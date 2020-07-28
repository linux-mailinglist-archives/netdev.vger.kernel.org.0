Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC072309BB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgG1MNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgG1MNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:13:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707EFC0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:50 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so9801079pls.5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K3QQVjySvfc5vwyeF7wUSJgI9iEWEM5fP8AMGfzg7SM=;
        b=xdCYVpQkfhC5Oxqz1cyN7jrOQtwu0BdLI5Gob/XT2NDFRIa0S1u0GmNeAs9XIQC+0a
         +RtZ3JK8vsgxm/69jR90yYcP/aX8vocTvQdA+WXLHOeNxhAFF80ayAomS636DoEXYEb4
         szZ6IxgpCTHv8OgTOUw5h8d9J+Byuo/68OJxUBrvP3vZF5+UTrYzMEI0BenFTGXv8NzS
         hQrrDv3/hCdVX1hxUSZIQZVzeDGbX28tUcreZqp7r760AwuyXyPoI/ZQln5CsK0steVp
         DNL1582gYlph4usFet0ci/X7S4ZA0+JIdfnZTejjD2R+qo35I77oi2qi5Zu6c+6/hnBl
         Kcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K3QQVjySvfc5vwyeF7wUSJgI9iEWEM5fP8AMGfzg7SM=;
        b=OTvcHK5vPxj5fUDK/+AjxO4pLZG9uH6QEqRo/mN1AXe/VfJGaS9qhWXNSrB/hqH3DE
         49acTxu6qoGEGlNeNJjSOmxstRYm31NdCf9TZ/zqmLwbAiLMCnEX3vBY0Jpc5KoRwFbW
         tIx+8Y6/aJnWLnhYLFgoQk1/nx94MkuGBSvtzWwdoyes5LWKX10G595KFZ2mHR0B3o5s
         QlfdKn+FswOZVxqVMa/N63Od64EplLetKWzIyXIZKtM7u/+O1nY+HWhSTViWTRT1c3az
         ag9mBFK59dcbitvMm2fQ5UZ4XspYg2EoaNEN9OTbLA5MrrkDtLmuRLpElsSXrnAivLZ2
         rVRA==
X-Gm-Message-State: AOAM530fgAaWDqtKGd8ib6hrU9CPPITOIhLQ7DDbK/sQJSVQ5+yVAb1j
        ksyCQ7Gqu4aMjJeTTxATNL5VJA==
X-Google-Smtp-Source: ABdhPJzzQmbkKMHP2JGQzhsGwXbiMe3/SbdqZff/jtbu3x/0mh1b6xo3B04dRhuSo955bn/uqkCLRw==
X-Received: by 2002:a17:90a:c398:: with SMTP id h24mr4184147pjt.211.1595938430063;
        Tue, 28 Jul 2020 05:13:50 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id f29sm18203612pga.59.2020.07.28.05.13.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 05:13:49 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Date:   Tue, 28 Jul 2020 17:43:20 +0530
Message-Id: <1595938400-13279-3-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
References: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will extend "struct fixed_phy_status" by adding new
"struct device *dev" member entry in it.
This change will help to handle the fixed phy registration in
ACPI probe case for fwnodes.

Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
---
 drivers/net/phy/fixed_phy.c | 2 ++
 include/linux/phy_fixed.h   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index c4641b1..011c033 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -267,6 +267,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 		phy->duplex = status->duplex;
 		phy->pause = status->pause;
 		phy->asym_pause = status->asym_pause;
+		if (!np)
+			phy->mdio.dev.fwnode = status->dev->fwnode;
 	}
 
 	of_node_get(np);
diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 52bc8e4..155fea6 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -8,6 +8,8 @@ struct fixed_phy_status {
 	int duplex;
 	int pause;
 	int asym_pause;
+	/* Associated device node */
+	struct device *dev;
 };
 
 struct device_node;
-- 
2.7.4

