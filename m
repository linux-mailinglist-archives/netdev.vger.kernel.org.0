Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABAD672AB6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjARVlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjARVlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:41:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A33B65C
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id b7so15548wrt.3
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMLRObJikupEwzTrRnh2PGmgjZ9Cqtc3WwiwTSH8KzM=;
        b=eCtXeYsP+ADhvJqyR5obWxJN2h47MVmxSPM3WN/yFWVLL7Bofz6ALMqkQ5FmPFSW8x
         UWaka0KuTIy7rIQGm6zFjHry+P1eL6Sk8lHn9fP+GlFKwmKfj/Q6EGvopu1kINYq/tef
         zm8zNYOALlS2vhNm+EkXcXVPzdDc/TXwTPpHmjgDI6AlVHBF2UVGGn5IwZJjA1mkQrTd
         W7/8pHqfbBiiPSMO3n8KjIvPtsQCwLJhGfGrg9lAgqPV+bv5lqOuwfh93c0xePh+Wkpp
         2YLAsoMIKNpdfYZLV7cFr9MhZ4e3JlmJFQlcJhphihQuV+4yzmbAlgwjxUanzoyThCaw
         x8Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMLRObJikupEwzTrRnh2PGmgjZ9Cqtc3WwiwTSH8KzM=;
        b=BGC1/a2grmVAXRZynlf8+1qIyrozYa6DT0CSGNWHbDQsSSWmHB9YszTk43RfW4c+3a
         66VXyTEqB9Gq6RlOHoq3ZfzhIKObMeysObXMnA1pNMIDLsEoMJbbieHBtpls4i1qx11T
         P7clO87O0GufzMB4qB3fkmQYORSkRxFQnmEFyTP66VkhG5SfNTzd4AiMVmaIejx6gB5Y
         p+XUEgM+iROiin34DyJFdBTGpzfPwumWym6fGHgfXZtKx2x38fJEu6Bc0GCnaSUwju53
         XpXoXUaK099SXuFahxNQ6vjdBHOQa0U1f59LQaJ6DPxCrxJYasktPYaD6lYJHgPkwRha
         7XcQ==
X-Gm-Message-State: AFqh2kqLJ+Yt4aV3k0maNyCiugfL5TQkhP8Jae/P2ThRQ5ablne5wjNR
        1tznnyRdYsgO4Ryty3Ayq1mqVQ==
X-Google-Smtp-Source: AMrXdXs9dt7f2UXQjFy9Tfqdc9IqVLQbqXGCkdLvQFCWCdoKDt4UIeux1A+ib39qTp53lS2eyE54aQ==
X-Received: by 2002:a5d:5b0e:0:b0:250:22e4:b89e with SMTP id bx14-20020a5d5b0e000000b0025022e4b89emr8426197wrb.65.1674078084270;
        Wed, 18 Jan 2023 13:41:24 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm33186349wrz.56.2023.01.18.13.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:41:23 -0800 (PST)
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
Subject: [PATCH v4 4/4] crypto/Documentation: Add crypto_pool kernel API
Date:   Wed, 18 Jan 2023 21:41:11 +0000
Message-Id: <20230118214111.394416-5-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118214111.394416-1-dima@arista.com>
References: <20230118214111.394416-1-dima@arista.com>
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
 Documentation/crypto/crypto_pool.rst | 36 ++++++++++++++++++++++++++++
 Documentation/crypto/index.rst       |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/crypto/crypto_pool.rst

diff --git a/Documentation/crypto/crypto_pool.rst b/Documentation/crypto/crypto_pool.rst
new file mode 100644
index 000000000000..84abd1f2ee80
--- /dev/null
+++ b/Documentation/crypto/crypto_pool.rst
@@ -0,0 +1,36 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Per-CPU pool of crypto requests
+===============================
+
+Overview
+--------
+The crypto pool API manages pre-allocated per-CPU pool of crypto requests,
+providing ability to use crypto requests on fast paths, potentially in atomic
+contexts. The allocation and initialization of the requests should be done
+before their usage as it's slow-path and may sleep.
+
+Order of operations
+-------------------
+You are required to allocate a new pool prior using it and manage its lifetime.
+You can allocate a per-CPU pool of ahash requests by crypto_pool_alloc_ahash().
+It will give you a pool id that you can use further on fast-path for hashing.
+You can increase the reference counter for an allocated pool via
+crypto_pool_get(). Decrease the reference counter by crypto_pool_release().
+When the refcounter hits zero, the pool is scheduled for destruction and you
+can't use the corresponding crypto pool id anymore.
+Note that crypto_pool_get() and crypto_pool_release() must be called
+only for an already existing pool and can be called in atomic contexts.
+
+crypto_pool_start() disables bh and returns you back ``struct crypto_pool *``,
+which is a generic type for different crypto requests and has ``scratch`` area
+that can be used as a temporary buffer for your operation.
+
+crypto_pool_end() enables bh back once you've done with your crypto
+operation.
+
+.. kernel-doc:: include/crypto/pool.h
+   :identifiers:
+
+.. kernel-doc:: crypto/crypto_pool.c
+   :identifiers:
diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
index 21338fa92642..3eaf4e964e5b 100644
--- a/Documentation/crypto/index.rst
+++ b/Documentation/crypto/index.rst
@@ -25,6 +25,7 @@ for cryptographic use cases, as well as programming examples.
    devel-algos
    userspace-if
    crypto_engine
+   crypto_pool
    api
    api-samples
    descore-readme
-- 
2.39.0

