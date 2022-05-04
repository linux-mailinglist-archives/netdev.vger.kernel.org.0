Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A95B51975F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344943AbiEDGeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344957AbiEDGdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:55 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD10BC9
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9GOZAQ5xLU0NjAK2uGaGzPEXSoyRUHd6ZLyhbm8bDjcdDVs6DQGhgyxUYMkVxtzgwKK8meyRwaccZkvyIl9boPX602kOKEg6Wse3K+unpiBRIHPyJrj94Jh8hGjDYtnaAZz1jdiQS9kZrmNPsNadK0Rj3zUoCcpuTn6SNRJZ5ujkoanQuua0Z3WbIQt/y+b1HU1wCwmW/RjvY+g+sfZYgmaq6x4lfQbZZ770LaJOP2Um6TgiFOHd1pgL5MkIKgvbMYkMNNL2l8O7p+LG44Fr4wqv/zLRFlyQme7XYwClFGUJxN82q7h9xh6qIYARN+nm71Ou0sGFCpiqlsLSnsuOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7iYmHo++cieXKSXASv9zo04VvqjrGetILonYHst5xPk=;
 b=jX2iwnhn+PViacY+3om0ErAySF9AxPKMdZXfv9CJUIpYD+1LcRMMhzA7O75juO8QszlH2Z7EiAxnPtpXcj02NV3FGqC8X9BrNaFhBd3wxcEQXp/bk6+zpudW268dpsZSuklL4fhj4tOvIBo1zoJPJn1TRLvu87XgOfT2p5twnSR9e0Qt9VS8/PVN7PkGylXldy/onYA2oqk7nfdFbqEk7DiBD213Bxch1V7YDKH82ue8onlzJXJvYNJhlFVJWIRP9EPLjvus1XwH4QofeztbgveCFwl1i+7WGRVh5h1aqNVLPouWt9CCopIT1HhpdulReTBjMfsSAU4e4VuE+XI7Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7iYmHo++cieXKSXASv9zo04VvqjrGetILonYHst5xPk=;
 b=CGvGw/oSpReIph4bPW8iGcdeySb4e6o+5R+1XAX6KzTNbddtxbU64B8FMZhkNHKwY6E0S0I92o6oBLs7hOss65FUY6eZ+GLzpiKSTD78dDYqxHRisKAQyVl9iiIe/4/Nk94GLp86RX5Gvh2Jpw22cen7hdWx1ohRkLvFdFDYQhfOHtm9LHZbW5wvOwqYtns1zRyhoD+ubNm0YSWsaztuqvuWH9vp2z5euyGF9vPNp8z60mjxYRNuVryfRnE+mvab5zsh44vKuLz/hFiHfWFsadGqG3t9sv4yVvxWoiFbwMgtl/4mqA+eW6hL3lv2BuL+rzkWLUvR6e1I2Wl6qpRMWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:30:16 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:30:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: Treat LLDP packets as control
Date:   Wed,  4 May 2022 09:29:06 +0300
Message-Id: <20220504062909.536194-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
References: <20220504062909.536194-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0255.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::22) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24d7034b-6f79-4b0b-a3ae-08da2d978d4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745C0B2C4991F330F957064B2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZf+4jKtJ7Wmk2DwZzFfOc2jWhCuUBAcLG3793Uqm/MAYwd1ob2Zt3uwkaL1FB8/cv3DskASSc6ZR7HRXWjeJF9N4yOxN6OdsY6eZaCYZxzcuBjAovXKvPqoj4Ggs2S6aYwarLs9Q5fpqZZgFtyIzKCNtSv0JT/8k6mkv99r2AxDHY6WQf8Qu3Wqeg5oe5ReBJ4/7yzf+PDO3t11qLrqV8uM4m4+yNEJigBkKym8dfl18xRv2Tn6kUsVjprv4rHydGuz8V8pw1MV8qZr/suP6lITzpc6ErSFN/QGeaArcXKODPB/PpHTThKDes6hJ0CdxyRcUFmzsl0nGr+YN6xDuCSpZcL8BHgZ3Urtb1ewGQnxQKaHSWDewTrL9typEUNXJKtgJUfF3ZYpgnOJNqkOQhEgs70EX3uGiJQagfJKJLruVLla1F07bUwkeBwr31KtG0s3jc5ITlnS1932MdYPkds3vi3n1sBc8vURJ6kb0J18EpaD4blRHR9eelBVKedadiWLuKb3NN6X+v2aXMobieGyASY8Nxhmw5niNTqLFOt4zcbc/O/7R2hto1ZHosCk2cNnK1sJZYCGzKBBxeVOmMX4v6D6GShEWa3K8VdoykUpWYCeqAGgyK4XQCDQ1qgxbwYUqhRUVCC6TeZkdXCCvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fj4+HlYQERWWQ8GIr5s8ov0hhmXZol8w3/37rkYPaTCupRIQEYpi/C8Yp3cR?=
 =?us-ascii?Q?FdkqDlNJ7Olsabounj3SUfXnsZUUDr8Ub6zRNkPPQbjmOff14ZvT1a4SwDRH?=
 =?us-ascii?Q?+B6Cg3OP1GZGOPA8chw1hLu8umFnP2/Mg50nzD44R2hubolZidXBHdSyxzGU?=
 =?us-ascii?Q?00X3pCvIBISECJI3G0lY4iVoPNjhuwy+7c8w5oKYTrpGW7c37l8zN56nHPK+?=
 =?us-ascii?Q?52ZaR6lSeW3OfXgxahVUsXqMRrVgrQT+TEesGunPWo1qz6G6aPIYlMa1qV+d?=
 =?us-ascii?Q?x2/CUovta1G6b37oVRsTAdeemyMp/UJ6LB9+fquVLEruVz4wxIW81g/Xib3K?=
 =?us-ascii?Q?6D+r2eCce+trCdJsxF+zPucEHQqccPffGsd3Tmfh7Nec5ZBB4CyZq8wRQjAe?=
 =?us-ascii?Q?fbi5gLn38XsYy41nlUg2sLc2noqZefCvfnmJVkInLRYHJU+DCUC6s41W11lB?=
 =?us-ascii?Q?dt0BcUJtXXxEJNlUd3JmBOSp+iJ7aBL+OT2HDEdKKI75oaxLWfvq/K/fB6nB?=
 =?us-ascii?Q?z4cttozViEI89TWOYce0tsc2tSKyEjHMxIHfr98bOxmohYkWYvGnXndNOIgr?=
 =?us-ascii?Q?tq9KNkbYxXxN9eXk56Hif0bneNiUdWE4kpu5s+M4rPpMeqj6vqGUbqZsgoWN?=
 =?us-ascii?Q?lGqZogljIrhzzdIO79m1D8F8Atx5lAx74IKQ26e+3NdBASnFZuvBjgsCqmy/?=
 =?us-ascii?Q?GlS9G3Sm+CvVmaq2KVMOvfcp1WPlMdzKo+9DdSALYU5dpEYzAJott9XL9INQ?=
 =?us-ascii?Q?Wq9u1MJ/a/qp3o3Rww4aJxl8jPmdN/FuE6rqFZIyz0wHtlzQTGBeySNrxMS5?=
 =?us-ascii?Q?HHcjLHd6ikeARCr/VpHwnoN5z2x4jObB7+UjyVJlND54Rd5dV2slBwtLPB9c?=
 =?us-ascii?Q?B2ESzwZ0oFDarXQ2bHTh2dFXGlxK3BfXyARPFzS6XhWWCtIk2J6+1pjZQCMq?=
 =?us-ascii?Q?GTdpfBRltpALn9Gd7v4VM6Y8fbMZH7ioo5e3rx1shtOtTCtdGuNlrg1/vv8q?=
 =?us-ascii?Q?c2WQPFL6145RCS7XZArTY7SZd2Z1mWKmVf9K8310cptNUvGR/Cg0GHGfw0qa?=
 =?us-ascii?Q?Xy0GvYhpk+M17e1Q4gFs/INCv7JgGV6QTlXL3k6UFzNH9cmWhyx96bu8rTWz?=
 =?us-ascii?Q?gabScYcuujwIkQpLG+LPFKEwaA4AXLXRuJEA4HdZEHmL0/lCpbqkJTpA6emr?=
 =?us-ascii?Q?J2STYoZUra9xKs0zkce+yEa7nn07SqTzeb0VMxMHpgydRaMHIi34GzuArFcP?=
 =?us-ascii?Q?9R5Bf7enTPjvxyVGOfMxC3XvWrj/ms4ReF4F9R05CYjh8+gVhgzuBwlvcrAl?=
 =?us-ascii?Q?6yky1nic/5SKX5fq30h/evQ9hIXdCdTTB2sdm4XlvVdEiKDbAXWxP3X0yNmx?=
 =?us-ascii?Q?HE2rIs4Pb6SZ4+0m1YsR4Yy6mcAqdaMaefZOgyfkEcKQzgv0MoA/frvZJEYu?=
 =?us-ascii?Q?WgqXu45kcl61i8dsRMQHbdWumpFkG34NrzV/5nP9d+gQSrLgOZIeReQCx3zj?=
 =?us-ascii?Q?3JEfrZFly5Naz7RUgY+8DFga/relsXi+sUoobA/I20ITGF8fUJ+/gWv7sRIL?=
 =?us-ascii?Q?BJ3xeknEVvMKpdjO1t/x3Wb4HVR31zVMGxvwNJ6j0wiKxiaT5r/taeAlZ01J?=
 =?us-ascii?Q?SGyHimZ3I7hSw2W8EOjftFeMI/b1GhiuLgIiXY31rZuhhrd8FDXTyx9qm/J8?=
 =?us-ascii?Q?rUIoOfaTvfVf8RHcVQTMoIwQ/YKW1vWuZw+RfNNSebepdnAlSxHAxPh0xpTp?=
 =?us-ascii?Q?VsV/mC4HUA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d7034b-6f79-4b0b-a3ae-08da2d978d4a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:30:16.0918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYjFOM0+RG0TRF2FMRtcKbKgEZwM348U3BfVISHkwU0my+jCDBZFTA8OYmpxAVQc6KSMFEVRBP/z6sK1f3haPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

When trapping packets for on-CPU processing, Spectrum machines
differentiate between control and non-control traps. Traffic trapped
through non-control traps is treated as data and kept in shared buffer in
pools 0-4. Traffic trapped through control traps is kept in the dedicated
control buffer 9. The advantage of marking traps as control is that
pressure in the data plane does not prevent the control traffic to be
processed.

When the LLDP trap was introduced, it was marked as a control trap. But
then in commit aed4b5721143 ("mlxsw: spectrum: PTP: Hook into packet
receive path"), PTP traps were introduced. Because Ethernet-encapsulated
PTP packets look to the Spectrum-1 ASIC as LLDP traffic and are trapped
under the LLDP trap, this trap was reconfigured as non-control, in sync
with the PTP traps.

There is however no requirement that PTP traffic be handled as data.
Besides, the usual encapsulation for PTP traffic is UDP, not bare Ethernet,
and that is in deployments that even need PTP, which is far less common
than LLDP. This is reflected by the default policer, which was not bumped
up to the 19Kpps / 24Kpps that is the expected load of a PTP-enabled
Spectrum-1 switch.

Marking of LLDP trap as non-control was therefore probably misguided. In
this patch, change it back to control.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 47b061b99160..ed4d0d3448f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -864,7 +864,7 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 		.trap = MLXSW_SP_TRAP_CONTROL(LLDP, LLDP, TRAP),
 		.listeners_arr = {
 			MLXSW_RXL(mlxsw_sp_rx_ptp_listener, LLDP, TRAP_TO_CPU,
-				  false, SP_LLDP, DISCARD),
+				  true, SP_LLDP, DISCARD),
 		},
 	},
 	{
-- 
2.35.1

