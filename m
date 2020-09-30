Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B427027F111
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgI3SKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3SKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:10:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA9AC061755;
        Wed, 30 Sep 2020 11:10:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g128so2904299iof.11;
        Wed, 30 Sep 2020 11:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNF2DTAtjoh3BWytNcKCrhLvx2bkbI2XntobJ3hyrNY=;
        b=u7Fj0kyDbe8b4vltpaXVO+Bu1yIpy8egL4l6CgUBF3S6/7kayVhmXnEevPag6oHo4i
         ZhUkQGNPbzXmHB0WIlv5YsewUrNR0iNi3+0QepmYl0cikVu6EJ0S2nSXULfqaKe7xJSW
         JWN7qlB3tQhNb4HpYtQielFwGgsOTarignKY/qWKUuiR7sc5PI+AeOsI8kq9bR1kvq3P
         ln0BnYWdYtCzj6pLO2IEcPVfqPeUZ+2urgjLqmaU+eCadqG+aVe7XHLIetCoYDpr8k2G
         6VIFBlbgi4nqVcdyWxxZHZsHPrjYNd/rYhnUKjBNxmRf96JTVKS9Rq5AcCNIZ4spqdi3
         mkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eNF2DTAtjoh3BWytNcKCrhLvx2bkbI2XntobJ3hyrNY=;
        b=NO8sxuQk+qDlwe3+A7MkiQKFB2tzZnSbxhVS+cfRf3IrhRyBoXMh4fLz5iMDidZrWv
         3QdN3xuwJj6uWWSF8MQXepxAhRdaNliBySunkSf0aTTv6IoAfJwuILGB4YIgK/C/BDvJ
         61erg2zpLGDd+oKVjQrpXbbUa1C+0wcmsoS+ew3arzvi01xBA1CLx48yk+G+RQmAdIrp
         UiWtFpE3lHol7SOAARRIc7Pee5bLjpU1GX8qzv/xe/VstkKz8ilUu1j+9iXVWLab1/3W
         35xykf++MbsXw9QZr5b68piEoNTdMmB+9sxFVCyGjDGkcobpkETR0iIM2ACGoNKyR/sM
         D0hQ==
X-Gm-Message-State: AOAM530bJHrJGzYaGBkcFcdK5O3E1aGeaNALE6sm701DnbvylrlImB/c
        BikmK/0kHFTRnH7vq74qQUZdGKaTBZuNFLRoWw4=
X-Google-Smtp-Source: ABdhPJyhbEH3tt7cxKslGSE2sIZ6aUT8Ly08g3MB5w+Sumr9vImjHzqJ3LlhuE+fBPWW4FuLgBSHEL9n+orugS10nII=
X-Received: by 2002:a02:2b04:: with SMTP id h4mr2456439jaa.49.1601489437588;
 Wed, 30 Sep 2020 11:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009dac0205b05ab52a@google.com> <000000000000c4d11a05b08b6b56@google.com>
In-Reply-To: <000000000000c4d11a05b08b6b56@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 30 Sep 2020 11:10:25 -0700
Message-ID: <CAM_iQpU+aq5XPmeyvWHhgi9Xc=thhtvqbYQ4GSLB227JmRPayw@mail.gmail.com>
Subject: Re: general protection fault in tcf_generic_walker
To:     syzbot <syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:42 AM syzbot
<syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    2b3e981a Merge branch 'mptcp-Fix-for-32-bit-DATA_FIN'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=16537247900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=99a7c78965c75e07
> dashboard link: https://syzkaller.appspot.com/bug?extid=b47bc4f247856fb4d9e1
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1412a5a7900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b47bc4f247856fb4d9e1@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 0 PID: 8855 Comm: syz-executor.1 Not tainted 5.9.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:tcf_dump_walker net/sched/act_api.c:240 [inline]
> RIP: 0010:tcf_generic_walker+0x367/0xba0 net/sched/act_api.c:343
> Code: 24 31 ff 48 89 de e8 c8 55 eb fa 48 85 db 74 3f e8 3e 59 eb fa 48 8d 7d 30 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 08 00 0f 85 26 07 00 00 48 8b 5d 30 31 ff 48 2b 1c 24 48 89
> RSP: 0018:ffffc9000b6ff3a8 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: c0000000ffffaae4 RCX: dffffc0000000000
> RDX: ffff8880a82aa140 RSI: ffffffff868ae502 RDI: 0000000000000020
> RBP: fffffffffffffff0 R08: 0000000000000000 R09: ffff8880a8c41e07
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809f226340
> R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  00007f156f7fa700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d25128b348 CR3: 00000000a7d3d000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tc_dump_action+0x6d5/0xe60 net/sched/act_api.c:1609


Probably just need another IS_ERR() check on the dump path.
I will take a second look.

Thanks.
