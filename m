Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927236A4AA2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjB0TNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjB0TNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:13:30 -0500
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 11:13:27 PST
Received: from mo6-p02-ob.smtp.rzone.de (mo6-p02-ob.smtp.rzone.de [IPv6:2a01:238:400:300::b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7CF1705;
        Mon, 27 Feb 2023 11:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677524843; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=lq0yLehKlFG/jxPN5dmprydYBhqFoo/hYgRD9hLfJ39Q2ilSMmAD+0Dyx93205Af6s
    OhKOOmfuWi8H7cSgsXqhMBsrOK0wSFj/nyRgdFE0Eq5Ya0JQrZZlIl4XkDGgaSHA+sxy
    DkNwVVDaYIEnWTVgLZ1NyWVrRV3MkzEyI2lHTh3bIyNi8JGRF6QsI+xhXjTdmASS68lJ
    VHFriwmYTdwLumkTn7EyT+cAvnaRgnH7t2d0yTMfTEXDk39QKVOiNAgb3eZKXA0CrCn6
    fSiZCJuyZehLiTZNN4yDw7cL/BbSMAya8QmKSTq7891SIZSt+4npQJZNrMAys7Ir8T18
    lT7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1677524843;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SCNnrfRfgYtJkgagR7PT+nuWe2DttbEbFxEiAZ3T8JU=;
    b=iVcn//ch/paGeGUTbOUrCaG0qbNN8FK5sQfIB/da2Lv3VHKAhdnAcdXDm4InA6z4VC
    V+T9v2gssU02P5OVVuYFP1oe5bjrS4wibM+aokefLjG1gkZDp0SOIUg9MF/JFMd6gify
    iMtSsGJVMrzeRRGiIHu+JBTBxJGUqk+2wqS+5hlnJx/GTcToQkaL09iHeAAHPRcPxR7A
    /fKrydTk4r0bpGnenNp2pfTTHLJsUgbxvonLN2yWuuEaW5lS7FO1WI/nSREKIhlbUh0B
    AcbwUBXLW16GuRI0AdhM6E3LQ3yPWGfFf3/TaC0Z4PnREtSXpGaGmc8OyRBBQ26hgIIp
    8nww==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1677524843;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SCNnrfRfgYtJkgagR7PT+nuWe2DttbEbFxEiAZ3T8JU=;
    b=khNjWqiIkNp8gzAKWMBc9yncWEKCsLCzBBsx3Opd24Aa/mQ3BCbysw0+OoUePjp2EY
    kZvcG5u4Driv3b0CM8pgDLMeZV8Bng0qF7fUYDD2uhgcS5w0yigTt1DLxncIB8LNKNja
    G7qAR64C06gvpuSJKkWt2cbpig+UrAAt6TNTgFYtw5fCTAMl0XUeKqKJuzuwv4z2ZvZF
    C+0IQdjEEAM5xFoxDShBuWfRG6rfwttYZ611Jnz2yaFJWfaAYYtQkGBsE+/b5MXUOEiS
    VAXGaT8n/fimA4oVTIIGtw6uFeN64LWtNmbJsMZSbITCTtsGwribwMg7KzIcnKqAf3Ca
    +OAA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.0 AUTH)
    with ESMTPSA id x84a76z1RJ7MrbT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 27 Feb 2023 20:07:22 +0100 (CET)
Message-ID: <1daa9f1f-6a68-273f-0866-72a4496cd0db@hartkopp.net>
Date:   Mon, 27 Feb 2023 20:07:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
To:     Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230227133457.431729-1-arnd@kernel.org>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arnd,

On 27.02.23 14:34, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>

(..)

> The remaining cardbus/yenta support is essentially a PCI hotplug driver
> with a slightly unusual sysfs interface, and it would still support all
> 32-bit cardbus hosts and cards, but no longer work with the even older
> 16-bit cards that require the pcmcia_driver infrastructure.

I'm using a 2005 Samsung X20 laptop (Pentium M 1.6GHz, Centrino) with 
PCMCIA (type 2) CAN bus cards:

- EMS PCMCIA
https://elixir.bootlin.com/linux/latest/source/drivers/net/can/sja1000/ems_pcmcia.c

- PEAK PCCard
https://elixir.bootlin.com/linux/latest/source/drivers/net/can/sja1000/peak_pcmcia.c

As I still maintain the EMS PCMCIA and had to tweak and test a patch 
recently (with a 5.16-rc2 kernel):

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/can/sja1000/ems_pcmcia.c?id=3ec6ca6b1a8e64389f0212b5a1b0f6fed1909e45

I assume these CAN bus PCMCIA interfaces won't work after your patch 
set, right?

Here is the dmesg output of the PCMCIA driver and the CAN drivers from 
the 5.16-rc2 kernel:

[   17.167938] yenta_cardbus 0000:02:09.0: CardBus bridge found [144d:c01a]
[   17.304252] yenta_cardbus 0000:02:09.0: ISA IRQ mask 0x0cb8, PCI irq 16
[   17.304266] yenta_cardbus 0000:02:09.0: Socket status: 30000006
[   17.304275] yenta_cardbus 0000:02:09.0: pcmcia: parent PCI bridge 
window: [io  0x4000-0x4fff]
[   17.304282] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x4000-0x4fff:
[   17.305582]  excluding 0x4000-0x40ff 0x4400-0x44ff
[   17.318112] yenta_cardbus 0000:02:09.0: pcmcia: parent PCI bridge 
window: [mem 0xb8000000-0xb80fffff]
[   17.318122] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xb8000000-0xb80fffff:
[   17.318129]  excluding 0xb8000000-0xb801ffff
[   18.481675] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:
[   18.482680]  excluding 0x170-0x177 0x1f0-0x1f7 0x370-0x377
[   18.483428] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:
[   18.484196]  excluding 0x3f0-0x3f7 0x4d0-0x4d7
[   18.484570] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:
[   18.485149]  clean
[   18.485178] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:
[   18.485818]  clean
[   18.485856] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x0c0000-0x0fffff:
[   18.485863]  excluding 0xc0000-0xc7fff 0xd8000-0xfffff
[   18.485908] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xa0000000-0xa0ffffff:
[   18.485929]  clean
[   18.485958] pcmcia_socket pcmcia_socket0: cs: memory probe 
0x60000000-0x60ffffff:
[   18.485972]  excluding 0x60000000-0x60ffffff
[   18.486005] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:
[   18.486663]  clean

(..)

[  176.999473] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card 
inserted into slot 0
[  176.999489] pcmcia_socket pcmcia_socket0: cs: memory probe 
0xb8020000-0xb80fffff:
[  177.009792]  clean
[  177.010039] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 3)
[  177.119671] CAN device driver interface
[  177.140214] sja1000 CAN netdevice driver
[  177.204920] ems_pcmcia: registered can0 on channel #0 at 0xbd4852ee, 
irq 3
[  177.212167] ems_pcmcia: registered can1 on channel #1 at 0x081f55b8, 
irq 3
[ 1003.014730] pcmcia_socket pcmcia_socket0: pccard: card ejected from 
slot 0
[ 1003.014801] ems_pcmcia: removing can0 on channel #0
[ 1003.027520] ems_pcmcia: removing can1 on channel #1
[ 1019.943489] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card 
inserted into slot 0
[ 1019.943715] pcmcia 0.0: pcmcia: registering new device pcmcia0.0 (IRQ: 3)
[ 1020.035605] peak_pcmcia 0.0: PEAK-System pcmcia card PC_CAN_CARD fw 1.5
[ 1020.039539] peak_pcmcia 0.0: can0 on channel 0 at 0x55749494 irq 3
[ 1020.045816] peak_pcmcia 0.0: can1 on channel 1 at 0x415066ba irq 3

Best regards,
Oliver


> 
> I don't expect this to be a problem normal laptop support, as the last
> PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
> all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
> boot Tiny Core Linux but not a regular distro.
> 
> Support for device drivers is somewhat less clear. Losing support for
> 16-bit cards in cardbus sockets is obviously a limiting factor for
> anyone who still has those cards, but there is also a good chance that
> the only reason to keep the cards around is for using them in pre-cardbus
> machines that cannot be upgrade to 32-bit devices.
> 
> Completely removing the 16-bit PCMCIA support would however break some
> 20+ year old embedded machines that rely on CompactFlash cards as their
> mass-storage device (extension), this notably includes early PocketPC
> models and the reference implementations for OMAP1, StrongARM1100,
> Alchemy and PA-Semi. All of these are still maintained, though most
> of the PocketPC machines got removed in the 6.3 merge window and the
> PA-Semi Electra board is the only one that was introduced after
> 2003.
> 
> The approach that I take in this series is to split drivers/pcmcia
> into two mutually incompatible parts: the Cardbus support contains
> all the code that is relevant for post-1997 laptops and gets moved
> to drivers/pci/hotplug, while the drivers/pcmcia/ subsystem is
> retained for both the older laptops and the embedded systems but no
> longer works with the yenta socket host driver. The BCM63xx
> PCMCIA/Cardbus host driver appears to be unused and conflicts with
> this series, so it is removed in the process.
> 
> My series does not touch any of the pcmcia_driver instances, but
> if there is consensus about splitting out the cardbus support,
> a lot of them can probably get removed as a follow-up.
> 
> [1] https://lore.kernel.org/all/Y07d7rMvd5++85BJ@owl.dominikbrodowski.net/
> [2] https://lore.kernel.org/all/c5b39544-a4fb-4796-a046-0b9be9853787@app.fastmail.com/
> [3] https://lore.kernel.org/all/20230222092302.6348-1-jirislaby@kernel.org/
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kevin Cernekee <cernekee@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
> Cc: bcm-kernel-feedback-list@broadcom.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> 
> Arnd Bergmann (6):
>    pccard: remove bcm63xx socket driver
>    pccard: split cardbus support from pcmcia
>    yenta_socket: copy pccard core code into driver
>    yenta_socket: remove dead code
>    pccard: drop remnants of cardbus support
>    pci: hotplug: move cardbus code from drivers/pcmcia
> 
>   arch/mips/bcm63xx/Makefile                    |    2 +-
>   arch/mips/bcm63xx/boards/board_bcm963xx.c     |   14 -
>   arch/mips/bcm63xx/dev-pcmcia.c                |  144 -
>   arch/mips/configs/bcm63xx_defconfig           |    1 -
>   .../asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h     |   14 -
>   arch/mips/pci/ops-bcm63xx.c                   |  294 --
>   arch/mips/pci/pci-bcm63xx.c                   |   44 -
>   drivers/Makefile                              |    2 +-
>   drivers/pci/hotplug/Kconfig                   |   56 +
>   drivers/pci/hotplug/Makefile                  |    1 +
>   drivers/pci/hotplug/yenta_socket.c            | 4056 +++++++++++++++++
>   drivers/pcmcia/Kconfig                        |   63 +-
>   drivers/pcmcia/Makefile                       |   13 +-
>   drivers/pcmcia/bcm63xx_pcmcia.c               |  538 ---
>   drivers/pcmcia/bcm63xx_pcmcia.h               |   61 -
>   drivers/pcmcia/cardbus.c                      |  124 -
>   drivers/pcmcia/cistpl.c                       |   10 +-
>   drivers/pcmcia/cs.c                           |  103 +-
>   drivers/pcmcia/cs_internal.h                  |   10 +-
>   drivers/pcmcia/ds.c                           |   14 +-
>   drivers/pcmcia/i82092.c                       |    2 +-
>   drivers/pcmcia/i82365.c                       |    2 +-
>   drivers/pcmcia/o2micro.h                      |  183 -
>   drivers/pcmcia/pd6729.c                       |    3 +-
>   drivers/pcmcia/ricoh.h                        |  169 -
>   drivers/pcmcia/socket_sysfs.c                 |    2 -
>   drivers/pcmcia/ti113x.h                       |  978 ----
>   drivers/pcmcia/topic.h                        |  168 -
>   drivers/pcmcia/yenta_socket.c                 | 1455 ------
>   drivers/pcmcia/yenta_socket.h                 |  136 -
>   {drivers => include}/pcmcia/i82365.h          |    0
>   include/pcmcia/ss.h                           |   21 -
>   32 files changed, 4147 insertions(+), 4536 deletions(-)
>   delete mode 100644 arch/mips/bcm63xx/dev-pcmcia.c
>   delete mode 100644 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h
>   create mode 100644 drivers/pci/hotplug/yenta_socket.c
>   delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.c
>   delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.h
>   delete mode 100644 drivers/pcmcia/cardbus.c
>   delete mode 100644 drivers/pcmcia/o2micro.h
>   delete mode 100644 drivers/pcmcia/ti113x.h
>   delete mode 100644 drivers/pcmcia/topic.h
>   delete mode 100644 drivers/pcmcia/yenta_socket.c
>   delete mode 100644 drivers/pcmcia/yenta_socket.h
>   rename {drivers => include}/pcmcia/i82365.h (100%)
> 
