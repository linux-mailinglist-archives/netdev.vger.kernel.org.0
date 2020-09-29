Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F71A27D6E4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 21:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgI2T25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 15:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2T25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 15:28:57 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002F5C061755;
        Tue, 29 Sep 2020 12:28:56 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b19so4973863lji.11;
        Tue, 29 Sep 2020 12:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B4tWsDsLK3168joBeLWYsNyvm8err8ZMXx3sFM2vJXM=;
        b=iBFcLQgPM+vp5wQwAeyzJh6pofv8ZNtzt9vuD+qKXqvVc5mv6h+P+e6BVIoWL7Koan
         mMQAAnR3YqqzdTxeE+4TidC+IN5qf9bjPlrTZQSbNUk1GN26jLK9KyDJpN6YCzZ+oNjt
         0rU499422oFEq5bRUgRY8bYHWXqILDdeXBSBcb6KzGr0e1IqHLtRB7jOD241mtaLskpz
         evEZ1dgtLpR1EBaMxw90mHoeFB3RAIPsJ8JabtCag9uZmQR/8hpPF+NcEYwTe/SNlJj2
         ao+Ap9oVPPaTjnlj5VTKNEYOLgPU0aJsNFJPASB/IWYWtt8WqpOHkJhbMkVa5jLfEziD
         4+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4tWsDsLK3168joBeLWYsNyvm8err8ZMXx3sFM2vJXM=;
        b=aZMCscCMDigUdIGm+zVhAO8q2iFR+Gy9DPsdmOWU6/qXUJZgw4/m3Y6IJys6fDi6k0
         pTqdwJ1b2O++aEVrQxu2SL8YMRKviC3AQ/sZCzQ7cPET9yux3Yb8aua/Jn7ZfwyaeRwl
         VTmlU57ag9LkFupTPQ51cJPOakCjbOOjfqwpJz5IlOyCudx7L4aV57YVMjAc0EdUil2M
         fpgj0OCQ48iJboP7yN9lEUqrhf9+tZmz1c6vmdIZUP+8qL8HCCq0BzRJIQxxiIvht8BK
         DlvjYfrUqoOkCmNqUCpxPNmV6/P1j+ncMQSWKXPtnGlzIXwGjRTLfEw76iYLKPIQkapO
         BxbQ==
X-Gm-Message-State: AOAM5308xun3YzK5cwtjTV3vQCJkZso17QDYvoDU1ROnXMdJPQfrs2pU
        M7BM7ENCm4zXb1ds6bhtitEml35H1+0tcSLlkQU=
X-Google-Smtp-Source: ABdhPJxBq+J12GSPG/GngQMExULLu20w8yTcF5qdIQv7W01muzsGJsPTE0/xxIM5Y+2d/Bw6+fRD2kT5048fUi3YPWQ=
X-Received: by 2002:a2e:d01:: with SMTP id 1mr1746602ljn.121.1601407735430;
 Tue, 29 Sep 2020 12:28:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-2-songliubraving@fb.com> <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
 <20200929190054.4a2chcuxuvicndtu@ast-mbp.dhcp.thefacebook.com> <7c13d40b-fe79-ddbf-2a37-abae1b44de71@iogearbox.net>
In-Reply-To: <7c13d40b-fe79-ddbf-2a37-abae1b44de71@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Sep 2020 12:28:43 -0700
Message-ID: <CAADnVQJKArVZBg+qLqG0=rFMHC77aOed5o+zydzuM3QXE+cZrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf event array
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Song Liu <songliubraving@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 12:18 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 9/29/20 9:00 PM, Alexei Starovoitov wrote:
> > On Tue, Sep 29, 2020 at 04:02:10PM +0200, Daniel Borkmann wrote:
> >>> +
> >>> +/* Share perf_event among processes */
> >>> +   BPF_F_SHARE_PE          = (1U << 11),
> >>
> >> nit but given UAPI: maybe name into something more self-descriptive
> >> like BPF_F_SHAREABLE_EVENT ?
> >
> > I'm not happy with either name.
> > It's not about sharing and not really about perf event.
> > I think the current behavior of perf_event_array is unusual and surprising.
> > Sadly we cannot fix it without breaking user space, so flag is needed.
> > How about BPF_F_STICKY_OBJECTS or BPF_F_PRESERVE_OBJECTS
> > or the same with s/OBJECTS/FILES/ ?
>
> Sounds good to me, BPF_F_PRESERVE_OBJECTS or _ENTRIES seems reasonable.

May be BPF_F_PRESERVE_ELEMENTS?
or _ELEMS ?
I think we refer to map elements more often as elements instead of entries.
But both _entries and _elems work for me.
