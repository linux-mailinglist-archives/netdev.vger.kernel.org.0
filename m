Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB61C628C67
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 23:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiKNW5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 17:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiKNW5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 17:57:03 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C1819029;
        Mon, 14 Nov 2022 14:57:02 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l14so21123700wrw.2;
        Mon, 14 Nov 2022 14:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qPyG0FSRCyKP6gYMH1LHT/s8pPm9SNYOKN61w9u/6Ew=;
        b=nQmwADRg32ms0Xw8eCNWAJkuFPGhmNlezbsM1/zBghMFcAP3PBjPQJW4N8M6QlTak8
         vtCh4nEVMYmWDei3ePjIyHxczO/mAGJvIIzhRcYxwYzkLK5LZTnonFJUFk4ymFNGWMVq
         ERHy/m6Zn49sZTMxPqDP2jzbhV0UUm0T5zvpKrnwrMLfucwGNUGoi7+zeZkOyvouzU0m
         GIc7lWsFYC0VZ4ZCuzoie7Nx4m7XddaQX0qtQCBN1QfncpaEx3HCB+AgEYVSKlY/r6H/
         PbWGfu9E4XClL3+tyH+KGSeCINg5o0zCtxXs8pZGX1XKOM2uQqBF74ba1Sh4ONGplc7o
         H/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qPyG0FSRCyKP6gYMH1LHT/s8pPm9SNYOKN61w9u/6Ew=;
        b=bIh6x2MkhfK8t10M+UxYKktNgMzSx64eRYowyTI/SMFfCk3JVQsZ74FmpIqqvszmkK
         OCnWXYb1aBsAoSoPOrTc2RRBS5XYnTeaPUdm+EVvawixUFJCWQBvQ63uhrVTKm8B5Amm
         x1I+p2HCzvo95uGpTt88G/xcbQ64TvVmvCNW6GZ5vzJdfQgENoBORaf/JhV00pAiPnxm
         s9JoJh5wDffyYA7f7LZQ4WcMpC/In4v0xEpjlcx4ioGN5OlhAvpUxbjaMKSAlk17XywM
         2dpT5HJ7X9eCG6QUSVxmuGxfV7QwF+0bz55BPBH7BvZa1g9BcivYeRw5dImoan7yYvDw
         ndsw==
X-Gm-Message-State: ANoB5pnAErM+Oif1e0mdNfy6EbfIWP0iyWvPQXbf3XEpJn2IhlIut42y
        Be6PzhZWC4VVBkCGhfxsPiA=
X-Google-Smtp-Source: AA0mqf6zWGEcgvjVqMekHC1S1PsTHAzOdnlHUbTqdNd8IAB9QqYH3iSJ4JP7xNtx2uhYYMXb7B+9vQ==
X-Received: by 2002:adf:dbc6:0:b0:236:5fe3:c459 with SMTP id e6-20020adfdbc6000000b002365fe3c459mr9094586wrj.219.1668466620620;
        Mon, 14 Nov 2022 14:57:00 -0800 (PST)
Received: from gleb-linux.. (cpc76906-dals22-2-0-cust400.20-2.cable.virginm.net. [81.106.81.145])
        by smtp.gmail.com with ESMTPSA id j7-20020a5d4527000000b00236545edc91sm10775485wra.76.2022.11.14.14.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 14:57:00 -0800 (PST)
From:   Gleb Mazovetskiy <glex.spb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Gleb Mazovetskiy <glex.spb@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tcp: configurable source port perturb table size
Date:   Mon, 14 Nov 2022 22:56:16 +0000
Message-Id: <20221114225616.16715-1-glex.spb@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On embedded systems with little memory and no relevant
security concerns, it is beneficial to reduce the size
of the table.

Reducing the size from 2^16 to 2^8 saves 255 KiB
of kernel RAM.

Makes the table size configurable as an expert option.

The size was previously increased from 2^8 to 2^16
in commit 4c2c8f03a5ab ("tcp: increase source port perturb table to
2^16").

Signed-off-by: Gleb Mazovetskiy <glex.spb@gmail.com>
---
 net/ipv4/Kconfig           | 10 ++++++++++
 net/ipv4/inet_hashtables.c | 10 +++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index e983bb0c5012..2dfb12230f08 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -402,6 +402,16 @@ config INET_IPCOMP
 
 	  If unsure, say Y.
 
+config INET_TABLE_PERTURB_ORDER
+	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
+	default 16
+	help
+	  Source port perturbation table size (as power of 2) for
+	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
+
+	  The default is almost always what you want.
+	  Only change this if you know what you are doing.
+
 config INET_XFRM_TUNNEL
 	tristate
 	select INET_TUNNEL
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d3dc28156622..033bf3c2538f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -906,13 +906,13 @@ EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
+ *
  * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
- * attacks were since demonstrated, thus we use 65536 instead to really
- * give more isolation and privacy, at the expense of 256kB of kernel
- * memory.
+ * attacks were since demonstrated, thus we use 65536 by default instead
+ * to really give more isolation and privacy, at the expense of 256kB
+ * of kernel memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 16
-#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
 static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-- 
2.37.2

