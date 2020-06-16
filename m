Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C01FB4A5
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgFPOl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbgFPOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:41:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53175C06174E;
        Tue, 16 Jun 2020 07:41:26 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k8so14461876edq.4;
        Tue, 16 Jun 2020 07:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l/4v4uNfxj2Ra/ecZb6XFusYhNP32Q1YssrDECez5T4=;
        b=QO/3jZe8jE3IbTNSTGc0+rbL0jw1MTZPmVlOJ94+3cRo4NQ1kqOUK/ObupR+A7ko5p
         4i6uHenHQWFkQgv/imQlO0FaMCy7EpKNKR7iU+n6N5+Zbx6eB0c5Uef3A1hhsMc9kgci
         +KXZ/2wkQS0I/qy3HydUV/T0apsK55J5UTvI2mr0pk2V0I2XhkHHOdyFlSpRMQZKOvvL
         4DoBRO5c6mYpwQQ8fr4xSJJ7+v4Em4YNRrUpx6iCumxEmbdHTeqwgqrQjzOemNQt76Dc
         Nj3aiUUaeGPRNb7BJSc4tzt9ORV6Wjq55/3GqeOcKjuL6ia4Hqi1fmAycF3LEIQwksm/
         HzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l/4v4uNfxj2Ra/ecZb6XFusYhNP32Q1YssrDECez5T4=;
        b=sDJY/CbHFTFlKkF3uyNgLXBAinj9V9Y0fe+5M/Uf4JsVx1wST5E4Rf8svUcQ4DU6zp
         DQZfXuwxrv3biZ6d0pTZxgp3+Xm48xwqpm7wSEo60tXloI+jsuEuqUNPcarE8GTsxCg2
         7zhlJyCJsi+EiVUftsayADe4p7RD9ssQHpDoS0dBaAxyG/qVBsl+kRyStPSSZnnI9IG/
         zuR/bjnE3PCowTYKJ2jg4REW4umeB1ADGZwHLs3n8cFO8yjXTSu7csGYFvll+4BemAVF
         vw2G/hZb2pDj/77oHUdEvf9o3G055HPZ/RTybSN4/0pUAtXMGO98wkp8yGXo99elBFrx
         reFQ==
X-Gm-Message-State: AOAM531p/rlYuqz4WphL42xKc7Hyg90OIqgpHOjR/ZRPXFnI1GrahYuO
        KI0WCtcI4iPU91XPG//R7ngo6M/g
X-Google-Smtp-Source: ABdhPJxAjfTQ5MsYKQ3ahtPWJqCQ3jUFi5p3FWQNFGkS2dhGlHlrMeRqBZxr7ozocCWUlKHfVjwT8g==
X-Received: by 2002:a05:6402:8d1:: with SMTP id d17mr2761655edz.38.1592318484856;
        Tue, 16 Jun 2020 07:41:24 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id c17sm11264964eja.42.2020.06.16.07.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 07:41:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Tue, 16 Jun 2020 17:41:17 +0300
Message-Id: <20200616144118.3902244-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616144118.3902244-1-olteanv@gmail.com>
References: <20200616144118.3902244-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit 5d14c304bfc14b4fd052dc83d5224376b48f52f0.

The Fixes: tag was incorrect, and it was subsequently backported to the
incorrect stable trees, breaking them.

Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2972244e6eb0..c4416a5f8816 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev->parent);
+	SET_NETDEV_DEV(net_dev, dev);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);
-- 
2.25.1

