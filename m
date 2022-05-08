Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B75651EC21
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiEHIMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiEHIMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:12:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD3CE038
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJTMva4zU9CeTdYLsvSsEgjEBrPwS0wa5epbu9IXGYH/NUhMezwPTk/y/PI+xpAwo2ERP576G+wa1dWprFvuWmAsjrJOl42pO5TqgrIn4OmZKl0F0guG/P7SHfjhTCoILQB3X1nPgahsMFJ1awUP1rvuMEVVmBuYbbDctT4Am0b/LY4oyhHwJ9kJCm8ZbAqUuw53S54nMsvKQZZoDVONlFJ0B9GvfXs8YW//yC1YEpltZiwQaHl4vCliOm8df09jUPIhOy/6Btez54JYMtiYm3W484RTggdaoE5K2i2n42DKZwFfOM+G0c3sy95W4g7YOlufLqGp1lir2bf5UxV80A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fN/bu4MIvBOksoM9ejh1sKwNe36L2/OFSkd+QYZvJfQ=;
 b=U8iUTUaAtOrbf5IGwwpQrJQyr33dTmyyrQ8wcdQRvmxUWJsr6MPP+Zr1/0TxEp8bCpR4FbiQZNLViqExPoAUsXpMjc93UrzOj9X+tXVuy5/4xIGe8lAv2+uks91aAQKoatBzDHSq1MO6Du4xJFP80MHzJJ7RXXUKolNopc2PU9jYfrv1bFIUUd/L+VUukR6G4bkqTXHyEum/F6IrS2wDV0Oq0OipL+1qG1wLggDrxax6ts0GeVYvUF2lxjYCtWMDsVfJNeONBOypTNJWVuj3cC+ppnndGwss8MIPNfnbPwKVM4ldzKya3MJAmKECGFKBVdh3M4eSiq5pC72R6UK67Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fN/bu4MIvBOksoM9ejh1sKwNe36L2/OFSkd+QYZvJfQ=;
 b=t6PO6SSW04C6fuMIdGC1POR9y6UIjNAZd64I/fOj4wSrMU/UNSD8EDIxD7a6OSQqF0bE+03/Mtq281rmutAVCnz3eYAttSoUKVCiSAQbRz2A2pQ00YwEjl8Yf5PmAtjRXS7TUbD/03nI3Zu+N80IT+hhz1vs9Txy0Eke2VqZKbuV3QKcAahP1A3tZ7/sWqdgThtItSLRMsElSnwKCHUgPSYAvtfXdv4w2USkqzJMcUBRpwNqFGorUHyunzsUL9genOkzmqOFLOTlhUZtIxRIPSEuSscUvGg8p8pdx4ArAah/kJujuU6P72fT9yTXrcJ8dwdzX2kMdrUCHEJ/HM1TuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:08:56 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:08:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum: Tolerate enslaving of various devices to VRF
Date:   Sun,  8 May 2022 11:08:14 +0300
Message-Id: <20220508080823.32154-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::12) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb91ac4e-9773-4f07-9c7d-08da30c9ffb7
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60967596F56E82E2C10696FBB2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5nJ4vkBDDROuuJ5vrer3yVxP2rIJDW1jS6jkTv+SX9WQxTGj8rY7nVcPHPup6tJpnDtHorhMtuNb+16WOwhLAIRJK6mUcrZkc+ElEiU6cVjaOB7Lk7KfpsICr9ek+Ljb4dQcqui/MDobvSCKJSILTUl8LUFDCuw1XQuFUZ70L5x8rK//Ex45BxI+4yU9Cnp1iF/WJqv7+3V3WyKDOAEzxQHVr7LqCbtFi0W3JL355I7NL4jldQJv24emoT2olW4CZbHTlZjwExLcGYwuOlUAJ4nHf+gVWhAzN4I2CyxZ+LVg7H7+oRp32mLQUSZp9j9wz1xrPtMbeR5ZDq3LkN5Prtdd3xRR47RFJ/X18kny8hgMua2A5yBMq/t5zcWMFT51jX450gw2HFgP+hc6DP9HIscjGUDt/pFZRLSQHKZq83Bdt+a7u8KFv/rkBMIVF1P/BnOHLC7Qmrgr3Bq89rwxqeoI2oiJktvmSyFfMJnMBoFj7Zs4haj6f3nqGWPujt1MbOGWXt2CnNXp3uMZIe2sJqQSRZk9OEjoHfZ+SuW/112kh53WB27XPc/oOiQeaCEEKSL6eLCBLJLS54RWcMrQFj3iSU7FgBWq41v1/WUl/BQu6T03yIDNXPTYsOGmwzdslDehxLFn6b82R2tDd/lRXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOVaaP6F+0/siw9ZoJ9l/i2ytcygXYoVmGlV6JLvnIA0BcDcm6NDwBIh50P0?=
 =?us-ascii?Q?VuXKDX+aP95I7/cOwf8P2DcYlarlH5xPI+hyv1SWJgmm9GqkPP1Kyr7I6H9z?=
 =?us-ascii?Q?CO/gcVxQ2PCvH1OWf49RUaYLYxrJ4GDNks2fSg0HNJu62XTjrN9pqtauU1aN?=
 =?us-ascii?Q?TWbWooVd+PL22quB1BMLC/qRTBGoJLzK3q9o7A7O0u7Frt7nEhcJT0OGOtQ5?=
 =?us-ascii?Q?ild27oZ/CXPBe9jB2XhCu875TDjO6dqAjMRGeDG3ulfKnmYDr5jRO9JdD0vz?=
 =?us-ascii?Q?w2Ycx06/1QAO5dxYRejjQ09ui32u/v+YuQli24BgNanZ5a6E5iV/One1kkI1?=
 =?us-ascii?Q?Gj3Ka1RlWDW+QwtEBZUYNyPOKkPGQlmzgvlFvmtWLUmKouIk/h14TL8UJmLS?=
 =?us-ascii?Q?A4uA72bFUH+gofjaytlPHGDas6vIEwcf+8UU8SZrD4pUWmjpxOK+4gBIjYq0?=
 =?us-ascii?Q?4SQZ7bflAp+GtbtmQIJQLmqjdnmnU+l3QzmWaPtJFrniYqXE4BI3lxho6/ad?=
 =?us-ascii?Q?JBjx7KkZYWwBnf7oCCXDUu35D/sTATpP2Ah3XKQ/khCpawGTmVfQqhJD8VwW?=
 =?us-ascii?Q?6yI0oTak7Y+e5w8oyEZOroXnWM6P9xzGptuuRxT9jJ1qeTWUmEg0dM8KnULY?=
 =?us-ascii?Q?JiKB+I6Co/xrcZzWMN0NydCerTYZNjcEhARE29+nflCRWOwyN8gBtUjCDMFj?=
 =?us-ascii?Q?+NP+kW8EEnqUdrixUw03CqsuLAAmcf4IUW72hXjDqhWRPfNOAzSw14kBGO/c?=
 =?us-ascii?Q?VLN0jgW8ldgrmgJrCwwAUOqBAlxSqvE7+gtC0yiIPofwHqA5o6EOG8lL9Snc?=
 =?us-ascii?Q?wyZihx/SPIz9VWTj8/KKGHLBpKcNRPJmePL4Teq5iFZHfv/YrquJm+RccULO?=
 =?us-ascii?Q?4jFhzpLV59Lz6InTRHeVwvuNWrMKsI+JcSKSk/RyJqy/QP03d+dYkQ+f17lS?=
 =?us-ascii?Q?/pMDqj1PkCr4He+1Hq9+cHk36N9y8jPL+xITUS1jcP5DpHilPslxpe6Z72fP?=
 =?us-ascii?Q?jxjliamGK51NejyZ90hWmNHcAtQ6RQJkALM7/7fsbSpRNJj969GzAeaVJlU7?=
 =?us-ascii?Q?dLWWasCXH8GdIIwETZIXizLobOuUAgYENjOLm3bjYnxMxrx7iF3oTpGnU4Pg?=
 =?us-ascii?Q?w+Ybu8VWQaUTvKp426urGnyLlMnPcOJ5vJXKiAV709w+WmegZAogw4DdtpKw?=
 =?us-ascii?Q?0mXV6cFQNDSYK4iAqZDCRT3IOK0WJXlP4lLXiFzTh5ARpLccykpZ1z8X6zUN?=
 =?us-ascii?Q?/yViQvNIJp82KVty9BMXVbKqlyeJCMAUXzGrcaUIW5mj5Z/JqptOGDYSvzPi?=
 =?us-ascii?Q?NP47t+rmU26JkdhpmvZJHcEw1MxTelu7CvFJlo//S49UZNfy41n+pZ5LuvM6?=
 =?us-ascii?Q?zImbA1vIwSKqMSGX6+fkWq8tI7L5U3sq7JsLP6umYHFjGkZRbk9K6qIYRh3O?=
 =?us-ascii?Q?qVh4hDkXjldZQgrbLf2jyYc05/QkaK9ncYfQZxuWZ6sDLWbWSzPUMnp5Qupu?=
 =?us-ascii?Q?VyjDeiUrGVC8zbHRw4hL/lA3ynkSGwJSF9iYpFD6JLTvIburjFg0W9S5mXpr?=
 =?us-ascii?Q?UuLMzuHoBflvU6eM1U5QHLNHKMVU7n1I5ZEtzE21Dyr4AF7R39eglnkcETfU?=
 =?us-ascii?Q?y/mj/pQwulnOBqhSxh6IxE5dQDlu2834S8FGzD+auM8SKUmyv4CRaeBYUNKr?=
 =?us-ascii?Q?RF0kPd7KYRHwKUSgoIE6SA9ePo6nKZkEsQgm3Nrr7qXKLIN6UMOrBqkgtbXv?=
 =?us-ascii?Q?iALqLadFTg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb91ac4e-9773-4f07-9c7d-08da30c9ffb7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:08:56.4992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwN5OEVbbD2AUN0Tw4JXL6kzHWNdPxCf3rThjZW7PbGPu1eNJqCn7khXU/YKx98nQ1HcmAhGnEzXtQ9r2gLSEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Enslaving netdevices to VRF is currently handled through an
mlxsw_sp_is_vrf_event() conditional in mlxsw_sp_netdevice_event(). In the
following patch sets, VRF enslavement will be handled purely in the router
code. Therefore make handlers of NETDEV_PRECHANGEUPPER tolerant of
enslaving to VRF, so that they do not bounce the change.

For NETDEV_CHANGEUPPER, drop the WARN_ON(1) and bounce from
mlxsw_sp_netdevice_port_vlan_event(). This is the only handler that warned
and bounces even in the CHANGEUPPER code, other handler quietly do nothing
when they encounter an unfamiliar upper.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ac6348e2ff1f..12fd846a778f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4525,7 +4525,8 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 		    !netif_is_lag_master(upper_dev) &&
 		    !netif_is_bridge_master(upper_dev) &&
 		    !netif_is_ovs_master(upper_dev) &&
-		    !netif_is_macvlan(upper_dev)) {
+		    !netif_is_macvlan(upper_dev) &&
+		    !netif_is_l3_master(upper_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
@@ -4724,7 +4725,8 @@ static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
 		if (!netif_is_bridge_master(upper_dev) &&
-		    !netif_is_macvlan(upper_dev)) {
+		    !netif_is_macvlan(upper_dev) &&
+		    !netif_is_l3_master(upper_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EINVAL;
 		}
@@ -4763,9 +4765,6 @@ static int mlxsw_sp_netdevice_port_vlan_event(struct net_device *vlan_dev,
 		} else if (netif_is_macvlan(upper_dev)) {
 			if (!info->linking)
 				mlxsw_sp_rif_macvlan_del(mlxsw_sp, upper_dev);
-		} else {
-			err = -EINVAL;
-			WARN_ON(1);
 		}
 		break;
 	}
@@ -4813,7 +4812,8 @@ static int mlxsw_sp_netdevice_bridge_vlan_event(struct net_device *vlan_dev,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
-		if (!netif_is_macvlan(upper_dev)) {
+		if (!netif_is_macvlan(upper_dev) &&
+		    !netif_is_l3_master(upper_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EOPNOTSUPP;
 		}
@@ -4874,7 +4874,9 @@ static int mlxsw_sp_netdevice_bridge_event(struct net_device *br_dev,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		upper_dev = info->upper_dev;
-		if (!is_vlan_dev(upper_dev) && !netif_is_macvlan(upper_dev)) {
+		if (!is_vlan_dev(upper_dev) &&
+		    !netif_is_macvlan(upper_dev) &&
+		    !netif_is_l3_master(upper_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
 			return -EOPNOTSUPP;
 		}
@@ -4918,16 +4920,20 @@ static int mlxsw_sp_netdevice_macvlan_event(struct net_device *macvlan_dev,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(macvlan_dev);
 	struct netdev_notifier_changeupper_info *info = ptr;
 	struct netlink_ext_ack *extack;
+	struct net_device *upper_dev;
 
 	if (!mlxsw_sp || event != NETDEV_PRECHANGEUPPER)
 		return 0;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
+	upper_dev = info->upper_dev;
 
-	/* VRF enslavement is handled in mlxsw_sp_netdevice_vrf_event() */
-	NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+	if (!netif_is_l3_master(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown upper device type");
+		return -EOPNOTSUPP;
+	}
 
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 static bool mlxsw_sp_is_vrf_event(unsigned long event, void *ptr)
-- 
2.35.1

