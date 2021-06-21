Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932453AF208
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhFURdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhFURdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:33:36 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBA6C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:19 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m21so31472906lfg.13
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SRF1siafcqtmCniXw5Nr6PWjFLq9MerPfEtSPjlMtOU=;
        b=w63SC6LB9NNI8xSAN0CyoCMee3khLwev7hcMa1NB3i+nVGYGsy4lAmVGHNt/tax3yT
         dU3YpNKH1iMryTxcBYdagpuByFlmwwiPbR3Zb0/wdfRXLidCXaJCVl7gAO8F8sZFn2fe
         3L+feREBAX4N7LE8Hd3yVyA7rQkkb3F3ZRrGEcMnO9NmjBqwUDIEDMNaDbi0BBJa8/6K
         dxNPiaJSWE2JwgrqRKtZDb3EmIn6Nse35AMlRNMncRx+I2pOa8GgDyC0h4mN5CyPlKNw
         xynY7nDF5q6TN0kgX7PRCMF2iZwqR0z9WEPUZgt9ISRshqAnDBD67amc+atAcae9Ft1J
         g5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SRF1siafcqtmCniXw5Nr6PWjFLq9MerPfEtSPjlMtOU=;
        b=NxSt3ClbbvmI+C5KAXt47Gou8TEw1wTbpso0Yh/m6Ke4l2czRUj3CytI5KtX/jo2Ez
         lw6XlDsxlME8XpnI+G+ddglGGddF4tEiHh7iGI1/i9Lyr02aSWLzxjkcjj/0IO4XPH0B
         xlcNFvF3G8M2VoW3UvCvFf0qflIIClywuhcbt3oe30AEhRLqz0BPAnaP1kOL+pQGgjTN
         qQ3C4RwqOPxSLQVYiGVSJthcoWOa1DmD96ypzohS6eyQPJlBAFt7bvy+h2IEhP9v4NMO
         eXO2dALwdAIZPp7jJI3NU/FYfjHyutAN/pfnPchvys2TzXmbvnJGtFhEnGp+foYswMOk
         CMZg==
X-Gm-Message-State: AOAM531r1+EF3AhIAYcoQXXn4c4SbIe88pl93qSr/qPsLRIaSo+mpjoy
        lVFbzI1Y7uucQN2Sb5Cx9l2r3Q==
X-Google-Smtp-Source: ABdhPJwq3TTD92mfSZ0QIaaOizPLZ1bWxgNta1N2gGBmvg59hhCm/YzsAHhmHssOS60BHcQWdiO1zg==
X-Received: by 2002:ac2:4d19:: with SMTP id r25mr2236456lfi.150.1624296677694;
        Mon, 21 Jun 2021 10:31:17 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id u11sm1926380lfs.257.2021.06.21.10.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:31:17 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org,
        Marcin Wojtas <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [net-next: PATCH v3 6/6] net: mvpp2: remove unused 'has_phy' field
Date:   Mon, 21 Jun 2021 19:30:28 +0200
Message-Id: <20210621173028.3541424-7-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210621173028.3541424-1-mw@semihalf.com>
References: <20210621173028.3541424-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'has_phy' field from struct mvpp2_port is no longer used.
Remove it.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 3 ---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4a61c90003b5..b9fbc9f000f2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1197,9 +1197,6 @@ struct mvpp2_port {
 	/* Firmware node associated to the port */
 	struct fwnode_handle *fwnode;
 
-	/* Is a PHY always connected to the port */
-	bool has_phy;
-
 	/* Per-port registers' base address */
 	void __iomem *base;
 	void __iomem *stats_base;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a66ed3194015..8362e64a3b28 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6790,7 +6790,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	port = netdev_priv(dev);
 	port->dev = dev;
 	port->fwnode = port_fwnode;
-	port->has_phy = !!of_find_property(port_node, "phy", NULL);
 	port->ntxqs = ntxqs;
 	port->nrxqs = nrxqs;
 	port->priv = priv;
-- 
2.29.0

