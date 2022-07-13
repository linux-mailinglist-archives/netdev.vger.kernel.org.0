Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE65572FE1
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiGMIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiGMIA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:00:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FF2E0249;
        Wed, 13 Jul 2022 01:00:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so2303159pjf.2;
        Wed, 13 Jul 2022 01:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UoKkbTCGppE1RjnxJhiFSTs25wxtlVXgMJ54CPVb2mk=;
        b=C//LZB2o5gZfRHuzi3bO0tBHyBOV56+mmRQD83HreBx7UgZ6b+k9lJpEFTKvL48jfZ
         PZ8AGMsGxDIcB9uB1JpbgcvvbXWS43SkHxcnjzRx6WnrfLiDcXwfxsDaI1I0/yQF5/Ic
         7i/5v5OeaHzG4pmSiOzilSEPMXv3wxJWikuZWtwWpeKbJ9swAGxczj+HZNkcOAmbHE+/
         PKdvUQCHHHE5C+VszPrXYYqXQ4mqSCuwNkNHwbZVd5e4rqYr3bnSgPpWthOx458ygKfZ
         BQNWvcJUNp0+VMaqd8pmcWribUA8A3OuXaCOt4AWlijsUdXMjn6vOw+iXjmaHKnt8xTh
         6XzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UoKkbTCGppE1RjnxJhiFSTs25wxtlVXgMJ54CPVb2mk=;
        b=B0zcZIC+3OqDkZbJgFhFmWl22Hzqf3U2KEGP7VKSuIeQgUmis1OuWSWpLsnXzxbRcy
         Nzz3OCyAz2BlB1Wir7nAzEV884+Ci/vz+XEkgN/q5SK759p8vEmQK71XWoVtlrp1lblM
         MwFvtAy6TH44vx+WvfXXUZC1ezaQJXFyoPaWucUWqK8A7LTLH+Jz1+FNTwpwpGZvaXjE
         2gR94aRCaAZk5zpIY4YKYd5JhcVHls0ijWm+V8kDAnVK/W9XU31tJTpyDwWCEGfOR8vb
         hVDLlsRjvlu1L2zezRxjQfcnf224Fz2uJBzpPzsHvbDxvX0IJPujRKYn13v7XZE/E2yS
         Gk/w==
X-Gm-Message-State: AJIora/82cBdvfunOifjNyib0lR1qLH0TODPHxLmbE0RC90G8HBdJ4NI
        XmkxZh//pXcC1VRWWMd8RQYBnfS5N3RzDw==
X-Google-Smtp-Source: AGRyM1vVTSqvvqV5eXj6we2txPZJMsjJKBNk7FSArmTJ7QPZDu8ST+LhD4F1yFmWUObwyhLSmkFHSg==
X-Received: by 2002:a17:90b:4f82:b0:1f0:95d:c029 with SMTP id qe2-20020a17090b4f8200b001f0095dc029mr2547730pjb.66.1657699223980;
        Wed, 13 Jul 2022 01:00:23 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:5ee1:7060:fe1d:88a2])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79f9b000000b0052089e1b88esm8187747pfr.192.2022.07.13.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 01:00:23 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:00:23 -0700
From:   Binyi Han <dantengknight@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] staging: qlge: Avoid multiplication while keep the
 same logic
Message-ID: <31fe21bf4a9e8f13cf27bd50073e9d5d197654ea.1657697683.git.dantengknight@gmail.com>
References: <cover.1657697683.git.dantengknight@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657697683.git.dantengknight@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid the more expensive multiplication while keep the same logic.

Signed-off-by: Binyi Han <dantengknight@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5209456edc39..4b166c66cfc5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3009,9 +3009,10 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 
 		for (page_entries = 0;
 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
-		     page_entries++)
-			base_indirect_ptr[page_entries] =
-				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+		     page_entries++) {
+			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
+			tmp += DB_PAGE_SIZE;
+		}
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3025,9 +3026,10 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 
 		for (page_entries = 0;
 		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
-		     page_entries++)
-			base_indirect_ptr[page_entries] =
-				cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
+		     page_entries++) {
+			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
+			tmp += DB_PAGE_SIZE;
+		}
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.25.1

