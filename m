Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3185C3162BB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhBJJwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:52:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229610AbhBJJue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:50:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11A9e0h0008644;
        Wed, 10 Feb 2021 01:49:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Lq1Smx+DEUnTfoNBQY/9X6EAfU0RZJZUvRTCbzNEoAk=;
 b=Mp1hf4EDWly53teZotxuNYxhJSRb1RaQPQu3TBWC8Kbf+J73wDbhq7AvanV0Acd1kybU
 kBDooyRrj38Ppz5hlFgBzGzciN6w/c6GbC0fDH9N+DwlrFWMqPKTtfXl6BD6rv80lUpz
 U1P54frZ8LR15RaXplA7QLuj4rIcvsFO/ot6ku8lsiMN6X3PHj8dC96qt46q+gaNxUFq
 tH3gP7DpCrBjd42iN3I8yPEzCxphnlBzNBLBnGyi90/WtIYt15x75eaJD1XL9MtK5Ada
 jF8BYqp/HvKe+qIb/4MdvLMMUqPZLMR7DLUorC9HsAxJeZqFKrq3AkmaECiiGQB1I9He Qw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqb93b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 01:49:43 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:49:41 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Feb
 2021 01:49:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 10 Feb 2021 01:49:40 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id A9ED43F703F;
        Wed, 10 Feb 2021 01:49:36 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <sebastian.hesselbarth@gmail.com>,
        <gregory.clement@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v12 net-next 03/15] net: mvpp2: add CM3 SRAM memory map
Date:   Wed, 10 Feb 2021 11:48:08 +0200
Message-ID: <1612950500-9682-4-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
References: <1612950500-9682-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_03:2021-02-09,2021-02-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch adds CM3 memory map.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 ++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..56e90ab 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -925,6 +925,7 @@ struct mvpp2 {
 	/* Shared registers' base addresses */
 	void __iomem *lms_base;
 	void __iomem *iface_base;
+	void __iomem *cm3_base;
 
 	/* On PPv2.2, each "software thread" can access the base
 	 * register through a separate address space, each 64 KB apart
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a07cf60..eec3796 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6846,6 +6846,27 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	return 0;
 }
 
+static int mvpp2_get_sram(struct platform_device *pdev,
+			  struct mvpp2 *priv)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (!res) {
+		if (has_acpi_companion(&pdev->dev))
+			dev_warn(&pdev->dev, "ACPI is too old, Flow control not supported\n");
+		else
+			dev_warn(&pdev->dev, "DT is too old, Flow control not supported\n");
+		return 0;
+	}
+
+	priv->cm3_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->cm3_base))
+		return PTR_ERR(priv->cm3_base);
+
+	return 0;
+}
+
 static int mvpp2_probe(struct platform_device *pdev)
 {
 	const struct acpi_device_id *acpi_id;
@@ -6902,6 +6923,11 @@ static int mvpp2_probe(struct platform_device *pdev)
 		priv->iface_base = devm_ioremap_resource(&pdev->dev, res);
 		if (IS_ERR(priv->iface_base))
 			return PTR_ERR(priv->iface_base);
+
+		/* Map CM3 SRAM */
+		err = mvpp2_get_sram(pdev, priv);
+		if (err)
+			dev_warn(&pdev->dev, "Fail to alloc CM3 SRAM\n");
 	}
 
 	if (priv->hw_version == MVPP22 && dev_of_node(&pdev->dev)) {
-- 
1.9.1

