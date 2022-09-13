Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06945B7A31
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbiIMSxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiIMSwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:52:53 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35301112
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:39:09 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w20so647201ply.12
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=orbJhFxE5HOptaUTrwjclSlFPR4aOjesoJrXhy8Wtts=;
        b=nxcB8lDUCl73YdcfRhMEAqDdCUdLG4SLHkeUiNjkBu1FXJYofVBUFa3b707o90XVoQ
         dNihqZ1DF3x6fZK+7ed5nOm30GRdc8KQhyxvICRIrCs3q5fbHr7gvEcj9BxAKrVt5ura
         Eyp2ZTlMCeGGRfTF61nOW4+zycbvSDifROf38oAULgtsPWtZws7s+52oUGkNUPMi15Ot
         Elik2yEVEjeh2DhorPYPsoeAn1sUZ8/mZUAvcOOrI4HMR12OCP1bWQ/20ATKVAUw8l8U
         qO/Cu44DX012kPCxBcmORr7Lw4WNaCmPA7gmm2yupvUnKdABmng93qFfAHFEkIX3YiR9
         8GDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=orbJhFxE5HOptaUTrwjclSlFPR4aOjesoJrXhy8Wtts=;
        b=wKk5x5AuNax1bW0e5qQqkDGc3GvlBU9Bg8AieX+dtLoXLd+/ACWazAwLjgWFLuF4Pq
         Vm1Ee+dMDquZvn+X20iR3rgCRX8mQINYc+F9rOids8Ylu4kBhreftu+gTozvD/Siq32s
         nwcls244KGikMHZ7Ufn75uvBEkiFkdK4K0wHEiKBmj4mUybcqPBtPeAxw6iQoiZL2Cc5
         lkFO/sXWQjyH9iBn6e0zWbKTQ0aAxTrKxRlaHeCFPPJAY/qBFv6nQpI0N+8oneeQIga/
         wSGc1PKgV/RkS6e2MzQ0uWXwjTr9n45vrdX0Y4tfRJ1E4z129q5QKmsN2A8jzxJ4iaan
         j01g==
X-Gm-Message-State: ACgBeo2jaa/QF/9NCdsagqP8Qeo0C93P8+Ncz9La+qvPoPN4Ka59aFWc
        8+JUjyX/XzGS4whrKlkBrh3W5g==
X-Google-Smtp-Source: AA6agR61gyqGv+L8wy1gCw1IQiL+Enkebzh35P2+foq3IsCkwYcjENVQSf0fRVd990XYSixuJQXJIQ==
X-Received: by 2002:a17:902:e2d3:b0:176:e97a:d3eb with SMTP id l19-20020a170902e2d300b00176e97ad3ebmr31754197plc.172.1663094349141;
        Tue, 13 Sep 2022 11:39:09 -0700 (PDT)
Received: from google.com (33.5.83.34.bc.googleusercontent.com. [34.83.5.33])
        by smtp.gmail.com with ESMTPSA id p67-20020a625b46000000b00540d03f3792sm8193827pfb.81.2022.09.13.11.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 11:39:08 -0700 (PDT)
Date:   Tue, 13 Sep 2022 11:39:05 -0700
From:   Zach O'Keefe <zokeefe@google.com>
To:     Yang Shi <shy828301@gmail.com>
Cc:     syzbot <syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bigeasy@linutronix.de, bpf@vger.kernel.org, brauner@kernel.org,
        daniel@iogearbox.net, david@redhat.com, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, yhs@fb.com
Subject: Re: [syzbot] BUG: Bad page map (5)
Message-ID: <YyDOSbLrUx6KbX+R@google.com>
References: <000000000000f537cc05ddef88db@google.com>
 <0000000000007d793405e87350df@google.com>
 <CAHbLzkp6BEaM8cFwLsCiYmGaR-LxbG8z-f_bz2ijL+K27zR4GQ@mail.gmail.com>
 <CAHbLzkrr3PvKjs2vanVi5JFTQQ3R7hSNRWoHhAw+gBWOcFurcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkrr3PvKjs2vanVi5JFTQQ3R7hSNRWoHhAw+gBWOcFurcw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sep 13 09:14, Yang Shi wrote:
> On Mon, Sep 12, 2022 at 2:47 PM Yang Shi <shy828301@gmail.com> wrote:
> >
> > On Sun, Sep 11, 2022 at 9:27 PM syzbot
> > <syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com> wrote:
> > >
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    e47eb90a0a9a Add linux-next specific files for 20220901
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=17330430880000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=7933882276523081
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=915f3e317adb0e85835f
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13397b77080000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1793564f080000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+915f3e317adb0e85835f@syzkaller.appspotmail.com
> > >
> > > BUG: Bad page map in process syz-executor198  pte:8000000071c00227 pmd:74b30067
> > > addr:0000000020563000 vm_flags:08100077 anon_vma:ffff8880547d2200 mapping:0000000000000000 index:20563
> > > file:(null) fault:0x0 mmap:0x0 read_folio:0x0
> > > CPU: 1 PID: 3614 Comm: syz-executor198 Not tainted 6.0.0-rc3-next-20220901-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:88 [inline]
> > >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> > >  print_bad_pte.cold+0x2a7/0x2d0 mm/memory.c:565
> > >  vm_normal_page+0x10c/0x2a0 mm/memory.c:636
> > >  hpage_collapse_scan_pmd+0x729/0x1da0 mm/khugepaged.c:1199
> > >  madvise_collapse+0x481/0x910 mm/khugepaged.c:2433
> > >  madvise_vma_behavior+0xd0a/0x1cc0 mm/madvise.c:1062
> > >  madvise_walk_vmas+0x1c7/0x2b0 mm/madvise.c:1236
> > >  do_madvise.part.0+0x24a/0x340 mm/madvise.c:1415
> > >  do_madvise mm/madvise.c:1428 [inline]
> > >  __do_sys_madvise mm/madvise.c:1428 [inline]
> > >  __se_sys_madvise mm/madvise.c:1426 [inline]
> > >  __x64_sys_madvise+0x113/0x150 mm/madvise.c:1426
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7f770ba87929
> > > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007f770ba18308 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> > > RAX: ffffffffffffffda RBX: 00007f770bb0f3f8 RCX: 00007f770ba87929
> > > RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000000020000000
> > > RBP: 00007f770bb0f3f0 R08: 00007f770ba18700 R09: 0000000000000000
> > > R10: 00007f770ba18700 R11: 0000000000000246 R12: 00007f770bb0f3fc
> > > R13: 00007ffc2d8b62ef R14: 00007f770ba18400 R15: 0000000000022000
> > >  </TASK>
> >
> > I think I figured out the problem. The reproducer actually triggered
> > the below race in madvise_collapse():
> >
> >              CPU A
> >         CPU B
> > mmap 0x20000000 - 0x21000000 as anon
> >
> >        madvise_collapse is called on this area
> >
> >            Retrieve start and end address from the vma (NEVER updated
> > later!)
> >
> >            Collapsed the first 2M area and dropped mmap_lock
> > Acquire mmap_lock
> > mmap io_uring file at 0x20563000
> > Release mmap_lock
> >
> >             Reacquire mmap_lock
> >
> >             revalidate vma pass since 0x20200000 + 0x200000 >
> > 0x20563000
> >
> >             scan the next 2M (0x20200000 - 0x20400000), but due to
> > whatever reason it didn't release mmap_lock
> >
> >             scan the 3rd 2M area (start from 0x20400000)
> >
> >               actually scan the new vma created by io_uring since the
> > end was never updated
> >
> > The below patch should be able to fix the problem (untested):
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 5f7c60b8b269..e708c5d62325 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2441,8 +2441,10 @@ int madvise_collapse(struct vm_area_struct
> > *vma, struct vm_area_struct **prev,
> >                 memset(cc->node_load, 0, sizeof(cc->node_load));
> >                 result = hpage_collapse_scan_pmd(mm, vma, addr, &mmap_locked,
> >                                                  cc);
> > -               if (!mmap_locked)
> > +               if (!mmap_locked) {
> >                         *prev = NULL;  /* Tell caller we dropped mmap_lock */
> > +                       hend = vma->end & HPAGE_PMD_MASK;
> > +               }
> 
> This is wrong. We should refetch the vma end after
> hugepage_vma_revalidate() otherwise the vma is still the old one.
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a3acd3e5e0f3..1860be232a26 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2592,6 +2592,8 @@ int madvise_collapse(struct vm_area_struct *vma,
> struct vm_area_struct **prev,
>                                 last_fail = result;
>                                 goto out_nolock;
>                         }
> +
> +                       hend = vma->vm_end & HPAGE_PMD_MASK;
>                 }
>                 mmap_assert_locked(mm);
>                 memset(cc->node_load, 0, sizeof(cc->node_load));
> 
> 
> >
> >                 switch (result) {
> >                 case SCAN_SUCCEED:
> >
> >

Hey Yang,

Thanks for triaging this, and apologies for intro'ing this bug.

Also thank you for the repro explanation - I believe you are correct here.

Generalizing the issue of:

	1) hugepage_vma_revalidate() pmd X
	2) collapse of pmd X doesn't drop mmap_lock
	3) don't revalidate pmd X+1
	4) attempt collapse of pmd X+1

I think the only problem is that

	hugepage_vma_revalidate()
		transhuge_vma_suitable()

only checks if a single hugepage-sized/aligned region properly fits / is aligned
in the VMA (i.e. the issue you found here).  All other checks should be
intrinsic to the VMA itself and should be safe to skip if mmap_lock isn't
dropped since last hugepage_vma_revalidate().

As for the fix, I think your fix will work.  If a VMA's size changes inside the
main for-loop of madvise_collapse, then at some point we will lock mmap_lock and
call hugepage_vma_revalidate(), which might fail itself if the next
hugepage-aligned/sized region is now not contained in the VMA.  By updating
"hend" as you propose (i.e. using vma->m_end of the just-found VMA), we also
ensure that for "addr" < "hend", the hugepage-aligned/sized region at "addr"
will fit into the VMA.  Note that we don't need to worry about the VMA being
shrank from the other direction, so updating "hend" should be enough.

I think the fix is fine as-is.  I briefly thought a comment would be nice, but I
think the code is self evident.  The alternative is introing another
transhuge_vma_suitable() call in the "if (!mmap_locked) { .. } else { .. }"
failure path, but I think your approach is easier to read.

Thanks again for taking the time to debug this, and hopefully I can be more
careful in the future.

Best,
Zach

Reviewed-by: Zach O'Keefe <zokeefe@google.com>

