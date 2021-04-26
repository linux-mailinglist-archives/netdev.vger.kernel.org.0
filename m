Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0086836ABAA
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 06:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDZEey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 00:34:54 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43540 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZEew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 00:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619411652; x=1650947652;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=waRlw9pfu8PFrlVj4Ow3lPiMZiLtQJObTByWWoeyO6o=;
  b=eeNpzuQagXFCyCAGvdNgoJ0I7SUwnBDj2wolqklFySfP02HMFhRYF9cM
   2a+XA5fjJ2gHvwiJD71E3hQTr6KgTKD3wfKvoFPpengHSxL+I4+AXAU13
   vO0FGXSBufmeuGjZafezbepQBugH1oLL4u6eTv2ZzoetY2o08WMRBQXTX
   pCDjl5UUUYVoJtI+8KW+KSOErUJlz/DqbC3XCHTRFKmX0pjONpZ20MV5M
   mtPipCy7GaT4Jrm8+JZbfqO2FnQdHiOQhZIX9yWdHB3sn9xJMhBSAPsDr
   FesrxMDlsgmYOtUHl0UKE3koDcp+W14mY0dgjPv8P0Hp9eJXxr3suJb73
   g==;
IronPort-SDR: M/57nWY0I+6MOvEU216SGDfVYpSN8KTmWI+alyI8ndXhWapYShl8IyExxP89IkNfEr/EL2sOat
 rKj8JaWCXxpbJnxJxr8+Fqn4zuw/s2uSMLTh4wH8nC0945q7cSoKlf6n/d9UkssK/hzOLyhF4D
 b/GD0RIVyvz5TrsHj7AQ74uOPo7KMbznnUvkzCkTXCLzTF7OqB6o+ZntaE0iQ9YKf5eKPGAEHF
 sZPGVi8a5mqxZ78+fXRthc2CTMNcJVKeicuFqD6LyBpYx/b9IvNQ13xMNZl/MVQhcEYmyByE+1
 Nz8=
X-IronPort-AV: E=Sophos;i="5.82,251,1613458800"; 
   d="scan'208";a="114842862"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2021 21:34:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Apr 2021 21:33:58 -0700
Received: from INB-LOAN0158.mchp-main.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sun, 25 Apr 2021 21:33:53 -0700
Message-ID: <c5f4e12beb6381c5ae08322f1316efcecf292e12.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 3/9] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 26 Apr 2021 10:03:52 +0530
In-Reply-To: <20210422191853.luobzcuqsouubr7d@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-4-prasanna.vengateshan@microchip.com>
         <20210422191853.luobzcuqsouubr7d@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-22 at 22:18 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Apr 22, 2021 at 03:12:51PM +0530, Prasanna Vengateshan wrote:
> > The Microchip LAN937X switches have a tagging protocol which is
> > very similar to KSZ tagging. So that the implementation is added to
> > tag_ksz.c and reused common APIs
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> > ---
> >  include/net/dsa.h |  2 ++
> >  net/dsa/Kconfig   |  4 ++--
> >  net/dsa/tag_ksz.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 62 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 507082959aa4..98c1ab6dc4dc 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -50,6 +50,7 @@ struct phylink_link_state;
> >  #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE     20
> >  #define DSA_TAG_PROTO_SEVILLE_VALUE          21
> >  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE              22
> > +#define DSA_TAG_PROTO_LAN937X_VALUE          23
> > 
> >  enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_NONE              = DSA_TAG_PROTO_NONE_VALUE,
> > @@ -75,6 +76,7 @@ enum dsa_tag_protocol {
> >       DSA_TAG_PROTO_XRS700X           = DSA_TAG_PROTO_XRS700X_VALUE,
> >       DSA_TAG_PROTO_OCELOT_8021Q      = DSA_TAG_PROTO_OCELOT_8021Q_VALUE,
> >       DSA_TAG_PROTO_SEVILLE           = DSA_TAG_PROTO_SEVILLE_VALUE,
> > +     DSA_TAG_PROTO_LAN937X           = DSA_TAG_PROTO_LAN937X_VALUE,
> >  };
> > 
> >  struct packet_type;
> > diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> > index cbc2bd643ab2..888eb79a85f2 100644
> > --- a/net/dsa/Kconfig
> > +++ b/net/dsa/Kconfig
> > @@ -97,10 +97,10 @@ config NET_DSA_TAG_MTK
> >         Mediatek switches.
> > 
> >  config NET_DSA_TAG_KSZ
> > -     tristate "Tag driver for Microchip 8795/9477/9893 families of
> > switches"
> > +     tristate "Tag driver for Microchip 8795/937x/9477/9893 families of
> > switches"
> >       help
> >         Say Y if you want to enable support for tagging frames for the
> > -       Microchip 8795/9477/9893 families of switches.
> > +       Microchip 8795/937x/9477/9893 families of switches.
> > 
> >  config NET_DSA_TAG_RTL4_A
> >       tristate "Tag driver for Realtek 4 byte protocol A tags"
> > diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> > index 4820dbcedfa2..a67f21bdab8f 100644
> > --- a/net/dsa/tag_ksz.c
> > +++ b/net/dsa/tag_ksz.c
> > @@ -190,10 +190,68 @@ static const struct dsa_device_ops ksz9893_netdev_ops
> > = {
> >  DSA_TAG_DRIVER(ksz9893_netdev_ops);
> >  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
> > 
> > +/* For xmit, 2 bytes are added before FCS.
> > + * ------------------------------------------------------------------------
> > ---
> > + *
> > DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
> > + * ------------------------------------------------------------------------
> > ---
> > + * tag0 : represents tag override, lookup and valid
> > + * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
> > + *
> > + * For rcv, 1 byte is added before FCS.
> > + * ------------------------------------------------------------------------
> > ---
> > + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> > + * ------------------------------------------------------------------------
> > ---
> > + * tag0 : zero-based value represents port
> > + *     (eg, 0x00=port1, 0x02=port3, 0x07=port8)
> > + */
> > +#define LAN937X_INGRESS_TAG_LEN              2
> > +
> > +#define LAN937X_TAIL_TAG_OVERRIDE    BIT(11)
> 
> I had to look up the datasheet, to see what this is, because "override"
> can mean many things, not all of them are desirable.
> 
> Port Blocking Override
> When set, packets will be sent from the specified port(s) regardless, and any
> port
> blocking (see Port Transmit Enable in Port MSTP State Register) is ignored.
> 
> Do you think you can name it LAN937X_TAIL_TAG_BLOCKING_OVERRIDE? I know
> it's longer, but it's also more suggestive.
Thanks for reviewing the patch series. Suggestion looks meaningful. Noted for
next rev.

> 
> > +#define LAN937X_TAIL_TAG_LOOKUP              BIT(12)
> > +#define LAN937X_TAIL_TAG_VALID               BIT(13)
> > +#define LAN937X_TAIL_TAG_PORT_MASK   7
> > +
> > +static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
> > +                                 struct net_device *dev)
> > +{
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     __be16 *tag;
> > +     u8 *addr;
> > +     u16 val;
> > +r
> > +     tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);
> 
> Here we go again.. why is it called INGRESS_TAG_LEN if it is used during
> xmit, and only during xmit?
Definition is ingress to the LAN937x since it has different tag length for
ingress and egress of LAN937x. Do you think should it be changed? 


> 
> > +     addr = skb_mac_header(skb);
> 
> My personal choice would have been:
> 
>         const struct ethhdr *hdr = eth_hdr(skb);
> 
>         if (is_link_local_ether_addr(hdr->h_dest))
It makes more understandable since h_dest is passed. Noted.

> 
> > 
> > 2.27.0
> > 


