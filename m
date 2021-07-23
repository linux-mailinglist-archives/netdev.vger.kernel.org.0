Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082673D3DAB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhGWPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWPzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:55:43 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FB4C061575;
        Fri, 23 Jul 2021 09:36:16 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id u20so2098050ljo.0;
        Fri, 23 Jul 2021 09:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=/USRxrU13aqu7zhq+t3JvF75EdmVYTDZtcN8HN3tTxk=;
        b=XcTLetOJ+2/MSjfBcdcA8mGbB8dewEH3zppwPDyKblQcid14hYlws5LMAVDPyewc47
         IDK8x4/8zIRC6wFnm3/HvsUaAnSstrMytpcZnBEmLEp/Duc4ZUeWtQpibTGXdxCXcLqE
         oovCn0LODMHN1hgS1hokyMZ56txwZXaE5D2RYO65fRosXgDZK+7LjDGZTEoAuUT0atGg
         aPCLKNEER04WB2EuV6MJCw7rpkTjj3HYpJURthFe2YPeGg9Ofb+uhFcTlCREO/4i61Jm
         7Rd+64kWyerlu0R6edpV7ISUj8pOF5NrExpNQrkwriRA6zleIrXQnYrBl//VwdYPMHtR
         fPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=/USRxrU13aqu7zhq+t3JvF75EdmVYTDZtcN8HN3tTxk=;
        b=sed+TWIgTHAM/+t9bzVjuak8anRxoYkhpjlVk7PnEicyEE+HIqUcH9xWugWEPE/E8O
         8c1tOFpT++OIkm1E22eEDnqC+ciaCYyeJk6dnNPKBvaFlB+eXNZlU+KkxPINlrGUYqbM
         mc0LQcdZVIechj8nh2gO3dq3GhgSxfsjL/1+q1OZ4td3DdFWMghCOldZzXZ01OLDYUev
         vWuAGL7sK23bXhBwJqvJbbtfMwe7ROWUJr6PQGewhV/t3b4Avt107Hzmr4ZiXhAQEBoT
         Fk6TkjQxdpczFsp9zolp/ErJZ6Ol6C45POBIHiCGT2QGBg1fcEI9hhE5Jqp+9/jWoAfz
         qVLg==
X-Gm-Message-State: AOAM530iF/3NQTo/WnuRKpmVL+pIMoCwCKAXVuepuLLgJ4JqaaqMb0Oq
        3yKnUqMzFGhpG9soEJsnjS0=
X-Google-Smtp-Source: ABdhPJxsZGGZtgDO2ScwU+VHsSRUrS9NeLgPnKJEwOtjcUo3ZXmFg6jQObIG4sUIcX5GNP3o2ipDbw==
X-Received: by 2002:a2e:9010:: with SMTP id h16mr3973685ljg.62.1627058175105;
        Fri, 23 Jul 2021 09:36:15 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id j26sm1643347lfh.71.2021.07.23.09.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 09:36:14 -0700 (PDT)
Date:   Fri, 23 Jul 2021 19:36:11 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        frowand.list@gmail.com, gregkh@linuxfoundation.org,
        jmaloy@redhat.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, robh+dt@kernel.org,
        robh@kernel.org, syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Subject: Re: [syzbot] KASAN: use-after-free Read in tipc_recvmsg
Message-ID: <20210723193611.746e7071@gmail.com>
In-Reply-To: <00000000000017e9a105c768f7a0@google.com>
References: <00000000000017e9a105c768f7a0@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/yRthpUK6XCZGPh=RhCsnSAD"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/yRthpUK6XCZGPh=RhCsnSAD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, 18 Jul 2021 10:15:19 -0700
syzbot <syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ab0441b4a920 Merge branch 'vmxnet3-version-6'
> git tree:       net-next
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=1744ac6a300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=e6741b97d5552f97c24d syz
> repro:
> https://syzkaller.appspot.com/x/repro.syz?x=13973a74300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ffc902300000
> 
> The issue was bisected to:
> 
> commit 67a3156453859ceb40dc4448b7a6a99ea0ad27c7
> Author: Rob Herring <robh@kernel.org>
> Date:   Thu May 27 19:45:47 2021 +0000
> 
>     of: Merge of_address_to_resource() and
> of_pci_address_to_resource() implementations
> 
> bisection log:
> https://syzkaller.appspot.com/x/bisect.txt?x=129b0438300000 final
> oops:     https://syzkaller.appspot.com/x/report.txt?x=119b0438300000
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=169b0438300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com Fixes:
> 67a315645385 ("of: Merge of_address_to_resource() and
> of_pci_address_to_resource() implementations")
> 
> ==================================================================
> BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90
> net/tipc/socket.c:1979 Read of size 4 at addr ffff8880328cf1c0 by
> task kworker/u4:0/8
> 

Since code accesing skb_cb after possible kfree_skb() call let's just
store bytes_read to variable and use it instead of acessing
skb_cb->bytes_read

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master



With regards,
Pavel Skripkin

--MP_/yRthpUK6XCZGPh=RhCsnSAD
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


--MP_/yRthpUK6XCZGPh=RhCsnSAD--
