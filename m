Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1D52FE2FB
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbhATXpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbhATV1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:27:36 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B885BC061786
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:26:12 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id p72so25059888iod.12
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xd2GUZj3T4zjFRODOdjWCJrpvC64HI9cvgOt1hRzcXo=;
        b=NcHa2lk+46K6MbdGohVqiHQXnmqpJ8siABBlaLV/rmA57a7Y3j6f77UeYkSpqwdB7R
         yrzNT3XPcVXuHpyoTumAbklQnFqGPOWAYKDKEHbSzBHFAJjUekNsG0x8lgKROoiuzbF6
         g5O7hBMEOGW6gkh8Pzrdd4EeOxK2/AHqOL0n+orJv2I8l1PCNOx4eh0IKi4W89Ga+RXm
         pZ3jN2ympQfC8zF14KfWE4otV3zrTZkEoVlcTEhg4Vm3O6E0xhmbqS9JIuLKn9llsBXn
         T69goAPjS26xVfX3oxp5PhrgPOevbiaSwa14TJicIJumolftO5NccU1thxr85ELS0Cpq
         thPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xd2GUZj3T4zjFRODOdjWCJrpvC64HI9cvgOt1hRzcXo=;
        b=PtdxZwrAsUAP6Lc0GaEiDXxCmETiBR2q3E1FZCSQCbsCB2Y3nrBpTOo3co9qI92sGt
         g3tFvS65+pvYRrBB6JGS50yresFuRx1aux1ABTkbM2xtki8KjbA5BgD05bvml86c1X4M
         7XnGZRsivjXVoDDHlPl+KW7om5yRBIBbly4JuQbOoW1zEtgOgU6s3NJIiZnBC/SHUUJ9
         zIZ3MbYmBszVKOKRS/mxSIUL9HRvNrGwjRXrJDFpGTsTTP6ly38YtmXY0xY+Bqv+Ruf5
         7mYYGUuXPJm3rRJ6lDaBwBdWA8Hk3ruy4ZPgNxKRFCQwy/2zESVSdpxNOe3cfpJ9pD/0
         WIcw==
X-Gm-Message-State: AOAM532e0mgZLajb7lAcAAkPPZK8CrUl5aBsoVmnKznKGv1ayrxzJRQ+
        QJXZtuGt15RM5o4Klxv2AhT0GQ==
X-Google-Smtp-Source: ABdhPJzZqPGNgOfIkksBHD4QL34TDOa2/VNuOfRn8fc4tYQlS13XMOlYT3l4noykcZKIbRPxD4ixTw==
X-Received: by 2002:a92:40c4:: with SMTP id d65mr9811584ill.197.1611177972089;
        Wed, 20 Jan 2021 13:26:12 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q196sm1335687iod.27.2021.01.20.13.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 13:26:11 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, robh+dt@kernel.org, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 1/4] net: ipa: remove a remoteproc dependency
Date:   Wed, 20 Jan 2021 15:26:03 -0600
Message-Id: <20210120212606.12556-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210120212606.12556-1-elder@linaro.org>
References: <20210120212606.12556-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA driver currently requires a DT property to be defined whose
value is the phandle for the modem subsystem.  This was needed to
look up a remoteproc structure pointer used when registering for
notifications in the original IPA notification mechanism.

Remoteproc provides a more generic SSR notifier system, and the IPA
driver switched over to it last summer, but this remoteproc phandle
dependency was not removed at that time.

Get rid of the IPA remoteproc pointer and stop requiring the phandle
be specified.

This avoids a link error (rproc_put() not defined) for certain
configurations.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h      |  2 --
 drivers/net/ipa/ipa_main.c | 38 ++------------------------------------
 2 files changed, 2 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 6c2371084c55a..c6c6a7f6909c1 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -43,7 +43,6 @@ enum ipa_flag {
  * @flags:		Boolean state flags
  * @version:		IPA hardware version
  * @pdev:		Platform device
- * @modem_rproc:	Remoteproc handle for modem subsystem
  * @smp2p:		SMP2P information
  * @clock:		IPA clocking information
  * @table_addr:		DMA address of filter/route table content
@@ -83,7 +82,6 @@ struct ipa {
 	DECLARE_BITMAP(flags, IPA_FLAG_COUNT);
 	enum ipa_version version;
 	struct platform_device *pdev;
-	struct rproc *modem_rproc;
 	struct notifier_block nb;
 	void *notifier;
 	struct ipa_smp2p *smp2p;
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 84bb8ae927252..ab0fd5cb49277 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
-#include <linux/remoteproc.h>
 #include <linux/qcom_scm.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
@@ -729,19 +728,6 @@ static const struct of_device_id ipa_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ipa_match);
 
-static phandle of_property_read_phandle(const struct device_node *np,
-					const char *name)
-{
-        struct property *prop;
-        int len = 0;
-
-        prop = of_find_property(np, name, &len);
-        if (!prop || len != sizeof(__be32))
-                return 0;
-
-        return be32_to_cpup(prop->value);
-}
-
 /* Check things that can be validated at build time.  This just
  * groups these things BUILD_BUG_ON() calls don't clutter the rest
  * of the code.
@@ -807,10 +793,8 @@ static int ipa_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	const struct ipa_data *data;
 	struct ipa_clock *clock;
-	struct rproc *rproc;
 	bool modem_init;
 	struct ipa *ipa;
-	phandle ph;
 	int ret;
 
 	ipa_validate_build();
@@ -829,25 +813,12 @@ static int ipa_probe(struct platform_device *pdev)
 		if (!qcom_scm_is_available())
 			return -EPROBE_DEFER;
 
-	/* We rely on remoteproc to tell us about modem state changes */
-	ph = of_property_read_phandle(dev->of_node, "modem-remoteproc");
-	if (!ph) {
-		dev_err(dev, "DT missing \"modem-remoteproc\" property\n");
-		return -EINVAL;
-	}
-
-	rproc = rproc_get_by_phandle(ph);
-	if (!rproc)
-		return -EPROBE_DEFER;
-
 	/* The clock and interconnects might not be ready when we're
 	 * probed, so might return -EPROBE_DEFER.
 	 */
 	clock = ipa_clock_init(dev, data->clock_data);
-	if (IS_ERR(clock)) {
-		ret = PTR_ERR(clock);
-		goto err_rproc_put;
-	}
+	if (IS_ERR(clock))
+		return PTR_ERR(clock);
 
 	/* No more EPROBE_DEFER.  Allocate and initialize the IPA structure */
 	ipa = kzalloc(sizeof(*ipa), GFP_KERNEL);
@@ -858,7 +829,6 @@ static int ipa_probe(struct platform_device *pdev)
 
 	ipa->pdev = pdev;
 	dev_set_drvdata(dev, ipa);
-	ipa->modem_rproc = rproc;
 	ipa->clock = clock;
 	ipa->version = data->version;
 
@@ -935,8 +905,6 @@ static int ipa_probe(struct platform_device *pdev)
 	kfree(ipa);
 err_clock_exit:
 	ipa_clock_exit(clock);
-err_rproc_put:
-	rproc_put(rproc);
 
 	return ret;
 }
@@ -944,7 +912,6 @@ static int ipa_probe(struct platform_device *pdev)
 static int ipa_remove(struct platform_device *pdev)
 {
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
-	struct rproc *rproc = ipa->modem_rproc;
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
@@ -970,7 +937,6 @@ static int ipa_remove(struct platform_device *pdev)
 	ipa_reg_exit(ipa);
 	kfree(ipa);
 	ipa_clock_exit(clock);
-	rproc_put(rproc);
 
 	return 0;
 }
-- 
2.20.1

