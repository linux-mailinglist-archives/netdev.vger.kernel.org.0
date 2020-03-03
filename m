Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5AA177882
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgCCONA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:13:00 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41645 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725932AbgCCONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:13:00 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:12:54 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023ECqq3022152;
        Tue, 3 Mar 2020 16:12:52 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH net-next 0/2] devlink: Introduce devlink port flavour virtual
Date:   Tue,  3 Mar 2020 08:12:41 -0600
Message-Id: <20200303141243.7608-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently PCI PF and VF devlink devices register their ports as
physical port in non-representors mode.

Introduce a new port flavour as virtual so that virtual devices can
register 'virtual' flavour to make it more clear to users.

An example of one PCI PF and 2 PCI virtual functions, each having
one devlink port.

$ devlink port show
pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0

Patch summary:
Patch-1 Introduces new devlink port flavour 'virtual'.
Patch-2 Uses new flavour to register PCI VF virtual ports.



Parav Pandit (2):
  devlink: Introduce devlink port flavour virtual
  net/mlx5e: Use devlink virtual flavour for VF devlink port

 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 39 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en/devlink.h  |  7 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 +--
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            |  2 +
 6 files changed, 33 insertions(+), 24 deletions(-)

-- 
2.19.2

