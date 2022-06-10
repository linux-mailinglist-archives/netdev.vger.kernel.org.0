Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED2546408
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346710AbiFJKmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346659AbiFJKlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:41:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A47F1C4B32;
        Fri, 10 Jun 2022 03:37:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id v1so41953896ejg.13;
        Fri, 10 Jun 2022 03:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RJUujkG76qVvHktVyroJwXiHF5a3Pxz7D+Gs0XGGk8=;
        b=AVnu1qKnpzyAq+6vrJ1rQAu+7GHzMtbJx86n1XZ+M4tSVOgFaM/kZXFe7Lxrh3JFNk
         COlyZXyD3sHR+8UnJQ6MAMbflYpgXNn06+XBC7sghOG6a+2LE5sx/9uW4WHAGPewS2Mi
         uoif4nmtmFS6/qq6pIgrn89NZBxsXAlOoag3e8LOb6NueyPGrgVW0XboCqh2+LaM+Tf2
         BE2MoWYBdaRFeR+ZqrsRg9QiV8ZEAjNg8JaPlWYVlvjTOydD8DsPkfeMiX8eHLSAAMYs
         txHVOh/WzCd1Lav0+lVfrsxZbTxRPaHGqmF3tM3CJ1qJEQxJYlsd7ga/zeI4brPhMH/3
         zs1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4RJUujkG76qVvHktVyroJwXiHF5a3Pxz7D+Gs0XGGk8=;
        b=akwDCUzb4DlVBiRFPGD5kBQ59G9qS5bvMc4D/TkYQ7Ddar+G18AhuB1X2tXlU63hTP
         /h+pmbmSF937rMN3SFGf6jGuo1XUb5QAWyr800OSxkdP+oK26sW5517OKztZvLgOE/Fx
         7MKmCpFhAdO+vy3rp+OdnceHfnfP8KTHIjXar1o+X+jabVIvF6fRJzgCg2mCE2XmUgZS
         gwvKBNU35oZayP96Z1ej/+FCSLzYqg9JFAKnK8D/+9xOuEMAYHsflx+FnAIVyVAQ3BRX
         V2VO1QfswpAvoSBA6CiO6tJR29mE/Q3fZfAKphyPopabz3UQNhT7SiVaAde5Uy8QKQ4C
         WMBw==
X-Gm-Message-State: AOAM531X4KDtJ5uHYzSoHe7R1HbQGIEGXLy1waKj88Vsjytik/uu7c/H
        xuHvW80utz4McBHkckZ3siM=
X-Google-Smtp-Source: ABdhPJxQoXVoZnISb/CGAqoY0+/YG3RCmLCHENDYdW/OQSQ7xioPYzSqQsA+hC5zQ5drHcXTD5xxCg==
X-Received: by 2002:a17:907:96ab:b0:711:f0a8:8fdc with SMTP id hd43-20020a17090796ab00b00711f0a88fdcmr13237546ejc.359.1654857419910;
        Fri, 10 Jun 2022 03:36:59 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id g12-20020a056402424c00b00431962fe5d4sm6919323edb.77.2022.06.10.03.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 03:36:58 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     openwrt-devel@lists.openwrt.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: gro: respect nf_conntrack_checksum for skipping csum verification
Date:   Fri, 10 Jun 2022 12:36:53 +0200
Message-Id: <20220610103653.15261-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Netfilter allows disabling checksum verification of incoming packets by
setting nf_conntrack_checksum variable. That feature is very useful for
home routers which:
1. Most of the time just /forward/ network traffic
2. Have slow CPU(s) and csum calculation is a challenge

Some projects like OpenWrt set nf_conntrack_checksum to 0 by default.

It would be nice to allow similar optimization in the GRO code paths.
This patch simply reuses nf_conntrack_checksum variable to skip
skb_gro_checksum_validate() calls if applicable.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Hi guys,

I'm not very familiar with net subsystem, please let me know if there is
a better way of implementing such a feature.
---
 net/ipv4/tcp_offload.c   | 3 +++
 net/ipv6/tcpv6_offload.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 30abde86db45..734a3c0f3d4a 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -311,6 +311,9 @@ struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if (!NAPI_GRO_CB(skb)->flush &&
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	    dev_net(skb->dev)->ct.sysctl_checksum &&
+#endif
 	    skb_gro_checksum_validate(skb, IPPROTO_TCP,
 				      inet_gro_compute_pseudo)) {
 		NAPI_GRO_CB(skb)->flush = 1;
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 39db5a226855..2144afa56fa3 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -18,6 +18,9 @@ struct sk_buff *tcp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if (!NAPI_GRO_CB(skb)->flush &&
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	    dev_net(skb->dev)->ct.sysctl_checksum &&
+#endif
 	    skb_gro_checksum_validate(skb, IPPROTO_TCP,
 				      ip6_gro_compute_pseudo)) {
 		NAPI_GRO_CB(skb)->flush = 1;
-- 
2.34.1

