Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4641552D19
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347674AbiFUIfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347518AbiFUIfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:25 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F2B24BF7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeGTW1UtW32FsoFUSXtuq/I2Y7q12Y37bgOftxbLcu4lvLi1T0pxkQba/JcnO9c6pz2wTgYJq+SGTlSO++5u4KINXpTtBl980ALvVw118jrym4rgm3Y9jpi9FaTeOBHDKVtceG8DBBuMiow3gpgyuMk53ShHKfgjQ0qzdmAbtWHLkbLGVLmDLmpF3j9EM4uL8QtzEC9ndSXnra0LLVzlqHRCjigxwex82k/FyYYG1xK9aE9a15bZlf9i0LHp/7N4Bh9YDm7+tV62P16eCSX1IW2r3+jbDAGk5czSUe3agXJoD3EcnE+0mu3HTBLMz1SrLyO4gzCNkqGmtreb0k5gpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZEfjnw4bImrzx1A2DPiZ55gvcmPK0efktLgU4IAY+0=;
 b=TpEwnP5Kf9gSMpNzPYxhqeLhWhQ6to05rTAvZrcT1MJp51i/AqiDRFK8+aqDqgZpfELcWDivL3nR1VRaQlpgrBBZuhVFW0VBLTKGuRflETRtW8OgLdLKzkyAt431olEpuR7YZ9uOxMrF8D4vNV3ktwspv5FPWd95EJhD/KEsVjtT47qjO/cAJNPm3FPd49fvzDU0iHr6571tKWmI4Hwf/9BYH4osg7S1uO0VA0jQRHDaVDIEm2JjFm4NKEgBVAs3LosugTviTJcsiVEPG+fMPXtZ45Vtl3xK/0CWkE5pfCh4k/QvdOLP/SO2vP9HyIGwTtSaJciwX6phr3/duea4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZEfjnw4bImrzx1A2DPiZ55gvcmPK0efktLgU4IAY+0=;
 b=n60A8Qg9c74lSAnu5xXDwPgwADK0kN+H0PpwpHR8nqQGKVCM8/P1Z9mc5LcXzdJxTyvF/Uuwt792Ni4ldbpQ0wkfz7Aod68bDZBfrD38wNQ4jdEWXI5c0+qkJ/BwGiJnMBin86ZOldCZvJpIeiIXNR8Q8KwGnVvh2mSqxMbQf6G5X4Pv3ldnAKoKVt5I2G8sZP1XkbyUwkRMwhkp7Puru1IlEEJJuit3M64OJSCVebfzpCOtK3iluLJc8WIJje24GOZYU8TzNASJTS8qk73Atn6W+9nkn3ascFH+GCqe1sMovHvJQukUubv7oIIrlydxAWN7IAdGJKGk9F9rI7/jlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:23 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/13] mlxsw: spectrum_switchdev: Handle error in mlxsw_sp_bridge_mdb_mc_enable_sync()
Date:   Tue, 21 Jun 2022 11:33:39 +0300
Message-Id: <20220621083345.157664-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3c13896-b699-456b-f919-08da5360fb99
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832000923B2A2C9EF191A00B2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kzOlZ0akm7oA/f0GEtahgtl7tV6A9fFdKm2oLcDML6nkgrZTvvb+Kmb70Xmv6RaPtbQF9iLEQrbEA2EeA17HQS2y41Faj/PNOwsI7v0iypy5vKtGTr99f6mbRvozoNtTG/Jsy8oa32So5Gf8CjHSv3OFDDnSUGV1b6z2BfFGVuCpu60SZHQl/o50lfXFjpiTXXXp/y5rSPi/80j8DlDtBxbzxYdu2mOwmpet80IpTwmluAYVH0+OgHq+BTtORuyW/2RmDvG9PRYISGhzuFJcsGEIL4+xl7OxL4oDkYS4nk4uqV797W1ud+4+/bBS0FUXA6W+GijQGgkf0Ox1YX+HKg+R9gFM+XRFeYnSwCKnQMigvTBx+C8g/xjmLmqNQ6Gv8vSCVWgUxpxusa7IqieQh81OT3/Vt+LWOVDXvfOB3V2rSFV5P0rAA7VHBVnuyPeORo2tNBo7U0XjyFuSplap0STPKnN6CgHErMeLXwoZaUfJ+2W6aHUs/DmTzPPwxQNkHLou/s2PfKkSRCh28DRDDeGdYwFWBO8j9TvV7tPbKMXsD4/tx/DaAyxfAiO/NatCFppRRYnWItZXhN0B7C3OgJccfSWTBTJ/2tEJU9bMQFiyEkd3Wqxazurp+3p+prQ+nDxyu3fA48unMhKzbTLl2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xw3iYzz1QduPz0a0Nf9f9W3WiIk8qlaV6NF4F7skk71fndAxvE1Nr1QaQDT4?=
 =?us-ascii?Q?0GYTUVEam0LYmKOpxLxjhC5IUYn8gVrSx9ZY4lDxT/Mmu66Ss6gOPHtDOt+t?=
 =?us-ascii?Q?DrgnDv/hlWDXHN6l8QaTD6gImNHo/wCM/dfGct0gXFpC8v1Af0D5xjokVLT+?=
 =?us-ascii?Q?drSnZ8P/D8SzWgIEVPytqN8sOeKOl1BGA+sFiOJVfElQ67igPnqzS4ku5Qc8?=
 =?us-ascii?Q?G7toy6zIChUfuAN/HJy+s6BmoLgrrlw77TaQ4viUKtwN3LTxaN/U8h8mQOu/?=
 =?us-ascii?Q?aLwTObVFu4nv+mnCCNSSyiyy04sIYRexjZVeVvIDyxZAP4hBbG6GnivQ2grD?=
 =?us-ascii?Q?KKRHUCyG96jeuuMDYKN16SZxZ7/+6fkYrv4bX5owgxGiaN4aCRHUqeqBdhpT?=
 =?us-ascii?Q?FReJtf5CZpe9WXLRUmAlJtMyz5NiV8F34gBDeYX9kQu5p8m2qck52fSmMrpC?=
 =?us-ascii?Q?uNTdUEOv3VBO6r/3l9zPMndRSAEhKYaqiLkl6AR9Q1O4QDgm0fdXdWk8ga5c?=
 =?us-ascii?Q?BxDypUn/Q1ZE2nKPpubYBS+ojItihsNTBsfEeNCu4aj3POQqlMUErtQWylsV?=
 =?us-ascii?Q?jBQ2O3s3JZJ6AFabjMAmZWptb+7DMNI4+E/yDfCjY9gzbMGqDf7La0p2Ab/F?=
 =?us-ascii?Q?K5mnKKXa9yaYfyZgC5JVlZI+rsCda2Vu3Yx6ieq5IAXw2N8KZ9rTjIlNotYf?=
 =?us-ascii?Q?sGL5lVF/D2MqGTglb0Un950cokqhHYJyYABQOEfSpY5MzW3CTVra/c4wjwd8?=
 =?us-ascii?Q?shvoKQfXPiChQHFz9Ne8E+3UV3D30fCut4GLrKNXmUIG8pGb3dGyJmUqOr93?=
 =?us-ascii?Q?a21evpY/atj0pVZfc35o+Arkk2ULVkJWFZvzkB2kyyR3gNJkIg9iY92II3Kv?=
 =?us-ascii?Q?95dXAO2LN0zJiXfNha43B3CIgx+i76pzvAugtKVJh2ffK0Wiifnls8fZzbkh?=
 =?us-ascii?Q?+IooNlUY78IDDtWbICYT9yjhqKYyACuCdC5Flfg2KqlAg+4C666YmEVwtx6f?=
 =?us-ascii?Q?N3hy8M5l2kdxDEUz0+H/UEuOiUVFllt7xL2vUvZltkbT3KUz3D2LWSLz6F/E?=
 =?us-ascii?Q?09W64zsIPhPTvm+EgTGMWLmTe0CBIzLZ+JPb2T0AIQxLXUh7lKfFSeNlS+2g?=
 =?us-ascii?Q?Z0mjTHfT/oOHiiop5kMAjcIl7KdEiv/FaZd2U5D8D1O7tomQARpmZ8eJ7rCt?=
 =?us-ascii?Q?UBk0bxFDgMajImVggimshwJkh3kvBIE3JZZ8Fq8NoucAUYQJKpJcD1o303DP?=
 =?us-ascii?Q?JCi4U4soBm/WWD54NJyCjo/hZ8DID7erPRP8ESZqgs0jXpGbAg23SUdAh0NF?=
 =?us-ascii?Q?jZX4YedDASElvfa4xEGRdB4CnY/AJIConbcu0JsVcTezeIPcK256MrU/KLGo?=
 =?us-ascii?Q?6xIIAymqnFr00LlFiebHDFqlDx5mcrRy9/2+YOd6qufrNNDD+Ms42Glz/G9m?=
 =?us-ascii?Q?t/rCFntACTkx9MZtXWWLTOHySeF5kWAZk6bx2FJ2ITaqIL17/4NdIHV6gjnB?=
 =?us-ascii?Q?fUFDL0BwUPmLoudd7rhSS/9an3gThc/bweDsky7syCmFoh982aRy3zlCluoO?=
 =?us-ascii?Q?SW9A3/Ge6XpSc6l1zHLt/nvcDkpPLe5PxnuZQSQ1aZolwC/XFQgoU61Xut2J?=
 =?us-ascii?Q?9wocPYIUW85EHWMnxg2U/ip25ZAwA6Jp8tS9pOjNhdEz8nUvnYcVJmmHKPrY?=
 =?us-ascii?Q?BwiJaZaATYWdt9ZBqQQA2imhXeSWytpnHEy5RqERjqFUI//jd+a5DARU85YK?=
 =?us-ascii?Q?1uKKmlHuPQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c13896-b699-456b-f919-08da5360fb99
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:23.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rMDmJxf5CKnhbI5BZVSDjDwVf6qaPgYFqJGcPIV+WjPqdGC4EcKsADeO7SRaR8ZK69Zs38aFSNl1QPVhIpgMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The above mentioned function calls two functions which return values, but
it ignores them.

Check if the return value is an error, handle it in such case and return
an error back to the caller.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 43 +++++++++++++------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 9043c6cdae89..863c8055746b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -111,10 +111,10 @@ static void
 mlxsw_sp_bridge_port_mdb_flush(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct mlxsw_sp_bridge_port *bridge_port);
 
-static void
+static int
 mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_bridge_device
-				   *bridge_device);
+				   *bridge_device, bool mc_enabled);
 
 static void
 mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -917,7 +917,10 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		return 0;
 
 	bridge_device->multicast_enabled = !mc_disabled;
-	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
+	err = mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device,
+						 !mc_disabled);
+	if (err)
+		goto err_mc_enable_sync;
 
 	list_for_each_entry(bridge_port, &bridge_device->ports_list, list) {
 		bool member = mlxsw_sp_mc_flood(bridge_port);
@@ -939,9 +942,10 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_bridge_ports_flood_table_set(bridge_port, packet_type,
 						      !member);
 	}
-
+	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device,
+					   mc_disabled);
+err_mc_enable_sync:
 	bridge_device->multicast_enabled = mc_disabled;
-	mlxsw_sp_bridge_mdb_mc_enable_sync(mlxsw_sp, bridge_device);
 	return err;
 }
 
@@ -1911,22 +1915,37 @@ static int mlxsw_sp_port_mdb_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err;
 }
 
-static void
+static int
 mlxsw_sp_bridge_mdb_mc_enable_sync(struct mlxsw_sp *mlxsw_sp,
-				   struct mlxsw_sp_bridge_device *bridge_device)
+				   struct mlxsw_sp_bridge_device *bridge_device,
+				   bool mc_enabled)
 {
 	struct mlxsw_sp_mid *mid;
-	bool mc_enabled;
-
-	mc_enabled = bridge_device->multicast_enabled;
+	int err;
 
 	list_for_each_entry(mid, &bridge_device->mids_list, list) {
 		if (mc_enabled)
-			mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid,
-						    bridge_device);
+			err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid,
+							  bridge_device);
 		else
+			err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
+
+		if (err)
+			goto err_mdb_entry_update;
+	}
+
+	return 0;
+
+err_mdb_entry_update:
+	list_for_each_entry_continue_reverse(mid, &bridge_device->mids_list,
+					     list) {
+		if (mc_enabled)
 			mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
+		else
+			mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid,
+						    bridge_device);
 	}
+	return err;
 }
 
 static void
-- 
2.36.1

