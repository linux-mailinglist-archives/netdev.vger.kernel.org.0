Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676BE552D1E
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346706AbiFUIft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347795AbiFUIfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2002528D
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQDmybossSZUIIF1coHS4NTkltrok5VG3d3m1jkWh0Dwg29/Axm6m5P0iUaxSB/dvajZFyfjvDi1zsiw6Q7vxPoFkGfYCKJY+Vl7KCsscxhFGdmUvu9/el/ld9VU0aD4zS6475HiCiiaF1k5PdG4MTmcbIg+rq9U84M2x/QI35AE4ok5NUlqK+e0qELVoQZHJnTtr6W3pJfcdZMjksk7oq+shNTmhsrZgPLofMcexOzbgmEsLLMvGQSAgtsLMXRuIz9RempFCLTxmL+tB7pipGQGrvXkuWC1CusdBEF65a6hOAJjP9r3GoDB3mDMr+Oomof0B9nycclClSkY0ExKgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKeRjnWiY5QKYPSKNX+X+mDX7dhAR/AhL/x9hKCGCoo=;
 b=fc9HYbi+IwMtx9Md0v001IMkHf1x/55WvgpLlBqgyqYvZxJpDGDqo3+dCqu8LsseOpLcjAmwWzGIYoeW4pCv5nHBAOarnALTK991fT8rGJ/+is+uhBrb67evRN1Sh0UJSaL5KeeWuoSM1Tn+W72D3QNd9fvfuWIYSIavnqSShwbQPBx8+LBe0El3Zvxyjyo+1+aSDfrGV/YEekMPH/Ca7qFOGPh3oICV2dmIwHcQhVcNjytKCZ2g/TbKP+B/l6P+ZyUGZQXIqsEvqb4odNMaXU1eA+U8bCfYQ0im3xKfdxwMI4AaARQG/DUvIPI6tuTPI9TblnDCB5yci6eBD953AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKeRjnWiY5QKYPSKNX+X+mDX7dhAR/AhL/x9hKCGCoo=;
 b=Tq/FVu9wSzEiP4IpgFYd/x4dgkjLxi7PkhQv/tW3vbgqgp84NDFCcdMBlbpnDUOb3p3SIXksOW2HD9tF6x73xxq0tO5FFD5jeFTuZuVHRuolfJkz/yIbrPuvD5FyDyHyAVco49thq+lu5SaLQztPyI8AgTYDHo4S+wwHXET0Aas8MazNAjc2F33cRro0CDCQdeE9KtGMPOkz1WqonID0g9yK9ATO7tLjoimARN9L6YFpbIUTeH5zgfBI6wXZfnv9faHyt7GAEYCRZFfPpPpR79Ju7oFmecBFs6u2ZM3bOJlhGWNfJxtmhw80p4L+NQPh/ATTf12HUOLxV/gquGjesw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/13] mlxsw: pci: Query resources before and after issuing 'CONFIG_PROFILE' command
Date:   Tue, 21 Jun 2022 11:33:42 +0300
Message-Id: <20220621083345.157664-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0090.eurprd04.prod.outlook.com
 (2603:10a6:803:64::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65fa58f3-6d7c-4fb8-f200-08da5361067f
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832AB6FDF523DBC481A9E0FB2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RoI+nIgI3vyMnG9xq5UX8SR9vjf9aozdQT3L06N9B3XBKlzMtuE8Rl/ZCOXnzmRSmb0Cz88SG7zo8C6Pb3YyP5KHaZxBlgBmd1Ilo7hKHNGSt6rJn9QUpmkJl+mSPX02ei3TJgRWGndJujTZHkw9c+rM6+iGEJVsb1FocMcwUrnSN59+LPCUDbHOTz1m0EU1vqebWiR2rqp0z200HBYxjJdu+OvLSKBIsAuNLZCWTBFgTThiKqOEO5S+EyOSVWXZydgrONY0kCxHRPjDpUZs4Ew4AxDU4urxfFdlHC4mXYsYJmjxWDx3qRbTrNl82pOUAOxJQWkk/wWKvNFCDrmfcCwcU48V3dem8KkqcEbhD0Vr7tYU3O7D1aD59aLIOcvCdF8xWYaxRZqALWLiT6c0xFfbIqp+wUSVAHyU3/smzvK5yZqRtJpvNy+k6tFo6ixwzcYnziZ4CkstZZvBeEed/JzpGyxYgbUraafq/uAA7VqelYUi9GVEKpx9VWRIfWqh8gfTAWpUn1ocTDKwbsOD11FnIBcsUmQE7ipScJPukxN4kJM2Gac+Gx+HcWAErfH2mwZDyy0yD11iOqPF4xtiGEMvIZnN5iR3I5wsn6gTsJMqwmwSjfnutfevj0GJajUCkfrqTkKgY+FLWxR0bFrWlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yqO7w5D511beEB09uQf8Wcd1mT7TJqXGQADdXkROYOU7Jih8p9KmUiC81NDC?=
 =?us-ascii?Q?b/cdhNhLwL5179ADkjxWxX7zebqX8HunBVhhGXGFyeIo+jc/1R7UYYlC08sL?=
 =?us-ascii?Q?dW72VGD4tCXQVjwbR6zoPuHLibz18O+bPTeRNhai7WmXUdeIGA76vsOL4Kuj?=
 =?us-ascii?Q?I7OFndfV8F3YptMiRFhwRPGYCK/7JzFLzHZGa2+c1cDq/yjDKDjbQohSpMVo?=
 =?us-ascii?Q?rdvyLlc4fFO64e/qQxsWb/b32b6ldsNOs3r4kR7XytMoPlAm48QMiXNqPZiU?=
 =?us-ascii?Q?ywwEUajbZS7dX2dj8/kOBBIgDrndkdb2io9KmXWOGZ68k+gC8Oc2S/jNLnJD?=
 =?us-ascii?Q?VwP60CO2v9/Vgzkad+ZJoD7mxVWp1FgUhxw08p5Qoln9k3dX8rvYhqZDY7nA?=
 =?us-ascii?Q?0o+b6L0aMdTLhbx8Fcqb+Z1EJN2uHuFwgtBnR6fK3O9jcNxu7NQY7Hk+RHQU?=
 =?us-ascii?Q?IMgdc7/exUJ3jfPutWRtl4eurjOLDy5qK17Bv3s4zhqUUoQPi4lBOU3H3wS5?=
 =?us-ascii?Q?vv7RnoXTiHt/1elQMADKj2bvj4Brd0OZLI+kVFEIW0XQTZ3KD4598ocG6Ue3?=
 =?us-ascii?Q?5K7PAwnjY3fpx9JXhA3XwZZbpCMqpLHnzlfGyBkZmwn0iQ3XVd+nzqrNJbWH?=
 =?us-ascii?Q?uZu0wcG1cTAVrd8YhW3DWwPWRevP0NQu5HibenhTMRGHOkjToJCAuM+/WmcE?=
 =?us-ascii?Q?4zqkoKz5i7mbHd9U708VchL0Rq1/58UENCegpetnY89OsvB8BabCvp8WZPvk?=
 =?us-ascii?Q?Ddxj3donZGV+4TjsFsCSO/DyjoQbvSb9p0s4lU4dYbYi2a68vqf6fyrP+nhS?=
 =?us-ascii?Q?nRvDesdmJaBal54R/DV1dMX+v4K4ESRFzoK8O1/PaKz0wsIjQsZECqfVks+i?=
 =?us-ascii?Q?S6bPcuDHKiQuOWiPqkTBUe2zU5S/bho3zIYRo5SxVrkzHC8hKuK6Y5TsQJtK?=
 =?us-ascii?Q?Lg5iMNDGC4H5gmbLKtvsDB1VNpPkYu8XIjj1dwL6si8p70gshoGjY3YGnmcL?=
 =?us-ascii?Q?JvemMNXCJktYmVC/8LdlSBM9b4r7gWBMg4h4yuMcYYxdtJYdGmavOW7Dnqkk?=
 =?us-ascii?Q?FrYEXEfmVdtPtf6mFKRqftWngJxtDM8OxNmHO1ho2da5YR9kEMFh92K9HSND?=
 =?us-ascii?Q?cuZX9YgfF0daZev96Mw0L8WZU4IZcldnI3xzDmsYYC0R6I2iyDu+0wrV24/Q?=
 =?us-ascii?Q?z7p1baXd9IFLQxtuEtwUyCOQm29sMW9wf0+u/rBRZkoLdA2ixsiS97pXrUNG?=
 =?us-ascii?Q?4J1VOqSOGuhKB4E6aFFnm6HYwf5w0byiMAH4YB9Rtyyfh6frmnVgVWdoseuE?=
 =?us-ascii?Q?hy57XtQypyccO1y3zq9fC3AFsKjZRUMCYpVsgMKWm89sVCCDbNtJdvjT+i4p?=
 =?us-ascii?Q?yBEUG6UvlOOkoxptqHMkvRH8q21EJpYKRPiwJ0dlytgEDrnb7LscJ6S8nRP/?=
 =?us-ascii?Q?O3t0W4rRNyLVIz7zNowWjmRaNXkEhbTIKJQCG36r3y9f/hlTw+czJyB6Q3ZM?=
 =?us-ascii?Q?8Bdp9RQVAjVoDlSbUbyvkYKItLhraIR4O9/yfhitwRwv4deTdNrDcdkHnSM/?=
 =?us-ascii?Q?WT17wWkKaPqGfD0O/9zu33aGMHqIgZmoRi6dWQmDNVuWN36NFzY5k/MeMNyo?=
 =?us-ascii?Q?aS3MlcnYNExXm+m5o1I7dn/SoNjt1daixf8lpoVEQM0qqXdbuQ4LJJ9b4pm8?=
 =?us-ascii?Q?O82CDuGNxT2vTMFOHF1wkqhzoBGHbyNSe/ULHIinXpDbt2u8ZMKblsQ58GaZ?=
 =?us-ascii?Q?BVuMZozuDQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fa58f3-6d7c-4fb8-f200-08da5361067f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:41.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vee7eQXp2D9ZYYJV1CImWwOS84l3JMhfYwq3CtJGIJUAwxs3Q2yFaRwp2/TthvXFmqmkZTPaAxPqxATYTOG6Fg==
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

Currently, as part of mlxsw_pci_init(), resources are queried from firmware
before issuing the 'CONFIG_PROFILE' command.

There are resources whose size depend on the enablement of the unified
bridge model that is performed via 'CONFIG_PROFILE' command. As a
preparation for unified bridge model, add an additional query after issuing
this command. Both queries are required as KVD sizes are read from
firmware and then are configured as part of 'CONFIG_PROFILE' command.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 8dd2479c7937..4687dabaaf09 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1551,6 +1551,14 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 	if (err)
 		goto err_config_profile;
 
+	/* Some resources depend on unified bridge model, which is configured
+	 * as part of config_profile. Query the resources again to get correct
+	 * values.
+	 */
+	err = mlxsw_core_resources_query(mlxsw_core, mbox, res);
+	if (err)
+		goto err_requery_resources;
+
 	err = mlxsw_pci_aqs_init(mlxsw_pci, mbox);
 	if (err)
 		goto err_aqs_init;
@@ -1568,6 +1576,7 @@ static int mlxsw_pci_init(void *bus_priv, struct mlxsw_core *mlxsw_core,
 err_request_eq_irq:
 	mlxsw_pci_aqs_fini(mlxsw_pci);
 err_aqs_init:
+err_requery_resources:
 err_config_profile:
 err_cqe_v_check:
 err_query_resources:
-- 
2.36.1

