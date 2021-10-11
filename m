Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4FD428E3D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhJKNlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 09:41:31 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:42354
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237133AbhJKNl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 09:41:27 -0400
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E585140010
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 13:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633959566;
        bh=7wHPc2hCaswmbEOYcj4jBzC9LLYp/Egl2xOhlhUQit0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=QL1j25t0TqS/jEbZoltiQrej8KobxpLJbp47XpS7IpWz0W3cCFLyP2Gz9vaDzYQ4A
         07s8AUz3zEOnUkaODP/E1HR7luDLuPvLheUeeatun9i6/VUM64K0htXxaCGkY2GBQb
         aNBK0MCjlZQxIE6xVB3z5i1rF/cHIKlmVBrE7gLWxGTpMpATiDX9sKWfu4ycI/a1Rk
         UNpJCAiqvRSgG6E+pv/0nT6O4s2NKElNn9ZqsfGV/gvlVHL1YOfkLj6tinZ5Cb67Mh
         W5bFWBiL9gFo8JwjsCzPJdBXQelte/mAMB+yY3XiwQ100xKGy2q5wfjm2bxaPtldTM
         TzI5Y9M7XEY2Q==
Received: by mail-lf1-f72.google.com with SMTP id z29-20020a195e5d000000b003fd437f0e07so9882730lfi.20
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 06:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wHPc2hCaswmbEOYcj4jBzC9LLYp/Egl2xOhlhUQit0=;
        b=QWR7g7BYHhNtupgFUIfGDY97cx5OMgBN5KqlvjZnTzcLg4aJ9VSVlsikR/A1cZdKlQ
         hRB7bW7iwF8CQ+oBzBz0p+8o/szWTwnZhTvYVvOAE+330YliTfF5abzkr1HmdzPy78MK
         cQj7Zneb7WKcde5PcUT8lIOc0b4eqFrAnpU9W9oGuWJy5QOTxugxOnn+qN1cCjP/HlS1
         NXa9tDEkIh6Eu+SM0bCB8Hxcq0LsmuWRNiajXHfaKEwEbFP57AsFVKzpYP++x0W+A6M2
         shr68m0EP9cUoDUZDFI1fiwn+C4+TOpyTFTU0DIAW3hVNIn+518i4MIfRlKim81jpV+u
         +W8w==
X-Gm-Message-State: AOAM5308LjBaqy/1yRtg5RSkySB3sESZ96c9iRtuXEnIhAb3MbeQjzjf
        HU4/6zQDc7oYqGOzw9Rbp+V8r17EDmNfgFhHb+7nS/C1wNMPn7ImghA+H5+Zx8ftH7hU13nKLg1
        VpZHYTfVC1hBFJjCx+yMYNQmMim9fpidbeg==
X-Received: by 2002:a2e:9a44:: with SMTP id k4mr14874400ljj.149.1633959564905;
        Mon, 11 Oct 2021 06:39:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQuusYej153D7T4843hgxhZnMn63CiNaU/WCoXvJeUKhYTRGz/hdmDHUziYWi9pV44z1agbQ==
X-Received: by 2002:a2e:9a44:: with SMTP id k4mr14874384ljj.149.1633959564729;
        Mon, 11 Oct 2021 06:39:24 -0700 (PDT)
Received: from localhost.localdomain (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a21sm738971lff.37.2021.10.11.06.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 06:39:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     joe@perches.com
Subject: [PATCH v3 6/7] nfc: trf7970a: drop unneeded debug prints
Date:   Mon, 11 Oct 2021 15:38:34 +0200
Message-Id: <20211011133835.236347-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
References: <20211011133835.236347-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Mark Greer <mgreer@animalcreek.com>
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

