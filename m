Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61068504CDC
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiDRGrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbiDRGqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:53 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CB613DF4
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pgmbbop3Jfbw1ym1HnEsOIP/5T8/jiv3Mf4AxGEk2yp4VcoDdUy+1bFbXuTx+n8YZV2fZR/huzJntiYwolM8GF5RzCym1w9EKeSypNnW+soi9NqD8bIyDcFqTsaxRJX2tnryh/KXquxbRJ3KxBs/lMm4WmRNMcFX2mDgP7tbdZoJmWWV/G9f1I4wOFHYTczMAcu1dBvfKJ3p9RPdgtcO5nLlS3Fqtp6j+tFOEU8A97/8KW0REVMYoaRGgTlGPS+Kl01H+Qct41iZVE+aJDL9zS3OSGdNaRpY/0cQ/MK0yVgR706NgpbQUuSHFt/YTEelPsfLVWMCX8peqzE86TT6vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DO/05PdJTmCA28Zrr9BHcfQha4/XLIGxx4HOlw1IE/o=;
 b=HStDZugfmcuVW1IUE1IBP/xuSI/YDR8QVIprYkXPWInLixgMRlmCGNNd38jeiAveA1M7vvz8VovBu7wcTKZ++evoEYrppevKYweqPV2upwqwBh2eT0LvR3ci/20oNyKcsSAsI6sZoEVsQvl1TjKjDPzumhhkCi7sSzm/Pf4OaHTIacqF8bQuh00zB+JdvHwuV0DPxjhxZcZ/Z1dxZxycxQwEQVz6dDuTZz3FDzaqmvjKk43k0ZXaLT+7ov0rGZWcn07Fn3q6RV41HWG7uAPXVoqCt/QGiJi6CHdEGis/DDxcwCVGP24MQ08DAkO8dCCHk+C56gT+5hbgTWo2O5FILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DO/05PdJTmCA28Zrr9BHcfQha4/XLIGxx4HOlw1IE/o=;
 b=suqBU8Ka6Czll5fbmI89d4Ai0zHahDheajyLd8JBj0jl1TaBCPcXWMwPwambkSs7whjD5zmesqm3bz5T8yrCJ6V/XZWUvKfAeQwdB1AYsLPMbrolAgEERKzQV3xdG8JFFgJO1BWEnsGoAXa3f8+LOzXeHJF8L4mZ3idm6PlI+kG4bCCLokeMJORJuEGy0xqSYhHbPl1w4bPs2mcvqKWRowWuezdHmYFE6HvXZphe9bbRa0TbUf+eHCIl8aaD5+kclmwK4YCgS3l6Mds4lxMsQskT1Pi7PZXZuPK1gC+447AZi5s9F1kArb1eeUzXffuT7SJCbyIXozd/UOPxBE0OOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:11 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/17] mlxsw: Narrow the critical section of devl_lock during ports creation/removal
Date:   Mon, 18 Apr 2022 09:42:32 +0300
Message-Id: <20220418064241.2925668-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0061.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::12) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc57eaca-ab6f-48f4-1fe9-08da2106d861
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3664CAD934C75C271012BE88B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P+nqn1wxJ4/XkjUnojpF8byKI54vefb6AR8d3eTqVDjpeUDRwSvIv6r06pu4GcHBSEmh+CfkbEpxdOCgvHPiRHZkW2v823M5Pm+V0mwCcDUXdpd2pZ/INCmZuNzZwgGRucspEyc+16+TvbOccBl7PjGvdEU5Y0ajprhii+Rkgzgt8lu9ZiM1C3Opgi/5WHD/xC9RiKEZD9Qep6DjtRmdmGYvQ2HpXnWrZJDfM/WjwNgAtC1k8VQ5pFF7+NKiQMVdB/wqdkqs/h4QMSxTiw+pFRcdQWKU+xe673GIhgk1/QICLzZ9RqsBaQMGzr/YSH13VjLOLOEAQ8qlrtQoKoLPEwgB0wLTbZNRZz5lFkwVCL9cfTLKvblfy9XtMpwU3dVwqxohHuW3qTbvd4HdFPKXL+PPhCfJYWfv1lBF5HyXwxrx9w7OYoDtE4huBAgjEu+0QBZLbr2SiqBsPPWNFSAvmEeCXi+8GZa53KwK0RfEnp+QDWCCacRLbyWg8wSxLcmEuqvB5SWd6cjZ7a6x6XYzzRRhz/Zo2jTvBgD5CtFcTvYJNpG6WPw7ux817Gh3t3CaxosvDUY2CSzNYWDW//rnE1bC3/AcR335FACf1yhbbIej3tacLX43QN/ce3XnV5+6UaPOt1IFjNwRQsYIW8lNmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bfz3HD1QEdF0KFjLjbLxQ2cvzNEOdqZ75xAUXx3X4Y/qWOd4SvtSydUw9q7C?=
 =?us-ascii?Q?EcLQFFPSu2fBRu3aqB40pBfau8kPH41mgMmMIcudPX4XknAMXwl8S5J26EJC?=
 =?us-ascii?Q?fJpcIAKNzfohYhHnd7S5Z/Tt2XGY4yxV/Of2jLnL/KTyHGKjbhERn29gAKEu?=
 =?us-ascii?Q?A3OXTcFw2qJwWbLDVxOB0AJLc3YzR3RuMEqcF+xOxXcv8ngUoBZG+MXi1rEm?=
 =?us-ascii?Q?oIHQarG0A7S3ITPdabeWyPF1IYLQdSAPW1LHqn/JLm4o1YLISrieEHMl4XIR?=
 =?us-ascii?Q?fnw0wAQXW0kr01gVbJhegD7S3pNx5ERDCMRfA7KFwJ2j5VIaq8mfOMMAYoI4?=
 =?us-ascii?Q?V/Ol9iPvGTfOcbCgqtv4nyQXYVLdUcOAZ9VYQDepiqlxnSjah5KOOM9Z60G0?=
 =?us-ascii?Q?Jfh57HvLKLH0oSUh2W5BIdXQIl+oYtVEHUBdhCaYY8swnMlqBis1PkGhHDf3?=
 =?us-ascii?Q?WfnrCeeT/4bHkE/84A3KH95wn/7wLmU3WLGPIldb5j9TaJVDdQDLD9T01iDR?=
 =?us-ascii?Q?HjoUmpA4UOr89G1IPwUb4CQojRHOp9PYy2v7Gb7mzt3CcToXB/l7SMdQ1i89?=
 =?us-ascii?Q?JBc9B1qghuRDLY+PYWkbdAoyGAYKZxe/3UvgvJJJvbpcyLsrKdpk34vl0bVq?=
 =?us-ascii?Q?3KIgH9bU1DGy8ZjjwqRtDGsTUXLDDaA8aAHE2W80HshjYAIDqagXOc6cKkvx?=
 =?us-ascii?Q?WGgqiKNYV1EfemOdlOXAbKhGcTVBlIvl281Jm+8ooJtKJkFVs2w0y7Y9h1je?=
 =?us-ascii?Q?5BGzDP+kwFC0fUqo3/bMXE1VYlKT4uiFMiz7Oo0QWLMypv1PTRAtgvwxt954?=
 =?us-ascii?Q?0IQEJ6sHzt9VHP0r41uL7Fl/I24kURHDvcaicRafhNSDdP8tWz1GTRuDH0zP?=
 =?us-ascii?Q?zGDmoxO/kTSyHxhIJz6w95Feab2MAG86aCjyoA+R/JZV8pvI45uJxCP9l0fi?=
 =?us-ascii?Q?6rG8WgRTIgZHYG+SfLPgRtqq9QzE1o+7Jm3F/iCnjELt5ttGHYnzqXcyT8RZ?=
 =?us-ascii?Q?ia2IJyjUI8GhApmEXRBXhMZ1tyBwagdAA23MwurVw05+ez+BDSOHmMQcNvSb?=
 =?us-ascii?Q?N88qTjltaeaD4+kjU8VS3YceCHXHj212ArlfuylE+MpL/Evth6r8Y9T2Bml4?=
 =?us-ascii?Q?g3p3DveJgU6xgYxuD6tyCxhi1wwddmNdrBYDkd7nZ7C98m1DOh7tk445PZ9B?=
 =?us-ascii?Q?lvxT/EuTjzviANItObaDH25DYoZouN/1zjk6vXLgJqbAVhZQeYYhaGVudAbx?=
 =?us-ascii?Q?3tPlpP/waEBBjqW5Zd5uuRnE0aRCrEIY14Zed6eabPXvNKz1rObOvBMHcC+0?=
 =?us-ascii?Q?MXdncvSclrNC96LMRr/dzWECkGa912+rXBSAKUSQQz9lRiBgy2j2UvekcJ+V?=
 =?us-ascii?Q?ngSu/Qa5EXc+eSOlYqlrLOJ2e+jBEglRljeTdzz8R90Z8aZenuNOT+jNS9yr?=
 =?us-ascii?Q?7mpgEF+pPcIOrKHcC+GSOmYEhN/PYtG5YZ+nHXK0gw3ecW1cI0nTUj7HWD6S?=
 =?us-ascii?Q?k0T3/C9MyjhC+LH8626HX2XPy7hOq13z1NCSysQq6x/TWgevwLjppRcTg7Jf?=
 =?us-ascii?Q?XTaoy789kHf2QqZirdbP9IBMR2K3iwHUDH34wpfTkNV9JsVkWKmFvTyMp2+5?=
 =?us-ascii?Q?/asNNOHTqODo2nmB+MKdKH9uqQMP32QnJAu9amnUaDvHPUca5fJTWHk9ao+E?=
 =?us-ascii?Q?aJACPfQxuLdW3qGi27P0p2hal9laWbohBCByePVhFIa3dMlnqgT4RwXuvDtg?=
 =?us-ascii?Q?mPp6rdHsiQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc57eaca-ab6f-48f4-1fe9-08da2106d861
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:11.2454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxzKlPsm/Ac0VXBW9WMSndiaXELmM4o5IdN+GgtM7rbLGvk1HTOqpcq9HnxMBVBen/CgsDzw9auClPxohyZh4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

No need to hold the lock for alloc and freecpu. So narrow the critical
section. Follow-up patch is going to benefit from this by adding more
code to the functions which will be out of the critical as well.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 13 +++++++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 +++++++-------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index eb906b73b4e2..ee1cb1b81669 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -328,6 +328,7 @@ static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
 static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
 	u8 last_module = max_ports;
 	int i;
 	int err;
@@ -356,6 +357,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 	}
 
 	/* Create port objects for each valid entry */
+	devl_lock(devlink);
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
 		if (mlxsw_m->module_to_port[i] > 0 &&
 		    !mlxsw_core_port_is_xm(mlxsw_m->core, i)) {
@@ -366,6 +368,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 				goto err_module_to_port_create;
 		}
 	}
+	devl_unlock(devlink);
 
 	return 0;
 
@@ -375,6 +378,7 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 			mlxsw_m_port_remove(mlxsw_m,
 					    mlxsw_m->module_to_port[i]);
 	}
+	devl_unlock(devlink);
 	i = max_ports;
 err_module_to_port_map:
 	for (i--; i > 0; i--)
@@ -387,8 +391,10 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 
 static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_m->core);
 	int i;
 
+	devl_lock(devlink);
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
 		if (mlxsw_m->module_to_port[i] > 0) {
 			mlxsw_m_port_remove(mlxsw_m,
@@ -396,6 +402,7 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 			mlxsw_m_port_module_unmap(mlxsw_m, i);
 		}
 	}
+	devl_unlock(devlink);
 
 	kfree(mlxsw_m->module_to_port);
 	kfree(mlxsw_m->ports);
@@ -424,7 +431,6 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 			struct netlink_ext_ack *extack)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	int err;
 
 	mlxsw_m->core = mlxsw_core;
@@ -440,9 +446,7 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
-	devl_lock(devlink);
 	err = mlxsw_m_ports_create(mlxsw_m);
-	devl_unlock(devlink);
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Failed to create ports\n");
 		return err;
@@ -454,11 +458,8 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 static void mlxsw_m_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	devl_lock(devlink);
 	mlxsw_m_ports_remove(mlxsw_m);
-	devl_unlock(devlink);
 }
 
 static const struct mlxsw_config_profile mlxsw_m_config_profile;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 55b97ccafd45..c26c160744d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1863,12 +1863,15 @@ static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 
 static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
+	devl_lock(devlink);
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, i))
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
+	devl_unlock(devlink);
 	kfree(mlxsw_sp->ports);
 	mlxsw_sp->ports = NULL;
 }
@@ -1876,6 +1879,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_port_mapping *port_mapping;
 	size_t alloc_size;
 	int i;
@@ -1886,6 +1890,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->ports)
 		return -ENOMEM;
 
+	devl_lock(devlink);
 	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
 	if (err)
 		goto err_cpu_port_create;
@@ -1898,6 +1903,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 		if (err)
 			goto err_port_create;
 	}
+	devl_unlock(devlink);
 	return 0;
 
 err_port_create:
@@ -1906,6 +1912,7 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 			mlxsw_sp_port_remove(mlxsw_sp, i);
 	mlxsw_sp_cpu_port_remove(mlxsw_sp);
 err_cpu_port_create:
+	devl_unlock(devlink);
 	kfree(mlxsw_sp->ports);
 	mlxsw_sp->ports = NULL;
 	return err;
@@ -2805,7 +2812,6 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 	int err;
 
 	mlxsw_sp->core = mlxsw_core;
@@ -2966,9 +2972,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_sample_trigger_init;
 	}
 
-	devl_lock(devlink);
 	err = mlxsw_sp_ports_create(mlxsw_sp);
-	devl_unlock(devlink);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create ports\n");
 		goto err_ports_create;
@@ -3149,12 +3153,8 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	devl_lock(devlink);
 	mlxsw_sp_ports_remove(mlxsw_sp);
-	devl_unlock(devlink);
-
 	rhashtable_destroy(&mlxsw_sp->sample_trigger_ht);
 	mlxsw_sp_port_module_info_fini(mlxsw_sp);
 	mlxsw_sp_dpipe_fini(mlxsw_sp);
-- 
2.33.1

