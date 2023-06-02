Return-Path: <netdev+bounces-7491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDCA72076D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:22:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EA7B281A66
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185FF1D2BA;
	Fri,  2 Jun 2023 16:21:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058D51C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:21:48 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1F410D1;
	Fri,  2 Jun 2023 09:21:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR18NgE1lZKPabHfnByMC7ZZ+zibHhZqAAWxo0IOp4fkBKeztjrGWmRBku05u3mi7hXngnUu7LE3WTkjdXywomWBZ4PFPRhiMyrf3bg49PLsG3UKQx0zbH5aFN3PmBV9AnI0F6tgnkzwEG5xDKlrCBP95aqQk0+GkxrXgR4q6ddg5pGGYW9kCFyMB4WS9FlnNh5C7HEfzLQsXA/xuGAMN+UnIeY8LnQlDCjpGUgffSKFGzPBJyYaD2rxmGURrL8mpx3yF2qO/NhEvICjsYFDrGYRfIWmegXUNJ/F3KYQS8xmxNsBFlvlh8x1xVQoPqnhEuvKEsHeU5mQH0A10/WOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pwz0QeAa0IEH0+AVI/QMhR6M7G9No7PUAVy7tSx37p4=;
 b=XasqkER52+LCkXXtIkhJBVgUAzKqmLdLmYEyS7u9ygZIO8SZd1cc275CwbZeXYms7y/8oOD6h1thI/9EELtD0YQM3OiGhTwsJBmS0J0x7nON916M9CO9zdAXo3sw3twuU8NZx002MyVxqlu4+UaEjpqTEglk1EZqmo+wENBPDGXDCP65cy3ogzWsUqX+kiujq6wfChAKkowIyV/ppyCfgYVWyqTUNeuKJbABiYVMgC3s8u7rg832+gjyDjxj2kUiYWmgjIZzhmvStovkXGpAgilf9aUNBGXNSgwwrP4aDiKEOwvRjn7FA/iEWyvhR8sgCkX4YsIn91PLzigRoYqt8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pwz0QeAa0IEH0+AVI/QMhR6M7G9No7PUAVy7tSx37p4=;
 b=VNolPuNMeT7k7agaiVlzuABFc3oYfo3naig86iGgL64qZviyNlovc4kCSM1AqJZGBFoGVZw22R+C9ozSEE8uhKlL7B+Ts+6JuAd2BTHf27J9d+u9Z55YNZFNleCBxBsHm0gut7dHke/f2UF2XkiuaI7Y6Px8Wn3fMtuiAYtOsEIzquFO8W0nSk1T3BlSEWucJohnsh9TmPl7DU7YIsNRC6aaxy4FhTo+Q+HXpT9M2WfYtAvBfbDBDTzP5TLUJ7ISK6MEYrD8pAEa4j+7+PMkb7c06xJEbRZYwZOwgI2T19SEz8hd28Fe4b4/9/oH3MIVACU4xmEI/154xnEgq8suNw==
Received: from DM6PR13CA0012.namprd13.prod.outlook.com (2603:10b6:5:bc::25) by
 DM8PR12MB5496.namprd12.prod.outlook.com (2603:10b6:8:38::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24; Fri, 2 Jun 2023 16:20:47 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::f1) by DM6PR13CA0012.outlook.office365.com
 (2603:10b6:5:bc::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.27 via Frontend Transport; Fri, 2 Jun 2023 16:20:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:35 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:32 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_router: Do not query MAX_RIFS on each iteration
Date: Fri, 2 Jun 2023 18:20:07 +0200
Message-ID: <c84b74e0dfc00d19a69697b9c609e352915b8126.1685720841.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
References: <cover.1685720841.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT008:EE_|DM8PR12MB5496:EE_
X-MS-Office365-Filtering-Correlation-Id: 646f983e-ce30-4468-b369-08db6385526b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SR82smzrRMpt3XNDxzZPMm+6XnWxTcnsSdLfpGjHSm3ZmFH3LpGOWUEV2WoOeDiQ1JMbKoCuXSE/964/i0DOJjx5Ry78M3tpGBwbblwQlrd0vkx3WHK5yANAYErGyUk0J2R4jHO12auNwXAxDrttzxaYZb5bACLd46z9j2tTqJj37daUyqVo8LGXNig3q2JuNVxot14v1Q2fvwwIqedVEMDjR/gQfXUcLqkycrUN0Yx7v3O9WfChLFIHH1AZqWNSiWu1zLNKM4OgA74McLrNmfsTo2hmOFtDgPUOJvKhlxo20K5vpYPeW8joEet8+wQ5bIcczCZFoSMW1xqpDlyzXph82t7CjpVx2neO+6i3iGL8bxOxkAUDoi1AzTBzkP23SwvAePWtKyblcXTBdWoVHrTXjlN4NMRd9f10Zk+giyj86YDH3ryQg6P15taXKYYwhdqL9eXUUWEJR2puwudAM3CoBoNJ2noaqfwCDtcvGKb2jSYhVJIG00WCoTGC1YRJ5wLQRUZSdvaSa5MRbEH88KsJWy7tzymfN+DPRh4Xl/HH56kbGy4kD70MkcIX0LOzsqbgFpa0vf10eWhQ8DKleQZEIYLkso7eKXqBQbWWy2+xpmCJpk81LzSap6811VxRw78bi02eyu5uupvU+JfGKEj+GDVzfRNFEpAil3mypgJ7K5URZo/C9Ey/e+9ZhZ+oW2UehfVFyfbkru9KYMy81SsOFWfuuYuhtUEkCcWhLwZyeSprVEGZHn8CgiugBwhi
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(186003)(107886003)(16526019)(26005)(478600001)(6666004)(47076005)(36860700001)(66574015)(2616005)(316002)(83380400001)(41300700001)(336012)(426003)(8936002)(5660300002)(2906002)(8676002)(54906003)(70206006)(70586007)(110136005)(40480700001)(86362001)(4326008)(36756003)(82740400003)(356005)(7636003)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:46.5616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 646f983e-ce30-4468-b369-08db6385526b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5496
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MLXSW_CORE_RES_GET involves a call to spectrum_core, a separate module.
Instead of making the call on every iteration, cache it up front, and use
the value.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 20ece1b49175..f88b0197a6ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7699,9 +7699,10 @@ static struct mlxsw_sp_rif *
 mlxsw_sp_rif_find_by_dev(const struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *dev)
 {
+	int max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	int i;
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
+	for (i = 0; i < max_rifs; i++)
 		if (mlxsw_sp->router->rifs[i] &&
 		    mlxsw_sp->router->rifs[i]->dev == dev)
 			return mlxsw_sp->router->rifs[i];
@@ -10041,11 +10042,12 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 
 static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	int max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
 	WARN_ON_ONCE(atomic_read(&mlxsw_sp->router->rifs_count));
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
+	for (i = 0; i < max_rifs; i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
 	devl_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_RIFS);
-- 
2.40.1


