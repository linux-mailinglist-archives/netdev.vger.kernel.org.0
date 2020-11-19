Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206222B957C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgKSOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728097AbgKSOv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:51:28 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E519C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:51:28 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so8283675ejy.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bln1aEoLKijTcwphU9bIkDXlLEs1WWqyUQ9PQCG29ug=;
        b=PEmJ3Wh4cbBc8LZ6Qh1jGPiZeQLi/e7R0F4a8lxQwvwlL5BsW3p5gJd+urOpEoagP2
         z5f6ZD+ilFczr1+lb/0vkWueJYXFlO3Sd5Jz6aED7COQXnt/dUuUOZI7Y15ekcmklt1a
         3RHce51MgcY9oXRLE25xYbo9q0ST/WSMwYpl8lt3/3BlLaSZkAFfp43EUDtgvJep2U15
         HXlpg2qKc5Q9LVwU+AgtZXhxwX1zJ/+9+1Co072GjKL9Rzx3ZbBtjISp+n/UfRYWjguL
         RP7QW3W5NgTej/anQxd18jLM3mK2xM1xiH8Ge7NTk9jdnf4IKBDduguj046NwltapfA1
         3gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bln1aEoLKijTcwphU9bIkDXlLEs1WWqyUQ9PQCG29ug=;
        b=VQWOPNM4s3KqUQ+V4ylJHJOp0mYuFsMusIgCIW760D2u1gXXYpLVGPzRGveq1UmcwL
         Idh6srQESQb70mtkr0lq6BxI3xixdZEG7JUL1ZcsjWgWy+nhY/MOYHktEea0qEO9QchQ
         ytryHdpmxoU9uKm2qZA9XTtOq63vpkYCYbJXJg0Mv6WNgcZjnQBUw8tCxZh3OXZb8FfO
         fVd/0VMV/ymIFH4WfMjilo0PZAaZ2aJ+kn8jURF0PuSYGM1j23yFa2VWJ6t2YiTat6F+
         0+0G+dFr+fXrKLDm2BB4fn6poza1h83I/NVQkpt4UXS7o68C+UKZLf5A//wbGAoIkH0H
         n3fg==
X-Gm-Message-State: AOAM532tsBGZcOfrnR9C9cGt6eJ65eZYvV5tS8x+mPjWPzoqezwQ+tR/
        fSY0Q4bK5UzAyBol5PyEsXPI8sNrYCI=
X-Google-Smtp-Source: ABdhPJwBW2teDKAnMJBKeOn5UIxMfn4Ks5SJWB5crCNGcgFSIX59KiaWagu3fdByFSEDDaQxo9NZqw==
X-Received: by 2002:a17:906:f1d8:: with SMTP id gx24mr28013464ejb.73.1605797486938;
        Thu, 19 Nov 2020 06:51:26 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 22sm14588343ejw.27.2020.11.19.06.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:51:26 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-eth: select XGMAC_MDIO for MDIO bus support
Date:   Thu, 19 Nov 2020 16:51:06 +0200
Message-Id: <20201119145106.712761-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Explicitly enable the FSL_XGMAC_MDIO Kconfig option in order to have
MDIO access to internal and external PHYs.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index cfd369cf4c8c..c0e05f71826d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -4,6 +4,7 @@ config FSL_DPAA2_ETH
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
 	select PCS_LYNX
+	select FSL_XGMAC_MDIO
 	help
 	  This is the DPAA2 Ethernet driver supporting Freescale SoCs
 	  with DPAA2 (DataPath Acceleration Architecture v2).
-- 
2.28.0

