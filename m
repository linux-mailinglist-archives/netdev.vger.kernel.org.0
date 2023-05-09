Return-Path: <netdev+bounces-1038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 598EB6FBEFF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65C971C20AFB
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5423FF9;
	Tue,  9 May 2023 06:07:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D226033C7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:07:01 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2118.outbound.protection.outlook.com [40.107.244.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFE29039;
	Mon,  8 May 2023 23:06:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mI5bP4/EQ6l1Prs36fD1Wn76KlfezqyqQJrs8QMo2nDQfTHIe5gRUM22DkTUruSySsgmPplQQm4jKERmrDEMYX+NLt/GP7NY4amLq3YJuIF64W2fK9UR2IvX4/DveznsQctj12t60roR4d49CiYRYVvMXTXssjiXOCCHOC7zNBOjFxZVuD9HEuqlCz+TxChW+54ncbuqUyYjuzoRGvgL4BpT1msO9uoBrvmb5Q0AmYkY1mKkwRY2fRyk7kMSJEJ6SzjGnBHjCreGSVHz9e2ymmcONT1LqMv431Bc8KILrMz7zgsBCylsKhTMAPp91B2nZ/1hPYifmvM1wn2TJz2r/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7voOdwIdMWl25MKFLsFHV/FPxo0I9kJbHUohmxDeiEA=;
 b=nxUs01mkqo9Totm7sgn9JMH9TDL7kx8CjYmHZYSQj2gs2NezxdM2YZTvIuKSx3dTJswI0T7BGV6lLG9jLODQR4zvsfm3KulNLziVokg5sVHRrWCtMFd/ElinKcvsiP4XEBlroU03P3Qq/sZsTSPSef0LYZqcEWldI4s80Lx5pW/rF026cGQWnL/+astNGfVRvWfwO2muCnfGnPsYdinmipMGhiHa3yisRYq3NP/+mPFYwLU/s6o9SyZ1Ne+ANd0DgCpsGpyNacGN8mkJMqpYXLW285/wC2taj+FTvE10CzOiXU0bHaWnH4fRUsDvX+uyWbJB3bm8qt0+xhLPkQkQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7voOdwIdMWl25MKFLsFHV/FPxo0I9kJbHUohmxDeiEA=;
 b=kL2ejjE6fOdHdj1n8E5AzIffwqucsa+AzXAreIYb96X9AZtl2coaunBaprc7kozwovt7J1Z6FHUeq2eRwecRDgpmXcHbix6UapxG7RvMBXzcnkTIqIrKP3eTkiEKPgRHb8oQGvO8nJo85Jw6ErfosNO9YoqL7yfNoT/dXrdf9NU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA1PR13MB4989.namprd13.prod.outlook.com (2603:10b6:806:1a1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Tue, 9 May 2023 06:06:56 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 06:06:56 +0000
From: Louis Peens <louis.peens@corigine.com>
To: David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net] nfp: fix rcu_read_lock/unlock while rcu_derefrencing
Date: Tue,  9 May 2023 08:06:32 +0200
Message-Id: <20230509060632.8233-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JN3P275CA0013.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:70::18)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA1PR13MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e50600-c0fd-4cd2-2729-08db505397e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vCXx9ctJZJDSPfnp6GLAivx2h2FNCXpAd+Ap1OJ1ogqFYJWdU/AruLxJiJ7EUB53/zFZEdxqfRdy3MZqPIPhfsVqsVfD8xMq45+eItWdMEpg3/uTEOZyK7hKDN9AjTSi0zMFESfuDRrtduqWI8zgNepn4g/stT7By2rwZedVUBW6zzsQuCBzSVA1LAH/Z1/Olq7l4M8C0WdfjsmLID57A19aYl9Ft0LAqAk9Yh7z09AyY2HJHGmbtAM7ANwcM6BQhWBnKpxyTXQZJ1Tl9Vu2jSpRH4hU60JCtLtCV1CYHKUan4I4uVkUwLllxaxZmZO2WlMizGcthEzA46CftzPXA16Dd5v78v5Qv5ojnkbdUMOg8Gbx5khXXGtgL75FyrobG1ZHhYNmYmjx/Uppeaz8IwkOe5zb9pH0TyKCX+Dek7VlVB8YKnq8w2rdtsI64/TgeTEKiAp6x7CCjsht2uddYbSNaBhqUcO9bCLYJha87SVUwgHO4IPK1WD7UHlN4p+bbEL0S7qgzYDU/Zwn11WaOEpGLR/ozQbqGJ0vqzdAkSOn8e3bPXbTF+fgRG9Y2abeWOQ9tc+uhSiNB6mZ/HUXIU/TVcwJHV76c6bQ0xr6xkYrjvrIBRDPUbY0HIsXknIzDJYTXcHPU49o1icA/vOahQfeJhDw2EGPQht3W7YrBuU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39830400003)(366004)(376002)(451199021)(83380400001)(6486002)(110136005)(6512007)(55236004)(26005)(478600001)(6506007)(186003)(8676002)(41300700001)(4326008)(66946007)(66476007)(6666004)(52116002)(1076003)(107886003)(8936002)(66556008)(316002)(2616005)(5660300002)(2906002)(44832011)(36756003)(86362001)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nwk+omiPrUy/laj1Jl6E8IKEGYL6zxk2BEd4MmhwVCgIsrcycSIFAhDTbj5K?=
 =?us-ascii?Q?TLGbIF2FvJG5AtR3HrEl80zr4ZyIGFtRvIXTcz7KtvO8D3D54rvvxt5ha9Hz?=
 =?us-ascii?Q?XB7TKq0S8TKpTSmJHeenn3vTVZAzvxR1wW+NDxfzWB80QRHFwZJ+pqEyCUCa?=
 =?us-ascii?Q?rr/feitJCFz1NQl2n0CkktBaYrAKGOs9nHXafMa+Bo8UXBzbcrubVf4ucTci?=
 =?us-ascii?Q?bYYwDlRncz9GPtFyraYRF5uJnu6qzANkFS8K4lSdS0AQ5uODkxATeU6tB1HN?=
 =?us-ascii?Q?Il0Es84c+vkGBsPSQKr9HZsaNuVBON6Jnfzq5QYFTghUqUvCzVlJji9QGMMC?=
 =?us-ascii?Q?kAS0lp7O/+V5dr98dJ/wqapitqq2DTATWVpZJOqQ0CaMWdyN0YrDmeDYtNQv?=
 =?us-ascii?Q?zZNfAKVm4nQfLF0K+ycqG63TwO5vXrN4JqAL8aHSpMTl9kES0TQC0YQTUada?=
 =?us-ascii?Q?lC2iejic0/6Mo/2LPY/f/7UC0ITzOtutQk3IX9VRlnDxHzhsW9/wiXo6i5Qn?=
 =?us-ascii?Q?BU8GMv6PvYz0Uf/MeqvDjY/xH+OCkRB2JwqHKjd4pHJfKpvGfEUNwnOqm37f?=
 =?us-ascii?Q?60e1WJxjpTB33Fn7klPLYYtbhO8+M+DHrppWyusynEnpxyNB5EssIXSrSrWK?=
 =?us-ascii?Q?EkCaKRZsAaowtfkcbiA2YUUn5Ffbfnui7L6TbRd0Gtt9e7rrxLZhXbwurJEa?=
 =?us-ascii?Q?1qXWuTUYhUWRxdEOlhwANBE0dEy80ttunKYfegjAH6jkonB+mOuJlNEq1QwR?=
 =?us-ascii?Q?wF3cf0AQ1uJw0vlQzcrX4duNGCaHoXkPL6R/bfVRxega/VWV4AKV3zirfEyO?=
 =?us-ascii?Q?L4vY51LcxJ9V/YdaBpa9V7d+mqol1wJAi6rBIZ7j2OPLOkAgFA/c+JIxHGbu?=
 =?us-ascii?Q?VkApdVAb95pCG/F7Plam7w+ur+w96KEmChAennav+2QzFyHKeUbEzyFJJhnV?=
 =?us-ascii?Q?Q6t8LHFdQe9HtwVRu3eiDWnUjjcbno6694XA6qg7/D0iEwh2Zry5CeyK8ecM?=
 =?us-ascii?Q?jFKxEJ9XkJIAgUhLUrw3QXF/qNAekQ5hy1NyzscW+uPndkVUN0qmd3GtTp8V?=
 =?us-ascii?Q?Em2tnmEGaqSyE/IMscjjEmPP/hhQ02TQ5h/z3Y83WpnEpVijC/9y1aTby+gt?=
 =?us-ascii?Q?bLR00fBcnrQHSx4UToGOcTnFZpKHr8dBH/MJnDDoArZ8zEX4TN1djPTRdtyv?=
 =?us-ascii?Q?7H6pa7/RRNnl7fedCDTeGhv/Wlloh7sDP6g4k1jXec8Z2jIGjyBZGiee5gLE?=
 =?us-ascii?Q?9XZCiEOSKDOtETF30+VCuvRunwsavx6WsISmRLikhlc3j6VSrLD25rgVTKrR?=
 =?us-ascii?Q?D03yapnFdQpmnIpJCuq72mTi3rq3aW2FwneaYiqAvgxjURUhlEwK0w0tl9ad?=
 =?us-ascii?Q?O+GD9gZftRkRKdWj8lxwTGSadgRwsvppFEcc9/ILals78+7Ahsg3lZAxNMLJ?=
 =?us-ascii?Q?MiMwCBQFfyK5IQpTLRq3dJstYOGWSgF4RyTpcpqn5hKCyDvcgj/U9JwekGYl?=
 =?us-ascii?Q?fnJYddEnqRubL72jY9JpII8LQ1wfC7kCYb2ybWIJWP+JhO06CY6QghpPo3Ft?=
 =?us-ascii?Q?zcRbyE/BbSszUV3dmZg8v2o/fNRRecNpFzY7kr6m2xxM3atMExR1EsjvFwgO?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e50600-c0fd-4cd2-2729-08db505397e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 06:06:56.5578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myQsraGMHyBqQPM1KPwrCFNPwP6qXdOWrXD1lMLRuB+s5UkyR4rX1TQ87e0kl0QvUtnS+fU5nSXdrPrNsYRynjelBwr/i/EUprZbzMhKPpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tianyu Yuan <tianyu.yuan@corigine.com>

When CONFIG_PROVE_LOCKING and CONFIG_PROVE_RCU are enabled, using
OVS with vf reprs on bridge will lead to following log in dmesg:

'''
 .../nfp/flower/main.c:269 suspicious rcu_dereference_check() usage!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 no locks held by swapper/15/0.

 ......
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x8c/0xa0
  lockdep_rcu_suspicious+0x118/0x1a0
  nfp_flower_dev_get+0xc1/0x240 [nfp]
  nfp_nfd3_rx+0x419/0xb90 [nfp]
  ? validate_chain+0x640/0x1880
  nfp_nfd3_poll+0x3e/0x180 [nfp]
  __napi_poll+0x28/0x1d0
  net_rx_action+0x2bd/0x3c0
  ? _raw_spin_unlock_irqrestore+0x42/0x70
  __do_softirq+0xc3/0x3c6
  irq_exit_rcu+0xeb/0x130
  common_interrupt+0xb9/0xd0
  </IRQ>
  <TASK>
  ......
  </TASK>
'''

This debug log is caused by missing of rcu_read_lock()/unlock().
In previous patch rcu_read_lock/unlock are removed while they are
still needed when calling rcu_dereference() in nfp_app_dev_get().

Fixes: d5789621b658 ("nfp: Remove rcu_read_lock() around XDP program invocation")
CC: stable@vger.kernel.org
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  4 ++--
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  2 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |  4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_app.h  | 16 ++++++++++++++++
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index 0cc026b0aefd..3e5a84370d8a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -1058,8 +1058,8 @@ static int nfp_nfd3_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			struct nfp_net *nn;
 
 			nn = netdev_priv(dp->netdev);
-			netdev = nfp_app_dev_get(nn->app, meta.portid,
-						 &redir_egress);
+			netdev = nfp_app_dev_get_locked(nn->app, meta.portid,
+							&redir_egress);
 			if (unlikely(!netdev)) {
 				nfp_nfd3_rx_drop(dp, r_vec, rx_ring, rxbuf,
 						 NULL);
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
index 5d9db8c2a5b4..6ec5b0d430ea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
@@ -71,7 +71,7 @@ static void nfp_nfd3_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
 	} else {
 		struct nfp_net *nn = netdev_priv(dp->netdev);
 
-		netdev = nfp_app_dev_get(nn->app, meta->portid, NULL);
+		netdev = nfp_app_dev_get_locked(nn->app, meta->portid, NULL);
 		if (unlikely(!netdev)) {
 			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
 			return;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 33b6d74adb4b..0ac68985d289 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -1177,8 +1177,8 @@ static int nfp_nfdk_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 			struct nfp_net *nn;
 
 			nn = netdev_priv(dp->netdev);
-			netdev = nfp_app_dev_get(nn->app, meta.portid,
-						 &redir_egress);
+			netdev = nfp_app_dev_get_locked(nn->app, meta.portid,
+							&redir_egress);
 			if (unlikely(!netdev)) {
 				nfp_nfdk_rx_drop(dp, r_vec, rx_ring, rxbuf,
 						 NULL);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_app.h b/drivers/net/ethernet/netronome/nfp/nfp_app.h
index 90707346a4ef..639bb1a6349b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_app.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_app.h
@@ -417,6 +417,22 @@ struct net_device *nfp_app_dev_get(struct nfp_app *app, u32 id,
 	return app->type->dev_get(app, id, redir_egress);
 }
 
+static inline
+struct net_device *nfp_app_dev_get_locked(struct nfp_app *app, u32 id,
+					  bool *redir_egress)
+{
+	struct net_device *dev;
+
+	if (unlikely(!app || !app->type->dev_get))
+		return NULL;
+
+	rcu_read_lock();
+	dev = app->type->dev_get(app, id, redir_egress);
+	rcu_read_unlock();
+
+	return dev;
+}
+
 struct nfp_app *nfp_app_from_netdev(struct net_device *netdev);
 
 u64 *nfp_app_port_get_stats(struct nfp_port *port, u64 *data);
-- 
2.34.1


