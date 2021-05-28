Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851043942DE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236961AbhE1Mot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42527 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbhE1Mnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:55 -0400
Received: from mail-ua1-f70.google.com ([209.85.222.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmboh-000809-K5
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:19 +0000
Received: by mail-ua1-f70.google.com with SMTP id i8-20020a9f3b080000b029023c932e01b8so1863537uah.3
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yRrONTypgp1EMOyVarHqpM55W7hpCkiyyNUgXqdeSg8=;
        b=iUw7F8ySr1rt69r60IoFR1yAzX2KGp03bfI41fao/Vq3L/LU/JbLtIDZEhAp0j7wMa
         2wj7UxG+QzW67Bp8JO49ZGbG0Cd4sv6a3/pHBk7otAtsTIFgmsVk2xTON0e9R33i0J64
         BxKIJx1tXmwJWbpxHC4jg7MBN864SobmSrojJp66ZayE7NmenGrC0UyWPfmCFHjRUdBS
         4ADTfDDjJvjxuOn8ahgdVHpEDp1PWf1rBvw++GL0hwxApnO2wS+sVBQW8kmqmlOavHqw
         GeanGQIy+NcY72CC/JAhcv1LTI2H8C7lOXrsYmwvl/QptLm3xx/qpssOO86qVQ3mWj/9
         mYTA==
X-Gm-Message-State: AOAM532WALH/DaP0bZkkkcF65pl6HW/de0S7kS2Ij4+CaNdrdl2r3Xbc
        eg/5jppqqY9+yiqXigNWl5lJgwZWxjPn9BeJU7hqKj+9Mtkc5Oxu2BV4aoxOBvY7MxvxkS4bn1c
        PZbmpVF43I4tfl4NEvc/qJB68YCjeQdW8bA==
X-Received: by 2002:a9f:3d8e:: with SMTP id c14mr2753857uai.56.1622205738279;
        Fri, 28 May 2021 05:42:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ85BUBzclvNLh7WIZE3MKmHtee0D8gkvhnzRRLXAKuWP18m1wvUKV55wFGMN9FZrfjQ2RGA==
X-Received: by 2002:a9f:3d8e:: with SMTP id c14mr2753841uai.56.1622205738135;
        Fri, 28 May 2021 05:42:18 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:17 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] nfc: pn533: mark OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:41:55 -0400
Message-Id: <20210528124200.79655-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match either via OF or I2C ID tables.  If OF is disabled,
the table will be unused:

    drivers/nfc/pn533/i2c.c:252:34: warning:
        ‘of_pn533_i2c_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index 795da9b85d56..bfc617acabae 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -249,7 +249,7 @@ static int pn533_i2c_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct of_device_id of_pn533_i2c_match[] = {
+static const struct of_device_id of_pn533_i2c_match[] __maybe_unused = {
 	{ .compatible = "nxp,pn532", },
 	/*
 	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
-- 
2.27.0

