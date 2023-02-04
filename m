Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C02368A956
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjBDKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbjBDKJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F1F68ADD
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB7160C02
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1697EC433EF;
        Sat,  4 Feb 2023 10:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505365;
        bh=27CgxurPhV8yobn8B4/JceiPHLNnTlF4ZQPKIFNwpY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uqkqn0L782b1fVGssZ45z87vzon/TNtVPrfbS0Es4tSfNGJK82L+fYHl/bt821RTp
         Un9mk4p3g8pwzGx8k6dLOoFuiOJX1JG8jKMmZ3ml3GrPemi1KSXzYub8wAGuA5Eu2K
         CEjItxp7Lt0JtPxnAjuFk1M7Gz1x3cojabC/HpFKaYnY0Fk4Tddw+aF4K0+FOFG/aC
         zZ54n4Wt2PPI5iWj6H71VBCMwwDztscbBfIvfEbD2p++xn9MYOub79939CFbuy356c
         npDkkfiAsdqNwUXs9YAhi6clyRCRh+0LcTgdHVeI1ZOKG63wOb1xzwj/ayttZKuhVK
         QT8vflfWZj3tA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Document support for RoCE HCA disablement capability
Date:   Sat,  4 Feb 2023 02:08:49 -0800
Message-Id: <20230204100854.388126-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Some mlx5 devices are capable of disabling RoCE. In this situation,
disablement does not need to be handled at the driver level.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5/devlink.rst     | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
index eca7ac0334c5..9b5c40ba7f0d 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
@@ -66,10 +66,12 @@ User command examples:
 
 enable_roce: RoCE enablement state
 ----------------------------------
-RoCE enablement state controls driver support for RoCE traffic.
-When RoCE is disabled, there is no gid table, only raw ethernet QPs are supported and traffic on the well-known UDP RoCE port is handled as raw ethernet traffic.
+If the device supports RoCE disablement, RoCE enablement state controls device
+support for RoCE capability. Otherwise, the control occurs in the driver stack.
+When RoCE is disabled at the driver level, only raw ethernet QPs are supported.
 
-To change RoCE enablement state, a user must change the driverinit cmode value and run devlink reload.
+To change RoCE enablement state, a user must change the driverinit cmode value
+and run devlink reload.
 
 User command examples:
 
-- 
2.39.1

