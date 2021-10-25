Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E954B439631
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhJYMYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbhJYMYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:24:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60B3C061230;
        Mon, 25 Oct 2021 05:21:34 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id r5so3215858pls.1;
        Mon, 25 Oct 2021 05:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+e9i1j4UbbSysykywCgKGACAoEqAJklSJx0zDl7vqfw=;
        b=AvjvC/YLJB4k7ntGp94FVgt0fLUESxLJ4KTQTaxtjwxNzVa/zrhAwzfPY4Az7qecjI
         5y5yXpQ2Q2QKHDteoTsYG7Oss+OiBQmgtwKRlT7u+nzQpfAKDuAQ3t6+qWY+RpTh0LBm
         1K9hVJpbVX0MNErosSTGGTmogLBP9f9RpIqm0xmPkz7iMgZ2en2bsZdj082yViS0t1Of
         l5u5rA8HFwyU9/kLLdb0lkFzAr+KjlSGGkQ4pl5YqycWT9yDcUZfyY9RhAGRe0EPPQoy
         2cySmO/vUQE0acz7BCc+lTDMwnmcyF7aT3p5K8lIhdLIvv28ovW0c5zhl7qTCbdh5Faz
         +ZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+e9i1j4UbbSysykywCgKGACAoEqAJklSJx0zDl7vqfw=;
        b=hcy1fgsdP4LPSiV4P8ag8TB/tW9V63mVwbP/tdavj4QLWDRoAeaOGFEE2cUS9bFbsP
         bXsYfoN5lqHdK3afZswZJJewmoZ1TSpl4dCf4U4DVW3VAhPSoufsdy9fqPdZAPNm8Ot7
         mUNbNToYbaTSRJu/XMluJjaY/+C9/aRMASY4qHy6eMDegVAtXA3VcPmQRVXG9N3pV42G
         qLflZ/bx4C7jlYC6x7uqq3tc5vXHoYxB2fGRlhIAZqhYtxujpUWekTPXHvBhwMjz9Odv
         14MGGZsPO9/Kc1QSpRUvZSRmQT5AuOFhbYtn5ce0e/e5dq/i16kfycWYir4rsV34iXCv
         m+Ug==
X-Gm-Message-State: AOAM532K1zjemr0yMCAM6xFva4KhtyynURscvsnLWn1cb4zaIz5FRkAx
        mQeLuNPLoiJAit2sCAhsPEQ=
X-Google-Smtp-Source: ABdhPJx1/AR0qB0jpQn88IE7C7QJNFUjA2YUmooYb7IMlzFN/02ccxrCutamhrXMaAcr0hqpY+P1Uw==
X-Received: by 2002:a17:90a:ba03:: with SMTP id s3mr19102903pjr.116.1635164491957;
        Mon, 25 Oct 2021 05:21:31 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:31 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        mikelley@microsoft.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, sfr@canb.auug.org.au, david@redhat.com,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V9 8/9] Drivers: hv: vmbus: Add SNP support for VMbus channel initiate  message
Date:   Mon, 25 Oct 2021 08:21:13 -0400
Message-Id: <20211025122116.264793-9-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
References: <20211025122116.264793-1-ltykernel@gmail.com>
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

Introduce monitor_pages_original[] in the struct vmbus_connection
to store monitor page virtual address returned by hv_alloc_hyperv_
zeroed_page() and free monitor page via monitor_pages_original in
the vmbus_disconnect(). The monitor_pages[] is to used to access
monitor page and it is initialized to be equal with monitor_pages_
original. The monitor_pages[] will be overridden in the isolation VM
with va of extra address. Introduce monitor_pages_pa[] to store
monitor pages' physical address and use it to populate pa in the
initiate msg.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v6:
	*  Add comment about calling memunmap() in the non-snp IVM.

Change since v5:
	*  change vmbus_connection.monitor_pages_pa type from
	   unsigned long to phys_addr_t
	*  Plus vmbus_connection.monitor_pages_pa with ms_hyperv.
	   shared_gpa_boundary only in the IVM with AMD SEV.

Change since v4:
	* Introduce monitor_pages_pa[] to store monitor pages' physical
	  address and use it to populate pa in the initiate msg.
	* Move code of mapping moniter pages in extra address into
	  vmbus_connect().

Change since v3:
	* Rename monitor_pages_va with monitor_pages_original
	* free monitor page via monitor_pages_original and
	  monitor_pages is used to access monitor page.

Change since v1:
        * Not remap monitor pages in the non-SNP isolation VM.
---
 drivers/hv/connection.c   | 95 ++++++++++++++++++++++++++++++++++++---
 drivers/hv/hyperv_vmbus.h |  2 +
 2 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8820ae68f20f..a3d8be8d6cfb 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -19,6 +19,8 @@
 #include <linux/vmalloc.h>
 #include <linux/hyperv.h>
 #include <linux/export.h>
+#include <linux/io.h>
+#include <linux/set_memory.h>
 #include <asm/mshyperv.h>
 
 #include "hyperv_vmbus.h"
@@ -102,8 +104,9 @@ int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo, u32 version)
 		vmbus_connection.msg_conn_id = VMBUS_MESSAGE_CONNECTION_ID;
 	}
 
-	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
-	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
+	msg->monitor_page1 = vmbus_connection.monitor_pages_pa[0];
+	msg->monitor_page2 = vmbus_connection.monitor_pages_pa[1];
+
 	msg->target_vcpu = hv_cpu_number_to_vp_number(VMBUS_CONNECT_CPU);
 
 	/*
@@ -216,6 +219,65 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
+	vmbus_connection.monitor_pages_original[0]
+		= vmbus_connection.monitor_pages[0];
+	vmbus_connection.monitor_pages_original[1]
+		= vmbus_connection.monitor_pages[1];
+	vmbus_connection.monitor_pages_pa[0]
+		= virt_to_phys(vmbus_connection.monitor_pages[0]);
+	vmbus_connection.monitor_pages_pa[1]
+		= virt_to_phys(vmbus_connection.monitor_pages[1]);
+
+	if (hv_is_isolation_supported()) {
+		ret = set_memory_decrypted((unsigned long)
+					   vmbus_connection.monitor_pages[0],
+					   1);
+		ret |= set_memory_decrypted((unsigned long)
+					    vmbus_connection.monitor_pages[1],
+					    1);
+		if (ret)
+			goto cleanup;
+
+		/*
+		 * Isolation VM with AMD SNP needs to access monitor page via
+		 * address space above shared gpa boundary.
+		 */
+		if (hv_isolation_type_snp()) {
+			vmbus_connection.monitor_pages_pa[0] +=
+				ms_hyperv.shared_gpa_boundary;
+			vmbus_connection.monitor_pages_pa[1] +=
+				ms_hyperv.shared_gpa_boundary;
+
+			vmbus_connection.monitor_pages[0]
+				= memremap(vmbus_connection.monitor_pages_pa[0],
+					   HV_HYP_PAGE_SIZE,
+					   MEMREMAP_WB);
+			if (!vmbus_connection.monitor_pages[0]) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+
+			vmbus_connection.monitor_pages[1]
+				= memremap(vmbus_connection.monitor_pages_pa[1],
+					   HV_HYP_PAGE_SIZE,
+					   MEMREMAP_WB);
+			if (!vmbus_connection.monitor_pages[1]) {
+				ret = -ENOMEM;
+				goto cleanup;
+			}
+		}
+
+		/*
+		 * Set memory host visibility hvcall smears memory
+		 * and so zero monitor pages here.
+		 */
+		memset(vmbus_connection.monitor_pages[0], 0x00,
+		       HV_HYP_PAGE_SIZE);
+		memset(vmbus_connection.monitor_pages[1], 0x00,
+		       HV_HYP_PAGE_SIZE);
+
+	}
+
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
 			  GFP_KERNEL);
@@ -303,10 +365,31 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
-	vmbus_connection.monitor_pages[0] = NULL;
-	vmbus_connection.monitor_pages[1] = NULL;
+	if (hv_is_isolation_supported()) {
+		/*
+		 * memunmap() checks input address is ioremap address or not
+		 * inside. It doesn't unmap any thing in the non-SNP CVM and
+		 * so not check CVM type here.
+		 */
+		memunmap(vmbus_connection.monitor_pages[0]);
+		memunmap(vmbus_connection.monitor_pages[1]);
+
+		set_memory_encrypted((unsigned long)
+			vmbus_connection.monitor_pages_original[0],
+			1);
+		set_memory_encrypted((unsigned long)
+			vmbus_connection.monitor_pages_original[1],
+			1);
+	}
+
+	hv_free_hyperv_page((unsigned long)
+		vmbus_connection.monitor_pages_original[0]);
+	hv_free_hyperv_page((unsigned long)
+		vmbus_connection.monitor_pages_original[1]);
+	vmbus_connection.monitor_pages_original[0] =
+		vmbus_connection.monitor_pages[0] = NULL;
+	vmbus_connection.monitor_pages_original[1] =
+		vmbus_connection.monitor_pages[1] = NULL;
 }
 
 /*
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 42f3d9d123a1..d0a5232a1c3e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -240,6 +240,8 @@ struct vmbus_connection {
 	 * is child->parent notification
 	 */
 	struct hv_monitor_page *monitor_pages[2];
+	void *monitor_pages_original[2];
+	phys_addr_t monitor_pages_pa[2];
 	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
-- 
2.25.1

