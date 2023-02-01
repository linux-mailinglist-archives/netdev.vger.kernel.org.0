Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE1686C2E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjBAQzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjBAQzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:55:05 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A3D728ED
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:54:56 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id pj3so5053018pjb.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 08:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CuWcrDVG77MlzAzG1Dc9fCEJWh5XQzqPcKQwClqpGQk=;
        b=elsctNm6DvnStQNg/FiqgVT58WMOCUG7xRLbpU1S3BHrK2CrWN3bs69y3FSS53aQIT
         VGfpRUFDv+zQ/9PPxQBjX0Hn5y15GaAc1Lhq8hOuApj/9xVEah0bavBFheTs7kb6viHU
         uzT67e9IFG4XJUH4X4EBou9OUYS6NnHgTRD/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CuWcrDVG77MlzAzG1Dc9fCEJWh5XQzqPcKQwClqpGQk=;
        b=CoT7OaYqtG/0mMqaIQ7CVsMWO/3Se5GrL2bayEGKaJxpuekDrhTYL6ZtHbEApoeIY7
         PHmj3Z4u7jtKSBoyKl7WcFdckZ7oFuk2DD08Gc+JieihvAVoosHXhemQgD9jh5a7F2Nn
         4jTh0+ZP9esAGOK+4nFB3uo5HYqmlgkN4gXCF0AmG67UvKIgcIUVxIwgjVG/ilsFiXkV
         I+LdK+EaWlw7qe/JLeYZa6Tl4d4mInHD0wDoYPvE8oCGEj+kLK1HFLLIdEJFPZzjHqbF
         u2vsrDzzL9/JtnSd3dH2rXsDM+kcaPDqF5t29VASy5MMNq1/7wrgqAC4y0m6365Lx49M
         9JOA==
X-Gm-Message-State: AO0yUKWY0/mO+KrQ4+Ig+swQ7W6PPbjAyMOtwBlP9lEKN+pHW0u9Yo7p
        mrkJph/ZeZBuPHAocEii9NsZkg==
X-Google-Smtp-Source: AK7set9yAZQ6+dqWsBd9DE4iXXS9o4iyPyJ7iSp8CiKtvLQ+kk68I2UOsZmjpeyAcBcmjYLHtzQXLQ==
X-Received: by 2002:a05:6a20:7da4:b0:bd:79a:a215 with SMTP id v36-20020a056a207da400b000bd079aa215mr4272667pzj.29.1675270496006;
        Wed, 01 Feb 2023 08:54:56 -0800 (PST)
Received: from tictac2.mtv.corp.google.com ([2620:15c:9d:2:ba26:efe8:5132:5fcf])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7870f000000b0058119caa82csm11605090pfo.205.2023.02.01.08.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:54:55 -0800 (PST)
From:   Douglas Anderson <dianders@chromium.org>
To:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>, junyuu@chromium.org,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Marc Zyngier <maz@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: ath5k: Use platform_get_irq() to get the interrupt
Date:   Wed,  1 Feb 2023 08:54:43 -0800
Message-Id: <20230201084131.v2.2.Ic4f8542b0588d7eb4bc6e322d4af3d2064e84ff0@changeid>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
References: <20230201084131.v2.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ
resource from DT core"), we need to use platform_get_irq() instead of
platform_get_resource() to get our IRQs because
platform_get_resource() simply won't get them anymore.

This was already fixed in several other Atheros WiFi drivers,
apparently in response to Zeal Robot reports. An example of another
fix is commit 9503a1fc123d ("ath9k: Use platform_get_irq() to get the
interrupt"). ath5k seems to have been missed in this effort, though.

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
I'm not setup to actually test this, but I figured that I might as
well go all the way and fix all the instances of the same pattern that
I found in the ath drivers since the old call was actually breaking me
in ath11k. I did at least confirm that the code compiles for me.

If folks would rather not land an untested patch like this, though,
feel free to drop this and just land patch #1 as long as that one
looks OK.

Changes in v2:
- Update commit message and point to patch that broke us (Jonas)

 drivers/net/wireless/ath/ath5k/ahb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 2c9cec8b53d9..28a1e5eff204 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -113,15 +113,13 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
-		ret = -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no IRQ resource found: %d\n", irq);
+		ret = irq;
 		goto err_iounmap;
 	}
 
-	irq = res->start;
-
 	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-- 
2.39.1.456.gfc5497dd1b-goog

