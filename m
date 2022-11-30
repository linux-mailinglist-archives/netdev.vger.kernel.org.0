Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E203663CE92
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiK3FMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiK3FMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDB968693
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CDD61A1B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F874C433D6;
        Wed, 30 Nov 2022 05:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785121;
        bh=obJSW4L2ICnFnAu/fE5kgdzQqy+C/CI1nejLZpFNaJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZtyzKVCr1Wlg5YqBqMbRq+AOTuf67Cx+mAgoHffomqDl2i1O1XPXKqHItHtwcHPM
         +Ul2FsgZVvdGSL2OGSMNgowSzCdiES7vUGQKYVSfsr7IiM8lVvgFdkJjtK43Ue899q
         0fWYeTLzYlXtRJB58OG30QnhTd9iR9lRvcFPmdPQUHFOGAPQhdzouRWuGwZLYBnZBR
         8zBK4QEKgcpj9pZPJDYRymbFDRN/tBA0c+k7W4DsqoZqCl8aflthqH0CTn0AISsmjH
         qRYm63JKkLrXdqmFE8wcx15SSMHzU9iB35L6JkjT7LhdNVK9CYLWsd2GEvr/C5qTjP
         ELBjAWIcvbEzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Petr Pavlu <petr.pavlu@suse.com>
Subject: [net-next 03/15] net/mlx5: Remove unused ctx variables
Date:   Tue, 29 Nov 2022 21:11:40 -0800
Message-Id: <20221130051152.479480-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Pavlu <petr.pavlu@suse.com>

Remove mlx5_priv.ctx_list and ctx_lock which are no longer used after
commit 601c10c89cbb ("net/mlx5: Delete custom device management logic").

Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 --
 include/linux/mlx5/driver.h                    | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 25e87e5d9270..7f5db13e3550 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1603,8 +1603,6 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	int err;
 
 	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
-	INIT_LIST_HEAD(&priv->ctx_list);
-	spin_lock_init(&priv->ctx_lock);
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 06cbad166225..d476255c9a3f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -606,8 +606,6 @@ struct mlx5_priv {
 	struct list_head        pgdir_list;
 	/* end: alloc staff */
 
-	struct list_head        ctx_list;
-	spinlock_t              ctx_lock;
 	struct mlx5_adev       **adev;
 	int			adev_idx;
 	int			sw_vhca_id;
-- 
2.38.1

