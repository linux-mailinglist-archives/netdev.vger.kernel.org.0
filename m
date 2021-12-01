Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCB546568E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbhLATkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbhLATkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:40:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E081CC061574;
        Wed,  1 Dec 2021 11:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB631CE204E;
        Wed,  1 Dec 2021 19:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3630EC53FAD;
        Wed,  1 Dec 2021 19:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638387409;
        bh=/ZNJpy8N0/5g3m3yGWYWipoLWcbIcuraQY0GRnBDbyw=;
        h=From:To:Cc:Subject:Date:From;
        b=VbjjadqACI7f701nHcZ9xLK2WhyDc9JSMK73cekMp2v2ZUpJHxn5yvZU3yjUBhCGd
         C6ucha9JZBKA9HEu5R5GNe7AMZHg0hwNdsUQBO+v9OkXOc0BoiDE0/te/InDNxnLtr
         k4dG1OII4M7g9Z9pOwRh+N9pydLxvsBMbRRRNqPNYm1C/s4XYqABlxLOJ6Tm3fvNSd
         vg8IEFUreanTZVxlBOWkdEB6tJjbBfKxlj2Iz3yxn5Le617YOnsQCOnykaWCnU666O
         mlayXF/6Ge4cvm+uxkbOf5AgjfAbSPB8ljR9OoHB3kOSY17qZm0Jb34A8fG7bkeqIP
         mv19eEdoGNlOA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/4] Add support to multiple RDMA priorities for FDB rules
Date:   Wed,  1 Dec 2021 11:36:17 -0800
Message-Id: <20211201193621.9129-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Currently, the driver ignores the user's priority for flow steering
rules in FDB namespace. Change it and create the rule in the right
priority.

It will allow to create FDB steering rules in up to 16 different
priorities.

Maor Gottlieb (4):
  net/mlx5: Separate FDB namespace
  net/mlx5: Refactor mlx5_get_flow_namespace
  net/mlx5: Create more priorities for FDB bypass namespace
  RDMA/mlx5: Add support to multiple priorities for FDB rules

 drivers/infiniband/hw/mlx5/fs.c               | 18 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 76 +++++++++++++++----
 include/linux/mlx5/fs.h                       |  1 +
 5 files changed, 75 insertions(+), 27 deletions(-)

--
2.31.1
