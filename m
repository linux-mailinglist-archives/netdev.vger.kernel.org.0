Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F25BB74
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 14:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfGAM1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 08:27:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52130 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbfGAM1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 08:27:46 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Jul 2019 15:27:42 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x61CRerv003688;
        Mon, 1 Jul 2019 15:27:41 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 0/3] devlink: Introduce PCI PF, VF ports and attributes
Date:   Mon,  1 Jul 2019 07:27:31 -0500
Message-Id: <20190701122734.18770-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset carry forwards the work initiated in [1] and discussion
futher concluded at [2].

To improve visibility of representor netdevice, its association with
PF or VF, physical port, two new devlink port flavours are added as
PCI PF and PCI VF ports.

A sample eswitch view can be seen below, which will be futher extended to
mdev subdevices of a PCI function in future.

Patch-1,2 extends devlink port attributes and port flavour.
Patch-3 extends mlx5 driver to register devlink ports for PF, VF and
physical link.

                                +---+      +---+
                              vf|   |      |   | pf
                                +-+-+      +-+-+
physical link <---------+         |          |
                        |         |          |
                        |         |          |
                      +-+-+     +-+-+      +-+-+
                      | 1 |     | 2 |      | 3 |
                   +--+---+-----+---+------+---+--+
                   |  physical   vf         pf    |
                   |  port       port       port  |
                   |                              |
                   |             eswitch          |
                   |                              |
                   +------------------------------+

[1] https://www.spinics.net/lists/netdev/msg555797.html
[2] https://marc.info/?l=linux-netdev&m=155354609408485&w=2

Parav Pandit (3):
  devlink: Introduce PCI PF port flavour and port attribute
  devlink: Introduce PCI VF port flavour and port attribute
  net/mlx5e: Register devlink ports for physical link, PCI PF, VFs

 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 108 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 include/net/devlink.h                         |  22 ++++
 include/uapi/linux/devlink.h                  |  11 ++
 net/core/devlink.c                            | 107 ++++++++++++++---
 5 files changed, 204 insertions(+), 45 deletions(-)

-- 
2.19.2

