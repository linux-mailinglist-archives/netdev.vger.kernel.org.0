Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1552E2CC960
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgLBWKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:10:48 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109EC0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:10:02 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so110899pga.9
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VG0vaQwrFYnD/GCo8JKxLSj9sQTE6KV05CLqDuVFyik=;
        b=QazQlcAt9gjTNRjlnvAfXpKw12cIWdIyX91nOUvPzSNdgsakIiBlLGRFsnj08QOi9U
         9TnBifbmtmOnzF1Nhxwoo/Y6oiX1VRlT1VeWG15vYCTdi5sB2+/S1xnuzTmrJamTyu+P
         BHp2iOlk3x/T31bqxtQMCK84nja8w0mY6mrunfzBvGNPehis0s8nzwiqEQ+qnql3cf99
         V4QeTslXvncdEB2mI5loI79LoL2qmAfRHagdLg2iIp58noMgm1pY0LKnsX4zPw1DASA4
         RP5uHtztfSjO2ieRk0qCSxGX0ze9jEVS3MTAAmRcWn6G9LwfjJU8BoHOfQe5WJwnDBkO
         edxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VG0vaQwrFYnD/GCo8JKxLSj9sQTE6KV05CLqDuVFyik=;
        b=pA3luy4oH5cQCZPXWLsGpV58tzZrP2uxk1lWN2A5pBO03pH9h0Gt0VLmwkeTMRQATy
         N7TARNUqBOuC5rM1+d4a2DxfTA3zr43XL6LxKcylzLVH6+JDEXJGVt+OkC9FbdpQ7DK7
         0IOyCnm3idiTgOyh3z/GN6DHBLLsDSpcnYqruYXlEj5pphSWcDmmgJbgomfo207JeVJl
         KG8B0pUbvOWhy1rtdOsYe+xwJyF2HklMCbRrQCiV5CCNBJ0VbnRrlpHPG1j6S9P3B3Fg
         ++Qt7Cb0gX/h6vaFy0ec54/K975PL2cJSgtAxfR6Xkvy8ppNZT8zo4+exiwTHpeRdATA
         w8MA==
X-Gm-Message-State: AOAM531tEIkh/1Xubmq+noCfTk726BVU7aNgz7UiM8xuYsorpGZqXiOx
        GhaYp/H16WXpMQ28loP5xps=
X-Google-Smtp-Source: ABdhPJzvl6z3+l5LkZwNWmFcPu71m1DHDPO7/z5NXUF2YWXqmaDeWKv+r2WgxvzFKEBu38BQl26kMA==
X-Received: by 2002:a05:6a00:148d:b029:19d:9622:bf7 with SMTP id v13-20020a056a00148db029019d96220bf7mr72858pfu.11.1606947001566;
        Wed, 02 Dec 2020 14:10:01 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id p16sm4872pju.47.2020.12.02.14.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:10:00 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v2 0/8] Perf. optimizations for TCP Recv. Zerocopy
Date:   Wed,  2 Dec 2020 14:09:37 -0800
Message-Id: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

This patchset contains several optimizations for TCP Recv. Zerocopy.

Note this is v2 of the patchset, fixing two 32-bit compilation errors
and a stylistic error.

Summarized:
1. It is possible that a read payload is not exactly page aligned -
that there may exist "straggler" bytes that we cannot map into the
caller's address space cleanly. For this, we allow the caller to
provide as argument a "hybrid copy buffer", turning
getsockopt(TCP_ZEROCOPY_RECEIVE) into a "hybrid" operation that allows
the caller to avoid a subsequent recvmsg() call to read the
stragglers.

2. Similarly, for "small" read payloads that are either below the size
of a page, or small enough that remapping pages is not a performance
win - we allow the user to short-circuit the remapping operations
entirely and simply copy into the buffer provided.

Some of the patches in the middle of this set are refactors to support
this "short-circuiting" optimization.

3. We allow the user to provide a hint that performing a page zap
operation (and the accompanying TLB shootdown) may not be necessary,
for the provided region that the kernel will attempt to map pages
into. This allows us to avoid this expensive operation while holding
the socket lock, which provides a significant performance advantage.

With all of these changes combined, "medium" sized receive traffic
(multiple tens to few hundreds of KB) see significant efficiency gains
when using TCP receive zerocopy instead of regular recvmsg(). For
example, with RPC-style traffic with 32KB messages, there is a roughly
15% efficiency improvement when using zerocopy. Without these changes,
there is a roughly 60-70% efficiency reduction with such messages when
employing zerocopy.

Arjun Roy (8):
  net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
  net-tcp: Introduce tcp_recvmsg_locked().
  net-zerocopy: Refactor skb frag fast-forward op.
  net-zerocopy: Refactor frag-is-remappable test.
  net-zerocopy: Fast return if inq < PAGE_SIZE
  net-zerocopy: Introduce short-circuit small reads.
  net-zerocopy: Set zerocopy hint when data is copied
  net-zerocopy: Defer vm zap unless actually needed.

 include/uapi/linux/tcp.h |   4 +
 net/ipv4/tcp.c           | 446 +++++++++++++++++++++++++++++----------
 2 files changed, 343 insertions(+), 107 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

