Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6CC3A7C1E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhFOKjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhFOKjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:39:47 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE2C061574;
        Tue, 15 Jun 2021 03:37:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce15so21705923ejb.4;
        Tue, 15 Jun 2021 03:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtrZlwOnKCiqTIsZyr9FcNUuCAAc8LVqPYmpZpunwBw=;
        b=sX/IKWWvBf7AJJgA801akMh10X6iRWyD4L4o2OhN3TDt0C155Zy2zLDzAogwg2Th2R
         FwZxMFoipKiLX0Aag8R9UtLARg/mp1xBS3Ly9RzC/DCbbWdr5wuQ5N4R+yAU62yViWzT
         gBzgIK0AKCKkWjcTsX1MPATcGpY6xSk7our/IYz2SJDi/pAkJzibdnOS5m2GIf5j6bSE
         QvUUo177tLuZBsufdLYeHqn/mtr00P/CI1whPol0ml+BV5s9rKwPbrAe1FXCl8eor12Q
         9fB/VxOvlLWBG46Tkp0lNJuGW6o+k+cMY8UOmX6etz2eUq09n6S/Zzs+Tli5cPmttAOA
         6QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MtrZlwOnKCiqTIsZyr9FcNUuCAAc8LVqPYmpZpunwBw=;
        b=Ib0+JtrNEZ16IHN6Dr/d+FBaAxRy29JReLc/0t/gg7D5WELAyHdRCtlHUHuoN/ktPR
         6B59ysoiRMzYy2712YgUsZOlv3JY0KPBSJElTZ5sSSQF3Q9kQuFPaeta5DW3w2tIW/9f
         uBNDa6yrRqf0FIXwAjQN+gFLiLqWQ7CZFQ833n98dvT6r8nVJxlk7NKAsZo2Qc40YKPj
         kc1GocHXtI9SYa7traI7GAWi/WVYRjdoH7RGDCJ/kICK4yRov6fIFZUttPhqJzxrzlHG
         PWhEs9iXz+5l2ITp3k50CwRdsHpYf0Sw7OyKoG4rt570CctFbrAK8aZaar/eCLJrJywo
         ReQg==
X-Gm-Message-State: AOAM531KPjIKzwYMTzCJKWdjp5WEW3nk7Q06ga81v9NIetZhJLxHT+sx
        6CER7Rfgig8huzm9S7UerwozTyIeOtEGAoZfzYU=
X-Google-Smtp-Source: ABdhPJz7lnbIX2lahXzVLoe09HL55d69W8pMSWjbbe0rh+PguNFz7IkFzdIbTH5JBTGQEDu6oEaWFf5u6V4iu/GygDM=
X-Received: by 2002:a17:906:4f10:: with SMTP id t16mr19512291eju.337.1623753461201;
 Tue, 15 Jun 2021 03:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
 <20210614163401.52807197@gmail.com> <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
 <20210614172512.799db10d@gmail.com> <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
 <20210614174727.6a38b584@gmail.com> <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
 <20210614233011.79ebe38a@gmail.com>
In-Reply-To: <20210614233011.79ebe38a@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 18:37:14 +0800
Message-ID: <CAD-N9QWj7LpdJvDy7r2+WCeFKw2P7DFos=88186-h3GFZPKAvw@mail.gmail.com>
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

On Tue, Jun 15, 2021 at 4:30 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 14 Jun 2021 23:04:03 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > On Mon, Jun 14, 2021 at 10:47 PM Pavel Skripkin
> > <paskripkin@gmail.com> wrote:
> > >
> > > On Mon, 14 Jun 2021 22:40:55 +0800
> > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > > On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> > > > <paskripkin@gmail.com> wrote:
> > > > >
> > > > > On Mon, 14 Jun 2021 22:19:10 +0800
> > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > >
> > > > > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > > > > <paskripkin@gmail.com> wrote:
> > > > > > >
> > > > > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > > >
> > > > > > > > Dear kernel developers,
> > > > > > > >
> > > > > > > > I was trying to debug the crash - memory leak in
> > > > > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > > > > disgusting issue: my breakpoint and printk/pr_alert in the
> > > > > > > > functions that will be surely executed do not work. The
> > > > > > > > stack trace is in the following. I wrote this email to
> > > > > > > > ask for some suggestions on how to debug such cases?
> > > > > > > >
> > > > > > > > Thanks very much. Looking forward to your reply.
> > > > > > > >
> > > > > > >
> > > > > > > Hi, Dongliang!
> > > > > > >
> > > > > > > This bug is not similar to others on the dashboard. I spent
> > > > > > > some time debugging it a week ago. The main problem here,
> > > > > > > that memory allocation happens in the boot time:
> > > > > > >
> > > > > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7
> > > > > > > > init/main.c:1447
> > > > > > >
> > > > > >
> > > > > > Oh, nice catch. No wonder why my debugging does not work. :(
> > > > > >
> > > > > > > and reproducer simply tries to
> > > > > > > free this data. You can use ftrace to look at it. Smth like
> > > > > > > this:
> > > > > > >
> > > > > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > > > > >
> > > > > > Thanks for your suggestion.
> > > > > >
> > > > > > Do you have any conclusions about this case? If you have found
> > > > > > out the root cause and start writing patches, I will turn my
> > > > > > focus to other cases.
> > > > >
> > > > > No, I had some busy days and I have nothing about this bug for
> > > > > now. I've just traced the reproducer execution and that's all :)
> > > > >
> > > > > I guess, some error handling paths are broken, but Im not sure
> > > >
> > > > In the beginning, I agreed with you. However, after I manually
> > > > checked functions: hwsim_probe (initialization) and  hwsim_remove
> > > > (cleanup), then things may be different. The cleanup looks
> > > > correct to me. I would like to debug but stuck with the debugging
> > > > process.
> > > >
> > > > And there is another issue: the cleanup function also does not
> > > > output anything or hit the breakpoint. I don't quite understand
> > > > it since the cleanup is not at the boot time.
> > > >
> > > > Any idea?
> > > >
> > >
> > > Output from ftrace (syzkaller repro):
> > >
> > > root@syzkaller:~# cat /sys/kernel/tracing/trace
> > > # tracer: function_graph
> > > #
> > > # CPU  DURATION                  FUNCTION CALLS
> > > # |     |   |                     |   |   |   |
> > >  1)               |  hwsim_del_radio_nl() {
> > >  1)               |    hwsim_del() {
> > >  1)               |      hwsim_edge_unsubscribe_me() {
> > >  1) ! 310.041 us  |        hwsim_free_edge();
> > >  1) ! 665.221 us  |      }
> > >  1) * 52999.05 us |    }
> > >  1) * 53035.38 us |  }
> > >
> > > Cleanup function is not the case, I think :)
> >
> > It seems like I spot the incorrect cleanup function (hwsim_remove is
> > the right one is in my mind). Let me learn how to use ftrace to log
> > the executed functions and then discuss this case with you guys.
> >
>
> Hmmm, I think, there is a mess with lists.
>
> I just want to share my debug results, I have no idea about the fix for
> now.
>
> In hwsim_probe() edge for phy->idx = 1 is allocated, then reproduces
> sends a request to delete phy with idx == 0, so this check in
> hwsim_edge_unsubscribe_me():
>
>         if (e->endpoint->idx == phy->idx) {
>                 ... clean up code ...
>         }
>
> won't be passed and edge won't be freed (because it was allocated for
> phy with idx == 1). Allocated edge for phy 1 becomes leaked after
> hwsim_del(). I can't really see the code where phy with idx == 1 can
> be deleted from list...

Thanks for sharing your debugging result.

              hwsim_phys
                       |
   ---------------------------------
   |                                      |
sub0 (edges)                 sub1 (edges)
   ----> e (idx = 1)               ----> e (idx = 0)

hwsim_del_radio_nl will call hwsim_del to delete phy (idx:1).
However, in this function, it only deletes the e in the edge list of sub1.
Then it deletes phy (i.e., sub0) from the hwsim_phys list. So it
leaves the e in the edge list of sub0 non-free.

I proposed a patch and test it successfully in the syzbot dashboard.

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c
b/drivers/net/ieee802154/mac802154_hwsim.c
index da9135231c07..b05159cff33a 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -824,9 +824,16 @@ static int hwsim_add_one(struct genl_info *info,
struct device *dev,
 static void hwsim_del(struct hwsim_phy *phy)
 {
  struct hwsim_pib *pib;
+ struct hwsim_edge *e;

  hwsim_edge_unsubscribe_me(phy);

+ // remove the edges in the list
+ list_for_each_entry_rcu(e, &phy->edges, list) {
+ list_del_rcu(&e->list);
+ hwsim_free_edge(e);
+ }
+
  list_del(&phy->list);

  rcu_read_lock();

 I will send a patch later.


>
> Maybe, it's kmemleak bug. Similar strange case was with this one
> https://syzkaller.appspot.com/bug?id=3a325b8389fc41c1bc94de0f4ac437ed13cce584.
> I find it strange, that I could reach leaked pointers after kmemleak reported a
> leak. Im not familiar with kmemleak internals and I might be wrong
>
>
> With regards,
> Pavel Skripkin
