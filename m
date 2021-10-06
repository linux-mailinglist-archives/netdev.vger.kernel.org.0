Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBE0424873
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbhJFVIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhJFVIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:08:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F172C061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 14:06:07 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i65so502142pfe.12
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 14:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xde1f9Ug4W6itlYBIif71OcerLPrmVBObFV6OCnWGV0=;
        b=lzMVvF/USSjhAelz4pHRhhpVq/+AnS26bdnydIeAUp4XVNdBgC3T9nLYFAN18bayhh
         imCzQqvkfWmaK14Eo0CDAm2bCAwMRZwo4APgdlfy7JekABvCw6jHTSoIn26Ov50OP7Vb
         IpQX8JAzuhJZ9j1tSdcUJwiF0wso++SGj12dSUtL4Xez1K4UQ6TmmqDwIE0mv6KirPgj
         HvnvcoylWdse4xlzjTN58eyj796KmAFk9JGU6rUNB4ELC5uCGMJm/pLvU4cerdT5+TZg
         rbeCvmNHiPPijHDLXJvwhKnoMhI1swdFCOY51R2diW9JenEgW5E1Imm7F9BQRrDkY9XG
         MEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xde1f9Ug4W6itlYBIif71OcerLPrmVBObFV6OCnWGV0=;
        b=zqGdxxgZB2UZGSnyTpN1aIA7ZJ50bwdBaFPh1Lg/LqHYeHhk6lMGyaMTXJ7AEJBz/S
         GaYNvPP/OPfH9oU4RqCO78c7U/jP3xFeya0rMCGGP4M/wuQpa16pAqoJkrG3Z5k49A7j
         xlY0/rYErhlzCK2azVPC21rEx7Eoj/XSdY105npoHAncIHCPQdjCwZMrUFtGYmrPS6po
         l4hf9AfBKanKUfV9X43Kg2QBO0bZVslSHtavCOQpPEIXMgPEO5BQZ8PblqjfyFTd/Khz
         +4/fi4YqJMCizAkfCKoUfp3HgtBYojIVqfZSz/vBQQ41pm8QlBQiR96i5IhUjESTaDzh
         umIA==
X-Gm-Message-State: AOAM530xBphrQBqbQamwzo8zmpxJb05LjE0n58uIgpdDEqogGRBna3r0
        wuSCgnHAr5nccFQHnWqtMwQSGd7kfzX8U/PYp9oW1Q==
X-Google-Smtp-Source: ABdhPJzvkAD6c3687rWNG8U0byqJ5Gng0298AP+cCzREGzz9Wyerh6AUECVkqWnLlCtjOwQtD/y/bBH9Rxi+sjZCg/Q=
X-Received: by 2002:a63:f94d:: with SMTP id q13mr237767pgk.230.1633554366732;
 Wed, 06 Oct 2021 14:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
 <20211005051306.4zbdqo3rnecj3hyv@ast-mbp> <CAL0ypaB3=cPnCGdwfEHhSLf8zh_mMJ=mL5T_3EfTsPFbNuLSAA@mail.gmail.com>
 <20211006164143.fuvbzxjca7cxe5ur@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211006164143.fuvbzxjca7cxe5ur@ast-mbp.dhcp.thefacebook.com>
From:   Joe Burton <jevburton@google.com>
Date:   Wed, 6 Oct 2021 14:05:55 -0700
Message-ID: <CAL0ypaCwmGkQ0VK3nvfimHsO+OhBZb8cew-5c1gjZoZVZb1bBg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Just to make sure we're on the same patch I'm proposing something like
> the patch below...

The proposed patch seems reasonable overall:
+ eliminates a lot of boilerplate
+ enables map update filtering
+ minimal perf cost when not tracing maps
+ avoids adding complexity to verifier
- requires touching every map type's implementation
- tracing one map implies tracing all maps

I can rev this RFC with hooks inside the common map types' update() and
delete() methods.

> Especially for local storage... doing tracing from bpf program itself
> seems to make the most sense.

I'm a little unclear on how this should work. There's no off-the-shelf
solution that can do this for us, right?

In particular I think we're looking for an interface like this:

        /* This is a BPF program */
        int my_prog(struct bpf_sock *sk) {
                struct MyValue *v = bpf_sk_storage_get(&my_map, sk, ...);
                ...
                bpf_sk_storage_trace(&my_map, sk, v);
                return 0;
        }

I.e. we need some way of triggering a tracing hook from a BPF program.
For non-local storage maps we can achieve this with a
bpf_map_update_elem(). For local storage I suspect we need something
new.

Assuming there's no off-the-shelf hook that I'm missing, we can do some
brainstorming internally and come back with a proposal or two.

On Wed, Oct 6, 2021 at 9:41 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 05, 2021 at 02:47:34PM -0700, Joe Burton wrote:
> > > It's a neat idea to user verifier powers for this job,
> > > but I wonder why simple tracepoint in map ops was not used instead?
> >
> > My concern with tracepoints is that they execute for all map updates,
> > not for a particular map. Ideally performing an upgrade of program X
> > should not affect the performance characteristics of program Y.
>
> Right, but single 'if (map == map_ptr_being_traced)'
> won't really affect update() speed of maps.
> For hash maps the update/delete are heavy operations with a bunch of
> checks and spinlocks.
> Just to make sure we're on the same patch I'm proposing something like
> the patch below...
>
> > If n programs are opted into this model, then upgrading any of them
> > affects the performance characteristics of every other. There's also
> > the (very remote) possibility of multiple simultaneous upgrades tracing
> > map updates at the same time, causing a greater performance hit.
>
> Also consider that the verifier fixup of update/delete in the code
> is permanent whereas attaching fentry or fmod_ret to a nop function is temporary.
> Once tracing of the map is no longer necessary that fentry program
> will be detached and overhead will go back to zero.
> Which is not the case for 'fixup' approach.
>
> With fmod_ret the tracing program might be the enforcing program.
> It could be used to disallow certain map access in a generic way.
>
> > > I don't think the "solution" for lookup operation is worth pursuing.
> > > The bpf prog that needs this map tracing is completely in your control.
> > > So just don't do writes after lookup.
> >
> > I eventually want to support apps that use local storage. Those APIs
> > generally only allow updates via a pointer. E.g. bpf_sk_storage_get()
> > only allows updates via the returned pointer and via
> > bpf_sk_storage_delete().
> >
> > Since I eventually have to solve this problem to handle local storage,
> > then it seems worth solving it for normal maps as well. They seem
> > like isomorphic problems.
>
> Especially for local storage... doing tracing from bpf program itself
> seems to make the most sense.
>
> From c7b6ec4488ee50ebbca61c22c6837fd6fe7007bf Mon Sep 17 00:00:00 2001
> From: Alexei Starovoitov <ast@kernel.org>
> Date: Wed, 6 Oct 2021 09:30:21 -0700
> Subject: [PATCH] bpf: trace array map update
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/arraymap.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 5e1ccfae916b..89f853b1a217 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -293,6 +293,13 @@ static void check_and_free_timer_in_array(struct bpf_array *arr, void *val)
>                 bpf_timer_cancel_and_free(val + arr->map.timer_off);
>  }
>
> +noinline int bpf_array_map_trace_update(struct bpf_map *map, void *key,
> +                                       void *value, u64 map_flags)
> +{
> +       return 0;
> +}
> +ALLOW_ERROR_INJECTION(bpf_array_map_trace_update, ERRNO);
> +
>  /* Called from syscall or from eBPF program */
>  static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
>                                  u64 map_flags)
> @@ -300,6 +307,7 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
>         struct bpf_array *array = container_of(map, struct bpf_array, map);
>         u32 index = *(u32 *)key;
>         char *val;
> +       int err;
>
>         if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
>                 /* unknown flags */
> @@ -317,6 +325,9 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
>                      !map_value_has_spin_lock(map)))
>                 return -EINVAL;
>
> +       if (unlikely(err = bpf_array_map_trace_update(map, key, value, map_flags)))
> +               return err;
> +
>         if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY) {
>                 memcpy(this_cpu_ptr(array->pptrs[index & array->index_mask]),
>                        value, map->value_size);
> --
> 2.30.2
>
