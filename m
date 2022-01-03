Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFAB483455
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiACPhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:37:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:27331 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbiACPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641224243; x=1672760243;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZrtULOTqtTIWzUD+cxiEiTVmr8tTBBL/eM5V0N//Qbs=;
  b=MS3iUKZQJq1v1/SPTnaHTGHKi8YBZ6swcN0K4upWud0QqgBMjBKlhLtC
   AAm6P9eAhHhzKE6xXxkKaxI7tQ8YdgrcE1xgakIx+ZkGo19bLE2YI6QmR
   IrcD5yEInCxlCUZV+Qzgw4Nx0YyEqHbK7wzXk21H8IiuA696Nm5yG9C/W
   03HXhRoXnZtrgOwBKGN5HQ7ANLK69/XMgQ4a/a+Ncot+ZRGStIQLjTM40
   ZAwalCDC+ZPQDsVbwirG86qF7+/eMH69hncobFqCYZZQVluv2MBeuyk4q
   iDhixLf/6bs4s2BSfretfsL942tmIg/CJbuVXrBQp+u4kaiKhLb0n36qU
   w==;
IronPort-SDR: BXhrI/gvbLbeQosWatebzD11xw0vUy2UKXgEbb/LyXml1oQlGqgy3BeZgDkt3z7nBGbUHKjrSI
 rNHsZg72/EcAfuazSj+zTslIN+rt8ZotqQ6xJ2myR++c7iiD9UWaVXmpy7S44DZmBHB0T09tpa
 cjIWVNZe6tvvaRiqncPpz+kgSJaN82zz5pjVZjG+zlatzE5i+74D5MYrFque/LpQ5l0o0g8lDW
 czwqQIoPYWOcvFzllo9trGeynU1UgF+9yDXyzBX3Qc74VeG3mkwJh9gSCyxQrqyndkMotI+gZG
 0gPqHgHnZIdT2Gcjc1gMKqtU
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="141470847"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jan 2022 08:37:00 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 3 Jan 2022 08:36:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 3 Jan 2022 08:36:57 -0700
Date:   Mon, 3 Jan 2022 16:39:10 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next 1/3] net: lan966x: Add function
 lan966x_mac_cpu_copy()
Message-ID: <20220103153910.pntxvz7qjaodd6s3@soft-dev3-1.localhost>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
 <20220103131039.3473876-2-horatiu.vultur@microchip.com>
 <20220103142754.vtotw3clkwdrvcrd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220103142754.vtotw3clkwdrvcrd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/03/2022 14:27, Vladimir Oltean wrote:
> 
> On Mon, Jan 03, 2022 at 02:10:37PM +0100, Horatiu Vultur wrote:
> > Extend mac functionality with the function lan966x_mac_cpu_copy. This
> > function adds an entry in the MAC table where a frame is copy to the CPU
> 
> s/copy/copied/
> 
> > but also can be forward on the front ports.
> 
> s/forward/forwarded/
> 
> > This functionality is needed for mdb support. In case the CPU and some
> > of the front ports subscribe to an IP multicast address.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../ethernet/microchip/lan966x/lan966x_mac.c  | 27 ++++++++++++++++---
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++++
> >  .../ethernet/microchip/lan966x/lan966x_regs.h |  6 +++++
> >  3 files changed, 34 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > index efadb8d326cc..ae3a7a10e0d6 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
> > @@ -68,16 +68,18 @@ static void lan966x_mac_select(struct lan966x *lan966x,
> >       lan_wr(mach, lan966x, ANA_MACHDATA);
> >  }
> >
> > -int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > -                   const unsigned char mac[ETH_ALEN],
> > -                   unsigned int vid,
> > -                   enum macaccess_entry_type type)
> > +static int lan966x_mac_learn_impl(struct lan966x *lan966x, int port,
> > +                               bool cpu_copy,
> > +                               const unsigned char mac[ETH_ALEN],
> > +                               unsigned int vid,
> > +                               enum macaccess_entry_type type)
> 
> In the kernel, the __lan966x_mac_learn naming scheme seems to be more
> popular than _impl.
> 
> Also, may I suggest that the "int port" argument may be better named
> "int pgid"?

Yes, I will rename it and change the argument name.

> 
> >  {
> >       lan966x_mac_select(lan966x, mac, vid);
> >
> >       /* Issue a write command */
> >       lan_wr(ANA_MACACCESS_VALID_SET(1) |
> >              ANA_MACACCESS_CHANGE2SW_SET(0) |
> > +            ANA_MACACCESS_MAC_CPU_COPY_SET(cpu_copy) |
> >              ANA_MACACCESS_DEST_IDX_SET(port) |
> >              ANA_MACACCESS_ENTRYTYPE_SET(type) |
> >              ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
> > @@ -86,6 +88,23 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
> >       return lan966x_mac_wait_for_completion(lan966x);
> >  }
> >
> > +int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
> > +                      bool cpu_copy,
> > +                      const unsigned char mac[ETH_ALEN],
> > +                      unsigned int vid,
> > +                      enum macaccess_entry_type type)
> 
> This doesn't seem to use the "port" argument from any of its call sites.
> It is always 0. What would it even mean?

When adding MAC table entries for IPv4/IPv6 then the port which is the
DEST_IDX needs to be 0. It should not point to a PGID entry because the
destination ports are encoded in the MAC address.

> 
> > +{
> > +     return lan966x_mac_learn_impl(lan966x, port, cpu_copy, mac, vid, type);
> > +}
> > +
> > +int lan966x_mac_learn(struct lan966x *lan966x, int port,
> > +                   const unsigned char mac[ETH_ALEN],
> > +                   unsigned int vid,
> > +                   enum macaccess_entry_type type)
> > +{
> > +     return lan966x_mac_learn_impl(lan966x, port, false, mac, vid, type);
> 
> If you call lan966x_mac_cpu_copy() on an address and then
> lan966x_mac_learn() on the same address but on an external port, how
> does that work (why doesn't the "false" here overwrite the cpu_copy in
> the previous command, breaking the copy-to-CPU feature)?

Then you will overwrite the cpu_copy so the frames will not reach the
CPU anymore.
But you should not do that. The function lan966x_mac_cpu_copy() should be
used for IPv4/IPv6 and lan966x_mac_learn() for the other types.

Maybe the function lan966x_mac_cpu_copy() is too generic. It should be
something like lan966x_mac_ipv4(), lan966x_mac_ipv6() and these functions
will call __lan966x_mac_learn with the correct parameters. Also I can
add a WARN_ON(...) inside lan966x_mac_learn not to be used with the
IPv4/IPv6 types.

> 
> > +}
> > +
> >  int lan966x_mac_forget(struct lan966x *lan966x,
> >                      const unsigned char mac[ETH_ALEN],
> >                      unsigned int vid,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index c399b1256edc..a7a2a3537036 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -157,6 +157,11 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
> >                        struct lan966x_port_config *config);
> >  void lan966x_port_init(struct lan966x_port *port);
> >
> > +int lan966x_mac_cpu_copy(struct lan966x *lan966x, int port,
> > +                      bool cpu_copy,
> > +                      const unsigned char mac[ETH_ALEN],
> > +                      unsigned int vid,
> > +                      enum macaccess_entry_type type);
> >  int lan966x_mac_learn(struct lan966x *lan966x, int port,
> >                     const unsigned char mac[ETH_ALEN],
> >                     unsigned int vid,
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > index a13c469e139a..797560172aca 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
> > @@ -169,6 +169,12 @@ enum lan966x_target {
> >  #define ANA_MACACCESS_CHANGE2SW_GET(x)\
> >       FIELD_GET(ANA_MACACCESS_CHANGE2SW, x)
> >
> > +#define ANA_MACACCESS_MAC_CPU_COPY               BIT(16)
> > +#define ANA_MACACCESS_MAC_CPU_COPY_SET(x)\
> > +     FIELD_PREP(ANA_MACACCESS_MAC_CPU_COPY, x)
> > +#define ANA_MACACCESS_MAC_CPU_COPY_GET(x)\
> > +     FIELD_GET(ANA_MACACCESS_MAC_CPU_COPY, x)
> > +
> >  #define ANA_MACACCESS_VALID                      BIT(12)
> >  #define ANA_MACACCESS_VALID_SET(x)\
> >       FIELD_PREP(ANA_MACACCESS_VALID, x)
> > --
> > 2.33.0
> >

-- 
/Horatiu
