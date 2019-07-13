Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10E67A2A
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfGMMsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 08:48:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41543 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfGMMsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 08:48:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so11455213eds.8
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 05:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SrkNb5xBxqGf+H+rFNko0YJ7bK2M7HbvhzTjBDSRtQ=;
        b=IZ/7bZgu214lk2BX+IN1LyuLuc1qHA0W65v08tN7dlYeKH8MXpCXnedCXIw6d5tnKp
         Orad18O5iEZcVcLHAu7VNqYsyYAD51OhE8RNwKhkGbc3KHQ89Rm1WhfemQwkfJQGrvuY
         4bPBrZIJzYjSz5M6x1/4sBtFQZsT4x7B8jblhbbMqcdZ37sUyCOJ7xniakjEp3YcBBph
         bdVaUbyREaK+XmmzO2PqD6nkytSeAMoO+1P4CjA72ytVM3PnrDnJAwP+ijhdyQcNw2Tu
         PHFtPWPBk8vDKbwA3aGL7xAPmrfmysuYijj+4L40cpDzjU6LmrIDGh+Qhi0T5kb50v63
         zk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SrkNb5xBxqGf+H+rFNko0YJ7bK2M7HbvhzTjBDSRtQ=;
        b=QSlL8zj4g4X96hcf2ioF8sZxTltumLYbLnUuJg6Nk6pCiczOxgSrtFAqs7CTRVOP57
         Wz5b+4vg2IUmfY1Ew14zV++tNRWEV7zZ9gH2fvOb92W+EKNLJPexBjlWtMjy14TOrJZP
         fRclHJjyx5GqBth2JCDyiA0aJXhllAYMBbwdjmD2sAvkeklwwfKWVgFzMdhdctIXC6DQ
         YzepSWtsT4mnBBACwlv7YfXiCbLVvDEeTgyBhoXD4MaKM2AsOkjChk7kUkV67DJqomQi
         2anRbpc9G/cF7bQVkErFPwU/QZdB2sOWqfBNZR/eb2uWqeAEvALraRdYBUBa+sPtponx
         Q2eA==
X-Gm-Message-State: APjAAAUw1Zmcre75ltYwyqkIRn6maQ005LLnJCsP4Oj027Ic4Qe6YBV4
        E4JJBkGOh1O0VvLkaWxXCE0LY+KlcnzTsCez4iU=
X-Google-Smtp-Source: APXvYqxqkweQPNbcNb+AxFSh4tMY9oWFhekl6cbiSskbVBZxbWQbBQYNDYHj4j3IsEhjysoCEuGKzeSF3iepqiGWsz0=
X-Received: by 2002:a50:ba1b:: with SMTP id g27mr14048736edc.18.1563022092231;
 Sat, 13 Jul 2019 05:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190707172921.17731-1-olteanv@gmail.com> <20190707172921.17731-4-olteanv@gmail.com>
 <20190708112307.GA7480@apalos>
In-Reply-To: <20190708112307.GA7480@apalos>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 13 Jul 2019 15:48:01 +0300
Message-ID: <CA+h21hoRnXYrudJVLpRnvaRj1pJurmOsUpkjkbGDtGqR_kUZcQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/6] net: dsa: Pass tc-taprio offload to drivers
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias,

On Mon, 8 Jul 2019 at 14:23, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Vladimir,
>
> > tc-taprio is a qdisc based on the enhancements for scheduled traffic
> > specified in IEEE 802.1Qbv (later merged in 802.1Q).  This qdisc has
> > a software implementation and an optional offload through which
> > compatible Ethernet ports may configure their egress 802.1Qbv
> > schedulers.
> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  include/net/dsa.h |  3 +++
> >  net/dsa/slave.c   | 14 ++++++++++++++
> >  2 files changed, 17 insertions(+)
> >
> > diff --git a/include/net/dsa.h b/include/net/dsa.h
> > index 1e8650fa8acc..e7ee6ac8ce6b 100644
> > --- a/include/net/dsa.h
> > +++ b/include/net/dsa.h
> > @@ -152,6 +152,7 @@ struct dsa_mall_tc_entry {
> >       };
> >  };
> >
> > +struct tc_taprio_qopt_offload;
> >
> >  struct dsa_port {
> >       /* A CPU port is physically connected to a master device.
> > @@ -516,6 +517,8 @@ struct dsa_switch_ops {
> >                                  bool ingress);
> >       void    (*port_mirror_del)(struct dsa_switch *ds, int port,
> >                                  struct dsa_mall_mirror_tc_entry *mirror);
> > +     int     (*port_setup_taprio)(struct dsa_switch *ds, int port,
> > +                                  struct tc_taprio_qopt_offload *qopt);
>
> Is there any way to make this more generic? 802.1Qbv are not the only hardware
> schedulers. CBS and ETF are examples that first come to mind. Maybe having
> something more generic than tc_taprio_qopt_offload as an option could host
> future schedulers?
>

Good point. I'll see what I can do to make DSA more qdisc-agnostic
when I gather enough feedback to mandate a v2.

> >
> >       /*
> >        * Cross-chip operations
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 99673f6b07f6..2bae33788708 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -965,12 +965,26 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
> >       }
> >  }
> >
> > +static int dsa_slave_setup_tc_taprio(struct net_device *dev,
> > +                                  struct tc_taprio_qopt_offload *f)
> > +{
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     struct dsa_switch *ds = dp->ds;
> > +
> > +     if (!ds->ops->port_setup_taprio)
> > +             return -EOPNOTSUPP;
> > +
> > +     return ds->ops->port_setup_taprio(ds, dp->index, f);
> > +}
> > +
> >  static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
> >                             void *type_data)
> >  {
> >       switch (type) {
> >       case TC_SETUP_BLOCK:
> >               return dsa_slave_setup_tc_block(dev, type_data);
> > +     case TC_SETUP_QDISC_TAPRIO:
> > +             return dsa_slave_setup_tc_taprio(dev, type_data);
> >       default:
> >               return -EOPNOTSUPP;
> >       }
> > --
> > 2.17.1
> >
> Thanks
> /Ilias

Thanks,
-Vladimir
