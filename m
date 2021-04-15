Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899D736167B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238001AbhDOXqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbhDOXqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:46:01 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1525C06175F;
        Thu, 15 Apr 2021 16:45:37 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a25so15771434ljm.11;
        Thu, 15 Apr 2021 16:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ihiapmhpJuINwzvpG/IVF1TRN+aBOSHQl91XNZxYiMc=;
        b=GOgCgg692WzmkpnYRmFqjUT0VXywqCAcPvBcQgWYBN0qN9EeSX6qLy7rWDA4ms6tuV
         IiZWR/9c1NA1DxZRg/01oK401tkwYXIOS1lt4GQIFheOqVT+6AKryBSd9odPlJTfrdUZ
         MegTIRdrJRKiNCm3rtD3XEf81pbcHNAC6AgvaDSU8smF2zwTwL2hjmiHKS0yl4c7Ko+8
         VWKKJrqYxacDZXa/Ncp+LX8v0bUgbG4ibF9qrYZZZAFZN2jaPbbdH9VaJNKxcZTs22Zs
         6Q6y3c0ZwisthiEzXQzwQlnu8rIxaM40529wbQWP+QKOzFPBSk2tEJtjN7mpzRso7NiZ
         B9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ihiapmhpJuINwzvpG/IVF1TRN+aBOSHQl91XNZxYiMc=;
        b=r/tR91qdfRE51wb2Q7K8mmhC2zjknCtQMyXDf3pDI4Sbi51H45GYU0RiJZi10v9MWf
         jOAVY09LrSZl1iifuPFuUFGqCiRosZ07PFB/Bc4Df0WenzLfyKqLu8H7OfRZ5G/MRW4e
         QUFJQOj3e16n++XJSA7BNV1O+Qb05Ek8vUVjjlGdWn6T28Fimcmjs+AIo9w7BaLUcBMC
         92Ltsfy8P3DYz0XnnGNr378RBGqb1ZvKeP4Oq2nU46S9qqiD8/5aduulRGjRrKPbU61U
         1GPd2odFZQYgQ0yAHGV3Jb1iE+GPSuyVH05ZSsnU3vGxKPhl4sQwi36woCpGfXs9Ytqe
         G6OQ==
X-Gm-Message-State: AOAM531HIltuEt0uMc+09zXwGqe+IKh/7M2aNz4n5Dg4Ik360C6U2PBY
        AQXx7Pp72eOiS/Qq8wb+2JCTm1aKRmoe0yFoFIU=
X-Google-Smtp-Source: ABdhPJxv3iMrOGY6XTLr/XCYY5D5/WzepaOBnHKN1RFYWR+Q5T+WvodUu8IwR2lIn+76Yqhoy5Md1yULnREImzgDSdc=
X-Received: by 2002:a05:651c:2001:: with SMTP id s1mr935019ljo.236.1618530335646;
 Thu, 15 Apr 2021 16:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210414195147.1624932-1-jolsa@kernel.org>
In-Reply-To: <20210414195147.1624932-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Apr 2021 16:45:24 -0700
Message-ID: <CAADnVQK9+Rj8CCC0JZaQaovWqeJKWoAQihOU3eMjf94mk9e+xA@mail.gmail.com>
Subject: Re: [PATCHv5 bpf-next 0/7] bpf: Tracing and lsm programs re-attach
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:52 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> while adding test for pinning the module while there's
> trampoline attach to it, I noticed that we don't allow
> link detach and following re-attach for trampolines.
> Adding that for tracing and lsm programs.
>
> You need to have patch [1] from bpf tree for test module
> attach test to pass.
>
> v5 changes:
>   - fixed missing hlist_del_init change
>   - fixed several ASSERT calls
>   - added extra patch for missing ';'
>   - added ASSERT macros to lsm test
>   - added acks

It doesn't work:
[   52.763254] ------------[ cut here ]------------
[   52.763767] WARNING: CPU: 2 PID: 1967 at kernel/bpf/syscall.c:2518
bpf_tracing_link_release+0x34/0x40
[   52.764666] Modules linked in: bpf_preload [last unloaded: bpf_testmod]
[   52.765310] CPU: 2 PID: 1967 Comm: test_progs Tainted: G
O      5.12.0-rc4-01652-gf03a9b92b5f3 #3293
[   52.766279] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[   52.767128] RIP: 0010:bpf_tracing_link_release+0x34/0x40
[   52.767653] Code: 8b 77 48 48 8b 7f 18 e8 ea 67 02 00 85 c0 75 1a
48 8b 7b 48 e8 ad 60 02 00 48 8b 7b 50 48 85 ff 74 06 5b e9 6e ff ff
ff 5b c3 <0f> 0b eb e2 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89
fd 8b
[   52.769444] RSP: 0018:ffffc900001bfe98 EFLAGS: 00010286
[   52.769957] RAX: 00000000ffffffed RBX: ffff88810218e420 RCX: 0000000000000000
[   52.770642] RDX: ffff888105e89f80 RSI: ffffffff8118e539 RDI: ffff88811cafec10
[   52.771338] RBP: ffff88810218e420 R08: 0000000000000270 R09: 00000000000003cb
[   52.772041] R10: ffff8881002a1090 R11: ffff888237d2aaf0 R12: ffff888101951030
[   52.772729] R13: ffff888100226f20 R14: ffff88810629f180 R15: ffff888105e89f80
[   52.773419] FS:  00007f82c7b93700(0000) GS:ffff888237d00000(0000)
knlGS:0000000000000000
[   52.774213] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   52.774784] CR2: 00007f82c7ba1000 CR3: 0000000105cfc006 CR4: 00000000003706e0
[   52.775494] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   52.776199] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   52.776887] Call Trace:
[   52.777143]  bpf_link_free+0x25/0x40
[   52.777525]  bpf_link_release+0x11/0x20
[   52.777924]  __fput+0x9f/0x240
[   52.778234]  task_work_run+0x63/0xb0
[   52.778588]  exit_to_user_mode_prepare+0x132/0x140
[   52.779064]  syscall_exit_to_user_mode+0x1d/0x40
[   52.779519]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   52.780026] RIP: 0033:0x7f82c6f3815d
[   52.780384] Code: c2 20 00 00 75 10 b8 03 00 00 00 0f 05 48 3d 01
f0 ff ff 73 31 c3 48 83 ec 08 e8 ee fb ff ff 48 89 04 24 b8 03 00 00
00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 fc ff ff 48 89 d0 48 83 c4 08 48
3d 01
test_module_attach:FAIL:delete_module unexpected success: 0
libbpf: prog 'handle_fexit': failed to attach: No such file or directory
test_module_attach:FAIL:attach_fexit unexpected error: -2
#68 module_attach:FAIL

and another in:
./test_progs -t module
[  156.660834] ------------[ cut here ]------------
[  156.661414] WARNING: CPU: 3 PID: 2511 at kernel/trace/ftrace.c:6321
ftrace_module_enable+0x33a/0x370
[  156.662445] Modules linked in: bpf_testmod(O+) bpf_preload [last
unloaded: bpf_testmod]
[  156.663325] CPU: 3 PID: 2511 Comm: test_progs Tainted: G        W
O      5.12.0-rc4-01652-gf03a9b92b5f3 #3293
[  156.664369] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[  156.665265] RIP: 0010:ftrace_module_enable+0x33a/0x370
[  156.665890] Code: 00 00 74 9d 48 0d 00 00 00 10 48 89 45 08 e9 db
fe ff ff 8b 8b 98 01 00 00 48 01 ca 48 39 d0 0f 83 2c fd ff ff e9 66
fd ff ff <0f> 0b e9 bd fe ff ff 0f 0b e9 b6 fe ff ff 48 83 78 10 00 0f
85 dd
[  156.667822] RSP: 0018:ffffc900001c7d50 EFLAGS: 00010206
[  156.668354] RAX: 0000000000000000 RBX: ffffffffa001c380 RCX: 0000000000005000
[  156.669079] RDX: 0000000000031045 RSI: ffffffffa0019080 RDI: 0000000000000000
[  156.669793] RBP: ffff888104bd9020 R08: ffffffff83174f00 R09: 0000000000000000
[  156.670529] R10: 0000000000000001 R11: ffffffffa0019080 R12: ffff88810092e480
[  156.671368] R13: 61c8864680b583eb R14: 0000000000000002 R15: 0000000000000000
[  156.672135] FS:  00007f198becc700(0000) GS:ffff888237d80000(0000)
knlGS:0000000000000000
[  156.672973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.673625] CR2: 00000000006a14f0 CR3: 00000001169be003 CR4: 00000000003706e0
[  156.674411] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.675209] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  156.675959] Call Trace:
[  156.676209]  load_module+0x1f71/0x27d0
[  156.676623]  ? __do_sys_finit_module+0x8f/0xc0
[  156.677084]  __do_sys_finit_module+0x8f/0xc0
[  156.677525]  do_syscall_64+0x2d/0x40
[  156.677932]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  156.678465] RIP: 0033:0x7f198afa37f9
[  156.678837] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 57 76 2b 00 f7 d8 64 89
01 48
[  156.680812] RSP: 002b:00007ffc428756d8 EFLAGS: 00000202 ORIG_RAX:
0000000000000139
[  156.681614] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f198afa37f9
[  156.682344] RDX: 0000000000000000 RSI: 00000000006a14f7 RDI: 0000000000000004
[  156.683111] RBP: 00007ffc428758b8 R08: 00007f198becc700 R09: 00007ffc428758b8
[  156.683842] R10: 00007f198becc700 R11: 0000000000000202 R12: 000000000040bce0
[  156.684590] R13: 00007ffc428758b0 R14: 0000000000000000 R15: 0000000000000000
[  156.685335] ---[ end trace 7086b04742183c35 ]---
#58 ksyms_module:OK
