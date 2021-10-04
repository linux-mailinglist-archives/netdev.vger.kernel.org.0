Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F027C421717
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbhJDTQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237863AbhJDTQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD486124C;
        Mon,  4 Oct 2021 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374896;
        bh=MmnkQnn2m4W5RZbjtHHI4Ix+O1u/p1qweQweYdQM8VQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jT3/omT1cwFNwipY+poNBKv2u6eB5/5AjEtnHVsMg8eyYT8ue6cEYaI2FsXqnzU2R
         z/Gqb3cU5cGpbOSmvIFCZW/RLsESRRZ9fs7OFr4qclzDDA6kJx7HBQ+2i8FYqthCZl
         fGzr5grO+ocUeBM7/ZlJWhEhsWXWf8Af7rLdmg7IqCU2f0Mfo7ls+KzTXkgnS9GELr
         9EJRD0OUHeGchOVI8offFD4Uz3apMY2lbxR2uZ5u1dVzIjQZAmI7J1i2Dze47e6xls
         VJgWsmutFIOqm3JRIXfS+8xQbNQnYk8wo/iE62SPKscJt9/N5GyC8QLqI4HmBlFnFY
         crBio+HM5vU3Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] mlx4: prep for constant dev->dev_addr
Date:   Mon,  4 Oct 2021 12:14:42 -0700
Message-Id: <20211004191446.2127522-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts mlx4 for dev->dev_addr being const. It converts
to use of common helpers but also removes some seemingly unnecessary
idiosyncrasies.

Please review.

Jakub Kicinski (4):
  mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
  mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
  mlx4: remove custom dev_addr clearing
  mlx4: constify args for const dev_addr

 drivers/infiniband/hw/mlx4/main.c             |  2 +-
 drivers/infiniband/hw/mlx4/qp.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c      |  4 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 37 +++++++------------
 drivers/net/ethernet/mellanox/mlx4/fw.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c      |  2 +-
 include/linux/mlx4/device.h                   |  2 +-
 include/linux/mlx4/driver.h                   | 22 -----------
 8 files changed, 21 insertions(+), 52 deletions(-)

-- 
2.31.1

