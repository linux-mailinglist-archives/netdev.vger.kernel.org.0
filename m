Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09F3A692E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhFNOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:44:42 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:38598 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbhFNOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:44:41 -0400
Received: by mail-ed1-f41.google.com with SMTP id t7so1629248edd.5;
        Mon, 14 Jun 2021 07:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xeKhQPh1Flb+tUHgI3Evju8LkzF+UVVPLnM1EMj1AbE=;
        b=hnyEavFEYT7mdJN620u6qpcNNOmQT6H8ehoFk5TXIUs2wWzp5y8mxp9Qdiwe3d3J3a
         pp/nEzoWJaRvsT/f9WF/pGE3FgG+bIzvKPNCxBLtddyzxRdjK4wnn4C+h84o1vI3Z9u1
         TmDBrKxIzyCTqejUO2I/jI3WZ6oHcTE8ai83ZnutlGWxYgP16y+zvBn96WFlJCCErKH1
         UqqhhmKLORDiQDkXsGr9gBIlEZcncJIBUj+DxGfZJdyrfLH20FdDuF7LjqVez180top3
         sfwKbax9qxxET/7FQ33K3WkMT9PtHTFHRwmNJQi3NCD2LjH8YMogziFTelHb6TYTTrGN
         wzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xeKhQPh1Flb+tUHgI3Evju8LkzF+UVVPLnM1EMj1AbE=;
        b=tV63JH7VCRQaxzRnOTeDlPpVc4Y06g/yXakxPir57rqu7iz/vleJBF85ZRMOdAiJEs
         PF1695zjoKUTbxoYo/mKA/XKm1cRLA0314IueTNYE4S2b6+yaBJELBnE+QN0yuEKuk5r
         vDOOY40v372KChqZiCrGB8ltAxeP6icplIsOv3yxoZ/RC7ofj9wdjmjQIqD0rk1Mdkwg
         mKkBhWpCe18Dc/YDPC8RlSWHRk2dNLLOxD5kTopXFZRAcoslD2D8kuErzH66Gz1VISpU
         5cch5El/q6UcRw342Ngt2rMW1CsYV8+Sx1ZLLA4VgdxzFRTa0Zflkzdpo5XlGKY3mjEk
         eI2w==
X-Gm-Message-State: AOAM530DdQdGfMi7mNvQSsyB4wY/VwjErjCc8XDuqFlmqof6Lw+zFXcy
        axm8xa4uTCTQ22IpAVNGpds7xocyWiDoKUuk/AU=
X-Google-Smtp-Source: ABdhPJyvn6iYmzaX/eieuNnZhYu4qyZbRg3qRXb0Tqi0Lvnpu1osLzRWrOifWWBX00nFinh7TSC7oRwhdVtpqMYvAvQ=
X-Received: by 2002:aa7:ce86:: with SMTP id y6mr17434142edv.309.1623681690012;
 Mon, 14 Jun 2021 07:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
 <20210614163401.52807197@gmail.com> <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
 <20210614172512.799db10d@gmail.com>
In-Reply-To: <20210614172512.799db10d@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 14 Jun 2021 22:40:55 +0800
Message-ID: <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
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

On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Mon, 14 Jun 2021 22:19:10 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin <paskripkin@gmail.com>
> > wrote:
> > >
> > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > >
> > > > Dear kernel developers,
> > > >
> > > > I was trying to debug the crash - memory leak in hwsim_add_one [1]
> > > > recently. However, I encountered a disgusting issue: my
> > > > breakpoint and printk/pr_alert in the functions that will be
> > > > surely executed do not work. The stack trace is in the following.
> > > > I wrote this email to ask for some suggestions on how to debug
> > > > such cases?
> > > >
> > > > Thanks very much. Looking forward to your reply.
> > > >
> > >
> > > Hi, Dongliang!
> > >
> > > This bug is not similar to others on the dashboard. I spent some
> > > time debugging it a week ago. The main problem here, that memory
> > > allocation happens in the boot time:
> > >
> > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
> > >
> >
> > Oh, nice catch. No wonder why my debugging does not work. :(
> >
> > > and reproducer simply tries to
> > > free this data. You can use ftrace to look at it. Smth like this:
> > >
> > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> >
> > Thanks for your suggestion.
> >
> > Do you have any conclusions about this case? If you have found out the
> > root cause and start writing patches, I will turn my focus to other
> > cases.
>
> No, I had some busy days and I have nothing about this bug for now.
> I've just traced the reproducer execution and that's all :)
>
> I guess, some error handling paths are broken, but Im not sure

In the beginning, I agreed with you. However, after I manually checked
functions: hwsim_probe (initialization) and  hwsim_remove (cleanup),
then things may be different. The cleanup looks correct to me. I would
like to debug but stuck with the debugging process.

And there is another issue: the cleanup function also does not output
anything or hit the breakpoint. I don't quite understand it since the
cleanup is not at the boot time.

Any idea?

>
>
> >
> > BTW, I only found another possible memory leak after some manual code
> > review [1]. However, it is not the root cause for this crash.
> >
> > [1] https://lkml.org/lkml/2021/6/10/1297
> >
> > >
> > > would work.
> > >
> > >
> > > With regards,
> > > Pavel Skripkin
>
>
>
>
> With regards,
> Pavel Skripkin
