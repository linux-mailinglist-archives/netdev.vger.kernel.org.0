Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97D2D66621D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjAKRjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbjAKRiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:38:22 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571A42C7;
        Wed, 11 Jan 2023 09:37:56 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l26so11625583wme.5;
        Wed, 11 Jan 2023 09:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ba5exfVk9OKxNnucEpm74nRdFtyLMKwxjalzW0GdQAA=;
        b=GtgaQBd4qJsUzXGgYnOjLi6sOvf4wklf72uBJp4y9pX9RxHcT4R71N7z0Hucir+Sgz
         OTyeoboJxLRycUOJPaX6Ve/wwuqn66auV0nNUhFmAyM+JRq0VloWbjisOKLS+/9+ql7i
         /LQCKH153QYSTHpHzXhgVQyhnOKBeNmGVgGfTQR1rCBzQAG/LO5Dw8s/T8id9dClP4oJ
         otBAubp3UzahLexdO5r3PpwGG8iYDfP0CGIfZxstnVKIjXP88Z9S1NJiu73rwh6SzVfG
         qL+vQ1d4Goax5DXV/4kczP2mx8VXn6AO9wFhG5tZTh+BjDz/RcnKTIGywfjwv59wkqdH
         NPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ba5exfVk9OKxNnucEpm74nRdFtyLMKwxjalzW0GdQAA=;
        b=0IvACVA7BfVzxQt8sWm9XfLyCDLtdt61t73xAxFxVrMqD/JtlBu17ZKAofPDf/OxKo
         OiTdirXRUNN31xD4ryVLKuWqAb/9A5jp3O4WSdRgGsiyeJe8Ptpj/IOwjkOHX0P45HUP
         LUoI783Pdzx/NZ5wT1sF8/TKlVJfyzCVZLZ7Algk3rkn5PqI5pIrwTRk3lP5VRk2by4+
         fVbIc/HJ1BizFNS2w+Jg6Eh87f8rrFgopwHU28+RC/bbbyAnwHH8poAIaIWNRhOtznYS
         NY/8Ji0zI1vblvUKBENBVMcs9GzpO4xAm3oUAP+mSYKdO3L04IGrjWAdo1pV/NW81gKk
         fKfw==
X-Gm-Message-State: AFqh2ko8JfEqSzkp1sC++7VeyG96ENeU4vU8e6WGK5OsTlNFQ4ZL2D6y
        T3PPMaq8lWseEEMGjqOMJ9E=
X-Google-Smtp-Source: AMrXdXsblMYERj3AOjfGMZ4MXHchIfzQd0z3xev79x7GkO6GET2+EB4YituzpNQqv4G2797Mv7Hszg==
X-Received: by 2002:a05:600c:4e51:b0:3cf:7b8b:6521 with SMTP id e17-20020a05600c4e5100b003cf7b8b6521mr52452017wmq.32.1673458674805;
        Wed, 11 Jan 2023 09:37:54 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b003d9862ec435sm7862972wms.20.2023.01.11.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:37:54 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:37:54 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v2 ethtool-next 1/2] update UAPI header copies
Message-ID: <f3aab04b22bd38cced713bb9afb34443220bd786.1673458497.git.piergiorgio.beruto@gmail.com>
References: <cover.1673458497.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673458497.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 60d86034b14e.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 uapi/linux/ethtool.h         |  5 ++++-
 uapi/linux/ethtool_netlink.h | 25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d1748702bddc..eb20bf873109 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1181,7 +1181,7 @@ struct ethtool_rxnfc {
 		__u32			rule_cnt;
 		__u32			rss_context;
 	};
-	__u32				rule_locs[0];
+	__u32				rule_locs[];
 };
 
 
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
index 0d553eccea81..a6d899cd7f3a 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -52,6 +52,9 @@ enum {
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
 	ETHTOOL_MSG_RSS_GET,
+	ETHTOOL_MSG_PLCA_GET_CFG,
+	ETHTOOL_MSG_PLCA_SET_CFG,
+	ETHTOOL_MSG_PLCA_GET_STATUS,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -99,6 +102,9 @@ enum {
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
 	ETHTOOL_MSG_RSS_GET_REPLY,
+	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
+	ETHTOOL_MSG_PLCA_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -894,6 +900,25 @@ enum {
 	ETHTOOL_A_RSS_MAX = (__ETHTOOL_A_RSS_CNT - 1),
 };
 
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
-- 
2.37.4

