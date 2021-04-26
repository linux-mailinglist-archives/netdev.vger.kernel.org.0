Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309A236AB64
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 06:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhDZEP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 00:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZEP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 00:15:26 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9E2C061574;
        Sun, 25 Apr 2021 21:14:43 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s9so4519340ljj.6;
        Sun, 25 Apr 2021 21:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2beU3f9zZ1QWH8Q9wqMeTxKqBXerQzZKRmfQLF6JixY=;
        b=pif8qPx9xiP9cCgTCFESfVNFQI+TpvvpdD7q1r3Q9m+mPFH80FCntk2KScy0FKF3hC
         4J8LydnLaGWuCx0EaSjDvrV0uWWOvm0Xq2ii/hd8IaOcfvjy/6uBX5EEIYf7Ai+HSlVS
         eSk1sC13KTLrOXZlHrKUOdWvCZSc0GPNUB3G5wFlrLIdpfAkcLaA8e57DhOc6Re0Y7MZ
         TZYFZeocWSEcxcV5DoeW8lyaYfUm2W45Oi1G4ouM67Gux+0lH3MYK7gp71fmxW140K8b
         I3fJJn/xw80H/Ruxj+hGl8tzyqOhGKPeO+iOZu1Z3jx5IciUOllF+V8Nj/6hOjHeSpvU
         7GUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2beU3f9zZ1QWH8Q9wqMeTxKqBXerQzZKRmfQLF6JixY=;
        b=qZZ1QOAaANplbCvZBuwKiDiHG5iwHWkmFpkjeLslW1A+rE0LTMzh9W4oDtUxBJL1oD
         HmyjNWRSUS6BT15YfpYm99LZNvQxgBYYR9Mqq4RPqjS4439xQhpBt1TqB8ktNppG8fy5
         m/cvBH5ixXk++ZnoKBEduhUnLSMNkBFcphGfG7Ovn7AOkXc7gbg9ErygVkZKjI8HfLf/
         lyln5vfeFdbVSgDgBxZTkxocsz2ugOuu0PtplS9suKYetkeUfYz4fvaMruO+4VALGz5p
         BPDD13G6lTyEJENVm+BGXrJmuGyRYEM4lWz8whJL2whNPXV4bT3nh+vhWN7/yU9cdG8G
         OLuQ==
X-Gm-Message-State: AOAM5316f58FGHB7KQB8O6OoVkVYNYG/P1r0EVzoXTWSieHXR4M9Kxzu
        zlB+3KF8ZDlrqk2o1yhEwnQtoKgAApA5RLT6rAs=
X-Google-Smtp-Source: ABdhPJx6O0RR8iQARa/rx+DHLTkonpD7IahkBsWWI/2/C0crCEg5JF9BBZiPQU4uQiVM7oJ1VvYxJF1ce1DiMlJcMTg=
X-Received: by 2002:a2e:a491:: with SMTP id h17mr8603296lji.236.1619410482332;
 Sun, 25 Apr 2021 21:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210414195147.1624932-1-jolsa@kernel.org> <CAADnVQK9+Rj8CCC0JZaQaovWqeJKWoAQihOU3eMjf94mk9e+xA@mail.gmail.com>
 <YHk0/QgLQagZMQpf@krava>
In-Reply-To: <YHk0/QgLQagZMQpf@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 25 Apr 2021 21:14:31 -0700
Message-ID: <CAADnVQ+D5ery27Qkswwn2z9aouiK3+F48hAHZd854sHwb=hRvg@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 0/7] bpf: Tracing and lsm programs re-attach
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:56 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Apr 15, 2021 at 04:45:24PM -0700, Alexei Starovoitov wrote:
> > On Wed, Apr 14, 2021 at 12:52 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > while adding test for pinning the module while there's
> > > trampoline attach to it, I noticed that we don't allow
> > > link detach and following re-attach for trampolines.
> > > Adding that for tracing and lsm programs.
> > >
> > > You need to have patch [1] from bpf tree for test module
> > > attach test to pass.
> > >
> > > v5 changes:
> > >   - fixed missing hlist_del_init change
> > >   - fixed several ASSERT calls
> > >   - added extra patch for missing ';'
> > >   - added ASSERT macros to lsm test
> > >   - added acks
> >
> > It doesn't work:
>
> hi,
> I got the same warning when running test without the
> patch [1] I mentioned:
>   861de02e5f3f bpf: Take module reference for trampoline in module
>
> I still don't see it in bpf-next/master

Finally applied to bpf-next.
Thank you and sorry for the delay.
