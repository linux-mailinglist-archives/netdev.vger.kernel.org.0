Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F53644C9A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLFThr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLFThq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:37:46 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96091B1C6;
        Tue,  6 Dec 2022 11:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670355464; x=1701891464;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=vN4lwqnsGyDLulqDpchOlpMKkxyM2VICPVBXfraX+Uk=;
  b=JD+DLY4Y0mVx3afohGeWqirW8SmYFReP1HkXsK6XxDt6593rAN9M7EgN
   zjgyiALKve9RA/RDjvQFXu1Z/kuUrbwtjoPLRAfFlE6wyLvoVjG85AHpA
   UYHDxsjkimIthQCg7slPBO4eKiVKuDAENaXo8Fc35cpk5SZ354PiqoXh4
   P/MNxguLT+ooavuF5roEKSRTNtDmt6rIngs0IJE51Pii7NjVtpVsUwQgP
   BVnbvCSWwZYF3jb4wu0LWD70zPTE/Oap8LkKUCzVvTMVF9g+uv3ifqQOE
   O6gOen7MiuOUiuF2TCq1UVXmwom827APHi5uRNOeF8rV3du3btQCBoEbT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="317853305"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="317853305"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 11:37:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="639989304"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="639989304"
Received: from smaslov-mobl3.amr.corp.intel.com (HELO [10.251.23.186]) ([10.251.23.186])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 11:37:43 -0800
Message-ID: <51fb66d6-f2e0-f11c-68a3-525723d56dd4@linux.intel.com>
Date:   Tue, 6 Dec 2022 11:37:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [Patch v4 05/13] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        ak@linux.intel.com, isaku.yamahata@intel.com,
        dan.j.williams@intel.com, jane.chu@oracle.com, seanjc@google.com,
        tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-6-git-send-email-mikelley@microsoft.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1669951831-4180-6-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/22 7:30 PM, Michael Kelley wrote:
> Full Hyper-V initialization, including support for hypercalls, is done
> as an apic_post_init callback via late_time_init().  mem_encrypt_init()
> needs to make hypercalls when it marks swiotlb memory as decrypted.
> But mem_encrypt_init() is currently called a few lines before
> late_time_init(), so the hypercalls don't work.

Did you consider moving hyper-v hypercall initialization before
 mem_encrypt_init(). Is there any dependency issue?

> 
> Fix this by moving mem_encrypt_init() after late_time_init() and
> related clock initializations. The intervening initializations don't
> do any I/O that requires the swiotlb, so moving mem_encrypt_init()
> slightly later has no impact.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  init/main.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index e1c3911..5a7c466 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1088,14 +1088,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
>  	 */
>  	locking_selftest();
>  
> -	/*
> -	 * This needs to be called before any devices perform DMA
> -	 * operations that might use the SWIOTLB bounce buffers. It will
> -	 * mark the bounce buffers as decrypted so that their usage will
> -	 * not cause "plain-text" data to be decrypted when accessed.
> -	 */
> -	mem_encrypt_init();
> -
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	if (initrd_start && !initrd_below_start_ok &&
>  	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
> @@ -1112,6 +1104,17 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
>  		late_time_init();
>  	sched_clock_init();
>  	calibrate_delay();
> +
> +	/*
> +	 * This needs to be called before any devices perform DMA
> +	 * operations that might use the SWIOTLB bounce buffers. It will
> +	 * mark the bounce buffers as decrypted so that their usage will
> +	 * not cause "plain-text" data to be decrypted when accessed. It
> +	 * must be called after late_time_init() so that Hyper-V x86/x64
> +	 * hypercalls work when the SWIOTLB bounce buffers are decrypted.
> +	 */
> +	mem_encrypt_init();
> +
>  	pid_idr_init();
>  	anon_vma_init();
>  #ifdef CONFIG_X86

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
