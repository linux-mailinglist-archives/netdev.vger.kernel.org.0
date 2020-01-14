Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE06013AE14
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgANPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:55:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41678 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726450AbgANPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:55:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00EFtiIe015197;
        Tue, 14 Jan 2020 17:55:44 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00EFtitB019698;
        Tue, 14 Jan 2020 17:55:44 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00EFti44019696;
        Tue, 14 Jan 2020 17:55:44 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 0/3] Add mlx5 devices FW upgrade reset support
Date:   Tue, 14 Jan 2020 17:55:25 +0200
Message-Id: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for FW upgrade.
On devlink reload, if a pending FW image is found, the driver will perform
a FW upgrade reset flow to activate the pending FW image.

Sending as RFC because the FW activation reset requires a pci link
toggling. Although it works and we verify that the device is the only
device on the pcie bridge before allowing such reset, as already done by
other drivers [1], we would like to get some feedback on the last patch
of this series.

[1] function trigger_sbr() at drivers/infiniband/hw/hfi1/pcie.c

Moshe Shemesh (3):
  net/mlx5: Add structure layout and defines for MFRL register
  net/mlx5: Add functions to set/query MFRL register
  net/mlx5: Add FW upgrade reset support

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 81 +++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       | 44 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/mlx5/mlx5_ifc.h                      | 17 +++++
 5 files changed, 144 insertions(+), 1 deletion(-)

-- 
1.8.3.1

