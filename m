Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2259C14F92C
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 18:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBARgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 12:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgBARgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 12:36:23 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A7DC20678;
        Sat,  1 Feb 2020 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580578582;
        bh=KuaxtJRw14v59ff+I3CJb9O7IIbfHXwjQfiE5sV/mdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=npYR5SuSSCd/RxiufbwuT5b4Zl8DzXdHMvm2gczI+LuLTrmyTyRHAxb8GqPRusVOi
         Nksy1LlWZ878WB0PdUdrVy/8Ii2I44Uj6dzZknH6IzTQTsdL+SqTTz+l5y69hwYEb7
         /5shIJwIWw2mwK7nG7bHMe+sX4ZF1a4Tus98IhLg=
Date:   Sat, 1 Feb 2020 09:36:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jiri Pirko <jiri@mellanox.com>, Andrew Lunn <andrew@lunn.ch>,
        Robin Murphy <robin.murphy@arm.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Jon Nettleton <jon@solid-run.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200201093620.4b55d6fa@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200201114919.GQ25745@shell.armlinux.org.uk>
References: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
        <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
        <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
        <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
        <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
        <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
        <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
        <20200131142906.GG9639@lunn.ch>
        <20200131151500.GO25745@shell.armlinux.org.uk>
        <20200131074050.38d78ff0@cakuba.hsd1.ca.comcast.net>
        <20200201114919.GQ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 11:49:19 +0000, Russell King - ARM Linux admin wrote:
> What if someone decides to do:
> 
> 	devlink port split device/1 count 2
> 
> what do we end up with?  Presumably two network devices running with
> two serdes lanes each (if supported by the hardware).  At that point
> can they then do:
> 
> 	devlink port split device/2 count 2
> 
> and end up with one network device with two 10G serdes lanes, and two
> network devices each with one 10G serdes lane, 

I think all your guesses are correct, it's a pretty straight forward
API, but it's also pretty thin, and some of the logic is in FW, so
there isn't much in a way of a standard on how things should behave :S

> or can port splitting only be used on the "master" device/port ?

I think both mlxsw and the NFP rejects re-split/further splitting.
Ports have to be unsplit first. So there is only one device for
splitting, and unsplitting can be done on any of the sub-devices.

> Unfortunately, I don't think I have any network devices that support
> this so I can't experiment to find out how this should work; yes, I
> have a Mellanox card, but it supports a single 10G SFP+, and therefore
> does not support port splitting.

I think you'd need a mlxsw or an nfp to play with this.

Maybe Jiri can clarify further :)
