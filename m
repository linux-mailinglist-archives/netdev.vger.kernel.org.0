Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B696D7A88
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 13:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbjDELAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 07:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237270AbjDELAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 07:00:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377B1268B;
        Wed,  5 Apr 2023 04:00:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso36832566pjb.3;
        Wed, 05 Apr 2023 04:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680692400;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OojazA+NEPlPaQEBfrRO3Y9bvHlzHo90rsLDWc44zhU=;
        b=gEPIYm5yvUCf3OtwTE65Lg4DylDh4HROmjCcuiI2jIKdXSPnrOzwEhxZhmGGQO1lk6
         v1Kl5RcwbETR/TgKAt2+6KnRR8YA/aFjFxjum/H7zJ5UJ7IQqZIOhHsl3vg9Az7jQWXL
         wAcOLHsXBXfRox39Zy2K0iqQ1t2KpvqmkdVsZG0RJd8Csq8jQUnMbazCdquRk+arQ6rd
         W5TVB6tqsWDNyHgmChSzIWXJqsoHH3/jOiYPbpbWCVmvwgzvaRt/QKhtdOYgmdfKvIC/
         u2HamOzBBTZSCWvJXeR6qvhe7/wTOpfs/+2pyAtVnXp9rt5Hy3vZ0/fnngboLwTJ5G/Y
         1QJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680692400;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OojazA+NEPlPaQEBfrRO3Y9bvHlzHo90rsLDWc44zhU=;
        b=hWVrDOYNLDke0Mp2QEha6cMShsl6QYv5sJ0s0PuV4bCZX0hMvWSKeyVdGIQMPchRTG
         F9MQQXh98G0oN/W+yQPl5S5wbcjw2DpVwtMYgpkLCXI853loqTCg5cAA+5n+pm5mgwzJ
         XokBSvQxjyQ3/1lVAD46D6HmdtjGMHnsBW2IUsYlyD+Cu6J+JVkaZPXUAMvsLhmUzPol
         QkjqQOe+G6YjyiyE7YohFUfbQAhPiet2CZPjx7f3ET5LAnUKE1JyseWX+7FtQmGQqLbc
         1hr4byDWYFrf/kBHUhv82+oQAHtwkxvTvGRSxSqnqGTYyyG9iI8pUjgjEUZSW5FMoRER
         bPyg==
X-Gm-Message-State: AAQBX9dkvP+Sl2pHkJxW4Erc3br1nWk1aPpzzwVzM88UXdDn3b+RTBy8
        YYxkX2CrqnnZoiIQp7o1l84=
X-Google-Smtp-Source: AKy350atiBozRrjibuqOuCSSysHRFHkCGXIxnG+BvHuVCfMCfKHER/3UF1by++/bTUr3UVTIvZfIWA==
X-Received: by 2002:a05:6a20:65a2:b0:da:7d8a:2cc9 with SMTP id p34-20020a056a2065a200b000da7d8a2cc9mr4264584pzh.24.1680692400450;
        Wed, 05 Apr 2023 04:00:00 -0700 (PDT)
Received: from dragonet (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id z15-20020aa785cf000000b0062d9ced3db3sm9859959pfn.23.2023.04.05.03.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 04:00:00 -0700 (PDT)
Date:   Wed, 5 Apr 2023 19:59:55 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: kernel BUG in pfkey_send_acquire
Message-ID: <ZC1Uqy8CqRTcXNoY@dragonet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We observed an issue "kernel BUG in pfkey_send_acquire".

We inform you that we observed this issue a few months ago, so we are
not sure that this issue still occurs in the kernel. And we also
didn't find a reproducer for the crash. We will inform you if we have
any update on this crash.

Detailed crash information is attached below.

Best regards,
Dae R. Jeong

-----
- Kernel commit:
92f20ff72066d

- Crash report:
skbuff: skb_over_panic: text:ffffffff8e5ddc75 len:736 put:72 head:ffff888159d0c000 data:ffff888159d0c000 tail:0x2e0 end:0x2c0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 20026 Comm: syz-executor.0 Not tainted 5.19.0-rc3-32288-g0f3b08299494 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:skb_panic+0x277/0x280 net/core/skbuff.c:113
Code: c0 48 c7 c5 c0 69 c7 91 48 0f 45 e8 44 89 e3 45 89 fa 48 c7 c7 40 69 c7 91 31 c0 55 53 41 52 41 53 e8 0c ed 77 03 48 83 c4 20 <0f> 0b 0f 1f 80 00 00 00 00 55 41 57 41 56 41 55 41 54 53 48 83 ec
RSP: 0000:ffffc90009596de8 EFLAGS: 00010286
RAX: 0000000000000088 RBX: 00000000000002c0 RCX: 777473599dfff200
RDX: ffffc900129fb000 RSI: 000000000000ff2d RDI: 000000000000ff2e
RBP: ffffffff91c769c0 R08: ffffffff816927a4 R09: ffffed10477867e9
R10: ffffed10477867e9 R11: 0000000000000000 R12: 00000000000002c0
R13: ffff88814b5cd050 R14: dffffc0000000000 R15: 00000000000002e0
FS:  00007f102dcfc700(0000) GS:ffff88823bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a592ebe008 CR3: 0000000024133000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 skb_over_panic+0x25/0x30 net/core/skbuff.c:118
 skb_put+0x2f7/0x3b0 net/core/skbuff.c:2015
 dump_esp_combs net/key/af_key.c:3006 [inline]
 pfkey_send_acquire+0x2aa5/0x4b00 net/key/af_key.c:3227
 km_query+0x18e/0x380 net/xfrm/xfrm_state.c:2247
 xfrm_state_find+0x5459/0x8180 net/xfrm/xfrm_state.c:1165
 xfrm_tmpl_resolve_one net/xfrm/xfrm_policy.c:2393 [inline]
 xfrm_tmpl_resolve net/xfrm/xfrm_policy.c:2438 [inline]
 xfrm_resolve_and_create_bundle+0x945/0x48c0 net/xfrm/xfrm_policy.c:2728
 xfrm_lookup_with_ifid+0x3cc/0x35b0 net/xfrm/xfrm_policy.c:3062
 xfrm_lookup net/xfrm/xfrm_policy.c:3191 [inline]
 xfrm_lookup_route+0x38/0x2d0 net/xfrm/xfrm_policy.c:3202
 udp_sendmsg+0x30f2/0x4e00 net/ipv4/udp.c:1220
 sock_sendmsg_nosec net/socket.c:693 [inline]
 sock_sendmsg net/socket.c:713 [inline]
 ____sys_sendmsg+0xaba/0x1010 net/socket.c:2471
 ___sys_sendmsg net/socket.c:2525 [inline]
 __sys_sendmmsg+0x406/0x850 net/socket.c:2611
 __do_sys_sendmmsg net/socket.c:2640 [inline]
 __se_sys_sendmmsg net/socket.c:2637 [inline]
 __x64_sys_sendmmsg+0x12c/0x190 net/socket.c:2637
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x4e/0xa0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x47268d
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f102dcfbbe8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000057d4a0 RCX: 000000000047268d
RDX: 0400000000000354 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 000002873dedf99c R11: 0000000000000246 R12: 000000000057d4a8
R13: 000000000057d4ac R14: 00007ffcaa189060 R15: 00007f102dcfbd80
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_panic+0x277/0x280 net/core/skbuff.c:113
Code: c0 48 c7 c5 c0 69 c7 91 48 0f 45 e8 44 89 e3 45 89 fa 48 c7 c7 40 69 c7 91 31 c0 55 53 41 52 41 53 e8 0c ed 77 03 48 83 c4 20 <0f> 0b 0f 1f 80 00 00 00 00 55 41 57 41 56 41 55 41 54 53 48 83 ec
RSP: 0000:ffffc90009596de8 EFLAGS: 00010286
RAX: 0000000000000088 RBX: 00000000000002c0 RCX: 777473599dfff200
RDX: ffffc900129fb000 RSI: 000000000000ff2d RDI: 000000000000ff2e
RBP: ffffffff91c769c0 R08: ffffffff816927a4 R09: ffffed10477867e9
R10: ffffed10477867e9 R11: 0000000000000000 R12: 00000000000002c0
R13: ffff88814b5cd050 R14: dffffc0000000000 R15: 00000000000002e0
FS:  00007f102dcfc700(0000) GS:ffff88823bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffd209df78 CR3: 0000000024133000 CR4: 0000000000350ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
