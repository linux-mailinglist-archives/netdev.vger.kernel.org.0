Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE098812A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436619AbfHIR3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:29:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44525 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436582AbfHIR3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 13:29:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so46185549pgl.11;
        Fri, 09 Aug 2019 10:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FUrszxfu12TYz4RSVAJdRYMRyY1/E4H2D0WlNLvKSkU=;
        b=kdszIFnCo6sZZCcRhyiqMMSZhlU8v9rxWv4gClrYhWcMSOFFyiNSwbUzdaAjCk0RGj
         jpZpkE50HqF55Vq3vd/tqgnYNVGXou0jM7Vw3SyRlfYcGheZBxa6TJuvs9P+k2xOzRxf
         ohVGmJ5t0+s6BU+tYqq/KEXmo9Tj3otw8BO8XS0cRmrarLZyZgTjQEcqOJMAw3z4FZiu
         mn6glH3aeIXR3mpcuOPegWlySanHChSNkE4WM/wJWZ6k0Hwins7b/RjM9rQWkCoZeL8u
         P0raqZHkk8UlURJTbOPbIzpoB2KMoTyigkkjH6MeGiz0NeoiTpWiCPYe3yK5BQgX41Dh
         g+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FUrszxfu12TYz4RSVAJdRYMRyY1/E4H2D0WlNLvKSkU=;
        b=fvhxnTgpZ4QuYqLmkbMTGKRmzrvO1u1OowfZUepou7ZKVMqpqmqHV4mdPfp5fHEI71
         ePxXG8FdIGuRhfzZWTogTNWcbEg0E25ZtTf38IkLwUnh9c2u/XFQZ2f2PPdY7N+il2pg
         wTfC7zR7f+1vcdnmxNKUPAQZcudNQMl8/dinup7N4CxB3qcUOpMl3U0wBVR1aWhqLjQ/
         4RE8Xulm0RRPsmxQqAiKSbLWt7hc6099YoiVyuC3MQxVteQqeX3sbsdL7F701KwhB/tK
         bHds+yS65yTkMX6O1ZFbQPLNT+AU1I4kjFTarGoVxGSvb6wG3kz4t1sZMEIx5GSygnJM
         wM1Q==
X-Gm-Message-State: APjAAAW2rWT6YEdXjd/P8HAyX0q5o/sRU8qCf9i+Q3yiaRspkgUN/RCZ
        tPgrJkXmQZhJt4gjsLB8u+QyH84S55Dhv94C4iw=
X-Google-Smtp-Source: APXvYqxBYUW+814s+7lrviU0TmD+7hu5PuAQYHJhVfj/j8HK6bW+t1XT1YwWM5b+aguA27df/H70hLt2izbcuuCAT+0=
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr10416653pjr.50.1565371751473;
 Fri, 09 Aug 2019 10:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a244b3058f9dc7d6@google.com> <4616850c-bf9e-d32a-3cfb-dbbaec5e17f2@I-love.SAKURA.ne.jp>
 <CACT4Y+Y7d29kA1fpS13QvSopknuChPANRc9evxeWiJd-zkyNug@mail.gmail.com>
In-Reply-To: <CACT4Y+Y7d29kA1fpS13QvSopknuChPANRc9evxeWiJd-zkyNug@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 9 Aug 2019 10:29:00 -0700
Message-ID: <CAM_iQpVUZGrz_w2Mv1YzCZaOpi9WdhJAZm_=ZkWRame=6odoog@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tomoyo_socket_sendmsg_permission
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+b91501546ab4037f685f@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-hams <linux-hams@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 1:53 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Fri, Aug 9, 2019 at 12:08 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >
> > On 2019/08/09 1:45, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    107e47cc vrf: make sure skb->data contains ip header to ma..
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=139506d8600000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4dba67bf8b8c9ad7
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=b91501546ab4037f685f
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > This is not TOMOYO's bug. LSM modules expect that "struct sock" does not go away.
> >
> > Also, another use-after-free (presumably on the same "struct sock") was concurrently
> > inflight at nr_insert_socket() in net/netrom/af_netrom.c . Thus, suspecting netrom's bug.
>
> There is a number of UAFs/refcount bugs in nr sockets lately. Most
> likely it's the same issue them. Most of them were bisected to:
>
> commit c8c8218ec5af5d2598381883acbefbf604e56b5e
> Date: Thu Jun 27 21:30:58 2019 +0000
>   netrom: fix a memory leak in nr_rx_frame()

The UAF introduced by this commit has been fixed. There is
another UAF in netrom which exists long before the above commit,
it is not fixed. The last time I looked at it, it seems related to the
state machine used by netrom sockets, so it is not easy.

Thanks,
