Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9F3BC40B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 01:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGEXWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 19:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbhGEXV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 19:21:59 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB07C061574;
        Mon,  5 Jul 2021 16:19:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so659497pjb.0;
        Mon, 05 Jul 2021 16:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwbRb3jpffDliQd5+ObWDoU7B1AAjNEgpgkFUzNvpnw=;
        b=pFesCE1VkR9SI4pdCrxbURHurlHIt4eRLJKC8LblTfpZ+XHwCZFE94HfRtesarR2c7
         P5k1nbLOJKFwJLf4a4y4M6wRcFb7zhs37sKOtNxAwiMvhJuNyzPZCOHZT4z/P/9qQBv1
         aC3lUFw++YSCh1PCm5Q5LFBVOsGOLQ44/N6nnKu2jO4hvfxSzw6IVvlHZCdx2lZtNacc
         C/3yT8MoCMkD/KaNVf9sEmyJ+2GlJpWybsTS83FI/edMdDU1v/nB0ivYvWfvWJ8+qX1b
         hB3aXw4wdmZQBQtQoKVhlfRNyrtbeXKpuYq92Ciq1XcAPxKbzVz6QrnZ/K8+A5HZfgk5
         j09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AwbRb3jpffDliQd5+ObWDoU7B1AAjNEgpgkFUzNvpnw=;
        b=bilbkT0Nmw9YxwGidlKLvdDy8aTSEN5uOnml8BibIUOeMw+yEJqoEKJEHcOT/mpcsj
         8dfsVjt54czZEEzSZ0AmXNaO/fPMd0dxUUFJEm75iEWLwShOBEeKT4gHzVKwRV0BNHav
         q9DejzXzCmjUQglyWIfic66WnwroFVT3ubPDa3nCzVj/y6VsQCYhMuriN+Xr5gQClhbx
         z9v58SqO1L8AIqzkreYbRA9xoIsTIeA2fOfHQ3GYllmWpskqJGOzNmtCEjQpfWMiHQKo
         3uhgvt9wKx/Kui/I9cWSffaezhRVN9ajtVe7EGEyODmKrdf+1OgST61a+9BLGSLz7V5/
         z1LQ==
X-Gm-Message-State: AOAM531kucPVveBM79JxbUO/3mNXa6mZDNq9GHvfomHEPrxQeeAg915Y
        Z5oSVJKXpl+TqCffpIDqANk=
X-Google-Smtp-Source: ABdhPJzkoI7y2nCb4uw1FOobg+RUTq8genZo373bH67t9YA/FNNwL/28LTVHjjYnaLLreGColocYCA==
X-Received: by 2002:a17:902:b210:b029:11a:bf7b:1a83 with SMTP id t16-20020a170902b210b029011abf7b1a83mr14306975plr.84.1625527160305;
        Mon, 05 Jul 2021 16:19:20 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id h9sm6579067pgi.43.2021.07.05.16.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 16:19:19 -0700 (PDT)
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
Subject: [PATCH v6] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
Date:   Tue,  6 Jul 2021 07:19:12 +0800
Message-Id: <20210705231912.532186-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a bug (found by syzkaller) that could cause spurious
double-initializations for congestion control modules, which could cause
memory leaks or other problems for congestion control modules (like CDG)
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

Fixes: 8919a9b31eb4 ("tcp: Only init congestion control if not initialized already")
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
V2:     - Modify the Subject line.
        - Adjust the commit message.
        - Add Fixes: tag.
V3:     - Fix netdev/verify_fixes format error.
V4:     - Add blamed authors to receiver list.
V5:	- Add comment about the congestion control initialization.
V6:	- Fix typo in commit message.
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7d5e59f688de..84c70843b404 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5922,8 +5922,8 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp = tcp_jiffies32;

-	icsk->icsk_ca_initialized = 0;
 	bpf_skops_established(sk, bpf_op, skb);
+	/* Initialize congestion control unless BPF initialized it already: */
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
--
2.25.1

