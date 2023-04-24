Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE946ED7E3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDXW3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDXW3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:29:35 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3846185
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:29:30 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-74e0180b7d3so247300585a.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682375369; x=1684967369;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lDySIbRJKbUgTG/ej/ftVE22p7NTEGrq8dyJrla1Z8=;
        b=d8sqAc0PJ0tFF+Mb3vdSOrQA9DzwldO38JLPfXTYEEar/LCtGATZHN2d+X3kf2zyVA
         MmUQvl+IpJrpziZFlCAQDuJ1cRQ4MhUJYrQbKE3PoUeNrqCyayx7Zs0k9wbF/mpFkEX9
         oOi2qvGAmLsIAzdkNc7FkCUEjSul4hTOOpBE1XthE4xaUtpUlpDi6QoTG/ubIW66hMlK
         +KozpUENiwq8fXEILEseG8aGkzClLP55YM1aG40I1w701xTmnMR4XAVqksUwgSDG6XoJ
         aCooe6q6BYxDWFZZFlhVdt+TrAE6SrT1MJZZFqftVYdfSLT3iR2oKezQGzx1JnxMeSMb
         hQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682375369; x=1684967369;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7lDySIbRJKbUgTG/ej/ftVE22p7NTEGrq8dyJrla1Z8=;
        b=fE06RUzP8jniL8jiQ64Sg38OHwhKd5NQi8Oyvzd1EkT6QoZHWFaEf5P0yE7jeJIq6I
         f43/hLCDGgJzJAGKntN2vM+G9GMYxcgmop1g47ouw2w1rzqb/qy4ueFM+o+v33JxDODp
         ZHB81mTB/9H3+ngj/tKFIZNdtk34fLr70AgdejNqwpUPYpoMU0iBTvgji+d0ox6D4clf
         wsT4dWm4Iql73jqN8oqLqX4+sd7tdfuVAxwjFidQ2VUCplP9eebYEs06XzStRUWD/G6r
         p6s3gFio0m4bn2CqN0Jy6gq0FccKNSC5H8XiHLMAjR8ZZnQ+KPcxbrRHqBkbPRolLPNZ
         eHdA==
X-Gm-Message-State: AAQBX9fkSjqMGFt+wgG/0cKCDvckYg/eT5KfwK63Gp0F/aXkw1enZ5xU
        FaykreI7HPqDiXliwVWSVXM=
X-Google-Smtp-Source: AKy350a3e+/0OJ2O8VkakbMlC6sZCxuS7WP7m02vR7R5fMNOyzrQwM9kVLCfMIQm7vL25ZlIjcxKNA==
X-Received: by 2002:a05:6214:2aad:b0:5ef:3b9a:b01d with SMTP id js13-20020a0562142aad00b005ef3b9ab01dmr23375539qvb.1.1682375369508;
        Mon, 24 Apr 2023 15:29:29 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id v14-20020a0ccd8e000000b006039f5a247esm3047767qvm.78.2023.04.24.15.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 15:29:29 -0700 (PDT)
Date:   Mon, 24 Apr 2023 18:29:28 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Message-ID: <644702c8e1ec5_1ad44a29462@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230424222022.46681-1-kuniyu@amazon.com>
References: <20230424222022.46681-1-kuniyu@amazon.com>
Subject: RE: [PATCH v4 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima wrote:
> syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> skbs.  We can reproduce the problem with these sequences:
> 
>   sk = socket(AF_INET, SOCK_DGRAM, 0)
>   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
>   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
>   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
>   sk.close()
> 
> sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> the socket's error queue with the TX timestamp.
> 
> When the original skb is received locally, skb_copy_ubufs() calls
> skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> This additional count is decremented while freeing the skb, but struct
> ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> not called.
> 
> The last refcnt is not released unless we retrieve the TX timestamped
> skb by recvmsg().  Since we clear the error queue in inet_sock_destruct()
> after the socket's refcnt reaches 0, there is a circular dependency.
> If we close() the socket holding such skbs, we never call sock_put()
> and leak the count, sk, and skb.
> 
> TCP has the same problem, and commit e0c8bccd40fc ("net: stream:
> purge sk_error_queue in sk_stream_kill_queues()") tried to fix it
> by calling skb_queue_purge() during close().  However, there is a
> small chance that skb queued in a qdisc or device could be put
> into the error queue after the skb_queue_purge() call.
> 
> In __skb_tstamp_tx(), the cloned skb should not have a reference
> to the ubuf to remove the circular dependency, but skb_clone() does
> not call skb_copy_ubufs() for zerocopy skb.  So, we need to call
> skb_orphan_frags_rx() for the cloned skb to call skb_copy_ubufs().
> 
> [0]:
> BUG: memory leak
> unreferenced object 0xffff88800c6d2d00 (size 1152):
>   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 cd af e8 81 00 00 00 00  ................
>     02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
>   backtrace:
>     [<0000000055636812>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:2024
>     [<0000000054d77b7a>] sk_alloc+0x3b/0x800 net/core/sock.c:2083
>     [<0000000066f3c7e0>] inet_create net/ipv4/af_inet.c:319 [inline]
>     [<0000000066f3c7e0>] inet_create+0x31e/0xe40 net/ipv4/af_inet.c:245
>     [<000000009b83af97>] __sock_create+0x2ab/0x550 net/socket.c:1515
>     [<00000000b9b11231>] sock_create net/socket.c:1566 [inline]
>     [<00000000b9b11231>] __sys_socket_create net/socket.c:1603 [inline]
>     [<00000000b9b11231>] __sys_socket_create net/socket.c:1588 [inline]
>     [<00000000b9b11231>] __sys_socket+0x138/0x250 net/socket.c:1636
>     [<000000004fb45142>] __do_sys_socket net/socket.c:1649 [inline]
>     [<000000004fb45142>] __se_sys_socket net/socket.c:1647 [inline]
>     [<000000004fb45142>] __x64_sys_socket+0x73/0xb0 net/socket.c:1647
>     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff888017633a00 (size 240):
>   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 2d 6d 0c 80 88 ff ff  .........-m.....
>   backtrace:
>     [<000000002b1c4368>] __alloc_skb+0x229/0x320 net/core/skbuff.c:497
>     [<00000000143579a6>] alloc_skb include/linux/skbuff.h:1265 [inline]
>     [<00000000143579a6>] sock_omalloc+0xaa/0x190 net/core/sock.c:2596
>     [<00000000be626478>] msg_zerocopy_alloc net/core/skbuff.c:1294 [inline]
>     [<00000000be626478>] msg_zerocopy_realloc+0x1ce/0x7f0 net/core/skbuff.c:1370
>     [<00000000cbfc9870>] __ip_append_data+0x2adf/0x3b30 net/ipv4/ip_output.c:1037
>     [<0000000089869146>] ip_make_skb+0x26c/0x2e0 net/ipv4/ip_output.c:1652
>     [<00000000098015c2>] udp_sendmsg+0x1bac/0x2390 net/ipv4/udp.c:1253
>     [<0000000045e0e95e>] inet_sendmsg+0x10a/0x150 net/ipv4/af_inet.c:819
>     [<000000008d31bfde>] sock_sendmsg_nosec net/socket.c:714 [inline]
>     [<000000008d31bfde>] sock_sendmsg+0x141/0x190 net/socket.c:734
>     [<0000000021e21aa4>] __sys_sendto+0x243/0x360 net/socket.c:2117
>     [<00000000ac0af00c>] __do_sys_sendto net/socket.c:2129 [inline]
>     [<00000000ac0af00c>] __se_sys_sendto net/socket.c:2125 [inline]
>     [<00000000ac0af00c>] __x64_sys_sendto+0xe1/0x1c0 net/socket.c:2125
>     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
>     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks for the analysis and fix!


