Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954A663F90E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 21:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLAUXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 15:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 15:23:18 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84AF40456;
        Thu,  1 Dec 2022 12:23:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npdioiMf2w9PP4/+NASbl46JLrdxOBOnjYvQv8Zs2FcVpeMW+rbfCCwOYlYYueuwORMgkyhcpTJoERheqDU24iVCbD3iD4pXgecRHoHfuR6mmYy+vwdsYDXWFvqufLnauQVQVuS88/YIVnTWEtD/1FjFZPpqjmbVRbxWqqi5Gyd72dUGJxyq4FZPvvC/f1CPQR9RhxrRiGuWXNvxOK9VhzAzBJXqNtoj6c3qeDvMaAXIVABF2ry98HV35gj1iSkEN3Nt78o5eCGNQE+Oa6uP/FczDcvZiS7A659WG+kFo35+Wtsm7YrCMuXWEdUdVrQ2CuXu0VLYlMvP7ro/o42FWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9bWpcjUxzVzKTP4IqHl+eMVzUIb7GYluumI7n7bcOo=;
 b=FTOHzz7e6Lh84MZKEZ7Ye/d2UcU/8a2Yi46aFS94dumUpP3Ja8+k99AqOhgO+oZj+5XKii2tWNQKJS/3nBBkovZbNNIWh69fNLXMjHWDuALked56WwsJdaH7Y0gGlLs2y/RE6YzygkQOS9oAaGVg76HIdKr2V857l8sjUtX9o6ESZjetKAu8kBFc9RNE7YYu/ZSAAFSgddwqev8afcE/puQzzmwyLfr7tyZJRCKfNjJNMUXoaFAu/GIVVTskY3x9TyU0OcE0exou/qYzENnnGWaSwJR8EL3kBdKBdaWoQ9nM1Mtu9wGID2XbRHK4KVp6fj//Ik51F6WXH9vPpRbGHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9bWpcjUxzVzKTP4IqHl+eMVzUIb7GYluumI7n7bcOo=;
 b=iB7RwhA8DAW696hKgK6kCQ57NbGu6oaLYHKg7IOBUmqzvfeCWtr4Qa3KKNDE14Ko5wmXRxjRNazte45Iec9k5BNjthf0jPBhyJIy0keDyRbwjfyPg1EWHpaVnwdyXmt/rxolu9FFu/g0QsR99cx9tt7unOE1ZCYcfICaQvxDvTR2jMwCPPCPg2np0PbUH6gPcRDnP+pDix0s7NbL60ABl0ZIxrSeI0LaIuRglZQOMoSkwZ1YZbZWBoRMXZUajKMoiZX+pBW/hTUYbdRklimNUx1gsMW3vMwkdSVtTs8/uHlZzKGJrw5kmsEuqMbzXja7SXYU15NrMevvvr36GrJB+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS1PR03MB8215.eurprd03.prod.outlook.com (2603:10a6:20b:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Thu, 1 Dec
 2022 20:23:13 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 20:23:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next] net: phy: swphy: Only warn once for unknown speed
Date:   Thu,  1 Dec 2022 15:22:53 -0500
Message-Id: <20221201202254.561103-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::19) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS1PR03MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5c4434-1d74-41f2-8231-08dad3d9de35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aa+/FjknU5+fZvYU6MYEOPltObuPZtgoTK/CiO/zh1wN+WJirTSaTjhPO1SpMXkUAjQrexEpegMEZo4RzkpapU/IEwc5tDuXnbsChiGtqpbtStXrA1jgsQDHRI/NAdDJEPXPIXa/a4TDenPMH9LavBkvB6Cp0IpxESIlBJC+z9TqYuJBSQl9GKNkwrfuwVqXN05Qfci3EJHusTO6jRp6jg6XHRre8prJBJTnLcwNZiNxPXoMc03dqYitznRbZJVY7SGrw2UbBqFMI1mHUXMUIOyXR08J+vTj8laj0lQ2bQT+zE58itNPUhNmYzbp4TlJJixjdRSPZOcOdrCmMdBc0dRQGUQkpgcUScDqNTeIZzzmmgTEL0TSV1Ci03WeSeMG25cUob2jzJgeqeujtuaanKsbq4A02Q0YQsHCBdw8QozW4ePgo7GvDMv0VZGKVuYOp0hbi2RiIWrFLAQiJTHXe9igMxhLuOCy+Um7d6zdNxx68YOiG9z1K+kWTvNnagRTI7BjNANLjR1QrIa4zJUrpHiu9bdTayOa7y/QzLUfaOCmm/LFxjJalxHDm4zWhMC/qz56xD4VvNY+gGbBA5WxGEOwubpxN/v4FS8FmfKtU/4QQcKxrRdeGK+3udhcZVxK3/pXQw3mCAkKtmSTXT/gBEuhXIxp5NBEt0kRhZuMxC153+putSJzyqW65BBLkoS7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39850400004)(136003)(346002)(366004)(396003)(451199015)(36756003)(316002)(83380400001)(54906003)(110136005)(5660300002)(4744005)(44832011)(8936002)(2906002)(66556008)(41300700001)(66476007)(4326008)(66946007)(8676002)(38350700002)(107886003)(38100700002)(6666004)(478600001)(6486002)(86362001)(1076003)(2616005)(186003)(6512007)(52116002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AmehDJfGeZPakyMWut9FpDNXXAS8XH4vky0zA/YlRLWxgsEH5LNpxLJzfkjU?=
 =?us-ascii?Q?hjfH1TQ0nTWIWFlz0KKLwZcsxYBBTveISFflIRiehE5TaTAZP9MqoiVYdpMF?=
 =?us-ascii?Q?/O+xaDTC4RhFZPZGSQ2kbBFR6qlEWsVAiasXlsLKpwREDNiD3HeQCtc7YFAt?=
 =?us-ascii?Q?xvu9qYw7MtK04Pe+xSE5+rvYBHcqYCn/mxF9qo5BwLpnY9bIyHG+qf8xynGL?=
 =?us-ascii?Q?BxLAuWMFMJnG6h0g+sZOBdOwCniWxNeoNy46dPTX2kmpgGW1oexl+QwF/TZy?=
 =?us-ascii?Q?YKc5XcNpHu4QOSKVRd6dUT+SPlpLbnsTy+KC0iKev99kYbjBcwqWkySP/9vN?=
 =?us-ascii?Q?f73FGmMCiyZOh0CBKq1Z7U8MPPPEO1Frw2aWUEftyMTrXaZCWUqoSiM8xmQt?=
 =?us-ascii?Q?iE4IQL44XVAAm0PmZKa3z/MRRyQNsrPktXPVxUt3baEyB+efBLR2DwXNptsS?=
 =?us-ascii?Q?ngkt8ERXBxX/wYR+Aa1QAf104eKAoM0CgEP0HIX3los7ZD2FREUGPjPeaBan?=
 =?us-ascii?Q?tQNKumY+mvCC6ZUYZ8U5qygYLOrXxepenfl2AUOb3hKMXTyp8OfYTc523l4J?=
 =?us-ascii?Q?SRJ+3V/r7+pglxHJlNj6zNrTWCg4E9N76Zrw5R2B8RlAnRNtdjXQK3PuEbIb?=
 =?us-ascii?Q?d0ZzdgurBry1gxsdjoYaPNckaVFH4VMpHYh0C/Mb5Q5Os/y8jpnaXbttqH80?=
 =?us-ascii?Q?/p96yNJDBxXxguuPpJL3zzRa2YMU0WaJnmOBbwrYhD3lt8Y+TnPKnHXsd3Dm?=
 =?us-ascii?Q?tEywF8mhUHyN+ACrH1L71IEtGAFd2jntsFUruRu/KKhAFAn99Mr5hKV3e8ik?=
 =?us-ascii?Q?9X+AAJ2mO69AIXfz8lGirSv/0lu/8BBENPfqCB+j/mqpfZbDuk05I5Ljw7ne?=
 =?us-ascii?Q?g68xj0stTVh3um+/z360mzLSIpnVn2cR+239EDyikw/uNd21FvAWi1g2OSMi?=
 =?us-ascii?Q?1hCW2lGxYKZU2KtLNOhnb9vFNq//axst8nwzw9NLKAk5AfNkTsgv8s8giWac?=
 =?us-ascii?Q?O5hb0gt/kVeC6lob+RAfxVay6KpFAccK95zm6+oHo+8pU5QjA2/BE9QGtxRN?=
 =?us-ascii?Q?Y6G1GEKRT6BurO/zD7811hosq0i68J6XSoollyqmOwlYrPUX47C4OdHQ+zwn?=
 =?us-ascii?Q?Umk8/BnXb12FYwTTvy7DAhZqaaKc7pV3NdYRCsr7zYCvj7GqyPLuAb5OH0vY?=
 =?us-ascii?Q?nUz7UrsqybS+oCN0PN/Ob5x2E7lZwJK52Q1N6P2Slt8om7/TrtOiVrZ/OIBW?=
 =?us-ascii?Q?F0ebfW/bw9+rsawAFzJHuDjbTEwvv3quRkSd3GWYDmK6CUHlFvYv4ETHBAez?=
 =?us-ascii?Q?j3/cSmgdNfSZeq8nqDjpZje5Uvd6gHKq51hTeFRLkIu7juY7FJssSVx5JwVL?=
 =?us-ascii?Q?lcxZw50yKI00yOx1sjh1PtQEX4w9nNerDulBR68t+tWvJjxM931Yt7tkYAgN?=
 =?us-ascii?Q?kERO2DG//4nJOSSHp3JyGL48Wj6cIN7qN0wvzV1PuvZGQcY2liqBdZt2dTGq?=
 =?us-ascii?Q?mr03UPDo3svaEq0Ky5lvWu5+XlhLlfXej7USGknVF7ZwMQ1GyWIBW3FTdK+6?=
 =?us-ascii?Q?A1fjmIn0bjhzmgveN/gY0eYJCCyWpUlUgbWAr7ajbDDD537pjEobAa3/jMWj?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5c4434-1d74-41f2-8231-08dad3d9de35
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 20:23:13.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytGh1Os77VuK5iZKpvUB6eT37mtZPbIpLnwwH4LNrxc3tmcrC8ZZoS62Mvs8KTKNW82jVowI6fyWQdN5R43/uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR03MB8215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

swphy_read_reg is called quite frequently during normal operation. If an
invalid speed is used for state, then it can turn dmesg into a firehose.
Although the first warn will likely contain a backtrace for the
offending driver, later warnings will usually just contain a backtrace
from the phy state machine. Just warn once.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/swphy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index 59f1ba4d49bc..9af155a25f23 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -124,7 +124,7 @@ int swphy_read_reg(int reg, const struct fixed_phy_status *state)
 		return -1;
 
 	speed_index = swphy_decode_speed(state->speed);
-	if (WARN_ON(speed_index < 0))
+	if (WARN_ON_ONCE(speed_index < 0))
 		return 0;
 
 	duplex_index = state->duplex ? SWMII_DUPLEX_FULL : SWMII_DUPLEX_HALF;
-- 
2.35.1.1320.gc452695387.dirty

