Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6524040F4B6
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 11:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343547AbhIQJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 05:25:37 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:48672
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245714AbhIQJWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 05:22:55 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9985F4025C
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 09:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631870492;
        bh=UKlAzsdkGy5Ivo7U8LqMCGMJPYyzm2idKi8StxjfYyY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=R+Pia2VCSZ6nVJfvuTDyaGg6x4w0+FIG87PqfG27HEzG6/p0fTw4xKfAtH7HnJSdf
         LUKasLMs3QoEKohAfzcJJxBaDVnPJTu4Q6Iilz+sqw5Myi9xPR2Mv2aVd0LmmOrEET
         yBRFqm/3I5e5F6t1eZSpNAIPOdQAheK+McusGq+vLMAA826xb0cTufQ8ko2fAg6esd
         qhRiBqM1y/QXC/z0orOY6row/LzpqIxZ5YunKqe+4y/nBurfs6t4a2j0dr+utHFwAu
         4SwcUL1GAx4nRFy6drMOaa7nDRGkhKAkNz/ATNitwiL7K80T72lumX4AEDnfLq6+eR
         AwHVFx6AgDfLw==
Received: by mail-wr1-f72.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso2169163wrb.20
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 02:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UKlAzsdkGy5Ivo7U8LqMCGMJPYyzm2idKi8StxjfYyY=;
        b=JkUpe97TAS4jFtSP53mITBLSWVkHtK5Py+saFzbD4vgvd4QjKO+xl1bLaY5KlPuX6K
         BIZyAt0pyUCjFS+e5y6OvnDmeRU3Ic92A7tzs+loAkr26RZQOjbqNVEPnUjsxZToKa0b
         EmE7tWXtu6ed1A0T2QeEXOlPtfm3MklQBPv1nvK3T59TVD51GRSh1AUzfANdl8rLFwPz
         vxw6Af8DX7cLRpN9CppONkPAWzwV5a6XUZIqHEHMHH65700g0BnL1xruuT/M0NDraQCk
         Nof3yrDFjR+kAOpd/dpoYubqyvZUSvigkvhCITHDlCqII0hjhhlkxMzo3J43ZK5+FthP
         w09Q==
X-Gm-Message-State: AOAM533FLisTmzZMZYstUdw0BX3D79v2nNyuo5xKsRiQx9M3Dq8NkmbQ
        j49VLu6w7ydSRJ4BdUubpJOnPRR6Zzriy/CCemLidHtFEfAV+TyXOVbS1Kg7OIPRg6F7s317+0A
        KQ3dzzNmPSGWBr6g3NHYLrK6DSHG5s/9y0Q==
X-Received: by 2002:a7b:c5d9:: with SMTP id n25mr14401830wmk.120.1631870492299;
        Fri, 17 Sep 2021 02:21:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvrZ0a3+0hizOcHHHoNzf7uUykimEKLTwGtpiSFv+u0RBZBQt8E/GTu0Xp+bUAKXnJWE810w==
X-Received: by 2002:a7b:c5d9:: with SMTP id n25mr14401813wmk.120.1631870492165;
        Fri, 17 Sep 2021 02:21:32 -0700 (PDT)
Received: from localhost.localdomain (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id c17sm7516772wrn.54.2021.09.17.02.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 02:21:31 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: freescale: drop unneeded MODULE_ALIAS
Date:   Fri, 17 Sep 2021 11:20:58 +0200
Message-Id: <20210917092058.19420-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MODULE_DEVICE_TABLE already creates proper alias for platform
driver.  Having another MODULE_ALIAS causes the alias to be duplicated.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 80bd5c629fa0..ec87b370bba1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4176,5 +4176,4 @@ static struct platform_driver fec_driver = {
 
 module_platform_driver(fec_driver);
 
-MODULE_ALIAS("platform:"DRIVER_NAME);
 MODULE_LICENSE("GPL");
-- 
2.30.2

