Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2445822977B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgGVLdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVLdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:33:24 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A2EC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:24 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x9so849715plr.2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LmZ2i95h00F6l5aQsli2APIkRkMWwbBsR4XeBnqAsMg=;
        b=hsLp5z9Bl9hLF6NMb9mf+5jLoIBDhaoHHj49s4auc60Vp3S9bR92+0VAKVfZ9ll39D
         wcIkrtzTqoB+xDy6q+LVQwQU1Qs0AN43Emorn3Qhn8MWGXbj54UbiB/4qC1btHR/bHpk
         PmoxN3UCF6crRydBVvBaNJWmPleoAlSrr3u+URadtjFqIaoRba8s18YX0nzxCnuhPeP3
         BocqNU3k8BI/2EkcJFVboDwupHiQ5J7uZXYUDpRJRqmeaco/F1ZLL4PMFRUjzeA2pVL5
         IJ8asFlUyM1i9xG4J4xovPXuyqi+dMmzEFvbCeOHLKINV+fJA6EXCX3eyO4TI7OUv+ek
         AsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=LmZ2i95h00F6l5aQsli2APIkRkMWwbBsR4XeBnqAsMg=;
        b=diTZKwnpto7Dce3EWGmRRQ/xZAyKBH0p809Y0II79a+tFk+8JFOrl9uuf/Cbvd/UDJ
         6zETd9c7hDZAuHl7dQUAm0NoK8omtYGoN/9xU1Ip62z/CUeGXV1iuJLYiki9qyRS42QJ
         TOERoF7mT01XsCqx4E8hVoL9M+jq6wJ70MunA311R88Z8u4encEjFsYfiFI6XhkziNVP
         2BTLMXPXrxj7wWs8aC8I5dbk87v+G85vTHA5cVc36E/llTS6vMKHBMrVDYUpAleAdnYI
         NGMgS62AXzzbLoQ5l7VtNA6+o+y1nSM2OuJ511TFv3pTw5TYNYfq9n10gVcFPfIrSUD7
         HiSA==
MIME-Version: 1.0
X-Gm-Message-State: AOAM532vNHOYPgEoQxaHbWqL2OQ4CiZo+cBYHZz9omUnzNNa+0iyp/W0
        3uuMvwizOQkaTB8oDXr0uZA37B271u1TGSJuap/mwF+cg4qhqxFy1euTV43slGfbZJI96nxKD3r
        DZZbG7SkgiDoQSXUsqA==
X-Google-Smtp-Source: ABdhPJxShALqK6ZvYC72YrpWkT8cfHDOmYu/JbCeoqZwmQvX1ptkwmjdYjvYNpKF0TUmBvGhWKHYbQ==
X-Received: by 2002:a17:90a:2d7:: with SMTP id d23mr9679879pjd.57.1595417603963;
        Wed, 22 Jul 2020 04:33:23 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id 66sm24783715pfa.92.2020.07.22.04.33.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 04:33:23 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 2/2] net: phy: Associate device node with fixed PHY
Date:   Wed, 22 Jul 2020 17:02:27 +0530
Message-Id: <1595417547-18957-3-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595417547-18957-1-git-send-email-vikas.singh@puresoftware.com>
References: <1595417547-18957-1-git-send-email-vikas.singh@puresoftware.com>
Content-Type: text/plain; charset="US-ASCII"
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


-- 




*Disclaimer* -The information transmitted is intended solely for the 
individual
or entity to which it is addressed and may contain confidential 
and/or
privileged material. Any review, re-transmission, dissemination or 
other use of
or taking action in reliance upon this information by persons 
or entities other
than the intended recipient is prohibited. If you have 
received this email in
error please contact the sender and delete the 
material from any computer. In
such instances you are further prohibited 
from reproducing, disclosing,
distributing or taking any action in reliance 
on it.As a recipient of this email,
you are responsible for screening its 
contents and the contents of any
attachments for the presence of viruses. 
No liability is accepted for any
damages caused by any virus transmitted by 
this email.
