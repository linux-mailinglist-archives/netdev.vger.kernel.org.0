Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CCF40AF5F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhINNmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbhINNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:41:09 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFC3C0613CF;
        Tue, 14 Sep 2021 06:39:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w8so12730937pgf.5;
        Tue, 14 Sep 2021 06:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6GY3z4JvJviWkSRCk5kJjmxao2kOnqCUtugNfHg/pw=;
        b=dDHEgjjhONvetT5YclBkax+X6EY3U8rrUfLy/aimO6iFEaJzZte34OHy3Gmk7JZfPE
         Pggybi9YLY9iIVSeqJqx7clgxMGVMEP8TtLaHzOW6LPUCpK91pv50TaSb2AEO9aMpLBd
         5vNa0hpfM90xmm+vOpPn4FaKRXi5urhJjU86eJpvLASlL+/dKBZuE22QOsg1W6uzTiyo
         kH5MFhd5SbmeVWhmueq7+NQylhNDj3Eh9b63XJbTIpiudQB42/28UOhDAfQf8/ph6yE7
         dcIqRYrSNXK3RNbQ3Xe+HFePVpn7E6KSoYLVPniJoegZD+jyC822quIHXse/2XucEYnb
         Llbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6GY3z4JvJviWkSRCk5kJjmxao2kOnqCUtugNfHg/pw=;
        b=UgQJS3DhyQ8Bdf59O4NWV5SnmcUg+NJ3aE805/OIipyYpW44lnznBxIPDx0XU49PV4
         RBN2rLVb7mU+4dFFfdma278pmwqFs38LT1b31xqBSMqJf/LS8mq1z6wmPnE9/YOicby2
         S3PPufYGvCYTywpCXthM63mn1XVrgurQQPJw3o4P8c/PvKgn3FQibTaZTro/5TpTrfxz
         tJsKg/qJOSxaCvP8nGp9p11812B+7OjwGniM0f77XoPTVdSMRlhJ2OV8TANOV2pXiUo1
         sNnQhf+KMRsB1ow86ue06G7oROqw7qkHvvGCRYBkYIs1xqUKc5sVpDeF7UWl0GeSVgbI
         2uwQ==
X-Gm-Message-State: AOAM533shT3LiCfyE+VHCEhqqVursf1lqvfASjPtvvzAqGokgVDBF2Yx
        qZe99ZUlXOArEcQMZeKA0o8=
X-Google-Smtp-Source: ABdhPJyd7B/cycREjmjwvYi/L8C41okdW25JkBh0jV2R9467KDZelN884wrT/mvAlGHMBU2oT9UWmg==
X-Received: by 2002:a63:ec06:: with SMTP id j6mr15654053pgh.259.1631626791699;
        Tue, 14 Sep 2021 06:39:51 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:7:6ea2:a529:4af3:5057])
        by smtp.gmail.com with ESMTPSA id v13sm10461234pfm.16.2021.09.14.06.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:39:51 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        gregkh@linuxfoundation.org, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, sfr@canb.auug.org.au, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, krish.sadhukhan@oracle.com,
        xen-devel@lists.xenproject.org, tj@kernel.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: [PATCH V5 11/12] scsi: storvsc: Add Isolation VM support for storvsc driver
Date:   Tue, 14 Sep 2021 09:39:12 -0400
Message-Id: <20210914133916.1440931-12-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914133916.1440931-1-ltykernel@gmail.com>
References: <20210914133916.1440931-1-ltykernel@gmail.com>
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
Change since v4:
	* use scsi_dma_map/unmap() instead of dma_map/unmap_sg()
	* Add deleted comments back.
	* Fix error calculation of  hvpnfs_to_add

Change since v3:
	* Rplace dma_map_page with dma_map_sg()
	* Use for_each_sg() to populate payload->range.pfn_array.
	* Remove storvsc_dma_map macro
---
 drivers/hv/vmbus_drv.c     |  1 +
 drivers/scsi/storvsc_drv.c | 24 +++++++++++++++---------
 include/linux/hyperv.h     |  1 +
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index b0be287e9a32..9c53f823cde1 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2121,6 +2121,7 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	hv_debug_add_dev_dir(child_device_obj);
 
 	child_device_obj->device.dma_mask = &vmbus_dma_mask;
+	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
 	return 0;
 
 err_kset_unregister:
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ebbbc1299c62..d10b450bcf0c 100644
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
@@ -1322,6 +1324,7 @@ static void storvsc_on_channel_callback(void *context)
 					continue;
 				}
 				request = (struct storvsc_cmd_request *)scsi_cmd_priv(scmnd);
+				scsi_dma_unmap(scmnd);
 			}
 
 			storvsc_on_receive(stor_device, packet, request);
@@ -1735,7 +1738,6 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct hv_host_device *host_dev = shost_priv(host);
 	struct hv_device *dev = host_dev->dev;
 	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
-	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count;
 	struct vmscsi_request *vm_srb;
@@ -1817,10 +1819,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
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
 
@@ -1834,8 +1837,11 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		payload->range.len = length;
 		payload->range.offset = offset_in_hvpg;
 
+		sg_count = scsi_dma_map(scmnd);
+		if (sg_count < 0)
+			return SCSI_MLQUEUE_DEVICE_BUSY;
 
-		for (i = 0; sgl != NULL; sgl = sg_next(sgl)) {
+		for_each_sg(sgl, sg, sg_count, j) {
 			/*
 			 * Init values for the current sgl entry. hvpgoff
 			 * and hvpfns_to_add are in units of Hyper-V size
@@ -1845,10 +1851,9 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			 * even on other than the first sgl entry, provided
 			 * they are a multiple of PAGE_SIZE.
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
@@ -1858,7 +1863,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			 * the PFN array is filled.
 			 */
 			while (hvpfns_to_add--)
-				payload->range.pfn_array[i++] =	hvpfn++;
+				payload->range.pfn_array[i++] = hvpfn++;
 		}
 	}
 
@@ -2002,6 +2007,7 @@ static int storvsc_probe(struct hv_device *device,
 	stor_device->vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 	spin_lock_init(&stor_device->lock);
 	hv_set_drvdata(device, stor_device);
+	dma_set_min_align_mask(&device->device, HV_HYP_PAGE_SIZE - 1);
 
 	stor_device->port_number = host->host_no;
 	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size, is_fc);
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index bb1a1519b93a..c94c534a944e 100644
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

