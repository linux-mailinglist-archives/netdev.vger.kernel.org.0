Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F85380B8A
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhENOSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:18:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:53036 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhENOSJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:18:09 -0400
IronPort-SDR: 5mPjetqVc47jCBi8MP8IiJu9J3Cqh0PPKIqFec0wSRoH+8xvVxroKupejlVfDRcR+MsZ5AV4qU
 3DYVRHKIhmKw==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199872564"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199872564"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:27 -0700
IronPort-SDR: 9Dbt39rUhut0RnhGspuugQMLndcU/nuFJSSybMRKSgfcqOyH5+aV6TvwnC1xapwaKFoyN0VuMB
 cuLbMYk+4gPg==
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="542867792"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.97.94])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:26 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v5 20/22] RDMA/irdma: Add ABI definitions
Date:   Fri, 14 May 2021 09:12:12 -0500
Message-Id: <20210514141214.2120-21-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210514141214.2120-1-shiraz.saleem@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail@intel.com>

Add ABI definitions for irdma.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 include/uapi/rdma/irdma-abi.h | 111 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)
 create mode 100644 include/uapi/rdma/irdma-abi.h

diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
new file mode 100644
index 0000000..26b638a
--- /dev/null
+++ b/include/uapi/rdma/irdma-abi.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR Linux-OpenIB) */
+/*
+ * Copyright (c) 2006 - 2021 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
+ */
+
+#ifndef IRDMA_ABI_H
+#define IRDMA_ABI_H
+
+#include <linux/types.h>
+
+/* irdma must support legacy GEN_1 i40iw kernel
+ * and user-space whose last ABI ver is 5
+ */
+#define IRDMA_ABI_VER 5
+
+enum irdma_memreg_type {
+	IRDMA_MEMREG_TYPE_MEM  = 0,
+	IRDMA_MEMREG_TYPE_QP   = 1,
+	IRDMA_MEMREG_TYPE_CQ   = 2,
+};
+
+struct irdma_alloc_ucontext_req {
+	__u32 rsvd32;
+	__u8 userspace_ver;
+	__u8 rsvd8[3];
+};
+
+struct irdma_alloc_ucontext_resp {
+	__u32 max_pds;
+	__u32 max_qps;
+	__u32 wq_size; /* size of the WQs (SQ+RQ) in the mmaped area */
+	__u8 kernel_ver;
+	__u8 rsvd[3];
+	__aligned_u64 feature_flags;
+	__aligned_u64 db_mmap_key;
+	__u32 max_hw_wq_frags;
+	__u32 max_hw_read_sges;
+	__u32 max_hw_inline;
+	__u32 max_hw_rq_quanta;
+	__u32 max_hw_wq_quanta;
+	__u32 min_hw_cq_size;
+	__u32 max_hw_cq_size;
+	__u16 max_hw_sq_chunk;
+	__u8 hw_rev;
+	__u8 rsvd2;
+};
+
+struct irdma_alloc_pd_resp {
+	__u32 pd_id;
+	__u8 rsvd[4];
+};
+
+struct irdma_resize_cq_req {
+	__aligned_u64 user_cq_buffer;
+};
+
+struct irdma_create_cq_req {
+	__aligned_u64 user_cq_buf;
+	__aligned_u64 user_shadow_area;
+};
+
+struct irdma_create_qp_req {
+	__aligned_u64 user_wqe_bufs;
+	__aligned_u64 user_compl_ctx;
+};
+
+struct irdma_mem_reg_req {
+	__u16 reg_type; /* enum irdma_memreg_type */
+	__u16 cq_pages;
+	__u16 rq_pages;
+	__u16 sq_pages;
+};
+
+struct irdma_modify_qp_req {
+	__u8 sq_flush;
+	__u8 rq_flush;
+	__u8 rsvd[6];
+};
+
+struct irdma_create_cq_resp {
+	__u32 cq_id;
+	__u32 cq_size;
+};
+
+struct irdma_create_qp_resp {
+	__u32 qp_id;
+	__u32 actual_sq_size;
+	__u32 actual_rq_size;
+	__u32 irdma_drv_opt;
+	__u16 push_idx;
+	__u8 lsmm;
+	__u8 rsvd;
+	__u32 qp_caps;
+};
+
+struct irdma_modify_qp_resp {
+	__aligned_u64 push_wqe_mmap_key;
+	__aligned_u64 push_db_mmap_key;
+	__u16 push_offset;
+	__u8 push_valid;
+	__u8 rsvd[5];
+};
+
+struct irdma_create_ah_resp {
+	__u32 ah_id;
+	__u8 rsvd[4];
+};
+#endif /* IRDMA_ABI_H */
-- 
1.8.3.1

