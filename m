Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24CD57178D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiGLKtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiGLKtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:49:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D721A828
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:48:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so9570331edb.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xFvLhpZkHISgnDC83dfl5Kxi12bkzGFASRURcstvTFc=;
        b=GYmlWfyvlTE7ZKNMe2DOy8ksmDgNqzTCOrrIzMUcC4OqWDlQt4WcQQRLgfBics9Ir9
         8B7qIKvVvqU6hGgI5P4VXX7ijvCFrWi8D46oqGA/qilThib4FC4vFU1IpyZIwucIoMQP
         1GfFh0lH0uyOLkURuj3eV24IlCi1R1f669s6bhZqDqMgWunsKo2xRoJHkFneiKBr96rX
         FTiOpkdbM7yTQ6jZa2KJAHMhFKtiF6vsJOefuwuFZ02uXjZZXhKkI4a51UPW5osvluoo
         LzbXKGAIg/dKD3b2elzBWBjOzo07PvU8Li1ecEtX15Z38LB4lzGaA4TpVuy2+3im5U1T
         5t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xFvLhpZkHISgnDC83dfl5Kxi12bkzGFASRURcstvTFc=;
        b=2UQqBY4teAUwa00npDdIN9foJtJpESIlERwT/UUeuPCeOy2uwSbYDmImF2GGm8DnzM
         6Avor36d0KEFQES4tPbjlDHSPieVqBu4kEjS8zONzHOAerT3u/JNnGSklu/CbEx1Wihe
         Pzwwf68ZIo5sX9lE3oQgGZ5D2HcaE4C9tWTDhfowpuMmf1EnBsjxdEuj5p+w2nSwU2bo
         JAjGyRduccKt5NZJb9MDwxmPkGgczI+TBfztqImmxQS7fedYOhFecI41iAwncYbanlav
         wjfvKCB5CNnrOSAAUG9NVAGwDy5rs8ccg5adq9x5qCJKp66VctNAl066S2j8UGgTMYND
         2bag==
X-Gm-Message-State: AJIora8J3a/REaEWuaIvwy30/A3Ni5/utSgBY/TZwd6ZxtBBAPdETkS6
        SNq58d5c6KXG0czUgAPFGwMPdECUwPKx8Mkwaik=
X-Google-Smtp-Source: AGRyM1s2gw2l937xOun0I+GD7LtCx0s8lbDk/k3eVKGxJqyxL2RhpwIljNEnDD9bgAOAu5SCCkVFhw==
X-Received: by 2002:a05:6402:1909:b0:43a:64bb:9f27 with SMTP id e9-20020a056402190900b0043a64bb9f27mr31713174edz.24.1657622936620;
        Tue, 12 Jul 2022 03:48:56 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 27-20020a170906311b00b0072aac739089sm3688821ejx.98.2022.07.12.03.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:48:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 1/3] net: devlink: make devlink_dpipe_headers_register() return void
Date:   Tue, 12 Jul 2022 12:48:51 +0200
Message-Id: <20220712104853.2831646-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104853.2831646-1-jiri@resnulli.us>
References: <20220712104853.2831646-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The return value is not used, so change the return value type to void.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c | 6 ++----
 include/net/devlink.h                                | 2 +-
 net/core/devlink.c                                   | 5 ++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 5d494fabf93d..c2540292702d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -1266,10 +1266,8 @@ int mlxsw_sp_dpipe_init(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int err;
 
-	err = devlink_dpipe_headers_register(devlink,
-					     &mlxsw_sp_dpipe_headers);
-	if (err)
-		return err;
+	devlink_dpipe_headers_register(devlink, &mlxsw_sp_dpipe_headers);
+
 	err = mlxsw_sp_dpipe_erif_table_init(mlxsw_sp);
 	if (err)
 		goto err_erif_table_init;
diff --git a/include/net/devlink.h b/include/net/devlink.h
index b1b5c19a8316..88c701b375a2 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1590,7 +1590,7 @@ int devlink_dpipe_table_register(struct devlink *devlink,
 				 void *priv, bool counter_control_extern);
 void devlink_dpipe_table_unregister(struct devlink *devlink,
 				    const char *table_name);
-int devlink_dpipe_headers_register(struct devlink *devlink,
+void devlink_dpipe_headers_register(struct devlink *devlink,
 				   struct devlink_dpipe_headers *dpipe_headers);
 void devlink_dpipe_headers_unregister(struct devlink *devlink);
 bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2b2e454ebd78..c261bba9ab76 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10425,13 +10425,12 @@ EXPORT_SYMBOL_GPL(devlink_sb_unregister);
  *
  *	Register the headers supported by hardware.
  */
-int devlink_dpipe_headers_register(struct devlink *devlink,
-				   struct devlink_dpipe_headers *dpipe_headers)
+void devlink_dpipe_headers_register(struct devlink *devlink,
+				    struct devlink_dpipe_headers *dpipe_headers)
 {
 	devl_lock(devlink);
 	devlink->dpipe_headers = dpipe_headers;
 	devl_unlock(devlink);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
 
-- 
2.35.3

