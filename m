Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46E1E66CFEF
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjAPUPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjAPUPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:15:08 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E40C23DB9
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:07 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1616875wms.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BXm2iudaboNNECVraopzZFOlk9fpCOWA8bZYDHmu2JE=;
        b=kvavdEJklSQPW4BPlF7gQcXgGCOwyILQRmqgdBU1y8dhBXR4ml6UjaJdhchOBcBJ5u
         E9VNBbVZ2Ayr8lQH19lZqzUiEMqgdb0YH+RTcmyF3QdE0/lhy0guDnv5XXBk9ROz+Xd+
         +/tmjvhWo7gB/RfZszrBvV2eO6CSgI3lnZ63nAgR/e8Bj6jcPTWGbshaUP/SpY7mcC12
         bthfWKs8TvS0Wno07m7urSj0qt+xdgpUdI/jlCk6APBUArtBLyzaaCGvXe1tKWBByxfB
         WZpA79LskAtrh8rmT/UScc8kZPB6HQlbTi8uF6qNy/n+tzaueUwYnt8WSQ7EVC+wEgqt
         X/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BXm2iudaboNNECVraopzZFOlk9fpCOWA8bZYDHmu2JE=;
        b=j+P/KFQKK2HTMzY2ioeuL6us17XTecPNPViXwTZ0xJbh/IrQu5baWE1NInIKDSRDaE
         SZYmYbVLaei9G0ivgyrneyoZoQEZ4Xoc8sxkiSQirH28V5KrLLvZFlxSOnemhMHzDk98
         C2VkStZ1KxX0K8U6A1dEUI4xSLz41/gI8z/8mJXVzPErVN76srZ2dY7i0AmX1oAQtrXh
         5oZR1UPYJ8LHcRqkYwJdlHakbnm4U+h7ZH10RCNO+MZQXhz64kcWE58T3XwKfREYoJKH
         hKfAV4mdDYo5tCKvK8+B+kwI5yeHf1Y4npAmoB2w+8gEstzPufV+gfKrhuQNH5vsbdFT
         VHLQ==
X-Gm-Message-State: AFqh2kr2LOBLNnXthJFKczIY9UEvGlMsuJNywmWe/3FkPGdgfql9k028
        EpxBYwQZWp8hTdQ9BKZ+uI73DQ==
X-Google-Smtp-Source: AMrXdXs11KEVijhi/vnwuIqP0bzhBdA9g37BqRTmAW6ovoxgf5b8jS9ru1OHNtAkjpHG0vlfn4LPkQ==
X-Received: by 2002:a7b:c7c5:0:b0:3da:1135:544 with SMTP id z5-20020a7bc7c5000000b003da11350544mr9277172wmk.40.1673900105894;
        Mon, 16 Jan 2023 12:15:05 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id bh13-20020a05600c3d0d00b003d358beab9dsm34549829wmb.47.2023.01.16.12.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 12:15:05 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/4] net/crypto: Introduce crypto_pool
Date:   Mon, 16 Jan 2023 20:14:54 +0000
Message-Id: <20230116201458.104260-1-dima@arista.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v2 [5]:
- Fix incorrect rebase of v2: tcp_md5_add_crypto_pool() was
  called on twsk creation even for sockets without TCP-MD5 key
- Documentation title underline length
  (Reported-by: kernel test robot <lkp@intel.com>)
- Migrate crypto_pool_scratch to __rcu, using rcu_dereference*()
  and rcu_replace_pointer(). As well, I changed local_bh_{en,dis}able()
  to rcu_read_{,un}lock_bh().
  (Addressing Jakub's review)
- Correct Documentation/ to use proper kerneldoc style, include it in
  toc/tree and editor notes (from Jakub's comments)
- Avoid cast in crypto_pool_get() (Jakub's review)
- Select CRYPTO in Kconfig, not only CRYPTO_POOL (Jakub's reivew)
- Remove free_batch[] with synchronize_rcu() in favor of a struct
  with a flexible array inside + call_rcu() (suggested by Jakub)
- Change scratch `size` argument type from (unsigned long) to (size_t)
  for consistency
- Combined crypto_pool_alloc_ahash() and crypto_pool_reserve_scratch(),
  now the scratch area size is supplied on crypto_pool allocation
  (suggested by Jakub)
- Removed CONFIG_CRYPTO_POOL_DEFAULT_SCRATCH_SIZE
- CRYPTO_POOL now is a hidden symbol (Jakub's review)
- Simplified __cpool_alloc_ahash() error-paths, adding local variables
  (suggested by Jakub)
- Resurrect a pool waiting to be destroyed if possible (Jakub's review)
- Rename _get() => _start(), _put() => _end(), _add() => _get()
  (suggested by Jakub)

Changes since v1 [1]:
- Patches went through 3 iterations inside bigger TCP-AO patch set [2],
  now I'm splitting it apart and sending it once again as a stand-alone
  patch set to help reviewing it and make it easier to merge.
  It is second part of that big series, once it merges the next part
  will be TCP changes to add Authentication Option support (RFC5925),
  that use API provided by these patches.
- Corrected kerneldoc-style comment near crypto_pool_reserve_scratch()
  (Reported-By: kernel test robot <lkp@intel.com>)
- Added short Documentation/ page for crypto_pool API

Add crypto_pool - an API for allocating per-CPU array of crypto requests
on slow-path (in sleep'able contexts) and for using them on a fast-path,
which is RX/TX for net/* users.

The design is based on the current implementations of md5sig_pool, which
this patch set makes generic by separating it from TCP core, moving it
to crypto/ and adding support for other hashing algorithms than MD5.
It makes a generic implementation for a common net/ pattern.

The initial motivation to have this API is TCP-AO, that's going to use
the very same pattern as TCP-MD5, but for multiple hashing algorithms.
Previously, I've suggested to add such API on TCP-AO patch submission [3],
where Herbert kindly suggested to help with introducing new crypto API.
See also discussion and motivation in crypto_pool-v1 [4].

The API will allow:
- to reuse per-CPU ahash_request(s) for different users
- to allocate only one per-CPU scratch buffer rather than a new one for
  each user
- to have a common API for net/ users that need ahash on RX/TX fast path

In this version I've wired up TCP-MD5 and IPv6-SR-HMAC as users.
Potentially, xfrm_ipcomp and xfrm_ah can be converted as well.
The initial reason for patches would be to have TCP-AO as a user, which
would let it share per-CPU crypto_request for any supported hashing
algorithm.

[1]: https://lore.kernel.org/all/20220726201600.1715505-1-dima@arista.com/ 
[2]: https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u
[3]: http://lkml.kernel.org/r/20211106034334.GA18577@gondor.apana.org.au
[4]: https://lore.kernel.org/all/26d5955b-3807-a015-d259-ccc262f665c2@arista.com/T/#u
[5]: https://lore.kernel.org/all/20230103184257.118069-1-dima@arista.com/

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Bob Gilligan <gilligan@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Salam Noureddine <noureddine@arista.com>
Cc: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Dmitry Safonov (4):
  crypto: Introduce crypto_pool
  crypto/net/tcp: Use crypto_pool for TCP-MD5
  crypto/net/ipv6: sr: Switch to using crypto_pool
  crypto/Documentation: Add crypto_pool kernel API

 Documentation/crypto/crypto_pool.rst |  36 +++
 Documentation/crypto/index.rst       |   1 +
 crypto/Kconfig                       |   3 +
 crypto/Makefile                      |   1 +
 crypto/crypto_pool.c                 | 334 +++++++++++++++++++++++++++
 include/crypto/pool.h                |  46 ++++
 include/net/seg6_hmac.h              |   7 -
 include/net/tcp.h                    |  24 +-
 net/ipv4/Kconfig                     |   1 +
 net/ipv4/tcp.c                       | 104 ++-------
 net/ipv4/tcp_ipv4.c                  | 100 ++++----
 net/ipv4/tcp_minisocks.c             |  21 +-
 net/ipv6/Kconfig                     |   1 +
 net/ipv6/seg6.c                      |   3 -
 net/ipv6/seg6_hmac.c                 | 207 +++++++----------
 net/ipv6/tcp_ipv6.c                  |  61 +++--
 16 files changed, 635 insertions(+), 315 deletions(-)
 create mode 100644 Documentation/crypto/crypto_pool.rst
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h


base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0

