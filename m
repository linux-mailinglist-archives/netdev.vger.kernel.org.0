Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE546C8E5D
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 14:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjCYNFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCYNFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 09:05:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295BEEC4D
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 06:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679749503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p5AnT4EajAj/sfPOwrH8wVcxH+vP8RQ1S3cIG2Qtejc=;
        b=LxbQoxVlpuKkDGDGqJ5UfW0GZsJ73IQLOtFT9z1yTJlxQ+vtSLjP0G4Z1pGQK9G58dzXwK
        1SP77m+MXakitw5by01Lo2+tat7v0jC9eOY0pXS+D1Xu4MgcTjSbBX6aMtt2hJ69s2GyGb
        fOHr8j4ZyfESPyJ7sb2kZ0yMN4tVJWE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-eyiIPuagNP-AYcT14WCYJA-1; Sat, 25 Mar 2023 09:04:09 -0400
X-MC-Unique: eyiIPuagNP-AYcT14WCYJA-1
Received: by mail-qk1-f198.google.com with SMTP id z187-20020a3765c4000000b007468706dfb7so2106720qkb.9
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 06:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679749448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5AnT4EajAj/sfPOwrH8wVcxH+vP8RQ1S3cIG2Qtejc=;
        b=Wc4yHCh9dnDmKFzXGWtt6vcQModk99kgqYYs/D8sZnKkf9HoYMupOKqIHXk4xvn/8W
         XTvf7u76aNGhhRCMZAkGbiAtA4OQIRPM1CXBvbEw7im3b5SE2sIE8mxXZ6FJoUGQ4N0Q
         UBFlTk/3f7TlwCrbud1HAc2aOqJMp1vHmoidhd4FwL3z6WHwl8/ZprSuLr4fNdfmD9fn
         4Zyj7RWpotycVTgAZdXHl3iXJB3QuvkXDJdA1Shp+qcQmMhq+pNdCwr6+gbbTY+sW0QD
         R+WapvQXZTwGKPEmpQObEN7D4cG57tmI5G+gFFqFK2VKoPg8gms4TChebYBrbl/Hmsfu
         TUrg==
X-Gm-Message-State: AO0yUKW5nPvesmyeGwUWd61gZWo0b+MnH5wuf2hhrJmZrDWAY9jyb9Rf
        Q9XccarragK93WyH9KgSIC21yWs3hpCyfe7KQqbVWY2G2+rV8eghP4vjrDGy/lHjSe3BZLFYvVi
        8VQY6TYF6kg4HwKRF
X-Received: by 2002:ac8:5905:0:b0:3e3:9958:5fe8 with SMTP id 5-20020ac85905000000b003e399585fe8mr10189598qty.42.1679749448555;
        Sat, 25 Mar 2023 06:04:08 -0700 (PDT)
X-Google-Smtp-Source: AK7set+2OrXAM6yLwAO51Ihw4Bnlq4mAxCyDb+OhQvXEXhrgJx/Z2aC+vH71MlObmyR5Qq6wWwaDFA==
X-Received: by 2002:ac8:5905:0:b0:3e3:9958:5fe8 with SMTP id 5-20020ac85905000000b003e399585fe8mr10189565qty.42.1679749448292;
        Sat, 25 Mar 2023 06:04:08 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u23-20020a37ab17000000b0071f0d0aaef7sm11776469qke.80.2023.03.25.06.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 06:04:08 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com,
        johannes.berg@intel.com, quic_srirrama@quicinc.com,
        alexander@wetzel-home.de, shaul.triebitz@intel.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] wifi: mac80211: remove unused has_5g variable
Date:   Sat, 25 Mar 2023 09:03:43 -0400
Message-Id: <20230325130343.1334209-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c:1051:6: error:
  variable 'has_5g' set but not used [-Werror,-Wunused-but-set-variable]
        int has_5g = 0;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index a8333e6adbda..0bd4e679a359 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1048,7 +1048,6 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	struct brcms_info *wl = hw->priv;
 	struct brcms_c_info *wlc = wl->wlc;
 	struct ieee80211_supported_band *band;
-	int has_5g = 0;
 	u16 phy_type;
 
 	hw->wiphy->bands[NL80211_BAND_2GHZ] = NULL;
@@ -1070,7 +1069,6 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 
 	/* Assume all bands use the same phy.  True for 11n devices. */
 	if (wl->pub->_nbands > 1) {
-		has_5g++;
 		if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
 			band = &wlc->bandstate[BAND_5G_INDEX]->band;
 			*band = brcms_band_5GHz_nphy_template;
-- 
2.27.0

