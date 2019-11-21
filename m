Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8C1105335
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUNgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 08:36:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:28493 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfKUNgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 08:36:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 05:36:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="238178517"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga002.fm.intel.com with ESMTP; 21 Nov 2019 05:36:50 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V1 0/2] Intel IFC VF driver for VDPA
Date:   Thu, 21 Nov 2019 21:34:35 +0800
Message-Id: <1574343277-8835-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series intends to implement driver module for Intel IFC VF NIC,
which can do Vhost Data Plane Acceleration(VDPA) by offloading
dataplane traffic to hardware.

This series depends on and complies to:
virtio_mdev V13 https://lkml.org/lkml/2019/11/18/261
vhost_mdev V7 https://lkml.org/lkml/2019/11/18/1068

There comes mainly two parts of the code:
(1) ifcvf_main layer handles probe / remove / mdev operations,
implemented struct mdev_virtio_ops to support virtio_mdev
and vhost_mdev, and other supportive functions.

(2) ifcvf_base layer talks directly to the hardware, which support
the ifcvf_main layer.


Zhu Lingshan (2):
  IFC VF initialization functions
  This commit adds functions to support virtio_mdev and vhost_mdev

 drivers/vhost/Kconfig            |  12 +
 drivers/vhost/Makefile           |   3 +-
 drivers/vhost/ifcvf/Makefile     |   2 +
 drivers/vhost/ifcvf/ifcvf_base.c | 328 +++++++++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_base.h | 126 +++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 557 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 1027 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vhost/ifcvf/Makefile
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c

-- 
1.8.3.1

