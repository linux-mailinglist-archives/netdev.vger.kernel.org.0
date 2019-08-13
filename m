Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753168AFF0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfHMGaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 02:30:14 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:7489 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMGaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 02:30:14 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: d+zlcMohyc6auW+Oa5nID1KDUrmEIHfhndwLCvOA4lZq5xbmzCsJ5GEDi+Ogl8jytPcgMWP52j
 MBToU6kqhfmiPrt5AEYu8Lsu7/Yc23mwuplF8WZWFHoZ9BSper0AoAnJYHwfjJdQ0WwdBsyD9u
 a2IP4KZONIxM2a18ebBwYAUAtcQfqy0HBMBQE9GawOB8xWGMWTkIVhHGnZglOlVwAHlJnfQ+nr
 LGK95o25G4UW185V65sNdOh1PJzR1U6brV99CUgFs3QAwKxwh8wfi2xKQbV+b4OzDrIqyBnssr
 tgs=
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="43372776"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2019 23:30:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Aug 2019 23:30:13 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 12 Aug 2019 23:30:13 -0700
Date:   Tue, 13 Aug 2019 08:30:12 +0200
From:   "Allan W . Nielsen" <allan.nielsen@microchip.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>
Subject: Re: [v2, 3/4] ocelot_ace: fix action of trap
Message-ID: <20190813063011.7pwlzm7mtzlqwwkx@lx-anielsen.microsemi.net>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-4-yangbo.lu@nxp.com>
 <20190813061651.7gtbum4wsaw5dahg@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190813061651.7gtbum4wsaw5dahg@lx-anielsen.microsemi.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/13/2019 08:16, Allan W . Nielsen wrote:
> The 08/13/2019 10:52, Yangbo Lu wrote:
> > The trap action should be copying the frame to CPU and
> > dropping it for forwarding, but current setting was just
> > copying frame to CPU.
> > 
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> > Changes for v2:
> > 	- None.
> > ---
> >  drivers/net/ethernet/mscc/ocelot_ace.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
> > index 91250f3..59ad590 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_ace.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_ace.c
> > @@ -317,9 +317,9 @@ static void is2_action_set(struct vcap_data *data,
> >  		break;
> >  	case OCELOT_ACL_ACTION_TRAP:
> >  		VCAP_ACT_SET(PORT_MASK, 0x0);
> > -		VCAP_ACT_SET(MASK_MODE, 0x0);
> > -		VCAP_ACT_SET(POLICE_ENA, 0x0);
> > -		VCAP_ACT_SET(POLICE_IDX, 0x0);
> > +		VCAP_ACT_SET(MASK_MODE, 0x1);
> > +		VCAP_ACT_SET(POLICE_ENA, 0x1);
> > +		VCAP_ACT_SET(POLICE_IDX, OCELOT_POLICER_DISCARD);
> >  		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
> >  		VCAP_ACT_SET(CPU_COPY_ENA, 0x1);
> >  		break;
> 
> This is still wrong, please see the comments provided the first time you
> submitted this.
> 
> /Allan

I believe this will make it work - but I have not tested it:

 	case OCELOT_ACL_ACTION_TRAP:
 		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x0);
+		VCAP_ACT_SET(MASK_MODE, 0x1);
 		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
 		VCAP_ACT_SET(CPU_COPY_ENA, 0x1);
 		break;

-- 
/Allan
