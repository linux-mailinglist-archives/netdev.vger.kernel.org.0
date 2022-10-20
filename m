Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24059605872
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJTH06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJTH04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:26:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB78155D8C;
        Thu, 20 Oct 2022 00:26:50 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m29-20020a05600c3b1d00b003c6bf423c71so1683401wms.0;
        Thu, 20 Oct 2022 00:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eXaiXcTVxNCGgz5uJUWTatWPnJcY0pIrG4sVGhUxXlU=;
        b=ISMsheSFMXB4SsSt1jv23NNzZvRf8mjplgctUOOaueloxupPXMBcnkM+IP0oDAZk+1
         szxS1hkfNCiAfYLhnoQL3nwqLgHip0YAazNkNbuxkUVQfMIZYK/yeLEsC+ISaajA3vjp
         F2D4Q0GhERkX5hHaU9v6gKU1KDiHq2LcAVMDAb7GzTudae/5dFhrCH/gXe95O65MKug3
         lqaAahpfEMTbAhdmqX06dq4nXDCTxoeuRFWv4W0NAXatYsrm1qVC9uZdF2QoUzGSJb4F
         92Jt81Kq6HiPcgf8nziIjvP4vcDP3rs+gZGJ/NIO2M5F2ZaJ5gByZFCofZyda5uhvZaV
         owwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eXaiXcTVxNCGgz5uJUWTatWPnJcY0pIrG4sVGhUxXlU=;
        b=sQ6hQv+ENNtnrqQREiuV6MC8zDMJdo7j4tTBi0gsws6F31JQ98bEerUol+d712MqcD
         wB0WB98C7eY7pG5co4P6YoxbB+k0UA/PLieifNuw46MdRlqGdae/AnnFSZJrBlGzOKaU
         X5z8amTT5QbKOpi61iZWxxd/SummDSnUY4sHnvrhxSOIZFXly4MG2/9dBXHJ2mOwvrI8
         QB40OzE7CAB/qUujOMSqKbwKZudEBLNquwX9BVE0mnN1x5W0KcYoUofjj5KoyTcWZYVc
         mQQEwxy4S6M2F+ntOmK0GICV4wqWRuARWsRuozrJAKdRo7xzRVmrf1CBE77jZjAfpzH0
         uxuA==
X-Gm-Message-State: ACrzQf0Rs12navCsNbAXXHPaJqMKRQgxCMUJJodz2+V7PtTl4HYWOghJ
        eXGcagbdlixBlQtsAatzRwE=
X-Google-Smtp-Source: AMsMyM67Awthpe8VwSguYH9pxXV8eCkbH76VTieowah7fdT61eqDFd9iVYxzbE2Gjq9s+fIGuoMLBw==
X-Received: by 2002:a1c:7906:0:b0:3c6:235f:5904 with SMTP id l6-20020a1c7906000000b003c6235f5904mr8547196wme.83.1666250808133;
        Thu, 20 Oct 2022 00:26:48 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d6d4d000000b0022ac38fb20asm15651740wri.111.2022.10.20.00.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 00:26:47 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] wifi: rtw89: 8852b: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE
Date:   Thu, 20 Oct 2022 08:26:46 +0100
Message-Id: <20221020072646.1513307-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ther is a spelling mistake in a rtw89_debug message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
index 8fd01502ac5b..722ae34b09c1 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
@@ -1754,7 +1754,7 @@ static void _dpk_one_shot(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 		    id == 0x14 ? "PWR_CAL" :
 		    id == 0x15 ? "DPK_RXAGC" :
 		    id == 0x16 ? "KIP_PRESET" :
-		    id == 0x17 ? "KIP_RESOTRE" : "DPK_TXAGC",
+		    id == 0x17 ? "KIP_RESTORE" : "DPK_TXAGC",
 		    dpk_cmd);
 }
 
-- 
2.37.3

