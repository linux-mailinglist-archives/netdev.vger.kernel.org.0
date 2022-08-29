Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69035A4A2A
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 13:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbiH2Leg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiH2LeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 07:34:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B13BEC;
        Mon, 29 Aug 2022 04:19:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y127so7850069pfy.5;
        Mon, 29 Aug 2022 04:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YkkKSKY+6i4yHV5ZW1S/rfBMmWbd8iaSJkFCcuATEeY=;
        b=LInHvVBeUEexcOe/cX62gE+S/tEsoIUhf5PfXek7gDmcpdHcmB40THnsBm3nkY7i42
         PryYhkkbIFqL4OGyJLNDa73lkcLq+xAxI2U1LjGnFCj7v7/xbSBUzVZjViXpoJtRQCs3
         zjKMT5dvbxd4kQv8x1B1gEXNiNlLEIl6+EwFKHY+S9GTUJBxzqdJF+eekIOJ8NT/pJp+
         m6yneZAuCLkqeYRI/uvhfdQvseUyElfBTxuc0kiPPMCkMtV7DB2CKxqYMCBx1sQaayb4
         XSpr/y1Rf4HW3CFFagStmJ6XGL8LubHgtGL+VZk33fUx+Nucwg61QcrlA8DX360dNKb2
         6nGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YkkKSKY+6i4yHV5ZW1S/rfBMmWbd8iaSJkFCcuATEeY=;
        b=e1PkLzw2bKxvAnEjIOjCB49fs8MCsHy/HCtY7JGtVRzhnc+fSBf5pgxNc94Pxfs+tp
         w1BBhf5uWOCAPtbdzNUzmXtD0mMCqifLfmYmb+qepfpd3F3kslIPi1h9mHzaFpOi8b+c
         50Y5jbPq5BeWnoYIjozEeuW9hZ1FiGxE45lsqvPptFNjcGNru6UNbsUnHxjP6bFPX0dm
         YahmwXDAGnK/TWhGwzhplVjBnZD3FekiMBelCEMucIOSZkM0G0O+BMZVHdiEnoOtJWrO
         DPtMaCNqfscqo1MHiHMdjo2Ssgx+TE7JSvKDHgB9cwfialu87Ti9tU5DZ0n6oAfhWI0x
         LD0Q==
X-Gm-Message-State: ACgBeo0A3oTtwhJVa3m57u0AT641g/T14ocCgm9Jnl0p0kIuo33Rhzsy
        RmZLhjnyt5YwASIs5paODbk=
X-Google-Smtp-Source: AA6agR7xoTZyJARGoWnaR8u6bIBcsAd0Tzd/NjaSus665bhBHmI7yO+ibqo0VXy0LEVbBKZytfMQHw==
X-Received: by 2002:a05:6a00:10d3:b0:4fe:5d:75c8 with SMTP id d19-20020a056a0010d300b004fe005d75c8mr16371630pfu.6.1661771835532;
        Mon, 29 Aug 2022 04:17:15 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903120f00b00174a8d357b7sm3062421plh.20.2022.08.29.04.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:17:15 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] wifi: cfg80211: remove redundant ret variable
Date:   Mon, 29 Aug 2022 11:16:44 +0000
Message-Id: <20220829111643.266866-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value from cfg80211_rx_mgmt() directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index f810a56a7ff0..b89047965e78 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -997,12 +997,11 @@ bool wilc_wfi_mgmt_frame_rx(struct wilc_vif *vif, u8 *buff, u32 size)
 {
 	struct wilc *wl = vif->wilc;
 	struct wilc_priv *priv = &vif->priv;
-	int freq, ret;
+	int freq;
 
 	freq = ieee80211_channel_to_frequency(wl->op_ch, NL80211_BAND_2GHZ);
-	ret = cfg80211_rx_mgmt(&priv->wdev, freq, 0, buff, size, 0);
 
-	return ret;
+	return cfg80211_rx_mgmt(&priv->wdev, freq, 0, buff, size, 0);
 }
 
 void wilc_wfi_p2p_rx(struct wilc_vif *vif, u8 *buff, u32 size)
-- 
2.25.1

