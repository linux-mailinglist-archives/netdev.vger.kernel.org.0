Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B53436690
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhJUPnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhJUPno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:43:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459DCC061226;
        Thu, 21 Oct 2021 08:41:27 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n11so698576plf.4;
        Thu, 21 Oct 2021 08:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YOBH9dydviDXfIFLYCaslNXDxefpefD14WizJYisjA4=;
        b=MpZyWB24GtgCcGVENA/WXQGZ6vOWxZyN+P/KQ3/7ARBHMGs0YjpQX5AM5iNG0jK5SV
         msAycoTuvP2yakUDRojp325U6rrYPt1aGZCz1XhKOA4RF6i/c5uOOZeDO51Ox5jTME24
         zLT44ID7yrHiv7h/4vtfRJ52yxDLafa2y1n4qp1Ro2gm0ndBYZSRutQmrrFofbFyxL6x
         PWV7sFWsFQJ7GhBEV+5WsMOTtQ4XsSlWGJKn6SeMVWspChM5NZv2BAzxTuopnIU6/vyL
         txuEqCYkeoI/AY/gdGGP72pLiVuwBynC57w7HE7WT2tjV4LEmEmwcxlShsyw1RAgwwBe
         pQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YOBH9dydviDXfIFLYCaslNXDxefpefD14WizJYisjA4=;
        b=NR2WoLZ5tJYs4oYfUPs+w/jBNlD5MHDZwNN29+ZNC5DGRC1N9bhXgPVaYC0yMzfcR/
         Ww+99HKTi3KbREGzp4+scF4nbMRHC9FbXBZBecbLuFF1OHK1dCG6+2+nya427g1VMb3P
         9e1Yzz0Oelh+ss1nUbTXny6N3yrgTnmthvYDKnyH3k0wqXC/RvfjzXqkgl5a3cLHxojW
         ZjjE+oAJ6oirVKht9+FYiQZiC3vCvsduoV46bBWadme1UXCcbRClCApyrLOYWdztCqSY
         QHU/vmSVLssanyfHFODmjKvjzrOu9lat/UExvyJJ+OphxermC0am0awiisY+7JhHz25R
         8MeA==
X-Gm-Message-State: AOAM532N7D6eqosdlV3U6O2HbzaFpvZXfxlcebD4YG9u+1EvCv2nU2yT
        QnRVclUdr0VfE3rIEcLP+e4=
X-Google-Smtp-Source: ABdhPJwHGiIgIMa/rdh9HHGAfLamb/tEBWm77DajD1Mersx5PBRy8hoDTZ1zjhNrUDJ2zS+Kd37V4Q==
X-Received: by 2002:a17:90b:3852:: with SMTP id nl18mr7356512pjb.94.1634830886819;
        Thu, 21 Oct 2021 08:41:26 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:f:a76d:53a5:b89f:c2a0])
        by smtp.gmail.com with ESMTPSA id p9sm6384130pfn.7.2021.10.21.08.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 08:41:26 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        rientjes@google.com, pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        saravanand@fb.com, aneesh.kumar@linux.ibm.com, hannes@cmpxchg.org,
        tj@kernel.org, michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V8 7/9] x86/hyperv: Add ghcb hvcall support for SNP VM
Date:   Thu, 21 Oct 2021 11:41:07 -0400
Message-Id: <20211021154110.3734294-8-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211021154110.3734294-1-ltykernel@gmail.com>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

hyperv provides ghcb hvcall to handle VMBus
HVCALL_SIGNAL_EVENT and HVCALL_POST_MESSAGE
msg in SNP Isolation VM. Add such support.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	* Add hv_ghcb_hypercall() stub function to avoid
	  compile error for ARM.
---
 arch/x86/hyperv/ivm.c          | 74 ++++++++++++++++++++++++++++++++++
 drivers/hv/connection.c        |  6 ++-
 drivers/hv/hv.c                |  8 +++-
 drivers/hv/hv_common.c         |  6 +++
 include/asm-generic/mshyperv.h |  1 +
 5 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 925cbc3e7601..260fcba97914 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -18,10 +18,84 @@
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 
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

