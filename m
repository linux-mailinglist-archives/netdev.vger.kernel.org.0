Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA06CEC14
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjC2OsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjC2Orp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:47:45 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2134.outbound.protection.outlook.com [40.107.101.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0033E7287
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:46:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVESRL5xgycBuZVrKxoIa3zJ0x1us0gpoTPcKSN9l5HFGvmL69+0J5Ateop6Bs2Rkfu9ShRbJPa/AErpdv/5Unt4N45u3zlu3+5oaraOrhKTD8BMite5096L5oujFOu1POq6mm5OnRZaDluAFZBaVE/QarnfzowaoSRbnNIWhccbegT3pYipGMnEQX0+/H6A0xdz/B79yGkmHc6sb0xFTFWrYjNHdAKwkV9kE0RriC22WLYa7WNn8L27rHx8DFAwV3nZuLtI4IlRkv4gX4kTdE0BZVpIwwNRxAvgAs24zaeagm95NLx3Hyx8K3D2wFrEPBcmVhhy7oxhzhOAHyxypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJNkN+IsF6bv7PCgoeniWhiam85ia8piAsrc4+W1fS0=;
 b=YDkSzJik8VQVHQDRlrpzhcocqiWhz8i6wHNbAaxUI/w7/7s1XPewCIPY85k9XpVkeAYIQbgp4GC89rmS73rpaZhN839JffYWJsQ2H6+KraAZ5Ga2OiJ43RMJNO1qOtWSqPO1bw5As+GfH6T9iZL5boL54To5EezOlkwpX5JdM0oTZQD6OLcl1AWkLkwX9JJv4TkazB+wZVEW6dt7qrFnGCDgjLpyaXwOSSZ/eOMkUkbGcvoccpdOYso6WkAIitl24JGnetyNNrEN5Fu7FdkjmdbApxV/I5SOvpFIb3WHBNsUOS5sMGJt22e1n6wUWRFM6AIMBhb5Yk/FFDphN/7Rdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJNkN+IsF6bv7PCgoeniWhiam85ia8piAsrc4+W1fS0=;
 b=Rf+sZ7Pk9p+zsOcYtFePliu73F1il8qXOA8YPs1A12RZxc5cmgkuIj9U46Ju5Kc2S3ukYQBBzfMrlnsf8uElmBcWwDJgeWy02//u6olpNlmo8xRGUp0/mNo+YrdtdlJiF6AcVeYFPUFbjrG27mVHepAJRCDuc/vTnXHm2F3l068=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA1PR13MB5588.namprd13.prod.outlook.com (2603:10b6:806:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 14:46:21 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84%6]) with mapi id 15.20.6222.029; Wed, 29 Mar 2023
 14:46:21 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: [PATCH net-next 2/2] nfp: separate the port's upper state with lower phy state
Date:   Wed, 29 Mar 2023 16:45:48 +0200
Message-Id: <20230329144548.66708-3-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230329144548.66708-1-louis.peens@corigine.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::11)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA1PR13MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb8621b-169b-4626-42c1-08db30645ccb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hLTus+6s2Am5zBxJxA7DUx8r8mHZTbWSJJs7jJt4pReaRGNc5p22stn8S7VOCwOkc+bdvVCWqpCCsg2yvC4I/oLkgoiC54Hy2dvpqZJIPSraGXCy2bQ6a9oZfMXzaMnKj4vPvnzgu0zdYsO/4MNIkRd6M1/SeH+gLJllSM3Tf1gJIhqKRy+TXBgtzE68utBH3mPVvKbJ3A3/AOP9Cs2pwk+/a/rPUK/bbt20qE46KejIsm1Ywk7x8K7Tu5MZ6jlSqywbvxLwZpx3K4vZxiSQK2eCrBXp9IKb++XMEcH4DezEMnEOcwu88kIsSGMN1z8LpfqjJZtlWhNccthKb0DrqeBvyRvI9v1zYtd0bg3VIcGQkAzuvgdPx6h725RLI+Gyfu3FSu5STts4rLYBbg51cLAUbosCWXxPSHgNd1xPT+yXE7aVoLHxHykLNFzTMT7DWzeRTG/eq3l/tEVz+t6hjzSjJK2Gu9tKfOE0MHpFQwwFB+uJWVQkLdPT5Gym1TaFuZFkKSmOc46oThuDykmfalW8YbNff/bMS4x50k95/qh8sdQ2idg2j3dxivO1gHh0CEGSiA6lr6aPs6NHbRDQ9XRi+h3GUdOhnqMMFgkgQKxPhafHaI5YpsD5tzYbdYmj0YMqTDROqghXxWexGP3sAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(396003)(346002)(376002)(451199021)(6512007)(26005)(41300700001)(6506007)(1076003)(6666004)(107886003)(186003)(6486002)(52116002)(83380400001)(2616005)(478600001)(54906003)(110136005)(316002)(4326008)(38350700002)(44832011)(66476007)(38100700002)(66556008)(2906002)(8676002)(66946007)(86362001)(36756003)(5660300002)(8936002)(20673002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NomTZYpNWYfu2hKdDFxVN807B4r9Poc6VCGMzOlsxgKPz4OViLTaTBzxujKx?=
 =?us-ascii?Q?bOhoxp/KugIDs1jXHzxHrVJrYypgaXva4ky6EXLrLuk2+b3iH2c8wGQEznKI?=
 =?us-ascii?Q?+H8DuyOLZ6aUBmpqBgBtqgzaqEYnrlp4NRCxlLuGIsidFoWQxCaWdpo/ULNT?=
 =?us-ascii?Q?OPJgJstFWUC/rT5Q80yWaH9iPG35N+yLI52CEFoIGKHS6Cwm6+w2KOFtdxG1?=
 =?us-ascii?Q?WuZe24+orTZL03a3qtL9nOTm/01mVRZlMIQe3tLAughVL3EfV8NZ68zbGeg9?=
 =?us-ascii?Q?Fe5LbSyDxecOHlGW+YzoUOV8r0C8vs0xFpLG4ptGUpQfR54zW4N+gXpg2jX4?=
 =?us-ascii?Q?wcfuQPBqEoLhFriWNvFOhYlCeSNJ3wUEBS1fBqOWk8qNNfTZRkW+MlajZL3l?=
 =?us-ascii?Q?AmZCuLG6Y3Dc8OMTDw41p+905Uo0K+e3Gr2So6lh7kzPhIMJ34DIauxUj/4Z?=
 =?us-ascii?Q?NcBsrMGk6sD8GAiZm8Z0wRf8mJJezQOqtoUEYOZIEc5yX0KSDvyH518WZRxE?=
 =?us-ascii?Q?c1hCiZMNrnXUD2fjCqEOcHRWxe+uIil9/FVJOK0Q7BKh1dOqnzoWI6DMNsLW?=
 =?us-ascii?Q?OKZp9ppWY7LdXLRQItf3yd48j6jyjJ74Zsy8oMJrOB9ENo24Y6kLc5guOxST?=
 =?us-ascii?Q?L+a59MtNnqlSdO5BH70NR2z835OO+aQxcs1wqmTHVfki6aWVY/2ODyFGJ/6A?=
 =?us-ascii?Q?/UTWx2Ng3jhhjfulLpz+elWIeBAgSk6waNE0jhnUAn97GjHS4p8pbtXq2OM6?=
 =?us-ascii?Q?6M7cRYUF00+YUyi+T9m3154ZGMR6GK+OCcGPbLiBaqoxWLaegmYl+JEvhN8T?=
 =?us-ascii?Q?fVBWbPnaR57XcqrDX3gnpHCr5JiGQSQdBoCCsL6L4Vc1bhuRECYx166QOe60?=
 =?us-ascii?Q?z/3kpByKT/CALiwia7Uli6NJlFdywIpuWgS3FCZAxCrhtkldBiyzwyVASX+p?=
 =?us-ascii?Q?E8NUyQ135+CrU05vhljmV+Vi/R9kwCB53bosJE1NJQyMnZ8AHgabMu9kGUNm?=
 =?us-ascii?Q?TxIMdKOeeAh7g6/Q28p0Pq+zirbQKxpDrjMecvwDkC+QnsUCsaHlNoZUYQjg?=
 =?us-ascii?Q?Lk9VBIyJnVLAE1QCdd8SQdr0gXrFsfy7LwLpwyNm1sYVXloSfoXamevpDMQD?=
 =?us-ascii?Q?22gso3zpOVZ6UGuXK8zd3GaCJpZfh035NfQigGNQ/hU2yaOne16o60vhfa+e?=
 =?us-ascii?Q?sgF+IzUtqlBaXbiqsB21VyemZjeJBXE1Q3npKEwY9YmjF+0Eod/0px6xBq7X?=
 =?us-ascii?Q?AnNuTS+D6qYf4qw1Gpvvjc7FwqO4PNXoMMMhfXdhUHUJYu/gNNfscW8gt/Ic?=
 =?us-ascii?Q?saKo0n53X9nPcSDdiGeEyFa0zcNNRvIo3rApSOtPq909qn7e9MeVsdkk5m8W?=
 =?us-ascii?Q?ejlWDCJhA9Iqi7KIo35p7x+vIu0NyXx8BxKMZSJfcxnZQnlkcXJS1P0KyGJi?=
 =?us-ascii?Q?ljTZmKieHh7dFV2OoGZEs0Kc7FLYK7Xg+lYCAEX2lgXEi6cPbJtwJ0Hs7p2x?=
 =?us-ascii?Q?ssgHVo6A3Et32XM3k+K4LaxixJirxvXO3lJHqMz3vQgtnGvvm6EvFg1jLhav?=
 =?us-ascii?Q?GYryRqPYbMp3d1VlqGLzuhnexYHInGPcc7u30+bBjSTepGgLeHRjMbs4XgU8?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb8621b-169b-4626-42c1-08db30645ccb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 14:46:21.6271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25MaXs/jvupLXBLnkFZGQ/4XWeDrHOvmfBbM130164oS/S1NXWPwBRuZI/F1KrAY11H9EBtv/OYtKHLTH0JrUp49Gqk21pqK7s9+tNGiksc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5588
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

For nic application firmware, enable the ports' phy state at the
beginning. And by default its state doesn't change in pace with
the upper state, unless the ethtool private flag "link_state_detach"
is turned off by:

 ethtool --set-private-flags <netdev> link_state_detach off

With this separation, we're able to keep the VF state up while
bringing down the PF.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 103 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nic/main.c |  20 ++++
 2 files changed, 123 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index dfedb52b7e70..fd4cf865da4a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -841,6 +841,102 @@ static void nfp_net_self_test(struct net_device *netdev, struct ethtool_test *et
 	netdev_info(netdev, "Test end\n");
 }
 
+static bool nfp_pflag_get_link_state_detach(struct net_device *netdev)
+{
+	struct nfp_port *port = nfp_port_from_netdev(netdev);
+
+	if (!__nfp_port_get_eth_port(port))
+		return false;
+
+	return port->eth_forced;
+}
+
+static int nfp_pflag_set_link_state_detach(struct net_device *netdev, bool en)
+{
+	struct nfp_port *port = nfp_port_from_netdev(netdev);
+	struct nfp_eth_table_port *eth_port;
+
+	eth_port = __nfp_port_get_eth_port(port);
+	if (!eth_port)
+		return -EOPNOTSUPP;
+
+	if (!en) {
+		/* When turning link_state_detach off, we need change the lower
+		 * phy state if it's different with admin state.
+		 * Contrarily, we can leave the lower phy state as it is when
+		 * turning the flag on, since it's detached.
+		 */
+		int err = nfp_eth_set_configured(port->app->cpp, eth_port->index,
+						 netif_running(netdev));
+		if (err && err != -EOPNOTSUPP)
+			return err;
+	}
+
+	port->eth_forced = en;
+	return 0;
+}
+
+#define DECLARE_NFP_PFLAG(flag)	{	\
+	.name	= #flag,		\
+	.get	= nfp_pflag_get_##flag,	\
+	.set	= nfp_pflag_set_##flag,	\
+	}
+
+static const struct {
+	const char name[ETH_GSTRING_LEN];
+	bool (*get)(struct net_device *netdev);
+	int (*set)(struct net_device *netdev, bool en);
+} nfp_pflags[] = {
+	DECLARE_NFP_PFLAG(link_state_detach),
+};
+
+#define NFP_PFLAG_MAX ARRAY_SIZE(nfp_pflags)
+
+static void nfp_get_pflag_strings(struct net_device *netdev, u8 *data)
+{
+	for (u32 i = 0; i < NFP_PFLAG_MAX; i++)
+		ethtool_sprintf(&data, nfp_pflags[i].name);
+}
+
+static int nfp_get_pflag_count(struct net_device *netdev)
+{
+	return NFP_PFLAG_MAX;
+}
+
+static u32 nfp_net_get_pflags(struct net_device *netdev)
+{
+	u32 pflags = 0;
+
+	for (u32 i = 0; i < NFP_PFLAG_MAX; i++) {
+		if (nfp_pflags[i].get(netdev))
+			pflags |= BIT(i);
+	}
+
+	return pflags;
+}
+
+static int nfp_net_set_pflags(struct net_device *netdev, u32 pflags)
+{
+	u32 changed = nfp_net_get_pflags(netdev) ^ pflags;
+	int err;
+
+	for (u32 i = 0; i < NFP_PFLAG_MAX; i++) {
+		bool en;
+
+		if (!(changed & BIT(i)))
+			continue;
+
+		en = !!(pflags & BIT(i));
+		err = nfp_pflags[i].set(netdev, en);
+		if (err)
+			return err;
+
+		netdev_info(netdev, "%s is %sabled.", nfp_pflags[i].name, en ? "en" : "dis");
+	}
+
+	return 0;
+}
+
 static unsigned int nfp_vnic_get_sw_stats_count(struct net_device *netdev)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -1107,6 +1203,9 @@ static void nfp_net_get_strings(struct net_device *netdev,
 	case ETH_SS_TEST:
 		nfp_get_self_test_strings(netdev, data);
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		nfp_get_pflag_strings(netdev, data);
+		break;
 	}
 }
 
@@ -1143,6 +1242,8 @@ static int nfp_net_get_sset_count(struct net_device *netdev, int sset)
 		return cnt;
 	case ETH_SS_TEST:
 		return nfp_get_self_test_count(netdev);
+	case ETH_SS_PRIV_FLAGS:
+		return nfp_get_pflag_count(netdev);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2116,6 +2217,8 @@ static const struct ethtool_ops nfp_net_ethtool_ops = {
 	.set_fecparam		= nfp_port_set_fecparam,
 	.get_pauseparam		= nfp_port_get_pauseparam,
 	.set_phys_id		= nfp_net_set_phys_id,
+	.get_priv_flags		= nfp_net_get_pflags,
+	.set_priv_flags		= nfp_net_set_pflags,
 };
 
 const struct ethtool_ops nfp_port_ethtool_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
index 9dd5afe37f6e..7d8505c033ee 100644
--- a/drivers/net/ethernet/netronome/nfp/nic/main.c
+++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
@@ -6,6 +6,7 @@
 #include "../nfp_app.h"
 #include "../nfp_main.h"
 #include "../nfp_net.h"
+#include "../nfp_port.h"
 #include "main.h"
 
 static int nfp_nic_init(struct nfp_app *app)
@@ -32,11 +33,30 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
 
 static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
 {
+	struct nfp_port *port = nn->port;
+
+	if (port->type == NFP_PORT_PHYS_PORT) {
+		/* Enable PHY state here, and its state doesn't change in
+		 * pace with the port upper state by default. The behavior
+		 * can be modified by ethtool private flag "link_state_detach".
+		 */
+		int err = nfp_eth_set_configured(app->cpp,
+						 port->eth_port->index,
+						 true);
+		if (err >= 0)
+			port->eth_forced = true;
+	}
+
 	return nfp_nic_dcb_init(nn);
 }
 
 static void nfp_nic_vnic_clean(struct nfp_app *app, struct nfp_net *nn)
 {
+	struct nfp_port *port = nn->port;
+
+	if (port->type == NFP_PORT_PHYS_PORT)
+		nfp_eth_set_configured(app->cpp, port->eth_port->index, false);
+
 	nfp_nic_dcb_clean(nn);
 }
 
-- 
2.34.1

