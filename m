Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE84108C8
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 00:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhIRWFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 18:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhIRWFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 18:05:41 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42246C061574;
        Sat, 18 Sep 2021 15:04:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so44443648edt.5;
        Sat, 18 Sep 2021 15:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SB9N6xhnuvHlcRP19/dvOoGmK4DWyYK4PyDYniPNxnc=;
        b=e44lKN3GMV77lsUgnLQLsXbcO3NTODa5+Ebw6EVqvtcWFkF3AwgeIf2EOg4QTyy5Lq
         zfUUXWEz4ycQc0avf3duygdd3KsBjiGfHhic2rdvhYBNlJ7ST6bt8sbj/yF9F5/RFQ+X
         DTUygZ93HrGZbZ8EjOOp2a0Q8awhHdh0+jAzYY8l9anbC5AyG8cEvBnXjAfOL38aO4Zp
         kfYXsG2vNWDTJ4+Wj7S+DuJjHEYZpbEbT+pdY5EFZHgWE9Oif8gChPPUBAr86j4P5ZAf
         Fp+VBc8CO0RBjmlnhzvUtJ/dZRh98mgOlJZw2MHMK5QKiszNa0rqqRjHm0pL4zuOxZOD
         T6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SB9N6xhnuvHlcRP19/dvOoGmK4DWyYK4PyDYniPNxnc=;
        b=61iOxZljGgGI3g/nPGZ4ht2zVkI4r8YMN88Y5F5pTgZV90ymdmrLXxDzzP23MOtMFv
         4BjpkLTd/PW+PhMereBBZd4jc5ZoSUZqZOPhOCwhsfpGEW+jImFhhSW3Ys9RTyaAJYw1
         7B9TijacKP5vDonKIF5Mfa6VIBMmsZANW6OVkTmA/r6r0kFNWENOmnDgUbKb6fUQLBd+
         mk298mbleK2EKHOeNWsv39CR60i8NBP8vOpAhEByNMzPeVxBs5d4HbM7lDR2raRCogwY
         LfjV/V66DzQ3XnsWXvtWAy8QdxElsJFdK47gPcxZ0Gn72MR7HM0PvyY5SgxMj/MY2Stv
         95eA==
X-Gm-Message-State: AOAM530oPI7QVt9vdhgPDFjeAGZy+YZtYvnViddNNcs6A82nGisfXQIH
        pq6/koawklajoaAjWNOLh2M=
X-Google-Smtp-Source: ABdhPJy75Zgk17az5HayPIL8RVQkNtGXc33wDpKSmE6zEBioiuWwcLApgQeEdR4Pv21X1+JO2zJHtg==
X-Received: by 2002:a17:906:1146:: with SMTP id i6mr20725310eja.12.1632002655575;
        Sat, 18 Sep 2021 15:04:15 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bj10sm4157190ejb.17.2021.09.18.15.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 15:04:14 -0700 (PDT)
Date:   Sun, 19 Sep 2021 01:04:12 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210918220412.keknt4ycnyafkf5b@skbuf>
References: <YTtG3NbYjUbu4jJE@lunn.ch>
 <20210910145852.4te2zjkchnajb3qw@skbuf>
 <53f2509f-b648-b33d-1542-17a2c9d69966@gmx.de>
 <20210912202913.mu3o5u2l64j7mpwe@skbuf>
 <trinity-e5b95a34-015c-451d-bbfc-83bfb0bdecad-1631529134448@3c-app-gmx-bs55>
 <20210913104400.oyib42rfq5x2vc56@skbuf>
 <trinity-6fefc142-df4d-47af-b2bd-84c8212e5b1c-1631530880741@3c-app-gmx-bs55>
 <20210914184856.vmqv3je4oz5elxvp@skbuf>
 <69b914bb-de19-e168-fe9c-61e125410fb6@gmx.de>
 <241a75e4-2322-8937-2bde-97a383284976@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <241a75e4-2322-8937-2bde-97a383284976@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 09:37:17PM +0200, Lino Sanfilippo wrote:
> Hi Vladimir,
> 
> On 15.09.21 at 07:42, Lino Sanfilippo wrote:
> > On 14.09.21 at 20:48, Vladimir Oltean wrote:
> >> On Mon, Sep 13, 2021 at 01:01:20PM +0200, Lino Sanfilippo wrote:
> >>>>>> Could you post the full kernel output? The picture you've posted is
> >>>>>> truncated and only shows a WARN_ON in rpi_firmware_transaction and is
> >>>>>> probably a symptom and not the issue (which is above and not shown).
> >>>>>>
> >>>>>
> >>>>> Unfortunately I dont see anything in the kernel log. The console output is all I get,
> >>>>> thats why I made the photo.
> >>>>
> >>>> To clarify, are you saying nothing above this line gets printed? Because
> >>>> the part of the log you've posted in the picture is pretty much
> >>>> unworkable:
> >>>>
> >>>> [   99.375389] [<bf0dc56c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<c0863ca0>] (platform_drv_shutdown+0x2c/0x30)
> >>>>
> >>>> How do you access the device's serial console? Use a program with a
> >>>> scrollback buffer like GNU screen or something.
> >>>>
> >>>
> >>> Ah no, this is not over a serial console. This is what I see via hdmi. I do not have a working serial connection yet.
> >>> Sorry I know this trace part is not very useful, I will try to get a full dump.
> >>
> >> Lino, are you going to provide a kernel output so I could look at your new breakage?
> >> If you could set up a pstore logger with a ramoops region, you could
> >> dump the log after the fact. Or if HDMI is all you have, you could use
> >> an HDMI capture card to record it. Or just record the screen you're
> >> looking at, as long as you don't have very shaky hands, whatever...
> >>
> >
> > Yes, I will try to get something useful. I have already set up a serial connection
> > now. I still see the shutdown stopping with your patch but I have not seen the
> > kernel dump any more. I will try further and provide a dump as soon as I am successful.
> >
> 
> Sorry for the delay. I was finally able to do some tests and get a dump via the serial console.
> I tested with the latest Raspberry Pi kernel 5.10.y. Based on commit
> 4117cba235d24a7c4630dc38cb55cc80a04f5cf3. I applied your patches and got the following result
> at shutdown:
> 
> raspberrypi login: [   58.754533] ------------[ cut here ]------------
> [   58.760053] kernel BUG at drivers/net/phy/mdio_bus.c:651!
> [   58.766361] Internal error: Oops - BUG: 0 [#1] SMP ARM
> [   58.772376] Modules linked in: 8021q garp at24 tag_ksz tpm_tis_spi ksz9477_spi tpm_tis_core ksz9477 ksz_common tpm rts
> [   58.837539] CPU: 3 PID: 1 Comm: systemd-shutdow Tainted: G         C        5.10.63-RP_PURE_510_VLADFIX+ #3
> [   58.848388] Hardware name: BCM2711
> [   58.852875] PC is at mdiobus_free+0x4c/0x50
> [   58.858143] LR is at devm_mdiobus_free+0x1c/0x20
> [   58.863853] pc : [<c08c9218>]    lr : [<c08c1898>]    psr: 80000013
> [   58.871212] sp : c18fdc38  ip : c18fdc48  fp : c18fdc44
> [   58.877505] r10: 00000000  r9 : c0867104  r8 : c18fdc5c
> [   58.883823] r7 : 00000013  r6 : c31c8000  r5 : c3a50000  r4 : c379db80
> [   58.891442] r3 : c2ab4000  r2 : 00000002  r1 : c379dbc0  r0 : c2ab4000
> [   58.899037] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   58.907297] Control: 30c5383d  Table: 03ac92c0  DAC: 55555555
> [   58.914139] Process systemd-shutdow (pid: 1, stack limit = 0xff8113c1)
> [   58.921774] Stack: (0xc18fdc38 to 0xc18fe000)
> [   58.927285] dc20:                                                       c18fdc54 c18fdc48
> [   58.936601] dc40: c08c1898 c08c91d8 c18fdc94 c18fdc58 c0866dac c08c1888 c31c819c c3527180
> [   58.945921] dc60: c332d200 c1405048 c32f8800 c31c8000 00000000 bf191010 00000000 c32f8800
> [   58.955289] dc80: c1095f3c c1aa6454 c18fdcac c18fdc98 c086715c c0866be8 c31c8000 00000000
> [   58.964644] dca0: c18fdccc c18fdcb0 c0862c7c c0867128 c1a42e30 c31c8000 c14f7cf0 00000000
> [   58.974018] dcc0: c18fdcdc c18fdcd0 c0862d40 c0862b68 c18fdcfc c18fdce0 c08613dc c0862d2c
> [   58.983391] dce0: c31c8000 00000a68 c08ba6cc 00000000 c18fdd44 c18fdd00 c085c710 c086130c
> [   58.992778] dd00: c0331394 c0332604 60000013 c18fdd74 c3656294 c1405048 c31c8000 c31c8000
> [   59.002140] dd20: 00000000 c08ba6cc c160657c c155c018 c1095f3c c1aa6454 c18fdd5c c18fdd48
> [   59.011521] dd40: c08ba6a8 c085c58c 00000000 00000000 c18fdd6c c18fdd60 c08ba6e4 c08ba670
> [   59.020921] dd60: c18fdd9c c18fdd70 c085bc84 c08ba6d8 c18fdd8c c3656200 c3656394 c1405048
> [   59.030334] dd80: c18fdda4 c32f8800 c32f8800 00000003 c18fddbc c18fdda0 c08bab7c c085bc20
> [   59.039737] dda0: c32f8b80 c32f8800 00000000 c160657c c18fdddc c18fddc0 bf182554 c08bab4c
> [   59.049164] ddc0: c1aa6400 c1a6e810 c1aa6410 c160657c c18fddf4 c18fdde0 bf1825a8 bf18252c
> [   59.058602] dde0: c1aa6414 c1a6e810 c18fde04 c18fddf8 c0863dec bf182598 c18fde3c c18fde08
> [   59.068057] de00: c085fd9c c0863dcc c18fde3c c1095f2c c024865c 00000000 00000000 620bef00
> [   59.077487] de20: c140f510 fee1dead c18fc000 00000058 c18fde4c c18fde40 c0249c84 c085fc0c
> [   59.086920] de40: c18fde64 c18fde50 c0249d74 c0249c4c 01234567 00000000 c18fdf94 c18fde68
> [   59.096386] de60: c024a018 c0249d64 c18fded4 c31b0c00 00000024 c18fdf58 00000005 c0441cec
> [   59.105852] de80: c18fdec4 c18fde90 c0441b30 c049852c 00000000 c18fdea0 c073ad04 00000024
> [   59.115330] dea0: c31b0c00 c18fdf58 c18fded4 c31b0c00 00000005 00000000 c18fdf4c c18fdec8
> [   59.124821] dec0: c0441cec c0425cb0 c18fded0 c18fded4 00000000 00000005 00000000 00000024
> [   59.134317] dee0: c18fdeec 00000005 c0200074 bec45250 00000004 bec45f62 00000010 bec45264
> [   59.143792] df00: 00000005 bec4531c 0000000a b6d10040 00000001 c0200e70 ffffe000 c1546a80
> [   59.153282] df20: 00000000 c0467268 c18fdf4c c1405048 c31b0c00 bec4528c 00000000 00000000
> [   59.162787] df40: c18fdf94 c18fdf50 c0441e6c c0441c50 00000000 00000000 00000000 00000000
> [   59.172269] df60: c18fdf94 c1405048 c0331394 c1405048 bec4531c 00000000 00000000 00000000
> [   59.181763] df80: 00000058 c0200204 c18fdfa4 c18fdf98 c024a16c c0249f10 00000000 c18fdfa8
> [   59.191250] dfa0: c0200040 c024a160 00000000 00000000 fee1dead 28121969 01234567 620bef00
> [   59.200735] dfc0: 00000000 00000000 00000000 00000058 00000fff bec45be8 00000000 00476b80
> [   59.210245] dfe0: 00488e3c bec45b68 004734a8 b6e4ca38 60000010 fee1dead 00000000 00000000
> [   59.219759] Backtrace:
> [   59.223546] [<c08c91cc>] (mdiobus_free) from [<c08c1898>] (devm_mdiobus_free+0x1c/0x20)
> [   59.232909] [<c08c187c>] (devm_mdiobus_free) from [<c0866dac>] (release_nodes+0x1d0/0x220)
> [   59.242551] [<c0866bdc>] (release_nodes) from [<c086715c>] (devres_release_all+0x40/0x60)
> [   59.252132]  r10:c1aa6454 r9:c1095f3c r8:c32f8800 r7:00000000 r6:bf191010 r5:00000000
> [   59.261338]  r4:c31c8000
> [   59.265239] [<c086711c>] (devres_release_all) from [<c0862c7c>] (device_release_driver_internal+0x120/0x1c4)
> [   59.276479]  r5:00000000 r4:c31c8000
> [   59.281440] [<c0862b5c>] (device_release_driver_internal) from [<c0862d40>] (device_release_driver+0x20/0x24)
> [   59.292802]  r7:00000000 r6:c14f7cf0 r5:c31c8000 r4:c1a42e30
> [   59.299900] [<c0862d20>] (device_release_driver) from [<c08613dc>] (bus_remove_device+0xdc/0x108)
> [   59.310267] [<c0861300>] (bus_remove_device) from [<c085c710>] (device_del+0x190/0x428)
> [   59.319748]  r7:00000000 r6:c08ba6cc r5:00000a68 r4:c31c8000
> [   59.326896] [<c085c580>] (device_del) from [<c08ba6a8>] (spi_unregister_device+0x44/0x68)
> [   59.336583]  r10:c1aa6454 r9:c1095f3c r8:c155c018 r7:c160657c r6:c08ba6cc r5:00000000
> [   59.345924]  r4:c31c8000
> [   59.349971] [<c08ba664>] (spi_unregister_device) from [<c08ba6e4>] (__unregister+0x18/0x20)
> [   59.359870]  r5:00000000 r4:00000000
> [   59.364972] [<c08ba6cc>] (__unregister) from [<c085bc84>] (device_for_each_child+0x70/0xb4)
> [   59.374899] [<c085bc14>] (device_for_each_child) from [<c08bab7c>] (spi_unregister_controller+0x3c/0x128)
> [   59.385979]  r6:00000003 r5:c32f8800 r4:c32f8800
> [   59.392086] [<c08bab40>] (spi_unregister_controller) from [<bf182554>] (bcm2835_spi_remove+0x34/0x6c [spi_bcm2835])
> [   59.404000]  r7:c160657c r6:00000000 r5:c32f8800 r4:c32f8b80
> [   59.411084] [<bf182520>] (bcm2835_spi_remove [spi_bcm2835]) from [<bf1825a8>] (bcm2835_spi_shutdown+0x1c/0x38 [spi_bc)
> [   59.423755]  r7:c160657c r6:c1aa6410 r5:c1a6e810 r4:c1aa6400
> [   59.430847] [<bf18258c>] (bcm2835_spi_shutdown [spi_bcm2835]) from [<c0863dec>] (platform_drv_shutdown+0x2c/0x30)
> [   59.442613]  r5:c1a6e810 r4:c1aa6414
> [   59.447635] [<c0863dc0>] (platform_drv_shutdown) from [<c085fd9c>] (device_shutdown+0x19c/0x24c)
> [   59.457932] [<c085fc00>] (device_shutdown) from [<c0249c84>] (kernel_restart_prepare+0x44/0x48)
> [   59.468135]  r10:00000058 r9:c18fc000 r8:fee1dead r7:c140f510 r6:620bef00 r5:00000000
> [   59.477470]  r4:00000000
> [   59.481509] [<c0249c40>] (kernel_restart_prepare) from [<c0249d74>] (kernel_restart+0x1c/0x60)
> [   59.491653] [<c0249d58>] (kernel_restart) from [<c024a018>] (__do_sys_reboot+0x114/0x1f8)
> [   59.501359]  r5:00000000 r4:01234567
> [   59.506447] [<c0249f04>] (__do_sys_reboot) from [<c024a16c>] (sys_reboot+0x18/0x1c)
> [   59.515628]  r8:c0200204 r7:00000058 r6:00000000 r5:00000000 r4:00000000
> [   59.523857] [<c024a154>] (sys_reboot) from [<c0200040>] (ret_fast_syscall+0x0/0x28)
> [   59.533038] Exception stack(0xc18fdfa8 to 0xc18fdff0)
> [   59.539607] dfa0:                   00000000 00000000 fee1dead 28121969 01234567 620bef00
> [   59.549318] dfc0: 00000000 00000000 00000000 00000058 00000fff bec45be8 00000000 00476b80
> [   59.559026] dfe0: 00488e3c bec45b68 004734a8 b6e4ca38
> [   59.565596] Code: ebfe49f5 e89da800 ebed72a3 e89da800 (e7f001f2)
> [   59.573246] ---[ end trace 7d800ce7b5664bb6 ]---
> [   59.579413] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [   59.588634] Rebooting in 10 seconds..
> 
> The concerning source code line 651 is in my case:
> 
> void mdiobus_free(struct mii_bus *bus)
> {
> 	/* For compatibility with error handling in drivers. */
> 	if (bus->state == MDIOBUS_ALLOCATED) {
> 		kfree(bus);
> 		return;
> 	}
> 
> 651<	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
> 	bus->state = MDIOBUS_RELEASED;
> 
> 	put_device(&bus->dev);
> }
> EXPORT_SYMBOL(mdiobus_free);
> 
> I tested with both versions of your patchset, with the same result. I also tested
> with a RP 5.14 kernel (the latest RP kernel) but I did not see the original issue
> (i.e. the system hang) here for some reason.
> 
> I then tried to get the net-next kernel running on my system but without success so far. So for
> now the result with the RP 5.10 is all I can offer. I hope that helps a bit nevertheless.

Thank you Lino, this is a very valuable report. I will send a v3 soon (not sure if today).
