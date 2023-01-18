Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3521672AAF
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjARVlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjARVlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:41:22 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818DDBBB9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:20 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bk16so35315136wrb.11
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8B1gvUeo570UTBfHDYlb1KlevQwv4wbaPwDQDlDx8dY=;
        b=g8Lag3ojyoFeBI0q8Mv3nS97JMmd2Tv3gcfIoYkWcbZKkjcYGMHM0P0EBnF1qTuX8g
         dL3nrjPjDzsCutcXFyqoYC/JIWGITou37Nlw2mXrUfINkflEuwWWVXWLKiku98WF8dZv
         XxnobcCtMd2NwQdWCeRnMBDQSL+ISz9p43TPRo5bT9qdxw3e7DETL4cC2x5MQts9VzYj
         lvhSgfq3fixcJEMMR7v7AsuBbwNpPmlv9GCXeIJwRDfvgeD5vbe4MvgwYa+dCqnVQ87N
         oUjK5dzyjtDg4EdTjvItymF1Yyqz9tFdGSXFBF7GNA7QdmYhzFnOJ8sMO/bo/1hJY3vp
         HqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8B1gvUeo570UTBfHDYlb1KlevQwv4wbaPwDQDlDx8dY=;
        b=O8gnu1t5JVd1gTv/jZbOfDWRFPI3DNwHW6Zb9K8zgS6ASKzr/lzfu2sQZDOAxvoXPW
         FAp6xS8UCWUXMtMLeR8D5uArgdrBdFrspdFrQ1aymPgP6DWMSxJ/Qzxgv7gNwbLbMbfe
         /HCJdItCNp7Y15eE/DyPGsVaL7D++wS6EnHKD3uzMiRqTPvysHgmPJTT8fGXgQH71pN3
         jlwu1rRfdDSceUnJxLQE6vljgCrlXBn2B1asZQN1oJLNnw2qLinVQII3fTjynLD8rk2K
         R9Ozh/+Bmv7f+2rIAiJPxYukny1WIaZxk3HcRD+I/foL21nBZmxIYCRJD9h4Pxiy+h3o
         azpg==
X-Gm-Message-State: AFqh2kqSaPl+5PAn/S1IGr4ESMueUD3yICdHExAyCopwgpwstAS3HEuh
        Ee4hcF9rxP87Zku52kbkL17yBA==
X-Google-Smtp-Source: AMrXdXuID8GDuJxz7/WCUTX0y6/oOD+MsLYybK8NOdE2wjHB9as0ABDj70nvrlHkBgAFjzxvNtpW0Q==
X-Received: by 2002:adf:e88f:0:b0:2bd:f388:841c with SMTP id d15-20020adfe88f000000b002bdf388841cmr7637022wrm.42.1674078078945;
        Wed, 18 Jan 2023 13:41:18 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm33186349wrz.56.2023.01.18.13.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:41:18 -0800 (PST)
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
Subject: [PATCH v4 0/4] net/crypto: Introduce crypto_pool
Date:   Wed, 18 Jan 2023 21:41:07 +0000
Message-Id: <20230118214111.394416-1-dima@arista.com>
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

Changes since v3 [6]:
- Cleanup seg6_hmac_init() and seg6_hmac_exit() declaration/usage
  left-overs (reported by Jakub)
- Remove max(size, __scratch_size) from crypto_pool_reserve_scratch()

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
[6]: https://lore.kernel.org/all/20230116201458.104260-1-dima@arista.com/T/#u

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
 crypto/crypto_pool.c                 | 333 +++++++++++++++++++++++++++
 include/crypto/pool.h                |  46 ++++
 include/net/seg6_hmac.h              |   9 -
 include/net/tcp.h                    |  24 +-
 net/ipv4/Kconfig                     |   1 +
 net/ipv4/tcp.c                       | 104 ++-------
 net/ipv4/tcp_ipv4.c                  | 100 ++++----
 net/ipv4/tcp_minisocks.c             |  21 +-
 net/ipv6/Kconfig                     |   1 +
 net/ipv6/seg6.c                      |  14 +-
 net/ipv6/seg6_hmac.c                 | 207 +++++++----------
 net/ipv6/tcp_ipv6.c                  |  61 +++--
 16 files changed, 636 insertions(+), 326 deletions(-)
 create mode 100644 Documentation/crypto/crypto_pool.rst
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h


base-commit: c1649ec55708ae42091a2f1bca1ab49ecd722d55
-- 
2.39.0

