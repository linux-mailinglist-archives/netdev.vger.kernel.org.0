Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8B6A5227
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfIBItn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:49:43 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43064 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfIBItn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:49:43 -0400
Received: by mail-ed1-f68.google.com with SMTP id c19so1041324edy.10
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Ucd2VN2pSWeyG/QqMUFzd1zAmcdR9ZpJ8vajkc30eM=;
        b=bWB4DVPyEctkGo0NYUfK1oOW2oVPVo2Z3T5iEWo/WRXOPof8CmWV8ZYjZgzF4oo0ws
         ivX0NtWLPT+b0mjVehgzq2Tu0+FnP/vd2Zd+HkCh06oKd3g4VeIZ0K+i5x6lgA0ZwxLz
         kIKgDquPd9/Ntv8ix4hPitrIFtw+bSIxjlaVBrxyApssxs4GAfqMNmWOFVuSUnO1UluQ
         GwC7EinIWEi2OxSwy3joCBs0WF/DkjEdN8sDbk5GuGah3veTAZ0JXgDDWgUtIe5TwPAm
         mWzjssfwFMN4N8T913EvWsRtKplXo1nP9zPUqL1I84021F7A+dbJ+SEwv6VvB75dR+F/
         Fotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Ucd2VN2pSWeyG/QqMUFzd1zAmcdR9ZpJ8vajkc30eM=;
        b=r0Pr1CFLSqQQ9JwRFxaSRXWVL3cBN0fot2JZk/EAh1IkmC+AmE8l0FltdksobRbOc/
         OgYndxerVN2v0KO2iRPm3m1BTmTDkp9FZbGZ0kfFHIAKFJX0oBLycha00eaCCXm3jLM3
         1D8DDUHCbX444HeLju/+NVMBVtf02gO4aZVogfx5kBYrqy0+2pnf7wZjot+OA9aCTlNq
         dXl/tJxVVXoeLuE8N6Utb6cgdeoDOxM/n0IYrUjeIIKD30mZGlJw4Ruqk77OvlAw7UfW
         MS/trl5+otTrOEsV56QbEydfph+8fMrgQ+81jFncxI9n3NOWfeHQYzn4MOJ92+oOnp/1
         xKNQ==
X-Gm-Message-State: APjAAAUZFDweSderQODRcTfpyGA44LYEiwNA6Y2ECxu/8pxJMdPLjIOv
        qd2IB2sI61wqvguniC02NwHftDGJPZFQ2z1tkIc=
X-Google-Smtp-Source: APXvYqz/Iywaovgx9zQXVzrkgmjxj8KZId24/PZmmZflnNDv6hh4rgbYOUqP2P+2mdzSMvdM579a5fgoWcO8GWng9jc=
X-Received: by 2002:a17:906:4e44:: with SMTP id g4mr4686564ejw.90.1567414181261;
 Mon, 02 Sep 2019 01:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190830004635.24863-1-olteanv@gmail.com> <20190830004635.24863-11-olteanv@gmail.com>
 <20190902075209.GC3343@linutronix.de>
In-Reply-To: <20190902075209.GC3343@linutronix.de>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 2 Sep 2019 11:49:30 +0300
Message-ID: <CA+h21hoVv0SwFf8=MS_SZf85QsObrNKQf_w_p=j_97i16psjDQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 10/15] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kurt,

On Mon, 2 Sep 2019 at 10:52, Kurt Kanzenbach
<kurt.kanzenbach@linutronix.de> wrote:
>
> Hi,
>
> On Fri, Aug 30, 2019 at 03:46:30AM +0300, Vladimir Oltean wrote:
> > DSA currently handles shared block filters (for the classifier-action
> > qdisc) in the core due to what I believe are simply pragmatic reasons -
> > hiding the complexity from drivers and offerring a simple API for port
> > mirroring.
> >
> > Extend the dsa_slave_setup_tc function by passing all other qdisc
> > offloads to the driver layer, where the driver may choose what it
> > implements and how. DSA is simply a pass-through in this case.
>
> I'm having the same problem on how to pass the taprio schedule down to
> the DSA driver. I didn't perform a pass-through to keep it in sync with
> the already implemented offload. See my approach below.
>
> >
> > There is an open question related to the drivers potentially needing to
> > do work in process context, but .ndo_setup_tc is called in atomic
> > context. At the moment the drivers are left to handle this on their own.
> > The risk is that once accepting the offload callback right away in the
> > DSA core, then the driver would have no way to signal an error back. So
> > right now the driver has to do as much error checking as possible in the
> > atomic context and only defer (probably) the actual configuring of the
> > offload.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  include/net/dsa.h |  3 +++
> >  net/dsa/slave.c   | 12 ++++++++----
> >  2 files changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 96acb14ec1a8..232b5d36815d 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -154,6 +154,7 @@ struct dsa_mall_tc_entry {
> >       };
> >  };
> >
> > +struct tc_taprio_qopt_offload;
>
> Is this needed? The rest looks good to me.
>

No, this isn't needed. It is a remnant from v1.

> My approach:
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index ba6dfff98196..a60bd55f27f2 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -20,6 +20,7 @@
>  #include <linux/platform_data/dsa.h>
>  #include <net/devlink.h>
>  #include <net/switchdev.h>
> +#include <net/pkt_sched.h>
>
>  struct tc_action;
>  struct phy_device;
> @@ -539,6 +540,13 @@ struct dsa_switch_ops {
>          */
>         netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
>                                           struct sk_buff *skb);
> +
> +       /*
> +        * Scheduled traffic functionality
> +        */
> +       int (*port_set_schedule)(struct dsa_switch *ds, int port,
> +                                const struct tc_taprio_qopt_offload *taprio);
> +       int (*port_del_schedule)(struct dsa_switch *ds, int port);
>  };
>
>  struct dsa_switch_driver {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 8157be7e162d..6290d55e6011 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -15,6 +15,7 @@
>  #include <linux/mdio.h>
>  #include <net/rtnetlink.h>
>  #include <net/pkt_cls.h>
> +#include <net/pkt_sched.h>
>  #include <net/tc_act/tc_mirred.h>
>  #include <linux/if_bridge.h>
>  #include <linux/netpoll.h>
> @@ -953,12 +954,33 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
>         }
>  }
>
> +static int dsa_slave_setup_tc_taprio(struct net_device *dev,
> +                                    const struct tc_taprio_qopt_offload *taprio)
> +{
> +       struct dsa_port *dp = dsa_slave_to_port(dev);
> +       struct dsa_switch *ds = dp->ds;
> +
> +       if (taprio->enable) {
> +               if (!ds->ops->port_set_schedule)
> +                       return -EOPNOTSUPP;
> +
> +               return ds->ops->port_set_schedule(ds, dp->index, taprio);
> +       }
> +
> +       if (!ds->ops->port_del_schedule)
> +               return -EOPNOTSUPP;
> +
> +       return ds->ops->port_del_schedule(ds, dp->index);
> +}
> +
>  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
>                               void *type_data)
>  {
>         switch (type) {
>         case TC_SETUP_BLOCK:
>                 return dsa_slave_setup_tc_block(dev, type_data);
> +       case TC_SETUP_QDISC_TAPRIO:
> +               return dsa_slave_setup_tc_taprio(dev, type_data);
>         default:
>                 return -EOPNOTSUPP;
>         }
>

I did something similar in v1 with a .port_setup_taprio in "[RFC PATCH
net-next 3/6] net: dsa: Pass tc-taprio offload to drivers".
Would this address Ilias's comment about DSA not really needing to
have this level of awareness into the qdisc offload type? Rightfully I
can agree that the added-value of making a .port_set_schedule and
.port_del_schedule in DSA compared to simply passing the ndo_setup_tc
is not that great.

By the way, thanks for the iproute2 patch for parsing 64-bit base time
on ARM 32, saved me a bit of debugging time :)

> Thanks,
> Kurt

Regards,
-Vladimir
