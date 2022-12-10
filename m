Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6D8649121
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 23:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLJWw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 17:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiLJWwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 17:52:23 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C34B1C0;
        Sat, 10 Dec 2022 14:52:21 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qk9so19537579ejc.3;
        Sat, 10 Dec 2022 14:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFJkwTEFSgPR36Zpv79C+3GhM7O6dp/lBALvB3RNw6g=;
        b=dcjstzkhaMUZDHLIpruwbwTWaKavRwsLhkaX/57LSB7oSIFlwGnGHg2nBjkE+Macsj
         M/28iJH8Im7tQnBQ+g45t8SwNlMJ9bAF3rGzfggAhoMseLIcFfsW6lUT1l2FJ02CTkyo
         HguSlEoL2/EA6kGUCnb2r0LPbgQ2fZPsgA58oFKpZDhCel/JUewl+Tc7N3nPUdz9y+kB
         WZ469a0orU8qmxWgKKMrEevRq5MZzv4x6Zm5dJPpbj/ZPa29PvzVZ2+rY6m00ZtG+wzT
         THza5rWQuC3/w4NK7VKhcv5k0eI7tVHnSEdxJylDVbXcfeitueiMv9ShNlJcbz+IoIXE
         W24Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFJkwTEFSgPR36Zpv79C+3GhM7O6dp/lBALvB3RNw6g=;
        b=kyVy/Y0EWB698Fivf9jGTlImmWLlWHiLvayLI4q/BEqISRhkysjUb9aZjV5ClzK0l1
         zGjHn9uH5EKB+vL9PqHlHjInI0ReL70GfRQyY97OPasS25Yn4cS0i6+FfHE94bev2CPA
         na3pZwEjxZwQuQXnOe7btl0V/SHF17EU+UXskRn4XuOmGa0sS2+hEkNVEyKc0ed7WOmc
         2ePz9x1Jyj4jZkmtkhUNjoQVmwjoyCfrwk0to0QbitwXyT220dTMSaO7QWtgxZd5QjyC
         +A3UzWuZdih1diTSqMUYKpDn8r6v3HAua4yy5dBE44nQm+WF7srvZZJw3vXs9uhkAKBM
         bPXQ==
X-Gm-Message-State: ANoB5pno24wkSa1E4nJDUytEKDulJ4riw/3NoNbPSlgWhN/zf6LLY+Gk
        MP65y2482n71oonuPINKHgo=
X-Google-Smtp-Source: AA0mqf7nTjic9wu7N79/zXCxxHg72UQWXzmamHYC/NjhnbTTPkZ4HNIW90qmwxPusgw4b0I/IItWrQ==
X-Received: by 2002:a17:906:f50:b0:7b2:c227:126d with SMTP id h16-20020a1709060f5000b007b2c227126dmr8456323ejj.20.1670712739999;
        Sat, 10 Dec 2022 14:52:19 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id tp25-20020a170907c49900b007bed316a6d9sm1486479ejc.18.2022.12.10.14.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 14:52:19 -0800 (PST)
Date:   Sat, 10 Dec 2022 23:52:18 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v3 ethtool-next 1/2] update UAPI header copies
Message-ID: <10579fca736e88a98183f3bce06f8ba089dc9543.1670712544.git.piergiorgio.beruto@gmail.com>
References: <cover.1670712544.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670712544.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 9f6c9504c56e.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 uapi/linux/ethtool.h         |  3 +++
 uapi/linux/ethtool_netlink.h | 39 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d1748702bddc..78bf6fad9e02 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1739,6 +1739,9 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
 	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
 	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
+	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
+	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
+	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index d581c43d592d..7e116fbe911f 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,10 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_PLCA_GET_CFG,
+	ETHTOOL_MSG_PLCA_SET_CFG,
+	ETHTOOL_MSG_PLCA_GET_STATUS,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +101,10 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
+	ETHTOOL_MSG_PLCA_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -880,6 +888,37 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_RSS_UNSPEC,
+	ETHTOOL_A_RSS_HEADER,
+	ETHTOOL_A_RSS_CONTEXT,		/* u32 */
+	ETHTOOL_A_RSS_HFUNC,		/* u32 */
+	ETHTOOL_A_RSS_INDIR,		/* binary */
+	ETHTOOL_A_RSS_HKEY,		/* binary */
+
+	__ETHTOOL_A_RSS_CNT,
+	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
+};
+
+/* PLCA */
+
+enum {
+	ETHTOOL_A_PLCA_UNSPEC,
+	ETHTOOL_A_PLCA_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PLCA_VERSION,			/* u16 */
+	ETHTOOL_A_PLCA_ENABLED,			/* u32 */
+	ETHTOOL_A_PLCA_STATUS,			/* u32 */
+	ETHTOOL_A_PLCA_NODE_CNT,		/* u32 */
+	ETHTOOL_A_PLCA_NODE_ID,			/* u32 */
+	ETHTOOL_A_PLCA_TO_TMR,			/* u32 */
+	ETHTOOL_A_PLCA_BURST_CNT,		/* u32 */
+	ETHTOOL_A_PLCA_BURST_TMR,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PLCA_CNT,
+	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.37.4

