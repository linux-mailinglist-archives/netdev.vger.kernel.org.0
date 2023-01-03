Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B83065C697
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbjACSo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbjACSoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:44:37 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6881401C
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 10:43:05 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bk16so17342402wrb.11
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 10:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ORcDlteljIofXFtgj0WqFlIjM+SxLCEMXAOiyOwdfWw=;
        b=eRrKrzeH9JPmrdylEKetUwIDwtKQki35PdTSyQndAquat1galIBd6+8U+I1Q11mBPr
         0l0YhzmfCzGTINPosuCM4Bwi7Z6qo/5D13ESpCQHGCZ66CY44UWTvlpX/SRg6at33CT/
         7gkmq+860ZIfztZbbqykNIgsuzT2BUhj9CjpjjBNBqZBqSDvdfgWCom8uNfkYVUyjyg7
         UMSdxzBmSw5G0zRjjkJq+qUkGCNZjZwd4aWz3wnXEyNjJZHc2BCEFvhZ9SbCTUg+GtOE
         J5jd6g06TyTbA9GrzDVn8A1dXvludmeCxno0bt/S0c6YWncf2sUDr9jrJoxNPQfSpZme
         M61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ORcDlteljIofXFtgj0WqFlIjM+SxLCEMXAOiyOwdfWw=;
        b=5qdxuFWzJMsW7tmIXALhjTF4rRPyJhVkUt+tFDyjCP40c9FIRTzcl/J+B7coDhTypj
         YzI7ce1J/qMRJ/hvxs0tLexhBKPzfyK3EvMG+pEw+WASRfBAPrZ5gUp0nxmRX93uBR6k
         yM4Akd3f9RAEjkmzyDz6+gOi217HZ5dgtee19T9l4lU4g49HIVFOD0VV5aJtZXeNvvrq
         a7AMwrKN+DfjWPkhErKlxzAI7q1V+7gkG42UcPzocI6K5xs6n2UV66XoSJC+Z1H4Rudz
         0Lo5kSvbaPimlMz620aeVn0hvsqQexnjfOSOL+j5lACe0yFGk4T90vFjnrwtwSd1fwKw
         MLUA==
X-Gm-Message-State: AFqh2kq3zXJOu4z+LGdE2IdhDcokZSohomoqYYGc9hwhYbyU2OAbPZKQ
        r6wJ62fjav9pCuf0FPL31IaCDw==
X-Google-Smtp-Source: AMrXdXtl1Mxf0G5kKYCzSmvXwrHTspZj4lhYWCvqOK8+XThWANrA1FYjSc5qcpb+O56zDEuNhAxhCA==
X-Received: by 2002:a5d:61c7:0:b0:269:7b65:f20a with SMTP id q7-20020a5d61c7000000b002697b65f20amr28525156wrv.71.1672771384442;
        Tue, 03 Jan 2023 10:43:04 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:03 -0800 (PST)
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
Subject: [PATCH v2 0/5] net/crypto: Introduce crypto_pool
Date:   Tue,  3 Jan 2023 18:42:52 +0000
Message-Id: <20230103184257.118069-1-dima@arista.com>
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

Dmitry Safonov (5):
  crypto: Introduce crypto_pool
  crypto/pool: Add crypto_pool_reserve_scratch()
  crypto/net/tcp: Use crypto_pool for TCP-MD5
  crypto/net/ipv6: sr: Switch to using crypto_pool
  crypto/Documentation: Add crypto_pool kernel API

 Documentation/crypto/crypto_pool.rst |  33 +++
 crypto/Kconfig                       |  12 +
 crypto/Makefile                      |   1 +
 crypto/crypto_pool.c                 | 338 +++++++++++++++++++++++++++
 include/crypto/pool.h                |  33 +++
 include/net/seg6_hmac.h              |   7 -
 include/net/tcp.h                    |  24 +-
 net/ipv4/Kconfig                     |   2 +-
 net/ipv4/tcp.c                       | 105 +++------
 net/ipv4/tcp_ipv4.c                  |  92 +++++---
 net/ipv4/tcp_minisocks.c             |  21 +-
 net/ipv6/Kconfig                     |   2 +-
 net/ipv6/seg6.c                      |   3 -
 net/ipv6/seg6_hmac.c                 | 204 +++++++---------
 net/ipv6/tcp_ipv6.c                  |  53 ++---
 15 files changed, 626 insertions(+), 304 deletions(-)
 create mode 100644 Documentation/crypto/crypto_pool.rst
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h


base-commit: 69b41ac87e4a664de78a395ff97166f0b2943210
-- 
2.39.0

