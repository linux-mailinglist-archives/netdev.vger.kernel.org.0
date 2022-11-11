Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC462575D
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 10:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbiKKJzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 04:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiKKJzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 04:55:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396656A6A5;
        Fri, 11 Nov 2022 01:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE31C61F25;
        Fri, 11 Nov 2022 09:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C3FC433D6;
        Fri, 11 Nov 2022 09:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668160536;
        bh=uaX19JVBBKkGIC4BtJYwZ5WLMPCevBN3Hz27gVGIP+o=;
        h=From:To:Cc:Subject:Date:From;
        b=fMTSTN/uhcCRd2pQU9Pd4IrgDY76jm3Qk9DVFYfLwtMr0QyeAsgwZKSFB3UpE5TZw
         iKdFJR0p2mPU63oQjs0zvdP7AUvK/S0b1rNZrNgHaYCkw0rcQNskqIIO6GN8Dksi72
         4w9aDK81rx+7eL1hCNmRUJiossovVPHdDAjq1GAwKzCFuO0LC03Wlj5Y7wFofoSB9Z
         jeqVqQ31/rB5NnTyxvI07/0jnQbO+66u5bLCB4JXy4IGguzFE716Acew1AGlnrHW2A
         WxNIo44CKIGjTaInGoCcT/170M/ICNBlqy8s4+BvWUpDX55SQCzWCa/zfgtWNcTWcx
         VySHLcuRl7kxw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Eric Dumazet <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH rdma-next] RDMA/mana: Remove redefinition of basic u64 type
Date:   Fri, 11 Nov 2022 11:55:29 +0200
Message-Id: <3c1e821279e6a165d058655d2343722d6650e776.1668160486.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

gdma_obj_handle_t is no more than redefinition of basic
u64 type. Remove such obfuscation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mana/mr.c               |  5 ++-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  3 +-
 include/net/mana/gdma.h                       | 31 +++++++++----------
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mana/mr.c b/drivers/infiniband/hw/mana/mr.c
index a56236cdd9ee..351207c60eb6 100644
--- a/drivers/infiniband/hw/mana/mr.c
+++ b/drivers/infiniband/hw/mana/mr.c
@@ -73,8 +73,7 @@ static int mana_ib_gd_create_mr(struct mana_ib_dev *dev, struct mana_ib_mr *mr,
 	return 0;
 }
 
-static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev,
-				 gdma_obj_handle_t mr_handle)
+static int mana_ib_gd_destroy_mr(struct mana_ib_dev *dev, u64 mr_handle)
 {
 	struct gdma_destroy_mr_response resp = {};
 	struct gdma_destroy_mr_request req = {};
@@ -108,9 +107,9 @@ struct ib_mr *mana_ib_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
 	struct gdma_create_mr_params mr_params = {};
 	struct ib_device *ibdev = ibpd->device;
-	gdma_obj_handle_t dma_region_handle;
 	struct mana_ib_dev *dev;
 	struct mana_ib_mr *mr;
+	u64 dma_region_handle;
 	int err;
 
 	dev = container_of(ibdev, struct mana_ib_dev, ib_dev);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 46a7d1e6ece9..69224ff8efb6 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -671,8 +671,7 @@ int mana_gd_create_hwc_queue(struct gdma_dev *gd,
 	return err;
 }
 
-int mana_gd_destroy_dma_region(struct gdma_context *gc,
-			       gdma_obj_handle_t dma_region_handle)
+int mana_gd_destroy_dma_region(struct gdma_context *gc, u64 dma_region_handle)
 {
 	struct gdma_destroy_dma_region_req req = {};
 	struct gdma_general_resp resp = {};
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 221adc96340c..a9fdae14d24c 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -65,8 +65,6 @@ enum {
 	GDMA_DEVICE_MANA	= 2,
 };
 
-typedef u64 gdma_obj_handle_t;
-
 struct gdma_resource {
 	/* Protect the bitmap */
 	spinlock_t lock;
@@ -200,7 +198,7 @@ struct gdma_mem_info {
 	u64 length;
 
 	/* Allocated by the PF driver */
-	gdma_obj_handle_t dma_region_handle;
+	u64 dma_region_handle;
 };
 
 #define REGISTER_ATB_MST_MKEY_LOWER_SIZE 8
@@ -624,7 +622,7 @@ struct gdma_create_queue_req {
 	u32 reserved1;
 	u32 pdid;
 	u32 doolbell_id;
-	gdma_obj_handle_t gdma_region;
+	u64 gdma_region;
 	u32 reserved2;
 	u32 queue_size;
 	u32 log2_throttle_limit;
@@ -699,14 +697,14 @@ struct gdma_create_dma_region_req {
 
 struct gdma_create_dma_region_resp {
 	struct gdma_resp_hdr hdr;
-	gdma_obj_handle_t dma_region_handle;
+	u64 dma_region_handle;
 }; /* HW DATA */
 
 /* GDMA_DMA_REGION_ADD_PAGES */
 struct gdma_dma_region_add_pages_req {
 	struct gdma_req_hdr hdr;
 
-	gdma_obj_handle_t dma_region_handle;
+	u64 dma_region_handle;
 
 	u32 page_addr_list_len;
 	u32 reserved3;
@@ -718,7 +716,7 @@ struct gdma_dma_region_add_pages_req {
 struct gdma_destroy_dma_region_req {
 	struct gdma_req_hdr hdr;
 
-	gdma_obj_handle_t dma_region_handle;
+	u64 dma_region_handle;
 }; /* HW DATA */
 
 enum gdma_pd_flags {
@@ -733,14 +731,14 @@ struct gdma_create_pd_req {
 
 struct gdma_create_pd_resp {
 	struct gdma_resp_hdr hdr;
-	gdma_obj_handle_t pd_handle;
+	u64 pd_handle;
 	u32 pd_id;
 	u32 reserved;
 };/* HW DATA */
 
 struct gdma_destroy_pd_req {
 	struct gdma_req_hdr hdr;
-	gdma_obj_handle_t pd_handle;
+	u64 pd_handle;
 };/* HW DATA */
 
 struct gdma_destory_pd_resp {
@@ -756,11 +754,11 @@ enum gdma_mr_type {
 };
 
 struct gdma_create_mr_params {
-	gdma_obj_handle_t pd_handle;
+	u64 pd_handle;
 	enum gdma_mr_type mr_type;
 	union {
 		struct {
-			gdma_obj_handle_t dma_region_handle;
+			u64 dma_region_handle;
 			u64 virtual_address;
 			enum gdma_mr_access_flags access_flags;
 		} gva;
@@ -769,13 +767,13 @@ struct gdma_create_mr_params {
 
 struct gdma_create_mr_request {
 	struct gdma_req_hdr hdr;
-	gdma_obj_handle_t pd_handle;
+	u64 pd_handle;
 	enum gdma_mr_type mr_type;
 	u32 reserved_1;
 
 	union {
 		struct {
-			gdma_obj_handle_t dma_region_handle;
+			u64 dma_region_handle;
 			u64 virtual_address;
 			enum gdma_mr_access_flags access_flags;
 		} gva;
@@ -786,14 +784,14 @@ struct gdma_create_mr_request {
 
 struct gdma_create_mr_response {
 	struct gdma_resp_hdr hdr;
-	gdma_obj_handle_t mr_handle;
+	u64 mr_handle;
 	u32 lkey;
 	u32 rkey;
 };/* HW DATA */
 
 struct gdma_destroy_mr_request {
 	struct gdma_req_hdr hdr;
-	gdma_obj_handle_t mr_handle;
+	u64 mr_handle;
 };/* HW DATA */
 
 struct gdma_destroy_mr_response {
@@ -827,7 +825,6 @@ void mana_gd_free_memory(struct gdma_mem_info *gmi);
 int mana_gd_send_request(struct gdma_context *gc, u32 req_len, const void *req,
 			 u32 resp_len, void *resp);
 
-int mana_gd_destroy_dma_region(struct gdma_context *gc,
-			       gdma_obj_handle_t dma_region_handle);
+int mana_gd_destroy_dma_region(struct gdma_context *gc, u64 dma_region_handle);
 
 #endif /* _GDMA_H */
-- 
2.38.1

