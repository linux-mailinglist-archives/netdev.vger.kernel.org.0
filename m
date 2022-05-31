Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0219539966
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348340AbiEaWSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiEaWSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:18:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801369C2DB;
        Tue, 31 May 2022 15:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22413B81639;
        Tue, 31 May 2022 22:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E44C3411F;
        Tue, 31 May 2022 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654035477;
        bh=kPz0kmcHmoiNz8TJQWJnQubb6pcM5fXPAa3VnwIRwsM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=RQwd3Pe/cnpI/xPt98ZR2wM7u5vCkUNSisG1AxUYH+YIfi1XHnZb/I3cciwqdGGNW
         l7OfgZU4RcR5dtJoqeYa8SfT9nhqh77qHoM0LZmYEL8c91+ukb/789rKaItyV5dTOl
         IL2ShR0Wbpn94u11kQOFnTDE+IFQJk2FvzvrZjcmwqozCWuO0f3nMdoswNdu/FW+2R
         Xm+c87VXBPsMDWw2MsDP/GRQrFm+RUU4b/VX7P9vK7XoCUSgWjvMMtYwekWFNSH/VI
         qMCYHBUCss5uCifImZLNKWiIzctPz1ya4PFipba9kGkgZ6o2zVSqo2DZGln1/4TSE+
         QTbaz+WKDscqA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-30ec2aa3b6cso1397127b3.11;
        Tue, 31 May 2022 15:17:57 -0700 (PDT)
X-Gm-Message-State: AOAM533gGJGYhnSPMmN59m5pf++de8VKmewQZhHy0O6Z4LhcUMzhh+Lx
        EdOX3XDaGQW0j8tlmGA2yT3my3DnPOYeY872+50=
X-Google-Smtp-Source: ABdhPJzAHdyFLSBA7NcpOHiWNPWZHzx+Rx8RVyhdqXbl126xCzVD1uGCHamNm2Q0Lvci71OClw3JekoaaLJoSUffXQc=
X-Received: by 2002:a0d:eb4d:0:b0:30c:9849:27a1 with SMTP id
 u74-20020a0deb4d000000b0030c984927a1mr8212639ywe.472.1654035476770; Tue, 31
 May 2022 15:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220531215113.1100754-1-eric.dumazet@gmail.com>
In-Reply-To: <20220531215113.1100754-1-eric.dumazet@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 May 2022 15:17:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4vhjb6TAtT4XqWVqdbBrAVMuaZrvVfZZK=jyaoBaxKMQ@mail.gmail.com>
Message-ID: <CAPhsuW4vhjb6TAtT4XqWVqdbBrAVMuaZrvVfZZK=jyaoBaxKMQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: arm64: clear prog->jited_len along prog->jited
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 2:51 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> syzbot reported an illegal copy_to_user() attempt
> from bpf_prog_get_info_by_fd() [1]
>
> There was no repro yet on this bug, but I think
> that commit 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
> is exposing a prior bug in bpf arm64.
>
> bpf_prog_get_info_by_fd() looks at prog->jited_len
> to determine if the JIT image can be copied out to user space.
>
> My theory is that syzbot managed to get a prog where prog->jited_len
> has been set to 43, while prog->bpf_func has ben cleared.
>
> It is not clear why copy_to_user(uinsns, NULL, ulen) is triggering
> this particular warning.
> I thought find_vma_area(NULL) would not find a vm_struct.
> As we do not hold vmap_area_lock spinlock, it might be possible
> that the found vm_struct was garbage.
>
> [1]
> usercopy: Kernel memory exposure attempt detected from vmalloc (offset 792633534417210172, size 43)!
> kernel BUG at mm/usercopy.c:101!
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 0 PID: 25002 Comm: syz-executor.1 Not tainted 5.18.0-syzkaller-10139-g8291eaafed36 #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : usercopy_abort+0x90/0x94 mm/usercopy.c:101
> lr : usercopy_abort+0x90/0x94 mm/usercopy.c:89
> sp : ffff80000b773a20
> x29: ffff80000b773a30 x28: faff80000b745000 x27: ffff80000b773b48
> x26: 0000000000000000 x25: 000000000000002b x24: 0000000000000000
> x23: 00000000000000e0 x22: ffff80000b75db67 x21: 0000000000000001
> x20: 000000000000002b x19: ffff80000b75db3c x18: 00000000fffffffd
> x17: 2820636f6c6c616d x16: 76206d6f72662064 x15: 6574636574656420
> x14: 74706d6574746120 x13: 2129333420657a69 x12: 73202c3237313031
> x11: 3237313434333533 x10: 3336323937207465 x9 : 657275736f707865
> x8 : ffff80000a30c550 x7 : ffff80000b773830 x6 : ffff80000b773830
> x5 : 0000000000000000 x4 : ffff00007fbbaa10 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : f7ff000028fc0000 x0 : 0000000000000064
> Call trace:
>  usercopy_abort+0x90/0x94 mm/usercopy.c:89
>  check_heap_object mm/usercopy.c:186 [inline]
>  __check_object_size mm/usercopy.c:252 [inline]
>  __check_object_size+0x198/0x36c mm/usercopy.c:214
>  check_object_size include/linux/thread_info.h:199 [inline]
>  check_copy_size include/linux/thread_info.h:235 [inline]
>  copy_to_user include/linux/uaccess.h:159 [inline]
>  bpf_prog_get_info_by_fd.isra.0+0xf14/0xfdc kernel/bpf/syscall.c:3993
>  bpf_obj_get_info_by_fd+0x12c/0x510 kernel/bpf/syscall.c:4253
>  __sys_bpf+0x900/0x2150 kernel/bpf/syscall.c:4956
>  __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
>  __arm64_sys_bpf+0x28/0x40 kernel/bpf/syscall.c:5019
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:52
>  el0_svc_common.constprop.0+0x44/0xec arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0xa0/0xc0 arch/arm64/kernel/syscall.c:206
>  el0_svc+0x44/0xb0 arch/arm64/kernel/entry-common.c:624
>  el0t_64_sync_handler+0x1ac/0x1b0 arch/arm64/kernel/entry-common.c:642
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
> Code: aa0003e3 d00038c0 91248000 97fff65f (d4210000)
>
> Fixes: db496944fdaa ("bpf: arm64: add JIT support for multi-function programs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  arch/arm64/net/bpf_jit_comp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index 8ab4035dea2742b704dc7501b0b2128320899b1e..42f2e9a8616c3095609c182e6f50defdbe862b46 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -1478,6 +1478,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>                         bpf_jit_binary_free(header);
>                         prog->bpf_func = NULL;
>                         prog->jited = 0;
> +                       prog->jited_len = 0;
>                         goto out_off;
>                 }
>                 bpf_jit_binary_lock_ro(header);
> --
> 2.36.1.255.ge46751e96f-goog
>
