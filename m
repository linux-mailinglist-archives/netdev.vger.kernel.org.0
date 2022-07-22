Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED43E57E16F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiGVMaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbiGVMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:30:19 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E9FE0E0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:30:09 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t3so5703819edd.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M+WvqbaFpPpGg91O1fVKyHX+g59A2oh+3eav6/3+mjU=;
        b=RolgvUGKU/Oww+066Om3j+mSOJxaKjTICUKNkhIgNPb7XaSAR+pKWuCdKUWr57rhZ0
         0l5D8lF43dr9s/Z3o1B00TQyG9s4D/gsfS4ocfFuWVEreY4tyamfeN0BLxpIX7VKMESG
         Oth4pmATrqRXXBDt1qRTYJBpD3Crj/VeebjWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+WvqbaFpPpGg91O1fVKyHX+g59A2oh+3eav6/3+mjU=;
        b=EJFi6FFqT8ujLqt/ruen+k6pAnuIk299Ko2nKsJpCZ05LXizKcMttHYtgMI52z7CVj
         KciYFRKtaQclKTasjbkWcvcfjrauBb9OfNh3wNyt5ORbW9hLXewsNypogGTtvxCYOKMn
         88rC1n3uzfYtsemSa0N+hqIOJHJ9rsxMvbePDcvb39Yz5TgKV9rJU8eGfxrvOJaQ6Bx4
         XpNm0zWhV88BcXSZJzKYm+R/kx+N2ohM0szNxzRrjFR2VtUfH80fp8wArk5R8jzHetR/
         TdHl9QfZ50nIEgp65XEiUIgcgHcLQV07otyx5GW+0wQMbZ2IRcHcvpKMI+rRJziNcI3X
         I4dQ==
X-Gm-Message-State: AJIora+WT2ttc0RRUfc5EjMSa+Bwu9/Lz4v+h5yqE0ovRhP0SrI9iIEa
        PgLm+gGrnzj1Ye2MfkdHs1oqtw==
X-Google-Smtp-Source: AGRyM1usxLZa8I/1EmNIa7uxFVGTc4tfKAIYw1LMOU0z4y9wLhiXDBeFLjIPWgqv4o1h9HdiThHJGA==
X-Received: by 2002:a05:6402:2405:b0:43a:86c6:862 with SMTP id t5-20020a056402240500b0043a86c60862mr431154eda.210.1658493008130;
        Fri, 22 Jul 2022 05:30:08 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id f6-20020a05640214c600b0043a6df72c11sm2462432edx.63.2022.07.22.05.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 05:30:07 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Soontak Lee <soontak.lee@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 1/2] brcmfmac: Support multiple AP interfaces and fix STA disconnection issue
Date:   Fri, 22 Jul 2022 14:29:54 +0200
Message-Id: <20220722122956.841786-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220722122956.841786-1-alvin@pqrs.dk>
References: <20220722122956.841786-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soontak Lee <soontak.lee@cypress.com>

Support multiple AP interfaces for STA + AP + AP usecase.
And fix STA disconnection when deactivating AP interface.

Signed-off-by: Soontak Lee <soontak.lee@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 48 +++++++++++++++----
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |  1 +
 .../broadcom/brcm80211/brcmfmac/common.c      |  5 ++
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3ae6779fe153..856fd5516ddf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4747,6 +4747,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		  settings->inactivity_timeout);
 	dev_role = ifp->vif->wdev.iftype;
 	mbss = ifp->vif->mbss;
+	brcmf_dbg(TRACE, "mbss %s\n", mbss ? "enabled" : "disabled");
 
 	/* store current 11d setting */
 	if (brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_REGULATORY,
@@ -4961,6 +4962,9 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	if ((err) && (!mbss)) {
 		brcmf_set_mpc(ifp, 1);
 		brcmf_configure_arp_nd_offload(ifp, true);
+	} else {
+		cfg->num_softap++;
+		brcmf_dbg(TRACE, "Num of SoftAP %u\n", cfg->num_softap);
 	}
 	return err;
 }
@@ -4975,6 +4979,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
 	struct brcmf_join_params join_params;
+	s32 apsta = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -4983,6 +4988,27 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev,
 		/* first to make sure they get processed by fw. */
 		msleep(400);
 
+		cfg->num_softap--;
+
+		/* Clear bss configuration and SSID */
+		bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
+		bss_enable.enable = cpu_to_le32(0);
+		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
+					       sizeof(bss_enable));
+		if (err < 0)
+			brcmf_err("bss_enable config failed %d\n", err);
+
+		memset(&join_params, 0, sizeof(join_params));
+		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
+					     &join_params, sizeof(join_params));
+		if (err < 0)
+			bphy_err(drvr, "SET SSID error (%d)\n", err);
+
+		if (cfg->num_softap) {
+			brcmf_dbg(TRACE, "Num of SoftAP %u\n", cfg->num_softap);
+			return 0;
+		}
+
 		if (profile->use_fwauth != BIT(BRCMF_PROFILE_FWAUTH_NONE)) {
 			if (profile->use_fwauth & BIT(BRCMF_PROFILE_FWAUTH_PSK))
 				brcmf_set_pmk(ifp, NULL, 0);
@@ -5000,17 +5026,18 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev,
 		if (ifp->bsscfgidx == 0)
 			brcmf_fil_iovar_int_set(ifp, "closednet", 0);
 
-		memset(&join_params, 0, sizeof(join_params));
-		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
-					     &join_params, sizeof(join_params));
-		if (err < 0)
-			bphy_err(drvr, "SET SSID error (%d)\n", err);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
-		if (err < 0)
-			bphy_err(drvr, "BRCMF_C_DOWN error %d\n", err);
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
+		err = brcmf_fil_iovar_int_get(ifp, "apsta", &apsta);
 		if (err < 0)
-			bphy_err(drvr, "setting AP mode failed %d\n", err);
+			brcmf_err("wl apsta failed (%d)\n", err);
+
+		if (!apsta) {
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
+			if (err < 0)
+				bphy_err(drvr, "BRCMF_C_DOWN error %d\n", err);
+			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
+			if (err < 0)
+				bphy_err(drvr, "Set AP mode error %d\n", err);
+		}
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
@@ -7641,6 +7668,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	cfg->wiphy = wiphy;
 	cfg->pub = drvr;
+	cfg->num_softap = 0;
 	init_vif_event(&cfg->vif_event);
 	INIT_LIST_HEAD(&cfg->vif_list);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index e90a30808c22..e4ebc2fa6ebb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -371,6 +371,7 @@ struct brcmf_cfg80211_info {
 	struct brcmf_cfg80211_wowl wowl;
 	struct brcmf_pno_info *pno;
 	u8 ac_priority[MAX_8021D_PRIO];
+	u8 num_softap;
 };
 
 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index fe01da9e620d..83e023a22f9b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -303,6 +303,11 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		brcmf_dbg(INFO, "CLM version = %s\n", clmver);
 	}
 
+	/* set apsta */
+	err = brcmf_fil_iovar_int_set(ifp, "apsta", 1);
+	if (err)
+		brcmf_info("failed setting apsta, %d\n", err);
+
 	/* set mpc */
 	err = brcmf_fil_iovar_int_set(ifp, "mpc", 1);
 	if (err) {
-- 
2.37.0

