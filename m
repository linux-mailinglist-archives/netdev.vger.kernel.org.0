Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9264F5A7EA3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiHaNXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHaNXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:23:05 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF57A2856;
        Wed, 31 Aug 2022 06:23:04 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 72so14389958pfx.9;
        Wed, 31 Aug 2022 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=GSBS1LQcbgyhNQw5aYu+ifT22UvTNUJPKtaTUkIicrE=;
        b=dHDe1xGB+PNE3nj1UIoOqRGuf6PzJJ7Ffj+Hr5+399Hx3MT2pGD/iAoy/NKn9zcy7Z
         WhreKBHworXHvjh75ZDASlCD77Pfz8532BFdjIB625m6guswJUdhVw76ELgfHrcoczlB
         14YvPDzekLXteWlGohqiij4gtam9sf6fllcvEJqgWjd7vT+z8E8C+fPOhePPZ4lmU1cK
         WttLRwzykdarIK8SbPU92wu0xxZgcwoU2HXgv+4boZ6gLcTzEVfUiVbWE6wGO+Y5dSIF
         ISEk4OUYPDt/QDKynMbCBEIzVwVjY+1Au18yU6pKBQU6I0bjaN4/mau0KxTB757b1ByI
         Gg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=GSBS1LQcbgyhNQw5aYu+ifT22UvTNUJPKtaTUkIicrE=;
        b=own+jOcCEfpgpszuERV/NvowsyUNcF0Dp4xr0g9bEgl0HL4e2iypF7HlVhQTaypodZ
         Ood/ZS41pDvQf6M4cfxOiKDhE/+j0LwdDLD/qKtggqjy56JquV2igy1SagNBbOI1V6NP
         HhmXV/gDWBTr2+HiC81vUFZOOfww2MHTm9FsYsoJkintQOAvLszi/3SH0rwENhlA7FxZ
         ctwPrbhyOs/zCcGO6vs46wO4EzR9jPq+kWF1M5rBdsOD5eearK5tJGyqwM5y7WyLEpZm
         1fCPFI57X+WYOjCx4hXFhEa0oi5fz1k7dgIbhisp8Jy79dHJ00NqiFm83+I21eEaIQmg
         hNvw==
X-Gm-Message-State: ACgBeo2HR3zRlEDKgTDE7dMu2NPRTCM433Mb8HCuNfNj2pW4+v+VbBFy
        JVemvKGt17gN/NldnGHoy9w=
X-Google-Smtp-Source: AA6agR4apanJBvhKCcUhWnruw+A9wyD/ViBodSXus2EbQypb6sFpnqNh/tycA8VBlvXsaPs/s34aAQ==
X-Received: by 2002:a63:41c5:0:b0:42c:6b7f:6d95 with SMTP id o188-20020a6341c5000000b0042c6b7f6d95mr8917345pga.175.1661952183824;
        Wed, 31 Aug 2022 06:23:03 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090a1f8d00b001f510175984sm1283089pja.41.2022.08.31.06.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:23:03 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alsi@bang-olufsen.dk, loic.poulain@linaro.org,
        quic_vjakkam@quicinc.com, cui.jinpeng2@zte.com.cn, smoch@web.de,
        hdegoede@redhat.com, prestwoj@gmail.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v3 linux-next] wifi: brcmfmac: remove redundant variable err
Date:   Wed, 31 Aug 2022 13:22:54 +0000
Message-Id: <20220831132254.303697-1-cui.jinpeng2@zte.com.cn>
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

Return value from brcmf_fil_iovar_data_set() and
brcmf_config_ap_mgmt_ie() directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7c72ea26a7d7..938a6ed10275 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3988,7 +3988,6 @@ brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 	struct brcmf_pmk_list_le *pmk_list;
 	int i;
 	u32 npmk;
-	s32 err;
 
 	pmk_list = &cfg->pmk_list;
 	npmk = le32_to_cpu(pmk_list->npmk);
@@ -3997,10 +3996,8 @@ brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 	for (i = 0; i < npmk; i++)
 		brcmf_dbg(CONN, "PMK[%d]: %pM\n", i, &pmk_list->pmk[i].bssid);
 
-	err = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
-				       sizeof(*pmk_list));
-
-	return err;
+	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
+			sizeof(*pmk_list));
 }
 
 static s32
@@ -5046,13 +5043,10 @@ brcmf_cfg80211_change_beacon(struct wiphy *wiphy, struct net_device *ndev,
 			     struct cfg80211_beacon_data *info)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	s32 err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	err = brcmf_config_ap_mgmt_ie(ifp->vif, info);
-
-	return err;
+	return brcmf_config_ap_mgmt_ie(ifp->vif, info);
 }
 
 static int
-- 
2.25.1

