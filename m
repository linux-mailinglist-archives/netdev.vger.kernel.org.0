Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A05735F6D1
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352112AbhDNOvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351963AbhDNOuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:50:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1F2C06138D;
        Wed, 14 Apr 2021 07:50:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u15so1688487plf.10;
        Wed, 14 Apr 2021 07:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CewzcGN2queQHJd+J82WZLFtEsY18cNfiGHIrQj3GfM=;
        b=nOk4uGV2612icoE6KiiMnihVY5JHClv+KaiNAxHeX6msxOQj9xeFgeyXgzuV9Sd7Ij
         3EGstiuG7E5ZaMqZazQ8zFoKTzoT62iMzgmBH+tZh+iYpEEsK600XCCcKCclZh0Y0x/u
         lPI4sDQZdZAMWqD+sOUOmLSztUBF0emqbSbT/bkw4pOBBCkruQo/ok2VzdifznwsKJMs
         ocsgxtRZuZhwa/4H3uMNQQH/MJK+ZGYBL5Une8lbE2Hi2dVG9kDPFVwgbdYojKKilNwO
         hZojnsV4Uidmr/W8cT1MCoZwuTcUd6+620Huo4X0ZKIUTvMpEIF6giQ2Vs7uJP0RlbHX
         V1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CewzcGN2queQHJd+J82WZLFtEsY18cNfiGHIrQj3GfM=;
        b=A2zSNmAY/eNh5iTFCqMjc0M/4kLDDRmqA3/NStBj5XrJAmzjjRSqHDnLv4z1u5OikC
         ZziqdwZTqEM1Nhfq5+ogcI+tnzhPFInfkSrKi4LiTgPE8LT7rxqKylt8GS5zZNDWA7Ac
         bG4s8GjJiXwuYREhwknBxWvks0LxqvnAPIqLtEbrlF0XCsm/85uhVW7588aWZ9PJbFih
         r+5CFLd05zckaqfqYhFPrOx8pP7I3fSVFH1bR4N/R+4/jX3T972kHGWFzHBWgeuy3Top
         iDhq1zrPx8snO8fl7hJxuiX6cbd0F2uCuCQinE12Zjfd35F0mVtnYtnuRNdjjXQ0guPI
         +RyQ==
X-Gm-Message-State: AOAM5320WSVKha8CREFKYGwvPHXJSx8RlmNzdB4gp5i3eNeOneaLgjsg
        fFWY45IQBzE0lOM+VcgNrnk=
X-Google-Smtp-Source: ABdhPJwbB1PldwXbeyiSuCQkyOEtifm++hxPqnW8Qh9Ekcj5s31E29ArK58tbba9T8p/t1IP5sOX7w==
X-Received: by 2002:a17:90a:5306:: with SMTP id x6mr4089960pjh.39.1618411830278;
        Wed, 14 Apr 2021 07:50:30 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:ebad:12c1:f579:e332])
        by smtp.gmail.com with ESMTPSA id w67sm17732522pgb.87.2021.04.14.07.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:50:29 -0700 (PDT)
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
Subject: [Resend RFC PATCH V2 06/12] HV/Vmbus: Add SNP support for VMbus channel initiate message
Date:   Wed, 14 Apr 2021 10:49:39 -0400
Message-Id: <20210414144945.3460554-7-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414144945.3460554-1-ltykernel@gmail.com>
References: <20210414144945.3460554-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The physical address of monitor pages in the CHANNELMSG_INITIATE_CONTACT
msg should be in the extra address space for SNP support and these
pages also should be accessed via the extra address space inside Linux
guest and remap the extra address by ioremap function.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/connection.c   | 62 +++++++++++++++++++++++++++++++++++++++
 drivers/hv/hyperv_vmbus.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 79bca653dce9..a0be9c11d737 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -101,6 +101,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
+
+	if (hv_isolation_type_snp()) {
+		msg->monitor_page1 += ms_hyperv.shared_gpa_boundary;
+		msg->monitor_page2 += ms_hyperv.shared_gpa_boundary;
+	}
+
 	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
 	/*
@@ -145,6 +151,29 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		return -ECONNREFUSED;
 	}
 
+	if (hv_isolation_type_snp()) {
+		vmbus_connection.monitor_pages_va[0]
+			= vmbus_connection.monitor_pages[0];
+		vmbus_connection.monitor_pages[0]
+			= ioremap_cache(msg->monitor_page1, HV_HYP_PAGE_SIZE);
+		if (!vmbus_connection.monitor_pages[0])
+			return -ENOMEM;
+
+		vmbus_connection.monitor_pages_va[1]
+			= vmbus_connection.monitor_pages[1];
+		vmbus_connection.monitor_pages[1]
+			= ioremap_cache(msg->monitor_page2, HV_HYP_PAGE_SIZE);
+		if (!vmbus_connection.monitor_pages[1]) {
+			vunmap(vmbus_connection.monitor_pages[0]);
+			return -ENOMEM;
+		}
+
+		memset(vmbus_connection.monitor_pages[0], 0x00,
+		       HV_HYP_PAGE_SIZE);
+		memset(vmbus_connection.monitor_pages[1], 0x00,
+		       HV_HYP_PAGE_SIZE);
+	}
+
 	return ret;
 }
 
@@ -156,6 +185,7 @@ int vmbus_connect(void)
 	struct vmbus_channel_msginfo *msginfo = NULL;
 	int i, ret = 0;
 	__u32 version;
+	u64 pfn[2];
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
@@ -213,6 +243,16 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
+	if (hv_isolation_type_snp()) {
+		pfn[0] = virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
+		pfn[1] = virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
+		if (hv_mark_gpa_visibility(2, pfn,
+				VMBUS_PAGE_VISIBLE_READ_WRITE)) {
+			ret = -EFAULT;
+			goto cleanup;
+		}
+	}
+
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
 			  GFP_KERNEL);
@@ -279,6 +319,8 @@ int vmbus_connect(void)
 
 void vmbus_disconnect(void)
 {
+	u64 pfn[2];
+
 	/*
 	 * First send the unload request to the host.
 	 */
@@ -298,6 +340,26 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
+	if (hv_isolation_type_snp()) {
+		if (vmbus_connection.monitor_pages_va[0]) {
+			vunmap(vmbus_connection.monitor_pages[0]);
+			vmbus_connection.monitor_pages[0]
+				= vmbus_connection.monitor_pages_va[0];
+			vmbus_connection.monitor_pages_va[0] = NULL;
+		}
+
+		if (vmbus_connection.monitor_pages_va[1]) {
+			vunmap(vmbus_connection.monitor_pages[1]);
+			vmbus_connection.monitor_pages[1]
+				= vmbus_connection.monitor_pages_va[1];
+			vmbus_connection.monitor_pages_va[1] = NULL;
+		}
+
+		pfn[0] = virt_to_hvpfn(vmbus_connection.monitor_pages[0]);
+		pfn[1] = virt_to_hvpfn(vmbus_connection.monitor_pages[1]);
+		hv_mark_gpa_visibility(2, pfn, VMBUS_PAGE_NOT_VISIBLE);
+	}
+
 	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
 	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
 	vmbus_connection.monitor_pages[0] = NULL;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 9416e09ebd58..0778add21a9c 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -240,6 +240,7 @@ struct vmbus_connection {
 	 * is child->parent notification
 	 */
 	struct hv_monitor_page *monitor_pages[2];
+	void *monitor_pages_va[2];
 	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
-- 
2.25.1

