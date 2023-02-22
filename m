Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5939269FE49
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjBVWOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjBVWOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:14:16 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FCA2DE7C
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:13:46 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gm13-20020a17090b100d00b0023704a72ca5so3308602pjb.4
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v371wfsV4J0hP2YWPldN/jyK7SvY4U1Nw/7wNzhqMJ0=;
        b=SDx040f4cRwUIq1/Pn9rbyUg0nODn7NLzfPtTsxeLPrGL2xKNJKKpZMMN83uN7u2Wl
         B6St8Ul6KmHV9YkKNP0QNKLSJhgww930gocbdTCTZz31aQ+6H2IX036kJTxBmGsaDZuM
         pLwxQa5BKAWyjM4aTyFHZFsc1ggRCEsp717a+hUJiyhhx04l5kL+tUuk/kAJZOTrjGTZ
         29ABu9JHgYtZ53tH+cm0XR1UR9WYYbYTvZHxC9DaiYE0ivRTQb0Q9C7XK4d1z33omvkV
         2/J+qNvJJL1wWZ9XsxPfsY1hiJ8ljtFxZcTnopaPx2qxyvdb6x59W4AfE7hPt/tB78BC
         sbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v371wfsV4J0hP2YWPldN/jyK7SvY4U1Nw/7wNzhqMJ0=;
        b=Hx9rm322MRWefrkpuHL2E2TTxgxrtV80IYdbdR+vU0XEXSNcb/fjcphVTdf0IpkH2+
         2HuPrQrr8V4lwsKVciLAWEVP1gX8JTBq8naXmkqgIJ5AS03xUW/vQMglSQgt4I0M9sln
         MalD/kQxniCHI1OHSNr4bwYhF9j5Fu2tMc6/q0ti5anInBN1zUAR9riGzHFMegFKQupZ
         YqDdvPk4hjTiM0QsIsbQZ3wbYIe1Qrz2iIAYoa4MtPNq+BoG3xRCXs6Rsf6puv0+ADkn
         i2gpWw7u+887ZGIpGxVao5d1VmmqACo1vWjMKlczChifppXlOQ2yw5loq2rmeMgST31K
         vzJg==
X-Gm-Message-State: AO0yUKU6QKTijPPhz6qMcyjuEY3eYasmCmfGf0ex+YqDCk7exCoHaBAW
        oxjLNbJGfe9i5gQ2H8jkiuspe5WlCzA=
X-Google-Smtp-Source: AK7set9Z1FLoPTpNq0n7vXYMl00aKb3WH8eouCDkP/taHVgLQB9g+fM0rK3HFBezOkWsQvlPcHR7H0gXMhg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:ec6:b0:234:6a5:5e3e with SMTP id
 gz6-20020a17090b0ec600b0023406a55e3emr12361pjb.7.1677104025901; Wed, 22 Feb
 2023 14:13:45 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:13:44 -0800
In-Reply-To: <Y++VSZNAX9Cstbqo@zn.tnic>
Mime-Version: 1.0
References: <cb80e102-4b78-1a03-9c32-6450311c0f55@intel.com>
 <Y+auMQ88In7NEc30@google.com> <Y+av0SVUHBLCVdWE@google.com>
 <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com> <Y+4wiyepKU8IEr48@zn.tnic> <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic> <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic>
Message-ID: <Y/aTmL5Y8DtOJu9w@google.com>
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

On Fri, Feb 17, 2023, Borislav Petkov wrote:
> On Fri, Feb 17, 2023 at 06:16:56AM +0000, Michael Kelley (LINUX) wrote:
> > Is that consistent with your thinking, or is the whole
> > cc_platform_has() approach problematic, including for the existing SEV
> > flavors and for TDX?
> 
> The confidential computing attributes are, yes, features. I've been
> preaching since the very beginning that vTOM *is* *also* one such
> feature. It is a feature bit in sev_features, for chrissakes. So by that
> logic, those SEV-SNP HyperV guests should return true when
> 
> 	cc_platform_has(CC_ATTR_GUEST_SEV_SNP_VTOM);
> 
> is tested.
> 
> But Sean doesn't like that.

Because vTOM is a hardware feature, whereas the IO-APIC and vTPM being accessible
via private memory are software features.  It's very possible to emulate the
IO-APIC in trusted code without vTOM.

> If the access method to the IO-APIC and vTPM are specific to the
> HyperV's vTOM implementation, then I don't mind if this were called
> 
> 	cc_platform_has(CC_ATTR_GUEST_HYPERV_VTOM);

I still think that's likely to caused problems in the future, e.g. if Hyper-V
moves more stuff into the paravisor or if Hyper-V ends up with similar functionality
for TDX.  But it's not a sticking point, the only thing I'm fiercely resistant to
is conflating hardware features with software features.
