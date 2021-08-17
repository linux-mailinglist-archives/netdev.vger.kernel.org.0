Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442813EF1EE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233424AbhHQSgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbhHQSgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:36:06 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A20C061764;
        Tue, 17 Aug 2021 11:35:33 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s3so283973ljp.11;
        Tue, 17 Aug 2021 11:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ouYM9VHMpEM8w2sBiSiM4kMsiclMCWPkcX2MmzsySN4=;
        b=GcRGVF89SwgKWtmB++fh8Vcvh0rJKY1OAGWUy+cYaEK9Nl+TGMAD9nZGZmIzgkpRps
         QSRe59oVgsjXLPYuWnhKVpzx+Wg9WvBwGAkPg0A54s4bOOMxrgNVS7TBDZAXixkNuoSx
         Rdk7T3Mpj1D0Gs/JsT+BdaPJ/BI5JzFYnU9QE9HppkP/5qcGGNleOG0eqg7tTMszWSbi
         T/TilJKi3iO2TjhmwteAdh9mAMn4kQpH4i4pQa7ox5nySa1+cjFh1HEqtqvg7EYN2MwO
         eK7D4R+7Tp9ZUFFtisMcBGAAv1H3I1nBZ73zaXKnnMaEWt6f/AiT6PnivXmBEBy4MQPb
         LIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ouYM9VHMpEM8w2sBiSiM4kMsiclMCWPkcX2MmzsySN4=;
        b=GrZX3VD0MQB2KrpAKa/t08FLuOwX8zgzLBQ8/ydVm1KAdiMaAIc1TAY3RJcTDHpsQr
         /mr+YrgIluxBVCvi93zK+Y4j2wZX7bzZCPlZSnxlJJg8e4p4/PT9faLDyTuqB+w/VGtS
         H6I92hOnd/DThuRtfB+H/fl+Wf7e3etUVShiHyfmqw4EDDfWxV4OCiwCnce0/dUG8GsI
         0uZieVxHyjyDZts0x5mr7vy1Y/+dt9NmGCwQN4XIS5+YdJx6BXPUkg+rOMT3WV2yCfpc
         HeQe65GIhBeEhl3+v84QjLcvmFWzFhYTmsfQezN+5O8HnRGsZ2QM6dqlPHHB1iMhZCjQ
         0KMg==
X-Gm-Message-State: AOAM532J85C/5w/kiWXkI2EJvtBFhCLPamDPlIQ7/alfs6WPBNuAFsbY
        /KBfuX7o6mnzBvpx+uns9xE=
X-Google-Smtp-Source: ABdhPJw0SXgT8GZ5K48mNK19qTuVj8zhO2h+zQR0hrgWHrJzlvs3R9mwE7tBOF0Jolacm1wL2pPfiw==
X-Received: by 2002:a2e:a914:: with SMTP id j20mr4390799ljq.460.1629225331328;
        Tue, 17 Aug 2021 11:35:31 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id y4sm259724lfl.38.2021.08.17.11.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 11:35:30 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        jesse.brandeburg@intel.com, kaixuxia@tencent.com,
        lee.jones@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 1/2] net: mii: make mii_ethtool_gset() return void
Date:   Tue, 17 Aug 2021 21:34:42 +0300
Message-Id: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii_ethtool_gset() does not return any errors. We can make it return
void to simplify error checking in drivers, that rely on return value
of this function.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/mii.c   | 5 +----
 include/linux/mii.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/mii.c b/drivers/net/mii.c
index 779c3a96dba7..3e7823267a3b 100644
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -50,9 +50,8 @@ static u32 mii_get_an(struct mii_if_info *mii, u16 addr)
  * The @ecmd parameter is expected to have been cleared before calling
  * mii_ethtool_gset().
  *
- * Returns 0 for success, negative on error.
  */
-int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
+void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
 {
 	struct net_device *dev = mii->dev;
 	u16 bmcr, bmsr, ctrl1000 = 0, stat1000 = 0;
@@ -131,8 +130,6 @@ int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
 	mii->full_duplex = ecmd->duplex;
 
 	/* ignore maxtxpkt, maxrxpkt for now */
-
-	return 0;
 }
 
 /**
diff --git a/include/linux/mii.h b/include/linux/mii.h
index 219b93cad1dd..12ea29e04293 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -32,7 +32,7 @@ struct mii_if_info {
 
 extern int mii_link_ok (struct mii_if_info *mii);
 extern int mii_nway_restart (struct mii_if_info *mii);
-extern int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
+extern void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
 extern void mii_ethtool_get_link_ksettings(
 	struct mii_if_info *mii, struct ethtool_link_ksettings *cmd);
 extern int mii_ethtool_sset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
-- 
2.32.0

