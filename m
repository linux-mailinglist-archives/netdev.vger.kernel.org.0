Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213AC3BA7E6
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 10:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhGCItr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 04:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhGCItq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 04:49:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A89C061762;
        Sat,  3 Jul 2021 01:47:13 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso9025217pjx.1;
        Sat, 03 Jul 2021 01:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5LqaHOTleUwEc8rezvK4+11SzDVWy9M2nq3QHqzO1A=;
        b=JmksDk+G/11lCWwdFtloFd5ErcfB70in1PJ8teXH827oRb1YG9b5QnMaMSA/l/3NwA
         VVYj5slobUkbtaJDdvQtd+OFd3BTpzfAtSpd9rSGgs0kODZqe5j5WyHbnNeBKb0mGemP
         0Kin+cgjF/yw/vXYSqrGex5qH89vLWcKilbKVL6m4XHhQ4CS5EGtS7JlclGzraL0+SLf
         IM2k5af5hs6PGPe4ZigHWrzVB5/xNeQGvEsTBF94q0kBGuBDwBiTbZTUHJgYqXALFgUd
         e/eC6kNfH0fpe7eWOBn5x5UTeI5dOLO2/D4UYHKOZVmXV/8NLzRJeWKC4JgYa1sjhg1/
         dttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X5LqaHOTleUwEc8rezvK4+11SzDVWy9M2nq3QHqzO1A=;
        b=cMHDyK5c7qIlwDPS7HXZSO11vJ3pxZbXM/HVdfLAYmBer3D6XplBBpGF2zq8yszM/u
         tyAW2dVDJkXEkz/Z7ElQU1WJPCb+2F8tpsL5ty1gsLZXIlzPPpRgd5eEFhf5w2DjxYd/
         vECm74TnO2b6SvDlNCFfQx6VqiPAhdVlPAejFiGu0VAVk4U+8va8cYDQqqMeV3m+HU8y
         O6VqSzGvEqzVAFROkwGBJ/kzcUVbEUU/qFo4Hizoa73LbzkCf6kQO2PSaWEjQ09hzUHA
         /mmfvuvJFwbG/ehqiPqBbz4r2GoTyXd4Zb06Cid/SNwa0iNM1l6ewhKqXaqGZXyRB4+5
         AQ0A==
X-Gm-Message-State: AOAM532LX3qidUwUkeC58J9+MV7CnoaaYz3a8x7sOojGTH5U5NKNe1jt
        GLJGQNc7lpbZ5RZmjcPs3GA=
X-Google-Smtp-Source: ABdhPJy4kQ82sVIVkMMbUFzKmgZYCcgMjoMXW0PnOfLEgnWYrWhHK49npgVaZbBi1xJ2U3+Pt8IvIw==
X-Received: by 2002:a17:90b:4d81:: with SMTP id oj1mr3609967pjb.153.1625302033236;
        Sat, 03 Jul 2021 01:47:13 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id h27sm6557907pfr.171.2021.07.03.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 01:47:12 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     yhs@fb.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: [PATCH v3] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
Date:   Sat,  3 Jul 2021 16:47:00 +0800
Message-Id: <20210703084700.1546968-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a bug (found by syzkaller) that could cause spurious
double-initializations for congestion control modules, which could cause
memory leaks orother problems for congestion control modules (like CDG)
that allocate memory in their init functions.

The buggy scenario constructed by syzkaller was something like:

(1) create a TCP socket
(2) initiate a TFO connect via sendto()
(3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
    which calls:
       tcp_set_congestion_control() ->
         tcp_reinit_congestion_control() ->
           tcp_init_congestion_control()
(4) receive ACK, connection is established, call tcp_init_transfer(),
    set icsk_ca_initialized=0 (without first calling cc->release()),
    call tcp_init_congestion_control() again.

Note that in this sequence tcp_init_congestion_control() is called
twice without a cc->release() call in between. Thus, for CC modules
that allocate memory in their init() function, e.g, CDG, a memory leak
may occur. The syzkaller tool managed to find a reproducer that
triggered such a leak in CDG.

The bug was introduced when that commit 8919a9b31eb4 ("tcp: Only init
congestion control if not initialized already")
introduced icsk_ca_initialized and set icsk_ca_initialized to 0 in
tcp_init_transfer(), missing the possibility for a sequence like the
one above, where a process could call setsockopt(TCP_CONGESTION) in
state TCP_SYN_SENT (i.e. after the connect() or TFO open sendmsg()),
which would call tcp_init_congestion_control(). It did not intend to
reset any initialization that the user had already explicitly made;
it just missed the possibility of that particular sequence (which
syzkaller managed to find).

Fixes: 8919a9b31eb4 (tcp: Only init congestion control if not initialized already)
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
V2:     - Modify the Subject line.
        - Adjust the commit message.
        - Add Fixes: tag.
V3:	- Fix netdev/verify_fixes format error.

 net/ipv4/tcp_input.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7d5e59f688de..855ada2be25e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp = tcp_jiffies32;

-	icsk->icsk_ca_initialized = 0;
 	bpf_skops_established(sk, bpf_op, skb);
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
--
2.25.1

