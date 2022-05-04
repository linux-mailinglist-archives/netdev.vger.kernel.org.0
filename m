Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A02E519763
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344960AbiEDGe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345009AbiEDGeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:34:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F752CFD
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcH2r4wRuq/i/HEsczYWgf4GkGWc1JlRJMsJWaKYqF5SCOwqxFz5EjvUGAvAVPj1Gl0Yh03LXSmZM+HM2SS8lmf1ZBP/xCS5cKG3u2q6T3gMa3rmxmTh2XFv47/7h9YQ7zghx/+O9fVgWjTznBYAGDudClJbprttdqFhyixBbEja0AgF1DGcn8dINWUAbi6eACd4clZI1O7RiQGvyO6Dd60funWIs5HZ+FoexP0CO8j45K25ArZmYonVYGESoUkxJ6SSozyX1gt+uAf3yzezGbodIWVjIL0POk3Z56jSd75VQumSio2GqEFGU74C4I21Far6mCxXo0ClVNbnqit+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GEODRA0nc7em+vBRKfa8MuQds1NFcFxr9P/Wh9BUJhE=;
 b=YeEgCB7y9czDnyhIlVsmr8NPz4pbxg8gX8wSyIHBY7unLMWoL65xfV1Ql+reZXqlHkEb5BrL26zp+/tE3yb0EdUPs1m27ZdVyoGuMW359Pq7tuhfVocFoIperihUnQuMftE+pxqM69rozvoiwxNHmw0rbujCHvd+zDRrTGoqOR4AVRO7bGCllh6IgQyqwviLR05Vw+ttk97UpFUObo6fNn9jDU1YqD2nKIPb/gzK6QWYx2eN5E67BnSy+IbzSDAoggRYqrKMC735S5E7BQzHNKu+aaywm7ol5WlL+upuH5akctsoo764Pg9w+iLjicSlwzyFFapojhoWYykG3DxcvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEODRA0nc7em+vBRKfa8MuQds1NFcFxr9P/Wh9BUJhE=;
 b=ZDNw1rL52+NaRyCN9RH4DwZZOZhJzqVkq8izCYATyyChRf5Il4le6g5fI/TGEakmentYzCZ7nIM0kGVExZ3G/diExoh3kgnjglcqiZEK15x+97byA4otaw8WTgJTBkJ/+CX4R/mpqO9qTSJUyMRLSRpPdqP8i1mCKlkiDUwO8SXJ5oJ8Xjpvt/SlXImTjE+LxE+8gdsKiKscKe4bO2wGn0WPmgLhUXyRHO3kFA45gl3z7L07MGm1QBhb43Wi/BS1I/TNROOolso+DxVVRy7Oi0cGmbG63WAXA3q6SALJ9YBA09MKYLpP+vqS1rOoAjHjB/ByCXeoDHMgeVYACYW4RQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN6PR1201MB0129.namprd12.prod.outlook.com (2603:10b6:405:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 06:30:34 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: spectrum_router: Only query neighbour activity when necessary
Date:   Wed,  4 May 2022 09:29:09 +0300
Message-Id: <20220504062909.536194-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0222.eurprd07.prod.outlook.com
 (2603:10a6:802:58::25) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bad7318-c5bf-4b7a-879a-08da2d9797f6
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0129:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB012906234CDC52D43B89FE9DB2C39@BN6PR1201MB0129.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNyomV92vetlQLPNdlfmQ93Dv3+cRDY0u5Ob+MLo4oRZ/+OFxDhAKl4alQz6S9ux4Zdii5r6U+zMqj2WgX2cF5tjiIgTVzA0tp7F8R1wTDhQaT0CB9ixnnWz5sqif4c1pfeXkXhxjA+mWbZBQlwXlH9p5NnhmMEKH7b/guOmFEWGCcNP0xh1W2WrrUS+luBD6VqWcR0Q6W0Bf+WoodDoQt0qTQDSmUJ1Oa+E9ddptngHy057+pWLJZ5dv+uTRPQt7VhLShv9aYmeYhrXym5wffhc33eaYujWByw7KDcPS9h7yWlyiv9EEK6rkKviYCNqpDUBZrI7ytorP991uE3bUslKwssnEiID+huZ95tvwKM1sKJBVJ5zZdsZV/IE6iKOhJ1qxYMljlpc+DiaklyDC1c2ZUKVbHu2Gwk2tB/2tqy4Vo+Sb70yQ/vT4NYz6E4FFZxF6JYlW/II/jfMrwbS1XUurKcHirBGbmGd5WqJJ0LDh/K6rCappckZf1LIOK9szHCZjkmi/twrEXQlxw/M+i6Jn2V2MEvrPq2PYJj3gwsDS/bEWw1MFovs1aPJBjS3IHy1N53aBR7tlizOtHM+a3s6MZlWjnzu7YU90iWQdQatSnNXpKT4Oc1IKBE0Lb6DBdkEPOJk00rlJP2it+aWLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6916009)(2616005)(316002)(86362001)(6506007)(6512007)(83380400001)(5660300002)(8936002)(186003)(1076003)(2906002)(66574015)(107886003)(4326008)(66946007)(36756003)(8676002)(66476007)(66556008)(6486002)(38100700002)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OBCplj2TkVLjN/OMbQ8Dw0BW70r0rlq+/AQ09qwubf+duyMjNgc+miBu1hez?=
 =?us-ascii?Q?9R+k20qAL+aZ0VL4EzPQ18iPITr5vT3abO1WHryBgXFfzZFwy6qQq22BPNZT?=
 =?us-ascii?Q?zrh6yOX/O8560lNUBzn/NZ4jrXAkdugdMmEYRnW3h53LEwS0IqC0kPgeVyZM?=
 =?us-ascii?Q?2DEtpIfLbtbXsFaxv1AGkCI3SaSIVJ0ruRNlYVLXPrzhTLJBmnfUHyzzt8uK?=
 =?us-ascii?Q?Je6pd8e5pD3wevvMMYEu8oHlGVjb4kdOsMAWkwDClr0oMtKPu6cIGsmjj/G4?=
 =?us-ascii?Q?JEhNYqOQqa30vO8xpqgs+WpcWI922kGsxA4wjG/LzRcpUoVPuYdfjiRXNVRY?=
 =?us-ascii?Q?g8+0BPMRP3ZNY9YJCZpOKoSpchWzrHjWxEgvp9ujAYgEiRsN2Mq1YnvbJ0Ot?=
 =?us-ascii?Q?kyzMJW4YtbnhL9oOVvu4rYFu1R92wLQ8a7UM4w+DtV89E07trGk/pw5oh87Q?=
 =?us-ascii?Q?mibu8QZ10mazNIDtK3BFFRGrqlGJ/omwyvF9BqRCz5BvgTY7LvixeWvPg/Lu?=
 =?us-ascii?Q?2uvuh24K9KrXbtRbNbTHGSAMj7zZ1fZP0jrd+w322/crl0AVSwiQMdQ7posw?=
 =?us-ascii?Q?zGlQ0hB6bkG5YnEuaDjZ0Sb1GJCT5CjQOWvxRZqJ7v+QhcXrgFeIkMIAJoRF?=
 =?us-ascii?Q?4hahC8MdOciHSHJs1LM9gFAIVq6O2etc1ckb9WOMZb1AgZw8gjqrENV1RNKa?=
 =?us-ascii?Q?DvmfxCnKMYh57oJ9CTGXPGooLxl2SQjxzhp+8iCR3bhyFxcPd2Ccv70CCpdj?=
 =?us-ascii?Q?mXAo3arFQdpFmt2687Wd1G8EBLBd/T1RF5LPQMqt8MPfZeFxKzDGV5NyE/ls?=
 =?us-ascii?Q?sOJ2FYms9hJJJeKdauhe65bYtjKHmXwUhHVGXcPD42s5ToQyzM/Wb+wLHEOp?=
 =?us-ascii?Q?d5sGgZHQ5+v8ovhgduzZ7mp23RIPd+PZdQA4j58LVrgYzOPvPFo/bJsrLU2z?=
 =?us-ascii?Q?5jRuqS9WwgjWvs3dB5TrXCwPMh+t3ukz6MhOA0sdClYe18vn0FuxFIXaoGcx?=
 =?us-ascii?Q?79N63WJeZj4POk7kEgN2a4eOUGAUqWwJbNkUL53oczy5UYVQ010+7u4GGWBP?=
 =?us-ascii?Q?J0m4+sPIe2cOXOy+31dhJFnVFV3T3aw8RJxqFsBlYDkz4IRi3Ic+TqRI/2vM?=
 =?us-ascii?Q?Iz8JaQF28s+PqaSPQ2xdNVqvEcoQqe6c/C0yPYl5g5wc2ibgs12qSRc/54vt?=
 =?us-ascii?Q?LjQkViUKzzJMMt6hmpcNxH/eUuQgbXMPH+qCPlnwiSiL3nV18cS+Vgk1tpQ1?=
 =?us-ascii?Q?G+op5NkWvL24rkVIlMMFDwYZw0yz8B37olwcmrd1AlK5f7/QCf/umk1qForf?=
 =?us-ascii?Q?SOCUT7lMsrmfZKP5ti0RqShPglKReEYKVytX59QLbEyyyx/STafRu3Df+xhU?=
 =?us-ascii?Q?5W/0hNviCp+qWL35qfwIjP8feHsXENnRqMc3dz/uKH2HMerWjQ3oqWFmjp86?=
 =?us-ascii?Q?MSrm9heqAkIL47E4IIYtKRgqLJ13I+dkyp61DJd860j0FJXXQ5ZfN9G9hzQK?=
 =?us-ascii?Q?q65qsNkz4Xypv9SOVQXWHZu3LnB9Mx6cWGkLaMrCbxgAJASTNPfSjBpqClpd?=
 =?us-ascii?Q?tgNV5197OPXbDswk9bJ190UtrI7IKDAzR8R5ye7KWf1tC0aIx29+b9Wk9EwO?=
 =?us-ascii?Q?aYf6I4Idn0ig91iPH/rl5+GiZgBNcEBU7hPnfYc+AnfsFFrQ4kwBAA5dWrsz?=
 =?us-ascii?Q?2rLTtMCbyxh/nnPgRlGQc7hpf4PoUA3v/te1rPF2d0xjoygqNd6l0FJgsNoc?=
 =?us-ascii?Q?+k+/JvNP2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bad7318-c5bf-4b7a-879a-08da2d9797f6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:34.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Owb6IQunhYBi9wE6ImEZnHU1koK5TmmMw/fv0C7elzvHG78D8EJc576SjReToK9Ypb9o7/ZPvr64JXNM9fwvxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0129
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver periodically queries the device for activity of neighbour
entries in order to report it to the kernel's neighbour table.

Avoid unnecessary activity query when no neighbours are installed. Use
an atomic variable to track the number of neighbours, as it is read
without any locks.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index dc820d9f2696..9ac4f3c00349 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2360,6 +2360,7 @@ mlxsw_sp_neigh_entry_create(struct mlxsw_sp *mlxsw_sp, struct neighbour *n)
 		goto err_neigh_entry_insert;
 
 	mlxsw_sp_neigh_counter_alloc(mlxsw_sp, neigh_entry);
+	atomic_inc(&mlxsw_sp->router->neighs_update.neigh_count);
 	list_add(&neigh_entry->rif_list_node, &rif->neigh_list);
 
 	return neigh_entry;
@@ -2374,6 +2375,7 @@ mlxsw_sp_neigh_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 			     struct mlxsw_sp_neigh_entry *neigh_entry)
 {
 	list_del(&neigh_entry->rif_list_node);
+	atomic_dec(&mlxsw_sp->router->neighs_update.neigh_count);
 	mlxsw_sp_neigh_counter_free(mlxsw_sp, neigh_entry);
 	mlxsw_sp_neigh_entry_remove(mlxsw_sp, neigh_entry);
 	mlxsw_sp_neigh_entry_free(neigh_entry);
@@ -2571,6 +2573,9 @@ static int mlxsw_sp_router_neighs_update_rauhtd(struct mlxsw_sp *mlxsw_sp)
 	char *rauhtd_pl;
 	int err;
 
+	if (!atomic_read(&mlxsw_sp->router->neighs_update.neigh_count))
+		return 0;
+
 	rauhtd_pl = kmalloc(MLXSW_REG_RAUHTD_LEN, GFP_KERNEL);
 	if (!rauhtd_pl)
 		return -ENOMEM;
@@ -2950,6 +2955,7 @@ static int mlxsw_sp_neigh_init(struct mlxsw_sp *mlxsw_sp)
 			  mlxsw_sp_router_neighs_update_work);
 	INIT_DELAYED_WORK(&mlxsw_sp->router->nexthop_probe_dw,
 			  mlxsw_sp_router_probe_unresolved_nexthops);
+	atomic_set(&mlxsw_sp->router->neighs_update.neigh_count, 0);
 	mlxsw_core_schedule_dw(&mlxsw_sp->router->neighs_update.dw, 0);
 	mlxsw_core_schedule_dw(&mlxsw_sp->router->nexthop_probe_dw, 0);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index fa829658a11b..6e704d807a78 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -56,6 +56,7 @@ struct mlxsw_sp_router {
 	struct {
 		struct delayed_work dw;
 		unsigned long interval;	/* ms */
+		atomic_t neigh_count;
 	} neighs_update;
 	struct delayed_work nexthop_probe_dw;
 #define MLXSW_SP_UNRESOLVED_NH_PROBE_INTERVAL 5000 /* ms */
-- 
2.35.1

