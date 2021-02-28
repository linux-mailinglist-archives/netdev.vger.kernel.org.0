Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1993272BD
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhB1PFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 10:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhB1PEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 10:04:54 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2F0C061786;
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u12so9437064pjr.2;
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afDh1ezD+1nZvgNHAzBZmDH+i7mNNVna0YI1LzLuZk4=;
        b=F6AOTF9aaRw70RjmvFvKFwDEI+xlUD5/9YCEMhLVTMAqBak/RKEeOax3ElrdXBMhGH
         uS8TdBkUqJ8+z6s63H4yZ7qu/ocBkQj1KfZ0yKz2skXQZDqs7r39IjB9a1hIedJIhTSp
         6wbKE2egPKO7qYTsdFDDWPvPPJaSnLo4nHNgFy2LY3LE/KJfmxKbiWtQ2URkkjvRpN8v
         SudiPFpEdVLMDTccu5+amC4/npNfqnhRKHH94SoYPnI1nT3lI8lkHmTiLYwpil5m7GrY
         /b9ydhTcN4RDxh4ilYXlmSb2cMnCPnAo3FDqNtaglg5Zi8BZ9YbkJ0ue8YWvqXBLnlHN
         yZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afDh1ezD+1nZvgNHAzBZmDH+i7mNNVna0YI1LzLuZk4=;
        b=bQsI1fgkLy5GiOBFJIj8q0QQqP4KYAENMqssEXWzb6mX9MlU0Q8gRiB8mZ4tI3p1Ri
         Vk3IYf9DSipnIZhFLntLXaI420/CrXQTzOG4JPTbVPht3mrtieoa9JDRk1KoJyvS3KAk
         V/HKjr+izPob/hX9VZjYHtt2E3blfodm+zMulsBSms5LhnE6o2WtUAz5HFWer7La0n/t
         kjZ7QG6e4gM0INzLCmh8Fn4GfAxnd+H7A8XsY+AuwW5rjkVpt5a+e0OSyveHQDYpnxdi
         g67xnqVZZ+ydLcP9GqJYvvuGc8lSr2KeAnkIqHlvzXAIGdLxkCr/ZwdFymwNLccki46s
         GfCA==
X-Gm-Message-State: AOAM530m8zlI2E98KuXzFqHS0ryubD45DJg8QnQDPs4CR2R7Ss4iKNlq
        QJiRI2qp4eEJh6L5S/6Nk04=
X-Google-Smtp-Source: ABdhPJx5m2fsI8Kmpe9Q2F0GcqjRQzrE6put3+t6RaMSSlY52R4Lkc+tj0QgE21NSefk7DITqp5uSA==
X-Received: by 2002:a17:90a:4fc1:: with SMTP id q59mr13214973pjh.129.1614524653406;
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:561f:afde:af07:8820])
        by smtp.gmail.com with ESMTPSA id 142sm8391331pfz.196.2021.02.28.07.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 07:04:13 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: [RFC PATCH 2/12] x86/Hyper-V: Add new hvcall guest address host visibility support
Date:   Sun, 28 Feb 2021 10:03:05 -0500
Message-Id: <20210228150315.2552437-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210228150315.2552437-1-ltykernel@gmail.com>
References: <20210228150315.2552437-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Add new hvcall guest address host visibility support. Mark vmbus
ring buffer visible to host when create gpadl buffer and mark back
to not visible when tear down gpadl buffer.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Co-Developed-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 13 ++++++++
 arch/x86/include/asm/mshyperv.h    |  4 +--
 arch/x86/kernel/cpu/mshyperv.c     | 46 ++++++++++++++++++++++++++
 drivers/hv/channel.c               | 53 ++++++++++++++++++++++++++++--
 drivers/net/hyperv/hyperv_net.h    |  1 +
 drivers/net/hyperv/netvsc.c        |  9 +++--
 drivers/uio/uio_hv_generic.c       |  6 ++--
 include/asm-generic/hyperv-tlfs.h  |  1 +
 include/linux/hyperv.h             |  3 +-
 9 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index fb1893a4c32b..d22b1c3f425a 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -573,4 +573,17 @@ enum hv_interrupt_type {
 
 #include <asm-generic/hyperv-tlfs.h>
 
+/* All input parameters should be in single page. */
+#define HV_MAX_MODIFY_GPA_REP_COUNT		\
+	((PAGE_SIZE - 2 * sizeof(u64)) / (sizeof(u64)))
+
+/* HvCallModifySparseGpaPageHostVisibility hypercall */
+struct hv_input_modify_sparse_gpa_page_host_visibility {
+	u64 partition_id;
+	u32 host_visibility:2;
+	u32 reserved0:30;
+	u32 reserved1;
+	u64 gpa_page_list[HV_MAX_MODIFY_GPA_REP_COUNT];
+} __packed;
+
 #endif
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index ccf60a809a17..1e8275d35c1f 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -262,13 +262,13 @@ static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
 	msi_entry->address.as_uint32 = msi_desc->msg.address_lo;
 	msi_entry->data.as_uint32 = msi_desc->msg.data;
 }
-
 struct irq_domain *hv_create_pci_msi_domain(void);
 
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 		struct hv_interrupt_entry *entry);
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
-
+int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility);
+int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility);
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index e88bc296afca..347c32eac8fd 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -37,6 +37,8 @@
 bool hv_root_partition;
 EXPORT_SYMBOL_GPL(hv_root_partition);
 
+#define HV_PARTITION_ID_SELF ((u64)-1)
+
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
 
@@ -477,3 +479,47 @@ const __initconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.init.msi_ext_dest_id	= ms_hyperv_msi_ext_dest_id,
 	.init.init_platform	= ms_hyperv_init_platform,
 };
+
+int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)
+{
+	struct hv_input_modify_sparse_gpa_page_host_visibility **input_pcpu;
+	struct hv_input_modify_sparse_gpa_page_host_visibility *input;
+	u16 pages_processed;
+	u64 hv_status;
+	unsigned long flags;
+
+	/* no-op if partition isolation is not enabled */
+	if (!hv_is_isolation_supported())
+		return 0;
+
+	if (count > HV_MAX_MODIFY_GPA_REP_COUNT) {
+		pr_err("Hyper-V: GPA count:%d exceeds supported:%lu\n", count,
+			HV_MAX_MODIFY_GPA_REP_COUNT);
+		return -EINVAL;
+	}
+
+	local_irq_save(flags);
+	input_pcpu = (struct hv_input_modify_sparse_gpa_page_host_visibility **)
+			this_cpu_ptr(hyperv_pcpu_input_arg);
+	input = *input_pcpu;
+	if (unlikely(!input)) {
+		local_irq_restore(flags);
+		return -1;
+	}
+
+	input->partition_id = HV_PARTITION_ID_SELF;
+	input->host_visibility = visibility;
+	input->reserved0 = 0;
+	input->reserved1 = 0;
+	memcpy((void *)input->gpa_page_list, pfn, count * sizeof(*pfn));
+	hv_status = hv_do_rep_hypercall(
+			HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY, count,
+			0, input, &pages_processed);
+	local_irq_restore(flags);
+
+	if (!(hv_status & HV_HYPERCALL_RESULT_MASK))
+		return 0;
+
+	return -EFAULT;
+}
+EXPORT_SYMBOL(hv_mark_gpa_visibility);
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index daa21cc72beb..204e6f3598a5 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -237,6 +237,38 @@ int vmbus_send_modifychannel(u32 child_relid, u32 target_vp)
 }
 EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
 
+/*
+ * hv_set_mem_host_visibility - Set host visibility for specified memory.
+ */
+int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)
+{
+	int i, pfn;
+	int pagecount = size >> HV_HYP_PAGE_SHIFT;
+	u64 *pfn_array;
+	int ret = 0;
+
+	if (!hv_isolation_type_snp())
+		return 0;
+
+	pfn_array = vzalloc(HV_HYP_PAGE_SIZE);
+	if (!pfn_array)
+		return -ENOMEM;
+
+	for (i = 0, pfn = 0; i < pagecount; i++) {
+		pfn_array[pfn] = virt_to_hvpfn(kbuffer + i * HV_HYP_PAGE_SIZE);
+		pfn++;
+
+		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
+			ret |= hv_mark_gpa_visibility(pfn, pfn_array, visibility);
+			pfn = 0;
+		}
+	}
+
+	vfree(pfn_array);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hv_set_mem_host_visibility);
+
 /*
  * create_gpadl_header - Creates a gpadl for the specified buffer
  */
@@ -410,6 +442,12 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 	if (ret)
 		return ret;
 
+	ret = hv_set_mem_host_visibility(kbuffer, size, visibility);
+	if (ret) {
+		pr_warn("Failed to set host visibility.\n");
+		return ret;
+	}
+
 	init_completion(&msginfo->waitevent);
 	msginfo->waiting_channel = channel;
 
@@ -693,7 +731,9 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 error_free_info:
 	kfree(open_info);
 error_free_gpadl:
-	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
+	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle,
+			     page_address(newchannel->ringbuffer_page),
+			     newchannel->ringbuffer_pagecount << PAGE_SHIFT);
 	newchannel->ringbuffer_gpadlhandle = 0;
 error_clean_ring:
 	hv_ringbuffer_cleanup(&newchannel->outbound);
@@ -740,7 +780,8 @@ EXPORT_SYMBOL_GPL(vmbus_open);
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
+int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle,
+			 void *kbuffer, u32 size)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -793,6 +834,10 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	kfree(info);
+
+	if (hv_set_mem_host_visibility(kbuffer, size, VMBUS_PAGE_NOT_VISIBLE))
+		pr_warn("Fail to set mem host visibility.\n");
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vmbus_teardown_gpadl);
@@ -869,7 +914,9 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 	/* Tear down the gpadl for the channel's ring buffer */
 	else if (channel->ringbuffer_gpadlhandle) {
 		ret = vmbus_teardown_gpadl(channel,
-					   channel->ringbuffer_gpadlhandle);
+					   channel->ringbuffer_gpadlhandle,
+					   page_address(channel->ringbuffer_page),
+					   channel->ringbuffer_pagecount << PAGE_SHIFT);
 		if (ret) {
 			pr_err("Close failed: teardown gpadl return %d\n", ret);
 			/*
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2a87cfa27ac0..b3a43c4ec8ab 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1034,6 +1034,7 @@ struct netvsc_device {
 
 	/* Send buffer allocated by us */
 	void *send_buf;
+	u32 send_buf_size;
 	u32 send_buf_gpadl_handle;
 	u32 send_section_cnt;
 	u32 send_section_size;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index bb72c7578330..08d73401bb28 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -245,7 +245,9 @@ static void netvsc_teardown_recv_gpadl(struct hv_device *device,
 
 	if (net_device->recv_buf_gpadl_handle) {
 		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->recv_buf_gpadl_handle);
+					   net_device->recv_buf_gpadl_handle,
+					   net_device->recv_buf,
+					   net_device->recv_buf_size);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -267,7 +269,9 @@ static void netvsc_teardown_send_gpadl(struct hv_device *device,
 
 	if (net_device->send_buf_gpadl_handle) {
 		ret = vmbus_teardown_gpadl(device->channel,
-					   net_device->send_buf_gpadl_handle);
+					   net_device->send_buf_gpadl_handle,
+					   net_device->send_buf,
+					   net_device->send_buf_size);
 
 		/* If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -419,6 +423,7 @@ static int netvsc_init_buf(struct hv_device *device,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
+	net_device->send_buf_size = buf_size;
 
 	/* Establish the gpadl handle for this buffer on this
 	 * channel.  Note: This call uses the vmbus connection rather
diff --git a/drivers/uio/uio_hv_generic.c b/drivers/uio/uio_hv_generic.c
index 813a7bee5139..c8d4704fc90c 100644
--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -181,13 +181,15 @@ static void
 hv_uio_cleanup(struct hv_device *dev, struct hv_uio_private_data *pdata)
 {
 	if (pdata->send_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl);
+		vmbus_teardown_gpadl(dev->channel, pdata->send_gpadl,
+				     pdata->send_buf, SEND_BUFFER_SIZE);
 		pdata->send_gpadl = 0;
 		vfree(pdata->send_buf);
 	}
 
 	if (pdata->recv_gpadl) {
-		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl);
+		vmbus_teardown_gpadl(dev->channel, pdata->recv_gpadl,
+				     pdata->recv_buf, RECV_BUFFER_SIZE);
 		pdata->recv_gpadl = 0;
 		vfree(pdata->recv_buf);
 	}
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 83448e837ded..ad19f4199f90 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -158,6 +158,7 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_RETARGET_INTERRUPT		0x007e
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
+#define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
 
 #define HV_FLUSH_ALL_PROCESSORS			BIT(0)
 #define HV_FLUSH_ALL_VIRTUAL_ADDRESS_SPACES	BIT(1)
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 016fdca20d6e..41cbaa2db567 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1183,7 +1183,8 @@ extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
 				      u32 visibility);
 
 extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
-				     u32 gpadl_handle);
+				u32 gpadl_handle,
+				void *kbuffer, u32 size);
 
 void vmbus_reset_channel_cb(struct vmbus_channel *channel);
 
-- 
2.25.1

