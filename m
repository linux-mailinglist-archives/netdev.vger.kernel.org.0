Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF66618A47
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiKCVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiKCVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:08:01 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12421E32;
        Thu,  3 Nov 2022 14:07:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx9wcH1UDehecoRuT7E4TNhK0yHu+m/GAhZ6n/AoyAodJoNySDpMgydgkt7himLzaJ/B9sU219sBXu4nu07z7mCh3sMDG3Vdbt6lTXdfrYyCzfhWVkRwkA2iAt5UGn11J1+SQaXMHW9XeMYu3IvEJxAUF8e/js4av3jApKq73QXlOv5XaP878UR4XSg/79lAc9UJXWgXs+PTzaVi28ElhiRuh7/zQwT18A+a8tBGnzffozt0zEQ/UoYF4Uy0VmfMknc4vc6IqjsjSpwsQjjlUys/ezv4e3SHuJ4ddyAPo5kWkAndlpr2JnRgoyoJScSqksgcgnat2XAJOnkIwrU31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nH8rZCLjdLr+07EOpHDJGK02c7tWfdaStMYyq9v/igM=;
 b=MayScKEicD8reiLZe50WbEK8S0Mi70mkK6RT1M77imk8logLG2pFXaUnaJ15m8YmK+mdTiMlhqvEFW42T1HTScMgluWfgXOGpgJkofm4KFeW6K3ARUSTA18+KMtoeZpFTq9SsfnnAJjZiKmasecdg2hpmIbwycr+xeMYNnDa0M7vFLnCBmdsvkVrkeaaFj7srujQNIu7phGbVA0LPYJJ8cd4QuZ6BlmaNPvbu2W08GKAqpjr4Yw0uebRL7dNbBRPInKyNH509NMTF6VMOlxnrTK2MlmOLySDdyjycAsNHk1hDOLdkNw9qRudmPc4TF/wlhN3HiLiIRX781E50wt5Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nH8rZCLjdLr+07EOpHDJGK02c7tWfdaStMYyq9v/igM=;
 b=ALun20ibNSkbwRfv6vlUfawK6ODjNGk3oQrVJW8k3Gb2Oexkl6NJo5x6ZYYcenUjG1wqLuToxyrxrcQCFgl0seCbxS+LDsT8P03dgxieUOHR3Ax/86z/+FwxCHBlu/ceD6lSojPdRTSyFe6ZPoMEvcFsNq1a6AJoMFchbycHXP+jjsN3foBME6TUnrak/GrNg7tWaYcfTc0HXmSQU20q0mj5Rk8tVz2TWiafiWB/SfKd/prb1+n8gFBbznIDEMDSOPraHATlIkZHUc9gk1eH7+fOtLdXYrKGrYCBdvkjWa4YfipanS0+ZDjuoFTKJdN7b10a3DWiLa10t/EsIZn+Kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:16 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v2 08/11] of: property: Add device link support for PCS
Date:   Thu,  3 Nov 2022 17:06:47 -0400
Message-Id: <20221103210650.2325784-9-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 275f29f5-b6cc-4d39-a89f-08dabddf6330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VMgq+cqwhDNvd1CcGCvAkK0flKVUfStLJ7MQZyXop+nlP3kdlujZdkEeXFTyS1/vTbQwjq/T//LaGpk1517j9/HJYKM248wYf7hws85MUZ3s2DV0d123NpJtFwfpJjxYa2tO4cuXogIqdmRs8kCLBW4xmWRsV77R9LdxyIpA0+BtM7OLRSOqsqGnjhxnuRwZVzK7QGsxhvktPL6ZqMU/lP/BlUbwuNkTNtOBeDLuKedMehgjTL0yds6H2n2XYMZOGJ1ugHWJLFq/cLOBpkfGnnWC5y/hpYZRImyLgMOcPNnmeNUl6eAE+igAGzPz0e4nxksztQmU4OKuaUnhbxnCf/omU69hH1yzCdpPHXzIWJ4jnktwTyipv5a9DpbZwVXfIYFqN99QknKxbJTYlXrNZsBxRKEyBY6UpmMeVPybLJ25PVxPABRI34CZpWKmmW1u3sb7PJ+72GMPP4FD67uIU/ArwCEONtsCeriOD1awDMo5s3AEsp3I4+tBMF9/FbfQzHPAGGl+oRgM9t6yPpYniABioYLRSLOYGCJreVpGA+X5/HzhS+32mX+FjPm/DjwfmuoU7aLK11GtAcJy3zb4lBcdBA4e9qXUUqgAJ6Tx/ysWPhof+/mODYjpNPp+DlQycwwQxTCKAw0Vp8Mzv9gx9tqusHdvo0+4Wn3lknpXq06MlqtynFCs/COdSkq5DLZ8AzEG3Mf9msoipnHBq6m6HiDtQSBywGB8cQMv9vhbcXzTFRQwQEdDwe6w9iIRYkX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WTH/7OVEF81kBoegajrFzNYssBtMNlzPipWfdQQX2/gJBg3ce4owS8mRFvQo?=
 =?us-ascii?Q?awsR2UYrAe2UsnTrIIqD6y19Z6CZb7PgFQHxPsCocrpTw4OykjPkMkXy5pMA?=
 =?us-ascii?Q?3cNdsGDTPhR2ryHFCegMPA7XC5CI8hbQlIb7P7WRXVnbynPhgDI8JQNG83eJ?=
 =?us-ascii?Q?U/l1EjCyck0PAhF1BA2A3zOX0t0dPQo4xRm/cjeEK92bXkDIY+NBGueoKXpO?=
 =?us-ascii?Q?VCchGA+A8cO1P5K9MKMT8ECZlNY9xzAG9SuNH7DGnmRqaaS74K8hNtTQReNh?=
 =?us-ascii?Q?Lz44Qr+Fi4GsHjjHRupH7ZTluQlNbM+Jaae+w1lTxooyaQx1W3wMcf4bwevu?=
 =?us-ascii?Q?7XPh+557ijuU5nuN8ekghIxic5hd03DJzvtRjm7dEa7b8hIAWxGpj0+WHKxy?=
 =?us-ascii?Q?/o1fIlZm0NYwoZDdb+eEW+fCd815dBUB2WzuVs3xsWVnXex76P8ryiPU3XC7?=
 =?us-ascii?Q?g+7lUrGxxaEs/95Ag1XmZHhclrQiX12iAGJeZ/Og4Uz0n4Lp2Wo1GCBGQjXW?=
 =?us-ascii?Q?kgoMkxDKfxiKCvs4r91BG0MiI8oXA8cF2+PCX4ojLrhCIopIPxq6GBkm8j1o?=
 =?us-ascii?Q?ewBMPe/d94u8E0L4nWVgHTyM3WP3ejAvqqjM2CZn3/wNVd5bbeRmSkDzokp/?=
 =?us-ascii?Q?bVaEW9aLimpJe4OQ1brkJMzkyVScnRhsoiZjaZLnhnmCE2PxBsYe3ZXYbiIG?=
 =?us-ascii?Q?hmIArFjZUPcyy3xVuvl/LvlAE6RC5dZZx8FsxmgSzmx675AxhuVVen6pv1SA?=
 =?us-ascii?Q?fB6MAho9jUiy9Zn0x53p7RHRFagp3z54+aujghJ3vb+0rb02ja4f6daPJXMv?=
 =?us-ascii?Q?yY6hXBMuK3VYv0sOwLvpHop1L4zum7M93rS7YYjJ/wRw4dh/xr4GeL1k5u+v?=
 =?us-ascii?Q?BT6SA8oWbaqEXJ5Rx7/FP89uBLslvjCF6G4ANrUsXCzIcp3An4KIM5Pek9LQ?=
 =?us-ascii?Q?3+UxXviounHAyVY2tY+GQQtgjE5EaM2uPNqE3MsZhJAngy9k6JrA3wEXrAMD?=
 =?us-ascii?Q?QcoCTvjHcXIV+ekFKfNzqsGyF2GxliCcSgnbUHR2XW/LRDtBiofwgUxm+6ay?=
 =?us-ascii?Q?2sdjQsbZ+EwhbzZfDzDDS3tOolAF0vO3pcy6X+nONqEcHCgQsHoQkm9ce4I4?=
 =?us-ascii?Q?u8yNgDFvrE5FgAAFhl7epnSKbd/bFFs9gnjKgpBm90DI6NMqkQBX9AU3li8z?=
 =?us-ascii?Q?Df5GYLXCwuytBEnvRAUhGz53uS+/TLydoyddTRLNaGC3mVDMQ2k9WfKK8njw?=
 =?us-ascii?Q?qSkPgVnHkk7U3YB2up0gtQCQkyfaVn2d79VZfE9otuovNoYFgPgWvDndXiUz?=
 =?us-ascii?Q?RLx95Iz+fJq84WErEZ5/vZMJLsxa3mU4RNd3qWS1l8TBj7FxaDzvEKO993nq?=
 =?us-ascii?Q?pf4ha+ZCKaaVLaDcoyKXec36ANfFsuwIZHxcYjcDj/INm2pqnBK4l1eW0yW+?=
 =?us-ascii?Q?E8NqYv0G+NECuVLEYE4AAfxuz89/gp4MuN+Q7SY/XJgjJFkVPiH8LTHpP78q?=
 =?us-ascii?Q?5TW0RnhzfefQDbjrBniTE8sbHfw9i7/W8Ec/40k0CS52r68ogafRNLXtF95Z?=
 =?us-ascii?Q?j7DiKuyLplDht69ou8lB7ho91pJhAMVVh//qWuuPoFqHHW9tVoQvlwLXOQ9h?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 275f29f5-b6cc-4d39-a89f-08dabddf6330
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:16.7086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZR0JjIZ1Qi5xJ03h+RaqXza0wmD7ROlUeeWPd+jk9fbXSqyDbOoPHgyiN4NKETO76BFSSgA+q2rmyru5F3uAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device link support for PCS devices. Both the recommended
pcs-handle and the deprecated pcsphy-handle properties are supported.
This should provide better probe ordering.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/of/property.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 967f79b59016..ec360a616d17 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1318,6 +1318,8 @@ DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
 DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
 DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
 DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
+DEFINE_SIMPLE_PROP(pcs_handle, "pcs-handle", NULL)
+DEFINE_SIMPLE_PROP(pcsphy_handle, "pcsphy-handle", NULL)
 DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
 DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
@@ -1406,6 +1408,8 @@ static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_pinctrl7, },
 	{ .parse_prop = parse_pinctrl8, },
 	{ .parse_prop = parse_remote_endpoint, .node_not_dev = true, },
+	{ .parse_prop = parse_pcs_handle, },
+	{ .parse_prop = parse_pcsphy_handle, },
 	{ .parse_prop = parse_pwms, },
 	{ .parse_prop = parse_resets, },
 	{ .parse_prop = parse_leds, },
-- 
2.35.1.1320.gc452695387.dirty

