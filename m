Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9114615B67
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiKBE1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiKBE1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:27:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE1B2496C
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 21:27:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b11so15118406pjp.2
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 21:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oqi0XqbkG3Dus9YH6EgfJKa6MhfGCNy0Tx+UnxgxZV4=;
        b=IvJWFukRqq5xhu95hUXGB4wmuYgkN31r4yzOGjAoYxeqmMlV3y2flvg8we0brHPG9U
         dfwgUaO5s7H8R3wMwUWbVlWBMmGl1UEX3r7n2150eaDmVgDQzDCAGHZyTDdpTdz/zBuX
         kUS0se5GEhzJZiKNmPiLr0mcZO+Ct9ZmXrsms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oqi0XqbkG3Dus9YH6EgfJKa6MhfGCNy0Tx+UnxgxZV4=;
        b=bPlUsBAGzyjv23cSDMNO8takY7LqaaS5IVWz1Cw410Obip4cEiWv4vX4+r3SpWe9KT
         72HLQ4Z4tPAjUbX4KcrfB2ZzJzzFhwg3t8peenkp0JZ+rGP2DbomIhJY3j6xBEd6WLQi
         WweS70Lz/eEqoBt9WMsbpS3ufG6/GeIET0t4qkX9V09HNtGvyDEQ6tVQMnRmG5/4T8Eq
         /qQ6kFIEMeoRF62+sL3W+1MdevgyiG9OcvjOu1QHeMfZLr+pv34GT8OOIvsSYyAYOuIF
         xRNqbIKVGW1jrD6BKQFWdaYZOjSc8l23Kx5BxGCiBOUua/Fqpc5smC66jQj/sXkvig4U
         zueQ==
X-Gm-Message-State: ACrzQf1ef+WsVCLeuhEHZ4b7WJ6rfJH3NLfavNBDBMFyE6tEdgk/6bdA
        2PwA0mg1/kvUDaGn8Xn3qbgtVQ==
X-Google-Smtp-Source: AMsMyM5Ek1438vr+3xOKmND8++COJWPH6Q8FcSG/Z2QSZuOIWkcsxgcLrac6I6p4ilO42AZ1fu3spw==
X-Received: by 2002:a17:90b:4a46:b0:214:27dc:a111 with SMTP id lb6-20020a17090b4a4600b0021427dca111mr2485292pjb.28.1667363225489;
        Tue, 01 Nov 2022 21:27:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090b078400b002009db534d1sm375509pjz.24.2022.11.01.21.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 21:27:04 -0700 (PDT)
Date:   Tue, 1 Nov 2022 21:27:03 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     zhongbaisong <zhongbaisong@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>, edumazet@google.com,
        davem@davemloft.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, song@kernel.org,
        yhs@fb.com, haoluo@google.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux MM <linux-mm@kvack.org>, kasan-dev@googlegroups.com
Subject: Re: [PATCH -next] bpf, test_run: fix alignment problem in
 bpf_prog_test_run_skb()
Message-ID: <202211012121.47D68D0@keescook>
References: <20221101040440.3637007-1-zhongbaisong@huawei.com>
 <eca17bfb-c75f-5db1-f194-5b00c2a0c6f2@iogearbox.net>
 <ca6253bd-dcf4-2625-bc41-4b9a7774d895@huawei.com>
 <20221101210542.724e3442@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221101210542.724e3442@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:05:42PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 10:59:44 +0800 zhongbaisong wrote:
> > On 2022/11/2 0:45, Daniel Borkmann wrote:
> > > [ +kfence folks ]  
> > 
> > + cc: Alexander Potapenko, Marco Elver, Dmitry Vyukov
> > 
> > Do you have any suggestions about this problem?
> 
> + Kees who has been sending similar patches for drivers
> 
> > > On 11/1/22 5:04 AM, Baisong Zhong wrote:  
> > >> Recently, we got a syzkaller problem because of aarch64
> > >> alignment fault if KFENCE enabled.
> > >>
> > >> When the size from user bpf program is an odd number, like
> > >> 399, 407, etc, it will cause skb shard info's alignment access,
> > >> as seen below:
> > >>
> > >> BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 
> > >> net/core/skbuff.c:1032
> > >>
> > >> Use-after-free read at 0xffff6254fffac077 (in kfence-#213):
> > >>   __lse_atomic_add arch/arm64/include/asm/atomic_lse.h:26 [inline]
> > >>   arch_atomic_add arch/arm64/include/asm/atomic.h:28 [inline]
> > >>   arch_atomic_inc include/linux/atomic-arch-fallback.h:270 [inline]
> > >>   atomic_inc include/asm-generic/atomic-instrumented.h:241 [inline]
> > >>   __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
> > >>   skb_clone+0xf4/0x214 net/core/skbuff.c:1481
> > >>   ____bpf_clone_redirect net/core/filter.c:2433 [inline]
> > >>   bpf_clone_redirect+0x78/0x1c0 net/core/filter.c:2420
> > >>   bpf_prog_d3839dd9068ceb51+0x80/0x330
> > >>   bpf_dispatcher_nop_func include/linux/bpf.h:728 [inline]
> > >>   bpf_test_run+0x3c0/0x6c0 net/bpf/test_run.c:53
> > >>   bpf_prog_test_run_skb+0x638/0xa7c net/bpf/test_run.c:594
> > >>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> > >>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> > >>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> > >>
> > >> kfence-#213: 0xffff6254fffac000-0xffff6254fffac196, size=407, 
> > >> cache=kmalloc-512
> > >>
> > >> allocated by task 15074 on cpu 0 at 1342.585390s:
> > >>   kmalloc include/linux/slab.h:568 [inline]
> > >>   kzalloc include/linux/slab.h:675 [inline]
> > >>   bpf_test_init.isra.0+0xac/0x290 net/bpf/test_run.c:191
> > >>   bpf_prog_test_run_skb+0x11c/0xa7c net/bpf/test_run.c:512
> > >>   bpf_prog_test_run kernel/bpf/syscall.c:3148 [inline]
> > >>   __do_sys_bpf kernel/bpf/syscall.c:4441 [inline]
> > >>   __se_sys_bpf+0xad0/0x1634 kernel/bpf/syscall.c:4381
> > >>   __arm64_sys_bpf+0x50/0x60 kernel/bpf/syscall.c:4381
> > >>
> > >> To fix the problem, we round up allocations with kmalloc_size_roundup()
> > >> so that build_skb()'s use of kize() is always alignment and no special
> > >> handling of the memory is needed by KFENCE.
> > >>
> > >> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
> > >> Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
> > >> ---
> > >>   net/bpf/test_run.c | 1 +
> > >>   1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > >> index 13d578ce2a09..058b67108873 100644
> > >> --- a/net/bpf/test_run.c
> > >> +++ b/net/bpf/test_run.c
> > >> @@ -774,6 +774,7 @@ static void *bpf_test_init(const union bpf_attr 
> > >> *kattr, u32 user_size,
> > >>       if (user_size > size)
> > >>           return ERR_PTR(-EMSGSIZE);
> > >> +    size = kmalloc_size_roundup(size);
> > >>       data = kzalloc(size + headroom + tailroom, GFP_USER);  
> > > 
> > > The fact that you need to do this roundup on call sites feels broken, no?
> > > Was there some discussion / consensus that now all k*alloc() call sites
> > > would need to be fixed up? Couldn't this be done transparently in k*alloc()
> > > when KFENCE is enabled? I presume there may be lots of other such occasions
> > > in the kernel where similar issue triggers, fixing up all call-sites feels
> > > like ton of churn compared to api-internal, generic fix.

I hope I answer this in more detail here:
https://lore.kernel.org/lkml/202211010937.4631CB1B0E@keescook/

The problem is that ksize() should never have existed in the first
place. :P Every runtime bounds checker has tripped over it, and with
the addition of the __alloc_size attribute, I had to start ripping
ksize() out: it can't be used to pretend an allocation grew in size.
Things need to either preallocate more or go through *realloc() like
everything else. Luckily, ksize() is rare.

FWIW, the above fix doesn't look correct to me -- I would expect this to
be:

	size_t alloc_size;
	...
	alloc_size = kmalloc_size_roundup(size + headroom + tailroom);
	data = kzalloc(alloc_size, GFP_USER);

-- 
Kees Cook
