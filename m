Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951D64F77C3
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241999AbiDGHk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241967AbiDGHkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:55 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE074EDCC
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmK2MdBprnL7q+r8w+EF0ARFUTfJh8fLRqru5EvIfyIv0myuRWZ5mZqCCCYDVSAiYvf/y5NgwOmiFBIF1saVnSE/ZRT59zUdEwQMeNc70D4dbQtVbpgKwou8hSnQeUA3X6ANCoMO2rLD2cjxnWsk2nxgbFMxj+BWA5TlcO933Z/X9W9OSmcXWJ2eOfoqBdAEHrOnIdDgDFKTnYK9NqeTGgVvslJnpNWOX2dCP8IMChWEdQ6v4W3u16UeHSS9DyXdfIgjcCJ/uEzfZrqc81jEDa1/BKYh92k61/9nNhewBgt+XB1Y7M1HMxLxtCounuM8RtGVu4fJnmH0rzpvBagZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOpUenFEemyUnw2X5e1GI8ttcBKN1FUoP/Z+w4Sp4N4=;
 b=MK9PnHk2gOn+ErNlQAg1n2T3wI13EY4kJyG05BXZ59y99e3km1k079Dd/U/XroGr7KJgug3ZgQW0A4RJaCTd38TScDPmrqR7CKxeBYCRk/e8MOymXRup7d3RL7bBp28bnSB8BBRPXtmlm93Qg/BG7ZFTHuNYGU5S9KL9k/1FWbzf93XLpV1cmWB7Ij+gIFI6FpAvZQBnxglas8YpIiVWRFW26dRci7BDPUamp39TSUuzXwoPWG45pKKTQVcDIdgryzC+Qr63fJ6PIiOqNADDbSysiyqU/NVwFfsJHEUziD2IdHtz88rBmTkzfEnFizL97kx6Hkv8r1JqJKULemLpoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOpUenFEemyUnw2X5e1GI8ttcBKN1FUoP/Z+w4Sp4N4=;
 b=WDcQAMhQWpv5gI2ERqZ74TX6X0IH4HHZN8dCIU0qPpvWv9ipP9qKKUGFL8J6NMN57TWFtuQWW3xvKH558nTct9+urtiKcHSpbeOUwuhQOHY7HXj3idCZCImr961nvmU2RanI2uiavbYbW44vtyERqncSX3KZeouZq4ER9HcN5P8JHT/wTYyAiBX4hvW6EfpKtJlq4BpvWHLnuyikFGwgQXYIzOiRnloyziiNapKxfaWuiHvqFnD/FtQqV6bDCsmqAXYYiPrdIwC3a4dmbW8kCzBB//C7MTlRoVzNgezrk01cPjY0wDmlqTV1mhtHVgIUCn45hioy0ewkwzudc5YEiA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5228.namprd12.prod.outlook.com (2603:10b6:408:101::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 07:38:39 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/14] net/sched: act_tunnel_key: Add extack message for offload failure
Date:   Thu,  7 Apr 2022 10:35:29 +0300
Message-Id: <20220407073533.2422896-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0183.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::40) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9c317d9-2da7-411e-da19-08da1869a1d5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5228:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB52289E91798B719D9D9CF8DFB2E69@BN9PR12MB5228.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pm/cQiW9FSp80YnSueBb6b2G6N0U004OikwfJRxpnZPAV/bfgNdhv78KbVEjyb+rMuOh2RRfVNNgU6PbP9oFLuA3nDIvx8Zvc9LkOQUvqNbi6r2PcYFVFS9CJUTF/SLBJis7patRbVXsJ4PHmqEjKXcl5TlCoIf3yfezQ7Z5Y0ww5M94R1kRgBf2Mqs75dafekMFdvecFYQseJtebuFnW+TLHonX+JHpvZzkBN7ohOAg+hCW3d/E+30KPpLFCEu0WT7Xnd0wJxEljkw4x7+XXjrz4648rNDtAar3UavRRnzRYeLMqbmR9/py3CJLVhJW3QFlZNZ5GPjJMtdctNw8FxTrtfPk/zHBS6jBFsWhGMUNapHqxiS2qM8/vZ1ejNuKUoHQH778MjHNfSUzFFfZ87lICYHPa+tLs8rmnZrRF14dvTej4b+ws31aOeNMJ7ZDyiVYc+5Z0dVyXU7I7aoEzv4COaj4xzoxw8ZLWMlil9ToS5RYrV3kgWjwIQ30cgRsGtnPSPM9oESHZ4I+RPiICAlIm28zhE0bizGDrQn73S+kkS4DXTNE5pvw/ih71rh0tALVTnBWFWLbLsIS1S+HJcLD6wd3Yx5RL+S+gzhWcB228lLvTbE5tYkIVcn1l4kvulnb8uC9xxVauFVQ63Mp5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(36756003)(4744005)(6666004)(4326008)(8676002)(66476007)(66556008)(66946007)(6506007)(38100700002)(5660300002)(8936002)(316002)(2906002)(15650500001)(6916009)(1076003)(107886003)(26005)(186003)(83380400001)(2616005)(6512007)(508600001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Js0nbkn2GRQnEtnuvJvhYsBbTMK0hTtARbEnCSR16t4wLgEXKU07a5vMe++N?=
 =?us-ascii?Q?sO6hdrVBO4d+5ohZ3lBVvZer10Ax+HI1gkPHAUSFpo0e6opqlBVeN8uKOIAA?=
 =?us-ascii?Q?Sxx3VxS1BdMvMl+AwoDQaDRIiik0FuVenlm7PAOP9WJbsj6o9dxgbITxuYTD?=
 =?us-ascii?Q?AKSUtpqLTNwzMXlzxbhLPVpN688U44Ir7VBoC8l1JXpBXZsIr0ZC4Rim7Z8T?=
 =?us-ascii?Q?1NHyKf/2ZPSbdC31l3XUXlElA/AQ6iRtkHiHQM0J+Zaougi5T8/g4SPLxlsx?=
 =?us-ascii?Q?RsYXjV9Gx8Q6YWXllKm0n1OCrFfThx2SlYQC33CidxQ4fudxfs4lKBe+qXjW?=
 =?us-ascii?Q?RR8/cC6t5lWr11ODALybn0Wz6RDgU6cogvzcL26SIh3u578kdVoLH712Brhc?=
 =?us-ascii?Q?HEEOOuLrwans/nA/gDXH7vPcNj5jEBl5zilwuMv16P8eYG2K+1ZPFLKkaTfU?=
 =?us-ascii?Q?mZ3y1lporO+A6LlMAkVB8vioAdSW+F1gX9IIvROKPtdilduNSYf1Ijv+gKhA?=
 =?us-ascii?Q?+16BqLZdUXn5InWfs30BzfXqeBLwuX70N086Qu5yhaUeuPrQUW45Xdw9LEq0?=
 =?us-ascii?Q?MK/2caTh7mNE7or1pztFE4H4P7l/7Ip5zQ+eX/48YOPSOlfpwgoqdLagYwTI?=
 =?us-ascii?Q?CXl33JvmgzxBfjQ/LWXpXS16GWLPdjRlTFBQ72Im+8nEy9l+/bEs3T/PufH2?=
 =?us-ascii?Q?aSNZPzJCKiIcFiccszEq+nHJyFdLAzoLoVCvuBSDTfVZ73c1IAGJgxg2/03r?=
 =?us-ascii?Q?Vs6d3IWwdB1olFkjvlmXJCxMc3FqStInOpccVG9SfuTgRlDdggqlvGoZsD7J?=
 =?us-ascii?Q?S3frGchxabbvrYEYwB+23H91//UX2OzR90vkPd8YnZUPDczpsR7JOgrnAOMm?=
 =?us-ascii?Q?1T3qF1pKiLONFXkQgVXt+Lx5n1nfexayyYmWRPwB6Ov8i+PVzrQ5VL+AEvne?=
 =?us-ascii?Q?ByL3i0dgWA8v3Q6lsyK9ZyKvio8AbaygwlQ+wT6DrZhmox6fQzl8H/DyqlyN?=
 =?us-ascii?Q?MQE9qmOw6kCVHKuaYvyHuo8+VJYmU/hP2QyQL5vdkTdIVVzT5OtDxiosmDMc?=
 =?us-ascii?Q?PRUsXEjJXJnjkhe0MQknrCHp2/1zQdSLTdaX67olCVSpb2yVJIQcpB0R7ra/?=
 =?us-ascii?Q?4QniQY+ymmxEUHlJUN175ZHOhj0BaqjWGPwfsho5ug/bKsrUMc9PVWquZt1T?=
 =?us-ascii?Q?neUpiXty/DC6CzodN5N77Y8OQhke9gT4EzEO9VP0/5bBsApaHjOmwcEjE4AR?=
 =?us-ascii?Q?dX37YWa3lEs4uFllmtZoHvq7A2dV6Kr0506cxWk7mXcMaLGoKoIKzCfoiOa8?=
 =?us-ascii?Q?YjB9gvgjbsqJHiB1/+fDGFE0+kWesbW13vsqtanMkFRheqy0UkdLiit30Ccz?=
 =?us-ascii?Q?D6xtP9ROTt/6ADCSdvdvdyHfopBRIpot0xzPH06VPzagbF7dAHVNPlWcOSLD?=
 =?us-ascii?Q?Ylb5DWUwOoaH7MzD1SaAAmC1Gxcy49sD2+fKYEsP4AMiBfj03GTA22MYfJZU?=
 =?us-ascii?Q?aM/r6bmOXTlaAe/fUbu9FHxzSLeFXtob3ljFBri/MWsmUU9R7i/Kdf1jBe4O?=
 =?us-ascii?Q?jxV3ADQE+E4ersec3e/UV14DfDlxu22P5+1x58KswkeN31um5v6db86/feMm?=
 =?us-ascii?Q?axw7C7joJ9s7e3+Dz95TSaURbN+/4WJqkGpKx52OE8DS0GMsLqWkRl6U9byY?=
 =?us-ascii?Q?OYf1xtlByHVzRbpbPKOzfEOxKGSDAzbKTd42zsld6DezYO5BSl7sn6OYOJaJ?=
 =?us-ascii?Q?Ukvm4L3Ybg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c317d9-2da7-411e-da19-08da1869a1d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:39.3063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qv5d74eHnvY9ACefaVFtukNU91nyqwftS9ClWQtncWJQnQo5LKv6FP3RS+REIOdtuRSi7BHl90Hwj+gdbwCFhg==
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
tunnel_key action offload fails.

Currently, the failure cannot be triggered, but add a message in case
the action is extended in the future to support more than set/release
modes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_tunnel_key.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 3c6f40478c81..856dc23cef8c 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -824,6 +824,7 @@ static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel key mode offload");
 			return -EOPNOTSUPP;
 		}
 		*index_inc = 1;
-- 
2.33.1

