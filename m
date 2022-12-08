Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF78C6472FD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLHPaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiLHPaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:05 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A5C7E414
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7nsl5BIaE5ouMSVMyLJv/tNMdssiQsufTXK7aUsdWBa3GUSQVFlYreQu2Nx76gvOm6FQn5Ye6ow/6mApUbUpWpiX24s++ov3KC+hBlFAi2TdLU1KHOxCiYRJbIR/OMNiWpkVgMfoxJswvZB/by3D0XpTtN8cOIiyrFKQxg2PfUdZUl8x0l6zm7UVRJAZwdGU2629R4Gt4nvkbgn2P1lj//hayoWp+B0Wqz6LRc75SpT9vwZbsTF81DaFA/VyciW+T7SRlSlZdsJjma/DeKVOXWhujMdDfOP3Xef3WE6x9e1OBBuct7k1bq/kyJ7pNmXOcOZMSZOuy9qqfSnUewq2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGAdrMfjbxvwPcFkMLK7vIWLclDlIPR8xC0JST0wvtg=;
 b=U5+HEiUBiUcFODdtf0lt8DRc6IR8xsOXn8gopiYP3PIuqyakWxbzl6UI5T3wYkXiwTBRShQug+X7GAzqygSxWdkXd7hBKAoT0p7JPxFdNCtAlZVcuPGWlDGarzTqYKcWd1gsxj9rBjPkqHB3MdZFm5Ikf5pa5DrP/S7J83O+HzH2wb9u4QeQFY93zWpKnV0GYoCrWBUw8ISAuuK6fM4G1/SzHD01qmou+WWqGueXDRJCQ6ncq7Jo/SfFY4za4omv9hwFWNpZj8wW/qECnFbsn/aVvuDZQLNQf4tgM6oI+fcPrOmeq68g7HXxltGAp0wb8e0+cqBqefuPRmwMUedBpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGAdrMfjbxvwPcFkMLK7vIWLclDlIPR8xC0JST0wvtg=;
 b=ZpX9KeWkheyij490KLQvvbvBtEDgb/AeNMpSyHzb7D2G4a3nMHP7N9A000ASM9ylJWyxdM8oTC07p2Wd9pvl2Bm4ndrZeWfoB0Z/JK44xgTiMPreXknF2UD3hILB0Xp4ASxuAPomUUr8kyA4Und89DjFcUZwbwGbKd6XlX8UmCR+2PDPSQcr+KNkW0BzACHaWDqZqKc5npFCJldliOxnVWDobQUPbeO7EOWR0jlOVCDkjyagCmXyU2d1nkDFe8TRa8Bj2/Jo2jMWypTB3pWdT4RDR4wZdqttF7NWLd+KBSJouUbEHklll2XcTCe1sxg3PdGE83bNO2hJ3Mi4lTlS3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Thu, 8 Dec
 2022 15:29:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:29:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/14] bridge: mcast: Avoid arming group timer when (S, G) corresponds to a source
Date:   Thu,  8 Dec 2022 17:28:33 +0200
Message-Id: <20221208152839.1016350-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0017.eurprd05.prod.outlook.com
 (2603:10a6:800:92::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: 45fc47eb-47a9-444a-b12c-08dad9310c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtkjdG+FE/ZQvhH5pzpq6p4abQOVVRonFL58nGFLfhXvKaDjTsAC7D3VHdRtmWzsbfSqktwDFZNqi0Fij60+8IfWluTJ1nLmQWbER8Hz5SG62fbNRQuJ7DsdaIMMz5MQpHE6IP5kRW4n96hHWO9CT7nW78vmqdMz2eJY4jlGHF0s586JQQ56q+tqd2ntrDfz1yw/6q4g+qwVEhoyW2sStecWtGgXlxPjKdqjriS3HqI5VCr0V9sav3yb6hdMwrNci63jV01qOLZvp5xeEJETGvuSi2uXqDOrI2QtHtiWtS7dRLwjMKz60p4EUjwe968/Tecv3q0VfyMdxs573fFaRZm95NIhc3u4fNf0ngVrBtKJ6USgC+uuPNCjugmtIWTLoWNH5L3E8jrbYNAkbzlBAYVQTyN2LMx3B728gHsJbFo8CJ8oD6FUNi2hE7DBGaWHjdz/ZHWa2bkDLLYpP/4AwLocv7lWwgGAkbXzU40YOn+r0MAndmX1z0My7Y0QkHGuMhIkzjuRvKuO+aHmemlPyTEPs1I7fv9LeHqgVQHdGdcSHIeXGLLBiKSKNqaDB+IC/qjEyu8IiVzAcyB+VZ2gBs4Rb6H773pGX/Rvm3mRvkHlStmGAolmMsZmSN8mRHammnmN3smAC1g96puEEZdc0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(2906002)(83380400001)(41300700001)(36756003)(1076003)(186003)(86362001)(5660300002)(38100700002)(8936002)(6666004)(316002)(6486002)(6512007)(478600001)(26005)(66476007)(2616005)(6506007)(107886003)(4326008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qEJdGxCeDG9Hj0qtgDAFLAgCceEA1cOYqcSwoeHc6eEJ62BpIjxfrLcIX/Xc?=
 =?us-ascii?Q?fbk5jiA8XaLGkI/lDU2pddcJ79Hk+bTcSuu8JTosEdvXv5YRLwTzoLHU6qXl?=
 =?us-ascii?Q?Te6ZfmHULv8mLMPy6Y/qQWbDCe5agNjW+5E1+SGAHxNR6ZVkFHKe9mQAPpkj?=
 =?us-ascii?Q?RNUquJEIxuKv65mhDdEe3yUyxj30MsEw9JzJtaxqtXn1jsSe4B9wCq+4ErS3?=
 =?us-ascii?Q?xLAZpeijBjkT8p/2qghb9X5ERNSNA2SdgmmAT04AkQqzOOVK5dohqShJd3+N?=
 =?us-ascii?Q?W8nF38AUUXu5dRKg42GJFyC7XLUkMNeXcPhh8pWw9pmKSvFFJKsp4HmskJXu?=
 =?us-ascii?Q?cSy0txMNsrbM7FiZawBWoSqGCAIDKjWROFFBx+QigLlS/XsUat0PkNWzEz59?=
 =?us-ascii?Q?cETjaKqMM/jNAsaVqIiEMGI4kDbPSANCsSqng554y4aLdr1A9wjaywlBH3CN?=
 =?us-ascii?Q?s4eyI3OFDkcT4oBSPYYYREj2P7gKwGbKj1trXlJZyr6yLA6bgu3/E9VD/tlY?=
 =?us-ascii?Q?5nm3vQJj4zSg4qwayXVqHNs9r6uoQGIfWI7ruYbqfEoSFa2XQDJcW3B8m80k?=
 =?us-ascii?Q?h52UhPJAP8ZinEMDIyOOX9a3QMESmg9YnWMt9rC6Dflev7oKU4AiSe77UKO5?=
 =?us-ascii?Q?8ztuYzvSuarryKPdFCPxAqNqM44DN++z6GPNtTuuWFntj/GPxwDqzxn6iTSP?=
 =?us-ascii?Q?okwGMGImO7SrrGsjSWNP7nchItghrC/sCSWwOeFsPeV8Xv31mmpJ2B5S61TU?=
 =?us-ascii?Q?OGSDveuguf8pEY8zvow32dEVnibbc+b68WGpbZArNLZb77yztns95xN/SENS?=
 =?us-ascii?Q?40HUX1MPCTzK9oN9fb11W8W4g3ZpTiZfXkS5iAx5q/KO1UGThzJkyP86CpYX?=
 =?us-ascii?Q?/D5ZEcgKHEIDGSTp9TXr39WG4ODrPYr6FkhTkThoGVKsLQk/221rx+Vab55L?=
 =?us-ascii?Q?uUdQl7ypEupPD4Si43SVXHX6zcbLFPUrlKOnTTb1ANXkKyN3YJPxGwgXeTIc?=
 =?us-ascii?Q?TS2CtCMC9skQSs1q6VnaA1jibWqt8sB/jCFaapElK/pJOaopj8qWfV3t8JFx?=
 =?us-ascii?Q?sFeQ9+AVQFGbBd7qCS3QjGkUmrA645TGFlGFV8lt/ZyVTsgsS9znhRslUiH8?=
 =?us-ascii?Q?QeBlV+b73N5hKPP+0N8Lh8LoG8wyriIc9Y44bs0FofLy4niQXwfyc0S8vUzO?=
 =?us-ascii?Q?0WK2Aml0lNIwW+W2GJv5mldlBq/bZ1/d1tN7V3b7uP2itclLsGXprt7mYLbM?=
 =?us-ascii?Q?Kp2VSZFpGswiXrtFMax+f+XEaP68pJDlIlrw2qD2zfI0UpKiEJaXT/0nyFsL?=
 =?us-ascii?Q?ZybbD2HW7OwKJEVhLL2Ofl6NctSnD+X/DdMXpoQaW7rNmuIyEexgIs45MGJa?=
 =?us-ascii?Q?1wkluHCHTCHEypmVEsyMRGlfdlpOhs/9VgbSbZVCvdeA2hSMQD3M/ZJCcBt1?=
 =?us-ascii?Q?P//7NfsDpdEJdgDiuF/R2L1lLd7du1RfMZuw/uwL18Re+SUvrgygQkfLLiJS?=
 =?us-ascii?Q?oFCrqzBzXWqjZT9DtLK+cYYqHUSWBY0ApTuLSXcuEy0yPqygoLp57ka7gJt1?=
 =?us-ascii?Q?vtUerplhPt+1JRN9LKrSf5X7DQ/wMaAr8WZoWyhS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fc47eb-47a9-444a-b12c-08dad9310c18
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:29:50.9196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sz17NGmv/2iNWmcOr2DMIX4GZpx0DF/L/sWj8UbZqetHWel576wehsfwa8yTwtc38ZkvQ2cNrGk/G5lgQnCgjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User space will soon be able to install a (*, G) with a source list,
prompting the creation of a (S, G) entry for each source.

In this case, the group timer of the (S, G) entry should never be set.

Solve this by adding a new field to the MDB configuration structure that
denotes whether the (S, G) corresponds to a source or not.

The field will be set in a subsequent patch where br_mdb_add_group_sg()
is called in order to create a (S, G) entry for each user provided
source.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c     | 2 +-
 net/bridge/br_private.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 95780652cdbf..7cda9d1c5c93 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -814,7 +814,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 		return -ENOMEM;
 	}
 	rcu_assign_pointer(*pp, p);
-	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
 		mod_timer(&p->timer,
 			  now + brmctx->multicast_membership_interval);
 	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 74f17b56c9eb..e98bfe3c02e1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -98,6 +98,7 @@ struct br_mdb_config {
 	struct net_bridge_port		*p;
 	struct br_mdb_entry		*entry;
 	struct br_ip			group;
+	bool				src_entry;
 };
 #endif
 
-- 
2.37.3

