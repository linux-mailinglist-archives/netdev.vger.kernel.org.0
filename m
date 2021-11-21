Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C26B458429
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238303AbhKUOrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 09:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhKUOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 09:47:09 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C306C061574;
        Sun, 21 Nov 2021 06:44:04 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bu18so68265022lfb.0;
        Sun, 21 Nov 2021 06:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YZOEE5LhWXe1Z1SYNbVR6XoNZt0+dw+XCA0sXOaqVSs=;
        b=D09+2OrdGJqiDZZmf5W0IKXHkAt5dFRnrMyKq2VqyuPsevu/A+Wwz6Qq9zGzZR2HAF
         nOJdXsxaqlnXRpgoAnfG3PfqnPAL+Yp0Rga4Xl4sHtepMzAuJYB1fbnia+gMWtT3uoRI
         yfqjG17T75f8aNaYya4cjvkM0iMKHM9+hCBgjRSOFTNDQGl60Ocl7YgoceQh1E2sVAP3
         ph/5iplRVloKtS6DmDzunFUjOi7toOsmo3oRAa/DPo6rayGk9cC297rMpmBR7DiPn0l1
         T8ZGhUm1OKB734/PWyCcGcLvl0zcy4e9f8qZYFcRRtqeJgjTAKpERmcw2uxoblQ+KHyz
         Z+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YZOEE5LhWXe1Z1SYNbVR6XoNZt0+dw+XCA0sXOaqVSs=;
        b=XmgLSesgjKqF5tAXX4KN1n2LVCrWuhw1/gcGISY36rqnJqF5lg7JwxF5OJ2OZbll5N
         Eymg7JPryE57BICPqxGwgG7bDExIAOaJm7O9jSkvV5YCaa8hmd/LoWlrGboy74uvGmQR
         W+Hwjxa6mb+eGhOC544ySeeaMDVNxTxeb+TNZc640iwsSkqsFHEDKYnwQNig40xWaaat
         iO5gn6TdvTumOh0LwkyUh6A+JT1KgV2x9TJX74qV5qO5cvDWuutaX5S9BKUVhy0b/F9H
         A15u4/7FveiFGswTYkBMpbg1PCUAHYjh1yCYlT1wRmFtVRdXSwl77x7ZzHF7Sgypcy0W
         Uodw==
X-Gm-Message-State: AOAM530HRiG2SNvlJq79B94BbrEEJbAhVNXzc5XjSazg+dtYED6dAKsV
        02N3NESNK9HExDKV0J/J+htCgmmucWDJ4NtxMSE=
X-Google-Smtp-Source: ABdhPJzo6BHQGl600d5/Hs8h6Zss+oCwjjtaSQuwNwaUOO3ywPBM94+90RXhO48qgJONeSaPHvVsK5NYSnzMQcMLMh4=
X-Received: by 2002:ac2:5fca:: with SMTP id q10mr50537321lfg.281.1637505842392;
 Sun, 21 Nov 2021 06:44:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c4e52d05d120e1b0@google.com> <91426976-b784-e480-6e3a-52da5d1268cc@gmail.com>
 <YZpUnR05mK6taHs9@unreal>
In-Reply-To: <YZpUnR05mK6taHs9@unreal>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Sun, 21 Nov 2021 22:43:50 +0800
Message-ID: <CAD=hENf41mpeQGkEx1VFqdPzQOqgL5nZB6s2iFK6tRYsxMs_8g@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in rxe_queue_cleanup
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot <syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 10:16 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sat, Nov 20, 2021 at 06:02:02PM +0300, Pavel Skripkin wrote:
> > On 11/19/21 12:27, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    8d0112ac6fd0 Merge tag 'net-5.16-rc2' of git://git.kernel...
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14e3eeaab00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=aab53008a5adf26abe91
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com
> > >
> > > Free swap  = 0kB
> > > Total swap = 0kB
> > > 2097051 pages RAM
> > > 0 pages HighMem/MovableOnly
> > > 384517 pages reserved
> > > 0 pages cma reserved
> > > ==================================================================
> > > BUG: KASAN: use-after-free in rxe_queue_cleanup+0xf4/0x100 drivers/infiniband/sw/rxe/rxe_queue.c:193
> > > Read of size 8 at addr ffff88814a6b6e90 by task syz-executor.3/9534
> > >
> >
> > On error handling path in rxe_qp_from_init() qp->sq.queue is freed and then
> > rxe_create_qp() will drop last reference to this object. qp clean up
> > function will try to free this queue one time and it causes UAF bug.
> >
> > Just for thoughts.
Agree with you. Thanks a lot.

Zhu Yanjun
>
> You are right, can you please submit patch?
>
> Thanks
>
> >
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c
> > b/drivers/infiniband/sw/rxe/rxe_qp.c
> > index 975321812c87..54b8711321c1 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> > @@ -359,6 +359,7 @@ int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp
> > *qp, struct rxe_pd *pd,
> >
> >  err2:
> >       rxe_queue_cleanup(qp->sq.queue);
> > +     qp->sq.queue = NULL;
> >  err1:
> >       qp->pd = NULL;
> >       qp->rcq = NULL;
> >
> >
> >
> >
> >
> > With regards,
> > Pavel Skripkin
