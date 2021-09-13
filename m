Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819AB408E04
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbhIMNbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:31:04 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34282
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241744AbhIMNZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:25:29 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1AEFF40280
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539264;
        bh=vC5ZeeYLEo1QgnDozyJaTYMB8bYZWzk5ZY30xgpVgcM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=NxX+W5q53mrv7BPf8fvhZP5qOOJVjz3Wz9gK16ncuOso7L44VDHCJf0DySMSRR2Xe
         wAJKoHZCyNFwJdQqRegd6j9Yp0p1FsCOrqmUHuEvcsc2V/O0KNmKnP9gPMTpYqpraS
         LIhpMMCdxh9xsPZ6QoFfKQLcnFAYuI+svYJBZ0QImfsl3kJxufz7F3Nt5aVywavsYc
         uVytcCuV9dHurAy1TmeW9nN9tNqcKfoY811qfz803MdSt1rA+dTrEsgYnMYoFxl+Qa
         8m1KMYG4QP79+VlSLqn/M5f38evu+Ss2gogjQ4h06HTWmMGvUtdNohmXdeMJqmyjjd
         VdNrJda/oL6IQ==
Received: by mail-wr1-f72.google.com with SMTP id i4-20020a5d5224000000b0015b14db14deso2645870wra.23
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vC5ZeeYLEo1QgnDozyJaTYMB8bYZWzk5ZY30xgpVgcM=;
        b=x95Yq7WOUsRxylkQpxrbHpHzMN7/DtmPzRdqu0t6TRRZSYJ2fzoUCxLZItnGkIURU4
         OScFCcgL52N/M1MzZDgInEqto46SJOiot1gs6E+CvrdrESABWzrgN8L95sInXwFhgF9L
         HjE1bpf+XSMcZ1x3Rb1LBGJQGEOQxk0edpT9GdxoxWMzTGlpRPZ6NfxtXIOIZnZmHFoU
         +KzgeHleY9QOxF55xSEFAHAjz1SL3avpgvLrcTK2IFQKXAhwgM+xi60MW8PwIvazV4gC
         BG8uDf7GRfsraSxj2ofrvraElVKvcEwavAAhdvayY70VuTdqeq8NuzbacsJP3pKCq4GP
         F1SQ==
X-Gm-Message-State: AOAM530eYVatcgKaSz/KcEnL4Ie5g9gK2/OO38BoGt/e8COYKXGnPNgv
        SIv51rvKHLmSkGHVMMefoH87ntFVrUhkdDqr2Toi+i7GAgd7aVPdcOEhKX0yD2wv9v+jFr9AEPa
        jM6vig2GQrKmGVd3Sv2xSL8g/B19h/1E9WQ==
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr11405613wmj.144.1631539263848;
        Mon, 13 Sep 2021 06:21:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/izsu1khftAkG5C5T0/hXLkw7auLof1x9kSlmEPTvEP1I+LgccfCmnvu7rQjvYP7wlALVsg==
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr11405588wmj.144.1631539263665;
        Mon, 13 Sep 2021 06:21:03 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:21:03 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 12/15] nfc: trf7970a: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:32 +0200
Message-Id: <20210913132035.242870-13-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
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

