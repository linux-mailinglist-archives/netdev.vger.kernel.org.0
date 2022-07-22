Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1EB57E16C
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiGVMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbiGVMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:30:20 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD5F1902C
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:30:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bp15so8339989ejb.6
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 05:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5lqye/hAmqL8Fnt3guUNsgTywC89s6aIPDnodlDq5eQ=;
        b=Gnx8GXRDxk9/3ygHEnLtTVN8bhhXjnkpykXfjNntr1aau+1ER5I1ZxMEx28Jvpa4gh
         6Qv9UVVNEb5bNfp7EIkgCPufTHaEgD6Cg/jgkMLSD3L89oOKlbIAVQmW3CerogUZkFjl
         ySB4vo5Wk/ppKJPITbE5ztK0zU+Jx71WeNjMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5lqye/hAmqL8Fnt3guUNsgTywC89s6aIPDnodlDq5eQ=;
        b=odAfoqYyEzoZLLodAcc79/FH3+LjxMsXMSXq5KKPgyetAKPCjUDlLjKg7QUbvb7RM1
         MhZJM/p4H3PwUJlSN+RqYbuV2z1VP7ntEnYjfYxUb1qXxPudjZ0HMZckkEBEuB43Gb/f
         Z7ZVsU91n04CsGHcSFadRslniO0zl0ZAf3S62bcCvo9HwSH/9qOWDL9CfrrLsZXIo9Zm
         1efx8O98spbbMwvIdaw3c+i14twpe3T7qKZ2zP5msfXRDZE8BBnRmfu6OYjvxABpkr58
         B1qoTAszS1XYPLoI75PxFm1ihqrd+DYSvGS3NlqqXr9fUSaa/FCXxQNOxsTRabMPSl2p
         R0SA==
X-Gm-Message-State: AJIora+UpdqoPYzxFiY4AAGmPUQP3nmAqKmUO1JKzEAAZ9i1B/k/kXlu
        NZnBnYcDuDbAsiNfC/5sgueahQ==
X-Google-Smtp-Source: AGRyM1v8ZZae8J7XVlQt6nOJwIGs8hqXBlcz5gENhw9RMFYyE+838PT+92etYbxcbxRe85a5a6yIew==
X-Received: by 2002:a17:907:2cd4:b0:72b:7fa8:eafc with SMTP id hg20-20020a1709072cd400b0072b7fa8eafcmr314478ejc.438.1658493009879;
        Fri, 22 Jul 2022 05:30:09 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id f6-20020a05640214c600b0043a6df72c11sm2462432edx.63.2022.07.22.05.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 05:30:09 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ting-Ying Li <tingying.li@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 2/2] brcmfmac: don't allow arp/nd offload to be enabled if ap mode exists
Date:   Fri, 22 Jul 2022 14:29:55 +0200
Message-Id: <20220722122956.841786-3-alvin@pqrs.dk>
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

From: Ting-Ying Li <tingying.li@cypress.com>

Add a condition to determine whether arp/nd offload enabling
request is allowed. If there is any interface acts as ap
mode and is operating, then reject the request of arp oflload
enabling from cfg80211.

Signed-off-by: Ting-Ying Li <tingying.li@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c      | 17 ++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h      |  1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c |  5 +++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 856fd5516ddf..29aa7613bcf3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -770,6 +770,21 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 	}
 }
 
+bool brcmf_is_apmode_operating(struct wiphy *wiphy)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_vif *vif;
+	bool ret = false;
+
+	list_for_each_entry(vif, &cfg->vif_list, list) {
+		if (brcmf_is_apmode(vif) &&
+		    test_bit(BRCMF_VIF_STATUS_AP_CREATED, &vif->sme_state))
+			ret = true;
+	}
+
+	return ret;
+}
+
 s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort)
@@ -5057,8 +5072,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev,
 			bphy_err(drvr, "bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ifp, 1);
-	brcmf_configure_arp_nd_offload(ifp, true);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
+	brcmf_configure_arp_nd_offload(ifp, true);
 	brcmf_net_setcarrier(ifp, false);
 
 	return err;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index e4ebc2fa6ebb..3133b6509870 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -468,5 +468,6 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 void brcmf_set_mpc(struct brcmf_if *ndev, int mpc);
 void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg);
 void brcmf_cfg80211_free_netdev(struct net_device *ndev);
+bool brcmf_is_apmode_operating(struct wiphy *wiphy);
 
 #endif /* BRCMFMAC_CFG80211_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 87aef211b35f..ab5ed4a9e57a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -97,6 +97,11 @@ void brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
 	s32 err;
 	u32 mode;
 
+	if (enable && brcmf_is_apmode_operating(ifp->drvr->wiphy)) {
+		brcmf_dbg(TRACE, "Skip ARP/ND offload enable when soft AP is running\n");
+		return;
+	}
+
 	if (enable)
 		mode = BRCMF_ARP_OL_AGENT | BRCMF_ARP_OL_PEER_AUTO_REPLY;
 	else
-- 
2.37.0

