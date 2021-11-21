Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84EF458445
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 16:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbhKUPGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 10:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbhKUPGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 10:06:03 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD7CC061574;
        Sun, 21 Nov 2021 07:02:58 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a9so27742597wrr.8;
        Sun, 21 Nov 2021 07:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=7eqor91/imhfG72H3lrj1aVDpyF8iy7jgStipaya1tw=;
        b=LyCHdXqfKAmaXgigAFrww+HgSpbc/NiFgGuQQ6zmSfpgu2IZNcQampoLBAjZvFYra1
         qlYInC+ZbEeRHqG43MmF6F7cCkvQU/ogXuqLk6QltbcyNn31jTIh0qfTWg+un07vSoyT
         Yj8We1EJ+LEb3jY5gLMTjOj0wkeJu17+SvEyZB9tncbAEeRTamvFq1Lk2GuoN9zq2GKr
         cA0dxvLbnA8PvTWCb2VeagVEdhbJJsFHafEhU8Ryvrdhk8TurS4Pza+ANd2i4lVEqmXU
         eH14g7WfqS9AUpnq+OOOKrDn6A1GRwnFZS/xtMG5zDHU9kV6uhgM3xjIh0S5nJhwY8rN
         JcLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7eqor91/imhfG72H3lrj1aVDpyF8iy7jgStipaya1tw=;
        b=oTpskWZVf1DJYwA8Cjv32ErTeuvHh+5bPigCEqzUZe6zTVK+OhovUdbQy9QT+/K8wk
         c1gpTnLFiDE8URz8VpuvJb2ZBLzIDs42YWC/ZDmzQye10XJlEkCytwtaW0lwNX6Vkcnc
         oHDyc1SJNiSC/GGr2wHtgftiwNoG4mY46JHnw9Slb6zdZ92VivBapr9u4x2lS9Q/NwFJ
         Cq/7DpmJtOKgnm7zQJbJ7VAbSI1P31Wljk7kaKlg7AcVi8rDrXquGW1Ac40twRbnk6gq
         uy12oe51+A9dicc9VnqlCCG9IAhItSiXRWSbA+fn9o06nXn2IDZT81q0hQmgbtQaHAu3
         ExyA==
X-Gm-Message-State: AOAM530Rz0R4aLJjVmQohkQ91PAAcVvWJnXKAzKT3LciHy8lUxRpQP9f
        HKI7Yt/v4diWTYecgQU0kh8=
X-Google-Smtp-Source: ABdhPJw9ymZYq+3sS+QnRE/KUrRNLZmhJC3mzLHo42GAbJELsCum88Bm+sizc3Gg+e4LV85a/8w7OQ==
X-Received: by 2002:a5d:51cf:: with SMTP id n15mr30269347wrv.106.1637506976703;
        Sun, 21 Nov 2021 07:02:56 -0800 (PST)
Received: from yacov-PR601-VR603 ([87.68.152.183])
        by smtp.gmail.com with ESMTPSA id f15sm7579952wmg.30.2021.11.21.07.02.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Nov 2021 07:02:56 -0800 (PST)
Date:   Sun, 21 Nov 2021 17:02:53 +0200
From:   Yacov Simhony <ysimhony@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix coverity issue 'Uninitialized scalar variable"
Message-ID: <20211121145624.GA5334@yacov-PR601-VR603>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are three boolean variable which were not initialized and later
being used in the code.

Signed-off-by: Yacov Simhony <ysimhony@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 57c5f48..d23c3f6 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -513,7 +513,7 @@ static void macb_validate(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 	struct macb *bp = netdev_priv(ndev);
-	bool have_1g, have_sgmii, have_10g;
+	bool have_1g=false, have_sgmii=false, have_10g=false;
 
 	/* Determine what modes are supported */
 	if (macb_is_gem(bp) &&
-- 
2.7.4

