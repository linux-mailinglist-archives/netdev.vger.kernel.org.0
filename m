Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A33567BE33
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbjAYVYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbjAYVYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:24:38 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB05245BC1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674681877; x=1706217877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4LysYDy5WwgLWIIXH3A0OHy8oNE2vNwiJd1RUouVVok=;
  b=PW3I7m4btCUU+sjK4mIUhaPnS+uyCQ+sv67pYJHeBZHKXO3j3RJezDxW
   lyRc3rHCWc0FkVmpv+PMab+NLThDC7ob9vUdrlaZJfv1omk4jr8oWFkxU
   IW35jtKdkkUwlkP8tw9UyM1rS8ATN6Rane2n0GOwqsPxFAyYGPoug4iR+
   vtfA+0jBrURJn5mCHXzzUA6oZx8DaUA9hsBYhc6sIvGUpXkAxDWdZXzwK
   t2msb5GtInHaVWBiiY6znM8O/gLDDjMP5z8YtS4lvXtSfEMFNHRj7l4UR
   7poZDxmmREEaULkwYxvccniI4eT7Wj3T/UTYZzbobQTaDBgp4CCFka5eI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="328767492"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="328767492"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 13:24:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="770894108"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="770894108"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jan 2023 13:24:35 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 2/4] virtchnl: update header and increase header clarity
Date:   Wed, 25 Jan 2023 13:24:39 -0800
Message-Id: <20230125212441.4030014-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
References: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

We already have the SPDX header, so just leave a copyright notice with
an updated year and get rid of the boilerplate header (so 2002!).

In addition, update a couple of comments to clarify how the various
parts of the virtchannel header interaction work.

No functional changes.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index b1cfa84904b1..2e685aa37688 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -1,21 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*******************************************************************************
- *
- * Intel Ethernet Controller XL710 Family Linux Virtual Function Driver
- * Copyright(c) 2013 - 2014 Intel Corporation.
- *
- * Contact Information:
- * e1000-devel Mailing List <e1000-devel@lists.sourceforge.net>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- ******************************************************************************/
+/* Copyright (c) 2013-2022, Intel Corporation. */
 
 #ifndef _VIRTCHNL_H_
 #define _VIRTCHNL_H_
 
 /* Description:
- * This header file describes the VF-PF communication protocol used
- * by the drivers for all devices starting from our 40G product line
+ * This header file describes the Virtual Function (VF) - Physical Function
+ * (PF) communication protocol used by the drivers for all devices starting
+ * from our 40G product line
  *
  * Admin queue buffer usage:
  * desc->opcode is always aqc_opc_send_msg_to_pf
@@ -29,8 +21,8 @@
  * have a maximum of sixteen queues for all of its VSIs.
  *
  * The PF is required to return a status code in v_retval for all messages
- * except RESET_VF, which does not require any response. The return value
- * is of status_code type, defined in the shared type.h.
+ * except RESET_VF, which does not require any response. The returned value
+ * is of virtchnl_status_code type, defined here.
  *
  * In general, VF driver initialization should roughly follow the order of
  * these opcodes. The VF driver must first validate the API version of the
@@ -323,6 +315,9 @@ VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_rxq_info);
  * PF configures queues and returns status.
  * If the number of queues specified is greater than the number of queues
  * associated with the VSI, an error is returned and no queues are configured.
+ * NOTE: The VF is not required to configure all queues in a single request.
+ * It may send multiple messages. PF drivers must correctly handle all VF
+ * requests.
  */
 struct virtchnl_queue_pair_info {
 	/* NOTE: vsi_id and queue_id should be identical for both queues. */
@@ -360,8 +355,13 @@ struct virtchnl_vf_res_request {
  * VF uses this message to map vectors to queues.
  * The rxq_map and txq_map fields are bitmaps used to indicate which queues
  * are to be associated with the specified vector.
- * The "other" causes are always mapped to vector 0.
+ * The "other" causes are always mapped to vector 0. The VF may not request
+ * that vector 0 be used for traffic.
  * PF configures interrupt mapping and returns status.
+ * NOTE: due to hardware requirements, all active queues (both TX and RX)
+ * should be mapped to interrupts, even if the driver intends to operate
+ * only in polling mode. In this case the interrupt may be disabled, but
+ * the ITR timer will still run to trigger writebacks.
  */
 struct virtchnl_vector_map {
 	u16 vsi_id;
@@ -388,6 +388,9 @@ VIRTCHNL_CHECK_STRUCT_LEN(14, virtchnl_irq_map_info);
  * (Currently, we only support 16 queues per VF, but we make the field
  * u32 to allow for expansion.)
  * PF performs requested action and returns status.
+ * NOTE: The VF is not required to enable/disable all queues in a single
+ * request. It may send multiple messages.
+ * PF drivers must correctly handle all VF requests.
  */
 struct virtchnl_queue_select {
 	u16 vsi_id;
-- 
2.38.1

