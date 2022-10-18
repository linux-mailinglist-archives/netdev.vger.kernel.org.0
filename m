Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDA76028D5
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiJRJ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiJRJ4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:56:10 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DDDB14E6
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:56:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l4so13320731plb.8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jtrYS4YHTHJyeV0BrKarMa2E7fQ5TkzCkIZIXsuNB6M=;
        b=oenwaTPW1G/G0oYjiY2Jz+vgubsEzMHjnssLGIteFpvx1UHaicxfzkrTXcHfKNjqgr
         H5GDYD8DIZsmoqWcOduHGD4UkJxy4uDmj2EHyhD3GGddJoR1x5FCwUlzeEnpJg5ofZ8b
         p7bQ9+3Ym69YubrP9h+mGcRCyXp/kWwXpymLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtrYS4YHTHJyeV0BrKarMa2E7fQ5TkzCkIZIXsuNB6M=;
        b=N00bUjXB9ylOBEEz7tvo4nof8AGAPwOQA5vG2qiyvMDYwE7GCU5Ji5sfgdzpUjAGar
         X0rIoDbEjdMY4zDyxyqy4CiFx7ELb1tYE3TK6NVLBNVdjrsSANI/5vp+onASMgNfes5o
         Hj0sv4eCUiy4ucmcmaugTZttjtmmtakF/5akeBmLgmF0+vkPiQrQxVis30BBYNLqpuPR
         QuU3MBGGBkumkSWbDRaMd5u/N4P/5iuzZH2i8gcKVGhSeNdwZHD2spP/mm9611LbVVVT
         9eMPUNEd810w+tUpl1WktByfsByGi+yqz59ixTCiM4mM4YmNX0Pveg4R44kaRxa16Q2u
         +ofg==
X-Gm-Message-State: ACrzQf0kJXtuUnpnZcSpdbmVqFkXURH2n8U56TBAKRC5rtWjXX8RBlOx
        jhVVkknLNkLQ0wiGQoqV/IJn1Q==
X-Google-Smtp-Source: AMsMyM5kBAOpMO4cIxI/xoGLpufUFikFXHqNkBnrcviabpH1rUnjV3XPBSpbn19uO3b0a9DH3TkvaA==
X-Received: by 2002:a17:903:22d2:b0:17f:7dea:985f with SMTP id y18-20020a17090322d200b0017f7dea985fmr2216382plg.68.1666086969145;
        Tue, 18 Oct 2022 02:56:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a15-20020aa7970f000000b00561ed54aa53sm9031861pfg.97.2022.10.18.02.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:56:08 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Dylan Yudaken <dylany@fb.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Petr Machata <petrm@nvidia.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Congyu Liu <liu3101@purdue.edu>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: dev: Convert sa_data to flexible array in struct sockaddr
Date:   Tue, 18 Oct 2022 02:56:03 -0700
Message-Id: <20221018095503.never.671-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5049; h=from:subject:message-id; bh=rod5eHf0YQaVZ5sdwIzdd3C3vGobY6SuehBoBbg6GcI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTngzTHeW9kIfcHHQzkfp7D2VeT13DlZgTB42LZtK VyM9/qCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY054MwAKCRCJcvTf3G3AJjpoD/ 4mywSfiiYVC2vh0zMOE/MTSX2SRkfMVgE8MnDwc61EJGRB2o0fYwvty4chFUzQrZcR9YURMHRu9+86 /3CAxYYoQVJgwbwZi7zoYlb6NowRphiNorvQ/ny0q6bDOTwUzF1DbADlrMaVwRjsg0j02bOHSb6AQq WSOa+11Xtjmp/4JAczO9sk/06Zuh8S0Pm4ITZrQxoIydZZVLo2HujJ2wcKqAelUiCXHKVAR4d+YgmZ bbnRvO7WvnsPRy1tEKrBSTsi4HfGwkdFLTRxAwkptpcMWB8fYdqnlcBwiIUdcgNvMuKyJ2FFSV1+n1 Ygy7hah6Sj40CJw4QpRgNlcA+Qt8yK3Gr8zys8oNZ73vR9LcHTXsX5tkFVo/KRzoFsBfXFKL4ldLHw VxbjJrk8q2ZodJfmqfBs8y9x1RVuOjHYJL2Lw71G6klBfjHobULRfdJ9Sz64UvGteSGQcoEkR5ar18 TdHVxysdjUrKciYlOWQrCiU+lXt1lXV2qHydQEf61GM1EOPnItbikWumCcxezfsUgdgXD8CYsSLW4D 5Hh625MMZen1VjTSztbEibqJcNHj8BQMoARGjMlsTdVCBctf2HRwofrX51F9BYeO1cvM4gi+bAEOz+ d090jiMeXjVqaiTUsXHJlu89A/7PwgcfRWYuIBHv4MdK8vKMU6l/L41uMP/A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the worst offenders of "fake flexible arrays" is struct sockaddr,
as it is the classic example of why GCC and Clang have been traditionally
forced to treat all trailing arrays as fake flexible arrays: in the
distant misty past, sa_data became too small, and code started just
treating it as a flexible array, even though it was fixed-size. The
special case by the compiler is specifically that sizeof(sa->sa_data)
and FORTIFY_SOURCE (which uses __builtin_object_size(sa->sa_data, 1))
do not agree (14 and -1 respectively), which makes FORTIFY_SOURCE treat
it as a flexible array.

However, the coming -fstrict-flex-arrays compiler flag will remove
these special cases so that FORTIFY_SOURCE can gain coverage over all
the trailing arrays in the kernel that are _not_ supposed to be treated
as a flexible array. To deal with this change, convert sa_data to a true
flexible array. To keep the structure size the same, move sa_data into
a union with a newly introduced sa_data_min with the original size. The
result is that FORTIFY_SOURCE can continue to have no idea how large
sa_data may actually be, but anything using sizeof(sa->sa_data) must
switch to sizeof(sa->sa_data_min).

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Petr Machata <petrm@nvidia.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/socket.h |  5 ++++-
 net/core/dev.c         |  2 +-
 net/core/dev_ioctl.c   |  2 +-
 net/packet/af_packet.c | 10 +++++-----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index de3701a2a212..13c3a237b9c9 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -33,7 +33,10 @@ typedef __kernel_sa_family_t	sa_family_t;
 
 struct sockaddr {
 	sa_family_t	sa_family;	/* address family, AF_xxx	*/
-	char		sa_data[14];	/* 14 bytes of protocol address	*/
+	union {
+		char sa_data_min[14];		/* Minimum 14 bytes of protocol address	*/
+		DECLARE_FLEX_ARRAY(char, sa_data);
+	};
 };
 
 struct linger {
diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..0649826e5803 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8818,7 +8818,7 @@ EXPORT_SYMBOL(dev_set_mac_address_user);
 
 int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
 {
-	size_t size = sizeof(sa->sa_data);
+	size_t size = sizeof(sa->sa_data_min);
 	struct net_device *dev;
 	int ret = 0;
 
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7674bb9f3076..5cdbfbf9a7dc 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -342,7 +342,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		if (ifr->ifr_hwaddr.sa_family != dev->type)
 			return -EINVAL;
 		memcpy(dev->broadcast, ifr->ifr_hwaddr.sa_data,
-		       min(sizeof(ifr->ifr_hwaddr.sa_data),
+		       min(sizeof(ifr->ifr_hwaddr.sa_data_min),
 			   (size_t)dev->addr_len));
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 		return 0;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6ce8dd19f33c..8c5b3da0c29f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3277,7 +3277,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 			    int addr_len)
 {
 	struct sock *sk = sock->sk;
-	char name[sizeof(uaddr->sa_data) + 1];
+	char name[sizeof(uaddr->sa_data_min) + 1];
 
 	/*
 	 *	Check legality
@@ -3288,8 +3288,8 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	/* uaddr->sa_data comes from the userspace, it's not guaranteed to be
 	 * zero-terminated.
 	 */
-	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data));
-	name[sizeof(uaddr->sa_data)] = 0;
+	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
+	name[sizeof(uaddr->sa_data_min)] = 0;
 
 	return packet_do_bind(sk, name, 0, pkt_sk(sk)->num);
 }
@@ -3561,11 +3561,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
-	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data_min));
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), READ_ONCE(pkt_sk(sk)->ifindex));
 	if (dev)
-		strscpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
+		strscpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data_min));
 	rcu_read_unlock();
 
 	return sizeof(*uaddr);
-- 
2.34.1

