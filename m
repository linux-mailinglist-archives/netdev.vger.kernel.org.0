Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B0E8AFC8
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfHMGQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:16:24 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:31047 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfHMGQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:16:24 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: zCxalVkiqoRclkFMscmbvXewqC1f8bXlfje0wLYQSgHTGkZkWHKLhkfNFreVxzsUr0b4Ke4MZm
 IiBg8IdWlLTUxqhdxUypec7rlYJn4UjSnCpD8LtSB6+NvXdpRhOrpMgZ/SuWGVwmdDd67uz3E3
 Xwior8EN6w6aDK5xF3/484vNG08pEBB2EFkPQTnNBm/Bq5f3o02QF/fFsDvZwB40L6Z3NhWbnD
 KWPWeIWsi85sZrw7h4Kycla7B+DPdr/rI/9XUFrBWZgZdaH4XceMWgdl892wcHjONr56e1kfOv
 r94=
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="46309282"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2019 23:16:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 23:16:06 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 12 Aug 2019 23:16:05 -0700
Date:   Tue, 13 Aug 2019 08:16:04 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190813061603.7ippfny5ce6iee2z@lx-anielsen.microsemi.net>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/13/2019 02:12, Y.b. Lu wrote:
> > -----Original Message-----
> > From: Allan W. Nielsen <allan.nielsen@microchip.com>
> > Sent: Monday, August 12, 2019 8:32 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux Driver
> > Support <UNGLinuxDriver@microchip.com>
> > Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
> > 
> > The 08/12/2019 18:48, Yangbo Lu wrote:
> > > The trap action should be copying the frame to CPU and dropping it for
> > > forwarding, but current setting was just copying frame to CPU.
> > 
> > Are there any actions which do a "copy-to-cpu" and still forward the frame in
> > HW?
> 
> [Y.b. Lu] We're using Felix switch whose code hadn't been accepted by upstream.
> https://patchwork.ozlabs.org/project/netdev/list/?series=115399&state=*
> 
> I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype 0x88f7.
> When I used current TRAP option, I found the frames were not only copied to CPU, but also forwarded to other ports.
> So I just made the TRAP option same with DROP option except enabling CPU_COPY_ENA in the patch.
This is still wrong to do - and it will not work for Ocelot (and I doubt it will
work for your Felix target).

The policer setting in the drop action ensure that the frame is dropped even if
other pipe-line steps in the switch has set the copy-to-cpu flag.

I think you can fix this patch my just clearing the port mask, and not set the
policer.

/Allan

