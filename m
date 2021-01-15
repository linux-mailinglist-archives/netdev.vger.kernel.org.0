Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2998F2F80FD
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbhAOQjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOQjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:39:53 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA98C061793
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:39:12 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id h1so4209825qvy.12
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+tkUYiTSMZ6aZ2SFhexaT+SsaeIWjTivEj+w6tLR3g=;
        b=TB5NZE3Hxl8ljI7dGaiqKe3Xr5kVQhSvWat/VKetbaGOEzq81mqtlI7mTc4uOEFGLY
         WNKbj/URwAYxLVNojc5ihCHBqcTpr5BLfuHAErztTgGOXLp/gu+TCrAZyWn3KxnFsCTa
         kn75VTHudIHwbLqSzCDi0N0zESdgaT+fd6mg4bOLsXuJKndhNxjrpDGZdQokowK4ZjCG
         dcPD6OUVGsSg1s8DdQC32qzlnBgRDIskrNHNI2q2OQju+wAAY/+UhA5460ofWLqe6PH6
         2Qdqfki3MYLxhRxF4aK6VJVjc94B6uCnWXh1avsnldoKB4SUHiGlLpCi+5QzUwkG+yZp
         dF3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+tkUYiTSMZ6aZ2SFhexaT+SsaeIWjTivEj+w6tLR3g=;
        b=SruF12IIDM88UYBb4zUq0mqZacE2vLD8rypYtziPmydVjlpPZXBZ6molcF4awGUTba
         ribwxVo4IVcinTucWjVzJVTgo0HN/XddE+5Hmw14gtK0QcrAl+4w/GYlT8eWcnTLvQ/E
         2KRvLJspFhAxkVakJuNADooa1nNJU0eCw38MMnpFBC3dVeSHIyMFEGf37Hd7xHkTwFDZ
         Xa18v8JEU0BrYBemJjMqMYD5sQoqqweiyYVHNwTSdia/iLjA1FmGqWdpqdH4WkHusQGv
         ki6fAmuG33BPNhcEBLyppe8NjhpHuaUYD1+0utia6HQW1BhCMRULo5LwIGdmYf92+a4J
         CjGQ==
X-Gm-Message-State: AOAM530tZUJK051Y5Q24VF2xWXGLDpY9cPWSDLsRrexAd3BrH5WfRG1X
        VECPdzVRQDlAkD3z1WVbZD+9BZUW3ct1+1ksJ+difA==
X-Google-Smtp-Source: ABdhPJy1Qtz6TjR5mJqiQ1mxDU1AgQiXDERUi9WuA2dypM2+OnO6K4m4y5ICpOwri14Hil3gSnpU1G2/ynvydUgowbo=
X-Received: by 2002:a0c:b21e:: with SMTP id x30mr12889913qvd.21.1610728751775;
 Fri, 15 Jan 2021 08:39:11 -0800 (PST)
MIME-Version: 1.0
References: <1627e0f688c7de7fe291b09c524c7fbb55cfe367.1610669653.git.sdf@google.com>
 <CAEf4BzZOt-VZPwHZ4uGxG_mZYb7NX3wJv1UiAnnt3+dOSkkqtA@mail.gmail.com>
 <CAKH8qBuvbRa0qSbYBqJ0cz5vcQ-8XQA8k6B4FS-TNE1QUEnH8Q@mail.gmail.com>
 <CAADnVQJwOteRbJuZXhbkexBYp2Sr2R9KxgTF4xEw16KmCuH1sQ@mail.gmail.com> <500e4d8b-6ed0-92a5-a5ef-9477766be3e4@fb.com>
In-Reply-To: <500e4d8b-6ed0-92a5-a5ef-9477766be3e4@fb.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 15 Jan 2021 08:39:00 -0800
Message-ID: <CAKH8qBuZ0iLAiuqi=65RBiQ=Vhi3qkitPzj0b7U=XuiH_4TuLA@mail.gmail.com>
Subject: Re: [RPC PATCH bpf-next] bpf: implement new BPF_CGROUP_INET_SOCK_POST_CONNECT
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 8:27 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/14/21 7:59 PM, Alexei Starovoitov wrote:
> > On Thu, Jan 14, 2021 at 7:51 PM Stanislav Fomichev <sdf@google.com> wrote:
> >>>>
> >>>>          lock_sock(sock->sk);
> >>>>          err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
> >>>
> >>> Similarly here, attaching fexit to __inet_stream_connect would execute
> >>> your BPF program at exactly the same time (and then you can check for
> >>> err value).
> >>>
> >>> Or the point here is to have a more "stable" BPF program type?
> >> Good suggestion, I can try to play with it, I think it should give me
> >> all the info I need (I only need sock).
> >> But yeah, I'd rather prefer a stable interface against stable
> >> __sk_buff, but maybe fexit will also work.
> >
> > Maybe we can add an extension to fentry/fexit that are cgroup scoped?
> > I think this will solve many such cases.
>
> Currently, google is pushing LTO build of the kernel. If this happens,
> it is possible one global function in one file (say a.c) might be
> inlined into another file (say b.c). So in this particular case,
> if the global function is inlined, fentry/fexit approach might be
> missing some cases? We could mark certain *special purpose* function
> as non-inline, but not sure whether this is scalable or not.
For this particular case I don't think it matters, right?
I'd like to fexit ip4_datagram_connect which is exported symbol,
it's accessed via proto->connect and there is no way it's
gonna be inlined. Unless our indirect call macros give clang
a hint :-/

I'm in general a bit concerned about using tracing calls for stuff
like that and depending on the non-uapi, but it's probably
time to give it a try and see how co-re works :-)
