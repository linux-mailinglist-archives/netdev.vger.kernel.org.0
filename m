Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4016100F54
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKRXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:13:50 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:35223 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfKRXNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:13:50 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: XbYZbG5Z2q6JE1EX0WRzxEtmEtVkrtD1iTk5xWdvFYWH1eRSqAkagrp5wZ8TE48bUtI7adcONJ
 7IurxRmxHh3j1lY4Ppsvm8JcL08mJrP5VcadsiRwEuPBhXWzVGHRFB1n8E6ZIIUR3tO3ttSf8S
 3X05mfme4x/Ol2K3ZaV9HL80h60tRUT1IOoiYBT0SSJ68F8EP4CjP4wrhpMXkoMfY4rou3vmkt
 CnYwyRI9/287QYPluBI7xPQCGcvhXHM3X/gcZBfRo7nPd5cfNb7ELuhmqUKtv4iKop4ijTRRZe
 +Sc=
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="57121928"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2019 16:13:46 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 Nov 2019 16:13:42 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 18 Nov 2019 16:13:41 -0700
Date:   Tue, 19 Nov 2019 00:13:41 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <allan.nielsen@microchip.com>,
        <claudiu.manoil@nxp.com>, <alexandru.marginean@nxp.com>,
        <xiaoliang.yang_1@nxp.com>, <yangbo.lu@nxp.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
References: <20191118181030.23921-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191118181030.23921-1-olteanv@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/18/2019 20:10, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> This series is needed on NXP LS1028A to support the CPU port which runs
> at 2500Mbps fixed-link, a setting which PHYLIB can't hold in its swphy
> design.
> 
> In DSA, PHYLINK comes "for free". I added the PHYLINK ops to the Ocelot
> driver, integrated them to the VSC7514 ocelot_board module, then tested
> them via the Felix front-end. The VSC7514 integration is only
> compile-tested.
> 
> Vladimir Oltean (2):
>   net: mscc: ocelot: treat SPEED_UNKNOWN as SPEED_10
>   net: mscc: ocelot: convert to PHYLINK
> 
>  drivers/net/dsa/ocelot/felix.c           |  65 +++++++---
>  drivers/net/ethernet/mscc/Kconfig        |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c       | 153 ++++++++++++-----------
>  drivers/net/ethernet/mscc/ocelot.h       |  13 +-
>  drivers/net/ethernet/mscc/ocelot_board.c | 151 +++++++++++++++++++---
>  include/soc/mscc/ocelot.h                |  21 +++-
>  6 files changed, 285 insertions(+), 120 deletions(-)
> 
> --
> 
> Horatiu, I am sorry for abusing your goodwill. Could you please test
> this series and confirm it causes no regression on VSC7514?

Hi Vladimir,

Sorry for late reply, I have tried your patches but unfortunetly I get
a segmentation fault when I try to set the link up.
Here is the stack trace:

# ip link set dev eth0 up
[  259.978564] CPU 0 Unable to handle kernel paging request at virtual address 00000008, epc == 805aa7a4, ra == 805aa79c
[  259.989679] Oops[#1]:
[  259.992007] CPU: 0 PID: 98 Comm: ip Not tainted
5.4.0-rc7-01844-g0d53d4ce24f5 #2
[  259.999428] $ 0   : 00000000 00000001 80910000 fffffff8
[  260.004687] $ 4   : 8090838c 0000000e 9e51589c 9e515cbc
[  260.009940] $ 8   : 00000000 807bea44 00000000 00000000
[  260.015193] $12   : 00000000 00000020 00402f1c 00000002
[  260.020445] $16   : 00000000 808e0000 808074f4 9f8a4828
[  260.025699] $20   : 00000000 9e515cbc 9e515ba0 9e54fc10
[  260.030952] $24   : 00000000 9e515dac
[  260.036206] $28   : 9e514000 9e515840 00000000 805aa79c
[  260.041460] Hi    : 00000129
[  260.044351] Lo    : 00001a94
[  260.047311] epc   : 805aa7a4 phylink_start+0x20/0x2e0
[  260.052387] ra    : 805aa79c phylink_start+0x18/0x2e0
[  260.057454] Status: 11008403 KERNEL EXL IE
[  260.061661] Cause : 00800008 (ExcCode 02)
[  260.065683] BadVA : 00000008
[  260.068575] PrId  : 02019654 (MIPS 24KEc)
[  260.072596] Modules linked in:
[  260.075673] Process ip (pid: 98, threadinfo=(ptrval), task=(ptrval), tls=77e564a0)
[  260.083263] Stack : 00000000 00000000 9f8a4800 808e0000 808074f4 9e515cbc 00000000 9f8a4800
[  260.091662]         808e0000 805b7898 00000000 00000000 00000000 808e0000 808074f4 8062cf20
[  260.100058]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 9f8a4800
[  260.108453]         9e515cbc 0295ff75 00000000 9f8a4800 00001003 808e0000 00000000 8062d39c
[  260.116850]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  260.125245]         ...
[  260.127706] Call Trace:
[  260.130176] [<805aa7a4>] phylink_start+0x20/0x2e0
[  260.134955] [<805b7898>] ocelot_port_open+0x10/0x20
[  260.139897] [<8062cf20>] __dev_open+0x10c/0x194
[  260.144457] [<8062d39c>] __dev_change_flags+0x1b0/0x210
[  260.149712] [<8062d420>] dev_change_flags+0x24/0x68
[  260.154625] [<806482d4>] do_setlink+0x340/0xaec
[  260.159182] [<8064978c>] __rtnl_newlink+0x484/0x7d8
[  260.164086] [<80649b30>] rtnl_newlink+0x50/0x84
[  260.168676] [<80643484>] rtnetlink_rcv_msg+0x2e8/0x3b8
[  260.173859] [<8067c9c0>] netlink_rcv_skb+0xa0/0x150
[  260.178766] [<8067abdc>] netlink_unicast+0x1c4/0x26c
[  260.183760] [<8067b478>] netlink_sendmsg+0x2cc/0x3e0
[  260.188758] [<80601df8>] ___sys_sendmsg+0xec/0x280
[  260.193584] [<80603b9c>] __sys_sendmsg+0x60/0xac
[  260.198246] [<80115e98>] syscall_common+0x34/0x58
[  260.202979] Code: afb10020  10400055  3c028091 <8e020008> 8c420004 10400086  24030001  1043006d  00000000
[  260.212788]
[  260.214696] ---[ end trace 42880f8a413b404b ]---
Segmentation fault
#

The reason of this segmentation is that, before it was fine to use the
phy PHY_INTERFACE_MODE_NA. Now if the phy interface is
PHY_INTERFACE_MODE_NA it would not create the phylink. I think this can
be fixed in the device tree.

Apparently there is another issue: mscc mdio bus driver fails to be
probed. So first I need to see this issue and then I will try your
patches.

> 
> 2.17.1
> 

-- 
/Horatiu
