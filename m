Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1D3BA895
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhGCMBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:08 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:8275
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230209AbhGCMBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBFnAbBR5m2AmAz0MN9ofObTOrkFzvTlFdbL8g02MXZhar+soDdOUMY1eEHhHG3CRFxTXnUmAcBZlVLzY9Tf1wXOrEYKR7dfcoDk9XhTHRszzwIa1GKzT9UGFBwfq5y/inPddD0EePBg70+jQlX6O6EFIkP3NpWxTIyFjfzg7MAeeD9ocPL7gafvgX/Bw4FuD4ltDuMEmyZdJ3vnUWK8Wj1wKuSarNtmLgr0Bo/00LfNIj7+hOgtCpmOIakv2cukUZneB0gT0uE/7J+8BVWUY1FCEHJT5CZJH0ZUrrpg8SVcWv60rICxCDuhme4i9oMCCGFruL/ciz3OfdJMMuek3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8ARGCbzXYmxoVhI/W45fy7wsub+EkJDR8//ZmjXIV0=;
 b=XM4w9UjhvbXRwMvuZQlQSBLfChaquFWZMuvMk/Jr/MK47bPTYIT6NWD1twJv3XZz5ukJdEwjI/38z3l+LBAUkxEdMBsjyhjFrB9idP+WixBSXi2X1di5mhz/kysfhuSdMCfOONdTOR17R/JxBVcovLHKRf2Kt5X0V3rZ/ji1Y6zsNlRL6SM2jPQp7qRWvWezG8HPF3vjcIUUIVAWizVtSgaudXKchTwJYOtIps3FVUXJhDG71S0nOabatEVDzzNbOc2G63H3aOp3lqo7hGa7cNfB/M2ZIL83h0JWt8VXmVtLCuw60bVBcwoSoJ9Z2WP5tKaxGvTlZRTWmC/RlxUTvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8ARGCbzXYmxoVhI/W45fy7wsub+EkJDR8//ZmjXIV0=;
 b=UdldaYw4PcFuEjx+U3FA+s70+P9JWLeP7uPnZYH/3YA8Kfxiq4vdgSWVbDvpIApj+WYejlfqc1G9kEOj9NU6RrFUL8wuFl+0xtn1TOUQyo+05vOYnbA4vWUM5bQhTTwbn6QsYxsDY74SZ6I0WWz6IhPwmFl6e77CfcxD04IY+bk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 01/10] net: dfwd: constrain existing users to macvlan subordinates
Date:   Sat,  3 Jul 2021 14:56:56 +0300
Message-Id: <20210703115705.1034112-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 008a85f0-f965-4ed1-b8fe-08d93e19de40
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509DE6C9B495E87D8228D68E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7AKiONQfHFmIheJfwdHIedL9rkavL2MlqgZ0fwDNzvugVmwGVXWYXYdCx8/krG/l0ScKmlWrtZNddCiycLDrU0HR6h8yxI8t9+hirbkRWMy7vtupw/7pK4JxOjNW2ZNXlTpRNJXFfXWL1JUYKvFloKqFJavpIVWnNsEnkWKuQ6xQ/c246VyF/ILxfWWdTR7dGwYzS2ZLZkgU5Ar4q5C8PiXEXHscWY5OZzeiAxE9WH1/YM/VJnLcrbX4EXqrz9/s0y2tznoS0mXqdH4UmXYTFW5a81GRj3d6CfciL8pnPSv0hDurlWVQif+KyuI2MVcDJieL9zptacARie1bqp7DLono+OINmGeAA6gr4DzkeerA/3+EbvmnJuviQ4QUStz1vBQL7C/hPtp0pb3uF7L/Hs1YcfZitb/ld0hVOc2BSJPgUZEnSghWwQHRx585JPiwQskQZmEL/r0PN2UJ86UmQ2ydd3eIvUy85Tc/Hvs/RljQQpaaoB6+uc2KYXWF7kdIhn9BOlTvw4mQy19bVx3TprTeCjfnt9QnUNBM8HRwIg5N6wRTR7MfS1ZVQxpgdAZ3RgPDnSnHVK8oUdmk/GSna9WQuA1erAoELfXQO4SuUpiyKZhNlWbPdGF9bPhh021EfBtmCGW6rfE4QtPN8g+6K/VcuffX8xVuSSu8jNJm82JEYP+COT2cAaS3wTlPwdlH56MyaNuQcGEe4eKbeTZkrsW7fNTFnmlfVD2dpzmzPkv5qY69TrRFOz8DOV45HLI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bhAVE4AAj6zIn5zXBD32TxDIseNtbCOUam94Z2dhpG0CRXwQ+uCQ5k+O7erh?=
 =?us-ascii?Q?anDQCoaASU30hcUJeExzZ6FLWR8tPWJqNPIwcOCPpGvnUqncXvZbuQe/UA3L?=
 =?us-ascii?Q?f4IngTgx3aHOXmZe7NloPqw1sFgSB4H2cVZDKfGQ8bgfDqezT20FRZ95aAXr?=
 =?us-ascii?Q?eeEm0T3AplmO/9lluGuMw+1M4pD9OUXRFEL2pklcMIfJbqMwrSkjNeBehQEM?=
 =?us-ascii?Q?DkZrPRE/CfAX8MF3tGq8q/ItOxAUOv/wk2qrysrQpGmJSApnl3oQgmikGOPF?=
 =?us-ascii?Q?eB+Q0TO+NoPULayoMcGfRJXa1lBCzpG9aPyGdNDOgdtsZ1lFDYEBn1l63lwv?=
 =?us-ascii?Q?D2wUTGExx4UAXubF6sFlTsMWr6FPz4Waf4OhatOtPNhrIyPwME1PgnGSAAqu?=
 =?us-ascii?Q?xPW8gce6aOjltHI9q+i3XHWk1LPowxT0CixU4CuP2FqbU1vUa24+4FpogGPk?=
 =?us-ascii?Q?V76tmZqhZJ8aFlPC5Zfy/bnoYFKL54tGKTmHHOVq5NrY0S8oPYSnOkN6uzCE?=
 =?us-ascii?Q?5TTl8b9DQe0mo7PdRn+7+KItauqFvGqlD4vc1mLFd6db8RruxCKz6a1IXoIh?=
 =?us-ascii?Q?4Zh0Jt9CluinKBW2krxVt83APru9omFPUCLuy1XfV5SqRMVs3hr9MG6fGZW3?=
 =?us-ascii?Q?YspMWxpu31UXADMuNGYCwNstvAKG4LDHCiQUTBeEuXvzmUU9+weEXAMB6B3n?=
 =?us-ascii?Q?XMSE+rHa+S9LIb6K6xQbnvJBtUfkIvaFWoRN3gEv5eMIz+Hj78vV5hNi1x9F?=
 =?us-ascii?Q?utljfTJSEvpLZxaI3goTqWEE9f0dU1+mURQg0SgoNqdYiU3Akfw6LZvOsk0I?=
 =?us-ascii?Q?wgrhKBQjc2cHvszLbnLo5ArGbWSSf9HEBPa+6X630+95fCfVAZRzEWfmRX3c?=
 =?us-ascii?Q?WnJnjTqSfeksLAvEybti02RwgdEvaMZMEz6oI5zn7MLgvbuDQax04STUJwuM?=
 =?us-ascii?Q?tjA9tc6FDZBrTpcBGmquCICV1ni5Z214Juw1/ONvXO/etRahMVRNyXOGtQaB?=
 =?us-ascii?Q?07IGRI4Fdu28I6gURzSXziMWNLTowjTlPs6jKcn/azQxE8zEeQWL8TSekrpc?=
 =?us-ascii?Q?CvBsdGIsQ1iFOm5jDEwC9/d3PzXR+Oi0bEhBeX+u+Jfbf8sw3QoxfeQ8zL+0?=
 =?us-ascii?Q?zOpFm0RDfbzDcewezEBM6z2cbjoVS1Oxx6hMkV0bJzBXP/D4WuXIrVya3R8z?=
 =?us-ascii?Q?ScoJ7ttbUbNSqjTLk66zAh5NsT1qJ2QeTTb0BnNL5B+lNwGZJmVjYXeY5cmq?=
 =?us-ascii?Q?aEYEmloYm7V7yDGbGFdnfR5vckdHTBnBHdk9XdddjKAYDv7NDkEsC8ixgtYm?=
 =?us-ascii?Q?0pGixhbtXqP10akAmCLThWXz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008a85f0-f965-4ed1-b8fe-08d93e19de40
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:27.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5hkSIc9L6k+wKEYSFrVtaGkMl3IuCTEY2DO9/tZEyTi95MieXHhLweetRjM6756n9UO5I6oLLHzym4Lv2pAJWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

The dfwd_add/del_station NDOs are currently only used by the macvlan
subsystem to request L2 forwarding offload from lower devices. In
order add support for other types of devices (like bridges), we
constrain the current users to make sure that the subordinate
requesting the offload is in fact a macvlan.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2fb52bd6fc0e..4dba6e6a282d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1352,6 +1352,9 @@ static void *fm10k_dfwd_add_station(struct net_device *dev,
 	int size, i;
 	u16 vid, glort;
 
+	if (!netif_is_macvlan(sdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/* The hardware supported by fm10k only filters on the destination MAC
 	 * address. In order to avoid issues we only support offloading modes
 	 * where the hardware can actually provide the functionality.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 861e59a350bd..812ad241a049 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7629,6 +7629,9 @@ static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
 	struct i40e_fwd_adapter *fwd;
 	int avail_macvlan, ret;
 
+	if (!netif_is_macvlan(vdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if ((pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ffff69efd78a..1ecdb7dc9534 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9938,6 +9938,9 @@ static void *ixgbe_fwd_add(struct net_device *pdev, struct net_device *vdev)
 	int tcs = adapter->hw_tcs ? : 1;
 	int pool, err;
 
+	if (!netif_is_macvlan(vdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (adapter->xdp_prog) {
 		e_warn(probe, "L2FW offload is not supported with XDP\n");
 		return ERR_PTR(-EINVAL);
-- 
2.25.1

