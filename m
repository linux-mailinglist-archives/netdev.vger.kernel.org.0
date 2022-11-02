Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C667E615B89
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiKBEh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKBEh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:37:27 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023A71AE
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 21:37:23 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-370547b8ca0so76042227b3.0
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 21:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kl7jVJ5y1oJ5tW7Nuyev1s6MjsKIGw83WGsKI/onrLQ=;
        b=Q0MGEOK+oOLZwpq9uwgU9Peye3A1IVvgxAaaw7txILYll0hfqC/5PrjNU9exdDMF3Z
         Dqs5Yj8pNaX5TXUV1ExT0o2U2+nMhMe9f3dhxcnYzdub/LlUgURhjm0MRIBDEe2BtIku
         KYyT5a3Iz+EA3j2WWL9wQcxsEj+ZPs2K3aMqA1sQwZ/Np0t+RmmSf3q74+YpQNuKjSLZ
         FWD8WQnxBJsvEoJsHiR72J5o7Vd+jknYYSTInuf+clvGRb4K3jn+5MBGU4ozjP2fsZf8
         ZeWVaGGirdm8CWQvgu5q8ePPwr1yQmwo5Btfv5ZQr6L+HtRWRcvLtJDsPy09qvmSVvik
         Piig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kl7jVJ5y1oJ5tW7Nuyev1s6MjsKIGw83WGsKI/onrLQ=;
        b=1n2dN+tIbJ2+QpOkBQJwuBwf3nfGTRbGGtUU8gF/Y1zUcca942ma/DVh0Dxe7aOeDR
         RiEGoWZt3mzKWeQWiHEm8rTh3B7tn/UP6Y40oKRAUzTxAJEtFqG248d0kTfKNpiM0d4F
         4js4oqhiKC3khDHSm14Hm9lN3SRqezotg9E83slO7SV+RU7ykeijvbWzBAGSjgRWm+sl
         PUziVxkEQzURp5iZzDLHTzaiy+AHloIS3NScuUiKUVWwXLHjT2Aou7a+m3iQuSMpsEJx
         0bWTAlaSn54Yk/FchGZuqkhizmGvjzhF60uXy7d4869lO9XpsjBjSweJ1t7vPmAaRKHZ
         1eJw==
X-Gm-Message-State: ACrzQf0i9u2GyklWFrd/3FlzqOsUvqehLyske+V5b0KAIwsPDGtWvWDR
        iQVxse1sChi/8dRSJjrx3JzaFYscKa9Jzeidf6nyqw==
X-Google-Smtp-Source: AMsMyM6j1szn06dZj2dfYwuGMkz2Ci3yBeV/a3S/Ue5Qnj/mNeMCZVW3DJoUD3U22hGeNDj8O044zJY4Wk9rzZZtFpI=
X-Received: by 2002:a81:7585:0:b0:368:28bd:9932 with SMTP id
 q127-20020a817585000000b0036828bd9932mr20627557ywc.332.1667363841841; Tue, 01
 Nov 2022 21:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221101040440.3637007-1-zhongbaisong@huawei.com>
 <eca17bfb-c75f-5db1-f194-5b00c2a0c6f2@iogearbox.net> <ca6253bd-dcf4-2625-bc41-4b9a7774d895@huawei.com>
 <20221101210542.724e3442@kernel.org> <202211012121.47D68D0@keescook>
In-Reply-To: <202211012121.47D68D0@keescook>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Nov 2022 21:37:10 -0700
Message-ID: <CANn89i+FVN95uvftTJteZgGQ_sSb6452XXZn0veNjHHKZ2yEFQ@mail.gmail.com>
Subject: Re: [PATCH -next] bpf, test_run: fix alignment problem in bpf_prog_test_run_skb()
To:     Kees Cook <keescook@chromium.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        zhongbaisong <zhongbaisong@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        song@kernel.org, yhs@fb.com, haoluo@google.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux MM <linux-mm@kvack.org>, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 1, 2022 at 9:27 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Nov 01, 2022 at 09:05:42PM -0700, Jakub Kicinski wrote:
> > On Wed, 2 Nov 2022 10:59:44 +0800 zhongbaisong wrote:
> > > On 2022/11/2 0:45, Daniel Borkmann wrote:
> > > > [ +kfence folks ]
> > >
> > > + cc: Alexander Potapenko, Marco Elver, Dmitry Vyukov
> > >
> > > Do you have any suggestions about this problem?
> >
> > + Kees who has been sending similar patches for drivers
> >
> > > > On 11/1/22 5:04 AM, Baisong Zhong wrote:
> > > >> Recently, we got a syzkaller problem because of aarch64
> > > >> alignment fault if KFENCE enabled.
> > > >>
> > > >> When the size from user bpf program is an odd number, like
> > > >> 399, 407, etc, it will cause skb shard info's alignment access,
> > > >> as seen below:
> > > >>
> > > >> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0
> > > >> net/core/skbuff.c:1032
> > > >>
> > > >> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
> > > >>   __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
> > > >>   arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
> > > >>   arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
> > > >>   atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
> > > >>   __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
> > > >>   skb_clone+0xf4/0x214 net/core/skbuff.c:1481
> > > >>   ____bpf_clone_redirect net/core/filter.c:2433 [inline]
> > > >>   bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
> > > >>   bpf_prog_d3839dd9068ceb51+0x80/0x330
> > > >>   bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
> > > >>   bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
> > > >>   bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
> > > >>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> > > >>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> > > >>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> > > >>
> > > >> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407,
> > > >> cache=kmalloc-512
> > > >>
> > > >> allocated by task 15074 on cpu 0 at 1342.585390s:
> > > >>   kmalloc include/linux/slab.h:568 [inline]
> > > >>   kzalloc include/linux/slab.h:675 [inline]
> > > >>   bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
> > > >>   bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
> > > >>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> > > >>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> > > >>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> > > >>   __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
> > > >>
> > > >> To fix the problem, we round up allocations with kmalloc_size_roundup()
> > > >> so that build_skb()'s use of kize() is always alignment and no special
> > > >> handling of the memory is needed by KFENCE.
> > > >>
> > > >> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> > > >> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> > > >> ---
> > > >>   net/bpf/test_run.c | 1 +
> > > >>   1 file changed, 1 insertion(+)
> > > >>
> > > >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > > >> index 13d578ce2a09..058b67108873 100644
> > > >> --- a/net/bpf/test_run.c
> > > >> +++ b/net/bpf/test_run.c
> > > >> @@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr
> > > >> *kattr, u32 user_size,
> > > >>       if (user_size > size)
> > > >>           return ERR_PTR(-EMSGSIZE);
> > > >> +    size = kmalloc_size_roundup(size);
> > > >>       data = kzalloc(size + headroom + tailroom, GFP_USER);
> > > >
> > > > The fact that you need to do this roundup on call sites feels broken, no?
> > > > Was there some discussion / consensus that now all k*alloc() call sites
> > > > would need to be fixed up? Couldn't this be done transparently in k*alloc()
> > > > when KFENCE is enabled? I presume there may be lots of other such occasions
> > > > in the kernel where similar issue triggers, fixing up all call-sites feels
> > > > like ton of churn compared to api-internal, generic fix.
>
> I hope I answer this in more detail here:
> https://lore.kernel.org/lkml/202211010937.4631CB1B0E@keescook/
>
> The problem is that ksize() should never have existed in the first
> place. :P Every runtime bounds checker has tripped over it, and with
> the addition of the __alloc_size attribute, I had to start ripping
> ksize() out: it can't be used to pretend an allocation grew in size.
> Things need to either preallocate more or go through *realloc() like
> everything else. Luckily, ksize() is rare.
>
> FWIW, the above fix doesn't look correct to me -- I would expect this to
> be:
>
>         size_t alloc_size;
>         ...
>         alloc_size = kmalloc_size_roundup(size + headroom + tailroom);
>         data = kzalloc(alloc_size, GFP_USER);

Making sure the struct skb_shared_info is aligned to a cache line does
not need kmalloc_size_roundup().

What is needed is to adjust @size so that (@size + @headroom) is a
multiple of SMP_CACHE_BYTES
