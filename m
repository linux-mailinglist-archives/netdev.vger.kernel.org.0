Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D10F2D244E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLHHZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgLHHZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:25:48 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AA8C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 23:25:07 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id 7so11387237qtp.1
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 23:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ne5ocnU3Q2GZ4v1HqRwDB0YtsVfKbIKPg6J2lUsAGIw=;
        b=AM7muwwv/iL6pryqdrnwuYzv+xnd/Q+WnXoK0mLKUUlfCywzJCZBAtaa+YDRK8Hp+X
         17EPC4MPDArnq0ZHzA6prXkFtyKE8+OSAnG+GAD31JcR4VzbIFQjrQr/RmbUfe/LtYTM
         NvcP0F1AOfUUV++1z4TASfY6z+QzrcofYdHQcBC1fgrA5cwkWAxUZB0ENPgOJm/oKPfb
         txl8j9KKTj2gsw1+f07tojKVkDzW3q2Gj2K3D3lSkbz0jnJVy4KwzgIvUzz3Ss6CqXe2
         ETfUe6vQUIQKDHOQxQBD6uW3Kzy1/I+C9ps7VHd/jUMIpYKhaB84NsEM5Pl5LQWPOVVA
         yBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ne5ocnU3Q2GZ4v1HqRwDB0YtsVfKbIKPg6J2lUsAGIw=;
        b=fpN34Mt8/e82vtQMgXzzIqhQnwy4D9BVGLJPganyMamNhJUsVP0peUdOZiinmP4/xM
         ePB0SxuZAEawuNrwb4iMMKFkoj2JwPyQ5gfWQjoHABdEuFtuvwOSyDMdw9u9Wq1sm5sF
         C/C2Vr0noRZIZ9GlwO1E78Xfr7ohXN2CJ+gUQ7BsuF9g2DCuALT3wo5G+YjOb35PWlrY
         O+O3xjrUUvthyMgmzd4rL61uxdOvllPPet6Ew5iD0kCXDwkij5YAt69WVTzC6j5ql2Os
         VC3QtA6TA2BxIYNaOt5Evwaa2aKl14MGxgxukFQ7xZPrvbnw2QmKoHLylPbyXUONfBWU
         kyxg==
X-Gm-Message-State: AOAM531h24GVuCMd2uXqy7vZZvQH5zXyZV2nCn3gsjOR7AJjz7KcV5Xy
        l8Ng9T/mLIj4JNqS45Q6NMxNA+3eN6FRY+qP+pWoWQ==
X-Google-Smtp-Source: ABdhPJy9P+pdumLjMSsYsKntP6nKT4+GNdeintlseUOpLH3iD/G0AyMRFJriQglZf/x6zg9Bu7L2zpSoEhLUs5sQAzg=
X-Received: by 2002:ac8:4986:: with SMTP id f6mr632117qtq.43.1607412306524;
 Mon, 07 Dec 2020 23:25:06 -0800 (PST)
MIME-Version: 1.0
References: <000000000000caabb705b5e550aa@google.com>
In-Reply-To: <000000000000caabb705b5e550aa@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 8 Dec 2020 08:24:55 +0100
Message-ID: <CACT4Y+bXh8=jKY=Fe2ykgk=h79pMpcTtxzOyWigUCws0bv_g6Q@mail.gmail.com>
Subject: Re: KASAN: vmalloc-out-of-bounds Write in pcpu_freelist_populate
To:     syzbot <syzbot+942085bfb8f7a276af1c@syzkaller.appspotmail.com>,
        guro@fb.com, Eric Dumazet <edumazet@google.com>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 9:03 PM syzbot
<syzbot+942085bfb8f7a276af1c@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    34da8721 selftests/bpf: Test bpf_sk_storage_get in tcp ite..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c3b837500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3cb098ab0334059f
> dashboard link: https://syzkaller.appspot.com/bug?extid=942085bfb8f7a276af1c
> compiler:       gcc (GCC) 10.1.0-syz 20200507
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+942085bfb8f7a276af1c@syzkaller.appspotmail.com

I assume this is also

#syz fix: bpf: Avoid overflows involving hash elem_size


> ==================================================================
> BUG: KASAN: vmalloc-out-of-bounds in pcpu_freelist_push_node kernel/bpf/percpu_freelist.c:33 [inline]
> BUG: KASAN: vmalloc-out-of-bounds in pcpu_freelist_populate+0x1fe/0x260 kernel/bpf/percpu_freelist.c:114
> Write of size 8 at addr ffffc90119e78020 by task syz-executor.4/27988
>
> CPU: 1 PID: 27988 Comm: syz-executor.4 Not tainted 5.10.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  pcpu_freelist_push_node kernel/bpf/percpu_freelist.c:33 [inline]
>  pcpu_freelist_populate+0x1fe/0x260 kernel/bpf/percpu_freelist.c:114
>  prealloc_init kernel/bpf/hashtab.c:323 [inline]
>  htab_map_alloc+0x981/0x1230 kernel/bpf/hashtab.c:507
>  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
>  map_create kernel/bpf/syscall.c:829 [inline]
>  __do_sys_bpf+0xa81/0x5170 kernel/bpf/syscall.c:4374
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e0f9
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f679c7a7c68 EFLAGS: 00000246
>  ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e0f9
> RDX: 0000000000000040 RSI: 0000000020000040 RDI: 0000000000000000
> RBP: 000000000119c068 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c034
> R13: 00007fffd601c75f R14: 00007f679c7a89c0 R15: 000000000119c034
>
>
> Memory state around the buggy address:
>  ffffc90119e77f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90119e77f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> >ffffc90119e78000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                                ^
>  ffffc90119e78080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>  ffffc90119e78100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000caabb705b5e550aa%40google.com.
