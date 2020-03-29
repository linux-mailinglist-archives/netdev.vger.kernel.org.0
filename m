Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD7196CCA
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgC2LGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:06:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51310 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727965AbgC2LGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:06:01 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Mar 2020 14:05:58 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02TB5wV7006555;
        Sun, 29 Mar 2020 14:05:58 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next v2 0/3] Devlink health auto attributes refactor
Date:   Sun, 29 Mar 2020 14:05:52 +0300
Message-Id: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactors the auto-recover health reporter flag to be
explicitly set by the devlink core.
In addition, add another flag to control auto-dump attribute, also
to be explicitly set by the devlink core.

For that, patch 0001 changes the auto-recover default value of 
netdevsim dummy reporter.

After reporter registration, both flags can be altered be administrator
only.

Changes since v1:
- Change default behaviour of netdevsim dummy reporter
- Move initialization of DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP 

Eran Ben Elisha (3):
  netdevsim: Change dummy reporter auto recover default
  devlink: Implicitly set auto recover flag when registering health
    reporter
  devlink: Add auto dump flag to health reporter

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  6 ++--
 .../mellanox/mlx5/core/en/reporter_rx.c       |  2 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  4 +--
 drivers/net/netdevsim/health.c                |  4 +--
 include/net/devlink.h                         |  3 +-
 include/uapi/linux/devlink.h                  |  2 ++
 net/core/devlink.c                            | 35 +++++++++++++------
 .../drivers/net/netdevsim/devlink.sh          |  5 +++
 9 files changed, 42 insertions(+), 21 deletions(-)

-- 
2.17.1

