Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF83D8440
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbhG0Xsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbhG0Xsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:48:45 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98271C061757;
        Tue, 27 Jul 2021 16:48:43 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w17so835581ybl.11;
        Tue, 27 Jul 2021 16:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPRgbtGS6Pk9frO0T63mWMz81DzPxMuuTkI6I2qFqkE=;
        b=Sf47/z3aiSLPyOftcCo2FmqTsmfyQR1RUOgoKIoZwkLdx5Q75xOhmJfo8BI6Vh3jQ1
         meiWGIJkK1Q/ZaT9B/8+5K/xT6xa/X2knk6uuHzy6laZuALLVNYn9BKNssZNWd6lM7BN
         KIfnf43CInjP21hwtjsOOYw9+9ZydeLafVnVD7am+TUiHITvHckh5ZEgrY/8ypXZmJQd
         N/Y7mma9oxKjoWa7MXqdGwFQKxpFul+BNskHnzdl7DBzQG9lr217nLCz/lURFbyWl+fu
         dQ90TPqC9WM6ochWbr/4rdMp/LvIuOwnFhO2Jtd7ntXWmYYnE9iv7o8ptMzBj22FZrTV
         6IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPRgbtGS6Pk9frO0T63mWMz81DzPxMuuTkI6I2qFqkE=;
        b=HxmAU3QzWVi0n7qLF878adXQRgMwtquQdc5kKy9jCzVOAevhO73yNpMYVJnKtOXiwH
         b2OSWb+MlcalGPf5RiQ2IwQxCQtUaqqO2ZGJqVRAYfglPAUTcfjFX24+TMlIAoK1pddO
         10NzFRT2ZVA2/XwKhZJrUJ3IjUcMXN3xt/5xLN9/ng4nMFqbd/6I24CDjvEK2y/ObPP0
         ctrgy9FBt4aVSq+JvXY9XhdFlLX26gIFi1adNUgpII2u0m1Kuo+SoDVoYSNGQZGLFGl8
         w3KH8rwbve9lLanNdjPp+4kyRwiMM6x4kCgEHcQa1w7jRWzvR0rU5m0f5nGF0tabB7Yc
         g9NQ==
X-Gm-Message-State: AOAM533ckOuaC6QpXSB5iTpMT1u5p/7PlBCZvN/hP+GECqXAHgTSnU3/
        trB3eb8GAnKSRtgkS1SMZAURrrwa+oDwOovZ2P4=
X-Google-Smtp-Source: ABdhPJwSRcZQaSjVxUkwcOaUXHLCCfEqSleQTztCc/umt6maWUz1l2z3+XL6u1Vlz9T9EOOM3bINd6ZNi1XvvUiRLts=
X-Received: by 2002:a25:9942:: with SMTP id n2mr34957355ybo.230.1627429722884;
 Tue, 27 Jul 2021 16:48:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210727222335.4029096-1-sdf@google.com> <CAEf4BzZJOH1wbQ2BCjaqkYWtW406Oh+UyWt_wM9AtggabY46RQ@mail.gmail.com>
 <YQCV/9NtQvtOk0sW@google.com>
In-Reply-To: <YQCV/9NtQvtOk0sW@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 16:48:31 -0700
Message-ID: <CAEf4BzZ4e+pjWqyAj-MEVY2pJi8Eg35OrGUbqACaV_WLdM9C8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: increase supported cgroup storage value size
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 4:25 PM <sdf@google.com> wrote:
>
> On 07/27, Andrii Nakryiko wrote:
> > On Tue, Jul 27, 2021 at 3:23 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Current max cgroup storage value size is 4k (PAGE_SIZE). The other local
> > > storages accept up to 64k (BPF_LOCAL_STORAGE_MAX_VALUE_SIZE). Let's
> > align
> > > max cgroup value size with the other storages.
> > >
> > > For percpu, the max is 32k (PCPU_MIN_UNIT_SIZE) because percpu
> > > allocator is not happy about larger values.
> > >
> > > netcnt test is extended to exercise those maximum values
> > > (non-percpu max size is close to, but not real max).
> > >
> > > v4:
> > > * remove inner union (Andrii Nakryiko)
> > > * keep net_cnt on the stack (Andrii Nakryiko)
> > >
> > > v3:
> > > * refine SIZEOF_BPF_LOCAL_STORAGE_ELEM comment (Yonghong Song)
> > > * anonymous struct in percpu_net_cnt & net_cnt (Yonghong Song)
> > > * reorder free (Yonghong Song)
> > >
> > > v2:
> > > * cap max_value_size instead of BUILD_BUG_ON (Martin KaFai Lau)
> > >
> > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > Cc: Yonghong Song <yhs@fb.com>
> > > Cc: Andrii Nakryiko <andrii@kernel.org>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
>
> > Added Martin's ack and applied to bpf-next. Please carry over received
> > Acks between revisions.
> Ah, sorry, forgot about it :-(
>
> > It's also a good practice to separate selftest from the kernel (or
> > libbpf) changes, unless kernel change doesn't immediately break
> > selftest. Please consider doing that for the future.
> I've actually seen some back and forth on this one. I used to split
> them in the past (assuming it makes it easy to do the
> backports/cherry-picks), but I remember at some point it was
> suggested not to split them for small changes like this.

So we asked to split UAPI header sync for tools/include/ into a
separate patch initially. But then I just improved libbpf's sync
script to handle that regardless and we stopped asking for that. But
the libbpf vs kernel vs selftests split was always (perhaps
implicitly) advised. Personally, I've only had a few cases where
selftest changes had to go in with kernel changes in the same patch to
avoid breaking selftests. In all other cases it's cleaner to have them
split out.

>
> Might be a good idea to document this (when and if to separate
> libbpf/selftests)
> on bpf_devel_QA.rst
>
> > I also just noticed that test_netcnt isn't part of test_progs. It
> > would be great to migrate it under the common test_progs
> > infrastructure. We've been steadily moving towards that, but there are
> > still a bunch of tests that are not run in CI.
> SG, I might do a follow up on this one.

Sounds good, thanks!
