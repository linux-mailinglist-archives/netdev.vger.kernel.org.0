Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397B21A470A
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDJNrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:47:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726092AbgDJNrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 09:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586526428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ormEpxTSigRdyxB042uzJD4Zjrr9oythNyI0u6o+KI=;
        b=gJSzUTAFob8aCqCEAywVM7DyDdQ8gaLrG5iF8FIyURkKtMayjV14WVLkL9Rrk9D5aoYxEb
        68A9N84aFbnGnDTqfIOJlH1zUM1aAMJURPCo8aSFcPrjvJolhprMAls1n92gEe9J5B7yhz
        8rK5ET8qEbOOjsTeRBYLFWDw4YqXTaU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-dOfJ5r1DNM2MgSyLTbGo_g-1; Fri, 10 Apr 2020 09:47:02 -0400
X-MC-Unique: dOfJ5r1DNM2MgSyLTbGo_g-1
Received: by mail-ed1-f70.google.com with SMTP id w6so2158101edq.3
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 06:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ormEpxTSigRdyxB042uzJD4Zjrr9oythNyI0u6o+KI=;
        b=SWgJsu2Yc1Jck6iRbgn5/Ym4fNJ/1ZE9dM79gqpTNbzSTV80yUHHpDDc+R3k3uPUKo
         64K8usfTTpiYL6/QG0r1S8y69n2aMmk9HbeCZ7tD7PIVmUQ0gKKutVeXmsvnkCrwSRNH
         91sG5iZEYokUvq19DduNej8zuUnZ9fkryBvZ3aaJy6ZWFyDBbU0wKDsXMdw0L5I//hhp
         eb5K5eQOS7R3If9uHuqaBv0Hlrtg9qTo7um3jEZEOZY53q20pTOYJLPVgrYE1xzABKcB
         84hhaxsZkjWOQ3I8u52muA4o88E50t3s8z1vRC5pFSej6VI0klov9KVMTLfhcAV8aTo3
         NbfQ==
X-Gm-Message-State: AGi0PuYDDT7Yzx7FQm40oH/mzVTEbRShrbjoFAu76vi0pnWOmkHiKda6
        aVON6UYQcbNmzMHEYa9L5mJ56YPdImZ/ZLZ75xBcJIr5DzYVrFIWWiqNpN44KazSiPDKy+GwmWv
        nT4liyw5IaQMymUF+9Wiv97dlAXqpMCQ8
X-Received: by 2002:aa7:db88:: with SMTP id u8mr4954980edt.366.1586526420789;
        Fri, 10 Apr 2020 06:47:00 -0700 (PDT)
X-Google-Smtp-Source: APiQypIcxIqTD9tk2CdchMUXw7UAV4TRAHkaLLVm/AKmidZn4r3YpKx3dol8q/h6grLU4j01d/9g6yqXnyhr45AmS0M=
X-Received: by 2002:aa7:db88:: with SMTP id u8mr4954964edt.366.1586526420519;
 Fri, 10 Apr 2020 06:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200316074907.21879-1-chris.packham@alliedtelesis.co.nz>
 <20200408031952.1d8dd01b@turbo.teknoraver.net> <ea3a8bfb9cef4c82447a8af5c891fe430fedd279.camel@alliedtelesis.co.nz>
In-Reply-To: <ea3a8bfb9cef4c82447a8af5c891fe430fedd279.camel@alliedtelesis.co.nz>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 15:46:24 +0200
Message-ID: <CAGnkfhxr3bLMBWp6+606mo5dFZ4Sy1JpMM60+1jGj5UYptV6bA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] net: mvmdio: avoid error message for optional IRQ
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "josua@solid-run.com" <josua@solid-run.com>,
        "luka.perkov@sartura.hr" <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 3:45 AM Chris Packham
<Chris.Packham@alliedtelesis.co.nz> wrote:
>
> Hi Matteo,
>
> On Wed, 2020-04-08 at 03:19 +0200, Matteo Croce wrote:
> > On Mon, 16 Mar 2020 20:49:05 +1300
> > Chris Packham <chris.packham@alliedtelesis.co.nz> wrote:
> >
> > > I've gone ahead an sent a revert. This is the same as the original
> > > v1
> > > except I've added Andrew's review to the commit message.
> > >
> > > Chris Packham (2):
> > >   Revert "net: mvmdio: avoid error message for optional IRQ"
> > >   net: mvmdio: avoid error message for optional IRQ
> > >
> > >  drivers/net/ethernet/marvell/mvmdio.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> >
> > Hi all,
> >
> > I have a Macchiatobin board and the 10G port stopped working in net-
> > next.
> > I suspect that these two patches could be involved.
> > The phy is correctly detected now (I mean no errors and the device is
> > registered) but no traffic can be sent or received:
> >
> > root@macchiatobin:~# dmesg |grep -i -e phy -e mvpp2
> > [    0.000000] Booting Linux on physical CPU 0x0000000000
> > [0x410fd081]
> > [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> > [    0.062798] libphy: Fixed MDIO Bus: probed
> > [    1.132552] armada8k-pcie f2600000.pcie: Phy link never came up
> > [    2.553464] libphy: orion_mdio_bus: probed
> > [    2.558045] libphy: orion_mdio_bus: probed
> > [    2.564037] mvpp2 f2000000.ethernet: using 8 per-cpu buffers
> > [    2.588754] mvpp2 f2000000.ethernet eth0: Using random mac address
> > 1e:a6:ce:39:8d:22
> > [    2.599980] mvpp2 f4000000.ethernet: using 8 per-cpu buffers
> > [    2.623293] mvpp2 f4000000.ethernet eth1: Using random mac address
> > aa:ad:b5:91:8c:1e
> > [    2.626535] mvpp2 f4000000.ethernet eth2: Using random mac address
> > 6e:39:fb:74:09:6e
> > [    2.629600] mvpp2 f4000000.ethernet eth3: Using random mac address
> > 16:ec:bf:9e:11:0f
> > [    2.952063] mvpp2 f4000000.ethernet eth2: PHY [f212a200.mdio-
> > mii:00] driver [Marvell 88E1510] (irq=POLL)
> > [    2.953251] mvpp2 f4000000.ethernet eth2: configuring for
> > phy/sgmii link mode
> > [    7.122899] mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full
> > - flow control rx/tx
> > [   25.727756] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-
> > mii:00] driver [mv88x3310] (irq=POLL)
> > [   25.746711] mvpp2 f2000000.ethernet eth0: configuring for
> > phy/10gbase-r link mode
> > [   27.842712] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> > - flow control off
> >
> >
> > The only way to have it working is to unplug the power, boot an old
> > kernel, e.g. 5.3.0:
> >
> > root@macchiatobin:~# dmesg |grep -i -e phy -e mvpp2
> > [    0.000000] Booting Linux on physical CPU 0x0000000000
> > [0x410fd081]
> > [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> > [    0.083647] libphy: Fixed MDIO Bus: probed
> > [    0.152788] armada8k-pcie f2600000.pcie: Failed to initialize
> > PHY(s) (-22)
> > [    1.429643] libphy: orion_mdio_bus: probed
> > [    1.439109] libphy: orion_mdio_bus: probed
> > [    1.450989] mvpp2 f2000000.ethernet eth0: Using random mac address
> > 5a:09:5f:97:aa:cc
> > [    1.476692] mvpp2 f4000000.ethernet eth1: Using random mac address
> > f2:e2:c1:77:fa:23
> > [    1.479688] mvpp2 f4000000.ethernet eth2: Using random mac address
> > b2:33:c0:2f:da:ba
> > [    1.482296] mvpp2 f4000000.ethernet eth3: Using random mac address
> > 6a:38:79:2e:96:8c
> > [    1.814163] mvpp2 f4000000.ethernet eth2: PHY [f212a200.mdio-
> > mii:00] driver [Marvell 88E1510]
> > [    1.814170] mvpp2 f4000000.ethernet eth2: phy: setting supported
> > 00,00000000,000066ef advertising 00,00000000,000066ef
> > [    1.826025] mvpp2 f4000000.ethernet eth2: configuring for
> > phy/sgmii link mode
> > [    1.826030] mvpp2 f4000000.ethernet eth2: phylink_mac_config:
> > mode=phy/sgmii/Unknown/Unknown adv=00,00000000,000066ef pause=10
> > link=0 an=1
> > [    1.827683] mvpp2 f4000000.ethernet eth2: phy link down
> > sgmii/1Gbps/Half
> > [    6.002304] mvpp2 f4000000.ethernet eth2: phy link up
> > sgmii/1Gbps/Full
> > [    6.002313] mvpp2 f4000000.ethernet eth2: phylink_mac_config:
> > mode=phy/sgmii/1Gbps/Full adv=00,00000000,00000000 pause=0f link=1
> > an=0
> > [    6.002332] mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full
> > - flow control rx/tx
> > [   33.186689] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-
> > mii:00] driver [mv88x3310]
> > [   33.194739] mvpp2 f2000000.ethernet eth0: phy: setting supported
> > 00,00008000,0000706f advertising 00,00008000,0000706f
> > [   33.218029] mvpp2 f2000000.ethernet eth0: configuring for
> > phy/10gbase-kr link mode
> > [   33.225637] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> > mode=phy/10gbase-kr/Unknown/Unknown adv=00,00008000,0000706f pause=10
> > link=0 an=1
> > [   33.241341] mvpp2 f2000000.ethernet eth0: phy link down 10gbase-
> > kr/Unknown/Unknown
> > [   35.362160] mvpp2 f2000000.ethernet eth0: phy link up 10gbase-
> > kr/10Gbps/Full
> > [   35.369243] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
> > mode=phy/10gbase-kr/10Gbps/Full adv=00,00000000,00000000 pause=00
> > link=1 an=0
> > [   35.381836] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
> > - flow control off
> >
> >
> > And then do a soft reboot to net-next which works.
> > By rebooting the board multiple times it works, until I unplug the
> > power.
> >
> > Any hint?
> > Bye,
> >
>
> Well certainly the first change that got applied commit e1f550dc44a4
> ("net: mvmdio: avoid error message for optional IRQ") would cause a
> problem. But the revert and the corrected change commit fa2632f74e57
> ("net: mvmdio: avoid error message for optional IRQ") should result in
> no behaviour changing (other than the spurious log message.
>
> There is a pre-existing problem that any error other than -EPROBE_DEFER
> will be silently ignored (that was what the initial attempt was trying
> to handle but got it wrong). So there could be an error that might be
> trying to tell you that something went wrong.

Indeed, it was caused by this one:

commit c9cc1c815d36f9d5723e369d662f238bc3b35d83
Author: Russell King <rmk+kernel@armlinux.org.uk>
Date:   Tue Mar 3 18:08:45 2020 +0000

    net: phy: marvell10g: place in powersave mode at probe

Thanks,
-- 
Matteo Croce
per aspera ad upstream

