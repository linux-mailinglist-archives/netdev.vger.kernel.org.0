Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F595A4B39
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiH2MM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiH2ML5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:11:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2C31A048;
        Mon, 29 Aug 2022 04:56:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j5so3852440plj.5;
        Mon, 29 Aug 2022 04:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=IhaMXTWAcaW3hhnK8+sC1vZiKgHn05Km4N0GxkG/RW0=;
        b=XwhGiA9hLdf7jF8Z1KwDvw+bXeHaXXbVKHSnXC8988+JZyQDwigHjK54u94bXwbnrs
         F6eKBgc/boIE1W0g7+YC2A5NpbFODdj0gooZ3ntTa+/PA8rUaJ0P9PLlhIGQ4ZdGjaoY
         SPDBHiL3TJFEAE1On7/N3BaV0tx3NNO0w40DvkjbW7CW58KZBvmGEUtPBBou0lpl/YCA
         aQ1gD6BwGVCBp6obAuRHo5tKKavKTxioCZXC7CrujjgxqrJ8YsSlEruXN9x2wggsBxc8
         dAzB5Hgpb36cudOLNZ11UPq18164SpkCWXQIei9wCUUaJmLuNwS3La7IjJemcl0YO+wD
         N9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=IhaMXTWAcaW3hhnK8+sC1vZiKgHn05Km4N0GxkG/RW0=;
        b=gUKmGAffws/TMHujp9mTv8TZDvJrnC4vNDNCHNkrf0pTo5ZHiX2pi2NXydEMfPwtec
         I5G2XmAaBpDcyAp9pJZJq+z5fhb4R9KizHFozD2K1rIOGVIzodKJTNOlcN061D6rgfyw
         G8OishivHf3XSMT7iBH5HTuk3Lj9mFxee6sJU+JPh4NEyUnMemZi1SqgZ4nKhMlrAQsr
         lYMw//gWbhlLBmf8TDw33XYaCTrwjOqnmS9PuX1JkSpzugWDuq1bk01wEofXCtwlTe9g
         M8Jsz82ukpvNusDY7a/+izinLN6/CnTJz2V2IvUVzIb/H5IJa+GuwW/1SVNmBxnFb+bF
         GipQ==
X-Gm-Message-State: ACgBeo02QZ6EnpWVwq39+/RN6rmFpcfGw3HMGzd6h/NT6SkIeH3WaJU4
        yjfsliQNYkhmCebMYmmmh1M=
X-Google-Smtp-Source: AA6agR7yzEYpT+OyneJp41HKj017miRViVo33bwauWIGBSTL3reK1YGOufd1Ki0uGR18e7YIWKhETQ==
X-Received: by 2002:a17:90b:4a84:b0:1fb:60a5:96b4 with SMTP id lp4-20020a17090b4a8400b001fb60a596b4mr18164900pjb.149.1661774124518;
        Mon, 29 Aug 2022 04:55:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m15-20020a170902bb8f00b00172dda377fesm7226353pls.260.2022.08.29.04.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:55:24 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org
Cc:     pabeni@redhat.com, johannes.berg@intel.com,
        a.fatoum@pengutronix.de, quic_vjakkam@quicinc.com,
        loic.poulain@linaro.org, hzamani.cs91@gmail.com,
        hdegoede@redhat.com, smoch@web.de, prestwoj@gmail.com,
        cui.jinpeng2@zte.com.cn, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] wifi: cfg80211: remove redundant err variable
Date:   Mon, 29 Aug 2022 11:55:16 +0000
Message-Id: <20220829115516.267647-1-cui.jinpeng2@zte.com.cn>
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

