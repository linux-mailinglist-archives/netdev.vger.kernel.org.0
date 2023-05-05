Return-Path: <netdev+bounces-622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 845A66F898C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6D61C21973
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178CCC8F4;
	Fri,  5 May 2023 19:34:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A18C8EF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 19:34:53 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6ECCC
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:34:52 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-74df47ad36eso115927485a.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 12:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683315291; x=1685907291;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/GW8ZaG71LinOU/o3tcbYUh3Ogferp+0/E1fdOdCcps=;
        b=HZCoyu8RhONFrv1fuilaUvKSCTAJC0HYyomVsvOVOLuqANQR/bX45e1Rr1dOM0Y8f7
         fQTDyCaMz6inuHWUsIgNUvisvdm0/0f6mduvaTkQaObL7fvNJmy0Xxy7ukQ9Ff+T2BKR
         lWvPVmgDyJqEHt7fw0u3ufVpupIBxoVwHr2QZ3TEKvzBZnLqoszLlZX5rGmqqhS9Aeay
         7i8+rtTn1KWSlFcMTNLLsnx2XOUE8t5xFWXRMBBKg6gV6qb2dX2GmnIlybNP7cLIEhCv
         ybGQfeInuRx1N809tlZYSUaIpG7qff4T8rMTTKOgnm2Z5biPVErRYlumFW7wMeRrKdWi
         zfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683315291; x=1685907291;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/GW8ZaG71LinOU/o3tcbYUh3Ogferp+0/E1fdOdCcps=;
        b=MQS34sVdlkvrYQhUNS1Z1okBSUt18hhExqXvAgGXCbFgQ/FIldHO1rnHPZ4MjoRZeU
         J4JYyORFcSKX+CUUeQx+g5ibOzXDxx++zRJcnFaQQrs6z71H1TUv9CGbJw/zwi1GFU6e
         RhXSIjXn8cdHsV7SfWOsJUixvVsySQ7T+j6fyxybcqI1KYJK6DDW23ZAi+PEPd58wjLJ
         gzvtX3ccnMjv9ILQUbBu1qLWduZZc45X+J0wHfK0ZoW5ATkT1j60pP8b1+1eF6DNiNVC
         jCz9YtfZzN7PFA6rzOekOJ/VEnHptvYEnl7gy+9qyVUMX6TLEQo1o9+ZOVGMA1EMBJ8v
         fZhQ==
X-Gm-Message-State: AC+VfDx3hw4M9I7XIeA/fVCil+nBwVPwQFKoQyopFn74Xj/VHrWEW5qD
	Qpp8pFsTVr5REuaKx5/nkm8=
X-Google-Smtp-Source: ACHHUZ49bjMQ308xKmzgTBNqLFDuEQx1yM425uobudB22a7+GMN7Encx2/V+DRnAdMhHWoAckbE+Wg==
X-Received: by 2002:a05:6214:20a5:b0:620:a1be:c74d with SMTP id 5-20020a05621420a500b00620a1bec74dmr3389346qvd.37.1683315291101;
        Fri, 05 May 2023 12:34:51 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id q7-20020a05620a038700b007463509f94asm788962qkm.55.2023.05.05.12.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 12:34:50 -0700 (PDT)
Date: Fri, 05 May 2023 15:34:50 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Eric Dumazet <edumazet@google.com>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, 
 eric.dumazet@gmail.com, 
 Eric Dumazet <edumazet@google.com>, 
 syzbot <syzkaller@googlegroups.com>, 
 Willem de Bruijn <willemb@google.com>
Message-ID: <64555a5a67dd9_4552d2944d@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230505170618.650544-1-edumazet@google.com>
References: <20230505170618.650544-1-edumazet@google.com>
Subject: RE: [PATCH net] net: skb_partial_csum_set() fix against transport
 header magic value
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
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

Eric Dumazet wrote:
> skb->transport_header uses the special 0xFFFF value
> to mark if the transport header was set or not.
> 
> We must prevent callers to accidentaly set skb->transport_header
> to 0xFFFF. Note that only fuzzers can possibly do this today.
> 
> syzbot reported:
> 
> WARNING: CPU: 0 PID: 2340 at include/linux/skbuff.h:2847 skb_transport_offset include/linux/skbuff.h:2956 [inline]
> WARNING: CPU: 0 PID: 2340 at include/linux/skbuff.h:2847 virtio_net_hdr_to_skb+0xbcc/0x10c0 include/linux/virtio_net.h:103
> Modules linked in:
> CPU: 0 PID: 2340 Comm: syz-executor.0 Not tainted 6.3.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> RIP: 0010:skb_transport_header include/linux/skbuff.h:2847 [inline]
> RIP: 0010:skb_transport_offset include/linux/skbuff.h:2956 [inline]
> RIP: 0010:virtio_net_hdr_to_skb+0xbcc/0x10c0 include/linux/virtio_net.h:103
> Code: 41 39 df 0f 82 c3 04 00 00 48 8b 7c 24 10 44 89 e6 e8 08 6e 59 ff 48 85 c0 74 54 e8 ce 36 7e fc e9 37 f8 ff ff e8 c4 36 7e fc <0f> 0b e9 93 f8 ff ff 44 89 f7 44 89 e6 e8 32 38 7e fc 45 39 e6 0f
> RSP: 0018:ffffc90004497880 EFLAGS: 00010293
> RAX: ffffffff84fea55c RBX: 000000000000ffff RCX: ffff888120be2100
> RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
> RBP: ffffc90004497990 R08: ffffffff84fe9de5 R09: 0000000000000034
> R10: ffffea00048ebd80 R11: 0000000000000034 R12: ffff88811dc2d9c8
> R13: dffffc0000000000 R14: ffff88811dc2d9ae R15: 1ffff11023b85b35
> FS: 00007f9211a59700(0000) GS:ffff8881f6c00000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200002c0 CR3: 00000001215a5000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> packet_snd net/packet/af_packet.c:3076 [inline]
> packet_sendmsg+0x4590/0x61a0 net/packet/af_packet.c:3115
> sock_sendmsg_nosec net/socket.c:724 [inline]
> sock_sendmsg net/socket.c:747 [inline]
> __sys_sendto+0x472/0x630 net/socket.c:2144
> __do_sys_sendto net/socket.c:2156 [inline]
> __se_sys_sendto net/socket.c:2152 [inline]
> __x64_sys_sendto+0xe5/0x100 net/socket.c:2152
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x2f/0x50 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f9210c8c169
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9211a59168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f9210dabf80 RCX: 00007f9210c8c169
> RDX: 000000000000ffed RSI: 00000000200000c0 RDI: 0000000000000003
> RBP: 00007f9210ce7ca1 R08: 0000000020000540 R09: 0000000000000014
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffe135d65cf R14: 00007f9211a59300 R15: 0000000000022000
> 
> Fixes: 66e4c8d95008 ("net: warn if transport header was not set")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks Eric.


