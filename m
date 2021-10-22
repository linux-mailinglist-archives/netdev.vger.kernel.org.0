Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1A437EB4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhJVTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbhJVTi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 15:38:26 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3398C061764;
        Fri, 22 Oct 2021 12:36:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j21so11309257lfe.0;
        Fri, 22 Oct 2021 12:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=i/KI1/mA4M1dRYYokxYvIyvZBPQEyoO/DtFoTzHdRLw=;
        b=L/Pcyuu6lOEaRzTwNjk0bHJOQBghBzsJu2SU8uGfvXvcufS0H4AAd+wCqaIOPhLkP6
         faAD/9zxbBHoC1yXWZDC7HKfHFnVnz8wAVEyswDWqzJoXzHgEOQs4dfuFu+VSUr7Yeda
         DBZHhzU8hnoai5Ik+owhXo+mqg3845i+gKM9qfr3f0GFMZhyg00axJIlj+vgs5EgdxgS
         RjsE69ANgfwUzUHqebIHmWHYNXdPI0rqFka4EvuFqESOuWHBiXk5w8k5Ssqy3NyfEl13
         6RHxQO8uHLQCWqlUA5UnNzvdUnoDaTFmaje2a5zcJwxCZgETTsv86KKECezNuhAfX710
         mQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i/KI1/mA4M1dRYYokxYvIyvZBPQEyoO/DtFoTzHdRLw=;
        b=52IRsA9XnkMyI/vW8YuIMnb5xNL282tzQE6J5JMokMqlTqz7Z2BUZeuPIWtKW3192F
         G7YVWnNlZ3syzY6in815FrBK4qDqln7zQX9M0q8wYPJo8U14IrJ8VcCPJhQtwxwd0N8R
         pajCaL1oqpKZSzbzcin9kvYggfePrwqR0Cp8b9hMNaV82pSrsZwF+WNnHtG5UMzUYxly
         6FCT8TaW6qB0bapCPwQPiPgfFmsjFs//ncC0eB+1c58UT6DMwPTIZMffpZn6+rMcLMGR
         Swoy2QAZMMVGhbyUd3ZP4l294HrDo9uxrfPXq+Tejrj8Njmt8PNI+VGLK94zP6/RvTtC
         1VSQ==
X-Gm-Message-State: AOAM532CVKNS7MUvgoFklQQx4GTQo5ze3nc7etCIu+sL/b5cCLo9tuIw
        Wp0zUyX7FY0M7sRJl+vNf6E=
X-Google-Smtp-Source: ABdhPJzovwP/gq7I0T+v9YM6XqBRzfSThE5kRZdyxgH/btRKigwgpOVPFRzE20PQ9jhzIz7DmUUTIg==
X-Received: by 2002:ac2:5e76:: with SMTP id a22mr1533729lfr.221.1634931367065;
        Fri, 22 Oct 2021 12:36:07 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.235.181])
        by smtp.gmail.com with ESMTPSA id a11sm1058083lji.90.2021.10.22.12.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:36:06 -0700 (PDT)
Message-ID: <2108d58b-2aca-12f1-59f0-cca5f63098d6@gmail.com>
Date:   Fri, 22 Oct 2021 22:36:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] WARNING: ODEBUG bug in batadv_nc_mesh_free
Content-Language: en-US
To:     syzbot <syzbot+1dca817d274a3fb19f2b@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
References: <000000000000c0c8d505cef55b23@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <000000000000c0c8d505cef55b23@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 21:41, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e0bfcf9c77d9 Merge tag 'mlx5-fixes-2021-10-20' of git://gi..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=17900a0cb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
> dashboard link: https://syzkaller.appspot.com/bug?extid=1dca817d274a3fb19f2b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144d76b4b00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14732b80b00000
> 
> Bisection is inconclusive: the issue happens on the oldest tested release.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14093652b00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16093652b00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12093652b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1dca817d274a3fb19f2b@syzkaller.appspotmail.com
> 
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
> WARNING: CPU: 0 PID: 6548 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Modules linked in:
> CPU: 0 PID: 6548 Comm: syz-executor286 Not tainted 5.15.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 80 3e e4 89 4c 89 ee 48 c7 c7 80 32 e4 89 e8 5e 1d 15 05 <0f> 0b 83 05 d5 39 90 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffffc90002d7ecc0 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: ffff8880163c8000 RSI: ffffffff815e88a8 RDI: fffff520005afd8a
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815e264e R11: 0000000000000000 R12: ffffffff898de560
> R13: ffffffff89e43900 R14: ffffffff81658550 R15: 1ffff920005afda3
> FS:  0000555555c03300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fef3003e098 CR3: 0000000073ad0000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   debug_object_assert_init lib/debugobjects.c:895 [inline]
>   debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
>   debug_timer_assert_init kernel/time/timer.c:739 [inline]
>   debug_assert_init kernel/time/timer.c:784 [inline]
>   del_timer+0x6d/0x110 kernel/time/timer.c:1204
>   try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1270
>   __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3129
>   batadv_nc_mesh_free+0x41/0x120 net/batman-adv/network-coding.c:1869
>   batadv_mesh_free+0x7d/0x170 net/batman-adv/main.c:245
>   batadv_mesh_init+0x62f/0x710 net/batman-adv/main.c:226

Same fault injection, same backtrace, same warning... Looks like duplicate.

#syz dup: WARNING in batadv_nc_mesh_free


With regards,
Pavel Skripkin
