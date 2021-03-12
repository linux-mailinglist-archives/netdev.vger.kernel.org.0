Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE33392C0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhCLQIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:08:51 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:59602 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhCLQI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615565307; x=1647101307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H0yilk8Ynx8IDoRIG1+JimWFbpODwhI5XVQ14H/FT18=;
  b=gqrX+3EnsgF5IeYaq5pPB3quI4WTkwrBEemaiuK03HyUtiGOH4G64Kr+
   ZTsaRsYdWHbNntGhi/zls6w8p4BFeRq72TNEExG7p6ym5VdCbujXqWYVm
   3LG1TB8if5cP8/gy+fmLiW6xQHhfZ5XTKYfis/Z+XLkRDKQMyQWhNDh4q
   FpGdeRetmtKOPye7BgshSBHTiiEfMmQIOb5uipaTuQJsbtblp8X095ihg
   o7kkpj4ppVgAIdFoNstazq7vGAvwqqZt+GfpOKJwa0WaYnOO4VpPRoE8K
   5TxCnMX5PJFFodglFsc554tR35ocG8UcJ4eEyDi6JQt7AyfATseggVxfR
   g==;
IronPort-SDR: DO2gqgluGr4qRorJ7FlDTEFHXtrr8UZCec/89ANaWmWj1N9TkvbqZcJjcVz866mzlxrIUOoyC6
 6yZhoYXAXeDnCiO5dt/+SISNa2JkXCmk15eKOJJ9mwS0HP0tjuRl0JId5OMotBYwW13gJbL6Tp
 KrhqrT8c/NH9Ri5ZEp8gOkggy3uhClSDOagD8t/ZYENN4mqx/KDQnk3vlJFm2spHobf7EB6VNS
 U8Padc3hV5WpSGLTtk6Eaez6SsE9ekRlW4tQZNVGAb49tbwFyk036QmcBs0gxFehiVHSV+EGAu
 kqk=
X-IronPort-AV: E=Sophos;i="5.81,244,1610434800"; 
   d="scan'208";a="106981947"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2021 09:08:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 12 Mar 2021 09:08:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Fri, 12 Mar 2021 09:08:26 -0700
Date:   Fri, 12 Mar 2021 17:08:37 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ocelot: Extend MRP
Message-ID: <20210312160837.ilib6auj4q6sskp4@soft-dev3-1.localhost>
References: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
 <20210311002549.4ilz4fw2t6sdxxtv@skbuf>
 <20210311193008.vasrdiephy36fnxa@soft-dev3-1.localhost>
 <20210311200230.k4jzp44lcphhtuor@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210311200230.k4jzp44lcphhtuor@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/11/2021 20:02, Vladimir Oltean wrote:
> 
> On Thu, Mar 11, 2021 at 08:30:08PM +0100, Horatiu Vultur wrote:
> > > > +static void ocelot_mrp_save_mac(struct ocelot *ocelot,
> > > > +                             struct ocelot_port *port)
> > > > +{
> > > > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_test_dmac,
> > > > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> > > > +     ocelot_mact_learn(ocelot, PGID_MRP, mrp_control_dmac,
> > > > +                       port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> > >
> > > Let me make sure I understand.
> > > By learning these multicast addresses, you mark them as 'not unknown' in
> > > the MAC table, because otherwise they will be flooded, including to the
> > > CPU port module, and there's no way you can remove the CPU from the
> > > flood mask, even if the packets get later redirected through VCAP IS2?
> >
> > Yes, so far you are right.
> >
> > > I mean that's the reason why we have the policer on the CPU port for the
> > > drop action in ocelot_vcap_init, no?
> >
> > I am not sure that would work because I want the action to be redirect
> > and not policy. Or maybe I am missing something?
> 
> Yes, it is not the same context as for tc-drop. The problem for tc-drop
> was that the packets would get removed from the hardware datapath, but
> they would still get copied to the CPU nonetheless. A policer there was
> an OK solution because we wanted to kill those packets completely. Here,
> the problem is the same, but we cannot use the same solution, since a
> policer will also prevent the frames from being redirected.
> 
> > >
> > > > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > > > index 425ff29d9389..c41696d2e82b 100644
> > > > --- a/include/soc/mscc/ocelot.h
> > > > +++ b/include/soc/mscc/ocelot.h
> > > > @@ -51,6 +51,7 @@
> > > >   */
> > > >
> > > >  /* Reserve some destination PGIDs at the end of the range:
> > > > + * PGID_MRP: used for not flooding MRP frames to CPU
> > >
> > > Could this be named PGID_BLACKHOLE or something? It isn't specific to
> > > MRP if I understand correctly. We should also probably initialize it
> > > with zero.
> >
> > It shouldn't matter the value, what is important that the CPU port not
> > to be set. Because the value of this PGID will not be used in the
> > fowarding decision.
> > Currently only MRP is using it so that is the reason for naming it like
> > that but I can rename it and initialized it to 0 to be more clear.
> 
> So tell me more about this behavior.
> Is there no way to suppress the flooding to CPU action, even if the
> frame was hit by a TCAM rule? Let's forget about MRP, assume this is an
> broadcast IPv4 packet, and we have a matching src_ip rule to perform
> mirred egress redirect to another port.
> Would the CPU be flooded with this traffic too? What would you do to
> avoid that situation?

I think so, I need to ask around to be able to answer your question.

You have to think about CPU port as a special port. If at any point
while the frame goes through the switch, there is a decision to copy the
frame to CPU, the frame will be copied to CPU regardless of the previous
or next decisions. That is at least my understanding.

-- 
/Horatiu
