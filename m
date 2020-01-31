Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AAB14EF4E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgAaPPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:15:32 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33869 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgAaPPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:15:32 -0500
Received: by mail-yw1-f66.google.com with SMTP id b186so5013715ywc.1
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 07:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKqqlpA+EkYjXixe2TS2xK7+DyD3uNKJKEB0gcN7Kss=;
        b=zM91B1671UUjUt7B4XhWH0jKv4TzeL2OGkjsxZr6YetTM6KnFw900Ukel/cRquX0U6
         /s2JfZpPbKUq/hyBOchczdnZP5oy6LHCnqrOZHmBiurBK22nhFbHBa0kNR9a7mmo7Ooy
         uXyyJl8Sw6q2bVInAbUXGqW1AXzLWuOuP7wcwOH0a406Qljft7LX0O9wfukjwAudPtZP
         NXoNfOkGncX1sLCF6A2cABmwx2anxLMJJj+k5cQQtCy9BdKCV+MVJFeKCh5ER4Mc2zJz
         wa+9WuxuAWSoLKZimoK3BKKytP0yZHM7LdE34XG08cOSXqyxkEWSXLPQyK9sCOJc/9ct
         zBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKqqlpA+EkYjXixe2TS2xK7+DyD3uNKJKEB0gcN7Kss=;
        b=r0MwJ13TiLc59tEYGZUfC5fbLwz0onS/1QTqppa+SWEM+QvkdYcPK+U/gDE4ZwW3WX
         c9EBYHAKM3fceUjlfIqWvEMKin7pOO9p6+56Ie4ixUyocaGg4tsgXOLyeGcATIs55L+A
         YC9KejHVNPdcr8eRxdXIEvZ+1dJkVCVLoJ9pwsYD8vYNJA4f6jKMZ6IwMwElXf0jlDG4
         hDic0GKtOAsrmu17XhVU75ykqiqKk9qDZ1MNI1u5hWl5/YRarI0DxKaBZoWBCd4kLr35
         CdDlr7J5pGApyvfqiOTv/tUqbzo/8LHdxBu00jq6h3kSBHoInEmJuiP4UgIYqIlVWo8n
         UCXg==
X-Gm-Message-State: APjAAAURDl5m0tkn6fr5cawj5pSrEEhpMsmDhvNX+89srUaJ9gEMQCNP
        Y0iZlqRlTKanRsLB4Vc3OzfTW4wbkGZwCqpJV/mOyg==
X-Google-Smtp-Source: APXvYqwsAGpGy6tic5rDdkc84xGCO6z1ubMWeOs7PNuXCUuhqHHO+HdXDIU+E2oTbdCyqF+X9ln5AxdumM3moQc/u34=
X-Received: by 2002:a25:e790:: with SMTP id e138mr822292ybh.120.1580483731154;
 Fri, 31 Jan 2020 07:15:31 -0800 (PST)
MIME-Version: 1.0
References: <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org> <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com> <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com> <20200131142906.GG9639@lunn.ch>
 <20200131144737.GA4948@willie-the-truck> <20200131150929.GB13902@lunn.ch>
In-Reply-To: <20200131150929.GB13902@lunn.ch>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Fri, 31 Jan 2020 16:14:55 +0100
Message-ID: <CABdtJHs5zdS=unviHX3=Gsbf=q9ooS0sYMUAbtvaZT0D0ORNkw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     Andrew Lunn <andrew@lunn.ch>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 4:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Devicetree to the rescue!
>
> Yes, exactly. We have good, standardised descriptions for most of this
> in device tree. And phylink can handle SFP and SFP+. Nobody has worked
> on QSFP yet, since phylink has mostly been pushed by the embedded
> world and 40G is not yet popular in the embedded world.
>
> > Entertaining the use of ACPI without any firmware abstraction for this
> > hardware really feels like a square peg / round hole situation, so I'm
> > assuming somebody's telling you that you need it "FOAR ENTAPRYZE". Who
> > is it and can you tell them to bog off?
>
> The issues here is that SFPs are appearing in more and more server
> systems, replacing plain old copper Ethernet. If the boxes use off the
> shelf Mellanox or Intel PCIe cards, it is not an issue. But silicon
> vendors are integrating this into the SoC in the ARM way of doing
> things, memory mapped, spread over a number of controllers, not a
> single PCIe device.
>
> Maybe we need hybrid systems. Plain, old, simple, boring things like
> CPUs, serial ports, SATA, PCIe busses are described in ACPI. Complex
> interesting things are in DT. The hard thing is the interface between
> the two. DT having a phandle to an ACPI object, e.g a GPIO, interrupt
> or an i2c bus.
>
>    Andrew

Just as a review reference, I have found an old attempted
implementation documented here.
https://github.com/CumulusNetworks/apd-tools/wiki

-Jon
