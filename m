Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CADE3AEA73
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFUNxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbhFUNxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:53:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D12C061574;
        Mon, 21 Jun 2021 06:51:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b3so945245plg.2;
        Mon, 21 Jun 2021 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4wtQAn6LzmVlaCqMqizM6ab4EoyWHwZrrQCDQEZJCVE=;
        b=KsYZRBVCVKS8ZtQhhdKkCHzLAngteaWyzxZ2c3GBjC/s1xJ4Rp7Gh0K1U2kEkJ8Z9Y
         EMRilykmwbrm+E2O8hxt9xCNxuB1BC9beU9B5e56l8SXn6Od8MQYN6hQDd4QseWRI0EK
         kBpHrttwMcWFmJqlCTYFpq9rd0BXet3ySC3EpdoVxtees7G4jJy9ccgVhlaVUf3BFZvT
         kn4qdZlgQtH6rFDQwcDKoq44if7vDYEoEd5nAEGBmVZxBQ06U9sjz6bQKSxBDoql/KAg
         vor69bpxhCLEO/DvQ5EUq40ME/SYRRK+QIiXIsdeKrIztoA88lClj0C3HVwIySYhPbac
         Hssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4wtQAn6LzmVlaCqMqizM6ab4EoyWHwZrrQCDQEZJCVE=;
        b=C8ZJFuyQtvQhfylqnMKpYWU4Ci80RaJsob0TMBkBPrASkRZxOJez8+uyCdcTragyTa
         q+zu7ABBSpod+5XLNssEc+pNq3pbauFzxj/5HfsZJtFMJ2uCyaaw4qVPThgOYfNZoYq6
         x5PFn99Ice+6HyqPMd1SiO5SCzo/a5UDuRAoGqlk6YEaEEyZV76W4Ge7qVBsNWXARxHj
         G25zpguXGUp2qYHBJ0H5R+WfnKBx6BUOwb5fIBdpwroOHJEkVZpc4I74Lc76+7GI5DCM
         xZ4JdWC7XDjeljvoc/WXHG60LZdm+8oFFCba2CXasq4jPvcU7biagB4J0ndbg/UWkzHs
         F5Ig==
X-Gm-Message-State: AOAM533OBREK0n6zQpoQVND8sH7/mYCQHUuHbnqL0PF1kHSjMc2+1eew
        fTEJ/ST/gDvdjbKQT5bdPUY=
X-Google-Smtp-Source: ABdhPJwFUktdrr4PhLpWpymkUiqvYP8hU7ocofZpZwVOz02ZFqqxCuUbnQ0Z6AgvXGLhDIPvf4ZH+Q==
X-Received: by 2002:a17:90a:2e87:: with SMTP id r7mr38259386pjd.232.1624283487677;
        Mon, 21 Jun 2021 06:51:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm16726628pgw.67.2021.06.21.06.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:51:27 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 14/19] staging: qlge: rewrite do while loop as for loop in qlge_refill_bq
Date:   Mon, 21 Jun 2021 21:48:57 +0800
Message-Id: <20210621134902.83587-15-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since refill_count > 0, the for loop is equivalent to do while
loop.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 2d2405be38f5..904dba7aaee5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1092,6 +1092,7 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 	struct qlge_bq_desc *bq_desc;
 	int refill_count;
 	int retval;
+	int count;
 	int i;
 
 	refill_count = QLGE_BQ_WRAP(QLGE_BQ_ALIGN(bq->next_to_clean - 1) -
@@ -1102,7 +1103,7 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 	i = bq->next_to_use;
 	bq_desc = &bq->queue[i];
 	i -= QLGE_BQ_LEN;
-	do {
+	for (count = 0; count < refill_count; count++) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "ring %u %s: try cleaning idx %d\n",
 			     rx_ring->cq_id, bq_type_name[bq->type], i);
@@ -1124,8 +1125,7 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 			bq_desc = &bq->queue[0];
 			i -= QLGE_BQ_LEN;
 		}
-		refill_count--;
-	} while (refill_count);
+	}
 	i += QLGE_BQ_LEN;
 
 	if (bq->next_to_use != i) {
-- 
2.32.0

