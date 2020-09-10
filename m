Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34162647F5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbgIJO0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 10:26:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56966 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730068AbgIJOK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:10:27 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 96CF9103931C117F82CF;
        Thu, 10 Sep 2020 22:09:57 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:09:47 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 2/3] rtlwifi: rtl8723ae: fix comparison pointer to bool warning in trx.c
Date:   Thu, 10 Sep 2020 22:16:41 +0800
Message-ID: <20200910141642.127006-3-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200910141642.127006-1-zhengbin13@huawei.com>
References: <20200910141642.127006-1-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c:592:5-9: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c:633:5-9: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 159f86e665f9..e3ee91b7ea8d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -589,7 +589,7 @@ void rtl8723e_set_desc(struct ieee80211_hw *hw, u8 *pdesc8,
 {
 	__le32 *pdesc = (__le32 *)pdesc8;

-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			set_tx_desc_own(pdesc, 1);
@@ -630,7 +630,7 @@ u64 rtl8723e_get_desc(struct ieee80211_hw *hw,
 	u32 ret = 0;
 	__le32 *pdesc = (__le32 *)pdesc8;

-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			ret = get_tx_desc_own(pdesc);
--
2.26.0.106.g9fadedd

