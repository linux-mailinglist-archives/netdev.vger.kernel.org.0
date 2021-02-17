Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775EE31E094
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhBQUff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235105AbhBQUer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:34:47 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B17C061574
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 12:34:06 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so24645552ejf.11
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 12:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oBgt9Mq/k2E06yHdinveNHfec7fr5BheObUa3x/HQvA=;
        b=qJ0MFutX5bryr+hSvoxaEvu7re95gbLvQZJxN5UICaKT+1XxoeoZvS4NzbGWOWvQfz
         wbdsGw9ZLdM1pBklrRz7dd90SkApdiYmR1031PG+oR5SFCUklg9Xuv7l+1Okbl22khfO
         nJ3A4YI6UHf83SKQJ2dfo43omcnNMKhnamFZKxV8Muj0HRamAkJuFoDjkcqHN/wVaidn
         91ZUkgI03NEfHdNfBfJ8fQOhwylMWSndgJCHK81E46l7U9wP/cbkh/WDIxuXv48GRdKu
         pnXNBJAgDA29gpkHRZw6Sh+hqblWKEXqE7j7y+4fyCC9Q3qLSsVs7Zx2M1QOSoMweWhI
         Y8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oBgt9Mq/k2E06yHdinveNHfec7fr5BheObUa3x/HQvA=;
        b=e3ZMbKyWLxEcaeuoKKCgsosV14CI3rl3vHt3i/+/zZ7P7HKLBYpXGVCQNZ6VF0reyT
         oL2wY68Yfem0/2/0zxtRjNj11TcuHXYPSP9uSK2nQwcJ8OVRXaUu1YAbM4gtUzeRh4YV
         APFO3PIdMSNqSwSQEAVKRcw6D5GyipNnjFTxCShFbN6a6Iyv7F49Rz10iKXmZtqhdCyb
         BvMNtWRTqx5P6rLBItWWrgFB1cOHKd8/GuJ5ziVxifXhAkMiF6dee6oGf6CrzzJohGmU
         299T4aly+uGIOd85NJxCxEDEazkmHQb2ibkj2Phw8cv0VFqwJM1cqnro+sKJA2ZWNUNz
         ZYdg==
X-Gm-Message-State: AOAM530khHRrCWElgHmwYMyR5iL+yKOF2jjUIB5sok1aeEkl4LeD9ys/
        anVkLMPj7Mum6CR9RHjtSL4=
X-Google-Smtp-Source: ABdhPJwz6Ioff91yIN7pH85ySNvz4qFxgqIFa8BCkv9tvEoaRvqcdi44xTDMazBj8vj6Jc4F3GL9JA==
X-Received: by 2002:a17:907:78d5:: with SMTP id kv21mr668252ejc.461.1613594043626;
        Wed, 17 Feb 2021 12:34:03 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id y20sm1577380edc.84.2021.02.17.12.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:34:03 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: mscc: ocelot: select PACKING in the Kconfig
Date:   Wed, 17 Feb 2021 22:33:48 +0200
Message-Id: <20210217203348.563282-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Ocelot now uses include/linux/dsa/ocelot.h which makes use of
CONFIG_PACKING to pack/unpack bits into the Injection/Extraction Frame
Headers. So it needs to explicitly select it, otherwise there might be
build errors due to the missing dependency.

Fixes: 40d3f295b5fe ("net: mscc: ocelot: use common tag parsing code with DSA")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index ee7bb7e24e8e..c0ede0ca7115 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -14,6 +14,7 @@ if NET_VENDOR_MICROSEMI
 # Users should depend on NET_SWITCHDEV, HAS_IOMEM
 config MSCC_OCELOT_SWITCH_LIB
 	select REGMAP_MMIO
+	select PACKING
 	select PHYLIB
 	tristate
 	help
-- 
2.25.1

