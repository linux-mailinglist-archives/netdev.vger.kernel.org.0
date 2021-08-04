Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC313E0801
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbhHDSqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 14:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbhHDSpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 14:45:54 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034D9C06179A;
        Wed,  4 Aug 2021 11:45:42 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso4833311pjf.4;
        Wed, 04 Aug 2021 11:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fidXEtxr0Zl52jhWQl2nqOsdWmM5fkjX/Uwz1S0YsxA=;
        b=DKgPJlPxJc7S08zxvYdozuE9CcJgrr2yVJnQeo4lSs1PLblHI0Kln54SlK4g9FTuRQ
         VvyzHahqdmXc6pvRwA5QdsBPO9C3AYu4jeWs9j7ah9GXgDPr5ecYHrqFeHgYegxOt2Px
         upG94ikShWwi73+xN5UK6HZTBmkKMcINJjCUv1OIaPEDRaD7q33Imawx6mkYtw+WxeFC
         TBXOLww7Ot3FnXj61uASdG/depPtOxQFS3FyV0rIrdlDe3jLz5URqhc2YI1Xabnso0hd
         GI6aiqZpZwuO4aFnZRWdmxA9A6u55yTXsL4vPC75OLcsQlYEj3M0mXrMSVjILgXtl0mq
         KUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fidXEtxr0Zl52jhWQl2nqOsdWmM5fkjX/Uwz1S0YsxA=;
        b=hvbtvVymOv5VIs5s3kPh3uC789XhOJnN8x4pGOA24MipR3K/MUYrTgoHWtKJpevlKw
         +XBX0b/x6E/A8nCfNY05M8FSkkNlm7YKz3aHgthHjwPJbKenizEwIHuR2OidBjjU5Aef
         kZr2QygIKyxbl7ZpHJXDZuZxB37Luh0+LekySyCqMRRawENi05zT1VPF+nKjbj7cQulT
         HCbe+G47lOMj5NtWd54Yqax9269+9IxIJqNHIHC1nbPcmkaPD2rM1+3yO49MhjzNHyFb
         kL/SXdl4hzE9mkk4ew00ShudYaOgRHQUQgT4OIGygsQj+imQVzkoIoROI339SmCa+9qI
         +LgA==
X-Gm-Message-State: AOAM53161lu0bGXHUmYpVf/icU/4KEgabmo1GAI30EwEn5Fd8WxOKckk
        ndrZPQ0Yft8QZ6lK0O8fZTg=
X-Google-Smtp-Source: ABdhPJzlK+c8vpymH687blGTcrr2axY1rMc4XoTiFdkA8J4DcgRL2/Kg+2cc3o9uYfAT7s7kmNgpiw==
X-Received: by 2002:a17:90a:cc8:: with SMTP id 8mr533872pjt.194.1628102741602;
        Wed, 04 Aug 2021 11:45:41 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:1947:6842:b8a8:6f83])
        by smtp.gmail.com with ESMTPSA id f5sm3325647pjo.23.2021.08.04.11.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:45:41 -0700 (PDT)
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
        Tianyu.Lan@microsoft.com, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, pgonda@google.com,
        david@redhat.com, krish.sadhukhan@oracle.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, xen-devel@lists.xenproject.org,
        martin.b.radev@gmail.com, ardb@kernel.org, rientjes@google.com,
        tj@kernel.org, keescook@chromium.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com
Subject: [PATCH V2 07/14] HV: Add ghcb hvcall support for SNP VM
Date:   Wed,  4 Aug 2021 14:45:03 -0400
Message-Id: <20210804184513.512888-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804184513.512888-1-ltykernel@gmail.com>
References: <20210804184513.512888-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V provides ghcb hvcall to handle VMBus
HVCALL_SIGNAL_EVENT and HVCALL_POST_MESSAGE
msg in SNP Isolation VM. Add such support.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c           | 43 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |  1 +
 drivers/hv/connection.c         |  6 ++++-
 drivers/hv/hv.c                 |  8 +++++-
 include/asm-generic/mshyperv.h  | 29 ++++++++++++++++++++++
 5 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index a135020002fe..377729279a0b 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -15,6 +15,49 @@
 #include <asm/io.h>
 #include <asm/mshyperv.h>
 
+#define GHCB_USAGE_HYPERV_CALL	1
+
+u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+
+	if (!ms_hyperv.ghcb_base)
+		return -EFAULT;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(ms_hyperv.ghcb_base);
+	hv_ghcb = (union hv_ghcb *)*ghcb_base;
+	if (!hv_ghcb) {
+		local_irq_restore(flags);
+		return -EFAULT;
+	}
+
+	hv_ghcb->ghcb.protocol_version = GHCB_PROTOCOL_MAX;
+	hv_ghcb->ghcb.ghcb_usage = GHCB_USAGE_HYPERV_CALL;
+
+	hv_ghcb->hypercall.outputgpa = (u64)output;
+	hv_ghcb->hypercall.hypercallinput.asuint64 = 0;
+	hv_ghcb->hypercall.hypercallinput.callcode = control;
+
+	if (input_size)
+		memcpy(hv_ghcb->hypercall.hypercalldata, input, input_size);
+
+	VMGEXIT();
+
+	hv_ghcb->ghcb.ghcb_usage = 0xffffffff;
+	memset(hv_ghcb->ghcb.save.valid_bitmap, 0,
+	       sizeof(hv_ghcb->ghcb.save.valid_bitmap));
+
+	local_irq_restore(flags);
+
+	return hv_ghcb->hypercall.hypercalloutput.callstatus;
+}
+EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
+
 void hv_ghcb_msr_write(u64 msr, u64 value)
 {
 	union hv_ghcb *hv_ghcb;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 3cccce14ff4c..8f7e2e3b7227 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -255,6 +255,7 @@ void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
 void hv_signal_eom_ghcb(void);
 void hv_ghcb_msr_write(u64 msr, u64 value);
 void hv_ghcb_msr_read(u64 msr, u64 *value);
+u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size);
 
 #define hv_get_synint_state_ghcb(int_num, val)			\
 	hv_sint_rdmsrl_ghcb(HV_X64_MSR_SINT0 + int_num, val)
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 5e479d54918c..6d315c1465e0 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -447,6 +447,10 @@ void vmbus_set_event(struct vmbus_channel *channel)
 
 	++channel->sig_events;
 
-	hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
+	if (hv_isolation_type_snp())
+		hv_ghcb_hypercall(HVCALL_SIGNAL_EVENT, &channel->sig_event,
+				NULL, sizeof(u64));
+	else
+		hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
 }
 EXPORT_SYMBOL_GPL(vmbus_set_event);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 59f7173c4d9f..e5c9fc467893 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -98,7 +98,13 @@ int hv_post_message(union hv_connection_id connection_id,
 	aligned_msg->payload_size = payload_size;
 	memcpy((void *)aligned_msg->payload, payload, payload_size);
 
-	status = hv_do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL);
+	if (hv_isolation_type_snp())
+		status = hv_ghcb_hypercall(HVCALL_POST_MESSAGE,
+				(void *)aligned_msg, NULL,
+				sizeof(struct hv_input_post_message));
+	else
+		status = hv_do_hypercall(HVCALL_POST_MESSAGE,
+				aligned_msg, NULL);
 
 	/* Preemption must remain disabled until after the hypercall
 	 * so some other thread can't get scheduled onto this cpu and
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index b0cfc25dffaa..317d2a8d9700 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -31,6 +31,35 @@
 
 union hv_ghcb {
 	struct ghcb ghcb;
+	struct {
+		u64 hypercalldata[509];
+		u64 outputgpa;
+		union {
+			union {
+				struct {
+					u32 callcode        : 16;
+					u32 isfast          : 1;
+					u32 reserved1       : 14;
+					u32 isnested        : 1;
+					u32 countofelements : 12;
+					u32 reserved2       : 4;
+					u32 repstartindex   : 12;
+					u32 reserved3       : 4;
+				};
+				u64 asuint64;
+			} hypercallinput;
+			union {
+				struct {
+					u16 callstatus;
+					u16 reserved1;
+					u32 elementsprocessed : 12;
+					u32 reserved2         : 20;
+				};
+				u64 asunit64;
+			} hypercalloutput;
+		};
+		u64 reserved2;
+	} hypercall;
 } __packed __aligned(PAGE_SIZE);
 
 struct ms_hyperv_info {
-- 
2.25.1

