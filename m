Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ADC20D760
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732709AbgF2T3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732677AbgF2T1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:27:42 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B3AC02E2FD
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:40:14 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id t7so7714232qvl.8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 07:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ui+xsOPnNPhORkFMFxqPhiEeKw1+pAKs0HxjVIv477I=;
        b=FJHvhOVJA+k+C6imFSZkxIGEnknUJ2Ms9/1buc7HB4IIU47iH6iQ3i9mGhc+WJ1pD2
         PM3uUIG62NEre8aVehpWWmz/xk0ICRkeHWQBFpbkxkGwo6cRPFC94wzXbCt2LE29Aya2
         cB11+1Vn4ydN4+cFc1MYEW3b/VlgtzlvxSewKsz0emG11OcSVjElYijgvg2KSH7huF/U
         3CY2ivFO4hRwxC88CB0DqH7wPBlMAkUlyb234krZG4eQ5WUmrlMWPrpzHhtGw4xOa1IN
         y7ewQwL6J7oe6FP1Xlkpl2wYdmJ5engQobUBxdv8ctwlHK4YXrXh+e6CN5HML1o+cfu9
         Gf4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ui+xsOPnNPhORkFMFxqPhiEeKw1+pAKs0HxjVIv477I=;
        b=TTVIvB+UwSlilefgclMYyvmtmqrebVfJsqihlfaTFzLSdh38rbJespprywllauCG28
         eS5bJD2E2EnzDkoREDyaqIDBYN5fMVpl18Z4A6Bjpzd3165IGLlEkEtYIgxF2ttyLhch
         tzBT97lqSF6n42baPGMkv9ITKAk6fq8nyynGEs392hhJrKez5su98KCmWRWXmaylCQju
         Mi+YG/Blwyl1A4jEf95ZxcsDGl8WMK+BUz//teIAP/3vcfSSfxa2Ajn/DNGkBxnTdBe+
         mkjxrjzEiabB0WagYFGA/Bbox4Iby6OqMxXSGNiLAcXuhAnT3Tojcq92Ap054o+oHlYI
         Bhnw==
X-Gm-Message-State: AOAM5336RFvQWfToZ+Y9scpTaOiBWTh04tstRZRTyXt9JqRaKwt8BI6b
        ZnND9nuYfB4EtvgMFivSvlXvu72ZCqldXlpJMW2c5aIM
X-Google-Smtp-Source: ABdhPJxRQiL83hy7uqEozRtvvMGTMEv5DqIaR/myyuXy+n+i5I7wGYfFbJBT8D7/+iJ+CdwVH6JS3x6peonhiG1diRU=
X-Received: by 2002:a0c:a993:: with SMTP id a19mr15714938qvb.34.1593441613003;
 Mon, 29 Jun 2020 07:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200623095945.1402468-1-Jason@zx2c4.com> <20200623095945.1402468-3-Jason@zx2c4.com>
 <CAHmME9qo6u1rmzgP0HEf2mVj+o4eWpjR+9j709NVhJuMAsb4uQ@mail.gmail.com>
 <CACT4Y+adKydDGcoz3xBb45g_J04kKtQpGRua3k_BvOF=mB4EdQ@mail.gmail.com> <CAHmME9rrpr97mXLoEgk9YvZCfEUeodhCGbbWV1t2+giDBasiKQ@mail.gmail.com>
In-Reply-To: <CAHmME9rrpr97mXLoEgk9YvZCfEUeodhCGbbWV1t2+giDBasiKQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 29 Jun 2020 16:40:01 +0200
Message-ID: <CACT4Y+YDcYqT+xxCe2+v4tqU01qTm5qZ2a=_NjWho6kO2_U7gw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] wireguard: device: avoid circular netns references
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 11:51 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Dmitry,
>
> On Sat, Jun 27, 2020 at 2:59 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > Hard to say. syzkaller frequently needs some time (days) to get
> > reasonable coverage of new code.
> > Is wg_netns_pre_exit executed synchronously in the context of a
> > syscall? If not, then it won't be shown as covered. If yes, then what
> > syscall is it?
>
> Aw, shucks, you're right. I thought that this would be from the
> syscall path for deleting a network namespace via netns_put, but
> sticking a dump_stack() in there, it's clear that namespace cleanup
> actually happens in a worker:
>
> [    0.407072]  wg_netns_pre_exit+0xc/0x98
> [    0.408496]  cleanup_net+0x1bd/0x2f0
> [    0.409844]  process_one_work+0x17f/0x2d0
> [    0.411327]  worker_thread+0x4b/0x3b0
> [    0.412697]  ? rescuer_thread+0x360/0x360
> [    0.414169]  kthread+0x116/0x140
> [    0.415368]  ? __kthread_create_worker+0x110/0x110
> [    0.417125]  ret_from_fork+0x1f/0x30
>
> > This is related to namespaces, right? syzkaller has some descriptions
> > for namespaces:
> > https://github.com/google/syzkaller/blob/master/sys/linux/namespaces.txt
> > But I don't know if it's enough nor I checked if they actually work.
> > We have this laundry list:
> > https://github.com/google/syzkaller/issues/533
> > and some interns working on adding more descriptions. If you can
> > identify something that's not covered but can be covered, please add
> > to that list. I think we can even prioritize it then b/c most items on
> > that list don't have anybody actively interested.
>
> Something to add to that list would be:
>
> - Create an interface of a given type (wg0->wireguard, for example)
> - Move it to a namespace
> - Delete a namespace
> - Delete an interface

What are the kernel interfaces for these? Some syscalls? /dev files?
People working on these will need at least some "entry pointer" to
start exploring involved interfaces.

> Some combination of those things might provoke issues. One would be
> what the original post of this email thread was about. Another would
> be that xfrmi OOPS from a few weeks ago, fixed with c95c5f58b35e
> ("xfrm interface: fix oops when deleting a x-netns interface"), which
> has a reproducer in the commit message pretty similar to the one here.
> There's an even older one in xfrmi, fixed with c5d1030f2300 ("xfrm
> interface: fix list corruption for x-netns").
>
> In short, adding and deleting namespaces and moving interfaces around
> between them, amidst other syzkaller chaos, might turn up bugs,
> because in the past humans have found those sorts of bugs doing the
> same.
>
> Jason
