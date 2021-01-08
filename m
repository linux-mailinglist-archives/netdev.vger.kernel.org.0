Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7F92EF88A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 21:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbhAHUI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 15:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbhAHUI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 15:08:57 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CA0C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 12:08:17 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i18so10986194ioa.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 12:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/7vhBfbWwjZTlVotRGMfq7oEXppwYsgrQl2Fcy78obM=;
        b=oE5HoZHiBanuwKnE1UAjtkNWlvnVf8SROTnG7NFOtL0DUSfjmW3AcC3eeu2hjFd2YK
         3A1AuIZ/gQBRx2TVI+kt/4AYqiN3bEhnHifnNscIQu0EPOfJwoAICihKaQCYf026r6hd
         oNzLrxYI3OPCQV2QM085v1RCal+3TsagMknMlZXhpYUdyRFkfmYT9r1/a9FdPeA5kAvI
         SJKtpLTY0FJJPzgX/TJDdkDN4jwI8Jfsfhkx7HCRWiHTJOUkdIbaX6I/MmQmy+8T7ISs
         n6tcHtm4K9iKqdd1dg3CkqgsOSlmhG2feTBKP4HNqEg7ODPGAiWTND65bnbyrPp3LSaX
         jDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/7vhBfbWwjZTlVotRGMfq7oEXppwYsgrQl2Fcy78obM=;
        b=UkFfCxUbxOrwVd0Rd+CXhfvIBsySela2bbUfzuU02VgWwhHvbfDyYvfDoUfKV9Kkgm
         Kcpju5V2+LLPjAIHgGunhLDaERls3W9dmvYMZsd6iemYgZir0uJywnhSOyapMBIJ2HIp
         0dk9YG6uIV4CUwV5nvbcSbl5k3QnAtL98vVvNF20qhwfTvCgD5Csjj4RhM5GPf1rUYc0
         NGf3pFj1rNvgP6lAeER0mY6KWM5++n7YHDSdyN9Sss5U0Upk7Q3RS+VtrhRal2wa7DVB
         HKfjGX0FDTkibolEA6V5cIZtQXV5S/HDj9436lqI4SSuLEAV4PGUv5fd/d+T/LPGm4Qw
         SH+Q==
X-Gm-Message-State: AOAM533s/ffMF3S6HURLopbpOVMRLw1viRMcwqDVxOxWhYX5LaMc869B
        TJJUm3S/bzpQQNDnWcrgPd2aSFHe/8RKLCdzowDipA==
X-Google-Smtp-Source: ABdhPJwE/30GBoj6yfEe8eHF4WeDaOnO6TjY95FxJ5SC5OVPyxonCPGsYpEIBA2ElpcqXe5cvC0fB3gYi2cQCxTJEp8=
X-Received: by 2002:a6b:928b:: with SMTP id u133mr6599931iod.145.1610136496255;
 Fri, 08 Jan 2021 12:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
 <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
 <CAKH8qBsWsKVxAyvhEYqXytTFMGEN=C3ZMKBPLs2RKcEpM4hXXQ@mail.gmail.com>
 <CANn89iKv1aKE3Tcyr-vqv2mHeDompWjUn6txeK-qEO6-G-pBBw@mail.gmail.com>
 <CAKH8qBuGi_7eFpX0y+HdJznMvUxZsrJtdz2O5P4WK-4H_8s8Xw@mail.gmail.com>
 <CANn89iL9L_6MyZ2qYM8pGmNqjfP25mO_wMAtb7ixp+dweBS0vw@mail.gmail.com> <CAKH8qBsuea-HbfDD4AB0sMgT2Gn-0P3xw0CdaTcoytRAGLa4zg@mail.gmail.com>
In-Reply-To: <CAKH8qBsuea-HbfDD4AB0sMgT2Gn-0P3xw0CdaTcoytRAGLa4zg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 21:08:03 +0100
Message-ID: <CANn89iJvGjtVD02MZPKwCkZ5raBDG4_SpejBGtdvSJ63XrqPww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 8:27 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Jan 8, 2021 at 8:08 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > On Fri, Jan 8, 2021 at 10:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, Jan 8, 2021 at 7:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > >
> > > > > On Fri, Jan 8, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > > >
> > > > > > On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > > >
> > > > > > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > > > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > > > > 3% overhead for locking/unlocking the socket.
> > > > > > >
> > > > > > > Without this patch:
> > > > > > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > > > > > >             |
> > > > > > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > > > > > >                        |
> > > > > > >                         --0.81%--__kmalloc
> > > > > > >
> > > > > > > With the patch applied:
> > > > > > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > > > > > >
> > > > > >
> > > > > >
> > > > > > OK but we are adding yet another indirect call.
> > > > > >
> > > > > > Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?
> > > > > Sure, but do you think it will bring any benefit?
> > > >
> > > > Sure, avoiding an indirect call might be the same gain than the
> > > > lock_sock() avoidance :)
> > > >
> > > > > We don't have any indirect avoidance in __sys_getsockopt for the
> > > > > sock->ops->getsockopt() call.
> > > > > If we add it for this new bpf_bypass_getsockopt, we might as well add
> > > > > it for sock->ops->getsockopt?
> > > >
> > > > Well, that is orthogonal to this patch.
> > > > As you may know, Google kernels do have a mitigation there already and
> > > > Brian may upstream it.
> > > I guess my point here was that if I send it out only for bpf_bypass_getsockopt
> > > it might look a bit strange because the rest of the getsockopt still
> > > suffers the indirect costs.
> >
> >
> > Each new indirect call adds a cost. If you focus on optimizing
> > TCP_ZEROCOPY_RECEIVE,
> > it is counter intuitive adding an expensive indirect call.
> Ok, then let me resend with a mitigation in place and a note
> that the rest will be added later.
>
> >  If Brian has plans to upstream the rest, maybe
> > > it's better to upstream everything together with some numbers?
> > > CC'ing him for his opinion.
> >
> > I am just saying your point about the other indirect call is already taken care.
> >
> > >
> > > I'm happy to follow up in whatever form is best. I can also resend
> > > with INDIRECT_CALL_INET2 if there are no objections in including
> > > this version from the start.
> > >
> >
> > INDIRECT_CALL_INET2 seems a strange name to me.
> Any suggestion for a better name? I did play with the following:
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index cbba9c9ab073..f7342a30284c 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -371,7 +371,9 @@ int bpf_percpu_cgroup_storage_update(struct
> bpf_map *map, void *key,
>         int __ret = retval;                                                    \
>         if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))                         \
>                 if (!(sock)->sk_prot->bpf_bypass_getsockopt ||                 \
> -                   !(sock)->sk_prot->bpf_bypass_getsockopt(level, optname))   \
> +
> !INDIRECT_CALL_INET1((sock)->sk_prot->bpf_bypass_getsockopt, \
> +                                       tcp_bpf_bypass_getsockopt,             \
> +                                       level, optname))                       \
>                         __ret = __cgroup_bpf_run_filter_getsockopt(            \
>                                 sock, level, optname, optval, optlen,          \
>                                 max_optlen, retval);                           \
> diff --git a/include/linux/indirect_call_wrapper.h
> b/include/linux/indirect_call_wrapper.h
> index 54c02c84906a..9c3252f7e9bb 100644
> --- a/include/linux/indirect_call_wrapper.h
> +++ b/include/linux/indirect_call_wrapper.h
> @@ -54,10 +54,13 @@
>  #if IS_BUILTIN(CONFIG_IPV6)
>  #define INDIRECT_CALL_INET(f, f2, f1, ...) \
>         INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__)
> +#define INDIRECT_CALL_INET1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
>  #elif IS_ENABLED(CONFIG_INET)
>  #define INDIRECT_CALL_INET(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
> +#define INDIRECT_CALL_INET1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
>  #else
>  #define INDIRECT_CALL_INET(f, f2, f1, ...) f(__VA_ARGS__)
> +#define INDIRECT_CALL_INET1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
>  #endif
>
>  #endif

Yes, or maybe something only focusing on CONFIG_INET to make it clear.

diff --git a/include/linux/indirect_call_wrapper.h
b/include/linux/indirect_call_wrapper.h
index 54c02c84906ab2548a93bacb46f7795a8e136d83..d082aa4bd3ecae52e5998b3ac05deffafcb45de0
100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -46,6 +46,12 @@
 #define INDIRECT_CALLABLE_SCOPE                static
 #endif

+#elif IS_ENABLED(CONFIG_INET)
+#define INDIRECT_CALL_INET1(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_INET1(f, f2, f1, ...) f(__VA_ARGS__)
+#endif
+
 /*
  * We can use INDIRECT_CALL_$NR for ipv6 related functions only if ipv6 is
  * builtin, this macro simplify dealing with indirect calls with only ipv4/ipv6
