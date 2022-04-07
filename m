Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4674F77C0
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbiDGHk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241977AbiDGHk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:57 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2055.outbound.protection.outlook.com [40.107.101.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16E68A6E6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7trG21EbbUgjXidOGGgri87FGbfQQioN2uK8Ei8IJ6PWvelSR1p2XpvFU+YRWcHlUN7vYIAQXEfhiImQF1Q1Iw81ihxaonoRnyhknC0+g8NX7IirCpfI/VwjBPf1AHOTn7l7PWP8shvgNa0kW3wfqQTAOL8i1P6PEGYhrhCaze2UODB9Y+1keZGx1fe9H2VBZJt+F4UGSZVtoZqO3P/uuBXf2BHBJNq7sAwW2NXZsgS8XRBdOYK7HNBnE2yBm+92hBIEiuNJ0dB8MzcbWEubCOBZUlM7O3TpwGFSbwgnUtyCOVdrQagse3d4T/+UVOIwYfwM+LQC4reaNIHWNFbeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRPnBijXnUBcS01j5v717liiaWEXkrCO/+py9eisDGU=;
 b=VVYDIC6PrPGPWR2lkeuNtG7MI63cOmEsCjK/Dm4CMrHqz/Am8d7fx/8N5XcKde/6oX8oOh0UBzkdHZL4Aj6bLwI1GPqqGs+lQ4QmKewyMLLChlA9+0higibh8Rr0tDJL0J9aXaDXGgCBPveoyJ5YZe9/BYCebxdMnrU3pEBKidwHPG+4JyTMZD+MgZCdha1sfY+faLGXLHUbTCHusyBIQg+6BL57hrDUq0wrLhz3hYcXPK/uevZTbi7eHy81kbysKhnSavMh1kk4I0gAsZ+k/HYnjXHesgfeDJnTjR/Ph8VBZ6/Yzei4U7Zh0EnD9NaXZHSAYkxXIaQj4shaToYdtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRPnBijXnUBcS01j5v717liiaWEXkrCO/+py9eisDGU=;
 b=GvMubnhnaBJAKmH4OWQzhOt9nhtXYxZvq3QFxIMY64m1LlCuPAX+JTdPFhqXgxXVvNwYWPbleLQbqrgCRDhIPoydZPCSI0bSvPUsPh6NHHZfAzcTA6m4ErOnUJOzU7UrDoQ7qWg+x6nIuCjY0Zgj2sCM/ZEyjdWH14vuTSTj4016eBvmaZL2xWRw8n6Kis9OVN1vBIOGZKEqOsheqdzjzr43GDYmM+Nel3thc/lBfxWHP0oASNxBRyGo96IKx+CtFJhb/ZIH4dLuUQcBppU4DjIPAC3ihvse5xt4awUbGvPbKJ54XvKudIMkOBZGQD0YpaTCi2u2yRiTQzsBEVxDdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:38:45 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/14] net/sched: act_vlan: Add extack message for offload failure
Date:   Thu,  7 Apr 2022 10:35:30 +0300
Message-Id: <20220407073533.2422896-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::17) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01793513-3b1c-4a7a-7113-08da1869a564
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5228D32A33C16A114071A3DBB2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Yzfec2u5LwS5+0wN11UKqZ1oQvxgzdUh01MJAkFegv92lIxPYIPhzcTJNDqvnXWZ7rnBSzmmv9IFjLszjASF3yQnQ+0zxxel+Ouq99ItS0Zl0hUA203f2u/Y9L7haOrWH3MtZrNX5MqyJOwTLkRNGFd9Qq+3qqIyRXO/Eedv/A43ISxG/kyAc5g+xLWXpkqmR+BJOtDF6icNCStwCCVxzksPwZiDhbUHZeyi4U7BrIAsfudgM4wE2lRiqIhsjcameyixuMO/Ft2Tw73om2vFIqQgUMsjpgfUjZS0jHXqloDvXtOw/7YLMjUEe0/ggVperW2G+gnYq6F0GjUhGm3KDSx4PkYt3Slvu6bM1P0X2Gxpnk7tomd/deKyo6TmuEJUOVGfITt8C+qj7MGyM6o8giBdO14YilJiXeQoITBcOBicZVFbPtZSTOf8Yg65Q69EQv1XCCw5vBqIY72NYp0Q/9f6NTL676XQDUvlEKGuiM/kFCr6WsYQAtXIlC8ZmG1Md8FiHkYc5JsBP6vSEJh7dOlQ0cZOdc8KStNQT4Ir5NoFr6S1WlXbxljNFbJrGtIs1PlD6iXgFkDniQLl7UZTAzbhz/IWYK+0rxcMPFz8wQJk2XRQfIG9wWySDmdGfk49V7qkzfVdAYvKT5CmtJcMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(4744005)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YGlV/asSbvN3b9y7eGJhqBOua0hOSEjZmymtVsdIFGX0WRjo4n2TWbz317sX?=
 =?us-ascii?Q?aKWMVLPGqXqA1bmiwXZvxHLSt2haYNBknPLK1SISuVNWh6LpKewNMnsNoRE9?=
 =?us-ascii?Q?mDHyFDRXVWXI/9pQ/8OGjsFvVUJJp4ARPxp1RAKFMlwrSbaMDeX2FsqGuAOd?=
 =?us-ascii?Q?+Q4Equ2gdTLOUHM6O3sMM5Vt8IjpTueLdKmcMiObVnSVGJvsqJ1Ccr7ECzw0?=
 =?us-ascii?Q?zkxUHPJ2ryFFqbgTFP8bs0rUAzMB20ZqnxLYeT/zDr2p6AlSvnbjhzzpc0c5?=
 =?us-ascii?Q?ppYXWa+zqxA5+9YvJAS7Ev+NVh35B1sfKDRl0SCGucf6YRGVjur/U70ch6ba?=
 =?us-ascii?Q?HZ0uKrygf4uOrZr3fQqyoByxKp6PBzIwQutiPf5nKFyuXiI49Ay19/b95obu?=
 =?us-ascii?Q?zHAKFnmtoZcXiiPpfFoiItKbdnQAL9IYacIzrIoVM3G9XM+2SuPVFExfNNke?=
 =?us-ascii?Q?9Vthim940+pMW/oBPEDT4K5dRhIkva5bFyZWXxMU0m8TH2tiRDCKXI1DStuW?=
 =?us-ascii?Q?DZytxfqJt85UZk6QRXZaFjxA4v9p3m/XOZ+9/aE7THjrEYxJfgzEvc/tn6pQ?=
 =?us-ascii?Q?ImIGPYy0T+6rozY6mwz80rOI/0NSX9id1lbkON9zd7g6XR/qJ+OsK4MZpMp8?=
 =?us-ascii?Q?K7YSbQTUpwPhLxYNGdfDK6sNFQgD1O02gKBq4q078wkvHUFqMhoSPtKOR2IA?=
 =?us-ascii?Q?gejXhNjuHeojMreKy0MRacySMMnffn7Q84NRyI/WrwuUApgA0h3QvpCoARpZ?=
 =?us-ascii?Q?mKU3MXJ8Jw2e2lXR48s2IiMjVE3ig+o/SkHPTzmCqlWNkQPAagtxnFy4gYwh?=
 =?us-ascii?Q?g2aap/BLDgtNkEgAnTcwuXeBK6G3ySl1Y2QefdVT+9GLC4Qm10U+xFlGdvv1?=
 =?us-ascii?Q?8ekryJuqe49ieV26v6Nr7SAbqdwovDBrlLblLkEiRpXABy6If7oc4cgIR2/+?=
 =?us-ascii?Q?8qFYBznTV77PPQpKUmi+TbZj9CFF6Swb3nOIvtvKfioe0as14gpzVxatvOJE?=
 =?us-ascii?Q?gVS7B2TjiodZP+FNZuh+PTZJ7Ap3m9lKwZe5aofgmsUtD1koUf1ZYsbAC72x?=
 =?us-ascii?Q?TTNIOz5qxtFs7RvuQ0guwc0uyp7Y/zGlUeFOb8meq+Saog4t3Lfzec5R1ULc?=
 =?us-ascii?Q?GxLAfwInwP/A48e+diNc+6nO/Kx2pAZTngpX5ihBb0zwjvbWC8SIfIpAP9TT?=
 =?us-ascii?Q?iUFOiLYUdsyYe8ipNjX6z4AguXgfhe1MaW7wDdwpzjeQze2c0IZ3Qgr/gxHT?=
 =?us-ascii?Q?JIVIMCtbUdTro17T+niPygBoVDGKdgI4tHYsuJqAflm3m4+XsW4duJmioVJE?=
 =?us-ascii?Q?kMF93k74GbeXRwB+dNmF2XcsNeGfmIR8cc157y+Mug9NwLCPYeWnt7pHp6H0?=
 =?us-ascii?Q?0sQOBtbH2tv+UA6h8fJl6RGpwvLFFy9wLv9dt3+Q772DgdreneNLQfFJb64t?=
 =?us-ascii?Q?8ZISPCXR9eu2HY3bfNIs2UDQ9B6ksYZ3bZtiSgbuP+QEvyTq4yR+T8Tqt1XR?=
 =?us-ascii?Q?IvzATwrM4HEnBFxRj8mr8iSGZXXMrbcaVD/7cdu/rP5Yq19DGJezQ7eENWR/?=
 =?us-ascii?Q?UuzFPBq/Buu3yBDzDHSGL++uDth3S19sLlTCAWXvAKeB7y4U8FLe9AbftCPv?=
 =?us-ascii?Q?y5QatoVkSJCBsGM+l4V9021enlSs/b3mLom+JmgVjYlcHQoOfEFxD8kY1AO+?=
 =?us-ascii?Q?uCfPAbn4TMSS0O4SA/EdKnTenyU11OEiLLeIf5hnCRETC9m9rZVhMR82peFi?=
 =?us-ascii?Q?Gp46TYI4MQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01793513-3b1c-4a7a-7113-08da1869a564
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:45.2583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t9T6HadAthNJTZ5Igjg9zCPUb8VKpZ0qSLAYnlzXminmNaRgV5pJpz8b+7JFSTzSA7werdgc0NMAvNeBgMNhhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5228
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better error reporting to user space, add an extack message when
vlan action offload fails.

Currently, the failure cannot be triggered, but add a message in case
the action is extended in the future to support more than the current
set of modes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_vlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 8c89bce99cbd..68b5e772386a 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -399,6 +399,7 @@ static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
 			tcf_vlan_push_eth(entry->vlan_push_eth.src, entry->vlan_push_eth.dst, act);
 			break;
 		default:
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported vlan action mode offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

