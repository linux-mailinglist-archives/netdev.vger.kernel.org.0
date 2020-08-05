Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B0E23D21C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgHEUJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:09:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:6730 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbgHEQce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:32:34 -0400
IronPort-SDR: jUYgZT5wOinZiVWNnUH5zLCtcgkqC9zo5HWVa7TwAX9VjTeHOmCpgPxv5oE4ZiN6EnMPqTtoTB
 l5+hiYhLViSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="214047223"
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="214047223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 04:41:48 -0700
IronPort-SDR: voInwl4vfbYWzZUXFHCdXSR5TLohsgoXijCOnbprW6erlSv+R5na1gMwKuobZESQFIQPx/W9hx
 4A4Yz0c4RE9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="467437398"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 05 Aug 2020 04:41:45 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/2] vDPA: get_vq_irq() should be optional
Date:   Wed,  5 Aug 2020 19:37:59 +0800
Message-Id: <20200805113759.3591-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_vq_irq() should be optional, it's required when
we need to setup irq offloading, otherwise it‘s OK to be NULL.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 include/linux/vdpa.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 03aa9f77f192..56c6a03db43b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -87,7 +87,8 @@ struct vdpa_device {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
- * @get_vq_irq:			Get the irq number of a virtqueue
+ * @get_vq_irq:			Get the irq number of a virtqueue (optional,
+ *				but must implemented if require vq irq offloading)
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns int: irq number of a virtqueue,
-- 
2.18.4

