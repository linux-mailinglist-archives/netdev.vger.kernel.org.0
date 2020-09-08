Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA3526091F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgIHDxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:53:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34288 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728327AbgIHDxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:53:07 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B35312A3C66C3DC1D735;
        Tue,  8 Sep 2020 11:53:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Sep 2020 11:53:00 +0800
From:   Wei Xu <xuwei5@hisilicon.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <xuwei5@hisilicon.com>,
        <linuxarm@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <john.garry@huawei.com>,
        <salil.mehta@huawei.com>, <shiju.jose@huawei.com>,
        <jinying@hisilicon.com>, <zhangyi.ac@huawei.com>,
        <liguozhu@hisilicon.com>, <tangkunshan@huawei.com>,
        <huangdaode@hisilicon.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net-next] net: smsc911x: Remove unused variables
Date:   Tue, 8 Sep 2020 11:49:25 +0800
Message-ID: <1599536965-162578-1-git-send-email-xuwei5@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/smsc/smsc911x.c: In function ‘smsc911x_rx_fastforward’:
 drivers/net/ethernet/smsc/smsc911x.c:1199:16: warning: variable ‘temp’ set but not used [-Wunused-but-set-variable]

 drivers/net/ethernet/smsc/smsc911x.c: In function ‘smsc911x_eeprom_write_location’:
 drivers/net/ethernet/smsc/smsc911x.c:2058:6: warning: variable ‘temp’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index fc168f8..823d9a7 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1196,9 +1196,8 @@ smsc911x_rx_fastforward(struct smsc911x_data *pdata, unsigned int pktwords)
 			SMSC_WARN(pdata, hw, "Timed out waiting for "
 				  "RX FFWD to finish, RX_DP_CTRL: 0x%08X", val);
 	} else {
-		unsigned int temp;
 		while (pktwords--)
-			temp = smsc911x_reg_read(pdata, RX_DATA_FIFO);
+			smsc911x_reg_read(pdata, RX_DATA_FIFO);
 	}
 }
 
@@ -2055,7 +2054,6 @@ static int smsc911x_eeprom_write_location(struct smsc911x_data *pdata,
 					  u8 address, u8 data)
 {
 	u32 op = E2P_CMD_EPC_CMD_ERASE_ | address;
-	u32 temp;
 	int ret;
 
 	SMSC_TRACE(pdata, drv, "address 0x%x, data 0x%x", address, data);
@@ -2066,7 +2064,7 @@ static int smsc911x_eeprom_write_location(struct smsc911x_data *pdata,
 		smsc911x_reg_write(pdata, E2P_DATA, (u32)data);
 
 		/* Workaround for hardware read-after-write restriction */
-		temp = smsc911x_reg_read(pdata, BYTE_TEST);
+		smsc911x_reg_read(pdata, BYTE_TEST);
 
 		ret = smsc911x_eeprom_send_cmd(pdata, op);
 	}
-- 
2.8.1

