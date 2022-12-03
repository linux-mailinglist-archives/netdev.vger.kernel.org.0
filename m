Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8245641897
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 20:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLCTYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 14:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLCTYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 14:24:30 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C662186EC
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 11:24:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso8493920pjb.1
        for <netdev@vger.kernel.org>; Sat, 03 Dec 2022 11:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55rmkUMZEa9+PRhwz9T505wsEW1RMyFqZE0ZJ8UMoG8=;
        b=qG/KBen62vQd1EavFV59J5+YAnnTJJdmghGdmKyjOirRG6MAfRFJMkPHThCqphFyue
         gxmjFinAyagyFy2KmINW3sevfD56fTyKZv+hg5R09z2uxi1hdOzFZQn/yBw2JN4MWp0z
         Uod9O2wMuydjZhw+AUszHuxhddLCrs/u0SznTgkG8aw04qNE16WZsLVV1KUrxPy/FSpX
         5WK/I1O32vRH3dvoWP+5cRuiTKmq56E9oF66ceSu/tIhjq8dsP8uX+geNNHR2ZWlqJGY
         zBSHRZ1VXlnXHhG4lR7Ocme1O32okXKsdNeXVYEto8levbCld7dIkw/QnsG+Gj1iWuee
         UhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=55rmkUMZEa9+PRhwz9T505wsEW1RMyFqZE0ZJ8UMoG8=;
        b=1UkIrzZUJWUMrW1wgTboWa8dBh6ho7Zkq2KZyCF4llKHmoYpPaHTh22aZFvReeWX0L
         6NFdGqoJgzmGXcd7SjJX4RCbkC2az9VJk1vGpYfduPUV5nknmn8L9Stht0lLdH13Gn28
         03tgPmEUAJPivTGdMy53Kws0SL9g1gYj4FG/SWlFEIzJfD+902V+8rY9Q3ZGxe6Yy4lm
         7VI5wHGNKWhhJvONbA+TgJ4Fj/dMJuxzdaKHUd1Q/Whq7eO11NgKG7liXiL1co0lOBJS
         ZPjSWAB/QeqK1hoQfqfXT1uA0VM3MusooCZb4Iulaf3gWHUw28QBpH9oaiFtFoiWsV42
         Rr0w==
X-Gm-Message-State: ANoB5plDHmL8j3Ce1GTCTUTFhDpFjJ9309T+ehd7r5a6P2q8lEFjd1jx
        BFWcGO7MrrHIc/r7oA3wGPY=
X-Google-Smtp-Source: AA0mqf4uzzqfiJp7lhdxRIKBS2kjOZZrYPYTkVd4tVyrJrMaIuDpWnSc5sMmbhniK+phybau4Y/fbg==
X-Received: by 2002:a17:902:e949:b0:189:7a15:1336 with SMTP id b9-20020a170902e94900b001897a151336mr36562272pll.122.1670095468901;
        Sat, 03 Dec 2022 11:24:28 -0800 (PST)
Received: from localhost ([129.95.228.55])
        by smtp.gmail.com with ESMTPSA id f139-20020a623891000000b005746c3b2445sm7047285pfa.151.2022.12.03.11.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 11:24:28 -0800 (PST)
Date:   Sat, 03 Dec 2022 11:24:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Message-ID: <638ba26b634d8_16f04208a2@john.notmuch>
In-Reply-To: <20221202111640.2745533-1-edumazet@google.com>
References: <20221202111640.2745533-1-edumazet@google.com>
Subject: RE: [PATCH net] bpf, sockmap: fix race in sock_map_free()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> sock_map_free() calls release_sock(sk) without owning a reference
> on the socket. This can cause use-after-free as syzbot found [1]
> 
> Jakub Sitnicki already took care of a similar issue
> in sock_hash_free() in commit 75e68e5bf2c7 ("bpf, sockhash:
> Synchronize delete from bucket list on map free")
> 
> [1]
> refcount_t: decrement hit 0; leaking memory.
> WARNING: CPU: 0 PID: 3785 at lib/refcount.c:31 refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
> Modules linked in:
> CPU: 0 PID: 3785 Comm: kworker/u4:6 Not tainted 6.1.0-rc7-syzkaller-00103-gef4d3ea40565 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events_unbound bpf_map_free_deferred
> RIP: 0010:refcount_warn_saturate+0x17c/0x1a0 lib/refcount.c:31
> Code: 68 8b 31 c0 e8 75 71 15 fd 0f 0b e9 64 ff ff ff e8 d9 6e 4e fd c6 05 62 9c 3d 0a 01 48 c7 c7 80 bb 68 8b 31 c0 e8 54 71 15 fd <0f> 0b e9 43 ff ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c a2 fe ff
> RSP: 0018:ffffc9000456fb60 EFLAGS: 00010246
> RAX: eae59bab72dcd700 RBX: 0000000000000004 RCX: ffff8880207057c0
> RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000000
> RBP: 0000000000000004 R08: ffffffff816fdabd R09: fffff520008adee5
> R10: fffff520008adee5 R11: 1ffff920008adee4 R12: 0000000000000004
> R13: dffffc0000000000 R14: ffff88807b1c6c00 R15: 1ffff1100f638dcf
> FS: 0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30c30000 CR3: 000000000d08e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> __refcount_dec include/linux/refcount.h:344 [inline]
> refcount_dec include/linux/refcount.h:359 [inline]
> __sock_put include/net/sock.h:779 [inline]
> tcp_release_cb+0x2d0/0x360 net/ipv4/tcp_output.c:1092
> release_sock+0xaf/0x1c0 net/core/sock.c:3468
> sock_map_free+0x219/0x2c0 net/core/sock_map.c:356
> process_one_work+0x81c/0xd10 kernel/workqueue.c:2289
> worker_thread+0xb14/0x1330 kernel/workqueue.c:2436
> kthread+0x266/0x300 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> </TASK>
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Song Liu <songliubraving@fb.com>

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
