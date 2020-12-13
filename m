Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43292D8AF8
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392621AbgLMCnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:43:12 -0500
Received: from mail-eopbgr140047.outbound.protection.outlook.com ([40.107.14.47]:19174
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391939AbgLMCnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:43:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb3UfTU1f2r5DVLPcC8kx19CaXEbSMPeUbVnXPrl0nKykXc/0zN046EXhPObKZ+8ablXUsiYzma+OJ7EerwRr/271oV+1lTccZamwyX7+1GmV0NO9FQs7tINI95azjraJesdjGByPgOSiW/WcM7fmvjyPUpeOg6uhXROTYnkDBHHK5RzwISLGVKU8j3xxzVDRceX9sttEpbtMzUne5UChQ5dBb8aJdbeITn9Mr3lCGRlQHWrv7L6LAVEozle7ZYQSHYcjIAr2FYZVFwEKtdym/YE8reRzT3WjQl30ZWSM3YNQ41Ap/iuQWu31GiVSXBf3UX3hBB0vNH3c/6kvp8ECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LvWwr5ZxZfUuNRDtPZWKbgWda9RNbr0e0Q17P0MKR4=;
 b=XKwgSL6ihvtSUIMg62PNEZXi5hmf4L7gak3OJVhFPs2s4/A8zPgi9SNr0aMWClOIj8c0lNIp9JopXH5DNY/irwx37vMkN7VFvZRXozw6ww4z7B6Wtm02UP1ifPr+gDf3epnbwgHsouBr3hDAHzaRoiSIWDM00kqDoBNSwTjUQCgA14YGIJ/iS4qJDyO87DFw4JoklyPkguEDwdHC8Z07H/Ywfebv3KN/4Kk9VX4zMT1m2TxljwYxNe34QNVUTQxjjPjKZWM1RgPUx1saY6NZ9Lp8rZCY+TJhg3kuQhvsR0BhnydqHm5/jaoWBdVIvRKglR5u2fVTjUE4l5NlP7YCiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LvWwr5ZxZfUuNRDtPZWKbgWda9RNbr0e0Q17P0MKR4=;
 b=R3z25tFj3lLcZM3g2tfHfxh94YnaXxfTTozJHFNE2XwXH0E/dnmQHV4ZIktlqih5T6Mvyry3WCZ70/0zddPOomytjM4JGvtCcyzKs6TBX+WD18q5wKiLduUVwFhmpRw3dJrAP8EkuX0Ytd3Q3JvhwESyQSlItsZlRqdHUk86iqU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:17 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 6/6] net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port
Date:   Sun, 13 Dec 2020 04:40:18 +0200
Message-Id: <20201213024018.772586-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213024018.772586-1-vladimir.oltean@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c3c545a-d5c5-47dd-3522-08d89f1090f5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407DEF4E64435628B783420E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8b9iVyUyvJDq4IqKTxZZ54mClPxs7aSaQn/Dea6ZhqnSL33CgoqKJcf7JzwhJytVuxmX0juEk/HwVhXj4qS62jO+fdPySOz+uhbnsvtrWgLO6ONlRoVW6xnR1nskuCWZCHnOPzsEVwakHwP44E3vGXEhiIYHeeSW1OVNwyIo8mdY2o1t0HuSV+EJqsG7wzjujf6c5VBbwHY8dVCaiqSCRraE2qjpJ/pT9HQbFuTBjwPBMBoLSJ+s229sN0zjd5Cm/J9Ybn/DhsBq4sRl23Lc0ZoEjblX1HAgiGEHiz5zXn/yYuODmJk0XFjo0qMGYQAkxWE2NE61TY3TT9Nw9x0e/+FDxLHV7m5n3xibfKyfCezSFaPfDviYFTMI7oQp3IGUFYzL0XRv426Vu4AkAJWJIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uauG0IoXfnTjBG2nqYVtDZfDR+EZNRBW4gg7uwaX3PLEmdwyyyrAQYgD5UFZ?=
 =?us-ascii?Q?SF5laCJx8wTJEe7XNusUHrC5tgb6qBFueS2qwFs2/iZ9bZaSJl3NrOKFgIl/?=
 =?us-ascii?Q?IH8IIOQDdbgBIqBhU2ERv8qD8w8y3lT7YNGFkdpRm6iF7yST30Z13vGe7MBF?=
 =?us-ascii?Q?rv31+0v+VxFqABknpJkksAxZ49spogYdY+gBoGNcZTqJUqWwdfBoB3/t3TPA?=
 =?us-ascii?Q?PpLiYx/CR9db8wzB4DWTzMXQBCNQcXRPthaH6X9+VR6p/vcDB7ucfEi27J91?=
 =?us-ascii?Q?/aqxAVIPQvDKhs94ZDiLP5sda2v5cj+W+vnoNav3rOIQ7EgbWtKcsc1Z0FRS?=
 =?us-ascii?Q?qyeK4wH5L3PuOtuoQfWo6bFkeSzC43YdLNACwAfv6iOjMU80RaVVaN7en6zV?=
 =?us-ascii?Q?4Ys2CO50K7BGwztn5I7c0QRuxPMDVVimZb6jpmVo0psF9BT9UwoPQkkEyAxT?=
 =?us-ascii?Q?27haGXGvazVsmgJ926xMIj0UiMPxiquTVBwXs66zR4S60YH5hj0kUS0V7D+V?=
 =?us-ascii?Q?D4zIkgmCY2Q6rduJ7Iljgn5YX4/kptRhdluV3/FU/qqs1lg8ni2O+NSxFGVA?=
 =?us-ascii?Q?dW78upJEQ3sdLEMF9/uv0smJ+/BqgSnwkAMoslEioUQ6bvN7shS3O3rntfMd?=
 =?us-ascii?Q?jrSlnKhiyfL4wCyVC+C2PK5y7gWZwMxToFDDChYqwcvYwC6Oa7y3aytvFJIZ?=
 =?us-ascii?Q?T81/bHjiMI/QoCEx7gOQ4cF83Bgt3JSjwcVrtrU3Dxchl8a/kTHJfe3e1PcJ?=
 =?us-ascii?Q?KSszHHRND6Sqgwo+jQpSVObvsljGXiSRBccUf0EFSj4CeaLeknwF1jzYDlgC?=
 =?us-ascii?Q?B1RPu9bBsxYm+/ijeDUrEhXYTb86dDhwvuaOQn+nywqsYQYF8MjUv9u3kL1S?=
 =?us-ascii?Q?CeA+VL5r8VYM6BsPFGCFEuUM6baRT9IWPsBR0dw8mNd/crUm/2eLZycwOwzc?=
 =?us-ascii?Q?oc6Xr+TL3CdXm475YyUPKvl6mbxq0frY5728kHRIvsuBfOVv83YzNiraKk6E?=
 =?us-ascii?Q?hsg/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:17.2207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3c545a-d5c5-47dd-3522-08d89f1090f5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1aPuftV7IeFaCvj9Np7xBr1eGNVy3rZd7lESxmOvsI9j+gvEuEKUwQdV/E8krRwsVlOpiZLX7hX5Pyz4lN3R4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the following setup:

ip link add br0 type bridge
ip link set eno0 master br0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp2 master br0
ip link set swp3 master br0

Currently, packets received on a DSA slave interface (such as swp0)
which should be routed by the software bridge towards a non-switch port
(such as eno0) are also flooded towards the other switch ports (swp1,
swp2, swp3) because the destination is unknown to the hardware switch.

This patch addresses the issue by monitoring the addresses learnt by the
software bridge on eno0, and adding/deleting them as static FDB entries
on the CPU port accordingly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 7dc230677b78..bf48f2e86bcf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -629,6 +629,7 @@ static int felix_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->learning_broken_on_cpu_port = true;
 
 	return 0;
 }
-- 
2.25.1

