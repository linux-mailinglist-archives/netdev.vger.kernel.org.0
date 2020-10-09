Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7E2289152
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732686AbgJISmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732380AbgJISmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:42:53 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8FFC0613D2;
        Fri,  9 Oct 2020 11:42:51 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id j76so7983483ybg.3;
        Fri, 09 Oct 2020 11:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHehwStZSh5i29OSgM53P0n9THKydgJyemP9HqZKMOg=;
        b=XgkhwKKgqt3qpiImVm8XVPpJE9JwANX6cXZDzDvsQJDbMH9NwE3bl5HCsRR9sSPeEa
         lef0ntlPYXT+rN6qKqr6ltPpX4V7MbNwFkx9zKt0iXo5BD8Z5UYVaq4ugedq2dscOOdz
         VQlGfzmoRqV/Bs1VMETrU6K9vsRcqDeHgBgEsMsdLsbMkYXE31IL3is/6ktTuQpviXCl
         9get5r50JOU/uK/kqeHN++p046EVx+2afeqLFxtg63ixa6iXRG7H1vyy1kOUEHr6nNG9
         xZfxI2dyttYWwNxvF0oknp9Iqgo1fjhP6aFboav4YAk9nuZuHQWvV9G95sjqBWdKzoXX
         dVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHehwStZSh5i29OSgM53P0n9THKydgJyemP9HqZKMOg=;
        b=K/1a9B9xtH1LWjzJRNJWRDq5hAQQxsjAmLMEcmk6HPZ64g3t+CBwzITLt3T02N4UtZ
         YuAeOx3os+3KHS1x0zx9EFroTgYbJpDz0az98aHGiCIE7zmaKAtg2YTv9oDopog2zAbh
         9rEgScthgeUAPtZnDAoBG9tOo4OA3V22NKKuII1dcnTgswNqS19Qhbzn//qJs84fPGjJ
         RPKnCaEQTXX09w77/r5qYP7fuc6x9Ru66iWpQevTW41rMFYvzMEYiYly2dAJZobu/IJy
         Un6J/3V+wR8MICZBbOrPVboB0hNmv9t1xdggsOE25jfQAARdOjN0Qkx0mQoJva+aYCER
         BlaQ==
X-Gm-Message-State: AOAM5329OtJ8OuQIcywJQuiackc8CF2JflJ11KpOGG2Mrtr5gDuFdEsJ
        4uMcgeKMBjgPjMia8sEFBRB6nwuMXfWFaoF89yA=
X-Google-Smtp-Source: ABdhPJxZZmudMrkApxKvaZDIpkfkM6NPJHwagdz88LFzqSS9TURXqYQFOZquY6Iuu15hG5xMX5TdPBJR1mCYbxN4OxQ=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr10720009ybl.347.1602268971024;
 Fri, 09 Oct 2020 11:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602252399.git.daniel@iogearbox.net> <48cbc4e24968da275d13bd8797fe32986938f398.1602252399.git.daniel@iogearbox.net>
 <CAEf4BzYVgs0vicVJTeT5yVSrOg=ArJ=BkEoA8KrwdQ8AVQ23Sg@mail.gmail.com> <99c67c05-700e-8f54-7fea-2daa6d19ec9e@iogearbox.net>
In-Reply-To: <99c67c05-700e-8f54-7fea-2daa6d19ec9e@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 9 Oct 2020 11:42:40 -0700
Message-ID: <CAEf4Bzb+p8Kum8aX-t7Zzm9VQADZZf=JU0CcqUUTT7Uut_uxzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 11:35 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/9/20 7:42 PM, Andrii Nakryiko wrote:
> > On Fri, Oct 9, 2020 at 7:13 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> [...]
> >>   static int percpu_array_map_btf_id;
> >>   const struct bpf_map_ops percpu_array_map_ops = {
> >>          .map_meta_equal = bpf_map_meta_equal,
> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> index 1110ecd7d1f3..519bf867f065 100644
> >> --- a/kernel/bpf/syscall.c
> >> +++ b/kernel/bpf/syscall.c
> >> @@ -111,7 +111,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
> >>          ops = bpf_map_types[type];
> >>          if (!ops)
> >>                  return ERR_PTR(-EINVAL);
> >> -
> >> +       if (ops->map_swap_ops)
> >> +               ops = ops->map_swap_ops(attr);
> >
> > I'm afraid that this can cause quite a lot of confusion down the road.
> >
> > Wouldn't designating -EOPNOTSUPP return code from map_gen_lookup() and
> > not inlining in that case as if map_gen_lookup() wasn't even defined
> > be a much smaller and more local (semantically) change that achieves
> > exactly the same thing? Doesn't seem like switching from u32 to int
> > for return value would be a big inconvenience for existing
> > implementations of inlining callbacks, right?
>
> I was originally thinking about it, but then decided not to take this path,
> for example the ops->map_gen_lookup() patching code has sanity checks for
> the u32 return code on whether we patched 0 or too many instructions, so

Right, we won't ever need to patch >2 billion instructions, so making
the return value int shouldn't be a problem. As for not catching
accidental patched insn == -EOPNOTSUPP, I don't think that's a real
concern, is it? All the other negative value would trigger loud error.

> if there is anything funky going on in one of the map_gen_lookup() that
> we'd get a negative code, for example, I don't want to just skip and not
> have the verifier bark loudly with "bpf verifier is misconfigured", also
> didn't want to make the logic inside fixup_bpf_calls() even more complex,
> so the patch here felt simpler & more straight forward to me.

It's not straightforward in the same way as class inheritance and
overriding methods is not straightforward to follow in general.
Swapping out entire sets of operations is super confusing, IMO.

>
> Thanks,
> Daniel
