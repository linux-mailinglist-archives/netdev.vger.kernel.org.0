Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF366570A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238590AbjAKJMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237954AbjAKJLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:36 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38B13D6E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:08 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g23so526054plq.12
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbpdQM9vF4qpv7TbsCwGpuCdyBeHOXTGK78hO76FOr8=;
        b=rhRKx+PzKmRYqyQnwJidNNTY3aLwFHkDTm5qA4h/x0KtYR3K35WrxoItT7rCLvFoKG
         lAzB/gGCRsFr56biGZGWwmDG0jypIYIKlLDQEAjztPgn/xAv0j0uYnNqCdSCawlrTc88
         WAvLeKMmFF/Ws7qjyEP2yIixJs8tYYzz33xLdJQMCEhGaS7SBp6RIVbeSLfXTGw0xWOS
         Fn+tCfnhXMjcsbdAAuu61emJtkc2HZ2ax4N1ahdh0EeYv5hMIzhOyw2tbCnsWzRQ/QeI
         MxpGOBzyf8yt3Xf0NVJxMVe99NTigx8f5D63HetX+p4njavr/FH4uRUH3iotGoIid1bY
         yvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zbpdQM9vF4qpv7TbsCwGpuCdyBeHOXTGK78hO76FOr8=;
        b=CkC6u+NFQkqKiawc60PrsxMk2YeJFl2Hpmq1gTbTkgQwTeTJdg4+VQXUmg/B1uc/B7
         26U3i5Eerk+t7gaZ9tSscUpRvfgp33nRGhwhlhMRxWfuztQKETzei9U5yjCl4bPqQZYA
         a/aPFx/nTsLWq98Z6mcnZzVAtNcezcClU92oZi+heKYInkNtHexSFSRfkMVeMXid0Ev/
         Zbqmi1UZO6qL5E1P/IgZWNIxWopMIgc86+9HyOY7rOmElrlJ6BlyuaYVkxKcglZoE4Br
         5lBLleWPLS7Uttbx8Tyd6lAPXVaik57dswPYn4xlAFiSFKjaEPSUQ8+Le3o0nKLIIgZy
         ZlFg==
X-Gm-Message-State: AFqh2kqqMWnIjW+p2bkkGd3NY+C/MUZeoZcZXnMC6jZY+hEGe3L6rIoj
        MrdrXo6HVBNaF1yKM6QqCB9sMZP97IGvKU1poxql3A==
X-Google-Smtp-Source: AMrXdXt7kuLyhuvS3P7G7fOQWCWFJXP4/nFiwVYQ/z1HyIZcBbkxWNCP+q2R0gC5AWepC55KcpYKvw==
X-Received: by 2002:a05:6a21:1788:b0:ad:def6:af3 with SMTP id nx8-20020a056a21178800b000addef60af3mr90532791pzb.57.1673428088222;
        Wed, 11 Jan 2023 01:08:08 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090a384200b0022727d4af8dsm3228613pjf.48.2023.01.11.01.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:07 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 05/10] devlink: remove devl_port_health_reporter_destroy()
Date:   Wed, 11 Jan 2023 10:07:43 +0100
Message-Id: <20230111090748.751505-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Remove port-specific health reporter destroy function as it is
currently the same as the instance one so no longer needed. Inline
__devlink_health_reporter_destroy() as it is no longer called from
multiple places.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 include/net/devlink.h                         |  3 ---
 net/devlink/leftover.c                        | 24 ++-----------------
 4 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index cdd4d2d0c876..662df2c21747 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -754,6 +754,6 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
 	if (!priv->rx_reporter)
 		return;
 
-	devl_port_health_reporter_destroy(priv->rx_reporter);
+	devl_health_reporter_destroy(priv->rx_reporter);
 	priv->rx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index ad24958f7a44..a932878971ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -609,6 +609,6 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 	if (!priv->tx_reporter)
 		return;
 
-	devl_port_health_reporter_destroy(priv->tx_reporter);
+	devl_health_reporter_destroy(priv->tx_reporter);
 	priv->tx_reporter = NULL;
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0b318a0209f2..ef9bea6ecc63 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1884,9 +1884,6 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter);
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
-void
-devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
-
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
 int devlink_health_report(struct devlink_health_reporter *reporter,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 5af7e619fb12..40226feff49b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7426,13 +7426,6 @@ devlink_health_reporter_put(struct devlink_health_reporter *reporter)
 		devlink_health_reporter_free(reporter);
 }
 
-static void
-__devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
-}
-
 /**
  *	devl_health_reporter_destroy - destroy devlink health reporter
  *
@@ -7443,7 +7436,8 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
 	devl_assert_locked(reporter->devlink);
 
-	__devlink_health_reporter_destroy(reporter);
+	list_del(&reporter->list);
+	devlink_health_reporter_put(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7458,20 +7452,6 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
-/**
- *	devl_port_health_reporter_destroy - destroy devlink port health reporter
- *
- *	@reporter: devlink health reporter to destroy
- */
-void
-devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	devl_assert_locked(reporter->devlink);
-
-	__devlink_health_reporter_destroy(reporter);
-}
-EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
-
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
 				struct devlink_health_reporter *reporter,
-- 
2.39.0

