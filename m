Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FFC1FFE5E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgFRWxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgFRWxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:53:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B1EC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:53:50 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id p20so8102294ejd.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kF2zXGy4sl/OrMiMXxLeLz0HYmRcQI6BbIz4IhSDuSg=;
        b=qTrZ3ykCqXXbQHgY1lAaxx5io8bziBXGxKSPlNhL+UO7wtD3bimORiBQFvQ2YXklyI
         0L6nzGzeiJcc7VW5dEktkmgxE2Y7hqmmQWd6okMYCCl2jR7F+zxG8vSGRY4Pfi66gxvC
         ZkuOOjta0+9XmSJnO9KZ/cusqQP3Q+fTQJLrwp2PuzmSKfwYfRbc4wCGYMCeiJ3Prsve
         UxJAJsCOELE5cMxeOzZ+H8ulTJgUAQC2gJ1yVIBiCUOsPOAEEFuXX0IAtdIVpgRxf7ep
         63TMsjkS90YGgl2qSQr7t0y3X6D+FDyNcTSxCiPAncZutRVXLYnt9Dh55tESzT1B0qHj
         N/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kF2zXGy4sl/OrMiMXxLeLz0HYmRcQI6BbIz4IhSDuSg=;
        b=LOry+4iHh4J2ZPKVnVNJWxHpuSiamgTtrzkAKKKSmtxvfA+BozD0/E3kYRk1wSoQxa
         oDYHE9+xKA+LUwY6L+wmNLB/vIQ9qtzoUdLHs+cIfaxg47Ws3vYYHpI1iPGij/Fwt19x
         +dLAZgPiO5NWqpW+FYt8FclbmAhHfsjBa7b7OP55soBQGLtL3OaodRCAm8Bgkv02jfao
         gJwdMYdlZ+0Fw4Ew3Yo+SCdVD72hjzwehDyQhksggkgc/pZArpAnBD7Mo4UhnP9RbIZ1
         P2B/4lDc69XFFURYm42ZCM/SBolnD6CYqKwR/F30MKo7Ai8F9PBQH8Ha+3zhutTGPbVb
         QH1w==
X-Gm-Message-State: AOAM530KQND3ZRoMpGKF2hgDELsHbvz4RE7uzFCYduKzpvsXI5+TmiQi
        JqkFX7pSrjmT6O4IrbzWLQ2Cea2U171owfv8hn4=
X-Google-Smtp-Source: ABdhPJw9OBmdp3NfKo+QO8aQrGKxBEG8+3hePO/+AHgd8maRwUnvF1ch/XCRkjoCWIw+ereLcK9YrU2BAYDd4w57sfg=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr917199ejh.406.1592520829617;
 Thu, 18 Jun 2020 15:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
 <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
 <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
 <20200618222959.GC279339@lunn.ch> <CA+h21hrZM8Dqi7AYPkKgsAm5-q=TxEdTaci=Tq35VfoOxt_5rw@mail.gmail.com>
 <20200618224632.GE279339@lunn.ch>
In-Reply-To: <20200618224632.GE279339@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 19 Jun 2020 01:53:38 +0300
Message-ID: <CA+h21hrZT6u1oy=cW1mcZuU7JFfHtxpzEjrf3CcuXLtzxe0kQw@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jun 2020 at 01:46, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Hi Vladimir
> > >
> > > So you are suggesting this?
> > >
> > > > > +       ret = netdev_upper_dev_link(master, slave_dev, NULL);
> > >
> > >   Andrew
> >
> > Yes, basically this:
> >
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 4c7f086a047b..6aff8cfc9cf1 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1807,6 +1807,13 @@ int dsa_slave_create(struct dsa_port *port)
> >                            ret, slave_dev->name);
> >                 goto out_phy;
> >         }
> > +       rtnl_lock();
> > +       ret = netdev_upper_dev_link(master, slave_dev, NULL);
> > +       rtnl_unlock();
> > +       if (ret) {
> > +               unregister_netdevice(slave_dev);
> > +               goto out_phy;
> > +       }
> >
> >         return 0;
> >
> > @@ -1826,12 +1833,14 @@ int dsa_slave_create(struct dsa_port *port)
> >
> >  void dsa_slave_destroy(struct net_device *slave_dev)
> >  {
> > +       struct net_device *master = dsa_slave_to_master(slave_dev);
> >         struct dsa_port *dp = dsa_slave_to_port(slave_dev);
> >         struct dsa_slave_priv *p = netdev_priv(slave_dev);
> >
> >         netif_carrier_off(slave_dev);
> >         rtnl_lock();
> >         phylink_disconnect_phy(dp->pl);
> > +       netdev_upper_dev_unlink(master, slave_dev);
> >         rtnl_unlock();
> >
> >         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
> >
> > Do you see a problem with it?
>
> I was initially not sure you could do this. But it looks like you can
> have N : M relationships between uppers and lowers. I suppose it does
> make sense. You can have multiple VLAN uppers to one base device. You
> can have multiple lowers to one bond device, etc.
>
> I wonder what 'side effects' there are for declaring this linkage. It
> is not something i've looked into before, since we never used it. So i
> don't see a problem with this, other than i don't know what problems
> we might run into :-)
>
>   Andrew
>

It was surprising to me as well, since I was used to the bridge model
(a port can have only one bridge master). But it looks like, that is
the difference between netdev_upper_dev_link and
netdev_master_upper_dev_link. This uses the former, and the bridge
layer uses the latter.

So I guess it is ok.

Thanks,
-Vladimir
