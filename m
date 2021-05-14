Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE42A381270
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234064AbhENVDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhENVB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28C0C061347;
        Fri, 14 May 2021 14:00:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id m12so596320eja.2;
        Fri, 14 May 2021 14:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/hfRg1nsLEvO95PxnKiZ8i2v3bLxOsvxz9ooe0Uvu0o=;
        b=b4FPA5SS3zJoqqETIdTQZO/NMm3/jNmmW3/HWwLU3jWotv4VXA35TnOBLkxFLuX7GR
         39L1Fym9fl9X1PvJR9RLNoRydGirluSwf47YAzMElwNgtxC6Qvlw2+FPz0OZCC71mqx4
         AdisSdefn3iILgRH5EVXezh7J3YlfRMs18+bf/PRkhCZmsRx/3rJBL1zV7XAIPkPSuIY
         Fpp4VfPid9E6B/8EOHigrXqXQMxPsJHGRCCcg8kw5wbr+Vvek2xE84behUIli6FAMEVT
         ZlVPqGpf0qJ1KoRax2rOho/yJ2nD5Q6e1YOYXr6M3ZS1IqdzcCNMyB+Dlxh45DJ7wtB6
         KipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/hfRg1nsLEvO95PxnKiZ8i2v3bLxOsvxz9ooe0Uvu0o=;
        b=lmDzlBNuzvnGnMMnXFs5RThHuEz+3KL61tmRlLVj/mZSbxWJdJwlNHf5sO1Vu6kUHE
         1M1ZlZsRfaAO4UBFdFxs4A0KzftfMXKw04Qe1uu+6/BOQgIw2/AQXLOcLUlW2kvxTiMq
         Io4neCTZNnXPA/MdbkiaP01rBw72GZQ4uFqKJB/lVIySVYqlOv+1CoikMe9LowRlyoss
         h5fpPWeYw72XgBC0Gzu10+Oz8rWF0XKQjRq3u4ASFyc0C8Fg5sFQH+ZYl/KW3pc7CbPu
         uV7WQpUm5bPvZsoREf5cNiSGpuxVtp9SSZ8KrqxIxgftMrosS60tGVs1H26OG66rcWRt
         TMJw==
X-Gm-Message-State: AOAM531HhQ/6gB01mNsjYOxsJoMO5VNAcLuS8cNNn3rJY11HxwUT+I/P
        N9mGtoljE4HbS5US/hwasJVMpmfu2I1s1g==
X-Google-Smtp-Source: ABdhPJxkVEhJucpQsMBXVQREt5t7D53YLNIGnt8VeYO/EekvHBe3k18oJjkhh5pCU5pd+gdGoiVNqg==
X-Received: by 2002:a17:907:9612:: with SMTP id gb18mr50998777ejc.408.1621026035413;
        Fri, 14 May 2021 14:00:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:35 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 19/25] net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Fri, 14 May 2021 23:00:09 +0200
Message-Id: <20210514210015.18142-20-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
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
index 1f8bfe0a78f4..df4cf6d75074 100644
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

