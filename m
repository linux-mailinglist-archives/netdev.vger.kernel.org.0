Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701DD1FFC8F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgFRUd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFRUd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:33:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1508EC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:33:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gl26so7804154ejb.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0t6ClrLaG6kAW7SY7B797SNTR5JzBFIXhKtbZ0Ork2k=;
        b=ZcWH9BLf4WPHUbSeaQSf/YAXNdtrsJCCPO0HC8dN3X9ob1ev2T9LeRl6lm/fmGqq6O
         SBQOdI4hm+OxSJEZS9wz2BXBdsUZCMQM8NkcsnwjGCJUjgJ7dccMO8MVdUM42WOVO+ey
         mc3cyX7yJQk+2tHM8WQEeKOTtMkjYTxbQ09pvsnF7WmQsqktpk3YVF1Iy58vS243u5nD
         /2Qw2FBXX2BTeGpBfmAZCe2SEr31pYXZ89u9eisMEXMxv3wQ+yrCGPhRaOGwZZACF/5S
         9h/XZeue2Jjur6kv1GxCjbvGiIseGq2PKBLeEIMfBatsyDla1x4PoNkGQB8HzoGsv4J9
         DZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0t6ClrLaG6kAW7SY7B797SNTR5JzBFIXhKtbZ0Ork2k=;
        b=fWcVy52fY8yBdDHniYM15TuAeCqlQgwhCHzwXWlmCOgyqVNNCIaBv8TAbNibl6j6Dv
         1ZWExC4FR5jZgYItlPes+EHn/ctrCiupj+x9NHjQmUYHbb1O4tuHvwk7GsuSO6a3kgeD
         BWyxRssTQ/xP1UE2suPmkADDZFtT5qXw5XcnbStp26N64RzAp0ptoL2NnP9fLHXaFTsZ
         ziuDMldBnNHdD0psE9ePVb58SEPaJgH1CH43tLCfH4QEVvkDHDmfsGcIhqH5kVkZBRRV
         m+G1o/vYsajD1vQYEEnA0FxjSejA1pH8GTrGpceK1vOuLyPqnjd7c21hZ/bVCeGqdVm/
         /vjw==
X-Gm-Message-State: AOAM531qWTQnH4KT7pxbcrO3WpvonCIWA30XSjdqcZzKBdw0i+ZzPqMV
        psDGkdlZaS8lcdbOa/lvcyUQlbON29xifuKOte4=
X-Google-Smtp-Source: ABdhPJx5kaockE4qKD2PTLxvMunsUCeoEB2ka1yoqoMphEuINgvCY0ny8pabZ2QBF/JOiYsEQ8jZlv1xoJ+8kzsNAd8=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr471895ejh.406.1592512435767;
 Thu, 18 Jun 2020 13:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200608215301.26772-1-xiyou.wangcong@gmail.com>
 <CA+h21hr_epEqWukZMQmZ2ecS9Y0yvX9mzR3g3OA39rg_96FfnQ@mail.gmail.com>
 <CAM_iQpW-5WpaSvSmJgoqEbcjtrjvaZY3ngKzVy2S-v81MdK4iQ@mail.gmail.com> <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
In-Reply-To: <CAM_iQpUBuk1D4JYZtPQ_yodkLJwAyExvGG5vSOazed2QN7NESw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 18 Jun 2020 23:33:44 +0300
Message-ID: <CA+h21hpjsth_1t1ZaBcTd1i3RPXZGqzSyegSSPS2Ns=uq5-HJw@mail.gmail.com>
Subject: Re: [Patch net] net: change addr_list_lock back to static key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot+f3a0e80c34b3fc28ac5e@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 at 23:06, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jun 18, 2020 at 12:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 12:40 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > It's me with the stacked DSA devices again:
> >
> > It looks like DSA never uses netdev API to link master
> > device with slave devices? If so, their dev->lower_level
> > are always 1, therefore triggers this warning.
> >
> > I think it should call one of these netdev_upper_dev_link()
> > API's when creating a slave device.
> >
>
> I don't know whether DSA is too special to use the API, but
> something like this should work:
>
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 4c7f086a047b..f7a2a281e7f0 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1807,6 +1807,11 @@ int dsa_slave_create(struct dsa_port *port)
>                            ret, slave_dev->name);
>                 goto out_phy;
>         }
> +       ret = netdev_upper_dev_link(slave_dev, master, NULL);
> +       if (ret) {
> +               unregister_netdevice(slave_dev);
> +               goto out_phy;
> +       }
>
>         return 0;
>
> @@ -1832,6 +1837,7 @@ void dsa_slave_destroy(struct net_device *slave_dev)
>         netif_carrier_off(slave_dev);
>         rtnl_lock();
>         phylink_disconnect_phy(dp->pl);
> +       netdev_upper_dev_unlink(slave_dev, dp->master);
>         rtnl_unlock();
>
>         dsa_slave_notify(slave_dev, DSA_PORT_UNREGISTER);

Thanks. This is a good approximation of what needed to be done:
- netdev_upper_dev_link needs to be under rtnl,
- "dp->master" should be "dsa_slave_to_master(slave_dev)" since it's
actually a union if you look at struct dsa_port).
- And, most importantly, I think the hierarchy should be reversed: a
(virtual) DSA switch port net device (slave) should be an upper of the
(real) DSA master (the host port). Think of it like this: a DSA switch
is a sort of port multiplier for a host port, based on a frame header.
But, it works!

Do you mind if I submit your modified patch to "net"? What would be an
adequate Fixes: tag?

Cheers,
-Vladimir
