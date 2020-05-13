Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92191D1776
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388914AbgEMOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733142AbgEMOVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:21:38 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931D0C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:21:36 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m18so13488214otq.9
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z4VXgd+zE4sqqhlf8pmbgOH5r+LEd8gnmKRJo3Gl5fY=;
        b=YPA5TAgKfumfVUDpmtoRY5G/myaD+x12+ATkr1ZXS4/pdnOs8FgXwqiDJy8Fy5mXL8
         8UBI+41Ls9TdIPYuSeHqjZdSZOHtQIG6KsaMlKE7rVSdw1LLS6S41OY/yXLVGntHNCI0
         ISl1vJPqgNJ2izUUaFOGLfjAmALLVrNHjJE9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z4VXgd+zE4sqqhlf8pmbgOH5r+LEd8gnmKRJo3Gl5fY=;
        b=Bo/W4LjWmzHIashmIQXhnH9+c/EPI2w6cLJD10FF4Oc9f/ZB0fg+p2UKkSW61FWsTQ
         2UpZ/wQEtMg1u82uexbseFnmulsQAnmv6gXd/yUHGOSHzD2GLOMK6EjC9ifcfeVQ6siU
         G6vzlKUfM/2AzjgDC9MSTWEBTmDVmTR+lrU2I8PvqC9xNkpbEURkYU9zQHhETauBl5ax
         cQJVIANS6MR3n8dOBzVncoO4AUlw5MHfQ+f1dbBFk88SKRE34g0zwCc2B1BGwJM9x6ED
         MJGmpnmFQy0H9GxEjcgXI1OiVbcoPGx+rtTEVQIlWEM5oyqQZp3skqnY1XjDIjqw5Ea1
         cEIg==
X-Gm-Message-State: AGi0PuaH5U/K3Yaky3erd7T45pzSG1W9KhUtLbwvkyncV0EkttOfPaVt
        fc26iyywCt8TA3rtvC00bGYi7cysKPWt+s9IzWNrgw==
X-Google-Smtp-Source: APiQypJHmHBQ2zzg44WjqJEXgL+RqABOJLmKL/0Nmwe6N3gdrGxA9CXCOHQzfuBd9rxw0MHGxOfGYY9GXYi9rsoyMj8=
X-Received: by 2002:a9d:a4c:: with SMTP id 70mr13476366otg.334.1589379695564;
 Wed, 13 May 2020 07:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511185218.1422406-6-jakub@cloudflare.com> <20200511204445.i7sessmtszox36xd@ast-mbp>
 <871rnpuuob.fsf@cloudflare.com>
In-Reply-To: <871rnpuuob.fsf@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 13 May 2020 15:21:24 +0100
Message-ID: <CACAyw98ngR+nQdg-MYhGMqQkdhyOGOcWQB+fgy8eTGwKj9-Rzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 05/17] inet: Run SK_LOOKUP BPF program on
 socket lookup
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dccp@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020 at 14:52, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, May 11, 2020 at 10:44 PM CEST, Alexei Starovoitov wrote:
> > On Mon, May 11, 2020 at 08:52:06PM +0200, Jakub Sitnicki wrote:
> >> Run a BPF program before looking up a listening socket on the receive path.
> >> Program selects a listening socket to yield as result of socket lookup by
> >> calling bpf_sk_assign() helper and returning BPF_REDIRECT code.
> >>
> >> Alternatively, program can also fail the lookup by returning with BPF_DROP,
> >> or let the lookup continue as usual with BPF_OK on return.
> >>
> >> This lets the user match packets with listening sockets freely at the last
> >> possible point on the receive path, where we know that packets are destined
> >> for local delivery after undergoing policing, filtering, and routing.
> >>
> >> With BPF code selecting the socket, directing packets destined to an IP
> >> range or to a port range to a single socket becomes possible.
> >>
> >> Suggested-by: Marek Majkowski <marek@cloudflare.com>
> >> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>  include/net/inet_hashtables.h | 36 +++++++++++++++++++++++++++++++++++
> >>  net/ipv4/inet_hashtables.c    | 15 ++++++++++++++-
> >>  2 files changed, 50 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> >> index 6072dfbd1078..3fcbc8f66f88 100644
> >> --- a/include/net/inet_hashtables.h
> >> +++ b/include/net/inet_hashtables.h
> >> @@ -422,4 +422,40 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >>
> >>  int inet_hash_connect(struct inet_timewait_death_row *death_row,
> >>                    struct sock *sk);
> >> +
> >> +static inline struct sock *bpf_sk_lookup_run(struct net *net,
> >> +                                         struct bpf_sk_lookup_kern *ctx)
> >> +{
> >> +    struct bpf_prog *prog;
> >> +    int ret = BPF_OK;
> >> +
> >> +    rcu_read_lock();
> >> +    prog = rcu_dereference(net->sk_lookup_prog);
> >> +    if (prog)
> >> +            ret = BPF_PROG_RUN(prog, ctx);
> >> +    rcu_read_unlock();
> >> +
> >> +    if (ret == BPF_DROP)
> >> +            return ERR_PTR(-ECONNREFUSED);
> >> +    if (ret == BPF_REDIRECT)
> >> +            return ctx->selected_sk;
> >> +    return NULL;
> >> +}
> >> +
> >> +static inline struct sock *inet_lookup_run_bpf(struct net *net, u8 protocol,
> >> +                                           __be32 saddr, __be16 sport,
> >> +                                           __be32 daddr, u16 dport)
> >> +{
> >> +    struct bpf_sk_lookup_kern ctx = {
> >> +            .family         = AF_INET,
> >> +            .protocol       = protocol,
> >> +            .v4.saddr       = saddr,
> >> +            .v4.daddr       = daddr,
> >> +            .sport          = sport,
> >> +            .dport          = dport,
> >> +    };
> >> +
> >> +    return bpf_sk_lookup_run(net, &ctx);
> >> +}
> >> +
> >>  #endif /* _INET_HASHTABLES_H */
> >> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> >> index ab64834837c8..f4d07285591a 100644
> >> --- a/net/ipv4/inet_hashtables.c
> >> +++ b/net/ipv4/inet_hashtables.c
> >> @@ -307,9 +307,22 @@ struct sock *__inet_lookup_listener(struct net *net,
> >>                                  const int dif, const int sdif)
> >>  {
> >>      struct inet_listen_hashbucket *ilb2;
> >> -    struct sock *result = NULL;
> >> +    struct sock *result, *reuse_sk;
> >>      unsigned int hash2;
> >>
> >> +    /* Lookup redirect from BPF */
> >> +    result = inet_lookup_run_bpf(net, hashinfo->protocol,
> >> +                                 saddr, sport, daddr, hnum);
> >> +    if (IS_ERR(result))
> >> +            return NULL;
> >> +    if (result) {
> >> +            reuse_sk = lookup_reuseport(net, result, skb, doff,
> >> +                                        saddr, sport, daddr, hnum);
> >> +            if (reuse_sk)
> >> +                    result = reuse_sk;
> >> +            goto done;
> >> +    }
> >> +
> >
> > The overhead is too high to do this all the time.
> > The feature has to be static_key-ed.
>
> Static keys is something that Lorenz has also suggested internally, but
> we wanted to keep it simple at first.
>
> Introduction of static keys forces us to decide when non-init_net netns
> are allowed to attach to SK_LOOKUP, as attaching enabling SK_LOOKUP in
> isolated netns will affect the rx path in init_net.
>
> I see two options, which seem sensible:
>
> 1) limit SK_LOOKUP to init_net, which makes testing setup harder, or
>
> 2) allow non-init_net netns to attach to SK_LOOKUP only if static key
>    has been already enabled (via sysctl?).
>
> >
> > Also please add multi-prog support. Adding it later will cause
> > all sorts of compatibility issues. The semantics of multi-prog
> > needs to be thought through right now.
> > For example BPF_DROP or BPF_REDIRECT could terminate the prog_run_array
> > sequence of progs while BPF_OK could continue.
> > It's not ideal, but better than nothing.
>
> I must say this approach is quite appealing because it's simple to
> explain. I would need a custom BPF_PROG_RUN_ARRAY, though.
>
> I'm curious what downside do you see here?
> Is overriding an earlier DROP/REDIRECT verdict useful?
>
> > Another option could be to execute all attached progs regardless
> > of return code, but don't let second prog override selected_sk blindly.
> > bpf_sk_assign() could get smarter.
>
> So if IIUC the rough idea here would be like below?
>
> - 1st program calls
>
>   bpf_sk_assign(ctx, sk1, 0 /*flags*/) -> 0 (OK)
>
> - 2nd program calls
>
>   bpf_sk_assign(ctx, sk2, 0) -> -EBUSY (already selected)
>   bpf_sk_assign(ctx, sk2, BPF_EXIST) -> 0 (OK, replace existing)
>
> In this case the last program to run has the final say, as opposed to
> the semantics where DROP/REDIRECT terminates.

Does sk_assign from TC also gain BPF_EXIST semantics? As you know,
I'm a bit concerned that TC and sk_lookup sk_assign are actually to completely
separate helpers. This is a good way to figure out if its a good idea to
overload the name, imo.

>
> Also, 2nd and subsequent programs would probably need to know if and
> which socket has been already selected. I think the selection could be
> exposed in context as bpf_sock pointer.
>
> I admit, I can't quite see the benefit of running thru all programs in
> array, so I'm tempted to go with terminate of DROP/REDIRECT in v3.
>
> >
> > Also please switch to bpf_link way of attaching. All system wide attachments
> > should be visible and easily debuggable via 'bpftool link show'.
> > Currently we're converting tc and xdp hooks to bpf_link. This new hook
> > should have it from the beginning.
>
> Will do in v3.
>
> Thanks for feedback,
> Jakub



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
