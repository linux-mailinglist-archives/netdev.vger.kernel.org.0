Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600C4134425
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgAHNoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:44:22 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:47158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726556AbgAHNoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 08:44:22 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DAEC7D65DF3EF50D2D83;
        Wed,  8 Jan 2020 21:44:15 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 8 Jan 2020 21:44:09 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chenzhou10@huawei.com>
Subject: [PATCH next] igc: make non-global functions static
Date:   Wed, 8 Jan 2020 21:39:59 +0800
Message-ID: <20200108133959.93035-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:
drivers/net/ethernet/intel/igc/igc_ptp.c:512:6:
	warning: symbol 'igc_ptp_tx_work' was not declared. Should it be static?
drivers/net/ethernet/intel/igc/igc_ptp.c:644:6:
	warning: symbol 'igc_ptp_suspend' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 6935065..389a969 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -509,7 +509,7 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
  * This work function polls the TSYNCTXCTL valid bit to determine when a
  * timestamp has been taken for the current stored skb.
  */
-void igc_ptp_tx_work(struct work_struct *work)
+static void igc_ptp_tx_work(struct work_struct *work)
 {
 	struct igc_adapter *adapter = container_of(work, struct igc_adapter,
 						   ptp_tx_work);
@@ -641,7 +641,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
  * This function stops the overflow check work and PTP Tx timestamp work, and
  * will prepare the device for OS suspend.
  */
-void igc_ptp_suspend(struct igc_adapter *adapter)
+static void igc_ptp_suspend(struct igc_adapter *adapter)
 {
 	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
 		return;
-- 
2.7.4

