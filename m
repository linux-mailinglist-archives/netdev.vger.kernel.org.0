Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A381B57E106
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiGVL5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbiGVL5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:57:02 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186DA9D1F9
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:57:00 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t3so5598949edd.0
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 04:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=flnEvotZidaUh2ykk93snCPMpbwPpMdDiRUs0F6eFEc=;
        b=Z6SfeP8zsYcJua2iTIQeZidzdyHntaXwsRbowZ7wR2rGGaujqr2+mDU88XYuiwUBD/
         bNxPs/fLEpfyBMPa42WlZXmp2Nslb7bqnMpqo70+FQBVckDSgAhrA6PVgtnBV+V75ane
         6vvH1huOD+yEuf8CiQ1EQSX/rYqyYpAZaLH1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=flnEvotZidaUh2ykk93snCPMpbwPpMdDiRUs0F6eFEc=;
        b=Sr+GMUH7LvYeeo7t13PdxuR1McRnlcfYwHPebq2VPDUp7UxDb/7u+NcNMLkSa+6nYB
         e/8zuWEdf5gYe7wQUye933YIBycRrkzCyL62/wAyQxxQri+nTNwR+x7LfVNF5gC8SMef
         vD0YrBNgopNKF61hwUV+8W593nQXNNAcXf7rz+5xYA5OMrn7pIOj8vAF1TiFapEO03T5
         J9V/t5pHNzMABNMwoie9KwW/ozg1NSOGPJlEx1ZR+AJCqmHR3rzZGlEewnG3SAbXHqkE
         yr854gQbh9qHBwy5CMLbPl3ciRa3XLxuRSiq5gmDb77OqmQ5GwQKIAsoujzKE/zEwLHp
         hqaw==
X-Gm-Message-State: AJIora8ejqhSeg1dTenYwK8Q0lWEVI/flJrr2ytLsvMCWDLkN5RHFwpw
        f7QmYJDmI2Lz3cKerTchqdqDew==
X-Google-Smtp-Source: AGRyM1vURj2VAwzGo07/a5qNyG8Qpq1IH/QMoTDEVKfcuwz69Cs5aCxc6iH2rOLcwmbtCV9HVOtKUQ==
X-Received: by 2002:a05:6402:2789:b0:43a:de54:40fd with SMTP id b9-20020a056402278900b0043ade5440fdmr234482ede.319.1658491018561;
        Fri, 22 Jul 2022 04:56:58 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id kx6-20020a170907774600b0072b3182368fsm1934370ejc.77.2022.07.22.04.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 04:56:58 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Wataru Gohda <wataru.gohda@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] brcmfmac: Fix to add skb free for TIM update info when tx is completed
Date:   Fri, 22 Jul 2022 13:56:30 +0200
Message-Id: <20220722115632.620681-6-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220722115632.620681-1-alvin@pqrs.dk>
References: <20220722115632.620681-1-alvin@pqrs.dk>
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

From: Wataru Gohda <wataru.gohda@cypress.com>

The skb will be allocated to send TIM update info in brcmf_fws_tim_update.
Currently the skb will be freed when tx is failed but it will not be freed
when tx is completed successfully. The fix is to free the skb when tx is
completed always.

Signed-off-by: Wataru Gohda <wataru.gohda@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c  |  3 +--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c       | 16 ++++++++++------
 .../broadcom/brcm80211/brcmfmac/fwsignal.h       |  3 ++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 2c95a08a5871..02a56edf08ba 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -368,8 +368,7 @@ brcmf_proto_bcdc_txcomplete(struct device *dev, struct sk_buff *txp,
 
 	/* await txstatus signal for firmware if active */
 	if (brcmf_fws_fc_active(bcdc->fws)) {
-		if (!success)
-			brcmf_fws_bustxfail(bcdc->fws, txp);
+		brcmf_fws_bustxcomplete(bcdc->fws, txp, success);
 	} else {
 		if (brcmf_proto_bcdc_hdrpull(bus_if->drvr, false, txp, &ifp))
 			brcmu_pkt_buf_free_skb(txp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index d58525ebe618..85e3b953b0a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -2475,7 +2475,8 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 	return fws->fcmode != BRCMF_FWS_FCMODE_NONE;
 }
 
-void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
+void brcmf_fws_bustxcomplete(struct brcmf_fws_info *fws, struct sk_buff *skb,
+			     bool success)
 {
 	u32 hslot;
 
@@ -2483,11 +2484,14 @@ void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
-	brcmf_fws_lock(fws);
-	hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
-	brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot, 0, 0,
-			      1);
-	brcmf_fws_unlock(fws);
+
+	if (!success) {
+		brcmf_fws_lock(fws);
+		hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+		brcmf_fws_txs_process(fws, BRCMF_FWS_TXSTATUS_HOST_TOSSED, hslot,
+				      0, 0, 1);
+		brcmf_fws_unlock(fws);
+	}
 }
 
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
index b16a9d1c0508..f9c36cd8f1de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h
@@ -40,7 +40,8 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_fws_reset_interface(struct brcmf_if *ifp);
 void brcmf_fws_add_interface(struct brcmf_if *ifp);
 void brcmf_fws_del_interface(struct brcmf_if *ifp);
-void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb);
+void brcmf_fws_bustxcomplete(struct brcmf_fws_info *fws, struct sk_buff *skb,
+			     bool success);
 void brcmf_fws_bus_blocked(struct brcmf_pub *drvr, bool flow_blocked);
 void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *skb);
 
-- 
2.37.0

