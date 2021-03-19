Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721C2341EA4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 14:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhCSNop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 09:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhCSNob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 09:44:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ECAC06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 06:44:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so5272704wmj.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 06:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SrPXMdsT8fh/wUuXWu6/XdTRaAoBqvPSi7osz8TT9SU=;
        b=U6R1VBR7eogovqe6fbsKMg5rSPuVNlwRpsQj7zgx5iIkAphJM281y9IMs1+1oloRuU
         IXjNVsdVkcYMH5Uun5Tb6+DKDB2ll9TYNJLw/eHctGukmi5uDfwSVInQd3PgXwYe4Bm8
         lhnpZqaKhEL1Oti1UB3WgXu/ALz2kAcvM8mUENcaeWbbcBX64Q+X8kLVaT73LZ/d0KAy
         TJ/kIbZvOxysalhkY703OtBRqgLboDTt0gbUQL9KfTUfz570+kqI3M4j5NthsgESxZ1D
         nnCryXE7M0zSct8hpFrH6ZkSdaH9rsDGG63WNBQoHDokk9QPG85SqWvPb96BMXZ1zYat
         2Vxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SrPXMdsT8fh/wUuXWu6/XdTRaAoBqvPSi7osz8TT9SU=;
        b=Znuz7NT4yaQ6kCdh/ks1xgytePSc944bMYj4IQ3bXR4s9AQDaQrFjpFXp7JVzbXdlC
         MgzUye6ru/qWKF2wpoMHkR5E3ZCO7aL0NwUbZdWrmRH20Qsb3VZ0lmW1u2/WB+ADdsiz
         RWPX5DJ0MIVshUCx5zBD8SqyJ2SPfKnZr1T0ewc9fTf/TD3h1bxJf5e+tml7Q2VK9H80
         BB2safNIkZHg/6hW2HcWU6XGPbP9We7uWzNOSFCPl4W+CGSPbqCUEfBtNyc2/59ItXtf
         fW2ZT05GSowjE6qjRp6tIdHHckd8awGZ6CLA035tgCyewH8DxoIyXncinhru4BKU8ygm
         CgOA==
X-Gm-Message-State: AOAM533uctPZY0DJhq497Tc8LnpwX/MXFd7CF4KauxY/+k+dZXDsrPwM
        w9woHcMEAFJXhg1s1juj38ReGQ==
X-Google-Smtp-Source: ABdhPJw0eghg2ZDKjaor7MbxmSXtlraqPUEAPJEv3PG9iEAsL4DxgNxTwpwnFkISye/A6z/DYyY8FQ==
X-Received: by 2002:a05:600c:4f14:: with SMTP id l20mr3772915wmq.71.1616161470266;
        Fri, 19 Mar 2021 06:44:30 -0700 (PDT)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id h8sm7829080wrt.94.2021.03.19.06.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 06:44:29 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        jernej.skrabec@siol.net, joabreu@synopsys.com,
        marek.belisko@gmail.com, mripard@kernel.org,
        peppe.cavallaro@st.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] net: stmmac: dwmac-sun8i: Provide TX and RX fifo sizes
Date:   Fri, 19 Mar 2021 13:44:22 +0000
Message-Id: <20210319134422.9351-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MTU cannot be changed on dwmac-sun8i. (ip link set eth0 mtu xxx returning EINVAL)
This is due to tx_fifo_size being 0, since this value is used to compute valid
MTU range.
Like dwmac-sunxi (with commit 806fd188ce2a ("net: stmmac: dwmac-sunxi: Provide TX and RX fifo sizes"))
dwmac-sun8i need to have tx and rx fifo sizes set.
I have used values from datasheets.
After this patch, setting a non-default MTU (like 1000) value works and network is still useable.

Tested-on: sun8i-h3-orangepi-pc
Tested-on: sun8i-r40-bananapi-m2-ultra
Tested-on: sun50i-a64-bananapi-m64
Tested-on: sun50i-h5-nanopi-neo-plus2
Tested-on: sun50i-h6-pine-h64
Fixes: 9f93ac8d408 ("net-next: stmmac: Add dwmac-sun8i")
Reported-by: Belisko Marek <marek.belisko@gmail.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 6b75cf2603ff..e62efd166ec8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -1214,6 +1214,8 @@ static int sun8i_dwmac_probe(struct platform_device *pdev)
 	plat_dat->init = sun8i_dwmac_init;
 	plat_dat->exit = sun8i_dwmac_exit;
 	plat_dat->setup = sun8i_dwmac_setup;
+	plat_dat->tx_fifo_size = 4096;
+	plat_dat->rx_fifo_size = 16384;
 
 	ret = sun8i_dwmac_set_syscon(&pdev->dev, plat_dat);
 	if (ret)
-- 
2.26.2

