Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD76B5D4F
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCKPZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCKPZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:25:00 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D78AC1C0E;
        Sat, 11 Mar 2023 07:24:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so10098077pjb.0;
        Sat, 11 Mar 2023 07:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678548298;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=crbZwDhWuP19Nx72AN6LNeVP5R+Lb57Ts6T9QLS5tCU=;
        b=OkfZQ/o6x6eDZRPH/ukLKDjV6f5jsB5Wreq2S6MRZ5hsv60SvPx8APXlXifFFG7M/z
         hdYG+M+fH2/GJC4Cw97edH5DfWc2YAZGBHFdqhJFeFi7UOvQO9JqAeBla7ImEe1t1Ikt
         5HLoQYeHHfi4A/l/PMjGYtA7qUoPUDv9b3cebQDvMT1QIOX7aGPaLEHFSOHDbcRmrmTD
         qEcGwB32rn6fmqh0k3ZQnq9FYwlj7VnIGmINwmZw1E4XrgJm/sQsC81CpBrppzxsVFvu
         PeXUO5Bxm0ahfiFfNzlI9lZT00F62bkWHZgElIV8l3b6O7KH2qORgK5HBvjAcihD4U1o
         HumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678548298;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crbZwDhWuP19Nx72AN6LNeVP5R+Lb57Ts6T9QLS5tCU=;
        b=SD5/N1uHbj0kbX4ka2a8wv3UlZjjG1d9QKvaM5uLCWTElaC7S6UxMB0A+LjyvXY0PM
         TU4Ji52l+m+4zwonYm9mERQ+lIl8Ua+69WaRNom8XM4uPpjtKFHrmVP4J71cdFS29M0q
         kWHs5sPwu7lLTCuu1HMgsadmxvW2hvZVk1/Kqz/g0Uke24JaHOcISUTlIQTG+SMAKEaA
         bcXL4Pb9vG56qfNAptFYRwnGXqu4tbRLtPR0M8duQnu+lYOuz7Yv3HOSkAK+N0X4HKuX
         GhXLoQmOA313puXldayXl08+BfTH/63sRgCexS6dxlP45rv4bnkA4QjR1CCYsw9yTW14
         4MdA==
X-Gm-Message-State: AO0yUKUbaVTBC0jxSRvAT73psLqac88aclAnZYWrCgBudD96XHXW6NdW
        FFg1a1TIzyOAhU0DZsyOYZI=
X-Google-Smtp-Source: AK7set9gJeRH76pCp0p9bue1wncgBaSpopayuwbdmPZQmpYlrWzMwSL3rPYeT1Kb0Zg4tS+QenKLJw==
X-Received: by 2002:a17:90a:52:b0:233:b20f:e646 with SMTP id 18-20020a17090a005200b00233b20fe646mr29110601pjb.0.1678548298653;
        Sat, 11 Mar 2023 07:24:58 -0800 (PST)
Received: from ubuntu ([117.199.152.23])
        by smtp.gmail.com with ESMTPSA id kb12-20020a170903338c00b0019906c4c9dcsm1713823plb.98.2023.03.11.07.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 07:24:58 -0800 (PST)
Date:   Sat, 11 Mar 2023 07:24:53 -0800
From:   Sumitra Sharma <sumitraartsy@gmail.com>
To:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Cc:     outreachy@lists.linux.dev
Subject: [PATCH] Staging: qlge: Fix indentation in conditional statement
Message-ID: <20230311152453.GA23588@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tabs/spaces in conditional statements in qlge_dbg.c to fix the
indentation.

Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 35 +++++++++++++++------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index b190a2993033..c7e865f515cf 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -351,26 +351,23 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
 		/* We're reading 400 xgmac registers, but we filter out
 		 * several locations that are non-responsive to reads.
 		 */
-		if (i == 0x00000114 ||
-		    i == 0x00000118 ||
-			i == 0x0000013c ||
-			i == 0x00000140 ||
-			(i > 0x00000150 && i < 0x000001fc) ||
-			(i > 0x00000278 && i < 0x000002a0) ||
-			(i > 0x000002c0 && i < 0x000002cf) ||
-			(i > 0x000002dc && i < 0x000002f0) ||
-			(i > 0x000003c8 && i < 0x00000400) ||
-			(i > 0x00000400 && i < 0x00000410) ||
-			(i > 0x00000410 && i < 0x00000420) ||
-			(i > 0x00000420 && i < 0x00000430) ||
-			(i > 0x00000430 && i < 0x00000440) ||
-			(i > 0x00000440 && i < 0x00000450) ||
-			(i > 0x00000450 && i < 0x00000500) ||
-			(i > 0x0000054c && i < 0x00000568) ||
-			(i > 0x000005c8 && i < 0x00000600)) {
+		if ((i == 0x00000114) || (i == 0x00000118) ||
+		    (i == 0x0000013c) || (i == 0x00000140) ||
+		    (i > 0x00000150 && i < 0x000001fc) ||
+		    (i > 0x00000278 && i < 0x000002a0) ||
+		    (i > 0x000002c0 && i < 0x000002cf) ||
+		    (i > 0x000002dc && i < 0x000002f0) ||
+		    (i > 0x000003c8 && i < 0x00000400) ||
+		    (i > 0x00000400 && i < 0x00000410) ||
+		    (i > 0x00000410 && i < 0x00000420) ||
+		    (i > 0x00000420 && i < 0x00000430) ||
+		    (i > 0x00000430 && i < 0x00000440) ||
+		    (i > 0x00000440 && i < 0x00000450) ||
+		    (i > 0x00000450 && i < 0x00000500) ||
+		    (i > 0x0000054c && i < 0x00000568) ||
+		    (i > 0x000005c8 && i < 0x00000600)) {
 			if (other_function)
-				status =
-				qlge_read_other_func_xgmac_reg(qdev, i, buf);
+				status = qlge_read_other_func_xgmac_reg(qdev, i, buf);
 			else
 				status = qlge_read_xgmac_reg(qdev, i, buf);
 
-- 
2.25.1
