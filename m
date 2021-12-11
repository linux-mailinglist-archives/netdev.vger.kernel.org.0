Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17D147108A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241349AbhLKCHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345746AbhLKCGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:35 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21880C061D5F;
        Fri, 10 Dec 2021 18:02:45 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id x10so17836555edd.5;
        Fri, 10 Dec 2021 18:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=pThIJt0pqie7D4cyJ/lHqE7OQbs6U1VKc+6L/kkoX4AgcJEuBaFJF6kDGpdiEyo5ID
         SklT0C+wni1q4RT4WioBIG80igPtlLusK2PR46pCBRlD845YYEJ8kpdBJl+lqRQ0OIcw
         6gXL46SKPzsZrkE0DXCWlsBmt4u5E3abmenm+Un2xClFWW28Wib8+cpFmemKxKnp8VBD
         ff8JG6k5CHAYeNNZLOeVnyeENcI9KXQamrYjRFIEnBW5lJCLboTG3L39gC1GlcvxsGqZ
         lYGFkSIrjO2zi0aeb9jALxMD3/g7UWRPayE+Qhq07qcBbfP1Vh9Ex48Uc8AxupTwyRRZ
         2Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQADOX9Nm0sVY3Eh8XHvdzdj54VJkMZKeLoeWQvIR1k=;
        b=sOFH1rBqZZhxw2gamaoWmUz1lHorpX5+3f809UxgUxjfDBO+ivojvDGLlRfwVzB3eV
         Ek6D6UZv7CxxolaJNOu4WKUnYIjI3ylhE+KiZo6giNKEhllLTQ1fyGisZwylROUw1PQQ
         zljldr127SBBne4aVoLlLZcxGlV6gPkEy128LiYBO20x6PdvxajeNGEcPyXYebzD81sT
         LZQ9qFwlBVZEWSCwvH24RXJvnuyqCUqerzYFrFxGJDOCxnP1ipe/PU1iHQwBP3BB8XZT
         sKmOBG2fYONI4NxDk162on7wYK2SmuDicbEiy1MWnRsDQjeF2hvmIGz0eb7sY+YjXxhV
         iDSg==
X-Gm-Message-State: AOAM533/RheWr1njIcTmA35z9WyQ3BfATFBAzj2Yovg/Ch+S2bLxvFRu
        VvDNXOPXPukVzgFcLI7PAxo=
X-Google-Smtp-Source: ABdhPJzJpyOvxblIyGPHhqR7BDdxWh9HM8avw+yxiRkStYhjnfFrSqBEz8+Vt4c8yWnp65BiKiAQbw==
X-Received: by 2002:a17:906:7307:: with SMTP id di7mr29442450ejc.322.1639188163571;
        Fri, 10 Dec 2021 18:02:43 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:43 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 15/15] net: dsa: qca8k: cache lo and hi for mdio write
Date:   Sat, 11 Dec 2021 03:01:55 +0100
Message-Id: <20211211020155.10114-24-ansuelsmth@gmail.com>
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

