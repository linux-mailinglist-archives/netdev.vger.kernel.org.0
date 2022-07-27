Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D1D582009
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiG0GYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiG0GYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:24:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36017402F8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSJYJQ78Io+oeJRo2dWdAiGu4lk2iQgHN6rpmhhMoyFtnxWjvYod3/kvDfGY33zjIGZNTsEMJ0H8UKqoO8CB3JIclkkj77N6nzwzWnMSNa2O1m61Og3fYK4uSnCQ9V3w2904xRmcitbYFPDrk6zkguINS4GFERor7Azju5hNWIhHZG1GGCDBGLUwM2TgQOTKCFH37ZenUHyWlih/1VuCKu9jfC7680zRdpCZmvSPBdw5NWLwgNuizAMj/0vaLjl3yeKTP23vMX2i1N9JF82D7Hoqjk4WryjshuWBJMyrTmKVCrFRq4UoCrg1oa0xluddiTdHXTLU4jYX3q/cbj03Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L54B+zWP28La9HtgMoSgOwiEeV20Yd0oRf4jLLQBZd8=;
 b=i/di02g9JJuRLMS511mihjJWD8Kt7PsXw4dBmo+ddItZ9JuA7aQ+hxuppm9mz4ANBnKP8+nkn5aTZSGLAg370tDzzfZxjA2EkPC7UuEq75szyugb5ChDFWDVZ1Dplxc18ORo0eJZrP3nvLMmyWrAPvtHFX9y47uvxeGLVev7PCC9N8lF7w9yP9+u440QTkn+0R2zQbuHSKvfTqga+HQU333nfB6zeGJvFhGf1vrTQ/p7jZdcEQDwGqePHoHNNr/7dSVIJNGdCYaGSkElgVuYiKwpgD23rrHN2ITsoe+H59HmCDb1KEeFEfyitCqlpKiLaDkR3e+N9VhZN+K8J21D0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L54B+zWP28La9HtgMoSgOwiEeV20Yd0oRf4jLLQBZd8=;
 b=FJ/G2GIX7X4aA3IRuEeiJBdFe1dbcyXv69ywjCuTgQAYCd6AfrFuNM89fvd03423V9ten3Ow/DtdmoPjEZINkidEp10BjwsUHIHqYqHT5ZYR7oTR2EKNC9wbY6b2JxtZ1K1d0iANbnPrcpSh6b/pwMtNsKuk6lNRzSD5VwHUAmnqRMIkDXzJ9z7yfzytLyNa8TYi6bATU53M/6L4wpvYeDTnO3UqyOBXfDojKq91kHfK3YjxCv0ZYJicsS1YuS6078BHqM+hSA457u8CbgghK4AS1PiwQWTa9oqdbJGKxopZOb4LHUJVm5GZ2mqm/qtKSBvpSQ63REhse1457rjpmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 06:24:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 06:24:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, richardcochran@gmail.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/9] mlxsw: Send PTP packets as data packets to overcome a limitation
Date:   Wed, 27 Jul 2022 09:23:25 +0300
Message-Id: <20220727062328.3134613-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220727062328.3134613-1-idosch@nvidia.com>
References: <20220727062328.3134613-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0016230-0ce9-4438-d573-08da6f98ad81
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0y7lLVTbsdSAUEBTI/lu9//IKChoj/CAdCTPQnMv8iWSJYhTD+wKnHGF5lpMDPI/vDmBdSM8d0R/CQZcgfPrpOTdzctIYn1hkQEyZL807esXW9xu7mul/kKPePSQHfCZdYv0YS8BsH0Va7GffAHkHg/lxckPa/KYro6Cqxw5yugumx13Aj4lGHVEsYd+vUVxIlmhXRjDhTbGrF1YLaAilmItDCLjMOM33EbvwQ3iaGNMjqEFUWL626h4Ylelo+4zCxevJmgMm4wO9jRz7yS9lsalJyfjWpVhngGYhq8oRWFggtTRd0/TKcM7dfELSOhKQctkb7jwC0scsBNB5KgqNCxM4JemML35ugQSE2CoBZ3hpmEVqyzV+KqVtWyzOavnQ6nz0mi5MBjHLIddokTEZ/Zc9flW/OWaUKZbRhZH1UPDmKwLMwZ+z5ZqCk9xxPxtvylNupbsnzt5TqD7hMZCcEaHHOfVvw3n8KWoaQ+vXBZCMUFwzE45e14703pNdlJKj46mPKxMyI+MK60XUbZ2UdZy7PYz01yk1tK8AqRMYk7v26Sa8uifuE8W7SRhkdVkOpGrit3vK3xTGyHC2aqsudC8kHNXg6G1K7uqNUtKDXpigVkRrTYdsDIHS1UKvCy32/0uEEWjotPe7DQkYAjSIcVifeFDeu8yelTCikTcG96hZPoxSs487esbcd2kgtbm/4M03puAt19AgSPA9ggDes/8w3UcV+sov7zmteOfCRkpc2+mVlAwzGdszn6dg0hUb71y1OjHDXf41amd3VPckM8SZ9+wvpuYRCPpQGOO2cc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(6916009)(6486002)(478600001)(41300700001)(6666004)(316002)(66556008)(2906002)(4326008)(66946007)(66476007)(30864003)(8676002)(5660300002)(86362001)(6506007)(8936002)(38100700002)(66574015)(1076003)(186003)(107886003)(83380400001)(6512007)(26005)(36756003)(2616005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R57Y7PD4bL0NhCePR7t/6AWXi4G96ZfeEXaLqCG8nH4J2lmWBG8DX/XYkWDv?=
 =?us-ascii?Q?daCw81LuXT2lhnN+TljV0XcztxYzVV/809++/b72AkT5i284n7bKcQtJxibV?=
 =?us-ascii?Q?lkHsMqUBiV4elbfm/1xWMpGPpHIil5G5Fd9Hqo6Q0WXP2nzHID3E7qFEWxeP?=
 =?us-ascii?Q?u7ET6ERASNS2G2n0EcN4eWCeKYTkW3i9RaXy3g5WEfvx3PzSTcS8kc9e765H?=
 =?us-ascii?Q?TjtdPxXD8ziWG0DPc1HBZ1NY6ESc0wp7XoN8/2ztScrjMGIfffXH1fAKKkuA?=
 =?us-ascii?Q?It9WI9mS4y7/COfq04ZWbT3uC3YCf+Q1l5vAjDVpD+lKWHmY7fhqlNL2/P8L?=
 =?us-ascii?Q?K1hgDYgHxQItacR0tBxUPy6kZgoib9m4tTDkYK5iPi3vnsowRsqEOPTJJ4P0?=
 =?us-ascii?Q?V2xiU0R0IDFgb4uHUGEv7MjT03CDkXayr2Wn5MC3aSRYEC90H0GSsbXvoItv?=
 =?us-ascii?Q?UFwyzJ+BtVsWEZe0+UHTLWxYuaL+AknvdzBK+eHPxPCLyVwHQ90vywr8cs59?=
 =?us-ascii?Q?6O3B7ysKg09A225Kxuql2X6zfpqfntJ+QMyLOFC00P0737nwZtPbMnUNbowZ?=
 =?us-ascii?Q?z3B40KtPqAVnwvKuFy7pogB1fqT+bjNuXvq/hibW8lXlC4q7w0tsu6mYglm5?=
 =?us-ascii?Q?E6rLXhWWQ+UAYaQhB9HAWzGfsHdvV3oC8QxxOIPE4wINo4bx8P/ZN6J81G6+?=
 =?us-ascii?Q?n3Ei0/W6Tv746/VmhCk1mB7yHeonXflpFR1OO/9yZuZETPWBp7jgpBZTMekP?=
 =?us-ascii?Q?2V8D/jfI5afUeJpqs/s5g9IpcYqCd9qJcwVKZmLXqPXRHQ5bkvruqtbOcyKa?=
 =?us-ascii?Q?9sDhZBjtJC+8WMqSLH0BSxo1U2lNmzoFMjCPfD0qoycHo0TBr3K3z9SWYKI9?=
 =?us-ascii?Q?1qa8iJB6aGEFWSe9iLzpoVW2UYQinmrF45BYqT55CdwPzBvOq2qHNg7KY4V4?=
 =?us-ascii?Q?tezrr5zf9YsE4U1ua+qYNmATtLofD8IwD9lS8v4BJ8Yyy3RZgBn/iKlQT7be?=
 =?us-ascii?Q?ySUhKJYku9QGiVzEXeSi+fKG/xhL+O2R5eDTJiRcKqeOwdgWKE7TTV/wHUh5?=
 =?us-ascii?Q?dKqFVx421KBrTUihaXGsvFqjlCJ+uiCjaTbDCrrTI0KwpdTPBW26aipmej+8?=
 =?us-ascii?Q?Km9f4pqHph5vXW7Sxb+Xh9KHzp914FYPdTQ+52fgdGHM0iZ0trnlHpQkRVCx?=
 =?us-ascii?Q?u2m6D9ivZZXTZ1B6d4qtRtSjIywu9iPTxkZY3Y+QZz0Dgq3FNQ+B49/j20i5?=
 =?us-ascii?Q?5X80RQ0m5BttIy3EsaDtEgsM7VrP7y7xIxO3a/fsOfn/i4WNVhTNbb+teV9x?=
 =?us-ascii?Q?VizbEeRDJYM0J2qcBXswC+kNDju5BqpLjd4zckT4kwarLotra5xigO4o2Z+Q?=
 =?us-ascii?Q?IZl99ZesurRa0Xk0zCock4NdXvg/9SjsLdtU/uTQLCzNEGG1RV6Jg9MYWESe?=
 =?us-ascii?Q?ABg6+SXf3BdWbD1zSBKo1VEmBRU4fuiiKoYtZd1XV1ZtOUMuzQItCf2SMdx9?=
 =?us-ascii?Q?eM2Xw1AsrHVVYaSO+10B6+xPSrEtpzE9QrgWptpNZj52yqmZ6mKCFn51Ydhb?=
 =?us-ascii?Q?npQuXRE/BMvE+yqL41ELCBVbvxZFS2B6TdMWI5qv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0016230-0ce9-4438-d573-08da6f98ad81
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 06:24:36.3963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaGRRJT0VpsYHQUSc4sBjz6cnHVmiUir9X4UccdBJw5sWdDRpj+gbiuA6JmycrR8Z2uPBgJ1LCmX50WnNwQi8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
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

In Spectrum-2 and Spectrum-3, the correction field of PTP packets which are
sent as control packets is not updated at egress port. To overcome this
limitation, PTP packets which require time stamp, should be sent as data
packets with the following details:
1. FID valid = 1
2. FID value above the maximum FID
3. rx_router_port = 1

>From Spectrum-4 and on, this limitation will be solved.

Extend the function which handles TX header, in case that the packet is
a PTP packet, add TX header with type=data and all the above mentioned
requirements. Add operation as part of 'struct mlxsw_sp_ptp_ops', to be
able to separate the handling of PTP packets between different ASICs. Use
the data packet solution only for Spectrum-2 and Spectrum-3. Therefore, add
a dedicated operation structure for Spectrum-4, as it will be same to
Spectrum-2 in PTP implementation, just will not have the limitation of
control packets.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 114 ++++++++++++++++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  10 ++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  34 ++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  27 +++++
 4 files changed, 175 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 896510c2d8d7..1e240cdd9cbd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -29,6 +29,7 @@
 #include <net/pkt_cls.h>
 #include <net/netevent.h>
 #include <net/addrconf.h>
+#include <linux/ptp_classify.h>
 
 #include "spectrum.h"
 #include "pci.h"
@@ -230,8 +231,8 @@ void mlxsw_sp_flow_counter_free(struct mlxsw_sp *mlxsw_sp,
 			       counter_index);
 }
 
-static void mlxsw_sp_txhdr_construct(struct sk_buff *skb,
-				     const struct mlxsw_tx_info *tx_info)
+void mlxsw_sp_txhdr_construct(struct sk_buff *skb,
+			      const struct mlxsw_tx_info *tx_info)
 {
 	char *txhdr = skb_push(skb, MLXSW_TXHDR_LEN);
 
@@ -246,6 +247,82 @@ static void mlxsw_sp_txhdr_construct(struct sk_buff *skb,
 	mlxsw_tx_hdr_type_set(txhdr, MLXSW_TXHDR_TYPE_CONTROL);
 }
 
+int
+mlxsw_sp_txhdr_ptp_data_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info)
+{
+	char *txhdr;
+	u16 max_fid;
+	int err;
+
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		err = -ENOMEM;
+		goto err_skb_cow_head;
+	}
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, FID)) {
+		err = -EIO;
+		goto err_res_valid;
+	}
+	max_fid = MLXSW_CORE_RES_GET(mlxsw_core, FID);
+
+	txhdr = skb_push(skb, MLXSW_TXHDR_LEN);
+	memset(txhdr, 0, MLXSW_TXHDR_LEN);
+
+	mlxsw_tx_hdr_version_set(txhdr, MLXSW_TXHDR_VERSION_1);
+	mlxsw_tx_hdr_proto_set(txhdr, MLXSW_TXHDR_PROTO_ETH);
+	mlxsw_tx_hdr_rx_is_router_set(txhdr, true);
+	mlxsw_tx_hdr_fid_valid_set(txhdr, true);
+	mlxsw_tx_hdr_fid_set(txhdr, max_fid + tx_info->local_port - 1);
+	mlxsw_tx_hdr_type_set(txhdr, MLXSW_TXHDR_TYPE_DATA);
+	return 0;
+
+err_res_valid:
+err_skb_cow_head:
+	this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+	dev_kfree_skb_any(skb);
+	return err;
+}
+
+static bool mlxsw_sp_skb_requires_ts(struct sk_buff *skb)
+{
+	unsigned int type;
+
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	type = ptp_classify_raw(skb);
+	return !!ptp_parse_header(skb, type);
+}
+
+static int mlxsw_sp_txhdr_handle(struct mlxsw_core *mlxsw_core,
+				 struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct sk_buff *skb,
+				 const struct mlxsw_tx_info *tx_info)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	/* In Spectrum-2 and Spectrum-3, PTP events that require a time stamp
+	 * need special handling and cannot be transmitted as regular control
+	 * packets.
+	 */
+	if (unlikely(mlxsw_sp_skb_requires_ts(skb)))
+		return mlxsw_sp->ptp_ops->txhdr_construct(mlxsw_core,
+							  mlxsw_sp_port, skb,
+							  tx_info);
+
+	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
+		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+		dev_kfree_skb_any(skb);
+		return -ENOMEM;
+	}
+
+	mlxsw_sp_txhdr_construct(skb, tx_info);
+	return 0;
+}
+
 enum mlxsw_reg_spms_state mlxsw_sp_stp_spms_state(u8 state)
 {
 	switch (state) {
@@ -648,12 +725,6 @@ static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
 	u64 len;
 	int err;
 
-	if (skb_cow_head(skb, MLXSW_TXHDR_LEN)) {
-		this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
-
 	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
 
 	if (mlxsw_core_skb_transmit_busy(mlxsw_sp->core, &tx_info))
@@ -664,7 +735,11 @@ static netdev_tx_t mlxsw_sp_port_xmit(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	mlxsw_sp_txhdr_construct(skb, &tx_info);
+	err = mlxsw_sp_txhdr_handle(mlxsw_sp->core, mlxsw_sp_port, skb,
+				    &tx_info);
+	if (err)
+		return NETDEV_TX_OK;
+
 	/* TX header is consumed by HW on the way so we shouldn't count its
 	 * bytes as being sent.
 	 */
@@ -2666,6 +2741,7 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.get_stats_count = mlxsw_sp1_get_stats_count,
 	.get_stats_strings = mlxsw_sp1_get_stats_strings,
 	.get_stats	= mlxsw_sp1_get_stats,
+	.txhdr_construct = mlxsw_sp_ptp_txhdr_construct,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
@@ -2682,6 +2758,24 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.get_stats_count = mlxsw_sp2_get_stats_count,
 	.get_stats_strings = mlxsw_sp2_get_stats_strings,
 	.get_stats	= mlxsw_sp2_get_stats,
+	.txhdr_construct = mlxsw_sp2_ptp_txhdr_construct,
+};
+
+static const struct mlxsw_sp_ptp_ops mlxsw_sp4_ptp_ops = {
+	.clock_init	= mlxsw_sp2_ptp_clock_init,
+	.clock_fini	= mlxsw_sp2_ptp_clock_fini,
+	.init		= mlxsw_sp2_ptp_init,
+	.fini		= mlxsw_sp2_ptp_fini,
+	.receive	= mlxsw_sp2_ptp_receive,
+	.transmitted	= mlxsw_sp2_ptp_transmitted,
+	.hwtstamp_get	= mlxsw_sp2_ptp_hwtstamp_get,
+	.hwtstamp_set	= mlxsw_sp2_ptp_hwtstamp_set,
+	.shaper_work	= mlxsw_sp2_ptp_shaper_work,
+	.get_ts_info	= mlxsw_sp2_ptp_get_ts_info,
+	.get_stats_count = mlxsw_sp2_get_stats_count,
+	.get_stats_strings = mlxsw_sp2_get_stats_strings,
+	.get_stats	= mlxsw_sp2_get_stats,
+	.txhdr_construct = mlxsw_sp_ptp_txhdr_construct,
 };
 
 struct mlxsw_sp_sample_trigger_node {
@@ -3327,7 +3421,7 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->sb_ops = &mlxsw_sp3_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
-	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
+	mlxsw_sp->ptp_ops = &mlxsw_sp4_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
 	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
 	mlxsw_sp->trap_ops = &mlxsw_sp2_trap_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 50a9380b76e9..c8ff2a6d7e90 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -243,6 +243,10 @@ struct mlxsw_sp_ptp_ops {
 	void (*get_stats_strings)(u8 **p);
 	void (*get_stats)(struct mlxsw_sp_port *mlxsw_sp_port,
 			  u64 *data, int data_index);
+	int (*txhdr_construct)(struct mlxsw_core *mlxsw_core,
+			       struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct sk_buff *skb,
+			       const struct mlxsw_tx_info *tx_info);
 };
 
 static inline struct mlxsw_sp_upper *
@@ -700,6 +704,12 @@ int mlxsw_sp_flow_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				unsigned int *p_counter_index);
 void mlxsw_sp_flow_counter_free(struct mlxsw_sp *mlxsw_sp,
 				unsigned int counter_index);
+void mlxsw_sp_txhdr_construct(struct sk_buff *skb,
+			      const struct mlxsw_tx_info *tx_info);
+int mlxsw_sp_txhdr_ptp_data_construct(struct mlxsw_core *mlxsw_core,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct sk_buff *skb,
+				      const struct mlxsw_tx_info *tx_info);
 bool mlxsw_sp_port_dev_check(const struct net_device *dev);
 struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev);
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index dd7c94dd4c01..25d96bedf243 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1385,3 +1385,37 @@ void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
 	mlxsw_sp_ptp_traps_unset(mlxsw_sp);
 	kfree(ptp_state);
 }
+
+int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				 struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct sk_buff *skb,
+				 const struct mlxsw_tx_info *tx_info)
+{
+	mlxsw_sp_txhdr_construct(skb, tx_info);
+	return 0;
+}
+
+int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info)
+{
+	/* In Spectrum-2 and Spectrum-3, in order for PTP event packets to have
+	 * their correction field correctly set on the egress port they must be
+	 * transmitted as data packets. Such packets ingress the ASIC via the
+	 * CPU port and must have a VLAN tag, as the CPU port is not configured
+	 * with a PVID. Push the default VLAN (4095), which is configured as
+	 * egress untagged on all the ports.
+	 */
+	if (!skb_vlan_tagged(skb)) {
+		skb = vlan_insert_tag_set_proto(skb, htons(ETH_P_8021Q),
+						MLXSW_SP_DEFAULT_VID);
+		if (!skb) {
+			this_cpu_inc(mlxsw_sp_port->pcpu_stats->tx_dropped);
+			return -ENOMEM;
+		}
+	}
+
+	return mlxsw_sp_txhdr_ptp_data_construct(mlxsw_core, mlxsw_sp_port, skb,
+						 tx_info);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index d5871cb4ae50..affc9930c5f9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -57,6 +57,11 @@ void mlxsw_sp1_get_stats_strings(u8 **p);
 void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 			 u64 *data, int data_index);
 
+int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				 struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct sk_buff *skb,
+				 const struct mlxsw_tx_info *tx_info);
+
 struct mlxsw_sp_ptp_clock *
 mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev);
 
@@ -65,6 +70,12 @@ void mlxsw_sp2_ptp_clock_fini(struct mlxsw_sp_ptp_clock *clock);
 struct mlxsw_sp_ptp_state *mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp);
 
 void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state);
+
+int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -145,6 +156,14 @@ static inline void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 }
 
+int mlxsw_sp_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				 struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct sk_buff *skb,
+				 const struct mlxsw_tx_info *tx_info)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct mlxsw_sp_ptp_clock *
 mlxsw_sp2_ptp_clock_init(struct mlxsw_sp *mlxsw_sp, struct device *dev)
 {
@@ -164,6 +183,14 @@ mlxsw_sp2_ptp_init(struct mlxsw_sp *mlxsw_sp)
 static inline void mlxsw_sp2_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 {
 }
+
+int mlxsw_sp2_ptp_txhdr_construct(struct mlxsw_core *mlxsw_core,
+				  struct mlxsw_sp_port *mlxsw_sp_port,
+				  struct sk_buff *skb,
+				  const struct mlxsw_tx_info *tx_info)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline void mlxsw_sp2_ptp_receive(struct mlxsw_sp *mlxsw_sp,
-- 
2.36.1

