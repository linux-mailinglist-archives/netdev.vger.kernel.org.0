Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A641DA99
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350254AbhI3NIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351282AbhI3NHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:07:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E68C061773;
        Thu, 30 Sep 2021 06:06:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a73so3208192pge.0;
        Thu, 30 Sep 2021 06:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cm4jgELk6Xp/hX/9BaiZTFfLPzmGCIgbhZco7tEeQqs=;
        b=MH6mI48j2sG8+TBin/n9o5VFA2a7oaoljutktiMjigjG6rh2zBV4QBgY1gDbnd+FUd
         0lWVKp+vLdeit+vM1JTBfLzrp3EwV/i0gkL/v9r0GmUH0DxMk629Ph/SKNwP6BKEN9Z2
         mvXrUaYWdcBa6V5GGMXBwac/cv12reKQWKDwvGSO2HqrVKGa3R34CHn+eG56blhE76uM
         NilT5dXAZ4tN/5rNRSMylJ3eA2hvo63wzJCw53bRYFvc6aM5dRnV6Q/O168uDlagLSot
         5gWKb5jLD+j19h1anNimVOd73MLB6hqwvA+5wIevrqdYPI8TBWNZQUSc7AXFD4mv5tHU
         j2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cm4jgELk6Xp/hX/9BaiZTFfLPzmGCIgbhZco7tEeQqs=;
        b=vS7NUPVM3AacfZWkQCj5D4cwWShb/uAY0r50TOys1l9ZJSbM+ux3X0OWk478O/fPoI
         datu3Pgz6mDnkGV48Ckpt+NOn6CzhqhrAQSTfVj5vD0MHUVj8SfINjQz8/LtX8/Z9ivn
         pANl13DZMTj6tpy1SxWy7aUbekb33OMDESAhtYbFqRaGWLroptYAbML3lBGK3q97YyB9
         wPqStdTGVTzTo/9/lAjwvFziqElOig8Sb3WP1iYzFscWMpOaRCSS7qqtglrsHNHUTNqJ
         1UrlmF9ZPSeFomyEiCoWK6pudkjimS3xXxssnkEX3bJXvm17OYGok9o5z4Rfnccb0kq8
         CoAA==
X-Gm-Message-State: AOAM532tSAmYEO7NnmxJ41ZKO9WeMNE0mVY1GFp2xPpf5JGeuKtjxxSJ
        bixlV/kmG4fRO6qWHr1oql0=
X-Google-Smtp-Source: ABdhPJwNukM0TqHOon4Icu8RwDqyCno+LHPa5gi5+tU8gD6a/aQQpItB0dTaD9KbHpa881M1EWOGIA==
X-Received: by 2002:a62:8141:0:b0:447:96be:ac2 with SMTP id t62-20020a628141000000b0044796be0ac2mr5398039pfd.61.1633007161074;
        Thu, 30 Sep 2021 06:06:01 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:35:a72f:86cf:2cc5:8116])
        by smtp.gmail.com with ESMTPSA id v7sm3072134pff.195.2021.09.30.06.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:06:00 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 7/8] Drivers: hv: vmbus: Add SNP support for VMbus channel initiate  message
Date:   Thu, 30 Sep 2021 09:05:43 -0400
Message-Id: <20210930130545.1210298-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930130545.1210298-1-ltykernel@gmail.com>
References: <20210930130545.1210298-1-ltykernel@gmail.com>
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

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
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
 drivers/hv/connection.c   | 90 ++++++++++++++++++++++++++++++++++++---
 drivers/hv/hyperv_vmbus.h |  2 +
 2 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8820ae68f20f..7fac8d99541c 100644
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
@@ -303,10 +365,26 @@ void vmbus_disconnect(void)
 		vmbus_connection.int_page = NULL;
 	}
 
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[0]);
-	hv_free_hyperv_page((unsigned long)vmbus_connection.monitor_pages[1]);
-	vmbus_connection.monitor_pages[0] = NULL;
-	vmbus_connection.monitor_pages[1] = NULL;
+	if (hv_is_isolation_supported()) {
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

