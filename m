Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F223A8EBC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhFPCNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhFPCNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:13:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE92C061574;
        Tue, 15 Jun 2021 19:11:35 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id nb6so986134ejc.10;
        Tue, 15 Jun 2021 19:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9fhT/YkW6rQCPQGnGw7DPEHUEt4MLs6RS0h8P2hM2M=;
        b=ZpdeQ2WXWkNudf1zCpE4L/Auk1c09CHHFa7SQzgJMGjCVu909Nw55uTONRG0k4yBrl
         vOjOvABkgbeTV1bILfmqYBycgOXBi3R2v1ZQTx/wM2JXBRFvoQ4BSyqVQga1h3eEFQNr
         XJTFY6WQSELcRtBnykCASw73vMJ7VJOG5m+VRIaXU6Gtf2XReenXzcOfHMusqkVC6Q/P
         xUhOMIe5lnar/DKy4i25GMvPiFWcY3Py23H+qhXO2YmOBwRu5112UXfTuwCPYc5DscDx
         xz6lO2Qpi/TGjT2Cl77J/VX2EaHJYJn8NW2TgOhlpWOmsNmcBzYkdDBnpdu0AidvTmUk
         QSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9fhT/YkW6rQCPQGnGw7DPEHUEt4MLs6RS0h8P2hM2M=;
        b=J4m+Awtpxs1eutpS/Dhfs4Mb+JTwAo0TRQCXVIa4xisEPwK1idRIzIY04XpXc5P58y
         LKLpC5oa2r+i66OwRyHDPQCRxy+i721nMumUUa+pOvnouFdHs0e9QoD5OXwcL0jiMTe/
         +4pp9Dg745f8AmOTOispIihJ7En538e2YJsYz6OmfdLhS0j9QXybpNP1QDZ6esgx+0zG
         h1+UunAgdGgI3gjDxJaKC+bIIlKl93BNHM2/FvOcFoa+mvET2+JDUJtLHlfSq3beY2si
         xp8EXCkMgMXB1CUvDhRjrWTY+AwWvtIIMNplVU+6iwMcJCYtOCWzZCqWW0M/1ZwoMr2L
         WPjQ==
X-Gm-Message-State: AOAM5337muC/q3xPaeIr25UHFqyW62cOrNG6sSxOOg4+C8uaBT18cqKt
        L7YKYsU/fhVyc+tZJQGIjskSdqdlqJ7Kp4JqEps=
X-Google-Smtp-Source: ABdhPJwggG3nFq4+0stP6AqeRuprsFYRdutuakA/StgzFseby6MHXwDWW25sly6daYfYPReHQgdq5Vo8lODnDq7/tWs=
X-Received: by 2002:a17:906:3c44:: with SMTP id i4mr2576340ejg.135.1623809494314;
 Tue, 15 Jun 2021 19:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
 <20210614163401.52807197@gmail.com> <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
 <20210614172512.799db10d@gmail.com> <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
 <20210614174727.6a38b584@gmail.com> <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
 <20210614233011.79ebe38a@gmail.com> <CAD-N9QWj7LpdJvDy7r2+WCeFKw2P7DFos=88186-h3GFZPKAvw@mail.gmail.com>
 <20210615163458.0cc5c524@gmail.com> <CAD-N9QV7o_gQtH4tCCDGheFjtx_7xBh7hgtyfbZo71FebUuUrA@mail.gmail.com>
In-Reply-To: <CAD-N9QV7o_gQtH4tCCDGheFjtx_7xBh7hgtyfbZo71FebUuUrA@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 16 Jun 2021 10:11:08 +0800
Message-ID: <CAD-N9QWH5ewqQrmo-h5Em9W=+kDB4JO0x==vE=hOH9f4MhQbJg@mail.gmail.com>
Subject: Re: Suggestions on how to debug kernel crashes where printk and gdb
 both does not work
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:02 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Tue, Jun 15, 2021 at 9:35 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
> >
> > On Tue, 15 Jun 2021 18:37:14 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > On Tue, Jun 15, 2021 at 4:30 AM Pavel Skripkin <paskripkin@gmail.com>
> > > wrote:
> > > >
> > > > On Mon, 14 Jun 2021 23:04:03 +0800
> > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > > On Mon, Jun 14, 2021 at 10:47 PM Pavel Skripkin
> > > > > <paskripkin@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, 14 Jun 2021 22:40:55 +0800
> > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > >
> > > > > > > On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> > > > > > > <paskripkin@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, 14 Jun 2021 22:19:10 +0800
> > > > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > > > >
> > > > > > > > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > > > > > > > <paskripkin@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > > > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > > Dear kernel developers,
> > > > > > > > > > >
> > > > > > > > > > > I was trying to debug the crash - memory leak in
> > > > > > > > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > > > > > > > disgusting issue: my breakpoint and printk/pr_alert
> > > > > > > > > > > in the functions that will be surely executed do not
> > > > > > > > > > > work. The stack trace is in the following. I wrote
> > > > > > > > > > > this email to ask for some suggestions on how to
> > > > > > > > > > > debug such cases?
> > > > > > > > > > >
> > > > > > > > > > > Thanks very much. Looking forward to your reply.
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Hi, Dongliang!
> > > > > > > > > >
> > > > > > > > > > This bug is not similar to others on the dashboard. I
> > > > > > > > > > spent some time debugging it a week ago. The main
> > > > > > > > > > problem here, that memory allocation happens in the
> > > > > > > > > > boot time:
> > > > > > > > > >
> > > > > > > > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7
> > > > > > > > > > > init/main.c:1447
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Oh, nice catch. No wonder why my debugging does not work.
> > > > > > > > > :(
> > > > > > > > >
> > > > > > > > > > and reproducer simply tries to
> > > > > > > > > > free this data. You can use ftrace to look at it. Smth
> > > > > > > > > > like this:
> > > > > > > > > >
> > > > > > > > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > > > > > > > >
> > > > > > > > > Thanks for your suggestion.
> > > > > > > > >
> > > > > > > > > Do you have any conclusions about this case? If you have
> > > > > > > > > found out the root cause and start writing patches, I
> > > > > > > > > will turn my focus to other cases.
> > > > > > > >
> > > > > > > > No, I had some busy days and I have nothing about this bug
> > > > > > > > for now. I've just traced the reproducer execution and
> > > > > > > > that's all :)
> > > > > > > >
> > > > > > > > I guess, some error handling paths are broken, but Im not
> > > > > > > > sure
> > > > > > >
> > > > > > > In the beginning, I agreed with you. However, after I manually
> > > > > > > checked functions: hwsim_probe (initialization) and
> > > > > > > hwsim_remove (cleanup), then things may be different. The
> > > > > > > cleanup looks correct to me. I would like to debug but stuck
> > > > > > > with the debugging process.
> > > > > > >
> > > > > > > And there is another issue: the cleanup function also does not
> > > > > > > output anything or hit the breakpoint. I don't quite
> > > > > > > understand it since the cleanup is not at the boot time.
> > > > > > >
> > > > > > > Any idea?
> > > > > > >
> > > > > >
> > > > > > Output from ftrace (syzkaller repro):
> > > > > >
> > > > > > root@syzkaller:~# cat /sys/kernel/tracing/trace
> > > > > > # tracer: function_graph
> > > > > > #
> > > > > > # CPU  DURATION                  FUNCTION CALLS
> > > > > > # |     |   |                     |   |   |   |
> > > > > >  1)               |  hwsim_del_radio_nl() {
> > > > > >  1)               |    hwsim_del() {
> > > > > >  1)               |      hwsim_edge_unsubscribe_me() {
> > > > > >  1) ! 310.041 us  |        hwsim_free_edge();
> > > > > >  1) ! 665.221 us  |      }
> > > > > >  1) * 52999.05 us |    }
> > > > > >  1) * 53035.38 us |  }
> > > > > >
> > > > > > Cleanup function is not the case, I think :)
> > > > >
> > > > > It seems like I spot the incorrect cleanup function (hwsim_remove
> > > > > is the right one is in my mind). Let me learn how to use ftrace
> > > > > to log the executed functions and then discuss this case with you
> > > > > guys.
> > > > >
> > > >
> > > > Hmmm, I think, there is a mess with lists.
> > > >
> > > > I just want to share my debug results, I have no idea about the fix
> > > > for now.
> > > >
> > > > In hwsim_probe() edge for phy->idx = 1 is allocated, then reproduces
> > > > sends a request to delete phy with idx == 0, so this check in
> > > > hwsim_edge_unsubscribe_me():
> > > >
> > > >         if (e->endpoint->idx == phy->idx) {
> > > >                 ... clean up code ...
> > > >         }
> > > >
> > > > won't be passed and edge won't be freed (because it was allocated
> > > > for phy with idx == 1). Allocated edge for phy 1 becomes leaked
> > > > after hwsim_del(). I can't really see the code where phy with idx
> > > > == 1 can be deleted from list...
> > >
> > > Thanks for sharing your debugging result.
> > >
> > >               hwsim_phys
> > >                        |
> > >    ---------------------------------
> > >    |                                      |
> > > sub0 (edges)                 sub1 (edges)
> > >    ----> e (idx = 1)               ----> e (idx = 0)
> > >
> > > hwsim_del_radio_nl will call hwsim_del to delete phy (idx:1).
> > > However, in this function, it only deletes the e in the edge list of
> > > sub1. Then it deletes phy (i.e., sub0) from the hwsim_phys list. So it
> > > leaves the e in the edge list of sub0 non-free.
> > >
> > > I proposed a patch and test it successfully in the syzbot dashboard.
> > >
> >
> > Cool! I thougth about similar fix before going to bed, but I had really
> > busy morning today :)
> >
> > > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c
> > > b/drivers/net/ieee802154/mac802154_hwsim.c
> > > index da9135231c07..b05159cff33a 100644
> > > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > > @@ -824,9 +824,16 @@ static int hwsim_add_one(struct genl_info *info,
> > > struct device *dev,
> > >  static void hwsim_del(struct hwsim_phy *phy)
> > >  {
> > >   struct hwsim_pib *pib;
> > > + struct hwsim_edge *e;
> > >
> > >   hwsim_edge_unsubscribe_me(phy);
> > >
> > > + // remove the edges in the list
> > > + list_for_each_entry_rcu(e, &phy->edges, list) {
> > > + list_del_rcu(&e->list);
> > > + hwsim_free_edge(e);
> > > + }
> > > +
> >
> > I think, rcu_read_lock() and rcu_read_unlock() are needed here (like in
> > hwsim_edge_unsubscribe_me()). Or you can delete this edges after deleting
> > phy node from global list, then, i guess, rcu locking won't be needed
> > here.
>
> Yes, you're right. rcu_read_lock is needed here. However, from the
> code below list_del(&phy->list), I think we'd better still add
> rcu_read_lock for those statements.
>
> How do you think about the following patch? BTW, I've sent a patch
> with the prefix PATCH. Maybe we can discuss this patch there.
>
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c
> b/drivers/net/ieee802154/mac802154_hwsim.c
> index da9135231c07..cf659361a3fb 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -824,12 +824,17 @@ static int hwsim_add_one(struct genl_info *info,
> struct device *dev,
>  static void hwsim_del(struct hwsim_phy *phy)
>  {
>         struct hwsim_pib *pib;
> +       struct hwsim_edge *e;
>
>         hwsim_edge_unsubscribe_me(phy);
>
>         list_del(&phy->list);
>
>         rcu_read_lock();
> +       list_for_each_entry_rcu(e, &phy->edges, list) {
> +               list_del_rcu(&e->list);
> +               hwsim_free_edge(e);
> +       }
>         pib = rcu_dereference(phy->pib);
>         rcu_read_unlock();
>

I have sent a v2 patch to the mailing list, please discuss the patch
in the corresponding thread [1].

[1] https://lkml.org/lkml/2021/6/15/1585.

> >
> > >   list_del(&phy->list);
> > >
> > >   rcu_read_lock();
> > >
> > >  I will send a patch later.
> > >
> > >
> > > >
> > > > Maybe, it's kmemleak bug. Similar strange case was with this one
> > > > https://syzkaller.appspot.com/bug?id=3a325b8389fc41c1bc94de0f4ac437ed13cce584.
> > > > I find it strange, that I could reach leaked pointers after
> > > > kmemleak reported a leak. Im not familiar with kmemleak internals
> > > > and I might be wrong
> > > >
> > > >
> > > > With regards,
> > > > Pavel Skripkin
> >
> >
> >
> >
> > With regards,
> > Pavel Skripkin
