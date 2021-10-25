Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED3E439638
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhJYMYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbhJYMYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:24:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C500CC06122E;
        Mon, 25 Oct 2021 05:21:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f4so5066402plt.3;
        Mon, 25 Oct 2021 05:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rfS0g7vb96rwV7A8IuQpnrVMO7EVsHi2UQpE9Aj3wKo=;
        b=CRGmA+vVXZqglJj6JMO9qpnImTaM90q51Q9XAmExNLSqchfVOdMVJLr5aqg9txl02q
         DGtmI6TFgyPQZtCyO8n+i4rqPWJPThvevlfLVw5/E33WWTPsPYWpqgOzf1XT2SgVBDh8
         nHfu0JP4zu++HN5ybyrgKW60m20dCSzIoJuxJMRSoWd1GecQVDT3MiQYIBSvAq62wngL
         xHcajGJo1vE0Nuug5i4yCIw1Gf5pEwyvOAJamGp81WZ61K1qRzQk+MZHgBnR4gYa+0Rk
         7BU7GLY5ga7eNy1g5oPnKfP9fleqgQzK3LKn9duxp5B+zy4HGqDRvEzG71r1Ak/5qbVu
         +dbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rfS0g7vb96rwV7A8IuQpnrVMO7EVsHi2UQpE9Aj3wKo=;
        b=qTdwqikeU3BFkpTirAbs3WNXjtpYSrTjh1BmIlrhhxW5TRYsYJPAiS4qtogI6bhA38
         iRWgi3Et0uzGpcj8iANXJJ+mwSVwf/7T84wQ8VlRl9MtSPA7LGgmuKV7OQ+PzUDyZvAJ
         Qq203VffR72ox3khf2u6lPs896z3MkSS4v7pw+CfId2wjwvrMz9LcdfMmxEbFR2G4Cc3
         Nuwgy0hlTT1m8T8brF4orFHLraHsOFHlY7i/5YC8xX2zNdV7bGSc0Iow6LWnGPJmlk5L
         k4BQR3aKib4tdQPbk/uOZts4yJtg6FoxvcmocY5v3lj4hPyEMoywwqM0MRGog8MMseFE
         tcjQ==
X-Gm-Message-State: AOAM533TS5s8twl4AARbsY0UOwobhkw3k6gmH0wzGLBh5tiiuWF54BPE
        EI0OGrZVpq3ecVmhoP325LY=
X-Google-Smtp-Source: ABdhPJxRo/vNJGpqgYNRQjK3zWJesZkpVcLskKYCNTUsIoj07wZqq4XSdM7XVCvF8z2trY4ab6ucqw==
X-Received: by 2002:a17:90a:39c5:: with SMTP id k5mr35590609pjf.211.1635164489391;
        Mon, 25 Oct 2021 05:21:29 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:8:bcf6:9813:137f:2b6])
        by smtp.gmail.com with ESMTPSA id mi11sm2786166pjb.5.2021.10.25.05.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 05:21:29 -0700 (PDT)
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
Subject: [PATCH V9 7/9] x86/hyperv: Add ghcb hvcall support for SNP VM
Date:   Mon, 25 Oct 2021 08:21:12 -0400
Message-Id: <20211025122116.264793-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025122116.264793-1-ltykernel@gmail.com>
References: <20211025122116.264793-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

hyperv provides ghcb hvcall to handle VMBus
HVCALL_SIGNAL_EVENT and HVCALL_POST_MESSAGE
msg in SNP Isolation VM. Add such support.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	* Add hv_ghcb_hypercall() stub function to avoid
	  compile error for ARM.
---
 arch/x86/hyperv/ivm.c          | 75 ++++++++++++++++++++++++++++++++++
 drivers/hv/connection.c        |  6 ++-
 drivers/hv/hv.c                |  8 +++-
 drivers/hv/hv_common.c         |  6 +++
 include/asm-generic/mshyperv.h |  1 +
 5 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 9c48d6e2d8b2..4d012fd9d95d 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -19,10 +19,85 @@
 #include <asm/hypervisor.h>
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+
+#define GHCB_USAGE_HYPERV_CALL	1
+
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
 } __packed __aligned(HV_HYP_PAGE_SIZE);
 
+u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size)
+{
+	union hv_ghcb *hv_ghcb;
+	void **ghcb_base;
+	unsigned long flags;
+	u64 status;
+
+	if (!hv_ghcb_pg)
+		return -EFAULT;
+
+	WARN_ON(in_nmi());
+
+	local_irq_save(flags);
+	ghcb_base = (void **)this_cpu_ptr(hv_ghcb_pg);
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
+	status = hv_ghcb->hypercall.hypercalloutput.callstatus;
+
+	local_irq_restore(flags);
+
+	return status;
+}
+
 void hv_ghcb_msr_write(u64 msr, u64 value)
 {
 	union hv_ghcb *hv_ghcb;
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 5e479d54918c..8820ae68f20f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -447,6 +447,10 @@ void vmbus_set_event(struct vmbus_channel *channel)
 
 	++channel->sig_events;
 
-	hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
+	if (hv_isolation_type_snp())
+		hv_ghcb_hypercall(HVCALL_SIGNAL_EVENT, &channel->sig_event,
+				NULL, sizeof(channel->sig_event));
+	else
+		hv_do_fast_hypercall8(HVCALL_SIGNAL_EVENT, channel->sig_event);
 }
 EXPORT_SYMBOL_GPL(vmbus_set_event);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 943392db9e8a..4d6480d57546 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -98,7 +98,13 @@ int hv_post_message(union hv_connection_id connection_id,
 	aligned_msg->payload_size = payload_size;
 	memcpy((void *)aligned_msg->payload, payload, payload_size);
 
-	status = hv_do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL);
+	if (hv_isolation_type_snp())
+		status = hv_ghcb_hypercall(HVCALL_POST_MESSAGE,
+				(void *)aligned_msg, NULL,
+				sizeof(*aligned_msg));
+	else
+		status = hv_do_hypercall(HVCALL_POST_MESSAGE,
+				aligned_msg, NULL);
 
 	/* Preemption must remain disabled until after the hypercall
 	 * so some other thread can't get scheduled onto this cpu and
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 1fc82d237161..7be173a99f27 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -289,3 +289,9 @@ void __weak hyperv_cleanup(void)
 {
 }
 EXPORT_SYMBOL_GPL(hyperv_cleanup);
+
+u64 __weak hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size)
+{
+	return HV_STATUS_INVALID_PARAMETER;
+}
+EXPORT_SYMBOL_GPL(hv_ghcb_hypercall);
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index 6d3ba902ebb0..3e2248ac328e 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -266,6 +266,7 @@ bool hv_is_hibernation_supported(void);
 enum hv_isolation_type hv_get_isolation_type(void);
 bool hv_is_isolation_supported(void);
 bool hv_isolation_type_snp(void);
+u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size);
 void hyperv_cleanup(void);
 bool hv_query_ext_cap(u64 cap_query);
 #else /* CONFIG_HYPERV */
-- 
2.25.1

