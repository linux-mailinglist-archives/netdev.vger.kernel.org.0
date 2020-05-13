Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5E41D17EB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389053AbgEMOug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEMOuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:50:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55150C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:50:34 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d207so9118387wmd.0
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=TUEpwpSDFGgC3x9maBBnlgNMRt3v6jbZxvQQyQHEr94=;
        b=mqAu3uxQJ3WAVXZdGPToexP6dCKb1KkTpzbqzxgGNgVjQbzSlpAEeMHze784WSHA14
         i7Iy6p4o008iEFpZAvMKY03rdpb+krznrOEkwutqAggicsMeRChHixnoQhRg50f2JJG4
         BfAEGj3YK2PxreG/i/Z5eOMbYqhrIznOty49U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=TUEpwpSDFGgC3x9maBBnlgNMRt3v6jbZxvQQyQHEr94=;
        b=LWm31kqkwlC8nZdNUlq8JBg/M1b7ASQExcS6if3VsD3daZn/odrpbqNIfp4L1yNr6S
         KQHIgpkBt1GTlyHvnwGtv1TPAWltfGG3y6/OrhmW9zV5XXJ8p4EZn3ILgwP6O0Q/5DAG
         p4P7PBkt6AGKTaF6a9y5E9KEPjGLHxkCEGwDJzJFpQdhQ5tIgj7mgyBoZze+F3QiFCRz
         qJdCT2t2tM0+Cu1Wt47qXY3SGyLlblWZH/TSYWRIJcyUAlCRxZ4Rp3rNGBqwmV1gUdb4
         gL9T8J4gOb5VSPG3wCPj0i9BGqhYxh31s33uy3lqcRKor7EJ0ao6v6oYkJ1DaSHTtUWZ
         supg==
X-Gm-Message-State: AGi0PubYviPcPw6pz50wBuzRr8mETQLFdLyhxCNca0NBqrrU37J6RdNg
        Ac/+4UedfumN5KeopPTsEVf6UJDp4YA=
X-Google-Smtp-Source: APiQypL+bxJyLq2YUDmTZRD1wYbjoKbIlxzkzC7wDLXrPFaI7EFQKr1tpl39HG4/Ec+TnjZmJDQMbg==
X-Received: by 2002:a1c:208e:: with SMTP id g136mr31578523wmg.80.1589381432946;
        Wed, 13 May 2020 07:50:32 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 88sm28481480wrq.77.2020.05.13.07.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 07:50:32 -0700 (PDT)
References: <20200511185218.1422406-1-jakub@cloudflare.com> <20200511185218.1422406-6-jakub@cloudflare.com> <20200511204445.i7sessmtszox36xd@ast-mbp> <871rnpuuob.fsf@cloudflare.com> <CACAyw98ngR+nQdg-MYhGMqQkdhyOGOcWQB+fgy8eTGwKj9-Rzg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
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
Subject: Re: [PATCH bpf-next v2 05/17] inet: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <CACAyw98ngR+nQdg-MYhGMqQkdhyOGOcWQB+fgy8eTGwKj9-Rzg@mail.gmail.com>
Date:   Wed, 13 May 2020 16:50:30 +0200
Message-ID: <87v9kzubwp.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 04:21 PM CEST, Lorenz Bauer wrote:
> On Tue, 12 May 2020 at 14:52, Jakub Sitnicki <jakub@cloudflare.com> wrote:

[...]

>> So if IIUC the rough idea here would be like below?
>>
>> - 1st program calls
>>
>>   bpf_sk_assign(ctx, sk1, 0 /*flags*/) -> 0 (OK)
>>
>> - 2nd program calls
>>
>>   bpf_sk_assign(ctx, sk2, 0) -> -EBUSY (already selected)
>>   bpf_sk_assign(ctx, sk2, BPF_EXIST) -> 0 (OK, replace existing)
>>
>> In this case the last program to run has the final say, as opposed to
>> the semantics where DROP/REDIRECT terminates.
>
> Does sk_assign from TC also gain BPF_EXIST semantics? As you know,
> I'm a bit concerned that TC and sk_lookup sk_assign are actually to compl=
etely
> separate helpers. This is a good way to figure out if its a good idea to
> overload the name, imo.

I don't have a strong opinion here. We could have a dedicated helper.

Personally I'm not finding it confusing. As a BPF user you know what
program type you're working with (TC vs SK_LOOKUP), and both helper
variants will be documented separately in the bpf-helpers man-page, like
so:

       int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64
       flags)

              Description
                     Helper is overloaded  depending  on  BPF  program
                     type.     This     description     applies     to
                     BPF_PROG_TYPE_SCHED_CLS                       and
                     BPF_PROG_TYPE_SCHED_ACT programs.

                     Assign  the  sk  to  the  skb. When combined with
                     appropriate routing configuration to receive  the
                     packet  towards  the socket, will cause skb to be
                     delivered to the  specified  socket.   Subsequent
                     redirection    of    skb   via    bpf_redirect(),
                     bpf_clone_redirect() or other methods outside  of
                     BPF may interfere with successful delivery to the
                     socket.

                     This operation is  only  valid  from  TC  ingress
                     path.

                     The flags argument must be zero.

              Return 0  on  success,  or  a  negative errno in case of
                     failure.

                     =C2=B7 -EINVAL           Unsupported flags specified.

                     =C2=B7 -ENOENT            Socket  is  unavailable  for
                       assignment.

                     =C2=B7 -ENETUNREACH       Socket is unreachable (wrong
                       netns).

                     =C2=B7

                       -EOPNOTSUPP Unsupported operation, for  example
                       a
                              call from outside of TC ingress.

                     =C2=B7 -ESOCKTNOSUPPORT   Socket  type  not  supported
                       (reuseport).

       int bpf_sk_assign(struct bpf_sk_lookup  *ctx,  struct  bpf_sock
       *sk, u64 flags)

              Description
                     Helper  is  overloaded  depending  on BPF program
                     type.     This     description     applies     to
                     BPF_PROG_TYPE_SK_LOOKUP programs.

                     Select the sk as a result of a socket lookup.

                     For  the  operation to succeed passed socket must
                     be compatible with the  packet  description  pro=E2=80=
=90
                     vided by the ctx object.

                     L4  protocol (IPPROTO_TCP or IPPROTO_UDP) must be
                     an exact  match.  While  IP  family  (AF_INET  or
                     AF_INET6)  must be compatible, that is IPv6 sock=E2=80=
=90
                     ets that are not v6-only can be selected for IPv4
                     packets.

                     Only TCP listeners and UDP sockets, that is sock=E2=80=
=90
                     ets which have SOCK_RCU_FREE  flag  set,  can  be
                     selected.

                     The flags argument must be zero.

              Return 0  on  success,  or  a  negative errno in case of
                     failure.

                     -EAFNOSUPPORT is socket  family  (sk->family)  is
                     not compatible with packet family (ctx->family).

                     -EINVAL if unsupported flags were specified.

                     -EPROTOTYPE  if socket L4 protocol (sk->protocol)
                     doesn't match packet protocol (ctx->protocol).

                     -ESOCKTNOSUPPORT if socket does not use RCU free=E2=80=
=90
                     ing.

But it would be helpful to hear what others think about it.
