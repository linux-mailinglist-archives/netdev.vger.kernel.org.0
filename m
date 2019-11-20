Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 083A610367B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbfKTJT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 04:19:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:61597 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfKTJT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 04:19:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 01:19:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,221,1571727600"; 
   d="scan'208";a="237660905"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga002.fm.intel.com with ESMTP; 20 Nov 2019 01:19:24 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC V4 0/2] Intel IFC VF driver for VDPA
Date:   Wed, 20 Nov 2019 17:17:09 +0800
Message-Id: <1574241431-24792-1-git-send-email-lingshan.zhu@intel.com>
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
virtio_mdev V13 https://lkml.org/lkml/2019/11/18/261
vhost_mdev V7 https://lkml.org/lkml/2019/11/18/1068

This patchset passed netperf tests.

This is RFC V4, plese help review. I will split them into small patches
once got reviewed.

Changes from V3:
Adapt to Jason Wang's virtio_mdev V13 patchset.
minor improvements

Changes from V2:
removed some unnecessary code.
using a struct ifcvf_lm_cfg to address hw->lm_cfg and operations on it.
set CONFIG_S_FAILED  when ifcvf_start_hw() fail.
removed VIRTIO_NET_F_CTRL_VQ and VIRTIO_NET_F_STATUS
replace ifcvf_net_config with virtio_net_config.
minor changes

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
  This commit introduced ifcvf_base layer.
  This commit introduced IFC operations for vdpa

 drivers/vhost/ifcvf/ifcvf_base.c | 326 ++++++++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_base.h | 129 +++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 582 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1037 insertions(+)
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c

-- 
1.8.3.1

