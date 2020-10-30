Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBC62A0DA5
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbgJ3Smc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgJ3Sma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:42:30 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96010C0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 11:42:30 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s14so5752829qkg.11
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 11:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIX0iUNYmKTGpsjIpq65NL9/sGsFnH8oZZCQcI/WsJo=;
        b=bYlk+E9UZt4DRqoUdZ6MTPapJE+3m7W6ymaVF0A/Ytf9ysgpdiRa2L3mNtWF5+Vqjs
         RUnhj68xulwkUTq7j5c+HznqkyxNCukA4LIN6ia0n8qO/Kg3DtA91F3vJui8So439Q1B
         cggJSTEdzhgvZe1TGhZPgF6lf16mwOJWW8TEp5PTzSQGsuDd3fDgy6s+XiODTahP9RQY
         VB2sNyLygfTA4c91kLbgbihNfNrxuJ4YT+AJzF0Fse4fAzUT/P4vszrp25TBRhOXY4kc
         lTUsNHB/0fpFCNRNNH56EWKkzwpAZ5naDTicUEgS2YMjYDTr3lNkagtjB5K+TxakydPn
         pFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIX0iUNYmKTGpsjIpq65NL9/sGsFnH8oZZCQcI/WsJo=;
        b=q+wuM7Xbmhtrjim/CoVw5ZDokA15xM1md2RlpkZz6u3CmO/bHabK+9BAqlYvEJ4gwj
         eDVJf5nOfUv/fZ4ZyngD80l3aJPBSuiG9i4v5dMcjUjM399us3Wb3wSUGwyeIBslO9m0
         HlbIsrBjWnKUrOJhh3Nww8RiAFWKWXqIxl5w9TcqdEcTawb6v5h7bWQJwnDiAtmk/Ym4
         ZfGHA6C10+kJvtxa4jEhR8LzRDvpPWb+Y4iJOsX6qTiwfnLff5m+OWVUIG2VmRIKsWaQ
         lhioHcf0LP5r3fKsnZmPeUPAyKd/Bfv7eHIqluKfGDQU6TJSZJkI2wdMOoqBFP1K/GKp
         rzLw==
X-Gm-Message-State: AOAM533Z0X8fHtb7z29jqnrxPAYOIc4l5LqFRghOMtIT9iJuMZOGb4Xe
        wOzfrb8L2cdjorddzFAU9+LNxk0STscdbAGOfGt31A==
X-Google-Smtp-Source: ABdhPJwWqIIGNUYiTZ//s/YW0jRWPtDrC/n5h2OIIkwmgvD9ZkczTEC7CFfpCs24TkfvR1NV9DvQppWgtO49wZ3mj+4=
X-Received: by 2002:a37:9747:: with SMTP id z68mr3469115qkd.424.1604083349448;
 Fri, 30 Oct 2020 11:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008caae305ab9a5318@google.com> <000000000000a726a405ada4b6cf@google.com>
 <CAFqZXNvQcjp201ahjLBhYJJCuYqZrYLGDA-wE3hXiJpRNgbTKg@mail.gmail.com> <CAJfpegtzQB09ind8tkYzaiu6ODJvhMKj3myxVS75vbjTcOxU8g@mail.gmail.com>
In-Reply-To: <CAJfpegtzQB09ind8tkYzaiu6ODJvhMKj3myxVS75vbjTcOxU8g@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 30 Oct 2020 19:42:18 +0100
Message-ID: <CACT4Y+Yyxdju4FR-E3bc5ERM6xhecnos6mkJR5==xS+RS_DUuw@mail.gmail.com>
Subject: Re: general protection fault in security_inode_getattr
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        James Morris <jmorris@namei.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 2:02 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Aug 24, 2020 at 11:00 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > On Mon, Aug 24, 2020 at 9:37 PM syzbot
> > <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com> wrote:
> > > syzbot has found a reproducer for the following issue on:
> >
> > Looping in fsdevel and OverlayFS maintainers, as this seems to be
> > FS/OverlayFS related...
>
> Hmm, the oopsing code is always something like:
>
> All code
> ========
>    0: 1b fe                sbb    %esi,%edi
>    2: 49 8d 5e 08          lea    0x8(%r14),%rbx
>    6: 48 89 d8              mov    %rbx,%rax
>    9: 48 c1 e8 03          shr    $0x3,%rax
>    d: 42 80 3c 38 00        cmpb   $0x0,(%rax,%r15,1)
>   12: 74 08                je     0x1c
>   14: 48 89 df              mov    %rbx,%rdi
>   17: e8 bc b4 5b fe        callq  0xfffffffffe5bb4d8
>   1c: 48 8b 1b              mov    (%rbx),%rbx
>   1f: 48 83 c3 68          add    $0x68,%rbx
>   23: 48 89 d8              mov    %rbx,%rax
>   26: 48 c1 e8 03          shr    $0x3,%rax
>   2a:* 42 80 3c 38 00        cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
>   2f: 74 08                je     0x39
>   31: 48 89 df              mov    %rbx,%rdi
>   34: e8 9f b4 5b fe        callq  0xfffffffffe5bb4d8
>   39: 48 8b 1b              mov    (%rbx),%rbx
>   3c: 48 83 c3 0c          add    $0xc,%rbx
>
>
> And that looks (to me) like the unrolled loop in call_int_hook().  I
> don't see how that could be related to overlayfs, though it's
> definitely interesting why it only triggers from
> overlay->vfs_getattr()->security_inode_getattr()...


>   26: 48 c1 e8 03          shr    $0x3,%rax
>   2a:* 42 80 3c 38 00        cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction


This access is part of KASAN check. But the original address kernel
tries to access is NULL, so it's not an issue with KASAN.

The line is this:

int security_inode_getattr(const struct path *path)
{
    if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
        return 0;

So it's either path is NULL, or something in d_backing_inode
dereferences NULL path->dentry.

The reproducer does involve overlayfs:

mkdir(&(0x7f0000000240)='./file1\x00', 0x0)
mkdir(&(0x7f0000000300)='./bus\x00', 0x0)
r0 = creat(&(0x7f00000000c0)='./bus/file1\x00', 0x0)
mkdir(&(0x7f0000000080)='./file0\x00', 0x0)
mount$overlay(0x400002, &(0x7f0000000000)='./bus\x00',
&(0x7f0000000100)='overlay\x00', 0x0,
&(0x7f00000003c0)=ANY=[@ANYBLOB='upperdir=./file1,lowerdir=./bus,workdir=./file0,metacopy=on'])
link(&(0x7f0000000200)='./bus/file1\x00', &(0x7f00000002c0)='./bus/file0\x00')
write$RDMA_USER_CM_CMD_RESOLVE_ADDR(r0, 0x0, 0x0)
acct(&(0x7f0000000040)='./bus/file0\x00')

Though, it may be overlayfs-related, or it may be a generic bug that
requires a tricky reproducer and the only reproducer syzbot come up
with happened to involve overlayfs.
But there are 4 reproducers on syzbot dashboard and all of them
involve overlayfs and they are somewhat different. So my bet would be
on overlayfs.
