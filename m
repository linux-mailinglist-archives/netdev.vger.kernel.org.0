Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1392651C0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgIJVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:01:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12217 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730993AbgIJOpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DD6926A6D308E9EA3F40;
        Thu, 10 Sep 2020 21:52:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:52:22 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 2/3] rtlwifi: rtl8188ee: fix comparison pointer to bool warning in trx.c
Date:   Thu, 10 Sep 2020 21:59:16 +0800
Message-ID: <20200910135917.143723-3-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200910135917.143723-1-zhengbin13@huawei.com>
References: <20200910135917.143723-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:735:5-9: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:776:5-9: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index 8f7689225393..b9775eec4c54 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -732,7 +732,7 @@ void rtl88ee_set_desc(struct ieee80211_hw *hw, u8 *pdesc8,
 {
 	__le32 *pdesc = (__le32 *)pdesc8;

-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			set_tx_desc_own(pdesc, 1);
@@ -773,7 +773,7 @@ u64 rtl88ee_get_desc(struct ieee80211_hw *hw,
 	u32 ret = 0;
 	__le32 *pdesc = (__le32 *)pdesc8;

-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			ret = get_tx_desc_own(pdesc);
--
2.26.0.106.g9fadedd

