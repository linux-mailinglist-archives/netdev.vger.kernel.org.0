Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC51FFD06
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgFRVAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgFRVAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:00:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91E8C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:00:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id a13so7342852ilh.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAbaBBlgo2E41ap4KFAOnToVzorD8tzflU17/nIx9wY=;
        b=E6+I0h/1ElPHBnZtlpB6xuKsRhj5eVQ43uwTfPEo51g0H6VifWYbIH1XzaiyDHfAH8
         RKyZVibIbjLmMpuIfmzqr26khjXQWpbyvDe4FwiGdaydCAZTqU/tHrBQV8QLFY2Pk2pl
         bqz0tCxg1sDBqHmFePllvknOsNxUYz7ds9Tsyk9CyRbSZjXWHbsEPRxOP9SqD4pcMGcj
         WZ3XT+DOlmB1VstlWJIujmCGZDEzKBpUQeAYyJDAy85rfREHJlZGynu3wYeWcXVBTW+g
         wKcYB52hROB3YiJ2QnEtHSx4DKInGq1QTz0DbgfWpW80VbicIkDt4oFG2KDf9Q9Z5RSV
         tG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MAbaBBlgo2E41ap4KFAOnToVzorD8tzflU17/nIx9wY=;
        b=TH9w/bDbEESSEPLbik0bVZ3bAzGAhckIsbscMiJ6WPb+Yfmjhwh5ww70GebX+epmRq
         JwrYmj/4Wolh+BLzJ9xtoXM0lQE8PEGdG0tswqsHviqCSmuEZjtnnlyIRRxHSym81JtE
         QsmrhIyYneBFVzudRWH35JzZCKexarMP8CiqGo53/2UO9eIprA7xMixdGn6VbEEC6SST
         UPf/jlAGtzlaJtIPQUdU5IeN8xc/SID1ni9o8EH4b8hwCS60XVAL8ceUMIugXNrQRYfz
         +BX+gR98+IpirH5PIsA65sym4a/9dtivxGQBZH8j2fCTQIw+pja23h2bV8yhq4QfLNMH
         RBmg==
X-Gm-Message-State: AOAM533MCK7NpwIn1U7vDKi6sGxblElxWMCihIb7B8iizA4XXGLty8in
        L9U8AjrPzOIvNqULVh3QxLbYyGhq6nMzfLIhv6oGTpDN
X-Google-Smtp-Source: ABdhPJyfQiohovxep2iZiwO1yd24RyWtRVoxzeLYubb2KnSzGO+Yl58P0B0tyHTwbeEA/xDmjMHOu1dolL86G7M2hcE=
X-Received: by 2002:a92:d905:: with SMTP id s5mr402361iln.268.1592514005150;
 Thu, 18 Jun 2020 14:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com>
 <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com> <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
In-Reply-To: <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 13:59:53 -0700
Message-ID: <CAM_iQpUn85pDjURnn8QtN2Wk2U=zb2C8M7H6Gm=5j=L0cg0VZg@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 1:33 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, 18 Jun 2020 at 23:06, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 12:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > It's me with the stacked DSA devices again:
> > >
> > > It looks like DSA never uses netdev API to link master
> > > device with slave devices? If so, their dev->lower_level
> > > are always 1, therefore triggers this warning.
> > >
> > > I think it should call one of these netdev_upper_dev_link()
> > > API's when creating a slave device.
> > >
> >
> > I don't know whether DSA is too special to use the API, but
> > something like this should work:
> >
> > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > index 4c7f086a047b..f7a2a281e7f0 100644
> > --- a/net/dsa/slave.c
> > +++ b/net/dsa/slave.c
> > @@ -1807,6 +1807,11 @@ int dsa_slave_create(struct dsa_port *port)
> >                            ret, slave_dev->name);
> >                 goto out_phy;
> >         }
> > +       ret = netdev_upper_dev_link(slave_dev, master, NULL);
> > +       if (ret) {
> > +               unregister_netdevice(slave_dev);
> > +               goto out_phy;
> > +       }
> >
> >         return 0;
> >
> > @@ -1832,6 +1837,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
> >         netif_carrier_off(slave_dev);
> >         rtnl_lock();
> >         phylink_disconnect_phy(dp->pl);
> > +       netdev_upper_dev_unlink(slave_dev, dp->master);
> >         rtnl_unlock();
> >
> >         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);
>
> Thanks. This is a good approximation of what needed to be done:
> - netdev_upper_dev_link needs to be under rtnl,
> - "dp->master" should be "dsa_slave_to_master(slave_dev)" since it's
> actually a union if you look at struct dsa_port).
> - And, most importantly, I think the hierarchy should be reversed: a
> (virtual) DSA switch port net device (slave) should be an upper of the
> (real) DSA master (the host port). Think of it like this: a DSA switch
> is a sort of port multiplier for a host port, based on a frame header.
> But, it works!

Please feel free to make any changes you need and submit it
by yourself, as you know DSA better than me and I do not even
have a DSA testing environment.

>
> Do you mind if I submit your modified patch to "net"? What would be an
> adequate Fixes: tag?

If it is merely to fix the lockdep warning, my commit 845e0ebb4408d447
is the right one to blame.

Thanks.
