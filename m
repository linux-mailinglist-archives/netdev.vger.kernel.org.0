Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0536270ED
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiKMQo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235450AbiKMQow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:44:52 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9784BDEF1;
        Sun, 13 Nov 2022 08:44:51 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id x21so6170786qkj.0;
        Sun, 13 Nov 2022 08:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aOiKBaDvQLb2jhb8/1noUpn7T84J17mtkV+rkYECE5w=;
        b=l9KqnMa7y4O0gnhuoOK6xCuK+jFlTEPbeZJTsLGm+wu9OnbWBVGDx6JdLBYMvvHf5B
         +c+oojzJz52RGIBZdWuW6Gk15IyKly3jkBYSmfaHqK4xmWxFQ8yRwtZ3zv0FgJnGzf9W
         w2aTUDm43MAOxpgCCXF1LRMEGp+apaMP41L4G300/YPSeZ279rUtsQDSTrfG4S8+3wbZ
         uedppBG+vJ8A/ZJY1XpTUBNUso+DsLGbJ8354d+UdkFQaF+YX3RU5yn3dNROCs7F52ZQ
         +bWzvq+T5gsd+BZUg8kvBo9waYKXhO1K1/WaM7LV0gUKIosyEpNYG9hNi5ErYQ26S2dB
         GfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOiKBaDvQLb2jhb8/1noUpn7T84J17mtkV+rkYECE5w=;
        b=DDVKNwiFLYRGkA9G5vnz3w6t4+U7pnC3xWbWeP36gvPvOaxp9iev200En6BT/Hj3GJ
         hu30OsZIL8gGuMxAdk76+C2pQzoNTguCSGPNEsNJZuYf6g8JDbchAo1FjCLPiy43RHnb
         EHKjZHZ7qJUYkMNwNvgA4jUMv31c2aNKr1J7+mEnUlhAg/r4kohqrR+BCt6gou/uJfIE
         0WtcM6fX9E0aem2uptIYy9thW9AMPI3P+59G/9/hGErbSkKs6QXF0UBEFU+SKTD4Hld/
         m9vlL3ZlZS5LRq6wzNFkRoD92KuIp6bxNurzjQS636uhvSfhBE3d0LZNzjmNl0cP1Kxf
         TQAA==
X-Gm-Message-State: ANoB5plrLZLTAAVJAXaNDBgMaedO+8rafTqPMfDuFEM2/4KxkIPGKR8X
        tgmpDCiCCgDK+BbMIdKdG0l2iIyH2WXZ+g==
X-Google-Smtp-Source: AA0mqf4S04Ru7CiKrlzTQD8+p/OpnOx+ubat1GI7iS2ZvKNzClF8va9aBSmr7KRLE9NYNjz1rSFrJA==
X-Received: by 2002:a05:620a:2602:b0:6f7:65f6:a99c with SMTP id z2-20020a05620a260200b006f765f6a99cmr8389788qko.125.1668357890512;
        Sun, 13 Nov 2022 08:44:50 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cf8-20020a05622a400800b0035d08c1da35sm4429191qtb.45.2022.11.13.08.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 08:44:49 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCH net-next 4/7] sctp: add skb_sdif in struct sctp_af
Date:   Sun, 13 Nov 2022 11:44:40 -0500
Message-Id: <3561f40b97b8db1d112af6768100e1d3a4c3119e.1668357542.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668357542.git.lucien.xin@gmail.com>
References: <cover.1668357542.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add skb_sdif function in struct sctp_af to get the enslaved device
for both ipv4 and ipv6 when adding SCTP VRF support in sctp_rcv in
the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 1 +
 net/sctp/ipv6.c            | 8 +++++++-
 net/sctp/protocol.c        | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 350f250b0dc7..7b4884c63b26 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -477,6 +477,7 @@ struct sctp_af {
 	int		(*available)	(union sctp_addr *,
 					 struct sctp_sock *);
 	int		(*skb_iif)	(const struct sk_buff *sk);
+	int		(*skb_sdif)(const struct sk_buff *sk);
 	int		(*is_ce)	(const struct sk_buff *sk);
 	void		(*seq_dump_addr)(struct seq_file *seq,
 					 union sctp_addr *addr);
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e6274cdbdf6c..097bd60ce964 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -842,7 +842,12 @@ static int sctp_v6_addr_to_user(struct sctp_sock *sp, union sctp_addr *addr)
 /* Where did this skb come from?  */
 static int sctp_v6_skb_iif(const struct sk_buff *skb)
 {
-	return IP6CB(skb)->iif;
+	return inet6_iif(skb);
+}
+
+static int sctp_v6_skb_sdif(const struct sk_buff *skb)
+{
+	return inet6_sdif(skb);
 }
 
 /* Was this packet marked by Explicit Congestion Notification? */
@@ -1142,6 +1147,7 @@ static struct sctp_af sctp_af_inet6 = {
 	.is_any		   = sctp_v6_is_any,
 	.available	   = sctp_v6_available,
 	.skb_iif	   = sctp_v6_skb_iif,
+	.skb_sdif	   = sctp_v6_skb_sdif,
 	.is_ce		   = sctp_v6_is_ce,
 	.seq_dump_addr	   = sctp_v6_seq_dump_addr,
 	.ecn_capable	   = sctp_v6_ecn_capable,
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index dbfe7d1000c2..a18cf0471a8d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -567,6 +567,11 @@ static int sctp_v4_skb_iif(const struct sk_buff *skb)
 	return inet_iif(skb);
 }
 
+static int sctp_v4_skb_sdif(const struct sk_buff *skb)
+{
+	return inet_sdif(skb);
+}
+
 /* Was this packet marked by Explicit Congestion Notification? */
 static int sctp_v4_is_ce(const struct sk_buff *skb)
 {
@@ -1185,6 +1190,7 @@ static struct sctp_af sctp_af_inet = {
 	.available	   = sctp_v4_available,
 	.scope		   = sctp_v4_scope,
 	.skb_iif	   = sctp_v4_skb_iif,
+	.skb_sdif	   = sctp_v4_skb_sdif,
 	.is_ce		   = sctp_v4_is_ce,
 	.seq_dump_addr	   = sctp_v4_seq_dump_addr,
 	.ecn_capable	   = sctp_v4_ecn_capable,
-- 
2.31.1

