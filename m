Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B904B7FDA
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 06:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbiBPFDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 00:03:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiBPFDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 00:03:46 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5912250B;
        Tue, 15 Feb 2022 21:03:32 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id y5so1203281pfe.4;
        Tue, 15 Feb 2022 21:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QYen+yXoACydatRF7VHxfC1n4Zzuip0//Ac/aVUXOg4=;
        b=PS2tgpS01v9O6W5wRKvdOLWYT3akkxWP9/9loaYN0/MBMOiE6SR3KuHuSKsOtej11H
         /CfjNY0/UZrTvTac9zWTTvmDEVfuLPosb09XPILSikZRMjM2HmIq3Cb4rEAevl3Yr0xk
         p3QCPiK8z/ZIhQCR9LmcOSARjlSCbJDch3eWKP+CnoTs9ETwgHM+lMEz4+dendx8j6Oo
         olt6HmVmvFEooQjKYYs02dpjGEBCY49jRymYEOvJJvdQWVrX78YVE6Lz1gRtDQhfynYc
         QXvAetXFi84QF2a7OaY79IwB+dR/I4X9GkcbMVK1YF7V8A5awZgocTjkTI4+c4tMcvuf
         rmqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QYen+yXoACydatRF7VHxfC1n4Zzuip0//Ac/aVUXOg4=;
        b=blG9AtzgxWtW7CXWpX64INPySuDak3LlcyGwZwXSWsOzYlxXl7npynrk5YtZuu2xte
         YdMEuOir1aj6qxl8DiEmqCAe2GSor4xopH59d/4NhsMg4mTFx/3fHlChntTdW1t3qkwn
         2sQFZOncl2BGoT+VFEg49EtJpROfMtXepKlj6hVexQrmeaKVp/Udm2eWZQvNMlzhwlaL
         /5RwVehpfgEqQ07/PKBDndlX2T8ebZLSm5XWuQSc5cisYtJeIqF+Ly8VmsS7tiVXdU5b
         tUryWezx63PNxsSxgZzDlVORIATHkWzoXaFKzE+cg5bdS3S5gUG+Fbe4dA1xNu13skJa
         FE9Q==
X-Gm-Message-State: AOAM532aF8jmVjTBxJHy9REYC4vNXtMi1RuyVJ676ctNddBiSv1xc+64
        eZ07aKi61+jWWLFX9eydUmQ=
X-Google-Smtp-Source: ABdhPJzIKn05hI2GOwLytg1pmVVm7M9vdSd0yfoW5F59aUuf2Wj51UEhjwqLA5tFB5fRVp4TeOwPfA==
X-Received: by 2002:a63:61d3:0:b0:34c:f48f:f96f with SMTP id v202-20020a6361d3000000b0034cf48ff96fmr908230pgb.622.1644987812170;
        Tue, 15 Feb 2022 21:03:32 -0800 (PST)
Received: from localhost.localdomain ([61.16.102.73])
        by smtp.gmail.com with ESMTPSA id s29sm4757996pfg.146.2022.02.15.21.03.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Feb 2022 21:03:31 -0800 (PST)
From:   kerneljasonxing@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, pabeni@redhat.com,
        weiwan@google.com, aahringo@redhat.com, yangbo.lu@nxp.com,
        fw@strlen.de, xiangxia.m.yue@gmail.com, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <xingwanli@kuaishou.com>
Subject: [PATCH v2 net-next] net: introduce SO_RCVBUFAUTO to let the rcv_buf tune automatically
Date:   Wed, 16 Feb 2022 13:03:20 +0800
Message-Id: <20220216050320.3222-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Normally, user doesn't care the logic behind the kernel if they're
trying to set receive buffer via setsockopt. However, once the new
value of the receive buffer is set even though it's not smaller than
the initial value which is sysctl_tcp_rmem[1] implemented in
tcp_rcv_space_adjust(),, the server's wscale will shrink and then
lead to the bad bandwidth as intended.

For now, introducing a new socket option to let the receive buffer
grow automatically no matter what the new value is can solve
the bad bandwidth issue meanwhile it's not breaking the application
with SO_RCVBUF option set.

Here are some numbers:
$ sysctl -a | grep rmem
net.core.rmem_default = 212992
net.core.rmem_max = 40880000
net.ipv4.tcp_rmem = 4096	425984	40880000

Case 1
on the server side
    # iperf -s -p 5201
on the client side
    # iperf -c [client ip] -p 5201
It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
server side is 10. It's good.

Case 2
on the server side
    #iperf -s -p 5201 -w 425984
on the client side
    # iperf -c [client ip] -p 5201
It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
wcale is 2, even though the receive buffer is not changed at all at the
very beginning.

After this patch is applied, the bandwidth of case 2 is recovered to
9.34 Gbits/sec as expected at the cost of consuming more memory per
socket.

Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
--
v2: suggested by Eric
- introduce new socket option instead of breaking the logic in SO_RCVBUF
- Adjust the title and description of this patch
link: https://lore.kernel.org/lkml/CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com/
---
 include/uapi/asm-generic/socket.h |  1 +
 net/core/sock.c                   | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index c77a131..f4ce79b 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -18,6 +18,7 @@
 #define SO_RCVBUF	8
 #define SO_SNDBUFFORCE	32
 #define SO_RCVBUFFORCE	33
+#define SO_RCVBUFAUTO	74
 #define SO_KEEPALIVE	9
 #define SO_OOBINLINE	10
 #define SO_NO_CHECK	11
diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d..8565684 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -917,13 +917,14 @@ void sock_set_keepalive(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_set_keepalive);
 
-static void __sock_set_rcvbuf(struct sock *sk, int val)
+static void __sock_set_rcvbuf(struct sock *sk, int val, bool is_set)
 {
 	/* Ensure val * 2 fits into an int, to prevent max_t() from treating it
 	 * as a negative value.
 	 */
 	val = min_t(int, val, INT_MAX / 2);
-	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+	if (is_set)
+		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 
 	/* We double it on the way in to account for "struct sk_buff" etc.
 	 * overhead.   Applications assume that the SO_RCVBUF setting they make
@@ -941,7 +942,7 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
 void sock_set_rcvbuf(struct sock *sk, int val)
 {
 	lock_sock(sk);
-	__sock_set_rcvbuf(sk, val);
+	__sock_set_rcvbuf(sk, val, true);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
@@ -1106,7 +1107,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
+		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max), true);
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -1118,7 +1119,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		/* No negative values (to prevent underflow, as val will be
 		 * multiplied by 2).
 		 */
-		__sock_set_rcvbuf(sk, max(val, 0));
+		__sock_set_rcvbuf(sk, max(val, 0), true);
+		break;
+
+	case SO_RCVBUFAUTO:
+		/* Though similar to SO_RCVBUF, we do not use userlocks in
+		 * order to let the receive buffer tune automatically.
+		 */
+		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max), false);
 		break;
 
 	case SO_KEEPALIVE:
-- 
1.8.3.1

