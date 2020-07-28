Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247942300C2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgG1E2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:28:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:26202 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbgG1E2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:28:33 -0400
IronPort-SDR: L+1tEf0DcZ92fY7ospyCocbL3LIWY4qIbVg4l4pVmA7IdE2UnalmQBIXbPUpXOAXtdCNBe1qae
 X467zPR6DliQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="152403604"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="152403604"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 21:28:32 -0700
IronPort-SDR: WSSrI+D5yJvwClMGjMihjes/bflV6ORi2yyxBce/uCH5p24n9+R4kSki0vpn09ztAN0ovVDr2J
 gC/U6wO7+DdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="290037290"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 21:28:25 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 3/6] vDPA: add get_vq_irq() in vdpa_config_ops
Date:   Tue, 28 Jul 2020 12:24:02 +0800
Message-Id: <20200728042405.17579-4-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200728042405.17579-1-lingshan.zhu@intel.com>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
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
index 239db794357c..cebc79173aaa 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -87,6 +87,11 @@ struct vdpa_device {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
+ * @get_vq_irq:			Get the irq number of a virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u32: irq number of a virtqueue,
+ *				-EINVAL if no irq assigned.
  * @get_vq_align:		Get the virtqueue align requirement
  *				for the device
  *				@vdev: vdpa device
@@ -178,6 +183,7 @@ struct vdpa_config_ops {
 	u64 (*get_vq_state)(struct vdpa_device *vdev, u16 idx);
 	struct vdpa_notification_area
 	(*get_vq_notification)(struct vdpa_device *vdev, u16 idx);
+	u32 (*get_vq_irq)(struct vdpa_device *vdv, u16 idx);
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
-- 
2.18.4

