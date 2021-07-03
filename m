Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE42A3BA812
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 11:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhGCJg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 05:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhGCJg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 05:36:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B92C061762;
        Sat,  3 Jul 2021 02:34:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 62so4355489pgf.1;
        Sat, 03 Jul 2021 02:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA2FyDBb7VVZ1//gW7vJlp4ZAiXUzh99M3RwT57vTIw=;
        b=Az5UIhl/sRLYFP7/l98uaxO8255cP2jLQFPASm7wIL8pcr4SkuEctY2ZXYCRWe6PYE
         Q8MKV/+5JjaVrkibRAlQVwwTbz287kc0JfkE0QG/Fpk7yGcZV9Xb0pAA8SdAf0hP+3BK
         nAZuI+V9p5GvL4HhqZdarEMj7b+0IH3xJ/D1Li5xnjtXJSUjhKfblPJylh3IyZFPtBtd
         9rIiKYQaHcw73Osh/cFoCqva612gT1Yv3DcJmC3bDw1NcK6kcbmjUOKZzHn9kcwsdXeI
         4M3mafEiCNk6pxelGcMhseZmhGyTBwVW2PzJ61aQ22GfgO01682JTKHfS+ObcA+SYA0i
         v1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA2FyDBb7VVZ1//gW7vJlp4ZAiXUzh99M3RwT57vTIw=;
        b=W7JAlbYjXqXBHOCyR7FXLPU0NOiEf6vRa1kHSHnf9CWFPn5DSj+BpqFqG2CaKLkNVe
         c3fl10N0x0F4kMn3eAbN1oJ7cy2uQQ5EQbhV5GxRR9a6E8y2qinjJ9SlizrKNFTUKgGs
         xj6Kj78sfhFMcDjS2omSqpIzdzTEF6SXvwAm8fN6XRi634cJHxog3bWByRkDGhWb7MrU
         gkdKfoZQ3L95eU0OM0MZIlx0b8DUdK/TDZdcXdI3LX6iNxn0BWSLnIlZaU3M5NdHQdkd
         OLaght0kBao0yEj8/v2SOA+nsQOeBYjxURqpzPa0TUXzP0iB5GJROPwU92PgPhYySzuz
         kxEg==
X-Gm-Message-State: AOAM533iS22baLy2/8E5HcNrXEYvJyWPt57BLYYdcPUZ2lg4qUkJ0pWJ
        bpUoeThbQ5K9h+kl9YsCXrk=
X-Google-Smtp-Source: ABdhPJxyffHwZGoXuXPFOyFpbw/YsOfSYAd3+uayOwhxVr3lCsxNRoB+lGmlEXPjCN7XJPH6dKOCmg==
X-Received: by 2002:a62:8286:0:b029:2fc:812d:2e70 with SMTP id w128-20020a6282860000b02902fc812d2e70mr3813374pfd.24.1625304864568;
        Sat, 03 Jul 2021 02:34:24 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id 144sm7200562pgg.4.2021.07.03.02.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jul 2021 02:34:24 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     yhs@fb.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, ncardwell@google.com,
        yyd@google.com
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: [PATCH v4] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
Date:   Sat,  3 Jul 2021 17:34:17 +0800
Message-Id: <20210703093417.1569943-1-phind.uet@gmail.com>
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
V4:	- Add blamed authors to receiver list.

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

