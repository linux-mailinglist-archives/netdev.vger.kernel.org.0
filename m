Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08020642147
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiLEB6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiLEB6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:58:22 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15C41144E;
        Sun,  4 Dec 2022 17:58:21 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s5so13781708edc.12;
        Sun, 04 Dec 2022 17:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tiw1kR5Fj9mSQPY+/a11FtsTXdBXPQZ0NfAI3+WT5gw=;
        b=oV6A5niSrMlQaL/PRvwZQFEdjN8kUtbgvZjJMo8UyV8eYM9Tb5m07Cyj3JQ38U7kYs
         VCu56GImf0EKcN38n1hyDdlqkHf6IQC2UKdM+D8nMIhvWo4yV0iBGL+EbZ7IRCxGvrwc
         IjQQ5Zx5U7w5NbZrL+9IjhLAN/i5BexKpb56t1KeKuY41/DvahoRbURlBiIbInCkAsHb
         3aodawn6qIBAxnb7aYjQz1WLvb1qMp4/T+/vyXEii9SWqZ63HFqeXOtPNz69Bf9yp3O6
         uX9nnnxI3U9oGmX18PE3mM4g1lSBcfzy5rC4UaKW88SUCAcyWJmw5qISead1L+p2EGzL
         EJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tiw1kR5Fj9mSQPY+/a11FtsTXdBXPQZ0NfAI3+WT5gw=;
        b=5KtFzvg6VxTIwzjTjKyyUPCd+MPnFMvX09rjJK30lL3eym8OZsnjoHF0YyZ77mG/xf
         vYIX3riupbN26BjSFnjW3jntD4Q6gY7uSMYVFXcpTx7fXdOy5EEOgGDMsiqf8GTuokxB
         SHBhp0ZguKsS8jr3R+AEi+LACZw2OWES2M31GhlcBwcQe1vzR2Te1UuCEg6JXSxlt8yV
         2EjP/EyQfN9mIbcIKNqsXrXU+9GBRKepEm1/h0RfSx7+fPU216wLgov8xqwTkCPGGYQx
         Bf6IJJGvl94VbbBtw3DRcSG/EEYpRMCby1ywY/e1kK/NsAgYL55nt3/95yx2AFPXOhZr
         cjsw==
X-Gm-Message-State: ANoB5pkC/OTPr4zoOuXhIEKtZ9hxnUNzJe6R4If74HcqnKHaXDRLrm7Y
        S04C3lPb/X53LzG8/jpvXTe1KaI11DpuAvyu
X-Google-Smtp-Source: AA0mqf4+vIIcd4V+SIYvFiklshQgnV8pEbbMRR6/A4Oi+RVWGjOPp43eRTlDgu4pT0vzTikVSJwWlA==
X-Received: by 2002:a05:6402:221b:b0:46c:6707:1036 with SMTP id cq27-20020a056402221b00b0046c67071036mr6528109edb.308.1670205500480;
        Sun, 04 Dec 2022 17:58:20 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906219200b0078d22b0bcf2sm5650505eju.168.2022.12.04.17.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 17:58:20 -0800 (PST)
Date:   Mon, 5 Dec 2022 02:58:29 +0100
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
Subject: [PATCH ethtool-next 1/2] update UAPI header copies
Message-ID: <f9712cc0a62fb1a2e4ab5016b2dc91a26b0e3891.1670205306.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit b71fb5b0b802.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 uapi/linux/ethtool.h         |  3 +++
 uapi/linux/ethtool_netlink.h | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
index d581c43d592d..11a0efbf815c 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,9 @@ enum {
 	ETHTOOL_MSG_MODULE_SET,
 	ETHTOOL_MSG_PSE_GET,
 	ETHTOOL_MSG_PSE_SET,
+	ETHTOOL_MSG_PLCA_GET_CFG,
+	ETHTOOL_MSG_PLCA_SET_CFG,
+	ETHTOOL_MSG_PLCA_GET_STATUS,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -97,6 +100,9 @@ enum {
 	ETHTOOL_MSG_MODULE_GET_REPLY,
 	ETHTOOL_MSG_MODULE_NTF,
 	ETHTOOL_MSG_PSE_GET_REPLY,
+	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
+	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
+	ETHTOOL_MSG_PLCA_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -880,6 +886,25 @@ enum {
 	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
 };
 
+/* PLCA */
+
+enum {
+	ETHTOOL_A_PLCA_UNSPEC,
+	ETHTOOL_A_PLCA_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_PLCA_VERSION,				/* u16 */
+	ETHTOOL_A_PLCA_ENABLED,				/* u8 */
+	ETHTOOL_A_PLCA_STATUS,				/* u8 */
+	ETHTOOL_A_PLCA_NODE_CNT,			/* u8 */
+	ETHTOOL_A_PLCA_NODE_ID,				/* u8 */
+	ETHTOOL_A_PLCA_TO_TMR,				/* u8 */
+	ETHTOOL_A_PLCA_BURST_CNT,			/* u8 */
+	ETHTOOL_A_PLCA_BURST_TMR,			/* u8 */
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

