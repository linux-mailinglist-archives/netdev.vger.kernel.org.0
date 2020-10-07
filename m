Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81141285C0E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgJGJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:48:50 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:16619
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727514AbgJGJss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 05:48:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SA5neAPW3fye97L9KO0mdfscBqCS0+Ws1YBhMFARv5nprXHCbNCq7VtJC+wY5t9KiVtqBdDOidvHkXfqCZzkaj85PHkJHb2RpQ/QQABL0PPR6hHtxfEg7yiABXhAcxJ0EXoSw1fdFMfNf4tT68samfwRcSUpJPlVDx+hXeP6AOByVdWL+3mLkaAwjdqP+FkvcCyqeP2MA+MX9RaMR0dDdPpQ5/P+PVW8fHT+kU6zfjxa7qWyBKKd+uJLpZTkF95okDklXCcZW1j5qFFt+tI/agq2hHw4gho/2ANoS2RUabZXHxyFpx3MaUhCK06F3mpjk+9EKFAH7m8IKL9vK4m4Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePgUDQX0uRbJdyXUEY/jHoY1z/v8xWThj+9/FZdm9gQ=;
 b=Zv0UijLrCnc80qXZdN358IGcwz9TtEbHl/wtI67CkAp0PYIMmqvn0gjkucak2aKDFXfhj7u9RzkAI8awBVoOdpQwNny/JlO8Dxiaw5UARZxb0vVNynFDxCLKAjyNedWKqsTENhXcOrHWCDyW14aMTk3pSySK1gd5pl6QjFihf1yIvuI8qi5tfacK076G/viA3OhsHt94dum0ruyxH3iCJylGxI0LD1lidk1SDxWt6kNitF3eHDrMwptqFk4O5hrYWgNXjotb/td2T/Vxf24NppCpc5i1o0VxQSbR9NwBXMFjcCj0Fsb6mMfZPv/gNSdT80vaWFN995iINlTHEHwOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ePgUDQX0uRbJdyXUEY/jHoY1z/v8xWThj+9/FZdm9gQ=;
 b=sLuq3Vd7+1cZAc7hvQ05NJSCB2eLYUR9KR6RafANnff5jEzkDXJRGOmTRalcbdc/l3npOfSIEIg3AsQfy3Vwftlse3obA3sW5d/TJL3iQxm2zKrViqKs2JBKafAsm3SDd6icvJ2qCEEy8kyo7HrwT5Uy7+fokf9GVFp6Kt8avtc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB7169.eurprd04.prod.outlook.com (2603:10a6:208:19a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 7 Oct
 2020 09:48:38 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3455.022; Wed, 7 Oct 2020
 09:48:38 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/4] arm64: dts: fsl-ls1028a-rdb: Specify in-band mode for ENETC port 0
Date:   Wed,  7 Oct 2020 12:48:22 +0300
Message-Id: <20201007094823.6960-4-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201007094823.6960-1-claudiu.manoil@nxp.com>
References: <20201007094823.6960-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0013.eurprd03.prod.outlook.com
 (2603:10a6:208:14::26) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0013.eurprd03.prod.outlook.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 09:48:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29649633-83f0-44a9-397a-08d86aa62ac2
X-MS-TrafficTypeDiagnostic: AM0PR04MB7169:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB71692E4B5C12477842EF2CAC960A0@AM0PR04MB7169.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V0RYaFLwAMs2FsWufWwASw6ORGAq6r7EfcPvXVeAcfvkmYnAxLV1mZIicPfbuKjmjln5wlm6wGF0nSIzo3JogxhMjX8cAvbb5CGz73nYLGT8u44jifrsV36CT4tVwU79c/W89SrI29g77vK457gBof2C3i9cKo7U9UbZizeF2B/+0m81GvIgxwri8vNq/MyleUtWVFx+S7ghB7TfZX26KNZ7axv5Ryw/RdP/z66C5l9INN+O9dMsA8gddV7WYeVHMwr2LMWh73Ms9Iz+r/yqNGVRpHwEdZxmFgSswTN0xPJWokK5bfhSvC/VFwYes4uzKC8AtY/Kr4t6vXc3Lo39Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(478600001)(186003)(8936002)(26005)(6486002)(16526019)(6916009)(44832011)(36756003)(8676002)(86362001)(2906002)(316002)(4744005)(1076003)(5660300002)(6666004)(4326008)(54906003)(66556008)(66476007)(66946007)(52116002)(2616005)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VpmAFtUCabBgqmAo0fdxl6sXbieN2tQ7Rt+v7M4sVz1ArvBNimADVtGL9q/mYmmPuZFRbutbIOZj6cAvtShqajNx6YkD0UJEsQTmPKsYDOo2nEXIYPME3ysAjG68wjau54BVF2+8zoutH6OXspLU7d8IWCkR66E4ghz4Tuo8D3jNBLFML52tJVMSRC5aXy4A/EyyrRvcb0k2VjZZgaZQEJmnEI5ZXgIEJKFgZCU0XUSN9BwcCX70lml3z4KdL5zpuya34pcnQHBBLaAf4Z3rq1akiflVQ1f5359fO5TTnMv6wcU6za5MzopcW0m32rTi9cn6D61j8f+/eaCYS5bMArBvzpAgF2IkyEh7xzl/PZLZzACJwTTe8GnuYP/8TMHqcRRgWVZfaSKpULWLX12nQ7S339wzBfbDja5DeZRNK1K1VmrbkIJWuSoi4UcWE6KGs2ieUMKFw5qPVMQzHZzftMDlEU32DwEDN8iuX9UoTCQS5rr9rPJcY7S44KFnh2AOQhc+wsbsIoxA8DfSwfD7/a8+byZ53YwJw71Mm9IkeTh3Kyta98Wy6VYMTxXS87JNH/5VxdhEMETpqfRPadlHg23p+F53vZrIm+5HOZkRIAEcMVgnm+cg6Ax5uQAiUhH2h4i9Onhsxk4T9ebMQvfKiA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29649633-83f0-44a9-397a-08d86aa62ac2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 09:48:38.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HmUYgINeBSiasN+tU7Qb4H2S7ZStJ8JwueioOtu4wSqZME1WKH0f6TztnNpf1NDEEWGaikgBEai0iRL97JYj8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the transition of the enetc ethernet driver from phylib
to phylink, the in-band operation mode of the SGMII interface
from enetc port 0 needs to be specified explicitly for phylink.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v3: none

 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
index c2dc1232f93f..1efb61cff454 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
@@ -199,6 +199,7 @@
 &enetc_port0 {
 	phy-handle = <&sgmii_phy0>;
 	phy-connection-type = "sgmii";
+	managed = "in-band-status";
 	status = "okay";
 
 	mdio {
-- 
2.17.1

