Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE2A2B0D58
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgKLTCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgKLTCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:02:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3616C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:33 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so5390960pfb.10
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPU/fUtO8a4XJUU4eFi78qfSaqkXCFsgFQy+xns/YT8=;
        b=V12cBg6PSnc3Q/n1KM/F4mcTyoYKT8vN9VtdVZ04jKgUXZxdyRkJ7wsLSu+sBKYtJH
         0vwpZKeW51p9BYktbX8Oa36SlLbdp/V8mZs0dQuVrJ/MY6OZaT9+gbPih/AnmHCuXb6u
         1wfySfew1yc4HPtA2Lqz2hAdbtJvyi+Bu1H60P0HuLn+1x7B6CxvAiPOAUieE5djkW1b
         j+1DErC/3DkYmADQjWKLMPdqKQQ3I3ll7PqkQvjtLJQnKakuq2wzpWwvsi4p/IHy6v7Q
         of18l5TGFRpx25CsmkNZYH3txHwEk0t/p37mVjnTpUXhUs8SLsk3ZDWbs4zqfvLz5JFb
         ym9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QPU/fUtO8a4XJUU4eFi78qfSaqkXCFsgFQy+xns/YT8=;
        b=c0pnBBCzo6oJsDIIPI5TODWabIt675/vFR+iI+p0D4MuCChT9vQ3vIZNSBY4aufpnl
         vH0rnQm5Qq3mDGjn5b175u0fmJXLc2vPEGEfSsjZ54PavG+6i+o5CmJEc9ETskQMdEVy
         TjeJyg/VZupWVdLWsgR7LiCeM4jCp3zEHg1mCP8fl5NKCQ7k5LMn+3AXUg+IdlBziAu2
         /TIY3WiQX1QCb+kQVoUeV+4j1O7+w7B17wp0GbMRuJVnvHUeS7hEJ6GecfAtF1ZNznh3
         ko2hrMX8+bjFmambDWf+vjYu1G8GEt7VaplxLj+X0WlBAnA5T1ymdLaRSESyGRPn23Nd
         n33w==
X-Gm-Message-State: AOAM532DSHg/0L4F6GnoT7ixBkfXuqhLEakRVg17ONgTsmXYcS8eMxuV
        uqnp4qHoEwrlim9G9R0cvqLCZ0Ynwzw=
X-Google-Smtp-Source: ABdhPJyocO4LKKjQJYsH7z1qNnG8I+PqE4DIek3+PT1zSy0V6vU1DdG/hc8v6F9/mT2Qi3daU8Iz9A==
X-Received: by 2002:aa7:8c55:0:b029:18c:45ed:d87e with SMTP id e21-20020aa78c550000b029018c45edd87emr832180pfd.76.1605207753435;
        Thu, 12 Nov 2020 11:02:33 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id z7sm7458809pfq.214.2020.11.12.11.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:02:32 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 0/8] Perf. optimizations for TCP Recv. Zerocopy
Date:   Thu, 12 Nov 2020 11:01:57 -0800
Message-Id: <20201112190205.633640-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

This patchset contains several optimizations for TCP Recv. Zerocopy.

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
  tcp: Copy straggler unaligned data for TCP Rx. zerocopy.
  tcp: Introduce tcp_recvmsg_locked().
  tcp: Refactor skb frag fast-forward op for recv zerocopy.
  tcp: Refactor frag-is-remappable test for recv zerocopy.
  tcp: Fast return if inq < PAGE_SIZE for recv zerocopy.
  tcp: Introduce short-circuit small reads for recv zerocopy.
  tcp: Set zerocopy hint when data is copied.
  tcp: Defer vm zap unless actually needed for recv zerocopy.

 include/uapi/linux/tcp.h |   4 +
 net/ipv4/tcp.c           | 437 +++++++++++++++++++++++++++++----------
 2 files changed, 334 insertions(+), 107 deletions(-)

-- 
2.29.2.222.g5d2a92d10f8-goog

