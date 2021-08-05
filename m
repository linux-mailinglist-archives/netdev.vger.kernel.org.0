Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339D53E165B
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241841AbhHEOGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241861AbhHEOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:06:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B96C061798;
        Thu,  5 Aug 2021 07:05:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so9037085pjv.3;
        Thu, 05 Aug 2021 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F8VMrdCyOywJRypSYr/zNvHCgQ+meFAot/YAU98HWWE=;
        b=ECF3X5iUC+sX/vDMJPtan9DyiKntE4JTT1Af+ZUPGy2bBqryLNVeJ3gR5+CS3fJHFH
         +BGde9+tFxN33KSJ0vdmOJMD6p8xehdYyALwQFZ6G3NzehgjZywkm09J/HtwwfaTXzBP
         S1WS2pWntdKte5+ILpRc2l734SfMuogBUrcU4GO/fIwTACeWEGst0D8KKq7Hp2ykipoA
         QyhNf7ug3UEf8Ogx6Kd+jbFj4xFPVdasYhyQWntvhxI1wBJbaTa3jT5pkrkRsaek/UAd
         NLLA6VCbXzd2NA0YhNwAwyGzJ7MPCd9oBnOdf+3gO1asduizzv+vye87H8v2E/Sqy61q
         QusA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F8VMrdCyOywJRypSYr/zNvHCgQ+meFAot/YAU98HWWE=;
        b=RhR6DUfep5k0/wzg6iwW6yTbiO+B+HXXsnOumI3TofbZS9C9kUDVVtb/HivlCE7Cbg
         yLc3qGIMjLLJLr+fTYAE31D6Y84YF/JTCOv5SgmlJcHxHTIyBijMMqkizIcLqbUjouVY
         D6OgeRvsOGRTmQoVViKUx5e2F13Td+qFobP7CzKZ99TU/9PHhjuCwz/ZGfoMnHNEVvgs
         dgO4ZV+ltwCh6g2xplvzcG679GsL+HBNZqBDaGKoCRYWed8X4TgV/WukidIqyN72FLjj
         FzHVpfXRMnGoJ12k/7+A54kV+ibUrDBkZS0wPx5BJLyTYNhqCuqyCk+n7MtRrY5htII6
         TBww==
X-Gm-Message-State: AOAM530uf2lmogXbILTf+hdG1UT5iFkOCOYkFRx+aJZ/GVhEJCwVdRDZ
        zAtfCBGE1csYDbq0STghdNg=
X-Google-Smtp-Source: ABdhPJwBb/TGQHg7Q/TCL0bQgwmOAloOQN4ZDR0PVYFzozUh9xJAeBD4+y2vpy2azMRYRouhtcDM2Q==
X-Received: by 2002:aa7:9719:0:b029:3b7:6965:c9b0 with SMTP id a25-20020aa797190000b02903b76965c9b0mr5413104pfg.50.1628172332669;
        Thu, 05 Aug 2021 07:05:32 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id w11sm8331978pgk.34.2021.08.05.07.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 07:05:31 -0700 (PDT)
Subject: Re: [PATCH V2 03/14] x86/set_memory: Add x86_set_memory_enc static
 call support
To:     Dave Hansen <dave.hansen@intel.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
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
        michael.h.kelley@microsoft.com, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com
References: <20210804184513.512888-1-ltykernel@gmail.com>
 <20210804184513.512888-4-ltykernel@gmail.com>
 <5823af8a-7dbb-dbb0-5ea2-d9846aa2a36a@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <942e6fcb-3bdf-9294-d3db-ca311db440d3@gmail.com>
Date:   Thu, 5 Aug 2021 22:05:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5823af8a-7dbb-dbb0-5ea2-d9846aa2a36a@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave:
	Thanks for review.

On 8/5/2021 3:27 AM, Dave Hansen wrote:
> On 8/4/21 11:44 AM, Tianyu Lan wrote:
>> +static int default_set_memory_enc(unsigned long addr, int numpages, bool enc);
>> +DEFINE_STATIC_CALL(x86_set_memory_enc, default_set_memory_enc);
>> +
>>   #define CPA_FLUSHTLB 1
>>   #define CPA_ARRAY 2
>>   #define CPA_PAGES_ARRAY 4
>> @@ -1981,6 +1985,11 @@ int set_memory_global(unsigned long addr, int numpages)
>>   }
>>   
>>   static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>> +{
>> +	return static_call(x86_set_memory_enc)(addr, numpages, enc);
>> +}
>> +
>> +static int default_set_memory_enc(unsigned long addr, int numpages, bool enc)
>>   {
>>   	struct cpa_data cpa;
>>   	int ret;
> 
> It doesn't make a lot of difference to add this infrastructure and then
> ignore it for the existing in-tree user:
> 
>> static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>> {
>>          struct cpa_data cpa;
>>          int ret;
>>
>>          /* Nothing to do if memory encryption is not active */
>>          if (!mem_encrypt_active())
>>                  return 0;
> 
> Shouldn't the default be to just "return 0"?  Then on
> mem_encrypt_active() systems, do the bulk of what is in
> __set_memory_enc_dec() today.
> 

OK. I try moving code in __set_memory_enc_dec() to sev file 
mem_encrypt.c and this requires to expose cpa functions and structure.
Please have a look.

Tom, Joerg and Brijesh, Could you review at sev code change?
Thanks.



diff --git a/arch/x86/include/asm/set_memory.h 
b/arch/x86/include/asm/set_memory.h
index 43fa081a1adb..991366612deb 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -4,6 +4,25 @@

  #include <asm/page.h>
  #include <asm-generic/set_memory.h>
+#include <linux/static_call.h>
+
+/*
+ * The current flushing context - we pass it instead of 5 arguments:
+ */
+struct cpa_data {
+	unsigned long	*vaddr;
+	pgd_t		*pgd;
+	pgprot_t	mask_set;
+	pgprot_t	mask_clr;
+	unsigned long	numpages;
+	unsigned long	curpage;
+	unsigned long	pfn;
+	unsigned int	flags;
+	unsigned int	force_split		: 1,
+			force_static_prot	: 1,
+			force_flush_all		: 1;
+	struct page	**pages;
+};

  /*
   * The set_memory_* API can be used to change various attributes of a 
virtual
@@ -83,6 +102,11 @@ int set_pages_rw(struct page *page, int numpages);
  int set_direct_map_invalid_noflush(struct page *page);
  int set_direct_map_default_noflush(struct page *page);
  bool kernel_page_present(struct page *page);
+int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias);
+void cpa_flush(struct cpa_data *data, int cache);
+
+int dummy_set_memory_enc(unsigned long addr, int numpages, bool enc);
+DECLARE_STATIC_CALL(x86_set_memory_enc, dummy_set_memory_enc);

  extern int kernel_set_to_readonly;

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index ff08dc463634..49e957c4191f 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,6 +20,8 @@
  #include <linux/bitops.h>
  #include <linux/dma-mapping.h>
  #include <linux/virtio_config.h>
+#include <linux/highmem.h>
+#include <linux/static_call.h>

  #include <asm/tlbflush.h>
  #include <asm/fixmap.h>
@@ -178,6 +180,45 @@ void __init sme_map_bootdata(char *real_mode_data)
  	__sme_early_map_unmap_mem(__va(cmdline_paddr), COMMAND_LINE_SIZE, true);
  }

+static int sev_set_memory_enc(unsigned long addr, int numpages, bool enc)
+{
+	struct cpa_data cpa;
+	int ret;
+
+	/* Should not be working on unaligned addresses */
+	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
+		addr &= PAGE_MASK;
+
+	memset(&cpa, 0, sizeof(cpa));
+	cpa.vaddr = &addr;
+	cpa.numpages = numpages;
+	cpa.mask_set = enc ? __pgprot(_PAGE_ENC) : __pgprot(0);
+	cpa.mask_clr = enc ? __pgprot(0) : __pgprot(_PAGE_ENC);
+	cpa.pgd = init_mm.pgd;
+
+	/* Must avoid aliasing mappings in the highmem code */
+	kmap_flush_unused();
+	vm_unmap_aliases();
+
+	/*
+	 * Before changing the encryption attribute, we need to flush caches.
+	 */
+	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
+
+	ret = __change_page_attr_set_clr(&cpa, 1);
+
+	/*
+	 * After changing the encryption attribute, we need to flush TLBs again
+	 * in case any speculative TLB caching occurred (but no need to flush
+	 * caches again).  We could just use cpa_flush_all(), but in case TLB
+	 * flushing gets optimized in the cpa_flush() path use the same logic
+	 * as above.
+	 */
+	cpa_flush(&cpa, 0);
+
+	return ret;
+}
+
  void __init sme_early_init(void)
  {
  	unsigned int i;
@@ -185,6 +226,8 @@ void __init sme_early_init(void)
  	if (!sme_me_mask)
  		return;

+	static_call_update(x86_set_memory_enc, sev_set_memory_enc);
+
  	early_pmd_flags = __sme_set(early_pmd_flags);

  	__supported_pte_mask = __sme_set(__supported_pte_mask);
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ad8a5c586a35..4f15f7c89dbc 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -18,6 +18,7 @@
  #include <linux/libnvdimm.h>
  #include <linux/vmstat.h>
  #include <linux/kernel.h>
+#include <linux/static_call.h>

  #include <asm/e820/api.h>
  #include <asm/processor.h>
@@ -32,24 +33,6 @@

  #include "../mm_internal.h"

-/*
- * The current flushing context - we pass it instead of 5 arguments:
- */
-struct cpa_data {
-	unsigned long	*vaddr;
-	pgd_t		*pgd;
-	pgprot_t	mask_set;
-	pgprot_t	mask_clr;
-	unsigned long	numpages;
-	unsigned long	curpage;
-	unsigned long	pfn;
-	unsigned int	flags;
-	unsigned int	force_split		: 1,
-			force_static_prot	: 1,
-			force_flush_all		: 1;
-	struct page	**pages;
-};
-
  enum cpa_warn {
  	CPA_CONFLICT,
  	CPA_PROTECT,
@@ -66,6 +49,13 @@ static const int cpa_warn_level = CPA_PROTECT;
   */
  static DEFINE_SPINLOCK(cpa_lock);

+static int default_set_memory_enc(unsigned long addr, int numpages, 
bool enc)
+{
+	return 0;
+}
+
+DEFINE_STATIC_CALL(x86_set_memory_enc, default_set_memory_enc);
+
  #define CPA_FLUSHTLB 1
  #define CPA_ARRAY 2
  #define CPA_PAGES_ARRAY 4
@@ -357,7 +347,7 @@ static void __cpa_flush_tlb(void *data)
  		flush_tlb_one_kernel(fix_addr(__cpa_addr(cpa, i)));
  }

-static void cpa_flush(struct cpa_data *data, int cache)
+void cpa_flush(struct cpa_data *data, int cache)
  {
  	struct cpa_data *cpa = data;
  	unsigned int i;
@@ -1587,8 +1577,6 @@ static int __change_page_attr(struct cpa_data 
*cpa, int primary)
  	return err;
  }

-static int __change_page_attr_set_clr(struct cpa_data *cpa, int 
checkalias);
-
  static int cpa_process_alias(struct cpa_data *cpa)
  {
  	struct cpa_data alias_cpa;
@@ -1646,7 +1634,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
  	return 0;
  }

-static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
+int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
  {
  	unsigned long numpages = cpa->numpages;
  	unsigned long rempages = numpages;
@@ -1982,45 +1970,7 @@ int set_memory_global(unsigned long addr, int 
numpages)

  static int __set_memory_enc_dec(unsigned long addr, int numpages, bool 
enc)
  {
-	struct cpa_data cpa;
-	int ret;
-
-	/* Nothing to do if memory encryption is not active */
-	if (!mem_encrypt_active())
-		return 0;
-
-	/* Should not be working on unaligned addresses */
-	if (WARN_ONCE(addr & ~PAGE_MASK, "misaligned address: %#lx\n", addr))
-		addr &= PAGE_MASK;
-
-	memset(&cpa, 0, sizeof(cpa));
-	cpa.vaddr = &addr;
-	cpa.numpages = numpages;
-	cpa.mask_set = enc ? __pgprot(_PAGE_ENC) : __pgprot(0);
-	cpa.mask_clr = enc ? __pgprot(0) : __pgprot(_PAGE_ENC);
-	cpa.pgd = init_mm.pgd;
-
-	/* Must avoid aliasing mappings in the highmem code */
-	kmap_flush_unused();
-	vm_unmap_aliases();
-
-	/*
-	 * Before changing the encryption attribute, we need to flush caches.
-	 */
-	cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_SME_COHERENT));
-
-	ret = __change_page_attr_set_clr(&cpa, 1);
-
-	/*
-	 * After changing the encryption attribute, we need to flush TLBs again
-	 * in case any speculative TLB caching occurred (but no need to flush
-	 * caches again).  We could just use cpa_flush_all(), but in case TLB
-	 * flushing gets optimized in the cpa_flush() path use the same logic
-	 * as above.
-	 */
-	cpa_flush(&cpa, 0);
-
-	return ret;
+	return static_call(x86_set_memory_enc)(addr, numpages, enc);
  }

  int set_memory_encrypted(unsigned long addr, int numpages)
