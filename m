Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05A2D3A0F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgLIFF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 00:05:58 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:46478 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbgLIFFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 00:05:52 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172]) by mx1.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 09 Dec 2020 05:04:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OtoqLxmRKWNkoSunDtL9ky58xiMJDksruabyHuiaAr4luXHhUlq7w7Vw4in0P8M4OtVMa1z9+aFgffOmMfbqrvy2tboYzkYluJLMMlqnInF/SJO/+qHkL+6eMwQtTnEtJg8YS2KI4KQ2ooLOQgbrCI1iAQ8A2KlZtjupKGfw5ZyzJpQbFvNAnls8O+53Mn8jo9mp76tojMc5fv4KeZJmqGhAfq1xiacb+D72OeroglOUNdOZ7mywbl6Wq2tKvLFT/X3GZ5LJgt4QEbNEhOVzw8knjlESRx9Xd5HB3B/+UWnmzEx2opvrq9D2VP3itQWJcq8SFumvJ/Xke3RiPDDLIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEtOKwi4P4PV69Z8JXFRNmuuo0X6owQYD5Iv66lSqF4=;
 b=cVKCRgzjh+Fzul2YFjRcUNprZAWZGyqgVN8kDUKWGVLhwdyu9sY+DuSZjHOt+DPquYsWC2UMc0iTX6J3btV6BW/9SBSh71FOdwJl8+yE0tcOkHR/AxkNrYd4pso6HiQogVqezv8WpxunaRYGlE4TFepXrizs9px80o92v1aTkrXIw9/DcnGCdSLaPdZ9gCYbPHL9l+nUXbZnpKuebaV2IKcBdjSVAIY4mb7DVcJ83FaCq+32hsZA7xNWjknQDDzj+7S/cczcphE76rG5kbBxglwLKUFu4BYRdT4Iqf8q3uPlKZJY5RDzgfiwt5YJ7eAvGPezAV7scrUPhxPlJuxpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEtOKwi4P4PV69Z8JXFRNmuuo0X6owQYD5Iv66lSqF4=;
 b=rhPr4rYMQF1ocHhBx6cV/KgDb7qBSbdl/B4TMoz2XX3wojrAzbpqVEyex1nbjShSvsrAsh3Q8S5KPf7fF+TMZKqx/WQfTyTfSK3HYTQoJAAaJ85x/fyvABmnBhd0lf7h1PgMQ2v6ilNpZQe+kk9Tz0k2fZP+Uq84ddN4zS33pq4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB3441.namprd10.prod.outlook.com (2603:10b6:208:7f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 9 Dec
 2020 05:04:48 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::c8b6:2021:35a0:2365%9]) with mapi id 15.20.3654.013; Wed, 9 Dec 2020
 05:04:48 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: [PATCH v11 2/4] net: phy: Add 5GBASER interface mode
Date:   Wed,  9 Dec 2020 15:04:23 +1000
Message-Id: <7d0e7609149c4e9c3295eff3323fdea92a4abc89.1607488953.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607488953.git.pavana.sharma@digi.com>
References: <cover.1607488953.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [203.111.5.166]
X-ClientProxiedBy: SYXPR01CA0135.ausprd01.prod.outlook.com
 (2603:10c6:0:30::20) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.111.5.166) by SYXPR01CA0135.ausprd01.prod.outlook.com (2603:10c6:0:30::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 05:04:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad650fb9-62bf-4870-d961-08d89bfff3bf
X-MS-TrafficTypeDiagnostic: BL0PR10MB3441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB3441750542056936343F8A6995CC0@BL0PR10MB3441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXStCTWKARb0GCMAjja9WVATqmTsczjJHCWPQZhLOU7usBBG+KjUpL8zmn0M6+JsPyMPX0g/IEOpzKugZ6Wg4hX0Rr3njSX3pnkr+gIijUQ2mGaRuZpmIYx7AMIx7hYfLUMb01pBTMSlM/OU8TQgiyKwj9pCbhghZs8LtVhmFa1MR9Cjsumdw1zpGaW73AcMQRCLNA1p1nk/zL9wlyTfq/G43x2mcQWVkSSonZ6r+KUb+ir24285D8Ap+2YQzenrVEl/xDJUb1Q1f5jKLXUDp0JyY6fsdZlrlRz46Jc4WDqJ/48ZU+kDTHJ87SmiLf9376luh8GQRdZyo6rBWivkAvSOSxYlgoVgg/Qlvo+lyep95mpIZKITsSp+r7SpTw7LB9WmUlKCr+ChLY8/qqLe6eCRy4ctKeX8ywWCdeIN4rc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(36756003)(52116002)(34490700003)(956004)(2616005)(508600001)(66556008)(26005)(66476007)(6916009)(86362001)(66946007)(6666004)(8936002)(8676002)(4326008)(6486002)(16526019)(186003)(44832011)(69590400008)(5660300002)(6512007)(6506007)(2906002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jiKcZDEGpKNNelCBuiVZe3BYkHcDGx4z2pS7blHkjSxWUKEryyVGyEx+/U7o?=
 =?us-ascii?Q?Tz5tnvo/hgos1yM6U/Dkv+LkzijpNc9AH8TykK6mRQlxHMt4UThlDrKfkZ19?=
 =?us-ascii?Q?3pbgTmqhuwJ/BOS9aJ+g7a515CukDfaGOoR2rZY1ZUhOJHiaINP4TmyreTLd?=
 =?us-ascii?Q?v10BcA7lsiBqOWd6mqIcO74jgQqVfUeKWuMivSf01e3r43FUjn6v8eH5Agyt?=
 =?us-ascii?Q?NdbFQIytAwsSsfcjeu2CgrEUxFq7bK7DXZbYKgITDGCHccoQuGbwaywOECW5?=
 =?us-ascii?Q?RDj0Kq0z5on5nYF6r0f5zK6c1HG5/XI2OGEuMDJZw+thg+T5OeCBXOhgEN2y?=
 =?us-ascii?Q?zd45YIMKMrBK/S2gKhX4owMdxJ8mDb+MaiuhHtH+pPhcfNjwCoSwfnn51pYZ?=
 =?us-ascii?Q?GirTmxB4V2Tul8h8n56G9yIDDid0olFw0D8IMDpE0jRHHXA/U4OOQ/t6Jm7i?=
 =?us-ascii?Q?JRGzRQ481Dj63FXVc5z3JRpzf+TgX8QbGPmQPMDOXQ47mGg4HMriNJ9sHCaP?=
 =?us-ascii?Q?PpdzqwT44VfSxWnNE6purkov5AYHs1hr1/vjlFN/aGzEA45+dRrhkyrMqJej?=
 =?us-ascii?Q?sPKSc0FFB7bEuYA1vq/zJZboIy8BWJUB0NFZ+bRPSAGLOmJ2Fatu30vfUFNX?=
 =?us-ascii?Q?wGUs3otUHEa5Xy1KyE06nUnaDgzzY6UiPOFZTn59UrK53hkk5mbbgUqEUdj/?=
 =?us-ascii?Q?yRcCnPpEQ8IfsiediNx+wIQdUGwIJmvZSRBDBHyMp9WYYxqF9VNUQQrDaL+F?=
 =?us-ascii?Q?mtQ0awmVbanft7dd0yOz8tVwCGJIKYkiUGVkBPa88N2jiZAkToVYXXuih/uV?=
 =?us-ascii?Q?aj2dq0xXNTF70tRJRuRowVRZRBEMhmJK4OlsXAy3klKz2LI1oaNnHelSkeZi?=
 =?us-ascii?Q?Tywpj8VdC5RcSodu6v95+BJPaT/c2OntM641ml/naOh/VIy4JYjUauuKSTSE?=
 =?us-ascii?Q?QzZcFyYUzsta5Knc1cisRHUUFmtoMFh2zIYmLkvWqhbTwfhyUakI+rhT9oRr?=
 =?us-ascii?Q?MwZO?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 05:04:47.8997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: ad650fb9-62bf-4870-d961-08d89bfff3bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybaOEYO+zzQ0BwJom21TGaAuUFFGugSuoETiwmRkos1R3D2YwRybk5VCyhVzp033wYH7r95kF4709VWn27Z0pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3441
X-BESS-ID: 1607490288-893000-4814-29180-1
X-BESS-VER: 2019.3_20201208.2330
X-BESS-Apparent-Source-IP: 104.47.59.172
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228709 [from 
        cloudscan11-63.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 56563e5e0dc7..8151e6ecf1b9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	/* 5GBASE-R mode */
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -207,6 +210,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

