Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC96F389F
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 21:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjEAT4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjEAT4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 15:56:02 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C192D4B
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 12:55:42 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-619be7d7211so9398936d6.3
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 12:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682970941; x=1685562941;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjpne/glXPozTmc4Nk3hboKXkpQtjxfoAxLH9LN6CYg=;
        b=HPBiKF0EHA42BNiJf/48VR7H+tlrOafdih+E2dDQDogssbzUSiqk4M+ZnlThMWdvtm
         gBl+g8fnRcolyHqotuiC6fPfHNAL53NhcnisGX163en4w/8cmNahx/7m03UnzCQMRjmb
         XZz6i4U87L1dCN9Pxth/JAFS1O3POvOdsg/h0PqUEV5hhLPIEkgVyjfNAyrdP8J1FrXA
         mAwitrIsjpuJHzPJ4ELntlzp7BKv8I5SNppyluZd3Bm0n0+2A+7mph6Ff1F/wtGJds7G
         QwhIIXWaMh4nCcQvohec/OcKJNZpSPdMNWoqbs2MwRYyIcqW3Lcm/TvfA1oCgtysUEyx
         CZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682970941; x=1685562941;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qjpne/glXPozTmc4Nk3hboKXkpQtjxfoAxLH9LN6CYg=;
        b=ZBq1IUocgA0LufjEHF67+tE+YJW6JkFYKPMueKpw3wGFn1KhBe3X732uwo30edbpbO
         mmGZinipISrX9eKAdLWZltxCZUMReNQ2sS99CnquxLGiHFTcKKfr8b0em0bP/lYQebWA
         qbDNFj21Ixn8UmNVA5wYvWiWwk1WMsCTIZzvEMbDcG1dOJ/Ri3nhP9Xf3+wCeNEK2rZs
         QnfGyewoXPD8YdxSn2oYWd66rpPFIsSStCAgd3kh9GffoEMbsizCll7mqbugtH6MvcQl
         0dLMBVA4iGTql7sZDh7QdFnp+r/5r2YPBvwbYgO9gNCgi1ekkzDDX0Lo1+bKNot4sAyY
         ImoQ==
X-Gm-Message-State: AC+VfDykR32B48gI8FiNBFeOe6SrG8uY1UaYUTPqSYpgfGZYuiryoKvE
        AACg6WjTpdxz7oFLEZ+3Ucg=
X-Google-Smtp-Source: ACHHUZ4v4H6qhSlpj6KK89uV2x4s+OVVG6u/uIRZ8FttP5gKw4kJA17ZIbYTUvK3UWh3QE+XZDe+Tw==
X-Received: by 2002:a05:6214:c4c:b0:5ef:83cf:91c2 with SMTP id r12-20020a0562140c4c00b005ef83cf91c2mr1906200qvj.45.1682970941255;
        Mon, 01 May 2023 12:55:41 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id r28-20020a0cb29c000000b006167758ca0bsm3620992qve.68.2023.05.01.12.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 12:55:40 -0700 (PDT)
Date:   Mon, 01 May 2023 15:55:40 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Message-ID: <6450193c852ef_3163ce2944d@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230501192322.89544-1-kuniyu@amazon.com>
References: <20230501192322.89544-1-kuniyu@amazon.com>
Subject: RE: [PATCH v1 net] af_packet: Don't send zero-byte data in
 packet_sendmsg_spkt().
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
> syzkaller reported a warning below [0].
> 
> We can reproduce it by sending 0-byte data from the (AF_PACKET,
> SOCK_PACKET) socket via some devices whose dev->hard_header_len
> is 0.
> 
>     struct sockaddr_pkt addr = {
>         .spkt_family = AF_PACKET,
>         .spkt_device = "tun0",
>     };
>     int fd;
> 
>     fd = socket(AF_PACKET, SOCK_PACKET, 0);
>     sendto(fd, NULL, 0, 0, (struct sockaddr *)&addr, sizeof(addr));
> 
> We have a similar fix for the (AF_PACKET, SOCK_RAW) socket as
> commit dc633700f00f ("net/af_packet: check len when min_header_len
> equals to 0").
> 
> Let's add the same test for the SOCK_PACKET socket.
> 
> [0]:
> skb_assert_len
> WARNING: CPU: 1 PID: 19945 at include/linux/skbuff.h:2552 skb_assert_len include/linux/skbuff.h:2552 [inline]
> WARNING: CPU: 1 PID: 19945 at include/linux/skbuff.h:2552 __dev_queue_xmit+0x1f26/0x31d0 net/core/dev.c:4159
> Modules linked in:
> CPU: 1 PID: 19945 Comm: syz-executor.0 Not tainted 6.3.0-rc7-02330-gca6270c12e20 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:skb_assert_len include/linux/skbuff.h:2552 [inline]
> RIP: 0010:__dev_queue_xmit+0x1f26/0x31d0 net/core/dev.c:4159
> Code: 89 de e8 1d a2 85 fd 84 db 75 21 e8 64 a9 85 fd 48 c7 c6 80 2a 1f 86 48 c7 c7 c0 06 1f 86 c6 05 23 cf 27 04 01 e8 fa ee 56 fd <0f> 0b e8 43 a9 85 fd 0f b6 1d 0f cf 27 04 31 ff 89 de e8 e3 a1 85
> RSP: 0018:ffff8880217af6e0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc90001133000
> RDX: 0000000000040000 RSI: ffffffff81186922 RDI: 0000000000000001
> RBP: ffff8880217af8b0 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff888030045640
> R13: ffff8880300456b0 R14: ffff888030045650 R15: ffff888030045718
> FS:  00007fc5864da640(0000) GS:ffff88806cd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020005740 CR3: 000000003f856003 CR4: 0000000000770ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  dev_queue_xmit include/linux/netdevice.h:3085 [inline]
>  packet_sendmsg_spkt+0xc4b/0x1230 net/packet/af_packet.c:2066
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg+0x1b4/0x200 net/socket.c:747
>  ____sys_sendmsg+0x331/0x970 net/socket.c:2503
>  ___sys_sendmsg+0x11d/0x1c0 net/socket.c:2557
>  __sys_sendmmsg+0x18c/0x430 net/socket.c:2643
>  __do_sys_sendmmsg net/socket.c:2672 [inline]
>  __se_sys_sendmmsg net/socket.c:2669 [inline]
>  __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2669
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3c/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7fc58791de5d
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
> RSP: 002b:00007fc5864d9cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00000000004bbf80 RCX: 00007fc58791de5d
> RDX: 0000000000000001 RSI: 0000000020005740 RDI: 0000000000000004
> RBP: 00000000004bbf80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000000b R14: 00007fc58797e530 R15: 0000000000000000
>  </TASK>
> ---[ end trace 0000000000000000 ]---
> skb len=0 headroom=16 headlen=0 tailroom=304
> mac=(16,0) net=(16,-1) trans=-1
> shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
> hash(0x0 sw=0 l4=0) proto=0x0000 pkttype=0 iif=0
> dev name=sit0 feat=0x00000006401d7869
> sk family=17 type=10 proto=0
> 
> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

This is a straightforward extension of the referenced commit.

But if the issue is only triggered by BPF shenanigans, as implied
by the Fixes and by commit fd1894224407 ("bpf: Don't redirect packets
with invalid pkt_len"), which introduces skb_assert_len, can that
be catched in BPF redirect, so that we don't have to add assertions
and checks elsewhere in the stack?

> ---
>  net/packet/af_packet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 6080c0db0814..640d94e34635 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2033,7 +2033,7 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
>  		goto retry;
>  	}
>  
> -	if (!dev_validate_header(dev, skb->data, len)) {
> +	if (!dev_validate_header(dev, skb->data, len) || !skb->len) {
>  		err = -EINVAL;
>  		goto out_unlock;
>  	}
> -- 
> 2.30.2
> 


