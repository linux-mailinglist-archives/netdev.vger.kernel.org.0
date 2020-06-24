Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC5206A90
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388736AbgFXD1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:27:02 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:64481
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387985AbgFXD1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 23:27:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/dsr6xX8B5PVd4V/8MxG9B03ulZ8TRfXflctnIuU7tjmddGu9rVPUf7NJoP3vz+8lIr1gjcnrsMhCHYs4QVv2JysuisEFfshVgCh1eon2yS2nVi8hfH6paaScHpTy+SMzLVASvGNWynKmjfBX1GkpNXUJQ0vuuroitHEMsOlb1scHmKMSPML7fDhvwcNgO+pDXL07iH7zWKiR7Y/peqtBf6dEvSF2NZdy3lG4rBDwpf3253e+qVlZD6grMzmnSNzfZxxfFjxYVhT66+r9vzPJlUazu4xiEiRCTd26yG0g0FthfYBrRlNzEpgOjj6pzcFV+EXoDYUAYyIobkVHCUPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esmGpd06+XbH8PEb5lccTyTxqWbNOmlM7DnYQwXJAHw=;
 b=MBFTEPlh9I++jMHUbm1h+W5W8SAtbit/h+b/m3Ut9hd9ZmmmsOCyJ0Pj5Pt3fR2dBAFv+iAi0GfTx6uzTnkRFn4k8VLA+aOkfiaCIa7MVZQgY14ds0JhOljtnBx4duMbzHyxaI+dxy0FWyMy4s8auScYOZJQa1Bf1gIlcvf4jaq+537vQqm7lETpsR9GE82ocrtBt5PdRgd5eLFgn1w++KdMnkLbJC0b7W0yOSoH3d9+01zHEZ2G/CfcD0epoW3xvLgE0o7cNMR7YgDYwrM+9hr0jDIGuZ/AyelJWF8X2fUNb5s12bKYpvcq22IcTJxcDB7iiED6UTCxoaLDMCVBVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esmGpd06+XbH8PEb5lccTyTxqWbNOmlM7DnYQwXJAHw=;
 b=jRYqK3q/8bD+4/xnF3zf071juajwykqIWKqClrgm5zlmF+7B1RZnYbDjqc+56G4zElFZ9ry7bwM4AxgqwDR8FbCAR3wH+CVKK6W8gRGR9n1mvMX95qhAEHsFb1FOZU7m1OAMJIMOPbwD4TAs3OPgvDGu4knmJlq4E6uJ4U8ZU7o=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5143.namprd03.prod.outlook.com (2603:10b6:a03:1f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 03:26:57 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 03:26:57 +0000
Date:   Wed, 24 Jun 2020 11:25:47 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] net: phy: make phy_disable_interrupts() non-static
Message-ID: <20200624112547.3caf4d61@xhacker.debian>
In-Reply-To: <20200624112516.7fcd6677@xhacker.debian>
References: <20200624112516.7fcd6677@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0025.apcprd06.prod.outlook.com
 (2603:1096:404:2e::13) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR06CA0025.apcprd06.prod.outlook.com (2603:1096:404:2e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 03:26:54 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f7d739c-c945-4dc8-13fc-08d817ee72a4
X-MS-TrafficTypeDiagnostic: BY5PR03MB5143:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5143167914C893CE7A2948CAED950@BY5PR03MB5143.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c2qr7T2UmQTraGJ751BbhQu6vzqwnT3nO/ADvct1rGHm0Ht+axgAH+jU6Z6RDEyDJymbm+mnEiWCp1Q0wurQhP6Kz1p2DkCPjUN3p9ZeNGdkniKBFMyzdR0Mj6lLseiIwlpEA7kai+mhmhGo6usSV/F83C/KzAqh5M1hq5MJ+icdqd8Xs3IhZ+sKLdIT7dD44vHYLA6gVv7sShRvRLT0+nQm3ctvlYcgcxG7J8Rh2K+G4fDj3XDy4LARCN2HKFEhcVyUBUprhNsqCiSFN6j+uMQH8cglLcDm9LXrX4agxWGjoHBIMfjyfJdXFGfbxdlR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(396003)(346002)(366004)(376002)(956004)(6506007)(6666004)(86362001)(186003)(1076003)(16526019)(5660300002)(26005)(66946007)(83380400001)(66476007)(66556008)(2906002)(110136005)(478600001)(4326008)(8676002)(9686003)(7696005)(55016002)(316002)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7qKpj0Gom4BpvFQ33q24b4HJivO4KzuVa5oJue+8PNvkFmxh9C1bnBMEBwmWQ2lcVg5a3QslpYINEEUN4lGpsgIEB0c0uX/rTtkR/hY4QUOHsIgw6hbV+injQ2psTcUkrhJlbrxuHnskJ9tcdrNVEE8mZmgg2OpztqK1nbycEdg7ZG50SP5wyasGSFKvBmig2VdPoSSlQdosuy/NIcuTLzF0FGp6es1lRDp2YwMNV7KY+5JddyfQPTR2IuMU3Nk+KybbRbOUKzqz2vScN1XjWtbaqOUtOCSC4eg08g4D8YunfFsT8ncde04bMcSmcAFAuvcKJx3rCBTfDugbb3aejDuewnBJDwPicP69y+O/FCI0RUTeWeZY+Y0C2fWqx7WA5yUHEs4L6/uof6fh0q8rPCcUvxqzcp37QMzuH/J1JnbQnew0EAa36gzz6yXkFO6cG83rJNRMU5s1lCm6qf8UEGH9P6EmchZCUGE0djVMnEscePR3W7JQ8DJ5ro6ZByID
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f7d739c-c945-4dc8-13fc-08d817ee72a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 03:26:57.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Sd0sijFLdNmAMEy7mhCLW7473OU1gWatf2mkZ67exYjaOIFnXmIMXEpyaspKxXzwjvSl9xczngAuk1g91E1AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5143
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

Make phy_disable_interrupts() non-static so that it could be used in
phy_init_hw() to have a defined init state.

Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/phy.c | 2 +-
 include/linux/phy.h   | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1de3938628f4..56cfae950472 100644
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

