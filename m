Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CD81FC8AA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 10:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgFQIbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 04:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgFQIbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 04:31:49 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FEDC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:48 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so1803250ljc.8
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 01:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c84FGVGvT0JUW6tVjnpdu63A5uo5FuKqONIDulr/ne0=;
        b=CRzdwEPvBkMKw0lHArpMOP7GwPMbN+yup9QItXTfJ6o/nCzcSUJqvzNyi1id76eqPJ
         4DUV5gOvVyU0jKJFrklOcPq0ZJd1+4ZaR7eKwOeG3urgzKcdUH3hkaijHxitEAOWrLp4
         wzcVNUiwME90+s21PG4Fn6ss8ow0Pj8LBZ8nU4ZpVDDsKvZ+EtJ46ELig5YTXAOEhFi4
         YaqQRPAi+2uDd54ulE/pFiNcBCnmYRMR7slWbJCAa6FKC171s3pzF5JW/PFcF1hcuDsX
         ptMXjrh+3K3yl9BHW7BJ7Qd0khbxyS8u3Mlx4CmEPe5LQZBiqVLsHHeuV00qy4MSFU1q
         mYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c84FGVGvT0JUW6tVjnpdu63A5uo5FuKqONIDulr/ne0=;
        b=VrYoGDXn8+/2OaOjHtFCmXLzac9bNIjRGIFTv6SS8s70fC4j//jG0rNc5Pap7JYJI6
         zwMd//WfHiY+YpdBBzEDq+NflhQLVApcWfLZiYENfZDtnen/bTekFwWWv3Ds8auWBK9O
         7nrC+sGEgLLjFXzYVLslciIX4hjDDV06H6TgnUDGPJmyOaEL0xH6FayFTUwb3xvAebb1
         c4uVlu1TZZcm05yo86CPvmzlgXkw36NC0y5pRcVCcCOZq43l0E/vzk6EZvZ6WCEw9zkl
         zhrJhZrltpISmouZ7NrvDOFHiuwq8TuORXOPqwKoPivTJjTWeMzb248cKuJZo/vedZlr
         838Q==
X-Gm-Message-State: AOAM530a71kJMBQ/jk6kaafsMP/K7uzWgzy7PuFHd7j5soVNIzrdFySC
        Upx9KDNr3xFsX+d40t6tB+udpw==
X-Google-Smtp-Source: ABdhPJxzSF+SJ2Hb+rc9c0BIlxse9N0afnWrTZtUQn9yfYdDvFhCApCE4hT4FurYC6mYqpdUYlrUGw==
X-Received: by 2002:a2e:8896:: with SMTP id k22mr3254049lji.331.1592382706774;
        Wed, 17 Jun 2020 01:31:46 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id c3sm89554lfi.91.2020.06.17.01.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 01:31:46 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 3/5 v2] net: dsa: rtl8366: Split out default VLAN config
Date:   Wed, 17 Jun 2020 10:31:30 +0200
Message-Id: <20200617083132.1847234-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617083132.1847234-1-linus.walleij@linaro.org>
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We loop over the ports to initialize the default VLAN
and PVID for each port. As we need to reuse the
code to reinitialize a single port, break out the
function rtl8366_set_default_vlan_and_pvid().

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Rebased on v5.8-rc1 and other changes.
---
 drivers/net/dsa/rtl8366.c | 70 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index ac88caca5ad4..66bd1241204c 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -253,6 +253,48 @@ int rtl8366_reset_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_reset_vlan);
 
+static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
+					     int port)
+{
+	u32 mask;
+	u16 vid;
+	int ret;
+
+	/* This is the reserved default VLAN for this port */
+	vid = port + 1;
+
+	if (port == smi->cpu_port)
+		/* For the CPU port, make all ports members of this
+		 * VLAN.
+		 */
+		mask = GENMASK(smi->num_ports - 1, 0);
+	else
+		/* For all other ports, enable itself plus the
+		 * CPU port.
+		 */
+		mask = BIT(port) | BIT(smi->cpu_port);
+
+	/* For each port, set the port as member of VLAN (port+1)
+	 * and untagged, except for the CPU port: the CPU port (5) is
+	 * member of VLAN 6 and so are ALL the other ports as well.
+	 * Use filter 0 (no filter).
+	 */
+	dev_info(smi->dev, "Set VLAN %04x portmask to %08x (port %d %s)\n",
+		 vid, mask, port, (port == smi->cpu_port) ?
+		 "CPU PORT and all other ports" : "and CPU port");
+	ret = rtl8366_set_vlan(smi, vid, mask, mask, 0);
+	if (ret)
+		return ret;
+
+	dev_info(smi->dev, "Set PVID %04x on port %d\n",
+		 vid, port);
+	ret = rtl8366_set_pvid(smi, port, vid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int rtl8366_init_vlan(struct realtek_smi *smi)
 {
 	int port;
@@ -266,33 +308,7 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 	 * it with the VLAN (port+1)
 	 */
 	for (port = 0; port < smi->num_ports; port++) {
-		u32 mask;
-
-		if (port == smi->cpu_port)
-			/* For the CPU port, make all ports members of this
-			 * VLAN.
-			 */
-			mask = GENMASK(smi->num_ports - 1, 0);
-		else
-			/* For all other ports, enable itself plus the
-			 * CPU port.
-			 */
-			mask = BIT(port) | BIT(smi->cpu_port);
-
-		/* For each port, set the port as member of VLAN (port+1)
-		 * and untagged, except for the CPU port: the CPU port (5) is
-		 * member of VLAN 6 and so are ALL the other ports as well.
-		 * Use filter 0 (no filter).
-		 */
-		dev_info(smi->dev, "VLAN%d port mask for port %d, %08x\n",
-			 (port + 1), port, mask);
-		ret = rtl8366_set_vlan(smi, (port + 1), mask, mask, 0);
-		if (ret)
-			return ret;
-
-		dev_info(smi->dev, "VLAN%d port %d, PVID set to %d\n",
-			 (port + 1), port, (port + 1));
-		ret = rtl8366_set_pvid(smi, port, (port + 1));
+		ret = rtl8366_set_default_vlan_and_pvid(smi, port);
 		if (ret)
 			return ret;
 	}
-- 
2.26.2

