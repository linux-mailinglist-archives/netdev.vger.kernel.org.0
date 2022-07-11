Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411BC56D784
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiGKIOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGKIOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:14:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB88C1D32E
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23329B80E45
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 08:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D39C341C0;
        Mon, 11 Jul 2022 08:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657527258;
        bh=BcZ899AzPTe6wxJpfQBvKDuTH+vzFYTkJy5fHL4KweE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlPP2XoOGSZyAbZIwj0/m7WFhq9aqkiQNb5owbj3QqS2pC1O17WN1G9UEKRQ4uQdd
         MK3m4+d2KAGsm24brqERGdHXyIhDMr/Tto1+cxC6W7IuoHyLMmcgLash4ozY9Ysyax
         83XKOVg0hRNF9xP/dqU03sFTtQghMlJ4vCz3xhLc4SEt8U78a4ytqkH69XqJ0aYrRu
         riJj14m+iNzcPCAhbEBGRLz42ibwb00oFdMuaLdW6xuruL+PsNfc2Clil3ieBV077o
         TAudpFFIbalAQmCxyhh6CG6sw3yQfC9DbcpP7QgqslEZm8O3XSR3l/VUI29MTr6Du+
         j0hfHp0sgofaA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 6/9] devlink: Remove unused functions devlink_rate_leaf_create/destroy
Date:   Mon, 11 Jul 2022 01:14:05 -0700
Message-Id: <20220711081408.69452-7-saeed@kernel.org>
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

The previous patch removed the last usage of the functions
devlink_rate_leaf_create() and devlink_rate_nodes_destroy(). Thus,
remove these function from devlink API.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/devlink.h |  2 --
 net/core/devlink.c    | 42 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0e163cc87d45..5150deb67fab 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1569,8 +1569,6 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port,
 				   u32 controller, u16 pf, u32 sf,
 				   bool external);
-int devlink_rate_leaf_create(struct devlink_port *port, void *priv);
-void devlink_rate_leaf_destroy(struct devlink_port *devlink_port);
 void devlink_port_linecard_set(struct devlink_port *devlink_port,
 			       struct devlink_linecard *linecard);
 struct devlink_linecard *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1588e2246234..970e5c2a52bd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10006,20 +10006,13 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
 
-int
-devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
-{
-	struct devlink *devlink = devlink_port->devlink;
-	int ret;
-
-	mutex_lock(&devlink->lock);
-	ret = devl_rate_leaf_create(devlink_port, priv);
-	mutex_unlock(&devlink->lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
-
+/**
+ * devl_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ * @devlink_port: devlink port linked to the rate object
+ *
+ * Destroy the devlink rate object of type leaf on provided @devlink_port.
+ */
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
@@ -10037,27 +10030,6 @@ void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devl_rate_leaf_destroy);
 
-/**
- * devlink_rate_leaf_destroy - destroy devlink rate leaf
- *
- * @devlink_port: devlink port linked to the rate object
- *
- * Context: Takes and release devlink->lock <mutex>.
- */
-void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
-{
-	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
-	struct devlink *devlink = devlink_port->devlink;
-
-	if (!devlink_rate)
-		return;
-
-	mutex_lock(&devlink->lock);
-	devl_rate_leaf_destroy(devlink_port);
-	mutex_unlock(&devlink->lock);
-}
-EXPORT_SYMBOL_GPL(devlink_rate_leaf_destroy);
-
 /**
  * devl_rate_nodes_destroy - destroy all devlink rate nodes on device
  * @devlink: devlink instance
-- 
2.36.1

