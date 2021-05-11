Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24A6379CA5
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhEKCKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhEKCJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:17 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89040C061355;
        Mon, 10 May 2021 19:07:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o6-20020a05600c4fc6b029015ec06d5269so371299wmq.0;
        Mon, 10 May 2021 19:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZcsI50W8fZKEEfpBDfMPpDBGNdHj0jl0+ZTd0U5FBw=;
        b=VDzhcTIaM9g51JWG54lURSfd5MyIaGh+jpazUrBLzCWO5WEIjfkMRWPf02+kQ5zvP9
         hMccorxbo337dGEKwJ6mLZrb5yoyEBETwi63HnBGukcDwYAuuMOK+ITwm8rcCPto3ntN
         z6DzqQ1YqKGJeCemsBZVl/DCD7vi+5KNVlL4adWHm4ZKc5OaK6STbzVDuhxZ2sX60puR
         saEZMWvWoUVrSKKCsXOF0RpVKJavMZX+l6sCqlEcWQinvwBgz27RWK7txnQZ37iHjKUU
         wRMiaQZHrq03N4d/3FzO8LV/pSmEF1pQYipOrb265JJPAjVp8DHeANSofUuJSkXCMdIm
         5bwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZcsI50W8fZKEEfpBDfMPpDBGNdHj0jl0+ZTd0U5FBw=;
        b=FPmEQb7x7dIRKTYkQCMVnNKFpi+QUaFHGHXqpg/NKtYlY2JSdXS1JVAHi7xU2QrnGk
         qXsLV4hOnO9uIh8JZLN+ejWsPjXPU2XVWSBE8DsedkYmco6Z3YIyroJvskTBniJlamHt
         89+dvGQvksKbfp6Kx9FtKxNtQPCcyLQO/jLMS6+ohCOEe/mUT8IvwVRo2YcIn6kdedcv
         Ick1RuEG11ZnaDQkJvDuUj50mOickMYZk7TLbMkGiMw1Of9Yk+IXtvnouYRPMoVvscST
         z0aYtYxXCSibpfF2A3dYXBZcujL9zwrWbNQSD8Jq6ZA94x5cGY1gCuXKfDErRGWLwGTG
         +9Hw==
X-Gm-Message-State: AOAM533o/88GT8mvwMNjcn8qspq766B2scsNk7tRSAdcKw37/7WdyDxM
        yCIoSCmvYDLb5TssFAOexF7d32uKD2H/9A==
X-Google-Smtp-Source: ABdhPJxA7ZnGEu6rf1EaWqkGkJRpWBRMeiG/yervGHRm2UPn/gKvlMJfJX/iZl/BMG6Kx2/Vvpt4Dw==
X-Received: by 2002:a7b:cd01:: with SMTP id f1mr2347583wmj.177.1620698861135;
        Mon, 10 May 2021 19:07:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:40 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 19/25] net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Tue, 11 May 2021 04:04:54 +0200
Message-Id: <20210511020500.17269-20-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The witch require some extra delay after setting page or the next
read/write can use still use the old page. Add a delay after the
set_page function to address this as it's done in QSDK legacy driver.
Some timeouts were notice with VLAN and phy function, enlarge the
mdio busy wait timeout to fix these problems.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 1 +
 drivers/net/dsa/qca8k.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index fd74fcaf815f..381c0e340c09 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -143,6 +143,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	}
 
 	qca8k_current_page = page;
+	usleep_range(1000, 2000);
 	return 0;
 }
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a878486d9bcd..d365f85ab34f 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -20,7 +20,7 @@
 #define PHY_ID_QCA8337					0x004dd036
 #define QCA8K_ID_QCA8337				0x13
 
-#define QCA8K_BUSY_WAIT_TIMEOUT				20
+#define QCA8K_BUSY_WAIT_TIMEOUT				2000
 
 #define QCA8K_NUM_FDB_RECORDS				2048
 
-- 
2.30.2

