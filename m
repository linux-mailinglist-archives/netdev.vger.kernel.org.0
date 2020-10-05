Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126DA2837BD
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgJEO2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:28:40 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:38417
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726517AbgJEO2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsErwRrTJhNGvPgT+4uQFnLA2KUrKWEd2JtXsQLYXnz0RmMWFs3dBt7ElkLjInxIbiIMQ1sgkCdes6x39iRI8ELEEaNRCXLDlZJl0E+P3tehvqvFcnLQOtItVh9WkXctC7JhAYZsXu3Fumjvuw+T2hgbV5VWhqYT829sQIBTW3NnbKi0Is2/RRKxotMvmPEPFr0oZDnp01KKHM9Cxvu/O2N+DBMRsrn9atCUTfvfLbncsg8u8Q5NsIZcMiyricufbKZN/d8Gktci2F+B8w/aDnqX34qz9mCPAshIVkOL0uaPA0Bgx5D1wRL3eO9ueFJMAP1KH1vb355CHngwRu493A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTQ9hk2lIWvd6+3g25p/mO5ho2/BmpM74MlW+kdADy8=;
 b=KU+bFgdBcZI5eb6UcDDOcGu3B8nlGfQv73+YZevCMptSBEFdm29p8qH+0KCKsnibWIfQmPDdu8PYDebACExAmxsBshc0Oo/Y6bIrmVRSWDs0PZiid6qEbQsg4QkBd1SAXJTPbzhaR8QXSQo0w0z9E8MNrrFIda8NaTtSRLC28RvVPLX9Tkp+Em6cNPOqKM1vqGoqhemGC+Iu7mj+xoXQsHJAyWYdi6KrjcyL4tY9as9jIZt0ZnLa+GMehRnyVhKN92NexcE2TWUxIVdqfBWSBeTmig9c0loOptKAqY2u70sis7JA8VS5vB5ybjV7ziNfEvRDvNkap4kUD54Qk8rDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTQ9hk2lIWvd6+3g25p/mO5ho2/BmpM74MlW+kdADy8=;
 b=JDmBbgW1coQC9siIuvenbsf6yn807wCpFalmCUlCortG77kyXok+IxIZrp0nb84FyRsKkVSOK2ApnhsqSlY1Bea2P2k+5hnNk3Nx1yVfqNuDanyRk/zND+yRTCSdOxhqvDWk2qZP+2fgDFlCBmuTlxgvW9BEBmWBFRjzztFp//Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6180.eurprd04.prod.outlook.com (2603:10a6:208:140::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Mon, 5 Oct
 2020 14:28:34 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 14:28:34 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/4] arm64: dts: fsl-ls1028a-rdb: Specify in-band mode for ENETC port 0
Date:   Mon,  5 Oct 2020 17:28:17 +0300
Message-Id: <20201005142818.15110-4-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201005142818.15110-1-claudiu.manoil@nxp.com>
References: <20201005142818.15110-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR04CA0060.eurprd04.prod.outlook.com
 (2603:10a6:208:1::37) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0060.eurprd04.prod.outlook.com (2603:10a6:208:1::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37 via Frontend Transport; Mon, 5 Oct 2020 14:28:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0d58267a-d16a-4eb8-d5dd-08d8693af0c0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6180:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB61800DC444AAF1D818CAD2A1960C0@AM0PR04MB6180.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+hXaY4Z564X31NTpp1sjWAJOVtXww0WjndotqlHMqsB3aUJxTxxKludplPw0Exe3RZg3XEKSs6RCCC1sx78796+l0HG2FcJS5PCi1KKmNiwdmUv1qP5RTN/lsBRNA/gZTG+76mbZz8p5XlyH2MgDR5/OhJQBBKuYWQP/lli9UrD8nFt76d1QRV6RUbO/LNgH9Zgd5d4UpOhK5y+3zrczvmCnhDnz4GYVoWeS4y0MLFRk2Bj9rWYL8ULLqaFaJAzMxVYj1YQGLOvXif9D4muLPKizPIeofVygXdd4jYmsRejsRNfdofD11cGFKdAU1GI35dytVUyKMKScvKWUz3ztQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(478600001)(316002)(86362001)(4744005)(54906003)(44832011)(5660300002)(66946007)(66556008)(1076003)(66476007)(8676002)(6666004)(36756003)(956004)(2616005)(6486002)(4326008)(7696005)(2906002)(52116002)(186003)(16526019)(26005)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TSMdHbJYjxuctDZ4NXYzKUTd8MxS1LC5BTx2k/cKChJMtrYd2IXECJ3DeV6B6xqDc+iHEycTQgrhYF7OXPMXWq5g3BF/sAcJHgUVNaHi+g0Y1C4gxCbajvMSIWEVq2uahTKHEY1gIWaZ+ulZD+8s2wBZTrhR0xuF6tOLFwr/j1AIsY5eSyguWOrepSIxNvS8nQ1hsY+U/4NyyoiJ+XsVOxx4e5JGBMw7qZddiGhD3EArdaYYoin22FNpuC8xCK1wS1YC/tku7dd+8xoqXQg0dryW8dxanZEh+3iQcXtZzRE2QLw+Ratv0/4svBEKWHrANLYTTUNBa2u5nHfmIQArCa4gKo7zqG4vADlyyjxqUdD/gyvu7z2nSNUP6GUjeu3ZzyDxjwxmb5bYFDPl0/CJ0HyJFjGtnDH0+Uq3dZP+wOCbMbOQLPKaNvjB1CSikBLRSi7dq1SOgB1nLnUEmq9jMMMUGE3ucw7eW3gySUuFDbiGdEd3iohCEMlldYoU6/VXJDe+EPIuwAgMs+lXMJA2Q5f1IRi7chcYx0sL/94AvJSlwHfUZ/YI6ilEexS8r6zNxjTsxMYMgNQVrCqt3SrpGXiO2BeMwcaPu1uPXfyvV8d/FAD20ALO6LyLLT1rysgFjYdvGQerE/A7gRvQjsjHwg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d58267a-d16a-4eb8-d5dd-08d8693af0c0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 14:28:34.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SNIb84YF6soR028qbvKiF/LNnS6S4eYhluXduOt4FWiKnaBMO33tRXk3XztJR+p8p1Hvp1epkEJ9t2zRTYYbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the transition of the enetc ethernet driver from phylib
to phylink, the in-band operation mode of the SGMII interface
from enetc port 0 needs to be specified explicitly for phylink.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
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

