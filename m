Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85D5A6139
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiH3KzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiH3KzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:55:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D77459B4;
        Tue, 30 Aug 2022 03:55:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l5so6861855pjy.5;
        Tue, 30 Aug 2022 03:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=YkkKSKY+6i4yHV5ZW1S/rfBMmWbd8iaSJkFCcuATEeY=;
        b=p3cq/nRDe5bCHQpv+Q/v+EOxCWzkEjShDMWv1x80W2zx27nfFDt9XzgftCVbiiYSwV
         0XhKEKhquLDXtGPpaf/19mwDLY2OPH9qWQrCD8tOhOVvqK2mwrQEO4uuqPf4c58LJmu+
         cgQGEBp4NQkeyV49XnxU5u0Z81i+vGZ1XEpwHrM+WAUNRju3ngosUJkHvvPzo0T8FKPF
         q4V6g915bpJ8FWeUoxbXxUoMyNA0HNe5hg8hTi6a/vBGYszrNroZvLz/rQVyoCW2yuFR
         rM+DzlLODvcZCMiwYkdinn+D6MX1H4bEqadGhJ2kV8eg0tbAQF7yfqMRLbiLPNw3IHrV
         PKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=YkkKSKY+6i4yHV5ZW1S/rfBMmWbd8iaSJkFCcuATEeY=;
        b=wNRQY8v/ijsHOUCkJYLAmeGkiz0Bo3GV8jPGaBxzVJQxkUojnlT9dScf53Rl+sjaP/
         CfH61egqtCqYVcnLXuPR7cQWz+v30uWAVvLGnegntrgHdO4p4fpOsTs5US/YOn1VZHPb
         oLwic3gv8ZJAgObxmfhRoRy020Ak/r72k3E/eSnpeNtN/mFqzi+YAVAAT5ykKsK+TBh2
         DdRElvl+trYqD2I5SI0fxxr/UIaFtrF0VcD/3kQ4K1/M7XTPjs1tZ1gvRGmKPgmy/+a4
         BhR2eKoAQxTTt+l8csXZkytIgxPl2kFMPKrc7tAdAhLC5bZ+7yNQV5giCQCE+V/XALD/
         XGWQ==
X-Gm-Message-State: ACgBeo1Tlk2zSarx4b3d4Cph8tDIV2Osvc8TqDjfFa1wxmp8PYAyCg1P
        XL6ipjRSfxO7aSyi0pVMF6g=
X-Google-Smtp-Source: AA6agR7bl0WZTwMSAILTrpdXV8udJeu1bpiewwcHUflUMe66bj1Y/+sOb0UN6GOSl/1q99T91lqljw==
X-Received: by 2002:a17:90a:bd02:b0:1fd:d9b5:c6ce with SMTP id y2-20020a17090abd0200b001fdd9b5c6cemr8319660pjr.219.1661856911486;
        Tue, 30 Aug 2022 03:55:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m20-20020a656a14000000b0042a59ecdbdfsm1349459pgu.84.2022.08.30.03.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:55:11 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2 linux-next] wifi: wilc1000: remove redundant ret variable
Date:   Tue, 30 Aug 2022 10:55:05 +0000
Message-Id: <20220830105505.287564-1-cui.jinpeng2@zte.com.cn>
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

