Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADD560C980
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJYKJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiJYKIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB994E19F
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imKH1o/gQe2ilj+nANsxjpMYhlF+CEI6i4aJXp28Vl5ewWSqgma1KqOHbA79Ehlm8TroMQweCwEIREJzeh3H3300RKI5o3VemyafNt6Q+TKky2UWVsdW+/XDlQNAXp8wa4Y+VSS3XqB2odsNqCprs6L/bI+sdBeKDzDUVRn6/tBaNLfpphwgXAS0TSnFDL/0NzE7D4uHL0Ea/GJouUtXbbkCZxhOkoqkrrW2RDVvVQZ6TSF2YkBC4JLxKMEMZerpX6aZWW91btdYWLG0V2HjrryKlhsy2Qa+aovRCxMj9XUEVrel49TmoUxydIFjQjMIQ2A+p57rv6E3Xfm0UFt4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zop3vzj9KLLSzeQ7JRIr/JoeQPSvvsIPznKs87oUeL4=;
 b=jGnjpIsTQgYyBQK3aKIFTqU3v9/pHmASKrwx64yc0p+dYlbz7fTtcRWN9lDIcNPc3IQt2hnTvJvq3ee7yciZQbOGvn8VTyNG3J6chCIdMTxYVFbqa0VJeyJvSJ0XUg1vZsAct4j1+0Sq70lj6WYVqk7nkY045kEMQS61P5/tVSQiXjix1R6hKpgLAo4tY+h2XhaILCcO9zmNwQE1ZK8F0gzF4OfzKlszeYV/sv2U+RJcLmgfDgqEoU4bfE6cUkjLeiwmzZUUK5LTZIh8BS43jqJIcTJD+uuh7HIVMUL7E1ksGqzv7ttOJJtwJMJR7sOJok/Hp4ks1Go/VOrOA9IMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zop3vzj9KLLSzeQ7JRIr/JoeQPSvvsIPznKs87oUeL4=;
 b=FDmVcMgXHKYeIJ/89yLPNELz29ZkycHUXxxFmJkxWyu5B5gcqw+TUcpxokBQ54IK3Iz9twEbYwiQVm4mEu4ZqXrqUYLZCm76uv74EfmLRdfa1pF75b3s+6wkyS7djqdE4LKrRkNqFGSBKr46TRAtAGfqPgNh+Ynme7wI10QJCfv60892k7nWQptHDSmqn4RxBJZHdSnz9gD0c23jrN0+JoE9BobhRKF0ZM/JhDkSA/lBUIZbnEVMpT4WDS1M7JIozQ9jP2R7kjvdnN70H0hTVvWDuXrAgBNDAzl8Y0Deq+Ozldx/rlQ0+RqGu+jjMpHtyShQOFJwKnasHfyhyOnFwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:02:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:02:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 12/16] mlxsw: spectrum_switchdev: Add locked bridge port support
Date:   Tue, 25 Oct 2022 13:00:20 +0300
Message-Id: <20221025100024.1287157-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0045.eurprd04.prod.outlook.com
 (2603:10a6:802:2::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f5836b0-34ac-4e37-c3d9-08dab66ffcbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/zSbSjofXZ1pqH3xl9wzh1WZg/AFimv4pekxKZw9WlsbTBo49qRHgcjNXYat598S8e1/TmWMbdFxG2V7fW4n+AzT0nLfWJMeM0lUvSFh3jzAU1O4HUxN4Cbs1nNvVUwUhLo2Q3bjbjR/EHeDAIHFNme5GKu1Pn43ULF1A226XUwqwz3ciX+bKDzhIitz5eYp1R0SlUorjZfobwd6SfxzBK/jSf2YCK37S85UnNq5/oYFAP9mUKEgmZeIoD+8pLxZDbbjZoyP0V52INKzoJQdw2ve+ibcVPmSEr/Es3L7DWjsWI/UWFsy0UlScdktDFC8KI3BFvv6tV0bNIMVWZZY0Iw7KE16F+7/kaL3jxoecPCKpaPVRYZMFHvB15UxPzr7CWLF7ph2o5F5YFZr8EGXifakN0o5RkOLa5jY+Ngnoh4JfJRLbog2ERlj0aaDWFHzkgibwEqf3dPWCQDrtJaomsjR/RzvHDRIvFr3e5h8qiF1w/oHvchOoGu3IcoH4YebYfZVzZfeq4xjtFcirMCT9fxpPMJoyZKfyjQ1zMzGw5UEAc+apUa65ygTBtBGL4K541tkaxgAyKRjvcX6bVM4NxvjcT4IfkFE5J1rUKgJH4GkrvuSHKyk4jlJbPhFAAgSPEAy9yK5VFb5BhKE7XyLu+tqRuXAL8PnKwM58pRhf58uBmPa2c48DyWlgEO9T4UFDvooFhYGvnG+dZ05qn77g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vku8AMZZ8jT213Wq5YcDM2DIt56YKvbUxFXDWdxjSHoMNtmbMQXfr5iIwygT?=
 =?us-ascii?Q?czeCUUUpFymdGYwwUksEU9GTIZql7sgMUk2kVRhNYIYGzziIdiDtd5TAOip+?=
 =?us-ascii?Q?teYRyA474QuEcLv7EGMrp9CLuxt8caD32UJ8dp6XLsPcJ7DSUCSH0FItihlV?=
 =?us-ascii?Q?o11zqDLtW1M0xk+bfv8jnwya5edasKEa6IcJpilOvT0eOQ+mCwyJPYVty4s9?=
 =?us-ascii?Q?rj+c5MP6GtH2+1mK613r9NbF3Cu+lvQLB3llBuX+l/i5PmdxDOwXC6lDn51t?=
 =?us-ascii?Q?5ygJzXYp+H8F4VgxlgPgPlcnt74ZLwThPnxq+DUH18kIvGuyVrbRi5x7hZs5?=
 =?us-ascii?Q?WaoP+UVGgwsJxmrVrQiimxKLGwJZV7y80c+D5hWocos/NdjyQzRtVjRk7W1O?=
 =?us-ascii?Q?8Cm5RAoB3glLVJcBUC9pRX3zqpGUULoDMBduOU5Rttuj4D//HHSMqHQS4A0F?=
 =?us-ascii?Q?cYr71CyhOwhxAML16VJp5dG2ZizVfu3mT+4oA3rLZKaLSckl7AIRwYUutJ68?=
 =?us-ascii?Q?tPQeGiqIaxhWxbwtq8Cbgag73qDLAAp8O9YamBGIGgXg8sw/u3oIy0wKCPpM?=
 =?us-ascii?Q?7eyxg+ur26wcFHyOvXgAMHV/iYc0x496wB7430P9QItbncle2MFo0ZlrTyxJ?=
 =?us-ascii?Q?4DRC31gqFFsVhx1p/uXmXv0rgZXl4xIkClNCytfvdF7uDcN/FgzuXPoCRLj3?=
 =?us-ascii?Q?r8dZsunfdOz8ehfgeK5JIfgzv+eBsEIHAgKYighR1GLaiaH6wXpCJ8EIR1Px?=
 =?us-ascii?Q?wQzdmg/2yNyBBIYetW9TK0VlAKZ4m4bdzIWkT27zIOCsMyIT2bl9RRKc/NDV?=
 =?us-ascii?Q?2qmT0TEsdGr3e49mpEI2BY8lypCg9gqt0X8LIdxVj9bHuTi3dd9ZtQb7FT43?=
 =?us-ascii?Q?CBr4XHvA1iBQnP3QKhHk8mMMK7A47VSIsI4osQqEsZL2wJpjqElHTOk8rA0t?=
 =?us-ascii?Q?pkNX64sj8cEKH8IUCzgg+vTiZYP9CwdpDhBtlbsSrG8pD1xYOzHeMoNlviq6?=
 =?us-ascii?Q?ke15gIlr1Susp8ZXMGPWRvt5F/dgnRqxBjEo2OmEIjL+BA+KSZvM+eHGG9kv?=
 =?us-ascii?Q?FQAi4n0kflXFNvlFk0MTVMorCWbBs0fkEP02ULqzODL8BC4twJrhz6TAwejH?=
 =?us-ascii?Q?kg4UQjOEmBmRzY35ApVYCkaRXLDijlrtXELUk+Bb18iiDoN6yyzu9CF3HL5u?=
 =?us-ascii?Q?/KPP6Gi6+5FEDKZzClfpvMdfstiFwd8siQcijioHKYy+QXxDN7Dc1d9qijU0?=
 =?us-ascii?Q?jbigikedvbVq12jSzWy1NsDCCY3KV2cr6QYyU1fsE77iCKMLjH2vWKJuqsoZ?=
 =?us-ascii?Q?TdIb4JbwJvsth/E6sBTqJsAMVdgPo+MOxGSjnzSFDL5b5sdTSuCYh1nVDCrW?=
 =?us-ascii?Q?zrUJ1gCCrXml3IaF1gMWJN89nFTNUcLCgT5veZdgZpvYOSGMJdkUu/ZF48X7?=
 =?us-ascii?Q?5MDMszsFihv/EBFspACZ9fOI2/Bu+83hsrgh+MQcW6YMqdM0k/zFWOX9kM9/?=
 =?us-ascii?Q?nFCn5PMA/BZNGKrP9lCTXwBOTbw+elUEM+dM/v69SWptlaZ0Hd6SgGplCYpW?=
 =?us-ascii?Q?2qMrCpJA1aqNM8NH9Zj0FJZdqBmhCpBmOsrYFKgL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5836b0-34ac-4e37-c3d9-08dab66ffcbb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:02:12.6010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eIJGgBEirEcE0Qp1fnjaJTxjAIB45KkU6AxeBPO5su8r0sL+fbZ68e9bRyxjIa0PwKK+NpLsIJhbGxasVbu7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add locked bridge port support by reacting to changes in the
'BR_PORT_LOCKED' flag. When set, enable security checks on the local
port via the previously added SPFSR register.

When security checks are enabled, an incoming packet will trigger an FDB
lookup with the packet's source MAC and the FID it was classified to. If
an FDB entry was not found or was found to be pointing to a different
port, the packet will be dropped. Such packets increment the
"discard_ingress_general" ethtool counter. For added visibility, user
space can trap such packets to the CPU by enabling the "locked_port"
trap. Example:

 # devlink trap set pci/0000:06:00.0 trap locked_port action trap

Unlike other configurations done via bridge port flags (e.g., learning,
flooding), security checks are enabled in the device on a per-port basis
and not on a per-{port, VLAN} basis. As such, scenarios where user space
can configure different locking settings for different VLANs configured
on a port need to be vetoed. To that end, veto the following scenarios:

1. Locking is set on a bridge port that is a VLAN upper

2. Locking is set on a bridge port that has VLAN uppers

3. VLAN upper is configured on a locked bridge port

Examples:

 # bridge link set dev swp1.10 locked on
 Error: mlxsw_spectrum: Locked flag cannot be set on a VLAN upper.

 # ip link add link swp1 name swp1.10 type vlan id 10
 # bridge link set dev swp1 locked on
 Error: mlxsw_spectrum: Locked flag cannot be set on a bridge port that has VLAN uppers.

 # bridge link set dev swp1 locked on
 # ip link add link swp1 name swp1.10 type vlan id 10
 Error: mlxsw_spectrum: VLAN uppers are not supported on a locked port.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 ++++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 23 ++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 10f438bc83dd..7ca96a4937b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4772,6 +4772,10 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
 			return -EOPNOTSUPP;
 		}
+		if (is_vlan_dev(upper_dev) && mlxsw_sp_port->security) {
+			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are not supported on a locked port");
+			return -EOPNOTSUPP;
+		}
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index db149af7c888..70b4f8c4b038 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -782,14 +782,26 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				    const struct net_device *orig_dev,
 				    struct switchdev_brport_flags flags,
 				    struct netlink_ext_ack *extack)
 {
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD)) {
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_PORT_LOCKED)) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported bridge port flag");
 		return -EINVAL;
 	}
 
+	if ((flags.mask & BR_PORT_LOCKED) && is_vlan_dev(orig_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Locked flag cannot be set on a VLAN upper");
+		return -EINVAL;
+	}
+
+	if ((flags.mask & BR_PORT_LOCKED) && vlan_uses_dev(orig_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Locked flag cannot be set on a bridge port that has VLAN uppers");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -822,6 +834,13 @@ static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			return err;
 	}
 
+	if (flags.mask & BR_PORT_LOCKED) {
+		err = mlxsw_sp_port_security_set(mlxsw_sp_port,
+						 flags.val & BR_PORT_LOCKED);
+		if (err)
+			return err;
+	}
+
 	if (bridge_port->bridge_device->multicast_enabled)
 		goto out;
 
@@ -1189,6 +1208,7 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev, const void *ctx,
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		err = mlxsw_sp_port_attr_br_pre_flags_set(mlxsw_sp_port,
+							  attr->orig_dev,
 							  attr->u.brport_flags,
 							  extack);
 		break;
@@ -2787,6 +2807,7 @@ void mlxsw_sp_port_bridge_leave(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	bridge_device->ops->port_leave(bridge_device, bridge_port,
 				       mlxsw_sp_port);
+	mlxsw_sp_port_security_set(mlxsw_sp_port, false);
 	mlxsw_sp_bridge_port_put(mlxsw_sp->bridge, bridge_port);
 }
 
-- 
2.37.3

