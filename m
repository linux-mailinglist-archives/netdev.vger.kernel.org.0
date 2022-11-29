Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0488C63C6B3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbiK2RrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiK2RrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:47:12 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B239754B1B;
        Tue, 29 Nov 2022 09:47:11 -0800 (PST)
Received: from zn.tnic (p200300ea9733e724329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e724:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DDD711EC04CB;
        Tue, 29 Nov 2022 18:47:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669744029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JYhgRUKR3FJNpFBq84Sg5nW8vU15kq68SWoPzofwG0Q=;
        b=C9yhgsGHLVsG8saaLstTe4dmxJhjJrBTCPd3mxTbQfv/ZNKgNmjwaJFRkyIDeReJdY8oJp
        ijIxUTdRKklOYNwQC8739rCLHnOBfPiMOPxKOA45aWsUni+NS12zAui7+VMmWL4BjXL+IF
        GJdt2hcUVZySzvYGVvQ2SxFp4+cFRpM=
Date:   Tue, 29 Nov 2022 18:47:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
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
Message-ID: <Y4ZFmktxPlEjyoeR@zn.tnic>
References: <BYAPR21MB16886FF8B35F51964A515CD5D70C9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <BYAPR21MB1688AF2F106CDC14E4F97DB4D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Ti4UTBRGmbi0hD@zn.tnic>
 <BYAPR21MB1688466C7766148C6B3B4684D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4Tu1tx6E1CfnrJi@zn.tnic>
 <BYAPR21MB1688BCC5DF4636DBF4DEA525D7139@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4USb2niHHicZLCY@zn.tnic>
 <BYAPR21MB16886FF5A63334994476B6ADD7129@BYAPR21MB1688.namprd21.prod.outlook.com>
 <Y4XFjqEATqOgEnR6@zn.tnic>
 <BYAPR21MB1688D73FBBF41B6E21265DA3D7129@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688D73FBBF41B6E21265DA3D7129@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 03:49:06PM +0000, Michael Kelley (LINUX) wrote:
> But it turns out that AMD really has two fairly different schemes:
> the C-bit scheme and the vTOM scheme.

Except it doesn't:

"In the VMSA of an SNP-active guest, the VIRTUAL_TOM field designates
a 2MB aligned guest physical address called the virtual top of memory.
When bit 1 (vTOM) of SEV_FEATURES is set in the VMSA of an SNP-active
VM, the VIRTUAL_TOM..."

So SEV_FEATURES[1] is vTOM and it is part of SNP.

Why do you keep harping on this being something else is beyond me...

I already pointed you to the patch which adds this along with the other
SEV_FEATURES.

> The details of these two AMD schemes are pretty different. vTOM is
> *not* just a minor option on the C-bit scheme. It's an either/or -- a
> guest VM is either doing the C-bit scheme or the vTOM scheme, not some
> combination. Linux code in coco/core.c could choose to treat C-bit and
> vTOM as two sub-schemes under CC_VENDOR_AMD, but that makes the code a
> bit messy because we end up with "if" statements to figure out whether
> to do things the C-bit way or the vTOM way.

Are you saying that that:

	if (cc_vendor == CC_VENDOR_AMD &&
	    sev_features & MSR_AMD64_SNP_VTOM_ENABLED)

is messy? Why?

We will have to support vTOM sooner or later.

> Or we could model the two AMD schemes as two different vendors,
> which is what I'm suggesting.  Doing so recognizes that the two schemes
> are fairly disjoint, and it makes the code cleaner.

How is that any different from the above check?

You *need* some sort of a check to differentiate between the two anyway.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
