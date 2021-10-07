Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B342545B
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhJGNk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:40:27 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:36918
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241724AbhJGNkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:40:20 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2F3063FFF4
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633613906;
        bh=7wHPc2hCaswmbEOYcj4jBzC9LLYp/Egl2xOhlhUQit0=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=bCkeO3ho4YrUR6lTkKn/tO58cFU212ssnq2pQ8FEdorzzaUIBaMRu6UKoftWX0EPm
         7vAcYyU74h6nyl6O2ZRmLwUrEQHhyzUF7h40jzlfz0RsvjR5pAj7BDjq67pBKetJT5
         UY9rBmr1nfbmy8oPtpdHFEuVI1vogY2SNQjbVZ4Ij74NF1e5hI8MOmaGlM6PpMNv1F
         ueQ90By2iPioZ52b04wqf8z7h/beYZzbN+Yu50Fea3FWAVzlRZO26bHW3VNP96BqTo
         /4cdhnCkixh+I65Obb3A0jMRuWB00EsJZVhvycsAyMhuYSFOgsTvF0zhpS32f1zWCI
         jmCBOSDZdsCLA==
Received: by mail-ed1-f70.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so5871160ede.16
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wHPc2hCaswmbEOYcj4jBzC9LLYp/Egl2xOhlhUQit0=;
        b=P0dG8wDcV5OySVdaXiK4EYoJ/E8IJ0Oq49/4jPHjVQ59d8/tqS7Rmjm5QkBV8VrmSL
         HoFndP62eRZOL3RhuVB0oyh0Wuz7gQ0o35CYnT0g8gwMln31Uidv2NbWnRFt35e9XZ5x
         7VWP/CZwIxgIVuvmwQ8dlDzzPZOcttlxmC2oZE2pvwr5cmTyt8bJnVjIUVLmqXGVHxdJ
         i2COZgbq4ABCMUCx9HVyKpZQHdF7lTQKVxlCi3TXcHneqYpUPBTmFG2mAVrv5kf1DZ7b
         T6rf1caxZc4+FPON6tfzGZ7IChZLupqlolYoV7W58++E76UM4k2LwtocgTZGRCChHAxC
         iXpw==
X-Gm-Message-State: AOAM53224ty1ienyp6UJUekhUwTmENFXqj9iGmKPZi2t4iuRvx5sFPx/
        t4NPmOXbNFl7HgjhpIj4LSEzxOTqhfav0Y7yaFQJeNztZY3NYJQ7FrYTg1EcqRQI0zs2myxcuEd
        C1prbPfI1btinj1p59KnegQ89cxyPuB4q9A==
X-Received: by 2002:a17:907:7691:: with SMTP id jv17mr5620866ejc.378.1633613905843;
        Thu, 07 Oct 2021 06:38:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW6wSstelqxnszacAmVV1yOLN/Y4Rrb3LyOnmrOYct0SAg12rc5jiDQJPx5MKSQQJZNOEMxQ==
X-Received: by 2002:a17:907:7691:: with SMTP id jv17mr5620839ejc.378.1633613905666;
        Thu, 07 Oct 2021 06:38:25 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id ay19sm8585613edb.20.2021.10.07.06.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:38:24 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [RESEND PATCH v2 6/7] nfc: trf7970a: drop unneeded debug prints
Date:   Thu,  7 Oct 2021 15:30:20 +0200
Message-Id: <20211007133021.32704-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
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

