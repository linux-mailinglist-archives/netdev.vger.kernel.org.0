Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA32034FC
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFVKlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgFVKlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:41:31 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ADDC061794;
        Mon, 22 Jun 2020 03:41:31 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id m21so13200592eds.13;
        Mon, 22 Jun 2020 03:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=at/r+Ih6r6041Lo7roIJWIdBavgd7AgczNOOvJzY2AM=;
        b=sMPRDl6qJ1RjUnRYOYB5CF7jALpIeH6ZmV9um3WLYR3zJK/AdG86RmmrwD3Uzfxu1r
         37tA5TjO9up/mT9zylXXLOl5p0IYNLX8DPLctLZUJ8Q0hhzcPxrOl0ZlYYC0g+4mlcsK
         ylboPAe/qPiLdxwSS2DydET4TyeflQ8agZ36xUUywGu9PGhGxlKxkhm5fvTAacbbmdA+
         qW3GFT/+eKCTOv9De8k8YsASGec4KqWStZYGarw7YZ63lM20h7V7lRVOVwu6+LPPGSWg
         BCBgB6Ddedw+CqOuO0o9DdflD0R4m8BMaH9lP4w+whSSz/KwXB8bpc3p3gfENBkhOQtN
         SdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=at/r+Ih6r6041Lo7roIJWIdBavgd7AgczNOOvJzY2AM=;
        b=WhG4JFCI9V71wa2ORgR6Y+3MVMOyTAscsPzBoANjYL3JWuTs71O5gzWvIoWTj76oZZ
         D5ZjyEXYfQnZaHMMVA7nNh5kiz3kMQhfMNXVZlpfRx6EDY936NYr+CRwuWl85mKKp8pr
         Ixq7ziRJb5OMG1jUIB2N/B5VezTf8Sadf7ihIeFVUJ+kcRyj4SmAl9BXyoJwBFXjNKqV
         fjkeKOTliv/00lPRZgP/EyREyrNRiFrel/gsMntSLJIhb6vxtNRyfgT65P1F+nSAy2+j
         rlWYZXtJnjjTn265epX50ZupqiJyzFxzGpTrH0hPSbFbvCJTzORz9bFS0ekRGJD0dpGy
         r9uQ==
X-Gm-Message-State: AOAM531OrQ8rAZVVDEYya52RQ8/YFAeKaRjhdzD0omuqxnwg9PkQnGGS
        m6g8y2Z/dSIgeKcIjrctf/Z97bsX
X-Google-Smtp-Source: ABdhPJxopCQl67U/hFUEMcMtku7eR8/uoDIn6bz30QSfq5oEeEoKY75jCezPewbKzZyzNeAsQDjBjQ==
X-Received: by 2002:a50:fb01:: with SMTP id d1mr16207046edq.94.1592822490228;
        Mon, 22 Jun 2020 03:41:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id t3sm11367507ejr.119.2020.06.22.03.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:41:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Cc:     madalin.bucur@oss.nxp.com, joakim.tjernlund@infinera.com,
        fido_max@inbox.ru, linux-kernel@vger.kernel.org
Subject: [PATCH stable-4.19.y] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Mon, 22 Jun 2020 13:40:41 +0300
Message-Id: <20200622104041.436940-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This reverts commit b145710b69388aa4034d32b4a937f18f66b5538e.

The patch is not wrong, but the Fixes: tag is. It should have been:

	Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")

which means that it's fixing a commit which was introduced in:

git describe --tags 060ad66f97954
v5.4-rc3-783-g060ad66f9795

which then means it should have not been backported to linux-4.19.y,
where things _were_ working and now they're not.

Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6683409fbd4a..4b21ae27a9fd 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2796,7 +2796,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev->parent);
+	SET_NETDEV_DEV(net_dev, dev);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);
-- 
2.25.1

