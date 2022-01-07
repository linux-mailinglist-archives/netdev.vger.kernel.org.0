Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF9B4872CC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 06:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiAGFmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 00:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAGFmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 00:42:36 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B607C061245;
        Thu,  6 Jan 2022 21:42:36 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d201so13794652ybc.7;
        Thu, 06 Jan 2022 21:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cvp0ba44kcAFvCOob5GGGooOUhpAsXQc7Exr9LrVl6M=;
        b=dRjkcgeZIvAGYGN7UaPliigog5s9kWF4+MdfeYFXrR85HDOXTa1WNJqeYwhVOfQOJi
         zIdk0MG/iWo591VuzLq+Isbu1clIcwwD/Q7/D199mCuQD5bVCUukg/bSMbsieS6aAlS1
         /llSlsSBY/5NXbyzgtIZI6h4pMVW+PJGw/quWLS/FP9etvPzaYH2Gh3ubzRw30NTA6E5
         zX1tN3zX6Cxl3MDDpU2zkLOR73N2gNAZnFYCuTVBtAqkKFNQBaLpx/0siSFRvSJBWOoY
         vn51gzJ/gvQBYJNUPHHByNuWRp+rvdAW4MEvntcQFSFzNSEZ4hdWy65Bh8127LxKY1kw
         uooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cvp0ba44kcAFvCOob5GGGooOUhpAsXQc7Exr9LrVl6M=;
        b=BZRIJiUy6pvJa+BXIP70sj/ThvQ8atgXCY20DZm323FqV7cdprX+X7LjKh6wc3iJse
         JOSbP342YRUfpayqS/hvwaBBVfGJ5hI+xG+ZR4FMro69IA5opFxBzZf1l6lcYL3OL9T7
         NglkjBjTrqxXhUOltEoTJZpS4CaLcndc7zA3yo7925h7L88CMfLnV+u6W6VZcXWHzl5p
         qu2YkI07G4HRONlJ7XiZx/z4CB6WLLjaF2qOlLjk72pcEFMFnCtSeDxHS3Cp+fTBgUji
         IGxjg1snpVmsebpoxor/HgcZvU2HmzVsKvDpEHGpDejMtklItnSANVxRaDQwgIKsZLQy
         vpYw==
X-Gm-Message-State: AOAM530auSspIyy8GLo+M0k3naMP/MX89XA4GppAP5aKaYkcNR5qGOxK
        OfLQ2B0LPj/5foOQSF6ErxGF7ART9xDcUbeKtEU=
X-Google-Smtp-Source: ABdhPJzypfmG9jpylqgbb9JtkqEICZRB7z1wwlvhoF+oCI1fKxqKRnqjkkvXv291X2u5NnrhyBDcNHCqmbOKUDXirRA=
X-Received: by 2002:a25:e705:: with SMTP id e5mr30480524ybh.618.1641534154571;
 Thu, 06 Jan 2022 21:42:34 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
 <CAADnVQJK5mPOB7B4KBa6q1NRYVQx1Eya5mtNb6=L0p-BaCxX=w@mail.gmail.com>
 <CAFcO6XMxZqQo4_C7s0T2dv3JRn4Vq4RDFqJO6ZQFr6kZzsnx9g@mail.gmail.com>
 <bc4e05a5-5d97-2da0-0f18-b7fa55799158@fb.com> <CAFcO6XMrDkx_eyHx=hRYwmsg0PHeJ78Oyuf1AgD_RYM7FY1CFQ@mail.gmail.com>
 <eb8b590a-fb3c-efc0-b879-96d03f38c159@fb.com>
In-Reply-To: <eb8b590a-fb3c-efc0-b879-96d03f38c159@fb.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Fri, 7 Jan 2022 13:42:23 +0800
Message-ID: <CAFcO6XMyL415YuyhJGP+wyw2xEmtSrtfLzc47+pE-RC88u=8sg@mail.gmail.com>
Subject: Re: A slab-out-of-bounds Read bug in __htab_map_lookup_and_delete_batch
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, I'll check it out. The call needs CAP_SYS_ADMIN capability, You
can try once again as a root.
Yes, I have debugged it many times. There are multi threads race to
ioctl, it increases debug difficulty.


On Fri, Jan 7, 2022 at 12:02 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/6/22 7:25 PM, butt3rflyh4ck wrote:
> > Ok, I just reproduce the issue with the latest bpf-next tree.
>
> I cannot reproduce with bpf-next tree. My bpf-next tree top commit is
>    70bc793382a0 selftests/bpf: Don't rely on preserving volatile in
> PT_REGS macros in loop3
>
> The config difference between mine and the one you provided.
>
> $ diff .config ~/crash-config
> --- .config     2022-01-06 19:29:10.859839241 -0800
> +++ /home/yhs/crash-config      2022-01-06 19:27:22.262595087 -0800
> @@ -2,16 +2,17 @@
>   # Automatically generated file; DO NOT EDIT.
>   # Linux/x86 5.16.0-rc7 Kernel Configuration
>   #
> -CONFIG_CC_VERSION_TEXT="gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-3)"
> +CONFIG_CC_VERSION_TEXT="gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
>   CONFIG_CC_IS_GCC=y
> -CONFIG_GCC_VERSION=80500
> +CONFIG_GCC_VERSION=90300
>   CONFIG_CLANG_VERSION=0
>   CONFIG_AS_IS_GNU=y
> -CONFIG_AS_VERSION=23000
> +CONFIG_AS_VERSION=23400
>   CONFIG_LD_IS_BFD=y
> -CONFIG_LD_VERSION=23000
> +CONFIG_LD_VERSION=23400
>   CONFIG_LLD_VERSION=0
>   CONFIG_CC_CAN_LINK=y
> +CONFIG_CC_CAN_LINK_STATIC=y
>   CONFIG_CC_HAS_ASM_GOTO=y
>   CONFIG_CC_HAS_ASM_INLINE=y
>   CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
> @@ -117,7 +118,7 @@
>   CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
>   CONFIG_USERMODE_DRIVER=y
>   CONFIG_BPF_PRELOAD=y
> -CONFIG_BPF_PRELOAD_UMD=m
> +CONFIG_BPF_PRELOAD_UMD=y
>   # CONFIG_BPF_LSM is not set
>   # end of BPF subsystem
>
> @@ -8456,7 +8457,6 @@
>   # CONFIG_DEBUG_INFO_DWARF4 is not set
>   # CONFIG_DEBUG_INFO_DWARF5 is not set
>   # CONFIG_DEBUG_INFO_BTF is not set
> -CONFIG_PAHOLE_HAS_SPLIT_BTF=y
>   # CONFIG_GDB_SCRIPTS is not set
>   CONFIG_FRAME_WARN=2048
>   # CONFIG_STRIP_ASM_SYMS is not set
>
> The main difference is compiler and maybe a couple of other things
> which I think should not impact the result.
>
> > On Fri, Jan 7, 2022 at 9:19 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 12/29/21 7:23 PM, butt3rflyh4ck wrote:
> >>> Hi, the attachment is a reproducer. Enjoy it.
> >>>
> >>> Regards,
> >>>      butt3rflyh4ck.
> >>>
> >>>
> >>> On Thu, Dec 30, 2021 at 10:23 AM Alexei Starovoitov
> >>> <alexei.starovoitov@gmail.com> wrote:
> >>>>
> >>>> On Wed, Dec 29, 2021 at 2:10 AM butt3rflyh4ck
> >>>> <butterflyhuangxx@gmail.com> wrote:
> >>>>>
> >>>>> Hi, there is a slab-out-bounds Read bug in
> >>>>> __htab_map_lookup_and_delete_batch in kernel/bpf/hashtab.c
> >>>>> and I reproduce it in linux-5.16.rc7(upstream) and latest linux-5.15.11.
> >>>>>
> >>>>> #carsh log
> >>>>> [  166.945208][ T6897]
> >>>>> ==================================================================
> >>>>> [  166.947075][ T6897] BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x87/0xb0
> >>>>> [  166.948612][ T6897] Read of size 49 at addr ffff88801913f800 by
> >>>>> task __htab_map_look/6897
> >>>>> [  166.950406][ T6897]
> >>>>> [  166.950890][ T6897] CPU: 1 PID: 6897 Comm: __htab_map_look Not
> >>>>> tainted 5.16.0-rc7+ #30
> >>>>> [  166.952521][ T6897] Hardware name: QEMU Standard PC (i440FX + PIIX,
> >>>>> 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
> >>>>> [  166.954562][ T6897] Call Trace:
> >>>>> [  166.955268][ T6897]  <TASK>
> >>>>> [  166.955918][ T6897]  dump_stack_lvl+0x57/0x7d
> >>>>> [  166.956875][ T6897]  print_address_description.constprop.0.cold+0x93/0x347
> >>>>> [  166.958411][ T6897]  ? _copy_to_user+0x87/0xb0
> >>>>> [  166.959356][ T6897]  ? _copy_to_user+0x87/0xb0
> >>>>> [  166.960272][ T6897]  kasan_report.cold+0x83/0xdf
> >>>>> [  166.961196][ T6897]  ? _copy_to_user+0x87/0xb0
> >>>>> [  166.962053][ T6897]  kasan_check_range+0x13b/0x190
> >>>>> [  166.962978][ T6897]  _copy_to_user+0x87/0xb0
> >>>>> [  166.964340][ T6897]  __htab_map_lookup_and_delete_batch+0xdc2/0x1590
> >>>>> [  166.965619][ T6897]  ? htab_lru_map_update_elem+0xe70/0xe70
> >>>>> [  166.966732][ T6897]  bpf_map_do_batch+0x1fa/0x460
> >>>>> [  166.967619][ T6897]  __sys_bpf+0x99a/0x3860
> >>>>> [  166.968443][ T6897]  ? bpf_link_get_from_fd+0xd0/0xd0
> >>>>> [  166.969393][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
> >>>>> [  166.970425][ T6897]  ? lock_acquire+0x1ab/0x520
> >>>>> [  166.971284][ T6897]  ? find_held_lock+0x2d/0x110
> >>>>> [  166.972208][ T6897]  ? rcu_read_lock_sched_held+0x9c/0xd0
> >>>>> [  166.973139][ T6897]  ? rcu_read_lock_bh_held+0xb0/0xb0
> >>>>> [  166.974096][ T6897]  __x64_sys_bpf+0x70/0xb0
> >>>>> [  166.974903][ T6897]  ? syscall_enter_from_user_mode+0x21/0x70
> >>>>> [  166.976077][ T6897]  do_syscall_64+0x35/0xb0
> >>>>> [  166.976889][ T6897]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> [  166.978027][ T6897] RIP: 0033:0x450f0d
> >>>>>
> >>>>>
> >>>>> In hashtable, if the elements' keys have the same jhash() value, the
> >>>>> elements will be put into the same bucket.
> >>>>> By putting a lot of elements into a single bucket, the value of
> >>>>> bucket_size can be increased to overflow.
> >>>>>    but also we can increase bucket_cnt to out of bound Read.
>
> But here bucket_size equals to bucket_cnt (the number of elements in a
> bucket), bucket_cnt has u32 type. The hash table max_entries maximum is
> UINT_MAX, so bucket_cnt can at most be UINT_MAX. So I am not sure
> how bucket_size/bucket_cnt could overflow. Even if bucket_cnt overflows,
> it will wrap as 0 which should not cause issues either.
>
> Maybe I missed something here. Since you can reproduce it, maybe you can
> help debug it a little bit more. It would be even better if you can
> provide a fix. Thanks.
>
> >>
> >> I tried the attachment (reproducer) and cannot reproduce the issue
> >> with latest bpf-next tree.
> >> My config has kasan enabled. Could you send the matching .config file
> >> as well so I could reproduce?
> >>
> >>>>
> >>>> Can you be more specific?
> >>>> If you can send a patch with a fix it would be even better.
> >>>>
> >>>>> the out of bound Read in  __htab_map_lookup_and_delete_batch code:
> >>>>> ```
> >>>>> ...
> >>>>> if (bucket_cnt && (copy_to_user(ukeys + total * key_size, keys,
> >>>>> key_size * bucket_cnt) ||
> >>>>>       copy_to_user(uvalues + total * value_size, values,
> >>>>>       value_size * bucket_cnt))) {
> >>>>> ret = -EFAULT;
> >>>>> goto after_loop;
> >>>>> }
> >>>>> ...
> >>>>> ```
> [...]



-- 
Active Defense Lab of Venustech
