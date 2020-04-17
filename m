Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE111AE4D5
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgDQSea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726750AbgDQSe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 14:34:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A6C061A0C;
        Fri, 17 Apr 2020 11:34:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so1435117pjb.3;
        Fri, 17 Apr 2020 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KldHZTnr7jqdruc1snUYVZ+gDF1RtUxdIYHh8TAAFPY=;
        b=uaAWu+d/OmQIgs6fP6iNvKsTDVfi41RwuXLxUNi7g59TACc4Wu2eOjBRNgdgDZ88mU
         IWvCova0KaKuJ3/yPlmRUG7P75A9gheFEtjCtOyZmfbCZKXtAqG53SwYWSUEXsa3P5Eb
         U4P97eazQIOysH3i8IgCkfuqdYldLMHge52RsX8CcTBtBvrSC53qZOJwA+l97gtv16YA
         Iz3z0Mge613VqHwEsBTjvsoljc1v1XpWG4hT0s+98PUTwFJKYFmv8DzZSUS/r3K18XEa
         zX/ATBcX5AevlXOCsD5KNznlqUOi1288u1NEDUGaE0n8bDiAX8eeqtWcn1eAKuJwFSBx
         NkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KldHZTnr7jqdruc1snUYVZ+gDF1RtUxdIYHh8TAAFPY=;
        b=XREpRQ1exoIxaY3R3tbmtnLhQGWrynrDT4gsNSyxT07R0H5Myd7LQlN/n1Uob32I8u
         IqW30+NcdUnGiLz6Achwogi9+hQynWY5Bj/a/FwMgeEPSi7xfgHarYDrIhJAVFaEYBt5
         uGLzI+yZ6yA0kCPdAUslt2OP/GzucmxGq9WWSq/lwJWA/DAmOHFMt5IyCf6nK1AB/ZJk
         MNrbKD+amQDNLI/C6huRUXc5Yijk5dSML08X3MlWIU/PyJdQZyQ+RqypJdPyk9adGcBn
         h1QdVnhrtKMxfkOOt3O6JDfuDfbrM0vAw0rMGXRfDNJCej62TGh294CgA6LQE6byIC/o
         beGQ==
X-Gm-Message-State: AGi0PuatxG0zuXEa6D0GOur50GYDwNIzENZ8/xsRnpvE1FoYCGk/W50s
        7237UQH3xVx3ehhofhmFaNxcdE2F
X-Google-Smtp-Source: APiQypIkH5Cq/WH/rUflEuZ754+vLCbmlo4nFnm4eDXOOhyU3fJyIkobX28d3PLqNzSNlnJaEKJbbA==
X-Received: by 2002:a17:902:444:: with SMTP id 62mr4697411ple.301.1587148467552;
        Fri, 17 Apr 2020 11:34:27 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o63sm6544022pjb.40.2020.04.17.11.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 11:34:26 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: mdio-bcm-iproc: Do not show kernel pointer
Date:   Fri, 17 Apr 2020 11:34:20 -0700
Message-Id: <20200417183420.8514-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Displaying the virtual address at which the MDIO base register address
has been mapped is not useful and is not visible with pointer hashing in
place, replace the message with something indicating successful
registration instead.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio-bcm-iproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-bcm-iproc.c b/drivers/net/phy/mdio-bcm-iproc.c
index f1ded03f0229..38bf40e0d673 100644
--- a/drivers/net/phy/mdio-bcm-iproc.c
+++ b/drivers/net/phy/mdio-bcm-iproc.c
@@ -159,7 +159,7 @@ static int iproc_mdio_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	dev_info(&pdev->dev, "Broadcom iProc MDIO bus at 0x%p\n", priv->base);
+	dev_info(&pdev->dev, "Broadcom iProc MDIO bus registered\n");
 
 	return 0;
 
-- 
2.19.1

