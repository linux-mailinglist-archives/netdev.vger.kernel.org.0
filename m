Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5C0D50711F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353665AbiDSO6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347205AbiDSO6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:58:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350342B18F
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8RYfwP8koIwAL5EEPe4ZNqvSgTTSLSItakndfy7vf6jEXtoUfRPTepFZdG0RtHvvpjyqs4Q+AOVd0ocOBGj3TBV4peKIdEvOvUJ9DhewvfoLEhevUqKOeNzj45IHO2oNWeSGY2arUzNpxvW6UMGVoztBwoWLDS8XLK4Ah3LtlmvlIeDuhtD277fxk+NoTRDvSwQ1iEq8dyEAnLHYUva1+iQAUfyyAxAqYlKY/KYR05gVmtiN4Ep4TirrgOgtOSzbHJBybUecACvrlLVEBXvxx3T0PVpHeDh4QH7wlAc4gRsboUhlwYbzfAHyEaj2NlSFaeauSma9OUmdhrsoZ/KFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elySh5niHyzK/DzdfXwwe45OttsaQJ5GdIdOyrzQvco=;
 b=D0rM4arEdCVNdVhGkWallESI0mplzBrGBriBc4Ov1N2cua3NrTzarp1zHjzSoGIJd4jJUv2q8lHsLXgiLm+eD9KOd6vHet546onb/AK3dHN0xMwld5QwgZ+ZO0SagGYgbYxfCB8AM9//v8iW3xAWVt4UiPdrn24a9j5d+ueEbqRJtl8V4zWY4XnX9IQAymMYk7Lh60KYVel0L2fJzvK+VzNqDrt6q29OY2+StS1YDc7VGTg1s+Doq+v3Gttx1CmHRJFJFAQOoflt8rdoakHVO0bPDffe40hNQxAR4GH1PYNyEzyWhsnjhzU2jxxrUbz7YHd0aiAVq4Ix/gIz1sb3Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elySh5niHyzK/DzdfXwwe45OttsaQJ5GdIdOyrzQvco=;
 b=d9jGOQXQz/P5tbp4ATBfwqa4052F9UR/If9aOn+zX0ggvDemHmHhaSHmgrgCR8R9dI0oJFfEWYZkgQeGS+sG47uoX8tZOpX8ajavYQiPQ7NFZpQGKfHdjIqi52ks+v/Gk0FB9/lIQ9Rumz9pgifGSpjO8AnA3kT1/JxaqAcSAZ8zh7ZSkaWc0409kUms8C9h7iLVxzNljhBzPp38gs9N4zSzmLf1BpKNTAjjFW0iS1GWYOmEYg79mVnq1vLkQhUWrVyq/W4e853mHRXPHDtwFEXewfajMVwTKaELSgi9nRXoCF94sOvvAVAVUQkR8wn2xkIeG5dq+EqwBfGMDbG4sA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:55:33 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: core_env: Add interfaces for line card initialization and de-initialization
Date:   Tue, 19 Apr 2022 17:54:29 +0300
Message-Id: <20220419145431.2991382-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0021.eurprd05.prod.outlook.com
 (2603:10a6:803:1::34) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 226680c1-c8d4-4a44-2af8-08da2214a73d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB13786EFD72BC73C88286357CB2F29@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PV/n2nRcniu5IcLPfftnGFpCX1o/SnTSI8BQKP+uSXUQfS97y6w97pJ61vkiiXri3IOdYbGa6A9pTGSIGKJsr4g7NjId1SR7cxM6oqiEyCquBSVWGallJMK3pL7hsk2Ln6uZCE9oLJUuUkZpwJRYZhQwggJ8iE179rsWY9RZSf5pYClQdRQ3drrK/Sr/HAgmztvqw1gDJxoHtalKKO0hF8+xdkRWhCynS6unfNFbp8CiEMYFrBLKV9lWOfHamd91vob3NThQedatfjwROyd9BZwgqVnUawauZUwR0NxfNv1VHLBBBA3STyfPelMqJJ+lQljsbddR76E1UA/ZZaqZ9LMPoSKCa62b/D1mvtU5UmbOIb5cGvSYYsaDtVsB+R4c6/DyxcjaiYMzvAwRGe+HjohjLMMxNHKvJNoqXjbjrCR13j30H+Gc10vWrQYlqN2WEuz/Zo6+qU7o40F02U3iqMZj3paGuXrPKExFh9R3NJmpIFv4EMMmFV5BGp7eTWTy0eoQnMOktnfLoeUIJd3yrG+5WdL0orRMsBw9u4EoeCaXNbdM8BacR4SaYKSyMJAoMd7UU0XGZedJisc+/AAKEiPl8SxKZK1LLeB63k6CggW4pzvFXCm6MM+pnrfqQx9IKXmi7bfdfVtX9aUbhuE4gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(30864003)(38100700002)(6486002)(508600001)(6666004)(8936002)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(66946007)(66556008)(83380400001)(186003)(66476007)(2906002)(6506007)(6916009)(2616005)(1076003)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vUaZ23PYSP1kkM2yVBoxsyhah8KS1kPh14kLzoSZRWmsJxhy4FjazZZ64tKP?=
 =?us-ascii?Q?fhRTF5ufmHRcP1O57Ukwej+Db6RUx1jGm6DJ6K3BJuVFjv6jbrjvNAPWp32h?=
 =?us-ascii?Q?yMb+fAUQc5yr8F0kbxNdpVZWv0v7M9feMCuk8O5tSjgjQrtDCX4QnEo37Uog?=
 =?us-ascii?Q?6EKoK3mtLTnaD8IORGIKq1xNZwXpzhqnC9o3if0rASu+Og7i8aEGdma9/5JT?=
 =?us-ascii?Q?BcQfvr6JKMFPnXDIwWUE8M4LM36XcjpR6yTKjBUzTyJTSa8hCGmHWxVs/Sys?=
 =?us-ascii?Q?Ebodz9fFy+QAUCTT5+weAIKazeGsTFMLnc8HuFQ19z3stjUGISBb3za+IXRy?=
 =?us-ascii?Q?UBzkNHSe+r7L37Y1zutUKyOZSzxD9xwUcvAUSNDavogVUS/SALdYyJexKQ9P?=
 =?us-ascii?Q?iT1LWXK/1EtF9ouxdFIS3Rq9LHvsZyXCehk9BBW41ce7CXAJ2GPThUXY1iJl?=
 =?us-ascii?Q?o92czhjWP1jgwNLrkWqNrH+wdAhgQ7QpzXH1tMnL8m6FyESW5g77lihhkkco?=
 =?us-ascii?Q?x+P8vAuKs64y1S6Wk1aoJ8JDheWlCoJ17c15hsdmcek9w3pQzalyGcGjVwr/?=
 =?us-ascii?Q?8DB0kLFIGuZi56oOHJH7xHlCO2G9KDBXJzGgAC2dyfU0sgw719HvjlZBNFdV?=
 =?us-ascii?Q?0/ROft4eH2YerpP4MVUx0PT7D9F2uwy+ZWvHnYkiQhwjzhVsBM9jbRcoa8HP?=
 =?us-ascii?Q?fy56P/UEhqiZCXp7LkJzw/PbOEzvSwrB5liBnTkL/mFMB3NiXFVcP3x+SW9S?=
 =?us-ascii?Q?polLA8+2u+SIo6+Bxk3IBikffZiXA46+t06/ceJYdJA3yYAK4pabQbcs9XBc?=
 =?us-ascii?Q?WvuT5WUBI3Ri+RAeYEELGYS2uceCgvKy5YB+fAnVpgPxzmFQjiJckM9mknjI?=
 =?us-ascii?Q?ukF1QN8tYpt7/7xh7WEf5dbWMmxiRnV+fZUxO7oeeZN4HKhflajKH1jc10J8?=
 =?us-ascii?Q?wiOseoe5qMG74iN/0rHFZWlyB2d1P21pJ6S827cNfta5BdUmHzf8EJCZOg6X?=
 =?us-ascii?Q?z5xp3sy4chj/GjxDc6TKsn6Io35CfKcrzHwbTnhEbSgIbwHtkoi9KgayOIQ1?=
 =?us-ascii?Q?igVNm/v+ctwb59hKTE2uMeA+YPWlk0M4Abb2EpjAGuiYa5Mf91D7d5VKuoYJ?=
 =?us-ascii?Q?8ngfU1/dCDrGFc1mHgW59NEjKnxHSb7OLcyJDL0CBEjLmTRwCOIAwJ31PMb1?=
 =?us-ascii?Q?WW4sWvccl8odLtYTs4FY3GPBJ5QVt5sP5C8vh8rSvpMHbIex5DAXtuD0MZ32?=
 =?us-ascii?Q?JU0fsPAgxJJU7KBU+4kNmV32I2YHr5VG9XnqP920tEDJEbs9A2ZZpeuOzvQz?=
 =?us-ascii?Q?lFijt7XzCFyZpflQNMlK2I6Os1vW44DTSx6zBpSch2diIfTMJSJVuI8OPxwe?=
 =?us-ascii?Q?EYDyStyr5Y7KyPFes6jH374z8J/a+kl2MfmivT/sa/5Dv0SuaI6lNkDch18y?=
 =?us-ascii?Q?mn8Rl1YXkCnFiEdpO4mZ8YNFJ5TAyAbc1cxmI4VOiwby1K2r3gTlyuG1W7t/?=
 =?us-ascii?Q?/FYqAz3OL6sB9bur1e664qlB5YUke3HJntvIqxWwNulpgXx5dVDP4HYXiVeG?=
 =?us-ascii?Q?ATHvf//WHwKAj6iUbnfLTPx0Y48YenXJxbh1kCyHZ0p85MpKHDliTkzfVHC6?=
 =?us-ascii?Q?hnasdkYW+bYvZL4y1qqyNlIOGGPTeJndA4JCnaGmL9e6Im5+40h53PPXiWFT?=
 =?us-ascii?Q?s3rBxr71kp6Vs1CTYlYk/Z888vMaoz+t7lPhFJgzxR7PhA9CIoUVol7JRQOm?=
 =?us-ascii?Q?gNrK5NYQYQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226680c1-c8d4-4a44-2af8-08da2214a73d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:32.9496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuTuGDAwx6n4AREXGOF5/46TvtWs5yaEMYe/aogsr4t+5Who3TUm7TPEX4/2qpPeSgjCFyh1hp20wtNAVFxlRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Netdevs for ports found on line cards are registered upon provisioning.
However, user space is not allowed to access the transceiver modules
found on a line card until the line card becomes active.

Therefore, register event operations with the line card core to get
notifications whenever a line card becomes active or inactive.

When user space tries to dump the EEPROM of a transceiver module or reset
it and the corresponding line card is inactive, emit an error
message:
ethtool -m enp1s0nl7p9
netlink error: mlxsw_core: Cannot read EEPROM of module on an inactive line card
netlink error: Input/output error

When user space tries to set the power mode policy of such a transceiver,
cache the configuration and apply it when the line card becomes active. This
is consistent with other port configuration (e.g., MTU setting) that user space
is able to perform while the line card is provisioned, but inactive.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 166 +++++++++++++++++-
 1 file changed, 165 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index a9b133d6c2fc..34bec9cd572c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -23,6 +23,7 @@ struct mlxsw_env_module_info {
 
 struct mlxsw_env_line_card {
 	u8 module_count;
+	bool active;
 	struct mlxsw_env_module_info module_info[];
 };
 
@@ -35,6 +36,24 @@ struct mlxsw_env {
 	struct mlxsw_env_line_card *line_cards[];
 };
 
+static bool __mlxsw_env_linecard_is_active(struct mlxsw_env *mlxsw_env,
+					   u8 slot_index)
+{
+	return mlxsw_env->line_cards[slot_index]->active;
+}
+
+static bool mlxsw_env_linecard_is_active(struct mlxsw_env *mlxsw_env,
+					 u8 slot_index)
+{
+	bool active;
+
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	active = __mlxsw_env_linecard_is_active(mlxsw_env, slot_index);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
+
+	return active;
+}
+
 static struct
 mlxsw_env_module_info *mlxsw_env_module_info_get(struct mlxsw_core *mlxsw_core,
 						 u8 slot_index, u8 module)
@@ -47,9 +66,13 @@ mlxsw_env_module_info *mlxsw_env_module_info_get(struct mlxsw_core *mlxsw_core,
 static int __mlxsw_env_validate_module_type(struct mlxsw_core *core,
 					    u8 slot_index, u8 module)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
 	struct mlxsw_env_module_info *module_info;
 	int err;
 
+	if (!__mlxsw_env_linecard_is_active(mlxsw_env, slot_index))
+		return 0;
+
 	module_info = mlxsw_env_module_info_get(core, slot_index, module);
 	switch (module_info->type) {
 	case MLXSW_REG_PMTM_MODULE_TYPE_TWISTED_PAIR:
@@ -269,12 +292,18 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 			      struct mlxsw_core *mlxsw_core, u8 slot_index,
 			      int module, struct ethtool_modinfo *modinfo)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	u8 module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE];
 	u16 offset = MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE;
 	u8 module_rev_id, module_id, diag_mon;
 	unsigned int read_size;
 	int err;
 
+	if (!mlxsw_env_linecard_is_active(mlxsw_env, slot_index)) {
+		netdev_err(netdev, "Cannot read EEPROM of module on an inactive line card\n");
+		return -EIO;
+	}
+
 	err = mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		netdev_err(netdev,
@@ -359,6 +388,7 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 				int module, struct ethtool_eeprom *ee,
 				u8 *data)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int offset = ee->offset;
 	unsigned int read_size;
 	bool qsfp, cmis;
@@ -368,6 +398,11 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 	if (!ee->len)
 		return -EINVAL;
 
+	if (!mlxsw_env_linecard_is_active(mlxsw_env, slot_index)) {
+		netdev_err(netdev, "Cannot read EEPROM of module on an inactive line card\n");
+		return -EIO;
+	}
+
 	memset(data, 0, ee->len);
 	/* Validate module identifier value. */
 	err = mlxsw_env_validate_cable_ident(mlxsw_core, slot_index, module,
@@ -428,10 +463,17 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	u32 bytes_read = 0;
 	u16 device_addr;
 	int err;
 
+	if (!mlxsw_env_linecard_is_active(mlxsw_env, slot_index)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot read EEPROM of module on an inactive line card");
+		return -EIO;
+	}
+
 	err = mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "EEPROM is not equipped on port module type");
@@ -497,6 +539,11 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT)))
 		return 0;
 
+	if (!mlxsw_env_linecard_is_active(mlxsw_env, slot_index)) {
+		netdev_err(netdev, "Cannot reset module on an inactive line card\n");
+		return -EIO;
+	}
+
 	mutex_lock(&mlxsw_env->line_cards_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
@@ -543,7 +590,7 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 	struct mlxsw_env_module_info *module_info;
 	char mcion_pl[MLXSW_REG_MCION_LEN];
 	u32 status_bits;
-	int err;
+	int err = 0;
 
 	mutex_lock(&mlxsw_env->line_cards_lock);
 
@@ -556,6 +603,10 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
 	params->policy = module_info->power_mode_policy;
 
+	/* Avoid accessing an inactive line card, as it will result in an error. */
+	if (!__mlxsw_env_linecard_is_active(mlxsw_env, slot_index))
+		goto out;
+
 	mlxsw_reg_mcion_pack(mcion_pl, slot_index, module);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
 	if (err) {
@@ -617,8 +668,16 @@ static int __mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core,
 					     bool low_power,
 					     struct netlink_ext_ack *extack)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int err;
 
+	/* Avoid accessing an inactive line card, as it will result in an error.
+	 * Cached configuration will be applied by mlxsw_env_got_active() when
+	 * line card becomes active.
+	 */
+	if (!__mlxsw_env_linecard_is_active(mlxsw_env, slot_index))
+		return 0;
+
 	err = mlxsw_env_module_enable_set(mlxsw_core, slot_index, module, false);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to disable module");
@@ -1208,6 +1267,98 @@ mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 	return 0;
 }
 
+static void
+mlxsw_env_linecard_modules_power_mode_apply(struct mlxsw_core *mlxsw_core,
+					    struct mlxsw_env *env,
+					    u8 slot_index)
+{
+	int i;
+
+	for (i = 0; i < env->line_cards[slot_index]->module_count; i++) {
+		enum ethtool_module_power_mode_policy policy;
+		struct mlxsw_env_module_info *module_info;
+		struct netlink_ext_ack extack;
+		int err;
+
+		module_info = &env->line_cards[slot_index]->module_info[i];
+		policy = module_info->power_mode_policy;
+		err = mlxsw_env_set_module_power_mode_apply(mlxsw_core,
+							    slot_index, i,
+							    policy, &extack);
+		if (err)
+			dev_err(env->bus_info->dev, "%s\n", extack._msg);
+	}
+}
+
+static void
+mlxsw_env_got_active(struct mlxsw_core *mlxsw_core, u8 slot_index, void *priv)
+{
+	struct mlxsw_env *mlxsw_env = priv;
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	int err;
+
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	if (__mlxsw_env_linecard_is_active(mlxsw_env, slot_index))
+		goto out_unlock;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl, slot_index);
+	err = mlxsw_reg_query(mlxsw_env->core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		goto out_unlock;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL,
+			       &mlxsw_env->line_cards[slot_index]->module_count,
+			       NULL);
+
+	err = mlxsw_env_module_event_enable(mlxsw_env, slot_index);
+	if (err) {
+		dev_err(mlxsw_env->bus_info->dev, "Failed to enable port module events for line card in slot %d\n",
+			slot_index);
+		goto err_mlxsw_env_module_event_enable;
+	}
+	err = mlxsw_env_module_type_set(mlxsw_env->core, slot_index);
+	if (err) {
+		dev_err(mlxsw_env->bus_info->dev, "Failed to set modules' type for line card in slot %d\n",
+			slot_index);
+		goto err_type_set;
+	}
+
+	mlxsw_env->line_cards[slot_index]->active = true;
+	/* Apply power mode policy. */
+	mlxsw_env_linecard_modules_power_mode_apply(mlxsw_core, mlxsw_env,
+						    slot_index);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
+
+	return;
+
+err_type_set:
+	mlxsw_env_module_event_disable(mlxsw_env, slot_index);
+err_mlxsw_env_module_event_enable:
+out_unlock:
+	mutex_unlock(&mlxsw_env->line_cards_lock);
+}
+
+static void
+mlxsw_env_got_inactive(struct mlxsw_core *mlxsw_core, u8 slot_index,
+		       void *priv)
+{
+	struct mlxsw_env *mlxsw_env = priv;
+
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	if (!__mlxsw_env_linecard_is_active(mlxsw_env, slot_index))
+		goto out_unlock;
+	mlxsw_env->line_cards[slot_index]->active = false;
+	mlxsw_env_module_event_disable(mlxsw_env, slot_index);
+	mlxsw_env->line_cards[slot_index]->module_count = 0;
+out_unlock:
+	mutex_unlock(&mlxsw_env->line_cards_lock);
+}
+
+static struct mlxsw_linecards_event_ops mlxsw_env_event_ops = {
+	.got_active = mlxsw_env_got_active,
+	.got_inactive = mlxsw_env_got_inactive,
+};
+
 int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 		   const struct mlxsw_bus_info *bus_info,
 		   struct mlxsw_env **p_env)
@@ -1247,6 +1398,11 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 	mutex_init(&env->line_cards_lock);
 	*p_env = env;
 
+	err = mlxsw_linecards_event_ops_register(env->core,
+						 &mlxsw_env_event_ops, env);
+	if (err)
+		goto err_linecards_event_ops_register;
+
 	err = mlxsw_env_temp_warn_event_register(mlxsw_core);
 	if (err)
 		goto err_temp_warn_event_register;
@@ -1271,6 +1427,8 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		goto err_type_set;
 
+	env->line_cards[0]->active = true;
+
 	return 0;
 
 err_type_set:
@@ -1280,6 +1438,9 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 err_module_plug_event_register:
 	mlxsw_env_temp_warn_event_unregister(env);
 err_temp_warn_event_register:
+	mlxsw_linecards_event_ops_unregister(env->core,
+					     &mlxsw_env_event_ops, env);
+err_linecards_event_ops_register:
 	mutex_destroy(&env->line_cards_lock);
 	mlxsw_env_line_cards_free(env);
 err_mlxsw_env_line_cards_alloc:
@@ -1289,11 +1450,14 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 
 void mlxsw_env_fini(struct mlxsw_env *env)
 {
+	env->line_cards[0]->active = false;
 	mlxsw_env_module_event_disable(env, 0);
 	mlxsw_env_module_plug_event_unregister(env);
 	/* Make sure there is no more event work scheduled. */
 	mlxsw_core_flush_owq();
 	mlxsw_env_temp_warn_event_unregister(env);
+	mlxsw_linecards_event_ops_unregister(env->core,
+					     &mlxsw_env_event_ops, env);
 	mutex_destroy(&env->line_cards_lock);
 	mlxsw_env_line_cards_free(env);
 	kfree(env);
-- 
2.33.1

