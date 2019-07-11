Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78466658C9
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 16:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfGKO2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 10:28:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:44004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728835AbfGKO1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D36AAE0C;
        Thu, 11 Jul 2019 14:27:54 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] libertas: add terminating entry to fw_table
Date:   Thu, 11 Jul 2019 16:27:44 +0200
Message-Id: <20190711142744.31956-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case no firmware was found, the system would happily read
and try to load garbage. Terminate the table properly.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: ce84bb69f50e6 ("libertas USB: convert to asynchronous firmware loading")
Reported-by: syzbot+8a8f48672560c8ca59dd@syzkaller.appspotmail.com
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index f1622f0ff8c9..b79c65547f4c 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -50,7 +50,10 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+
+	/*terminating entry - keep at end */
+	{ MODEL_8388, NULL, NULL }
 };
 
 static const struct usb_device_id if_usb_table[] = {
-- 
2.16.4

