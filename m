Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574F94406DD
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhJ3CIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 22:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhJ3CId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 22:08:33 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396C6C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:04 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id u25so7581597qve.2
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O93JhHz7dL8HV068W5SFXezG8oDF5b3ADAXpF6LNIhw=;
        b=aPwTIytJ88A7o+C4yDusZHMA7RRIXBEW3R4D0U3NKvYnGqx2T7IGwyxeN7Ryc/5Wga
         NOoVcVBqv4t3PkAopJO0X9ncXl+i0Z86ZsEpbUROdKqYPPPUhKVLeYUUnr+nnCgNYJCB
         aFXCuBgAf9cHLAOydoksjIxxM5hsLyKMmOlMDmO8SqdtrljhHGwmlImFFSSEAa9+OeRa
         Q2oTTFW1mwHAnsfnIoxoSDBjYA1PYWO+Gb4K9Jwfj9BTCin7eQ0bl+jLsC6gNDZKCfwP
         pEllTnUtMgp1p0FfXgjEaTscWAXSWJcc2V98iybh2V42eA6ZkiUA+uViEdmDpcrw2SJw
         XW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O93JhHz7dL8HV068W5SFXezG8oDF5b3ADAXpF6LNIhw=;
        b=IScO1yQOlShKrTKtmV15GKpuUnzFqq0BFUTLOzZUb5zJL9LFeefSMQ6QGJtny+x2ni
         /lRteDlPpxrZpAoLI8l/fR7+KiHcNYNtAYx8bEZXbum6XMK65oe2L+0i1a+l5mae2gMi
         7ZEpq5bTzZwRU44/A9cbrcwTwdjUA2YF835bcQuZm3iuhJvmfDH1R+4BqIanXD65jgOV
         FOQrAYNx254YAVztGbKEUb6pZw2Ttsu6x3eHZI19HgmqWUePFprNIYsv9nqcvFmJn55j
         nIbX5EQYSwAM99SprPXXwuWeFO+GYzg8qDzTyt509kd7KxD/j0Qm8QKONXUaSxDCOIFg
         h+aw==
X-Gm-Message-State: AOAM531bBgJStA3QHw881yvRsthfZz1kv9iUasmwIqSeUlDubhw3qy9M
        DZkvp++1e9gbd2uDGNuLuGE=
X-Google-Smtp-Source: ABdhPJw0FTsjlcIFOtYXZXcF7GiQMzsnugb8/kb5ATScNkq5t90/1N9TwTITAFuZteoZYrhyF0pH1Q==
X-Received: by 2002:a05:6214:528b:: with SMTP id kj11mr14893463qvb.1.1635559563357;
        Fri, 29 Oct 2021 19:06:03 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:317:25ce:101f:81db:24e8])
        by smtp.gmail.com with ESMTPSA id az12sm5044391qkb.28.2021.10.29.19.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 19:06:02 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        willemb@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, cong.wang@bytedance.com, haokexin@gmail.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, pabeni@redhat.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, elver@google.com,
        nogikh@google.com, vvs@virtuozzo.com,
        Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net-next v2 0/2] Accurate Memory Charging For MSG_ZEROCOPY
Date:   Fri, 29 Oct 2021 22:05:40 -0400
Message-Id: <20211030020542.3870542-1-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

This series improves the accuracy of msg_zerocopy memory accounting.
At present, when msg_zerocopy is used memory is charged twice for the
data - once when user space allocates it, and then again within
__zerocopy_sg_from_iter. The memory charging in the kernel is excessive
because data is held in user pages and is never actually copied to skb
fragments. This leads to incorrectly inflated memory statistics for
programs passing MSG_ZEROCOPY.

We reduce this inaccuracy by introducing the notion of "pure" zerocopy
SKBs - where all the frags in the SKB are backed by pinned userspace
pages, and none are backed by copied pages. For such SKBs, tracked via
the new SKBFL_PURE_ZEROCOPY flag, we elide sk_mem_charge/uncharge
calls, leading to more accurate accounting.

However, SKBs can also be coalesced by the stack at present,
potentially leading to "impure" SKBs. We restrict this coalescing so
it can only happen within the sendmsg() system call itself, for the
most recently allocated SKB. While this can lead to a small degree of
double-charging of memory, this case does not arise often in practice
for workloads that set MSG_ZEROCOPY.

Testing verified that memory usage in the kernel is lowered.
Instrumentation with counters also showed that accounting at time
charging and uncharging is balanced.

Talal Ahmad (2):
  tcp: rename sk_wmem_free_skb
  net: avoid double accounting for pure zerocopy skbs

 include/linux/skbuff.h | 19 ++++++++++++++++++-
 include/net/sock.h     |  7 -------
 include/net/tcp.h      | 15 +++++++++++++--
 net/core/datagram.c    |  3 ++-
 net/core/skbuff.c      |  3 ++-
 net/ipv4/tcp.c         | 28 +++++++++++++++++++++++-----
 net/ipv4/tcp_output.c  |  9 ++++++---
 7 files changed, 64 insertions(+), 20 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

