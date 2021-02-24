Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D0032457F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhBXU4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:56:24 -0500
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:53327
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235479AbhBXU4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 15:56:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNiD/27VmdJMJCIZWfyN82w1sO4DvmenU/XLV/ZTDYs96sugdshe/JVdPVsjOZWWv6doQUBu8VhhPT+U+cf3JkH/EbS4kM6IbX0+vXASfjUIHMcOnLnMwJQqQAa/VkxuSEB8wbmDTK9ew3fk4CJdYw+Wb8sZjlhdYpXEeeQ2phhtH6Pw2o7rBiR2FoCMS2En6HwfG2+Y/lYLPXm+82ol5G6H1UM1br2MQO6MwQ9luZRmlqzy9k2EDAiiGO93O+aa41kLEk1vFRVUYhQgUZHVm/XlBzv0XwA25nFpCl77snEhox9TYFw7JuTA9bE7XnZppinSWj3YXh5Rxixeh/j4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsSXnGrsdDAy53mSqYunuPYxgi6BtuJlISYJRAr67pM=;
 b=UlRyL18jLpw6nbl4VncANKjhCbRmDfhbfHYQRq2xzObQ6RTnvyyzbiJlOymgFsspbwrjvNRXcMWWKg8pJNKh7IYSLIx4uoNDcfaymPGY7kli3r49n/18iVhmEHFrzlZ77M/aKij4o8B0sk217nIQsT0xeSZx2chLQJnSuAkhZcOQX3adoSTCTFxxTb/DRJ4iKyDBfKiNXOZHjiEZX+wqm16U0ocZH3wv80/AbFxNuXNu2sSTvpxmHkNQUo7sbwgH8uHRCB4jloYB9HDL5q29PdmjcuZgpymh1rWUvPrzOETzQTQFq96i9JE/SoAolsubU7PPUsLgFN8K2REriSvMqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=t2data.com; dmarc=pass action=none header.from=t2data.com;
 dkim=pass header.d=t2data.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=t2datacom.onmicrosoft.com; s=selector1-t2datacom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SsSXnGrsdDAy53mSqYunuPYxgi6BtuJlISYJRAr67pM=;
 b=JrUQAyAAoP5Mw/2Swe+lx4uj60pN21V+/uB+ZML8fU+vVxfnU2aYkMOOZYsUohYsvVtfstPrATqKnUZiM6SCZLJ3IWEVdIFupBo0e84bP9v3UeI4cGF9FxCQ1L7nm+nLce7qPB4i8kISP7O16mkRN3mA/EuSaso7A9NUCQy4KYQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=t2data.com;
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com (2603:10a6:3:da::10)
 by HE1PR0601MB2635.eurprd06.prod.outlook.com (2603:10a6:3:4c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Wed, 24 Feb
 2021 20:55:23 +0000
Received: from HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb]) by HE1PR0602MB2858.eurprd06.prod.outlook.com
 ([fe80::a40f:7a6e:fca8:eedb%8]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 20:55:22 +0000
From:   Christian Melki <christian.melki@t2data.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        Christian Melki <christian.melki@t2data.com>
Subject: [PATCH v3 net] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
Date:   Wed, 24 Feb 2021 21:55:36 +0100
Message-Id: <20210224205536.9349-1-christian.melki@t2data.com>
X-Mailer: git-send-email 2.30.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [81.234.39.46]
X-ClientProxiedBy: HE1PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:7:67::32) To HE1PR0602MB2858.eurprd06.prod.outlook.com
 (2603:10a6:3:da::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from voodoomaster.example.org (81.234.39.46) by HE1PR07CA0022.eurprd07.prod.outlook.com (2603:10a6:7:67::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.13 via Frontend Transport; Wed, 24 Feb 2021 20:55:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e9feec5-d408-41a8-ed6d-08d8d90680af
X-MS-TrafficTypeDiagnostic: HE1PR0601MB2635:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0601MB26353421C9DAAA4568CB25B9DA9F9@HE1PR0601MB2635.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0SrRjirpCGRISPREpqYPUU52ytpVWjWclDZiARnv/B7/m+tkmo6TMfMA9JUzejg6xipNT1f4YBMGGWDT/LeaxHifIit2ltnGEfxs7miU2W9ox3LWgSEhWC6jqmp+RkbyM0vV4eY1oo1lpU4M2ywOkW8n2NpqNHiyF9erlVvbwzfnZblGq2uSDhuXISopAyOG9CEEnIrEYrMZX2LR4z1qkCGQOFhkvgDTygMacWN0rKVkIf4ZLG1siv2IIdCdqp98Ih/PNCX8UiEt1zYdScU5uas01Ace+miCDuBntoo89KtlB6hfXJ4BJc7a3rnsyyCm/6F8AlO1n17BRA6ni2zdhztrsm1S/xsQ1j3QLxV3IcrkmeyBC4qUgvwgQnncYIeCiGq9icEbnLw1f9R30ht4pcIxLNj/ErgFicS4yktayUYKw/8T8/fZtmvC5VrrcBICiBVeaoXQ5YrS4m4Lz/mK3kOec3TUnaAl6tbZ4NGE8PHYVpG+YaVp5DaRiEM7eqveLzZuL8WpKEz4zBAWxJ6kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB2858.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(366004)(376002)(346002)(396003)(42606007)(2616005)(66476007)(6506007)(66556008)(478600001)(186003)(316002)(16526019)(8676002)(52116002)(5660300002)(4326008)(6512007)(36756003)(6486002)(1076003)(2906002)(107886003)(6666004)(6916009)(44832011)(956004)(66946007)(86362001)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vWXULqQElu5CyAIkZ8CYT76xkRjwCh2I1no4TzntwuQgERCvXmTG1TDceimz?=
 =?us-ascii?Q?jYKyunQ+pit3DgnNT/NP3jBr9FOyrwbNrv1K4Hy/MwBXIA8j004uUgnpAGFW?=
 =?us-ascii?Q?sWHbLCmBhj63tKFXtTMAC9+fTMRtXBYf/VlQ3+qbsNy3eO/vKiCAz9X+6Su4?=
 =?us-ascii?Q?7Cd4zfgb0ndPDAkKzf9b84kUZQas014sc5KDJkyeOcKF2FHr3zCrArvlPH9s?=
 =?us-ascii?Q?UvTaV+bdH6H+Z6K8lCt0HwmjLXj6YDiKvIENUwrbbHifdI+0adv+4XDEdrsd?=
 =?us-ascii?Q?hkMIfe3H4e9vqrpuYZougo481EAn2RzP1AlwYg0DS8rL2yN2b51KaQU0GSHB?=
 =?us-ascii?Q?jz8U+C+MKaX5RzCMv7jgtHuus9Mj8dqiZDOvNbmNJA5CyRqPeasZ9aDYE4Rh?=
 =?us-ascii?Q?Y1OUjqeyg9PRXYY1Xr4FeUDW3AP1uSYzf8H1rmgReFK0BAysmdeQEzU1lcoV?=
 =?us-ascii?Q?Rfu0sLtcBt9wbz/LbUsmNulOw+hESqRDkG7k0HCLXWDX47S4rQ8QRZp5mF7o?=
 =?us-ascii?Q?xppKT37ES8AM7qwSxl/tOlTEKLWSuLsNVmAFKZRe1dw7fkMdmpubikhTMKpy?=
 =?us-ascii?Q?plOlGvZnfGjzC3su8JPnEeMZDYTvlqV1p2NETdBh91++qguAtzlZz9ZFmIAX?=
 =?us-ascii?Q?BAMwrpHEIzIBxXIAUjQr1pR4RJV1W+XcQTilYPEXkwoQty0A0mogdOEwVtJG?=
 =?us-ascii?Q?q98aQ1Noe1mMiklHINfNEePUA5iSVznt2hHnI/g0pZzsy2/SiBModtjl1CBO?=
 =?us-ascii?Q?NHr1KwgkbxdhNIcu3OdUWmL6ZinLkL5yDmOpt73UcgTeEloKyMTUKGUgXDGr?=
 =?us-ascii?Q?V1Bo1jw62/4zTv9Qop6d9cf1SAjREXSPJbAQG9k5KuXKz35EqPbWmLEisEnJ?=
 =?us-ascii?Q?+jm3ozlzUDM8izGoSM7P41pold+yjy7Rb21umxwSsDAR70QFjzAKIhx9bJBc?=
 =?us-ascii?Q?M0xr6YyW5kk+cWGKQ0/yTOpTGB4zZXl/uCleV5qacsaHMG5CnLxp3rx4odCy?=
 =?us-ascii?Q?ffZueWhoflkwUmLYR2FSL7+biNuA6u/ajxSwN1u/etwJHoGz8ICS/6RfdSZ+?=
 =?us-ascii?Q?EYostIvy6v11+E1S4lIJ7J7SakPwGE3lv2pSpaDEAsH6LXv2OhLpgx1OUURv?=
 =?us-ascii?Q?jdvLSOwPJv5iheJiXJxzDD+AjF+b8GmA6UZdUfTX85eG5kbt5843Po01CvW5?=
 =?us-ascii?Q?yU/+6vtZ+hq0oR9MNQWmi3eymtmkaWIfUBHMWar+S8C1K+vyDF24/TClUp5b?=
 =?us-ascii?Q?BM7Ex9WNXYpEkbECSPntDJNNqn4qqJw+PMjLPm3QMWL1/LQdskInTdxt9Ifh?=
 =?us-ascii?Q?nlp7WVYlLA/tx6HGFi4lehPM?=
X-OriginatorOrg: t2data.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e9feec5-d408-41a8-ed6d-08d8d90680af
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB2858.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 20:55:22.7408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 27928da5-aacd-4ba1-9566-c748a6863e6c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GO5CjaEgQI5nV/dyNPF4MDmdPSNLTqAEW9IiTpaxoTMkL2J2P/E1XoIL0gD5GdAD4BaIIyNzMyAPcJA/rVPBgqm9v2Y2LoQ9nvu9A1YY81M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

Bluntly removing that default may expose a lot of situations where various
PHYs/board implementations won't recover on various changes.
Like with this implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if it
did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 7ec6f70d6a82..a14a00328fa3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1303,6 +1303,7 @@ static struct phy_driver ksphy_driver[] = {
 	.driver_data	= &ksz8081_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.get_sset_count = kszphy_get_sset_count,
-- 
2.30.1

