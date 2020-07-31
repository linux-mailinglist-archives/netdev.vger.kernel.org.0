Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A8233F94
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbgGaG7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:59:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:18704 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731543AbgGaG7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:59:48 -0400
IronPort-SDR: 0Zghag5NsRC5km8ULH2ylju8rmplFaaNODoquugr5oLhANaYCa7qewKGrgm3H0jWxNxtugVOxg
 JDO5ctk3DzFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="152949295"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="152949295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 23:59:48 -0700
IronPort-SDR: TT3bTrJrO5mUVQB5IMlPYH4DcQcv556DPBE61Ec3E7zOyAoPThXuvW9ljU4lzNP/QkTzzm5HV+
 UsCs9VCrtNSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="273136586"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2020 23:59:44 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 3/6] vDPA: add get_vq_irq() in vdpa_config_ops
Date:   Fri, 31 Jul 2020 14:55:30 +0800
Message-Id: <20200731065533.4144-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200731065533.4144-1-lingshan.zhu@intel.com>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new function get_vq_irq() in struct
vdpa_config_ops, which will return the irq number of a
virtqueue.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 239db794357c..ba898486f2c7 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -87,6 +87,11 @@ struct vdpa_device {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
+ * @get_vq_irq:			Get the irq number of a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns int: irq number of a virtqueue,
+ *				negative number if no irq assigned.
  * @get_vq_align:		Get the virtqueue align requirement
  *				for the device
  *				@vdev: vdpa device
@@ -178,6 +183,7 @@ struct vdpa_config_ops {
 	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
 	struct vdpa_notification_area
 	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
+	int (*get_vq_irq)(struct vdpa_device *vdv, u16 idx);
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
-- 
2.18.4

