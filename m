Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC80C65332C
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiLUPZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiLUPZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:47 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471B5B20
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d20so22556204edn.0
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+yme8fXO1k6A7s/D5dm0smB9lGyLseYaKaraSpk4eI=;
        b=y3tpr8tNDFKTiSH+l3HSSVqSypavIYRgUCdD5vQ90b36Z2HjfdRi6sguvae0ccMetm
         D2yr7MTF/FIPYmUNC1j2X4CZ3l8m5GovPkDvxcAQGoodopd9dzFpQ02ICNMxftef394x
         ceX50juaGs3TyrlQpoXFEuT5ddcpTtiLeCqJ//5mi7r9Zz0fy3LIOVYhC6Q+7Sy6ZLjo
         hDtWmHOoHxNlomdNzYOUByJAzuL3m+Plas1pxeoENGJ6vYkG2lKIGXoY72lvzf0SUTID
         FQ4A1ZKDYRcmTtPAj3d54ytgqrhR3zHdGbjFyVBspU4e00j/AUMUyZdIsDH0v2sQJgW8
         Eynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+yme8fXO1k6A7s/D5dm0smB9lGyLseYaKaraSpk4eI=;
        b=0JblEJLVXBR5OcIZOZ59muotjUQOFyLF8zoK9EtGzcc4jK9R0J2SQUPr4O7vdiw9ID
         d7Y4hEWESj63C6V7KHnPLPM8EuGAjoCOC5zNklbQeZZt7qSweC5mODLxGEVLNaHpJvDZ
         E7o0r46kOEVgwkSk5HxGci7T8tzuhPWd8ATk38b+K2KWJP8g3/TO1GYofy4UbBxGzyiN
         ndvxxKSfGGJ7CXuTQ0WJJMt0RFQr+8pZm+RZT5YR07af3ggvbKhUqOujFBKwfHUncVKi
         ppvqmRF2GHzYtM8zgsUQ3IKoA50twjHdHt7NhxeZcZdSLBur9pJ2k6/BetEdQNCu4rJ9
         J+VQ==
X-Gm-Message-State: AFqh2koqK7SOnsWyHrGCrMNlwZQfOXjLeqe2gzuE4CSz29codWcN4fDb
        L3P7geVCQ3rXFO8SiVClgZIVrw==
X-Google-Smtp-Source: AMrXdXsd8O5QTgH3RQbR4hfIkXviaUW64/PHpxvP7vKAL9gwSWAAh2wMODnt5wvoGJnzKZcAFx6iUw==
X-Received: by 2002:a50:e60b:0:b0:468:3252:370f with SMTP id y11-20020a50e60b000000b004683252370fmr1862773edm.34.1671636343675;
        Wed, 21 Dec 2022 07:25:43 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:43 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 03/18] can: m_can: Remove repeated check for is_peripheral
Date:   Wed, 21 Dec 2022 16:25:22 +0100
Message-Id: <20221221152537.751564-4-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge both if-blocks to fix this.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f3ee21ce6109..a43abc667757 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1568,10 +1568,8 @@ static int m_can_close(struct net_device *dev)
 		cdev->tx_skb = NULL;
 		destroy_workqueue(cdev->tx_wq);
 		cdev->tx_wq = NULL;
-	}
-
-	if (cdev->is_peripheral)
 		can_rx_offload_disable(&cdev->offload);
+	}
 
 	close_candev(dev);
 
-- 
2.38.1

