Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DE939518C
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 17:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhE3PIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 11:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhE3PIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 11:08:25 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F291C061574;
        Sun, 30 May 2021 08:06:47 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d16so7049418pfn.12;
        Sun, 30 May 2021 08:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QKK0SjDRQsBHXdgV5ktTvZVGUyDxuCI7H9YXqu8ylp4=;
        b=c4gjM4Jy3YZ+/DG7gJXR32TyHNrd2AT2w1NRjMRL/cVwnE9Khie59tuur1IINr0LLL
         6PZbttSNvgl9BLFIsGHuSc+FJJmIp6Abf0SCFmm2OMKXGKumPVltWHy67nL9KV9jEyvK
         PEkAMyNbfg9acDIg1EYYlwzHuyceS5JTu6FgLVMgyuSfaM2bY1ImRe4AQpVCfcxArLyf
         2orge+sbm53BUlc2H/Pqht+gxOC5rv9V1Jvz+CQB0vMOQlMPoDaTCkjFsnL76KSZ3ys3
         7eaQ9eSv/+WkbiIZxtGq9L5QDqfVWwVAegCdGoAEYHKpEA2U7AjeuHqOCq8YttRFBnB5
         XuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QKK0SjDRQsBHXdgV5ktTvZVGUyDxuCI7H9YXqu8ylp4=;
        b=NkFVCaxcLSpVBGBt2P3k3HcNJigDAvav4DZ6orfUDH9/BKrIURCDBOGdlaUZORVsqB
         ay/wr/Rb9VEcZhpwDk2oXo5CntZLgYhZhvN1Wc9RjuS1BaJ5pH7hTwulce3YE1HxR3bm
         odPSLjoGoF9IXAjWck7eB1NRSu7x4gOLsjO74YuGo/4QBu0OojwlkfjuOX0Ec6rD8Fpa
         2Pba1zAsnN8MHS2pjIAeQQLaxJhRnCUVRUxn60z0qHFTuLzLh7dq76Z6CmtId0E2Ss8L
         qGYJCEvn0HToEP5Io3aOJW2rFA2rvExtybQh86Qwmo+Yc57+QEqAD2MErrlxILwd/Isn
         g6PQ==
X-Gm-Message-State: AOAM5315xqsN15wxgZ1tsa6/MwXGoImPFSUY8RAflxN8s+p99qiET4SQ
        zYCtf/C3X8UX672bYMFA4No=
X-Google-Smtp-Source: ABdhPJw+q9VKcKHyDWVpvxugITxjif6TDbX7YEFx343/WR9bqFMb8Oo7wu2PPv+4Bif5UQ80/Bo2xg==
X-Received: by 2002:a62:ae14:0:b029:2e9:c6ef:9856 with SMTP id q20-20020a62ae140000b02902e9c6ef9856mr2736868pff.77.1622387206687;
        Sun, 30 May 2021 08:06:46 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:9:dc2d:80ab:c3f3:1524])
        by smtp.gmail.com with ESMTPSA id b15sm8679688pfi.100.2021.05.30.08.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 08:06:46 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: [RFC PATCH V3 06/11] HV/Vmbus: Add SNP support for VMbus channel initiate message
Date:   Sun, 30 May 2021 11:06:23 -0400
Message-Id: <20210530150628.2063957-7-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530150628.2063957-1-ltykernel@gmail.com>
References: <20210530150628.2063957-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The monitor pages in the CHANNELMSG_INITIATE_CONTACT are shared
with host and so it's necessary to use hvcall to set them visible
to host. In Isolation VM with AMD SEV SNP, the access address
should be in the extra space which is above shared gpa boundary.
So remap these pages into the extra address(pa + shared_gpa_boundary).

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/connection.c   | 62 +++++++++++++++++++++++++++++++++++++++
 drivers/hv/hyperv_vmbus.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 186fd4c8acd4..389adc92f958 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -104,6 +104,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
+
+	if (hv_is_isolation_supported()) {
+		msg->monitor_page1 += ms_hyperv.shared_gpa_boundary;
+		msg->monitor_page2 += ms_hyperv.shared_gpa_boundary;
+	}
+
 	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
 	/*
@@ -148,6 +154,29 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		return -ECONNREFUSED;
 	}
 
+	if (hv_is_isolation_supported()) {
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
 
@@ -159,6 +188,7 @@ int vmbus_connect(void)
 	struct vmbus_channel_msginfo *msginfo = NULL;
 	int i, ret = 0;
 	__u32 version;
+	u64 pfn[2];
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
@@ -216,6 +246,16 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
+	if (hv_is_isolation_supported()) {
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
@@ -282,6 +322,8 @@ int vmbus_connect(void)
 
 void vmbus_disconnect(void)
 {
+	u64 pfn[2];
+
 	/*
 	 * First send the unload request to the host.
 	 */
@@ -301,6 +343,26 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
+	if (hv_is_isolation_supported()) {
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
index 42f3d9d123a1..40bc0eff6665 100644
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

