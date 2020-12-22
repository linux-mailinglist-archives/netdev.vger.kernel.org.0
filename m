Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA82E0C3D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgLVO5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:57:04 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:37311 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgLVO5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:57:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608649023; x=1640185023;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zSqM23FYwmjShJs7eVnwXuEF5SG8gM0/xyTioQGi8nk=;
  b=GTVZ+UdpK9Ez/XAcjP5eZzJdbXEEIlYc6sxgeYkQsueRN0oQm9jO5Vo9
   GwwFtmMEQYXo1myO16A3g1GWZg5Q6OFOPOuoFvgqRzaSpInj4SAQCp+Dc
   SmQ7OQ/MCKboUj0SXuFxSQ+Wak9zecW/mKZXpY4J5vDGhiiHd7Wc0zoKc
   1jtBqxwVZofb/C/yVG83Arrs7nju/Obcw86+sNKBG4yGKPhskJUijoZtS
   YZ6mwRRPzywysSn3whZK1/PrcLZ3yprBMywG+Qc9/7a2wp2mNX2chBe8g
   /oZ+dC5je4gkdd5a99hi9JO4uO7+KLxwc2PpwqnFx+X9H8q5GxALh7KMc
   A==;
IronPort-SDR: da/mAXKzwpDDiyTEGPZ3BBdrWH7mEnrZgstpTRhKU+9TX51QZ1M9gYEkpRMVcKQmEKBEFcOtdM
 X3e9UtbniJqi0q7VByOtLm3T1JcL8a+ny0NWSObcrQxsKPIAlHdVQIrco9NaZtp/Is2d9M9wWe
 JwxW5AAFQf8Y9e1VUfGqNXJEiEHcO+mY0bFZsszqVJ08A6hcbzT90b384yxlOxaHbUYZDITTD0
 IiIHGZJtTmrAgBKs0/PMTnvDNrM2Ozd4esAn73iTJePbP0mVlgR6gu27J8bbZ+4UqKYM49VsXI
 3Wg=
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="103153674"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2020 07:55:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 07:55:46 -0700
Received: from soft-dev2 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 22 Dec 2020 07:55:43 -0700
Message-ID: <d728e952c95dff188239d5d5a3c066a3e633af6b.camel@microchip.com>
Subject: Re: [RFC PATCH v2 4/8] net: sparx5: add port module support
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Steen Hegelund <steen.hegelund@microchip.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Tue, 22 Dec 2020 15:55:42 +0100
In-Reply-To: <20201220233543.GB3107610@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
         <20201217075134.919699-5-steen.hegelund@microchip.com>
         <20201220233543.GB3107610@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-21 at 00:35 +0100, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> > +     /* Aneg complete provides more information  */
> > +     if (DEV2G5_PCS1G_ANEG_STATUS_ANEG_COMPLETE_GET(value)) {
> > +             if (port->conf.portmode == PHY_INTERFACE_MODE_SGMII)
> > {
> > +                     /* SGMII cisco aneg */
> > +                     u32 spdvalue = ((lp_abil >> 10) & 3);
> 
>                         u32 spdvalue = lp_abil & LPA_SGMII_SPD_MASK;
> 
> > +
> > +                     status->link = !!((lp_abil >> 15) == 1) &&
> > status->link;
> 
> Maybe
> 
>                         status->link = !!((lp_abil & LPA_SGMII_LINK)
> && status->link;
> 
> > +                     status->an_complete = true;
> > +                     status->duplex = (lp_abil >> 12) & 0x1
> > ?  DUPLEX_FULL : DUPLEX_HALF;
> 
>                         status->duplex = (lp_abil &
> LPA_SGMII_FULL_DUPLEX) ?  DUPLEX_FULL : DUPLEX_HALF;

Yes, changed to use the SGMII macroes.

> 
> 
> > +                     if (spdvalue == LPA_SGMII_10)
> > +                             status->speed = SPEED_10;
> > +                     else if (spdvalue == LPA_SGMII_100)
> > +                             status->speed = SPEED_100;
> > +                     else
> > +                             status->speed = SPEED_1000;
> 
> I wonder if there is a helper for this?
> 
> 
> > +             } else {
> > +                     /* Clause 37 Aneg */
> > +                     status->link = !((lp_abil >> 12) & 3) &&
> > status->link;
> > +                     status->an_complete = true;
> > +                     status->duplex = ((lp_abil >> 5) & 1) ?
> > DUPLEX_FULL : DUPLEX_UNKNOWN;
> > +                     if ((lp_abil >> 8) & 1) /* symmetric pause */
> > +                             status->pause = MLO_PAUSE_RX |
> > MLO_PAUSE_TX;
> > +                     if (lp_abil & (1 << 7)) /* asymmetric pause
> > */
> > +                             status->pause |= MLO_PAUSE_RX;
> > +             }
> 
> Please check if there are any standard #defines you can use for
> this. Russell King has done some work for clause 37. Maybe there is
> some code in phy_driver.c you can use? phylink_decode_sgmii_word()

There are the ADVERTISE_* macroes in mii.h.
I've changed the code to use them.

> 
> > +static int sparx5_port_verify_speed(struct sparx5 *sparx5,
> > +                                 struct sparx5_port *port,
> > +                                 struct sparx5_port_config *conf)
> > +{
> > +     case PHY_INTERFACE_MODE_SGMII:
> > +             if (conf->speed != SPEED_1000 &&
> > +                 conf->speed != SPEED_100 &&
> > +                 conf->speed != SPEED_10 &&
> > +                 conf->speed != SPEED_2500)
> > +                     return sparx5_port_error(port, conf,
> > SPX5_PERR_SPEED);
> 
> Is it really SGMII over clocked at 2500? Or 2500BaseX?

Yes the SGMII mode in the serdes driver is overclocked.
Nothing in the switch driver needs changing when changing between
speeds 1G/2G5.
> 
> > +static int sparx5_port_fifo_sz(struct sparx5 *sparx5,
> > +                            u32 portno, u32 speed)
> > +{
> > +     u32 sys_clk    = sparx5_clk_period(sparx5->coreclock);
> > +     u32 mac_width  = 8;
> > +     u32 fifo_width = 16;
> > +     u32 addition   = 0;
> > +     u32 mac_per    = 6400, tmp1, tmp2, tmp3;
> > +     u32 taxi_dist[SPX5_PORTS_ALL] = {
> 
> const. As it is at the moment, it gets copied onto the stack, so it
> can be modified. Const i guess prevents that copy?
> 
> > +             6, 8, 10, 6, 8, 10, 6, 8, 10, 6, 8, 10,
> > +             4, 4, 4, 4,
> > +             11, 12, 13, 14, 15, 16, 17, 18,
> > +             11, 12, 13, 14, 15, 16, 17, 18,
> > +             11, 12, 13, 14, 15, 16, 17, 18,
> > +             11, 12, 13, 14, 15, 16, 17, 18,
> > +             4, 6, 8, 4, 6, 8, 6, 8,
> > +             2, 2, 2, 2, 2, 2, 2, 4, 2
> > +     };
> > +static int sparx5_port_fwd_urg(struct sparx5 *sparx5, u32 speed)

Changed to const.
> 
> What is urg?

urg=urgency (taken directly from the name in the asic). 
Another name for speed, or actually how many clockcycles can go by
before the port instance must be served. 
> 
> > +static u16 sparx5_get_aneg_word(struct sparx5_port_config *conf)
> > +{
> > +     if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX) /* cl-37
> > aneg */
> > +             return ((1 << 14) | /* ack */
> > +             ((conf->pause ? 1 : 0) << 8) | /* asymmetric pause */
> > +             ((conf->pause ? 1 : 0) << 7) | /* symmetric pause */
> > +             (1 << 5)); /* FDX only */
> 
> ADVERTISE_LPACK, ADVERTISE_PAUSE_ASYM, ADVERTISE_PAUSE_CAP,
> ADVERTISE_1000XFULL?

Yes, applied.
> 
> > +int sparx5_port_config(struct sparx5 *sparx5,
> > +                    struct sparx5_port *port,
> > +                    struct sparx5_port_config *conf)
> > +{
> > +     bool high_speed_dev = sparx5_is_high_speed_device(conf);
> > +     int err, urgency, stop_wm;
> > +
> > +     err = sparx5_port_verify_speed(sparx5, port, conf);
> > +     if (err)
> > +             return err;
> > +
> > +     /* high speed device is already configured */
> > +     if (!high_speed_dev)
> > +             sparx5_port_config_low_set(sparx5, port, conf);
> > +
> > +     /* Configure flow control */
> > +     err = sparx5_port_fc_setup(sparx5, port, conf);
> > +     if (err)
> > +             return err;
> > +
> > +     /* Set the DSM stop watermark */
> > +     stop_wm = sparx5_port_fifo_sz(sparx5, port->portno, conf-
> > >speed);
> > +     spx5_rmw(DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM_SET(stop_wm),
> > +              DSM_DEV_TX_STOP_WM_CFG_DEV_TX_STOP_WM,
> > +              sparx5,
> > +              DSM_DEV_TX_STOP_WM_CFG(port->portno));
> > +
> > +     /* Enable port forwarding */
> > +     urgency = sparx5_port_fwd_urg(sparx5, conf->speed);
> > +     spx5_rmw(QFWD_SWITCH_PORT_MODE_PORT_ENA_SET(1) |
> > +              QFWD_SWITCH_PORT_MODE_FWD_URGENCY_SET(urgency),
> > +              QFWD_SWITCH_PORT_MODE_PORT_ENA |
> > +              QFWD_SWITCH_PORT_MODE_FWD_URGENCY,
> > +              sparx5,
> > +              QFWD_SWITCH_PORT_MODE(port->portno));
> 
> What does it mean by port forwarding? By default, packets should only
> go to the CPU, until the port is added to a bridge. I've not thought
> much about L3, since DSA so far only has L2 switches, but i guess you
> don't need to enable L3 forwarding until a route out the port has
> been
> added?

This mean that the port is enabled in the queue system - not that it
can participate in switching.  When the port joins the bridge, then
forwarding masks will enable swithcing.
I've changed the comment to "Enable port in queue system"
> 
> > +/* Initialize port config to default */
> > +int sparx5_port_init(struct sparx5 *sparx5,
> > +                  struct sparx5_port *port,
> > +                  struct sparx5_port_config *conf)
> > +{
> > +     /* Discard pause frame 01-80-C2-00-00-01 */
> > +     spx5_wr(0xC, sparx5, ANA_CL_CAPTURE_BPDU_CFG(port->portno));
> 
> The comment is about pause frames, but the macro contain BPDU?

The "0xC" is a 2 bit field that chooses what to do with the second BPDU
with the address 01-80-C2-00-00-01 (0x3 chooses the first 01-80-C2-00-
00-00, and 0x300 chooses the third 01-80-C2-00-00-02, etc..).  Both
bits high means discard.
I've change the 0xC to a macro called "PAUSE_DISCARD"
> 
>     Andrew

Thanks
Bjarni Jonasson
Microchip

