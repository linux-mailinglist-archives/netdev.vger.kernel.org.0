Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D17A5B6302
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiILVsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiILVsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:48:03 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD461836E;
        Mon, 12 Sep 2022 14:48:01 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s18so3894801plr.4;
        Mon, 12 Sep 2022 14:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ju/BoI0cUOrilm7U0D3lKO4lFOs3ZMMqejXmhw4/Fak=;
        b=ZpxMuXoij2XD+K0KoIjK2iZBsrCAMF4I2+j5wjiwVv5Es2oov1S88imhutEr5pf/dM
         Y8XEyC8WtFUW/pWbbjfihJ5o32MV7VMOOFcVSZuLXSTR0Q+EsbmU0StS6ICVQF8QK3ag
         vCuMmND3BYiWjndK3l/yzFvfn3UsteY699Wa6w2qQ9GoIv77vjTa/d/D/++twbuRIFSQ
         X5ZGfM5wBlOLo9u6JLWWngKUNAuh7PRSZPfTUo6jLfg8X4i7rBMyzWDx/9XQHIFlUY2S
         WmpuV2ePb4rra2f/psX2PqPmdBaoMvTc0E8hczDQlk/cldtSP7s0e89NAuTBvXmykz76
         7SzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ju/BoI0cUOrilm7U0D3lKO4lFOs3ZMMqejXmhw4/Fak=;
        b=PmhL09GjPagp3XOs8bm5QbROkFlQHEYq57EWcUGkwbca5woA3iZVPt91nx8YHSFvxF
         XJ/fsxGyLBaEQFhQ0L8/RYwA5WpOUtfsLFkegkDGeEfhcm4z/KvJeydNpgxZBdpQmLy3
         9WXd+G+ZRdyl4V1ACxGK6MbWVZu9UOw4ga6iVC+pBvSqE6YRwFW09id8fZoYbBDFLY0D
         hc1QW8CeA4nbJKF2le73vfNiIHfCzvlQ1XciMXa7Tqzi64+s093VxpTjL3LVNNgfcNdr
         4h1ztsb0Rc38AdYmAUu9ujoq3fMfE9EiKyXViOsqTa9gi7U/h1lOiS/QqjN8e4v+7qVm
         hvZQ==
X-Gm-Message-State: ACgBeo1E2kgPBPjLwUygH6/6z7tP6SLKA1MqnLydiBJTYWTuWEghX1Rq
        y3N0cTQXS6nZrSVfi7keN3AzzqGdRZTFRaOBLxg=
X-Google-Smtp-Source: AA6agR4gSCEGGERtYbfMrbUdD055rL9KFSXYCiEsKiEnI3ZsV82VHr/529eXK7hJ5BxmMY8NBYbSxomKComMuUX9EKc=
X-Received: by 2002:a17:902:e5c1:b0:176:c2b3:6a4c with SMTP id
 u1-20020a170902e5c100b00176c2b36a4cmr28810957plf.87.1663019280658; Mon, 12
 Sep 2022 14:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f537cc05ddef88db@google.com> <0000000000007d793405e87350df@google.com>
In-Reply-To: <0000000000007d793405e87350df@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 12 Sep 2022 14:47:48 -0700
Message-ID: <CAHbLzkp6BEaM8cFwLsCiYmGaR-LxbG8z-f_bz2ijL+K27zR4GQ@mail.gmail.com>
Subject: Re: [syzbot] BUG: Bad page map (5)
To:     syzbot <syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com>,
        "Zach O'Keefe" <zokeefe@google.com>
Cc:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bigeasy@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 9:27 PM syzbot
<syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    e47eb90a0a9a Add linux-next specific files for 20220901
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=17330430880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7933882276523081
> dashboard link: https://syzkaller.appspot.com/bug?extid=915f3e317adb0e85835f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13397b77080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1793564f080000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com
>
> BUG: Bad page map in process syz-executor198  pte:8000000071c00227 pmd:74b30067
> addr:0000000020563000 vm_flags:08100077 anon_vma:ffff8880547d2200 mapping:0000000000000000 index:20563
> file:(null) fault:0x0 mmap:0x0 read_folio:0x0
> CPU: 1 PID: 3614 Comm: syz-executor198 Not tainted 6.0.0-rc3-next-20220901-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_bad_pte.cold+0x2a7/0x2d0 mm/memory.c:565
>  vm_normal_page+0x10c/0x2a0 mm/memory.c:636
>  hpage_collapse_scan_pmd+0x729/0x1da0 mm/khugepaged.c:1199
>  madvise_collapse+0x481/0x910 mm/khugepaged.c:2433
>  madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1062
>  madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1236
>  do_madvise.part.0+0x24a/0x340 mm/madvise.c:1415
>  do_madvise mm/madvise.c:1428 [inline]
>  __do_sys_madvise mm/madvise.c:1428 [inline]
>  __se_sys_madvise mm/madvise.c:1426 [inline]
>  __x64_sys_madvise+0x113/0x150 mm/madvise.c:1426
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f770ba87929
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f770ba18308 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f770bb0f3f8 RCX: 00007f770ba87929
> RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
> RBP: 00007f770bb0f3f0 R08: 00007f770ba18700 R09: 0000000000000000
> R10: 00007f770ba18700 R11: 0000000000000246 R12: 00007f770bb0f3fc
> R13: 00007ffc2d8b62ef R14: 00007f770ba18400 R15: 0000000000022000
>  </TASK>

I think I figured out the problem. The reproducer actually triggered
the below race in madvise_collapse():

             CPU A
        CPU B
mmap 0x20000000 - 0x21000000 as anon

       madvise_collapse is called on this area

           Retrieve start and end address from the vma (NEVER updated
later!)

           Collapsed the first 2M area and dropped mmap_lock
Acquire mmap_lock
mmap io_uring file at 0x20563000
Release mmap_lock

            Reacquire mmap_lock

            revalidate vma pass since 0x20200000 + 0x200000 >
0x20563000

            scan the next 2M (0x20200000 - 0x20400000), but due to
whatever reason it didn't release mmap_lock

            scan the 3rd 2M area (start from 0x20400000)

              actually scan the new vma created by io_uring since the
end was never updated

The below patch should be able to fix the problem (untested):

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5f7c60b8b269..e708c5d62325 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2441,8 +2441,10 @@ int madvise_collapse(struct vm_area_struct
*vma, struct vm_area_struct **prev,
                memset(cc->node_load, 0, sizeof(cc->node_load));
                result = hpage_collapse_scan_pmd(mm, vma, addr, &mmap_locked,
                                                 cc);
-               if (!mmap_locked)
+               if (!mmap_locked) {
                        *prev = NULL;  /* Tell caller we dropped mmap_lock */
+                       hend = vma->end & HPAGE_PMD_MASK;
+               }

                switch (result) {
                case SCAN_SUCCEED:


>
>
