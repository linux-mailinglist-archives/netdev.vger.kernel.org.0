Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF3F3AE3B2
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFUHIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFUHIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 03:08:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4945E6115A;
        Mon, 21 Jun 2021 07:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624259180;
        bh=eiMJ/pkxwY9j6+Zhmr7tL1TiplN0jzJFxPuuTyDavgE=;
        h=From:To:Cc:Subject:Date:From;
        b=kM5voF831UzjN236ydBeQ1LNAf3u9mSPFPdL4qHu0XeyEfjEu/1E9eU7+wg+ajBYw
         LUsZCXwxkIe1cInzbFpU5/CPQOjHrYTJQGHvPR1T8qQLvvp/Mz9s4Ks/B0a0vm1l/8
         BCJ0PDTwlOwNN73vby/MO/Z2kGTTdyhAyGWv9CFPUqKP2DozaIFwRq55NvpJM8qsvH
         fivkJ+8Xt3Q5T8sbg7R9iJZjb5Pv0bFP1z96UPx3/Gdlr3PIfOcEVKkDbXwsvmo2fK
         ZLkfy7V//QvLOm6ZPiGNJqfQMqWyvj7uVu6a2UQ9K4NlMMUcULMnfIO2tu8u7gH+3T
         /YroVCOQ6msZg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 0/3] Add ConnectX DCS offload support
Date:   Mon, 21 Jun 2021 10:06:13 +0300
Message-Id: <cover.1624258894.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Rephrase commit message of second patch
v0: https://lore.kernel.org/linux-rdma/cover.1622723815.git.leonro@nvidia.com

------------

This patchset from Lior adds support of DCI stream channel (DCS) support.

DCS is an offload to SW load balancing of DC initiator work requests.

A single DC QP initiator (DCI) can be connected to only one target at the time
and can't start new connection until the previous work request is completed.

This limitation causes to delays when the initiator process needs to
transfer data to multiple targets at the same time.

Thanks

Lior Nahmanson (3):
  net/mlx5: Add DCS caps & fields support
  RDMA/mlx5: Separate DCI QP creation logic
  RDMA/mlx5: Add DCS offload support

 drivers/infiniband/hw/mlx5/main.c |  10 ++
 drivers/infiniband/hw/mlx5/qp.c   | 168 ++++++++++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h     |  14 ++-
 include/uapi/rdma/mlx5-abi.h      |  17 ++-
 4 files changed, 204 insertions(+), 5 deletions(-)

-- 
2.31.1

