Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D531E495
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 04:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBRDqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 22:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBRDqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 22:46:17 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ED4C061574;
        Wed, 17 Feb 2021 19:45:37 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so597804pji.3;
        Wed, 17 Feb 2021 19:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8uMtznD3p3EhqcTbtr8IDaJ/5CTHRJW4vcAG2UKHgc=;
        b=a/x2jdsRvYukM5hDyg2CEZji4q6K7Crry7yICP4CePs+a2hfVTbr1KrCfv4VCdMv6T
         JJkGTvHhO757JRsrPMJrAw7dZdUt7rRY92pe7Z5w4lknDCxOVVcK2IXeU0QZ9MTg0jtn
         IHw1HcxuXNMPlk0SVDDYZZQd4W2B8MBHKaJ4C0+0om9HfctLli2TwNcmXqCxJYsyQI1/
         mmVm4rbKPZmDEVO2aM6dIn4fNWBTEAKzed+vLl7scNjRjkFTK+FyUG/lfIHiNpzwLIIu
         s4qoHqVoWJVZ38Og35z9tmdx2N5zEB7x+xKBV86qJk2dpSdaWYIjdQAM6oknokYwhIuK
         b9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8uMtznD3p3EhqcTbtr8IDaJ/5CTHRJW4vcAG2UKHgc=;
        b=p1r+2Xpu7quUawaWhCmpqTU4H3T0mi41siTbEpfuzCq5EZYNxhdVzLB1Trb1r9feFh
         zfDHLlkBWCoooRohUcyUuAXtlBt/CQGf8OFCWnXXHRiSqXhsenhlOQ3m+9COstOVzVMF
         neLpUiBXnQmPL8//Y7Di+PibSh90UdmgobyJ6lGMQ+wVlBP6pIEReWpHMF3WsILPjQp+
         ZVNz0AU45io331J8ZXARxRmkz88gt8PUW/5AEDQMTezdrSh/jtEaf7f0+B2d1rlbRDuO
         T5FAzMu9c0FkeqP6n7xADr6jSILp9J0Nmt8Sl9JrO0VJHOyCSlSQz0wDVh7XN3Sqc/V/
         9FHw==
X-Gm-Message-State: AOAM531av84QSMgwE4H7X6lDvI9FgI9+SwMbl5eKxqD2K1IUcw7u1p4+
        BF8e32e0iIRuEegQbqGcl2w=
X-Google-Smtp-Source: ABdhPJwQzBlJ7daHg7E+sNZLTY3HdbG/nZ6uWXP287NKOtMvLlVmZxdiBoRRW/Xf80v0y9iwsx+4sg==
X-Received: by 2002:a17:90a:9105:: with SMTP id k5mr2048618pjo.148.1613619936993;
        Wed, 17 Feb 2021 19:45:36 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.28.185])
        by smtp.gmail.com with ESMTPSA id l190sm3876989pfl.205.2021.02.17.19.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 19:45:35 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Rosen Penev <rosenp@gmail.com>
Subject: [PATCH net] net: ag71xx: remove unnecessary MTU reservation
Date:   Thu, 18 Feb 2021 11:45:14 +0800
Message-Id: <20210218034514.3421-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2 bytes of the MTU are reserved for Atheros DSA tag, but DSA core
has already handled that since commit dc0fe7d47f9f.
Remove the unnecessary reservation.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index dd5c8a9038bb..a60ce9030581 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -223,8 +223,6 @@
 #define AG71XX_REG_RX_SM	0x01b0
 #define AG71XX_REG_TX_SM	0x01b4
 
-#define ETH_SWITCH_HEADER_LEN	2
-
 #define AG71XX_DEFAULT_MSG_ENABLE	\
 	(NETIF_MSG_DRV			\
 	| NETIF_MSG_PROBE		\
@@ -933,7 +931,7 @@ static void ag71xx_hw_setup(struct ag71xx *ag)
 
 static unsigned int ag71xx_max_frame_len(unsigned int mtu)
 {
-	return ETH_SWITCH_HEADER_LEN + ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
+	return ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
 }
 
 static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
-- 
2.25.1

