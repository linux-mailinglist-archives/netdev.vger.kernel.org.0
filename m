Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E806D479DBE
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhLRVuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:22 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234625AbhLRVuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiLsApbbdRdDysiZa+erdAWVZ0WvEuBCbesvIRRgLORM23vTqyfS8HoRIvw91DRjljm6rlrNBYyJMRc1d174LHwA8m62Q5b2UQiKBttewW/9ZFfafj8ldjx76c8USqr++4Pa2K311Zb6P4W3PqSa0d+x0EjbedyuNq6hY5KzCRSh/7jpXHBA/A4pDW9IPxfBU09zfVrQzjUpmESDsti55X3On28w72UvcusAnpj2itHQ4sr/Q16tPvsSl22FmvpgSK8U4i8Fa7oo4VuXGdVLhc0kYi571vYcCuE3yPY7qjvGxQQLiG72jah67aBK7Ryz+WsvZw2Mi9sEzFuPPuxqQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NN+CtDrNO/jO4nNH9m+X/O+qtA2g6dQCde/ATpmoi3I=;
 b=JimkL4oyNut6V4IOLWCqqqFGd0fKrsoBE4jBwkw37JxOm2X+1184tB5ZSbJKbyG9OFSPCR4BiO8G7luS/DuAFxCM9WfLvN/9kHjRP4jov7t+2B+DYSSZJNFbvFZaHZENgzEVWuKVsWbZPLlMLwsQpN0f8ox5GOoXFl63rgGHTWOU3GTZovIsIxFmL0uNjVI3zlDCa0AX87BfTciU8xMONCyJe7qEKZGAtAFwoankXAZRA6xuX8hEKlLWuYqRHpw4r4Gauk44VEPOCNPiGiG2bmhop9o44rot4ZGLNgomnPbRXLvTblH16AZlWOGn5HlBo8VJCog3lfPGiv9QmJBTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NN+CtDrNO/jO4nNH9m+X/O+qtA2g6dQCde/ATpmoi3I=;
 b=gWR0qO/bwQ6vQDe7a6Jnl64709rTrbbvcaY6ycfLRvsndHVzmsgM/NMVIkSZyjXwxpUrE+w0AKq6y4aGItOkOzTY2JjjhMxfSM3+UzXxPrgszA8nD2USq9N55WMR+equkqNNdI+IPfMZZE7+zywx5Wj4ilrsASLQx7qy36bVoUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:11 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:11 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 07/13] mfd: ocelot: enable the external switch interface
Date:   Sat, 18 Dec 2021 13:49:48 -0800
Message-Id: <20211218214954.109755-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78339a6f-dd24-4e86-2129-08d9c2705d94
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB56339AD3D98E80141ADCFB65A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnuvAWolywkJ9ogY6r/fH+HwhU1aKFemMXNE9kv5eulceM2NidtrHko0awaNzPqEPEC6RYjNB/6QJ6ppbXGLZjgZsUPzaixH9bm442L2K0hI7ESQUvTeoT6w5xJVuHDZyaphQ8YiMxeKlINlYLraj9gWAytD6CjfANbKLgf8r8epwVE6yaZI5aOYYp0lT3hJHxAf7s+nDK2XcTT2xx6ZcG3tmyyqySx8abkGy9p4HvDALCx5rLcRglphPqxJvxkrERhlZ1P/cWog25pxOpojL6/4hYHECHxQNabmLPtKBp0qxVhLdsLlPCGOE3xtfljcHWRbAmWQPW9jKzrC23yE3p0nN3XKLhEyPMBWrr4fd8L1TamAvKvSeK1Sov5xNC9686oJh8n63jkRwAxiGF/kmvR9lWv8oIYPBW8RqT13E4uYVQRjOPxZRBjOmYmX7t5AE/n3V2e00SfD5L3WN5QvKeW861gyd2xz0YPvVjBZt7+NaVvY+IFmCxvNyMVvi8k7S4q3DRwqlQD6MNwVSVdLBUXc2t5kt8bzLQNeDd155scEN8ibS4A/lT7jGXKHOYVWFxlz1UPF5qWzytITRGRSm81SbexL1PeLhWXSgw55UcYKyO3ke9BLX+3vJZtVziAEkpofHMOf95imhv8fvf0izWQr385duotjTMMBcinzW1ZxE/OUhjzg6n3WYdUvXLhOMkwqBU6RMaWiZzbha1tHPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(83380400001)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?60rFgRtq4frtd5CCAfuFt2NGu8aaPDdrNLkeDYxSWSaHorqYcKJxvREKH7s5?=
 =?us-ascii?Q?zNahb+aWx2mtU/IRu4yKWtQgJrxf5L9GuqBI3dcdSLJqWj3it3vL7XgZ9vSa?=
 =?us-ascii?Q?vJTwBKHh1a4pP2+vKxkflnF80URrh5ShLhGe0twe3JOuT61gFrrSHZHenJXl?=
 =?us-ascii?Q?b7tnueFuHGWeyWF3byNjdbiNrtd50i77oocldGQYBtKu2K8PTGHNAhKmmOJl?=
 =?us-ascii?Q?+5v8K7NgO8iRXHm8qfw+nUyEGukXAbA+0wwhQcg0l9JDInlprLI3HkXs4btv?=
 =?us-ascii?Q?8jhiXuHv33x2STObdhilPvwai0tPNYXwoHgbUSMCP0C/kkJx8Q/fQsmX77+o?=
 =?us-ascii?Q?Y/5SLr4y8mO1WO+E+O7OoQ2i8EFHfjtFWrGwzivsAw1CmBwR7Vr7MsJ+Ujgj?=
 =?us-ascii?Q?/YSABa861BYMonLwHZwR2+X3zir0TiPl7FxnRh3lnFpbAF6s1iABdyhHNJOd?=
 =?us-ascii?Q?7a1SMASy6yF/4bJrB+yuZ+TQNWH7fS+qRArSNjcOArmvA69IM8uTUwgDhuO6?=
 =?us-ascii?Q?VTFi8vL0EFS3quv5Kb57+dIa0ioVBEIuFyAWg1rMqI/U7mmFNw2yGmD56OZI?=
 =?us-ascii?Q?v92IkSKPTt6OgS5ZYKTAkjmC33Sbpj7P3hde3HVVCziKdBzl7Iv08JRTttMc?=
 =?us-ascii?Q?D5fIeuMPWDLLyuq2CQuaBk2IBmUTnJ4wwtEWQWOrPLvvVCAI8+URMUrcaqu3?=
 =?us-ascii?Q?9Xwb7rdiolaRXdrRPyQyk+5PYRcRvkIcDlKv85DT3L3sVNcuG4LC2r+t8GBJ?=
 =?us-ascii?Q?64QXptFelvrQRLXjhppAZ4qfWoqy27cr2wfcpHct5+YuulNd2SkfLSU2Hm9b?=
 =?us-ascii?Q?A8tS2rCEfC+/XREMeLJhAm8R2j6XvqSUmVq3a5SAP0qf5rK2xDRAX9ZtXbxU?=
 =?us-ascii?Q?fomvf4a4NaD7VwzjlaWuf3ztdKFYQYRhPfRitkgBAiZeHIockmDKu/KbQmEx?=
 =?us-ascii?Q?Z9YtiLdu/JxgtCh6odq7nZwB/CPmIO6A2nq7Zpyjxm/Wjf1yaomfoYEZpSGx?=
 =?us-ascii?Q?dq17fDJBhUt1MayT2Qt+0Lw3FfSXnGY7/RhU1Fe97VXWwF4fzLlN3ecB0n2w?=
 =?us-ascii?Q?sHp0jVlI7ubPvuS1azqA1s8jQZBZsUBvTAopPIgCw+9fz+gjeCXa2T61uU/h?=
 =?us-ascii?Q?rKBy0i0z7f+83UQb0h10dQOaSMxlOJkXqSMYFq//x3mPHGa8hTXRM66dtqFI?=
 =?us-ascii?Q?35sg/weonzG3INOO+TW9wpI/Im8rea9cIidAonEANDr4yiq1HS1KwMY7hrMM?=
 =?us-ascii?Q?I0SH0KPVbBi3hi0TQtW+Mo9lgGe1V/R3VbD6a5IP4h1iZhyHuhU6KlYTKbU8?=
 =?us-ascii?Q?GHLCT81C11difTRb7c9UOVSTsDbKGWSkO2ZIwglvZf4eG4KkL4e/3TI6Fxej?=
 =?us-ascii?Q?/62VTQmPQ824N9t7fHrSYTOXVNu0NREL2Va8HdCs2wVr+RJTSLWo00I1SWOv?=
 =?us-ascii?Q?ausw6a5ngkZCHA9hGmAnIBxkWwcYMRXz6k5lEYPDIuolFCgapAEMGWZ1fmzm?=
 =?us-ascii?Q?8t6NYNvbENP53bSxW1U8k9RiwNARW2gOrUKQNwsAFixzAHXztVSoaFhLKM10?=
 =?us-ascii?Q?4a7MN397p/xndUXMiq+k/BerNUPz8kHAqA90XyJBQyRdmimT2/l6FxPnn5oC?=
 =?us-ascii?Q?gHStHlNWyblyKLBHaHNFvxgCil0Ss4JnCRoojPC2imGKLe34GKByNsc21sSo?=
 =?us-ascii?Q?gCOpKQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78339a6f-dd24-4e86-2129-08d9c2705d94
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:11.3781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVHT5w6OAClSFN1lq6FWwbpKjMNMi99FAXUjzqI3iKmcoB/nJfjex5E9IMXxdBrM2jgk+yXVtNjRKJmUlg2IEslQWdMdBcafZLHQkPZCpXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ocelot-ext child device to the MFD. This will enable device-tree
configuration of the MFD to include the external switch, if desired.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 09132ea52760..52aa7b824d02 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -6,6 +6,7 @@
 #include <asm/byteorder.h>
 #include <linux/spi/spi.h>
 #include <linux/kconfig.h>
+#include <linux/mfd/core.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
 
@@ -103,6 +104,13 @@ struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
 }
 EXPORT_SYMBOL(ocelot_mfd_get_regmap_from_resource);
 
+static const struct mfd_cell vsc7512_devs[] = {
+	{
+		.name = "ocelot-ext-switch",
+		.of_compatible = "mscc,vsc7512-ext-switch",
+	},
+};
+
 int ocelot_mfd_init(struct ocelot_mfd_config *config)
 {
 	struct device *dev = config->dev;
@@ -139,7 +147,10 @@ int ocelot_mfd_init(struct ocelot_mfd_config *config)
 		return ret;
 	}
 
-	/* Create and loop over all child devices here */
+	ret = mfd_add_devices(dev, PLATFORM_DEVID_NONE, vsc7512_devs,
+			      ARRAY_SIZE(vsc7512_devs), NULL, 0, NULL);
+
+	dev_info(dev, "ocelot mfd core setup complete\n");
 
 	return 0;
 }
@@ -147,7 +158,7 @@ EXPORT_SYMBOL(ocelot_mfd_init);
 
 int ocelot_mfd_remove(struct ocelot_mfd_config *config)
 {
-	/* Loop over all children and remove them */
+	mfd_remove_devices(config->dev);
 
 	return 0;
 }
-- 
2.25.1

