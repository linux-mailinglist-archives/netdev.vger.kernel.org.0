Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A95644BCF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLFSd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiLFSdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:33:38 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25CF2B0
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:31:59 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id i12so11028116qvs.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 10:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KqUAYb/fXjf+DnnONFt9R7wczdlGsDniuWCIhYP8EcQ=;
        b=TNO6BxsIVU6eCOU2Do84isXfsLDc0DgZ8a10aCZhInQH6K7nuMPuT3blwZdef3Xzhm
         9wtnCP+z5u02o9pxfWhXV7P0UeDUWn2R85ZUTA261U3VpMRCbpUKdlN8wYox6DkUk/JR
         Xr3fAkNmZJpL/Me3+wknDBYGuZNhx15gLdTCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KqUAYb/fXjf+DnnONFt9R7wczdlGsDniuWCIhYP8EcQ=;
        b=5rTx6oQ4U9KxlYiiqU21G4n8S3NJnbH+sh35Avfkvm8tvLJF/a6QPD4vGStaGlsF52
         rXlZafGMsSPG/UVgT3n1HRLDpoYIkZUyfxzBKREhawARehM5JjfTWX8+UaiD5eoRYNBm
         Yef553ZD2OoJH7jd2WPNLd2dbtlg1gb+MJisaYjbiQdBd8oH6t7DSLYfr19opqnAFLel
         T5Xe9HkJGtzXlSgOlQob/TfNuLYRsWqm03IMzZGBgXvoit+8uRkBh3+/p2wFBJAuTNTZ
         SqLQ6pT+2aIrl/YLr2QctUNqkieJwW2bpvsiovGIOrRJutJcaq5ifmZKIvM4q3neyP3a
         J/Rg==
X-Gm-Message-State: ANoB5pmSDb04tG/G9EYFVie2xvafT4iivyZ1wE6CWNkthB+WwpXE01VI
        txM+RB+jg8jYfVR8Hwr+ULvUC2HrByuFDFEg
X-Google-Smtp-Source: AA0mqf4gO4Fbn7nNMhKpAzX0wOEbrLvjXUslMwTkLhw4w7R7HYJ8XGT/PLj57bibIsR9Ne2k6gSlVA==
X-Received: by 2002:a05:6214:84c:b0:4c7:7514:676b with SMTP id dg12-20020a056214084c00b004c77514676bmr6628861qvb.16.1670351518554;
        Tue, 06 Dec 2022 10:31:58 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id bn36-20020a05620a2ae400b006fafaac72a6sm4781964qkb.84.2022.12.06.10.31.58
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:31:58 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id d131so16317154ybh.4
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 10:31:58 -0800 (PST)
X-Received: by 2002:a81:8644:0:b0:3c7:3c2b:76b5 with SMTP id
 w65-20020a818644000000b003c73c2b76b5mr39379193ywf.22.1670351506938; Tue, 06
 Dec 2022 10:31:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fa798505ee880a25@google.com> <ac0d8823-e7b3-4524-8864-89b4c85315b5n@googlegroups.com>
 <CACT4Y+bz-z9s+sDh916rfw9ezW0XROkAKfMDvdVi-wDuf849MQ@mail.gmail.com>
In-Reply-To: <CACT4Y+bz-z9s+sDh916rfw9ezW0XROkAKfMDvdVi-wDuf849MQ@mail.gmail.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 6 Dec 2022 10:31:10 -0800
X-Gmail-Original-Message-ID: <CAGXu5jLCdfVLz9PLVs4XkyOY3=V=W8x7WF=E+yRUnsE=425vAw@mail.gmail.com>
Message-ID: <CAGXu5jLCdfVLz9PLVs4XkyOY3=V=W8x7WF=E+yRUnsE=425vAw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in __build_skb_around
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     pepsipu <soopthegoop@gmail.com>,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Vlastimil Babka <vbabka@suse.cz>,
        kasan-dev <kasan-dev@googlegroups.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, martin.lau@linux.dev,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 12:04 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sun, 4 Dec 2022 at 19:16, pepsipu <soopthegoop@gmail.com> wrote:
> >
> > I believe this is a KASAN bug.
> >
> > I made an easier to read version that still triggers KASAN:
> >
> > #define _GNU_SOURCE
> >
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> > #include <sys/syscall.h>
> > #include <sys/types.h>
> > #include <linux/bpf.h>
> > #include <unistd.h>
> >
> > #include "bpf.h"
> >
> > int main(void)
> > {
> >     __u64 insns[] = {
> >         (BPF_CALL | BPF_JMP) | ((__u64)0x61 << 32),
> >         (BPF_AND | BPF_ALU),
> >         (BPF_EXIT | BPF_JMP),
> >     };
> >     bpf_load_attr_t load_attr = {
> >         .prog_type = BPF_PROG_TYPE_CGROUP_SKB,
> >         .insn_cnt = sizeof(insns) / sizeof(__u64),
> >         .insns = (__u64)insns,
> >         .license = (__u64) "GPL",
> >     };
> >     long prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &load_attr, sizeof(bpf_load_attr_t));
> >     if (prog_fd == -1)
> >     {
> >         printf("could not load bpf prog");
> >         exit(-1);
> >     }
> >     bpf_trun_attr_t trun_attr = {
> >         .prog_fd = prog_fd,
> >         .data_size_in = 0x81,
> >         .data_size_out = -1,
> >         .data_in = (__u64) "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
> >     };
> >
> >     syscall(__NR_bpf, BPF_PROG_TEST_RUN, &trun_attr, sizeof(bpf_trun_attr_t));
> >     return 0;
> > }
> >
> > It looks like KASAN believes the tail access of SKB's backing buffer, the SKB shared info struct, allocated by bpf_test_init is out-of-bounds.
> > This is likely because when the SKB is setup, in build_skb, the tail is calculated as "data + ksize(data) - sizeof(skb_shared_info)". ksize returns the size of the slab, not the allocation, so the tail is much further past the allocation.
> > However, KASAN is usually supposed to correct for ksize calls by unpoisioning the entire slab it's called on... I'm not sure why this is happening.
>
> Hi,
>
> [+orignal CC list, please keep it in replies, almost none of relevant
> receivers read syzkaller-bugs@ mailing list]
>
> Also +Kees and kasan-dev for ksize.
>
> After the following patch the behavior has changed and KASAN does not
> unpoison the fail of the object:
>
> mm: Make ksize() a reporting-only function
> https://lore.kernel.org/all/20221118035656.gonna.698-kees@kernel.org/
>
> Kees, is this bpf case is a remaining ksize() use that needs to be fixed?
>

Hi, yes, this seems like a missed ksize() usage. I will take a look at
it -- nothing should be using ksize() to resize the allocation any
more: it should either fully allocate the bucket at the start, or use
krealloc().

-Kees

> > On Monday, November 28, 2022 at 5:42:31 AM UTC-8 syzbot wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit: c35bd4e42885 Add linux-next specific files for 20221124
> >> git tree: linux-next
> >> console+strace: https://syzkaller.appspot.com/x/log.txt?x=15e5d7e5880000
> >> kernel config: https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=fda18eaa8c12534ccb3b
> >> compiler: gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> >> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=1096f205880000
> >> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=10b2d68d880000
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/968fee464d14/disk-c35bd4e4.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/4f46fe801b5b/vmlinux-c35bd4e4.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/c2cdf8fb264e/bzImage-c35bd4e4.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+fda18e...@syzkaller.appspotmail.com
> >>
> >> ==================================================================
> >> BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
> >> Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
> >>
> >> CPU: 0 PID: 5295 Comm: syz-executor413 Not tainted 6.1.0-rc6-next-20221124-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> >> Call Trace:
> >> <TASK>
> >> __dump_stack lib/dump_stack.c:88 [inline]
> >> dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
> >> print_address_description mm/kasan/report.c:253 [inline]
> >> print_report+0x15e/0x45d mm/kasan/report.c:364
> >> kasan_report+0xbf/0x1f0 mm/kasan/report.c:464
> >> check_region_inline mm/kasan/generic.c:183 [inline]
> >> kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
> >> memset+0x24/0x50 mm/kasan/shadow.c:44
> >> __build_skb_around+0x235/0x340 net/core/skbuff.c:294
> >> __build_skb+0x4f/0x60 net/core/skbuff.c:328
> >> build_skb+0x22/0x280 net/core/skbuff.c:340
> >> bpf_prog_test_run_skb+0x343/0x1e10 net/bpf/test_run.c:1131
> >> bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
> >> __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
> >> __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
> >> __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
> >> __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
> >> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> RIP: 0033:0x7f30de9aad19
> >> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> >> RSP: 002b:00007ffeaee34318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> >> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f30de9aad19
> >> RDX: 0000000000000028 RSI: 0000000020000180 RDI: 000000000000000a
> >> RBP: 00007f30de96eec0 R08: 0000000000000000 R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f30de96ef50
> >> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> >> </TASK>
> >>
> >> Allocated by task 5295:
> >> kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
> >> kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> >> ____kasan_kmalloc mm/kasan/common.c:376 [inline]
> >> ____kasan_kmalloc mm/kasan/common.c:335 [inline]
> >> __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:385
> >> kasan_kmalloc include/linux/kasan.h:212 [inline]
> >> __do_kmalloc_node mm/slab_common.c:955 [inline]
> >> __kmalloc+0x5a/0xd0 mm/slab_common.c:968
> >> kmalloc include/linux/slab.h:575 [inline]
> >> kzalloc include/linux/slab.h:711 [inline]
> >> bpf_test_init.isra.0+0xa5/0x150 net/bpf/test_run.c:778
> >> bpf_prog_test_run_skb+0x22e/0x1e10 net/bpf/test_run.c:1097
> >> bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
> >> __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
> >> __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
> >> __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
> >> __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
> >> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >> entry_SYSCALL_64_after_hwframe+0x63/0xcd

-- 
Kees Cook
