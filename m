Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E8A215C14
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgGFQmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:42:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34641 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgGFQmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:42:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jsUCX-0001cA-6c; Mon, 06 Jul 2020 16:42:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: mcba_usb: remove redundant initialization of variable err
Date:   Mon,  6 Jul 2020 17:42:40 +0100
Message-Id: <20200706164240.518623-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is never read
and it is being updated later with a new value.  The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/can/usb/mcba_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 21faa2ec4632..37ab3de43acc 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -793,7 +793,7 @@ static int mcba_usb_probe(struct usb_interface *intf,
 {
 	struct net_device *netdev;
 	struct mcba_priv *priv;
-	int err = -ENOMEM;
+	int err;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
 
 	netdev = alloc_candev(sizeof(struct mcba_priv), MCBA_MAX_TX_URBS);
-- 
2.27.0

