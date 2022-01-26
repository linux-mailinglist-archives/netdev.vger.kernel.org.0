Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86DC49C79C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbiAZKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:32:08 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:2593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240051AbiAZKcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:32:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6dLaTk2tWS5ecMKjoy6WuZtyKJgNreYNg65icpwYxXvnMkTaPnFQLfJMzEOHQimwOSVoORSz9HvscnTYdEAIApjcww2TwQFrkIChiebSuvPFpisoZjQ6OW35AfDtV5qUmqr/E9MI6rmDLTxkzA3bJ7MPeQfwB4YpGLougxZXQsZ37eYqdYlLTQKBeVkihTSfdV03WnGWApS6N3gjshhCzhPe2tcjm2Ns/4FVjX/gnrl8ZYs0rO163QniDF0ZHmwzhGczL8D48S6TrZB8bc+A8/pL4ISJTAyl40R/BihO/LYfUxe3s3Jtmid0mtmbm24e04HclKWYj1d+0NxM2qaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0+NleJ0WFgXdijaH9a28TOrw7bsk6XXc39hQFrFzE8=;
 b=QbAnUfBGxumBT7FWu+s2T4UsipakYAOHOYTPv7c7jzk/XF/AVGQfdJZFKX8k/KZZX9+otbJs3Efu44ski+Kw7dRdX+7ut8HkL5Zn6ewv7/b0+lR0jeGSgNjtUB3r+EY1JyRpoGDNFJq6/uVy/0GQk+9roySPqtvXD0jh1VhGV75JDMJfNiFKSE3rRf9VnFmwy+KDsm2h2IPjvrsXMxBCqdkPbyEovvIxZ5j+V1lPRWtARZhvhZ4TlTy7R/UgLg5jY49sNoMQbMbpnX/uNx6QO+c7QjMVEDgsVU8c1dv/RLLixSs7j8e1dgkhPaiD0ng3+zcjvejzs6aKxrgPFTRqJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0+NleJ0WFgXdijaH9a28TOrw7bsk6XXc39hQFrFzE8=;
 b=bjDv4bkXnlGncg01L6aYjPDQetrXtVsEshcsf8+H9H7O09v2HTu7li1avuHBhm0jJW7483TTtH+T9Pcr8JQUWltNe2MoufJ5YOCcIla9XRy28uguTT4GzGyWw8piT1AOBGNH5UG9ahe3Dim6lTrs4Bg7SSt8GvnTSxu+BjAZ2zxjdvcOis1u378+uq6fjdEISWjIht1vyyQJ8MFaSTHAwQ3tZ1Rx5IzxZOsjLBw2rIPeH7+RGJVG9g7Nve4hqKgy+579mOG8znepHF63W9n8q+lUcDEvQOCg/7wrer1uH0KanS2R+bX0T085Rjjc157tp8KGnJS6Scq38cs0Jc6uQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 10:32:03 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 10:32:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] mlxsw: core_env: Forbid getting module EEPROM on RJ45 ports
Date:   Wed, 26 Jan 2022 12:30:35 +0200
Message-Id: <20220126103037.234986-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220126103037.234986-1-idosch@nvidia.com>
References: <20220126103037.234986-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0151.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::35) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8606d61c-ed09-4391-7492-08d9e0b717fd
X-MS-TrafficTypeDiagnostic: BN8PR12MB3620:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB36207C944BF8933CD7E70D37B2209@BN8PR12MB3620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0QcuAJ5J9iwE64Xvkd1tWsBZ9LzPgPTekxMKdqJJEYTWQtzIkFSb4ylGAfPNSLWT5mijwlmUugxObREs541UBwrLtAgbwC8yMf6EGiURpF95rlo0p9FKTO0pUIfhJKkTFc3nwKPcLz/IBXlSuYHA85r/VQ3qLUD0PaI2b//C2aNxEUyL3Sqr7VgvwYEh8AnsVTXNYnYh/hHmJS7eSE0eCr+jSoloTZkgr0GJ0+LgcCveo+mZxUBC+b1cbp3zVZFLfe0I+e7iXaNIZFh5jY/m/OS+Bps6BIthRsd9k5OC/VDuj1JMTb4XOP51BHiOMcCFkIy9OnLuafxkfPge4IiuW32JTnEOdMs+w5NUXlouuMwBQ8VUfSEPK2ZIOi9Mpbh469FtkohJ/AvgkvEdNeK58lRhGfRmtS6/T5ph82HpDDZNtG0v+LNyk3Q2XzWd37kPWhXTP7HZa4yRLYDd08wL3LrPuDYyPjgfgLuEiV65xL2gRYEF9eftcWAYua6T1rS6xuYNdVIidKxG7QgQdKcQtRXWB/yG9Ap9QtKkCyQlA0KDvp/lZIkJ1WVuB+E8mXv7JdcgVOLhJ1WBw5LuHGb3k9DO/WE9zK1E3pc+g9D2q0mt6ANIGqoUmSoQ/xfhAl7dRKSgZ7vdIPgeN2ClrbH9iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(26005)(6512007)(8936002)(316002)(2616005)(508600001)(36756003)(186003)(66476007)(38100700002)(6486002)(107886003)(6506007)(4326008)(6916009)(86362001)(1076003)(66556008)(2906002)(6666004)(66946007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y5EtBd0QqKM0IcPU7I5AYsz2KjoictuD5VU/nMW4XHV6IhAkZ4rZ1zijBoJ+?=
 =?us-ascii?Q?Zi8Brc/s5VeKNuo1/YlkQMwmcBYGvy/wtuFzQjjbDIXCJYtUnUu3MxRMxJY/?=
 =?us-ascii?Q?OMC8eyaHQpbMKL7tjsLe5CkBvx93vsUSX5/32gqfgPmfgY/jnn0wJ2SSxJlt?=
 =?us-ascii?Q?ukAHQMa5QopH9ZZiYyY08uHO2cXj8vW6GUNPURsa6JrpdlXjMXzCR6oIEodw?=
 =?us-ascii?Q?iQom0X7nHsJh7EXeU4aG4bW4l8Mihrs9E259ZijF5ZfK4BDDfmEP3eo+Syjr?=
 =?us-ascii?Q?o+CTFiQ7meEIbFKrtetwCfqVi02OR6fweB0hrhMoGzVwakGcy7/9oLt4yaTJ?=
 =?us-ascii?Q?vBgYmTS5hFb1GqAaEg+fHYGgu53owwZOs2x5aaFkMlrtjXrVPnywfNbebNYF?=
 =?us-ascii?Q?OkUdWbvewhbqYZ9FBaGUv+7CvrRVNZ69qbUuCJp00GSXHzkcjQDSNuNntF8r?=
 =?us-ascii?Q?qNsu4rKaeXozfSEbYPj7BrK+VHSgpV1z9fUxi8Yk0Qa1R5FGVFAokm5GFle5?=
 =?us-ascii?Q?8KifLG0/kQS9bO01TF4jmoxTdhdsmkPE1eZwNGNh0yIEFq23nkbd1+5RfseP?=
 =?us-ascii?Q?9lxP9db9TB6ZeUV9QirpjsTlJtO9SgRL8KuGLizbFP6KnMDvW77iJr7Hw90P?=
 =?us-ascii?Q?SM0QLu3uTinAyzCf9SXBZSdotzcZz8yZhctWS6PMK+hU70MDnqjRstI1y9CL?=
 =?us-ascii?Q?9ApsVRa+cF0bQwWCiolvIizoLhPSc8Bo4RX0j9peoObcSH7FkRd7CHloB9Yt?=
 =?us-ascii?Q?WeUOtTFeNdpuQ/5iHPhAfKH4qclbnCYw5lXeSnZEKfC1zlAfkUXWnZbG150k?=
 =?us-ascii?Q?KMQP5WnEaWgWGSaBAPvDFa1P+4EFpmwqJLFaRnwKEJyk3cxGajoZ5esppfmM?=
 =?us-ascii?Q?LwgFHyGMWzYUGBHiMh2+FdGORc8OAl4r3Fi7wVIt7tPDrU6vwrVXhShSx66Q?=
 =?us-ascii?Q?2zO+Lue8JhhQlWn5Uo15lAWBiqcTSjbpkiJi7inUL7q4uoM7e9GKBYXH50dR?=
 =?us-ascii?Q?2XiH7SLfAArBcMmEFhp3c16ZtCRqWR8eIdD+QEAKgiESdfT7BuQ2ICBiHBfN?=
 =?us-ascii?Q?pVmgQFUDkwwnDBLHIfENTZsRSLnfmNo0fDGq80DBS3dSoeOMqWlXUrOTHXpu?=
 =?us-ascii?Q?dws7ryedqubsyX/XvWdnw+y7q5+E5xOJLCgYme0aBj3XC4gC0Q8roWDM6UEC?=
 =?us-ascii?Q?47xSvnMZZDyzyha+F1sg7bnV9jajmC50+Qp3P78y0QIqXqyU5nInbeSvkIXc?=
 =?us-ascii?Q?HXgHPWDGAfL0x2ODlqAwnnRYfLBFICXPYe82JoLz+1usE9io7oARQ6pQa7q9?=
 =?us-ascii?Q?R0tyhSXh/0OBrfMQPhI/Li+9kvrAj0Jpxpjzo7BCFXoKWG/vFyLhHjyVTVmc?=
 =?us-ascii?Q?2jVeb4sLIwl4AdOB1z7G7tG5B+84zVy5lW4boekSbJ4/6BjNP5JEmmYYTv/C?=
 =?us-ascii?Q?tO7ugC2rXRKwFP6vUxWMsbdF1S7PvSM4HvUNbgesrpOaNry6ITp5uYIwV4Sq?=
 =?us-ascii?Q?PiKDa+PM3gdmsXIrwpkvbc5muZqWV+3NwN0A0HIwcKUFqwks92CPvAPivR2Q?=
 =?us-ascii?Q?EVCVtZuD5JpIfNtHei+GWFDvwR2vdDU9FC/+r/lb7Vf0audxhAfK0GZfRzpN?=
 =?us-ascii?Q?Zfd1Cbt/eewGpiZ2iLcvyXY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8606d61c-ed09-4391-7492-08d9e0b717fd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:32:03.7790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeX1QWl0pnwMrb5DKb06otsfg+M8zounM49lSUtQZ8+zt04YhPNBGjbF4p77LEN/tdm9LXUgfM2hCN5Y3lwhjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

MCIA (Management Cable Info Access) register is not supported on RJ45
ports, so getting module EEPROM should be rejected.

Therefore, before trying to access this register, validate the port
module type that was queried during initialization and return an error
to user space in case the port module type is RJ45 (twisted pair).

Examples for output when trying to get EEPROM module:

Using netlink:

 # ethtool -m swp1
 netlink error: mlxsw_core: EEPROM is not equipped on port module type
 netlink error: Invalid argument

Using IOCTL:

 # ethtool -m swp1
 Cannot get module EEPROM information: Invalid argument
 $ dmesg
 mlxsw_spectrum 0000:03:00.0 swp1: EEPROM is not equipped on port module type

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 52 +++++++++++++++++--
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 5a9c98b94b33..b63e66b7e2b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -28,14 +28,47 @@ struct mlxsw_env {
 	struct mlxsw_env_module_info module_info[];
 };
 
-static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
-					  bool *qsfp, bool *cmis)
+static int __mlxsw_env_validate_module_type(struct mlxsw_core *core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
+	int err;
+
+	switch (mlxsw_env->module_info[module].type) {
+	case MLXSW_REG_PMTM_MODULE_TYPE_TWISTED_PAIR:
+		err = -EINVAL;
+		break;
+	default:
+		err = 0;
+	}
+
+	return err;
+}
+
+static int mlxsw_env_validate_module_type(struct mlxsw_core *core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
+	int err;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+	err = __mlxsw_env_validate_module_type(core, module);
+	mutex_unlock(&mlxsw_env->module_info_lock);
+
+	return err;
+}
+
+static int
+mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id, bool *qsfp,
+			       bool *cmis)
 {
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
 	char *eeprom_tmp;
 	u8 ident;
 	int err;
 
+	err = mlxsw_env_validate_module_type(core, id);
+	if (err)
+		return err;
+
 	mlxsw_reg_mcia_pack(mcia_pl, id, 0, MLXSW_REG_MCIA_PAGE0_LO_OFF, 0, 1,
 			    MLXSW_REG_MCIA_I2C_ADDR_LOW);
 	err = mlxsw_reg_query(core, MLXSW_REG(mcia), mcia_pl);
@@ -217,6 +250,13 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 	unsigned int read_size;
 	int err;
 
+	err = mlxsw_env_validate_module_type(mlxsw_core, module);
+	if (err) {
+		netdev_err(netdev,
+			   "EEPROM is not equipped on port module type");
+		return err;
+	}
+
 	err = mlxsw_env_query_module_eeprom(mlxsw_core, module, 0, offset,
 					    module_info, false, &read_size);
 	if (err)
@@ -358,6 +398,13 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 {
 	u32 bytes_read = 0;
 	u16 device_addr;
+	int err;
+
+	err = mlxsw_env_validate_module_type(mlxsw_core, module);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "EEPROM is not equipped on port module type");
+		return err;
+	}
 
 	/* Offset cannot be larger than 2 * ETH_MODULE_EEPROM_PAGE_LEN */
 	device_addr = page->offset;
@@ -366,7 +413,6 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 		char mcia_pl[MLXSW_REG_MCIA_LEN];
 		char *eeprom_tmp;
 		u8 size;
-		int err;
 
 		size = min_t(u8, page->length - bytes_read,
 			     MLXSW_REG_MCIA_EEPROM_SIZE);
-- 
2.33.1

