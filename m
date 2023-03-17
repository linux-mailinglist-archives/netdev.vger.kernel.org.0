Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87976BEAEC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCQOR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCQOR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:17:26 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D4C1ADFC;
        Fri, 17 Mar 2023 07:17:24 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id n125so5810966ybg.7;
        Fri, 17 Mar 2023 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679062643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWj7UtLe90naf1fPcSOD1HiWgunjA67trQ9URwm+TNg=;
        b=CBw5lO1KlmCsceOVZnKaycjOSfZat/Hlh/JFUlOVLQY3GDDyn/p1goa9Y67+wpB5Pw
         em4d2UfXmjupCYFjMSIpg95wQ6LjvhB6kEWIW9ukPIZgXYybWKPJyH0IPeLHv8aaJwNz
         Ygp768EPeata8kYssjBBuBb+l7qwn2btDMfnRIlKzG6/cdszyZTT3zMz4Wjytvl/TU6c
         NC7vVUqvFlsS+STxxmvDfuGaaVZma/beHmEARHhyB3BH5TK0HiFn7R/uqspVeNPC7raA
         KoirEmVKYiDKE4zs3fdPp0Qu0lSL3UZIpSR4wTXt5dh0bNkbCbQ1RvfpidobHgB5Nu8I
         jCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679062643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWj7UtLe90naf1fPcSOD1HiWgunjA67trQ9URwm+TNg=;
        b=Ba4clilcuIX7pPvU41KrAgHs3NNADR36ECN9qRCm8wT30ZcWxdDWjUmBsNeBigC3Qn
         QFonURVjKE82BI6+65ziJGaQ3yzrXOGZmaLHQWXfoH6if5CnNPanBXEhfB42whzrCusC
         +dYUSJBPCHRWUwwkmk/WKW5AyfJBPiZQ2BBwVPtmnZ/tgzK0+HqJBo0PhOQlKEDtU6lF
         6fVahhHxAGQxp3Puh5V5OfuP8LymOBUPEpTCr7DOUeGHq0pYplJeghvLlKDX/03zbMPh
         Hkj1aRwZPsT0btIaQj05dS/OtxigseFA+kM5z1EQMXXRiCAAsrpVft5kLAfJT0X8cx6w
         6zLQ==
X-Gm-Message-State: AO0yUKW3hm+E4kgHbXMV0VskXow/EgbxZE3JQM2I1PGBv7RvJdNT+1F6
        i+JzWTYxlJSNXCHRockWQKn2qOXVA4+xfINlZ7s=
X-Google-Smtp-Source: AK7set/AvkXboti3g67W0E5gnj9H9gbp70iGfPV3mPZRmPqigCw1kWMNrv2MiRw/vCo1kpiG2eElsC9PgotFwb7Aa94=
X-Received: by 2002:a25:f50a:0:b0:b46:4a5e:3651 with SMTP id
 a10-20020a25f50a000000b00b464a5e3651mr8184686ybe.9.1679062643166; Fri, 17 Mar
 2023 07:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf>
In-Reply-To: <20230317130434.7cbzk5gxx5guarcz@skbuf>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 15:17:12 +0100
Message-ID: <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

El vie, 17 mar 2023 a las 14:04, Vladimir Oltean (<olteanv@gmail.com>) escr=
ibi=C3=B3:
>
> On Fri, Mar 17, 2023 at 01:06:43PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > Hi Vladimir,
> >
> > El vie, 17 mar 2023 a las 12:51, Vladimir Oltean (<olteanv@gmail.com>) =
escribi=C3=B3:
> > >
> > > On Fri, Mar 17, 2023 at 12:34:26PM +0100, =C3=81lvaro Fern=C3=A1ndez =
Rojas wrote:
> > > > b53 MMAP devices have a MDIO Mux bus controller that must be regist=
ered after
> > > > properly initializing the switch. If the MDIO Mux controller is reg=
istered
> > > > from a separate driver and the device has an external switch presen=
t, it will
> > > > cause a race condition which will hang the device.
> > >
> > > Could you describe the race in more details? Why does it hang the dev=
ice?
> >
> > I didn't perform a full analysis on the problem, but what I think is
> > going on is that both b53 switches are probed and both of them fail
> > due to the ethernet device not being probed yet.
> > At some point, the internal switch is reset and not fully configured
> > and the external switch is probed again, but since the internal switch
> > isn't ready, the MDIO accesses for the external switch fail due to the
> > internal switch not being ready and this hangs the device because the
> > access to the external switch is done through the same registers from
> > the internal switch.
>
> The proposed solution is too radical for a problem that was not properly
> characterized yet, so this patch set has my temporary NACK.

Forgive me, but why do you consider this solution too radical?

>
> > But maybe Florian or Jonas can give some more details about the issue..=
.
>
> I think you also have the tools necessary to investigate this further.
> We need to know what resource belonging to the switch is it that the
> MDIO mux needs. Where is the earliest place you can add the call to
> b53_mmap_mdiomux_init() such that your board works reliably? Note that
> b53_switch_register() indirectly calls b53_setup(). By placing this
> function where you have, the entirety of b53_setup() has finished
> execution, and we don't know exactly what is it from there that is
> needed.

In the following link you will find different bootlogs related to
different scenarios all of them with the same result: any attempt of
calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
will either result in a kernel panic or a device hang:
https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7

1. before b53_switch_register():
[ 1.756010] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
[ 1.761917] bcm53xx 0.1:1e: failed to register switch: -517
[ 1.767759] b53-switch 10e00000.switch: MDIO mux bus init
[ 1.774237] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 1.785673] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
[ 1.795932] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
[ 1.884320] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
[ 1.901957] NET: Registered PF_INET6 protocol family
[ 1.935223] Segment Routing with IPv6
[ 1.939160] In-situ OAM (IOAM) with IPv6
[ 1.943514] NET: Registered PF_PACKET protocol family
[ 1.949564] 8021q: 802.1Q VLAN Support v1.8
[ 1.987591] CPU 1 Unable to handle kernel paging request at virtual
address 00000000, epc =3D=3D 804be000, ra =3D=3D 804bbf3c
[ 1.998697] Oops[#1]:
[ 2.000995] CPU: 1 PID: 91 Comm: kworker/u4:3 Not tainted 5.15.98 #0
[ 2.007533] Workqueue: events_unbound deferred_probe_work_func
[ 2.013541] $ 0 : 00000000 00000001 804bdfd4 81ee6800
[ 2.018916] $ 4 : 834c7000 00000000 00000002 00000001
[ 2.024291] $ 8 : c0000000 00000110 00000114 00000000
[ 2.029668] $12 : 00000001 81cf2f8a fffffffc 00000000
[ 2.035043] $16 : 00000000 00000000 00000002 834bc680
[ 2.040420] $20 : 00000000 00000080 81c0700d 81f37a40
[ 2.045796] $24 : 00000018 00000000
[ 2.051171] $28 : 81f58000 81f59c80 80870000 804bbf3c
[ 2.056547] Hi : e6545baf
[ 2.059505] Lo : a4644567
[ 2.062462] epc : 804be000 mdio_mux_read+0x2c/0xd4
[ 2.067569] ra : 804bbf3c __mdiobus_read+0x20/0xc4
[ 2.072766] Status: 10008b03 KERNEL EXL IE
[ 2.077066] Cause : 00800008 (ExcCode 02)
[ 2.081187] BadVA : 00000000
[ 2.084145] PrId : 0002a070 (Broadcom BMIPS4350)
[ 2.088983] Modules linked in:
[ 2.092119] Process kworker/u4:3 (pid: 91, threadinfo=3D(ptrval),
task=3D(ptrval), tls=3D00000000)
[ 2.100812] Stack : 00000080 80255cfc 81c0700d 81f37a40 834c7000
00000000 00000002 834c7558
[ 2.109438] 00000002 804bbf3c 00000000 83501f78 834bb0b0 834df478
8194eae0 834c7000
[ 2.118058] 00000000 804bc020 ffffffed 83508780 00000000 00000004
834bb0b0 81f5b800
[ 2.126677] 808eb104 808eb104 81950000 804c48cc 00000003 81f5b800
81f5b800 00000000
[ 2.135297] 808eb104 81f5b800 808eb104 804bc6c0 834c7570 10008b01
81f5b800 81f5b8e0
[ 2.143925] ...
[ 2.146435] Call Trace:
[ 2.148943] [<804be000>] mdio_mux_read+0x2c/0xd4
[ 2.153697] [<804bbf3c>] __mdiobus_read+0x20/0xc4
[ 2.158533] [<804bc020>] mdiobus_read+0x40/0x6c
[ 2.163193] [<804c48cc>] b53_mdio_probe+0x38/0x16c
[ 2.168120] [<804bc6c0>] mdio_probe+0x34/0x7c
[ 2.172600] [<80437930>] really_probe.part.0+0xac/0x35c
[ 2.177976] [<80437c8c>] __driver_probe_device+0xac/0x164
[ 2.183531] [<80437d90>] driver_probe_device+0x4c/0x158
[ 2.188907] [<80438444>] __device_attach_driver+0xd0/0x15c
[ 2.194552] [<804353a0>] bus_for_each_drv+0x70/0xb0
[ 2.199569] [<804380f0>] __device_attach+0xc0/0x1d8
[ 2.204588] [<804367f4>] bus_probe_device+0x9c/0xb8
[ 2.209604] [<80436d58>] deferred_probe_work_func+0x94/0xd4
[ 2.215339] [<80058314>] process_one_work+0x290/0x4d0
[ 2.220536] [<800588ac>] worker_thread+0x358/0x614
[ 2.225464] [<80061064>] kthread+0x148/0x16c
[ 2.229854] [<80013848>] ret_from_kernel_thread+0x14/0x1c
[ 2.235413]
[ 2.236931] Code: 00a0a025 8e700004 00c09025 <8e040000> 0c1ba5d8
24840558 8e020010 8e06000c 8e65000c
[ 2.247011]
[ 2.248726] ---[ end trace 9e5942a13795eb30 ]---
[ 2.253490] Kernel panic - not syncing: Fatal exception
[ 2.258831] Rebooting in 1 seconds..

2. before dsa_register_switch():
[ 1.759901] bcm53xx 0.1:1e: failed to register switch: -19
[ 1.765837] b53-switch 10e00000.switch: MDIO mux bus init
[ 1.771412] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 1.782683] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
[ 1.793149] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
[ 1.875791] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
[ 1.893480] NET: Registered PF_INET6 protocol family
[ 1.922283] Segment Routing with IPv6
[ 1.926192] In-situ OAM (IOAM) with IPv6
[ 1.930392] NET: Registered PF_PACKET protocol family
[ 1.936526] 8021q: 802.1Q VLAN Support v1.8
[ 2.245288] bcm53xx 1.1:1e: failed to register switch: -19
[ 2.251210] b53-switch 10e00000.switch: MDIO mux bus init
[ 2.256761] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
*** Device hangs ***

3. before b53_switch_init():
[ 1.757728] bcm53xx 0.1:1e: failed to register switch: -19
[ 1.763689] b53-switch 10e00000.switch: MDIO mux bus init
[ 1.769780] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 1.781130] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
[ 1.790996] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
[ 1.875775] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
[ 1.893523] NET: Registered PF_INET6 protocol family
[ 1.921605] Segment Routing with IPv6
[ 1.925513] In-situ OAM (IOAM) with IPv6
[ 1.929695] NET: Registered PF_PACKET protocol family
[ 1.935809] 8021q: 802.1Q VLAN Support v1.8
[ 2.244702] bcm53xx 1.1:1e: failed to register switch: -19
[ 2.250653] b53-switch 10e00000.switch: MDIO mux bus init
[ 2.256751] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
*** Device hangs ***

I will be happy to do any more tests if needed.

Best regards,
=C3=81lvaro.
