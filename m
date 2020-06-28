Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A0D20CA15
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgF1TyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgF1TyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:54:01 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B13C03E979;
        Sun, 28 Jun 2020 12:54:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n26so572289ejx.0;
        Sun, 28 Jun 2020 12:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5AwQdwtfID2u/puIgMbLam+xf3huoq1vXnu8WamPow=;
        b=FbhLWOsy5hN3Yj+XBZf75+l8rvYCOtk92ZDNUrqA9xFV1FBDxfTu8Cvv+VkrAm49na
         xn+Jz9hNP5JnYntKrVJ+iFF5zpcJHq/LNVcRWaxziTBLuiQ3ieXX7ARMisotVH+yObLq
         v281Qaq2x1w6xRJdyEteibsLPb4J1TAtn5fwozLdvYeQPnFR/n0qQRkB0xFIaPkELVhT
         bHpFBvzqUzz2jI0lRjNaHW8wySCE77anb9vjGaFUuy5hGjy73l9/4S1qZeQhcYpAIzZo
         8NEonDLWpWCuKHYzzlLBNDNkuLHl1nGiab5XISls0+1NbcTy3hPfUv8BxrRsCll9JaSv
         9UbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5AwQdwtfID2u/puIgMbLam+xf3huoq1vXnu8WamPow=;
        b=Bfd+hDX9aFWnzZ2gtqCFbELE9eCFJcNNOO7rRctE/geu+uXF+27m2bKuhN9AwpG1o3
         6/LCdbi+HqBEM8YjYPsSOMSM64WeEkG2WXgkNnMht24AeEqbX2n4Kh6OIgidNcC+xRzw
         EbT69Kf/yRlAPV9CHtBo5taCnMI12FLpaWwrDzw6F4CQCFTN8atoHG9QOj1KVEXBLPOt
         2tvQZrgWurtHu7/4o/OL3Vd+cucaW35/2T/Ag9kRz51hSGMkKQcc+1krBGy+AL51RVlJ
         Jk0y5GQLfZBB5AzpMaMNtYv83zRa12ErIRCZYlnVjLjReittk52q3MEOPIPNpPv49pR8
         YpeA==
X-Gm-Message-State: AOAM531cY9nRNEDlqgTcNE+xVndCnM6S6+YG6cNrnfVCn2Iio477xhG5
        H78s9bYL4vdVTqS3tL7iUCA=
X-Google-Smtp-Source: ABdhPJyzQxjzIga1VRSuK67nFui0CBRkn+mtt7nH66aoALVG79Pk8BsBkLSSXRmmxUQOk6JRL9Eeuw==
X-Received: by 2002:a17:906:23e9:: with SMTP id j9mr159779ejg.107.1593374039753;
        Sun, 28 Jun 2020 12:53:59 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:59 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 14/15] l2tp: fix l2tp_eth_dev_xmit()'s return type
Date:   Sun, 28 Jun 2020 21:53:36 +0200
Message-Id: <20200628195337.75889-15-luc.vanoostenryck@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
References: <20200628195337.75889-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 net/l2tp/l2tp_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index fd5ac2788e45..3099efa19249 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -73,7 +73,7 @@ static void l2tp_eth_dev_uninit(struct net_device *dev)
 	 */
 }
 
-static int l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct l2tp_eth *priv = netdev_priv(dev);
 	struct l2tp_session *session = priv->session;
-- 
2.27.0

