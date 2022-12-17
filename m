Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873FC64F690
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLQAwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiLQAv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:51:26 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C9F67D98;
        Fri, 16 Dec 2022 16:50:25 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so9787651ejc.12;
        Fri, 16 Dec 2022 16:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xq4dzQl9OuBQ7d1dc6U7JIoqgeHWEMyw11N7wDetnOA=;
        b=fT+YXK7LJm7bC4grRK3q8ZQe5wqgJNiAuAxv8jUP+uhbeGYyrXhlrVy9zE0ETTbrZZ
         bUUN1cVwaDNn2GXpSI37W2sc6ecl3xJiiK+vzhWCgHzAipbKhYQYNv4o2Vc+bM/ZGYYN
         ZHsXYg9Wab50N3VYtPxAmHXftTdIUo8tE+/GIflpiWAzv264qVLr8LUUhF7R2TlKS/LS
         PjsVs67Fb0MCUvPBtvpVPiFWZDGcn21n1kAqBXQdgO1pJs1Um3PgdmE99/8Y+wvHoIYn
         IHuR+bKsCO6wdZRBxhgdmWAMELE1pQCPRHIXcervcHvz3G2ozpUy41F3HeM12ESzBrId
         DcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xq4dzQl9OuBQ7d1dc6U7JIoqgeHWEMyw11N7wDetnOA=;
        b=RdPCPE1np7uvLCBIK4RLoAUqRshiEtHpA7gwIUfwAWp+eCdFuiEwlmeIqzrlklMFLO
         58PwRrOqz2J/JSt6XB6Op0LLmjqWnViXFANie7HiNtaLCLiQiUWGRQgxnjMEiNRHDipJ
         Rotn5gyfjVMV0DJwCZhnPhM/7I20h5R6G4ekeY4bx3UNEMUaQLXrO3ZABPlf9vRwWbIK
         vP3ARpS0Rhj+iRi8YreF2OcGIXKkglUb1Un6/tZHC5sPAmGOS67HqPdjJMtkfWvaNlq4
         CpE2oqNhjRnnf0n0ZDuFtWj53FHIn5om+Toj2cY+cdKLekzsLoKzg0HVdzY7/CY+O5sB
         6QCA==
X-Gm-Message-State: ANoB5pkhU5EWlbNeWBWyvschiINmtInVrTzISIGBCuGWX7Wa4fFlxoGc
        FZk8Ukt5WDLakdKwZvTuFUM=
X-Google-Smtp-Source: AA0mqf4TN8E13XlAXjWWDz8BJ+v5UQx5vrycrQo9bY5dCI+MzGyO/FZ9fFac5W0vP7hTUjqQgcXTww==
X-Received: by 2002:a17:906:298c:b0:7c1:9eb:845b with SMTP id x12-20020a170906298c00b007c109eb845bmr28641130eje.16.1671238223618;
        Fri, 16 Dec 2022 16:50:23 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 25-20020a170906309900b007c53090d511sm1396499ejv.192.2022.12.16.16.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:50:23 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:50:21 +0100
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
Subject: [PATCH v4 ethtool-next 1/2] update UAPI header copies
Message-ID: <8eb8d565bf8b2d7e6ebf7cccb7719f8c543cb44d.1671236216.git.piergiorgio.beruto@gmail.com>
References: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 5518b1e55dcd.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 uapi/linux/ethtool.h         |  3 +++
 uapi/linux/ethtool_netlink.h | 39 ++++++++++++++++++++++++++++++++++++
 uapi/linux/net_tstamp.h      |  3 ++-
 3 files changed, 44 insertions(+), 1 deletion(-)

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
index d581c43d592d..a6d899cd7f3a 100644
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
+	ETHTOOL_A_PLCA_ENABLED,			/* u8  */
+	ETHTOOL_A_PLCA_STATUS,			/* u8  */
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
diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
index 55501e5e7ac8..a2c66b3d7f0f 100644
--- a/uapi/linux/net_tstamp.h
+++ b/uapi/linux/net_tstamp.h
@@ -31,8 +31,9 @@ enum {
 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
 	SOF_TIMESTAMPING_BIND_PHC = (1 << 15),
+	SOF_TIMESTAMPING_OPT_ID_TCP = (1 << 16),
 
-	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
+	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_OPT_ID_TCP,
 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
 				 SOF_TIMESTAMPING_LAST
 };
-- 
2.37.4

