Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421CE440456
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJ2UuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:50:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:9536 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231203AbhJ2Utu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587518"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587518"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483301"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 5/7] virtchnl: Use the BIT() macro for capability/offload flags
Date:   Fri, 29 Oct 2021 13:45:38 -0700
Message-Id: <20211029204540.3390007-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently raw hex values are used to define specific bits for each
capability/offload in virtchnl.h. Using raw hex values makes it
unclear which bits are used/available. Fix this by using the BIT()
macro so it's immediately obvious which bits are used/available.

Also, move the VIRTCHNL_VF_CAP_ADV_LINK_SPEED define in the correct
place to line up with the other bit values and add a comment for its
purpose.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 2e1e1379b569..b30a1bc74fc7 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -238,26 +238,26 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
  * VIRTCHNL_VF_OFFLOAD_L2 flag is inclusive of base mode L2 offloads including
  * TX/RX Checksum offloading and TSO for non-tunnelled packets.
  */
-#define VIRTCHNL_VF_OFFLOAD_L2			0x00000001
-#define VIRTCHNL_VF_OFFLOAD_IWARP		0x00000002
-#define VIRTCHNL_VF_OFFLOAD_RSS_AQ		0x00000008
-#define VIRTCHNL_VF_OFFLOAD_RSS_REG		0x00000010
-#define VIRTCHNL_VF_OFFLOAD_WB_ON_ITR		0x00000020
-#define VIRTCHNL_VF_OFFLOAD_REQ_QUEUES		0x00000040
-#define VIRTCHNL_VF_OFFLOAD_VLAN		0x00010000
-#define VIRTCHNL_VF_OFFLOAD_RX_POLLING		0x00020000
-#define VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2	0x00040000
-#define VIRTCHNL_VF_OFFLOAD_RSS_PF		0X00080000
-#define VIRTCHNL_VF_OFFLOAD_ENCAP		0X00100000
-#define VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM		0X00200000
-#define VIRTCHNL_VF_OFFLOAD_RX_ENCAP_CSUM	0X00400000
-#define VIRTCHNL_VF_OFFLOAD_ADQ			0X00800000
-#define VIRTCHNL_VF_OFFLOAD_USO			0X02000000
-#define VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF		0X08000000
-#define VIRTCHNL_VF_OFFLOAD_FDIR_PF		0X10000000
-
-/* Define below the capability flags that are not offloads */
-#define VIRTCHNL_VF_CAP_ADV_LINK_SPEED		0x00000080
+#define VIRTCHNL_VF_OFFLOAD_L2			BIT(0)
+#define VIRTCHNL_VF_OFFLOAD_IWARP		BIT(1)
+#define VIRTCHNL_VF_OFFLOAD_RSS_AQ		BIT(3)
+#define VIRTCHNL_VF_OFFLOAD_RSS_REG		BIT(4)
+#define VIRTCHNL_VF_OFFLOAD_WB_ON_ITR		BIT(5)
+#define VIRTCHNL_VF_OFFLOAD_REQ_QUEUES		BIT(6)
+/* used to negotiate communicating link speeds in Mbps */
+#define VIRTCHNL_VF_CAP_ADV_LINK_SPEED		BIT(7)
+#define VIRTCHNL_VF_OFFLOAD_VLAN		BIT(16)
+#define VIRTCHNL_VF_OFFLOAD_RX_POLLING		BIT(17)
+#define VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2	BIT(18)
+#define VIRTCHNL_VF_OFFLOAD_RSS_PF		BIT(19)
+#define VIRTCHNL_VF_OFFLOAD_ENCAP		BIT(20)
+#define VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM		BIT(21)
+#define VIRTCHNL_VF_OFFLOAD_RX_ENCAP_CSUM	BIT(22)
+#define VIRTCHNL_VF_OFFLOAD_ADQ			BIT(23)
+#define VIRTCHNL_VF_OFFLOAD_USO			BIT(25)
+#define VIRTCHNL_VF_OFFLOAD_ADV_RSS_PF		BIT(27)
+#define VIRTCHNL_VF_OFFLOAD_FDIR_PF		BIT(28)
+
 #define VF_BASE_MODE_OFFLOADS (VIRTCHNL_VF_OFFLOAD_L2 | \
 			       VIRTCHNL_VF_OFFLOAD_VLAN | \
 			       VIRTCHNL_VF_OFFLOAD_RSS_PF)
-- 
2.31.1

