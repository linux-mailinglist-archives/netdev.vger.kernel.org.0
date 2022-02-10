Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3599D4B18F8
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbiBJXC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:02:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345039AbiBJXCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:02:54 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0CD1107;
        Thu, 10 Feb 2022 15:02:54 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id m8so5613457ilg.7;
        Thu, 10 Feb 2022 15:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x5y11i0zdnz/BX0MaBmAp+uRfUX2Rak/fHPY7uFI9V0=;
        b=CSDL1Vj/nWsuuxYBwx/1wZqFN7bmDSB+ohNjATtPUS/FmhKwM8U3HzQsAuHa9fxhdw
         4Jz3dKN1fN/o+4qihImxLWv+8hHfE0gxZLyEK1R//WED6Y4hZewiadnqdFSpUy5z0lxd
         lmW8scFb12dfcMOtEH2AdhXB3ZaHAM6AzRoLsapN1LJb1Ng2nN7e6DuYgJSNhKBPQv37
         Za/uaPxa9OZzjDClHWB4tE9R4ub2sYccHlPLr9lZL9ZjugJwdvgdi67a+QlwHiDQXNF8
         gufo35FdLMxm4rYABpmBVhdRWQxoj1egoyHZJzvxhzdCt+PUML3+Uln5r0OWfgGCDVoa
         uptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5y11i0zdnz/BX0MaBmAp+uRfUX2Rak/fHPY7uFI9V0=;
        b=1xg0xXMb9MCzKdp6ToWjUCV87e1WFC+7uyVu5Mc9AQ7v/YDo+F07OB1lZ6U0A9BXDr
         UxODn5JZ4LBwCrmND86/C4fiyyJ2rtSCXtH9eFoX/Whcdszza8w+y/RO1bkfeIS8pV+d
         Tnx2whCGX1aVfAwKihEp9ZCmqP64FFA+WtEgrX8MreEF+zLULxoj1ewBUa70qknnq/Lb
         xD+nGMSvQspGkHvPSbFHisFOVNivj8ShitbcKv3FgtOUeoewtaqlpSS+22weWT4xZ5K3
         mTu3UXMp5njuvZNuR1zfOIEd0bmKj1OtIB7WaBSIIRw4kRtkbEeuM9HvRRxDZl3NDalJ
         K2tg==
X-Gm-Message-State: AOAM5324b9HOfdIcdOoYESoY3tImeMnEzwgTZTb/LrKem461CNyn2moO
        6Zm9ENFA6LidaM06OHfPpow=
X-Google-Smtp-Source: ABdhPJzPA3K644w+KPqoBt0nZGj9yYw0gW84+vIzUuBQFk1Yiwg2zu/FkqSM3NWQY8+eYGjQJPYgSw==
X-Received: by 2002:a05:6e02:1090:: with SMTP id r16mr5059802ilj.183.1644534173993;
        Thu, 10 Feb 2022 15:02:53 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id d12sm11567868ilv.42.2022.02.10.15.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:02:53 -0800 (PST)
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
Subject: [RFC PATCH 05/49] qed: rework qed_rdma_bmap_free()
Date:   Thu, 10 Feb 2022 14:48:49 -0800
Message-Id: <20220210224933.379149-6-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_rdma_bmap_free() is mostly an opencoded version of printk("%*pb").
Using %*pb format simplifies the code, and helps to avoid inefficient
usage of bitmap_weight().

While here, reorganize logic to avoid calculating bmap weight if check
is false.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---

This is RFC because it changes lines printing format to bitmap %*pb. If
it hurts userspace, it's better to drop the patch.

 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 45 +++++++---------------
 1 file changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 23b668de4640..f4c04af9d4dd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -319,44 +319,27 @@ static int qed_rdma_alloc(struct qed_hwfn *p_hwfn)
 void qed_rdma_bmap_free(struct qed_hwfn *p_hwfn,
 			struct qed_bmap *bmap, bool check)
 {
-	int weight = bitmap_weight(bmap->bitmap, bmap->max_count);
-	int last_line = bmap->max_count / (64 * 8);
-	int last_item = last_line * 8 +
-	    DIV_ROUND_UP(bmap->max_count % (64 * 8), 64);
-	u64 *pmap = (u64 *)bmap->bitmap;
-	int line, item, offset;
-	u8 str_last_line[200] = { 0 };
-
-	if (!weight || !check)
+	unsigned int bit, weight, nbits;
+	unsigned long *b;
+
+	if (!check)
+		goto end;
+
+	weight = bitmap_weight(bmap->bitmap, bmap->max_count);
+	if (!weight)
 		goto end;
 
 	DP_NOTICE(p_hwfn,
 		  "%s bitmap not free - size=%d, weight=%d, 512 bits per line\n",
 		  bmap->name, bmap->max_count, weight);
 
-	/* print aligned non-zero lines, if any */
-	for (item = 0, line = 0; line < last_line; line++, item += 8)
-		if (bitmap_weight((unsigned long *)&pmap[item], 64 * 8))
+	for (bit = 0; bit < bmap->max_count; bit += 512) {
+		b =  bmap->bitmap + BITS_TO_LONGS(bit);
+		nbits = min(bmap->max_count - bit, 512);
+
+		if (!bitmap_empty(b, nbits))
 			DP_NOTICE(p_hwfn,
-				  "line 0x%04x: 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx 0x%016llx\n",
-				  line,
-				  pmap[item],
-				  pmap[item + 1],
-				  pmap[item + 2],
-				  pmap[item + 3],
-				  pmap[item + 4],
-				  pmap[item + 5],
-				  pmap[item + 6], pmap[item + 7]);
-
-	/* print last unaligned non-zero line, if any */
-	if ((bmap->max_count % (64 * 8)) &&
-	    (bitmap_weight((unsigned long *)&pmap[item],
-			   bmap->max_count - item * 64))) {
-		offset = sprintf(str_last_line, "line 0x%04x: ", line);
-		for (; item < last_item; item++)
-			offset += sprintf(str_last_line + offset,
-					  "0x%016llx ", pmap[item]);
-		DP_NOTICE(p_hwfn, "%s\n", str_last_line);
+				  "line 0x%04x: %*pb\n", bit / 512, nbits, b);
 	}
 
 end:
-- 
2.32.0

