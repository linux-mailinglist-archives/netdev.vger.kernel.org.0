Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C706924B907
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730664AbgHTLeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbgHTLd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:33:27 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCF0C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:33:27 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id q9so1174059oth.5
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 04:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QDmA2I/vpmdly65/ewdOkuvkgD5OTZaOmPpGyJss1r8=;
        b=dNd1ucF68FOwK698++MeDaHZC8R4QTfkj/7ds5fx+EVzNfJCMORnX8FAOUdJXqjhwB
         KzyLCNsY8RwuHBIj/D1WqqnFEjPzWvq/PbQrZhsKiZ2hAM1Tl2HAg7aZ9Om4JaruuI0q
         ECAeeAY4+/MbKn5cW+ySGsEjinxUvgEoWpJtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDmA2I/vpmdly65/ewdOkuvkgD5OTZaOmPpGyJss1r8=;
        b=K/tNP18vIALoQ/1+KMkZaxhE5pq7EB+ilDht/fif5yq2Yrr5lqOnZ+a+1TZt1X6nY1
         oy3jlwylsn27UeTIFeR47SiJ0/ZgOo6H9jxeKjg9iODfRoem/9MLYWhFXMTqFHUV2xZJ
         Q5IRR7Ya+FG7VculrfpxERtTeoM72C4xzde8a6ZdEUsYvM6C6OAbpWRs/cq0nsRnvt+8
         /JWbJyqcPp8hDWmas8jM9PCQmkc/AY+zel10iEXBJvB3OUQU3BsAAlMUmjgtg2X5VsUd
         kZAObkbSkmvX7wI9FfPlfNZKFzmS2CO+FjaEmAqz6xLbWnoIQXpmg8GxYjyzu5xSBHsq
         iBxg==
X-Gm-Message-State: AOAM533nptcrR8KvNLVMYpAtfj6YxxTH0JATqeFS35ruFd0L5atU57Z2
        PyOGc82MNQrEvOJTlKLUrVxj/5g2B/hP/Xf0JR6OzA==
X-Google-Smtp-Source: ABdhPJz5sS9SzkLweMOTau3oDrIAtuUMdCvWcs9y5ZeCHjWJmjdV0SWMRwsXpqL0zJOpQbQIgTkvrSUYiwFOo9W6SY8=
X-Received: by 2002:a9d:2f23:: with SMTP id h32mr1908222otb.334.1597923206365;
 Thu, 20 Aug 2020 04:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200819092436.58232-1-lmb@cloudflare.com> <20200819092436.58232-6-lmb@cloudflare.com>
 <5f3d982f51f22_2c9b2adeefb585bccb@john-XPS-13-9370.notmuch> <5f3daa91265a7_1b0e2ab87245e5c05@john-XPS-13-9370.notmuch>
In-Reply-To: <5f3daa91265a7_1b0e2ab87245e5c05@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 20 Aug 2020 12:33:15 +0100
Message-ID: <CACAyw9_oa5BKq+0gLS6pAuGu6pj9MsRHhEAxFvts167DwpdhLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] bpf: sockmap: allow update from BPF
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 at 23:41, John Fastabend <john.fastabend@gmail.com> wrote:
>
> John Fastabend wrote:
> > Lorenz Bauer wrote:
> > > Allow calling bpf_map_update_elem on sockmap and sockhash from a BPF
> > > context. The synchronization required for this is a bit fiddly: we
> > > need to prevent the socket from changing it's state while we add it
> > > to the sockmap, since we rely on getting a callback via
> > > sk_prot->unhash. However, we can't just lock_sock like in
> > > sock_map_sk_acquire because that might sleep. So instead we disable
> > > softirq processing and use bh_lock_sock to prevent further
> > > modification.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > ---
> > >  kernel/bpf/verifier.c |  6 ++++--
> > >  net/core/sock_map.c   | 24 ++++++++++++++++++++++++
> > >  2 files changed, 28 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 47f9b94bb9d4..421fccf18dea 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -4254,7 +4254,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
> > >                 func_id != BPF_FUNC_map_delete_elem &&
> > >                 func_id != BPF_FUNC_msg_redirect_map &&
> > >                 func_id != BPF_FUNC_sk_select_reuseport &&
> > > -               func_id != BPF_FUNC_map_lookup_elem)
> > > +               func_id != BPF_FUNC_map_lookup_elem &&
> > > +               func_id != BPF_FUNC_map_update_elem)
> > >                     goto error;
> > >             break;
> > >     case BPF_MAP_TYPE_SOCKHASH:
> > > @@ -4263,7 +4264,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
> > >                 func_id != BPF_FUNC_map_delete_elem &&
> > >                 func_id != BPF_FUNC_msg_redirect_hash &&
> > >                 func_id != BPF_FUNC_sk_select_reuseport &&
> > > -               func_id != BPF_FUNC_map_lookup_elem)
> > > +               func_id != BPF_FUNC_map_lookup_elem &&
> > > +               func_id != BPF_FUNC_map_update_elem)
> >
> > I lost track of a detail here, map_lookup_elem should return
> > PTR_TO_MAP_VALUE_OR_NULL but if we want to feed that back into
> > the map_update_elem() we need to return PTR_TO_SOCKET_OR_NULL
> > and then presumably have a null check to get a PTR_TO_SOCKET
> > type as expect.
> >
> > Can we use the same logic for expected arg (previous patch) on the
> > ret_type. Or did I miss it:/ Need some coffee I guess.
>
> OK, I tracked this down. It looks like we rely on mark_ptr_or_null_reg()
> to update the reg->tyype to PTR_TO_SOCKET. I do wonder if it would be
> a bit more straight forward to do something similar to the previous
> patch and refine it earlier to PTR_TO_SOCKET_OR_NULL, but should be
> safe as-is for now.

Yes, it took me a while to figure this out as well. I think we can use
the same approach, but I wanted to keep this series simple.

> I still have the below question though.
>
> >
> > >                     goto error;
> > >             break;
> > >     case BPF_MAP_TYPE_REUSEPORT_SOCKARRAY:
> > > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > > index 018367fb889f..b2c886c34566 100644
> > > --- a/net/core/sock_map.c
> > > +++ b/net/core/sock_map.c
> > > @@ -603,6 +603,28 @@ int sock_map_update_elem_sys(struct bpf_map *map, void *key,
> > >     return ret;
> > >  }
> > >
> > > +static int sock_map_update_elem(struct bpf_map *map, void *key,
> > > +                           void *value, u64 flags)
> > > +{
> > > +   struct sock *sk = (struct sock *)value;
> > > +   int ret;
> > > +
> > > +   if (!sock_map_sk_is_suitable(sk))
> > > +           return -EOPNOTSUPP;
> > > +
> > > +   local_bh_disable();
> > > +   bh_lock_sock(sk);
> >
> > How do ensure we are not being called from some context which
> > already has the bh_lock_sock() held? It seems we can call map_update_elem()
> > from any context, kprobes, tc, xdp, etc.?

Yeah, to be honest I'm not entirely sure.

XDP, TC, sk_lookup are fine I think. We have bpf_sk_lookup_tcp and
friends, but these aren't locked, and the BPF doesn't run in a context
where there is a locked socket.

As you point out, kprobes / tracing is problematic because the probe
_can_ run at a point where an sk is locked. If the tracing program
somehow gets a hold of this socket via sk_lookup_* or
a sockmap the program could deadlock.

bpf_sock_ops is also problematic since ctx->sk is in various states of
locking. For example, BPF_SOCK_OPS_TCP_LISTEN_CB is called with
lock_sock held, so unproblematic. BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB
on the other hand is called with the spinlock held.

It seems to me like the only option is to instead only allow updates
from "safe" contexts, such as XDP, tc, bpf_iter etc.

Am I missing something?


> >
> > > +   if (!sock_map_sk_state_allowed(sk))
> > > +           ret = -EOPNOTSUPP;
> > > +   else if (map->map_type == BPF_MAP_TYPE_SOCKMAP)
> > > +           ret = sock_map_update_common(map, *(u32 *)key, sk, flags);
> > > +   else
> > > +           ret = sock_hash_update_common(map, key, sk, flags);
> > > +   bh_unlock_sock(sk);
> > > +   local_bh_enable();
> > > +   return ret;
> > > +}
> > > +
> > >  BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
> > >        struct bpf_map *, map, void *, key, u64, flags)
> > >  {
> > > @@ -687,6 +709,7 @@ const struct bpf_map_ops sock_map_ops = {
> > >     .map_free               = sock_map_free,
> > >     .map_get_next_key       = sock_map_get_next_key,
> > >     .map_lookup_elem_sys_only = sock_map_lookup_sys,
> > > +   .map_update_elem        = sock_map_update_elem,
> > >     .map_delete_elem        = sock_map_delete_elem,
> > >     .map_lookup_elem        = sock_map_lookup,
> > >     .map_release_uref       = sock_map_release_progs,
> > > @@ -1180,6 +1203,7 @@ const struct bpf_map_ops sock_hash_ops = {
> > >     .map_alloc              = sock_hash_alloc,
> > >     .map_free               = sock_hash_free,
> > >     .map_get_next_key       = sock_hash_get_next_key,
> > > +   .map_update_elem        = sock_map_update_elem,
> > >     .map_delete_elem        = sock_hash_delete_elem,
> > >     .map_lookup_elem        = sock_hash_lookup,
> > >     .map_lookup_elem_sys_only = sock_hash_lookup_sys,
> > > --
> > > 2.25.1
> > >
> >
> >
>
>


--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
