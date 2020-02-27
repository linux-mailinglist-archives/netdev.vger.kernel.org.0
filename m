Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B541172915
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgB0T7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:59:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44193 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbgB0T73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:59:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id m16so251388wrx.11
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 11:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pj57iWuAkKlK8GjNd8RkaCGJcjqX0qTThl+KiAza1Og=;
        b=Oep4g3/ePJQcx9jUVvpnwRCWGAO1sCqieiLykhKJJIXK/a0XipkddSdQXMp0Dmkfbv
         J+odksffRzZyeBHGmWo/je+DqepGjm42JFYDc7zIh/KcuKSGacq/XGQ/xbu5L8ieIZfl
         cDTu8xKOMq9LOf2NTJNbEJdVofNf2mSgANh1//GZtRc7uM5xiA0/+HceEFa5ngIFQ9bK
         kMa9BiNE/KVQ4lEuqFqB1AyzUjdWE+81ySZrO+RBdgjLGwF5Vk/03nGn7OZAL/Vf4e6L
         ADSLpjGR6LiU0TLuUw8t0nnBlSGs2RdJppR4TaIicicDkzR7Qf/5uVqoJySo1QzK/coN
         Zvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pj57iWuAkKlK8GjNd8RkaCGJcjqX0qTThl+KiAza1Og=;
        b=OB/FuAsfkFjPYH3jzeotmZbkXE5RYiaN02KC3SptEvG/2Ra/fLspQB0W8ohLav2S4c
         cebXr5iF0mgAWp0k5PwMEKqf0MXDgN34/91wd2JRENnr/4a1VNyhs8bsM3qC3KQ4BRth
         c79JcR+/a6SKoBt3/1vyEq2UPIGozDi//DO/ufyKJLOOPfcoYaDMIb92CaRgQjn2Lac2
         elUuPb6OxWXZ+rhtecsJPjqExdz6NzO5sHziAlgZdO0KokV+1vD+3OCrZ/MqGH5ZkqoX
         bXNLsZ6FPdBaMvUhxvQjSp1PUBFoCWZSjga+P2BTmAnJRoVSRhDFiGeXRMrng0Pkjo/O
         Svow==
X-Gm-Message-State: APjAAAX6Dk1nkT/tEPbZZqsoqf8BXga/92zvJk8/ej8Nk9/KcAVKnfLC
        lgxNQW7vHN+EO3OCGcI7XWripN6SVt4=
X-Google-Smtp-Source: APXvYqzQtwq84RLRIsJmTvnZCWhqSpYlWdYPyaMCkieDwp++k+FVj0Tv+ZhYC25zIMtEPTwcdN1uXg==
X-Received: by 2002:adf:fa86:: with SMTP id h6mr497478wrr.418.1582833567596;
        Thu, 27 Feb 2020 11:59:27 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j14sm9781849wrn.32.2020.02.27.11.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 11:59:27 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next] mlxsw: reg: Update module_type values in PMTM register and map them to width
Date:   Thu, 27 Feb 2020 20:59:26 +0100
Message-Id: <20200227195926.20759-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

There are couple new values that PMTM register can return
in module_type field. Add them and map them to module width in
mlxsw_core_module_max_width(). Fix the existing names on the way.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 17 +++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 22 ++++++++++++++++++----
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3da2a4bde2b8..1078f88cff18 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2201,13 +2201,22 @@ int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module)
 	/* Here we need to get the module width according to the module type. */
 
 	switch (module_type) {
+	case MLXSW_REG_PMTM_MODULE_TYPE_C2C8X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_QSFP_DD: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_OSFP:
+		return 8;
+	case MLXSW_REG_PMTM_MODULE_TYPE_C2C4X: /* fall through */
 	case MLXSW_REG_PMTM_MODULE_TYPE_BP_4X: /* fall through */
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_QSFP:
+	case MLXSW_REG_PMTM_MODULE_TYPE_QSFP:
 		return 4;
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_2X:
+	case MLXSW_REG_PMTM_MODULE_TYPE_C2C2X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_2X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_SFP_DD: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_DSFP:
 		return 2;
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_SFP: /* fall through */
-	case MLXSW_REG_PMTM_MODULE_TYPE_BP_1X:
+	case MLXSW_REG_PMTM_MODULE_TYPE_C2C1X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_BP_1X: /* fall through */
+	case MLXSW_REG_PMTM_MODULE_TYPE_SFP:
 		return 1;
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 26ac0a536fc0..1bc65e597de0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5440,15 +5440,29 @@ enum mlxsw_reg_pmtm_module_type {
 	/* Backplane with 4 lanes */
 	MLXSW_REG_PMTM_MODULE_TYPE_BP_4X,
 	/* QSFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_BP_QSFP,
+	MLXSW_REG_PMTM_MODULE_TYPE_QSFP,
 	/* SFP */
-	MLXSW_REG_PMTM_MODULE_TYPE_BP_SFP,
+	MLXSW_REG_PMTM_MODULE_TYPE_SFP,
 	/* Backplane with single lane */
 	MLXSW_REG_PMTM_MODULE_TYPE_BP_1X = 4,
 	/* Backplane with two lane */
 	MLXSW_REG_PMTM_MODULE_TYPE_BP_2X = 8,
-	/* Chip2Chip */
-	MLXSW_REG_PMTM_MODULE_TYPE_C2C = 10,
+	/* Chip2Chip4x */
+	MLXSW_REG_PMTM_MODULE_TYPE_C2C4X = 10,
+	/* Chip2Chip2x */
+	MLXSW_REG_PMTM_MODULE_TYPE_C2C2X,
+	/* Chip2Chip1x */
+	MLXSW_REG_PMTM_MODULE_TYPE_C2C1X,
+	/* QSFP-DD */
+	MLXSW_REG_PMTM_MODULE_TYPE_QSFP_DD = 14,
+	/* OSFP */
+	MLXSW_REG_PMTM_MODULE_TYPE_OSFP,
+	/* SFP-DD */
+	MLXSW_REG_PMTM_MODULE_TYPE_SFP_DD,
+	/* DSFP */
+	MLXSW_REG_PMTM_MODULE_TYPE_DSFP,
+	/* Chip2Chip8x */
+	MLXSW_REG_PMTM_MODULE_TYPE_C2C8X,
 };
 
 /* reg_pmtm_module_type
-- 
2.21.1

