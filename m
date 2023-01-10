Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A56466459D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjAJQIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjAJQIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:08:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2D34F13A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:08:01 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673366866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pmtpr6zGZ8hx41ENd+2CnDBw8zYk3Ya7H/aRfMcemUg=;
        b=pdWvhxh6kxWZGilLyU/MIca9Q2WA1km6jd8mRkGZE+Pqg2o6UzJ/+v95srC2eaLuD8KVXo
        VtdNABjtLadrJ0rJxp7CJTYuuIWGgLKTcm+6HgbkR+m3M4nvpPQuDPSJKz9RjEVvp+PV5y
        QPuvzdek44ZkmlOuREG33InYIMaP9G5fCp/xO1k4o4y+o8OuISoxmrI0OiQqRWIodT8R8S
        /qrANNLYxZy9Py1MWKYg67kGZZ+UJ3GgdfsFiZIrQjkl8qzyY4OQCipV1FNwDqH+P4aIBa
        Q82TRMIMUIqB49Z9dAa6jds55SE3KKctCwaEy9bSPXTesXmZ4nGd6V1Wvm5kAg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673366866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pmtpr6zGZ8hx41ENd+2CnDBw8zYk3Ya7H/aRfMcemUg=;
        b=YHdL4rwblIX8e6eB2cTI9cWgZXfUhMZiY+MFg/sn5jWWLyBy7UuNyPk7K6TNGD89d7bD/Y
        3zEjMe+wm01Er/DA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next] u64_stat: Remove the obsolete fetch_irq() variants.
Date:   Tue, 10 Jan 2023 17:07:38 +0100
Message-Id: <20230110160738.974085-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

There are no more users of the obsolete interface
u64_stats_fetch_begin_irq() and u64_stats_fetch_retry_irq().

Remove the obsolete API.

[bigeasy: Split out the bits from a larger patch].

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/u64_stats_sync.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 46040d66334a8..ffe48e69b3f3a 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -213,16 +213,4 @@ static inline bool u64_stats_fetch_retry(const struct =
u64_stats_sync *syncp,
 	return __u64_stats_fetch_retry(syncp, start);
 }
=20
-/* Obsolete interfaces */
-static inline unsigned int u64_stats_fetch_begin_irq(const struct u64_stat=
s_sync *syncp)
-{
-	return u64_stats_fetch_begin(syncp);
-}
-
-static inline bool u64_stats_fetch_retry_irq(const struct u64_stats_sync *=
syncp,
-					     unsigned int start)
-{
-	return u64_stats_fetch_retry(syncp, start);
-}
-
 #endif /* _LINUX_U64_STATS_SYNC_H */
--=20
2.39.0

