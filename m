Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78C3D9131
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhG1Ox6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbhG1Ox3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:53:29 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4076AC06179C;
        Wed, 28 Jul 2021 07:53:25 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d17so2973478plh.10;
        Wed, 28 Jul 2021 07:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VC37tGvMnXRZFIidUDGGN3vUKeS5FmCKfybWMaE6JMY=;
        b=lh23Rm3aSU+fQaWGX59d9ft0lbpKg8YIgoW0ciAzDdoAicxxQA0REzzkXmGjNCrEGP
         4pj1gCuNR9MTox0HLcJ503kNlHTUux4o7GZcKj/lKGsRUPw3RikRbxR7SpBPKWxYqYVu
         xAkYNbZiR4WUrdjn5boJtiK7CDtDNXreVlifiqilqBV4N4cuNWP0fTtRbA3rbN6pN/1s
         RYiI6hEL9EIBT5ckmBGD6ZOx1hpJvBVU8Xhh1J6gBmIKH8LauQKmeMyjVtVR+wWihnkz
         OcxTQVpkPzEcil6Nqk2MWCZvGf7dWM8uECT0LE5ukPyeTp3SNM2AGww5Jr8E4esn0lwY
         7JMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VC37tGvMnXRZFIidUDGGN3vUKeS5FmCKfybWMaE6JMY=;
        b=knQhaD86MiLED0EHXCgeYwA6rLFI2wHeemUWY+siQ/amJHwUiupLRDFliArUXOyopN
         9v5fCSidjOJit7qQRq924j9YMLah1VL7zbfbJr8vVJCn/fIAo02pVCu4LidWOzTKhh+Y
         H8emOoE8XdxiWPW+DEHJ9ROoPTdRLuaeY1dPnfHZZF3K7jHkYElnxBrrxbh64PIesAiE
         QpIYuYlYCBY3P+3ee9RflTnSY3DwOmKky3n/OcFdg20PAXAMhEn1NqNwT5fRro1+jcsK
         iSRVMKGz4V7l9PasBxJkPrZ4awAHFkGJLZot2UfEnoo/0vW/c65jT4Oc64U/knxDtSWg
         ghPg==
X-Gm-Message-State: AOAM530ZL9jZWnIxMHQz87XLKZwxfptmr5TrJpPccJTbAl2Z8o2JSlQb
        yYCg0VZpgh3akpcwpPKdvrU=
X-Google-Smtp-Source: ABdhPJwd/hsA9oYd6C/i3E05WDHsS/g/X1F+CQSyKJUNUTpiXXONzBW9uqRKafI8icCemeeqwaRYFg==
X-Received: by 2002:a05:6a00:1889:b029:332:13d6:a6eb with SMTP id x9-20020a056a001889b029033213d6a6ebmr269004pfh.25.1627484004862;
        Wed, 28 Jul 2021 07:53:24 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:3823:141e:6d51:f0ad])
        by smtp.gmail.com with ESMTPSA id n134sm277558pfd.89.2021.07.28.07.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:53:24 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
Subject: [PATCH 07/13] HV/Vmbus: Add SNP support for VMbus channel initiate message
Date:   Wed, 28 Jul 2021 10:52:22 -0400
Message-Id: <20210728145232.285861-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728145232.285861-1-ltykernel@gmail.com>
References: <20210728145232.285861-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

The monitor pages in the CHANNELMSG_INITIATE_CONTACT msg are shared
with host in Isolation VM and so it's necessary to use hvcall to set
them visible to host. In Isolation VM with AMD SEV SNP, the access
address should be in the extra space which is above shared gpa
boundary. So remap these pages into the extra address(pa +
shared_gpa_boundary).

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/connection.c   | 65 +++++++++++++++++++++++++++++++++++++++
 drivers/hv/hyperv_vmbus.h |  1 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 6d315c1465e0..e6a7bae036a8 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -19,6 +19,7 @@
 #include <linux/vmalloc.h>
 #include <linux/hyperv.h>
 #include <linux/export.h>
+#include <linux/io.h>
 #include <asm/mshyperv.h>
 
 #include "hyperv_vmbus.h"
@@ -104,6 +105,12 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 
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
@@ -148,6 +155,31 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		return -ECONNREFUSED;
 	}
 
+	if (hv_is_isolation_supported()) {
+		vmbus_connection.monitor_pages_va[0]
+			= vmbus_connection.monitor_pages[0];
+		vmbus_connection.monitor_pages[0]
+			= memremap(msg->monitor_page1, HV_HYP_PAGE_SIZE,
+				   MEMREMAP_WB);
+		if (!vmbus_connection.monitor_pages[0])
+			return -ENOMEM;
+
+		vmbus_connection.monitor_pages_va[1]
+			= vmbus_connection.monitor_pages[1];
+		vmbus_connection.monitor_pages[1]
+			= memremap(msg->monitor_page2, HV_HYP_PAGE_SIZE,
+				   MEMREMAP_WB);
+		if (!vmbus_connection.monitor_pages[1]) {
+			memunmap(vmbus_connection.monitor_pages[0]);
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
 
@@ -159,6 +191,7 @@ int vmbus_connect(void)
 	struct vmbus_channel_msginfo *msginfo = NULL;
 	int i, ret = 0;
 	__u32 version;
+	u64 pfn[2];
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
@@ -216,6 +249,16 @@ int vmbus_connect(void)
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
@@ -284,6 +327,8 @@ int vmbus_connect(void)
 
 void vmbus_disconnect(void)
 {
+	u64 pfn[2];
+
 	/*
 	 * First send the unload request to the host.
 	 */
@@ -303,6 +348,26 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
+	if (hv_is_isolation_supported()) {
+		if (vmbus_connection.monitor_pages_va[0]) {
+			memunmap(vmbus_connection.monitor_pages[0]);
+			vmbus_connection.monitor_pages[0]
+				= vmbus_connection.monitor_pages_va[0];
+			vmbus_connection.monitor_pages_va[0] = NULL;
+		}
+
+		if (vmbus_connection.monitor_pages_va[1]) {
+			memunmap(vmbus_connection.monitor_pages[1]);
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

