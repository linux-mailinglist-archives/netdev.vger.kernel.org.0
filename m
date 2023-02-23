Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7B66A11F1
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 22:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBWVZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 16:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjBWVZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 16:25:04 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F64E5E7;
        Thu, 23 Feb 2023 13:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677187503; x=1708723503;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=InpjG85eDJI/NoCWvGi6uqwUG/vQ6jnJDzFVyLxNEdY=;
  b=Ux9xASPRx6wXH3yU4a8E5HSrKUqg4R769EhuuVYHMGFFm8OjECeelVJP
   ZxnX/aER0SoBdBHGBfIh0Q6F1xN4ntG4oL4pU0KAQNeBvw86oy7k5yYSe
   veRMS7JNmo/qV/pXb8gafBoSgIBHsRl6Bkj25/spn0xwkgY5Oh3t7cwnF
   CSoK5xcwvD3u8kCFLJjtCWZQGt5zi7xrghBCPTWTfA3ANfnVdQ1bqT37+
   5DdhbDxa7pmuKXc9wlHe2pXCeHQfsfZpCUwXMwJ2nw5oy3cYTd+Jqcm8P
   zYaeu82IKaW4P0CNGKGwJmVy0RUzwh1Y6+j95gh4z8emstWT4H4gm/I9a
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="419563336"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="419563336"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 13:24:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="918175991"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="918175991"
Received: from bhouse-desk.amr.corp.intel.com (HELO [10.255.229.193]) ([10.255.229.193])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 13:24:46 -0800
Message-ID: <98950604-b9ff-f021-0c79-021e09e1e291@intel.com>
Date:   Thu, 23 Feb 2023 13:24:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>
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
References: <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic> <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com>
 <e15a1d20-5014-d704-d747-01069b5f4c88@intel.com>
 <e517d9dd-c1a2-92f6-6b4b-c77d9ea47546@intel.com>
 <BYAPR21MB168836495869ABB4E3D61D61D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y/fVoc4C5BNI+i7l@google.com>
 <BYAPR21MB1688452212CF8E1B97D8826DD7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BYAPR21MB1688452212CF8E1B97D8826DD7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/23 13:15, Michael Kelley (LINUX) wrote:
> Or statically set a default stub function for is_private_mmio() that returns "false".
> Then there's no need to check for NULL, and only platforms that want to use it
> have to code anything.  Several other entries in x86_platform have such defaults.

Yeah, that's what I was thinking too, like 'x86_op_int_noop':

> struct x86_platform_ops x86_platform __ro_after_init = {
>         .calibrate_cpu                  = native_calibrate_cpu_early,
>         .calibrate_tsc                  = native_calibrate_tsc,
...
>         .hyper.pin_vcpu                 = x86_op_int_noop,

It's kinda silly to do an indirect call to a two-instruction function,
but this is a pretty slow path.
