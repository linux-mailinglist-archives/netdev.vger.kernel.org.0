Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357EB55E603
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346801AbiF1NoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346711AbiF1NoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:44:19 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E982A976
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 06:44:18 -0700 (PDT)
X-QQ-mid: bizesmtp64t1656423844t3a26bay
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 28 Jun 2022 21:44:02 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000C00A0000000
X-QQ-FEAT: ZHWZeLXy+8dNqmTeNYcSBLpGb3yyRxv7f+CJdSU4W2HelncSAvCniH4VuIENT
        1mE15xcwRwaP95h6+FBOLhgSrRZe72qxfFnuvssqqmST7yNU5vg2OLv3akpisxZXBKy2+IM
        5Q/8rSd8MnzbZfmCOp1gqa9emAYaXk3NzdjcDaEIDrL3cn3VSVtcaUAEyB/PnEX0dLuBdPe
        w62rUBSxyST4G3PZRklK7Iz7vKloDE0Pv8NFYK44E5dAZeihAtumhu1lyups9C0jqLLAw2e
        SBcoPIohJVrBdCaeHXoysq4EN3jOyIt0w4lliWM+iSd7eCit/xRvnlVEUcAy1s8q8mfliP9
        WWGxguO3QTsfkVekKl1wfPfdWnKnyao5OfS8OvXu2XqOWignTW2Hq3oOBaRgJEdCVDlCcZM
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stable@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.10 v2 2/3] commit b789e3fe7047 ("rtw88: 8821c: support RFE type4 wifi NIC")
Date:   Tue, 28 Jun 2022 21:43:50 +0800
Message-Id: <20220628134351.4182-2-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628134351.4182-1-tangmeng@uniontech.com>
References: <20220628134351.4182-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign10
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo-Feng Fan <vincent_fann@realtek.com>

RFE type4 is a new NIC which has one RF antenna shares with BT.
RFE type4 HW is the same as RFE type2 but attaching antenna to
aux antenna connector.

RFE type2 attach antenna to main antenna connector.
Load the same parameter as RFE type2 when initializing NIC.

Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210922023637.9357-1-pkshih@realtek.com
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 4514c4e8ee58..9c8fbc96f536 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -300,7 +300,8 @@ static void rtw8821c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	if (channel <= 14) {
 		if (rtwdev->efuse.rfe_option == 0)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2)
+		else if (rtwdev->efuse.rfe_option == 2 ||
+			 rtwdev->efuse.rfe_option == 4)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
@@ -737,6 +738,15 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 	if (switch_status == coex_dm->cur_switch_status)
 		return;
 
+	if (coex_rfe->wlg_at_btg) {
+		ctrl_type = COEX_SWITCH_CTRL_BY_BBSW;
+
+		if (coex_rfe->ant_switch_polarity)
+			pos_type = COEX_SWITCH_TO_WLA;
+		else
+			pos_type = COEX_SWITCH_TO_WLG_BT;
+	}
+
 	coex_dm->cur_switch_status = switch_status;
 
 	if (coex_rfe->ant_switch_diversity &&
@@ -1457,6 +1467,7 @@ static const struct rtw_intf_phy_para_table phy_para_table_8821c = {
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.20.1



