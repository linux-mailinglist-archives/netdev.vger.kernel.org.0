Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34762E719
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbiKQVjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiKQVjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:39:09 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4782251C;
        Thu, 17 Nov 2022 13:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668721148; x=1700257148;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=0niZneHfbkcxXEZ9uvCv+etpZqLq0KbVLSwB6K5fTv4=;
  b=UwFcpCkqRTsf0nLvu0eaM/WnpffQJfY//ELSqIWuX7D/JtxcnXP8RnpW
   jTYsj36VF05RPejPZaWAiVbz8d/7fB2ExP3EiBQBLoWaGP4nKlYEwKTl4
   yQhNvEIGCJJUErIvXdjvJ7ULCk3tqHFe95rAdibZ1SUwWoq3olAAqQw68
   w2VIlJqQN5hDagWVP1werbIdpz3dA98lYu6kCN5nL9qpBn1PpfHH4+vNP
   SPFkeuy5SW4GDKyMTlt3CyR2kDkkN7c3BgHwXrkVLHGBUlJyHdsnShXeT
   nKR+2TWsdJ8F5rL8CgiEChu9jDkQDzKZJBfV2mxrDiadbBZZvex59xv2b
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="312995513"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="312995513"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 13:39:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="639967396"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="639967396"
Received: from wangyi7-mobl3.amr.corp.intel.com (HELO [10.212.182.5]) ([10.212.182.5])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 13:39:06 -0800
Message-ID: <23c123b6-4588-9888-ec8d-ec3303ce2406@linux.intel.com>
Date:   Thu, 17 Nov 2022 13:39:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [Patch v3 02/14] x86/ioapic: Gate decrypted mapping on
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
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-3-git-send-email-mikelley@microsoft.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <1668624097-14884-3-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/22 10:41 AM, Michael Kelley wrote:
> Current code always maps the IOAPIC as shared (decrypted) in a
> confidential VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
> enabled use a paravisor running in VMPL0 to emulate the IOAPIC.
> In such a case, the IOAPIC must be accessed as private (encrypted).
> 
> Fix this by gating the IOAPIC decrypted mapping on a new
> cc_platform_has() attribute that a subsequent patch in the series
> will set only for Hyper-V guests.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> ---

Looks fine to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

>  arch/x86/kernel/apic/io_apic.c |  3 ++-
>  include/linux/cc_platform.h    | 12 ++++++++++++
>  2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index a868b76..c65e0cc 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2686,7 +2686,8 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
>  	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
>  	 * bits, just like normal ioremap():
>  	 */
> -	flags = pgprot_decrypted(flags);
> +	if (!cc_platform_has(CC_ATTR_EMULATED_IOAPIC))
> +		flags = pgprot_decrypted(flags);
>  
>  	__set_fixmap(idx, phys, flags);
>  }
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index cb0d6cd..7a0da75 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -90,6 +90,18 @@ enum cc_attr {
>  	 * Examples include TDX Guest.
>  	 */
>  	CC_ATTR_HOTPLUG_DISABLED,
> +
> +	/**
> +	 * @CC_ATTR_EMULATED_IOAPIC: Guest VM has an emulated I/O APIC
> +	 *
> +	 * The platform/OS is running as a guest/virtual machine with
> +	 * an I/O APIC that is emulated by a paravisor running in the
> +	 * guest VM context. As such, the I/O APIC is accessed in the
> +	 * encrypted portion of the guest physical address space.
> +	 *
> +	 * Examples include Hyper-V SEV-SNP guests using vTOM.
> +	 */
> +	CC_ATTR_EMULATED_IOAPIC,
>  };
>  
>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
