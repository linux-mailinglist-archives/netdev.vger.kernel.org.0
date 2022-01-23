Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC2497476
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiAWSkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiAWSkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:40:20 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8451BC06173D;
        Sun, 23 Jan 2022 10:40:20 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y17so3130522plg.7;
        Sun, 23 Jan 2022 10:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QqjEcwh/Vt3ob/xyYzKK4XDGLqNzTDbmtmru+0FTCuE=;
        b=QirWg+lweofM9kFw4lQkoYZAFuKzZxOxrfW4krFfMwzWQOQc828Kg4wUFu/CnyQyYo
         jXMbk78JyjVnL00jc+K6b7IKZaGBiJkUZRjZhvTWLZjdoGe7Rmc5Ld5gBMmQE4h8CBwc
         2nZWoOHGLABDxeInZgxPd1zaaerdmwx1uw/CoJ2KNxMrjYLyYAlHX6xP1WQspeALHNbo
         sOmk6CFE7AWiAd2Uop6Jh9ZUqhP1IiO6WNhmYk8AGo4PvVqdXR12F00sDQVaFHhrZT3G
         cr4x4N9BbO3MSVwZxJWjB2Lb76qglUp3ZalrE3oh0Bi001lr9e34A5qeWoVSN8j9CeP2
         22Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QqjEcwh/Vt3ob/xyYzKK4XDGLqNzTDbmtmru+0FTCuE=;
        b=p47GPAYHS8CCalQoJs3WgeqGZhSSgzX6BHuCUYwcJIX062oZaFkdnkEevSvive1aRX
         TIO0DoJj4Q3VnUAnSERJYGxixGb6Ut3uj/22NChLlmbSFy2ZqSzvHQ/fZ6aqC2lnJu5t
         8EMNpuyZJzvQd6m4JfHiEkKeq4C/1r5YbuXdi2MyjK7atWZVqf3Bu8Zn/nXImGRhgX4S
         poeM4iQ3xAFDZ+bnDwzd8ipZzB3PrsH/dt8bLDgEkTd6JXvDVYk5frjixffgIbH+DCv8
         D+mgOM3/r0pqh35hBkIgetXZLswdf+8Q9mW7NRCI9PBFXBrIuVjCXRd2HHY65JobQ7sO
         dxJw==
X-Gm-Message-State: AOAM533Ge3zwx7u9AMz4ij+jhXICuBvGvwJe6FNTixrs/hRhV5X3SF6Z
        vEcCK7QG9p9S9EkHFJZ86rs=
X-Google-Smtp-Source: ABdhPJwbVELe7QC7MMVE53A+dZrALuLWXks3kDspFFg5RnGQ+U6L1gKvdNAVlETCFY4gN45eIP7tHg==
X-Received: by 2002:a17:902:b185:b0:149:fccf:1cf3 with SMTP id s5-20020a170902b18500b00149fccf1cf3mr11659042plr.77.1642963220019;
        Sun, 23 Jan 2022 10:40:20 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r19sm10615026pjz.6.2022.01.23.10.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:19 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 10/54] net: ethernet: replace bitmap_weight with bitmap_empty for qlogic
Date:   Sun, 23 Jan 2022 10:38:41 -0800
Message-Id: <20220123183925.1052919-11-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qlogic/qed code calls bitmap_weight() to check if any bit of a given
bitmap is set. It's better to use bitmap_empty() in that case because
bitmap_empty() stops traversing the bitmap as soon as it finds first
set bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 4 ++--
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 23b668de4640..b6e2e17bac04 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -336,7 +336,7 @@ void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
 
 	/* print aligned non-zero lines, if any */
 	for (item = 0, line = 0; line < last_line; line++, item += 8)
-		if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
+		if (!bitmap_empty((unsigned long *)&pmap[item], 64 * 8))
 			DP_NOTICE(p_hwfn,
 				  "line 0x%04x: 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
 				  line,
@@ -350,7 +350,7 @@ void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
 
 	/* print last unaligned non-zero line, if any */
 	if ((bmap->max_count % (64 * 8)) &&
-	    (bitmap_weight((unsigned long *)&pmap[item],
+	    (!bitmap_empty((unsigned long *)&pmap[item],
 			   bmap->max_count - item * 64))) {
 		offset = sprintf(str_last_line, "line 0x%04x: ", line);
 		for (; item < last_item; item++)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 071b4aeaddf2..134ecfca96a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -76,7 +76,7 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	 * We delay for a short while if an async destroy QP is still expected.
 	 * Beyond the added delay we clear the bitmap anyway.
 	 */
-	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
+	while (!bitmap_empty(rcid_map->bitmap, rcid_map->max_count)) {
 		/* If the HW device is during recovery, all resources are
 		 * immediately reset without receiving a per-cid indication
 		 * from HW. In this case we don't expect the cid bitmap to be
-- 
2.30.2

