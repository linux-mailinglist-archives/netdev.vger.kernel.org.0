Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E9C60FF06
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbiJ0RMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbiJ0RMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:12:34 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F12196080;
        Thu, 27 Oct 2022 10:12:32 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7A95A1B40;
        Thu, 27 Oct 2022 19:12:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1666890750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=87i5Q/0uCLplFlxSa2RqpYeR/VGW/CdY0QMvOH7duJY=;
        b=W9WOcfB74iGgKJf6WhT4vGsWSPMYYbvY2mcQ1JEPI0HpejFi1C1NM0+jL8UGfAqJE0MOtn
        umhC70yTv8xGHjKF83XBM6mej/u5qpZ5Z5ZpHat+f+rgRMLB5yN0mS97+icNP2l9CdoWWf
        Kbk9pWDUh2AFRAv+nIopArdBQ1RFQ0JAIjr+BF2wIGYy2B+GHzGI4V0lR3f/wxUbEKQsgg
        Jj0kmz8ov8uhFDhbnpqOd4IK8ZWmd2ib+byie4iFo6Z9aVe5DRpoY+wPH3xZi9LcJyUZG7
        DsEhNb2UuXi6OvJ8hzRMjAnNzMgDdOT48KiOhIni1FCR+9GeZ2KLEmx+n05ptQ==
From:   Michael Walle <michael@walle.cc>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        stable@vger.kernel.org
Subject: [PATCH] wifi: wilc1000: sdio: fix module autoloading
Date:   Thu, 27 Oct 2022 19:12:21 +0200
Message-Id: <20221027171221.491937-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are no SDIO module aliases included in the driver, therefore,
module autoloading isn't working. Add the proper MODULE_DEVICE_TABLE().

Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 7390f94cd4ca..a05bda7b9a3b 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MICROCHIP_WILC, SDIO_DEVICE_ID_MICROCHIP_WILC1000) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
-- 
2.30.2

