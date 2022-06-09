Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF45455E4
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbiFIUqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345178AbiFIUqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:46:42 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B86733A1E;
        Thu,  9 Jun 2022 13:46:41 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id d23so3742011qke.0;
        Thu, 09 Jun 2022 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=tE3FN1D8dyvNHStQKSchutVQqs+h1CQjl2plmGuD71I=;
        b=RxqHyq0JqjcYr4FuRUzHJCOM2ScB9CwEwr0cSOwlry6JfVchPSuPTRVjWc5wdvMapw
         6E5S/4UtEvmdySavjEV73tZwUgG8fOngF883Is12oMIok2W+qPQOjC7dlZWx+Dx3nimy
         3qTyA1eiKSuoBuZ/yvhUrbthQxMyeYdoqpzUIqUV3jYj+Ecz+ErZtPB3scdUrHZznlEi
         D0EUEBAcM26c+jDGra1+QzmH1roP8ebKb+VFwAB8EIAi2hs9tQv0tWHdQ/2TknunyD/X
         WK4+8fryMnr4eNeK4xf7ml65wD2c6vGNhvd2Il7/GI9kl4LPMTOQsdlTeAH1YOmdPh5n
         n3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tE3FN1D8dyvNHStQKSchutVQqs+h1CQjl2plmGuD71I=;
        b=svWeTRnl3SA9nU5bkC3YYHgmGIv85g7Sph3+oNzMbN/MHCXcQ5vcD+eVHPHSUDjxcJ
         9rtD907CWdF0i9dfofzDfZ7rIEyK3E9qG8qWbuFFddN/hJ//aoQdlvhngQDjrJbAGJay
         +Vt/SCVXlG9T7E97B4wweRAI0RrkmUNy2EJYjTqNjK7+5u/YErBypBP/AxHSDY6skZa2
         LffzliFk12QyjIsc3d5vpYyc+x1EUzlJZ35UWnWglytmF8TkjIySRfBP8T6tz1a0nytO
         6Js9NWjOKbh9D/9ZlRKHKf3N8UQjuJn6k0JpaLjib7mFLz7o1oMNjlEAf6QDH6/9QpwO
         o3YA==
X-Gm-Message-State: AOAM532itnC7Gbw1JWRxiWeUiIESyUAsq4HIuGNYYtf6+GiXvuMpbGq+
        AscQSa5HrLShOmBEyBwaKG0CN+BbWwnnng==
X-Google-Smtp-Source: ABdhPJzgKcL7IHdRRhICBBwShEX+JSw4kT2bjFOL9LCQh2jqtDmZrB+T2ncO/USgZzXbpXh5267mVA==
X-Received: by 2002:a05:620a:4404:b0:6a0:51e5:ee72 with SMTP id v4-20020a05620a440400b006a051e5ee72mr28843314qkp.121.1654807600108;
        Thu, 09 Jun 2022 13:46:40 -0700 (PDT)
Received: from Sassy (bras-base-oshwon9577w-grc-06-184-148-179-98.dsl.bell.ca. [184.148.179.98])
        by smtp.gmail.com with ESMTPSA id bn10-20020a05622a1dca00b0030501abadabsm4051488qtb.19.2022.06.09.13.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:46:39 -0700 (PDT)
Date:   Thu, 9 Jun 2022 16:46:39 -0400
From:   Srivathsan Sivakumar <sri.skumar05@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: qlge: qlge_main.c: rewrite do-while loops into
 more compact for loops
Message-ID: <YqJcLwUQorZQOrkd@Sassy>
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

simplify do-while loops into for loops

Signed-off-by: Srivathsan Sivakumar <sri.skumar05@gmail.com>
---
Changes in v2:
 - Rewrite for loops more compactly

 drivers/staging/qlge/qlge_main.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8c35d4c4b851..689a87d58f27 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3006,13 +3006,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
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
+			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
+				base_indirect_ptr[page_entries] =
+					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3023,13 +3021,11 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
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
+			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
+				base_indirect_ptr[page_entries] =
+					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
 		cqicb->sbq_addr =
 			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
-- 
2.34.1

