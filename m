Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5584239C171
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 22:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhFDUla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 16:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhFDUl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 16:41:29 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADAFC061766;
        Fri,  4 Jun 2021 13:39:41 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b11so12589026edy.4;
        Fri, 04 Jun 2021 13:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bbs2f9nLMHjJjeZNHLtdRYuTq//61AHn6SXNQVNmxPQ=;
        b=ar6TX8e3UpC1L0TykgNN7STEVagcr+akpIDyRRBuhaYpSEmeYH9SvruJ8tKYnQmHtG
         GXHHpegfvf1oGzYJQefzikIbZxr+heMOJ+P21g+4+rENKvXXlGzQnvKGiIDOanwwqybe
         DmbdiY+prLwaMUvYL66FKYTJlr0ru+6KnyAyWw+hVVD7OFE0QRqUv5HVgq6HLW4g2mjS
         PIxPVFtwJNo5RLbBgIFgguVR9Fp+PQe3loGB5vDL0ze+bGfeKYU7kYFy7qJf6eA0zram
         WrxQFZoElNtSntQ8/9KYBVeO7UVNkWM1Dm125cQ3O8VKADUaG8CbOLNapZDfIDrvFenP
         SAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bbs2f9nLMHjJjeZNHLtdRYuTq//61AHn6SXNQVNmxPQ=;
        b=nfdqmKYZjLSj224R6hTw37bbzxdv/t13mAQazZNdun+11JFr+VzHtXcFV2bPXwhptQ
         NJLIBxZ76hkvH1u4+L6TnDanLMJhaji4mgcWPB019WoBTF/cPi8Wv3HACL/7tYYqF7bq
         lE0y0ItGCr+rNhncaDHVim5TtOCQH14ovEF6mxm+b/juEfONlYe/5J+sramjHvQfwpC+
         45MrV8/lSFyiNlgjtqBHFntqXLVB/cmXqeIs4yYGvbygrvPIOz7Po7FsJPo5C5XnV5fY
         ahxcpUHUiYtd1a4IvmrmEoRZjvNu8Yiv+BweC3pjnGJ2TTviSGSYFjPq7HnUjVlNl1kC
         iQ1w==
X-Gm-Message-State: AOAM5323uQhJSN28b8ARjkl0khMZ8i5CqFRHE9Q9K3RAr6lN8p3tmjil
        WfK66SZrfkMIolYoQbypxkUJyFYXhlk=
X-Google-Smtp-Source: ABdhPJyiIUcW2mT03Ljh8Snqx+MKIkiXa1oASeOdc/fESx/oM6Ap/gwmi/m1uDggg3v6MdEPdnOE3A==
X-Received: by 2002:a05:6402:31ba:: with SMTP id dj26mr6591152edb.71.1622839180449;
        Fri, 04 Jun 2021 13:39:40 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k21sm3221361ejp.23.2021.06.04.13.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 13:39:40 -0700 (PDT)
Date:   Fri, 4 Jun 2021 23:39:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision
 dupes for node_table
Message-ID: <20210604203938.gxmkm3prrmkgc7fl@skbuf>
References: <20210604162922.76954-1-george.mccollister@gmail.com>
 <20210604185511.yi5zejpz37rklzfw@skbuf>
 <CAFSKS=Mdx3FH1bkiBfCitxSAP1CCYTb4jkkF0SoC72_a0KWL0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=Mdx3FH1bkiBfCitxSAP1CCYTb4jkkF0SoC72_a0KWL0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 02:50:31PM -0500, George McCollister wrote:
> On Fri, Jun 4, 2021 at 1:55 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Fri, Jun 04, 2021 at 11:29:22AM -0500, George McCollister wrote:
> > > Add an inbound policy filter which matches the HSR/PRP supervision
> > > MAC range and forwards to the CPU port without discarding duplicates.
> > > This is required to correctly populate time_in[A] and time_in[B] in the
> > > HSR/PRP node_table. Leave the policy disabled by default and
> > > enable/disable it when joining/leaving hsr.
> > >
> > > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > > ---
> >
> > What happens if duplicates are discarded for supervision frames and
> > time_in[A] or time_in[B] is not updated in the node table?
> 
> It'll indicate an error condition that doesn't exist though everything
> will work just fine.
> It'll call hsr_nl_ringerror() and show only time_in[A] or time_in[B]
> updating in /sys/kernel/debug/hsr/hsr0/node_table.

I see.

> IEC 62439-3 specifies an SNMP MIB that contains the node_table. I've
> implemented Net-SNMP mibgroup code to provide the node table data for
> remote monitoring.
> 
> Basically if time_in[A] and time_in[B] aren't both updating it means:
> For HSR there is a break in the ring.
> For PRP: A device has a cable connecting to a switch unplugged or a failed port.
> 
> >
> > >  drivers/net/dsa/xrs700x/xrs700x.c | 67 +++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 67 insertions(+)
> > >
> > > diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
> > > index fde6e99274b6..a79066174a77 100644
> > > --- a/drivers/net/dsa/xrs700x/xrs700x.c
> > > +++ b/drivers/net/dsa/xrs700x/xrs700x.c
> > > @@ -79,6 +79,9 @@ static const struct xrs700x_mib xrs700x_mibs[] = {
> > >       XRS700X_MIB(XRS_EARLY_DROP_L, "early_drop", tx_dropped),
> > >  };
> > >
> > > +static const u8 eth_hsrsup_addr[ETH_ALEN] = {
> > > +     0x01, 0x15, 0x4e, 0x00, 0x01, 0x00};
> > > +
> >
> > What if the user sets a different last address byte for supervision frames?
> 
> Below I only actually use 40 bits in the policy. See comment in the code.

Yes, I didn't reach that far with reading.

> >
> > >  static void xrs700x_get_strings(struct dsa_switch *ds, int port,
> > >                               u32 stringset, u8 *data)
> > >  {
> > > @@ -329,6 +332,50 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
> > >       return 0;
> > >  }
> > >
> > > +/* Add an inbound policy filter which matches the HSR/PRP supervision MAC
> > > + * range and forwards to the CPU port without discarding duplicates.
> > > + * This is required to correctly populate the HSR/PRP node_table.
> > > + * Leave the policy disabled, it will be enabled as needed.
> > > + */
> > > +static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
> > > +{
> > > +     struct xrs700x *priv = ds->priv;
> > > +     unsigned int val = 0;
> > > +     int i = 0;
> > > +     int ret;
> > > +
> > > +     /* Compare 40 bits of the destination MAC address. */
> > > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 40 << 2);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     /* match HSR/PRP supervision destination 01:15:4e:00:01:XX */
> > > +     for (i = 0; i < sizeof(eth_hsrsup_addr); i += 2) {
> > > +             ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 1) + i,
> > > +                                eth_hsrsup_addr[i] |
> > > +                                (eth_hsrsup_addr[i + 1] << 8));
> > > +             if (ret)
> > > +                     return ret;
> > > +     }
> > > +
> > > +     /* Mirror HSR/PRP supervision to CPU port */
> > > +     for (i = 0; i < ds->num_ports; i++) {
> > > +             if (dsa_is_cpu_port(ds, i))
> > > +                     val |= BIT(i);
> > > +     }
> > > +
> > > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 1), val);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     /* Allow must be set prevent duplicate discard */
> > > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > >  static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> > >  {
> > >       bool cpu_port = dsa_is_cpu_port(ds, port);
> > > @@ -358,6 +405,10 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> > >               ret = xrs700x_port_add_bpdu_ipf(ds, port);
> > >               if (ret)
> > >                       return ret;
> > > +
> > > +             ret = xrs700x_port_add_hsrsup_ipf(ds, port);
> > > +             if (ret)
> > > +                     return ret;
> > >       }
> > >
> > >       return 0;
> > > @@ -565,6 +616,14 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
> > >                           XRS_PORT_FORWARDING);
> > >       regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> > >
> > > +     /* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> > > +      * which allows HSR/PRP supervision forwarding to the CPU port without
> > > +      * discarding duplicates.
> > > +      */
> > > +     regmap_update_bits(priv->regmap,
> > > +                        XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
> > > +     regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
> > > +
> > >       hsr_pair[0] = port;
> > >       hsr_pair[1] = partner->index;
> > >       for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> > > @@ -611,6 +670,14 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
> > >                           XRS_PORT_FORWARDING);
> > >       regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
> > >
> > > +     /* Disable inbound policy added by xrs700x_port_add_hsrsup_ipf()
> > > +      * which allows HSR/PRP supervision forwarding to the CPU port without
> > > +      * discarding duplicates.
> > > +      */
> > > +     regmap_update_bits(priv->regmap,
> > > +                        XRS_ETH_ADDR_CFG(partner->index, 1), 1, 0);
> > > +     regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 0);
> > > +
> > >       hsr_pair[0] = port;
> > >       hsr_pair[1] = partner->index;
> > >       for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
> > > --
> > > 2.11.0
> > >
