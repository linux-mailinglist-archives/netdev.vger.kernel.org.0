Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2BD3F0694
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbhHROXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbhHROXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 10:23:24 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0129EC06122E;
        Wed, 18 Aug 2021 07:19:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id r9so5013461lfn.3;
        Wed, 18 Aug 2021 07:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Niom4r7CiNkFb479/SvmpQz+2D5mYeNhdGJ/1p0GpQk=;
        b=eRlVA6tvKARkL8wKgtmgNtUjQ9u4X0C6aXxv1C4WnO/+VdNSNkuRKThsSHWr1xFgH2
         ERAHM/ZAYOjEOn8NbC77oGCM2Rc1FKAnQssJYsfqM8nBkjEbaQ6dBpxbdiSGvmBLwLqI
         kb8aNM5LcyOzgIBr2SrYjh1CTRP7XgOISQyfyVl7YccMEe5dK9C2v1IvRPNnmuz/V/xs
         3SdSzM+NjfE9oEdg6rcdKOuP4DaGDHaq/EdvPTsyHO6pFw06Y/MvJWAQ/vt/dmo8TvYv
         odcLQtDPCn3NArmBV0AwQd1vdTFpCF0Gg3y0S4kNcH5BRAhCdDULM8OHF0qGBFQqxfM4
         p1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Niom4r7CiNkFb479/SvmpQz+2D5mYeNhdGJ/1p0GpQk=;
        b=VjcivgyOeVr8ywaeTkklH6W6hBSvBvl+A8e7DNuAeDNSLi1cscogCdugmekuaKzGNq
         TiGucYFlipkdyStSLkSZLHVZXzlOEq1lIUn+xoCIgZqDfCALSlYNChUdfrkkJ7amB1QE
         jTCzv6QxzKjEbmRQbT03yhbPVpQjbGzCKFmY4X8ZP+pCX4mwvdJatB9BvYotivk7Dz3y
         RAF79pMjJRHJkdpPYLhMPn+bV/UQrW/ohhLnErqMAgDBn/WY2fV5pXrZGeacDHrMVtbG
         k+lr03PRYuBEJFHqvR+rS8UP+qPZlKCTkyvqR1AHR0cHhYA1L6jhvyFVWK9HWnhDxAgO
         iHUA==
X-Gm-Message-State: AOAM530I0nOxERF0GMye3y3al2cbgq9kr8ZYLBBqYpnwwiX5ZHJ8ulBL
        K/UBsW64thDMCxhMKiFvUCc=
X-Google-Smtp-Source: ABdhPJy/sVpEk8D4pag3+3OdqmoSoPJtGZohIa0OGLj3TkbKPqPm0iCJkIhsnLy9cqlw7T2EPjMdlA==
X-Received: by 2002:a19:491b:: with SMTP id w27mr6309011lfa.421.1629296343342;
        Wed, 18 Aug 2021 07:19:03 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id z8sm555712lfb.30.2021.08.18.07.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 07:19:03 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        kaixuxia@tencent.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 2/2] net: mii: make mii_ethtool_gset() return void
Date:   Wed, 18 Aug 2021 17:18:55 +0300
Message-Id: <94ec6d98ab2d9a937da8fba8d7b99805f72809aa.1629296113.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629296113.git.paskripkin@gmail.com>
References: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629296113.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii_ethtool_gset() does not return any errors. Since there is no users
of this function that rely on its return value, it can be
made void.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	inverted the order of patches

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

