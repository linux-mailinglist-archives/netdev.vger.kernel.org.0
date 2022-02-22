Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4FE4C0005
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiBVRTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiBVRTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:19:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD7316EA81
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBUI9TOq/gVe6rmSPTH/yl9VJyf7BL+rvPI0AjTAh7X54KJkWfuhMgqoFcho63Fr/6hqvzdw8WSvdI7JkWaHxjIsNoDgKuGs0frUrCTPiboZ7iaP/5G9f9h9v820JzwMhWiT3Jjv5Caai3vUEXOXJKA8eBdHvkA8FSozqpjHh1mQrmfxS4VUprcaMeEg5cTDZps2rXFtQi6I9BQOQ0jK3PtgarlQh7FOP98vcMNff/+cJ+r2eEbF55HwAePAmo9LPhHUw/P+7IlJFE+RaRMatM/WYH1zRg433NIU5FN907mnf+obcs82hwm3Wpemz/TAERIGR6+2Ba1azmwkZ5IKLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gm+8/fJpbvCu2zO6Wuhoyvvk0m6+yReZdD13udKxrDw=;
 b=YUrIMFuGT9BTIZ6Xtfz2jGtlJJ70ko0wIAewkJQoJn+Uy7xB2ZZVOr6SHwlpEM+/Z2GgYBmtfY4snYa5Qf5V2JhcvtoDXwZ8147HzN/qLJgNObYc/1RZ02N1s0oaDEJTBch0t17Aie5+3OSJNw9auZQQA1avrifljrqK6JBTfFOb1koByQIaLvAQZSN0Foq9tiWKdNSUdqAcoUY8sMfPbVZiv0Qtet9wDXIHq0qigGp0Ac40SO4FvvQp5zCulZCR+QSS2UlzwCHj1PNog4o2TyU7c7qasdI7Hzaq7nhTrU+t7FhG5krvXIZZ4AEhpDwwCOVlogb+C5UR91S+bwFuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm+8/fJpbvCu2zO6Wuhoyvvk0m6+yReZdD13udKxrDw=;
 b=kJEWFRe3rYD1wxohiLvBGURcMDMKM6ROO/Vc3WP+9hrghlmxtZmTLjR0mjzqpw/fR/rNIyXV8m5v+0tLOGPH/3N1Jbkn6KSBWC1jkLd550phnbqli+mNiLWvuWyZwWzo3cM+6RISwkvcmJU2/6uJERwmHTF+SV6SWv4/BLhYS0WGgiYVLXFfTy3pVYWayKbyG2TR4BdaNPsYSgP4PRrLfmQ8ks1V+c9osmEFxiKHrzQyKiBDPdbnSdXYcfKLdrJ41o2GCFg8IBiYbO985pY5HFnMhr3BOz436x3ZDz+Ffisx6aoxD5/g0BR0hMxu9FLIDIGW0ZZbT5RALDlZOm76PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:45 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/12] mlxsw: Remove resource query check
Date:   Tue, 22 Feb 2022 19:17:02 +0200
Message-Id: <20220222171703.499645-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0019.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6afe07b8-1435-47af-58ef-08d9f6276161
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4262132AE2E12D643882AEB6B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 339ifXsY79xE71Z1JYaiNsYhG1g5oz5R8/sxnI0sPrlv1vRz3hkelQfRVrdfrPOIck2RbAjmWRtpB8lfAuMvxFBYbKqjKoonTqlCRas5761+atRXjVJIJ7zNwr6KLd9bn89ylgh7+ADYC5rkz77t92UakytIZUVQa3WqHPcqXf1G/kV0RMQpjZddRAkKbbgyS0rT/0lUZLnIxC37W1QEjpVlrmlxjtRCamD19o0yIwIiZPzWuSTmHKTOBCkTkaYbiUAGmTZIW8549KtJxPMceJnBR2NB576tsoEauzhUp8r4EXzxl/9C6P7TUZHurlHoZf17eRM11miNprilfKJRzG0taJD/w7Hgenyd/bvA+fcd8CmB3z97GvZ1OXzgA3GrMpVfXwL/dXbg2IC/m71iSSfucIUVRMU5Jk8VLWhTP1oFDN2yyGGGRC3k3xBbq5xASGcVnrH/wkftFrEG08EbAIjfsyaCR0ErwzxEUniTodzvZT6MLcDzjh5pmjyXpkVLTQPtWDZc4mrDGSx+1fF+QlaCH3v2G0pUaKZ4HallpbRlM7CkizHKpnfzLESIG+58IP48VDWKRwBwfDWl8+YhuKexhKz3gQQQ+CdLUINblC3lYF36ilJEYextRVxt0bLlZznaHw/DqmxQ9ySkmsioyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6BsfM5lr/83D2yFaoRJz/ulqhGdtuajfYWqSIgG97q8WvQvP0nhrNlJLR8n?=
 =?us-ascii?Q?FGqcn7PdpRMdRAV1YaoCIdCRjq8dTiRAcmZlrUul40gVEA1q+4ojZF7I3/Sg?=
 =?us-ascii?Q?vEPJRSy3rZdfb3oOQOhDqj1cpjqh1087Jjb3FjlFBoaAfbMLY/Dr8UBIg5f3?=
 =?us-ascii?Q?ZLSxvw1Rutf7QA/BXkitidqqI3HbUG1UXAUx9NrkMtKI+X8DZACZTGitfWuC?=
 =?us-ascii?Q?KAnedXZUnRPD67Zknx1vMyqF23B6AM5mrX0zjokxtISSGnffZUKSm4KZ6fUC?=
 =?us-ascii?Q?uI05/MzqE9G6S0XN46UCVoqpgKlEteyVo4bnGezsLCcvDpgG4s3uS4ssC5Kj?=
 =?us-ascii?Q?UBpdkaLkuacdAfHVu7tatRy87FuUvGZZDvwmdwhVn8sm2OW2hs+jcJLcLpSi?=
 =?us-ascii?Q?8m65ho7nGA3oBic1uW64MM/763S7WxUWBvqFEAP5Z0A3Y0LY5j+T0LqQGFEm?=
 =?us-ascii?Q?6R2Aw3BODj95fyNO5pA/Em9AuAJVpMLg7rmv+GEvyVYteUJoTwa5n5e1OIk3?=
 =?us-ascii?Q?PYJZ06Sdx3z7QW20L4vLsD9mDukLfGdOZ46X+j/T6bP0NBpmE1JqVxa2GJCK?=
 =?us-ascii?Q?sSLZTdfmoF/FakzIbHhN1pu1lu8/LckHQbpOiWbnl9Qc0bjF34KT5h6KZQ9a?=
 =?us-ascii?Q?fWXf+7FJNHr79D/Ca4hWr/z/rgg5FbolFsX75u5BtDOdak0NZM2Y/HVVfXkb?=
 =?us-ascii?Q?W5lMBbM2g28hJshJXb1mSy3usju9XbEiscdXtwpp2aNmyFXm/rRWICeKH5JG?=
 =?us-ascii?Q?09HQbujOnDafitj4I2SkN959dt4Ha6vHK8N3DODuZoM5C8tDg6IFjbO8R7o3?=
 =?us-ascii?Q?S2SUbaB23QB+jgPcpApirnLfOePOhIw/afPndvFCvc0tsO/+aR65sV6ik0XH?=
 =?us-ascii?Q?qvtH3CAs5l68pWPYmBswI2rhG55HoRB1zPrkb/CE/eifE5UuBqqNN9DtIXic?=
 =?us-ascii?Q?DTqB8WSc58RA7j2rIcl26xFlyyb07h7HA5FmcPhfhccCzyNFFSfOLhuLiFUy?=
 =?us-ascii?Q?9Ap44u8vQVp2dxXngzziMcs9rFZJVeNFq1LqqNtSou8qTuBlytMZXecT4Vov?=
 =?us-ascii?Q?kfZ9bxnpNTx87mIJRjlyXIStwU3EtFzK12q+X4fwf4yQeqAkKLPHvB9L+Fgb?=
 =?us-ascii?Q?V569efR6r/H3QSB9Oed9I9CwgEZmSO5N1oaGI9NDptYtmgmS6EyfR2OdfzQN?=
 =?us-ascii?Q?dDpJwTBQLUPotOx+dWIUXW5Tq0U5S06KDUtImh0IP2ra8YgmyH98tHEBOe4u?=
 =?us-ascii?Q?9ApvEgc9NWhzrURi72b2UDuRkk0bzSNG8CFVGJp8NbeblM96dGUfHgmJwbys?=
 =?us-ascii?Q?5+A0ddpeUJ2p5Uwj3g29nAieYQed2tTP62FtUYeg4F0s5Jbc/6hCpWAlknJj?=
 =?us-ascii?Q?Vwcnw7PF5fusPYWaD65ojykmC7W4chErygTZaTMgL64NMEFhFtlp04fU3u1h?=
 =?us-ascii?Q?Yg+vBjeFzRQTIURkCDa3+N5n/XLRlkYwoHQuBCiu7eaBiuW7B6I0NtVOWRKc?=
 =?us-ascii?Q?XfkqinNGxKEFe1BXJ6l+RWd193DJ3CuKtgmCWhXXvqQH6Vs52g+phxYDCTud?=
 =?us-ascii?Q?euuzw2tFVhWcMiQKJg9N9BuZIW7Y6wsbWGghwhiQ8r01HeckW4kD0sCNRH1+?=
 =?us-ascii?Q?+q/uc63xf6XkCsvdQp13YEQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afe07b8-1435-47af-58ef-08d9f6276161
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:45.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 03p+YDeJW6d8kDGebgbEn93Ryk3irm5RlHi/9mnw/rIjWRdpsDih9PwzDv5JW9sCLsVkhmf4zwjjFUEi4o4FhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since SwitchX-2 support was removed in commit b0d80c013b04 ("mlxsw:
Remove Mellanox SwitchX-2 ASIC support"), all the ASICs supported by
mlxsw support the resource query command.

Therefore, remove the resource query check and always query resources
from the device.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 8 ++------
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 1 -
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 1 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 ----
 4 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 4edaa84cd785..0bf1d64644ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2078,7 +2078,6 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	const char *device_kind = mlxsw_bus_info->device_kind;
 	struct mlxsw_core *mlxsw_core;
 	struct mlxsw_driver *mlxsw_driver;
-	struct mlxsw_res *res;
 	size_t alloc_size;
 	int err;
 
@@ -2104,8 +2103,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	mlxsw_core->bus_priv = bus_priv;
 	mlxsw_core->bus_info = mlxsw_bus_info;
 
-	res = mlxsw_driver->res_query_enabled ? &mlxsw_core->res : NULL;
-	err = mlxsw_bus->init(bus_priv, mlxsw_core, mlxsw_driver->profile, res);
+	err = mlxsw_bus->init(bus_priv, mlxsw_core, mlxsw_driver->profile,
+			      &mlxsw_core->res);
 	if (err)
 		goto err_bus_init;
 
@@ -3240,9 +3239,6 @@ int mlxsw_core_resources_query(struct mlxsw_core *mlxsw_core, char *mbox,
 	u16 id;
 	int err;
 
-	if (!res)
-		return 0;
-
 	mlxsw_cmd_mbox_zero(mbox);
 
 	for (index = 0; index < MLXSW_CMD_QUERY_RESOURCES_MAX_QUERIES;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 14ae18e8c6f4..16ee5e90973d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -402,7 +402,6 @@ struct mlxsw_driver {
 
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
-	bool res_query_enabled;
 };
 
 int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 9ac8ce01c061..060209983438 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -461,7 +461,6 @@ static struct mlxsw_driver mlxsw_m_driver = {
 	.init			= mlxsw_m_init,
 	.fini			= mlxsw_m_fini,
 	.profile		= &mlxsw_m_config_profile,
-	.res_query_enabled	= true,
 };
 
 static const struct i2c_device_id mlxsw_m_i2c_id[] = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index da6023def6ee..4880521b11a7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3627,7 +3627,6 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
-	.res_query_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp2_driver = {
@@ -3665,7 +3664,6 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
-	.res_query_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp3_driver = {
@@ -3703,7 +3701,6 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
-	.res_query_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp4_driver = {
@@ -3739,7 +3736,6 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
-	.res_query_enabled		= true,
 };
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
-- 
2.33.1

