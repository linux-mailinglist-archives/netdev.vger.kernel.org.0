Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48681954AD
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 11:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0KAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 06:00:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44104 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgC0KAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 06:00:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id i16so9378338edy.11
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 03:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jAel3J0RK+nVzQL5+BbyTkLxt0qa1UNMPLWPhOjb0g8=;
        b=dfTcnMRKiSOaAT7LBCcrT5STnuVaMP3KyEw9ETXPq8x9Y6JQLArR3Bq7llqzgTRQB6
         2SH5LCproaUZMkIwCbrDGPp4OXtmm8QpriywCcBn2B2H/ZNt/yP8Mq4yJJyfAVAaDSyZ
         yi43hiNEvjllvjNtIY4Ug4Sf6ApeM8XlFX9H2Pqk5XhmyoHo3rxvHmRMhozqff9xMLXB
         GOtpSckmSu+kNWET1wY72VYGSQtuN9QgBwku0GZs2EovEJ/Ts8dwY1cBvqF7fJG9NMPg
         8/i3CiTK7UGQca1E4fgUhGvVGtnSCC13JL1b3xbdwJuicEv3PmN6j4vMMD9Ie6sMFaky
         XSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jAel3J0RK+nVzQL5+BbyTkLxt0qa1UNMPLWPhOjb0g8=;
        b=M07Q+upmKMHPcR4IDsn1pvNMInN6ajAYjoJY1IXwLdSHV8eBCNJIVMVD13yW6he+ro
         ExNVH+s8oK6vUzRqt5vwdf5dcANVN7MOFRXMKO9niG2jveZ1Z3VjgveVZFspIF+lAMnW
         FTGfDG0AVMSgd23CENveT1Tulpyh4/KGiDk2uldXUiC6eFXPKt61uyc4JeXWDKLYR6vZ
         EWWmszWAOR6fTg/HRZQFN1l7W822Ec9Lim8GaPDdJ1GhY3b6QocPaD+ivB5d9fp79Bbm
         dH7MQKHGeekjUM7wIA3F8jUSr8EV2e+8HD9TNDRIKNEzwSq9+lJR/z+hWe5w9Lx7cFuR
         AKGQ==
X-Gm-Message-State: ANhLgQ0p8gK05403mKuYrKUoQNqwckrBXvWFqF8YY5yYzWFjQLLiqu1R
        VT9WFgepi1DiLKDthkhv84bp4hFLvu7q+xtf5c8=
X-Google-Smtp-Source: ADFU+vtYuesJvbwyZLwTyPYLoXz7ahw8sTSScBsmugeLRA4QX2O4MyUsGDIdkFMLtyQ5Mt86CbBHIawAha/+4O4/EqQ=
X-Received: by 2002:aa7:d602:: with SMTP id c2mr12757106edr.118.1585303212097;
 Fri, 27 Mar 2020 03:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200326224040.32014-1-olteanv@gmail.com> <20200326224040.32014-4-olteanv@gmail.com>
 <20200327000625.GJ3819@lunn.ch>
In-Reply-To: <20200327000625.GJ3819@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 27 Mar 2020 12:00:01 +0200
Message-ID: <CA+h21ho_Q-3eUGNk_zH76nE-+hPu4AW68uu4Kd6XNSWL20izUg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/8] net: dsa: configure the MTU for switch ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 at 02:06, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > -static void dsa_master_set_mtu(struct net_device *dev, struct dsa_port *cpu_dp)
> > -{
> > -     unsigned int mtu = ETH_DATA_LEN + cpu_dp->tag_ops->overhead;
> > -     int err;
> > -
> > -     rtnl_lock();
> > -     if (mtu <= dev->max_mtu) {
> > -             err = dev_set_mtu(dev, mtu);
> > -             if (err)
> > -                     netdev_dbg(dev, "Unable to set MTU to include for DSA overheads\n");
> > -     }
> > -     rtnl_unlock();
> > -}
> > -
> >  static void dsa_master_reset_mtu(struct net_device *dev)
> >  {
> >       int err;
> > @@ -344,7 +330,14 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
> >  {
> >       int ret;
> >
> > -     dsa_master_set_mtu(dev,  cpu_dp);
> > +     rtnl_lock();
> > +     ret = dev_set_mtu(dev, ETH_DATA_LEN + cpu_dp->tag_ops->overhead);
> > +     rtnl_unlock();
> > +     if (ret) {
> > +             netdev_err(dev, "error %d setting MTU to include DSA overhead\n",
> > +                        ret);
> > +             return ret;
> > +     }
>
> I suspect this will break devices. dsa_master_set_mtu() was not fatal
> if it failed. I did this deliberately because i suspect there are some
> MAC drivers which are unhappy to have the MTU changed, but will still
> send and receive frames which are bigger than the MTU.
>
> So please keep setting the MTU of ETH_DATA_LEN +
> cpu_dp->tag_ops->overhead or less as non-fatal. Jumbo frame sizes you
> should however check the return code.
>

Ok, I'll leave it non-fatal here.

> > @@ -1465,7 +1556,10 @@ int dsa_slave_create(struct dsa_port *port)
> >       slave_dev->priv_flags |= IFF_NO_QUEUE;
> >       slave_dev->netdev_ops = &dsa_slave_netdev_ops;
> >       slave_dev->min_mtu = 0;
> > -     slave_dev->max_mtu = ETH_MAX_MTU;
> > +     if (ds->ops->port_max_mtu)
> > +             slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
> > +     else
> > +             slave_dev->max_mtu = ETH_MAX_MTU;
>
> Does this bring you anything. You have a lot more checks you perform
> when performing the actual change. Seems better to keep them all
> together.
>

This here is for cooperating with dev_validate_mtu() so I can get this
nice message:

ip link set dev sw0p1 mtu 2400
Error: mtu greater than device maximum.

>         Andrew

Thanks,
-Vladimir
