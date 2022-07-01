Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1789B56382C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiGAQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGAQkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:40:20 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABEA27FF5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:40:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so4313558wmr.0
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gytAPwyfOtXarB0gmwWuVe9Ikqalz5MJ7KJtzEP1EE=;
        b=uK/eSCrA/1Shj2LUv3K9m7rVIxV/8Aw3Wjn3cs3i4/iv1+K9gCEIAE/t5oMbUBcfCH
         ebeIRfrRGvOrz4zoZ/lABSMA/+dPdxiNYLLt9hhN8OKQkrYAgCrlQFrRNGCBZHTb/xLe
         mO7/VOueh5PZ3cfPbcNAAhzEJECIdt2InRhMx/6tWbU4WuqpysJ0xA641tWV9HeHtRwJ
         8DmVWcT0VJVl35KQZN4a5AYjbm9cQmzHUWxAqIVidOhM7x+FV/kGM+BoP0ryd2mW4Y8S
         hqn79/z/bj9p/hGwGP9bxdbjRfjgynw9KfleTO8JnlDOTO59amlmF9R6Ovdc83HKpbM5
         qslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3gytAPwyfOtXarB0gmwWuVe9Ikqalz5MJ7KJtzEP1EE=;
        b=wwJgP8FW4CHFFWHj2pf/MJ+FMKjumoY4CJGlLVz3hJZPWprPffLunJIhMQ3/0WjV0G
         bMxBRCkYg8Sq2Gm7QLeIXmkiUD+aDwBRRTGBghkONa3pF3MVdHsGQhjhv6RYp9pcDznp
         GIzHhWfmdlmDdKSGbvpqRV1t0CIAZ5oKouGMeAq9p7YGI+TWJCqFHbRIXi/T6bLIz3GQ
         35ut3zMuIfD3x8WPyy4VQj9JBQW5MzDN/nX2kvMN/QjgWt1JuaxC5ksEIL0nN4c0Vjz8
         7sHzdmpN4fHNwLswswa0V7w9TF/uSA2hVfcfWwtDQxgRm54Zj57UClBJzWr3NDUUSOPQ
         bOCA==
X-Gm-Message-State: AJIora8JUWPRES77cMs7Jr1TXm1PqvVI1CfG6HDw/+BWYz05Ud9+BGta
        HMYf0QDG42/4trHwWXc/Ntle0G+ZOOLKBA4M
X-Google-Smtp-Source: AGRyM1sBBHZpA9X9hjl2g8ctbPF+JQbk154j2D3VUe0teaNKXHAaM6uE0+ECm6DdmhNtx6DiF9eXpg==
X-Received: by 2002:a05:600c:3d8b:b0:3a0:466c:b08d with SMTP id bi11-20020a05600c3d8b00b003a0466cb08dmr16822009wmb.125.1656693614071;
        Fri, 01 Jul 2022 09:40:14 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f25-20020a7bcd19000000b0039c673952bfsm6724309wmj.6.2022.07.01.09.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:40:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v2 3/3] net: devlink: fix unlocked vs locked functions descriptions
Date:   Fri,  1 Jul 2022 18:40:07 +0200
Message-Id: <20220701164007.1243684-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701164007.1243684-1-jiri@resnulli.us>
References: <20220701164007.1243684-1-jiri@resnulli.us>
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

To be unified with the rest of the code, the unlocked version (devl_*)
of function should have the same description in documentation as the
locked one. Add the missing documentation. Also, add "Context"
annotation for the locked versions where it is missing.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- s/devlink_/devl_/ for unregister comment
- removed tabs
- added ()s
---
 net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a7477addbd59..330a7260fae0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9877,6 +9877,19 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ * devl_port_register() - Register devlink port
+ *
+ * @devlink: devlink
+ * @devlink_port: devlink port
+ * @port_index: driver-specific numerical identifier of the port
+ *
+ * Register devlink port with provided port index. User can use
+ * any indexing, even hw-related one. devlink_port structure
+ * is convenient to be embedded inside user driver private structure.
+ * Note that the caller should take care of zeroing the devlink_port
+ * structure.
+ */
 int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
@@ -9915,6 +9928,8 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *	is convenient to be embedded inside user driver private structure.
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
@@ -9929,6 +9944,11 @@ int devlink_port_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
+/**
+ * devl_port_unregister() - Unregister devlink port
+ *
+ * @devlink_port: devlink port
+ */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
@@ -9946,6 +9966,8 @@ EXPORT_SYMBOL_GPL(devl_port_unregister);
  *	devlink_port_unregister - Unregister devlink port
  *
  *	@devlink_port: devlink port
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
@@ -10206,6 +10228,15 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
 
+/**
+ * devlink_rate_leaf_create - create devlink rate leaf
+ * @devlink_port: devlink port object to create rate object on
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type leaf on provided @devlink_port.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
 int
 devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
@@ -10220,6 +10251,11 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
 
+/**
+ * devl_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ * @devlink_port: devlink port linked to the rate object
+ */
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
-- 
2.35.3

