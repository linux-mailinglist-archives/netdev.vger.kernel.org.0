Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8E46B3BD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhLGHXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhLGHXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:23:35 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502D3C061748;
        Mon,  6 Dec 2021 23:20:05 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v23so9608773pjr.5;
        Mon, 06 Dec 2021 23:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yy/2OZY9J/wYavLFTDE3NlPfcML7wexzr9ziGzbYE+w=;
        b=FzlqxS98zQRZobTTPj7joOGf0jAuriPD10zkSfwUxtwoMfNaaCWbqNxOMqOz1zSVnR
         jhINxg1RZY1rvdjniIwsHXa8AxzGCizRHjX8jYN8vt2Caei72j1sVVwWcU5jhy0KOZy5
         ZT1VklSfMk5S2bEAFLI031dchspTryJ4rgLXbLEq/G+Oln+hG21lJ2P1DK7Ea8yxzzpb
         MrYOw3B06Baaqh+/4Xt4KVu683dcGo0jeNAVbgb79PS5LRP+c72QVUFT+HOZ7y07uzCI
         2xi+hfzrI2x2p5yQfvfSDA4QaYxX+UeclRH7PQz12VVi9tKlIKIOPN+wlb3zrrH59tIW
         aRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yy/2OZY9J/wYavLFTDE3NlPfcML7wexzr9ziGzbYE+w=;
        b=PfALpqS/9HlgIiQrHS/PdVGf4YlSJqwWA4HJcxktRNUxBB4pm/XqOb5pzpfaBGQj0H
         okcyMTh/kAoVflrLn1E5GWfPu0JgJSwio7nTlBVnmBE6KMZ1VrhjGk0ERewwVviPr5yY
         w8kYy+REID3wvCUbIgLM+Wvc3zwSRtGt4t+XCBwajtb5R9HXO0mNOo0/s53DqJcmyBaQ
         UgVy2ityqK4Xa1o9x/T6Igb0aJFN9hrAh6dwo/9/HrUhguX88IzWS0vWQIJ3b4JPrVWq
         7yVQF9dIYFXKwB0hku/aUe1KSn7KHUUuLTJM2QOAhac8nBizwGK1HxUn7/5Umj38etdM
         fwlg==
X-Gm-Message-State: AOAM530b4OKJ5wijJO3P+E4jKnCHmUoO46PgvfyHyKQ6cd52FUIjJBqo
        /oLS2cD7OarXdqnFbBsKZ7Q=
X-Google-Smtp-Source: ABdhPJy5k0jGESG5VpsraXqRrKwUIWIJcT+nwrfIpedlwvljyeNhkOGCeIgTgKVRtBphQevxYIkmLg==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr4486211pjb.157.1638861603388;
        Mon, 06 Dec 2021 23:20:03 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:38:e747:5b78:1904:a4ed])
        by smtp.gmail.com with ESMTPSA id u12sm2081789pfk.71.2021.12.06.23.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:20:03 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 4/5] scsi: storvsc: Add Isolation VM support for storvsc driver
Date:   Tue,  7 Dec 2021 02:19:40 -0500
Message-Id: <20211207071942.472442-5-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207071942.472442-1-ltykernel@gmail.com>
References: <20211207071942.472442-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM, all shared memory with host needs to mark visible
to host via hvcall. vmbus_establish_gpadl() has already done it for
storvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
mpb_desc() still needs to be handled. Use DMA API(scsi_dma_map/unmap)
to map these memory during sending/receiving packet and return swiotlb
bounce buffer dma address. In Isolation VM, swiotlb  bounce buffer is
marked to be visible to host and the swiotlb force mode is enabled.

Set device's dma min align mask to HV_HYP_PAGE_SIZE - 1 in order to
keep the original data offset in the bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/vmbus_drv.c     |  4 ++++
 drivers/scsi/storvsc_drv.c | 37 +++++++++++++++++++++----------------
 include/linux/hyperv.h     |  1 +
 3 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 392c1ac4f819..ae6ec503399a 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -33,6 +33,7 @@
 #include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/syscore_ops.h>
+#include <linux/dma-map-ops.h>
 #include <clocksource/hyperv_timer.h>
 #include "hyperv_vmbus.h"
 
@@ -2078,6 +2079,7 @@ struct hv_device *vmbus_device_create(const guid_t *type,
 	return child_device_obj;
 }
 
+static u64 vmbus_dma_mask = DMA_BIT_MASK(64);
 /*
  * vmbus_device_register - Register the child device
  */
@@ -2118,6 +2120,8 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
+	child_device_obj->device.dma_mask = &vmbus_dma_mask;
+	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 20595c0ba0ae..ae293600d799 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -21,6 +21,8 @@
 #include <linux/device.h>
 #include <linux/hyperv.h>
 #include <linux/blkdev.h>
+#include <linux/dma-mapping.h>
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -1336,6 +1338,7 @@ static void storvsc_on_channel_callback(void *context)
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
+				scsi_dma_unmap(scmnd);
 			}
 
 			storvsc_on_receive(stor_device, packet, request);
@@ -1749,7 +1752,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
 	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
-	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count;
 	struct vmscsi_request *vm_srb;
@@ -1831,10 +1833,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	payload_sz = sizeof(cmd_request->mpb);
 
 	if (sg_count) {
-		unsigned int hvpgoff, hvpfns_to_add;
 		unsigned long offset_in_hvpg = offset_in_hvpage(sgl->offset);
 		unsigned int hvpg_count = HVPFN_UP(offset_in_hvpg + length);
-		u64 hvpfn;
+		struct scatterlist *sg;
+		unsigned long hvpfn, hvpfns_to_add;
+		int j, i = 0;
 
 		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
 
@@ -1848,21 +1851,22 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 
+		sg_count = scsi_dma_map(scmnd);
+		if (sg_count < 0)
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 
-		for (i = 0; sgl != NULL; sgl = sg_next(sgl)) {
+		for_each_sg(sgl, sg, sg_count, j) {
 			/*
-			 * Init values for the current sgl entry. hvpgoff
-			 * and hvpfns_to_add are in units of Hyper-V size
-			 * pages. Handling the PAGE_SIZE != HV_HYP_PAGE_SIZE
-			 * case also handles values of sgl->offset that are
-			 * larger than PAGE_SIZE. Such offsets are handled
-			 * even on other than the first sgl entry, provided
-			 * they are a multiple of PAGE_SIZE.
+			 * Init values for the current sgl entry. hvpfns_to_add
+			 * is in units of Hyper-V size pages. Handling the
+			 * PAGE_SIZE != HV_HYP_PAGE_SIZE case also handles
+			 * values of sgl->offset that are larger than PAGE_SIZE.
+			 * Such offsets are handled even on other than the first
+			 * sgl entry, provided they are a multiple of PAGE_SIZE.
 			 */
-			hvpgoff = HVPFN_DOWN(sgl->offset);
-			hvpfn = page_to_hvpfn(sg_page(sgl)) + hvpgoff;
-			hvpfns_to_add =	HVPFN_UP(sgl->offset + sgl->length) -
-						hvpgoff;
+			hvpfn = HVPFN_DOWN(sg_dma_address(sg));
+			hvpfns_to_add = HVPFN_UP(sg_dma_address(sg) +
+						 sg_dma_len(sg)) - hvpfn;
 
 			/*
 			 * Fill the next portion of the PFN array with
@@ -1872,7 +1876,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			 * the PFN array is filled.
 			 */
 			while (hvpfns_to_add--)
-				payload->range.pfn_array[i++] =	hvpfn++;
+				payload->range.pfn_array[i++] = hvpfn++;
 		}
 	}
 
@@ -2016,6 +2020,7 @@ static int storvsc_probe(struct hv_device *device,
 	stor_device->vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 	spin_lock_init(&stor_device->lock);
 	hv_set_drvdata(device, stor_device);
+	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
 
 	stor_device->port_number = host->host_no;
 	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 1f037e114dc8..74f5e92f91a0 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1261,6 +1261,7 @@ struct hv_device {
 
 	struct vmbus_channel *channel;
 	struct kset	     *channels_kset;
+	struct device_dma_parameters dma_parms;
 
 	/* place holder to keep track of the dir for hv device in debugfs */
 	struct dentry *debug_dir;
-- 
2.25.1

