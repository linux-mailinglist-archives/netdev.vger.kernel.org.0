Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCCA207389
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390586AbgFXMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389336AbgFXMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 08:40:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921CEC061573;
        Wed, 24 Jun 2020 05:40:23 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so2291792ejq.6;
        Wed, 24 Jun 2020 05:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bn5TVU/nW/bgfATcG9+z6zl/KPajXa2DYKDGrKOJLu8=;
        b=oxyHXCiGH+fToizrLcsX+wtcUo3wwAnL1rg0ZciTerqCviZfbzxBAjL3PIiyUGBvz8
         +B0Ii0iMnmnQC8sRG7haR8F93KgvZffcJy5db8ofmvf8fb7qnIersn7yMgnATcy2kJhg
         vjnpdwPik0GYsGC3lvymomApMmyXXA4QobMzNLV79MvRkdhRIOSBEzKvBEWVvF6kUPOg
         8atkSUsUmX9NEBeoxfOg+zr3nFeyNjT24bWFcC9rp4KkJVeaam0GC0mdUecrSHwtF+MB
         RIELcW4j3TaJqzbpZMbOkdlyGrhDdWdLT2NDTQ4zY9ANvRu+N7AEH5WxIujJFTAdpdaq
         mscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bn5TVU/nW/bgfATcG9+z6zl/KPajXa2DYKDGrKOJLu8=;
        b=Hjv3UtGxwPdB5E+NoGIYCzkFLh0J+rsaJaXDNsvE+sS5KyGEwKkthlfMVVHDHZ3Igv
         BqJRiqrhnJFCzr+/56wqgLqBKoNYZh3tGU3uUcngWYE94wMmqWtiDyX5Rt2F3CQCwequ
         i0Gec/oHXsVqrvd1zmRBmzQhpXRRxhqrs1GlED10C6h9H5heVUlFrqECTSKrexA8+L1E
         SwrvDUU9f+iq8wSsWnWvw6gwDv52trsBtPLaczkHk+fMuD5hXrI6XbCY63NFPWE2XAQL
         PZk+hQLemv4UACIptgfclHGKNqJtxSgQMCIFF6kXThW1XkbBn+cFooFbh8AoKdL0c9kU
         rd0g==
X-Gm-Message-State: AOAM530WbZZ1xaLWdS2fFeYnUG2UJdGJvIZU49JCCbXAdXESmGmt1Wne
        tSi6hb/TqXs8MnQZirtPbYb0z3CU
X-Google-Smtp-Source: ABdhPJwFbEj5+vtIVk799zais4HB5rvWpOC3PBuRy84HW5qcliF+P2+NrOLo/TVF2E4vpTgREF9EDA==
X-Received: by 2002:a17:906:4b16:: with SMTP id y22mr3654476eju.4.1593002422079;
        Wed, 24 Jun 2020 05:40:22 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id gv24sm10605997ejb.72.2020.06.24.05.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 05:40:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Cc:     madalin.bucur@oss.nxp.com, camelia.groza@nxp.com,
        joakim.tjernlund@infinera.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH stable-5.4.y] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Wed, 24 Jun 2020 15:40:13 +0300
Message-Id: <20200624124013.3210537-1-olteanv@gmail.com>
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

git tag --contains 060ad66f97954
v5.5

which then means it should have not been backported to linux-5.4.y,
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

