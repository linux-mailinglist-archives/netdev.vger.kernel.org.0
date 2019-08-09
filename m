Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83A686EEB
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404958AbfHIApX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:45:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39996 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHIApX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:45:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so94176221qtn.7;
        Thu, 08 Aug 2019 17:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YbIEMZbtzCXpq/MNUh4eWzpCyaArIiGShovNn2U+vxo=;
        b=TWTRQBLMTs6ciccZhps1ttQ4fZK9Xg7OiSrrrWfMirmK8xJ1bxCJPHElOVKTZbV9RG
         tBqrG87zGb1uf/pCL70VCfLQUaV9UwEDQzySbKg44Z7P3vA/7dQxpQ10LZ/q4sWzxlwi
         pZxeveZiN9a81X1gWRWphTmCjhVyP6ng0hbBx/JxMfw2wKacH6NVuG4BuGsHNmtOfliw
         yVaAgLeRYgonkZA4hfrwFGL+jVXjGWXhJpBIaJTsu2lzloJmYm4GB0bkxJ+fWK28VZ50
         pTGVkcKndbe6jXzjGwipjRuXIb862pi2AMKyNrwoQbBDuP4lww3krG4YPtjwkj1RkPV5
         woDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YbIEMZbtzCXpq/MNUh4eWzpCyaArIiGShovNn2U+vxo=;
        b=aQZAeiXij5WITWInYo064129NMTHLkJjvjVjkVd6DdZKgK/3EYxNO8Y0sDEzWdgP+Y
         ITW3kkdttwVicIjzUl2trJc7ASGbK0nUmyc/acFfPV3q3ZdWOkdYSCabm0Ad5c1Jz4HZ
         quyvsAqP1TNvpHkq1JcSG6J/1yak3lMW3V24nfBM2Vzf7u3moq4HmQ1FvKY3O3c980Ze
         iFkXeNvfHr/OEvewERL9CAYmn2+ZS1nnGkec7fwXeH4WEJtF41XWdC9wpwJy+3SU+IOd
         BJO6Pha+8pKC2yD9yR7aWdiI5JLIzLfF7Jl1zOYijDMTyoPiDLVgRbPTpXJ/US4w8OE+
         Vndw==
X-Gm-Message-State: APjAAAWFToEWfnbvgUSMk14m/CVtGeIBlVv9yvOpjHockrfcas+KyGeG
        7F0G7DdexIYy6l1IKQa4KTQ=
X-Google-Smtp-Source: APXvYqygRXht2AbFPnYF6rY+qxqh/NxMhl/JPp04DrEq4iH55DI/mUE6Vxr7898TFiPui0U9W9OipQ==
X-Received: by 2002:a0c:e1cd:: with SMTP id v13mr15727930qvl.245.1565311521542;
        Thu, 08 Aug 2019 17:45:21 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.117])
        by smtp.gmail.com with ESMTPSA id w62sm38405674qkd.30.2019.08.08.17.45.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:45:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DF7E2C0ABC; Thu,  8 Aug 2019 21:45:17 -0300 (-03)
Date:   Thu, 8 Aug 2019 21:45:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+13210896153522fe1ee5@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in internal_dev_create
Message-ID: <20190809004517.GD4063@localhost.localdomain>
References: <20190806115932.3044-1-hdanton@sina.com>
 <CAOrHB_BmuAxdch-nbaTS-1eXN-0goUb5UXtYDr==0KeM9vVsRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_BmuAxdch-nbaTS-1eXN-0goUb5UXtYDr==0KeM9vVsRw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 01:32:40PM -0700, Pravin Shelar wrote:
> On Tue, Aug 6, 2019 at 5:00 AM Hillf Danton <hdanton@sina.com> wrote:
> >
> >
> > On Tue, 06 Aug 2019 01:58:05 -0700
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> 
> ...
> > > BUG: memory leak
> > > unreferenced object 0xffff8881228ca500 (size 128):
> > >    comm "syz-executor032", pid 7015, jiffies 4294944622 (age 7.880s)
> > >    hex dump (first 32 bytes):
> > >      00 f0 27 18 81 88 ff ff 80 ac 8c 22 81 88 ff ff  ..'........"....
> > >      40 b7 23 17 81 88 ff ff 00 00 00 00 00 00 00 00  @.#.............
> > >    backtrace:
> > >      [<000000000eb78212>] kmemleak_alloc_recursive  include/linux/kmemleak.h:43 [inline]
> > >      [<000000000eb78212>] slab_post_alloc_hook mm/slab.h:522 [inline]
> > >      [<000000000eb78212>] slab_alloc mm/slab.c:3319 [inline]
> > >      [<000000000eb78212>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
> > >      [<00000000006ea6c6>] kmalloc include/linux/slab.h:552 [inline]
> > >      [<00000000006ea6c6>] kzalloc include/linux/slab.h:748 [inline]
> > >      [<00000000006ea6c6>] ovs_vport_alloc+0x37/0xf0  net/openvswitch/vport.c:130
> > >      [<00000000f9a04a7d>] internal_dev_create+0x24/0x1d0  net/openvswitch/vport-internal_dev.c:164
> > >      [<0000000056ee7c13>] ovs_vport_add+0x81/0x190  net/openvswitch/vport.c:199
> > >      [<000000005434efc7>] new_vport+0x19/0x80 net/openvswitch/datapath.c:194
> > >      [<00000000b7b253f1>] ovs_dp_cmd_new+0x22f/0x410  net/openvswitch/datapath.c:1614
> > >      [<00000000e0988518>] genl_family_rcv_msg+0x2ab/0x5b0  net/netlink/genetlink.c:629
> > >      [<00000000d0cc9347>] genl_rcv_msg+0x54/0x9c net/netlink/genetlink.c:654
> > >      [<000000006694b647>] netlink_rcv_skb+0x61/0x170  net/netlink/af_netlink.c:2477
> > >      [<0000000088381f37>] genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
> > >      [<00000000dad42a47>] netlink_unicast_kernel  net/netlink/af_netlink.c:1302 [inline]
> > >      [<00000000dad42a47>] netlink_unicast+0x1ec/0x2d0  net/netlink/af_netlink.c:1328
> > >      [<0000000067e6b079>] netlink_sendmsg+0x270/0x480  net/netlink/af_netlink.c:1917
> > >      [<00000000aab08a47>] sock_sendmsg_nosec net/socket.c:637 [inline]
> > >      [<00000000aab08a47>] sock_sendmsg+0x54/0x70 net/socket.c:657
> > >      [<000000004cb7c11d>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2311
> > >      [<00000000c4901c63>] __sys_sendmsg+0x80/0xf0 net/socket.c:2356
> > >      [<00000000c10abb2d>] __do_sys_sendmsg net/socket.c:2365 [inline]
> > >      [<00000000c10abb2d>] __se_sys_sendmsg net/socket.c:2363 [inline]
> > >      [<00000000c10abb2d>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2363
> >
> >
> > Always free vport manually unless register_netdevice() succeeds.
> >
> > --- a/net/openvswitch/vport-internal_dev.c
> > +++ b/net/openvswitch/vport-internal_dev.c
> > @@ -137,7 +137,7 @@ static void do_setup(struct net_device *
> >         netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_OPENVSWITCH |
> >                               IFF_NO_QUEUE;
> >         netdev->needs_free_netdev = true;
> > -       netdev->priv_destructor = internal_dev_destructor;
> > +       netdev->priv_destructor = NULL;
> >         netdev->ethtool_ops = &internal_dev_ethtool_ops;
> >         netdev->rtnl_link_ops = &internal_dev_link_ops;
> >
> > @@ -159,7 +159,6 @@ static struct vport *internal_dev_create
> >         struct internal_dev *internal_dev;
> >         struct net_device *dev;
> >         int err;
> > -       bool free_vport = true;
> >
> >         vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
> >         if (IS_ERR(vport)) {
> > @@ -190,10 +189,9 @@ static struct vport *internal_dev_create
> >
> >         rtnl_lock();
> >         err = register_netdevice(vport->dev);
> > -       if (err) {
> > -               free_vport = false;
> > +       if (err)
> >                 goto error_unlock;
> > -       }
> > +       vport->dev->priv_destructor = internal_dev_destructor;
> >
> I am not sure why have you moved this assignment out of do_setup().
> 
> Otherwise patch looks good to me.
> 
> Thanks.

Seems it's to avoid re-introducing the issue that was fixed by:

commit 309b66970ee2abf721ecd0876a48940fa0b99a35
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Sun Jun 9 23:26:21 2019 +0900

    net: openvswitch: do not free vport if register_netdevice() is failed.

A Fixes: 309b66970ee2a  is welcomed then.

> >         dev_set_promiscuity(vport->dev, 1);
> >         rtnl_unlock();
> > @@ -207,8 +205,7 @@ error_unlock:
> >  error_free_netdev:
> >         free_netdev(dev);
> >  error_free_vport:
> > -       if (free_vport)
> > -               ovs_vport_free(vport);
> > +       ovs_vport_free(vport);
> >  error:
> >         return ERR_PTR(err);
> >  }
> > --
> >
> 
