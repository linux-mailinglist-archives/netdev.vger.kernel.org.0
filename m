Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3769D6160C5
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiKBK1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBK1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:27:04 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18466BC7
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 03:27:04 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 66so3837824ybl.11
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 03:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4IlMzjocpQ3xJ7mqXdVgMQ+/v/ebRCnLK4aF994ATY=;
        b=KPVnu+85ZKx0bh6CW4cn4sU14+i95U6p4qna3HElBkhCmw34FDpOA/zFYwt5liE78D
         8CV+XKr83wlYNv9e5Vr4Hj98mok6lsDUXFOM7Srkwrkh9qPctXbYPVy8isiGizD+BnUY
         44gLesA67le5o8gFfKUIgX+IfpjgreeFqDWtbrtVQ9dES0ChfoTKCxDmS4RYs7CZ6ijN
         OUB+hKTlE8PPunLjEGCTPbUNGVCqIsesMxMzAdWDto2XDfKksnPz1ufexdM8D4zAMlEn
         qm5BEvjrTyTy0qTnfEdZn+rPQeXB9/ZqSmX+vawqcq9C9rpANx3qXrSBrZ40zzIDujqx
         HEaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4IlMzjocpQ3xJ7mqXdVgMQ+/v/ebRCnLK4aF994ATY=;
        b=uwVjjaGsfFzmRTVXCP93bhCXGRN6cPv0r8zhNrCBXT+eb/cBKJ26HOCPMu8KW+bJ3E
         jPSswgC5i6o6Fi0nutK5wX6/vBjMDlaROxDmd7cPKaV2dIQr45/ogwpM+7tVQh5V/tsm
         unEydJXr0j8j1AkUvr3+7SVlxy9Rfq4q9zcyLu5qSi/3jrAELcKcXWgC6dbAjlgr6rMp
         mB+EhVUqs5Z3buiZAMR7E9mIhBEVd6r0HYz40tTaNZmEzkCo7O1ZaZc2JlzAxV5gY1Ad
         iiIAio2DB5aNFgTohCrJ/6HbKUeevRsJjUSDXyQ9u2fpQwrKxrKjTOLJU6nnN99nh5Ar
         KAZQ==
X-Gm-Message-State: ACrzQf0n1A9CMz6jwSnXDMCAG+LKN/JonEhPvsf5irb3ky7lOuZwBR9/
        E4WMx0uESdy53nfdWmn2R5oziRwCDQC0eVv5vfRYeg==
X-Google-Smtp-Source: AMsMyM6foZu/ErMZB/+DeimFP1ldhtHUQHUv7K4smYFiRTjB+PFYFh8C29WNRaYbrIDK1B2lP+BgQc7zz77gMEUA0L8=
X-Received: by 2002:a25:c08b:0:b0:6bf:b095:c192 with SMTP id
 c133-20020a25c08b000000b006bfb095c192mr22243249ybf.143.1667384823192; Wed, 02
 Nov 2022 03:27:03 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e9df4305ec7a3fc7@google.com>
In-Reply-To: <000000000000e9df4305ec7a3fc7@google.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 2 Nov 2022 11:26:26 +0100
Message-ID: <CANpmjNMxfFui+ZooJfCNQPwayiHgr6OZgpfGKJH-Tb6UvdT=cQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in __perf_event_overflow
To:     syzbot <syzbot+589d998651a580e6135d@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 at 11:24, syzbot
<syzbot+589d998651a580e6135d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    88619e77b33d net: stmmac: rk3588: Allow multiple gmac cont..
> git tree:       bpf
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=11842046880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=589d998651a580e6135d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11eabcea880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f7e632880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f8435d5c2c21/disk-88619e77.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/551d8a013e81/vmlinux-88619e77.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7d3f5c29064d/bzImage-88619e77.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+589d998651a580e6135d@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3607 at kernel/events/core.c:9313 __perf_event_overflow+0x498/0x540 kernel/events/core.c:9313
> Modules linked in:
> CPU: 0 PID: 3607 Comm: syz-executor100 Not tainted 6.1.0-rc2-syzkaller-00073-g88619e77b33d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
> RIP: 0010:__perf_event_overflow+0x498/0x540 kernel/events/core.c:9313
> Code: 80 3c 02 00 0f 85 b2 00 00 00 48 8b 83 20 02 00 00 48 ff 80 b8 01 00 00 e9 5b fe ff ff 45 31 f6 e9 a2 fd ff ff e8 f8 ae dd ff <0f> 0b e9 47 fe ff ff 4c 89 e7 e8 39 ff 29 00 e9 b2 fb ff ff e8 0f
> RSP: 0000:ffffc90003c4fb00 EFLAGS: 00010046
> RAX: 0000000080010000 RBX: ffff888011a891d0 RCX: 0000000000000000
> RDX: ffff88801a4d57c0 RSI: ffffffff819eecc8 RDI: 0000000000000001
> RBP: ffffc90003c4fb80 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000020 R11: 0000000000000001 R12: 0000000000000020
> R13: ffff888011a895f4 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000555555a8e300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000648 CR3: 000000007c988000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  perf_swevent_hrtimer+0x34f/0x3c0 kernel/events/core.c:10729
>  __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>  __hrtimer_run_queues+0x1c6/0xfb0 kernel/time/hrtimer.c:1749
>  hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1096 [inline]
>  __sysvec_apic_timer_interrupt+0x17c/0x640 arch/x86/kernel/apic/apic.c:1113
>  sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1107
>  asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
> RIP: 0033:0x7f74350afae5
> Code: 00 c7 04 25 b0 06 00 20 00 00 00 00 c7 04 25 b4 06 00 20 00 00 00 00 48 c7 04 25 b8 06 00 20 4f ff ff ff e8 ed e2 03 00 31 ff <e8> a6 75 00 00 66 0f 1f 44 00 00 41 57 41 56 41 55 41 54 55 53 48
> RSP: 002b:00007fffceb2b0e0 EFLAGS: 00000246
> RAX: 0000000000000003 RBX: 000000000000a025 RCX: 00007f74350edde9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000008 R09: 00007fffceb2b278
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fffceb2b0ec
> R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
>  </TASK>

Proposed fix for this is:
https://lore.kernel.org/all/20221031093513.3032814-1-elver@google.com/
