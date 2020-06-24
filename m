Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5E8206E76
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390222AbgFXH7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 03:59:50 -0400
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:18896
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390208AbgFXH7s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 03:59:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZd5WC9kbD5oWekYISiKw/fL/0DUrihCGGmq3n5qTBak9frlNv7TlKlbsBGdCp9D04933uYdWBqWgeocFAMrOPKEoBhbSypWdyJn+WXFdF2OQ3rnlzPIuYQCMHu0n2tuv3ozrcrnRSD89jzOK4k5XCxJubiHP/H+0XOIo1PDY0agqJypOEbpFefdL+LlA8jIX+nAv3lEkfTnaDfp0I9rO5uYoIF1sPJLKaMepfexJW8gqYYdnLnVt7VKiGX3WCRO0qrtxWNSYGCQhQsxkiDFk+Xm/lAIbtA8k0MgJGerLgmHFYqr+tf7/veTOxEGaxU5WYQAMQU4vWRRISV3bQZ/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esmGpd06+XbH8PEb5lccTyTxqWbNOmlM7DnYQwXJAHw=;
 b=m7EaDwfsDtGfIVyMDQ1ReYExEbN8Z+7x+VRsVR2Py+apEzy4uLX8dSbcrfUC4U4XCZBdl9PxZ+zzU/hfri6NBJlS81GIF/rwVRdy45+XkBWHueOhEnBSbXFVlT1rMFilwbdi/QMpAaClRq2guRoOOSeiOZ5dy38hGEtmclMApAatc6jkNqLWAlHRC0DgPIBniprvwGpnH/HZArR2VtsZhfRv1bRBtYP4XT0wfXnRpOolzlRNpBHPo7EHAgpdAJWt3zHVdmbwin6vwh5HU/HL8YTDRKE38kY+hJCDVfWAdQ670WV3u1Uzl17G1QgCjOW8xyxHp9bSU+vZzF4ztWi2aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esmGpd06+XbH8PEb5lccTyTxqWbNOmlM7DnYQwXJAHw=;
 b=DfbNRKOpdDCt0nWuEg38GViXzyMYT/38uv7ZyaH52L+GoTFh7Fw+cpSAJQZxsVBxrpPZ9UZkldIGF/EW7TiX+9faoC8Ri+5qqlrw6arkwzzfNIugwkz02Y99Xbg/NfIHhoJTuJieyw6TRCeDYO1Ngr0sb+QvApGCknSOX+0or3U=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5361.namprd03.prod.outlook.com (2603:10b6:a03:21a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 24 Jun
 2020 07:59:46 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 07:59:46 +0000
Date:   Wed, 24 Jun 2020 15:58:24 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] net: phy: make phy_disable_interrupts() non-static
Message-ID: <20200624155824.4afc1a8e@xhacker.debian>
In-Reply-To: <20200624155757.6b2e82cb@xhacker.debian>
References: <20200624155757.6b2e82cb@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20)
 To BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY1PR01CA0190.jpnprd01.prod.outlook.com (2603:1096:403::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Wed, 24 Jun 2020 07:59:44 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fa41d64-4cd9-492b-17b2-08d818148fe8
X-MS-TrafficTypeDiagnostic: BY5PR03MB5361:
X-Microsoft-Antispam-PRVS: <BY5PR03MB5361A649DA41B4D2B267C67CED950@BY5PR03MB5361.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sl/2udKB+E2qYxrHG2RkJTNtOttEynxsUxQqw9uzB4aa0nNSCFJ0vpNTzKSvJ7AZyAGFyqmTzYKGs4q5hQaGOA0zg43pSa9MvRy7yzFR4Sl9qoVd7c7+tWO6OToTaQzV/4QRZEvhpCpsgqTfqON2oqfNhRdjiCroq9KM9xc0pPrEHGe9dAyCvHSrf8sPxWA6DMznJWw84ZuEdrJnzJn2Q9Ee3r+xwYN/Rpe5jgV/Jd4bM6yE4rfM7SiCRJJMmQslGlyXWxBxVBjCz6g9oBglNt2WuqanIYzFZt+9WkrKQYAOQMt1kuN2L/89ad6ioArq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(396003)(39860400002)(346002)(136003)(6506007)(52116002)(26005)(186003)(16526019)(7696005)(8676002)(66556008)(66476007)(110136005)(6666004)(8936002)(66946007)(9686003)(55016002)(1076003)(316002)(4326008)(478600001)(956004)(2906002)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5WJHrr8ytDXhAXwoPjuPvi1veNhs92OJa8uBMT4nZDkhv/lGp4G461EWUdR9XA8HbLxxDznQFQ+DvkABNJ4K6HEFKaD8AuOuNHHKdeatxaMNIK6jAnTxGcd8lnHxgRJzKNpHINd69bQtdbjkdNKKRuRsKcOqctrkCMNIVR9ajPNZdpGmoyn2z88X5F1fhUxMwn4pxzEjh0wnG75EGqU5KGrIWDHqznXsk1g7iiuEHKhOj9s3pwueiSKk76hMT/Z/iB0ctd/rLZbRbXGB64NJDk897tvkY8TH9ZXkPpgKUEkqv+/2Yv5K8dhfBnKISmCe6qUjzteq9zKHsFeu9T2Kt3OFqYkRrOR57YZwYL2uxYH8hzG2HV1FS9j6hYD2Ik6rp1pLY6jw2siNp/qqYfr0GIxWqK5jvDrrbXqEIGem8gX4k53HY1OjLpLiRdhtqGixeCDMkfkNEGlR2Ngx1HrH+unO++u5kBZD3BlZb73ZzE/l2RQJ3YEjoPV+PQupqG7J
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa41d64-4cd9-492b-17b2-08d818148fe8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 07:59:46.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /G/BScYBBjEKNBETTq872aXzaggdTSmg5V/MP+uYgl1LABHScFj9NKPLl7B/w0bBnhx9pw7YORPrxk2ewnWiBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5361
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

