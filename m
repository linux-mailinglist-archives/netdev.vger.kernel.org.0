Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E99635F6DC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352093AbhDNOwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352003AbhDNOu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A99C061756;
        Wed, 14 Apr 2021 07:50:35 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d10so14564546pgf.12;
        Wed, 14 Apr 2021 07:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FJbcZ8KnexDAAQ5C4Sah9FWkqLY6Pv3HeJbolDJY4aA=;
        b=pJqRunkA+uvhxmvikCt8JBi6ru5mMAHBSouNbpNF9rJ0/UZBeBZbNJBCihskZckNdz
         VF19al63x7JcKIwSaI+KgRMKfSCSAY1Rw9bm3SeZTFumtAQ1F6F2t95WHbTa7fd9i7Tn
         oYWyOXXwTN9+AehaDQOGu3IYPhNL0uJPAF/Y5xrfhILPXupgDCaiPCDkfxwVRVWqt8q+
         v1FJRcKkKffDj4UMUcXDwJEin7yz4TBxBoW5ErGESAAdJKNwJ1ukgEYbn+s0z/MPExFU
         EV7Gn16e8uqLMsjL1/Ua5qlsNxwABA+5vNnnX0j44xHWZEyyVt04dkbZk7p6QtVwr46f
         qTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FJbcZ8KnexDAAQ5C4Sah9FWkqLY6Pv3HeJbolDJY4aA=;
        b=GvNpKmeYZCewxMj0gRCDXVdOYeh3MQ+MeNV8pKu3jhgw/kVZ8J2zvbxrBbvyksOm0S
         3vOKTdwaaNX6Ik2Sg4yR2auW25wWkQplZqArGOtHuaCTL5+D/tZV9K9ZGBpLNZcWL90P
         ymxJ6i7rczWFuvBk9gGbKNTBx5OuHEpSlFHU+C/hLqP122iLaMDoIyLxI6z+YlU2Zk7C
         u19mOOuaSQqqzp0brUhBt2bviw7ZoMg2X4gaotqHDKrtrKA1fcCGeE8FjW9D4YPgTi7O
         nym2F5zriPEz0mJC8ODj7X1sd4dl2yyc8/eivA+HembqYyUBNs7nzGTGMEakh0C0wLIY
         3YkA==
X-Gm-Message-State: AOAM533X0H9AFVC1D6IT0Dl2YDG0eK7eSMQCSeObnhKoiAIrecBnPlgF
        VXjh1zdDMqm1xfd8bghS/j0=
X-Google-Smtp-Source: ABdhPJxHAv83JdLDizjV20z7u62dRC/ZGAyfJ/XHZQUwINjnLav8NcwqNU6XQrZbUuAS+bM3Dz+Utw==
X-Received: by 2002:a63:1646:: with SMTP id 6mr39049996pgw.321.1618411835543;
        Wed, 14 Apr 2021 07:50:35 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:35 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: [Resend RFC PATCH V2 12/12] HV/Storvsc: Add Isolation VM support for storvsc driver
Date:   Wed, 14 Apr 2021 10:49:45 -0400
Message-Id: <20210414144945.3460554-13-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM, all shared memory with host needs to mark visible
to host via hvcall. vmbus_establish_gpadl() has already done it for
netvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
mpb_desc() still need to handle. Use DMA API to map/umap these
memory during sending/receiving packet and Hyper-V DMA ops callback
will use swiotlb fucntion to allocate bounce buffer and copy data
from/to bounce buffer.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 67 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2e4fa77445fd..d271578b1811 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -21,6 +21,8 @@
 #include <linux/device.h>
 #include <linux/hyperv.h>
 #include <linux/blkdev.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -414,6 +416,11 @@ static void storvsc_on_channel_callback(void *context);
 #define STORVSC_IDE_MAX_TARGETS				1
 #define STORVSC_IDE_MAX_CHANNELS			1
 
+struct dma_range {
+	dma_addr_t dma;
+	u32 mapping_size;
+};
+
 struct storvsc_cmd_request {
 	struct scsi_cmnd *cmd;
 
@@ -427,6 +434,8 @@ struct storvsc_cmd_request {
 	u32 payload_sz;
 
 	struct vstor_packet vstor_packet;
+	u32 hvpg_count;
+	struct dma_range *dma_range;
 };
 
 
@@ -1236,6 +1245,7 @@ static void storvsc_on_channel_callback(void *context)
 	const struct vmpacket_descriptor *desc;
 	struct hv_device *device;
 	struct storvsc_device *stor_device;
+	int i;
 
 	if (channel->primary_channel != NULL)
 		device = channel->primary_channel->device_obj;
@@ -1249,6 +1259,8 @@ static void storvsc_on_channel_callback(void *context)
 	foreach_vmbus_pkt(desc, channel) {
 		void *packet = hv_pkt_data(desc);
 		struct storvsc_cmd_request *request;
+		enum dma_data_direction dir;
+		u32 attrs;
 		u64 cmd_rqst;
 
 		cmd_rqst = vmbus_request_addr(&channel->requestor,
@@ -1261,6 +1273,22 @@ static void storvsc_on_channel_callback(void *context)
 
 		request = (struct storvsc_cmd_request *)(unsigned long)cmd_rqst;
 
+		if (request->vstor_packet.vm_srb.data_in == READ_TYPE)
+			dir = DMA_FROM_DEVICE;
+		 else
+			dir = DMA_TO_DEVICE;
+
+		if (request->dma_range) {
+			for (i = 0; i < request->hvpg_count; i++)
+				dma_unmap_page_attrs(&device->device,
+						request->dma_range[i].dma,
+						request->dma_range[i].mapping_size,
+						request->vstor_packet.vm_srb.data_in
+						     == READ_TYPE ?
+						DMA_FROM_DEVICE : DMA_TO_DEVICE, attrs);
+			kfree(request->dma_range);
+		}
+
 		if (request == &stor_device->init_request ||
 		    request == &stor_device->reset_request) {
 			memcpy(&request->vstor_packet, packet,
@@ -1682,8 +1710,10 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct scatterlist *cur_sgl;
 	struct vmbus_packet_mpb_array  *payload;
+	enum dma_data_direction dir;
 	u32 payload_sz;
 	u32 length;
+	u32 attrs;
 
 	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
 		/*
@@ -1722,14 +1752,17 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	case DMA_TO_DEVICE:
 		vm_srb->data_in = WRITE_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_OUT;
+		dir = DMA_TO_DEVICE;
 		break;
 	case DMA_FROM_DEVICE:
 		vm_srb->data_in = READ_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_DATA_IN;
+		dir = DMA_FROM_DEVICE;
 		break;
 	case DMA_NONE:
 		vm_srb->data_in = UNKNOWN_TYPE;
 		vm_srb->win8_extension.srb_flags |= SRB_FLAGS_NO_DATA_TRANSFER;
+		dir = DMA_NONE;
 		break;
 	default:
 		/*
@@ -1786,6 +1819,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		hvpgoff = sgl->offset >> HV_HYP_PAGE_SHIFT;
 
 		cur_sgl = sgl;
+
+		cmd_request->dma_range = kzalloc(sizeof(struct dma_range) * hvpg_count,
+			      GFP_ATOMIC);
+		if (!cmd_request->dma_range)
+			return -ENOMEM;
+
 		for (i = 0; i < hvpg_count; i++) {
 			/*
 			 * 'i' is the index of hv pages in the payload and
@@ -1805,6 +1844,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 			 */
 			unsigned int hvpgoff_in_page =
 				(i + hvpgoff) % NR_HV_HYP_PAGES_IN_PAGE;
+			dma_addr_t dma;
+			u32 size;
 
 			/*
 			 * Two cases that we need to fetch a page:
@@ -1817,8 +1858,28 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 				cur_sgl = sg_next(cur_sgl);
 			}
 
-			payload->range.pfn_array[i] = hvpfn + hvpgoff_in_page;
+			size = min(HV_HYP_PAGE_SIZE - offset_in_hvpg, (unsigned long)length);
+			dma = dma_map_page_attrs(&dev->device,
+						 pfn_to_page(hvpfn),
+						 offset_in_hvpg, size,
+						 scmnd->sc_data_direction, attrs);
+			if (dma_mapping_error(&dev->device, dma)) {
+				pr_warn("dma map error.\n");
+				ret = -ENOMEM;
+				goto free_dma_range;
+			}
+
+			if (offset_in_hvpg) {
+				payload->range.offset = dma & ~HV_HYP_PAGE_MASK;
+				offset_in_hvpg = 0;
+			}
+
+			cmd_request->dma_range[i].dma = dma;
+			cmd_request->dma_range[i].mapping_size = size;
+			payload->range.pfn_array[i] = dma >> HV_HYP_PAGE_SHIFT;
+			length -= size;
 		}
+		cmd_request->hvpg_count = hvpg_count;
 	}
 
 	cmd_request->payload = payload;
@@ -1836,6 +1897,10 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	}
 
 	return 0;
+
+free_dma_range:
+	kfree(cmd_request->dma_range);
+	return ret;
 }
 
 static struct scsi_host_template scsi_driver = {
-- 
2.25.1

