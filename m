Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2337495
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfFFM4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:56:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:55654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728175AbfFFM4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:56:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2790DAF42;
        Thu,  6 Jun 2019 12:56:08 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6/6] usb: hso: remove bogus check for EINPROGRESS
Date:   Thu,  6 Jun 2019 14:55:48 +0200
Message-Id: <20190606125548.18315-6-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190606125548.18315-1-oneukum@suse.com>
References: <20190606125548.18315-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This check makes no sense. It is an inherent race.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/hso.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 489024f0ae62..f7976a6fa570 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -845,8 +845,7 @@ static void hso_net_tx_timeout(struct net_device *net)
 	dev_warn(&net->dev, "Tx timed out.\n");
 
 	/* Tear the waiting frame off the list */
-	if (odev->mux_bulk_tx_urb &&
-	    (odev->mux_bulk_tx_urb->status == -EINPROGRESS))
+	if (odev->mux_bulk_tx_urb)
 		usb_unlink_urb(odev->mux_bulk_tx_urb);
 
 	/* Update statistics */
-- 
2.16.4

