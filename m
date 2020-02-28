Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A026517353F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 11:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgB1K0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 05:26:09 -0500
Received: from foss.arm.com ([217.140.110.172]:36148 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgB1K0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 05:26:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0806D4B2;
        Fri, 28 Feb 2020 02:26:08 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FBBF3F73B;
        Fri, 28 Feb 2020 02:26:04 -0800 (PST)
Date:   Fri, 28 Feb 2020 10:25:56 +0000
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
Message-ID: <20200228102556.1dde016e@donnerap.cambridge.arm.com>
In-Reply-To: <20200228100446.GA2395@willie-the-truck>
References: <20200218171321.30990-1-robh@kernel.org>
        <20200218171321.30990-7-robh@kernel.org>
        <20200218172000.GF1133@willie-the-truck>
        <CAL_JsqJn1kG6gah+4318NQfJ4PaS3x3woWEUh08+OTfOcD+1MQ@mail.gmail.com>
        <20200228100446.GA2395@willie-the-truck>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 10:04:47 +0000
Will Deacon <will@kernel.org> wrote:

Hi,

> On Tue, Feb 25, 2020 at 04:01:54PM -0600, Rob Herring wrote:
> > On Tue, Feb 18, 2020 at 11:20 AM Will Deacon <will@kernel.org> wrote:  
> > >
> > > On Tue, Feb 18, 2020 at 11:13:16AM -0600, Rob Herring wrote:  
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Robin Murphy <robin.murphy@arm.com>
> > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > Cc: iommu@lists.linux-foundation.org
> > > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > > ---
> > > > Do not apply yet.  
> > >
> > > Pleeeeease? ;)
> > >  
> > > >  drivers/iommu/arm-smmu-impl.c | 43 -----------------------------------
> > > >  1 file changed, 43 deletions(-)  
> > >
> > > Yes, I'm happy to get rid of this. Sadly, I don't think we can remove
> > > anything from 'struct arm_smmu_impl' because most implementations fall
> > > just short of perfect.
> > >
> > > Anyway, let me know when I can push the button and I'll queue this in
> > > the arm-smmu tree.  
> > 
> > Seems we're leaving the platform support for now, but I think we never
> > actually enabled SMMU support. It's not in the dts either in mainline
> > nor the version I have which should be close to what shipped in
> > firmware. So as long as Andre agrees, this one is good to apply.  
> 
> Andre? Can I queue this one for 5.7, please?

I was wondering how much of a pain it is to keep it in? AFAICS there are other users of the "impl" indirection. If those goes away, I would be happy to let Calxeda go.
But Eric had the magic DT nodes to get the SMMU working, and I used that before, with updating the DT either on flash or dynamically via U-Boot.

So I don't know exactly *how* desperate you are with removing this, or if there are other reasons than "negative diffstat", but if possible I would like to keep it in.

Cheers,
Andre.
