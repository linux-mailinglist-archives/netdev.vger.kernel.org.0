Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3536B30F
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 14:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhDZM2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 08:28:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232987AbhDZM2L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 08:28:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lb0Kc-001AA3-DK; Mon, 26 Apr 2021 14:27:18 +0200
Date:   Mon, 26 Apr 2021 14:27:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
Message-ID: <YIaxpsBFDiEiiRj4@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-4-prasanna.vengateshan@microchip.com>
 <20210422191853.luobzcuqsouubr7d@skbuf>
 <c5f4e12beb6381c5ae08322f1316efcecf292e12.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5f4e12beb6381c5ae08322f1316efcecf292e12.camel@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +#define LAN937X_TAIL_TAG_LOOKUP              BIT(12)
> > > +#define LAN937X_TAIL_TAG_VALID               BIT(13)
> > > +#define LAN937X_TAIL_TAG_PORT_MASK   7
> > > +
> > > +static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
> > > +                                 struct net_device *dev)
> > > +{
> > > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > > +     __be16 *tag;
> > > +     u8 *addr;
> > > +     u16 val;
> > > +r
> > > +     tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);
> > 
> > Here we go again.. why is it called INGRESS_TAG_LEN if it is used during
> > xmit, and only during xmit?

> Definition is ingress to the LAN937x since it has different tag length for
> ingress and egress of LAN937x. Do you think should it be changed? 

tag drivers run on Linux, not the switch. So all ingress/egress should
be relative to linux, not the switch. You are writing a linux driver
here, not firmware running on the switch.

      Andrew
