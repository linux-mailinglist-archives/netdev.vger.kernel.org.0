Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1547107C
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbhLKCG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345830AbhLKCGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DBDC0698D9;
        Fri, 10 Dec 2021 18:02:43 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so36046606edv.1;
        Fri, 10 Dec 2021 18:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=TkfDyOuhvtRTFcgNmp6kloZwLebDas4XaQ58yL3jUsZj3zN5bPJYm/nUMo/vjgvS/4
         qL8HGW0zqHeRbEWIHuOBIGsJR3lNOjuVjQxMBsDMB2hGyfmuizXrlDhkWfc/LJCUGXdK
         L6rHuB1My9TcOYiYKWeYAXnJCH+E2EwQvbn1//EGwPF4jrxMJVZzDfeGdAUcpdaMQDTW
         YW1JuAeCP8vxbZGjuJnvlQ2zoIhrp7hVusmIqouJIVg4eeOV2Ky8kypW4MbB1JS3Efyp
         yHT9tdtDUucZcX/F02dftRDS+uyh2d+/n/uOxvYoFve+XVaXmVUPo88dCr+kWO1yd3rd
         a/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=KlziJHBj34VXNN7bV5JFt2DRGzrRB2khKaDwnu16JjtF70fMpJSrCFkSGSS81vSuKg
         y+DRnAC88N8si5lWleErIXv8LNRY8pRrnCQKW2OvxRVt13YHckmV/Y1Zla0rxY6hWGX/
         OWgv9C6ekOcCzMGVC/67jErui2R3swKwIW8COHPZ03Zn0FhYyUHVokE4fbrh8FXl1Q66
         9dix+cp2fNRZpNGD+d+ErQiuf+kcJ/CkXrATVCil3X2cYEm+p52wgu/PZBeRc2Aj99FP
         2naFOwcbHZw6yrgwHAC1nhlwx+CwCRIXYNv57ZdvtIviCbr+3n6ZIjkI7RFi8M5O8fz8
         Ynog==
X-Gm-Message-State: AOAM533Cbz/Et9svg7SIH78q4Z3VZi67ydwrur/88VcM2t92tDbAu3S3
        /RNTA6Q9ah0f7vMt8UL33G8=
X-Google-Smtp-Source: ABdhPJz6CUBA3N96ex6OAMdX3P6A285kmAIQxIITLVFk+otDqwy/m2uCUlreR9gTzJJKcnfOoERFyg==
X-Received: by 2002:a17:907:7e96:: with SMTP id qb22mr28037252ejc.469.1639188162274;
        Fri, 10 Dec 2021 18:02:42 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:42 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 14/14] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Sat, 11 Dec 2021 03:01:54 +0100
Message-Id: <20211211020155.10114-23-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Documentation, we can cache lo and hi the same way we do with the
page. This massively reduce the mdio write as 3/4 of the time we only
require to write the lo or hi part for a mdio write.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 49 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 375a1d34e46f..b109a74031c6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -94,6 +94,48 @@ qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 	*page = regaddr & 0x3ff;
 }
 
+static u16 qca8k_current_lo = 0xffff;
+
+static int
+qca8k_set_lo(struct mii_bus *bus, int phy_id, u32 regnum, u16 lo)
+{
+	int ret;
+
+	if (lo == qca8k_current_lo) {
+		// pr_info("SAME LOW");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, lo);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit lo register\n");
+
+	qca8k_current_lo = lo;
+	return 0;
+}
+
+static u16 qca8k_current_hi = 0xffff;
+
+static int
+qca8k_set_hi(struct mii_bus *bus, int phy_id, u32 regnum, u16 hi)
+{
+	int ret;
+
+	if (hi == qca8k_current_hi) {
+		// pr_info("SAME HI");
+		return 0;
+	}
+
+	ret = bus->write(bus, phy_id, regnum, hi);
+	if (ret < 0)
+		dev_err_ratelimited(&bus->dev,
+				    "failed to write qca8k 32bit hi register\n");
+
+	qca8k_current_hi = hi;
+	return 0;
+}
+
 static int
 qca8k_mii_read32(struct mii_bus *bus, int phy_id, u32 regnum, u32 *val)
 {
@@ -125,12 +167,9 @@ qca8k_mii_write32(struct mii_bus *bus, int phy_id, u32 regnum, u32 val)
 	lo = val & 0xffff;
 	hi = (u16)(val >> 16);
 
-	ret = bus->write(bus, phy_id, regnum, lo);
+	ret = qca8k_set_lo(bus, phy_id, regnum, lo);
 	if (ret >= 0)
-		ret = bus->write(bus, phy_id, regnum + 1, hi);
-	if (ret < 0)
-		dev_err_ratelimited(&bus->dev,
-				    "failed to write qca8k 32bit register\n");
+		ret = qca8k_set_hi(bus, phy_id, regnum + 1, hi);
 }
 
 static int
-- 
2.32.0

