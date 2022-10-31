Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A139613AD7
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiJaP4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiJaP4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:56:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358451262F;
        Mon, 31 Oct 2022 08:56:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a14so16605447wru.5;
        Mon, 31 Oct 2022 08:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yiIQqUgAicF1IqI0TD1/vWxeqEODaUy7zyfXvnZJius=;
        b=B4GLhZdBSMgf4MInk9YzxaAZdPHiTWlOPOIGf29fu2Y90nYFRbsxKO2toypxwyCT7y
         CGOGYT60OdC+G2F10/wvDJrR586+EKMUZONdyiv+Vs3AIKxD145/fOfMTmMQsDCxZ3Ot
         S4tHjP1JavUMCfi0p80zqozsY/gRwFvR7Xrl4nA9QUvSePyWOvkRQtFl1ZrcekZGMihJ
         sXLJiTjilWYsPTnkgRgNyMUyUAm76wI5f+FhveF0ulOIgw1QShKfo34EyFUqawJfA9Gz
         6/oTXtnaNXp5lxc6lvH4t3lvPxJxJH6t2dP8OcNdRZ8x0JURzm0gkr1UU6gzBgnVX6tE
         xiiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiIQqUgAicF1IqI0TD1/vWxeqEODaUy7zyfXvnZJius=;
        b=su/JP05BVcuvqoTRAXwHM8gHw9Au4P6dhfdVWF5g4SXpyLCD90CnqPEoOrkSNy9I1r
         LSMBv1uJZs+XHG13HXXZe80mDMbEPW/HPtKsmXXXu3656AQ9Lh3H1Ql1+170Y2kYH2fq
         IKPtg2vn//Ly6c94+QSTJMjMhZNalQZjFLvB35lhZ6LCHXXjFYPssLpHc08cl+8nCk21
         qZGoSATXX0k32M0axUjMFWK3YoKpIwVDbj4DcgK4li5/UxM58kTBReBO7Ld6XAh2N0/j
         ECae9XDLkxlJtKjlJyKzXoPRFw3El5QtC9xnYdmZOgu/GSFcfXkmafMQLck2C/NhycAP
         2Xlw==
X-Gm-Message-State: ACrzQf23IBf1kxinDtByGfr6ypjNwiTQHF5NXzD3/L1q8z7//SrG/G9H
        icbyNUkzfCc9Pa3jOkIyOKA=
X-Google-Smtp-Source: AMsMyM4/irtNqZnPzYVXBivUMUii0bMR2GOzaMUXE9e4uh5P3vwnckqqZANG/P8yFmPZyq7Uv3Ythw==
X-Received: by 2002:a05:6000:2c3:b0:236:dd92:16d1 with SMTP id o3-20020a05600002c300b00236dd9216d1mr912518wry.50.1667231798642;
        Mon, 31 Oct 2022 08:56:38 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c3b8a00b003cf71b1f66csm4077946wms.0.2022.10.31.08.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 08:56:37 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ee: remove static variable stop_report_cnt
Date:   Mon, 31 Oct 2022 15:56:37 +0000
Message-Id: <20221031155637.871164-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable stop_report_cnt is being set or incremented but is never
being used for anything meaningful. The variable and code relating
to it's use is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 8043d819fb85..a182cdeb58e2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -997,7 +997,6 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u16 read_point, write_point;
 	bool ret = false;
-	static u8 stop_report_cnt;
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
 
 	{
@@ -1038,13 +1037,6 @@ bool rtl92ee_is_tx_desc_closed(struct ieee80211_hw *hw, u8 hw_queue, u16 index)
 	    rtlpriv->psc.rfoff_reason > RF_CHANGE_BY_PS)
 		ret = true;
 
-	if (hw_queue < BEACON_QUEUE) {
-		if (!ret)
-			stop_report_cnt++;
-		else
-			stop_report_cnt = 0;
-	}
-
 	return ret;
 }
 
-- 
2.37.3

