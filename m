Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1DB437B02
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhJVQiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:38:21 -0400
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:5957
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229968AbhJVQiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:38:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyR88000TtF6L/qp+nYoD9DEq8hPChYP25S0yD1ilwp1kd7lhRqT34l7dFiR3EzMcpDShOEJ49Mx15KmKu9kjrDog/mAfbW2VuWI0p6e4LbrAfRHrglU6gBQLAgMXlf+K4uVvr9MYXEYw3IPajeiZoks1wnfzwc7ooM7IhdMVShA2eGgWjB+OiC7O6mVZZKA9MWV3ysFkRfeVfSz6iZ6t+BnBSceG3jovpwULvDdNIrVL60QYt+/sI0HG1y/nqHa0NSZyp9EgmwwopUqPGvSTM729sSW6asz2AEj0VIcFddWF02Dzfr0ex8lPDzL7h+Olp1uoz9FBcKTj/GQeblQ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y4tLCv3Y3CiM7gtJUwihWe+hjKK4/oPQp2dMCrg7bM=;
 b=OSebc0hBnGK04VCKIM55AAiwKughBbfml2arH7ezwvmcM5PGr8QykyjAUVKqebyWZZbg53+4rOwoqQhyxWbpR39yt1NMKFI7nTQUd0y8Yt0pp9XN4MdDyXM0iQD5YMoNm+e90uNdd7GOlGoYHaMtGkv4KVVK3Xq0M2Wzm1WX/PIKULmXDW1WiAKpiXZ8u6ShDeXbgDRWXQxjwegkXQ65cDMaSvCf+Qklmfyi0Vei6e0PDsTiYij3KlnTSTheLIrGF7vaRy+y3nBqTLwbpRiQKWJd+D+HQH7RQiNg2zjxEA5Cmsrres9/iKXBnL4agaBhTla+VoTFkM5FriwIhEEGTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y4tLCv3Y3CiM7gtJUwihWe+hjKK4/oPQp2dMCrg7bM=;
 b=TZ5nICyaEWZVvonVoXaLaa4Qqttp4QHqQdVFTzBtgJ43/4RkRY2UbrNPQewdg9wHLQ2y5VNJxwWIqwRXBZFwe2d6zk5pwR5MN7pd1+DYqM3xO9ldR345Dl8F9F1dMyaMJMSNM5Drcq81a5z7os/wKf1UfsmDslPAOPyoHcQxQZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7418.eurprd03.prod.outlook.com (2603:10a6:10:22e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Fri, 22 Oct
 2021 16:35:59 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 16:35:59 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH 1/2] dt-bindings: net: macb: Add mdio bus child node
Date:   Fri, 22 Oct 2021 12:35:47 -0400
Message-Id: <20211022163548.3380625-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:160::30) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR13CA0017.namprd13.prod.outlook.com (2603:10b6:208:160::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Fri, 22 Oct 2021 16:35:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cc4d16e-e8a3-4900-c1cc-08d9957a078d
X-MS-TrafficTypeDiagnostic: DB9PR03MB7418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74189895132202B58E08869D96809@DB9PR03MB7418.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: emipfumIICNl31Y69Jk/zUVVe5bOBRgg1Z6UQ4IjhOL6g2K3dFabbZMzUzThimmVVd4z1qW2b31o7BFyd9kLM5D5ux+D5lkfUugLFf26rFBFni6p5qFIEQq3V57z8pOPw6QuG8Ohsh7S1xa8lKuRYgbh2Az5Y/itDIUKecLdJ1lZiGcxUAdvIzJktpQPjIwx3iTwykgP5MXzwHGRAVdw5ysZ0HWSg44s/ud5ZriH5p1v/u2pE3ryMpuwFi6hhzsc9vfUMaLajHR/n7OzS6YU0iWHfc01MR2+qOwtnW3Rg5ZnkXvim0RnqTO79fHYUxAsnO1zApZTbp1oZAuhDMsnM2sisadjmyxopDEy/Zy4Vqyvq90PpSp4xhkWXfgRctWrPYk4slcqrdtSBeTB3Pv5ksNPEP1EBgtIu0cWl/Abp5buKSP+1QFi8hDpwhyqYz48HIDGfWGiwVhWwlQBZ11h3KgiooR8aBCQN1pOIwhN+Y1xWXEAUOq4uLgEF9DoXfqKWFlo7+l/Y6Dd1DkvmD6d0MTimLya3zJOBExU+b3lSz9hUiALyJKRQoIwEDdfKsOTZHdYiigjB+Bw1TBoH9IhLzi8YNfyZb2oX10K9vNkUrUKUBFs2dTIfx07TX9OXVuZXWRBiC70s6SwP3/kCUa5JITPxhyU6GL1mu0+86WeTDlUzFyldAjIrSFanmpKnHKlJvHFmi+n5Q3Ym+bWGDg1OA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(8936002)(508600001)(66476007)(66556008)(38100700002)(38350700002)(2616005)(4326008)(6666004)(1076003)(6512007)(5660300002)(4744005)(110136005)(54906003)(36756003)(66946007)(86362001)(83380400001)(44832011)(26005)(52116002)(186003)(316002)(2906002)(8676002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SyPfogVQeq6r/OKd29w4O/Vke2mWSwjWnClT7apayxf98lFLioj4nMTjjhCA?=
 =?us-ascii?Q?JCh9lL82zHv/uLQJMy35q+iSIpzaizrjP9j0HMm4T6biyVkEHAHtZ6OuKiCD?=
 =?us-ascii?Q?Zw16BWNXW9Ty4WCgXtdWbCfvhvAmwyd9v8LYYCnkLI9Uk3aN91e8v9K/vYvX?=
 =?us-ascii?Q?KEtVJVNr8iZd4ZztTzJ+FcxTk3brb5iDLcbkQUtnHboVzfN2CvwT+zH0f61u?=
 =?us-ascii?Q?vLYu1cev84sH7RSMekIISeucrpWm/RlYOf8AP1gUYMUuDaC0Vkd+arH2Jpbi?=
 =?us-ascii?Q?Kqj3dKdLglt6wXQkSOB1X+fhmV5MGE9qUwP47bREvrpbwgGxuxARQH1xPDj9?=
 =?us-ascii?Q?VIMKX9xQYMC4M6OHMcxdX3wJKQXMe139PQnsd4q9v+H9Non4to8W3jRRMWFZ?=
 =?us-ascii?Q?NKEUe3w3bIbDD2dclEbiPKwETlcC7Hf/oKwop7r2YCf2m7+0cXBtGQxMTjUT?=
 =?us-ascii?Q?tjIsZ8NkR8as+NtPEQtSTdqYNeIEh8fVcOFCGj9gMXErbyH1rdWMFplaJAyH?=
 =?us-ascii?Q?A2mKX1l3WrJlHjPfc1Ov6xPB9s1+3D9mxaaks3fp1uqYuddYmk+R3r2rgUnh?=
 =?us-ascii?Q?gqMWkP3fiFY9WLkjbhJ7mBF3KOWOUPFtd/TnN5rlgpJX67E/lvdp+Lk4koSp?=
 =?us-ascii?Q?5+Ch2joM+rsMa7Twtl5DF2qABxpNOa5F8occNMky8mea5vL6l0nbNdGsIesy?=
 =?us-ascii?Q?qQfxBazN7BVugbcqY0pYVNT7IfYhsrgK5xHN14adMRNDyX3dC3rGOkb2gQAT?=
 =?us-ascii?Q?IwEclQKrnhMzYygMnQYvbnlcWj1FvSu3bAfobKTFU2AzAiEKDea3OY5nxQi+?=
 =?us-ascii?Q?wD7IgH7i76lHTrT63zUXvDZEtPnduJcH7WqygcH8hmbUxlMSWxSIfhiC46Fc?=
 =?us-ascii?Q?ArjW+/mqdXr6dZpsiToG1rleNGUPBusm+o7rFBKCpAj/jmpUB58cO+UbRtv4?=
 =?us-ascii?Q?nAPM3h0bqCJa4HFdsMPKRwa/EAvyxp87DgdKuUroq4EinnWMHdwWj3/vgzQN?=
 =?us-ascii?Q?oimeP08II0vg//PzH/hMXQHcuIryQYg1af1ufNHIaO1lD3iCKOCK9kurZ6Q2?=
 =?us-ascii?Q?n4z+JL0BFg93ed0jkH3xlQis2ohaknCWfXC43gws+yIaAuKovfadmBELvveJ?=
 =?us-ascii?Q?fcWKSJclwxyyWOETFdQew+m06q7PRbKESOzriWvzW8ta43O7vAgDxeyIj58Y?=
 =?us-ascii?Q?vctKEq343WRaYSOwAX0y18knnLkLPYf39Dlr2eFkhiG/4Wk0JwYD1kvLoWcz?=
 =?us-ascii?Q?y5jy+clRek83XrVfAN6UEanNqBfWVSCYTIavx3OVvjeDockiyLDM4bz6KQyc?=
 =?us-ascii?Q?KNNMV7H4L289VZY490TnpHWd?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cc4d16e-e8a3-4900-c1cc-08d9957a078d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:35:59.6984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an optional mdio bus child node. If present, the mac will
look for PHYs there instead of directly under the top-level node. This
eliminates any ambiguity about whether child nodes are PHYs, and allows
the MDIO bus to contain non-PHY devices.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 Documentation/devicetree/bindings/net/macb.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index af9df2f01a1c..a1b06fd1962e 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -30,6 +30,10 @@ Required properties:
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
 
+Optional properties:
+- mdio: node containing PHY children. If this node is not present, then PHYs
+        will be direct children.
+
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
 
-- 
2.25.1

