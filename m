Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5675576D67
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiGPLDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiGPLDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:03:05 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE9127FE7
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:03:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id j22so13036082ejs.2
        for <netdev@vger.kernel.org>; Sat, 16 Jul 2022 04:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmbFYBTsqTl9R6LCikmBFsJRI2cTvOHNxJVLGniJP+A=;
        b=NEsKy+90Hd/QXMfOKhAlcUscqCHtVYB6240gR7vAM/tOxQX5fzJG3y4vsP4YoUv8EW
         1DtkHoJIYll2Q1JhOaFLgFSQ11Sd6NnIIG7tlyToB4MiJcm8cw81zh05MUvMec7POg02
         3z3p2o4CZFQNjs8o4ZIkUO/RbwoIf1D73XKuvbeoNYPIugGGmyfARVREhYWRvps0isYm
         HSE7ehIkIxMBwFCaS7Y4CDTmXCEbHaE+5p8uiaeiN0WN+SCleGn6Vmd4f6SMIEUmddD8
         SexZ1RkelhCNM7Q1sDEDfzCymTWImokfi26a4Y+p1Ra7aJHX/AmtlWHrGEFrfJ5ONPCw
         c57w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmbFYBTsqTl9R6LCikmBFsJRI2cTvOHNxJVLGniJP+A=;
        b=0NntN9t/Vu/UFojtV1hDKYsLWGVCMqsBwNd17m8ltPmAjkDaNWVYXdrSCYELf10blC
         XTSVeI58+agleuxGeC9bMGpxfQ7sjOr91bqjccQbpSr/c9rGH4KqAFGbgQEephjH+9W4
         92B9X7xdLp6HK61mT0l6zqFbK/WIOGduwKiCT+W1rfj10J0yB+vEmL9WqW+82PPqp5Su
         QLX9xjs1fN2ELP7na5LiCaXe0IW2u3UTJeLCPmgwlRYa1ytG8DzDRPgZCklneZOMSuyQ
         Eskf7bvNDFzaujwduxBoDJGhjEEE2ZBQ4EsuO8J+w06iVRzxclt7wjWaou82lHJ2MuI6
         0fFw==
X-Gm-Message-State: AJIora+zDGbG304uTfX3/C9PpKSy3jqpkd4XvYCYLVVYcJVzTM0YLTow
        iXx+ZJvtpCC48RTUFX/PwlNa3XK3P01+b0q0
X-Google-Smtp-Source: AGRyM1skVLzCAWOT9OgczR8uStu59Nlwwxfu/O7lJwvyvi0ddSaYm6pvI4d6SVKVodYiHx46ZMXsow==
X-Received: by 2002:a17:907:2887:b0:72b:68ce:2fff with SMTP id em7-20020a170907288700b0072b68ce2fffmr17614493ejc.423.1657969380305;
        Sat, 16 Jul 2022 04:03:00 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r17-20020a056402035100b0043a6a7048absm4536226edw.95.2022.07.16.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 04:02:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next 9/9] net: devlink: remove unused locked functions
Date:   Sat, 16 Jul 2022 13:02:41 +0200
Message-Id: <20220716110241.3390528-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220716110241.3390528-1-jiri@resnulli.us>
References: <20220716110241.3390528-1-jiri@resnulli.us>
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

Remove locked versions of functions that are no longer used by anyone.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  20 -----
 net/core/devlink.c    | 168 ------------------------------------------
 2 files changed, 188 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 242798967a44..780744b550b8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1594,20 +1594,11 @@ int devl_dpipe_table_register(struct devlink *devlink,
 			      const char *table_name,
 			      struct devlink_dpipe_table_ops *table_ops,
 			      void *priv, bool counter_control_extern);
-int devlink_dpipe_table_register(struct devlink *devlink,
-				 const char *table_name,
-				 struct devlink_dpipe_table_ops *table_ops,
-				 void *priv, bool counter_control_extern);
 void devl_dpipe_table_unregister(struct devlink *devlink,
 				 const char *table_name);
-void devlink_dpipe_table_unregister(struct devlink *devlink,
-				    const char *table_name);
 void devl_dpipe_headers_register(struct devlink *devlink,
 				 struct devlink_dpipe_headers *dpipe_headers);
-void devlink_dpipe_headers_register(struct devlink *devlink,
-				   struct devlink_dpipe_headers *dpipe_headers);
 void devl_dpipe_headers_unregister(struct devlink *devlink);
-void devlink_dpipe_headers_unregister(struct devlink *devlink);
 bool devlink_dpipe_table_counter_enabled(struct devlink *devlink,
 					 const char *table_name);
 int devlink_dpipe_entry_ctx_prepare(struct devlink_dpipe_dump_ctx *dump_ctx);
@@ -1640,9 +1631,6 @@ void devlink_resources_unregister(struct devlink *devlink);
 int devl_resource_size_get(struct devlink *devlink,
 			   u64 resource_id,
 			   u64 *p_resource_size);
-int devlink_resource_size_get(struct devlink *devlink,
-			      u64 resource_id,
-			      u64 *p_resource_size);
 int devl_dpipe_table_resource_set(struct devlink *devlink,
 				  const char *table_name, u64 resource_id,
 				  u64 resource_units);
@@ -1817,18 +1805,10 @@ int
 devl_trap_policers_register(struct devlink *devlink,
 			    const struct devlink_trap_policer *policers,
 			    size_t policers_count);
-int
-devlink_trap_policers_register(struct devlink *devlink,
-			       const struct devlink_trap_policer *policers,
-			       size_t policers_count);
 void
 devl_trap_policers_unregister(struct devlink *devlink,
 			      const struct devlink_trap_policer *policers,
 			      size_t policers_count);
-void
-devlink_trap_policers_unregister(struct devlink *devlink,
-				 const struct devlink_trap_policer *policers,
-				 size_t policers_count);
 
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1c75de6f6388..98d79feeb3dc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10461,25 +10461,6 @@ void devl_dpipe_headers_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_dpipe_headers_register);
 
-/**
- *	devlink_dpipe_headers_register - register dpipe headers
- *
- *	@devlink: devlink
- *	@dpipe_headers: dpipe header array
- *
- *	Register the headers supported by hardware.
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_dpipe_headers_register(struct devlink *devlink,
-				    struct devlink_dpipe_headers *dpipe_headers)
-{
-	devl_lock(devlink);
-	devl_dpipe_headers_register(devlink, dpipe_headers);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_dpipe_headers_register);
-
 /**
  * devl_dpipe_headers_unregister - unregister dpipe headers
  *
@@ -10495,23 +10476,6 @@ void devl_dpipe_headers_unregister(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_dpipe_headers_unregister);
 
-/**
- *	devlink_dpipe_headers_unregister - unregister dpipe headers
- *
- *	@devlink: devlink
- *
- *	Unregister the headers supported by hardware.
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_dpipe_headers_unregister(struct devlink *devlink)
-{
-	devl_lock(devlink);
-	devl_dpipe_headers_unregister(devlink);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_dpipe_headers_unregister);
-
 /**
  *	devlink_dpipe_table_counter_enabled - check if counter allocation
  *					      required
@@ -10583,32 +10547,6 @@ int devl_dpipe_table_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_dpipe_table_register);
 
-/**
- *	devlink_dpipe_table_register - register dpipe table
- *
- *	@devlink: devlink
- *	@table_name: table name
- *	@table_ops: table ops
- *	@priv: priv
- *	@counter_control_extern: external control for counters
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-int devlink_dpipe_table_register(struct devlink *devlink,
-				 const char *table_name,
-				 struct devlink_dpipe_table_ops *table_ops,
-				 void *priv, bool counter_control_extern)
-{
-	int err;
-
-	devl_lock(devlink);
-	err = devl_dpipe_table_register(devlink, table_name, table_ops, priv,
-					counter_control_extern);
-	devl_unlock(devlink);
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_dpipe_table_register);
-
 /**
  * devl_dpipe_table_unregister - unregister dpipe table
  *
@@ -10631,23 +10569,6 @@ void devl_dpipe_table_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_dpipe_table_unregister);
 
-/**
- *	devlink_dpipe_table_unregister - unregister dpipe table
- *
- *	@devlink: devlink
- *	@table_name: table name
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_dpipe_table_unregister(struct devlink *devlink,
-				    const char *table_name)
-{
-	devl_lock(devlink);
-	devl_dpipe_table_unregister(devlink, table_name);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_dpipe_table_unregister);
-
 /**
  * devl_resource_register - devlink resource register
  *
@@ -10820,28 +10741,6 @@ int devl_resource_size_get(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_resource_size_get);
 
-/**
- *	devlink_resource_size_get - get and update size
- *
- *	@devlink: devlink
- *	@resource_id: the requested resource id
- *	@p_resource_size: ptr to update
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-int devlink_resource_size_get(struct devlink *devlink,
-			      u64 resource_id,
-			      u64 *p_resource_size)
-{
-	int err;
-
-	devl_lock(devlink);
-	err = devl_resource_size_get(devlink, resource_id, p_resource_size);
-	devl_unlock(devlink);
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_resource_size_get);
-
 /**
  * devl_dpipe_table_resource_set - set the resource id
  *
@@ -10868,30 +10767,6 @@ int devl_dpipe_table_resource_set(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_dpipe_table_resource_set);
 
-/**
- *	devlink_dpipe_table_resource_set - set the resource id
- *
- *	@devlink: devlink
- *	@table_name: table name
- *	@resource_id: resource id
- *	@resource_units: number of resource's units consumed per table's entry
- *
- *	Context: Takes and release devlink->lock <mutex>.
- */
-int devlink_dpipe_table_resource_set(struct devlink *devlink,
-				     const char *table_name, u64 resource_id,
-				     u64 resource_units)
-{
-	int err;
-
-	devl_lock(devlink);
-	err = devl_dpipe_table_resource_set(devlink, table_name,
-					    resource_id, resource_units);
-	devl_unlock(devlink);
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_dpipe_table_resource_set);
-
 /**
  * devl_resource_occ_get_register - register occupancy getter
  *
@@ -12262,30 +12137,6 @@ devl_trap_policers_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_trap_policers_register);
 
-/**
- * devlink_trap_policers_register - Register packet trap policers with devlink.
- * @devlink: devlink.
- * @policers: Packet trap policers.
- * @policers_count: Count of provided packet trap policers.
- *
- * Return: Non-zero value on failure.
- *
- * Context: Takes and release devlink->lock <mutex>.
- */
-int
-devlink_trap_policers_register(struct devlink *devlink,
-			       const struct devlink_trap_policer *policers,
-			       size_t policers_count)
-{
-	int err;
-
-	devl_lock(devlink);
-	err = devl_trap_policers_register(devlink, policers, policers_count);
-	devl_unlock(devlink);
-	return err;
-}
-EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
-
 /**
  * devl_trap_policers_unregister - Unregister packet trap policers from devlink.
  * @devlink: devlink.
@@ -12305,25 +12156,6 @@ devl_trap_policers_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devl_trap_policers_unregister);
 
-/**
- * devlink_trap_policers_unregister - Unregister packet trap policers from devlink.
- * @devlink: devlink.
- * @policers: Packet trap policers.
- * @policers_count: Count of provided packet trap policers.
- *
- * Context: Takes and release devlink->lock <mutex>.
- */
-void
-devlink_trap_policers_unregister(struct devlink *devlink,
-				 const struct devlink_trap_policer *policers,
-				 size_t policers_count)
-{
-	devl_lock(devlink);
-	devl_trap_policers_unregister(devlink, policers, policers_count);
-	devl_unlock(devlink);
-}
-EXPORT_SYMBOL_GPL(devlink_trap_policers_unregister);
-
 static void __devlink_compat_running_version(struct devlink *devlink,
 					     char *buf, size_t len)
 {
-- 
2.35.3

