Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E337EF9B3
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730935AbfKEJjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:39:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:24242 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730630AbfKEJjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 04:39:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 01:39:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,270,1569308400"; 
   d="scan'208";a="200323047"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga008.fm.intel.com with ESMTP; 05 Nov 2019 01:39:47 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] Intel IFC VF driver for VDPA
Date:   Tue,  5 Nov 2019 17:37:38 +0800
Message-Id: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:
  This series intends to introduce Intel IFC VF NIC driver for Vhost
Data Plane Acceleration(VDPA).
  
Here comes two main parts, one is ifcvf_base layer, which handles
hardware operations. The other is ifcvf_main layer handles VF
initialization, configuration and removal, which depends on
and complys to:
virtio_mdev https://lkml.org/lkml/2019/10/30/62 
vhost_mdev https://lkml.org/lkml/2019/10/31/440

This patchset passed netperf tests.

This is RFC V2, plese help review.

Changes from V1:
using le32_to_cpu() to convert PCI capabilities.
some set /get  operations will sync with the hardware, eg get_status
and get_generation.
remove feature bit VHOST_F_LOG_ALL, add VIRTIO_F_ORDERED_PLATFORM
add get/set_config functions.
split mdev type group into mdev_type_group_virtio and mdev_type_group_vhost
add ifcvf_mdev_get_mdev_features()
coding stype changes.

Zhu Lingshan (2):
  IFC hardware operation layer
  IFC VDPA layer

 drivers/vhost/ifcvf/ifcvf_base.c | 344 ++++++++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_base.h | 132 +++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 605 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1081 insertions(+)
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c

-- 
1.8.3.1

