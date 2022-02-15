Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EA04B6114
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 03:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiBOCeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 21:34:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiBOCeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 21:34:16 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BC8C7D44;
        Mon, 14 Feb 2022 18:34:07 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id f19so5912653qvb.6;
        Mon, 14 Feb 2022 18:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06Kfv1DXtnVDrheRxya2snTjYCwD2TQR57hbpR3zm0s=;
        b=OJUTaC8m4FlgAFC/uh7uJBfFqqP/RkqnhJTE59PCuIH76NWYuimLf/S2LQejeyi662
         bFda6a/SPjSJoKXe3yWCje0n+Q7l+ikqo8j32lVc2XsHc+bQOjG/sm1PqP9+sY1HOAjd
         0P3Z00beuW1C64qL8bVTHg7+XTkp2++lLg9XgBKZcs8PU/jOoFFZgEY9PfSk5k2QjTsd
         fZVQx0j0E/RbeOCEDPeRkOxyBIbyxVKnYOBJIVleOCox0eXHYItVAUeq/JL4Ahc2mUcb
         cmYPtxBdWHYwsGxkhaPXC0+vjH0cSXY0cMfLHzEWiLX09nsWGZH4VI0hPTDwT3BKJNvv
         B0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=06Kfv1DXtnVDrheRxya2snTjYCwD2TQR57hbpR3zm0s=;
        b=KPmVJ579qtgiT6pXYd5Bu7m4U4xWvYrESs5H9uaHG6kBZLaOpnty8iDv+/Bg/K2noB
         UFHZSZbfZqTD4G5SfH9frWXDG+pXITYIznyiTeORlg1+ReOoN04/LvcncIhx93+sOj4k
         MXbL5vaCHolxymxa1Ow1bpxcG47gQsit7nEhTpffyeW8WEj1SJ9+Fu4q5NsoA3G+iPmQ
         3x2t7OZLbFeCpxwImAgGWkcm0RjsJot6I5YKtMk/DMIlcr520sVQ4KfEaPvfquE0o4gQ
         Fdv+kyiUQEbBItVyAvZOeg0uB4Kn4ANMwFwWOpxN5fKHm+/tSb7IicDsySPl5CSUdK6V
         DLeg==
X-Gm-Message-State: AOAM5322acEtVe9UaU93TdDeIpc67i4VUy/eIZsmgK1akWfPL0waeRxg
        VgHjZ+vyqUFDmOUL7Ipvgxw=
X-Google-Smtp-Source: ABdhPJysV3vOFxo9MY9xSnNFS0irUrGngNCaqUIS5vyTJGLJ3J7HfDrRw4++7et3pzr7mwdIB3xOgg==
X-Received: by 2002:a05:6214:1c07:: with SMTP id u7mr1073836qvc.129.1644892446726;
        Mon, 14 Feb 2022 18:34:06 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s1sm18976509qta.0.2022.02.14.18.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 18:34:06 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     nbd@nbd.name
Cc:     lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, matthias.bgg@gmail.com,
        arnd@arndb.de, Bo.Jiao@mediatek.com, deng.changcheng@zte.com.cn,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] mt76: mt7915: use min_t() to make code cleaner
Date:   Tue, 15 Feb 2022 02:33:55 +0000
Message-Id: <20220215023355.1750720-1-deng.changcheng@zte.com.cn>
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

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min_t() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7915/testmode.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index 83da21d15ddd..61f255166a7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -228,12 +228,8 @@ mt7915_tm_set_ipg_params(struct mt7915_phy *phy, u32 ipg, u8 mode)
 
 		ipg -= aifsn * slot_time;
 
-		if (ipg > TM_DEFAULT_SIFS) {
-			if (ipg < TM_MAX_SIFS)
-				sifs = ipg;
-			else
-				sifs = TM_MAX_SIFS;
-		}
+		if (ipg > TM_DEFAULT_SIFS)
+			sifs = min_t(u32, ipg, TM_MAX_SIFS);
 	}
 done:
 	txv_time = mt76_get_field(dev, MT_TMAC_ATCR(ext_phy),
-- 
2.25.1

