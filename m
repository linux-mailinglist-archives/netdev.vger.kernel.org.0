Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090DC3D88E0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhG1Hdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232691AbhG1Hdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84AF160E78;
        Wed, 28 Jul 2021 07:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627457633;
        bh=uPbyNLfxnXmaIsbtu2itws9HGIbGQSrwkqk6xBg1Jg4=;
        h=From:To:Cc:Subject:Date:From;
        b=F+hgG7ovLHHL0hA3yzdh4NPImlcoHeVC04Wgqku3O7gKZubi/6oDC6H6DcUyajUzn
         qWjlsqcXzdLHqSlSCd1KBSZt2jNM/r8LlQtnjzCckVo0hy2HoxMiac/0OZz2+xugUK
         mTEmzCgm5E+v2euTMYAlSLL+XgCbI2sS3eNHSvkt9IZB+1HYuiVqM8o8LOucAvUW9V
         Xwrc091w1Ae3whc/emnCzWZKPthy6GaE8F5Ft9XuGyOmFN7i7hN6yQOBl9cewHoFqH
         K1ph+48Pzt5ZcZShQ5hFTuG+/tXJM4j6IJqcXxcrRa/F8478FMmrip97rs38JtWspJ
         QZJbheVn4TajQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH net-next v1 0/3] Remove duplicated devlink registration check
Date:   Wed, 28 Jul 2021 10:33:44 +0300
Message-Id: <cover.1627456849.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Added two new patches that remove registration field from mlx5 and ti drivers.
v0: https://lore.kernel.org/lkml/ed7bbb1e4c51dd58e6035a058e93d16f883b09ce.1627215829.git.leonro@nvidia.com

--------------------------------------------------------------------

Both registered flag and devlink pointer are set at the same time
and indicate the same thing - devlink/devlink_port are ready. Instead
of checking ->registered use devlink pointer as an indication.

Thanks

Leon Romanovsky (3):
  net: ti: am65-cpsw-nuss: fix wrong devlink release order
  net/mlx5: Don't rely on always true registered field
  devlink: Remove duplicated registration check

 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 10 ++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      | 34 +++++++++----------
 include/net/devlink.h                         |  4 +--
 net/core/devlink.c                            | 19 ++++++-----
 5 files changed, 33 insertions(+), 45 deletions(-)

-- 
2.31.1

