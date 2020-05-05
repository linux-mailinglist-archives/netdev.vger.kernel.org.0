Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24461C4F84
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgEEHq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:46:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3409 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725833AbgEEHq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:46:57 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0C4A467DFD34D00D0C71;
        Tue,  5 May 2020 15:46:54 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:46:46 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <sumit.semwal@linaro.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: bnxt: Remove Comparison to bool in bnxt_ethtool.c
Date:   Tue, 5 May 2020 15:46:08 +0800
Message-ID: <20200505074608.22432-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c:1991:5-46: WARNING:
Comparison to bool
drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c:1993:10-54: WARNING:
Comparison to bool
drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c:2380:5-38: WARNING:
Comparison to bool

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 34046a6286e8..75f60aea8dec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1988,9 +1988,9 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
 			   rc, filename);
 		return rc;
 	}
-	if (bnxt_dir_type_is_ape_bin_format(dir_type) == true)
+	if (bnxt_dir_type_is_ape_bin_format(dir_type))
 		rc = bnxt_flash_firmware(dev, dir_type, fw->data, fw->size);
-	else if (bnxt_dir_type_is_other_exec_format(dir_type) == true)
+	else if (bnxt_dir_type_is_other_exec_format(dir_type))
 		rc = bnxt_flash_microcode(dev, dir_type, fw->data, fw->size);
 	else
 		rc = bnxt_flash_nvram(dev, dir_type, BNX_DIR_ORDINAL_FIRST,
@@ -2377,7 +2377,7 @@ static int bnxt_set_eeprom(struct net_device *dev,
 	}
 
 	/* Create or re-write an NVM item: */
-	if (bnxt_dir_type_is_executable(type) == true)
+	if (bnxt_dir_type_is_executable(type))
 		return -EOPNOTSUPP;
 	ext = eeprom->magic & 0xffff;
 	ordinal = eeprom->offset >> 16;
-- 
2.21.1

