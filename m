Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1C86B27C9
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjCIOwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjCIOvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:51:37 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06738F4039;
        Thu,  9 Mar 2023 06:50:11 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0AC781EC06C0;
        Thu,  9 Mar 2023 15:45:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678373109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=If/RB/hr/c7VUMqd+cgR77ldxUk5sLws7vhF9to8FDQ=;
        b=jus71OLR74X/1ogUazggcBxXv8CUTmUJ1nEFSUoX3c2qdRny1LQLWh9C1o6fblZiFQqeMB
        aZ1BaeLhfeAOgz3a0/k6Rz9q2rDEQvgImmdDPFWDJaDR93eM4YldkMU+jxzTn4PyNgGxpp
        Pgtvm//JDTh8xON5nJ7CO7crxDtsGkY=
Date:   Thu, 9 Mar 2023 15:45:05 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
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
Subject: Re: [PATCH v5 06/14] x86/ioremap: Support hypervisor specified range
 to map as encrypted
Message-ID: <20230309144505.GEZAnw8QpyOyMpCD4r@fat_crate.local>
References: <Y/ammgkyo3QVon+A@zn.tnic>
 <Y/a/lzOwqMjOUaYZ@google.com>
 <Y/dDvTMrCm4GFsvv@zn.tnic>
 <BYAPR21MB1688F68888213E5395396DD9D7AB9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <255249f2-47af-07b7-d9d9-9edfdd108348@intel.com>
 <20230306215104.GEZAZgSPa4qBBu9lRd@fat_crate.local>
 <a23a36ccb8e1ad05e12a4c4192cdd98267591556.camel@infradead.org>
 <20230309115937.GAZAnKKRef99EwOu/S@fat_crate.local>
 <a4fc8686-f82d-370e-309f-d6d3fc0568e8@amd.com>
 <ZAnu/Um+4qq4Owuh@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAnu/Um+4qq4Owuh@8bytes.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:36:45PM +0100, Jörg Rödel wrote:
> Yes, that is right. The key is mainly for the NMI entry path which can
> be performance relevant in some situations. For SEV-ES some special
> handling is needed there to re-enable NMIs and adjust the #VC stack in
> case it was raised on the VC-handlers entry path.

So the performance argument is meh. That key will be replaced by

	if (cc_vendor == CC_VENDOR_AMD &&
	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT)

which is something like 4 insns or so. Tops.

Haven't looked yet but it should be cheap.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
