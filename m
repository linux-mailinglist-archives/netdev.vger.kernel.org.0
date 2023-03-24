Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7276C8124
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbjCXPYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbjCXPYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73818F77D;
        Fri, 24 Mar 2023 08:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A435B824F8;
        Fri, 24 Mar 2023 15:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F96C433EF;
        Fri, 24 Mar 2023 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679671467;
        bh=jOuFrReXEcmNuXh48EzaKOxXoRuwvYMtKdgb5EN0x2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4rjk5/4fCLDYsZ5Pz+6iIesW3ftkP0Qw2eR3A+P7kCtTCqII0uwahfAftC2UASHI
         tn3wkODgEA/o8SqZ6zloKnijXRxo+9NFG9BGiVusrdjb/wZgGVm8SKzEFOCRaiwFjw
         avkMfwuIVl5dsfQE/nctb674GJK+pBX+k0w6HfDOxdHVoR/gNorJkTkAJqQ/20VRFt
         2whdHWHfBoe5N3Z6ElPzvw9OQ6jGzud+oqXxKBgtPKvWev7HsJCPSOirgfFh5HKIYx
         0Xr4mNzf8CejJmJoLOxwsWZ5GuYN46mxVqGqRVKBLqS4VdhBajDNQLQL1KL1UnCPYQ
         SI8jSmqMJQ3fA==
Date:   Fri, 24 Mar 2023 16:24:14 +0100
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
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
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
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
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v6 12/13] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <ZB3AnngemTf8vKlA@lpieralisi>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-13-git-send-email-mikelley@microsoft.com>
 <ZB24Kdu6WMGYH1L7@lpieralisi>
 <BYAPR21MB1688C99BC6C86DEAC22C35D1D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1688C99BC6C86DEAC22C35D1D7849@BYAPR21MB1688.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 03:13:02PM +0000, Michael Kelley (LINUX) wrote:
> From: Lorenzo Pieralisi <lpieralisi@kernel.org> Sent: Friday, March 24, 2023 7:48 AM
> > 
> > On Wed, Mar 08, 2023 at 06:40:13PM -0800, Michael Kelley wrote:
> > > To support PCI pass-thru devices in Confidential VMs, Hyper-V
> > > has added hypercalls to read and write MMIO space. Add the
> > > appropriate definitions to hyperv-tlfs.h and implement
> > > functions to make the hypercalls.
> > >
> > > Co-developed-by: Dexuan Cui <decui@microsoft.com>
> > > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > > Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
> > >  drivers/pci/controller/pci-hyperv.c | 64
> > +++++++++++++++++++++++++++++++++++++
> > >  include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
> > >  3 files changed, 89 insertions(+)
> > 
> > Nit: I'd squash this in with the patch where the calls are used,
> > don't think this patch is bisectable as it stands (maybe you
> > split them for review purposes, apologies if so).
> > 
> > Lorenzo
> 
> I did split the new code into two patches to make it more
> consumable from a review standpoint.  But I'm not understanding
> what you mean by not being bisectable.  After applying the first
> of the two patches, everything should still compile and work
> even though there are no users of the new hypercalls.  Or maybe
> your concern is that there would be "unused function" warnings?

That's what I meant - that's it.
 
> In any case, squashing the two patches isn't a problem.

Thanks,
Lorenzo
