Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9193A706C
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFNUcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbhFNUcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 16:32:21 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C5CC061574;
        Mon, 14 Jun 2021 13:30:16 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id c11so21906496ljd.6;
        Mon, 14 Jun 2021 13:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/hnnncj7vzT6xrqQOtqK95hj1J3zQcIX0GD5ENHwYGs=;
        b=Sf/C6jQAejQ7QgbqyKgzN5j9RKIEIYJ5qRCASL/CGyadtbYOldpIm39EE+PC/IKXuf
         P8tJ6EJIryYoPG1+Fy2KA1D+ZHhcsLap7Y8VKeDn1AnPFqUxZ+rNJ4xuw8fmFAzS0n7F
         DbJG3wesc2UbKZsKsj+rHOO9uXSbn86OdUlQalg6+3hnLjAJ/AhVrRQjFzYaXK+ynlfZ
         IwG6Lx/G3uFxuU+hEOIPhrvgt/LS6Bg1CNUWUv3FIcqdaSjwP8Aim+e1DsTbUoskgPFH
         07q4i7KlMmaO5Q4Z4XqSLYnOmdSguEV8WZjDyE3riaIy+dUZzZ6zOsOy/NnRPDA1TL14
         TEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hnnncj7vzT6xrqQOtqK95hj1J3zQcIX0GD5ENHwYGs=;
        b=TaZwYsptwrnXkdtpktSroOvEm+uT1+8XrfqQuL5Nmwk3+iToA6UsxnNUySDmNxtw68
         aWDE/8tt5H5kOKtrPcdiiMrtkZFglPtXq9y4rXYhbMSuhpQOlonGZM1/LyDHxoyp+u87
         Z/Ym+S+/LxDY3WdjRk1U7lixWHB+wB1SgibXHuTq4jQsup3DvOQR0GMue8uGCYvSMIYs
         MLPSSYY8gHG9hdG0oWq9JmlT+WCAsY5OBYdkpywhN/5bM07ji+++K8Sv1yL0hsuDOO0V
         0FdghefG/ct1VtFsUqgpiSyUtbOgN7nWrFHE7jUn8w08TP1qc1SvqO4FaoUg7S1J1Ngn
         leiA==
X-Gm-Message-State: AOAM531lu4WKRlrtEvnVdxQmxEXB5cgoy8bPud54jCSuH83HFfopfyQU
        ddhAiXX/cVV5FgKLNLr9hkM=
X-Google-Smtp-Source: ABdhPJwIAkPoePHhzl7KL6lSn4/Ac+1NH4oqgxaj2w/nYPwdN8ocoZPG8abc63Nw9LkwP5vtZ0O+8w==
X-Received: by 2002:a2e:9959:: with SMTP id r25mr14631258ljj.317.1623702614608;
        Mon, 14 Jun 2021 13:30:14 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id d4sm1574079lfk.295.2021.06.14.13.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 13:30:14 -0700 (PDT)
Date:   Mon, 14 Jun 2021 23:30:11 +0300
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
Message-ID: <20210614233011.79ebe38a@gmail.com>
In-Reply-To: <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
        <20210614163401.52807197@gmail.com>
        <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
        <20210614172512.799db10d@gmail.com>
        <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
        <20210614174727.6a38b584@gmail.com>
        <CAD-N9QXUrv7zjSyUjsJsWO6KZDhGYtkTCK9U_ZuPA7awJ8P3Yw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 23:04:03 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Mon, Jun 14, 2021 at 10:47 PM Pavel Skripkin
> <paskripkin@gmail.com> wrote:
> >
> > On Mon, 14 Jun 2021 22:40:55 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> > > <paskripkin@gmail.com> wrote:
> > > >
> > > > On Mon, 14 Jun 2021 22:19:10 +0800
> > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > > > <paskripkin@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > > > >
> > > > > > > Dear kernel developers,
> > > > > > >
> > > > > > > I was trying to debug the crash - memory leak in
> > > > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > > > disgusting issue: my breakpoint and printk/pr_alert in the
> > > > > > > functions that will be surely executed do not work. The
> > > > > > > stack trace is in the following. I wrote this email to
> > > > > > > ask for some suggestions on how to debug such cases?
> > > > > > >
> > > > > > > Thanks very much. Looking forward to your reply.
> > > > > > >
> > > > > >
> > > > > > Hi, Dongliang!
> > > > > >
> > > > > > This bug is not similar to others on the dashboard. I spent
> > > > > > some time debugging it a week ago. The main problem here,
> > > > > > that memory allocation happens in the boot time:
> > > > > >
> > > > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7
> > > > > > > init/main.c:1447
> > > > > >
> > > > >
> > > > > Oh, nice catch. No wonder why my debugging does not work. :(
> > > > >
> > > > > > and reproducer simply tries to
> > > > > > free this data. You can use ftrace to look at it. Smth like
> > > > > > this:
> > > > > >
> > > > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > > > >
> > > > > Thanks for your suggestion.
> > > > >
> > > > > Do you have any conclusions about this case? If you have found
> > > > > out the root cause and start writing patches, I will turn my
> > > > > focus to other cases.
> > > >
> > > > No, I had some busy days and I have nothing about this bug for
> > > > now. I've just traced the reproducer execution and that's all :)
> > > >
> > > > I guess, some error handling paths are broken, but Im not sure
> > >
> > > In the beginning, I agreed with you. However, after I manually
> > > checked functions: hwsim_probe (initialization) and  hwsim_remove
> > > (cleanup), then things may be different. The cleanup looks
> > > correct to me. I would like to debug but stuck with the debugging
> > > process.
> > >
> > > And there is another issue: the cleanup function also does not
> > > output anything or hit the breakpoint. I don't quite understand
> > > it since the cleanup is not at the boot time.
> > >
> > > Any idea?
> > >
> >
> > Output from ftrace (syzkaller repro):
> >
> > root@syzkaller:~# cat /sys/kernel/tracing/trace
> > # tracer: function_graph
> > #
> > # CPU  DURATION                  FUNCTION CALLS
> > # |     |   |                     |   |   |   |
> >  1)               |  hwsim_del_radio_nl() {
> >  1)               |    hwsim_del() {
> >  1)               |      hwsim_edge_unsubscribe_me() {
> >  1) ! 310.041 us  |        hwsim_free_edge();
> >  1) ! 665.221 us  |      }
> >  1) * 52999.05 us |    }
> >  1) * 53035.38 us |  }
> >
> > Cleanup function is not the case, I think :)
> 
> It seems like I spot the incorrect cleanup function (hwsim_remove is
> the right one is in my mind). Let me learn how to use ftrace to log
> the executed functions and then discuss this case with you guys.
> 

Hmmm, I think, there is a mess with lists.

I just want to share my debug results, I have no idea about the fix for
now.

In hwsim_probe() edge for phy->idx = 1 is allocated, then reproduces
sends a request to delete phy with idx == 0, so this check in
hwsim_edge_unsubscribe_me():

	if (e->endpoint->idx == phy->idx) { 
		... clean up code ...
	}

won't be passed and edge won't be freed (because it was allocated for
phy with idx == 1). Allocated edge for phy 1 becomes leaked after
hwsim_del(). I can't really see the code where phy with idx == 1 can
be deleted from list...

Maybe, it's kmemleak bug. Similar strange case was with this one
https://syzkaller.appspot.com/bug?id=3a325b8389fc41c1bc94de0f4ac437ed13cce584.
I find it strange, that I could reach leaked pointers after kmemleak reported a
leak. Im not familiar with kmemleak internals and I might be wrong 


With regards,
Pavel Skripkin
