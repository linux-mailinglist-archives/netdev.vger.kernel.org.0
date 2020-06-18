Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9911FFE30
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgFRWdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgFRWdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:33:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846C5C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:33:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so8114075eja.7
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CxniwLTDE3n+5gp+EtpDieNbAwNFPQ6+9L09qnZ3lYc=;
        b=HZJInFZWbZ+a8MJWnmMqO90L8XI3mihTxZ6eujhqI4paF8OlUhwDqpMIG/y2ieyqRq
         MvPoOHfoPY54rUfYVxK9SJE9j6gCAByPPrtaDuIi5DDPm9T7R5U96/KZN/YGuJwJuvmx
         Q3EfKxWF1s2ltJ2tXCxBjBVwIJFtX0w+M5VqrS22rvEnr028naBJeaRk3h6E8Bt5ruUl
         +RR2o+a1yltP9k577vAF+23vcqL1ygLCaqwyAQ7Kt+mRdVzdW+ulezRZ3OJjObFSBJeu
         jBZUSzPhJjGH5lV5KHcnamIth2hkRMV3LcevM2oNgy9kjNwHX8E9mnxhXKQkZsdnJMZC
         CZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CxniwLTDE3n+5gp+EtpDieNbAwNFPQ6+9L09qnZ3lYc=;
        b=iCJZu69qpPZ95r/LOEfG3IIuWYuO/nJF2ceI7yQVj+xkXlCsRBYEmsx2zf2VuFgv4K
         /+wjg8qEnfpajv92Y1KYyVo6zIPG6qNcjhTd79yTSn4uLc9nhOGgAt/JR7EdXdGd7Mfw
         locCYzkPz5Eo5mofXL7s6VXEYwbabWmwY2QvJXB5797ah4xRYi0yGa96OQs7ZfLw7b+x
         zHxdnmvNUx9Csn7zXvaEPWmMhA66LpuTc5fQel7xjV242+pCvwNymXC7oxW8rHAizqbJ
         KN/7/4niae7c5T0bBx5AZhMb+LpRIyDl66OhE1WxHiDUuJlrsbeLYyAOBsnE11b7vi43
         5LDA==
X-Gm-Message-State: AOAM530gkOPyWKD2bE6yrgCLzmIONFlbbO8u+pkoI2i5VugwDJrcWh0F
        9+SzcMPQFjgYzB+pzKaeOTT7Dd2fftJxs0byE88=
X-Google-Smtp-Source: ABdhPJzf5ghF9Xsl4/XBmN0mKKBSEHsrxZbk6dT3s9jTP9YOR64B/oS2WvgHHlq/3Cq4thPS1/qcaKOJzcY7VOOufRM=
X-Received: by 2002:a17:906:af84:: with SMTP id mj4mr546819ejb.473.1592519586932;
 Thu, 18 Jun 2020 15:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
 <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
 <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com> <20200618222959.GC279339@lunn.ch>
In-Reply-To: <20200618222959.GC279339@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 19 Jun 2020 01:32:56 +0300
Message-ID: <CA+h21hrZM8Dqi7AYPkKgsAm5-q=TxEdTaci=Tq35VfoOxt_5rw@mail.gmail.com>
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

On Fri, 19 Jun 2020 at 01:30, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Jun 18, 2020 at 11:33:44PM +0300, Vladimir Oltean wrote:
> > On Thu, 18 Jun 2020 at 23:06, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 12:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > It's me with the stacked DSA devices again:
> > > >
> > > > It looks like DSA never uses netdev API to link master
> > > > device with slave devices? If so, their dev->lower_level
> > > > are always 1, therefore triggers this warning.
> > > >
> > > > I think it should call one of these netdev_upper_dev_link()
> > > > API's when creating a slave device.
> > > >
> > >
> > > I don't know whether DSA is too special to use the API, but
> > > something like this should work:
> > >
> > > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > > index 4c7f086a047b..f7a2a281e7f0 100644
> > > --- a/net/dsa/slave.c
> > > +++ b/net/dsa/slave.c
> > > @@ -1807,6 +1807,11 @@ int dsa_slave_create(struct dsa_port *port)
> > >                            ret, slave_dev->name);
> > >                 goto out_phy;
> > >         }
> > > +       ret = netdev_upper_dev_link(slave_dev, master, NULL);
> > > +       if (ret) {
> > > +               unregister_netdevice(slave_dev);
> > > +               goto out_phy;
> > > +       }
> > >
> > >         return 0;
> > >
> > > @@ -1832,6 +1837,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
> > >         netif_carrier_off(slave_dev);
> > >         rtnl_lock();
> > >         phylink_disconnect_phy(dp->pl);
> > > +       netdev_upper_dev_unlink(slave_dev, dp->master);
> > >         rtnl_unlock();
> > >
> > >         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
> >
> > Thanks. This is a good approximation of what needed to be done:
> > - netdev_upper_dev_link needs to be under rtnl,
> > - "dp->master" should be "dsa_slave_to_master(slave_dev)" since it's
> > actually a union if you look at struct dsa_port).
>
> > - And, most importantly, I think the hierarchy should be reversed: a
> > (virtual) DSA switch port net device (slave) should be an upper of the
> > (real) DSA master (the host port). Think of it like this: a DSA switch
> > is a sort of port multiplier for a host port, based on a frame header.
> > But, it works!
>
> Hi Vladimir
>
> So you are suggesting this?
>
> > > +       ret = netdev_upper_dev_link(master, slave_dev, NULL);
>
>   Andrew

Yes, basically this:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4c7f086a047b..6aff8cfc9cf1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1807,6 +1807,13 @@ int dsa_slave_create(struct dsa_port *port)
                           ret, slave_dev->name);
                goto out_phy;
        }
+       rtnl_lock();
+       ret = netdev_upper_dev_link(master, slave_dev, NULL);
+       rtnl_unlock();
+       if (ret) {
+               unregister_netdevice(slave_dev);
+               goto out_phy;
+       }

        return 0;

@@ -1826,12 +1833,14 @@ int dsa_slave_create(struct dsa_port *port)

 void dsa_slave_destroy(struct net_device *slave_dev)
 {
+       struct net_device *master = dsa_slave_to_master(slave_dev);
        struct dsa_port *dp = dsa_slave_to_port(slave_dev);
        struct dsa_slave_priv *p = netdev_priv(slave_dev);

        netif_carrier_off(slave_dev);
        rtnl_lock();
        phylink_disconnect_phy(dp->pl);
+       netdev_upper_dev_unlink(master, slave_dev);
        rtnl_unlock();

        dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);

Do you see a problem with it?

Thanks,
-Vladimir
