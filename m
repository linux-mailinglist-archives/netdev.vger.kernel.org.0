Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A579A2EF81A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbhAHT1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbhAHT1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 14:27:40 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2740CC061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 11:27:00 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id p14so9480983qke.6
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 11:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r3YWZKOsbKHdcfW5cDuSwubW/xGwJ2ZqokaG99gSdTg=;
        b=D8Rfdfg2utOln5e+sUKnih8x/0abAxpSzRsCg0h3UgsTV3RvgTbR2LLWY76z1RcZQs
         iBpiX9e6KqBcD/O3pdh+3zYxT3hyvypBRVOoolVeKIqp+JVx/pdPB4f05IuY6MHwKxTR
         /kK2ITakWNLXo9CQyxo6aI+F6sYIYOoyIhdmChdN2/dGt21f/iGPH6SbZ/Wm07TvokdY
         5RQRwZ9fiyFmqMNm9q9VcBNhcYCPuU/A6kpJ+wjWDyFUBcHzx1qCAAFvSyILnweKXWZ6
         DRlxuFsmsnhcuVnnCelq5dLOvJ+21m+gnSZFf90bm/vKEQ5sU2QLnxXign8yH2h/bcxe
         bN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r3YWZKOsbKHdcfW5cDuSwubW/xGwJ2ZqokaG99gSdTg=;
        b=MRAwM0oxb3E/nWaVilraEjdNZIO73ws+zB6ltjQNnJSjqR+I+Mh2GTNW5PzR9fJUGz
         zgBc5isUrz6NA6WDwYDfn+B/X5/Ob8kUAZRfIbRpaWcgpNJCSdkykq2DMGOa6wfrnlch
         0UKRhWhNRlEmX/1cnmIasCmW0b1wl3mXNoTvVHdGC1txdL5Xgdapqa3ur6B9n01HTU/h
         YVkOWb8jYTwsCJaHLQ26m3+9A0/wIYxdscYOnL2sY3jct+gjITgGPpTRJh1tqXJDfB7j
         hhUgp/vFUj0nmJLAmVV/qjI1ymqn+Tvwg7qlQH5twfWmoCt3AySve87vjRMXz9LdOzhV
         hfeQ==
X-Gm-Message-State: AOAM533dzG3k9WyEagavpUlLFeagMcRUdC3JtzLxeUoRdGMvQBK7HwFt
        m2CdQX3V3xawItDTSd2KEEbZhRkAmCpfxeGc0jGVeA==
X-Google-Smtp-Source: ABdhPJwTkv6X3cWmZOIcFxWHWAj3c+37hg/v3tmT3ydBhmV++EVFunI+g2I0EuZmp1oldw7RtxPIhJuhZphr4boTCXs=
X-Received: by 2002:a37:a516:: with SMTP id o22mr5532131qke.17.1610134019074;
 Fri, 08 Jan 2021 11:26:59 -0800 (PST)
MIME-Version: 1.0
References: <20210108180333.180906-1-sdf@google.com> <20210108180333.180906-2-sdf@google.com>
 <CANn89i+GvEUmoapF+C0Mf1qw+AuWhU5_MMPz-jy8fND0HmUJ=Q@mail.gmail.com>
 <CAKH8qBsWsKVxAyvhEYqXytTFMGEN=C3ZMKBPLs2RKcEpM4hXXQ@mail.gmail.com>
 <CANn89iKv1aKE3Tcyr-vqv2mHeDompWjUn6txeK-qEO6-G-pBBw@mail.gmail.com>
 <CAKH8qBuGi_7eFpX0y+HdJznMvUxZsrJtdz2O5P4WK-4H_8s8Xw@mail.gmail.com> <CANn89iL9L_6MyZ2qYM8pGmNqjfP25mO_wMAtb7ixp+dweBS0vw@mail.gmail.com>
In-Reply-To: <CANn89iL9L_6MyZ2qYM8pGmNqjfP25mO_wMAtb7ixp+dweBS0vw@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 8 Jan 2021 11:26:47 -0800
Message-ID: <CAKH8qBsuea-HbfDD4AB0sMgT2Gn-0P3xw0CdaTcoytRAGLa4zg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/3] bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
To:     Eric Dumazet <edumazet@google.com>
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

On Fri, Jan 8, 2021 at 11:23 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jan 8, 2021 at 8:08 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Fri, Jan 8, 2021 at 10:41 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, Jan 8, 2021 at 7:26 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > On Fri, Jan 8, 2021 at 10:10 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Fri, Jan 8, 2021 at 7:03 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > > > >
> > > > > > Add custom implementation of getsockopt hook for TCP_ZEROCOPY_RECEIVE.
> > > > > > We skip generic hooks for TCP_ZEROCOPY_RECEIVE and have a custom
> > > > > > call in do_tcp_getsockopt using the on-stack data. This removes
> > > > > > 3% overhead for locking/unlocking the socket.
> > > > > >
> > > > > > Without this patch:
> > > > > >      3.38%     0.07%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt
> > > > > >             |
> > > > > >              --3.30%--__cgroup_bpf_run_filter_getsockopt
> > > > > >                        |
> > > > > >                         --0.81%--__kmalloc
> > > > > >
> > > > > > With the patch applied:
> > > > > >      0.52%     0.12%  tcp_mmap  [kernel.kallsyms]  [k] __cgroup_bpf_run_filter_getsockopt_kern
> > > > > >
> > > > >
> > > > >
> > > > > OK but we are adding yet another indirect call.
> > > > >
> > > > > Can you add a patch on top of it adding INDIRECT_CALL_INET() avoidance ?
> > > > Sure, but do you think it will bring any benefit?
> > >
> > > Sure, avoiding an indirect call might be the same gain than the
> > > lock_sock() avoidance :)
> > >
> > > > We don't have any indirect avoidance in __sys_getsockopt for the
> > > > sock->ops->getsockopt() call.
> > > > If we add it for this new bpf_bypass_getsockopt, we might as well add
> > > > it for sock->ops->getsockopt?
> > >
> > > Well, that is orthogonal to this patch.
> > > As you may know, Google kernels do have a mitigation there already and
> > > Brian may upstream it.
> > I guess my point here was that if I send it out only for bpf_bypass_getsockopt
> > it might look a bit strange because the rest of the getsockopt still
> > suffers the indirect costs.
>
>
> Each new indirect call adds a cost. If you focus on optimizing
> TCP_ZEROCOPY_RECEIVE,
> it is counter intuitive adding an expensive indirect call.
Ok, then let me resend with a mitigation in place and a note
that the rest will be added later.

>  If Brian has plans to upstream the rest, maybe
> > it's better to upstream everything together with some numbers?
> > CC'ing him for his opinion.
>
> I am just saying your point about the other indirect call is already taken care.
>
> >
> > I'm happy to follow up in whatever form is best. I can also resend
> > with INDIRECT_CALL_INET2 if there are no objections in including
> > this version from the start.
> >
>
> INDIRECT_CALL_INET2 seems a strange name to me.
Any suggestion for a better name? I did play with the following:
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index cbba9c9ab073..f7342a30284c 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -371,7 +371,9 @@ int bpf_percpu_cgroup_storage_update(struct
bpf_map *map, void *key,
        int __ret = retval;                                                    \
        if (cgroup_bpf_enabled(BPF_CGROUP_GETSOCKOPT))                         \
                if (!(sock)->sk_prot->bpf_bypass_getsockopt ||                 \
-                   !(sock)->sk_prot->bpf_bypass_getsockopt(level, optname))   \
+
!INDIRECT_CALL_INET1((sock)->sk_prot->bpf_bypass_getsockopt, \
+                                       tcp_bpf_bypass_getsockopt,             \
+                                       level, optname))                       \
                        __ret = __cgroup_bpf_run_filter_getsockopt(            \
                                sock, level, optname, optval, optlen,          \
                                max_optlen, retval);                           \
diff --git a/include/linux/indirect_call_wrapper.h
b/include/linux/indirect_call_wrapper.h
index 54c02c84906a..9c3252f7e9bb 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -54,10 +54,13 @@
 #if IS_BUILTIN(CONFIG_IPV6)
 #define INDIRECT_CALL_INET(f, f2, f1, ...) \
        INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__)
+#define INDIRECT_CALL_INET1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
 #elif IS_ENABLED(CONFIG_INET)
 #define INDIRECT_CALL_INET(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#define INDIRECT_CALL_INET1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
 #else
 #define INDIRECT_CALL_INET(f, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_INET1(f, f1, ...) f(__VA_ARGS__)
 #endif

 #endif
