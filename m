Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FBC3B43A8
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 14:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhFYNBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 09:01:11 -0400
Received: from m12-12.163.com ([220.181.12.12]:38189 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229653AbhFYNBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 09:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=3KXI/
        viPQWubHjZ8/VUFgGSWBhnRPxP5F8dc26BSHrM=; b=gkI9e7r5N2UHito8f+pDr
        9vQkuOn44DiPg4gnxC6iSJVIcGkqGxcuJGV6W5an4ApAzWofFlL24Ls74WpbQghc
        mBL9ixzPkRXabfhhEQX2nLtofd+9qci8/dvctR6nUlfnPRICncAUtRKBCrT0QAUf
        jXQC+LAmULdGFco3ZxIXLc=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp8 (Coremail) with SMTP id DMCowABnhFkHyNVgSkfzLg--.11659S2;
        Fri, 25 Jun 2021 20:11:53 +0800 (CST)
From:   dingsenjie@163.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] wireless: marvell/libertas: Remove unnecessary label of lbs_ethtool_get_eeprom
Date:   Fri, 25 Jun 2021 20:11:08 +0800
Message-Id: <20210625121108.162868-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABnhFkHyNVgSkfzLg--.11659S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XF15CFWkZw4UuFW7JrW3Awb_yoW8JrW7pF
        WUC34DZr45ZF1qyan3Jan5AF95W3Z7t3sxKrWIk34rXr4rJrn5ZFnYgFy8ur45ZFW8ZFy2
        qF48Kr17A3WDG37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j9VyxUUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbiHgq1yFSIvSnxlgABsH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

The label is only used once, so we delete it and use the
return statement instead of the goto statement.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 drivers/net/wireless/marvell/libertas/ethtool.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/ethtool.c b/drivers/net/wireless/marvell/libertas/ethtool.c
index 1bb8746..d8e4f29 100644
--- a/drivers/net/wireless/marvell/libertas/ethtool.c
+++ b/drivers/net/wireless/marvell/libertas/ethtool.c
@@ -43,10 +43,8 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
 	int ret;
 
 	if (eeprom->offset + eeprom->len > LBS_EEPROM_LEN ||
-	    eeprom->len > LBS_EEPROM_READ_LEN) {
-		ret = -EINVAL;
-		goto out;
-	}
+	    eeprom->len > LBS_EEPROM_READ_LEN)
+		return -EINVAL;
 
 	cmd.hdr.size = cpu_to_le16(sizeof(struct cmd_ds_802_11_eeprom_access) -
 		LBS_EEPROM_READ_LEN + eeprom->len);
@@ -57,8 +55,7 @@ static int lbs_ethtool_get_eeprom(struct net_device *dev,
 	if (!ret)
 		memcpy(bytes, cmd.value, eeprom->len);
 
-out:
-        return ret;
+	return ret;
 }
 
 static void lbs_ethtool_get_wol(struct net_device *dev,
-- 
1.9.1


