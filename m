Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278E13B65D9
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 17:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhF1PlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 11:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238352AbhF1Pkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 11:40:33 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED227C014DB2;
        Mon, 28 Jun 2021 07:49:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s137so6658100pfc.4;
        Mon, 28 Jun 2021 07:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiDXnE8T2Ig5kLEgxQ1DfTJKMTQe2R8bhbRnEAoK84s=;
        b=Vrq/Ea6qGJUhzc7gcvNXr57zCRefc4FYl6MasfCkZZ8WaC0yPEEnfdg1z8CR/Ykoph
         KM2apzV6fPdUogvpTes/NWICoQWmZ9nqHa4/Jd15l13BQbzMRGqgupSCSUeaa8ujaAaf
         Xj1BYIshZxIF9exy9WTevwciw9WZzkOx1fTbDujJ3oJiKWhqcKltHoiKRpjMay24gkDN
         nrS74Xt7HJdLwsIuUfeMavUi92C5rUF8yD9gdi3ZUZHI7pn11nufYoY9fB6muo0H06i0
         ezDWdzWmk2A09w1NWjiR2Ahn4STqPGxwme4TocaRRSQafPPcRC8XP+WGzCkKfDxOaYc6
         STJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xiDXnE8T2Ig5kLEgxQ1DfTJKMTQe2R8bhbRnEAoK84s=;
        b=TXjGmoQYIb1ytfXe35iD1d1zfJULEN1Ws7E5d/hkDOYVX6mixKqIAqCUjWH2oKL8R7
         Da2RSxrbzfhh+rJwuMwsdc5j5ZBIYbC4WbjTWJctAV7PnhT6B241q2WY6bRYPhzNZgiE
         KVHhJOioCsu8mi/mZZOWAtCTIT/TjmjV5JpAmf6SsNJ4HhaKBiJ3ZxOR9+YwGML4OOXH
         sSUFbeYJxMQu7Q7qyF5Prf3FvZmiEcyIJNHjRF3BlHiZhL3fzwjgD7t6vFT803peYPxZ
         hWi3Xm1OuHpBSXp0QuGYa1nLUX7v7tBLwUaLdYRx7JHWS78HeH2eaEvcOLTs/kmlxE0Z
         YaAw==
X-Gm-Message-State: AOAM5328hsHqXYtPe1h9tlGi0yznqPeDqu2CULEepMqtQft7f7POllwu
        YYXAewpm2ImXlb2qHRYUu8k=
X-Google-Smtp-Source: ABdhPJwKRrblBM25Q0gWgepFLowuQ9Gnaf0uLSdgkLD8VmLcQUsMzPzn0e2TSPMDaIbzr3Q8UTXvxQ==
X-Received: by 2002:aa7:999c:0:b029:308:7e6e:6fbc with SMTP id k28-20020aa7999c0000b02903087e6e6fbcmr22364879pfh.10.1624891755408;
        Mon, 28 Jun 2021 07:49:15 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id j24sm14695331pfe.58.2021.06.28.07.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 07:49:15 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: [PATCH] tcp: Do not reset the icsk_ca_initialized in tcp_init_transfer.
Date:   Mon, 28 Jun 2021 22:49:08 +0800
Message-Id: <20210628144908.881499-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

icsk_ca_initialized be always set to zero before we examine it in if
block, this makes the congestion control module's initialization be
called even if the CC module was initialized already.
In case the CC module allocates and setups its dynamically allocated
private data in its init() function, e.g, CDG, the memory leak may occur.

Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
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

