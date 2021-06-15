Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C603A73AA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhFOCZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbhFOCZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:25:27 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACD0C061574;
        Mon, 14 Jun 2021 19:23:23 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g12so10165108qtb.2;
        Mon, 14 Jun 2021 19:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eN4jLDO5ZyjqYLbpt/gFWZcY5yGAo59kBcRM9OErJwo=;
        b=d7YB4179DjPirCANDqeGzyc6MZHJ/65nBoRHl77NvSByKmVk4xerbbil1ajiODX+/j
         HLWlD30eRLywnGp7u8x2Aq0XESnxAbtBDwO8VUjIozabHJgI5AvqaWxke0tm8Ig6KWUO
         +3knEQDx88GLh/JhV22exhNJtfpD5virR/c33i5Uwf7sVGl/T3a8zfiS+1pRSk2jC0lE
         W6t2yBEu8F19IKHxWWLMJiUd/tWxhv9cV1BYz8NDWuZBAomJV+J88C6gY0XT+iUQ3sWg
         iIlIMB7ARt1CLsn8VPZlKaGEWTryuFWtyw8hzFXmUI0cLQ6XmTzWJdX3nEYBR2azMTDk
         cu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eN4jLDO5ZyjqYLbpt/gFWZcY5yGAo59kBcRM9OErJwo=;
        b=H4Y7yLXHtZ5zFt7uVB/p7SAaMJQNyozgm8IpoVwuWJlWJ/d6T2NTNXLxkXWyqxNqdC
         slnve2SCuq3Ek6xZMtIWsVOD4XGUBGkKQtMnfU1P3urroHY7pVEeWwsQoVMQHS2b1hlk
         qoU+GOzZ/UefiMG9qni8RpYCwVzms6+Xuq99KzFKtYYVEv7sw4TP0Vxsbwzv9gll82uQ
         Th0uNdc8CrPNCm24vsoBuvc4OPgY4gEU2UAJYS8zzTv5JWsj4xvUipP0CoiHpvbqEPYo
         i5yhbXoDjgLZOsFhSNDTSDhkUhwgz4qGrjrfWcInHjhW2GELz024KYWFgtsWQndwvizm
         5ElQ==
X-Gm-Message-State: AOAM532+GlwNQtG5LwN4UDX6mED9tuHnLtwWGluveLzsGPZ9sMRLMOmM
        p2CXHRZbWuFoLCvrLbwvT4ZnfF3m5PgcGw==
X-Google-Smtp-Source: ABdhPJzYC0/49AofL9k7eso6yPXhOa80WdN6e6H0bNtvrtxbrI9xhZzOPrHUUXJQFA2jGakqsnhAYQ==
X-Received: by 2002:a37:a1d5:: with SMTP id k204mr19816231qke.300.1623723235086;
        Mon, 14 Jun 2021 19:13:55 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:13:54 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH RESEND bpf v3 0/8] sock_map: some bug fixes and improvements
Date:   Mon, 14 Jun 2021 19:13:34 -0700
Message-Id: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains a few bug fixes and improvements for sock_map.

Patch 1 improves recvmsg() accuracy for UDP, patch 2 improves UDP
non-blocking read() by retrying on EAGAIN. With both of them, the
failure rate of the UDP test case goes down from 10% to 1%.

Patch 3 is memory leak fix I posted, no change since v1. The rest
patches address similar memory leaks or improve error handling,
including one increases sk_drops counter for error cases. Please
check each patch description for more details.

Acked-by: John Fastabend <john.fastabend@gmail.com>

---
Resend this patchset as it is lost after John's review.

v3: add another bug fix as patch 4
    update patch 5 accordingly
    address John's review on the last patch
    fix a few typos in patch descriptions

v2: group all patches together
    set max for retries of EAGAIN

Cong Wang (8):
  skmsg: improve udp_bpf_recvmsg() accuracy
  selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
  udp: fix a memory leak in udp_read_sock()
  skmsg: clear skb redirect pointer before dropping it
  skmsg: fix a memory leak in sk_psock_verdict_apply()
  skmsg: teach sk_psock_verdict_apply() to return errors
  skmsg: pass source psock to sk_psock_skb_redirect()
  skmsg: increase sk->sk_drops when dropping packets

 include/linux/skmsg.h                         |  2 -
 net/core/skmsg.c                              | 82 +++++++++----------
 net/ipv4/tcp_bpf.c                            | 24 +++++-
 net/ipv4/udp.c                                |  2 +
 net/ipv4/udp_bpf.c                            | 47 +++++++++--
 .../selftests/bpf/prog_tests/sockmap_listen.c |  7 +-
 6 files changed, 112 insertions(+), 52 deletions(-)

-- 
2.25.1

