Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6FB48883B
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbiAIGhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiAIGhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:37:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30361C06173F;
        Sat,  8 Jan 2022 22:37:18 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so3217964pja.1;
        Sat, 08 Jan 2022 22:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iti5sESAOcClmZrnJzGTRKx0DfFMS6RUHfyIcg2sm0M=;
        b=H4XTKWn52DkOQY8RTNT6sXH0wIUZ/6UDKNShUgPNfMk4ctOGUs6YLnD7KM7hcnkHQH
         bqTj/uwHiuStZKbQ5olShYHgBc1FNfSTPokagR/HXCBldtoBwmiYHPIpaxFhwlqPA3fg
         iYFzVF1I3rsQv0vzBmz2pbgWhU+CF2Bzc4u4ylaHdg28OJxiUsy1V7ucGhdkEjHtqoJn
         5MazbhsLaGLzErJgAemrBgr46C61GhVGvixK5z5vHAy5mdSAGRUWVlrDSpQ23OrYA4GJ
         T3H9aNqb2WWo/YjN9F7FEtlP5z6ErD3c2DR70W5cXtlFgp2cjbiHnqv3y+dANXHmyYki
         lgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iti5sESAOcClmZrnJzGTRKx0DfFMS6RUHfyIcg2sm0M=;
        b=GbFNj45BxEdeJtFq55gwcqog22h/9Nd8nu/9kSSSM5a7atTFFor/8LkcfOYI5FHXsK
         HfrwwwTx2UWEOHcesMLxg6ORg5jvpbnEuHjb1fOi1E89aDiY0daOeK/kZ34P9Egnvt3p
         Ch7OCtJFtB0tH/JYIOpg1OmXiron+BAqNTm1OM6EgwL6FNk+ln8VK6SUmWoje8BNEszH
         LO0Ky5eTInH/a+4kYQPPLgzM0hBbnpKsvxOi7SO0yBitOv/8Xstgn758cWFxR7D5jf7F
         AgBGiGlr+mz37NnJV3keJNPqcvXbD97ylUS0w2D/UF7IAJL6OHiRMzqWRflDoIEiaErq
         Dxuw==
X-Gm-Message-State: AOAM531zs26d6XpvC0GjYIn4GfnXHs20jrZ2jBVny5DXX3WubllwSYrI
        Br6mi4CA09hDAe2vsl6WxbQ=
X-Google-Smtp-Source: ABdhPJzQgBuulClcFSDrkGK/2LXG4hJ8BQ7KJjCr8JwaT/Ewm6qwRI55gdNIbeaGEMeYausDb5ZXUQ==
X-Received: by 2002:a17:902:8347:b0:149:b26a:b9bc with SMTP id z7-20020a170902834700b00149b26ab9bcmr34789001pln.141.1641710238047;
        Sat, 08 Jan 2022 22:37:18 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id my5sm5892042pjb.5.2022.01.08.22.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 22:37:17 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, alobakin@pm.me, willemb@google.com,
        cong.wang@bytedance.com, keescook@chromium.org, pabeni@redhat.com,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        imagedong@tencent.com
Subject: [PATCH v4 net-next 0/3] net: skb: introduce kfree_skb_with_reason()
Date:   Sun,  9 Jan 2022 14:36:25 +0800
Message-Id: <20220109063628.526990-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patch, the interface kfree_skb_with_reason() is
introduced(), which is used to collect skb drop reason, and pass
it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
able to monitor abnormal skb with detail reason.

In fact, this series patches are out of the intelligence of David
and Steve, I'm just a truck man :/

Previous discussion is here:

https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/

In the first patch, kfree_skb_with_reason() is introduced and
the 'reason' field is added to 'kfree_skb' tracepoint. In the
second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
in tcp_v4_rcv(). In the third patch, 'kfree_skb_with_reason()' is
used in __udp4_lib_rcv().

Changes since v3:
- fix some code style problems in skb.h

Changes since v2:
- rename kfree_skb_with_reason() to kfree_skb_reason()
- make kfree_skb() static inline, as Jakub suggested

Changes since v1:
- rename some drop reason, as David suggested
- add the third patch


Menglong Dong (3):
  net: bpf: handle return value of 
    BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
  bpf: selftests: use C99 initializers in test_sock.c
  bpf: selftests: add bind retry for post_bind{4, 6}

 include/net/sock.h                      |   1 +
 net/ipv4/af_inet.c                      |   2 +
 net/ipv4/ping.c                         |   1 +
 net/ipv4/tcp_ipv4.c                     |   1 +
 net/ipv4/udp.c                          |   1 +
 net/ipv6/af_inet6.c                     |   2 +
 net/ipv6/ping.c                         |   1 +
 net/ipv6/tcp_ipv6.c                     |   1 +
 net/ipv6/udp.c                          |   1 +
 tools/testing/selftests/bpf/test_sock.c | 370 ++++++++++++++----------
 10 files changed, 233 insertions(+), 148 deletions(-)

-- 
2.27.0

