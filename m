Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCC4324F7D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhBYLvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:51:21 -0500
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:2291
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229961AbhBYLvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:51:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGmGmUXulTQIbgiU4f3xNdwKYRla78RqnxczXT1jASXJxSvy5Q7BvSGXxUONrPxsgq1NpuhJPpdrGMpD3wmx/pvwj1Is2B/bOt6xG0Ia9asoWrYvKDfA7JqjdW3GLr4WVSP5h9+b0mcXzqO2tz2Qlh01BIIdYJWuyu9u0dJ2IobacdKTOlva+RV3ug4SUwpfFPtm9o1X/R++hBtfSNVIpAIr69ijXoqF84uvpHI3GX9QZYAz3p80k4pR5HJdFcrS41Q5f8sOrjNXY97kuDR8pYaRFryd9MnxMv44Xa0o/2Vqc8tuFhpeAD9HNb8YH9jodwrVkEuVnutv7AP34idWRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4hOEgWwJ/8UbtlMLGk3bOUnloyACAmd6KHa1ScQfKc=;
 b=YnbULIDQEfreQkqLqmu2E8Ndb/Gy2xei3U68sAVZMQUN2rItSkkjylKTzmwnQudEAU2ysK8eFlzviXGR7MbUwV29b0/wDsh8+MV+vgf8e7joXk8ZQAXX4fdaXE9E9cTaYrORYsQwMg9LEHVkSkU7O0jqAofUdgw63BBWmOtL13Ji5krZ1TqelLjMc/0BpVKPL4ba8FJDNHrowH49Xb500Kj+R3N8T1gkDIewfNT7A5gnLs84v5IAD7gzdD+SgMF8UyIZytsJp1/0zabDuUGK4pf6psosDm6Z0YECchmLmXSww7okn8IC6KqrL0DmTdU6atx86rRIPkINO++XmLc3Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4hOEgWwJ/8UbtlMLGk3bOUnloyACAmd6KHa1ScQfKc=;
 b=ZHxds78P60FbcHr0XJ6sMWq8UlENG/ncuYVcotK2UAxA5ZLkgAhGn213aCrjGSOG66pAsD2C/Kw2vq73iQr+ETz8/nOCHv5Cuq5kzbuJfwDZGYRcP/SrJURE0WOwNNie7TOtP+V0mJ8OGEG6HQZd7k7KIhpu9Tl/GTR4Nenfjvg=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5132.eurprd04.prod.outlook.com (2603:10a6:10:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 11:50:26 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 11:50:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 net-next 0/3] net: stmmac: implement clocks management
Date:   Thu, 25 Feb 2021 19:50:47 +0800
Message-Id: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 11:50:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab98b306-105e-4508-385e-08d8d9838abf
X-MS-TrafficTypeDiagnostic: DB7PR04MB5132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB51326084A614AEEB21F7A628E69E9@DB7PR04MB5132.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B0djpQ5Z61CjbmRoH5+tI20dUYnnx8dMXyxAQuICV2nFfGoaTLblz1GpR53KjA8FSBHNmN9n5OsE8gjSdDjGcQfib9Ioab6/ufplhGV4turX32v1w4KWfEm7B6GukiSIFYEtmm46GIRcl65cof7btPI70bkadG2+EqbAeQeqWBR5Yg9jh27HUVZ/Pahg+cF2dYImDZjt5yal1oG2izJagjdH1YPL3wrrYsI1ABjnrEJNm5qbjgGNz/ieJYNo3uA5CmKhjFj0OXGv2ecGE7lh96Ut9gqFf9ddB5zbketI0Xssma30cF03PUxySzYC8VGlJdi1xtHzXhhRO3DTNmHj/2CBHjpTeKzCr5UQzsFcfPlV/4mrkNzipqpueJQ3kc4q0hVVW6Rrgu2F7Lq848iSNqI9gagErgLXM7IZNN2PPVCPwhfkK1B4F6B+qoYa02MtD6uiK8xzCgQwY6ar8BwIpfLze91kic5PPeHao4VBjUjZjijfh8RbZo/0aTgDzhZK1OxSQArpRStzvPOIk4d8OYUV5Hh/5r7WwgfJ7XbdMFfmZU8gU4Vg9MQxdrRg1Paa+dCfTVTgkEe/kueANDjyWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(8676002)(6486002)(6512007)(186003)(26005)(316002)(5660300002)(69590400012)(1076003)(52116002)(36756003)(16526019)(8936002)(478600001)(4744005)(6666004)(83380400001)(956004)(6506007)(2906002)(86362001)(66946007)(4326008)(2616005)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0WXln9113wCcF/KgVOxgBTG1Jz5gzNEGV95JClItPSz1sbn51u6caVbTo/rl?=
 =?us-ascii?Q?2gYqqijRhPKwvcrEFmU57gilGefBwKGcDvWfaRAdkv3HVg6cichVlHZqUaoC?=
 =?us-ascii?Q?jButo8kvX2+UjIy5d5xSbVZxwhyQn4QKT1VplgBaa+Z6VFOnv3cN+4dWn1wn?=
 =?us-ascii?Q?hCdd57ReSGtsogenzJgYLX9gJ8JvJuNu1//ACK8R9mwZA9TOgehBPBzNYTNH?=
 =?us-ascii?Q?1b5tcTBDXf49uLmXQ7qkmCIt6Q66PMTTUR4vFSmdCLECZi9qVZYlnuO8QBYw?=
 =?us-ascii?Q?S68mB1zVfmk5XJsYQS51BeXAB0VfzFbSbSnxQ/I9M8AInoZpcRela6lE7yPj?=
 =?us-ascii?Q?5dQONxZzQuXl561x6UF778oGkblop2Baa1NR7LPBp5lCMoX442x5d8o68ueq?=
 =?us-ascii?Q?cRXJ4NbD9lUqlaP+VcuX+9R7VmGazPsqOVGXUhFbpPD3iAqiL7YvaK3gNyab?=
 =?us-ascii?Q?4l+LHbefk47Zk937SjDQrJTd5FH6KZVyjN+Pp/CLUEp7V0RQV9SXtaRwulU+?=
 =?us-ascii?Q?ZBJ3OtPEK9XB/a7dTMl0KGKlW86IMAjbVYz/3KRxL532em5VX/8u58WQVcoY?=
 =?us-ascii?Q?XLLLmdl36eaJ/lsSjXkdENg6Pmje1+fyfoxjQAVPo0cmGcer+570FAUwxGs2?=
 =?us-ascii?Q?wXs5/O26DXVjQjVpx+ruQmmBRWuH859T8uvqyF1gbGRUKDpMgslrA15KW3Qa?=
 =?us-ascii?Q?55IwXpCsINWuQlTxe4DJbYsvHCjygxzVwCfG9giBs0zv8YxAWi32HG5BuiC3?=
 =?us-ascii?Q?UBgboyeWBh3AajbbBFTwnhQeTaS3plta9Cf8V7f5+SgJrjCfk1U8YPM8XAqO?=
 =?us-ascii?Q?S2VHjs8T7a97BNqJ4tSZ2uK/jEGjMbQaDF/I5iPzCOFB+wHlZjozbmBabmph?=
 =?us-ascii?Q?YzTVtq56fGc/QsGT+fezwy0UEVSVWsFeyCxAIKrDDw935TYZZC+GoCLqTt2C?=
 =?us-ascii?Q?d1HuDXN1mw+KZnXuNnE6K2ex+7Mu63JNkm4px3ua3P9RRJQU0bOLTRDXYMhX?=
 =?us-ascii?Q?2D4gocLBWYHUyD9SW27vga7kCPlJsbykK3vi+swTwudUj9aOMjIIFKN+Ifc6?=
 =?us-ascii?Q?HEKCV4tgs4ivTcJCPeVlL+oYTlPcF7TP+qlG+/iBy/RY6wTCRTV99MeR+Unc?=
 =?us-ascii?Q?ho/aXqeB/vqUY40yE19ayIE7XJqOpMug7SpDzpuu+A4w6dsBAKm3z7sVQla2?=
 =?us-ascii?Q?urrRcMZ8Q9grqrnkTuH+lBnRasjV9Xm/gszuePuGz1SiGXDfVxdHQW6FhCil?=
 =?us-ascii?Q?N4o/5EK82J8EF9dyuhBYklysjvzH1Je70bEtJslN1Uy7qYq33A9WBykafY8K?=
 =?us-ascii?Q?scnNHMQotM5BRdceZxC8vsii?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab98b306-105e-4508-385e-08d8d9838abf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 11:50:26.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0pcom5Myj75tNgpYNGCNPtnkTMJ+ZKE3S6c+BzPp9G4Pq4DBZ77T+wUjmTM6jzy/o1YFu9aXB2nCu4tzHTxeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set tries to implement clocks management, and takes
i.MX platform as an example.

---
ChangeLogs:
V1->V2:
	* change to pm runtime mechanism.
	* rename function: _enable() -> _config()
	* take MDIO bus into account, it needs clocks when interface
	is closed.

Joakim Zhang (3):
  net: stmmac: add clocks management for gmac driver
  net: stmmac: add platform level clocks management
  net: stmmac: add platform level clocks management for i.MX

 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  60 ++++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  84 ++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 105 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 include/linux/stmmac.h                        |   1 +
 6 files changed, 218 insertions(+), 57 deletions(-)

-- 
2.17.1

