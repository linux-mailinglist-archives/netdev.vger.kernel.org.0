Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8AB485338
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiAENHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236830AbiAENHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:07:01 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2179C061761;
        Wed,  5 Jan 2022 05:07:00 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id z9so91825987edm.10;
        Wed, 05 Jan 2022 05:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WnNpFiRXIcbe/rQ88mzpqZm3Y+nspDIbixstGluci7A=;
        b=pfpod37ny0k6n+YjaesFuw2FbJmXlSV4dPobriBgBQxhnB69Wl+WH1oG7S82S2yq2X
         mcAtWS8ZqrREZCPm9Ix9sSk3u+EFjI79zCEt0vdgV2qXBVjIhk3im0xv2WFrrB1o0DP7
         OYmmJPYZGhrmSNi5vNIfLGwRu7Wy3MUrwB3XENFie4ppriIuIQ0KYX9/GvspopDSaFEY
         +2pFcYaP/kKLszrXWwvqz2b36BKMCQfYZXM1Mb+TDTdkme8CgCtJy34O5EXXREfEUa+z
         66jmQgVvUd9neaih7HYehix0sCKcYwd9Xb7onAQbcC/NBiaA3Az11TptE62O+U6/IBT9
         hQ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WnNpFiRXIcbe/rQ88mzpqZm3Y+nspDIbixstGluci7A=;
        b=X7hSgCJAU6zFihnixkIYWXb9FE7g5MtgOp2Dgy6SG+NccIyf9gBTW5gQhBQSDrRuDy
         1BQ9dceyJ6CFH3TJ/qtmNPIQmQ0ixlN4+dkTAFQtWLFIzAH9UCcXCDzP36HoiYVzsI4B
         9yJfUQ7aJTTWRQ2saGudhrAzel8o4KQpfA/sL/lkZynzBsk1zsAPUYjebwL35CIvA/k1
         b/+tm67KXiJJXFMFJ6GiP8blbet1Djin+Lg0ZYuxY9uVm8/mJ2KSKNFq2SkGUQZryq1d
         dk3xiFF1Y1bwa/NthtmRSvowVgBohktVsvBJcZILwMkyGmlqOFID+RHVCwtnxGMZ5xiI
         /L+w==
X-Gm-Message-State: AOAM533rOdrRJio/2wzhVRrmPHxFNlwbrdF4fErfInCA3b3dLgAyTABb
        Iy0+Q7eAne6H2R/i4YBGMauIG99vbRiaWukJci4=
X-Google-Smtp-Source: ABdhPJzg7Pyai++3/6t0wLyt+p4dh9JqbkdiR+BepUJpIJ4cfmb2VRJvuHA0eclte6uT2u0Abhl6sL+huMVq3GKwayk=
X-Received: by 2002:a17:906:9912:: with SMTP id zl18mr751316ejb.348.1641388019538;
 Wed, 05 Jan 2022 05:06:59 -0800 (PST)
MIME-Version: 1.0
References: <20211230080305.1068950-1-imagedong@tencent.com>
 <20211230080305.1068950-2-imagedong@tencent.com> <5cf64605-7005-ac06-6ee1-18547910697a@iogearbox.net>
In-Reply-To: <5cf64605-7005-ac06-6ee1-18547910697a@iogearbox.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 5 Jan 2022 21:03:13 +0800
Message-ID: <CADxym3aBqBPAMT59dbDoAHvVyXq9ZQBc99Z+kje40UmzHUp+QQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] net: bpf: handle return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 9:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/30/21 9:03 AM, menglong8.dong@gmail.com wrote:
> [...]
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 44cc25f0bae7..f5fc0432374e 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1209,6 +1209,7 @@ struct proto {
> >       void                    (*unhash)(struct sock *sk);
> >       void                    (*rehash)(struct sock *sk);
> >       int                     (*get_port)(struct sock *sk, unsigned short snum);
> > +     void                    (*put_port)(struct sock *sk);
> >   #ifdef CONFIG_BPF_SYSCALL
> >       int                     (*psock_update_sk_prot)(struct sock *sk,
> >                                                       struct sk_psock *psock,
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 5d18d32557d2..8784e72d4b8b 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -531,6 +531,8 @@ int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >                       err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
> >                       if (err) {
> >                               inet->inet_saddr = inet->inet_rcv_saddr = 0;
> > +                             if (sk->sk_prot->get_port)
> > +                                     sk->sk_prot->put_port(sk);
> >                               goto out_release_sock;
> >                       }
> >               }
> [...]
> > diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> > index d1636425654e..ddfc6821e682 100644
> > --- a/net/ipv6/af_inet6.c
> > +++ b/net/ipv6/af_inet6.c
> > @@ -413,6 +413,8 @@ static int __inet6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> >                       if (err) {
> >                               sk->sk_ipv6only = saved_ipv6only;
> >                               inet_reset_saddr(sk);
> > +                             if (sk->sk_prot->get_port)
> > +                                     sk->sk_prot->put_port(sk);
> >                               goto out;
> >                       }
> >               }
>
> I presume both tests above should test for non-zero sk->sk_prot->put_port
> callback given that is what they end up calling when true, no?
>

You are right, I think that I made a big mistake here...:/

Thanks!
Menglong Dong
