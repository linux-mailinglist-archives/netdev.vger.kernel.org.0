Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8345A65D516
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbjADOI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbjADOIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:08:52 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7E71B9E5;
        Wed,  4 Jan 2023 06:08:51 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b88so41409715edf.6;
        Wed, 04 Jan 2023 06:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mK9Z/AU8nGQ9sZMvDQuANxIsK6zhP0TpVbEgNn1uSXE=;
        b=GK2h5xTuX5pqmEi2bDO4KshsH9h5dUr0UW6UZbDKtCo5BK1NBc9iqFEgSYWVDLdsQ3
         h2dgUnSxyHqTZb1axRx0POJa68a47w+b8fA4ipAGsiRsMLRMGmpAGQMB+GBGKKwkhZCD
         Ikv+8rXGg7oCfXwP/15Z23XcKGMSBBIe7NggMnF0u97p3YhYSD9Qe0MLFx7pl6Gbz43Y
         EDGHawDuiwlx/UoyovgHUTMiYZymklaDX4YZjCjfs0CbsLA7+Tl5eKpL57zjSWiRu+hh
         ZKQy1G0NiXeyghh03NtMtspfrQEU4446O718jST6bDNh8PbeCEu1WbWbAFGM8TAZyvgI
         MFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mK9Z/AU8nGQ9sZMvDQuANxIsK6zhP0TpVbEgNn1uSXE=;
        b=y/9/ZF6WE5yMSM0Xh1pr5kOwc4lHr5XHsk6DXwem5iNI7mt6TIK9tYTOpHBrcmjkZU
         VyA5ETgV3lVHiIL89uiiRRU/P6LDvAO9bMN8mRn7VQeD+BrVbJuwikFqEOzVIdzaYG+R
         Z6FC/sVBS9Yx2FifP0mCg2lfKET3lnNffYwVaRB7ejb+8+01X7mZV4rd0PSWBQHSsU4d
         KbTNLWDg1kKcnONdJSqw4ZgBQ3crCWWTZcQRafvtd/ilvZUTMo6Qfhq7MLR5sWlgKay+
         Nq1Pey5MGBcOXSr/rC8ZcR+YKzQKQ7hm1DR68mhscDKFtjyhXNAt9q5CvO402ZVzZJGE
         xffQ==
X-Gm-Message-State: AFqh2kqGkFPQujyGW/iz/lgZjd4i+JBd8uvlEWO89MEOknZRPx7UUcV3
        60cjteL+iBIEpK94+mlTsdQ=
X-Google-Smtp-Source: AMrXdXuNXEUHC6QW+5j3OLmzpwvqOnR/tQ30OKVigQHI2KJHp0nNhrTSd8VYIm9aODqbiXLyEUANGw==
X-Received: by 2002:a05:6402:1c95:b0:48b:a29f:4bef with SMTP id cy21-20020a0564021c9500b0048ba29f4befmr14029755edb.6.1672841330329;
        Wed, 04 Jan 2023 06:08:50 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id b12-20020aa7dc0c000000b0046892e493dcsm14744531edu.26.2023.01.04.06.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:08:49 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:08:58 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH ethtool-next 1/2] update UAPI header copies
Message-ID: <aa2698743539e903075ced36366afbf61aae6b10.1672840949.git.piergiorgio.beruto@gmail.com>
References: <cover.1672840949.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1672840949.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit d6ffe9c0296b.

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

