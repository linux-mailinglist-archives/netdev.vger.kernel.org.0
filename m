Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8C758200A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiG0GZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiG0GY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:59 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419D7402F3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI0YMFOn/GkmCa5ahnT4G+x2lENVguq2eJ7fabFAUoYDiXDsYKCYk+xAUqijxLP1f6kbeTSzZ6PhKAjKKrNFIsFJBqqtsJ69DYoQRLfLe0wl8v7W+fk4yM9ccYuiyZSbogVWxAA6nFdefAz0hry6OdfGIUUZxN0k0vTmQmPeRzw5uCxaUHHnjoPWhiuDLjySPvwbGHCTUWgEyX6UNIFT3/IoqGh5jcmL2HcPdyi68j5tBKzqPxF5PfT+Q3EeOq84KSfrAwJfSJcs5g2mSbb3ghFLsJBdFdQeNBYkVmOz2fTMraDAu8Q4GAgSgnwgiosSFtIExikkf+LbwKshY+cJPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SBrGsn0NGG0lATcIyz5J7ZwRkCp/XJwGm9IDNBB6wk=;
 b=GGJl/3s8042SG6LtXb80SBpSebB4j/PiAvklpwPZ5u6BYvRgQ6fUP60513J9Whu+g3MsycG1N7hyfOwpIGvo/8KMc3/h84kF/Gxs/jBJ4oAI5KENuR5q39X+Rk/pi5P5z+r891aXTna4zruoJF5mU0G9e5Ny+7N6lX3HFkQ0QcvU/p6Aivpo77RzZLX1Ek5zHWEGvKUtpTld4USW77MeRlJP21oTskX2MI9KSwjYe3eiSAwEbDh/3DJ1O6j1VRUbylGD7a9qwOL+wLFoR3K6ipB/7R9ThxwLU3y2oVHB3Eua+4Bb+q1KuSeRr/WsOrhAzAN+70Yc4QTI5eO8v+D5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SBrGsn0NGG0lATcIyz5J7ZwRkCp/XJwGm9IDNBB6wk=;
 b=gk6cybr3M5WHvrQ5XaX6egTVceTyEeRKsXYUt0YUco5H6Y4oKuS39pG9hVZeUsskPiqKxnGSwdJWEW502mv8P83Dpw+Jols1CiGgqqvRKzlencNv4+yuEGVi1yqlx/BJv3+tde/+DyG0TpjP++QWWglTaeJG7lvzxiec9Qqr9QmeRCdKvp9lkBFMRq2wJYyi7YErXMIuKHYeUT6K1NkaxyYLwmgjlmgzdz4ifT85qz12SeXy628y/BvbEeMyqeIieObFbGJS5i/wkrhMBqcDMdYOiGAEegBlK7+ZAtrh2DFqE3jRumqH7qlTBE0KQsiI7Y6hWBNmdA3Vk1ipDVt7kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1697.namprd12.prod.outlook.com (2603:10b6:404:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 06:24:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
Date:   Wed, 27 Jul 2022 09:23:27 +0300
Message-Id: <20220727062328.3134613-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0264.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f03eb09a-e782-47c7-8d2a-08da6f98b576
X-MS-TrafficTypeDiagnostic: BN6PR12MB1697:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pXn/lGwcTdhAqqulbzH8wM/1sPR3QGVUfkdxhbdzgfzp426d5soNdoC4xlI+iADWJSEFaTsVJPFOQEsV9NpsGbL4etUbnj9K5bGViD1WS5s5c179wGLM1wfb7nJ0tzxQIOCqT3uT8NmvnOIvuygKNJ6RvpspRVm7iVHsULc2syx5JeoY5AtjAGUCkXFUr5HX5LC/RnRaFE84YT/Q1GC0KI9lGEwThFzAuyRSTuv6XVA9LAFTqYLdKrOTOUOcAoktqG+R3zj9iq4QuifC0fg1oQwMbHSs3pyFCBPh5YKL+PeOq4/e8dWdI5mdLBHFOOE0JEQ3/yG4/mLWvul///i/U3sqygLTLRX4F5kArT2tfGDt+PDArAlSyTUZ37INoqNenXkW4Ujr1/LZ6fa497bpnmQ+aVAs1NxiW7mNIMJHcujLTNJGjx766WkWsROhpHFilLtH+wjK3CGU2L5Jwa9GHb89E398dWrubjSyZkfTqc9H8+wduQwxOlg+jE65lyiClLt5MhTWiVMKUbSI3e5rGsY5PeJgha9nn/9c3O0ARS5oYCLWmBJXti62plQZtaU2TgNHTt1u/HzeuIxuA8r3NEGy85F2Q5t2wR86ZS6cL7FbeJmxoZJWGxwt0BSVH8Qwp8v6SwxnJnrNjXwm0EWK72GO+16ugz2ZMYyVwtRht1VMCeCNPt9EbDTgEzz8JZGz7cQV+zI+zY7hL3NSwru9yR0DvlONg8wGMVrJPP0SL1rZAspS1V/8WrDiPDhtijBq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(8936002)(5660300002)(30864003)(36756003)(66556008)(8676002)(66476007)(4326008)(316002)(6916009)(478600001)(6486002)(2906002)(6506007)(38100700002)(41300700001)(6666004)(86362001)(6512007)(26005)(83380400001)(186003)(66946007)(1076003)(2616005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jcTrRwSmj2/X1oWkq5d7XShOnrfMFogGoHu2S7BfI5uTbs8ZjAqm5LC0PpFZ?=
 =?us-ascii?Q?nU6L7GkIGdx5oX9AHZg3PGLHozA4JfkMkv72ep8WNJstO5hjRcHXzHmGYoGv?=
 =?us-ascii?Q?toK3QO/oFICLkkB/8OnYAOo6TB/uSyvbYRUf51cPB78bJeVO7PFnMhSUqtLH?=
 =?us-ascii?Q?5MTtCyu85wSjp1oeqfnokvyvXSpDvV0Niv2Qp8GZIB3kYiLatyKaVuLr2a9C?=
 =?us-ascii?Q?TY9HQLm9GjvzDeR5ssoT9yEvslr/4w21TBIKTT2JcTwfUfpQZ+ED8bJYvQ3d?=
 =?us-ascii?Q?STcMG7ssr+wW4tGEMW1/CxDcw9GhEtv7JPlGABOKRnipDcTVmTGa2OrKo6z3?=
 =?us-ascii?Q?ttxB5lcc+uDlWTuX+IuhPzUjFQGunO8Xy4eS5JEjeegz4ADIMzTfSI3NgsLO?=
 =?us-ascii?Q?0/26oz1KTROV/VSeRoWjkMBNXa8ayfJo2CzlTcyDz+TJrAC3yBki5E7+0fRx?=
 =?us-ascii?Q?joS6hIXK0PxF+rTl58TqrgGmuVz44Snw00CrT7Tqo4ac71Rgs0iZa1W2sfHN?=
 =?us-ascii?Q?oGFHDcO3JkiwrCj6vX3FvzFXQDRpjEEZXIFmekqAG6slOqPB1RGt73s7/yoa?=
 =?us-ascii?Q?31lXX3k3iVnzJMaUH6x7rWWqewhOAcN5nLCqQeFIsmBeS7H0WitLjxvUNvTi?=
 =?us-ascii?Q?ysRkmkR0PvhKRH3Mv9SYUjVYhqIbU4b/PBuA/6JYiDLzz3UgeAi7hA0qLXHj?=
 =?us-ascii?Q?1cfNgdheTs6ekB2LUOwrEzYw/9FBTkxEJMLHTCz4aojjhQP8RPPenFa3i49o?=
 =?us-ascii?Q?724HHrBVfzzio4ZJo+/2NMaVj/Ld7QpK79JCCSF26doHJIJYEMWCQH4DA9Xi?=
 =?us-ascii?Q?+VYDdbLdOWMH77q5Xsf8nbXP/9MLQb1NQh3h/i9+NX7rU0AskNquSi0m3iLq?=
 =?us-ascii?Q?7s+ANwf/di9CEeHg333rcXAzaksJo9Yac/O51rxrMZcJ7irAhpSxhSXUQLuG?=
 =?us-ascii?Q?MXhA7KVrEvhreoPAS7Sb9mamxqnIeNZk0frpu6LfWV6FzJmpWQde6t2ofZfJ?=
 =?us-ascii?Q?QlqQOL250LmdCoMQCfvpp0f5sirj0ZNVbPQJkY+y2gA2qFdrStdGaLYrqiAw?=
 =?us-ascii?Q?AHG6I1Su0zo2+nkyFEC0F4LqoPLXo6mBsTlb723i+SaUd2mc2dH4rdY83e2x?=
 =?us-ascii?Q?S3B8XDXEnZ9DNKM6rV7+9FsLjzNPB6DodLw7afnZKtA0ZF4PRYMy4oFYP772?=
 =?us-ascii?Q?HAcHdJyPLGh4VwvcZK5h2yo8tfuH/oFhgAmYFNy/79d9MAf7BTUjiUE0iYIE?=
 =?us-ascii?Q?z74gNzsWMjYYyz0R0VzOkOT026yPf+kJu/libTh549KGhfcQoTqONi/3GO+x?=
 =?us-ascii?Q?zU0nx9v86KnPmphowMGEAOSngbVPrN9Y41DT7ZCFGqdMDIridyCvZ2AwZ3ZQ?=
 =?us-ascii?Q?0m2Hmeudbq64Ht6cOV4l157GJoHyFWim1/Zz8ij4CntUplKzI84USBVdJ741?=
 =?us-ascii?Q?fnNF9ABC924gQX0ZIrfVXIRb8goIt5PfeUSiq+ZjjGIEWCr1DUrQBdoxeKB3?=
 =?us-ascii?Q?mTXVq3lDEVoEQFaBVrgMSbs5XhYAqlTGuZJVED2xAaYj9AE9OkCVAz3bU/O+?=
 =?us-ascii?Q?Uuzl8lENbgvx6ZKP+j8K5A/+DrTTNqgWGvZYjho8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03eb09a-e782-47c7-8d2a-08da6f98b576
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:49.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fo9lQkj4Ym9kmjbCncstUpn53WpQHkl2fFzeKmHrsQ3oSeYY87GTDKN7iRXbjpEthHuDPn7K3R3DSYHiPjzpuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1697
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The SIOCSHWTSTAMP ioctl configures HW timestamping on a given port. In
Spectrum-2 and above, each packet gets time stamp by default, but in
order to provide an accurate time stamp, software should configure to
update the correction field. In addition, the PTP traps are not enabled
by default, software should enable it per port or for all ports.

The switch behaves like a transparent clock between CPU port and each
front panel port. If ingress correction is set on a port for a given packet
type, then when such a packet is received via the port, the current time
stamp is subtracted from the correction field. If egress correction is set
on a port for a given packet type, then when such a packet is transmitted
via the port, the current time stamp is added to the correction field.

The result is that as the packet ingresses through a port with ingress
correction enabled, and egresses through a port with egress correction
enabled, the PTP correction field is updated to reflect the time that the
packet spent in the ASIC.

This can be used to update the correction field of trapped packets by
enabling ingress correction on a port where time stamping was enabled,
and egress correction on the CPU port. Similarly, for packets transmitted
from the host, ingress correction should be enabled on the CPU port, and
egress correction on a front-panel port.

However, since the correction fields will be updated for all PTP packets
crossing the CPU port, in order not to mangle the correction field, the
front panel port involved in the packet transfer must have the
corresponding correction enabled as well.

Therefore, when HW timestamping is enabled on at least one port, we have
to configure hardware to update the correction field and trap PTP event
packets on all ports.

Add reference count as part of 'struct mlxsw_sp_ptp_state', to maintain
how many ports use HW timestamping. Handle the correction field
configuration only when the first port enables time stamping and when the
last port disables time stamping. Store the configuration as part of
'struct mlxsw_sp_ptp_state', as it is global for all ports.

The SIOCGHWTSTAMP ioctl is a getter for the current configuration,
implement it and use the global configuration.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 208 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  24 +-
 2 files changed, 223 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 5bf772ceb1e0..774db250fc37 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -11,6 +11,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/net_tstamp.h>
+#include <linux/refcount.h>
 
 #include "spectrum.h"
 #include "spectrum_ptp.h"
@@ -41,6 +42,10 @@ struct mlxsw_sp1_ptp_state {
 
 struct mlxsw_sp2_ptp_state {
 	struct mlxsw_sp_ptp_state common;
+	refcount_t ptp_port_enabled_ref; /* Number of ports with time stamping
+					  * enabled.
+					  */
+	struct hwtstamp_config config;
 };
 
 struct mlxsw_sp1_ptp_key {
@@ -1368,6 +1373,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	if (err)
 		goto err_ptp_traps_set;
 
+	refcount_set(&ptp_state->ptp_port_enabled_ref, 0);
 	return &ptp_state->common;
 
 err_ptp_traps_set:
@@ -1448,6 +1454,208 @@ void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	dev_kfree_skb_any(skb);
 }
 
+int mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state;
+
+	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
+
+	*config = ptp_state->config;
+	return 0;
+}
+
+static int
+mlxsw_sp2_ptp_get_message_types(const struct hwtstamp_config *config,
+				u16 *p_ing_types, u16 *p_egr_types,
+				enum hwtstamp_rx_filters *p_rx_filter)
+{
+	enum hwtstamp_rx_filters rx_filter = config->rx_filter;
+	enum hwtstamp_tx_types tx_type = config->tx_type;
+	u16 ing_types = 0x00;
+	u16 egr_types = 0x00;
+
+	*p_rx_filter = rx_filter;
+
+	switch (rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ing_types = 0x00;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+		/* In Spectrum-2 and above, all packets get time stamp by
+		 * default and the driver fill the time stamp only for event
+		 * packets. Return all event types even if only specific types
+		 * were required.
+		 */
+		ing_types = 0x0f;
+		*p_rx_filter = HWTSTAMP_FILTER_SOME;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_SOME:
+	case HWTSTAMP_FILTER_NTP_ALL:
+		return -ERANGE;
+	default:
+		return -EINVAL;
+	}
+
+	switch (tx_type) {
+	case HWTSTAMP_TX_OFF:
+		egr_types = 0x00;
+		break;
+	case HWTSTAMP_TX_ON:
+		egr_types = 0x0f;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		return -ERANGE;
+	default:
+		return -EINVAL;
+	}
+
+	*p_ing_types = ing_types;
+	*p_egr_types = egr_types;
+	return 0;
+}
+
+static int mlxsw_sp2_ptp_mtpcpc_set(struct mlxsw_sp *mlxsw_sp, bool ptp_trap_en,
+				    u16 ing_types, u16 egr_types)
+{
+	char mtpcpc_pl[MLXSW_REG_MTPCPC_LEN];
+
+	mlxsw_reg_mtpcpc_pack(mtpcpc_pl, false, 0, ptp_trap_en, ing_types,
+			      egr_types);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mtpcpc), mtpcpc_pl);
+}
+
+static int mlxsw_sp2_ptp_enable(struct mlxsw_sp *mlxsw_sp, u16 ing_types,
+				u16 egr_types,
+				struct hwtstamp_config new_config)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp);
+	int err;
+
+	err = mlxsw_sp2_ptp_mtpcpc_set(mlxsw_sp, true, ing_types, egr_types);
+	if (err)
+		return err;
+
+	ptp_state->config = new_config;
+	return 0;
+}
+
+static int mlxsw_sp2_ptp_disable(struct mlxsw_sp *mlxsw_sp,
+				 struct hwtstamp_config new_config)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp);
+	int err;
+
+	err = mlxsw_sp2_ptp_mtpcpc_set(mlxsw_sp, false, 0, 0);
+	if (err)
+		return err;
+
+	ptp_state->config = new_config;
+	return 0;
+}
+
+static int mlxsw_sp2_ptp_configure_port(struct mlxsw_sp_port *mlxsw_sp_port,
+					u16 ing_types, u16 egr_types,
+					struct hwtstamp_config new_config)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state;
+	int err;
+
+	ASSERT_RTNL();
+
+	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
+
+	if (refcount_inc_not_zero(&ptp_state->ptp_port_enabled_ref))
+		return 0;
+
+	err = mlxsw_sp2_ptp_enable(mlxsw_sp_port->mlxsw_sp, ing_types,
+				   egr_types, new_config);
+	if (err)
+		return err;
+
+	refcount_set(&ptp_state->ptp_port_enabled_ref, 1);
+
+	return 0;
+}
+
+static int mlxsw_sp2_ptp_deconfigure_port(struct mlxsw_sp_port *mlxsw_sp_port,
+					  struct hwtstamp_config new_config)
+{
+	struct mlxsw_sp2_ptp_state *ptp_state;
+	int err;
+
+	ASSERT_RTNL();
+
+	ptp_state = mlxsw_sp2_ptp_state(mlxsw_sp_port->mlxsw_sp);
+
+	if (!refcount_dec_and_test(&ptp_state->ptp_port_enabled_ref))
+		return 0;
+
+	err = mlxsw_sp2_ptp_disable(mlxsw_sp_port->mlxsw_sp, new_config);
+	if (err)
+		goto err_ptp_disable;
+
+	return 0;
+
+err_ptp_disable:
+	refcount_set(&ptp_state->ptp_port_enabled_ref, 1);
+	return err;
+}
+
+int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config)
+{
+	enum hwtstamp_rx_filters rx_filter;
+	struct hwtstamp_config new_config;
+	u16 new_ing_types, new_egr_types;
+	bool ptp_enabled;
+	int err;
+
+	err = mlxsw_sp2_ptp_get_message_types(config, &new_ing_types,
+					      &new_egr_types, &rx_filter);
+	if (err)
+		return err;
+
+	new_config.flags = config->flags;
+	new_config.tx_type = config->tx_type;
+	new_config.rx_filter = rx_filter;
+
+	ptp_enabled = mlxsw_sp_port->ptp.ing_types ||
+		      mlxsw_sp_port->ptp.egr_types;
+
+	if ((new_ing_types || new_egr_types) && !ptp_enabled) {
+		err = mlxsw_sp2_ptp_configure_port(mlxsw_sp_port, new_ing_types,
+						   new_egr_types, new_config);
+		if (err)
+			return err;
+	} else if (!new_ing_types && !new_egr_types && ptp_enabled) {
+		err = mlxsw_sp2_ptp_deconfigure_port(mlxsw_sp_port, new_config);
+		if (err)
+			return err;
+	}
+
+	mlxsw_sp_port->ptp.ing_types = new_ing_types;
+	mlxsw_sp_port->ptp.egr_types = new_egr_types;
+
+	/* Notify the ioctl caller what we are actually timestamping. */
+	config->rx_filter = rx_filter;
+
+	return 0;
+}
+
 int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				 struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 26dda940789a..fbe88ac44bcd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -77,6 +77,12 @@ void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 			       struct sk_buff *skb, u16 local_port);
 
+int mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config);
+
+int mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config);
+
 int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
 				  struct mlxsw_sp_port *mlxsw_sp_port,
 				  struct sk_buff *skb,
@@ -202,15 +208,6 @@ static inline void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	dev_kfree_skb_any(skb);
 }
 
-int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
-				  struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct sk_buff *skb,
-				  const struct mlxsw_tx_info *tx_info)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 static inline int
 mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct hwtstamp_config *config)
@@ -225,6 +222,15 @@ mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static inline void mlxsw_sp2_ptp_shaper_work(struct work_struct *work)
 {
 }
-- 
2.36.1

