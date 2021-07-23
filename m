Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84A93D3DD6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhGWQJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhGWQJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:09:04 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3FAC061575;
        Fri, 23 Jul 2021 09:49:37 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r17so3128288lfe.2;
        Fri, 23 Jul 2021 09:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=XDdh4rsKCJAYgwlkXrp6L+w5K0Erf3OhyE3Aj6eU6sA=;
        b=AmwVGzlKyCKPOIJ2ogRrtIH7RqFfUAqExHjcDk8F/xCS3SPvdjHiFV/cRm8DkxEzaB
         pZczAZvXF5BT5ioLpNS13dK2nTwvpk1HLUXFIhK6zLKcdV1H0P0F7WwNp7FJNijnXtDq
         8tqNxNearVag8divC8tmS5XjhRiZB3O+UyBoRMD95cNrsrndbCLMQHoYMfstqlkACQf2
         UpVF4zAt241vyZRPdMK9T9jbNJqCanazLWZ9wTys7qy4RprHQxspZVCBs0hdmoZPHLR2
         dPhfYx0td/CrbXkr7Fs0Q7+Ut4Xl8S+ts4Val/o1yZRs+WamKgXB0OADPbsFTypqa2QG
         zlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=XDdh4rsKCJAYgwlkXrp6L+w5K0Erf3OhyE3Aj6eU6sA=;
        b=SJ0nEheL7+f3wQUPgC2PdekvHldfD15bSwYr6I10h457+UKj+hW6CafLp9lxh7FO22
         QTzeQcNneHkDMcXqBOayZm56qbIvnZSE39zvoMoFJh+kJ5DmijgV5TNE8j3f5E8a4xVU
         yldd06wbUWiYnNXwNZR2/9XXhB8v27Voxa7Lw7v5omKxaMdbzhKjUllQA/hDiCjplEB1
         H0wE8TUg2xxi0dXboWg/gD5ed0rK1ET/zxOChRyaq5WCMCxpOe4uIqoTBtXK4r0gNCuX
         KYLRPPPc2w9d22shWm5TIwvooAUUpF0psTeRKvNOe5WsHRRScxwdgyogPRZLt2PPcMM7
         IwPA==
X-Gm-Message-State: AOAM530JbFgRxNxPfDt9BP/u4LbfTqt8dlS3+rRwm70ght2XIsyhSbZB
        dMAiDoD0EJGVK208JdP1tEI=
X-Google-Smtp-Source: ABdhPJzL1HxlMjQiKhhOw+Ya/ml4TZtcO/9Y3QafLiMoR9r/yEwfO2YjlxRegkMoKqZKwt4uo8XrBQ==
X-Received: by 2002:a05:6512:110b:: with SMTP id l11mr3662847lfg.255.1627058975585;
        Fri, 23 Jul 2021 09:49:35 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id 193sm3419844ljf.46.2021.07.23.09.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 09:49:35 -0700 (PDT)
Date:   Fri, 23 Jul 2021 19:49:32 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        frowand.list@gmail.com, gregkh@linuxfoundation.org,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, robh+dt@kernel.org,
        robh@kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
Message-ID: <20210723194932.6c3b77a8@gmail.com>
In-Reply-To: <20210723193611.746e7071@gmail.com>
References: <00000000000017e9a105c768f7a0@google.com>
        <20210723193611.746e7071@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/MKoJ6vq7qt8cDOW_ZXQsPzL"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/MKoJ6vq7qt8cDOW_ZXQsPzL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 23 Jul 2021 19:36:11 +0300
Pavel Skripkin <paskripkin@gmail.com> wrote:

> On Sun, 18 Jul 2021 10:15:19 -0700
> syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com> wrote:
> 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    ab0441b4a920 Merge branch 'vmxnet3-version-6'
> > git tree:       net-next
> > console output:
> > https://syzkaller.appspot.com/x/log.txt?x=1744ac6a300000 kernel
> > config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d syz
> > repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=13973a74300000 C
> > reproducer:
> > https://syzkaller.appspot.com/x/repro.c?x=17ffc902300000
> > 
> > The issue was bisected to:
> > 
> > commit 67a3156453859ceb40dc4448b7a6a99ea0ad27c7
> > Author: Rob Herring <robh@kernel.org>
> > Date:   Thu May 27 19:45:47 2021 +0000
> > 
> >     of: Merge of_address_to_resource() and
> > of_pci_address_to_resource() implementations
> > 
> > bisection log:
> > https://syzkaller.appspot.com/x/bisect.txt?x=129b0438300000 final
> > oops:
> > https://syzkaller.appspot.com/x/report.txt?x=119b0438300000 console
> > output: https://syzkaller.appspot.com/x/log.txt?x=169b0438300000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the
> > commit: Reported-by:
> > syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com Fixes:
> > 67a315645385 ("of: Merge of_address_to_resource() and
> > of_pci_address_to_resource() implementations")
> > 
> > ==================================================================
> > BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90
> > net/tipc/socket.c:1979 Read of size 4 at addr ffff8880328cf1c0 by
> > task kworker/u4:0/8
> > 
> 
> Since code accesing skb_cb after possible kfree_skb() call let's just
> store bytes_read to variable and use it instead of acessing
> skb_cb->bytes_read
> 
> #syz test
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> master
> 
> 

Oops... The buggy code is in -next tree.

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master 



With regards,
Pavel Skripkin

--MP_/MKoJ6vq7qt8cDOW_ZXQsPzL
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-tipc-fix-use-after-free-in-tipc_recvmsg.patch

From 9f81f8574bfc1183209022b405848e01c35b86e6 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Fri, 23 Jul 2021 19:34:06 +0300
Subject: [PATCH] tipc: fix use-after-free in tipc_recvmsg

/* .. */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/tipc/socket.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9b0b311c7ec1..0cf2468d209d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1886,6 +1886,7 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 	struct sk_buff *skb;
 	bool grp_evt;
 	long timeout;
+	unsigned int bytes_read;
 
 	/* Catch invalid receive requests */
 	if (unlikely(!buflen))
@@ -1973,10 +1974,13 @@ static int tipc_recvmsg(struct socket *sock, struct msghdr *m,
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	if (!skb_cb->bytes_read)
+	/* To avoid accesing skb_cb after tsk_advance_rx_queue */
+	bytes_read = skb_cb->bytes_read;
+
+	if (!bytes_read)
 		tsk_advance_rx_queue(sk);
 
-	if (likely(!connected) || skb_cb->bytes_read)
+	if (likely(!connected) || bytes_read)
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */
-- 
2.32.0


--MP_/MKoJ6vq7qt8cDOW_ZXQsPzL--
