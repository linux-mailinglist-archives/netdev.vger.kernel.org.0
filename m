Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDDC5B8CD1
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiINQYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiINQYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:24:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94489E55;
        Wed, 14 Sep 2022 09:24:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso19603228pjk.0;
        Wed, 14 Sep 2022 09:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=1xfAttjBNPJfxtb2E9TpigfOTCC44pqkuTF09xMIE/Y=;
        b=ZUmP/LWkJ80NgeLZCrUctArN9tCXv0/OhrqrK2V9652lwfpuzNs4ulKzj4AcaPkTfT
         r0VmZULDVvnjei/QQjGZvetTEzPY1F6XrcO2cxrycBrbMK1z9rHqrM8DwF1XU2qm80Nx
         GrbHiYBoGxHRdUg0UFrHddTacogLdVUJgAEngbyJzmaSGpFS2Iyw+wkWhl3YW1y1tZLm
         kpjhnZesqgz3KahFwkPvFoL4yDEdeK7ZGH0RQwU1LnwM9zIT4mieaa5GNtStug+0cVy8
         QvJrZay0fsDowrUepq9wa2CvEnr+ix3krWCpmTzVTARlDldtYE/vrP+rilVZELt5RPzz
         GKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=1xfAttjBNPJfxtb2E9TpigfOTCC44pqkuTF09xMIE/Y=;
        b=6sz33LPWmRvfPxH2JcqdiNsypBQDw8qCpY2qGF16IdfRQnC3azGbM8EV3kb/bP2C69
         DT07i8YzO7QSdiu9MmvCIslKrAGJZGZcSFMadGLuOLO2sq4AT+tG2NXvSAzIDVOxQR/l
         51Qn6Z/8qpcHAeDdU8gINyCev75wvcnmPTYsFPnmjAAul0dZh1rFJ70EqwZA21JigAu1
         q3qu2fiNREOX4640LOOo7o7jZgp9PZEDHg9YQfUsFIIGSQSxoIrE56BOfB7tFnYGe9Za
         SFtO9t5cq35C/6qLNAwkw7YTZW+RR7Wgu39lzK51/pq+fD1t+F3xnY+R0FqvshuVPRCR
         0QNQ==
X-Gm-Message-State: ACgBeo0mdsiPREaV4HCpsrD0U3ayCmyTV/8G1kbL53TzVoxndDk5BO0P
        Vun2heSd6Kg1o9zMT9ZhBtc=
X-Google-Smtp-Source: AA6agR6yqUO2xlxnDZIsxZUQ1iiTrfUkJpZoGwYNT/mYAHZk1/oWXAceWvhjUUWuegu4XCccv1M7lw==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr37498461plg.11.1663172669034;
        Wed, 14 Sep 2022 09:24:29 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b00438fe64d61esm6701672pgv.0.2022.09.14.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 09:24:27 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hayeswang@realtek.com
Cc:     aaron.ma@canonical.com, jflf_kernel@gmx.com, dober6023@gmail.com,
        svenva@chromium.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] r8152: Replace conditional statement with min() function
Date:   Wed, 14 Sep 2022 16:23:26 +0000
Message-Id: <20220914162326.23880-1-cui.jinpeng2@zte.com.cn>
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Use the min() function instead of "if else" to get the minimum value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/usb/r8152.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a51d8ded60f3..6cead36aef56 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4829,10 +4829,7 @@ static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy,
 		u32 ocp_data, size;
 		int i;
 
-		if (len < 2048)
-			size = len;
-		else
-			size = 2048;
+		size = min(2048, len);
 
 		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
 		ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
-- 
2.25.1

