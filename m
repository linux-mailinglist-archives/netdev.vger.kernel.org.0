Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD655ABEAD
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiICLPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 07:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiICLPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 07:15:24 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BCB5E64E
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 04:15:22 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso2901427wmb.2
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 04:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=RuQ87rcj7ev128wJJbAlv4mZbJrp2RWwhmBI2Dso/58=;
        b=K+bCfnGsX2Fo1MOfOIDpyzfiziD+DME0nO6/0Q0TpI7bbDjjWHQzAC92+n4uE5wjJB
         IEIuec43cntBYT26D0b80crqQjHVX6B+NhA8NPJAveDxBHGV7BKyCy8FO2Nxej/zLZDR
         H47NNUigl78z1qmb892VQcXfKbuZN+AAQdKmljvLUP9WmKOv00PZUCu7iNQmgfL9EwX9
         t3pPIOCxho2/FdMPRmzIWUCqimn8j05Qmj2n3QIabFXrwZP2Zu+y9QCE0HU3ncCCfSQA
         VVZno+DrdwPUuA8gHHBVRQbkWDwwDjQ5iJK+hWDtOUOo/dJ7Sa2WtIX7MlE6o8G/I4p8
         2Ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=RuQ87rcj7ev128wJJbAlv4mZbJrp2RWwhmBI2Dso/58=;
        b=q9lnUnsXCcRu3wCZwxF1VJWyONJozgu/v+mZB74ESmna7wZp5HLdnvEcFtGu/Hmfs7
         OvpDTBu07Ci01UAxj2F88fADY6sl/Dc0gteVYU2PTpYr+QOdyYPiPcbgoCPVzM1nVDVv
         SsrVdfaaxXYLTEVzyK9W4ZhXb7P4OlXoehm2fXXvG1Nzw4oLyjqV/bzMdkS+DXxIftQX
         dtmicFm4OrIKfmgkogO+tSb0QfwjBxLOSXcgOB8RQw6PVlATQ3H8r0zvuLFNZwL69ysZ
         kBArUOyZRMhe42ytZmyy36442sH+jdcDtv8f7mycQh5O+8UoDcWzLIbYWKiuXyHMc4dY
         /u5g==
X-Gm-Message-State: ACgBeo1lQPzQe+OzcyZvjU6XB2w4WvJvE6IWUzXwBZR6UrWg/jZbanpw
        Xk2LE9/nUqIUTpRs8uHiANxaiaCNv34=
X-Google-Smtp-Source: AA6agR5p6bLAaHP4BK4nkpmGHLX2evdc/vjlZeFHbfVFzktIGvIq4Olf5KelIBsXuWnLKqlLUcMNqA==
X-Received: by 2002:a05:600c:3ac9:b0:3a5:f114:1f8 with SMTP id d9-20020a05600c3ac900b003a5f11401f8mr5529558wms.204.1662203720554;
        Sat, 03 Sep 2022 04:15:20 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bdec:da00:8852:534c:71fa:beb4? (dynamic-2a01-0c23-bdec-da00-8852-534c-71fa-beb4.c23.pool.telefonica.de. [2a01:c23:bdec:da00:8852:534c:71fa:beb4])
        by smtp.googlemail.com with ESMTPSA id v14-20020a5d43ce000000b002253fd19a6asm4177938wrr.18.2022.09.03.04.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 04:15:19 -0700 (PDT)
Message-ID: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
Date:   Sat, 3 Sep 2022 13:15:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove not needed net_ratelimit() check
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're not in a hot path and don't want to miss this message,
therefore remove the net_ratelimit() check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8e1dae4de..52dacf59a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4573,8 +4573,7 @@ static void r8169_phylink_handler(struct net_device *ndev)
 		pm_runtime_idle(&tp->pci_dev->dev);
 	}
 
-	if (net_ratelimit())
-		phy_print_status(tp->phydev);
+	phy_print_status(tp->phydev);
 }
 
 static int r8169_phy_connect(struct rtl8169_private *tp)
-- 
2.37.3

