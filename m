Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3633BB4A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhCOOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhCOOO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:14:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2490C06174A;
        Mon, 15 Mar 2021 07:14:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b18so8768512wrn.6;
        Mon, 15 Mar 2021 07:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xa3qsev/2jV/i3dBlay9LDIKdfg6k8HE1s8EfIPtymo=;
        b=gJAriO1QXr3dIjgJ0hQMj6hwTvuFUT8dfClikBDsIwgJVC3Vp9ivXYzSBEspCChUUi
         2PatHe7fF6eVU19oGpco/rmrqa5Wqj1GIHZi0wfWM5hlbROUC3+Nv2mOexEhJmNeIFYn
         ONtvX/zcY8u+iBfFPqfDc1FATAhXCZbp6RjQjvPIVYzSOF8vy983ycMGYH4DOCdly75h
         2IChJ5SutWdLowK6o3AWs4UNuJyD/RnC6FF/MpnQUxB9TnLb8S4N4RApoDGeDup4wcwk
         DeglRdTWcfvnT8SFgROIVUSb8sQVL56B6Pt8XoOAqzmJkDjS3tgkLJ/A0JeePw68+ZtS
         LCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xa3qsev/2jV/i3dBlay9LDIKdfg6k8HE1s8EfIPtymo=;
        b=sInOP9YB30J4AV9VCAP0rOqpZXIhKiTU2TwFuAutL67bruMcMKZYH1kDP236DcUdmO
         vYGddiZ8HfkKGL0RKE3nQdIltUczPZod35Y43FeRYlu5rdFNhgy0w6NT19ippzrdk+91
         nuJT1Uam7soZcCSDFM91pHvkaxX6v/YegcLy00I6AXYT5Y7rSHH+obDXq8hp/z9uZewJ
         wMyMXI+Z0a1Do0Jzx7QTBo+h3uju9TCjPyxSr1kVf0agGFWD+4lh+lTYcFeKYJJbO6Ar
         IMZvnjcn4PQqwixrZQDHBRzW5cL5rkEEmPm4O7TsNvU046f8gKX9UbF+InG6q5vksrPT
         NxKA==
X-Gm-Message-State: AOAM531Ixw2Ot3owuhECZcKTUSBMEjHyuVFci1Dzn3sdYzAMVAphF0rD
        h066k/e5CjSXfXVv1eoaJIw=
X-Google-Smtp-Source: ABdhPJxjB/UozMo+xsrXufA0zYe/bRabR7W3mjZejj9kZI+VtnpmH44u+sqtIneHDMNM8rqKD63vCg==
X-Received: by 2002:a5d:5104:: with SMTP id s4mr28801836wrt.62.1615817665365;
        Mon, 15 Mar 2021 07:14:25 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id v7sm12421881wme.47.2021.03.15.07.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:14:25 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH net-next] net: dsa: b53: spi: allow device tree probing
Date:   Mon, 15 Mar 2021 15:14:23 +0100
Message-Id: <20210315141423.1373-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing of_match_table to allow device tree probing.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_spi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
index 7abec8dab8ba..413158275db8 100644
--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -324,9 +324,22 @@ static int b53_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
+static const struct of_device_id b53_spi_of_match[] = {
+	{ .compatible = "brcm,bcm5325" },
+	{ .compatible = "brcm,bcm5365" },
+	{ .compatible = "brcm,bcm5395" },
+	{ .compatible = "brcm,bcm5397" },
+	{ .compatible = "brcm,bcm5398" },
+	{ .compatible = "brcm,bcm53115" },
+	{ .compatible = "brcm,bcm53125" },
+	{ .compatible = "brcm,bcm53128" },
+	{ /* sentinel */ }
+};
+
 static struct spi_driver b53_spi_driver = {
 	.driver = {
 		.name	= "b53-switch",
+		.of_match_table = b53_spi_of_match,
 	},
 	.probe	= b53_spi_probe,
 	.remove	= b53_spi_remove,
-- 
2.20.1

