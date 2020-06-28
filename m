Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AA520CA30
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgF1TzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgF1Txu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:50 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527A5C03E979;
        Sun, 28 Jun 2020 12:53:50 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id h28so11146592edz.0;
        Sun, 28 Jun 2020 12:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pCi2aD3tv5ST/a/DsPqPX7Y3piJk+0Ealzz1YbxZv30=;
        b=tpZRnsO/eN+KxN0fx3K5tOgplIrKMno2Ja9sH5yGG3MtFuoxdL5lLYGSHOh/Xe4wVy
         dCvqI5w8Y5oxOWmCd1FhG3MAuceDn2mq63E4dgpcrZcORTeH8bo+kmfmmQB3y3Mn6GIw
         ljx9qO+qgRxtzORKNYp1eefK2LCJiQv5U3LXWdu+GgIa04hKGYTULr384Gx7YHB2TQDu
         HxtQJJw/uXsnSqmpJ6nERHVMrmBC+PEevlnFMI8tZ7d67qv2DCaY+Cvh33RT807VuboO
         Iz2ZHDcV3QDheWWcWFyhvTblJk+dYdovEEhDfmnnMVneTQzNVumXL8nAJ8mrByTbiUqw
         WkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pCi2aD3tv5ST/a/DsPqPX7Y3piJk+0Ealzz1YbxZv30=;
        b=GK43PVxnYpCLNk/6jQpwKGtlaPiyWrq9n0rxVPjd2mNBqzXf4u5qLPM7gMDyP28xc2
         xty5CWpHw9IZH1SEm0tPBMdUtNLSLQMPitCT1zE4L+hrbQDKwJ7Y/NI4lDnGPApnRNUf
         G+ffMndld9WtG+3N5SXx1kdWWBcmPv1lWalZ5tDpo+pvKF+TU53Eh7QmShpSw+RhqpSd
         ztMaIUMVgE0oqVbGQkIACrwvTtQSTewBCOykQDcUG190TJ1dq08rVNkZYmcZUE1JbE42
         fcJsocpVB10mW/JGDXNj2qryxonSY6Oj9niC9MpQzvFTAPRQneh9MKed2fS13/yJoUV3
         JHrQ==
X-Gm-Message-State: AOAM532JSGv1k1ohBO75KtRFsKt1oDD7RRZ/bgRQBvZgARz50e6EqAAZ
        I1+DxVXUNh/AzobhdX4C1Fg=
X-Google-Smtp-Source: ABdhPJwbJADA1syV4LLKf41oJs+nJMUDIZNnLfCgYxz3265iuheg5lFIWOHOdYkb7UbO1Rt9KlfTPg==
X-Received: by 2002:a50:ef10:: with SMTP id m16mr13666297eds.206.1593374029142;
        Sun, 28 Jun 2020 12:53:49 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:b7f9:7600:f145:9a83:6418:5a5c])
        by smtp.gmail.com with ESMTPSA id z8sm15669531eju.106.2020.06.28.12.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 12:53:48 -0700 (PDT)
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH 06/15] net: arc_emac: fix arc_emac_tx()'s return type
Date:   Sun, 28 Jun 2020 21:53:28 +0200
Message-Id: <20200628195337.75889-7-luc.vanoostenryck@gmail.com>
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
 drivers/net/ethernet/arc/emac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 38cd968b6a3b..b56a9e2aecd9 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -673,7 +673,7 @@ static struct net_device_stats *arc_emac_stats(struct net_device *ndev)
  *
  * This function is invoked from upper layers to initiate transmission.
  */
-static int arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t arc_emac_tx(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct arc_emac_priv *priv = netdev_priv(ndev);
 	unsigned int len, *txbd_curr = &priv->txbd_curr;
-- 
2.27.0

