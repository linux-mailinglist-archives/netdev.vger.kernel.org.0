Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D993D912B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhG1Oxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbhG1OxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 10:53:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F045C061764;
        Wed, 28 Jul 2021 07:53:22 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z3so1675779plg.8;
        Wed, 28 Jul 2021 07:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v51HbVj9oUgMShtZEj3Pp1xicbgTTaQMmcrpxVSeHWs=;
        b=J1bP3zz2e9Ky6Qac+aF/nab3UrGFJCXZcJO+f4RIMpnMf5/FPnldo0qUWUtq//NT5y
         gC/R4rItPntl/y/ciDSd9VWz04QFZe3XcST16OzWZtFjSEz1aVUAeDJ3QtRE2cSWojXO
         cZ75GJsU4hDfJfqFP8o6hN6kwUJtfSeEk21602ZW7rRvu7mNJyBe8lvmT9orbv2qW+P1
         XUJ2oymKMxvbkhA8y5/wvIzfEbXg0UZ8APbjtFUVxdcyM0fkc0tM4I993BegwvwzHhPo
         XwT+MQZ2cphoNI70/JrvceBhTCfttWejvlYS6aYsvD62kE1r33z8ezadatHFd9fbrpvF
         GEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v51HbVj9oUgMShtZEj3Pp1xicbgTTaQMmcrpxVSeHWs=;
        b=N9xDUbKZ9wTac885zLXlTnU4sTnSd6WYaB34Zgdob4WtsWmEGkOoubjB80BHiOIFxf
         RO3A1hUGDp94Ms+piS3n5vv1vuMSAu+uJ59htf7NsnEwdNBhpPSmj85VGxyBHaG7mCWQ
         9Ws6FUvHOD5wkPFpBwms/p6udyE/SUR479umUzHVqQpqxwpjAmDA1DvT0bg6NaBJKzvI
         8r0V9+s2J89AEfXJ+YyFAwqsT+7q+/ZhuCDdoeWpVtOjaprUDPLQF93rJtBk3hnoGgZd
         BLUJSMP5FwijbWXyT9dEEnI5LW0NVWm9ie9Vpc8hj72Re6yHJTAUyvlx2nPkMiyHg357
         cGWg==
X-Gm-Message-State: AOAM530i4d1K75fskX+Z3krAsEUEPxToVJGqluWNSi20t8Uk9iQwy0MO
        SUcFZAjI/6G19ZOXE3VD/B4=
X-Google-Smtp-Source: ABdhPJx53zStKiyjEMPaVE5CG/AOPZ91uL54k+pFpCVnyB2dlyAFOANHVd5oiIcOg5eiMuEJpQ9u6g==
X-Received: by 2002:a63:ef02:: with SMTP id u2mr211497pgh.298.1627484002239;
        Wed, 28 Jul 2021 07:53:22 -0700 (PDT)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:3823:141e:6d51:f0ad])
        by smtp.gmail.com with ESMTPSA id n134sm277558pfd.89.2021.07.28.07.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 07:53:22 -0700 (PDT)
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
Subject: [PATCH 06/13] HV: Add ghcb hvcall support for SNP VM
Date:   Wed, 28 Jul 2021 10:52:21 -0400
Message-Id: <20210728145232.285861-7-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728145232.285861-1-ltykernel@gmail.com>
References: <20210728145232.285861-1-ltykernel@gmail.com>
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
 arch/x86/hyperv/ivm.c           | 42 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/mshyperv.h |  1 +
 drivers/hv/connection.c         |  6 ++++-
 drivers/hv/hv.c                 |  8 ++++++-
 include/asm-generic/mshyperv.h  | 29 +++++++++++++++++++++++
 5 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 9c30d5bb7b64..13bab7f07085 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -15,6 +15,48 @@
 #include <asm/io.h>
 #include <asm/mshyperv.h>
 
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
+	memset(hv_ghcb, 0x00, HV_HYP_PAGE_SIZE);
+	hv_ghcb->ghcb.protocol_version = 1;
+	hv_ghcb->ghcb.ghcb_usage = 1;
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
index 3c0cafdf7309..8bf26e6e7055 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -254,6 +254,7 @@ void hv_sint_rdmsrl_ghcb(u64 msr, u64 *value);
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

