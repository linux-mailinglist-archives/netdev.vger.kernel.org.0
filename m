Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D3C61E1E6
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 12:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKFLkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 06:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiKFLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 06:40:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63515AE43
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 03:40:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVSrKBXF99Y+sU8jqlgyPU/Z9PVow+5QpiNMa8OEBpkzynR4mtiNhpdx3UXhZAnP6TiHR7p9dm8mu6Sw+emvAWdnYpxzu7XM1L929KC2P076fwpwie6LACMJCykAZhVEC6j4qsc6Bb7TAq8IXYNQr0k2vt+2opi0YRCCJ6qXWO9wYfgpi/e8Ay2oJwab9WbLZFwFKnhj4HT4JcEM/QtxQr2K8ufQLfhapT6keFqXLZZ/QOuaoA1hQUHmuhtpvulyhMZOpJPohoaJK11KCkeL/TyPjtAcHoxcZ/977Kcq3rkPkqag1cFtZSb644+os5d0CohiHKsMkmW3fcS2fF870g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zqr+f9QdaBBx3EF6eFPCDb7Xh8ffgr/RKNDB8x4i8JM=;
 b=dh9dwNVsRQU+L8Bn9uflg40KOUzJOXg+Q7z3Q9/NNblC9rL73Xn6vTs9ttBD5hysp5y8MP9geqAD6wEHHSodaps+bdT+u3rNyAN+GlDgemMmetJCL1hlFhFXe41a6nz5AyTqx04Osb3Jzsgo+aolpfCzcbCNV3WjpcLnvqocDuiuppab1D+es2TQs8FRl0ae9k2uuO+U0RhypldtGiQxolhB/ydhP3Q7eXL8llX6SAhmBWCQNpF/PBMdbEywKss/fwYKzgc6Xvu8QYZ54IApcMcwLiJGVtAoZGRAoXTNZX1CsK/LhBoSvF4x4XcSu4aSxkKOuLPjHuaEW8Ia4JyNRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zqr+f9QdaBBx3EF6eFPCDb7Xh8ffgr/RKNDB8x4i8JM=;
 b=EkHB4dD9Eia6lpGLumFMNtoSX6vfbj/yOjjweNFIz3+LVE1cgIsn/uwSNDbf3iY3zrYWMao71VYRUo+UDdv29m8Rb6flOKWkps/zg0xNRzgnla7b4EhM2d/Bz7m1wmGUiuVg2ejk2myw95B6VFmvPRJnFh6vIoTnxI+KcwdIqj44D+q6Ted4aQBm8Ry1DP1J8W99gE7QdH9bJLwKMhwK3nt3c5M9ipp/2EeD2BVStjyTiVo4B5CgcZtpmebPxTabQb1uYanPaAegMDwN7Pxm3opVrXumqLhSllaHpXkwtPxUwaxmSvFYI+ihNIjcCxkX+GPe4vriBI5pzsr0yGspAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:40:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 11:40:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 1/4] Sync kernel headers
Date:   Sun,  6 Nov 2022 13:39:54 +0200
Message-Id: <20221106113957.2725173-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221106113957.2725173-1-idosch@nvidia.com>
References: <20221106113957.2725173-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0034.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a44b633-93d7-4098-91a8-08dabfebb543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoAiDKPxWE9KhkgErNa4AknFy0PFridxbQsIwZKt2doWe8pF4GwWSry8Z5ebYrNnxHTgQlutf+DLIKDA7+8SELM3Nc5N+4pbmDollfRkNqDIeQGS+4KtIjFOz7VywkUS+oMhcaazTQHX+pYdPlfRGsjgr31jC41Aci3dwMFph9o+c2owaIzpgEp+HGS/+cfXFbRRoWpO4Aa8/C6J1IiBlAHAd+r71mUX5Yjysngs+8G0HMgYlfVL1AMwuwnJT1YNRYcrVcj3W0RxQoxsqo/TH6r5drIXzm5axLbXwbFTY+aW3Zicqh7nhO1dN6wmY4nDQf17UJViUGGAis2akoaiYaVxdpWLMb3w4eNYsSs/prFhG4LMje8eplvtWzMOksMyHbCDDtPlOQ2bfR/eReqrIDBO6l3rBkoKyVW7RvVPAnVStnTcYb2Wvzm2QGdFi4mHSx+w2JQ09KhxFML7eYDKKQQhM8vgWMlFi2O8SgRZ44FYxjYb76waanmCAjc/5bG7i9PU0LfuAoLDMjImKa51NShtLWpXLNcHzOv+qQ18sx5eyvtvh5pGMDGz1B2JOkyGwNAFHU6N2LP2IsHiLkC6rnh65+idLP+WB9Hg2TYEGH83vXnQu4jgzU0kwiPtt3YoDFV/pEDCgw0MhvVgGem1dMNBmRp+Nk6nXdh1OTBi/NmtPkBqA5L7ZSX3s9n8L1DPa5JRQcg+iGWZcHATIJigpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(26005)(41300700001)(6512007)(6916009)(2616005)(38100700002)(107886003)(36756003)(6666004)(6506007)(4326008)(8676002)(86362001)(66476007)(2906002)(66946007)(66556008)(83380400001)(66574015)(316002)(186003)(1076003)(6486002)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkK7v6mYwXm0GWNz2acGUi+SlFgcYQh8XXxeWX8p/oCYs5bhlv6D7WM0RCyA?=
 =?us-ascii?Q?BsFCVwQJuDvbDXYq9ltq1LeW87P+UJT4wfBLCYUlwKEqs0ltBRoCI3X/lWBy?=
 =?us-ascii?Q?542Srw/JohAqG5vgdtnVz7Rqq5WW3Apq7EM6S8vXIlVT5M7UcxeZn8r6FneW?=
 =?us-ascii?Q?mi/3VtcsldDmXAM+f9MDYOMntWKiN5o3nk+kC1rrObTNvhQE7wzhG0Wg/VTZ?=
 =?us-ascii?Q?35t7zjqO/Yrn+M/FHmtESd3M77uSWNf53sX3EjOujSpav8S9E0hyxELQ8ts4?=
 =?us-ascii?Q?WXdOMdUSJBGFUnJSgHCct6I+23WSZ/K4WZhQp0Y00Z1bO9DIe8oYIgp2g4MP?=
 =?us-ascii?Q?afHs5Qy5Tis2eXfsySyjSXd7F6jOPbqiIjgyl8MOSOZWGt3rITX4EW/RLnLK?=
 =?us-ascii?Q?mK7sH0gt9ZEulBPrr4VsXDdQbQUQcj5b4GSXk4G/Sb6r23PADQfluc7gGFE/?=
 =?us-ascii?Q?msswdDsK+PB99b/HTkfuIpURRgreHWrp7VMlMITcWqZdzGka3GycGv1Mf8x6?=
 =?us-ascii?Q?YjTcxZxKTHQG5MTDwTaluRsC3uUO192/Fn7wMmDi0I93MEQBiplkYZRjjbFQ?=
 =?us-ascii?Q?uku8DD+tK/cF6o51OysV/dLCK9Hobv0oNuzrA7Gou/RylaCIFB+jdnJH/krs?=
 =?us-ascii?Q?9m2/i2iZUKOVo51vKaG5Y4DjYN03Wf5x7FKT2jmlh/yfhEF9HcyhY6N5aOAb?=
 =?us-ascii?Q?fv+mtu5k4swkTxn4ljOolzMHp/E8iiCGPNVJ6kfJJcGQDP/LaiiN8l1GDCuP?=
 =?us-ascii?Q?jBlbLLBx14MqNtic6SIfDkc3cpgk0xa81+k37yZTFxDEiTrXBfTO8F1pCcw6?=
 =?us-ascii?Q?ydPFqghI/6zH+Pg7V8VzJYi0V/muHv6vH0H8YvJVQBFnbcJHV1OOY27NWiP0?=
 =?us-ascii?Q?NqSC9s59otdVLeYmilrg4ajnn3mhETeJaa0gwcTqMLsQ8n3nvvOfqD0beI80?=
 =?us-ascii?Q?ZxmlIBeAm/h5yM0Zb/99oZWc9v99QpN8sx5Va3Y2o8wBRtplhdWMGHIexJ5R?=
 =?us-ascii?Q?q19BsIwtAo93jOrzO8U+KNzJATKWrJLvg6VUMJqspwhh0LFiHvIIP9M9GRZV?=
 =?us-ascii?Q?SeOjnBPHFxen1sv2QUdRNmcjPbbvAP7Kpeye8P3gMWoRKxiofoHG0LGhiVws?=
 =?us-ascii?Q?0j0yCZTzhesgZLi0GvJcTk+0WreWrCGc4R8fMLSHdjN5D/I5bSO36RzQI5W3?=
 =?us-ascii?Q?Lp6jqQQBkNRES0CWOxiGkbXx2bmLfJT0THbOLgxD3eGu+sDLnwo2vqg9ruAP?=
 =?us-ascii?Q?zem4PlZeNQrvZQgZvxFNcbxUq3uEyGisVT+KVf01sAJcRylVufJIGYAYYj/V?=
 =?us-ascii?Q?mRjYu4SqMsCkT1Og6axskIQyOCf5cP9ERYhC5sgdzq1g1mAF8kbyIxdmfoZf?=
 =?us-ascii?Q?+kyUik0M7GylL21DlQGvQshaAoxjobwwTpyozWWsM9z0QVt200Jo2Ccalgiz?=
 =?us-ascii?Q?jpMoyUw5ezKCT+mnJfi8Zqmtr+QWU00Vn+ULoeaBxbqHRPatgJVT4akwBWAM?=
 =?us-ascii?Q?n941h12f1FGju72yt173u0K1ameNvJ96cmsCGXMz8u+Vwij06PzJe7nFcNyi?=
 =?us-ascii?Q?GuiZd4OJpbaoSSo/2at1svqTlvE0sTrBgP492YXs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a44b633-93d7-4098-91a8-08dabfebb543
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:40:30.6764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cpg+OPRqKKEw4MiHPq8YfEXPoLoXu0MTGBCReHfxBxXUCBiDGOCh9Dr7GbVqcxts3Lcizh/GU2/uMApuET5jHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_link.h   | 1 +
 include/uapi/linux/neighbour.h | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 153fcb9617f8..4683fead5432 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -559,6 +559,7 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
+	IFLA_BRPORT_MAB,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index a998bf761635..5e67a7eaf4a7 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -52,7 +52,8 @@ enum {
 #define NTF_STICKY	(1 << 6)
 #define NTF_ROUTER	(1 << 7)
 /* Extended flags under NDA_FLAGS_EXT: */
-#define NTF_EXT_MANAGED	(1 << 0)
+#define NTF_EXT_MANAGED		(1 << 0)
+#define NTF_EXT_LOCKED		(1 << 1)
 
 /*
  *	Neighbor Cache Entry States.
@@ -86,6 +87,11 @@ enum {
  * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
  * of a user space control plane, and automatically refreshed so that (if
  * possible) they remain in NUD_REACHABLE state.
+ *
+ * NTF_EXT_LOCKED flagged bridge FDB entries are entries generated by the
+ * bridge in response to a host trying to communicate via a locked bridge port
+ * with MAB enabled. Their purpose is to notify user space that a host requires
+ * authentication.
  */
 
 struct nda_cacheinfo {
-- 
2.37.3

