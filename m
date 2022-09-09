Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2485B3D22
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 18:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiIIQhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiIIQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 12:37:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF95413FA44
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 09:37:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a33-20020a630b61000000b00429d91cc649so1207341pgl.8
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 09:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=SYxPApAHgZr703DB+c9euDT6JedgaQrmDjdOdOtOsLY=;
        b=a7H5n0Q4/3gMDbUj3vQoobfe0EqJ0Kr1h8JdjtV9QDlk5uSqfykczww9qESu5sIRqV
         WiYWT5XdqhsRnsR/EljHBYR96P38IBXIMJNeQQpyma0kQQcTJhdEGofhdNDhyaYxLg0A
         ZoYOKlChNt0r+/TY6wCijxllGY+VepgyslDN1PZXj5Au1zUbGjbSgMtj4M0jhiwjujEy
         Bjx2uo2XehkGNYSYCeBXK1Gi+5PcnsQe+t5lxYydwJXZZkFtt7YiktWzsFUqLm9z8DGt
         oUh//RMj7d8SH+Tcyi83V9gDLniFkevfJ7YCiY/LK0rPG0jBZlz6Eg7x0XOMSNUtX0Tp
         6qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=SYxPApAHgZr703DB+c9euDT6JedgaQrmDjdOdOtOsLY=;
        b=HCD0qWQDf+vXjX6b9dHTyCajOc8FzPf8r1X3qPGo1ygoBV0sq19az+qnBzkzeX1Mgb
         REWdVuXvfXnYZkmK9Lh8SAEblxzG9FdE4KewRcE6dQM9maa0i+q1dpNqEWl1IN5LhhQT
         Utmas9PRyfutpvglwLnGbSKapGXTg32B/qvrkhcm3YCjll+u7bl3xjip+mfIOF1j+9Mp
         mJM/7HeYaZZ2tC6Z/wL97XnJKD3OGrCO/tyjSvggWhOL0tUCOcE6uTBLB3mJe/Ts/J/i
         0xwN1ql9Iiu9jFwqRrjbB4ewjfQFF10FEBVejjSRL2HxY1/YGU4B1nkUqMn67+iv8+Ys
         f25A==
X-Gm-Message-State: ACgBeo1xGtIEb3Eserc4RkmbhG9U7Q1UShZe43edPt9SzMK2xtr/L4tz
        jbxqnGkdVIYyHiMJO28JN7OeKLg=
X-Google-Smtp-Source: AA6agR7Ty3Z3+CK5HhcAXqFq9gExo2Fk7eHfCZYnPb5MhwEUy0XG728e4hzEbnpkwgjreXRKKJOPxuE=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:10c2:b0:4f7:5af4:47b6 with SMTP id
 d2-20020a056a0010c200b004f75af447b6mr15258004pfu.6.1662741422295; Fri, 09 Sep
 2022 09:37:02 -0700 (PDT)
Date:   Fri, 9 Sep 2022 09:37:00 -0700
In-Reply-To: <000000000000e506e905e836d9e7@google.com>
Mime-Version: 1.0
References: <000000000000e506e905e836d9e7@google.com>
Message-ID: <YxtrrG8ebrarIqnc@google.com>
Subject: Re: [syzbot] WARNING in bpf_verifier_vlog
From:   sdf@google.com
To:     benjamin.tissoires@redhat.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
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

On 09/08, syzbot wrote:
> Hello,

> syzbot found the following issue on:

> HEAD commit:    7e18e42e4b28 Linux 6.0-rc4
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1551da55080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f4d613baa509128c
> dashboard link:  
> https://syzkaller.appspot.com/bug?extid=8b2a08dfbd25fd933d75
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU  
> Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1798cab7080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ccbdc5080000

> Downloadable assets:
> disk image:  
> https://storage.googleapis.com/syzbot-assets/da260c675b46/disk-7e18e42e.raw.xz
> vmlinux:  
> https://storage.googleapis.com/syzbot-assets/58f7bbbaa6ff/vmlinux-7e18e42e.xz

> IMPORTANT: if you fix the issue, please add the following tag to the  
> commit:
> Reported-by: syzbot+8b2a08dfbd25fd933d75@syzkaller.appspotmail.com

> ------------[ cut here ]------------
> verifier log line truncated - local buffer too short
> WARNING: CPU: 1 PID: 3604 at kernel/bpf/verifier.c:300  
> bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> Modules linked in:
> CPU: 1 PID: 3604 Comm: syz-executor146 Not tainted 6.0.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 08/26/2022
> RIP: 0010:bpf_verifier_vlog+0x267/0x3c0 kernel/bpf/verifier.c:300
> Code: f5 95 3d 0c 31 ff 89 ee e8 06 07 f0 ff 40 84 ed 75 1a e8 7c 0a f0  
> ff 48 c7 c7 c0 e7 f3 89 c6 05 d4 95 3d 0c 01 e8 fb 4c ae 07 <0f> 0b e8 62  
> 0a f0 ff 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1
> RSP: 0018:ffffc900039bf8a0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff888017a19210 RCX: 0000000000000000
> RDX: ffff888021fb1d80 RSI: ffffffff8161f408 RDI: fffff52000737f06
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff89f5aba0
> R13: 00000000000003ff R14: ffff888017a19214 R15: ffff888012705800
> FS:  0000555555cba300(0000) GS:ffff8880b9b00000(0000)  
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020100000 CR3: 000000001bf9e000 CR4: 0000000000350ee0
> Call Trace:
>   <TASK>
>   __btf_verifier_log+0xbb/0xf0 kernel/bpf/btf.c:1375
>   __btf_verifier_log_type+0x451/0x8f0 kernel/bpf/btf.c:1413
>   btf_func_proto_check_meta+0x117/0x160 kernel/bpf/btf.c:3905
>   btf_check_meta kernel/bpf/btf.c:4588 [inline]
>   btf_check_all_metas+0x3c1/0xa70 kernel/bpf/btf.c:4612
>   btf_parse_type_sec kernel/bpf/btf.c:4748 [inline]

Benjamin, this seems to be coming from BTF loading. Could this be caused
by some of your recent activity with things like:

commit f9b348185f4d684cc19e6bd9b87904823d5aa5ed
Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue Sep 6 17:13:01 2022 +0200

     bpf/btf: bump BTF_KFUNC_SET_MAX_CNT

?

I haven't looked too deep, maybe you can give it a shot? There is
reproducer; should be relatively easy to verify. Thx.


>   btf_parse kernel/bpf/btf.c:5031 [inline]
>   btf_new_fd+0x939/0x1e70 kernel/bpf/btf.c:6710
>   bpf_btf_load kernel/bpf/syscall.c:4314 [inline]
>   __sys_bpf+0x13bd/0x6130 kernel/bpf/syscall.c:4998
>   __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5055
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fb092221c29
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89  
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0  
> ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff5b0a6878 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb092221c29
> RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000012
> RBP: 00007fb0921e5dd0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb0921e5e60
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>


> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.

> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
