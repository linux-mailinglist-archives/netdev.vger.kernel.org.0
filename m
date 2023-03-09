Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3496B2B1C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCIQqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbjCIQqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:46:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C865CF8F07;
        Thu,  9 Mar 2023 08:34:36 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 16FCD1EC01CE;
        Thu,  9 Mar 2023 17:34:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678379675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:references;
        bh=hOei1CaI+9KLLzxWuYHEeWFq523hC358nYg82qEk0P8=;
        b=lQXq02kbV26V098b2/yjVkgJDGMNI2zho6Gfyn8txrIWTk5PlovjwTXeA/A3Lr2JnqJDMn
        4JJONSCvKRvdeQUqsg/EdUUl7mkVX4t16UEunFe1wXVWVpGDtfaMEE7g82LkN9ean15hUi
        6D6zF6xljU+52MZ/unkZ2yfpSI4uZ2M=
Date:   Thu, 9 Mar 2023 17:34:31 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     David Woodhouse <dwmw2@infradead.org>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Usama Arif <usama.arif@bytedance.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <20230309163431.GFZAoKl2zgRdi8UXIQ@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ff5bec2dd121d598da3cfd74cc95e25856b54a34.camel@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:45:35PM +0000, David Woodhouse wrote:
> cc_vendor isn't yet exposed. As we discussed this in IRC, I've been

Right, and we might just as well expose it because having
a setter/getter is kinda silly for a __ro_after_init variable, see
below.

So here's what I was able to scratch up quickly to remove the static
key.

The asm looks like this:

# ./arch/x86/include/asm/sev.h:156: 	if (cc_vendor == CC_VENDOR_AMD &&
	cmpl	$1, cc_vendor(%rip)	#, cc_vendor
	je	.L204	#,

...

.L204:
# ./arch/x86/include/asm/sev.h:157:         cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
        movl    $3, %edi        #,
        call    cc_platform_has #
# ./arch/x86/include/asm/sev.h:156:     if (cc_vendor == CC_VENDOR_AMD &&
        testb   %al, %al        # tmp134
        je      .L158   #,

and so I doubt that this is at all measureable comparing that to the
rest of the code that gets executed in the NMI handler. And it lets us
get rid of yet another static key and use only the CC APIs.

Oh, and it bitches because cc_platform_has() is being called in noinstr
region but we can mark it noinstr or add the drop-noinstr markers around
it, if needed. Not that important as that function and what it calls
don't do anything magical.

Thx.

---
diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f881484..34446383e68b 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -13,7 +13,7 @@
 #include <asm/coco.h>
 #include <asm/processor.h>
 
-static enum cc_vendor vendor __ro_after_init;
+enum cc_vendor cc_vendor __ro_after_init;
 static u64 cc_mask __ro_after_init;
 
 static bool intel_cc_platform_has(enum cc_attr attr)
@@ -83,7 +83,7 @@ static bool hyperv_cc_platform_has(enum cc_attr attr)
 
 bool cc_platform_has(enum cc_attr attr)
 {
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return amd_cc_platform_has(attr);
 	case CC_VENDOR_INTEL:
@@ -105,7 +105,7 @@ u64 cc_mkenc(u64 val)
 	 * - for AMD, bit *set* means the page is encrypted
 	 * - for Intel *clear* means encrypted.
 	 */
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return val | cc_mask;
 	case CC_VENDOR_INTEL:
@@ -118,7 +118,7 @@ u64 cc_mkenc(u64 val)
 u64 cc_mkdec(u64 val)
 {
 	/* See comment in cc_mkenc() */
-	switch (vendor) {
+	switch (cc_vendor) {
 	case CC_VENDOR_AMD:
 		return val & ~cc_mask;
 	case CC_VENDOR_INTEL:
@@ -131,7 +131,7 @@ EXPORT_SYMBOL_GPL(cc_mkdec);
 
 __init void cc_set_vendor(enum cc_vendor v)
 {
-	vendor = v;
+	cc_vendor = v;
 }
 
 __init void cc_set_mask(u64 mask)
diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
index 3d98c3a60d34..0563e07a1002 100644
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -11,6 +11,8 @@ enum cc_vendor {
 	CC_VENDOR_INTEL,
 };
 
+extern enum cc_vendor cc_vendor;
+
 void cc_set_vendor(enum cc_vendor v);
 void cc_set_mask(u64 mask);
 
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index ebc271bb6d8e..1335781e4976 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -12,6 +12,7 @@
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/bootparam.h>
+#include <asm/coco.h>
 
 #define GHCB_PROTOCOL_MIN	1ULL
 #define GHCB_PROTOCOL_MAX	2ULL
@@ -134,24 +135,26 @@ struct snp_secrets_page_layout {
 } __packed;
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
-extern struct static_key_false sev_es_enable_key;
 extern void __sev_es_ist_enter(struct pt_regs *regs);
 extern void __sev_es_ist_exit(void);
 static __always_inline void sev_es_ist_enter(struct pt_regs *regs)
 {
-	if (static_branch_unlikely(&sev_es_enable_key))
+	if (cc_vendor == CC_VENDOR_AMD &&
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
 		__sev_es_ist_enter(regs);
 }
 static __always_inline void sev_es_ist_exit(void)
 {
-	if (static_branch_unlikely(&sev_es_enable_key))
+	if (cc_vendor == CC_VENDOR_AMD &&
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
 		__sev_es_ist_exit();
 }
 extern int sev_es_setup_ap_jump_table(struct real_mode_header *rmh);
 extern void __sev_es_nmi_complete(void);
 static __always_inline void sev_es_nmi_complete(void)
 {
-	if (static_branch_unlikely(&sev_es_enable_key))
+	if (cc_vendor == CC_VENDOR_AMD &&
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
 		__sev_es_nmi_complete();
 }
 extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..7d873bffbd8e 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -111,7 +111,6 @@ struct ghcb_state {
 };
 
 static DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
-DEFINE_STATIC_KEY_FALSE(sev_es_enable_key);
 
 static DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
 
@@ -1393,9 +1392,6 @@ void __init sev_es_init_vc_handling(void)
 			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 	}
 
-	/* Enable SEV-ES special handling */
-	static_branch_enable(&sev_es_enable_key);
-
 	/* Initialize per-cpu GHCB pages */
 	for_each_possible_cpu(cpu) {
 		alloc_runtime_data(cpu);

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
