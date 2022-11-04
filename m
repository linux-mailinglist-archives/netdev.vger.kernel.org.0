Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD43619E1C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiKDRGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiKDRGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:06:45 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360A631FA0
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:06:44 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-367cd2807f2so49443617b3.1
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uh2Soqcix5NF4+gCA5HXepCepNj3tY45FfqIOXMoSa0=;
        b=ogeWQukOaRtpW/g5+B8JjKag8ZQd2pKV7FnS1McLPACz4Fl7GCI1jzTDRlTVtMTN/v
         CeFaqhO4h/paTdV9pAcLhWvVuX6IWxdlw1d98k65P4WYuZ5wN9pgH9H+BInFuJTBvyz3
         ZWwTo5TEQcKq50mRoc7vH24ad+gxRVqenCH1UQn0cxen5Lwqc7lqthHJptv6Q7fynV16
         CDrXyEmvybW6EzxA8sVwZ7wbUg+rtuGzSP9wcau/OjhcJbrvqwqd75kXhjlQ4Wx0AaLL
         9bb0+thT8ugs3NvsuexF+OPLyh0vUC90BjeUsJkq22K/Uc4U1OVBe1MYRhlcjILM4UTl
         FtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uh2Soqcix5NF4+gCA5HXepCepNj3tY45FfqIOXMoSa0=;
        b=dYqLYDwopjk4EtYOwMExWOKzOVcJ4IMmLXv4qnLYXZd9TlNJMeJrWI6zZNcYVVPW/o
         XnESRROryZOnjCo7wnZSkaVX9hFlIAoBld0zXS38eYpz6lhZ6skGF+s88/99ompFM9Hi
         Nd+SalRt94CP8+C/OmGLW95nuCKkhvvzNOY6S0lC17ZfDHpS3MMhw1b/Vu0FFZCQUuhT
         OaP5fpKrU8KHZf0duyGkQu6aLboJtYdgg+7VxFJw9U78eMvCO3HpJvmNyMI7md0hsyZD
         fSetxoPKOFg5/ubTHGQ7wKt5KRchp60zXt9ttQKwMcpXPKnusJCZkM/9MSjYfefaQdZu
         bS8w==
X-Gm-Message-State: ACrzQf3PCtuyHWlAevswfkZAhm19NUtl59dLrmbDp1vZlX50zMWdSVTt
        APxD4IjA4e6ESaSwEYnWYxzRPtT50VGwnjZFARahZg==
X-Google-Smtp-Source: AMsMyM5fulznOy0WkME0p6/ckcRkBb2ufpSlRYzkvA0Cr6xRpbyJ7kzo/KNTsjaMAUh3HbHLY/xWtfl+i7078Lfe3uE=
X-Received: by 2002:a81:4811:0:b0:368:e6a7:6b38 with SMTP id
 v17-20020a814811000000b00368e6a76b38mr35079787ywa.20.1667581603227; Fri, 04
 Nov 2022 10:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221102081620.1465154-1-zhongbaisong@huawei.com>
In-Reply-To: <20221102081620.1465154-1-zhongbaisong@huawei.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 4 Nov 2022 18:06:05 +0100
Message-ID: <CAG_fn=UDAjNd2xFrRxSVyLTZOAGapjSq2Zu5Xht12JNq-A7S=A@mail.gmail.com>
Subject: Re: [PATCH -next,v2] bpf, test_run: fix alignment problem in bpf_prog_test_run_skb()
To:     Baisong Zhong <zhongbaisong@huawei.com>, elver@google.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     edumazet@google.com, keescook@chromium.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 9:16 AM Baisong Zhong <zhongbaisong@huawei.com> wrot=
e:
>
> we got a syzkaller problem because of aarch64 alignment fault
> if KFENCE enabled.
>
> When the size from user bpf program is an odd number, like
> 399, 407, etc, it will cause the struct skb_shared_info's
> unaligned access. As seen below:
>
> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/skbu=
ff.c:1032

It's interesting that KFENCE is reporting a UAF without a deallocation
stack here.

Looks like an unaligned access to 0xffff6254fffac077 causes the ARM
CPU to throw a fault handled by __do_kernel_fault()
This isn't technically a page fault, but anyway the access address
gets passed to kfence_handle_page_fault(), which defaults to a
use-after-free, because the address belongs to the object page, not
the redzone page.

Catalin, Mark, what is the right way to only handle traps caused by
reading/writing to a page for which `set_memory_valid(addr, 1, 0)` was
called?

> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
>  __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
>  arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
>  arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
>  atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
>  __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
>  skb_clone+0xf4/0x214 net/core/skbuff.c:1481
>  ____bpf_clone_redirect net/core/filter.c:2433 [inline]
>  bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
>  bpf_prog_d3839dd9068ceb51+0x80/0x330
>  bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
>  bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
>  bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
>  bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>  __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>  __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
>
> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=3D407, cache=3Dk=
malloc-512
>
> allocated by task 15074 on cpu 0 at 1342.585390s:
>  kmalloc include/linux/slab.h:568 [inline]
>  kzalloc include/linux/slab.h:675 [inline]
>  bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
>  bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
>  bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
>  __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
>  __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
>  __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
>
> To fix the problem, we adjust @size so that (@size + @hearoom) is a
> multiple of SMP_CACHE_BYTES. So we make sure the struct skb_shared_info
> is aligned to a cache line.
>
> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> ---
> v2: use SKB_DATA_ALIGN instead kmalloc_size_roundup
> ---
>  net/bpf/test_run.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 4b855af267b1..bfdd7484b93f 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -259,6 +259,7 @@ static void *bpf_test_init(const union bpf_attr *katt=
r, u32 size,
>         if (user_size > size)
>                 return ERR_PTR(-EMSGSIZE);
>
> +       size =3D SKB_DATA_ALIGN(size);
>         data =3D kzalloc(size + headroom + tailroom, GFP_USER);
>         if (!data)
>                 return ERR_PTR(-ENOMEM);
> --
> 2.25.1
>


--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
