Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDE0645011
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLGAOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiLGAOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:14:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3CE4B77E;
        Tue,  6 Dec 2022 16:14:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m19so22671711edj.8;
        Tue, 06 Dec 2022 16:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4T2/HexI1hSTt9gmc3yW6TbJLDMLbXXKsjlPWdDV1/4=;
        b=RnnK7xUgHqWAC8iOb2///LeXbjlvuNuSKJhbTtnqedtxrunmNcOBLXeWZRNBPXSfdD
         Kq8h+ch7AOlIRCL4FZ3/ekAMdp8cGEZXk0fsK/iXnk+02sR8M9FW/uC0EyCrhSei2p7L
         6/ITn5fKHNJDCqhIQMMzBBreOWJNnO1My2bSRmzgsT9zAp5bAa8J0NWV9F6CET+4dF8m
         7vb5GmlXL3rhS2otuIyWczzWf3UKCTiUmpjn4KK6KBOU2o/CjP3yJh2kRHv3DuQMfQSj
         XWV0YExWvu9c5ZfJgDt/PwwDfvxRnapjqnkFFp4RKcwfKUOYARGeoFgubXdR1gwSPGi4
         oCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4T2/HexI1hSTt9gmc3yW6TbJLDMLbXXKsjlPWdDV1/4=;
        b=3X3NdXuUkMDwW7q29KXGu93kY5Yxv1+wrqv7F1y61jaC0DToYDcuDPAl7nVjkng/HE
         8x0hokLK2w/OBexsY791kTM1yWFGMEdBp90A9oB8T3R3qxQDG/IZmq7CGIbbeorRbgVL
         +l//tgXxHK+6/qKeSa5hlQn0L+RPr9SRwmiezIY7o/FF367Rat2Txfko82qNPYmH/+AB
         nJ5+0xlc7MJgDQdS0fvor7tPXtycrAWw4DR7z2dJxFGfU6S+1Zn8GOCiXGjNRpAwuJPp
         0QdWHKNTeD82ePgMiaYmqWIMGk/70YRo+mGkTTIbmV00wKbCDm1+RZyAy1wCiaKU3mO9
         Vyfw==
X-Gm-Message-State: ANoB5pm4czJsE+/EAPBbwQNGDM0/SHyUhhSBAOOrDQlQLUV5FtnkAFGJ
        WuiiL1AbG5r4yvRXTE8O0sw=
X-Google-Smtp-Source: AA0mqf6Vpq/v6izJqgXy86RyxDzQYRHjmb2hNoOnKyP0aN8RO3AmOfWVMERvi4cNh1TloCJXYUXQcQ==
X-Received: by 2002:aa7:c988:0:b0:46b:aedf:f330 with SMTP id c8-20020aa7c988000000b0046baedff330mr26609682edt.76.1670372076820;
        Tue, 06 Dec 2022 16:14:36 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id k13-20020a170906680d00b007c0f2d051f4sm3081200ejr.203.2022.12.06.16.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:14:36 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:14:47 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v2 ethtool-next 1/2] update UAPI header copies
Message-ID: <7d9ef2360bf0b001470cd78fcec581465adba2a8.1670371908.git.piergiorgio.beruto@gmail.com>
References: <cover.1670371908.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670371908.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit d979c7488080.

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
index d581c43d592d..db134bb24f0f 100644
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
+	ETHTOOL_A_PLCA_ENABLED,			/* u8 */
+	ETHTOOL_A_PLCA_STATUS,			/* u8 */
+	ETHTOOL_A_PLCA_NODE_CNT,		/* u8 */
+	ETHTOOL_A_PLCA_NODE_ID,			/* u8 */
+	ETHTOOL_A_PLCA_TO_TMR,			/* u8 */
+	ETHTOOL_A_PLCA_BURST_CNT,		/* u8 */
+	ETHTOOL_A_PLCA_BURST_TMR,		/* u8 */
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
2.35.1

