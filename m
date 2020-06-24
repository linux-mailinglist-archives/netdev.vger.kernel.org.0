Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204BB206A8D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgFXD05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:26:57 -0400
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:6157
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387985AbgFXD0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 23:26:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeepqgT9R1eA6dT+BW4//gaSsO+9ltWEKE5VXSfR/NMOhP0GHpU5hxrF02npP+EYjbabPbs9fPf2Np/Z3RQdydsPdhCxFjEJFMwcAo6GYp5fwhFReYknZ4A+tFhCzfG7iWlv0xdHrTOLbk63DeeE7khe63Hn9idJ6Wvk4Nd+bJo98eiNpMPuiZEoH+FzXW9A4RJFma9I1MpYzNaRJzbnTFlE9d+zdj9G1/+x7oeNtoLgaIZ2zUfITExh9fMjAR/MtrI5TWlueB2oPWrHBawrtZwA+35/OJrXYN5wCQJmUTOuiQCQ32kx50z4eJpuMndBZHAEAP7gJLav3Xnrth5JWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trfnXziPShFSqtOjjV8n/XNlr/pCI8Mdz6xFZqXN3I4=;
 b=KTt7sLn848xo49anyIkIq3TbWfIU3JvsVWPBrvKfg7wonBu4zX4ZCFPLXhUITDc2550rvUfYZOolnU8RrvDs+0+yHrVjGuPyQafOTaJybrtye+KqjXR2ZxrspBmB11/I470A/Pxx/xOT5zJyuoLCwd4vGlv+zQLKjOYoNiXLyK+Iucec5mXCHNDezSPKTcEQE60SZ+rsbzK+3E7wPRIpQnF9JE23KlHaGdpIZiuIT1YR+4nNOInVXsGuzZNvu+tYgLQ8dksuGMiXwEyW3T/o6o94GbjqQYgKZ2UjXLHjQdUDyb+S8zMncEs7N7NIl1GIcTqlbn8trjRf6Hq6/e/LVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trfnXziPShFSqtOjjV8n/XNlr/pCI8Mdz6xFZqXN3I4=;
 b=ZyaY3lkZ0KsSwdgtSOH2EObXFuVhhZ1QVZEEzHcr6S1/c76DvWSUWkyI1GXBE5aiq2HM/5Tf622MSK8wL0yo5+V4kwMp5v/O8rwyPb4CCl7cZmRVmseQ4cF3HZKH8m2yJx7/P7Z/lcN+KB+A37mx/LRAbKllj7SWjmoh5ny5KII=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BY5PR03MB5143.namprd03.prod.outlook.com (2603:10b6:a03:1f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 03:26:52 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::d1ae:8ea7:ea:8998%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 03:26:52 +0000
Date:   Wed, 24 Jun 2020 11:25:16 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
Message-ID: <20200624112516.7fcd6677@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR06CA0025.apcprd06.prod.outlook.com
 (2603:1096:404:2e::13) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR06CA0025.apcprd06.prod.outlook.com (2603:1096:404:2e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 03:26:50 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f50112b6-b372-4a1a-07e5-08d817ee6ff7
X-MS-TrafficTypeDiagnostic: BY5PR03MB5143:
X-Microsoft-Antispam-PRVS: <BY5PR03MB51438E4000E5ACAC80854B83ED950@BY5PR03MB5143.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XCzCduKYIvpRtWynnYlPaiyakrRvwN3sDs6zynnoCNkADrELf6zfv+W1X/BggADapuPrYXPPGnioQxVL3Jno5xMGuuQ/DjFOtxnPwKaNE5K2+vQb1loF2/FVs+z4ZP+BwQ+/w7LwgwKrHqz6ob7WHgePmCKdgUwYvlxNv973kmhqewUl5V3pomCceAg/ulYMRKPoc78FFnPqG5Ng1VmlhT9L6cmIK7oXSvbZhe2ogJ3nTIV95q9X/URVJvP3ZK2/7SaOlV8WRGz2MIPV7JGrQEW2WKew6guV0tKLRo3W59xeP6VpzZDUOOJXzRA7BOBw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(396003)(346002)(366004)(376002)(956004)(6506007)(6666004)(86362001)(186003)(1076003)(16526019)(5660300002)(26005)(66946007)(83380400001)(66476007)(66556008)(2906002)(110136005)(478600001)(4326008)(8676002)(9686003)(7696005)(55016002)(316002)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mSV2RfxLEgXDGR/vOOrAuX8vNVw0kL1APaIGv2Qz1qXBv4++kIpS/KuJeKsmjBX1gXy0J+yKVwhpqbczkzbG27ZkBkm7D2w6antkPHlOxaWZ2F0rkFRv9lx+ImTw1dumqd5xFdJ8rywNkygs08Ahnh4kshRGiIrZCVeaeai1VWn0TnT12TyaKq/5cAgoMalwOmJGO+Jc+5VFcabyOTikDxwanJEmJwv+T7NpwAjNxrV7VDIEe8S1L5U7fab0C0vlLkM1ZhHocNRO1FdD0X0cSslFGp41XZReHqNih5b/Z55JdzpuAqgX/P5LA5c5LxZvNMAsCIfbly9csGedq8w8BGJog7WLoW3uAOJLypxB8J3OOMDY7Zmre9Ds/8suoPnq4CcJTkXkKIpbVg46Cl4HK6A9ioHXteaxSdQEkCv7uIYznhsBVUB9WUgWrfSGSpbC8E+VVvg7CaAnJj71ZhlH/LBg6HCTrSaYtBkpt3eK39DnklrC7md10dujG4cD+QMk
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50112b6-b372-4a1a-07e5-08d817ee6ff7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 03:26:52.4019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahnfXcg9tYMBVhsosPOQ6mHQDN/ll7nnO5YqCQTQUQzbbakbuf6M1BYI1JZGbUP1Dvq/cf+DdgVpJff7vDX++g==
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

patch1 makes phy_disable_interrupts() non-static so that it could be used
in phy_init_hw() to have a defined init state.

patch2 calls phy_disable_interrupts() in phy_init_hw() to have a
defined init state.

Since v2:
  - Don't export phy_disable_interrupts() but just make it non-static

Since v1:
  - EXPORT the correct symbol

Jisheng Zhang (2):
  net: phy: make phy_disable_interrupts() non-static
  net: phy: call phy_disable_interrupts() in phy_init_hw()

 drivers/net/phy/phy.c        | 2 +-
 drivers/net/phy/phy_device.c | 7 +++++--
 include/linux/phy.h          | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.27.0

