Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A359A50A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349930AbiHSSDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349917AbiHSSCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:16 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2F06112C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXgufXWkcS/V9ROhM6azU/u/cEOtKP6PHSgtXvi2Usd5g1nQ+1Vertuw1QWOGn5ihz+jrYpc0PWMnfZF81T3WgTYoixAJJRUuA4P8EeyFtO9Byy9lBh86gZOLc2TiI36bUtFN+xN2HPyH5qQ3DaRAq+5TBesgmsnEH3FpbAtG38tGY1xn5NjKA4d94xIW/yG+exmdvNgp6Jrfe9DaY9Nft2cOpYbfYAhCWh+qRaf04hTff776WF9Zk3fsU6gVbbM/MsdSEg2SAcPoWmvp0wkahXkvz4hNwCWDsv2V9WxTlBqe1HpuRhrNy+n3NsjWUWZbDnVlu9k5kIU4KU00PUMaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mF07jgnWJtKVHThmWo1HxIg+r5h+Jy3bAD+dyfIOQD4=;
 b=Crd8uvn2bz3tpE84loOOHUE2b1Sp1Pvl81pSCDgpANCKtlDVQcYi3KOIZQoGBeZ5Hw4UpQHMVWmiBmJCnCQ3E+Z53rNW+JkL2FVfJQ2/g8+q93MbUJRr9JbvMvcjjMvwkg4jdBRlkUrcLaTF310DdVNujdiyC+u/bvM2fiWtVInrJdzLV0AVi31U2O7QL2q+rl58gufdDHb0JRhsV2Sy2t67/N352OLsBaZ11O2+8OFKrlrhy3vibYA3hBMaVc8EaCqJ8Xr+4fezYa7a4NxKahTStkaxiyi9QvDB0JVa3r4udwk+u08uJ1LEiVLmRKXnY/ldEXlcDRhTQCdpXCthQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mF07jgnWJtKVHThmWo1HxIg+r5h+Jy3bAD+dyfIOQD4=;
 b=LltqTFLpCQj2Hg6lUsY5G0e0qlPR22zYRa+P1HQ/roRb6eswUse4u+hhifUNxZouuutEp7GPd946sCpOq+ZdyHlGs78V7QN16KDI7ml11z6HzbdD/kghVIiTQBnNnVDn8hUBWRdWD6CFjBdSyUBerRkBkWKWpi0Y+Fsbjo0H6Zs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 5/9] net: dsa: only bring down user ports assigned to a given DSA master
Date:   Fri, 19 Aug 2022 20:48:16 +0300
Message-Id: <20220819174820.3585002-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cedce49-e779-45a6-8f08-08da820b0b4c
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9s4QIJXV0ibAxsQhI+HlxBdQi8m7Cc5UsZweus5tnBUji67q4Iq5F4E8wu3pbjWC50DjsVcEIptRBAun/V/wHwPqsIwc/aL+SxhV8OZfuiqu/hX1DJ5qD6jlZ7ogjOo1/WcpCchOgk42J3JcASEFPqTkz+Wyc+yiv+nt09r2kVqX1hXzYh2fWWi1Zar1EeotV+FR5dmqTOf1EtBRCjKiz+05scT7imJPZX52f4JzKz1IZRThbJxsMsO1tYal7Wznn6ef2qvHsDiEAzIz82uIA9+tOMshcfe1kCM0HXvYbG9NsIRNrqXP9koOaqctbdUnAdoxkgJqfPIMGevwr/2v6rVZKmNJEv2FCPsyI8vhSgnWQ+csZIWnK4sNdmbj3y+pbcT2zZzmQdW+PM0I6qMi+CxmwMGpdyu93eU/LZH3y7sGVticOLYqP1ZV4D+GGFC3pNIflZ+era+/bRofEy3VPlsdTAn/4cwh8td9NpM6kthCSMbGmBd80z7quDW7d/vqF2hh0iGCrnubsCFg2evkK+QGMuuPgwwWm5ot7N3TQtFCYhBK1mta0mwuOxWNckH7RzuVXfpGBc8wN0KwYutp75p2JfnHQ7LTEcG+iWH0JQuun2rlAaqXI8UFnDHX0QgZTngNl4abrhklue5ESkC/crqOtGLsolS7f/hZM6m4AHCkHFh6if4sMo8JpoFG8D0YfN/JO4AB2NTMpN5wE9PFfi+0sNx3b1I1FIVsIRGWuzbD6inYI8h1hHlIyO3jyNlG1vq9cVv4vury2Ih/h2Siqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(4744005)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LeMgw8d7i83EGbM0dBXPLPue+kaPz4VC1NPO6UcTV9FO/0ahv9QDFSAQhsEa?=
 =?us-ascii?Q?6ykObF/T+lsykI+ZkGmBFFx4XFw9KlXBNBQrilxD7oN9btkeFNmRHddENcfi?=
 =?us-ascii?Q?pujm9OwQHzGUE/9aAzRqXg1fHTubDENpSvrNsO0SOmgGQwasPxfZeyrw0djr?=
 =?us-ascii?Q?AiULTuA96ytl09PIIQCdSQTQQIZs2lqohXX8pYc98UXjQwyBjAVIpy+fIORU?=
 =?us-ascii?Q?77zDyMzznW/5Tad8UftOGt7i01OGMeyLbU4s21YOgvIgOjJ3COGYOVNVG+zt?=
 =?us-ascii?Q?K7+DcnScjXbK6/PtdcNRXmYyTBHdLDKm92lVnecfZiAkoY3ON9x4287iXjxg?=
 =?us-ascii?Q?JyrYgyEKOIjn4E17lQHvVE0C6CoWD1NRys3UOBk2QAqJEXs+yT/vE2ozilOF?=
 =?us-ascii?Q?6OqSa+DMP3uBtTN/0KjCtJ22t2SSM58hVKwLFsp/BTE1jHyP9rzC0IotZ+4l?=
 =?us-ascii?Q?qAFvEPGtR2xSM5OprXZvMRrft56bu3DTSp+bDyxXq2j90ITnQuVNO5+Kmmx7?=
 =?us-ascii?Q?pWPzJlMeUdJ7t1CYnupoQYrITbp2Zxm1W1rvoTaqKalFAW4hTE75UwKcDwkb?=
 =?us-ascii?Q?AdTS3AA+tbf8A3lovj0RtKEXmRTeqUrpBiPii//2NjbGMC3tVF/WYU3KQ7JX?=
 =?us-ascii?Q?ONoiTA0etuv71ATlH8Q5oB31aFMIu1N5MfOker+047aeoK40lNCE2cTYNPMh?=
 =?us-ascii?Q?QjsLbv0nvxZ0ot8yHUi/xIHynSfxEHipwc3Of1bdSBuYpTam1eOIBPtOlfwg?=
 =?us-ascii?Q?pJM5xd/JMO47KMfPA1bwrjtwpOBKpP3QNd5pyDVejcp4TBrc5hBS1yA9VavL?=
 =?us-ascii?Q?uf08YAHggaXToZ7JjiXQvOQCaq7+zVW9O8PQVco+gqmiYlktLIElKzOpzc/2?=
 =?us-ascii?Q?4/G7ctp8MCiRUb0JGdzV34cKoE+A5gkP3fm1nwdEwFYhdA9Sw3GzNWvArHSG?=
 =?us-ascii?Q?uPplFHWa2Ych7VvLxKLTeHmwcm5yxvONRj4ZTwLCliukFFkVtJk96Jdt6ID5?=
 =?us-ascii?Q?SCmvJF+7plWoIIVMxS/tIM/S+b1kl2uoLQCjsO0+xGzDe1u2aZH+mIIZf5bp?=
 =?us-ascii?Q?wFX5ptYj7xdfmJLLeKvhL9hcO2RZJ8maJ69KqSbNIOfwtfgU9k6agYD48DNd?=
 =?us-ascii?Q?fNrVR3wW4wEg4s+0x89IApK/xBUjRnRIiTN0ocfUnKbPcvyZIJnf9hRu+E8n?=
 =?us-ascii?Q?lQd24lFVfXdF4W36OSobd7Xr0e91zbcnmovcSND7U+YV29zkAd4AheXaAFY6?=
 =?us-ascii?Q?iK1VBm1J1caifeaRrLEI2MJH415EVYTXT2cHctLNfSndvHCK8H5Re/ct5zvZ?=
 =?us-ascii?Q?MOrGjej2FpV52JYBUUer7+CyqxGrrX9rmDrbL0/ZAzWCRGEPRxxlcD70msP2?=
 =?us-ascii?Q?o6ZsPRkr9owhiWHlgA2WT1lvCl2RYb33/oShH0tZfzErMlh4USo5wwAva80A?=
 =?us-ascii?Q?1KdxgKW9BsGLs3EXaEgSbYydY1609xVCcEyfN/c3tyhbjBNod8TnuCk0HoY1?=
 =?us-ascii?Q?FxVOaLJuwgw/SAPwykAPb4fcO6WWp2pFdFB/bltbKWz7RLxK5vxGyo4y8OTw?=
 =?us-ascii?Q?I/cEqNN5FYIpepNaghEkkXbtxmJI/wwWMSuOx4yMSJOU6ckufkZteuJmLnnO?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cedce49-e779-45a6-8f08-08da820b0b4c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:37.3882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ODKtNbINseBs5zAnJ6qAbmJfTWAjH237fCA0cBPJTyrTzVWIMO3UhLxTauH3Jz2CIPWEYR3m4xUG9e0RMQMQuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an adaptation of commit c0a8a9c27493 ("net: dsa: automatically
bring user ports down when master goes down") for multiple DSA masters.
When a DSA master goes down, only the user ports under its control
should go down too, the others can still send/receive traffic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5b2e8f90ee2c..c548b969b083 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2873,6 +2873,9 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 			if (!dsa_port_is_user(dp))
 				continue;
 
+			if (dp->cpu_dp != cpu_dp)
+				continue;
+
 			list_add(&dp->slave->close_list, &close_list);
 		}
 
-- 
2.34.1

