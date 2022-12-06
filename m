Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533A5644D3D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiLFUa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLFUaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:30:25 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7672340903;
        Tue,  6 Dec 2022 12:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670358624; x=1701894624;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=cKNUhoCiYNYxcj4olMwEpjiNpmt1LAcQUcHFx6HzQpQ=;
  b=SLFPOyb4xSgXi6DJPhwUK+7I7MdRjHEZV7rmBimV5AL2oCNvLiVxGpv2
   GZa8SPq0yJNIgihvcg+HyoTNV8U4+18NiiBLE2Yt/cqDT5GAlAIXwEJxt
   8UqfNAF1eVMmbbzEi4LR/F41VqunmPo1Xy477DQyBnSaz6nmk/j6wqYvm
   +AiAqQggJMVIJYhMEhEwg2cJmb+oTpS9Y5Wpk5heV8QLZSsdGU/BpM1yb
   hGQDb0fL3lUhq89bPBH2KVQLZlU3JA9XGfPtTWH7zelaHjiT5BI+c9uhS
   4WnBt52vFtq57HYQ+yV2jsvJKX+0eDAflpYIjFf6cJ+OLCuU0trqyzcKp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="297080636"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="297080636"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 12:30:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="788621078"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="788621078"
Received: from smaslov-mobl3.amr.corp.intel.com (HELO [10.251.23.186]) ([10.251.23.186])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 12:30:21 -0800
Message-ID: <ad273f8d-e6f5-16e1-0768-3a678b873202@linux.intel.com>
Date:   Tue, 6 Dec 2022 12:30:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [Patch v4 05/13] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-6-git-send-email-mikelley@microsoft.com>
 <51fb66d6-f2e0-f11c-68a3-525723d56dd4@linux.intel.com>
 <BYAPR21MB1688BD8EF5F5E7B572846116D71B9@BYAPR21MB1688.namprd21.prod.outlook.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <BYAPR21MB1688BD8EF5F5E7B572846116D71B9@BYAPR21MB1688.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/22 12:13 PM, Michael Kelley (LINUX) wrote:
> From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@linux.intel.com>
>>
>>
>>
>> On 12/1/22 7:30 PM, Michael Kelley wrote:
>>> Full Hyper-V initialization, including support for hypercalls, is done
>>> as an apic_post_init callback via late_time_init().  mem_encrypt_init()
>>> needs to make hypercalls when it marks swiotlb memory as decrypted.
>>> But mem_encrypt_init() is currently called a few lines before
>>> late_time_init(), so the hypercalls don't work.
>>
>> Did you consider moving hyper-v hypercall initialization before
>>  mem_encrypt_init(). Is there any dependency issue?
> 
> Hyper-V initialization has historically been done using the callbacks
> that exist in the x86 initialization paths, rather than adding explicit
> Hyper-V init calls.  As noted above, the full Hyper-V init is done on
> the apic_post_init callback via late_time_init().  Conceivably we could
> add an explicit call to do the Hyper-V init, but I think there's still a
> problem in putting that Hyper-V init prior to the current location of
> mem_encrypt_init().  I'd have to go check the history, but I think the
> Hyper-V init needs to happen after the APIC is initialized.

Ok. If there is a dependency or complexity issue, I recommend adding that
detail in the commit log.

> 
> It seems like moving mem_encrypt_init() slightly later is the cleaner
> long-term solution.  Are you aware of a likely problem arising in the
> future with moving mem_encrypt_init()?

I did not investigate in depth, but there appears to be no problem with
moving mem_encrypt_init(). But my point is, if it is possible to fix this
easily by changing Hyper-v specific initialization, we should consider it
first before considering moving the common mem_encrypt_init() function.



> 
> Michael
> 
>>
>>>
>>> Fix this by moving mem_encrypt_init() after late_time_init() and
>>> related clock initializations. The intervening initializations don't
>>> do any I/O that requires the swiotlb, so moving mem_encrypt_init()
>>> slightly later has no impact.
>>>

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
