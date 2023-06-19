Return-Path: <netdev+bounces-11880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94663735003
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45D31C209CE
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CEAF9CC;
	Mon, 19 Jun 2023 09:24:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75A4F9C5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:29 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58792197
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:28 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4f63ab1ac4aso3947262e87.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166666; x=1689758666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjzvLDkciXjZFL92+Kc0vSUQwlE6cL6G+2BzLekYlAI=;
        b=XNGhzaLmiL3KFTWhOvSO8p3J4tRL+xF8RjpYFWLGEPTdg3gX53kow5eWe+GjPmXtw0
         sOJSIyFuACVYYRxWiyz0R7WM2rD1gwWMwsa39vDl23Zi5zZ0WBUndG4r92W534zVGbDH
         jv666tDWiF4qCqZ82WKGeOXBufFyzpZBKEzwPfEsy43G2Z8qWHZHMkDcuos8Nh9Ntrwr
         ujCEYuNqFXACZBpFHRRi5hv6NDQRqjQRNN+r/SMze9BWoTgc8xMxPwAlpKYE5CRlCDRh
         m6WjPkZt0YdAwFiPhjEOE9KX9kJIQA8BK/TaDHsrwYuXpROrOffd01l1wT8Cj4wzkFyj
         O1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166666; x=1689758666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjzvLDkciXjZFL92+Kc0vSUQwlE6cL6G+2BzLekYlAI=;
        b=fRZr52P9a76u8r+DqztZbjE5Z5HWvAWuL4VFE5a504PLNqiLEcAlHI2Q/Gh6z77MJ9
         dylRuE8iOb4h00E/dBkfEfiLeXz+txc7Y8Qz21uSMnrUe0YrvWvPiitfxcO3LhZXjdmY
         Tl01arlydINWpVTMkxlkmEhveCBbaXoJPrhbaHQ6USevzi8Sesc5BU9U34arbmX3BYDl
         9VVGVBehBIozU9yQtiCPTn7b2PsKhhSjY6zxRzlGseOWWHNvsvkAp0bR3ipzsqFOrHm4
         L4VRyX8oQ37TAhM0FBDTBG5tVW0uAhpLjvrgYOIJ1MQ1FkFBBxzKKUHwIIvlaK5uzrJ+
         3uCA==
X-Gm-Message-State: AC+VfDxJOWmKHAoOMf2xsFe/3BRJmava4DHlCzzfstcJnRtAkQSBSHC4
	WKNmd0d+BcPPvHEDFUesswZrKQ==
X-Google-Smtp-Source: ACHHUZ4anpGLkXxAz3jzfzAJHE59yvmhAwwgk3HqvnBqFL9PAYQbIBsx1uANXwdQxgAGAMhIDJka/Q==
X-Received: by 2002:a19:5f08:0:b0:4f6:3677:553 with SMTP id t8-20020a195f08000000b004f636770553mr4429152lfb.38.1687166666442;
        Mon, 19 Jun 2023 02:24:26 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:26 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [RESEND PATCH v2 12/14] net: stmmac: add new switch to struct plat_stmmacenet_data
Date: Mon, 19 Jun 2023 11:24:00 +0200
Message-Id: <20230619092402.195578-13-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230619092402.195578-1-brgl@bgdev.pl>
References: <20230619092402.195578-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

On some platforms, the PCS can be integrated in the MAC so the driver
will not see any PCS link activity. Add a switch that allows the platform
drivers to let the core code know.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Jose Abreu <Jose.Abreu@synopsys.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 include/linux/stmmac.h                            | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5c645b6d5660..10e8a5606ba6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5798,7 +5798,7 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 		}
 
 		/* PCS link status */
-		if (priv->hw->pcs) {
+		if (priv->hw->pcs && !priv->plat->has_integrated_pcs) {
 			if (priv->xstats.pcs_link)
 				netif_carrier_on(priv->dev);
 			else
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 225751a8fd8e..06090538fe2d 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -293,5 +293,6 @@ struct plat_stmmacenet_data {
 	bool sph_disable;
 	bool serdes_up_after_phy_linkup;
 	const struct dwmac4_addrs *dwmac4_addrs;
+	bool has_integrated_pcs;
 };
 #endif
-- 
2.39.2


