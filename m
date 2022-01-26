Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1065749C794
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbiAZKbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:31:37 -0500
Received: from mail-bn7nam10on2051.outbound.protection.outlook.com ([40.107.92.51]:6688
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239984AbiAZKbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:31:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzX+Cy13zBUQU3Pkye0F3q+CeY6vzagdwcubt3rZ6VH6wyeM+H8SyaIdZhWJUUyKYUbGg+rD2LY3vuKe4vmp30h1ggA1Nj1slMeL9j+QVIZmMjCBVIrRpECsBplWndxhRecz7RYluqi4uZ2zyMIZfkKjlWynAyg1Uo/C6l8km5O2mPmxEKHGsYRwbArmkILAuUDEaH5XxN0f+h4TwJ89GfZ8fUo12KIT1XuR4ol6gkQbTzhO0I5pI6FDj7VXqjSdyIDlumz+mrlnmtNyTGYwvGmtz2v6AEdZp3dSc+dd3MQnLfRv7n2NYwPcRFt6lvVdbggJQQb5pQ0ruZbbCmAPLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3/ClhcY2f3fqHrBsWyo3vYN4ofULRCizkpHQ3gciSI=;
 b=e3WNcyIdyF8ydiVSSD8HMuUGq61sxda5zmEQyA9erFNcqJo9Xs8nQ/49+/1728KY+hV6O2z0rA+1V/3FLZq5usZaV/6r3DWJnfS0rm+3PZybwBQpep3YVe8OBkAe8nJ4YARa+YPNI1yvONGIXXtavvtNH1TWWA5yk7z6xlH/Hw1vyZyhUpKVCm8nfYfPC3y1Ft9JHTCvniZZf9PQ0DzUUk8rFf71KtSlx3ivjHlgq1v66YbreSQEMhMauZxKBfKbiH3RPBidO/mio9C81FsQq3vzFcuWdLd7OWP68JIjjApgYEM5Ewuu7l6Fn6kZYTxDUPX8mHdkFuTUUhApuZd6Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3/ClhcY2f3fqHrBsWyo3vYN4ofULRCizkpHQ3gciSI=;
 b=ZeJhXJxjD8eeC4Jd/Efk3B08Ay+u2sKwsSIherXnPpLnV71Ird5oqyEwbFPZubmgMknFQRd66NWgamXW5xChHCpTdzHyegCUFlTSsc9g4ynETLdubnqRyojigw8MrlC3ZscNcE/DgaJ++icH57iTa4oH/olDduMZUnV5ggbsimfXzlfZLoB+EQhZvJrr1107BVq4LvrK75dD2nB5y8EvobFhIO/Oq389b7TishADiWI/IBIqBnTak+dxqg7VMmeCurjV3Fq1EOUw97hg4YV1o/jIYj/UyUUbSeioTV2sFVbo43ndEK8TmbxkH1ejU5Lyu2VO2Q++AOZDKiHBjVglhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by SA0PR12MB4461.namprd12.prod.outlook.com (2603:10b6:806:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 26 Jan
 2022 10:31:34 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:31:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: Add netdev argument to mlxsw_env_get_module_info()
Date:   Wed, 26 Jan 2022 12:30:31 +0200
Message-Id: <20220126103037.234986-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0173.eurprd09.prod.outlook.com
 (2603:10a6:800:120::27) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a09b6dbb-0cf9-4355-7214-08d9e0b70668
X-MS-TrafficTypeDiagnostic: SA0PR12MB4461:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4461ACC65E06673760AC6E04B2209@SA0PR12MB4461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/PU2vQdirx4a04TV9gFvwAb0Ocz//2iQjpbCY7Dxrb6KTNXG7yRqU/02t35nEMDn0tCekX5NuwEfu96uc+l07+7LoTYjir1FFAWpixcB58vQ07JdzGllu5F7M0BfSpHOyoKjI70TySIL63ENlIrRdPL+8NpzptLAdmb29wftI0SPyi9eEA/7DFhQLY4OHyAv2HYRcbQrTg3tQfYQMVnWDkqSJpYn/taSVKsKdhegakWHByNFv+Mf4ik6uLZzl/FbN/hHCkYqPsETJZgIZkFQvK6bZfDOORQ3HASjl2UBA3ZpJ4ctB1K3ay5cb/s/b3TITVl7fklef9zmg7RO4P95D0ZxXkaVWbN8yXpgWFxP6V6Sm6BuAeL1tZqYyLecouMVZYHR+LgX2hl93otnV7xQV7UNyg5gaiodoOHTXXzaQcKvHRtLvAWn9udC+oox6h9Dy7u3BHtghszEvltgl9bUWFFoZeO+86bP8XqdtqKsNjPOSqSYGUQiBp77VkKx+jPI51GAFz4Hu+ITZi7iDwXxd8EIsLLsA2jpedMQq3W3aBkhpQvvKRTb6pKM5DqyOeZIxd9K7YQCX0IS7M0GajTDvRkR4YlGaz1/X8lDBQ+EC3iW6Y5aaJlBWMMFCUCcxXFnBKHO3/1dUUD2R0Ni+AcrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(107886003)(86362001)(66476007)(508600001)(8676002)(66556008)(38100700002)(2616005)(5660300002)(8936002)(6666004)(83380400001)(4326008)(6916009)(186003)(6486002)(6512007)(6506007)(2906002)(316002)(26005)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uqQi4NRVuXW7M+70jT+u4awmHKfsS8FpN4HK5iVINeKkS+PNOgkA1S6Grz68?=
 =?us-ascii?Q?MHpTXzrLKFUA1NkfDXrGbgNcx/1OCICTLhVih+oVDwz2AM3bpXpz4M60GPa8?=
 =?us-ascii?Q?A7QqOUZgEgQZAxELxX/JPS3ierXjzFsNtYzZMva56hihnbDxwmAxI1ymG1Oz?=
 =?us-ascii?Q?MN8KH94YPRKDQPig5VejC1IfU1wYYeQCgm2f5kr3XD+8nAROEVMWDHbqyXN8?=
 =?us-ascii?Q?pvILOGWDqBI1sX+wOnH+Nz2CNv6aJaO/jdJ9dUvUlgF9R+eNai/TYXgAFjSy?=
 =?us-ascii?Q?g9ntgQF5HrtgXIRiBeA/LH8jMGbwA+dSnq5dOR6uisgF8XTN8Nkfo7u6feTv?=
 =?us-ascii?Q?SiT5eqSRxBHL8kvtLKrE5gsWJxYpwd+GeJImJ29dp+3/YyIs6C4G3PO3V5W1?=
 =?us-ascii?Q?cXSfRXVgzqhVXFLayGWrv5Yma6SroDmuPkRHkm+xjHGPnV5fiwTN+EoMAb4T?=
 =?us-ascii?Q?SIWI3V3s+48uVPOslaZrco1G5INSZVQQ6S0igHL3zppOiYkrdKu9D+WtJCSg?=
 =?us-ascii?Q?44esnLEsqCLa5RcM1+cJQYA1R0N7syZQSDl4VZ81LMEhGvWZxmRZ+tC0WPnB?=
 =?us-ascii?Q?q35qLTE6Gi7ewEM4lckxdI2U0Xgp6hBKCP4jaI/wEbuS+XAcsnnPZBWdoINf?=
 =?us-ascii?Q?faF12Hfm9RalkgXtURDE4YnReqapqlOzbH2diMroN4TsGIeT73/KQ8Q/dlI7?=
 =?us-ascii?Q?7HloC2+vh1isv801PaElkQDzUD0TZukjPJH5LJ0NX3BibuO7EneVp/D1giEA?=
 =?us-ascii?Q?a1YoBP4S6RpKxLW4iWMHnazV0f2zkk5/k5bxLM/jiSgd72nf4nRPhOI8LmwF?=
 =?us-ascii?Q?I3CSPNtLuGZKHH00qHZumnRm6UDLb8nMXNf0Ad1ANjukK41jxpgb0o4nxK7F?=
 =?us-ascii?Q?jeEkKmOqvBoqA0XUzMlezaikAyu3LbZETkGJTgEkfwYed5HICIBW+63tWlho?=
 =?us-ascii?Q?cJxd4IyY8fmTTZRc1wi6dNkTgzCXS+iWynbeJCV14Dbw2/uoGw2J1i0dgnEn?=
 =?us-ascii?Q?PhW3ffASD+vCziAYrqh7cb1FTDi8qGtPChYGgLu9tgs0JUQ/o9iUq8ju856X?=
 =?us-ascii?Q?nG9h8lGHszA/wjqQzfm2Fr/I0nspj5yKjnk5DON82XtsMJgFSDtc667bUMHe?=
 =?us-ascii?Q?Pxo2qjBltw0moQEcTWa0dL3LV9ZltOumje77n0XtecCxBpKe7GPg1G0z8qzC?=
 =?us-ascii?Q?M3MlLhTIbc0sKsxnNRTlpHeLtf+RWA5b2IzouER7g5D8z+CXXP0q/7iN9nnf?=
 =?us-ascii?Q?0FQ5HgKW3JZfrhepoteUm9259SNMfbPluGsAWu01MsQD3MrnsD70t8qy2Q6J?=
 =?us-ascii?Q?IWzO0lVnum/Y9mfUiyGVWXcl9n+h2emGzmEyUOeMx4H1mpSdFAKfRye9oI6Z?=
 =?us-ascii?Q?OHZu+b331RmgExHamUYlJSM6sCciRcQgKYZk+ErimGdJoEHra9Eu5zCEYaIS?=
 =?us-ascii?Q?qS1+3eVY5mEmimR+fBVjlKuoqQ9C9ETgDsaPsR7DN70SRqAiODTfzYWYJCaT?=
 =?us-ascii?Q?U0aOKIInIQEPpQxoRKyXOfI3Vamg0FiwOfAMqKgP/CXWUxRGbU92fDA3pTUd?=
 =?us-ascii?Q?qrddnF9F/pvNRPwmSShzg9IKbRLVhbw7yItSJ99WybFglb8UUNVvmsK8vgzE?=
 =?us-ascii?Q?F/JImvz9d0ICijy1a50/eWg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09b6dbb-0cf9-4355-7214-08d9e0b70668
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:31:34.3437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRuOY91T3P1Jze+N6k8F1dSNuvRW8ynbXh5Wt8qk14N7aAgwfFtp7oujyOzYrwWlpaN389gUYdHr8Or8E1eVGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The next patches will forbid querying the port module's EEPROM info when
its type is RJ45 as in this case no transceiver module can ever be
connected to the port.

Add netdev argument to mlxsw_env_get_module_info() so it could be used
to print an error to the kernel log via netdev_err().

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c         | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h         | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c          | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index e84453d70355..06b6acc028e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -206,7 +206,8 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	return 0;
 }
 
-int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
+int mlxsw_env_get_module_info(struct net_device *netdev,
+			      struct mlxsw_core *mlxsw_core, int module,
 			      struct ethtool_modinfo *modinfo)
 {
 	u8 module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index da121b1a84b4..ec6564e5d2ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -12,7 +12,8 @@ struct ethtool_eeprom;
 int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 					 int off, int *temp);
 
-int mlxsw_env_get_module_info(struct mlxsw_core *mlxsw_core, int module,
+int mlxsw_env_get_module_info(struct net_device *netdev,
+			      struct mlxsw_core *mlxsw_core, int module,
 			      struct ethtool_modinfo *modinfo);
 
 int mlxsw_env_get_module_eeprom(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 10d13f5f9c7d..9ac8ce01c061 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -110,7 +110,8 @@ static int mlxsw_m_get_module_info(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_info(core, mlxsw_m_port->module, modinfo);
+	return mlxsw_env_get_module_info(netdev, core, mlxsw_m_port->module,
+					 modinfo);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 68c0ddf3b6c1..055f857931b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1035,7 +1035,7 @@ static int mlxsw_sp_get_module_info(struct net_device *netdev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	return mlxsw_env_get_module_info(mlxsw_sp->core,
+	return mlxsw_env_get_module_info(netdev, mlxsw_sp->core,
 					 mlxsw_sp_port->mapping.module,
 					 modinfo);
 }
-- 
2.33.1

