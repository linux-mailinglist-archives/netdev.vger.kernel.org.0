Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14675B3D7C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiIIQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiIIQxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:53:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63C7E000
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 09:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662742384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TgO3N0qP8iuZUQ578O33EC3J9Pns4trql2X/6qLcYJc=;
        b=WBJRFpFlbboOttVwSnUJlc3aLBY9wKePOFKZAiaty7YfRUUjQZ9kTTUrq22elq+BU0Q5lD
        yYXGrWHdwrMXhC14wRB8MdcrgL+U/ku6tsMlslRRLXQ2EVjzcyhRnOulBXjX7lWwvz4pwl
        BAWu2GyNtYdEDVESXtGwyrTm7SkfUgY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-114-yD6BTEVhMGyv9Fber9zybA-1; Fri, 09 Sep 2022 12:53:03 -0400
X-MC-Unique: yD6BTEVhMGyv9Fber9zybA-1
Received: by mail-pl1-f199.google.com with SMTP id o5-20020a1709026b0500b001755c286c81so1600683plk.14
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 09:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TgO3N0qP8iuZUQ578O33EC3J9Pns4trql2X/6qLcYJc=;
        b=I9HTVbhww4LJoYCG1xEhnS+OFF7sj6j/3xmyd300XITEfRkcng+erHFeOp7HOLgVGB
         +fRw4QQoG8bt6sW570vtrexfWL1zyZgqUttmIj45d9ExhZjkrRU+WWlipRxbB4/Rn/5Q
         2zYPKvLMDiC5OsIjRt8oGRoNRofj4SjC+8DwhszW6xl0RdiUPDjs7he2/qLtwZ/WWBvv
         aEDA81ifHCftpQmhewoEyGNd+1jsNHiaKZ/NNJNbEUkvXlYca0Nav6hp+2seyTUrAIkw
         hGQvUld7bsghr/vGoIyNtPGEgkJNGRNOhpVEaTvwSUF4ctp2R6ErmA+SkT3wAe9WtMYy
         6Hvg==
X-Gm-Message-State: ACgBeo3LfQFEx0ouZUtSMRIq27d0DJ+4gla30N3Own3tOZvRmIYjzvT1
        qXcDsy+E40UBB+YoB9mwlIix9WNKY7EH3H58cz7VDz9Q3OMsVG5eDkjbGfOVRVs3i2UuwwH6fiy
        0DSecjkxG3UNcv+DSWehEzWC3sLa9HmaM
X-Received: by 2002:a63:d10b:0:b0:41d:bd7d:7759 with SMTP id k11-20020a63d10b000000b0041dbd7d7759mr12939032pgg.196.1662742379916;
        Fri, 09 Sep 2022 09:52:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7SM7G0m4RJYj2cNzM3FrNcQUKszjetNj3hFRPDTH9yWCQT63+rSnjg+MtmeGpwn60vLcyxNRP/pbnvQi7VeS0=
X-Received: by 2002:a63:d10b:0:b0:41d:bd7d:7759 with SMTP id
 k11-20020a63d10b000000b0041dbd7d7759mr12939005pgg.196.1662742379643; Fri, 09
 Sep 2022 09:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e506e905e836d9e7@google.com> <YxtrrG8ebrarIqnc@google.com>
In-Reply-To: <YxtrrG8ebrarIqnc@google.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 9 Sep 2022 18:52:48 +0200
Message-ID: <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
To:     sdf@google.com
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        haoluo@google.com, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>, kuba@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev,
        martin.lau@linux.dev, nathan@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, Song Liu <song@kernel.org>,
        syzkaller-bugs@googlegroups.com, Tom Rix <trix@redhat.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 6:37 PM <sdf@google.com> wrote:
>
> On 09/08, syzbot wrote:
> > Hello,
>
> > syzbot found the following issue on:
>
> > HEAD commit:    7e18e42e4b28 Linux 6.0-rc4
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1551da55080000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=f4d613baa509128c
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=8b2a08dfbd25fd933d75
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU
> > Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1798cab7080000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ccbdc5080000
>
> > Downloadable assets:
> > disk image:
> > https://storage.googleapis.com/syzbot-assets/da260c675b46/disk-7e18e42e.raw.xz
> > vmlinux:
> > https://storage.googleapis.com/syzbot-assets/58f7bbbaa6ff/vmlinux-7e18e42e.xz
>
> > IMPORTANT: if you fix the issue, please add the following tag to the
> > commit:
> > Reported-by: syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com
>
> > ------------[ cut here ]------------
> > verifier log line truncated - local buffer too short
> > WARNING: CPU: 1 PID: 3604 at kernel/bpf/verifier.c:300
> > bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> > Modules linked in:
> > CPU: 1 PID: 3604 Comm: syz-executor146 Not tainted 6.0.0-rc4-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 08/26/2022
> > RIP: 0010:bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> > Code: f5 95 3d 0c 31 ff 89 ee e8 06 07 f0 ff 40 84 ed 75 1a e8 7c 0a f0
> > ff 48 c7 c7 c0 e7 f3 89 c6 05 d4 95 3d 0c 01 e8 fb 4c ae 07 <0f> 0b e8 62
> > 0a f0 ff 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1
> > RSP: 0018:ffffc900039bf8a0 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: ffff888017a19210 RCX: 0000000000000000
> > RDX: ffff888021fb1d80 RSI: ffffffff8161f408 RDI: fffff52000737f06
> > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff89f5aba0
> > R13: 00000000000003ff R14: ffff888017a19214 R15: ffff888012705800
> > FS:  0000555555cba300(0000) GS:ffff8880b9b00000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020100000 CR3: 000000001bf9e000 CR4: 0000000000350ee0
> > Call Trace:
> >   <TASK>
> >   __btf_verifier_log+0xbb/0xf0 kernel/bpf/btf.c:1375
> >   __btf_verifier_log_type+0x451/0x8f0 kernel/bpf/btf.c:1413
> >   btf_func_proto_check_meta+0x117/0x160 kernel/bpf/btf.c:3905
> >   btf_check_meta kernel/bpf/btf.c:4588 [inline]
> >   btf_check_all_metas+0x3c1/0xa70 kernel/bpf/btf.c:4612
> >   btf_parse_type_sec kernel/bpf/btf.c:4748 [inline]
>
> Benjamin, this seems to be coming from BTF loading. Could this be caused
> by some of your recent activity with things like:
>
> commit f9b348185f4d684cc19e6bd9b87904823d5aa5ed
> Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Date:   Tue Sep 6 17:13:01 2022 +0200
>
>      bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
>
> ?

I doubt this commit is the culprit for 2 reasons:
- BTF_KFUNC_SET_MAX_CNT just sets the size of an internal memory chunk
where we store kfunc definitions. I don't really see how this could be
linked to a verifier log being full
- this commit has been applied on Sep 7, and the first crash in the
dashboard was from Sep 5. So unless the dates are wrong, I don't think
this commit creates the crash.

Unfortunately, I am really new into the bpf/btf world, and I have no
ideas on what could be the cause of that crash. We probably need a
bisect, but I'll be out next week at plumbers, so can't really work on
that now.

Cheers,
Benjamin

>
> I haven't looked too deep, maybe you can give it a shot? There is
> reproducer; should be relatively easy to verify. Thx.
>
>
> >   btf_parse kernel/bpf/btf.c:5031 [inline]
> >   btf_new_fd+0x939/0x1e70 kernel/bpf/btf.c:6710
> >   bpf_btf_load kernel/bpf/syscall.c:4314 [inline]
> >   __sys_bpf+0x13bd/0x6130 kernel/bpf/syscall.c:4998
> >   __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
> >   __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
> >   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5055
> >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7fb092221c29
> > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89
> > f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0
> > ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fff5b0a6878 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb092221c29
> > RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000012
> > RBP: 00007fb0921e5dd0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb0921e5e60
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> >   </TASK>
>
>
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>

