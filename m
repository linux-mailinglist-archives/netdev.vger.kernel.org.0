Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6618CC0E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 08:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfHNGpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 02:45:10 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:42937 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfHNGpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 02:45:10 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: natVrZLTfWSsOsfo/vf04jdNk7l39f0V2vZ3wXx5NR6hwyzgCq2uSjw6xUbw8xRgImUTjViM4Y
 UMzLzRX5G1buRMIjl7dqU4Hjq5kJdYyRXdqEfRIBohc0hHJrp5QP21U94bSoQCBFJviB0160lv
 5lkbBks9nngxR4FZGghnNjn7Ia2e03UkJEu9eKuFqShlz4+5fg09sy2K/BUNcUGEbU7p4o/ckj
 Z0Gv9DAt5X5sKmjP3i2mpwV1OjCOc/7Q7n1KvCvjhI4BdiESv7g7bkpvyLq9CsOvGfP17v70Db
 +mQ=
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="42196019"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Aug 2019 23:45:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 23:45:08 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 13 Aug 2019 23:45:08 -0700
Date:   Wed, 14 Aug 2019 08:45:07 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190814064506.krzcsm5osnnyexic@lx-anielsen.microsemi.net>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813061603.7ippfny5ce6iee2z@lx-anielsen.microsemi.net>
 <VI1PR0401MB223711A1DB199D1C3CCFD9CCF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB223711A1DB199D1C3CCFD9CCF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > -----Original Message-----
> > From: Allan W. Nielsen <allan.nielsen@microchip.com>
> > Sent: Tuesday, August 13, 2019 2:16 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux Driver
> > Support <UNGLinuxDriver@microchip.com>
> > Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
> > 
> > The 08/13/2019 02:12, Y.b. Lu wrote:
> > > > -----Original Message-----
> > > > From: Allan W. Nielsen <allan.nielsen@microchip.com>
> > > > Sent: Monday, August 12, 2019 8:32 PM
> > > > To: Y.b. Lu <yangbo.lu@nxp.com>
> > > > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > > > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux
> > > > Driver Support <UNGLinuxDriver@microchip.com>
> > > > Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
> > > >
> > > > The 08/12/2019 18:48, Yangbo Lu wrote:
> > > > > The trap action should be copying the frame to CPU and dropping it
> > > > > for forwarding, but current setting was just copying frame to CPU.
> > > >
> > > > Are there any actions which do a "copy-to-cpu" and still forward the
> > > > frame in HW?
> > >
> > > [Y.b. Lu] We're using Felix switch whose code hadn't been accepted by
> > upstream.
> > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpatc
> > >
> > hwork.ozlabs.org%2Fproject%2Fnetdev%2Flist%2F%3Fseries%3D115399%26s
> > tat
> > >
> > e%3D*&amp;data=02%7C01%7Cyangbo.lu%40nxp.com%7C42cd202cb17b45
> > 69821708d
> > >
> > 71fb5c5de%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6370127
> > 37899910
> > >
> > 736&amp;sdata=QnsDaWPHK9rb0XWg%2BduYEha6fuYSlv4YZdsu5f4kbfc%3D
> > &amp;res
> > > erved=0
> > >
> > > I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype
> > 0x88f7.
> > > When I used current TRAP option, I found the frames were not only copied to
> > CPU, but also forwarded to other ports.
> > > So I just made the TRAP option same with DROP option except enabling
> > CPU_COPY_ENA in the patch.
> > This is still wrong to do - and it will not work for Ocelot (and I doubt it will
> > work for your Felix target).
> > 
> > The policer setting in the drop action ensure that the frame is dropped even if
> > other pipe-line steps in the switch has set the copy-to-cpu flag.
> > 
> > I think you can fix this patch my just clearing the port mask, and not set the
> > policer.
> 
> [Y.b. Lu] Sorry. I missed your previous comments on the TRAP action.
> With my configuration in the patch, it indeed worked. Maybe it was because "the CPU port is not touched by MASK_MODE" which I saw in RM.
Okay. If this is working, then you should properly test and see if the DROP
action is working on your target. I do not have access to the SoC which incldues
Felix, so I cannot check.

> I will try your suggestion too. It sound more proper.
Sounds good - thanks

/Allan

