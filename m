Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AE1567795
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiGETPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiGETPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:15:31 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FD321827
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 12:15:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y8so10774838eda.3
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 12:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=MdtMQ1amvFGizB2CTM2d7usH/3dGNJ5MnHro8idhi1Y=;
        b=LibhHVf5zcWWPR93Db+UtVn2r9p/MjupU51pj0pi5W5IlyFEiDcLhq+eIRM4Ul0dtc
         DVpjXmV4XkDVEDtfkHrKrM3z01vwcgNI8fqS3caPsXam7pndIxXJzDW3f+E7r0kWrmSM
         tZ8LWOVpUqFoP1GvQMQT3Be2YX3SjDWAqUzbsD6VeQVdNRNK/jip2Hfy4wP2XFvEYIH7
         qrj4nZFUtuvE1dOahufz8/xjed1YqCDzJX5ArKAUFVjHxQ94fR5TE/MrzsLeW7YPFaXu
         4poGnFBIdEbBR9mPeKaX2wO+7KgEAli8ksf+UsZpDp8vLPNOVr+3Szg1jScNUi9kmi+/
         jGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=MdtMQ1amvFGizB2CTM2d7usH/3dGNJ5MnHro8idhi1Y=;
        b=2sEC7PihsjRotfOhXQE16nZENbpSLCtMmnnZuQq63+/027De0zfzV3MkV8NR219Pag
         PEfUWWWeHlJegRUX+8A92cU/pYe5/+XrwM69W5LroWM1Y42u3I3DTVTt2MmDAh9n/KDg
         WmkUqscsEbBReOK5A1YkSH/4zwmDSGD1Kg90zZGMpCAqSI/3wPtjbjvjhkHJoMXbrkCg
         +2pZw7DHh+Robz0j6ZwE598c1nVNeI7P/Dcfc6Ncoj5M/qzlZ0/IynzuzFrmKj8FW/Gl
         /DsDZGrlZBKOq8ENCmX+7MQ7RYQX7lU/waC1iI5eB7R6phgVrIYjz0tv5tdgwB+vLZFA
         haqw==
X-Gm-Message-State: AJIora9VMFYosNDNxbyI6jfKgtmTvAfPczsr7gsjYGIMwC5FU2blb0Vw
        wup18llCPpt98T226M+zMUo=
X-Google-Smtp-Source: AGRyM1sDp7AcPqXHac5uIZhqhGTJaZPrsU3DA1581LasxxQG+XP0rSsZJCLedxA6+7hFngl+JhAo8g==
X-Received: by 2002:aa7:dd48:0:b0:437:9074:8bc5 with SMTP id o8-20020aa7dd48000000b0043790748bc5mr26676429edw.266.1657048528793;
        Tue, 05 Jul 2022 12:15:28 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b67:e500:f0a2:195e:b254:a6a7? (dynamic-2a01-0c22-7b67-e500-f0a2-195e-b254-a6a7.c22.pool.telefonica.de. [2a01:c22:7b67:e500:f0a2:195e:b254:a6a7])
        by smtp.googlemail.com with ESMTPSA id b9-20020aa7dc09000000b00437938c731fsm17888113edu.97.2022.07.05.12.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 12:15:28 -0700 (PDT)
Message-ID: <1b2c2b29-3dc0-f7b6-5694-97ec526d51a0@gmail.com>
Date:   Tue, 5 Jul 2022 21:15:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] r8169: fix accessing unset transport header
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

66e4c8d95008 ("net: warn if transport header was not set") added
a check that triggers a warning in r8169, see [0].

The commit referenced in the Fixes tag refers to the change from
which the patch applies cleanly, there's nothing wrong with this
commit. It seems the actual issue (not bug, because the warning
is harmless here) was introduced with bdfa4ed68187
("r8169: use Giant Send").

[0] https://bugzilla.kernel.org/show_bug.cgi?id=216157

Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Tested-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3098d6672..1b7fdb4f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4190,7 +4190,6 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 				struct sk_buff *skb, u32 *opts)
 {
-	u32 transport_offset = (u32)skb_transport_offset(skb);
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	u32 mss = shinfo->gso_size;
 
@@ -4207,7 +4206,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 			WARN_ON_ONCE(1);
 		}
 
-		opts[0] |= transport_offset << GTTCPHO_SHIFT;
+		opts[0] |= skb_transport_offset(skb) << GTTCPHO_SHIFT;
 		opts[1] |= mss << TD1_MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ip_protocol;
@@ -4235,7 +4234,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		else
 			WARN_ON_ONCE(1);
 
-		opts[1] |= transport_offset << TCPHO_SHIFT;
+		opts[1] |= skb_transport_offset(skb) << TCPHO_SHIFT;
 	} else {
 		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
 
@@ -4402,14 +4401,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
 {
-	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
 			features = rtl8168evl_fix_tso(skb, features);
 
-		if (transport_offset > GTTCPHO_MAX &&
+		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		if (rtl_quirk_packet_padto(tp, skb))
 			features &= ~NETIF_F_CSUM_MASK;
 
-		if (transport_offset > TCPHO_MAX &&
+		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_CSUM_MASK;
 	}
-- 
2.36.1

