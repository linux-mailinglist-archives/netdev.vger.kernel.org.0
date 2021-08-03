Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952123DF66A
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhHCUej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:34:39 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:60396
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229733AbhHCUei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 16:34:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV8gkr0Qb9gbRGq7zoervBAC1lcv0KHqUVgDgdc46325fPq4+UFjmKjBY5XhIoJ8toDCL+0hfvXrmiVHDvADgascksx8ndDYgUSdM64ZyrxHVMBnln76sgTlfZCRlExJDN3yMqc1NMA0uycI3eQ1htFLQLnh4N2cgCTxhZycMyPeL4hUwgw1JgzPCVg1FguZu3eCjcq+71n5hNWoGLNy9K7U6rr0ng573NJPrjzl28DAe7RueQW+YArBMkFd2gZScp78i94A3zwGKtP10kZqqqCXxH/phBMNx4U1Nn38BRIInVKEdVVPvjcoV/KKLOCnwg1j2NHI4Akef3kdoCtzVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81X+Bx2MsAfsLoRpNc+d5R3mCTnQmp7qpPlhgsGQIuE=;
 b=aeub627IhqlKPGDgQg9lBDu25SQX85vp9YggnuwTkd08NR1G9dmFFNnvcXPAi/Sy/br3FjqynTJFMyU85Pnu9vmbI3QoUP8SHZPa6XQxtUCLL9HngOMIXX7y0cKv7FP0cdj7nDCNgr/SZOMW0Fd8YOuoFTO/v9IaUwKjYcZ+pwcsGmo6h/VVvGU03O5vX5/plDkTulJiBQbpI2Ymhq8Rwa/PdvILLaZ6F+M8V8es4hji2XMDRVHwBO2J6UNZY+AV5MVnkCoaAfzU8g9xFJBtFlB/NYW1RE2+0HHzOWJ4PZ/IemkGlw1gD5SpF0sRzbdiCz5Xn87Yi77HsjyAHB5rLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81X+Bx2MsAfsLoRpNc+d5R3mCTnQmp7qpPlhgsGQIuE=;
 b=RPsqP5maDKwVuKe9vUJxJhQ3KpubehyC2BJcX2WzNHcE7rC7EyBir/7B8fuszGjiR8qJEcOOPRJavPmrTre6cf2XlwVjdF6wuxgYxizxVun6Jfm908cG8UPEDlvHe0oXbairsnkttJ3WHLGdRM93kXXybDG7Pj4f2JFkFAi7saU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 20:34:24 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 20:34:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v2 net-next 0/2] Convert switchdev_bridge_port_{,un}offload to notifiers
Date:   Tue,  3 Aug 2021 23:34:07 +0300
Message-Id: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 20:34:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a6bab98-6264-4080-4fa2-08d956be1492
X-MS-TrafficTypeDiagnostic: AM0PR04MB6465:
X-Microsoft-Antispam-PRVS: <AM0PR04MB646572BF0339AA5F2D71717BE0F09@AM0PR04MB6465.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oBPnuvb3N7hevVzKo8xPYNTmIP4EPShTukJaczwWXdZEKSH4yTWPBc/NYZMs9enxA5dOzGvRC+4qwRmUAoaDqYsqHGss92lOB89kMf4p9VR01fwUT90FQL/imJPaoIkjBTWssRUnTFGaeb5Xt0GcAyy4jj4baUUMuCQs3fepXhcCLTnomfemMLT7XHoNLjrqz/+BLh6qWHmpSuaPSKVyKjeMuuBreUXCcyY5Pvyz8gejn2DC6M74pbmCxk7Xk/I1oRzNDLlC7goQU3vFRBApk2fw50U1T6jOwPvzMmCL9Chs1/tuCgZRpU06ZJ+bXiMTztMrn+o46dsKMHl0nP8pRVo8IpeyozYnWMuuCwYJo+aCNmmAZiotPMcqVw1o50q2y7RHk7C4DYlBPhr4Lk4f80yshIW57Z9MKOy18X2fUE0Tpzjh7prOz4MLtvSpefrGLZFiAH5qLgOweSzfhCT30h7p6juqole86RHf4PFPmIMaRZYI3XVwApKMvzZWJshiTNwsUnHRbfzK+2m1vTP19f/2bYHj493ILYfI9k6/n91Sw8FmJ17G6ooRHpeq5kwxxDdvemlYXYae7Np/9ujnQc4KG3iDwaA4Om89VFrm51GTMYKepc/X9VCGak2/EY1Qu8qOJmnwjIdlbqRUKIOzSoi4GdIO0EEG02jI9+IB/mlSnHqHUW8L2w2Gv7eTy8oQekD3P8Le4ghp5yg38sYGtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(376002)(136003)(44832011)(956004)(83380400001)(66556008)(1076003)(8936002)(6506007)(52116002)(186003)(110136005)(54906003)(2616005)(7416002)(478600001)(8676002)(5660300002)(26005)(66476007)(6512007)(38350700002)(6666004)(6486002)(4326008)(2906002)(86362001)(316002)(66946007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?92PYTWhqVcIyCfX6PnToXftrytSwojgAkhZvTQ1kdpsA+ba7/ckBpiYJuHYq?=
 =?us-ascii?Q?7lmGOmX7CM92bVt+8UM9SCc+gNn89lyLBdPZYV2zzXfb/RPcb2Ooyo5wzizr?=
 =?us-ascii?Q?MgVWanx4rhW7z1rVJEJh8z6+rOciK6lQ+0aP6Xo91vcD1szvmtyhs8HMQKbR?=
 =?us-ascii?Q?s4KgfBqbu1Zd4avstduBw6CYIrE2xo0/goAthLCumH1t6w/DSuK+1REd9O+X?=
 =?us-ascii?Q?k2l3SFGC+N8m2e444s2vzhArAe2WH8u0/fspnKKTtQJMHslM3CE12y/enNO5?=
 =?us-ascii?Q?uq2o1zTo4yItmrHJwmr6uV/SpbzpClcHaGKU3zk5TbxCqKFShUJ6cYg65Vns?=
 =?us-ascii?Q?5yp7nnJ5sGmvBYan5IVQPWGzW0fU47MjPA92tEO+sEheoO/abUHLG3KK34SQ?=
 =?us-ascii?Q?sPeeEr4l0+tU41gmEiuReYAMzEXc8E8LpCcpNFTv9tM1zCit9ii/aST38P7+?=
 =?us-ascii?Q?2Dip4eCSPsoKYmCwtFpidJEBfDJNOELdgdK5JvT/4pPo6pBWlajRGCCuGfJw?=
 =?us-ascii?Q?paV96ByV//oDDnKhwTJoKnF2qOHqYqlDqy8tRIG8sxxJtHYvkv07C83iiD8I?=
 =?us-ascii?Q?AbobD5nZD1VoyRbaSCjgllXMHdLFhE5JxNfjx5fi2AI9hdRf+W0MWTsXIeLh?=
 =?us-ascii?Q?NoastXfobL8Xy0MEXjWNejxknqzSXTDviE7P21uCjo1GasNpB2lChHwsYDeJ?=
 =?us-ascii?Q?jxji/WRXYmgOgr9BPQZu/m4A2hFKGnHYmP18PVEO1uBAVFuz1oHVdiZBPxpw?=
 =?us-ascii?Q?3smg23anHxxksMpBcteK4n5/0u/SLStF1jNNZxEFNW2nrxF4Btj7bwGOCOQQ?=
 =?us-ascii?Q?Xw0zMOYE5Vj7ITV+NG+w5gLJdN/1VJ2P+m3fwFTJorFyP2E0X4e+6Rk6k2bI?=
 =?us-ascii?Q?KifwRHTPTDtQ6EjHuabupV01ApyMUv76WbhY8iKiz+5xQlJfeTXHBDVilf/X?=
 =?us-ascii?Q?wKo8n/bYZEvo0VhQiVjrWXADModebybw+D016WLxsm4JCvsc/ZkYRo/hwaqW?=
 =?us-ascii?Q?KseZCRtbCiiVdm4fPXKDNaPthRCvV+2QGy4EoEXEk2hJWkbKurhBTNoNOeK+?=
 =?us-ascii?Q?01A2OdgFym4xzIjk1a4g2aplKIiJ5IUuI88vHMcxFg7leIHPehcODXggDlQq?=
 =?us-ascii?Q?8v2hZVxQksnncSz4/cCvnJXsBMt8NOrTZ0nDOvIuVgjSkSEJjLTqwu8bjkW5?=
 =?us-ascii?Q?Lk4Ca7GH4e37BPfm1lm41g51tPcjy+H00NasoPdy8JxcMamRcs+bOUG9L+Kj?=
 =?us-ascii?Q?5LdpsbZqTB4ZV1TzpMW41fE55adTRGdBe+JNkAuCEHe9tJ8Fk9cI7VJ49/Bu?=
 =?us-ascii?Q?2ubAI3wVkTozYkSe2rBbjlCn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6bab98-6264-4080-4fa2-08d956be1492
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 20:34:24.1092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFV10YmO+J9s7xjeA/sk3WFGAL6tdQE1+7RA3eFa+kySsR4+DihCsrzKg52ZOMUYmu5YMN5tP2fTON2kXZf8lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The introduction of the explicit switchdev bridge port offloading API
has introduced dependency regressions between switchdev drivers and the
bridge, with some drivers where switchdev support was optional before
being now compiled as a module when the bridge is a module, or worse.

This patch makes the switchdev bridge port offload/unoffload events
visible on the blocking notifier call chain, so that the bridge can
indirectly do something when those events happen, without the driver
explicitly calling a symbol exported by the bridge driver.

v1->v2: removed a bogus return value from a void function

Vladimir Oltean (2):
  net: make switchdev_bridge_port_{,unoffload} loosely coupled with the
    bridge
  Revert "net: build all switchdev drivers as modules when the bridge is
    a module"

 drivers/net/ethernet/microchip/sparx5/Kconfig |  1 -
 drivers/net/ethernet/ti/Kconfig               |  2 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c            |  2 +-
 include/linux/if_bridge.h                     | 35 -------------
 include/net/switchdev.h                       | 46 +++++++++++++++++
 net/bridge/br.c                               | 51 ++++++++++++++++++-
 net/bridge/br_private.h                       | 29 +++++++++++
 net/bridge/br_switchdev.c                     | 36 ++++---------
 net/switchdev/switchdev.c                     | 48 +++++++++++++++++
 10 files changed, 184 insertions(+), 68 deletions(-)

-- 
2.25.1

