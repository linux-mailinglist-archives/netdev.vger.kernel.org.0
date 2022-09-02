Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D8B5ABA68
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIBV5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIBV5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:57:24 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5225F54B8;
        Fri,  2 Sep 2022 14:57:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKl+5u9plnZ14KeNk9V9FJhuaExFeuF4YVaqDU6CHQAZbYkHsa4DjX3965E/FaV5kOEhgc5R144SRkqKPLW5TPqlXrSFE0lvaud0Gq9pStlqSPZNgTR6eK9OYlillMmw7hRrdwYexGW0pEzEcGAzwRclqc42Xa8BaVCQjNgXDwckI2EMPtYBgxNZxjoiCexxC/1M0hD/X6D9r19pEgQIaLIDP4SuKsqVLYfD9O+2x4GPQH/b2BWpjdNolMsNEbK3odhRlluc321OPJji7VmfyLwEqUGbwtULRzGLtqltP6YnR70nQU3EAXU6pOhmdGAnudI225DLGwOXL5uLx752dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nHBMUwQTCMHMGEnjTu6m4JdPEHbzPTr1Bv36Gxb0aY=;
 b=WZAwI0MDeuUHwXg7o03HnSd7MCrcBV+nRwUXS+0tiC4R3cIFT8BQ/Ruawg42zWzQFwX+iY4vBb690EEknpiKx45X5ee4JA+9hpEoYQwzRgA8oiH4J1jBAZEdGMZoe4404MSgbK9WfCLGDi7dCMPFsDscpLK0p5XP+vgjVxiHyAlATas1jPRjwOBx3eKF5KWEBBAJ8+nI0hdBS7HvsCAVAG2tpp2gXMvXvVK/Hq6blSI0xqqSgg7QKfeMDrU13pL6UNAft2ByKoPQq+YnhwlK6/u/HAz0805suSS70gwsnIKC0CyJC56w7E3bc/4ZAa0gI37lIdiwyE7rMIdJ5GyobA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nHBMUwQTCMHMGEnjTu6m4JdPEHbzPTr1Bv36Gxb0aY=;
 b=ToNuodaAV9FMYG3i5ZgwXWA8/gmMuBCd4F2NjrTQtMbdq61dfvU1Z45KbSh1I+5nA+mmVt8tRcW3VbkrI7JFGa/oy5BYwb9jatFAJF/33yQ6qdDfS93JurWc9t03kiCqE8K3IxZyLnXc15GVAKqFTcLB4/o38vbvrQlXHTyqpkQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4576.eurprd04.prod.outlook.com (2603:10a6:803:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 21:57:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 21:57:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in vsc9959_sched_speed_set
Date:   Sat,  3 Sep 2022 00:57:02 +0300
Message-Id: <20220902215702.3895073-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47649cf8-931c-4ee1-7dbf-08da8d2e1a64
X-MS-TrafficTypeDiagnostic: VI1PR04MB4576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g++G5XIVAMvivwSxH1jY+8oxmw8Bw+j/S9IZ4zsl0V9GEhtPSn0Teu3XEvLwBxWp33fBNDtqUSCV+dIp34oA4nZZRe6hV634jHykuLA1AFd7w5hADh7gEHCL2VL4Ed8DSHOCpKiPir8IO7ahcRK8PUz+5XCnHJORxzVkdfpXr3vcsH79eDjVsd4mAzAepixTq2SlHSO0dYujhdzpaGFO0n7DfiUKVNwEWY3EG/UpJAP8vLhuNgYCcpSV6/2oYfURG8leLlRSdle4Is+p0GUtYWY8WsNKM4UwyxWIjNFeXnRyPbTN0K1cvjPf0oXP8UYA2xvMUIdr+C9FqJlC4sxOGbXo3H0NQo6N27p5+FBV0SQRWkyiDnChcmoYnu+/D60HSTlO7J6jjMh+6GsE1I73EU2fjfc6daMfbGXqi/YFhOofn9BxOmcaRcZG8rdq4kuv4pwhUEzrfgtB82jF3eE9tw8pNF4WD5zv0M0qIaPxKXkgkSaD2MnL+KWb8m7EGETHZbDBUlqejlmzYJExdtSHRw51JYol+ieNZqn4qfioAkJCM2ErzM7IyN9TCPDK0Wb4dJZH/FvZ+F7RdpsU50BZMlYm/tc51KXRsxRhcplKhdDi4JWk+7kFTI3+fmPWuyoCf/bBqUcMO1z8PbSY9uUQzy5i/n6eiA9+0ZXGQKsEPsMxswyr5ihiSD7fY9x/jKJppIyxYnuqf7loXzuSJN9F79LwWhgTl6d0POKVC6TQeKi6jHBFs249MiPWMzkEVhxc++HtO9hW/c3QPVMoAR86Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(6916009)(36756003)(316002)(54906003)(38350700002)(186003)(38100700002)(1076003)(2616005)(86362001)(52116002)(2906002)(83380400001)(41300700001)(66556008)(66946007)(478600001)(4326008)(66476007)(6666004)(8676002)(6486002)(8936002)(7416002)(44832011)(6512007)(6506007)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MprNVvYEcOc2aVwMaGNAUCaB2k8e7fYh4hTXjP5FvdRK2TSKrvemAXlb0ZIE?=
 =?us-ascii?Q?eGp1Uaor2fqW9aC/YQfOjqNIiN9NN+LSl3sSO2Qm058yKm8WnxDsZczmA4d5?=
 =?us-ascii?Q?UgKe+2wlxiyLIx5HPZ/cff7mYezk6vt7sYppoagZL6gN3yTAneqdDvduzcYZ?=
 =?us-ascii?Q?a/v4sGKKIDVCx5F4mu7HT2y4h4QrDsRrVkfb9m8xTUlEA79CFykPsUJcHUQr?=
 =?us-ascii?Q?yNgI+7I3EkWwCpGNcFiM3S+kX613vW5KOFTGYtwdlYgB4ioHoCiU6SRKLor2?=
 =?us-ascii?Q?SxL2cppzQdnSvdK8mV3aAp2Cu53AeN4K6K8m6Bcn41WNgpfVk5Hy4CJTrxTg?=
 =?us-ascii?Q?5l0rdlTGDjXfLI61hdt9Ng8WFE6dd8jpcCwzqaEs/HXI85xVW4vJU66TrLN+?=
 =?us-ascii?Q?G7Vntb5PpxMcB/rPSgocSRrHVyMgvVigH+T322UtsLeoz6Aa6nkpsef0o0LR?=
 =?us-ascii?Q?J7RguzeHtyRToryZJEXQGngGorYIIYCU+hlI86pLWclJLz3DaLedzDH55CY+?=
 =?us-ascii?Q?sWoQjbW24LuK3Tcqvp1R5HsHFhX/vUxGmFgwNIBJcnG9WDBcUvwH8aK8qXqP?=
 =?us-ascii?Q?l4WLmUHKy1NluiTIP/flzkln1hdDtMC/9Mdf32XGQKdqNk/jjOG4IhVlQTTw?=
 =?us-ascii?Q?aPwJ9AePStG4ii0nHCvww6kM0TzLFwQRVMPMwxZzIb/up9osJQr0HyyG0yog?=
 =?us-ascii?Q?5+Seeq0yMP0+qOqGcFoQYGGMsFM212F5o9GHOvNFyeb6JE9zeyeZjrusEE+h?=
 =?us-ascii?Q?SZKqRVGkjceUMbaj46e7UwmrEMRmMa0tYpP02K0btcKd05qMmjGem+erUiQI?=
 =?us-ascii?Q?PTQAfuGzXFhZqYM9ag8xpozRKoDifQ/+/QgZoewkqaBeQ8igtY+DblJcIV87?=
 =?us-ascii?Q?ISZes9g7p7PrDKvKnPx8p4A9ThpieH1cxWDpbP2NYEPjkRpWZD6PNab7oiVQ?=
 =?us-ascii?Q?MSGj5TZ7jjepRzuxDGe2LVqAd/X6EQw9n15IOjXwnsh02e8OVXUjjSMjrejL?=
 =?us-ascii?Q?MYk6uO+ACrD2EbYBvLwVeblHz1Z9bC8XEgvMfY25C2mjKSWWnZKU2nExCLE3?=
 =?us-ascii?Q?rup5s2dczZ+m/hDAcRbHopSyfIUhL68lxOOhnDmYcWVTTFG6ZuW+t6XmXwQt?=
 =?us-ascii?Q?fT2t0R2INguk/4Zfs6ljp1P/1LSFCnkdEsosDkdxXGg4t0cBIUMitkyKXkBE?=
 =?us-ascii?Q?FVidc2WnG3hL+15CnQcjw5cai3jRXeTdmOdQctQIqTFAOELtrxYNOtHWLbuo?=
 =?us-ascii?Q?Apy8gtMbC2fNDpf4fS1fye2GLvNrI5h7JgNQD4VbyHBt7RPs/pXP4Y3H3vXc?=
 =?us-ascii?Q?Ic8yN8edidjRuJS1XV/yQ58Pc+SYG0LEMyYYj/0sI0z6xKt1JUBvMlIZUAYf?=
 =?us-ascii?Q?uOUd67xY/rtxuauJYlPlNyd2GRBcT/Shup3MsEAcVtxYtuHenz6d0y2OK0K4?=
 =?us-ascii?Q?9+kCiM3eeiLvH+paAweR/i3nipLz501KThkH5M4qGUUa/sivUv4mNHywai+K?=
 =?us-ascii?Q?CqXRlLtpoyT/TZDV6emr6TpIjBg9nH/PxvQUY1RExoPCFzgzBjEQaNq3nxTE?=
 =?us-ascii?Q?qJHKERQVq5P8pvfxFZKm6BlCTBC/iHr4A0Bk+CPMtJakKLsczipKArRpQmiP?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47649cf8-931c-4ee1-7dbf-08da8d2e1a64
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:17.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tC6JSnDkdRBHoajg1bXAp5mV63caNOikGxBz00TiGQLCD1SnhWoVrhB42KhF87Y+g9X/PjygHc/B052UvQctuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read-modify-write of QSYS_TAG_CONFIG from vsc9959_sched_speed_set()
runs unlocked with respect to the other functions that access it, which
are vsc9959_tas_guard_bands_update(), vsc9959_qos_port_tas_set() and
vsc9959_tas_clock_adjust(). All the others are under ocelot->tas_lock,
so move the vsc9959_sched_speed_set() access under that lock as well, to
resolve the concurrency.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 35ce08b485f3..db0aec807965 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1741,13 +1741,13 @@ static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 		break;
 	}
 
+	mutex_lock(&ocelot->tas_lock);
+
 	ocelot_rmw_rix(ocelot,
 		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
 
-	mutex_lock(&ocelot->tas_lock);
-
 	if (ocelot_port->taprio)
 		vsc9959_tas_guard_bands_update(ocelot, port);
 
-- 
2.34.1

