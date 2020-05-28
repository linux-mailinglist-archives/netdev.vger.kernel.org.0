Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EA01E6B8F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406709AbgE1TrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgE1TqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:06 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D7DC08C5C7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:04 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id v79so52947qkb.10
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nEoxBguK4qNWi3uR8EUH/hHTH5lHRdvmMpiHkRl66JU=;
        b=ezC+9NyOm57x6hRLyuz81sHZ8Hi59+1YbGn62g/+KOjos3x9/wM4U6KoRjnT8MRxPe
         jzYOFieR7z/3rsMnB6lRm2xcWo8MLMCOQnXO44Cg0tGMZm3KLzz2dRZXP0hyTgPVtgYN
         DsdcHcx7t0eL6EUSfQgp4/aMkCviuLKl+N7cLfGkaPL6R4MfRb95PrOY1QikcgASzwu2
         PxYWTIBkwg0hXFHNrNJiydz1vmfRW2dg53uvg5QBuwmUCRJjZYzowfV1mKpvRhd1ftf5
         ul0Vt5T779W34IfoY85fs9285C1ak80Ipq8+HYeogeBoO1Lb3dTx0sP5mAdPuZdF/tDw
         OaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nEoxBguK4qNWi3uR8EUH/hHTH5lHRdvmMpiHkRl66JU=;
        b=rTr/YhQ9FUVG53soVt2ItJs4BymrNDzFlRX0oF6kOgf0taxSX1EXJP155EXnooydJf
         X4w5DjOicUb8bJjLUIejSSjRdEB7zSfQdtx8c9c6MtMrQOuGJ4A6tiPtdWD4AZIN3+ci
         Ey73OOKj96qkB3wEFmoOAgAy73Mfrj6o+46HeLBn2GgkUueaV+x1LBKPYleiH/DWCgfS
         jv9I1eW9lvKNxAC6vErX0O8ma7lyNu7nrAxm2lz5k9yaPMBqu+2DwuhsAesgmsVba974
         J9tzYzgsRpFX8Fx4ez8K/YS94Kp4fBwqkBbUJ1MY2az+HqjxwjjSSZDGrr9gFGC7qreb
         LVyA==
X-Gm-Message-State: AOAM530i8iXRxYMh091kKwL7esG3Sd0hn2R9WLusVgHan+KHTmMUR1MJ
        AcAkO/Tg9GL5L4wwoBVX6oAW8A==
X-Google-Smtp-Source: ABdhPJxIcrPBFZci5pqH5pwoLSR3ryLDmVGLZYq9WZXmkY6uYTuQZLxQ2l3BpuWMlZyc43CjrawIQw==
X-Received: by 2002:a37:a18d:: with SMTP id k135mr4446009qke.155.1590695164173;
        Thu, 28 May 2020 12:46:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x205sm6071875qka.12.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006hJ-87; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Max Gurtovoy <maxg@mellanox.com>, oren@mellanox.com,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        shlomin@mellanox.com, Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        vladimirk@mellanox.com
Subject: [PATCH v3 06/13] RDMA/bnxt_re: Remove FMR leftovers
Date:   Thu, 28 May 2020 16:45:48 -0300
Message-Id: <6-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

The bnxt_re_fmr struct is never referenced and the max_fmr items
in bnxt_qplib_dev_attr are never read.

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>
Cc: Somnath Kotur <somnath.kotur@broadcom.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 3 ---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h | 6 ------
 drivers/infiniband/hw/bnxt_re/qplib_sp.c | 3 ---
 drivers/infiniband/hw/bnxt_re/qplib_sp.h | 2 --
 4 files changed, 14 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 5a7c090204c537..8b6ad5cddfce99 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -177,9 +177,6 @@ int bnxt_re_query_device(struct ib_device *ibdev,
 	ib_attr->max_total_mcast_qp_attach = 0;
 	ib_attr->max_ah = dev_attr->max_ah;
 
-	ib_attr->max_fmr = 0;
-	ib_attr->max_map_per_fmr = 0;
-
 	ib_attr->max_srq = dev_attr->max_srq;
 	ib_attr->max_srq_wr = dev_attr->max_srq_wqes;
 	ib_attr->max_srq_sge = dev_attr->max_srq_sges;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index 204c0849ba2847..e5fbbeba6d28d3 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -122,12 +122,6 @@ struct bnxt_re_frpl {
 	u64				*page_list;
 };
 
-struct bnxt_re_fmr {
-	struct bnxt_re_dev	*rdev;
-	struct ib_fmr		ib_fmr;
-	struct bnxt_qplib_mrw	qplib_fmr;
-};
-
 struct bnxt_re_mw {
 	struct bnxt_re_dev	*rdev;
 	struct ib_mw		ib_mw;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.c b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
index 66954ff6a2f275..4cd475ea97a24e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
@@ -132,9 +132,6 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw,
 	attr->max_raw_ethy_qp = le32_to_cpu(sb->max_raw_eth_qp);
 	attr->max_ah = le32_to_cpu(sb->max_ah);
 
-	attr->max_fmr = le32_to_cpu(sb->max_fmr);
-	attr->max_map_per_fmr = sb->max_map_per_fmr;
-
 	attr->max_srq = le16_to_cpu(sb->max_srq);
 	attr->max_srq_wqes = le32_to_cpu(sb->max_srq_wr) - 1;
 	attr->max_srq_sges = sb->max_srq_sge;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_sp.h b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
index 13d9432d5ce222..6404f0da10517a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_sp.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.h
@@ -64,8 +64,6 @@ struct bnxt_qplib_dev_attr {
 	u32				max_mw;
 	u32				max_raw_ethy_qp;
 	u32				max_ah;
-	u32				max_fmr;
-	u32				max_map_per_fmr;
 	u32				max_srq;
 	u32				max_srq_wqes;
 	u32				max_srq_sges;
-- 
2.26.2

