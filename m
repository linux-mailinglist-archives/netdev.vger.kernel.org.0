Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC88614AE4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiKAMkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiKAMkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:40:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E36DC3
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5htBl1jJEyhNqDRqx2HN4kx6QAbXAZHJhx/WqQEq/AgxZpsg8gPP7ZbrrciHIVjslRJ3G8UW18lgAzcdyw595XO6Fbi9KVc+OxC2LbNVJ52qDtBc/xz00rNarY/G+R4ScfXu9hWnpIhaYeDkMSWakXXOSQDhdo0UxyGNGhw1mgx5s3+fgpTqdNuis6SDdpNd/vl4hy8OBbRkP9nbvEL8xev/3UWFwG4K7aeXhajRm1gMIhTON3/1F+usfkZ81weN59QkK8prus5rxuM05g8modUk2VZ5yD6JWAqP35EqNuUnnMqo7IlQ1ySvJD9GmytnReQ/5g2U7122JPWKiGrKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O3xcC0kfNkGiE/ReBCMKuaTDpRZO9bSzQNR2Blaox5A=;
 b=JsHd9FGUF9IREO14lLmYQee07FAJhC1Lm8X9ssW7gIHgJjuf9RA5XsljWnddTHzUTXZvO77oTevwSh4VIitt54yKtPP9uad542+HBmne/kOGZA0IXEkYjp2Blx7/fWuMWKv/r19Kf8t/nzuOwsuh9AF/GblRjL4QIP7rJuVde5Np04AwAJjYygjnxbr0ZSPHdEIc+rsWizmJSDPoH3FVe3xPZ14YJ6c23W3sAowneeWtQzp7JFJv/0gdB/swc8DsuGOrKCBcuslH2Ng411ixFqzyv638NnLTmxz/6YmwikV8mmOME5GrwHIXsJdDRJJwt+1XKne/VRFPEHG0FHqFkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3xcC0kfNkGiE/ReBCMKuaTDpRZO9bSzQNR2Blaox5A=;
 b=joQAsYGsY560mSRqP6tx9MMcfxS3PfaM7abFqxuXYvsl+K2txVpOS+ON9bhrENLjdlHNiDNVNE76LN5s/ocFlA747NfMRyA9gK5+cETsHNnpTm2LlWhO2+BDTVCCDMyCLNs3yFiN4KySRZqXk1svdRpW8db8OGltdyNpnUamg+jQiKpyA6bSLsmn+ljSHSQAY7N3svGuLVscU0a2Y9YxA1djWWrm4Zp+gEVLPeDXb9iRmYTubx3OrLB4PvsXin51LSyKsAoFyw11vezBVFpVDBbf0HaTzaTZDVdVQtMhtbupKtunciuiHn2dsHkhXySEw2tGwlYfscBDDxntPPuW+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN0PR12MB5834.namprd12.prod.outlook.com (2603:10b6:208:379::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 12:40:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 12:40:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@resnulli.us, vladimir.oltean@nxp.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 1/2] rocker: Avoid unnecessary scheduling of work item
Date:   Tue,  1 Nov 2022 14:39:35 +0200
Message-Id: <20221101123936.1900453-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221101123936.1900453-1-idosch@nvidia.com>
References: <20221101123936.1900453-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0003.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN0PR12MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: d459d83a-d035-41ee-d9a2-08dabc0630ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5tLR5umOWh08NC9b52rY1Zyw+FUMgrI2HpfQDfU4d0+jIW79b07UjMkjuSHK7+Gip8lV8sP7sPEH3ZG/eGWi9UVQaJX+veTpeGY57mZbrqlCWOwDDAKYgaWuyQnRB6Gt6HiGeYiQR8wRjO7E+OPnB15dQ7rrq53AuyAXtan1t/DZ6UpudVr3vwzO4i+leEe3LVoapM0+0H8yUIxHRcoBPLZf2tsVPO49E3fW1wSvtVOSi6+4jpjtPeb3Cttl8eE7jQzYkVncHp9mo/ssBq2bsFwKVZQETZJFoVnM/KdbxJQcMMdfRxX442Na192BHjP/YRjhxXWwb41DIrMtF4ap3FvuBr1myCwZa/njRmmzEbjQKwyM2lgLZndARzXdnfbeQIM8EkxbyAp99Qr8pmNzf/1FxRg/bbQIyC/UJ0U6UYTehNPqz5vJ6EBylAZ6r7JFVFbkiB2thoHTWHRg6GFbmCTDMZEZnFEKGrzoB32p1i1inoGm+j+fZWn5cmV3+iRg++g7TGz8ZGgtG94X5wg7jtSvILPb2Rxit86/OqdX2iY77JzeRrYB4YAfaoc+xNdp7YLZmJtv5X1nEYDdc2dyg8PA7csfwixdmbhSyDusaUoFhicdtNgOTs9irYmBB5Q75v61SMZOxzvAUKTQ8EYNlMPekwjn69VUckGCJnavP0sBEMnT8VWpB+gjlaJngAvdoR1VVVCYG6xWB3k+0Ppsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(2906002)(6916009)(8936002)(41300700001)(478600001)(6486002)(6506007)(5660300002)(6666004)(107886003)(6512007)(186003)(1076003)(83380400001)(316002)(2616005)(36756003)(66946007)(26005)(38100700002)(66556008)(86362001)(66476007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8PsOLrvtjycmd+nwEnZTgfCwrhQLrt5G+SC1RnTYkC7NmyjN5+LLmmEG5sfY?=
 =?us-ascii?Q?ga4KvXQoV5qD7lXqwQ2g5ZDwumNzxOPy/QDpqefn4t+O9/zBWAHihkrlZA6z?=
 =?us-ascii?Q?LMXzcWUTngjPyJ694LNuIb0hG4iq0xBhwCOprcTWiINcAaUDWQhl4/71/VfM?=
 =?us-ascii?Q?+oMWnom/4N053ypAD+cm44m3dKTkt1741MipTqv4pOtK9OeV0uRq/h9aaOzA?=
 =?us-ascii?Q?DoTSSLd6wb3hdsKGby/IlJFgBZ6RCPAC37MQo7CfqGfev3B0HFJNuKkFlzx0?=
 =?us-ascii?Q?m3uLmeOUNmd4mYelr9cuEZgf7AFeOH1m7WjTW3P+OaanS4Bb28203nt0cohF?=
 =?us-ascii?Q?/7oWK0n/W1XjrYYBhzfzy/SBm5aXJTFDYMxxbpem31amIxC5ZwFZ1/OhDyNJ?=
 =?us-ascii?Q?eCwdt/y1MpBQW8FqZXxi42IwsPDEDDVR8VEgPCWx6xcm608lzZpEgZCetfNh?=
 =?us-ascii?Q?Vvl7A/DghUt5TPNyupELDnmXhK99uQ//8Q0iMhKoVWqDnb09JZyMe7W/F1CT?=
 =?us-ascii?Q?RDu/cs2l6EgTeCrYISsfR6dfmHDMWY80Vxm3yvvDIvIxym70foRItZP3izsD?=
 =?us-ascii?Q?SPE4YsHWyGDhXYpozMIesJ8SWY0aiJZdSO981urSUgxf+pT/rYyU27lUu0hH?=
 =?us-ascii?Q?XR3OrB5kJegoIxIjtJyOgoHRATaYAffXiyZWiCVwhntL5DCEh8EyGVB+TjAL?=
 =?us-ascii?Q?Zzw0bFMzzTozaDD1EfdZjMcAXvXx4uW98QD3mVlHFECWi8l9ijA24U9WNHXy?=
 =?us-ascii?Q?6AW83e8d8LBkFA2FwAnwjyZf+x1N0OdilRfkQ3AcrUl0fMAH/lmlEkCnJ7C5?=
 =?us-ascii?Q?w1gqvNpt+7vw3vHodNLRW5Y8J2SOnKiHAD+QaQ4Fhxlc+wxqNegc3Q0ai6Hq?=
 =?us-ascii?Q?XZsoMsOv7lQc/3aXRwe8IFrEyrxTHTcwC00B5/4Jv4g0dKnyNMaQLYFxJt1P?=
 =?us-ascii?Q?JKsx7Dsa9rwB9DiTrpqYM78kup8s7QvKV/cAoQclE/LjTV7oA5Xe+vkequ+h?=
 =?us-ascii?Q?irRpK0FB2Ai3s8wazonGy+/cZJ0eWM+5D81VFLnGvX7Ld5ID2Fvd7s/YyfZ2?=
 =?us-ascii?Q?9tTcEZdD0pSl3IbGD/1M64k009m8GB2ltMJyawuS6iCHncd4KMs0mlVigNHY?=
 =?us-ascii?Q?1kFMVMw04loAOHrH3ATwKQ148lKqGnVIFPAzFj71rVArxrtlmy/TZEWsits8?=
 =?us-ascii?Q?dhON6qNPozU9rMSuhTvGGNz/vaaTuvOEETSMfUSlKDUksQuQpB9+088Yq+Un?=
 =?us-ascii?Q?AvPrk7FAAIdbEmYkEUAbtJ+DOE/0GLg9P6ne4claeh235ySFLNU06tyTMO4h?=
 =?us-ascii?Q?EbdfeGzrAVB9Jzb1ZvG0gK920NzWEwqJP0UurnDn1mP4Sgh0egKlGSyLMvWm?=
 =?us-ascii?Q?cidFt5SjbCjE+DXLd/OCAZ5a4pRD66/L+7CkBpqwft8bWzaTktphpcKKq3+t?=
 =?us-ascii?Q?1SXlZDK1DwThxMqRt4yl6SXJtdsY5CxOgUtghxK/0hoIjgJLkrWUADBUFmi7?=
 =?us-ascii?Q?nROXP65mnZ8lwNozCen/yETPzf+PPc4OtN+Qa6OFQzDnkHH2ZteHKQthkekV?=
 =?us-ascii?Q?wzjWLwRRrKZ8q6U49H+w1TcbAa94lvu0qEfL1z0K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d459d83a-d035-41ee-d9a2-08dabc0630ef
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 12:40:00.4134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vGZc/Vjdw5GyDN1C3eb3MpFezzWIqBE/axNNJaPgflrrEWe9IqOwgxAnrIkW8mDSMft+aCPWL2AUWm/2KO57GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5834
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The work item function ofdpa_port_fdb_learn_work() does not do anything
when 'OFDPA_OP_FLAG_LEARNED' is not set in the work item's flags.

Therefore, do not allocate and do not schedule the work item when the
flag is not set.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * New patch

 drivers/net/ethernet/rocker/rocker_ofdpa.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 58cf7cc54f40..77ad09ad8304 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1821,19 +1821,16 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 	const struct ofdpa_fdb_learn_work *lw =
 		container_of(work, struct ofdpa_fdb_learn_work, work);
 	bool removing = (lw->flags & OFDPA_OP_FLAG_REMOVE);
-	bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
 	struct switchdev_notifier_fdb_info info = {};
+	enum switchdev_notifier_type event;
 
 	info.addr = lw->addr;
 	info.vid = lw->vid;
+	event = removing ? SWITCHDEV_FDB_DEL_TO_BRIDGE :
+			   SWITCHDEV_FDB_ADD_TO_BRIDGE;
 
 	rtnl_lock();
-	if (learned && removing)
-		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
-					 lw->ofdpa_port->dev, &info.info, NULL);
-	else if (learned && !removing)
-		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
-					 lw->ofdpa_port->dev, &info.info, NULL);
+	call_switchdev_notifiers(event, lw->ofdpa_port->dev, &info.info, NULL);
 	rtnl_unlock();
 
 	kfree(work);
@@ -1865,6 +1862,9 @@ static int ofdpa_port_fdb_learn(struct ofdpa_port *ofdpa_port,
 	if (!ofdpa_port_is_bridged(ofdpa_port))
 		return 0;
 
+	if (!(flags & OFDPA_OP_FLAG_LEARNED))
+		return 0;
+
 	lw = kzalloc(sizeof(*lw), GFP_ATOMIC);
 	if (!lw)
 		return -ENOMEM;
-- 
2.37.3

