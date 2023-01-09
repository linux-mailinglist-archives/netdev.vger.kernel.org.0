Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5329A662F42
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbjAISex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237867AbjAISdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:50 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC673631A8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:45 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jn22so10424976plb.13
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpkI6LkrvMQIQDWSSPG6slB2MzXabzQEr2SFrWQP85E=;
        b=nFZkzNVHjnAGChloHy1hBbyz7x4t/xKMzySy+166SAaK5Xd16fEhMQERLxjx24YR7F
         vbQvhuqvUoPfmSgdLtlRVszxa9f2eJVtyet+A/cK5ASig4erXQKahduXJ2DqQhPZCSP7
         eW7n2yOB68EM+qLYLZD8pVGD87PF4hOJB/lAmA5BqNosYXlrqXMEeFgu0LCC1HbezUMZ
         OE4KzKqHXacwa38NG77ibEeYRVa0uRoPN529SMp/E+Cj2tvcSnrQUEnkQheX7gZ5lDoj
         +7LQhnxaYkF0nxU3srB0zySUvncs3JF8qv61eGSC6A4XEKEYDdsb6MGqhZgVDmL/R8a0
         h4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SpkI6LkrvMQIQDWSSPG6slB2MzXabzQEr2SFrWQP85E=;
        b=OrwmcEpHCYCivWwk07vmDLzdq262l5PIFteavmzog292lenQa8qp3XWvxzJAOU5TRz
         /XoLpTabK+58mMZJHlRnCkb5Ty0Fd49S8aVWbPVDTZRldoRKWUR3qynzL3L+2MzscTWD
         TVDtV/P2gCLD32Qo3PnDJNpo8M/NqVZPAPkSRFJ2lL6tlkthwDE4hhm9dEy4WX3d8M8S
         FKJqE72DTXAEq85QRj7s8Su3dPkh5AxDbZb9YaKeifLLB5W+DeiOV8RzKTa+oqOBeRFi
         vGVSoVdStWKI2qiMQ8ovC48hDE7usB11oK/01ATgpkNzdtyzFFtiGxih7bGHKwF3pnFm
         xrlQ==
X-Gm-Message-State: AFqh2kra0JE52iPXpJeSG6d5OU0OrILEfR4jZRJpZW6eKlg5qoCVwimS
        1IF0lxMmQ8RvVOAK883xD+hEAmsQPLPJZXYPOn4CcQ==
X-Google-Smtp-Source: AMrXdXvq4qdHuU0Okt9/ydLLH1nQB49ikRPQINlYfr3oRg0FBKsQ170fgF+9NEQWQnsxHF7O/GoW6A==
X-Received: by 2002:a17:902:c702:b0:192:666f:933e with SMTP id p2-20020a170902c70200b00192666f933emr48960979plp.1.1673289105460;
        Mon, 09 Jan 2023 10:31:45 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id i18-20020a170902c95200b00189a50d2a3esm6368459pla.241.2023.01.09.10.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:44 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 06/11] devlink: remove devl_port_health_reporter_destroy()
Date:   Mon,  9 Jan 2023 19:31:15 +0100
Message-Id: <20230109183120.649825-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
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
index b8ef03445b3a..dc8e7684fec4 100644
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
index 50ac049ee60b..70b8a9f15ac3 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7423,13 +7423,6 @@ devlink_health_reporter_put(struct devlink_health_reporter *reporter)
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
@@ -7440,7 +7433,8 @@ devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
 	devl_assert_locked(reporter->devlink);
 
-	__devlink_health_reporter_destroy(reporter);
+	list_del(&reporter->list);
+	devlink_health_reporter_put(reporter);
 }
 EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
@@ -7455,20 +7449,6 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
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

