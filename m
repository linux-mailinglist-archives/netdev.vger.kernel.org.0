Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C022FF4D5
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 20:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbhAUSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbhAUIqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 03:46:55 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3344FC0613CF
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:46:06 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id y205so1101139pfc.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 00:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=T/kOn/K024TpuPWtmw1eFn6iyRtsLplc24wC47bYr/w=;
        b=kI+ndFObMxOoERGMPJ3llUwoEPCzuaeNkHYO4Nk5hAeyWjApGcgQmjF2Ana+bwC9Pg
         0EC+ciQYrwQG+eNsgACJGO5qiXNn4beDRuxrhV07KmXZb1A19tArDNX681WsH5afT4Fo
         +3fEPgtnNKi5QEV6uYp4vRIM3NPljtL6M38r1qrOjlVbWlFVeg9uQ3M44Gm1U3ZxiOSU
         AMiODdhM0LtejcJGnH1S+tPFXVkSTSdn5vD8LAAxrNcGrG2rttpjUnI8pBpwCVbMPiiR
         V1MoJOBm6fA4UMDhnf4FcCYeyBXlNcxJeurPiIiFhYwO+8MZSp0CRDSGePWCY+Y4smHZ
         Xwow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=T/kOn/K024TpuPWtmw1eFn6iyRtsLplc24wC47bYr/w=;
        b=AIHEurD/SF0VtVhoZmVBDTLm1udfTknuPmdfsghBGvzzsnoRsnKchRUsidMdsa6TwI
         n1HkOpwYW718772F6DsQpw9+d70iepXEvf+EZp2UplN8ngEx50YTPBQ22FVjViHB+6Eb
         X9+x3Qv719Y4S9YY7xr2jtKvz4MehrT2XOuhvagPB7kSBMLu1q3Qh1oHbtRB5rVMlcDM
         YDm0YZ+QbjHlytmT7PlruE/wEVyntLiMgvZZ5UimPxQR4KowlPNHzNnnpzZ/6FAuyJuJ
         FyF3Fn/QhEnBPH2J5t3RGmh1mac/MHXr1gzgkovSpMEqGLqlAhKl4CcYA2bI5u1W/a7B
         HytQ==
X-Gm-Message-State: AOAM531mqfrTgKAkjpMj1F0pAfZQTc36zNF0D4GZeMZUC3JT6wtVwn9j
        wgwkbZc1dYAIhxf0gEyryTzySFBL/ZE=
X-Google-Smtp-Source: ABdhPJy0TVrMnDc1VOmgKPvDd3JC7YJ1Qiq5EDi9VbaViqaOeBOx/wxon9k507PW6Eiq3GQymIZ66w==
X-Received: by 2002:a62:ed09:0:b029:1bb:3ffc:b7f9 with SMTP id u9-20020a62ed090000b02901bb3ffcb7f9mr5504068pfh.52.1611218765471;
        Thu, 21 Jan 2021 00:46:05 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h11sm4767375pjg.46.2021.01.21.00.46.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Jan 2021 00:46:04 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 2/3] net: add CSUM_T_IP_GENERIC csum_type
Date:   Thu, 21 Jan 2021 16:45:37 +0800
Message-Id: <bb59ed7c9c438bf076da3a956bb24fddf80978f7.1611218673.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
 <0fa4f7f04222e0c4e7bd27cbd86ffe22148f6476.1611218673.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611218673.git.lucien.xin@gmail.com>
References: <cover.1611218673.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extend csum_type field to 2 bits, and introduce
CSUM_T_IP_GENERIC csum type, and add the support for this in
skb_csum_hwoffload_help(), just like CSUM_T_SCTP_CRC.

Note here it moves dst_pending_confirm field below ndisc_nodetype
to avoid a memory hole.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/skbuff.h |  5 +++--
 net/core/dev.c         | 17 +++++++++++++----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 67b0a01..d5011fb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -224,6 +224,7 @@
 
 #define CSUM_T_INET		0
 #define CSUM_T_SCTP_CRC		1
+#define CSUM_T_IP_GENERIC	2
 
 /* Maximum value in skb->csum_level */
 #define SKB_MAX_CSUM_LEVEL	3
@@ -839,11 +840,11 @@ struct sk_buff {
 	__u8			vlan_present:1;
 	__u8			csum_complete_sw:1;
 	__u8			csum_level:2;
-	__u8			csum_type:1;
-	__u8			dst_pending_confirm:1;
+	__u8			csum_type:2;
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	__u8			ndisc_nodetype:2;
 #endif
+	__u8			dst_pending_confirm:1;
 
 	__u8			ipvs_property:1;
 	__u8			inner_protocol_type:1;
diff --git a/net/core/dev.c b/net/core/dev.c
index 3241de2..6d48af2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3617,11 +3617,20 @@ static struct sk_buff *validate_xmit_vlan(struct sk_buff *skb,
 int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
-	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
-			skb_crc32c_csum_help(skb);
+	if (likely(!skb->csum_type))
+		return !!(features & NETIF_F_CSUM_MASK) ? 0 :
+		       skb_checksum_help(skb);
 
-	return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
+	if (skb_csum_is_sctp(skb)) {
+		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
+		       skb_crc32c_csum_help(skb);
+	} else if (skb->csum_type == CSUM_T_IP_GENERIC) {
+		return !!(features & NETIF_F_HW_CSUM) ? 0 :
+		       skb_checksum_help(skb);
+	} else {
+		pr_warn("Wrong csum type: %d\n", skb->csum_type);
+		return 1;
+	}
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
-- 
2.1.0

