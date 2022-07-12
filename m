Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB38571801
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiGLLFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiGLLFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:33 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D34B026A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:29 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eq6so9639217edb.6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VvJVBpAmry3qQxleAYU1E1eJPOZDjTEfYtYAlTZyagQ=;
        b=g0ypmGWA0KZmyMrNhcgf0Q59t5HT0j2CGvSLqKyau8yr+m/CebjfwzE1nt/jPzT3KK
         oLWgs1gb5Y0eREX2+VJas48Cr4vgMlC+a+v2B4a5Qs69Mm0Dw2lvgE+eFA3RKuF5Fh4u
         dBzikagnphVBj6LGbO552nl2GKR8gyIzaaMaLme5vpxUDJeS3gQBcQs2jY1wPwyMPM58
         qAcbQSk0vDWfsBrxg2y/6r5lTQ6m4f1I5Yeu/4URVaFiT/en1yHUX4Bl4cqqYpQeE42J
         qw9lNLahCoMZZIxDucpUwalAWFM3/R784qAyGm23tBKE7b7ade3jIae1YrCqcf90Cl7J
         4F2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VvJVBpAmry3qQxleAYU1E1eJPOZDjTEfYtYAlTZyagQ=;
        b=4vl7jPZMnwt/8XdrGznG2sOmH2wBpcI+hJHJyEuyC7py+L1EjK8tgM1shtVTtYpL8y
         /5v4/asCdHvhkZLrSbpvj88+91dIIRR4tyVTiRZMD/KQkb5MZfSVgNXU5TZoVj1sSnXH
         Vq/gmWzyoSKB1cWWjh8PS3Y3a/bfzSvo7+n5FQPIaTvp+IonMb7RP5ThaWnfaqVC/w7Y
         QzlrOr7sZOY3Yn/i6YF4XLz2x+CBEbLYScIuCHvBfqWCuxLBeQyMzb2yaJrwUfM5In4D
         GpJdgU6Ncohk8Vog7+3ieLBfNhnNIZZ4rAfA/I6p2SGSvDsp5bwp+HkM+8T11bOJzi5q
         cK7Q==
X-Gm-Message-State: AJIora/UYe+u6YJ4YBSCmKPziCD8Lqff8CMyWU4qd3z+chsvEPw9BGp6
        QIsNVy+gkXmTW3knwHG8J/imZKuhtYXnn5C4KJA=
X-Google-Smtp-Source: AGRyM1va4zc+ovB0QCrcbUnz/WhNhxEZJ6DMODbDLNM6pJjfhky7dU4aXl+WhqUm2XCFiuJE8fRuiQ==
X-Received: by 2002:a05:6402:d05:b0:435:b2a6:94eb with SMTP id eb5-20020a0564020d0500b00435b2a694ebmr30025718edb.87.1657623928326;
        Tue, 12 Jul 2022 04:05:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r17-20020a17090609d100b0071d3b6ed4eesm3661683eje.160.2022.07.12.04.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 10/10] net: devlink: remove unused locked functions
Date:   Tue, 12 Jul 2022 13:05:11 +0200
Message-Id: <20220712110511.2834647-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
References: <20220712110511.2834647-1-jiri@resnulli.us>
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
index 7cf4fa2daabd..80bd9d3824ed 100644
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
@@ -12259,30 +12134,6 @@ devl_trap_policers_register(struct devlink *devlink,
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
@@ -12302,25 +12153,6 @@ devl_trap_policers_unregister(struct devlink *devlink,
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

