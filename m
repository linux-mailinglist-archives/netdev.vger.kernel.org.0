Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E216363BBD8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiK2Iku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiK2Ikt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:40:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28092D4;
        Tue, 29 Nov 2022 00:40:48 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2F66B1EC04AD;
        Tue, 29 Nov 2022 09:40:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669711247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=LtafUuhoGhuxiOxEKxOMOok0bCWTN1htaAAgYkWpfmw=;
        b=i5XWBIBr7fytFgs7Uf48RLs5dWMHp5K+KK9mvmX6p+c/f8RiFg1SkSTuEH3YhFg2LUJpue
        0Xgl2zSKsATfHJFPsmiZbVgMxftc/Rlo/tFBkhM3/tkfCFrnhCPpLzT8jsQEis6ic4I2KS
        Ai7bkeoFc5//t614TyupdVgfKsrswu4=
Date:   Tue, 29 Nov 2022 09:40:46 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
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
Subject: Re: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use
 standard coco mechanisms
Message-ID: <Y4XFjqEATqOgEnR6@zn.tnic>
References: <BYAPR21MB16886AF404739449CA467B1AD70D9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y31Kqacbp9R5A1PF@zn.tnic>
 <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
 <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4USb2niHHicZLCY@zn.tnic>
 <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:15:39AM +0000, Michael Kelley (LINUX) wrote:
> So that's why I'm suggesting CC_VENDOR_AMD_VTOM.

There's no CC_VENDOR_AMD_VTOM. How many times do I need to explain this?!
CC_VENDOR is well the CC vendor - not some special case.

IOW, the goal here is for generic SNP functionality to be the same for
*all* SNP guests. We won't do the AMD's version of vTOM enablement,
Hyper-V's version of vTOM enablement and so on. It must be a single
vTOM feature which works on *all* hypervisors as vTOM is a generic SNP
feature - not Hyper-V feature.

> Of course, when you go from N=1 hypervisors (i.e., KVM) to N=2 (KVM
> and Hyper-V, you find some places where incorrect assumptions were
> made or some generalizations are needed. Dexuan Cui's patch set for
> TDX support is fixing those places that he has encountered. But with
> those fixes, the TDX support will JustWork(tm) for Linux guests on
> Hyper-V.

That sounds like the right direction to take.

> I haven't gone deeply into the situation with AMD C-bit support on
> Hyper-V. Tianyu Lan's set of patches for that support is a bit bigger,
> and I'm planning to look closely to understand whether it's also just
> fixing incorrect assumptions and such, or whether they really are
> some differences with Hyper-V. If there are differences, I want to
> understand why.

You and me too. So I guess we should look at Tianyu's set first.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
