Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E213F9DF9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 19:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbhH0RXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 13:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241005AbhH0RW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 13:22:57 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1653C0613A3;
        Fri, 27 Aug 2021 10:21:55 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id t42so6214865pfg.12;
        Fri, 27 Aug 2021 10:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gLQw+gOkOgBpF527SY7hnRVsopMwR8pUZ+6p/+sCMZE=;
        b=jqKW1cLVDQjLgxObfit7zrVrS1J/x3pPdbxN1asI4+M8zeuts6wiVmaF5gUPo9V2FS
         JXeBFTb/jNQsN8TVkdzk5dR/ZI/RL9bT7w6c7bid9edxLa0DUGokGuxk8lS91UGkaZj4
         eqhtySo2OVg6q8KSYAGPGN96kFNqzBoVPg3X/PK5X2nNp/aialOuUPCIlZMUG0e+PnrF
         loz3O3FeTYg3uZwrb5yAi3OMvnSUXqfLmi7a7GhGDDQYfkSFFvgBDn2e4Y2I1ay7oW87
         728MiFOG393bdP8GnvBwKHUYm2+UuifhwCPpfKTJJH5Hk/ZtBiCsSRaDaNOT026pRuBy
         Imzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gLQw+gOkOgBpF527SY7hnRVsopMwR8pUZ+6p/+sCMZE=;
        b=WUD8Jq1yEH6Z3shieF9xly0FPQT8xLhOPtCEX79HaJDAx8oXCIeiuXANo8Sn99ctJ4
         ffQq+lUaIkmJvsfNwPZRMU2D3iJUaFEvtugjzj3fidYEK3IopzzKS6IN5e5ieEPvmx6r
         W0v13hrty15xqGYD6NEBXA0hRZJGWC3XuGFjYU+kUA2pq43CjuQ+9cSu4An/LMHb1mpF
         7/rUZtD7TxB6jTVzhtrH0Py5Pv+Ru59SCsM3E7CnBuAK4LFSbV7Jx4vreL4/u7TilagU
         7yzKYg9iYd+M3Ky8FlQ1RREXiuWZluLIZ7ZaeKrDU+cHnYa2WR1dwzT0D0vpiChJRnfc
         +D0g==
X-Gm-Message-State: AOAM5318QCNIm4wnXfwAbSlQC4O5I685530n991eRN2hbKW5sSvVR8vh
        Gcj6gUUOSKjtJn6oL4IZKUA=
X-Google-Smtp-Source: ABdhPJwuiMDXHrHAjE5Ue90v/UaZtCN02djvrlnnwi5m/AZBQrrgZl+iVNvLmQEttw3bmm/01KlJZg==
X-Received: by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id b20-20020a056a000a94b02903841dc67012mr10074419pfl.53.1630084915337;
        Fri, 27 Aug 2021 10:21:55 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:36:ef50:8fcd:44d1:eb17])
        by smtp.gmail.com with ESMTPSA id f5sm7155015pjo.23.2021.08.27.10.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 10:21:54 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        pgonda@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        linux-arm-kernel@lists.infradead.org,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        ardb@kernel.org, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V4 13/13] hv_storvsc: Add Isolation VM support for storvsc driver
Date:   Fri, 27 Aug 2021 13:21:11 -0400
Message-Id: <20210827172114.414281-14-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210827172114.414281-1-ltykernel@gmail.com>
References: <20210827172114.414281-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM, all shared memory with host needs to mark visible
to host via hvcall. vmbus_establish_gpadl() has already done it for
storvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
mpb_desc() still needs to be handled. Use DMA API(dma_map_sg) to map
these memory during sending/receiving packet and return swiotlb bounce
buffer dma address. In Isolation VM, swiotlb  bounce buffer is marked
to be visible to host and the swiotlb force mode is enabled.

Set device's dma min align mask to HV_HYP_PAGE_SIZE - 1 in order to
keep the original data offset in the bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	* Rplace dma_map_page with dma_map_sg()
	* Use for_each_sg() to populate payload->range.pfn_array.
	* Remove storvsc_dma_map macro
---
 drivers/hv/vmbus_drv.c     |  1 +
 drivers/scsi/storvsc_drv.c | 41 +++++++++++++++-----------------------
 include/linux/hyperv.h     |  1 +
 3 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f068e22a5636..270d526fd9de 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2124,6 +2124,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	hv_debug_add_dev_dir(child_device_obj);
 
 	child_device_obj->device.dma_mask = &vmbus_dma_mask;
+	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 328bb961c281..4f1793be1fdc 100644
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
@@ -1312,6 +1314,9 @@ static void storvsc_on_channel_callback(void *context)
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
+				if (scsi_sg_count(scmnd))
+					dma_unmap_sg(&device->device, scsi_sglist(scmnd),
+						     scsi_sg_count(scmnd), scmnd->sc_data_direction);
 			}
 
 			storvsc_on_receive(stor_device, packet, request);
@@ -1725,7 +1730,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
 	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
-	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count;
 	struct vmscsi_request *vm_srb;
@@ -1807,10 +1811,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
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
 
@@ -1824,31 +1829,16 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 
+		if (dma_map_sg(&dev->device, sgl, sg_count,
+		    scmnd->sc_data_direction) == 0)
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 
-		for (i = 0; sgl != NULL; sgl = sg_next(sgl)) {
-			/*
-			 * Init values for the current sgl entry. hvpgoff
-			 * and hvpfns_to_add are in units of Hyper-V size
-			 * pages. Handling the PAGE_SIZE != HV_HYP_PAGE_SIZE
-			 * case also handles values of sgl->offset that are
-			 * larger than PAGE_SIZE. Such offsets are handled
-			 * even on other than the first sgl entry, provided
-			 * they are a multiple of PAGE_SIZE.
-			 */
-			hvpgoff = HVPFN_DOWN(sgl->offset);
-			hvpfn = page_to_hvpfn(sg_page(sgl)) + hvpgoff;
-			hvpfns_to_add =	HVPFN_UP(sgl->offset + sgl->length) -
-						hvpgoff;
+		for_each_sg(sgl, sg, sg_count, j) {
+			hvpfns_to_add = HVPFN_UP(sg_dma_len(sg));
+			hvpfn = HVPFN_DOWN(sg_dma_address(sg));
 
-			/*
-			 * Fill the next portion of the PFN array with
-			 * sequential Hyper-V PFNs for the continguous physical
-			 * memory described by the sgl entry. The end of the
-			 * last sgl should be reached at the same time that
-			 * the PFN array is filled.
-			 */
 			while (hvpfns_to_add--)
-				payload->range.pfn_array[i++] =	hvpfn++;
+				payload->range.pfn_array[i++] = hvpfn++;
 		}
 	}
 
@@ -1992,6 +1982,7 @@ static int storvsc_probe(struct hv_device *device,
 	stor_device->vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 	spin_lock_init(&stor_device->lock);
 	hv_set_drvdata(device, stor_device);
+	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
 
 	stor_device->port_number = host->host_no;
 	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 139a43ad65a1..8f39893f8ccf 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1274,6 +1274,7 @@ struct hv_device {
 
 	struct vmbus_channel *channel;
 	struct kset	     *channels_kset;
+	struct device_dma_parameters dma_parms;
 
 	/* place holder to keep track of the dir for hv device in debugfs */
 	struct dentry *debug_dir;
-- 
2.25.1

