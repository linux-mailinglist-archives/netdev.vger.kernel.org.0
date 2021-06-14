Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E03A6993
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhFNPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 11:07:37 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:41891 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhFNPHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:07:33 -0400
Received: by mail-ed1-f54.google.com with SMTP id g18so44970731edq.8;
        Mon, 14 Jun 2021 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gKOqFyi4Kfd36nKwUO//09yp/Fk/9vPvsaRoEvmhhEw=;
        b=YGqkqsr7KhcdZj9qKkcEDepxpSMy/3yWai0cAk3yDde0be9PQj04rQf/a3INGwYEai
         Ygqeo5gaf6lQku45u80xltUtahGhhgjiin/svVZfJEi2WfF3Tg4n57bQGYb+uUOgVEeT
         FGaexQeqy1CWSVk7c/UM9wOSAT3eMeH3thofGgthHa0wmuV60LcyyAH1p1TTASb6kPYv
         VUAd7Vn6oENLipOseM8oLplTVZYRVky/meSbESDxDFpQWs333dZ3ioe7vG1Pcl5p8KQB
         IKkX68uUQhaYVFu055a8GjUX2Ja1yDgKJJ96PKW+8NZjqwjejBmwkLj30hotGc8coJFG
         8sXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gKOqFyi4Kfd36nKwUO//09yp/Fk/9vPvsaRoEvmhhEw=;
        b=iX8YKSmG7yJ13G/1B6u4WRNXLvzsSE4oPXEr+LZCbxPK1SPEUbwdZ0JBLhSplrk3wE
         PEIXJCoIExC1HT9dExcLAB5gUz2J93xNdcSx6R5AttCwIgDy3K9K3TJsPI8MHs/emvk8
         SCgNU5LD/vI3TBp38548ksWC/+7dU62f/8Y4fV4v5ELRJQ1AwLV2hlaiGFnq3vKpzgiD
         VlZyhCw96lmhnO/eW3RF/e+oXC0VnwtZlXFCdbAZO2uHsK0lhANpNFi5YuapTC0tJA9p
         o8plxPop9YZCpi5M9ltTbskgGm2QBksCjBA23ikLih41pAVu+9GDR4131HngLI+w5t8s
         39KQ==
X-Gm-Message-State: AOAM531REm1VJcByUpiGoZpz29ukGTDbCbiRkFiWjDV3EHAY/+ZcrGa8
        eNWelTIR8sBO00u4KE8wUlFJ//a3D0CsO6bVNp4=
X-Google-Smtp-Source: ABdhPJzdQ6lrhG9gpBqbvd6q0ekw1bd9mvfGMN3acxnq3U50/r85H2JU/wbAkH9ghaZDAN4S9pOU2P4lgeipIHQ0aVE=
X-Received: by 2002:a05:6402:22f9:: with SMTP id dn25mr17519671edb.241.1623683069887;
 Mon, 14 Jun 2021 08:04:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
 <20210614163401.52807197@gmail.com> <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
 <20210614172512.799db10d@gmail.com> <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
 <20210614174727.6a38b584@gmail.com>
In-Reply-To: <20210614174727.6a38b584@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 14 Jun 2021 23:04:03 +0800
Message-ID: <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
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

On Mon, Jun 14, 2021 at 10:47 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 14 Jun 2021 22:40:55 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> > <paskripkin@gmail.com> wrote:
> > >
> > > On Mon, 14 Jun 2021 22:19:10 +0800
> > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > > <paskripkin@gmail.com> wrote:
> > > > >
> > > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > >
> > > > > > Dear kernel developers,
> > > > > >
> > > > > > I was trying to debug the crash - memory leak in
> > > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > > disgusting issue: my breakpoint and printk/pr_alert in the
> > > > > > functions that will be surely executed do not work. The stack
> > > > > > trace is in the following. I wrote this email to ask for some
> > > > > > suggestions on how to debug such cases?
> > > > > >
> > > > > > Thanks very much. Looking forward to your reply.
> > > > > >
> > > > >
> > > > > Hi, Dongliang!
> > > > >
> > > > > This bug is not similar to others on the dashboard. I spent some
> > > > > time debugging it a week ago. The main problem here, that memory
> > > > > allocation happens in the boot time:
> > > > >
> > > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
> > > > >
> > > >
> > > > Oh, nice catch. No wonder why my debugging does not work. :(
> > > >
> > > > > and reproducer simply tries to
> > > > > free this data. You can use ftrace to look at it. Smth like
> > > > > this:
> > > > >
> > > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > > >
> > > > Thanks for your suggestion.
> > > >
> > > > Do you have any conclusions about this case? If you have found
> > > > out the root cause and start writing patches, I will turn my
> > > > focus to other cases.
> > >
> > > No, I had some busy days and I have nothing about this bug for now.
> > > I've just traced the reproducer execution and that's all :)
> > >
> > > I guess, some error handling paths are broken, but Im not sure
> >
> > In the beginning, I agreed with you. However, after I manually checked
> > functions: hwsim_probe (initialization) and  hwsim_remove (cleanup),
> > then things may be different. The cleanup looks correct to me. I would
> > like to debug but stuck with the debugging process.
> >
> > And there is another issue: the cleanup function also does not output
> > anything or hit the breakpoint. I don't quite understand it since the
> > cleanup is not at the boot time.
> >
> > Any idea?
> >
>
> Output from ftrace (syzkaller repro):
>
> root@syzkaller:~# cat /sys/kernel/tracing/trace
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  1)               |  hwsim_del_radio_nl() {
>  1)               |    hwsim_del() {
>  1)               |      hwsim_edge_unsubscribe_me() {
>  1) ! 310.041 us  |        hwsim_free_edge();
>  1) ! 665.221 us  |      }
>  1) * 52999.05 us |    }
>  1) * 53035.38 us |  }
>
> Cleanup function is not the case, I think :)

It seems like I spot the incorrect cleanup function (hwsim_remove is
the right one is in my mind). Let me learn how to use ftrace to log
the executed functions and then discuss this case with you guys.

>
>
>
> With regards,
> Pavel Skripkin
