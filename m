Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76756D780
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiGKIOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGKIOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086571D300
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D07CB80D2C
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E27C34115;
        Mon, 11 Jul 2022 08:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527256;
        bh=WMVuuOZKwwegUAYxXTiO+M/YeLley02rtiztGEhPh+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZyxIqIB7wwwZejFFEx79y1rw7fgeRzQdl0bbzAjOttXy9gryHMpHUdWBK2EqoVgEA
         QWYaw1tZig04pntlRUzVdjNJ3KUn5FuRkTeQiGOjNJPs0gm0yLQAXXj4jMw+dmXLcx
         i8NujDNHWBIdO7o6A4AzxmOdind+Ce5OhoVRZ0bT2eAwafCG2B+FT2OzpKvGLi3tG7
         yaUN4nU6zz7eqWdNMUeDS8olrxujuorCxEko9bxJ9Xx05B+kvRdXLIbNuUWDLeA1Au
         +bpuguYlWhtqeTbB6HfIdthXu0uV3bromu31X1RHFI65hQgvkfifx3u53NcS9oI8tI
         6gpdDLEycbQwA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 3/9] devlink: Remove unused function devlink_rate_nodes_destroy
Date:   Mon, 11 Jul 2022 01:14:02 -0700
Message-Id: <20220711081408.69452-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711081408.69452-1-saeed@kernel.org>
References: <20220711081408.69452-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

The previous patch removed the last usage of the function
devlink_rate_nodes_destroy(). Thus, remove this function from devlink
API.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/devlink.h |  1 -
 net/core/devlink.c    | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..0e163cc87d45 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1571,7 +1571,6 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   bool external);
 int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
 void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
-void devlink_rate_nodes_destroy(struct devlink *devlink);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
 struct devlink_linecard *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db61f3a341cb..1588e2246234 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10095,24 +10095,6 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devl_rate_nodes_destroy);
 
-/**
- * devlink_rate_nodes_destroy - destroy all devlink rate nodes on device
- *
- * @devlink: devlink instance
- *
- * Unset parent for all rate objects and destroy all rate nodes
- * on specified device.
- *
- * Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_rate_nodes_destroy(struct devlink *devlink)
-{
-	mutex_lock(&devlink->lock);
-	devl_rate_nodes_destroy(devlink);
-	mutex_unlock(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devlink_rate_nodes_destroy);
-
 /**
  *	devlink_port_linecard_set - Link port with a linecard
  *
-- 
2.36.1

