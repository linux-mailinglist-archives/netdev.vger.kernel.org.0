Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491D01FD346
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgFQRQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:16:56 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:6036
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726879AbgFQRQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:16:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNGGNuz8G99STX2gL8X7ikwPodIg2bQpLEH6Qnf+VvcLK506gv73rX+FVtwVlpKJOAq0F1wm1IdygBx8Uzbk6are8AeMKZuhvIi1sv5p+BK+8p2ug+eQJIh1D3wGhKR920//S/pnGl0RWUEOehP1kPi4EL+mhvopyGnGpMtbJ08aX7TMQ3bTKCJOWMokkeq/mfMvQjWQm3lg0JQGpM0rF3f7XiwWKfAdnz0CTUUZvAUMz0Zezx37DurXAqirmVWu/rNryTEwlE5bq+5ENQ5w5W4+hMdYgX9gGs5J5YHhOwTIsxVNZ/74PJdESa4zQINBQwWz4HeBfv0v+aKTRPVNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un7kg9WCfpUnBeBkcApcV5LaT+i67s71Bj75eRvXFog=;
 b=T+PJJCKenf36K6xHSlBbZdes+FD/k/CoG+GjCZ/0bXXACnRS00mzynm0DAnGGGbc0P2CyPJGD5VyIY5l2bcpZ2kP8HE3UG4SseWUJOAN43atZdlsB5x2MvFr5HtwCGN88EE8DAP2RRQIPKQ2eGoTE8NCkEWQxrqstkEONKtx1WZufcmHcanvk8MCMAhEBvAEDav4dFmAV5JJzUBdOs2zzC8FExX284czdBECGZWaeUkXX9mnoXFS5T5DYOaGmVng3VdMc/ZVIMr+M7dYnhUbIDBhkSEwFxrgaHaPYOYxwMyA8E/ImMsvuUkBR/0ZtqrCN0btFl1awv0V8iTNfqEGLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un7kg9WCfpUnBeBkcApcV5LaT+i67s71Bj75eRvXFog=;
 b=fyp9UZNM0zLZcUnHRkKR4YufvDcHzGDVKLWW7dTdtbpS6/+dlWFI6cJD2zc7b6GBd4Zd6N2VkK9Yt/telI82ezyp0TYyFF6nWGmC0avSQWWOznpHqhpJwGrKVTdmkuDRTguIy29c5E3QXr4iFr0fLk3YAmptViD6MWFZyx6m5ps=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5427.eurprd04.prod.outlook.com (2603:10a6:208:119::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Wed, 17 Jun
 2020 17:16:51 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Wed, 17 Jun 2020
 17:16:51 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [PATCH v1 3/3] net/fsl: enable extended scanning in xgmac_mdio
Date:   Wed, 17 Jun 2020 22:45:35 +0530
Message-Id: <20200617171536.12014-4-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0146.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 17:16:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f6ce411b-3df8-4707-7976-08d812e239b0
X-MS-TrafficTypeDiagnostic: AM0PR04MB5427:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5427B91973669FCFFFEFFDA0D29A0@AM0PR04MB5427.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDP0p4505T0f11ULIPd8r1j3TeX0EUuN+KTziwaVpzXojctwNS8Yv9/B/71wf9wjfEbYhWMuE/74X97qL8JyIhlgxQ8FDhe62VPxjsRCvLseoYgMDFblc+eRQlkSFDTLUB6b5mN5K3QH6CmjARq0ENI3qVy9Lo1O4REIXQ4dFgfYBbu6rR/bc7+dWyZZnfc+iMGYX3inP9QBnmlQtRTonrwN6RdXgzilkvefd2U4XNuip5BTRYlm0yZuFjA2uPhk/zvKdFExbxxnHeg6zvwTMNmPsUFqGlQPDFm/pf0JKLbWQxl5EDzLoPUg5VbQJfLLQ9P9K+S/z2FFzT915AViYd0Iq06sFOPYX/iHXv6Vl4JxX2mZmzA0JVOSv31rRbrf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(6512007)(52116002)(6486002)(26005)(6666004)(1076003)(478600001)(8936002)(1006002)(66946007)(2906002)(66476007)(86362001)(4744005)(66556008)(956004)(44832011)(316002)(186003)(8676002)(55236004)(110136005)(16526019)(6636002)(5660300002)(4326008)(6506007)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R6biWCUDN01FAa3eatIOdFA5IzrMlDaN5pz5YmgxtJ7/MftMJNr5PN8GkB0X5C7nVsPl/uhuovLGM+M5QqjoAaSQmF3/eH0icmioICFPOD1UH/TUen5j2SH4/KiUYosbqF99HPbEiNA4vvZGnsIoynfhF73/12NUUtDJf6dAy2Tn+3GWtQ2UP9ycz8IhqnbTkIlwP719jdPRpEjeabvx4g9fw5UkdQ9O96k8YG0yo0JwDiM1lDGTYdIRaFWf8oI4wmmNU5RaKuJaICfkHa09C6aAbzYtCN1vuRK++sDpgnSw615IVUC1Mf76wJEnuWLq2WojTJI2ZV/34mQm8FaWNVfwtUIKH6JyYcV5k1aor7ESc/Zw68/qCoYz0noOWxypk6gT3IaB746n9B/o8dKEUSdWyxyxy0eXGE0pOnPWvYUZjU7DWCGW+XA2J0c+UvYC7yLWhFeEpOUZZZnfIbDuGHj+Hcp/fjDAQRbzJSxcbrWF+dv4jApHOcu8MDRYpD22
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ce411b-3df8-4707-7976-08d812e239b0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:16:51.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIdnVsC8bqgW24PF0TgSpPhb5iQJaDQ5iDdtq13qaXdZKfdfTbspOlsh565NPwJsx/BjmeaqbSUitbhGSoO/AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

Since we know the xgmac hardware always has a c45
complaint bus, lets try scanning for c22 capable
phys first. If we fail to find any, then it with
fall back to c45 automatically.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

 drivers/net/ethernet/freescale/xgmac_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index fb7f8caff643..5732ca13b821 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -263,6 +263,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	bus->read = xgmac_mdio_read;
 	bus->write = xgmac_mdio_write;
 	bus->parent = &pdev->dev;
+	bus->probe_capabilities = MDIOBUS_C22_C45;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
 
 	/* Set the PHY base address */
-- 
2.17.1

