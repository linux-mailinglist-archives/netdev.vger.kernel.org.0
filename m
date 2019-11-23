Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27F11080A7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfKWUsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:48:45 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38113 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWUso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:48:44 -0500
Received: by mail-ed1-f65.google.com with SMTP id s10so9059986edi.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i34EvRHBRhmXFO6xmdF8o5LSzrXvvTL3TZi/0m69pMg=;
        b=LfuIiva22WybIDE3snbJsf098/fZBmYCAR628Yp9CW1eKfC15HcFeYlKCfFxy6/LoD
         GMp2Ord/2ODYrenWehuaPWL/00oUEU6LUZ1kDjfn8tInMeMOlXLp04T4oyV+Y+qW+b4p
         L+puoFNsxb8Xkzj+JL/9rzeOOrO6avwwEqATvPer6vvJ5jf/jXCyhVDWykGYt7H0exDZ
         OB/EBhZuWwBre4+PCDz5rXtPszx2KE88rltJBYPHonzWsgpes6fkdDv93Pbl4gRLpUc/
         iAVtDIdSU8FKF+uC0yqv58hUFa6TNLGNvpw+QxPT8HLzeouIAK/UfxuR3LxjgJ6uE0m/
         qK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i34EvRHBRhmXFO6xmdF8o5LSzrXvvTL3TZi/0m69pMg=;
        b=luymzvEf8J/CXVcAmKOzMBTQTUJgmVWDYj6C5iAXCzhXcDfiiC7dWIYJQOipVctfnW
         3gn7IjVQXtEpuZ4EL5JJf8VTipYlVPWOUDnc8OGZLWls/VbD9yTt5W2tKkN0dbMKFCqA
         SgmZYySbs9ZtGUkRRvN3RpUxzsX6KtetR5aMmjyItGIexkTG571YpwsXPb7UNH9cZfl0
         5JshEtZvyY5xQa4MbppmigJnTVb95SgMgDgQ5CUbGBnbPaGp+0V2YgVoQY6vkjL0Fp1k
         N3bYh6Bm60GmViw2ImrFs07LzOQCbXJce0mxC7ktQrzsFW7G0gXVSh8A7fcwqOxgTrB/
         VEVA==
X-Gm-Message-State: APjAAAVGqpLqf24WlK2+aIkySDeT/iGs3QVMLSRZi9nHpyi3k8JYPr7Y
        1STEzkL29IZazbA9iKkG2vnKqIoJEDkmEYfkEu0=
X-Google-Smtp-Source: APXvYqxUuw+z6Vq3fvCitGz+tFrQC36o8Fb9hm7CmKUetKSzUjr90sRveizDyvu9k1XOaENXUok4tci+AkhA6W+7jig=
X-Received: by 2002:a50:b63b:: with SMTP id b56mr8921529ede.165.1574542122254;
 Sat, 23 Nov 2019 12:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20191123194844.9508-1-olteanv@gmail.com> <20191123194844.9508-3-olteanv@gmail.com>
 <6bb2b2cb-361f-69bc-0299-26abcb09882f@gmail.com>
In-Reply-To: <6bb2b2cb-361f-69bc-0299-26abcb09882f@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 23 Nov 2019 22:48:31 +0200
Message-ID: <CA+h21hpES4JOM=UGMydf4rFMHO=LhzOQFMPY=Kao92ozGPxyWA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: Implement the port MTU callbacks
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 at 22:30, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 11/23/2019 11:48 AM, Vladimir Oltean wrote:
> > On this switch, the frame length enforcements are performed by the
> > ingress policers. There are 2 types of those: regular L2 (also called
> > best-effort) and Virtual Link policers (an ARINC664/AFDX concept for
> > defining L2 streams with certain QoS abilities). To avoid future
> > confusion, I prefer to call the reset reason "Best-effort policers",
> > even though the VL policers are not yet supported.
> >
> > We also need to change the setup of the initial static config, such that
> > DSA calls to .change_mtu (which are expensive) become no-ops and don't
> > reset the switch 5 times.
> >
> > A driver-level decision is to unconditionally allow single VLAN-tagged
> > traffic on all ports. The CPU port must accept an additional VLAN header
> > for the DSA tag, which is again a driver-level decision.
> >
> > The policers actually count bytes not only from the SDU, but also from
> > the Ethernet header and FCS, so those need to be accounted for as well.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  drivers/net/dsa/sja1105/sja1105.h      |  1 +
> >  drivers/net/dsa/sja1105/sja1105_main.c | 48 +++++++++++++++++++++++---
> >  2 files changed, 45 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
> > index d801fc204d19..3a5c8acb6e2a 100644
> > --- a/drivers/net/dsa/sja1105/sja1105.h
> > +++ b/drivers/net/dsa/sja1105/sja1105.h
> > @@ -122,6 +122,7 @@ enum sja1105_reset_reason {
> >       SJA1105_RX_HWTSTAMPING,
> >       SJA1105_AGEING_TIME,
> >       SJA1105_SCHEDULING,
> > +     SJA1105_BEST_EFFORT_POLICING,
> >  };
> >
> >  int sja1105_static_config_reload(struct sja1105_private *priv,
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index b60224c55244..3d55dd3c7e83 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -459,12 +459,12 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
> >  #define SJA1105_RATE_MBPS(speed) (((speed) * 64000) / 1000)
> >
> >  static void sja1105_setup_policer(struct sja1105_l2_policing_entry *policing,
> > -                               int index)
> > +                               int index, int mtu)
> >  {
> >       policing[index].sharindx = index;
> >       policing[index].smax = 65535; /* Burst size in bytes */
> >       policing[index].rate = SJA1105_RATE_MBPS(1000);
> > -     policing[index].maxlen = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
> > +     policing[index].maxlen = mtu;
> >       policing[index].partition = 0;
> >  }
> >
> > @@ -496,12 +496,16 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
> >        */
> >       for (i = 0, k = 0; i < SJA1105_NUM_PORTS; i++) {
> >               int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + i;
> > +             int mtu = VLAN_ETH_FRAME_LEN + ETH_FCS_LEN;
> > +
> > +             if (dsa_is_cpu_port(priv->ds, i))
> > +                     mtu += VLAN_HLEN;
>
> That really seems like a layering violation it so happens that you use
> DSA_TAG_8021Q which is why you need VLAN_ETH_HLEN, but you should not
> assume that from with your driver, even if this one is special on so
> many counts. How about using use dsa_port(port)->tag_ops->overhead +
> ETH_HLEN here?

True here.

> >
> >               for (j = 0; j < SJA1105_NUM_TC; j++, k++)
> > -                     sja1105_setup_policer(policing, k);
> > +                     sja1105_setup_policer(policing, k, mtu);
> >
> >               /* Set up this port's policer for broadcast traffic */
> > -             sja1105_setup_policer(policing, bcast);
> > +             sja1105_setup_policer(policing, bcast, mtu);
> >       }
> >       return 0;
> >  }
> > @@ -1346,6 +1350,7 @@ static const char * const sja1105_reset_reasons[] = {
> >       [SJA1105_RX_HWTSTAMPING] = "RX timestamping",
> >       [SJA1105_AGEING_TIME] = "Ageing time",
> >       [SJA1105_SCHEDULING] = "Time-aware scheduling",
> > +     [SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
> >  };
> >
> >  /* For situations where we need to change a setting at runtime that is only
> > @@ -1886,6 +1891,39 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
> >       return sja1105_static_config_reload(priv, SJA1105_AGEING_TIME);
> >  }
> >
> > +static int sja1105_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> > +{
> > +     int bcast = (SJA1105_NUM_PORTS * SJA1105_NUM_TC) + port;
> > +     struct sja1105_l2_policing_entry *policing;
> > +     struct sja1105_private *priv = ds->priv;
> > +     int tc;
> > +
> > +     new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
>
> Likewise

Not the same thing here. I wrote about this one in the commit message:
"A driver-level decision is to unconditionally allow single
VLAN-tagged traffic on all ports". How is this handled more correctly?

> --
> Florian

Thanks,
-Vladimir
