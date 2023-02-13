Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6761D69457D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBMML6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjBMMLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:11:08 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657671BE;
        Mon, 13 Feb 2023 04:10:42 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id 73B2ABA18BF;
        Mon, 13 Feb 2023 13:09:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676290173;
        bh=XI7gUu/J8R03sEmkggazfxi5UIEjFaUpF2GfWUJIa30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jM4Uj1FbHfEXciIJZpCdIV2AavqGCPG6vTSaTDvwiSPIlb73f4+AYu0D++td5J3rs
         4PqtjSt+er1OxqJfpUUKNy/zk962tTAPsjv+gnO/Pegmt1solnGtWB87bkEu6TgkJ8
         UQ07a1RKbREeK5jljJQEMBCvBWAuS5CCsbjEvDOwnRXfUYMFiPJwcMbktH24BZ8Fld
         eqj8b5claZPKTrW2ElCg4Um1P9JWHh5wxuTuH8YXNXIgFEY/dXCDjKX7pMclCwLH/y
         SDLTfyFOHHmF6apXHnyxviinUU1qZkHF9DDAZ8ImfeBdCCNz0Ex5kjC4AuVDPO3jhk
         E1MrOe8vO64Mw==
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
Subject: [PATCH v3 3/5] Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
Date:   Mon, 13 Feb 2023 13:09:24 +0100
Message-Id: <20230213120926.8166-4-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213120926.8166-1-francesco@dolcini.it>
References: <20230213120926.8166-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
v3: no changes
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

