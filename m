Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D45CF5A0F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbfKHVem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:34:42 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:45051 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfKHVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:34:42 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MaInF-1iNMKJ1SOz-00WBZ3; Fri, 08 Nov 2019 22:34:22 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Willem de Bruijn <willemb@google.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Stanislav Fomichev <sdf@google.com>,
        John Hurley <john.hurley@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Pedro Tammela <pctammela@gmail.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 03/16] net: sock: use __kernel_old_timespec instead of timespec
Date:   Fri,  8 Nov 2019 22:32:41 +0100
Message-Id: <20191108213257.3097633-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108213257.3097633-1-arnd@arndb.de>
References: <20191108213257.3097633-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dHZS9u9EEGjfoUU8DwFFYZFr9GRmH/0v+mphqJL+9zdWkvhrYSd
 IjhFW4adgcjrYBzyCFla32nOecMkZ7WtqrNYDuLPjbbUaVAqfFEUwnnJdPdZosywpQApddx
 CwBRz8KhG0DgQk5LRHYpA2Nyccpus4ewZHGyFhMU6ZTzGs+97OmoSj5Z66HJmrU0H+BUrgG
 OpGJIgPhmUJk6jsa0uQfg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:scDJt0L2i3s=:/0ToOLlNJ3SE+J0uqz1CcQ
 uqEaJAU2iU3qiFECJgMLAlSwHpUxqfWHl02EDRRsh5ILvCVS30o3bBobHpBzxB3WHHjeDATwY
 KC20Mf2kGiq2fmh2PVXjh3pwFqhFtDQwdZNkE87fzAFSKAAg8rRKrzsCfYfF+9LpbbFPt2FPY
 XmjLvY1wXiiqG0N2Yx3ovraqgjppqtFLHu4bkphwguR9+5Mh6Q7Q9WrbrJPYM80FrBfAZEW5m
 MJRgVhl2CC5VINqjv4YVJcPCKtBUg/l/0lfzv5Y392YNn2aSRJjLKJSmPinDNWkOBV+ICpr3B
 HjcTRFKg4FBajsYoI5meWzTOjEZ6PLAhH8JlF7hxyrncy7o+S8+8/Q6A236Bj//JMkyKayfBN
 dY6DO1elP4J+3Jcxby68osNl9L684vZ6/SFe+gk8OmRi/RBIp3e3wf0BiX3UredWF6sIV/BSA
 ++MBVFOnz5l/hAuilO3ZXvS0Vc3hQ/sBV715NUChQfZMISyyYbSRWEQDtrjJceDVKcUULxSr0
 yygz4xrcSoXt4f9ozxETUCEmETv8uqpHzIjjlooiwccrcRCeo7WxXvP0oOJSMrOG14q2Migpj
 /OiRKhid1N1yzlEvZ8m16fZIQbaNGZ14FL+vgE4HkSWQ3whA3bdAoyr9fg7y3ifzPPfutzfGp
 IRnUup2M6/MNdzbUmck7/LNvIqj1qJgDCYGuZdiAZK+7303FU7NxtW87QH7/4A9kexC8r6dG/
 7xXIHeMU/5xg6auy0lJUGwT3PsC0Wbh8iwaobHQ6NTTNdPGTohAezNV/KYtoShc66EZgheh9M
 s/BE56MbGfcOAwQ9/8cpN8J6dd37nFr1VHH0z8CLFhrfBnXLnW+KZGY9p80g8cfDY6p4b5bFR
 RPbhyrd4d4f3hzy7WbqQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'timespec' type definition and helpers like ktime_to_timespec()
or timespec64_to_timespec() should no longer be used in the kernel so
we can remove them and avoid introducing y2038 issues in new code.

Change the socket code that needs to pass a timespec to user space for
backward compatibility to use __kernel_old_timespec instead.  This type
has the same layout but with a clearer defined name.

Slightly reformat tcp_recv_timestamp() for consistency after the removal
of timespec64_to_timespec().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/skbuff.h |  7 +++++--
 net/compat.c           |  2 +-
 net/ipv4/tcp.c         | 28 ++++++++++++++++------------
 net/socket.c           |  2 +-
 4 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 64a395c7f689..6d64ffe92867 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3656,9 +3656,12 @@ static inline void skb_get_new_timestamp(const struct sk_buff *skb,
 }
 
 static inline void skb_get_timestampns(const struct sk_buff *skb,
-				       struct timespec *stamp)
+				       struct __kernel_old_timespec *stamp)
 {
-	*stamp = ktime_to_timespec(skb->tstamp);
+	struct timespec64 ts = ktime_to_timespec64(skb->tstamp);
+
+	stamp->tv_sec = ts.tv_sec;
+	stamp->tv_nsec = ts.tv_nsec;
 }
 
 static inline void skb_get_new_timestampns(const struct sk_buff *skb,
diff --git a/net/compat.c b/net/compat.c
index 0f7ded26059e..47d99c784947 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -232,7 +232,7 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
 		    (type == SO_TIMESTAMPNS_OLD || type == SO_TIMESTAMPING_OLD)) {
 			int count = type == SO_TIMESTAMPNS_OLD ? 1 : 3;
 			int i;
-			struct timespec *ts = (struct timespec *)data;
+			struct __kernel_old_timespec *ts = data;
 			for (i = 0; i < count; i++) {
 				cts[i].tv_sec = ts[i].tv_sec;
 				cts[i].tv_nsec = ts[i].tv_nsec;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d8876f0e9672..013f635db19c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1864,29 +1864,33 @@ static void tcp_recv_timestamp(struct msghdr *msg, const struct sock *sk,
 		if (sock_flag(sk, SOCK_RCVTSTAMP)) {
 			if (sock_flag(sk, SOCK_RCVTSTAMPNS)) {
 				if (new_tstamp) {
-					struct __kernel_timespec kts = {tss->ts[0].tv_sec, tss->ts[0].tv_nsec};
-
+					struct __kernel_timespec kts = {
+						.tv_sec = tss->ts[0].tv_sec,
+						.tv_nsec = tss->ts[0].tv_nsec,
+					};
 					put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
 						 sizeof(kts), &kts);
 				} else {
-					struct timespec ts_old = timespec64_to_timespec(tss->ts[0]);
-
+					struct __kernel_old_timespec ts_old = {
+						.tv_sec = tss->ts[0].tv_sec,
+						.tv_nsec = tss->ts[0].tv_nsec,
+					};
 					put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
 						 sizeof(ts_old), &ts_old);
 				}
 			} else {
 				if (new_tstamp) {
-					struct __kernel_sock_timeval stv;
-
-					stv.tv_sec = tss->ts[0].tv_sec;
-					stv.tv_usec = tss->ts[0].tv_nsec / 1000;
+					struct __kernel_sock_timeval stv = {
+						.tv_sec = tss->ts[0].tv_sec,
+						.tv_usec = tss->ts[0].tv_nsec / 1000,
+					};
 					put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_NEW,
 						 sizeof(stv), &stv);
 				} else {
-					struct __kernel_old_timeval tv;
-
-					tv.tv_sec = tss->ts[0].tv_sec;
-					tv.tv_usec = tss->ts[0].tv_nsec / 1000;
+					struct __kernel_old_timeval tv = {
+						.tv_sec = tss->ts[0].tv_sec,
+						.tv_usec = tss->ts[0].tv_nsec / 1000,
+					};
 					put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMP_OLD,
 						 sizeof(tv), &tv);
 				}
diff --git a/net/socket.c b/net/socket.c
index 98f6544b0096..9ab00a080760 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -793,7 +793,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_NEW,
 					 sizeof(ts), &ts);
 			} else {
-				struct timespec ts;
+				struct __kernel_old_timespec ts;
 
 				skb_get_timestampns(skb, &ts);
 				put_cmsg(msg, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
-- 
2.20.0

