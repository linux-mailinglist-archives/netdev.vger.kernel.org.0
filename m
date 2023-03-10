Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0B6B51DC
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjCJU35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjCJU3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:29:49 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DAB118812;
        Fri, 10 Mar 2023 12:29:48 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a25so25621233edb.0;
        Fri, 10 Mar 2023 12:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678480188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhwkHRMFo1emA/EWcjQUn3Crg3a7cGKBuL3rT4jEUjQ=;
        b=hGSzl2+EzLeDnxGgTyC4pq7eW+u1dsnZ/AyhGJDLw97MU2+vtrdgjUcIODsndaDM7i
         d8x5vVUhN5OoFDrULBr4udPswuQkMuN/6WwYTm0Mrt8EvtF0wPOwYIZNDAtH73b5Jobm
         Gtn4OCTPVTCntGVOVJMQPkmKTb5yTu51iUvnUWYzvmmm4RI33btMN8+afEtpFfA19tK4
         Ys34MuMReZ6H3wEewYLEdZJWRrwRhzuSIeT/YDbrLOs/EOKd9hkpmb+R4iyIbRmIArVS
         NfhQe40jGllrYvyHI0VFVwC8AdZRVJpOfIPk89t6Hc7c+0lMs7GlC4S1SK4uL+bPiMDH
         aNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678480188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yhwkHRMFo1emA/EWcjQUn3Crg3a7cGKBuL3rT4jEUjQ=;
        b=neA3k+cENmwfNSDvrIcRo3hgiYxibyt05bXBIGAxHjtbP/4yS5tc4Rqwus3BVKgbNX
         ahITwKrNLZcbDODtVEj5lxO9+ORXOTQHOXulTQS2JK1DwARn3vFn0Va0/6K9szzWha0s
         8v0GVXAjhZoF19pmN1w+k2XVv6MWpBgA0kYEXvyMzZ3TmDRM8s4B59fbSlNuCEq9sXk3
         cBmEcviu6b9+4vPteSwvMPpbrT5JwPImcznzntm+yRzjmwWaSa4qTy/LdViYqIRfxopJ
         UtybA2sA6zd3DRG+B6p7COO6q6gE9M9zjz5YxlXucDzcscd3pVnde70DB3ZlecR9iIyt
         oQbg==
X-Gm-Message-State: AO0yUKUSh9hIi31LRS76pjl0zKujMM7WF6I+XPkHyQFEfQq8hixY1zWC
        /bcu4kewBYBToNwFCU2QOVNQVGqxUTM=
X-Google-Smtp-Source: AK7set+fB73brtkB7U1p/xoFNJ/zm95Jr2F9dvqbD41x0fVBo0I/qi7k0b31BYtOW/nYZej/irt7rg==
X-Received: by 2002:a17:906:2989:b0:88f:13f0:4565 with SMTP id x9-20020a170906298900b0088f13f04565mr23842339eje.69.1678480188103;
        Fri, 10 Mar 2023 12:29:48 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-b84f-c400-0000-0000-0000-079c.c23.pool.telefonica.de. [2a01:c23:b84f:c400::79c])
        by smtp.googlemail.com with ESMTPSA id md10-20020a170906ae8a00b008e34bcd7940sm259047ejb.132.2023.03.10.12.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 12:29:47 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v2 RFC 4/9] wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
Date:   Fri, 10 Mar 2023 21:29:17 +0100
Message-Id: <20230310202922.2459680-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize the rpwm_addr and cpwm_addr for power-saving support on SDIO
based chipsets.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v1:
- none


 drivers/net/wireless/realtek/rtw88/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index b2e78737bd5d..cdc4703ead5f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -18,6 +18,7 @@
 #include "debug.h"
 #include "bf.h"
 #include "sar.h"
+#include "sdio.h"
 
 bool rtw_disable_lps_deep_mode;
 EXPORT_SYMBOL(rtw_disable_lps_deep_mode);
@@ -1785,6 +1786,10 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 		rtwdev->hci.rpwm_addr = 0x03d9;
 		rtwdev->hci.cpwm_addr = 0x03da;
 		break;
+	case RTW_HCI_TYPE_SDIO:
+		rtwdev->hci.rpwm_addr = REG_SDIO_HRPWM1;
+		rtwdev->hci.cpwm_addr = REG_SDIO_HCPWM1_V2;
+		break;
 	case RTW_HCI_TYPE_USB:
 		rtwdev->hci.rpwm_addr = 0xfe58;
 		rtwdev->hci.cpwm_addr = 0xfe57;
-- 
2.39.2

