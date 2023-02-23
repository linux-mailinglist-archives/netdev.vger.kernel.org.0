Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5576A0087
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 02:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbjBWBVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 20:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjBWBVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 20:21:32 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC557196B8
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 17:21:29 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id t21-20020a056a00139500b005a8534314aeso4651530pfg.17
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 17:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Utax3e55p3N2FiK+44m4EPF0IspqZNOsObveiGZKnps=;
        b=qEb0sRMMQP+D3NIM0EavDhPqQ4MvMH/BkwStlAQZrjsNxsvp5AK1UfYEygcyPWPwJL
         aw+JkiEqI0Wk8zGQmrouiI1z4upjRMubH9ZbMcD4DfUtX9Kh6wziQif1uoq55HTC3OnT
         FkqnuFlPOv90b4F9aF2KaT24ghCOlh+8WCOGn6hLcFk+lS1tpcpAs56CWVfDHEhq5Ah+
         M5mzL9C5YTPTLkTiGKHI6Qe115kFoyX58YgaW0qYBkv6o9AziLvKdimHbPOGepgb44h4
         mzvdFkwJ0UuukAL7MBFDuYqBQ7qmF7FQJtSZrsAyl+BiB9B4nmX4rvZmwl8TcRhOvWlG
         zxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Utax3e55p3N2FiK+44m4EPF0IspqZNOsObveiGZKnps=;
        b=TZ1P0KYjTsXXPwCcBGP2TeuBcfoHOSKMRBPSrS2U5aIiFEKmo7aOU3bg3SAAWlWHlt
         t6Z5W1/0RRGB2hC3SHusl4qjKNYMj+PEdRUtTRL+8jXCQCi7yg6stPitgwnEs89FpMuu
         gAXSx1YIVXdg6/PwbClGeHdVHCQdgdczMpBa1nYrWrwliCh6ZinsCHusGnGjt3FI/lXj
         d+9a4Oz0g9VJetzJ/2prglUepBff6JV7vowzOfP+EbUi5yc8L6P5dMoSxnLbgSykrCUg
         fJec1aj6b8rP7uemfjYagL1QoYd9bXQEK2yPbbCxl8MbSE6PfNhtIQuSZR4LoIt6slnx
         cpqg==
X-Gm-Message-State: AO0yUKV8uahZaWbrUZevNmyx2dpseJxHGeO0xhhBOvqgYq+K7t5rqv7i
        LiHvEqkVvwyfUavXIGEI6rhXZcXLODo=
X-Google-Smtp-Source: AK7set8uqJFTeifQRndK5OY7LsjNYEZihFhZGcRxMmqtrSL2SRl7UXNO3Bil4Wyqwogd1sRe6etbqkK7/G4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:66c6:0:b0:4fc:1da2:5f95 with SMTP id
 c6-20020a6566c6000000b004fc1da25f95mr1307512pgw.7.1677115288904; Wed, 22 Feb
 2023 17:21:28 -0800 (PST)
Date:   Wed, 22 Feb 2023 17:21:27 -0800
In-Reply-To: <Y/ammgkyo3QVon+A@zn.tnic>
Mime-Version: 1.0
References: <Y+bXjxUtSf71E5SS@google.com> <Y+4wiyepKU8IEr48@zn.tnic>
 <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic> <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic> <Y/aTmL5Y8DtOJu9w@google.com> <Y/aYQlQzRSEH5II/@zn.tnic>
 <Y/adN3GQJTdDPmS8@google.com> <Y/ammgkyo3QVon+A@zn.tnic>
Message-ID: <Y/a/lzOwqMjOUaYZ@google.com>
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Dave Hansen <dave.hansen@intel.com>,
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
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023, Borislav Petkov wrote:
> On Wed, Feb 22, 2023 at 02:54:47PM -0800, Sean Christopherson wrote:
> > Why?  I genuinely don't understand the motivation for bundling all of this stuff
> > under a single "feature".
> 
> It is called "sanity".
> 
> See here:
> 
> https://lore.kernel.org/r/Y%2B5immKTXCsjSysx@zn.tnic
> 
> We support SEV, SEV-ES, SEV-SNP, TDX, HyperV... guests and whatever's
> coming down the pipe. And all that goes into arch/x86/ kernel proper
> code.
> 
> The CC_ATTR stuff is clean-ish in the sense that we have separation by
> confidential computing platform - AMD's and Intel's. Hyper-V comes along
> and wants to define a different subset of that. And that's only the
> SEV-SNP side - there's a TDX patchset too.
> 
> And then some other hypervisor will come along and say, but but, I wanna
> have X and Y and a pink pony too.
> 
> Oh, and there's this other fun with MTRRs where each HV decides to do
> whatever it wants.

The MTRR mess isn't unique to coco guests, e.g. KVM explicitly "supports" VMMs
hiding MTTRs from the guest by defaulting to WB if MTTRs aren't exposed to the
guest.  Why on earth Hyper-V suddenly needs to enlighten the guest is beyond me,
but whatever the reason, it's not unique to coco VMs.

> So, we have a zoo brewing on the horizon already!
> 
> If there's no clean definition of what each guest is and requires and
> that stuff isn't documented properly and if depending on which "feature"
> I need to check, I need to call a different function or query
> a different variable, then it won't go anywhere as far as guest support
> goes.
> 
> The cc_platform_has() thing gives us a relatively clean way to abstract
> all those differences away and keep the code sane-ish.

For features that are inherent to the platform, I agree, or at least I don't hate
the interface.  But defining a platform to have specific devices runs counter to
pretty much the entire x86 ecosystem.  At some point, there _will_ be more devices
in private memory than just IO-APIC and TPM, and conversely there will be "platforms"
that support a trusted TPM but not a trusted IO-APIC, and probably even vice versa.

All I'm advocating is that for determining whether or not a device should be mapped
private vs. shared, provide an API so that the hypervisor-specific enlightened code
can manage that insanity without polluting common code.  If we are ever fortunate
enough to have common enumeration, e.g. through ACPI or something, the enlightened
code can simply reroute to the common code.  This is a well established pattern for
many paravirt features, I don't see why it wouldn't work here.
