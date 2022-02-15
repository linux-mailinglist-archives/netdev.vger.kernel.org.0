Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913F94B5F9A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiBOAxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 19:53:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiBOAxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 19:53:16 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E0B82DA;
        Mon, 14 Feb 2022 16:52:44 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z17so11830981plb.9;
        Mon, 14 Feb 2022 16:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dv3kssat0G0+r/mn6cZ8o0DJdBpH+IYK8WlYpDl7VRk=;
        b=SiiOQxbKe+V7ewVUSXRYdLtkyJFMtToCQ0GCZt4YMjE1T6aYhYrtpfQKxavLNorTDE
         Y3/jPyC0k3UntNxxiyrIIMOvRe2MYad/kG6kRl4pr9IpKljm1P3Hg2rtKHSd2gDg9pCE
         ublTc4KTbQc6RTf6KD2bh9xI6mJ1X6VbJgdUdjHNqzq9j3mY25Y3cCWMOjVbmKUcyIj4
         47FKm+6D1xSvvztKjtPUhl7YO5BHtGLJuFUuY+npoWVIWnOH1F9Zuhg3q8aYKLn+QKke
         wJTBq1Ebfmjxr8Mn3Y7QBG27CnVBTwiCQYlzMBGbqPl7/kLaUZmduGPIIwRZdhtRMg3j
         0VPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dv3kssat0G0+r/mn6cZ8o0DJdBpH+IYK8WlYpDl7VRk=;
        b=bGOqIjP1gfvzmGflaIr5zOBxpdmxQokXuzf3bMWLKQMtyR3S/G46daO4gEmOPKVhEg
         4sKaJD0pFsapcNRv2VTiI65qnjNbAMQBymVNJ0ls3P59pctdy4/kL7d9IBhoGuVgIxPn
         Nm9qM7/eFtc5akgfgFoWJ44S8dxvpI0J7uIgl5JHor1owvufEgU7e8Fr8UQkwxnpgOf6
         AY2na6L//DGGHmVZDMU70pccLPR6Y9NY38E8XK/SQgYg4RqbH+HhQV6Y4AXG6JlubL/I
         1vtnOYI5vdJuxTg8ZWyMd+Exbk4LKlYCP7ltkG8X5iSjEwABwRJFSUkvqecuYqnOw5/l
         J9CA==
X-Gm-Message-State: AOAM532+UauM54jo0r646ICLum+cUIuotuBBDQIAsG7t2lsiiTpK4QcM
        YqCxPoNSu17QP+rVOOQ6cnnc3orwDmY=
X-Google-Smtp-Source: ABdhPJywNgst+GINAh2ryDsXhp3cqrx9PpdL4N7LTQmDZF2YSZEu16v/j4TLyB9n2OCN8nGWaHk/LQ==
X-Received: by 2002:a17:90b:4ac4:b0:1ba:3b4:d3c with SMTP id mh4-20020a17090b4ac400b001ba03b40d3cmr1346349pjb.201.1644886363049;
        Mon, 14 Feb 2022 16:52:43 -0800 (PST)
Received: from localhost.localdomain (192.243.120.247.16clouds.com. [192.243.120.247])
        by smtp.gmail.com with ESMTPSA id w198sm4014674pff.96.2022.02.14.16.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 16:52:42 -0800 (PST)
From:   davidcomponentone@gmail.com
To:     toke@toke.dk
Cc:     davidcomponentone@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath9k: use swap() to make code cleaner
Date:   Tue, 15 Feb 2022 08:52:29 +0800
Message-Id: <a2400dd73f6ea8672bb6e50124cc3041c0c43d6d.1644838854.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
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

From: Yang Guang <yang.guang5@zte.com.cn>

Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
opencoding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 0422a33395b7..daf88330e13b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -33,9 +33,7 @@ static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 	for (i = 0; i < ATH9K_NF_CAL_HIST_MAX - 1; i++) {
 		for (j = 1; j < ATH9K_NF_CAL_HIST_MAX - i; j++) {
 			if (sort[j] > sort[j - 1]) {
-				nfval = sort[j];
-				sort[j] = sort[j - 1];
-				sort[j - 1] = nfval;
+				swap(sort[j], sort[j - 1]);
 			}
 		}
 	}
-- 
2.30.2

