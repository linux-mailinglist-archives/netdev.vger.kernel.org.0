Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE5014EFD8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgAaPkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:40:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgAaPkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:40:52 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AE6D20707;
        Fri, 31 Jan 2020 15:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580485252;
        bh=p1kYkLVWMHwzIbsEGD46qdhZq5Y2YJPlobf+Blab68E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lfZ/hfqTb0BASsotmVHVHj2tQUvKafrX3wJzuaN3VhrqcZbum02xR0sPK280lWANx
         xIOmJZbqxvSv8A3k9XPcNLfLhegYjp5NgSDka9igFFVF6EeX+u5r7n2yeYthuilkA7
         1aYnGTH2/vTocVAYAJcanlDeXHDBQwV8mYaoAcyU=
Date:   Fri, 31 Jan 2020 07:40:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20200131074050.38d78ff0@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131151500.GO25745@shell.armlinux.org.uk>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
        <20200128110916.GA491@e121166-lin.cambridge.arm.com>
        <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
        <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
        <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
        <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
        <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
        <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
        <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
        <20200131142906.GG9639@lunn.ch>
        <20200131151500.GO25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 15:15:00 +0000, Russell King - ARM Linux admin
wrote:
> I have some prototype implementation for driving the QSFP+ cage, but
> I haven't yet worked out how to sensible deal with the "is it 4x 10G
> or 1x 40G" issue you mention above, and how to interface the QSFP+
> driver sensibly with one or four network drivers.

I'm pretty sure you know this but just FWIW - vendors who do it in FW
write the current config down in NVM so it doesn't get affected by
reboots and use devlink port splitting to change it.
