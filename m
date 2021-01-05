Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDE22EB656
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbhAEXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbhAEXhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:37:19 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874CCC061793
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 15:36:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id r4so583429pls.11
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 15:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OscJM8Ne0lsjnE8WMZEkgwYXERgfwuv1hElV1hBbLL4=;
        b=OfKcSy1aKqQpK9spG5P6b8ktSWpqfuBmMLbavQLaGGGVjhcaKdiCQXXIGkdvMXneXk
         99G+uNGv7dP0TY06KhxneDTCwxhjcLoDHIcL59v0XWFQVwFk2AyNSZGmEIgvDMOxA6kH
         Gc5gwMAL/dU4H+mflIK9VsFkYG5jQUYPbtm0Tt6Sd9U824l+D/Z5wPSl+bS8NpT75tk/
         siTD8NAR+xr5ALjbf9B10nGRkTY4M09e1ecNgDOSyMRyHvju9qC6EqWTQrjWF5Fvz9dE
         VH9il+ZzxzMeUcmPL8M7ImvTlo5NeDNa5U/YXgA3b43Z5C59rs3bkESmnBMHssqSGMhM
         rQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OscJM8Ne0lsjnE8WMZEkgwYXERgfwuv1hElV1hBbLL4=;
        b=KXD8dV1RzpG0D1GorRgwxIuC7cpUaXC8cmb2k3KejxeNF5qfUYhsnWj88THup0S6pj
         hy/e1GzohEB18e7RxcppiXwOyiKAwMrB3OzeeryZ8lMqGK9IkmUa8k03NN5996ZqdUJ6
         wTXrJBpLZ4dpECyUSONZg4UKWfCtFvmMrsWGFsCcieNMzGAfJpdnCftV8YL6m8wc6gOx
         hWkqwo6FkRzml4wsAhC3/ecT4lhuM6g6p3ivjjnVviXYwSkumCYQzxiRhrDB7GKhZJ+R
         zVTNmxC9HmScV1eO8oFDwdUeO7Q08M5nHd9U+Zmt1J4oyYvOark4BuyNupiLsUYW9sIR
         Fc1A==
X-Gm-Message-State: AOAM531p9us81yierJmX+630KrXGK5EPViOqKCOIKFo8hsTZQlClIhUA
        g2PhJwkEaQkyNaCEZOOZ2kY/w6nIYiy+YM9zRASjs6lSFuw=
X-Google-Smtp-Source: ABdhPJy/iHCEed7nhUbjtBXbTGMoFKuUreSj7/QeYna20632QJTGd2xI7zZ4ud9nlAgGpwGPf1dxqNCQ63Wq8pf04g4=
X-Received: by 2002:a17:90a:6705:: with SMTP id n5mr1441342pjj.215.1609889799089;
 Tue, 05 Jan 2021 15:36:39 -0800 (PST)
MIME-Version: 1.0
References: <20210105190725.1736246-1-kuba@kernel.org> <CAM_iQpVMBjoSFH34cunM+e+E6Qu+eWVfoduo5LvyupRHq1OG1w@mail.gmail.com>
 <20210105143912.34e71377@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210105143912.34e71377@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 Jan 2021 15:36:27 -0800
Message-ID: <CAM_iQpVk7ek8RbWX0df3ghoYxf4dC1Ezbcy=7hfR8WaS3fjzYg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: bareudp: add missing error handling for bareudp_link_config()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 2:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 5 Jan 2021 12:38:54 -0800 Cong Wang wrote:
> > On Tue, Jan 5, 2021 at 11:07 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > +static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> > > +{
> > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > +
> > > +       list_del(&bareudp->next);
> > > +       unregister_netdevice_queue(dev, head);
> > > +}
> > > +
> > >  static int bareudp_newlink(struct net *net, struct net_device *dev,
> > >                            struct nlattr *tb[], struct nlattr *data[],
> > >                            struct netlink_ext_ack *extack)
> > >  {
> > >         struct bareudp_conf conf;
> > > +       LIST_HEAD(list_kill);
> > >         int err;
> > >
> > >         err = bareudp2info(data, &conf, extack);
> > > @@ -662,17 +671,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
> > >
> > >         err = bareudp_link_config(dev, tb);
> > >         if (err)
> > > -               return err;
> > > +               goto err_unconfig;
> > >
> > >         return 0;
> > > -}
> > > -
> > > -static void bareudp_dellink(struct net_device *dev, struct list_head *head)
> > > -{
> > > -       struct bareudp_dev *bareudp = netdev_priv(dev);
> > >
> > > -       list_del(&bareudp->next);
> > > -       unregister_netdevice_queue(dev, head);
> > > +err_unconfig:
> > > +       bareudp_dellink(dev, &list_kill);
> > > +       unregister_netdevice_many(&list_kill);
> >
> > Why do we need unregister_netdevice_many() here? I think
> > bareudp_dellink(dev, NULL) is sufficient as we always have
> > one instance to unregister?
> >
> > (For the same reason, bareudp_dev_create() does not need it
> > either.)
>
> Ack, I'm following how bareudp_dev_create() is written.
>
> I can follow up in net-next and change both, sounds good?

Yes, either way is fine.

Thanks.
