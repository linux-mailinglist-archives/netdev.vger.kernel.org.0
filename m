Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BF570212
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiGKMaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiGKMaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:30:52 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB94D4E603
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:51 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id oy13so3678996ejb.1
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 05:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYvWlChUTRjZ40L2MhpeE72DGwoPhHfF/1ipkuBiJBE=;
        b=b/Aa+wXf5yJPAx+b+cKVIzEPsd/fK4KDVHLBkpiBJlEe6/xTnwrsojoh5acydEzceI
         BZ6xqSQ2iUzlRC9oj8dv5+RsJamcVJLzRL855YavTAkhKtqtDynEF2UIoo92TUJF7pGY
         GlXYDZUrd7nnHVfp7WdK0blwj3Rr+anWSdeCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYvWlChUTRjZ40L2MhpeE72DGwoPhHfF/1ipkuBiJBE=;
        b=091r2/6//MS7FxLxYZueOhAYe0RoJmsNAUL+INj09p67zu4Uo0vzSiiTWbdMOJpr3H
         g7HN9/X7jsIy5GN96DUQA14/rVFcLgEAlbE8Drq17Nrzsy+HA7quHGw8rp//S9xynU9P
         CL2UUouawRbtYl9+WlfRg6j6sH/4pFuKkDS2Lt5nl2zrb/kkTGjDfKFpwfeGrNMA0jpH
         HSLlHjFoa/1DMeIHM+q4r04Cso7iTgEfOPPMmzHnL6CzuZkul9wwNv5AjOZ9INos2cM4
         PUuygFqDiQ/Y8ToiC92Xduuvg7CxtCrvQxc0lfzhaMJ+/WRHrJ34a6q5FQUiiRaenAWS
         GFMg==
X-Gm-Message-State: AJIora+LplI8V8A/T/wWQZRi0bLTsVWp/OjeESnfAveTm6dpUcEbA9Ot
        OdKmELrRBkFgfiOyzfAmwXH8yQ==
X-Google-Smtp-Source: AGRyM1v82oZO0az0Nf6XSyx/DfS6/dODO82EVOMfKtCbzwizV+rE6Q2Kcqmp6s+ussAHNPGgtsISKA==
X-Received: by 2002:a17:906:8a45:b0:72b:31d4:d537 with SMTP id gx5-20020a1709068a4500b0072b31d4d537mr14585748ejc.170.1657542650255;
        Mon, 11 Jul 2022 05:30:50 -0700 (PDT)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0072b16a57cdcsm738785eja.118.2022.07.11.05.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 05:30:48 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 2/2] wifi: brcmfmac: support brcm,ccode-map-trivial DT property
Date:   Mon, 11 Jul 2022 14:30:04 +0200
Message-Id: <20220711123005.3055300-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711123005.3055300-1-alvin@pqrs.dk>
References: <20220711123005.3055300-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Commit a21bf90e927f ("brcmfmac: use ISO3166 country code and 0 rev as
fallback on some devices") introduced a fallback mechanism whereby a
trivial mapping from ISO3166 country codes to firmware country code and
revision is used on some devices. This fallback operates on the device
level, so it is enabled only for certain supported chipsets.

In general though, the firmware country codes are determined by the CLM
blob, which is board-specific and may vary despite the underlying
chipset being the same.

The aforementioned commit is actually a refinement of a previous commit
that was reverted in commit 151a7c12c4fc ("Revert "brcmfmac: use ISO3166
country code and 0 rev as fallback"") due to regressions with a BCM4359
device. The refinement restricted the fallback mechanism to specific
chipsets such as the BCM4345.

We use a chipset - CYW88359 - that the driver identifies as a BCM4359
too. But in our case, the CLM blob uses ISO3166 country codes
internally, and all with revision 0. So the trivial mapping is exactly
what is needed in order for the driver to sync the kernel regulatory
domain to the firmware. This is just a matter of how the CLM blob was
prepared by the hardware vendor. The same could hold for other boards
too.

Although the brcm,ccode-map device tree property is useful for cases
where the mapping is more complex, the trivial case invites a much
simpler specification. This patch adds support for parsing the
brcm,ccode-map-trivial device tree property. Subordinate to the more
specific brcm,ccode-map property, this new proprety simply informs the
driver that the fallback method should be used in every case.

In the absence of the new property in the device tree, expect no
functional change.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h   | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c       | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 3ae6779fe153..db45da33adfd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7481,6 +7481,9 @@ int brcmf_cfg80211_wait_vif_event(struct brcmf_cfg80211_info *cfg,
 
 static bool brmcf_use_iso3166_ccode_fallback(struct brcmf_pub *drvr)
 {
+	if (drvr->settings->trivial_ccode_map)
+		return true;
+
 	switch (drvr->bus_if->chip) {
 	case BRCM_CC_4345_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index 15accc88d5c0..fe717cce5d55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -38,6 +38,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
  * @fcmode: FWS flow control.
  * @roamoff: Firmware roaming off?
  * @ignore_probe_fail: Ignore probe failure.
+ * @trivial_ccode_map: Assume firmware uses ISO3166 country codes with rev 0
  * @country_codes: If available, pointer to struct for translating country codes
  * @bus: Bus specific platform data. Only SDIO at the mmoment.
  */
@@ -48,6 +49,7 @@ struct brcmf_mp_device {
 	bool		roamoff;
 	bool		iapp;
 	bool		ignore_probe_fail;
+	bool		trivial_ccode_map;
 	struct brcmfmac_pd_cc *country_codes;
 	const char	*board_type;
 	unsigned char	mac[ETH_ALEN];
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 083ac58f466d..1add942462f8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -24,6 +24,12 @@ static int brcmf_of_get_country_codes(struct device *dev,
 
 	count = of_property_count_strings(np, "brcm,ccode-map");
 	if (count < 0) {
+		/* If no explicit country code map is specified, check whether
+		 * the trivial map should be used.
+		 */
+		settings->trivial_ccode_map =
+			of_property_read_bool(np, "brcm,ccode-map-trivial");
+
 		/* The property is optional, so return success if it doesn't
 		 * exist. Otherwise propagate the error code.
 		 */
-- 
2.37.0

