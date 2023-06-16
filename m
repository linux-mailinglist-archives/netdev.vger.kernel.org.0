Return-Path: <netdev+bounces-11343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A18732AB1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 921081C20F6A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6256CC8C3;
	Fri, 16 Jun 2023 08:57:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5647533ED
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:57:56 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BCDB3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:57:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56fffdea2d0so7654987b3.1
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 01:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686905873; x=1689497873;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C6Gvy2z57I02Yc7Rb+mkOaLtZ+86uVuzyz0jZ4G5FIM=;
        b=22M1Ug9zFupOlTupEo+RLMwFgEmQb5jiScUBB0bL3DH9KtKwQVtuR/qBSV0Xcz4r2n
         H6ePaHloBQDBrn28xbe1ymzGl4bsxvxnNR/M5pjDFTpnmvcmrwdDlQnX4luO8J+JJ7qT
         1cXGGyCZgZcE3W2IANAdAUhw9utCXQ35vj1GI4JpqHzPnLmZIbbvL4lxNp/ahYchnXha
         /cuRdHTso1rkYwtR9V2QAHLd36ZBNqRneonEyCyvRKwCWKO8Ej18bcRDVpClyifjjWfr
         tlWa0MCpyS2g4pXIF1Bs5wm4xMNQebtwpBoHsSHKLQRy69YRkT2QL4Qzh/eqxbDmxcGo
         l3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686905873; x=1689497873;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6Gvy2z57I02Yc7Rb+mkOaLtZ+86uVuzyz0jZ4G5FIM=;
        b=FMoWGM5CUKKDk5HgpptOTkHZtj1y24tlBwNVJ552bwmmX7wuRANWCbOo9A29kFvwGH
         8WkHchET2E/uZfgTVekW9ca9sbBoOnihrCC9sujV25cPgL32MdTrF1wuyJ2MTbvZsBb6
         KJ6q0S+QzqfWHFe844zMbGKyc9Bws5jmaNCSGkgdSzeFv/jrmglDZOfAjL+9v8yPUNVD
         CHZJRfV3IWmniTpRCZEB+zJv3dzDOGuQybhiHNqb2ZrHg72PCs6Eoc0iyM8w/VoZWNR1
         dP+G8CnIHJgbgG9wLPV+aH9MqzVrY5UvctazhC8nvpI0zyKPAJ6Al7qWm+F8Jvlczjh1
         c/5A==
X-Gm-Message-State: AC+VfDyTiSPjMOA5w1QHIi9uD8vfqJjqnc/FSg58/T0bwDKfvCwymIdI
	A322VE7JOb6sdIvwW5wNFvnKCUWg2QDqNg==
X-Google-Smtp-Source: ACHHUZ54mQgQbo2kee6aB3PYVnfzsp2G5eBUGx8TcX/1v7Irc6IpRVOjr7f/9f6SGRsRM+xpatg8zP+2F4io+Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:a701:0:b0:570:2879:833 with SMTP id
 e1-20020a81a701000000b0057028790833mr507307ywh.7.1686905873781; Fri, 16 Jun
 2023 01:57:53 -0700 (PDT)
Date: Fri, 16 Jun 2023 08:57:52 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.185.g7c58973941-goog
Message-ID: <20230616085752.3348131-1-edumazet@google.com>
Subject: [PATCH net-next] ipv6: also use netdev_hold() in ip6_route_check_nh()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In blamed commit, we missed the fact that ip6_validate_gw()
could change dev under us from ip6_route_check_nh()

In this fix, I use GFP_ATOMIC in order to not pass too many additional
arguments to ip6_validate_gw() and ip6_route_check_nh() only
for a rarely used debug feature.

syzbot reported:

refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 5006 at lib/refcount.c:31 refcount_warn_saturate+0x1d7/0x1f0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 5006 Comm: syz-executor403 Not tainted 6.4.0-rc5-syzkaller-01229-g97c5209b3d37 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
RIP: 0010:refcount_warn_saturate+0x1d7/0x1f0 lib/refcount.c:31
Code: 05 fb 8e 51 0a 01 e8 98 95 38 fd 0f 0b e9 d3 fe ff ff e8 ac d9 70 fd 48 c7 c7 00 d3 a6 8a c6 05 d8 8e 51 0a 01 e8 79 95 38 fd <0f> 0b e9 b4 fe ff ff 48 89 ef e8 1a d7 c3 fd e9 5c fe ff ff 0f 1f
RSP: 0018:ffffc900039df6b8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888026d71dc0 RSI: ffffffff814c03b7 RDI: 0000000000000001
RBP: ffff888146a505fc R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 1ffff9200073bedc
R13: 00000000ffffffef R14: ffff888146a505fc R15: ffff8880284eb5a8
FS: 0000555556c88300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004585c0 CR3: 000000002b1b1000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__refcount_dec include/linux/refcount.h:344 [inline]
refcount_dec include/linux/refcount.h:359 [inline]
ref_tracker_free+0x539/0x820 lib/ref_tracker.c:236
netdev_tracker_free include/linux/netdevice.h:4097 [inline]
netdev_put include/linux/netdevice.h:4114 [inline]
netdev_put include/linux/netdevice.h:4110 [inline]
fib6_nh_init+0xb96/0x1bd0 net/ipv6/route.c:3624
ip6_route_info_create+0x10f3/0x1980 net/ipv6/route.c:3791
ip6_route_add+0x28/0x150 net/ipv6/route.c:3835
ipv6_route_ioctl+0x3fc/0x570 net/ipv6/route.c:4459
inet6_ioctl+0x246/0x290 net/ipv6/af_inet6.c:569
sock_do_ioctl+0xcc/0x230 net/socket.c:1189
sock_ioctl+0x1f8/0x680 net/socket.c:1306
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:870 [inline]
__se_sys_ioctl fs/ioctl.c:856 [inline]
__x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
do_syscall_x64 arch/x86/entry/common.c:50 [inline]

Fixes: 70f7457ad6d6 ("net: create device lookup API with reference tracking")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
---
 net/ipv6/route.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e510a4162ef8b8bd7209d8c571a6a1fc465244ab..64e873f5895f1907b813d675a9ea46f5db3f429c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3360,6 +3360,7 @@ static int ip6_route_check_nh_onlink(struct net *net,
 static int ip6_route_check_nh(struct net *net,
 			      struct fib6_config *cfg,
 			      struct net_device **_dev,
+			      netdevice_tracker *dev_tracker,
 			      struct inet6_dev **idev)
 {
 	const struct in6_addr *gw_addr = &cfg->fc_gateway;
@@ -3404,7 +3405,7 @@ static int ip6_route_check_nh(struct net *net,
 			err = -EHOSTUNREACH;
 	} else {
 		*_dev = dev = res.nh->fib_nh_dev;
-		dev_hold(dev);
+		netdev_hold(dev, dev_tracker, GFP_ATOMIC);
 		*idev = in6_dev_get(dev);
 	}
 
@@ -3412,7 +3413,9 @@ static int ip6_route_check_nh(struct net *net,
 }
 
 static int ip6_validate_gw(struct net *net, struct fib6_config *cfg,
-			   struct net_device **_dev, struct inet6_dev **idev,
+			   struct net_device **_dev,
+			   netdevice_tracker *dev_tracker,
+			   struct inet6_dev **idev,
 			   struct netlink_ext_ack *extack)
 {
 	const struct in6_addr *gw_addr = &cfg->fc_gateway;
@@ -3453,7 +3456,8 @@ static int ip6_validate_gw(struct net *net, struct fib6_config *cfg,
 		if (cfg->fc_flags & RTNH_F_ONLINK)
 			err = ip6_route_check_nh_onlink(net, cfg, dev, extack);
 		else
-			err = ip6_route_check_nh(net, cfg, _dev, idev);
+			err = ip6_route_check_nh(net, cfg, _dev, dev_tracker,
+						 idev);
 
 		rcu_read_unlock();
 
@@ -3571,7 +3575,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	}
 
 	if (cfg->fc_flags & RTF_GATEWAY) {
-		err = ip6_validate_gw(net, cfg, &dev, &idev, extack);
+		err = ip6_validate_gw(net, cfg, &dev, dev_tracker,
+				      &idev, extack);
 		if (err)
 			goto out;
 
-- 
2.41.0.185.g7c58973941-goog


