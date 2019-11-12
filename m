Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9AF8F42
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfKLMIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:10 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58215 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbfKLMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACC87sG029717;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xACC87rS004236;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xACC85e2004235;
        Tue, 12 Nov 2019 14:08:05 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next 0/4] Update devlink binary output
Date:   Tue, 12 Nov 2019 14:07:48 +0200
Message-Id: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series changes the devlink binary interface:
-The first patch forces binary values to be enclosed in an array. In
 addition, devlink_fmsg_binary_pair_put breaks the binary value into
 chunks to comply with devlink's restriction for value length.
-The second patch removes redundant code and uses the fixed devlink
 interface (devlink_fmsg_binary_pair_put).
-The third patch make self test to use the updated devlink
 interface.
-The fourth, adds a verification of dumping a very large binary
 content. This test verifies breaking the data into chunks in a valid
 JSON output.

Series was generated against net-next commit:
ca22d6977b9b Merge branch 'stmmac-next'

Regards,
Aya

Aya Levin (4):
  devlink: Allow large formatted message of binary output
  net/mlx5: Dump of fw_fatal use updated devlink binary interface
  netdevsim: Update dummy reporter's devlink binary interface
  selftests: Add a test of large binary to devlink health test

 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 18 +---------------
 drivers/net/netdevsim/health.c                     |  8 +-------
 include/net/devlink.h                              |  4 +---
 net/core/devlink.c                                 | 24 ++++++++++++++--------
 .../selftests/drivers/net/netdevsim/devlink.sh     |  9 ++++++++
 5 files changed, 27 insertions(+), 36 deletions(-)

-- 
2.14.1

