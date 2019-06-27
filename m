Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB8258477
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfF0OaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:30:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60145 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF0OaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:30:08 -0400
Received: from orion.localdomain ([77.7.61.149]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1M5fdC-1heqS92wkU-007ASL; Thu, 27 Jun 2019 16:30:03 +0200
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] drivers: net: wireless: rsi: return explicit error values
Date:   Thu, 27 Jun 2019 16:30:02 +0200
Message-Id: <1561645802-1279-1-git-send-email-info@metux.net>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K1:LD1XqncTtp4Z4IX2vE/ddO3xe3+A4yTOO84WkoCTzL4iY55/4EI
 IvYDyUIepL04Be8NzulLbuAO8xKrQHjFCrvhg03O+X5OlkfCMiuKc4ixdRKv/jWeK2TyAGp
 wLiSCwJfqg0JiYlt5i1AGpJFoysqyKc/dHPsbo25v3yMN67zdtTx2O7gz3WggstEPCfb3oB
 4M2VrucesCj2G8maAiQ+g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VX1ooUieOIM=:fRd9ZmsoM1/T5whX34GEcE
 nz1xYDLGuUfXhijW02HVftdL+eUaFMjDdppCX29QBN4YV+oGSaUzoO3dClTohbZbVo/uOM8fI
 rrOH/JMLj0LwB4JCgQK+1iR6o1jNxyLKC7mWo8yzXHmnzMdKzikwb7D4LPBjDW7SPQE6PR6I8
 Gjtlkb/DWa7z9VDsmqSw1idHT62vyixIgHGb7FlpXIxbsMIbXguxuaD6F/qcPFeKOwV6OEXHd
 H6hEggsGV9yB/eBA9qjxuNp5Ek3mt8TFZ01FohUTdtJaTgb96q2CWGYhcUOiVeQBkVOp0fdma
 tFJ7eO+uQpHVw4XXCMBFjzhPK9SHb94XMEc+0dNx2D6XfFTeyALFgQ9lrfKmDAwRLhdOhlYeD
 cub0g7WUVAY7QXrqqOC6t+D5d06/K5Sc3A2L9gjKfd/pE73ZiopLZFTk44jDrhsDXQwhjeelC
 O0YEUVR7riR8WB0Ki9yshlXeir0rjxr4Eb0AzbNAOVl1UCfk9fen7EXdUHDYO3CWA4Dl8Ngip
 IBj0DJNkD3Tyl4hWBsogKL667PbLnqkNbNj2bL8Xg0701QiKsylkeiaPLYRFU3jGOwCWHcCIS
 aLL2jozhYQdXd/Uqiya9+2Cfcqvyp3tgHe8xNWMQeXOROSLZDGgr0zNxWvieqr34BjY3HooI+
 aWc0uBRK90JYz9wiRX/Lw6Y0WBujloA2qCx1tWEDCb8JBC2ZtWgvnVy58rJBqQh6R9gy32BjT
 6l6SfZWXmR01HKlBsyV8os6hbGarnMXxfq7XaQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

Explicitly return constants instead of variable (and rely on
it to be explicitly initialized), if the value is supposed
to be fixed anyways. Align it with the rest of the driver,
which does it the same way.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b42cd50..2a3577d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -844,11 +844,11 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 				   struct sdio_func *pfunction)
 {
 	struct rsi_91x_sdiodev *rsi_91x_dev;
-	int status = -ENOMEM;
+	int status;
 
 	rsi_91x_dev = kzalloc(sizeof(*rsi_91x_dev), GFP_KERNEL);
 	if (!rsi_91x_dev)
-		return status;
+		return -ENOMEM;
 
 	adapter->rsi_dev = rsi_91x_dev;
 
@@ -890,7 +890,7 @@ static int rsi_init_sdio_interface(struct rsi_hw *adapter,
 #ifdef CONFIG_RSI_DEBUGFS
 	adapter->num_debugfs_entries = MAX_DEBUGFS_ENTRIES;
 #endif
-	return status;
+	return 0;
 fail:
 	sdio_disable_func(pfunction);
 	sdio_release_host(pfunction);
-- 
1.9.1

