Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6443F19F841
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 16:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgDFOwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 10:52:41 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39332 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgDFOwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 10:52:41 -0400
Received: by mail-yb1-f194.google.com with SMTP id h205so8915576ybg.6;
        Mon, 06 Apr 2020 07:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4wjTXsPVYDAF0Rh7pFMNhwtFuty/N2rOqgxDEfZ/Sw=;
        b=SBhq0q/ZK03IfVa4a6D2mf9RXC2ytcswUYBcuVaz3kuZsif/61gpy1LRRI+zsU6++O
         fWVrwWYFL0SbAiVsex7wd79xGP9NzMufXbwc9DWj074Pt4NsigrVSrH3gj0tjk8TOJi7
         iwB6q8g14hF1e0DFdkMKFoS4FIbzSbZFCL0Irn09eu6+beuSgYYkGbzi2GeB0mv7Cybe
         bYt0oMbKrQOaPokPGCjKGImNAW7m7SWarLy9Snr3MnsldszuNH74KBXIqUbfzLLn4GuP
         RoFF4GUSMv/5pwjTzaOe8thYd6YgfJ5DK97R8qy7HI+bcnv1r8Rzd9uBfrtMcMbKyX2u
         gjmg==
X-Gm-Message-State: AGi0Pub8refGSTXDCBZCcYc49hPN6tCowtQ5SoSgQBmGAGW8gmkEyYhl
        /upL4vTUb7s91IdkzepOKKxsEzJpQ71Nuzjm+QQ=
X-Google-Smtp-Source: APiQypI1cMI5XMrDE3mSE6bbYAawc2oBNbpcDCRXHpJDoX3XOsXlC/vfwSZUcgq4MmsZjYrhcfzTbDuI279TT3hvxUQ=
X-Received: by 2002:a25:aa29:: with SMTP id s38mr34746167ybi.325.1586184759706;
 Mon, 06 Apr 2020 07:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585917191.git.nicolas.ferre@microchip.com>
 <CAFcVECLkPxN0nk=jr9AxJoV3i1jHBoY4s3yeodHDO2uOZspQPg@mail.gmail.com> <9e2ab6cd-526d-f1b5-4bd0-4a8f80d9dd8f@microchip.com>
In-Reply-To: <9e2ab6cd-526d-f1b5-4bd0-4a8f80d9dd8f@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Mon, 6 Apr 2020 20:22:28 +0530
Message-ID: <CAFcVECLHkLSa+PaRWyoiqfYBpNNY3to-TSE3sqWPY3hY2chrXg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] net: macb: Wake-on-Lan magic packet fixes
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rafal Ozieblo <rafalo@cadence.com>,
        Sergio Prado <sergio.prado@e-labworks.com>,
        antoine.tenart@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>, linux@armlinux.org.uk,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Mon, Apr 6, 2020 at 7:56 PM Nicolas Ferre
<nicolas.ferre@microchip.com> wrote:
>
> Hi Harini,
>
> On 03/04/2020 at 15:36, Harini Katakam wrote:
> > Hi Nicolas,
> >
> > On Fri, Apr 3, 2020 at 6:45 PM <nicolas.ferre@microchip.com> wrote:
> >>
> >> From: Nicolas Ferre <nicolas.ferre@microchip.com>
<snip>
> >
> > I know that the IP versions from r1p10 have a mechanism to disable DMA queues
> > (bit 0 of the queue pointer register) which is cleaner. But for
> > earlier IP versions,
>
> Which IP name are you referring to? GEM, GEM-GXL? What is the value of
> register 0xFC then?

GEM_GXL

>
> > I remember discussing with Cadence and there is no way to keep RX
> > enabled for WOL
> > with RX DMA disabled. I'm afraid that means there should be a bare
> > minimum memory
> > region with a dummy descriptor if you do not want to process the
> > packets. That memory
> > should also be accessible while the rest of the system is powered
> > down. Please let me
>
> Very interesting information Harini, thanks a lot for having shared it.
>
> My GEM IP has 0xFC at value: 0x00020203. But I don't see a way to keep
> DMA queues disabled by using the famous bit that you mention above.

Yeah, it is not possible in this revision. This is part of the GEM_GXL r1p10 or
higher I think. I can't be sure of all the possible variations of the
revision reg
because the scheme changed at some point but it looks like this:
0x00070100
bits 27:16 (module_ID), bits16:0 (module_revision); they could increase.

Regards,
Harini
