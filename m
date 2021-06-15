Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C973A8041
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFONhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbhFONhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:37:10 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70131C0617AF;
        Tue, 15 Jun 2021 06:35:04 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id z22so25018450ljh.8;
        Tue, 15 Jun 2021 06:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ulugoPBBhevnhzCJrZTOMqZJ5udLj5TuytaXQ7l1OPU=;
        b=UN4iupDt5jMBARHlso8hJRoIVE544OZRG/IYugMd531Z11jTaGHkVslOzOz/KRUlTY
         QUpEKvqdvOo5/c089oT8EmS+MOJN6igxkpN2SJGsacoQ1ay1CSXZJpICibmVs0su/oCH
         ximNqHVKIxJXlEzQk5LpgZfNB9M4tueIa/Iw6jDdntCPUkjVZMnrRnjxU6xJEMbO8AA5
         e02xkHT/FPy4t7D5dXuGkrH26Jy5KFAf8MdbTbDmlKzT0zikvoRC1Quk4Yk8Fo0I7qVC
         GbSXAhmKz/a7bVzndN3G6nZPa9E6lTvnS7/S0xI8f0o2qqQJVr+CYcQS8gqm9S5AtjHA
         034A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ulugoPBBhevnhzCJrZTOMqZJ5udLj5TuytaXQ7l1OPU=;
        b=um4yjucVfndQwxg5QRyqmYwo6rFHDJEWQDJ3/s2VDQB+HJuEDLALftsJCoEyHqJkLb
         ogMmPsPFgvNw5CvdUWp6LGA0N88XWgbqxa1Rl5mmAHCSbl/UcEdW1QZipYmcpL9vjP7S
         CJbRMKWGsGdNorscSxmfOlVlZgiHCALEhS/fX3i3Vq0Lah/OC3UJh7t+GmAhwoGk7fy/
         khcZ+W0BgBjBJ40DH4HHG8BxbBEBi20pGXdVobJSG+stUwWz9o2atnidTVMr4ynj7hvd
         1cssAM9uaIsNxylckzhbEl6cixTk4A04x4eA3ZPYDlUBb+tVGs8uwmgFb2UoZfwmpFNX
         ut1A==
X-Gm-Message-State: AOAM532g62hbthYjPh2QVL7mm+j+llZ/iKawQPCTudSmQVIg9adBBgae
        h6OS2qEBLlwL651DVqOhAiA=
X-Google-Smtp-Source: ABdhPJwZe8zjLBh+yPjTAzvAwcOZMQCA3qdou21RN9fcK3aikcFx3JkTA3O5nOvkpYpmz3uVEsO7Lw==
X-Received: by 2002:a2e:2e0d:: with SMTP id u13mr18575422lju.351.1623764102697;
        Tue, 15 Jun 2021 06:35:02 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id v10sm1810605lfg.224.2021.06.15.06.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 06:35:02 -0700 (PDT)
Date:   Tue, 15 Jun 2021 16:34:58 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Suggestions on how to debug kernel crashes where printk and gdb
 both does not work
Message-ID: <20210615163458.0cc5c524@gmail.com>
In-Reply-To: <CAD-N9QWj7LpdJvDy7r2+WCeFKw2P7DFos=88186-h3GFZPKAvw@mail.gmail.com>
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
        <20210614163401.52807197@gmail.com>
        <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
        <20210614172512.799db10d@gmail.com>
        <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
        <20210614174727.6a38b584@gmail.com>
        <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
        <20210614233011.79ebe38a@gmail.com>
        <CAD-N9QWj7LpdJvDy7r2+WCeFKw2P7DFos=88186-h3GFZPKAvw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 18:37:14 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Tue, Jun 15, 2021 at 4:30 AM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > On Mon, 14 Jun 2021 23:04:03 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > On Mon, Jun 14, 2021 at 10:47 PM Pavel Skripkin
> > > <paskripkin@gmail.com> wrote:
> > > >
> > > > On Mon, 14 Jun 2021 22:40:55 +0800
> > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > > On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> > > > > <paskripkin@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, 14 Jun 2021 22:19:10 +0800
> > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > >
> > > > > > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > > > > > <paskripkin@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > > > >
> > > > > > > > > Dear kernel developers,
> > > > > > > > >
> > > > > > > > > I was trying to debug the crash - memory leak in
> > > > > > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > > > > > disgusting issue: my breakpoint and printk/pr_alert
> > > > > > > > > in the functions that will be surely executed do not
> > > > > > > > > work. The stack trace is in the following. I wrote
> > > > > > > > > this email to ask for some suggestions on how to
> > > > > > > > > debug such cases?
> > > > > > > > >
> > > > > > > > > Thanks very much. Looking forward to your reply.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Hi, Dongliang!
> > > > > > > >
> > > > > > > > This bug is not similar to others on the dashboard. I
> > > > > > > > spent some time debugging it a week ago. The main
> > > > > > > > problem here, that memory allocation happens in the
> > > > > > > > boot time:
> > > > > > > >
> > > > > > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7
> > > > > > > > > init/main.c:1447
> > > > > > > >
> > > > > > >
> > > > > > > Oh, nice catch. No wonder why my debugging does not work.
> > > > > > > :(
> > > > > > >
> > > > > > > > and reproducer simply tries to
> > > > > > > > free this data. You can use ftrace to look at it. Smth
> > > > > > > > like this:
> > > > > > > >
> > > > > > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > > > > > >
> > > > > > > Thanks for your suggestion.
> > > > > > >
> > > > > > > Do you have any conclusions about this case? If you have
> > > > > > > found out the root cause and start writing patches, I
> > > > > > > will turn my focus to other cases.
> > > > > >
> > > > > > No, I had some busy days and I have nothing about this bug
> > > > > > for now. I've just traced the reproducer execution and
> > > > > > that's all :)
> > > > > >
> > > > > > I guess, some error handling paths are broken, but Im not
> > > > > > sure
> > > > >
> > > > > In the beginning, I agreed with you. However, after I manually
> > > > > checked functions: hwsim_probe (initialization) and
> > > > > hwsim_remove (cleanup), then things may be different. The
> > > > > cleanup looks correct to me. I would like to debug but stuck
> > > > > with the debugging process.
> > > > >
> > > > > And there is another issue: the cleanup function also does not
> > > > > output anything or hit the breakpoint. I don't quite
> > > > > understand it since the cleanup is not at the boot time.
> > > > >
> > > > > Any idea?
> > > > >
> > > >
> > > > Output from ftrace (syzkaller repro):
> > > >
> > > > root@syzkaller:~# cat /sys/kernel/tracing/trace
> > > > # tracer: function_graph
> > > > #
> > > > # CPU  DURATION                  FUNCTION CALLS
> > > > # |     |   |                     |   |   |   |
> > > >  1)               |  hwsim_del_radio_nl() {
> > > >  1)               |    hwsim_del() {
> > > >  1)               |      hwsim_edge_unsubscribe_me() {
> > > >  1) ! 310.041 us  |        hwsim_free_edge();
> > > >  1) ! 665.221 us  |      }
> > > >  1) * 52999.05 us |    }
> > > >  1) * 53035.38 us |  }
> > > >
> > > > Cleanup function is not the case, I think :)
> > >
> > > It seems like I spot the incorrect cleanup function (hwsim_remove
> > > is the right one is in my mind). Let me learn how to use ftrace
> > > to log the executed functions and then discuss this case with you
> > > guys.
> > >
> >
> > Hmmm, I think, there is a mess with lists.
> >
> > I just want to share my debug results, I have no idea about the fix
> > for now.
> >
> > In hwsim_probe() edge for phy->idx = 1 is allocated, then reproduces
> > sends a request to delete phy with idx == 0, so this check in
> > hwsim_edge_unsubscribe_me():
> >
> >         if (e->endpoint->idx == phy->idx) {
> >                 ... clean up code ...
> >         }
> >
> > won't be passed and edge won't be freed (because it was allocated
> > for phy with idx == 1). Allocated edge for phy 1 becomes leaked
> > after hwsim_del(). I can't really see the code where phy with idx
> > == 1 can be deleted from list...
> 
> Thanks for sharing your debugging result.
> 
>               hwsim_phys
>                        |
>    ---------------------------------
>    |                                      |
> sub0 (edges)                 sub1 (edges)
>    ----> e (idx = 1)               ----> e (idx = 0)
> 
> hwsim_del_radio_nl will call hwsim_del to delete phy (idx:1).
> However, in this function, it only deletes the e in the edge list of
> sub1. Then it deletes phy (i.e., sub0) from the hwsim_phys list. So it
> leaves the e in the edge list of sub0 non-free.
> 
> I proposed a patch and test it successfully in the syzbot dashboard.
> 

Cool! I thougth about similar fix before going to bed, but I had really
busy morning today :)

> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c
> b/drivers/net/ieee802154/mac802154_hwsim.c
> index da9135231c07..b05159cff33a 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -824,9 +824,16 @@ static int hwsim_add_one(struct genl_info *info,
> struct device *dev,
>  static void hwsim_del(struct hwsim_phy *phy)
>  {
>   struct hwsim_pib *pib;
> + struct hwsim_edge *e;
> 
>   hwsim_edge_unsubscribe_me(phy);
> 
> + // remove the edges in the list
> + list_for_each_entry_rcu(e, &phy->edges, list) {
> + list_del_rcu(&e->list);
> + hwsim_free_edge(e);
> + }
> +

I think, rcu_read_lock() and rcu_read_unlock() are needed here (like in
hwsim_edge_unsubscribe_me()). Or you can delete this edges after deleting
phy node from global list, then, i guess, rcu locking won't be needed
here.

>   list_del(&phy->list);
> 
>   rcu_read_lock();
> 
>  I will send a patch later.
> 
> 
> >
> > Maybe, it's kmemleak bug. Similar strange case was with this one
> > https://syzkaller.appspot.com/bug?id=3a325b8389fc41c1bc94de0f4ac437ed13cce584.
> > I find it strange, that I could reach leaked pointers after
> > kmemleak reported a leak. Im not familiar with kmemleak internals
> > and I might be wrong
> >
> >
> > With regards,
> > Pavel Skripkin




With regards,
Pavel Skripkin
