Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61CB114EE70
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgAaO3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:29:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgAaO3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 09:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wII15MgeqWbZfMqpukw8WbJXMIjvvlTLwoyDgIUTqRM=; b=ShZjamFMEFEi8ZK6lvRTAfg72t
        Vnb01CyPnJ7r54jskpVozNRpja4cak/rpQ3EA+z8tdCxGk/ma0n7XNXXYSzDi8aJs81HiyfqbzIDI
        TBwGIdJHIzI15tZXE3NfSucMK1mqWPVg/4N3IYkodR379POfvridvakg2WpfKOtGPAOs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixXIA-0007bY-Q6; Fri, 31 Jan 2020 15:29:06 +0100
Date:   Fri, 31 Jan 2020 15:29:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jon Nettleton <jon@solid-run.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200131142906.GG9639@lunn.ch>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
 <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > But by design SFP, SFP+, and QSFP cages are not fixed function network
> > adapters.  They are physical and logical devices that can adapt to
> > what is plugged into them.  How the devices are exposed should be
> > irrelevant to this conversation it is about the underlying
> > connectivity.
> 
> Apologies - I was under the impression that SFP and friends were a
> physical-layer thing and that a MAC in the SoC would still be fixed such
> that its DMA and interrupt configuration could be statically described
> regardless of what transceiver was plugged in (even if some configurations
> might not use every interrupt/stream ID/etc.) If that isn't the case I shall
> go and educate myself further.

Hi Robin

It gets interesting with QSFP cages. The Q is quad, there are 4 SERDES
lanes. You can use them for 1x 40G link, or you can split them into 4x
10G links. So you either need one MAC or 4 MACs connecting to the
cage, and this can change on the fly when a modules is ejected and
replaced with another module. There are only one set of control pins
for i2c, loss of signal, TX disable, module inserted. So where the
interrupt/stream ID/etc are mapped needs some flexibility.

There is also to some degree a conflict with hiding all this inside
firmware. This is complex stuff. It is much better to have one core
implementing in Linux plus some per hardware driver support, than
having X firmware blobs, generally closed source, each with there own
bugs which nobody can fix.

     Andrew
