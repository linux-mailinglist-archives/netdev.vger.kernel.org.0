Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC65BB450
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 00:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiIPWNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 18:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiIPWNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 18:13:35 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F3BBA4A
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 15:13:34 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id z9-20020a921a49000000b002f0f7fb57e3so14997932ill.2
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 15:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=EqMgv96S6WOApHkV1NNQhBVATR9B3h0BGCpG14NXv7E=;
        b=Yzn4To+yahdRcO8bMUB4rv7x4axiWmhGJH8XVhJVjN8Z5zSTs9wTgHddY+mfk5difR
         3IlarrvdVwhQK84JQivcYDvB0NDtEAN4PXL977YcV+gwDIOBMzbyL+ZElVVjpeMePC66
         Z4VjPSjofoJWviAGi/Zv/HagSYYVX3Vuk+M+l/VJjLI47h2yepUDT0KUMYzGBSArkCtI
         hkRU+yKJwIftLodQOJhp9hcn/Xyw+P8B74VmiCQ2A7rAl0IafDB2tVLW2vT8wNVtdjyQ
         Ndw01OH5xo5BHEAMpE4SNTJKO9CAw392qDkWmglb5Ko2YUHim0LXZjwuRKBpnXYbgTqH
         ZreA==
X-Gm-Message-State: ACrzQf0A+eV0+OsoDrvTdk9CuUomug/w+H+GVMTBQ+rg2NBkH+iJJlMo
        Kkhkndh92684IeiyLG0bC4uEr+iEzJFw/qHfWl/WUU7VgoNk
X-Google-Smtp-Source: AMsMyM6+Auj0NFS3XWN08knoqKP1R6D6Hg0acSp2RtRUzfCLPUJTUYyFzAUmxaEGrYertHxCWX8cPSe1znjm9opSFyEQdBAK9uzP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1748:b0:2eb:e656:8123 with SMTP id
 y8-20020a056e02174800b002ebe6568123mr3055166ill.15.1663366414212; Fri, 16 Sep
 2022 15:13:34 -0700 (PDT)
Date:   Fri, 16 Sep 2022 15:13:34 -0700
In-Reply-To: <0000000000006b15c805c7fbd885@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004027ca05e8d2ac0a@google.com>
Subject: Re: [syzbot] memory leak in mld_newpack
From:   syzbot <syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, phind.uet@gmail.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    6879c2d3b960 Merge tag 'pinctrl-v6.0-2' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1053435d080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4afe4efcad47dde
dashboard link: https://syzkaller.appspot.com/bug?extid=dcd3e13cf4472f2e0ba1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11842b37080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15078ed5080000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0e68bb9c6cf9/disk-6879c2d3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bf179217db31/vmlinux-6879c2d3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810bb0bb00 (size 240):
  comm "kworker/0:2", pid 143, jiffies 4294946271 (age 15.640s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 bb b0 0b 81 88 ff ff  ................
    00 70 aa 11 81 88 ff ff 80 10 e9 44 81 88 ff ff  .p.........D....
  backtrace:
    [<ffffffff8387bb59>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:422
    [<ffffffff8388255a>] alloc_skb include/linux/skbuff.h:1257 [inline]
    [<ffffffff8388255a>] alloc_skb_with_frags+0x6a/0x340 net/core/skbuff.c:6021
    [<ffffffff8387508f>] sock_alloc_send_pskb+0x39f/0x3d0 net/core/sock.c:2665
    [<ffffffff83d4eb01>] sock_alloc_send_skb include/net/sock.h:1866 [inline]
    [<ffffffff83d4eb01>] mld_newpack.isra.0+0x81/0x200 net/ipv6/mcast.c:1748
    [<ffffffff83d4ed26>] add_grhead+0xa6/0xc0 net/ipv6/mcast.c:1851
    [<ffffffff83d4f4fc>] add_grec+0x7bc/0x820 net/ipv6/mcast.c:1989
    [<ffffffff83d514e3>] mld_send_cr net/ipv6/mcast.c:2115 [inline]
    [<ffffffff83d514e3>] mld_ifc_work+0x273/0x750 net/ipv6/mcast.c:2653
    [<ffffffff8127afca>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff8127b8e9>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff81284c95>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100224f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306


