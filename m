Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD7644C7D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLFT1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiLFT1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:27:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4657C28E33;
        Tue,  6 Dec 2022 11:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670354835; x=1701890835;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=YQoQoyLUM0xhlZ4+yB0EZnkDFWB3Rz3vmZvgjvLmZX8=;
  b=Hqoh7VVjRz/9WEPA1zeeh8gFh/ThyVvsT+UFlxNBgy/u+baRzKLA/SRG
   dGP4Pot/uMBHXKdwYuelGu9kKwoFVblUq0nOVgHvbE8lZPERUgrT0Ctcm
   V+5jNjQ+5FcxnfSYath3znPcCym6iUuGeta68KaNcgG/3E6Y/9mMRSImT
   pA/R0OVHqchfGkwUzwHbgC8cfl3PlcDlr9GAosL+LsnmeD8QLIMVsQpyP
   Nn/MsfSpl+8ChXweKDHgij8xd0/O9uAqycxrZckKykEMMu6vG6YqPW/dU
   eSS2vB2meoo/Zg4pIyCUjVWjn02qGS5l8ikLSzFNu5vW/WRqib0V636KU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="316731509"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="316731509"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 11:27:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="678863673"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="678863673"
Received: from smaslov-mobl3.amr.corp.intel.com (HELO [10.251.23.186]) ([10.251.23.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 11:27:13 -0800
Message-ID: <a531ff8a-79a2-f801-921b-0c83d3d44913@linux.intel.com>
Date:   Tue, 6 Dec 2022 11:27:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [Patch v4 01/13] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
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
 <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1669951831-4180-2-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/22 7:30 PM, Michael Kelley wrote:
> Current code always maps the IO-APIC as shared (decrypted) in a
> confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> enabled use a paravisor running in VMPL0 to emulate the IO-APIC.
> In such a case, the IO-APIC must be accessed as private (encrypted).
> 
> Fix this by gating the IO-APIC decrypted mapping on a new
> cc_platform_has() attribute that a subsequent patch in the series
> will set only for guests using vTOM.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> ---

Looks good to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

>  arch/x86/kernel/apic/io_apic.c |  3 ++-
>  include/linux/cc_platform.h    | 12 ++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index a868b76..2b70e2e 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
>  	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
>  	 * bits, just like normal ioremap():
>  	 */
> -	flags = pgprot_decrypted(flags);
> +	if (!cc_platform_has(CC_ATTR_ACCESS_IOAPIC_ENCRYPTED))
> +		flags = pgprot_decrypted(flags);
>  
>  	__set_fixmap(idx, phys, flags);
>  }
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index cb0d6cd..7b63a7d 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -90,6 +90,18 @@ enum cc_attr {
>  	 * Examples include TDX Guest.
>  	 */
>  	CC_ATTR_HOTPLUG_DISABLED,
> +
> +	/**
> +	 * @CC_ATTR_ACCESS_IOAPIC_ENCRYPTED: Guest VM IO-APIC is encrypted
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine with
> +	 * an IO-APIC that is emulated by a paravisor running in the
> +	 * guest VM context. As such, the IO-APIC is accessed in the
> +	 * encrypted portion of the guest physical address space.
> +	 *
> +	 * Examples include Hyper-V SEV-SNP guests using vTOM.
> +	 */
> +	CC_ATTR_ACCESS_IOAPIC_ENCRYPTED,
>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
