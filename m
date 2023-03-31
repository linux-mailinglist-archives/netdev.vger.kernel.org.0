Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20296D1AEB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjCaI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjCaI5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:57:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D13910E7;
        Fri, 31 Mar 2023 01:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F57B82D6D;
        Fri, 31 Mar 2023 08:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABB1C433D2;
        Fri, 31 Mar 2023 08:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680253028;
        bh=uIJIxQuv/Gb7pO/vxDBm4QwOZ3l/iJ1p1YbIJCIbmDc=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=QvuosjGkRXQEJapQzDKELHQhqg4xBtleJI+nvc1ZXdDgaXnpARYUD+Xq1+c65WME/
         HK7OkCdGWU2ngzb+kKP8ReGCeHocAx2jODrovtRAAjHkEwdsRxbdpMNEb1NnUdNP4P
         Rtqae8CdYhFsJ3gkSIvijmNH/MAgIkdqH2qkdWv15LK3dCCeQCYlx+TeWHGWDWBUzc
         uRf/iWQVZS+iVSt4O7roqOYXc6aXipTyw/FSHjClb1EPLjZ0mTMFtH/uz1eDToWh9r
         rn0BqrHAkFtxbNqrxIJtgm9GfRodWxQzoTI790GERsxYLCInPe8T0erTlc1xT8k7Lq
         uSGxOG7EndRcA==
From:   Simon Horman <horms@kernel.org>
Date:   Fri, 31 Mar 2023 10:56:55 +0200
Subject: [PATCH vhost 1/3] vdpa: address kdoc warnings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-vhost-fixes-v1-1-1f046e735b9e@kernel.org>
References: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
In-Reply-To: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses the following minor kdoc problems.

* Incorrect spelling of 'callback' and 'notification'
* Unrecognised kdoc format for 'struct vdpa_map_file'
* Missing documentation of 'get_vendor_vq_stats' member of
  'struct vdpa_config_ops'
* Missing documentation of 'max_supported_vqs' and 'supported_features'
  members of 'struct vdpa_mgmt_dev'

Most of these problems were flagged by:

 $ ./scripts/kernel-doc -Werror -none  include/linux/vdpa.h
 include/linux/vdpa.h:20: warning: expecting prototype for struct vdpa_calllback. Prototype was for struct vdpa_callback instead
 include/linux/vdpa.h:117: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
  * Corresponding file area for device memory mapping
 include/linux/vdpa.h:357: warning: Function parameter or member 'get_vendor_vq_stats' not described in 'vdpa_config_ops'
 include/linux/vdpa.h:518: warning: Function parameter or member 'supported_features' not described in 'vdpa_mgmt_dev'
 include/linux/vdpa.h:518: warning: Function parameter or member 'max_supported_vqs' not described in 'vdpa_mgmt_dev'

The misspelling of 'notification' was flagged by:
 $ ./scripts/checkpatch.pl --codespell --showfile --strict -f include/linux/vdpa.h
 include/linux/vdpa.h:171: CHECK: 'notifcation' may be misspelled - perhaps 'notification'?
 ...

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/linux/vdpa.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 43f59ef10cc9..010321945997 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -10,7 +10,7 @@
 #include <linux/if_ether.h>
 
 /**
- * struct vdpa_calllback - vDPA callback definition.
+ * struct vdpa_callback - vDPA callback definition.
  * @callback: interrupt callback function
  * @private: the data passed to the callback function
  */
@@ -114,7 +114,7 @@ struct vdpa_dev_set_config {
 };
 
 /**
- * Corresponding file area for device memory mapping
+ * struct vdpa_map_file - file area for device memory mapping
  * @file: vma->vm_file for the mapping
  * @offset: mapping offset in the vm_file
  */
@@ -165,10 +165,16 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				@state: pointer to returned state (last_avail_idx)
+ * @get_vendor_vq_stats:	Get the vendor statistics of a device.
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				@msg: socket buffer holding stats message
+ *				@extack: extack for reporting error messages
+ *				Returns integer: success (0) or error (< 0)
  * @get_vq_notification:	Get the notification area for a virtqueue (optional)
  *				@vdev: vdpa device
  *				@idx: virtqueue index
- *				Returns the notifcation area
+ *				Returns the notification area
  * @get_vq_irq:			Get the irq number of a virtqueue (optional,
  *				but must implemented if require vq irq offloading)
  *				@vdev: vdpa device
@@ -506,6 +512,8 @@ struct vdpa_mgmtdev_ops {
  * @config_attr_mask: bit mask of attributes of type enum vdpa_attr that
  *		      management device support during dev_add callback
  * @list: list entry
+ * @supported_features: features supported by device
+ * @max_supported_vqs: maximum number of virtqueues supported by device
  */
 struct vdpa_mgmt_dev {
 	struct device *device;

-- 
2.30.2

