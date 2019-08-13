Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E524C8B7D7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfHMMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:01:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727144AbfHMMB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 08:01:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5F8EAAFF5;
        Tue, 13 Aug 2019 12:01:25 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, dsd@gentoo.org,
        kune@deine-taler.de, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCHv2] zdnet: remove false assertion from zd_mac_clear()
Date:   Tue, 13 Aug 2019 14:01:18 +0200
Message-Id: <20190813120119.6043-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function is called before the lock which is asserted was ever used.
Just remove it.

V2: correct CCs

Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index da7e63fca9f5..a9999d10ae81 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -223,7 +223,6 @@ void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
 	zd_chip_clear(&mac->chip);
-	lockdep_assert_held(&mac->lock);
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-- 
2.16.4

