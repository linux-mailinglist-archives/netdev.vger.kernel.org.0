Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC214BB3F5
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiBRIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:12:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiBRIMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:12:03 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E5E33E93;
        Fri, 18 Feb 2022 00:11:42 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id v4so7936031pjh.2;
        Fri, 18 Feb 2022 00:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4tyuVDt8konpruvFZLheBo0477RzkXZvUE1/xQIQQzU=;
        b=HGxw+cT80fKVAuFta3cCBeLL2b3yRUW4hCLbJ2St0WM6ijqZZ41IvyiizVcSr/bqL0
         7GQoGde/lTLLFvZf5RXAu44mpBNxaYjiFE+ah3cPxMwb59NyI4gG1pazf2+OyVrfB1tQ
         NOyeWna96ckGtA+bPNeAFOPqajoNvpB1LEjj6sRdzXnyVvlrOzdOw9oeWuOhSvBhVwOP
         4Aj3WAyj2s09kvwuVgAnYx1CCTiPBd+7Jxok0aL2n/e4KT3816iH37IADV81aPwdsMmc
         sbgk0kCwqj5g5ZCL1qKVYcZhc9f3VFrYOWshUVKwWLLzOv4fBMTNKR7rUA0RdPvJlfPc
         37RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4tyuVDt8konpruvFZLheBo0477RzkXZvUE1/xQIQQzU=;
        b=f6kRVPGxQECXiBpBo28saO3dzIxc9UsLXmaakf0H67hblZ881ls+KHSzdZHKHZ2p9n
         rKDP9n7VS1mtmZ8+MoZt+Arsrem1Qdkol1CBeSUyLgJzdLQjTBiMVZnh7n+PfbCo8Jda
         FwxwTDov/fsDH3pPvEtbIHf3OdwEkAJxg6SfeXXl5/PxFacNeOB7lEoedSqrWRVtryyK
         B2I4RQu/HKZRuT0oru2A5zHN5YgDaytvMUhSWonWY9eWJ/OXQCmwZtbfGIuNkr9QylzG
         +jOB/wY6CfUmpBAbgTdxYp+V4iENfptwqqHkJ0amHdCHeOQNLwnNoVomcBorh8ddZUX/
         MLBg==
X-Gm-Message-State: AOAM532J7JLCc7oJXYyHuS97cRsaADl0yI1pDmwiwm8cIBBM/n1eEX18
        Mv8CPZvJTuG3k+SbpiAcCTM=
X-Google-Smtp-Source: ABdhPJy6dTgjTfwO+xBjsRnrzDVHxDWbcM2O1ZHCcdZ0hKvPfLXE8LTO96lZXLmUSDJ8THT3vpCP2w==
X-Received: by 2002:a17:90a:1202:b0:1b9:b7e7:1652 with SMTP id f2-20020a17090a120200b001b9b7e71652mr7282313pja.1.1645171901988;
        Fri, 18 Feb 2022 00:11:41 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id g21sm2004515pfc.167.2022.02.18.00.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:11:41 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] staging: qlge: add unregister_netdev in qlge_probe
Date:   Fri, 18 Feb 2022 16:11:30 +0800
Message-Id: <20220218081130.45670-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

unregister_netdev need to be called when register_netdev succeeds
qlge_health_create_reporters fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 9873bb2a9ee4..0a199c6d77a1 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4611,8 +4611,10 @@ static int qlge_probe(struct pci_dev *pdev,
 	}
 
 	err = qlge_health_create_reporters(qdev);
-	if (err)
+	if (err) {
+		unregister_netdev(ndev);
 		goto netdev_free;
+	}
 
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
-- 
2.25.1

