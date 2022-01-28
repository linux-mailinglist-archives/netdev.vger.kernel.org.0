Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AE249F117
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345461AbiA1ChT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345446AbiA1ChP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:37:15 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4442FC06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:15 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s185so9763874oie.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 18:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5dgQWYND+e7bBhhq2m8dIyD6s1d0jNZlIUjo2ijeq08=;
        b=iH67ShbEMI2ZxcAFNSqcaX8h4AP1joQfyGy/6PWh8HAmatXpc8K1eFPnNLsxOrdvdv
         AIY2aBY8uMfvh2yC1fo7mrxVKjr2qf3SBJfYMNoSBhAyvojhIYa71ucDF8SvcXaWefQC
         5H48MRVKIgARZmQEjVHxQ/E2dosArSjgB5km2ClePt8igNMeoWyW48ICUk/EUpoCB1o7
         J1qHi2hp8HJFxD8G2AEHAIQZm9MSvlgT1rzZ10q39TSuzuap/THB+qT+ttv++6XcvWHR
         Qzw5L5o5bRu8Y8QWH4Tei2yDOb/R9DW5dfnS1R9eoEJrGIHmj+xzhb6QZm9kfOi5Go5G
         7l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5dgQWYND+e7bBhhq2m8dIyD6s1d0jNZlIUjo2ijeq08=;
        b=mgrsD1fYEOnm6pF2O04CZmRwjhmbvf6gcUkyLK2/u5C4qPoNeO2AU5qXJkIRV3v+1V
         L/VdRrcUCWycS8AvYA+CwzhrM6smxy/Lybnuc1srSK4hmoPf0eiDzdQfmsaCEreHUUY/
         EIrRVImEXlYIssW7JIPeNOFw7vXYVsElXbVHED6YqDSrjDyCut/YYl7Ljz23dzDf81iw
         B0z49X6dYseS4XEFOASzN9lyf48efufcfjh/le2YmH0OVQ6vdU3ueFV22W+SQ7njX2nu
         Zo4o7qIVw/R5sL1RyBqgQ4yjqAazgiB8sq3GNocT2sRUegnQkRIqpQ1A+8TQVRuX/cj6
         ZKbA==
X-Gm-Message-State: AOAM530bTfe31q7/DAFe+G7vE8K297gRXYaz2OJBfbzVw361aQYZ/JX7
        Fn5Tu27iANizd30I6V1K1ODtkbrR4vc3eg==
X-Google-Smtp-Source: ABdhPJx+iTZgNj5eNAO+jFQEOtJ29iGn2MikfkgfEp5+AKpUK3mc6OBoRvLSaQDRa7hkcQXPMhmoyA==
X-Received: by 2002:aca:e103:: with SMTP id y3mr8947490oig.146.1643337434462;
        Thu, 27 Jan 2022 18:37:14 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id p82sm2586920oib.25.2022.01.27.18.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:37:13 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v5 08/11] net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
Date:   Thu, 27 Jan 2022 23:36:08 -0300
Message-Id: <20220128023611.2424-9-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128023611.2424-1-luizluca@gmail.com>
References: <20220128023611.2424-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index e115129cd5cd..b22f50a9d1ef 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1973,7 +1973,7 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->priv = priv;
 		mb->chip_id = chip_id;
 		mb->chip_ver = chip_ver;
-		mb->port_mask = BIT(priv->num_ports) - 1;
+		mb->port_mask = GENMASK(priv->num_ports - 1, 0);
 		mb->learn_limit_max = RTL8365MB_LEARN_LIMIT_MAX_8365MB_VC;
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
-- 
2.34.1

