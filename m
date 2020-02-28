Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A017398A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgB1OLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:11:39 -0500
Received: from foss.arm.com ([217.140.110.172]:39026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgB1OLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 09:11:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A6DC31B;
        Fri, 28 Feb 2020 06:11:37 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B99B3F7B4;
        Fri, 28 Feb 2020 06:11:33 -0800 (PST)
Date:   Fri, 28 Feb 2020 14:11:30 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Rob Herring <robh@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        soc@kernel.org, Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH 06/11] iommu: arm-smmu: Remove Calxeda secure mode
 quirk
Message-ID: <20200228141130.18be5bb8@donnerap.cambridge.arm.com>
In-Reply-To: <20200228135645.GA4745@willie-the-truck>
References: <20200218171321.30990-1-robh@kernel.org>
        <20200218171321.30990-7-robh@kernel.org>
        <20200218172000.GF1133@willie-the-truck>
        <CAL_JsqJn1kG6gah+4318NQfJ4PaS3x3woWEUh08+OTfOcD+1MQ@mail.gmail.com>
        <20200228100446.GA2395@willie-the-truck>
        <20200228102556.1dde016e@donnerap.cambridge.arm.com>
        <20200228105024.GC2395@willie-the-truck>
        <20200228134254.03fc5e1b@donnerap.cambridge.arm.com>
        <20200228135645.GA4745@willie-the-truck>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 13:56:46 +0000
Will Deacon <will@kernel.org> wrote:

> On Fri, Feb 28, 2020 at 01:42:54PM +0000, Andre Przywara wrote:
> > On Fri, 28 Feb 2020 10:50:25 +0000
> > Will Deacon <will@kernel.org> wrote:  
> > > On Fri, Feb 28, 2020 at 10:25:56AM +0000, Andre Przywara wrote:  
> > > > > On Tue, Feb 25, 2020 at 04:01:54PM -0600, Rob Herring wrote:    
> > > > > > Seems we're leaving the platform support for now, but I think we never
> > > > > > actually enabled SMMU support. It's not in the dts either in mainline
> > > > > > nor the version I have which should be close to what shipped in
> > > > > > firmware. So as long as Andre agrees, this one is good to apply.      
> > > > > 
> > > > > Andre? Can I queue this one for 5.7, please?    
> > > > 
> > > > I was wondering how much of a pain it is to keep it in? AFAICS there are
> > > > other users of the "impl" indirection. If those goes away, I would be
> > > > happy to let Calxeda go.    
> > > 
> > > The impl stuff is new, so we'll keep it around. The concern is more about
> > > testing (see below).
> > >   
> > > > But Eric had the magic DT nodes to get the SMMU working, and I used that
> > > > before, with updating the DT either on flash or dynamically via U-Boot.    
> > > 
> > > What did you actually use the SMMU for, though? The
> > > 'arm_iommu_create_mapping()' interface isn't widely used and, given that
> > > highbank doesn't support KVM, the use-cases for VFIO are pretty limited
> > > too.  
> > 
> > AFAIK Highbank doesn't have the SMMU, probably mostly for that reason.
> > I have a DT snippet for Midway, and that puts the MMIO base at ~36GB, which is not possible on Highbank.
> > So I think that the quirk is really meant and needed for Midway.  
> 
> Sorry, but I don't follow your reasoning here. The MMIO base has nothing
> to do with the quirk,

It hasn't, but Highbank has no LPAE, so couldn't possible have a device at such an address. And this is the only MMIO address I know of.

> although doing some digging it looks like your
> conclusion about this applying to Midway (ecx-2000?) is correct:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/226095.html

Right, thanks for that find. Yes, Midway is the codename for the ECX-2000 SoC product.

Cheers,
Andre
 
> > > > So I don't know exactly *how* desperate you are with removing this, or if
> > > > there are other reasons than "negative diffstat", but if possible I would
> > > > like to keep it in.    
> > > 
> > > It's more that we *do* make quite a lot of changes to the arm-smmu driver
> > > and it's never tested with this quirk. If you're stepping up to run smmu
> > > tests on my queue for each release on highbank, then great, but otherwise
> > > I'd rather not carry the code for fun. The change in diffstat is minimal
> > > (we're going to need to hooks for nvidia, who broke things in a different
> > > way).  
> > 
> > I am about to set up some more sophisticated testing, and will include
> > some SMMU bits in it.  
> 
> Yes, please.
> 
> Will

