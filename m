Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7528415904
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhIWHbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:31:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55370 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhIWHbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632382166; x=1663918166;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e0OqG1sEb/DAQaezsPSnpiZgTs6I9hcfFvcyuLy9A7s=;
  b=WkzRsYA2JbWGyP1EK/q8GiyVN3gd+lskMcgG9W/a5DbbvLsExvmIxsrr
   NR3qr++XtNYzmAboQpQrdMwYXPMuLAuprKnAYfCsn3mgjlPbVZcTF1AoO
   KQ6/rOxdm/i2twFcPP9+SiXoeYkDRfPu5ghXulinndl9sSnx7RRYlHrHM
   yhlUmHv866qYrwQAvF4as2SU4MO3FDTXmRA9tynNR3fm36/7fpPQPWEzP
   YNNGSndGifmElCI04LIxEOQ46uJvd0rITNRs8U4c8QjNpXV1s22HV6l3O
   HWd+5AJV6Cvnftm6/2aVWdGUIG4gsZOj1S0NWfZlO5mHw54BT6d+x4wr+
   A==;
IronPort-SDR: sv3tT0VKyDGAd+CHy9fThgcz4Zt6g9q5ft5tyF7/X+OSk+nXDte5aCpUv81Kzskc49hQoUMrhK
 b95kjpILbyT6T4kE5YlUBKfrEZWwrFI7mrAKlQ6Fs6eBWVoAfDUDD+NRmsZJ2pvyGOJHtm0zdF
 k4lVGbbccnQ+UXUUOKsMvKFXdao/z4A8TvwQE1BjRDw8pfKaC39zxHBTaSyOzKSOTorfcQ2Chz
 vOUvHjdV3SfP7Jt6wBETQ4Y2Zf3lX+6l0BSqZYGUQF4rs9JS6QeSam3Ir72kvT8khQ3gikmVzS
 sUDgwiq8zH8AkPEiC5/dMpB3
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="130315249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2021 00:29:25 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 23 Sep 2021 00:29:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 23 Sep 2021 00:29:29 -0700
Date:   Thu, 23 Sep 2021 09:30:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Message-ID: <20210923073059.wbzukwaiyylel72x@soft-dev3-1.localhost>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
 <20210922131837.ocuk34z3njf5k3yp@skbuf>
 <DB8PR04MB578599F04A8764034485CE89F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB578599F04A8764034485CE89F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/23/2021 01:52, Xiaoliang Yang wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, Sep 22, 2021 at 13:18:37 +0000, Vladimir Oltean wrote:
> > > Policer was previously automatically assigned from the highest index
> > > to the lowest index from policer pool. But police action of tc flower
> > > now uses index to set an police entry. This patch uses the police
> > > index to set vcap policers, so that one policer can be shared by multiple
> > rules.
> > >
> > > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > > ---
> > > +#define VSC9959_VCAP_POLICER_BASE  63
> > > +#define VSC9959_VCAP_POLICER_MAX   383
> > >
> >
> > > +#define VSC7514_VCAP_POLICER_BASE                  128
> > > +#define VSC7514_VCAP_POLICER_MAX                   191
> >
> > I think this deserves an explanation.
> >
> > The VSC7514 driver uses the max number of policers as 383 (0x17f) ever since
> > commit b596229448dd ("net: mscc: ocelot: Add support for tcam"), aka the
> > very beginning.
> >
> > Yet, the documentation at "3.10.1 Policer Allocation"
> > https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf
> > says very clearly that there are only 192 policers indeed.
> >
> > What's going on?
> 
> In commit commit b596229448dd ("net: mscc: ocelot: Add support for tcam"), Horatiu Vultur define the max number of policers as 383:
> +#define OCELOT_POLICER_DISCARD 0x17f
> VCAP IS2 use this policer to set drop action. I did not change this and set the VCAP policers with 128-191 according to the VSC7514 document.
> 
> I don't know why 383 was used as the maximum value of policer in the original code. Can Microchip people check the code or the documentation for errors?

It was defined as 383 because the HW actually support this number of
policers. But for this SKU it is recomended to use 191, but no one will
stop you from using 383.

> 
> >
> > Also, FWIW, Seville has this policer allocation:
> >
> >       0 ----+----------------------+
> >             |  Port Policers (11)  |
> >      11 ----+----------------------+
> >             |  VCAP Policers (21)  |
> >      32 ----+----------------------+
> >             |   QoS Policers (88)  |
> >     120 ----+----------------------+
> >             |  VCAP Policers (43)  |
> >     162 ----+----------------------+
> 
> I didn't find Seville's document, if this allocation is right, I will add it in Seville driver.
> 
> Thanks,
> Xiaoliang

-- 
/Horatiu
