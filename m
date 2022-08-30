Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0235A612A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiH3KvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiH3Kuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:50:40 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B3C61124;
        Tue, 30 Aug 2022 03:50:25 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f24so7978141plr.1;
        Tue, 30 Aug 2022 03:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=IhaMXTWAcaW3hhnK8+sC1vZiKgHn05Km4N0GxkG/RW0=;
        b=lHomL4xEN0wjcDcNxCpVINhbuhekmy1qmwlIc2sII/l02dAPS2iaLeRNU6nI8XAfhW
         jK3P+XYW/yAU0LwHZJZDOWItZVfjcCN9TCjdqZSWuJvf/MHz1HLewtQvwtITo7uT9MSX
         eYoSt5xuhZiXd2ZTN3xen5ijEpdeknJ+8cVHNKV4tRP+o1Rxzw7g1zZQ8BsTyXwIER5a
         IiEx+mwDnZ4clVX/fzeNf99CUEavXzBQdXsyBUE6sBr5dHz1IspEALz+czefmzQzn5Tb
         Gh1URRqE64V3TkfnDUAVR6Zh8scB8a+S6ghT0eb+gqbOyPlaY7LfJRVXECPyM93/2r4q
         7pJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=IhaMXTWAcaW3hhnK8+sC1vZiKgHn05Km4N0GxkG/RW0=;
        b=JsZSTURZgwWsVD0tVly/Wu7WUYm/mnmK5LAHkbtwFwm7LM3bSY+Rtzwvhq9hz0+CCp
         WzOvwA7B03qEsnUOd6Xq5VWSV8Ur9odQGpzotFBSNOggTmj7NmBugF88OURU7b/HorXf
         gZ0/tnD7VTrbpZde0AZBiaM1Esm3Ok0LNC+ssN6zFc1hc/O0RkUZLilzebbC5SvhYQZZ
         2+KsiscJgJfdy5po31bJkwERzau+zvrjvdZGZCiCv89t2H0tu9puuC7haipvTGdCSQ7b
         g1Jd6BviDhLuEofOVjCLt/YF52QJ5/daN5eLsn1kbQxt+aBR9svzUqQTbED3VHp2MziO
         eSrg==
X-Gm-Message-State: ACgBeo0jm2hmhqM5GDn9YKXTjpNutqufzvDwirMxC49+wfxnuYcEIkHI
        JOyGJehKmsuVlu+Inj+eWKA=
X-Google-Smtp-Source: AA6agR4L12NnWdeknXVCJQE3JGwrtXsEDyRO+bGNadYbaB/gOM/nUCFaR6bvSQQg5F9lQHnRIiS+FA==
X-Received: by 2002:a17:902:a705:b0:172:ecca:8d2d with SMTP id w5-20020a170902a70500b00172ecca8d2dmr20794672plq.27.1661856624399;
        Tue, 30 Aug 2022 03:50:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p5-20020a17090a2c4500b001efa9e83927sm8150591pjm.51.2022.08.30.03.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 03:50:24 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alsi@bang-olufsen.dk, a.fatoum@pengutronix.de,
        loic.poulain@linaro.org, quic_vjakkam@quicinc.com,
        prestwoj@gmail.com, colin.i.king@gmail.com, hdegoede@redhat.com,
        smoch@web.de, cui.jinpeng2@zte.com.cn,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2 linux-next] wifi: brcmfmac: remove redundant err variable
Date:   Tue, 30 Aug 2022 10:50:16 +0000
Message-Id: <20220830105016.287337-1-cui.jinpeng2@zte.com.cn>
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
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7c72ea26a7d7..8a8c5a3bb2fb 100644
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
+	return brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
 				       sizeof(*pmk_list));
-
-	return err;
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

