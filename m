Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F48545069
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344311AbiFIPQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344338AbiFIPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:16:03 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ACB419A4;
        Thu,  9 Jun 2022 08:15:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a10so22416511ioe.9;
        Thu, 09 Jun 2022 08:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=XjDcxc7sQfpXSZ1klfFIU0xeG3PIJolrhiT/911tClE=;
        b=fppqyvuMKJGHBPZhOK9EHVChnvSGKHOdURrkPjnlsrlvdZKmkYaOIaxbtFXgTCyHqJ
         s4nXebMun2v4vxvvUiYsTwNPFRrv/FceI9cL+qXIFGy9o2eK6PSIClX1cIP38yUCUQuM
         gE8/+tDPpMivdu8kZIgr4kpEu1ISRqDBT7MP6aEG0nKEvT6mYqRgKIn8nAbGv2zFszzy
         WPZ9u+0lR6Pl1uSMkZURCgEQ39zUJ5tsZ3nJaiwinfN4Rr6hKZ1Jo9CvyS6Rne3Zf4zW
         WRH+oqkVprKah3fNVLiDbGMMUFagBUWSmYdVcDqp0O3M8yaoYJ1Nr/xnHkxpwGPhTClg
         Dpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=XjDcxc7sQfpXSZ1klfFIU0xeG3PIJolrhiT/911tClE=;
        b=oXPtbWUfZr2aNyUeK6173gVetTjOhK41hLeWVOKAuOpdvGYioGoS9x9YriRuq9ITBu
         78Zg0sqwqvf77UQQw8wX/HLzT4mmjS6RQDeQMRcjsZtE1thjni4ZAg5qVg5WYwWqGrhE
         OBqu6DYr+m2QN2UMMF06CVICmPs2Wx4YC55c9XLnEuvvRrfDn4RoR9Uqmg+xggUb6Pxs
         CJm+GglhqW4BIPwpq+n2MzOxkolpxwI+J/PPwwxPaQA8xAOmBczkvUSg7JG4o0zEl2lE
         6tTy2gb/8tYYY0SgsCHCNHOBi/+6lGXNQ2tkQgYuRIFibpC4scTUfaUCIYF3LG+eVf26
         2RYA==
X-Gm-Message-State: AOAM53321Y7aR0ALM+YH6JAGhcsSIc8kYriy0mcPyo4ko36EgMIad1YZ
        3UDLaPg8Xob2ZFVLpenmaEs5HQ1RNWJpHNTg
X-Google-Smtp-Source: ABdhPJxb727WnXl7RLk2R1XnZfkIyBiIPHdm6AHrJyUkzWugSsolcX3iq7utyu5mjGz2i5myr/aG6g==
X-Received: by 2002:a02:a313:0:b0:331:7bfc:9830 with SMTP id q19-20020a02a313000000b003317bfc9830mr17152543jai.2.1654787752977;
        Thu, 09 Jun 2022 08:15:52 -0700 (PDT)
Received: from Sassy (bras-base-oshwon9562w-grc-61-184-146-75-18.dsl.bell.ca. [184.146.75.18])
        by smtp.gmail.com with ESMTPSA id i131-20020a6bb889000000b00669ae49f762sm1008064iof.19.2022.06.09.08.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:15:52 -0700 (PDT)
Date:   Thu, 9 Jun 2022 11:15:51 -0400
From:   Srivathsan Sivakumar <sri.skumar05@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_main.c: convert do-while loops to for
 loops
Message-ID: <YqIOp+cPXNxLAnui@Sassy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

simplify do-while loops to for loops

Signed-off-by: Srivathsan Sivakumar <sri.skumar05@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8c35d4c4b851..308e8b621185 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3006,13 +3006,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
 		tmp = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
-		page_entries = 0;
-		do {
-			*base_indirect_ptr = cpu_to_le64(tmp);
-			tmp += DB_PAGE_SIZE;
-			base_indirect_ptr++;
-			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
+
+		for (page_entries = 0; page_entries <
+			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
+				*base_indirect_ptr = cpu_to_le64(tmp);
+				tmp += DB_PAGE_SIZE;
+				base_indirect_ptr++;
+		}
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3023,13 +3023,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		cqicb->flags |= FLAGS_LS;	/* Load sbq values */
 		tmp = (u64)rx_ring->sbq.base_dma;
 		base_indirect_ptr = rx_ring->sbq.base_indirect;
-		page_entries = 0;
-		do {
-			*base_indirect_ptr = cpu_to_le64(tmp);
-			tmp += DB_PAGE_SIZE;
-			base_indirect_ptr++;
-			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
+
+		for (page_entries = 0; page_entries <
+			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
+				*base_indirect_ptr = cpu_to_le64(tmp);
+				tmp += DB_PAGE_SIZE;
+				base_indirect_ptr++;
+		}
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.34.1

