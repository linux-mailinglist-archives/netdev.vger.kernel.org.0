Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C9047CD49
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 08:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbhLVHIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 02:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhLVHIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 02:08:41 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E11C061574;
        Tue, 21 Dec 2021 23:08:41 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id a9so1537447qvd.12;
        Tue, 21 Dec 2021 23:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+4MJW7EYeQHdXBq8fuiaiXyr4Eoc+IH0oj+VCDJk7v4=;
        b=RdYFOp1H/dzVftbwpZI0Z7aD4Iao8f/aMrVo9kgh7jAe/tfW9IP4rwsG3xez0bOLn7
         uPxQeapHzHRMOf2NoYMnUdGIE8GTDt2/vNcw40m/Zo1EJ+zUH+p9Ia238STB2n9f7WnG
         OPpIAXS9rkuqugaaUBmW1B5Uuob4us0p7cNeEAHlj5uk52s4Qqvqey+P6k/uZGfmZFrY
         fA2BIKhnvTL3Pq9vNq3y9CBl7XqX0XO1NzKPxS2FTWn0nsco0YwR/NNpWn/nQwnsbhHU
         qlCjfkHBkIkVuOlHE4/dKIDl47wqB5xdORga/RCKzXWQGPL9EOlwt8OEv7zVaRF+T6H7
         YZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+4MJW7EYeQHdXBq8fuiaiXyr4Eoc+IH0oj+VCDJk7v4=;
        b=RfAstlceABPYdvRlx/o5X+p94rl6Qdwx016UYp6WVvn7pfxFeoIb8+Q5S1Vpjs+7Ep
         GiIE7GJrWqDMTiHAPHhw3CNoBumKzfhGMXq391xIWlJyyf8/HlFiNO31xiywPxwCZL9N
         q5nAYyJwlPjsNtmmvuBQOokHjcXpoeQimvsj0JvX2XOXjHnApLmaamONwJCeU/4mI27D
         vD79nEiI+QTGii2V7jk04RDvv/spNE1fVGVDMbf2OVbgIWChaPo/m+rVWOz43PlVV3Zu
         ak/tdveld1N8pnvM7O5TowHFBJ+F8UO8WDKW3r5quibnXf44Zii6NqiwBvYLIuSJhLDo
         iq9A==
X-Gm-Message-State: AOAM530ukqPOHTBmJxTL+tW2VLDR1oQ9bbQn9fQpAUqQOiazSN3cTC/m
        /wol2pyhj8m/Nn1Yy0CCuZs=
X-Google-Smtp-Source: ABdhPJyelLbKC0kyiz9F4RZeKMmEV3QXFd9sVgMH3N4W2+t5Y1UD+x2qQMtMeif1fgxUVcLpcbGuDA==
X-Received: by 2002:ad4:4027:: with SMTP id q7mr1379019qvp.117.1640156920410;
        Tue, 21 Dec 2021 23:08:40 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c1sm1034997qte.79.2021.12.21.23.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 23:08:39 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     kvalo@kernel.org
Cc:     ajay.kathat@microchip.com, cgel.zte@gmail.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        deng.changcheng@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, zealci@zte.com.cn
Subject: [PATCH v2] wilc1000: use min_t() to make code cleaner
Date:   Wed, 22 Dec 2021 07:08:15 +0000
Message-Id: <20211222070815.483009-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <164011040619.7951.14619016402908057909.kvalo@kernel.org>
References: <164011040619.7951.14619016402908057909.kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min_t() in order to make code cleaner.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/microchip/wilc1000/spi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 5ace9e3a56fc..1057573d086b 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -674,10 +674,7 @@ static int wilc_spi_dma_rw(struct wilc *wilc, u8 cmd, u32 adr, u8 *b, u32 sz)
 		int nbytes;
 		u8 rsp;
 
-		if (sz <= DATA_PKT_SZ)
-			nbytes = sz;
-		else
-			nbytes = DATA_PKT_SZ;
+		nbytes = min_t(u32, sz, DATA_PKT_SZ);
 
 		/*
 		 * Data Response header
-- 
2.25.1

