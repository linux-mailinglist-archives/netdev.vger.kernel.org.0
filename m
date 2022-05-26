Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727B4534EBA
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 14:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240642AbiEZMBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 08:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbiEZMBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 08:01:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D751C8BEC;
        Thu, 26 May 2022 05:01:21 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y199so1508031pfb.9;
        Thu, 26 May 2022 05:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oaqG6keHyyCSAVb73eGtDPFdUcregAH3H4j2SG+oYUM=;
        b=kJazciJ8tosHNjEcGmQPRBsvV97CnX70u9eK1RMlJ7V8o0r69g17gCeql6TfT+VBhX
         b4cMWi4Vynnv0NTYxJgk1dNRtzcobgplTF+zC1VmCzXPBsk1NEmKS4IbkpPrA2jw4skU
         uRTzcZEwW/+oVg9UZJUsxMbFQ+rzfMvx6al2/hSBbUmaJq36/1MoI759wCzU4FDN3eib
         ebc0SfzXGHwpq/TsybeSupVrN7GlsXmhFaK7e/hDvHqlV/+epOYsvvATdIW3I8YBpo/g
         7yDlGNoT9YK7Vyvvew/SrrKf07ENspk3z2GefeXk7ZOA/Abdi/+EuqFzZ9wVtlMpnOP3
         vzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaqG6keHyyCSAVb73eGtDPFdUcregAH3H4j2SG+oYUM=;
        b=JmST/jei6xw3HrMVrijBpmeA2f8QavobCCefxJWJH7zJy81xrVIY7bReXgZED8wPK+
         NDX6PR8x2MJ9QPPRYfNgn1O8QN0TKEBmFIBL5QhmeS/FOnw1/mCtDcHVfpQzdArUvcIv
         waDr5y5M0Kyv8BgrP01RfmS0FBis61QvX9+OaT6iQWnU3m1Prdf0rHLuZp2Yi7momSGH
         imo6LhJPC2rYQrGmEYvugEIAFbTZqCWO9CB0KLFI4wbWfJKSEnSbjPCYmBv6wkbSVNzg
         4LVPqXk0UyIy80NDcUyNH+j3s5hFT/0RYbgRl7vxWHECs89HTW6sZgNaYUQGxc6x8sPP
         a9FA==
X-Gm-Message-State: AOAM531vanqJN3Oy4yYQqu6T1k4o9TMwV00kGQKWdtXupZhcfO/FsIKH
        w5flvqw9pxMOGj+Epcgo20A=
X-Google-Smtp-Source: ABdhPJwX2SpqKU5d/cL5IEDu3OEqy5GvPcCmDcmiNn5GROww05NYfwGcdG7Hd0ARlyh8HFsXeDYNUA==
X-Received: by 2002:a63:5:0:b0:3c6:dcb2:428 with SMTP id 5-20020a630005000000b003c6dcb20428mr32725819pga.73.1653566480747;
        Thu, 26 May 2022 05:01:20 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:1:45c7:d5e2:7b45:3336])
        by smtp.gmail.com with ESMTPSA id bi7-20020a170902bf0700b0015e8d4eb282sm1328190plb.204.2022.05.26.05.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 05:01:20 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        parri.andrea@gmail.com, thomas.lendacky@amd.com,
        andi.kleen@intel.com, kirill.shutemov@intel.com
Subject: [RFC PATCH V3 2/2] net: netvsc: Allocate per-device swiotlb bounce buffer for netvsc
Date:   Thu, 26 May 2022 08:01:12 -0400
Message-Id: <20220526120113.971512-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220526120113.971512-1-ltykernel@gmail.com>
References: <20220526120113.971512-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Netvsc driver allocates device io tlb mem via calling swiotlb_device_
allocate() and set child io tlb mem number according to device queue
number. Child io tlb mem may reduce overhead of single spin lock in
device io tlb mem among multi device queues.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9442f751ad3a..26a8f8f84fc4 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -23,6 +23,7 @@
 
 #include <asm/sync_bitops.h>
 #include <asm/mshyperv.h>
+#include <linux/swiotlb.h>
 
 #include "hyperv_net.h"
 #include "netvsc_trace.h"
@@ -98,6 +99,7 @@ static void netvsc_subchan_work(struct work_struct *w)
 	struct netvsc_device *nvdev =
 		container_of(w, struct netvsc_device, subchan_work);
 	struct rndis_device *rdev;
+	struct hv_device *hdev;
 	int i, ret;
 
 	/* Avoid deadlock with device removal already under RTNL */
@@ -108,6 +110,9 @@ static void netvsc_subchan_work(struct work_struct *w)
 
 	rdev = nvdev->extension;
 	if (rdev) {
+		hdev = ((struct net_device_context *)
+			netdev_priv(rdev->ndev))->device_ctx;
+
 		ret = rndis_set_subchannel(rdev->ndev, nvdev, NULL);
 		if (ret == 0) {
 			netif_device_attach(rdev->ndev);
@@ -119,6 +124,10 @@ static void netvsc_subchan_work(struct work_struct *w)
 			nvdev->max_chn = 1;
 			nvdev->num_chn = 1;
 		}
+
+		/* Allocate boucne buffer.*/
+		swiotlb_device_allocate(&hdev->device, nvdev->num_chn,
+				10 * IO_TLB_BLOCK_UNIT);
 	}
 
 	rtnl_unlock();
@@ -769,6 +778,7 @@ void netvsc_device_remove(struct hv_device *device)
 
 	/* Release all resources */
 	free_netvsc_device_rcu(net_device);
+	swiotlb_device_free(&device->device);
 }
 
 #define RING_AVAIL_PERCENT_HIWATER 20
-- 
2.25.1

