Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56235204B75
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731567AbgFWHoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:44:07 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:6021
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731158AbgFWHoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:44:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhXLLHljaq8DAI1ss8rQ922xSAkuJ4IiQe6b4uM/FqZXaNCa4/o53idOLTdryhnXHDpYjt5JZ6+498u8oCSVVGBLLU4yV2uc8wQDKEs8vWr3ezL80GiaYY84JqOLEXgXzAtsHJ11zplrsJS8gU2B1hWwlZy42hQNjWP4Qw6qgIohBL6sLvZP9WqzSDvxFx4ljQImhQyDmnMF81RNuXq4iayRISyU++x6hBaCdMJcn6BrhIHDSPEASCaWiXRv40deI9rKxeb9BnEOceiWYZxzCqIpB1k76Hbj8MWKsgG3n6dom1FcW6jrET+mifrWLW+Ofa5vLSQ9REuOGcUYVPVI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzcYXAM/aHEQnw4+nA0wsykCAPcGuJA6haz1YRPKGvw=;
 b=azHT15p7ciQTYciwfpKaMfRcoRyzfau8AQeb9r9nB/Igwce41XvPU3tP5PHZI0gaeP6V5eqchEnTfP97OLQ+rtdLXvtEySKCO7QPhw8gaj19narf9rBf4s/0xjtYRjDka4nS7fg/yHziICsr9/D1jPOMEagfyevNvIq8+PBvthTKVfPT4TY/yBXja41Njstk+xaykdL0yNrze8V+jbPpsbjbefzMCK97slccnbjw/oM1/wE5DLqM+QuLyC1dvcNwXIZ03MQZSJBhLRrcpH9wQ8y3CQirM9r8fi755FFSmtPgKpDn79neN45n1pSQ8DTMRrppGOwaTOh35wXh7AV+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzcYXAM/aHEQnw4+nA0wsykCAPcGuJA6haz1YRPKGvw=;
 b=K5dGeHvyujVnuInEb2AaNXEGFwhYadDgMGgIfKZXlOxFuoRvnnMawIT3YBf25Uu9hfo9KMb19Gk5ZaTooPi/uzeKX3fakg7qGV4GUQ/fvi2co5xuB71Ft7A+I5QZwNjagnTBgUE4Mu1p4uWLua1HBY8HcwS2djViPLeEFil+AUU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5141.namprd03.prod.outlook.com (2603:10b6:a03:1e9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 07:44:05 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:44:05 +0000
Date:   Tue, 23 Jun 2020 15:41:04 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] net: phy: export phy_disable_interrupts()
Message-ID: <20200623154104.3ba15b4d@xhacker.debian>
In-Reply-To: <20200623154031.736123a6@xhacker.debian>
References: <20200623154031.736123a6@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0205.jpnprd01.prod.outlook.com
 (2603:1096:404:29::25) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0205.jpnprd01.prod.outlook.com (2603:1096:404:29::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Tue, 23 Jun 2020 07:44:02 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9159be9b-767d-4a02-98cb-08d817493438
X-MS-TrafficTypeDiagnostic: BY5PR03MB5141:
X-Microsoft-Antispam-PRVS: <BY5PR03MB514184C71E1F012A287C5A32ED940@BY5PR03MB5141.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFGgbI6IWtrDYFFVeN+bQkWPFu7JNBykU1lzxXkUsLM7EJHYAqRUAv21G5HjliNxH7kk22Tf6xrOquyi7BRHiRFvgMY5nA+Pr603QY5UJuyop9qa5E6Ys2qTo4uGA8s5L9hZWQ3DCCx8KNWuet20Z908tIs7xS7YmUt/i7P5hOXA5RPjWv+sNwuyxs/ns8rkIOhr1RrRVip6dOStloZWOsvm8EvTylfjdMHzVQxp8lRYwuuAD72/LgEchKdE6cWBSQVK6uDOKAE8mq1HgmtqGs0Zz5y6P9T7PzlCmfQiQlUbJFUvxJtOALNZoat1UG+9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(83380400001)(66476007)(66556008)(5660300002)(8676002)(55016002)(86362001)(6506007)(66946007)(9686003)(7696005)(52116002)(8936002)(2906002)(110136005)(498600001)(26005)(1076003)(186003)(4326008)(16526019)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: npz4OD7Iu3HEdUUlJ6kkg6n51xB+JOhbX1Rtr+iYQG5yV4cYgBhe3272uDRXvsk14QL+GPhiUCl7tPv9TJugWCHgsHyTx+73mJyTZFn/TmJfxBub5CWyEj8QeX58tiyYIdrXDchxsqT9Na+HClJPWkAxPjRRVW3n9L41BOr3OPeygyLl7x0uMRRWbvNgezy8NOnbn5YHAb2fZm8LZ0A/DOI6OY4eEfyXjg0yiffb2ljFzjMQiPYImCQk+o6kcLK4TEOcr3gJndXfg8XX0e/YMkTCCOnlfEr2xuyGCSOjStziKOCX3WcNyXVbWbxM4NyBxZWQFMnzznRlWfdxQLrOoZAgv1iBtjEITqBfkaBaLMg4k02wSVJr1G8Njo08EQxt6gHAYbA/Yr4UHXgCvM3xnGe6+vUt3U2uGSCFgTxv8ypM4ZruAB3heh2E2aC4QbIwriNq5izzlSRi+qLTTps3EajVcnCNXWZFeRXr/AIGGSuUhaTGwcsLHTP4OUi9ptgL
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9159be9b-767d-4a02-98cb-08d817493438
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 07:44:05.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8soDgEyIkbmvujkdeZH8zjhQyiLC5C7JJqlCZmM8OiyXDmno9kV3KyDTEz9i1ZYqREbOZV0CkWs3ToFaFOsvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We face an issue with rtl8211f, a pin is shared between INTB and PMEB,
and the PHY Register Accessible Interrupt is enabled by default, so
the INTB/PMEB pin is always active in polling mode case.

As Heiner pointed out "I was thinking about calling
phy_disable_interrupts() in phy_init_hw(), to have a defined init
state as we don't know in which state the PHY is if the PHY driver is
loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
or boot loader could have changed this. Or in case of dual-boot
systems the other OS could leave the PHY in whatever state."

Export phy_disable_interrupts() so that it could be used in
phy_init_hw() to have a defined init state.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/phy.c | 3 ++-
 include/linux/phy.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1de3938628f4..cd2dbbdba235 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -840,7 +840,7 @@ static void phy_error(struct phy_device *phydev)
  * phy_disable_interrupts - Disable the PHY interrupts from the PHY side
  * @phydev: target phy_device struct
  */
-static int phy_disable_interrupts(struct phy_device *phydev)
+int phy_disable_interrupts(struct phy_device *phydev)
 {
 	int err;
 
@@ -852,6 +852,7 @@ static int phy_disable_interrupts(struct phy_device *phydev)
 	/* Clear the interrupt */
 	return phy_clear_interrupt(phydev);
 }
+EXPORT_SYMBOL_GPL(phy_disable_interrupts);
 
 /**
  * phy_interrupt - PHY interrupt handler
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8c05d0fb5c00..b693b609b2f5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1416,6 +1416,7 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd);
+int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
-- 
2.27.0

