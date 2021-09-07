Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8175402885
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344664AbhIGMUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:23 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36936
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344339AbhIGMTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:51 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DC816407A8
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017116;
        bh=vC5ZeeYLEo1QgnDozyJaTYMB8bYZWzk5ZY30xgpVgcM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tTyMQxiqTAGMXRkmo9aHy0Xh+NsYkcZDhsUaVu85+4GuPOu9SaUXKoB2Iyx/MHECt
         JghnYmR3Fx7/fYl/JhRoZiDqs/+/CpB026Q6ZS7On+U67bQEM7KVlat4H5qoHfL0lv
         dQGOleE7W5aYRGU3H6P1c18o4PgigX9xzN6zByLmOUuhB44uwsuKSZ1SI5yT5bgOv9
         /PmIszq/E4HIPhCSdDdMiB4FPIvhT5scRHX4U5Er1slOAmB45HEcu5o2jSelxEktTi
         Hmo+ydRKBS23PPyvSV9RBC6rrqHxm3JWGEIfNOcx6j2Om3olCEiLwstCOT7wVZ0JXI
         444hpHS4Gw4uA==
Received: by mail-wm1-f69.google.com with SMTP id p11-20020a05600c204b00b002f05aff1663so1039174wmg.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vC5ZeeYLEo1QgnDozyJaTYMB8bYZWzk5ZY30xgpVgcM=;
        b=GmGU2fBPJq89ZTBti6w0guk01z7tZ16w98Hg6MIenyiXoxf7taQ/syhoVRBFx3B4v3
         hJ2oUFMuD+o1XrSfcDSEjac+perShIA59Dq7oKq0nY17yMS7q/+NK/5UnxJ3TahV3ZZF
         v5LMycOHVf9HiAVoS794I3gVFMltsFuCKZCYmlQmbLR2lAktPXQPJn5xejGpnaX1byb0
         x8oDEvfghdQ6LTbp2WKhYn1qDnccUek7uCRa1/wk/2bubfHYXbcq6COhNGMZSr7+KTs7
         HsjNkvfihXBopv8EA6Dmz8fuO9StGFgGX6ssdsFd0Uf17yp0R6rdUNIc8jAtNoit8jxa
         1a9w==
X-Gm-Message-State: AOAM533OGIG87NtqNvu8pUl2n3/qLs59gjgmuf/7yIqS56NjhYr/1D39
        vv3z6KKfXxOwZaF1bH/SyX6LJtYYNGtTHk7YdrsVd/ys63WMpLJMwLV5ZA0L19lu23MRkl8aXqt
        EldukyuaIb8FGJaOBGn7W1dIrDUiH4M+H5g==
X-Received: by 2002:a05:600c:350b:: with SMTP id h11mr3654649wmq.101.1631017116587;
        Tue, 07 Sep 2021 05:18:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1nc8FfA3NegAiSteStJpWLEeZZ3ZcnTr4pnxkPwnCbeOusix2fXAFJixkw6WN/2ypjZQRhw==
X-Received: by 2002:a05:600c:350b:: with SMTP id h11mr3654639wmq.101.1631017116468;
        Tue, 07 Sep 2021 05:18:36 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:36 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 12/15] nfc: trf7970a: drop unneeded debug prints
Date:   Tue,  7 Sep 2021 14:18:13 +0200
Message-Id: <20210907121816.37750-13-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/trf7970a.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 8890fcd59c39..29ca9c328df2 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -2170,8 +2170,6 @@ static int trf7970a_suspend(struct device *dev)
 	struct spi_device *spi = to_spi_device(dev);
 	struct trf7970a *trf = spi_get_drvdata(spi);
 
-	dev_dbg(dev, "Suspend\n");
-
 	mutex_lock(&trf->lock);
 
 	trf7970a_shutdown(trf);
@@ -2187,8 +2185,6 @@ static int trf7970a_resume(struct device *dev)
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
-	dev_dbg(dev, "Resume\n");
-
 	mutex_lock(&trf->lock);
 
 	ret = trf7970a_startup(trf);
@@ -2206,8 +2202,6 @@ static int trf7970a_pm_runtime_suspend(struct device *dev)
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
-	dev_dbg(dev, "Runtime suspend\n");
-
 	mutex_lock(&trf->lock);
 
 	ret = trf7970a_power_down(trf);
@@ -2223,8 +2217,6 @@ static int trf7970a_pm_runtime_resume(struct device *dev)
 	struct trf7970a *trf = spi_get_drvdata(spi);
 	int ret;
 
-	dev_dbg(dev, "Runtime resume\n");
-
 	ret = trf7970a_power_up(trf);
 	if (!ret)
 		pm_runtime_mark_last_busy(dev);
-- 
2.30.2

