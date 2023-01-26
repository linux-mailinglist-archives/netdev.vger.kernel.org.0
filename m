Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA0767C510
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbjAZHpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbjAZHpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:45:21 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B77266EDF;
        Wed, 25 Jan 2023 23:45:13 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 1990F5612C2;
        Thu, 26 Jan 2023 08:45:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674719109;
        bh=4edNf8hDVsHhrnz0fKugX0626QqWgyq6YjRr6TulDJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=uDMM+5xmu/TP/EZafXt69VRYkK3eQEOANozP4SUYP9qA7zeT3/sTfig1FmmNmdJcf
         F7LXFACB4eNswuaZFcs/mdPm1hGFt19dfKyrZ88x+V2+h4beHsgdxEvJa31PL6Trcj
         H6yfpd9NC1gl15Kb2Q5HNzQGHdy7wh9hy4RjhujbDU5z4KHpva5zMeYEm0WxhTr2Yp
         smUg8dltKGq8Yj7N5l0G+3YQAmzc95BSexmLy5deAiyyoZZdVZNxDN4eMmXJyXcFqg
         aLEFPkuAwNYb/B6JgG8jG7y7SqpujnHdnJDi+wGcfolhR4m3XWqIiZVIUVBF3/AFpg
         f7UCjiSriPs+Q==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v2 3/5] Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
Date:   Thu, 26 Jan 2023 08:43:54 +0100
Message-Id: <20230126074356.431306-4-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230126074356.431306-1-francesco@dolcini.it>
References: <20230126074356.431306-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

Use the maybe_unused macro for the device tree ids instead of #ifdef
CONFIG_OF. This makes it easier to add support for new devices.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
v2: new patch
---
 drivers/bluetooth/hci_mrvl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_mrvl.c b/drivers/bluetooth/hci_mrvl.c
index fbc3f7c3a5c7..eaa9c51cacfa 100644
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -414,13 +414,11 @@ static void mrvl_serdev_remove(struct serdev_device *serdev)
 	hci_uart_unregister_device(&mrvldev->hu);
 }
 
-#ifdef CONFIG_OF
-static const struct of_device_id mrvl_bluetooth_of_match[] = {
+static const struct of_device_id __maybe_unused mrvl_bluetooth_of_match[] = {
 	{ .compatible = "mrvl,88w8897" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, mrvl_bluetooth_of_match);
-#endif
 
 static struct serdev_device_driver mrvl_serdev_driver = {
 	.probe = mrvl_serdev_probe,
-- 
2.25.1

