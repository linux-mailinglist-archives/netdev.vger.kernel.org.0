Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8029692786
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbjBJT6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbjBJT6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:58:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD007D3F3;
        Fri, 10 Feb 2023 11:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676059115; x=1707595115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RaSai31/ZxzznTIHdzlNKBGywMqWTjXsH8thm9cfa1I=;
  b=Koy6RfJ65u+Z4TQbhH6OSf36O7vjbV+f7dJvOerV8yIcVF1seNxB90iB
   b3k0YlV+P0Ku2zaxPIs+2LY3sUjpxB02jDD3E8pvDw4katoOIAtrgGJmL
   B/zobczEq+FyUbiaZxwtOVLW+g+JMNLOJ8DE4gNBePE+ZSGcn76UbmS6F
   g8v5+xmm2BYzdnUIUFHKyAkOCxeYUiMVhwjiZ1H44JVCMekHFec4M62RE
   wA2gEUz3ZqKBOtcfieQ9OMvwxUYRzjIUwkLpCFuWdA/4ZGQbF/mWCzAv/
   FJ2p3IBGcCoAdWIURKLoRXNeyxpXkQtD+UtA+voBp5HQuSX8MSZ/xOD2L
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="318532371"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="318532371"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:58:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="913659098"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="913659098"
Received: from hyekyung-mobl1.amr.corp.intel.com (HELO [10.209.82.221]) ([10.209.82.221])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 11:58:32 -0800
Message-ID: <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
Date:   Fri, 10 Feb 2023 11:58:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
References: <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic> <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com> <Y+aVFxrE6a6b37XN@zn.tnic>
 <BYAPR21MB16882083E84F20B906E2C847D7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aczIbbQm/ZNunZ@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y+aczIbbQm/ZNunZ@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 11:36, Borislav Petkov wrote:
>> One approach is to go with the individual device attributes for now.>> If the list does grow significantly, there will probably be patterns
>> or groupings that we can't discern now.  We could restructure into
>> larger buckets at that point based on those patterns/groupings.
> There's a reason the word "platform" is in cc_platform_has(). Initially
> we wanted to distinguish attributes of the different platforms. So even
> if y'all don't like CC_ATTR_PARAVISOR, that is what distinguishes this
> platform and it *is* one platform.
> 
> So call it CC_ATTR_SEV_VTOM as it uses that technology or whatever. But
> call it like the platform, not to mean "I need this functionality".

I can live with that.  There's already a CC_ATTR_GUEST_SEV_SNP, so it
would at least not be too much of a break from what we already have.
