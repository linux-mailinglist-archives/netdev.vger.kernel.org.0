Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9896A112E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBWU0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBWU0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:26:49 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ABF5D459;
        Thu, 23 Feb 2023 12:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677184008; x=1708720008;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IGl0r14webusJRTD0HcY0iXfPccIG/+jMeNAYQxtmZc=;
  b=JEQahSqhBlOTXbqHq3PwYmTolESiSh3lvPDtnDBzJyaLLbZOaUOcvEtE
   QwMwMff1+DERxAK/30vTrn/5pjH0Ek4zshmjoBmlzTH+d7s0osHXhoFpR
   UszaLjzQGIb9W/AzJRMuEJZHgkKjb0nlgxkGRYSC6yPe7n1NMAc4rzZR6
   t8mBY1FEy+uay5oVzPPIJYdMSUMyHPlWa6Zcrw0ODxGUtjdZHvDOd0jFg
   uj4rCqtJOnKMEsRcP/bAdSVjO68QbHlcmr04atH/norXePQnS9U0WuAF7
   qstJ+T7QQskjSBajUGWdMX6v3p4jhz1oeCzwkWhESO4PcAtGCZ/RWzUz6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="312952864"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="312952864"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 12:26:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="650117218"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="650117218"
Received: from bhouse-desk.amr.corp.intel.com (HELO [10.255.229.193]) ([10.255.229.193])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 12:26:47 -0800
Message-ID: <e15a1d20-5014-d704-d747-01069b5f4c88@intel.com>
Date:   Thu, 23 Feb 2023 12:26:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Borislav Petkov <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
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
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
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
References: <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y+bXjxUtSf71E5SS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 15:47, Sean Christopherson wrote:
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index a868b76cd3d4..08f65ed439d9 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2682,11 +2682,16 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
>  {
>         pgprot_t flags = FIXMAP_PAGE_NOCACHE;
>  
> -       /*
> -        * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
> -        * bits, just like normal ioremap():
> -        */
> -       flags = pgprot_decrypted(flags);
> +       if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
> +               /*
> +               * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
> +               * bits, just like normal ioremap():
> +               */
> +               if (x86_platform.hyper.is_private_mmio(phys))
> +                       flags = pgprot_encrypted(flags);
> +               else
> +                       flags = pgprot_decrypted(flags);
> +       }

I don't completely hate this.  Thinking to the future, I'd hope that
future platforms will include information about which physical addresses
are shared or private.  This might even vary per device, but this
interface would still work.

I _think_ it would be nicer to wrap both checks up in a helper where the
comments can be more detailed, like:

	if (cc_private_mmio(phys))
		flags = pgprot_encrypted(flags);
	else
		flags = pgprot_decrypted(flags);

but I honestly don't feel that strongly about it.

It does seem a bit odd that there's a new CC_ATTR_GUEST_MEM_ENCRYPT
check wrapping this whole thing.  I guess the trip through
pgprot_decrypted() is harmless on normal platforms, though.

> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 6453fbaedb08..0baec766b921 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -116,6 +116,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
>         if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>                 return;
>  
> +       if (x86_platform.hyper.is_private_mmio(addr))
> +               desc->flags |= IORES_MAP_ENCRYPTED;
> +
>         if (!IS_ENABLED(CONFIG_EFI))
>                 return;
>  

