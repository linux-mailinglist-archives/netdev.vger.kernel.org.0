Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BB11FB5F5
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgFPPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbgFPPTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:19:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E592C06174E;
        Tue, 16 Jun 2020 08:19:50 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n24so21960773ejd.0;
        Tue, 16 Jun 2020 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h6YpwHWmqVDet/aw3KTdSTcGMZv3RJhbQkb+9BUai5g=;
        b=Nk2UmaMalq7kg2zDeOcMSpxl2FckJgpbm60Vcm6VdCFHCNKPjb/4c4s0R57RiX87Yq
         SpMaFOrJQ4Lc9W6rLa+fWW5ncqTgeo/mK5dVykhNXozziCP/3BNMckM8rIIwsQbaoete
         g3EJDalZ7P9jepuUQtN6NZTYFPVXWsUl4eismAFt9rS64K4jAOrkRHbfnmaMk/Wtnbu3
         9yauGGCGY7mLz0NK+ZGOAV2a8udQUHf7o+ZBZnvbwQN7MRuU+mVIVbcy5b7/z27eDRwl
         Xe25pjtF2qnqP/YygsoZRF/psvE9dWErPRqZxC4/sNMb0vTVu+RCcbESuIQCvOkiqa+w
         PZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h6YpwHWmqVDet/aw3KTdSTcGMZv3RJhbQkb+9BUai5g=;
        b=higKCOKSGlbdYjNQMDtv+6QbWXI3jKyCaVdKyF4gzle+XfZFBh8MF4PkGnjSmLAQsj
         5VM0C85cKw7ghkCPaaaqJeMaT2yCwvY8rlE0GRSfAJWeDKQGZxFL8WixfBhbebBo2ZZz
         sWAkLJ4p31+FgBGXUdLh5gnRQehaDaH4uwzWqTtuMVNGUh3uZa2BlsARFYsI3A0Ppdpp
         Df3+fyKKbfRvjNjr2fnv2eijcJgnCgobxlRFU5EY3+kJyCUlhSnfT6l0vDnJ4m9ifBYT
         FvdODLaU0dTGtq0Pw7Qp/SLISE55bH8KaCHADCHPxUm7E7yiPYq+aI0J3ogi8gPhoGxM
         r9tw==
X-Gm-Message-State: AOAM530msgCPvZ39Q3zDsT3BL5y/9Sx+T/Zhx7eyT+YrCSO7jqwwgBhY
        45rwizerslDnJBqLDRj9qis=
X-Google-Smtp-Source: ABdhPJz7XeMNeeFPtzrv99qSLkHa81roBxeEHK5L60seimHiWpiueJzNvQLRhbN6xLYqoObCP5xQnQ==
X-Received: by 2002:a17:906:3e0c:: with SMTP id k12mr3170425eji.441.1592320788874;
        Tue, 16 Jun 2020 08:19:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id ce23sm11368587ejc.53.2020.06.16.08.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:19:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/2] Revert "dpaa_eth: fix usage as DSA master, try 3"
Date:   Tue, 16 Jun 2020 18:19:09 +0300
Message-Id: <20200616151910.3908882-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616151910.3908882-1-olteanv@gmail.com>
References: <20200616151910.3908882-1-olteanv@gmail.com>
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
Changes in v2:
None.

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

