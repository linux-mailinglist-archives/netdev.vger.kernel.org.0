Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3371D9404
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgESKGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 06:06:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38930 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726333AbgESKGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:06:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589882759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7Pb0OijTA+irttwxC+dxELBnYCuz9NJOuNYknbTw1Q=;
        b=WLNGyhE59TAn+NOIB3tfIp1NHP6D6qhXpXRogSNh2raDSZe+ImnAtCoZf5Wb0PyScLdoV8
        E5oM/Jfx84pRPBj+O1G6XbsN2uqYMw5Oo+gO3RetgIZlOUcCpgblV3r0uteTyE2HEkb00j
        JwJKnE5t/XfRwUCAYAzFHaNnlc3yRnA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-7hIPIKxGNr-mwmGk74P7-w-1; Tue, 19 May 2020 06:05:58 -0400
X-MC-Unique: 7hIPIKxGNr-mwmGk74P7-w-1
Received: by mail-ed1-f72.google.com with SMTP id f18so4670310eds.6
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:05:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7Pb0OijTA+irttwxC+dxELBnYCuz9NJOuNYknbTw1Q=;
        b=bKZ9jo9U22tfjk+XBcd6gS5gYK2hDNBfhOVUfQSQR1ooipP1D53PO6BSn2pyFsVLe+
         vZHv0e2Eb3WoyeIwvkQQvhGaunloBAAFYj0cIW67jR+MBHYR+M4i6LyRvB/zA6CxsRO3
         fw+4X/8+xGUIaKmVn+apOZYCxuqyDFL6JU0BFOL41rHJT7Z7mHm6PFZpCa3Vu37VFbI8
         vA8ftD2793tVuJdZDHuLa+locvIs7MlOQSSua8GC1rPQXUtFWC4nTC8XOZqnXEpOHbYy
         vbsLo7hUXDgO96AXRQClYNVz9NSVl4uI0sg4Bq1wXbg8X2JEIUvjGi+PYlFGi696WNCZ
         RUSg==
X-Gm-Message-State: AOAM530aFGYEc+p+AxnWYt7+YTh2Cf+pLBHqcdzT8ELztxjzC4hhELAQ
        Z4XD6PIQgwuJsHsBlsU1pn9efgw/fMJwDFRl7tpkqhMnlJ8APS7bewiIR8C27Ps9WHiEW4aX+d0
        ld3s2lbv9RRgZgIOK8gsDrWEwwJucEhOi
X-Received: by 2002:a17:906:2503:: with SMTP id i3mr17354035ejb.293.1589882756926;
        Tue, 19 May 2020 03:05:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJ1McJxtcCmjVmosQ2avZ2PtCSSDCXz2Om0hD2da3gdN7fS7o6Mf8E32HG29p7gwidi7B2T3qwUaeoW85+L6Q=
X-Received: by 2002:a17:906:2503:: with SMTP id i3mr17354012ejb.293.1589882756498;
 Tue, 19 May 2020 03:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com> <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk> <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk> <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
 <20200509195246.GJ1551@shell.armlinux.org.uk> <20200509202050.GK1551@shell.armlinux.org.uk>
 <20200519095330.GA1551@shell.armlinux.org.uk>
In-Reply-To: <20200519095330.GA1551@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 19 May 2020 12:05:20 +0200
Message-ID: <CAGnkfhzuyxJDo-DXPHPiNtP4RbRpry+3M9eoiTknGR0zvgPuoA@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 11:54 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sat, May 09, 2020 at 09:20:50PM +0100, Russell King - ARM Linux admin wrote:
> > On Sat, May 09, 2020 at 08:52:46PM +0100, Russell King - ARM Linux admin wrote:
> > > It is highly likely that 895586d5dc32 is responsible for this breakage.
> > > I've been investigating this afternoon, and what I've found, comparing
> > > a kernel without 895586d5dc32 and with 895586d5dc32 applied is:
> > >
> > > - The table programmed into the hardware via mvpp22_rss_fill_table()
> > >   appears to be identical with or without the commit.
> > >
> > > - When rxhash is enabled on eth2, mvpp2_rss_port_c2_enable() reports
> > >   that c2.attr[0] and c2.attr[2] are written back containing:
> > >
> > >    - with 895586d5dc32, failing:    00200000 40000000
> > >    - without 895586d5dc32, working: 04000000 40000000
> > >
> > > - When disabling rxhash, c2.attr[0] and c2.attr[2] are written back as:
> > >
> > >    04000000 00000000
> > >
> > > The second value represents the MVPP22_CLS_C2_ATTR2_RSS_EN bit, the
> > > first value is the queue number, which comprises two fields.  The high
> > > 5 bits are 24:29 and the low three are 21:23 inclusive.  This comes
> > > from:
> > >
> > >        c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
> > >                      MVPP22_CLS_C2_ATTR0_QLOW(ql);
> > > #define     MVPP22_CLS_C2_ATTR0_QHIGH(qh)       (((qh) & 0x1f) << 24)
> > > #define     MVPP22_CLS_C2_ATTR0_QLOW(ql)        (((ql) & 0x7) << 21)
> > >
> > > So, the working case gives eth2 a queue id of 4.0, or 32 as per
> > > port->first_rxq, and the non-working case a queue id of 0.1, or 1.
> > >
> > > The allocation of queue IDs seems to be in mvpp2_port_probe():
> > >
> > >         if (priv->hw_version == MVPP21)
> > >                 port->first_rxq = port->id * port->nrxqs;
> > >         else
> > >                 port->first_rxq = port->id * priv->max_port_rxqs;
> > >
> > > Where:
> > >
> > >         if (priv->hw_version == MVPP21)
> > >                 priv->max_port_rxqs = 8;
> > >         else
> > >                 priv->max_port_rxqs = 32;
> > >
> > > Making the port 0 (eth0 / eth1) have port->first_rxq = 0, and port 1
> > > (eth2) be 32.  It seems the idea is that the first 32 queues belong to
> > > port 0, the second 32 queues belong to port 1, etc.
> > >
> > > mvpp2_rss_port_c2_enable() gets the queue number from it's parameter,
> > > 'ctx', which comes from mvpp22_rss_ctx(port, 0).  This returns
> > > port->rss_ctx[0].
> > >
> > > mvpp22_rss_context_create() is responsible for allocating that, which
> > > it does by looking for an unallocated priv->rss_tables[] pointer.  This
> > > table is shared amongst all ports on the CP silicon.
> > >
> > > When we write the tables in mvpp22_rss_fill_table(), the RSS table
> > > entry is defined by:
> > >
> > >             u32 sel = MVPP22_RSS_INDEX_TABLE(rss_ctx) |
> > >                           MVPP22_RSS_INDEX_TABLE_ENTRY(i);
> > >
> > > where rss_ctx is the context ID (queue number) and i is the index in
> > > the table.
> > >
> > > #define     MVPP22_RSS_INDEX_TABLE_ENTRY(idx)   (idx)
> > > #define     MVPP22_RSS_INDEX_TABLE(idx)         ((idx) << 8)
> > > #define     MVPP22_RSS_INDEX_QUEUE(idx)         ((idx) << 16)
> > >
> > > If we look at what is written:
> > >
> > > - The first table to be written has "sel" values of 00000000..0000001f,
> > >   containing values 0..3. This appears to be for eth1.  This is table 0,
> > >   RX queue number 0.
> > > - The second table has "sel" values of 00000100..0000011f, and appears
> > >   to be for eth2.  These contain values 0x20..0x23.  This is table 1,
> > >   RX queue number 0.
> > > - The third table has "sel" values of 00000200..0000021f, and appears
> > >   to be for eth3.  These contain values 0x40..0x43.  This is table 2,
> > >   RX queue number 0.
> > >
> > > Okay, so how do queue numbers translate to the RSS table?  There is
> > > another table - the RXQ2RSS table, indexed by the MVPP22_RSS_INDEX_QUEUE
> > > field of MVPP22_RSS_INDEX and accessed through the MVPP22_RXQ2RSS_TABLE
> > > register.  Before 895586d5dc32, it was:
> > >
> > >        mvpp2_write(priv, MVPP22_RSS_INDEX,
> > >                    MVPP22_RSS_INDEX_QUEUE(port->first_rxq));
> > >        mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE,
> > >                    MVPP22_RSS_TABLE_POINTER(port->id));
> > >
> > > and after:
> > >
> > >        mvpp2_write(priv, MVPP22_RSS_INDEX, MVPP22_RSS_INDEX_QUEUE(ctx));
> > >        mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE, MVPP22_RSS_TABLE_POINTER(ctx));
> > >
> > > So, before the commit, for eth2, that would've contained '32' for the
> > > index and '1' for the table pointer - mapping queue 32 to table 1.
> > > Remember that this is queue-high.queue-low of 4.0.
> > >
> > > After the commit, we appear to map queue 1 to table 1.  That again
> > > looks fine on the face of it.
> > >
> > > Section 9.3.1 of the A8040 manual seems indicate the reason that the
> > > queue number is separated.  queue-low seems to always come from the
> > > classifier, whereas queue-high can be from the ingress physical port
> > > number or the classifier depending on the MVPP2_CLS_SWFWD_PCTRL_REG.
> > >
> > > We set the port bit in MVPP2_CLS_SWFWD_PCTRL_REG, meaning that queue-high
> > > comes from the MVPP2_CLS_SWFWD_P2HQ_REG() register... and this seems to
> > > be where our bug comes from.
> > >
> > > mvpp2_cls_oversize_rxq_set() sets this up as:
> > >
> > >         mvpp2_write(port->priv, MVPP2_CLS_SWFWD_P2HQ_REG(port->id),
> > >                     (port->first_rxq >> MVPP2_CLS_OVERSIZE_RXQ_LOW_BITS));
> > >
> > >         val = mvpp2_read(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG);
> > >         val |= MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
> > >         mvpp2_write(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG, val);
> > >
> > > so, the queue-high for eth2 is _always_ 4, meaning that only queues
> > > 32 through 39 inclusive are available to eth2.  Yet, we're trying to
> > > tell the classifier to set queue-high, which will be ignored, to zero.
> > >
> > > So we end up directing traffic from eth2 not to queue 1, but to queue
> > > 33, and then we tell it to look up queue 33 in the RSS table.  However,
> > > RSS table has not been programmed for queue 33, and so it ends up
> > > (presumably) dropping the packets.
> > >
> > > It seems that mvpp22_rss_context_create() doesn't take account of the
> > > fact that the upper 5 bits of the queue ID can't actually be changed
> > > due to the settings in mvpp2_cls_oversize_rxq_set(), _or_ it seems
> > > that mvpp2_cls_oversize_rxq_set() has been missed in this commit.
> > > Either way, these two functions mutually disagree with what queue
> > > number should be used.
> > >
> > > So, 895586d5dc32 is indeed the cause of this problem.
> >
> > Looking deeper into what mvpp2_cls_oversize_rxq_set() and the MTU
> > validation is doing, it seems that MVPP2_CLS_SWFWD_P2HQ_REG() is
> > used for at least a couple of things.
> >
> > So, with the classifier having had RSS enabled and directing eth2
> > traffic to queue 1, we can not ignore the fact that we may have
> > packets appearing on queue 32 for this port.
> >
> > One of the things that queue 32 will be used for is if an over-sized
> > packet attempts to egress through eth2 - it seems that the A8040 has
> > the ability to forward frames between its ports.  However, afaik we
> > don't support that feature, and the kernel restricts the packet size,
> > so we should never violate the MTU validator and end up with such a
> > packet.  In any case, _if_ we were to attempt to transmit an oversized
> > packet, we have no support in the kernel to deal with that appearing
> > in the port's receive queue.
> >
> > Maybe it would be safe to clear the MVPP2_CLS_SWFWD_PCTRL_MASK() bit?
> >
> > My testing seems to confirm my findings above - clearing this bit
> > means that if I enable rxhash on eth2, the interface can then pass
> > traffic, as we are now directing traffic to RX queue 1 rather than
> > queue 33.  Traffic still seems to work with rxhash off as well.
> >
> > So, I think it's clear where the problem lies, but not what the correct
> > solution is; someone with more experience of packet classifiers (this
> > one?) needs to look at this - this is my first venture into these
> > things, and certainly the first time I've traced through how this is
> > trying to work (or not)...
>
> This is what I was using here to work around the problem, and what I
> mentioned above.
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> index fd221d88811e..0dd3b65822dd 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> @@ -1058,7 +1058,7 @@ void mvpp2_cls_oversize_rxq_set(struct mvpp2_port *port)
>                     (port->first_rxq >> MVPP2_CLS_OVERSIZE_RXQ_LOW_BITS));
>
>         val = mvpp2_read(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG);
> -       val |= MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
> +       val &= ~MVPP2_CLS_SWFWD_PCTRL_MASK(port->id);
>         mvpp2_write(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG, val);
>  }
>
>

Hi,

I will try this change and let you know if it works.

Thanks

-- 
Matteo Croce
per aspera ad upstream

