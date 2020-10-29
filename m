Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42229E296
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391109AbgJ2C2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:04 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726748AbgJ2C2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJ/nLRvA8fw0ks+WuNwoUDHuT0/sAxBy8eiY1/hFTDOc/oqTIux6eCYg9rCY9Lpr67rr3almShcpUlvOpIc5beojj5CbDuTxA4pMbosNRLXhx0CxOe6bJ3K2bZ3lsfz2OM/qlvlusa150rEKkt+WtwxFnMajO/OKinjMsc4tjE2HIj7HoJ3wZE0aO5JTGlgaxG31q+PUrVZLlAAVRjQqVmaBT9mDWezQTZwEuFBVhSgDRBP2OvLPIjyqw3SPuCxAyxc/WgV/lTMF47Di5ovdt90j/S7rMytCxdLoTVMpDFUSp/9ud/GbpT0B6mWxH/iXNtLuvLle3tZ8VTpfqMgYZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1/SQKfKUY6IO1qCN4nzPGqHCUTvb+QYu2660JfHyWY=;
 b=OHUJRoB2iq+AMzIrSRfBcQsBGw7Z2qtNLhgQJfvTuJwbu5kD4fLrCx+cq8rSCeeztl+7dWYT7yK1VeyLK7+idpKS9rIhsVuo5JVVWZ+gfIy488lg4MmX+HoDdylJ38mZGnFivs/HpBaOXSMsGjCjQddXP3Xf2bYW1D0BEPgqG7JvmeyCX45ctUSHg3KqvM3eHYqk9DFucqAIxOZXqY1kIpHVx9QwBTp/JoxiBtU0n4QbDAZ3YlDZzrZxf343/v1ycRM1FsDC8evDL+zN5DPy/ayOxFIRXPBHH1/+GRPUpzk9/IKjeUmZ4zuvpRL+XK/+0uZpWtxUax7RuvqcfmWECw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1/SQKfKUY6IO1qCN4nzPGqHCUTvb+QYu2660JfHyWY=;
 b=K/RMSQWQgcVBDaH4n+hYXG0xJ7buwwYXuVTd2OQCG6mB7OXskmUNC/gd2A8ChrhToTeZVxFL11532N3qdVt/iXykOvC8dQnLGC/YTdxmIftPBZJQo+F6OiLkJOPhPqu79LBC7lzxt694LOxWAb20/+jWPtV5J1LVEOYGezdb8B8=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:27:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:27:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] L2 multicast forwarding for Ocelot switch
Date:   Thu, 29 Oct 2020 04:27:33 +0200
Message-Id: <20201029022738.722794-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 02:27:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8bdd3a37-0b21-4c07-9fef-08d87bb240aa
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69428CCA11202BBCC2EF6671E0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WgqnL0WdG5qC+Kc/vVsv7kZvhT0DjnGoPvNBzMdJtRdQHP1+wgP2g7i+V5H/ga4yKLCPfe2Vg141LjqYYyR00kgKnbFF20cofKVWRBQe0HseO5UzfWraqd9wcfgWQxOJvyJ7ur2LjVi+phcynW+EXr9VzLLhT3vRxEi2P9ENzc9Xw7eTNlA/30DIwLYDWj50QY4BxTVZmStuqQB2rNA2aAR5ulPeI50P2ymPkzU5LPQGRKfcZEyh4P6BYqeaBnuCS0wRimaU03iEh6f4CO2fuhaz7Mz1xCkAdJDAmfrXYmDUosflFrQBPBqrkWJXqgLM9jHpKPsd6eu8fA2Ex/pIhUO8DGdEucU/P2dD5dC+WnVD1tYr8OVQveD4YNFcAYPtWjhPzKPcqU5CgfokJ6CJxVVofaSWlx4G7Y+rJmGAZ3BLR7iSgal9n9TzhRPhJbuqVta5rhKDFFZzSnA/IGqkNrWFdQRJ3rPIK/nrqkiY8DQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(4744005)(956004)(6512007)(966005)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xTX5AkPHDNw63sN5iqZGcQU65A+5H8QXv3tbuCMKbtR/oXZz6k7lfFxDGOefeaN/PiLaRFANoV3GW6fyDIxz28Q55lvkcTG2oFg/UCrayxsmGfbLy55K3pTzWyuuQ9R/MaqXUz5e19pl4Co378J0c1vGWp2l4mQ5oTmyXmcB6cSh/Jz0n94PMyXgLwW8btq9fDcgzu7BehrWfuVjq60hQlmirK7wO2xnnnlGnVJzw9kog0pLIEms4ilGCsqzYAFyQxXTI5nIwWEyr2tWnuLJN28/JcrS56zyRekQg6fVwMvOMCRmU9VCxqxzYeI515n4/AwD/gxa0s3FiK1Tk8p+6doLAwpjJ4V5MVOT1QebhlcX6s7cnAb7HCJ8ED7s5v1b7x51cyfuBL7qwe4KaXDDFwInwvzk3Iw/q/7w8XvpnkTElEEcygDftm39YH41TJmGNjFugtiP3nyQvDu1RdXsUl4Bx4at4Me4XhKHXkvOh+EVS/2gVpVq4spNIljuWxv1nuL8SeyjdHjGCmW6ZfHq+QcRe5SWsM6eK5U417qRnQg/QQRBm7MeY1mFIgS3I2akhNfzau4pqtDHmU1o/Fpo+eeF7YydgGDdwoI1xLnNN3H6Zaie0YNOqzBWJlgpTMFW/uKB7lrXHRWhWXS5Qi8tNg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdd3a37-0b21-4c07-9fef-08d87bb240aa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:27:59.4153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AijNvL0bWWT8YrqnoMDvC6aZAoo8MLhOSt7ElRQX2BWDTNkSHDaNH0oszZS31qZdw1N1OXz8sNkIwJzvX0a+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enables the mscc_ocelot switch to forward raw L2 (non-IP)
mdb entries as configured by the bridge driver after this patch:

https://patchwork.ozlabs.org/project/netdev/patch/20201028233831.610076-1-vladimir.oltean@nxp.com/

Vladimir Oltean (5):
  net: mscc: ocelot: classify L2 mdb entries as LOCKED
  net: mscc: ocelot: use ether_addr_copy
  net: mscc: ocelot: remove the "new" variable in ocelot_port_mdb_add
  net: mscc: ocelot: make entry_type a member of struct ocelot_multicast
  net: mscc: ocelot: support L2 multicast entries

 drivers/net/ethernet/mscc/ocelot.c | 147 ++++++++++++++++++++---------
 drivers/net/ethernet/mscc/ocelot.h |  31 ++++--
 include/soc/mscc/ocelot.h          |   1 +
 3 files changed, 125 insertions(+), 54 deletions(-)

-- 
2.25.1

