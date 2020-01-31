Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EE914EFEB
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgAaPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:42:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60264 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgAaPmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=af7+Bsa4FLscpB6733Wg20Cckf2L8D3h7E9G+fD24P0=; b=jd35rxH9/vacgzLSEFyxHa9YOs
        qqBY5xOsAhIAt5OVjZwrns5lyMi1mgIVC7GYsmM9eG7ijC7dsGaoBHuGeTWYwjYp+S7AJoBhI3KSG
        dFSvihcIN+LcaURbfwMmPoPPDCUBWoPjbcNphkrbKNLB5cfXZ9336rk6/64j5vOm/4SU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixYQf-000824-IP; Fri, 31 Jan 2020 16:41:57 +0100
Date:   Fri, 31 Jan 2020 16:41:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jon Nettleton <jon@solid-run.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
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
Message-ID: <20200131154157.GE13902@lunn.ch>
References: <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
 <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
 <20200131142906.GG9639@lunn.ch>
 <20200131144737.GA4948@willie-the-truck>
 <20200131150929.GB13902@lunn.ch>
 <CABdtJHs5zdS=unviHX3=Gsbf=q9ooS0sYMUAbtvaZT0D0ORNkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdtJHs5zdS=unviHX3=Gsbf=q9ooS0sYMUAbtvaZT0D0ORNkw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just as a review reference, I have found an old attempted
> implementation documented here.
> https://github.com/CumulusNetworks/apd-tools/wiki

That is interesting, but you need to be careful with it.

Top of rack switches are very different beasts to the majority of
switches supported by Linux, which are SOHO. TOR switches have a lot
of firmware running on them doing most of the work. A typical SOHO
switch with a Linux kernel driver has very little firmware, Linux
really is driving it, not just asking it to do things.

Also, TOR switches typically have a binary blob running in userspace,
meaning different information is probably required compared to kernel
driver.

There may be useful information here, but please take it with a big
pinch of salt. And make sure you have the appropriate networking
people involved in any specification work you do.

      Andrew
