Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDA8573892
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiGMOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiGMOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:19:00 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66933DF5C
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:18:58 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g1so14278596edb.12
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G5D9ObugWzkVvxI4itszsf2bVDOEhul6X0UMnwjbpJ8=;
        b=45jfJ9VZtFXf+WRKwYUQth7/hrYxDNXWCV9hDrhgkzc3ihDDlT2Bj0kaXc9y5N48Tc
         EM8RB+aZyDSVslzQzQKy3EUfECF8/PSnXC0yLCIm4qRoGJZEX/VBNEb+dEC0y0L3/UMN
         +pEP8YeAujRJVWxDSpouibrBVIB00ceGumG9qKSHFHzPJ49OoT/zZ1BiRECXgf+RcXEy
         rzw8q0VCFqfwIIEt4aVApzxaAGr6wRttlI4ZdwNc6PqVE0qKErEnGn18EPIK2xuSc/cN
         QWPKLDHZRwQNvL3LzPqjLzQjNEsGgRl712PrHkVs2rtpWyEjMQbjkZ9LaVIY9HEIqPy7
         auRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G5D9ObugWzkVvxI4itszsf2bVDOEhul6X0UMnwjbpJ8=;
        b=fcA3m2QpxaHVuRxrZduIXphsS21Rouik0+axTNpAd9mKBX0cCkiKanUmhKEzndNWH/
         5LCb9Erog7v6n0ZXI0stENPjkwCDujNb9F/SiwOdOyeO7lQ4e/j+jQVsPjdl9HRDLmi9
         IkzhQOpYV7EnihHSYC4YBXLyoq9n7CzHqIwWa5ii3Ccwt+nJJP9FNdx5dkSSGfh9Jlil
         ti3RurcqUvmThq5wFEsv3Eq3MXUvidRSEO6bPwHBPlRXjrI/rdzPPrCOMO0zp0esrq+l
         rqHB/enxFySkjO5RH0Rj0lbR5latPvtakAoJbVCjzEkolX1wL5THOkze8ImB/d53OwlP
         kGDw==
X-Gm-Message-State: AJIora/gDsHg0022eRuHB8eRXh1VXgr+Gvk4Xe8qi8np1BmkWjiQoPVX
        vgPuqCrwEEwByUVP9jW5CTyy7e/BciVcu1IOxOA=
X-Google-Smtp-Source: AGRyM1uv/xBUdBNPdQVho4UsaiLYHZp1homVs0aBPiLWv9eNtdQe5IFvqP0vard4h5fi3/5rqlKnyg==
X-Received: by 2002:a05:6402:414c:b0:435:1e2a:2c7f with SMTP id x12-20020a056402414c00b004351e2a2c7fmr5365731eda.132.1657721937010;
        Wed, 13 Jul 2022 07:18:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b16-20020a17090630d000b0072aeaa1bb5esm5055928ejb.211.2022.07.13.07.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:18:56 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next repost 1/3] net: devlink: make devlink_dpipe_headers_register() return void
Date:   Wed, 13 Jul 2022 16:18:51 +0200
Message-Id: <20220713141853.2992014-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713141853.2992014-1-jiri@resnulli.us>
References: <20220713141853.2992014-1-jiri@resnulli.us>
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
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

