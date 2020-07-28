Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56823022F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgG1F7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgG1F7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:59:44 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED64C061794;
        Mon, 27 Jul 2020 22:59:44 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id r19so146527qvw.11;
        Mon, 27 Jul 2020 22:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wTdlg95ZXA4TOgFXjgtc+n7E+T+5B9dQx/aSYFnHSfI=;
        b=i8ALjci8bEtI5Kdl1vA8f/CZ8e3VOIZMgU3kxLr1qUQx6fwap0HFd48p/VQgVtNazW
         u7Zk0ZtOuHCJtA3gZzhMEpDdMfPPhwFmNjbSfFgmu7LE3hq1FPvlyqEzh86RBBPZ6ryF
         8FnNOnY6bc37h/U1fgIJXj8RaYJdPz74csFUqBgmgFreU/WUMD3709uchus5jUU1yKJL
         SOQ/djnxHCUowWA1uLApIYJnJ0elXu/iwTZfw5+UlFPD9PYOX6ZNtIfqRktcOcg425Gf
         KvvGX6np7Eu6STOjBJiENi8UV2HMw4ogOS+DarcDUrw7AHKPepO9qE6GvtLtNRHtJNqz
         vQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wTdlg95ZXA4TOgFXjgtc+n7E+T+5B9dQx/aSYFnHSfI=;
        b=RVDe+rdxZhsO3gxrNsEcuQWBpjHZ+YFTGHFQkBhnWQADrCon3/fdMkUI//rd8hYmmD
         8cgHxgL+T5BrbhX074cbhMmk1d+1EpvxeIvV/DYiGbYM9bAQm00ekNYj+jMfHbAgm7Go
         iww6/w1fnck7iISQ/UeNsEBne7QD79pC/2CnFyjhO3liUOQsNIS4YbOKqdZYYonlHTpF
         urQzOLTe2W4y7Zpl3B9HGgV43DfjdpfknSgCvL6ogz+bpGku/rkO+xggOkOypWl0lZLQ
         XlBivuAiFHUXjM6exkWQ6bwvyuKJLJpypxJN8ekB9kmIMTkh+sQeX1OEH6OJin3Uvsyn
         nD0Q==
X-Gm-Message-State: AOAM532Vl+oYR23C/5jXD8OC3grM/71nB9Pe2Ca6kuZ/6pNYnvrNWUZ+
        Vx25ScO5dw+7QSvPpeq6rPzE0i6QtihuUQoG+DY=
X-Google-Smtp-Source: ABdhPJwn2wespE9XOkqpCWxpA2XpOqLKtNWofAPw5Yo7gt71X+rSI9CSbGmSXYTGORpc53oSaVqf7QUnluPfJRl+veU=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr26753304qvv.163.1595915983996;
 Mon, 27 Jul 2020 22:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-30-guro@fb.com>
 <CAEf4BzZjbK4W1fmW07tMOJsRGCYNeBd6eqyFE_fSXAK6+0uHhw@mail.gmail.com> <20200727231538.GA352883@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200727231538.GA352883@carbon.DHCP.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 22:59:33 -0700
Message-ID: <CAEf4BzamC4RQrQuAgH1DK-qcW3cKFuBEbYRhVz-8UMU+mbTcvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 29/35] bpf: libbpf: cleanup RLIMIT_MEMLOCK usage
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 4:15 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Jul 27, 2020 at 03:05:11PM -0700, Andrii Nakryiko wrote:
> > On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > As bpf is not using memlock rlimit for memory accounting anymore,
> > > let's remove the related code from libbpf.
> > >
> > > Bpf operations can't fail because of exceeding the limit anymore.
> > >
> >
> > They can't in the newest kernel, but libbpf will keep working and
> > supporting old kernels for a very long time now. So please don't
> > remove any of this.
>
> Yeah, good point, agree.
> So we just can drop this patch from the series, no other changes
> are needed.
>
> >
> > But it would be nice to add a detection of whether kernel needs a
> > RLIMIT_MEMLOCK bump or not. Is there some simple and reliable way to
> > detect this from user-space?
>
> Hm, the best idea I can think of is to wait for -EPERM before bumping.
> We can in theory look for the presence of memory.stat::percpu in cgroupfs,
> but it's way to cryptic.
>

As I just mentioned on another thread, checking fdinfo's "memlock: 0"
should be reliable enough, no?

> Thanks!
