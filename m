Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898EB5B5596
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiILHyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 03:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiILHye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:54:34 -0400
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FAC1E4;
        Mon, 12 Sep 2022 00:54:26 -0700 (PDT)
Received: by mail-pf1-f193.google.com with SMTP id j12so7807014pfi.11;
        Mon, 12 Sep 2022 00:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lJBwS02KAdobM2rJ9xyt/rRL/BLUdzQqKDAHOmdhQwE=;
        b=q1voRHu/CaI5b77mNBYkB7BB7CFfDJq+jMchUAzJ+rj5u4JhtXeVEvUy16DCwo1Lv3
         nFLoeX75cz68TAi6tUZtyeYGlwddE9moFYB+sfN0e9lL+iAOpJCRYVgCi4aZ8OLZ8y9Y
         1YGEaUqv0enQI0OKFuijLIs7P6PZjCgEL9bEUdyWPOmGL9wr5o0lHjIoHR379QyXEgzi
         Ae7EBLUtw8PJE8AsIb0P0z63eDqaO7NL0HPp4SeoKBVfxNcxguNA7zrFF40EPI2LhZz+
         Lk20/1w1TauVxo7mX1wLAxEDxzwkt/prD6E9gBnj0xM6J2E3BhuP7PWYlqjoEGiXHd7P
         Jdhw==
X-Gm-Message-State: ACgBeo1hUIoyDbKqT9QR6GwF1IGqJHchVMdi0/HYyuC1oJuh8yI9bzFp
        tbXX6KRZAc7646sCeMyCKQ==
X-Google-Smtp-Source: AA6agR4Ga+Y074cdgGWUIfmU9FKdwW2HXPR5Xd23tiKFreNI52KKWUEJpeh/rZ94GGbGKW1uzE7WfA==
X-Received: by 2002:a05:6a00:ac4:b0:535:c08:2da7 with SMTP id c4-20020a056a000ac400b005350c082da7mr26653838pfl.69.1662969266309;
        Mon, 12 Sep 2022 00:54:26 -0700 (PDT)
Received: from localhost.localdomain ([156.146.53.107])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709029b8e00b001745919b197sm5187970plp.243.2022.09.12.00.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 00:54:25 -0700 (PDT)
From:   sunliming <sunliming@kylinos.cn>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kelulanainsley@gmail.com, sunliming <sunliming@kylinos.cn>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH RESEND] wifi rtw89: coex: fix for variable set but not used warning
Date:   Mon, 12 Sep 2022 15:54:18 +0800
Message-Id: <20220912075418.1459127-1-sunliming@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below kernel warning:
drivers/net/wireless/realtek/rtw89/coex.c:3244:25: warning: variable 'cnt_connecting'
set but not used [-Wunused-but-set-variable]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 683854bba217..ee4817358c35 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3290,7 +3290,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev)
 	struct rtw89_btc_wl_link_info *wl_linfo = wl->link_info;
 	struct rtw89_btc_wl_role_info *wl_rinfo = &wl->role_info;
 	struct rtw89_btc_wl_dbcc_info *wl_dinfo = &wl->dbcc_info;
-	u8 i, cnt_connect = 0, cnt_connecting = 0, cnt_active = 0;
+	u8 i, cnt_connect = 0, cnt_active = 0;
 	u8 cnt_2g = 0, cnt_5g = 0, phy;
 	u32 wl_2g_ch[2] = {0}, wl_5g_ch[2] = {0};
 	bool b2g = false, b5g = false, client_joined = false;
@@ -3324,9 +3324,7 @@ static void _update_wl_info(struct rtw89_dev *rtwdev)
 
 		if (wl_linfo[i].connected == MLME_NO_LINK) {
 			continue;
-		} else if (wl_linfo[i].connected == MLME_LINKING) {
-			cnt_connecting++;
-		} else {
+		} else if (wl_linfo[i].connected != MLME_LINKING) {
 			cnt_connect++;
 			if ((wl_linfo[i].role == RTW89_WIFI_ROLE_P2P_GO ||
 			     wl_linfo[i].role == RTW89_WIFI_ROLE_AP) &&
-- 
2.25.1

