Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A324F601599
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiJQRoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJQRn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:43:58 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5B87393D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:43:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-349423f04dbso117642397b3.13
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7tL4iHZcgAfm6m4eFT/wRjkCDpO+CYTn3CGNj+Lr9Y=;
        b=sLc6qaMJaV75H51YmYYklched11hNG97Vf7CWqm9TMz70wa4lYR11PkBTz6szJHx6g
         nNpzkz+p24x3hoIecPMfm1k+T78wjuTr20yrUmAZN27HN14Z2diougn222pAAqBhH+Uf
         CApDD0YMg2+givSUalGe8kN9PebKaW8zhWp7ut5ESe4DKnilCvhZxryJWQsNlfcD+sz/
         znRiFsG5loUuw666847sKfm1rTVLv4eAwD4AyBRdF2IXtK4u9OlhvI7y/j5fofw0dKvl
         r56tzc9KCq87WXSnsJtYqGN96FABCs5NE8bvxDOzjeZjmpx364k1AF8owr5Fp+JT5LM+
         wpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7tL4iHZcgAfm6m4eFT/wRjkCDpO+CYTn3CGNj+Lr9Y=;
        b=amgD4IJBwmhVMrWwIL5od3uX/VQ/DCwL4kHwZI8LKr4CEWWzPbnjN5zYqLNztZ3QP0
         jDWQynvX7p+WIHe08OmHHVDyh+DZb/fVmaxYGSI1udvY0LU179EFBRKcgPjd0KX5LnnH
         rjunG4d1zsoG7V5RbFKjfL6raTlY3w+RPsuWUUjCmnAG3FmQtH+rzK57RkRK8oMp85VS
         bbet03D6/d0c3vP0F2c+A3j4+CkKPaeAHvjBsgZ8pQPVbGOGoOfaurC1PVC+8e6CQnRC
         bRth/gknWWan5malkSXRrpnqjep3s9kLdy+sGDRek3AStWrwoIAbPjvFaAPaZHHL3Meb
         5xAQ==
X-Gm-Message-State: ACrzQf0tUhUilZspypvjv85bfQTb8IO0T07EHvRvF9A7rdCVvPHUoZwL
        hHsw+8pLQg5zh5QRYUD6lzinnPo=
X-Google-Smtp-Source: AMsMyM7nVUa8XHJpaKrYavgobpehZ9R1wZ1J9WTOC/gBX26M5PyLNUfpn/Tj1UQ0NDs7nq9C5s125NQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a81:1908:0:b0:33c:7394:9ee1 with SMTP id
 8-20020a811908000000b0033c73949ee1mr10321282ywz.408.1666028632833; Mon, 17
 Oct 2022 10:43:52 -0700 (PDT)
Date:   Mon, 17 Oct 2022 10:43:51 -0700
In-Reply-To: <CANp29Y5ZsUQ64iizRVQiuunGceH_gGTQbLrKRDZWYuSHRdazLQ@mail.gmail.com>
Mime-Version: 1.0
References: <00000000000068cb2905eb214e9a@google.com> <CAKH8qBu+oT+BF6sA4PKxfUsj43O5BNSLzrdhirWOLJ0O8KbA3w@mail.gmail.com>
 <CANp29Y5ZsUQ64iizRVQiuunGceH_gGTQbLrKRDZWYuSHRdazLQ@mail.gmail.com>
Message-ID: <Y02UV5XnsWo+Zd7q@google.com>
Subject: Re: [syzbot] WARNING in btf_type_id_size
From:   sdf@google.com
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     syzbot <syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, haoluo@google.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17, Aleksandr Nogikh wrote:
> Let's tell the bot about the fix

> #syz fix: bpf: prevent decl_tag from being referenced in func_proto

Thx! Wasn't sure syzkaller would accept that until the fix is actually
pulled in.

> On Mon, Oct 17, 2022 at 9:16 AM 'Stanislav Fomichev' via
> syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Sat, Oct 15, 2022 at 11:52 PM syzbot
> > <syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    0326074ff465 Merge tag 'net-next-6.1' of  
> git://git.kernel...
> > > git tree:       bpf
> > > console+strace:  
> https://syzkaller.appspot.com/x/log.txt?x=1376ba52880000
> > > kernel config:   
> https://syzkaller.appspot.com/x/.config?x=796b7c2847a6866a
> > > dashboard link:  
> https://syzkaller.appspot.com/bug?extid=6280ebbcdba3e0c14fde
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU  
> Binutils for Debian) 2.35.2
> > > syz repro:       
> https://syzkaller.appspot.com/x/repro.syz?x=15e182aa880000
> > > C reproducer:    
> https://syzkaller.appspot.com/x/repro.c?x=1677bfcc880000
> > >
> > > Downloadable assets:
> > > disk image:  
> https://storage.googleapis.com/syzbot-assets/7cc67ced256d/disk-0326074f.raw.xz
> > > vmlinux:  
> https://storage.googleapis.com/syzbot-assets/86a7be29267c/vmlinux-0326074f.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the  
> commit:
> > > Reported-by: syzbot+6280ebbcdba3e0c14fde@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 3609 at kernel/bpf/btf.c:1946  
> btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
> > > Modules linked in:
> > > CPU: 0 PID: 3609 Comm: syz-executor361 Not tainted  
> 6.0.0-syzkaller-02734-g0326074ff465 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine,  
> BIOS Google 09/22/2022
> > > RIP: 0010:btf_type_id_size+0x2d5/0x9d0 kernel/bpf/btf.c:1946
> > > Code: ef e8 7f 8e e4 ff 41 83 ff 0b 77 28 f6 44 24 10 18 75 3f e8 6d  
> 91 e4 ff 44 89 fe bf 0e 00 00 00 e8 20 8e e4 ff e8 5b 91 e4 ff <0f> 0b 45  
> 31 f6 e9 98 02 00 00 41 83 ff 12 74 18 e8 46 91 e4 ff 44
> > > RSP: 0018:ffffc90003cefb40 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> > > RDX: ffff8880259c0000 RSI: ffffffff81968415 RDI: 0000000000000005
> > > RBP: ffff88801270ca00 R08: 0000000000000005 R09: 000000000000000e
> > > R10: 0000000000000011 R11: 0000000000000000 R12: 0000000000000000
> > > R13: 0000000000000011 R14: ffff888026ee6424 R15: 0000000000000011
> > > FS:  000055555641b300(0000) GS:ffff8880b9a00000(0000)  
> knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000000f2e258 CR3: 000000007110e000 CR4: 00000000003506f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  btf_func_proto_check kernel/bpf/btf.c:4447 [inline]
> > >  btf_check_all_types kernel/bpf/btf.c:4723 [inline]
> > >  btf_parse_type_sec kernel/bpf/btf.c:4752 [inline]
> > >  btf_parse kernel/bpf/btf.c:5026 [inline]
> > >  btf_new_fd+0x1926/0x1e70 kernel/bpf/btf.c:6892
> > >  bpf_btf_load kernel/bpf/syscall.c:4324 [inline]
> > >  __sys_bpf+0xb7d/0x4cf0 kernel/bpf/syscall.c:5010
> > >  __do_sys_bpf kernel/bpf/syscall.c:5069 [inline]
> > >  __se_sys_bpf kernel/bpf/syscall.c:5067 [inline]
> > >  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5067
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > RIP: 0033:0x7f0fbae41c69
> > > Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48  
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01  
> f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffc8aeb6228 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> > > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0fbae41c69
> > > RDX: 0000000000000020 RSI: 0000000020000140 RDI: 0000000000000012
> > > RBP: 00007f0fbae05e10 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f0fbae05ea0
> > > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > >  </TASK>
> >
> > Will be addressed by
> >  
> https://lore.kernel.org/bpf/d1379e3f-a64d-8c27-9b77-f6de085ce498@meta.com/T/#u
> >
> >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > syzbot can test patches for this issue, for details see:
> > > https://goo.gl/tpsmEJ#testing-patches
> >
> > --
> > You received this message because you are subscribed to the Google  
> Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send  
> an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit  
> https://groups.google.com/d/msgid/syzkaller-bugs/CAKH8qBu%2BoT%2BBF6sA4PKxfUsj43O5BNSLzrdhirWOLJ0O8KbA3w%40mail.gmail.com.
