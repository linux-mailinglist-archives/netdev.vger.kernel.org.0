Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82064645414
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 07:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLGGi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 01:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLGGiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 01:38:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCBA5F88;
        Tue,  6 Dec 2022 22:38:24 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so606604pjd.5;
        Tue, 06 Dec 2022 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tD69vDvkIT0dyNx4kVDCFtqOdS3Qb9ZPGBgF5SG27cs=;
        b=j26yvcQZMkoClvEbJBR7YbLSP68OgfM4D/zuLVvwLMC2iuoreCU0eWDHEx+ZONPvVV
         8bj61RUrs4scVRoadPhVLc6j3fQp8Q/Z1rMMlxBGdlGu34giPTxz5OoRBU1MWPAMM8x0
         oN9SJWl4t618ofXuYVfJl4D4GbyueXDG2EVrhSQXECoJ2vqrZ0vnnpGvE40AKaHySO5q
         VVC+S7Tgw1xImQYhDwAwp0xeqqH3dU67QgNHqg4CE+CoPwrsLK3nyYaxsCIhK4ci26U2
         L5+kg/UJUC285tqRlMtYzl6Ro/3HqWEjYQaI0Y6s7wDW4p0LF/mRsWWjIlBYsXQf3gZi
         JujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tD69vDvkIT0dyNx4kVDCFtqOdS3Qb9ZPGBgF5SG27cs=;
        b=ejP5/maZWn3gR0yWHia6sWhwhzoTAgI5BDhJMbcFTGQvGsf3yeBhgBastdlxeiM5oH
         K6yzzeSlFGO+pS8wR6N8XZGh4hu50HgFjtljJ7KTSd6bbnfkJSmxlL0EonbsTJAYbYn6
         wQWR6b1tMReeDAqxZU+pZLsATHqbcOC8A1sgsc4BoT2HBoK+UwRGHW8fIGF4BOrNNbpf
         pq/aIG4NkoXweV7GwqvwI2CbQ9bvjPcp0Evo/LbPbrpMmzsF41M+OiFwRAqDNyP8EM9+
         ScwiZMyDTo7htdMBfe5VrFwE3DMfg2AZS5NTm8eIWS13H9EZQVT0qvUwz31SFftnQStO
         5QUA==
X-Gm-Message-State: ANoB5pmZ3oUbJRij/AWp7G4NNvVDkwCekE7owciD1opq3oK2dcyIEO3q
        7HVcNz+fov2xZMUYUMkDsLM=
X-Google-Smtp-Source: AA0mqf4I0gr3NkA1tjW9B6DhQB7itpiUtzfFqHxiUelDGMsC2eRrXrE6I7gCVnWqZnDud2lX+kV2KA==
X-Received: by 2002:a17:902:8a97:b0:189:de2a:8829 with SMTP id p23-20020a1709028a9700b00189de2a8829mr11304562plo.44.1670395104102;
        Tue, 06 Dec 2022 22:38:24 -0800 (PST)
Received: from localhost ([98.97.38.190])
        by smtp.gmail.com with ESMTPSA id x10-20020aa7940a000000b005775c52dbc4sm1250348pfo.167.2022.12.06.22.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 22:38:23 -0800 (PST)
Date:   Tue, 06 Dec 2022 22:38:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Message-ID: <639034dda7f92_bb36208f5@john.notmuch>
In-Reply-To: <00000000000073b14905ef2e7401@google.com>
References: <00000000000073b14905ef2e7401@google.com>
Subject: RE: [syzbot] BUG: stack guard page was hit in inet6_release
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6a30d3e3491d selftests: net: Use "grep -E" instead of "egr..
> git tree:       net
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1576b11d880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
> dashboard link: https://syzkaller.appspot.com/bug?extid=04c21ed96d861dccc5cd
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1656b880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077da23880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/bbee3d5fc908/disk-6a30d3e3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bf9e258de70e/vmlinux-6a30d3e3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/afaa6696b9e0/bzImage-6a30d3e3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
> 
> BUG: TASK stack guard page was hit at ffffc90003cd7fa8 (stack is ffffc90003cd8000..ffffc90003ce0000)
> stack guard page: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 3636 Comm: syz-executor238 Not tainted 6.1.0-rc7-syzkaller-00135-g6a30d3e3491d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
> Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
> RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
> RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
> RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
> RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
> R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
> R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
> FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  mark_lock kernel/locking/lockdep.c:4598 [inline]
>  mark_usage kernel/locking/lockdep.c:4543 [inline]
>  __lock_acquire+0x847/0x56d0 kernel/locking/lockdep.c:5009
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>  lock_sock_nested+0x3a/0xf0 net/core/sock.c:3447
>  lock_sock include/net/sock.h:1721 [inline]
>  sock_map_close+0x75/0x7b0 net/core/sock_map.c:1610

I'll take a look likely something recent.
