Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED05F57E2
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 17:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJEP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJEP4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 11:56:02 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593A4792F2;
        Wed,  5 Oct 2022 08:56:01 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v130-20020a1cac88000000b003bcde03bd44so1260137wme.5;
        Wed, 05 Oct 2022 08:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8iRyDbr2Fao2IZ/++yFwguDpgiQWqWc7nZ9QJM6w5YQ=;
        b=K4j+mqNekxS2juIlcCqo6hEAeHhoFX/mKVwTSY0Cpz09LnVBs2VUyXrtC046TGI/71
         V67Qpz5Htr3x5WKJqZmajZBqs6cU1c3eqpGkQQngkiLXNzXOzozr4QEd2H5HxDZqLPWc
         4Uh9pXRkp2EgIyYH+dIZmKbE7CgP9HvH7rooZlVrizqAqkbOfvy1o9RtI17C/8tfMqCV
         2EpSUDZP+403vRURaT2e9spnrkCnOJQvfyVYju14GDrtoLAqTypUxBYwenvTSTAsYs/h
         drtqEdY0R1jliV5PWBt94hlfZ89z9/DZtnZUUBI7UllwoZYGAO/cihpghhhBS6NZ31RL
         mpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8iRyDbr2Fao2IZ/++yFwguDpgiQWqWc7nZ9QJM6w5YQ=;
        b=CttBn8JZWxRGyFoqfm9fgYXcWJRNW8PJdA7FMEZljDvYwLgABRYYOTu1ZuwUz+Euk3
         B7JX8OpMZ1I1NqtP10e00VFHgKZUnBIoLi8crTDJyC4d3QoUFqpSuNqMQQaeI2QBC8U3
         X4FuO8sMN0o1GDZy0jr54PHfLcmM5Oheg/zvqC862gz13pr3kEeUVdoQbUjK/ia2/E8P
         LiQVGQkw1Jvs6mFaOk9/s/3RcBpzSLN+I9EjjDmy+kV4Y8gh9J8X4FThTejgbbg2rzvY
         COL1DbqD2z7rm7Lypizn7LkTPjvzUPYmfexHpYeYJu4wk9MikOvWhieCIgpTXoLngAnd
         iUiA==
X-Gm-Message-State: ACrzQf1ILMDo1SCM1VAFSKYUx+6T5kCw1Z4E3sNtClwUwCUMchQGnjuB
        FNlya4vK+bOaBNBZKBxOppSxuMlesy1SBVeA
X-Google-Smtp-Source: AMsMyM5GMv1gas4MsYlqj0uFvpm5cOSxzOJd3Ban7D5L/2vYhJJrYdfZzWqHR3AMmek6LvK1VGf/sw==
X-Received: by 2002:a05:600c:4f13:b0:3b4:9a07:efdb with SMTP id l19-20020a05600c4f1300b003b49a07efdbmr177506wmq.94.1664985359918;
        Wed, 05 Oct 2022 08:55:59 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r6-20020a5d4986000000b0022ccae2fa62sm3429714wrq.22.2022.10.05.08.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 08:55:59 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Make arrays prof_prio and channelmap static const
Date:   Wed,  5 Oct 2022 16:55:58 +0100
Message-Id: <20221005155558.320556-1-colin.i.king@gmail.com>
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

Don't populate the read-only arrays prof_prio and channelmap
on the stack but instead make them static const. Also makes the
object code a little smaller.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 039bf0c35fbe..3363fc4e8966 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -266,7 +266,9 @@ static void ath_mci_set_concur_txprio(struct ath_softc *sc)
 			stomp_txprio[ATH_BTCOEX_STOMP_NONE] =
 				ATH_MCI_INQUIRY_PRIO;
 	} else {
-		u8 prof_prio[] = { 50, 90, 94, 52 };/* RFCOMM, A2DP, HID, PAN */
+		static const u8 prof_prio[] = {
+			50, 90, 94, 52
+		}; /* RFCOMM, A2DP, HID, PAN */
 
 		stomp_txprio[ATH_BTCOEX_STOMP_LOW] =
 		stomp_txprio[ATH_BTCOEX_STOMP_NONE] = 0xff;
@@ -644,7 +646,9 @@ void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	struct ath9k_channel *chan = ah->curchan;
-	u32 channelmap[] = {0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff};
+	static const u32 channelmap[] = {
+		0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff
+	};
 	int i;
 	s16 chan_start, chan_end;
 	u16 wlan_chan;
-- 
2.37.3

