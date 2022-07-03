Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0D564A41
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 00:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiGCWPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 18:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGCWPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 18:15:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A922BDE
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 15:15:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id lw20so13701695ejb.4
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 15:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=UVGjhNsxf9Pqlt4hYzLXIn0bG47YzWCIOzPWT6C2oko=;
        b=bddGaiZsJGl6jy7/XS10ZRUyTL/tu9axfv6z0ElM5itft793ZiJWOrvkBLp5UKjRPZ
         otJeIBnxJRs7OV3M8F00+IIZ1UT98z04Ex1iyup4cU4yCkPAiWjVpMY0Zwg7fUGJtL1K
         oiHHlsjRHdD8bd+LLohlzHspAVBCuJ9aPLNEjN2xN4rMnXEIEm6eofs61zuUItE/vZOT
         ZvL8N7LSy7FZo83EvpPGUUe3U+rVCAx3kz6n3F092FGkKYNkwrP16tbqSgzAQKUzoI9u
         HBAbpM9QiUPwDaYBxdiWR+22DGq7ZpyPROXXeX9Fa4zSYHrKZs7dlHb0fEAc4OeeG4Oj
         6lLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=UVGjhNsxf9Pqlt4hYzLXIn0bG47YzWCIOzPWT6C2oko=;
        b=sosZFjlHF6Vp7x4SWBxw+R5rnvggiVsP1VjfGOiG3aik5Ay0ge0wl+m2LDawGtylYo
         w0V2myajeRSCGklxYzZjtEdS0KgYnPTEbWUbkCumsxCIWXX0LPRhk5GgOVM6xP+g/Y64
         cW/cAsVK9i3s3ggzvoEeveDYCZzS1vxS/xpTTr7KEpa0BztDNyH/HvuOqsrT1WkljUEV
         FSnUCRKrd5JV8aWgsHpRNdVo1MuvHWyp+L/+UYwlB6Zp6cf2uSf3dod5K+K/oo9yXjST
         7FftmnyJTWEaycZP3XFd7HDygZ3Oxw0ueF5yq/896mxCb84vCjkNBx+s0UJCl5yxFvt9
         YwbQ==
X-Gm-Message-State: AJIora/A3MtLVytD5otUyL4CS1pvJkr1GRji/j8BpNOKXcwCPVDErj1F
        mHSu6HtqF97Ao324TzKm8BU=
X-Google-Smtp-Source: AGRyM1uqpBpr0arprAKtRXQITNYpPaqJO0rgs5Hp/BCX200qWQeG+0kqY/HL4f0maWS1LA1KAYSRYg==
X-Received: by 2002:a17:907:75cc:b0:726:f11c:4c5c with SMTP id jl12-20020a17090775cc00b00726f11c4c5cmr25652781ejc.404.1656886517604;
        Sun, 03 Jul 2022 15:15:17 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c593:4a00:182f:71f5:ae83:e676? (dynamic-2a01-0c23-c593-4a00-182f-71f5-ae83-e676.c23.pool.telefonica.de. [2a01:c23:c593:4a00:182f:71f5:ae83:e676])
        by smtp.googlemail.com with ESMTPSA id k25-20020aa7d8d9000000b004356c18b2b9sm19453410eds.44.2022.07.03.15.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 15:15:17 -0700 (PDT)
Message-ID: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
Date:   Mon, 4 Jul 2022 00:12:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
Content-Language: en-US
Subject: [PATCH net] r8169: fix accessing unset transport header
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

