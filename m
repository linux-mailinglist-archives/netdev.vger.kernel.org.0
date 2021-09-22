Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B914841467B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhIVKeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:34:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235001AbhIVKek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632306790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eSL0RGR02+ETLFprPy9AGNzZ8i/AOq/enLbPN5MAacg=;
        b=Q84LFqrdq7lYkvmDsmSrpdmCVYJ8yNcoyxXMZNsJrUl3CbjT66An8iIKOcwf+/DCjshbaP
        O4fLji4cFUFhczWq7z+Fui7qiwcvA/LVnONstQ/Abg3DWWLrLzoKoj19giNlKpT6ifNQMe
        1LotWivxfGqouuY7VtI7r31eQz4RxY4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-nr0FpaaHPQ6wS-S51JOccw-1; Wed, 22 Sep 2021 06:32:59 -0400
X-MC-Unique: nr0FpaaHPQ6wS-S51JOccw-1
Received: by mail-wr1-f69.google.com with SMTP id m18-20020adfe952000000b0015b0aa32fd6so1726297wrn.12
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eSL0RGR02+ETLFprPy9AGNzZ8i/AOq/enLbPN5MAacg=;
        b=XwXH9tefpYxJcWp7YOhZ81xoi29cftHNqKFl170hJNIPvYojbXT4/lX1rwPmHHkl0J
         IqEskN4HhCmDOQ/OnjVb8jBTo2EDF7jLtPzi5TWVgczXc+QttK+KNkJf+qaOrea9DS/p
         jMZ2ICoFZtyTDPDcFQzkUhEzmTlXmPun9uXDOa45cR2OK6/rW4+Vk2vrr0U1BVyMTKtD
         ZCdnzq3c9vVpJ6UKmutpqWXPaMiQElQ2/Bm+mbiSMiBt5tLPWAn1LQYqnU6Dv1SJlYZQ
         7Eb3bEfWvsfoMBQ/eJd21YN0X2BKkdGl/FEcKzAPA/NSXL8FIvcssQuH2UeyyGBu+SLO
         zeNg==
X-Gm-Message-State: AOAM531BJMLZlwt56ea2fJRzCEvqMR0bHZII+1tuZg8kE7y9xt0LtYLI
        EfKkK5B4dIZ3asK6AgQ5VC08BX5YZ2GqmfVLINTEOPfDyohcG8KLRZ7fMXs3Wxzsa3UbhyoNcNE
        cLR0oc6kKPmSghoMA
X-Received: by 2002:a5d:404b:: with SMTP id w11mr40359288wrp.437.1632306778478;
        Wed, 22 Sep 2021 03:32:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCNKW1oFUoHevtzLoWvSCH7OLS39ZQzOJ4rhBh7tlsl9vJfben8sgiyRTsICuwBK7jRIBY2g==
X-Received: by 2002:a5d:404b:: with SMTP id w11mr40359269wrp.437.1632306778237;
        Wed, 22 Sep 2021 03:32:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-102-46.dyn.eolo.it. [146.241.102.46])
        by smtp.gmail.com with ESMTPSA id y197sm6589927wmc.18.2021.09.22.03.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 03:32:57 -0700 (PDT)
Message-ID: <7de92627f85522bf5640defe16eee6c8825f5c55.camel@redhat.com>
Subject: Re: [syzbot] WARNING in mptcp_sendmsg_frag
From:   Paolo Abeni <pabeni@redhat.com>
To:     syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date:   Wed, 22 Sep 2021 12:32:56 +0200
In-Reply-To: <00000000000015991c05cc43a736@google.com>
References: <00000000000015991c05cc43a736@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-09-18 at 04:50 -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    02319bf15acf net: dsa: bcm_sf2: Fix array overrun in bcm_s..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=170f9e27300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
> dashboard link: https://syzkaller.appspot.com/bug?extid=263a248eec3e875baa7b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1507cd8d300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174c8017300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 7032 at net/mptcp/protocol.c:1366 mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
> Modules linked in:
> CPU: 1 PID: 7032 Comm: syz-executor845 Not tainted 5.15.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
> Code: ff 4c 8b 74 24 50 48 8b 5c 24 58 e9 0f fb ff ff e8 83 40 8b f8 4c 89 e7 45 31 ed e8 88 57 2e fe e9 81 f4 ff ff e8 6e 40 8b f8 <0f> 0b 41 bd ea ff ff ff e9 6f f4 ff ff 4c 89 e7 e8 b9 89 d2 f8 e9
> RSP: 0018:ffffc90003acf830 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888072918000 RSI: ffffffff88eacb72 RDI: 0000000000000003
> RBP: ffff88807a182580 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff88eac1a7 R11: 0000000000000000 R12: ffff88801a08a000
> R13: 0000000000000000 R14: ffff888018cb9b80 R15: ffff88801b4f2340
> FS:  000055555723b300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000380 CR3: 000000007bebe000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __mptcp_push_pending+0x1fb/0x6b0 net/mptcp/protocol.c:1547
>  mptcp_sendmsg+0xc29/0x1bc0 net/mptcp/protocol.c:1748
>  inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:643
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  sock_write_iter+0x2a0/0x3e0 net/socket.c:1057
>  call_write_iter include/linux/fs.h:2163 [inline]
>  new_sync_write+0x40b/0x640 fs/read_write.c:507
>  vfs_write+0x7cf/0xae0 fs/read_write.c:594
>  ksys_write+0x1ee/0x250 fs/read_write.c:647
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f40ee3c4fb9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd96b7a0f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f40ee3c4fb9
> RDX: 00000000000e7b78 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000f0b5ff R09: 0000000000f0b5ff
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000012096
> R13: 00007ffd96b7a120 R14: 00007ffd96b7a110 R15: 00007ffd96b7a104

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

The debug code helped a bit. It looks like we have singed/unsigned
comparisons issue

Tentative patch, plus debug code
---
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2602f1386160..c38506c5ea05 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1316,7 +1316,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			goto alloc_skb;
 		}
 
-		must_collapse = (info->size_goal - skb->len > 0) &&
+		must_collapse = (info->size_goal > skb->len) &&
 				(skb_shinfo(skb)->nr_frags < sysctl_max_skb_frags);
 		if (must_collapse) {
 			size_bias = skb->len;
@@ -1325,7 +1325,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	}
 
 alloc_skb:
-	if (!must_collapse && !ssk->sk_tx_skb_cache &&
+	if (!must_collapse &&
 	    !mptcp_alloc_tx_skb(sk, ssk, info->data_lock_held))
 		return 0;
 
@@ -1363,6 +1363,10 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	}
 
 	mpext = skb_ext_find(tail, SKB_EXT_MPTCP);
+	if (!mpext)
+		pr_warn("must_collapse=%d old skb=%p:%d avail_size=%d:%d state=%d",
+			must_collapse, skb, skb ? skb->len:0, info->size_goal, avail_size,
+			ssk->sk_state);
 	if (WARN_ON_ONCE(!mpext)) {
 		/* should never reach here, stream corrupted */
 		return -EINVAL;




