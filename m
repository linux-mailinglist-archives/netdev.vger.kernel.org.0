Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4AB2F598B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbhANDmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbhANDmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 22:42:40 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C09C061794;
        Wed, 13 Jan 2021 19:41:54 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id 23so6026911lfg.10;
        Wed, 13 Jan 2021 19:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QS8VXFs7x3ra/481hC4Sih94E6bZRvUnSXpvEKmNHbo=;
        b=eID+qmHMVTeQyADuqgulk25EF1tIoUmyOQGCPvY/lbzzcJdTRTosfWB0bU53Bfl6ra
         8U+51f8h9Q9gACGyrdDGGom/owSLh7aOw7Rfw6eAuVt8wEiWBjml/hwy4iuKK8YQIivB
         kAUSBaet0rQqWRu3ST/BfBpvZwHf7c+pQKA3D7z/HppSCdQBAwK4XDRR7IUvHRL+2JYr
         7RXsYiLj1apCOb+nLGDnNdO3W9IMzHk5tPk/uS2dHWIE5WcRaWvDhCD7XlLY3WceLSFT
         xjOwBWy2UJS69k6zVaXGyKPkuL5EbChsHUWnNUfL7UdxM3aC0eMeRcnLHl6sQNk+ZVMZ
         yq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QS8VXFs7x3ra/481hC4Sih94E6bZRvUnSXpvEKmNHbo=;
        b=nbvVMd4hzRks+VVzmmCm2lRSvrcT6ryWRoNsTmso4H03XW3H8xXyprAF3hLSvXVFvq
         LQ92xLiTel+zOFo2ItsoeD60I6kc8kmkdBXVTYpY4/uYAjpmDoISQmnWXrvRIxi3Avjc
         loWIgnJGdMEzbeGRcagIoTTGI1DzUNG7CK/JVpnmcgEJOn0S31+1nE/e8bvZ6eYsP7VV
         WVsAX8C+vf5GG1xJSCgmVPZg4HIslJ806h/+WR8BOCD0V61UL8B52edOwgiC2BUYZDNn
         UlWvNdyrxgUFgO15fQnRRhzi1qK0oye+GhS5Gc/0rKv+YqfgVFq1GxAcpQ3R3Br+wGJO
         Gklw==
X-Gm-Message-State: AOAM533xU+ECw345ICak3r59/8vgKsciKbviPUCe5D7q1lucOuv0qus0
        8a2DFTj1jX5d8wRO7dPLBlh5flnUge/pH0/uL9U=
X-Google-Smtp-Source: ABdhPJyWuPE8DhzRAipubVuzxv1DGesJa040QbCsbjGTgoqPO1sUV3JYTEtaRND0Uah7Kct+An+jUvKz2Gckd8Hp66Q=
X-Received: by 2002:ac2:43c1:: with SMTP id u1mr2447985lfl.38.1610595713006;
 Wed, 13 Jan 2021 19:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20210112234254.1906829-1-songliubraving@fb.com>
 <b8b16115-4fba-265f-b0a5-33af02a75bbb@fb.com> <2DAED411-C65F-4BFD-A627-1EED4823168B@fb.com>
 <1d116261-5ef2-eef6-369f-e8e12eaebc6e@fb.com>
In-Reply-To: <1d116261-5ef2-eef6-369f-e8e12eaebc6e@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 Jan 2021 19:41:41 -0800
Message-ID: <CAADnVQJFSLitAYK_yR-5YV6YoeXjiuqA03t7KEanPwi2hwWf5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test run
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com" 
        <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 3:28 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/13/21 1:48 PM, Song Liu wrote:
> >
> >
> >> On Jan 12, 2021, at 9:17 PM, Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 1/12/21 3:42 PM, Song Liu wrote:
> >>> syzbot reported a WARNING for allocating too big memory:
> >>> WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
> >>> Modules linked in:
> >>> CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller #0
> >>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >>> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
> >>> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
> >>> RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
> >>> RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
> >>> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
> >>> RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
> >>> R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
> >>> R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
> >>> FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> >>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
> >>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>> Call Trace:
> >>> alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
> >>> alloc_pages include/linux/gfp.h:547 [inline]
> >>> kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
> >>> kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
> >>> kmalloc include/linux/slab.h:557 [inline]
> >>> kzalloc include/linux/slab.h:682 [inline]
> >>> bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
> >>> bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
> >>> __do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
> >>> do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>> RIP: 0033:0x440499
> >>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> >>> RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> >>> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
> >>> RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
> >>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> >>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
> >>> R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000
> >>> This is because we didn't filter out too big ctx_size_in. Fix it by
> >>> rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
> >>> numbers.
> >>> Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
> >>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
> >>> Cc: stable@vger.kernel.org # v5.10+
> >>> Signed-off-by: Song Liu <songliubraving@fb.com>
> >>
> >> Maybe this should target to bpf tree?
> >
> > IIRC, we direct fixes to current release under rc (5.11) to bpf tree. This
> > one is for 5.10 and 5.11, so should go bpf-next, no?
>
> I don't know where it should go first. Maintainers know better. But it
> should go to 5.10, 5.11 (currently rc4) and bpf-next.

Not sure what is the disagreement here.
It's clearly a fix. Hence it was applied to bpf tree.
Song, please mark subj as [PATCH bpf] not to confuse CI,
since it's using this tag to test patches against appropriate tree.
