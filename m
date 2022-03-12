Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2A4D70C9
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 21:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiCLUV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 15:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiCLUV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 15:21:56 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3AD207A20
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 12:20:50 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id a14so10168141qtx.12
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 12:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rxkUDg+qBB3WQG4mCBC3m79wqb1PB3BKKrUVCN9KZn0=;
        b=2tZaw4Qwh/ihASXpHkGEsxQLKIj1+qcRrCZ7L5/y3AauHchtWbFXGIovhMRfZORndK
         8X9euYlM/49MOrxzsCq5zpJOwmRjjeeYNC0ZJW4g3xAFp73IbehzbLQW1phi+ugXFPW1
         tUWxPzIGITeRjkSmJ5U+YQKdvPOhRnw+TaLnv4jNFKDihCdIkqwZltFzjxUf/g1Rz3/g
         euVvNrkf3aiab64rMf7aWzIKBczGi0NfElF3+/fX/ACn2OeuYvjtEH8uHm07KURR+zA0
         MCy1qG220vPLj/NH/LyyjkV3ZG3avKbXplyYrtefbGOXLgh00qaldxERpzl1tJRWqaCM
         Bnrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxkUDg+qBB3WQG4mCBC3m79wqb1PB3BKKrUVCN9KZn0=;
        b=gfxmKvGrekMbQRs5GRl8awfqFmZyzF31F07Almqy7bTH+XW60JqvJAi3sds25M22MA
         J3RQtaFmaefCLe+quiDqPMZ23FEbgzna7WoQ/nJ3k5jdG3zzlyt4eGPISKlR5YKSCVZZ
         D/4W5Dfxqw+JSOyKZkmxbsnunxO1qhMkDi0NLwnCfpXQ+X4wqNfH6LRBdrXYTEq5OqlJ
         5qgrxVEGJ3oe6DEsiwWSn25z+j4Mw5I7RkUU7ZjNxMtAi3YU+DG+O4xr94Aq3l7nJoAJ
         grHdvLyS5RsyDByBEtbSyRJjQ4i9cBN7Zft11gLKMAh7b9PeQ50n1WYPzTivh4nmr6TT
         1Ofw==
X-Gm-Message-State: AOAM531t5vmBMFuoSgrc8l199m0bP9QRnsxyfbH0jQbU1L55Q6ka8l0g
        exkyzF/EVj1BhmDyzDYVH5FBMpHJ4e39QvMW7PI=
X-Google-Smtp-Source: ABdhPJwQlz+GEvLyQCD1Kv5tSQI55A5GrgRbqCvQTLLCKRhh2ZOSv30BGtcfgL2/z1olP9SXo0ZWZA==
X-Received: by 2002:ac8:5dd2:0:b0:2e0:688f:ba8f with SMTP id e18-20020ac85dd2000000b002e0688fba8fmr13227062qtx.139.1647116449276;
        Sat, 12 Mar 2022 12:20:49 -0800 (PST)
Received: from kcancemi-arch.Engineering.com ([167.206.126.218])
        by smtp.gmail.com with ESMTPSA id o21-20020ac85a55000000b002e16389b501sm8186224qta.96.2022.03.12.12.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 12:20:49 -0800 (PST)
From:   Kurt Cancemi <kurt@x64architecture.com>
To:     netdev@vger.kernel.org
Cc:     kurt@x64architecture.com, kabel@kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v3] net: phy: marvell: Fix invalid comparison in the resume and suspend functions
Date:   Sat, 12 Mar 2022 15:15:13 -0500
Message-Id: <20220312201512.326047-1-kurt@x64architecture.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220312002016.60416-1-kurt@x64architecture.com>
References: <20220312002016.60416-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug resulted in only the current mode being resumed and suspended when
the PHY supported both fiber and copper modes and when the PHY only supported
copper mode the fiber mode would incorrectly be attempted to be resumed and
suspended.

Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
---

I removed the dot from the summary line.

 drivers/net/phy/marvell.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2429db614b59..80b888a88127 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1687,7 +1687,7 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
@@ -1722,7 +1722,7 @@ static int marvell_resume(struct phy_device *phydev)
 	int err;
 
 	/* Resume the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
 			       phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
-- 
2.35.1

