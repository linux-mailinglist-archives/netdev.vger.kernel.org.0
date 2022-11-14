Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E98B628515
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiKNQXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiKNQXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:23:34 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD80BF6;
        Mon, 14 Nov 2022 08:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668443012; x=1699979012;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=YG88I7VKq38DmjvfFFAngUFF9qTpl6rTFa1hUvsPS78=;
  b=gRxaiBv0T3ycOWy7yxxvtGO3Dy0AyslJEuGVGrHLowdI4pVzLsKDb8oe
   +inCOIYPfEWHwu+0Jy9bMCo8UH3b6XO1jkCMGbMrOjQqy5WO9w2KB6oPg
   PcJQc5aPeiynmrMPnYA9MNGc6L5ogVUuvn4HPtMZjmFN7KwTdP83tkVky
   zJQNkTIRJAschGsC7xdX2SQVOglOKq9+HVL7Z1OTdwKQPl6Wa06CCDVU8
   V6xpRtfRwYKouMd4T5XLe+HpWrP1fFWq22/buqn6SUPX+g16Uf8CE9mx3
   B4b0gJFN3mVQjoz42z2L0WvfCptf1mvtGyOPMCbLK7XhzgnGneBvzxPTo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292410010"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292410010"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:23:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="640830720"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="640830720"
Received: from satyanay-mobl1.amr.corp.intel.com (HELO [10.209.114.162]) ([10.209.114.162])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:23:29 -0800
Message-ID: <ac5f0e24-cac8-828c-3b4b-995f77f81ce3@intel.com>
Date:   Mon, 14 Nov 2022 08:23:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 02/12] x86/ioapic: Gate decrypted mapping on
 cc_platform_has() attribute
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
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
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
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
 <1668147701-4583-3-git-send-email-mikelley@microsoft.com>
 <50a8517d-328e-2178-e98c-4b160456e092@intel.com>
 <BYAPR21MB168860D4D19F088CB41E7548D7039@BYAPR21MB1688.namprd21.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <BYAPR21MB168860D4D19F088CB41E7548D7039@BYAPR21MB1688.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 20:48, Michael Kelley (LINUX) wrote:
> From: Dave Hansen <dave.hansen@intel.com> Sent: Friday, November 11, 2022 4:22 PM
>> On 11/10/22 22:21, Michael Kelley wrote:
>>>  	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
>>>  	 * bits, just like normal ioremap():
>>>  	 */
>>> -	flags = pgprot_decrypted(flags);
>>> +	if (!cc_platform_has(CC_ATTR_HAS_PARAVISOR))
>>> +		flags = pgprot_decrypted(flags);
>> This begs the question whether *all* paravisors will want to avoid a
>> decrypted ioapic mapping.  Is this _fundamental_ to paravisors, or it is
>> an implementation detail of this _individual_ paravisor?
> Hard to say.  The paravisor that Hyper-V provides for use with the vTOM
> option in a SEV SNP VM is the only paravisor I've seen.  At least as defined
> by Hyper-V and AMD SNP Virtual Machine Privilege Levels (VMPLs), the
> paravisor resides within the VM trust boundary.  Anything that a paravisor
> emulates would be in the "private" (i.e., encrypted) memory so it can be
> accessed by both the guest OS and the paravisor.  But nothing fundamental
> says that IOAPIC emulation *must* be done in the paravisor.

Please just make this check more specific.  Either make this a specific
Hyper-V+SVM check, or rename it HAS_EMULATED_IOAPIC, like you were
thinking.  If paravisors catch on and we end up with ten more of these
things across five different paravisors and see a pattern, *then* a
paravisor-specific one makes sense.
