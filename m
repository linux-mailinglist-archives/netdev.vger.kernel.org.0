Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3069FEC8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjBVWyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjBVWyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:54:52 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA7937F1A
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:54:50 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s20-20020a056a00179400b005c4d1dedc1fso4942864pfg.11
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1rUxcsEzgzkuc81EHAiSJThwOfOiPUl0WEkc2IML/M=;
        b=p4sXIDbjE4Nc/nRU1X8iV1XYE4jomrb+UJhtC7J+xEm7INBfiDn27gs/eoHnGlzmRT
         92NbvCgseDZ0JsQv3XF/gwcMtKevWDZckWffhhm1iVJQBk+R5lUHI6CKSOloHvmr5SXD
         BvdY7F8b50dcNqhHzIYk3cub1ZEBEA8+kXj+nWZ5dvUznAb22X/ufd/HOqJW5U4x5C4B
         JQ1TG20xtnMqed4yXHC4Ock+whPxUyHQMHZjkt/JIt8uxh8Qe/UOObrTwEnXqaCLC3js
         c4oFz5cV9DaUM/VtN6S58luTPLE4WRjwkm5QlSNnfO16B01aCPeJv7rypyvXDzgyxkMp
         sLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1rUxcsEzgzkuc81EHAiSJThwOfOiPUl0WEkc2IML/M=;
        b=sKoVRK9PsqODIC4V6ZhdfTdQdF7LD7Ths1HmazGiz7GFRaXDJnVWVzUXVwSBCcdEUv
         ZJlzHDu/yFpBqhSOgvZqYU6RrMb4+ilnUhysIbIOcgb2QIvUhK3pByWJFAlCQFo7oFLF
         qPgkTXSpbxv2ziZ8x4VjbC/bRfocCqAJ50uufR2NCB9pdunPyQN53i1Z8QMFp91g83KZ
         dXS+Evps/Hdm41Dtf+3RJ3hOYuxNIZ6t6cQ0M6Gfy5reS91wzJ28L8mGf4PvWVgXYlPy
         h/I4nu2U0dFoVEzFw6/XIZYFSPOpzRWwo9LFYrRhlBnAdrymTNg1QW+KeVEDCfdOj7bp
         F6GA==
X-Gm-Message-State: AO0yUKX8aA6/P9YFEmN1qQxE+Mon1Y1NKP3SoZKDR3PWVc+uQkPHyVN3
        W32kfX30IOmxXw3AMpDY9o1Xg0vwpv8=
X-Google-Smtp-Source: AK7set/sQOffs0k3s7KounKG129lsIZ65HRvR+ia/A/0i253S1K0NbH2/JiaGq46cARK3kvQ+iKylGsp5hE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:864e:0:b0:5d6:4f73:9ad with SMTP id
 x75-20020a62864e000000b005d64f7309admr454083pfd.2.1677106489373; Wed, 22 Feb
 2023 14:54:49 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:54:47 -0800
In-Reply-To: <Y/aYQlQzRSEH5II/@zn.tnic>
Mime-Version: 1.0
References: <Y+av0SVUHBLCVdWE@google.com> <BYAPR21MB168864EF662ABC67B19654CCD7DE9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+bXjxUtSf71E5SS@google.com> <Y+4wiyepKU8IEr48@zn.tnic> <BYAPR21MB168853FD0676CCACF7C249B0D7A09@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y+5immKTXCsjSysx@zn.tnic> <BYAPR21MB16880EC9C85EC9343F9AF178D7A19@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y++VSZNAX9Cstbqo@zn.tnic> <Y/aTmL5Y8DtOJu9w@google.com> <Y/aYQlQzRSEH5II/@zn.tnic>
Message-ID: <Y/adN3GQJTdDPmS8@google.com>
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

On Wed, Feb 22, 2023, Borislav Petkov wrote:
> On Wed, Feb 22, 2023 at 02:13:44PM -0800, Sean Christopherson wrote:
> > Because vTOM is a hardware feature, whereas the IO-APIC and vTPM being accessible
> > via private memory are software features.  It's very possible to emulate the
> > IO-APIC in trusted code without vTOM.
> 
> I know, but their use case is dictated by the fact that they're using
> a SNP guest *with* vTOM as a SEV feature. And so their guest does
> IO-APIC and vTPM *with* the vTOM SEV feature. That's what I'm trying to
> model.

Why?  I genuinely don't understand the motivation for bundling all of this stuff
under a single "feature".  To me, that's like saying Haswell or Zen2 is a "feature",
but outside of a very few cases where the exact uarch truly matters, nothing pivots
on FMS because the CPU type is not a single feature.
