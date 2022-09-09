Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF25B4039
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 21:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIITyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 15:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiIITyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 15:54:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79715AE879
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 12:54:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id bt5-20020a056a00438500b0053b090003b0so1544013pfb.16
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 12:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=wDqXtVdMTs92PAybMF9uPUfYKImKnY+xxkOefLyhhOo=;
        b=sg2xmuzSAkVb5rHOakkJbiWux+Kyumc9+s9d4lwhMiGR13oYg0voahRvR1u3iuk3Iw
         nWYP8c8zBb9wq129sQu9r3rftIhn39KCcTaItMcZ7N1SJONbn5JLvstrLCWdGkDZS2Tr
         Hkstl4AeA3E/qhJD8snl9z8eIOgm89LcLlNmmjzGR74cm2bZHlJpuhxGZzne/ZW5GCtw
         UTOS1JsddAAiZHPc6CisiOGd2X5Y1fDvGrMWWDmqYgbcIr7TjTEUBOE/E5B2rjckuQuh
         qpgHWZ4tr/h1M+s3SBsvJbJeIj9GW1q7DHF2fEgcDHdGoX9Wm84WCCKeZSEC2LTNnhUz
         TMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=wDqXtVdMTs92PAybMF9uPUfYKImKnY+xxkOefLyhhOo=;
        b=f1sk+WoCW0J2i2tPgbD79BPhMw5jitgV0d3er4dS7ncG5wRV91x73BS+M1LNT2KyQO
         1fr89CVN2IMOyvMjMU4qYNGVByEd0I5ohcbC916524Ho7Go+UaFRzrQGndL3nbVdFSOg
         +dbOD+k+wd7Bd0mM/YMiEx1Fgeg3gi/IvARWU6W8RjFaYzDANx5Cehc+aehIw7BY4UxQ
         IKiIR+TqngxpsWAJDupVm8NKMR+qd5T58KeG1AlZm6FlFZPs7UsN2Te3Jsp28ncOnlmN
         vW1/lROL33arosU+ke6lsUrx0mYby7iRLZjlU1duc7Im7l2uF6Vs5Ztkep9re6hzw4Vw
         27gA==
X-Gm-Message-State: ACgBeo1L4yjYWsAM+G31wWA51yAdQZt6db/JLHpMsaJh/u/taQEFlPyi
        thJAETh63sqn0jggxUpOOpA15XA=
X-Google-Smtp-Source: AA6agR4CQZbGQZLua9AlfJ0wnXvadUpnEPyS+tmL6wetKl5rc2KatDjBrUR9v84zkOlRSS1k7sGI18c=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr261648pje.0.1662753248222; Fri, 09 Sep
 2022 12:54:08 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:54:06 -0700
In-Reply-To: <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
Mime-Version: 1.0
References: <000000000000e506e905e836d9e7@google.com> <YxtrrG8ebrarIqnc@google.com>
 <CAO-hwJJyrhmzWY4fth5miiHd3QXHvs4KPuPRacyNp8xrTxOucA@mail.gmail.com>
Message-ID: <YxuZ3j0PE0cauK1E@google.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
From:   sdf@google.com
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09, Benjamin Tissoires wrote:
> On Fri, Sep 9, 2022 at 6:37 PM <sdf@google.com> wrote:
> >
> > On 09/08, syzbot wrote:
> > > Hello,
> >
> > > syzbot found the following issue on:
> >
> > > HEAD commit:    7e18e42e4b28 Linux 6.0-rc4
> > > git tree:       upstream
> > > console+strace:  
> https://syzkaller.appspot.com/x/log.txt?x=1551da55080000
> > > kernel config:   
> https://syzkaller.appspot.com/x/.config?x=f4d613baa509128c
> > > dashboard link:
> > > https://syzkaller.appspot.com/bug?extid=8b2a08dfbd25fd933d75
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU
> > > Binutils for Debian) 2.35.2
> > > syz repro:       
> https://syzkaller.appspot.com/x/repro.syz?x=1798cab7080000
> > > C reproducer:    
> https://syzkaller.appspot.com/x/repro.c?x=16ccbdc5080000
> >
> > > Downloadable assets:
> > > disk image:
> > >  
> https://storage.googleapis.com/syzbot-assets/da260c675b46/disk-7e18e42e.raw.xz
> > > vmlinux:
> > >  
> https://storage.googleapis.com/syzbot-assets/58f7bbbaa6ff/vmlinux-7e18e42e.xz
> >
> > > IMPORTANT: if you fix the issue, please add the following tag to the
> > > commit:
> > > Reported-by: syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com
> >
> > > ------------[ cut here ]------------
> > > verifier log line truncated - local buffer too short
> > > WARNING: CPU: 1 PID: 3604 at kernel/bpf/verifier.c:300
> > > bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> > > Modules linked in:
> > > CPU: 1 PID: 3604 Comm: syz-executor146 Not tainted  
> 6.0.0-rc4-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine,  
> BIOS
> > > Google 08/26/2022
> > > RIP: 0010:bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> > > Code: f5 95 3d 0c 31 ff 89 ee e8 06 07 f0 ff 40 84 ed 75 1a e8 7c 0a  
> f0
> > > ff 48 c7 c7 c0 e7 f3 89 c6 05 d4 95 3d 0c 01 e8 fb 4c ae 07 <0f> 0b  
> e8 62
> > > 0a f0 ff 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1
> > > RSP: 0018:ffffc900039bf8a0 EFLAGS: 00010282
> > > RAX: 0000000000000000 RBX: ffff888017a19210 RCX: 0000000000000000
> > > RDX: ffff888021fb1d80 RSI: ffffffff8161f408 RDI: fffff52000737f06
> > > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > > R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff89f5aba0
> > > R13: 00000000000003ff R14: ffff888017a19214 R15: ffff888012705800
> > > FS:  0000555555cba300(0000) GS:ffff8880b9b00000(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000020100000 CR3: 000000001bf9e000 CR4: 0000000000350ee0
> > > Call Trace:
> > >   <TASK>
> > >   __btf_verifier_log+0xbb/0xf0 kernel/bpf/btf.c:1375
> > >   __btf_verifier_log_type+0x451/0x8f0 kernel/bpf/btf.c:1413
> > >   btf_func_proto_check_meta+0x117/0x160 kernel/bpf/btf.c:3905
> > >   btf_check_meta kernel/bpf/btf.c:4588 [inline]
> > >   btf_check_all_metas+0x3c1/0xa70 kernel/bpf/btf.c:4612
> > >   btf_parse_type_sec kernel/bpf/btf.c:4748 [inline]
> >
> > Benjamin, this seems to be coming from BTF loading. Could this be caused
> > by some of your recent activity with things like:
> >
> > commit f9b348185f4d684cc19e6bd9b87904823d5aa5ed
> > Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Date:   Tue Sep 6 17:13:01 2022 +0200
> >
> >      bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
> >
> > ?

> I doubt this commit is the culprit for 2 reasons:
> - BTF_KFUNC_SET_MAX_CNT just sets the size of an internal memory chunk
> where we store kfunc definitions. I don't really see how this could be
> linked to a verifier log being full
> - this commit has been applied on Sep 7, and the first crash in the
> dashboard was from Sep 5. So unless the dates are wrong, I don't think
> this commit creates the crash.

> Unfortunately, I am really new into the bpf/btf world, and I have no
> ideas on what could be the cause of that crash. We probably need a
> bisect, but I'll be out next week at plumbers, so can't really work on
> that now.

Yeah, good point. I've run the repro. I think the issue is that
syzkaller is able to pass btf with a super long random name which
then hits BPF_VERIFIER_TMP_LOG_SIZE while printing the verifier
log line. Seems like a non-issue to me, but maybe we need to
add some extra validation..

Sorry for tagging you here, you were that last to touch that
kernel/bpf/btf.c so were an obvious target :-) But it seems like
it's just a coincidence, the issue still happens on 5.19.

> Cheers,
> Benjamin

> >
> > I haven't looked too deep, maybe you can give it a shot? There is
> > reproducer; should be relatively easy to verify. Thx.
> >
> >
> > >   btf_parse kernel/bpf/btf.c:5031 [inline]
> > >   btf_new_fd+0x939/0x1e70 kernel/bpf/btf.c:6710
> > >   bpf_btf_load kernel/bpf/syscall.c:4314 [inline]
> > >   __sys_bpf+0x13bd/0x6130 kernel/bpf/syscall.c:4998
> > >   __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
> > >   __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
> > >   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5055
> > >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7fb092221c29
> > > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48  
> 89
> > > f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d  
> 01 f0
> > > ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007fff5b0a6878 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> > > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb092221c29
> > > RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000012
> > > RBP: 00007fb0921e5dd0 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb0921e5e60
> > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > >   </TASK>
> >
> >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > syzbot can test patches for this issue, for details see:
> > > https://goo.gl/tpsmEJ#testing-patches
> >

