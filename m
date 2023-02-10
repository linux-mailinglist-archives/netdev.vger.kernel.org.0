Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191706925E2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjBJS6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjBJS6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:58:30 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4525F7B16B;
        Fri, 10 Feb 2023 10:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676055509; x=1707591509;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A03pmXrdhpVrzEP+7l9NWtjt5nMdZBxhCed5VX/Bfc0=;
  b=RjpjvYdu5WfHG/lpc6rFF5PK/SyLijIrar3NoG9SQwrqC+N16fl/kpl3
   2mI8uB9s0jJQi2BHycADaSOiG0LP+IEhJSuhIrulL5BoFSBV+X/y8gQ3a
   SfMuvO0SUoXwFZTR+hF3dgCC6ZDyRjK2bGimW3cdUCVU/y6emXOE/yqJv
   QGgDD1lj5tpLwPWmbRA9FoAk9QibF0+UdMehtplSXDo5Z1hE/qSfYd6bs
   2NDWfy0gJeOB6Q5DKXAch2xBjFU4zixdyeTp1sEx6NTldSGiFzSPybXoD
   Uz14YaPtvE1iq1eI0/OXGeghTuYnXag/Qe7p9TUZraKVGuRoYXJnzYTMB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="332637792"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="332637792"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 10:58:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="756879427"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="756879427"
Received: from hyekyung-mobl1.amr.corp.intel.com (HELO [10.209.82.221]) ([10.209.82.221])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 10:58:18 -0800
Message-ID: <5e3fb10d-29d4-3272-674f-2bd6cb0540e1@intel.com>
Date:   Fri, 10 Feb 2023 10:58:18 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
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
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
 <1673559753-94403-7-git-send-email-mikelley@microsoft.com>
 <Y8r2TjW/R3jymmqT@zn.tnic>
 <BYAPR21MB168897DBA98E91B72B4087E1D7CA9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y9FC7Dpzr5Uge/Mi@zn.tnic>
 <BYAPR21MB16883BB6178DDEEA10FD1F1CD7D69@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+JG9+zdSwZlz6FU@zn.tnic> <4216dea6-d899-aecb-2207-caa2ae7db0e3@intel.com>
 <BYAPR21MB16886D92828BA2CA8D47FEA4D7D99@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+aP8rHr6H3LIf/c@google.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y+aP8rHr6H3LIf/c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 10:41, Sean Christopherson wrote:
> Anyways, tying things back to the actual code being discussed, I vote against
> CC_ATTR_PARAVISOR.  Being able to trust device emulation is not unique to a
> paravisor.  A single flag also makes too many assumptions about what is trusted
> and thus should be accessed encrypted.

Did you like the more wordy per-device flags better?  Or did you have
something else in mind entirely?
