Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBA365C6A8
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjACSqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjACSpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:45:00 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EEA14084
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 10:43:12 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g10so9745801wmo.1
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 10:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCJ7npxHWqpq76xLkWO4j8PK4QmIgUKzcUbzkkrjhHk=;
        b=CZ5qHYLwlLPQI0PG3wJmLeJmMjKX0fENp37n8nEwoXnjIKGMPeZs6j6FtyOBT6Yp5J
         7KgQcqLS3n/tSclWR5Iew/zedibQuNm8CFGB1BLQ/G35Vkng58i/RBKR6P04gmY9bDBU
         OAbSlnzVH2PjtmHk9m5csZGnCiVfOu9zyD68rt6hrYFzWAaBG1CKSLsxPlvVFk83Exft
         G9mrsd04Tnt7S3nYb5O1wCqG68BANgvT1EoiN1b/BXRpP5KIB1jmA5SQWCGKTy5rAvbJ
         HU0a6kiFN1iXZGm2yo/+yeunkHFQxgsBMKPs5l+9vqAzTGamfTJ72LYB/QUwHuMii40r
         LfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCJ7npxHWqpq76xLkWO4j8PK4QmIgUKzcUbzkkrjhHk=;
        b=ozghd50FMAD05NJH+0ZaXagrNtbP3sSWTAbiCWP88O99qps5v0GAZkXe7b4P0crXad
         vwmnXjoPC1WVZ0n01BMF55QKjRpJUE8Wo1mF4aTUiVvYisnD8pJbTy46nDNpTiRaj+FX
         bPfnaX1K56/hXGkg9rWrqfYdh9TQMWIWydh751uOV609Xpv2ZqbBhci8YtS7F8b+njWe
         +VIWD7QAAe9x45GLJBBInuZzKR4xbmWvzuNKX95Yj3SVm+bd2xaCq3C6vp6AtNi3QbiZ
         vMGhsyskxHbru/dOQPKwkMKYSGB9oXIVAJdsZd/QvSEz4P3XxovXfmMZbj7DABT2/Y+l
         pH7w==
X-Gm-Message-State: AFqh2kpOtDvuDKQwR+vAaHph1CuMtR4phi+Lt4o3xemXru7wioDapwo1
        1jxvZZOBdLVLLniveh4fAUkaAg==
X-Google-Smtp-Source: AMrXdXtbXCx4js4WZ3kq1vAN/GqYO0G3aTLNuJAMOuTxxZEl1HjjPQFV849khE0HGIATJQTU13cCKw==
X-Received: by 2002:a05:600c:4d21:b0:3d2:2a72:2573 with SMTP id u33-20020a05600c4d2100b003d22a722573mr32110883wmp.11.1672771390924;
        Tue, 03 Jan 2023 10:43:10 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:10 -0800 (PST)
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
Subject: [PATCH v2 5/5] crypto/Documentation: Add crypto_pool kernel API
Date:   Tue,  3 Jan 2023 18:42:57 +0000
Message-Id: <20230103184257.118069-6-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103184257.118069-1-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 Documentation/crypto/crypto_pool.rst | 33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/crypto/crypto_pool.rst

diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
new file mode 100644
index 000000000000..4b8443171421
--- /dev/null
+++ b/Documentation/crypto/crypto_pool.rst
@@ -0,0 +1,33 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Per-CPU pool of crypto requests
+=============
+
+Overview
+--------
+The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
+providing ability to use async crypto requests on fast paths, potentially
+on atomic contexts. The allocation and initialization of the requests should
+be done before their usage as it's slow-path and may sleep.
+
+Order of operations
+-------------------
+You are required to allocate a new pool prior using it and manage its lifetime.
+You can allocate a per-CPU pool of ahash requests by ``crypto_pool_alloc_ahash()``.
+It will give you a pool id that you can use further on fast-path for hashing.
+You can increase the reference counter for an allocated pool via
+``crypto_pool_add()``. Decrease the reference counter by ``crypto_pool_release()``.
+When the refcounter hits zero, the pool is scheduled for destruction and you
+can't use the corresponding crypto pool id anymore.
+Note that ``crypto_pool_add()`` and ``crypto_pool_release()`` must be called
+only for an already existing pool and can be called in atomic contexts.
+
+``crypto_pool_get()`` disables bh and returns you back ``struct crypto_pool *``,
+which is a generic type for different crypto requests and has ``scratch`` area
+that can be used as a temporary buffer for your operation.
+
+``crypto_pool_put()`` enables bh back once you've done with your crypto
+operation.
+
+If you need to pre-allocate a bigger per-CPU ``scratch`` area for you requests,
+you can use ``crypto_pool_reserve_scratch()``.
-- 
2.39.0

