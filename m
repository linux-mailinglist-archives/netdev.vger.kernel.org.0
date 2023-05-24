Return-Path: <netdev+bounces-5023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E07770F732
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59A892813C7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9948160872;
	Wed, 24 May 2023 13:02:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F9C6084B;
	Wed, 24 May 2023 13:02:23 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2044.outbound.protection.outlook.com [40.107.7.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB3E5A;
	Wed, 24 May 2023 06:02:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ui86wVHYq8EBojzLapfdX4BK+bIoF6V2DDBVYjO1Ff2hD2CQDtCj2Sj3e0MHbH+9ileAd9He3m3dXt9A19pfGeKZZ3eEUjENdjO8yFt69BqWp+OwCU6LuRV+itiOX6GzKWqkaUwoTsL5X38NjYu7h6LIDbv6zX5BLNgkMYNAB78Hy7VPyz2Jikx77oEuSCY+ypZ7BnxhcTj7c7t1jJXOmUM4+SsDfUDZz39tQOGEubT9QM5MslA/HvtOULc5DbQbJINRoYBaUcX2gKO6XomFGark/L5aNhgDC8plkb/ENvjCs0YrOzSYrvnhTJG85x/f4QQ2Rkyt2iDhcre5GhbkFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOOzGhN8zeK8EnP+vIKsmAHCmdkmrTUbdHOXdKO7agM=;
 b=e/MkLJhe8m2TEvJei5occXBeqgSCLhI8q41SOPJRA7IaWvjbmKZ1B0e0AQKdtwnKjFNqGKGuITGtIPlo5KT0FTrl+xyUkPkdkgSFmOWnTgXKYi0tL2WsBiW6byqt//F3HwL6BxyOV1K+D4imeAq5C5i44BJ8aXLeTIrJdkJE2uSr1L8kw6ACEruOY3P26Or02K96zNCCpbAJx9j9zq/x77/orMJ4W0QNjI3cX2RfasGzGFV1Xo1FwOi/BdOt0Ymk0TH/xGqR+otmSltGcX+KAbFHrpF/b6UJJEN2850Tvxl4wEk7D0kr3Q0u7FxWPw28bHjg0hgAJgujFGsVJK0VCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOOzGhN8zeK8EnP+vIKsmAHCmdkmrTUbdHOXdKO7agM=;
 b=KZQbZ/j+f8Rswa2efYXs893y0IpeAm2M6F4ddUJe/A5NPy1E60qjqW35ojSSLVjvZdkUwLTtGfJbaUBcy8xrngOATsBF3b69oCidLNXTzYx1nhPIG7whJ3U7smuRvhmV/8n5cHO8ORK4LqWmLuqwRrUEMrFNmAU/Ss3ogy9FaxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by DB8PR04MB7099.eurprd04.prod.outlook.com (2603:10a6:10:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 13:01:45 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 13:01:45 +0000
From: wei.fang@nxp.com
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	peppe.cavallaro@st.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com,
	pabeni@redhat.com,
	mcoquelin.stm32@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@google.com,
	gerhard@engleder-embedded.com,
	lorenzo@kernel.org,
	simon.horman@corigine.com
Cc: netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH net] net: stmmac: fix call trace when stmmac_xdp_xmit() is invoked
Date: Wed, 24 May 2023 20:57:14 +0800
Message-Id: <20230524125714.357337-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|DB8PR04MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 98866545-8d90-4dc4-6d5e-08db5c570727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	96xSO3Tg8OUEkYlRrHxsNBwYzIRQ0ZNiKiHdYfbog+WIbgdAwz6NQ93W+7ByEkBvCMvRuONplrCqFHIIO5YjLrL/8pKx53SJcRB2pyRT3n4EYsxY9/iF+QDreriEN4jz8+7B2bOu69AS2K4Jk2JXmGGZvhKsklQ6F+iFxDjbdkudn7dM4izxQe+ObJmUS4BFpzHyneN9SgiwhNypk4ASvXRmfKT0ikWZDxSTaP/4ix1CgulejD/zLxrUISbTsnsTXMKmmoYyAL+VD9MegBIyB3L5RmIam1AaLTMdrSwJoVMm7won67IL6GKuoYg2zOXvPyktKvslyKzJZkAGkQiL5/SqpALdG7KrePfY7Fxn9D8NxTNzs6/5XR0XlYzqRIqDaG1e7R39fAMPFW3i7N08d/EHyT8bdA+YLBlmf+GeSBhTLpJt84n8YVhzPVU4I0GskQ89SEYl0LZ8tU8gbDRh/rWeYQ72wCVWp+7j68rw3jQ4eKy4tanK8DaJjyiYkUR9QgTW84JpdjZfYxZ9qq1VV/uzCkpkE/jhhPmRDkBBPzcblLK12huifLGj9f9Gd4i7SkklWx6wtjo9sdG4bnwA5VlF1nPatagH37Nzhrm4InnGBon0UBuDVaqQKbD4ruVddKCYAaJsf4aVkVDMouGXhaxQ8zlMUuXUPGuDyWS000Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(5660300002)(8676002)(8936002)(86362001)(26005)(6512007)(1076003)(9686003)(6506007)(2906002)(83380400001)(2616005)(36756003)(186003)(7416002)(66476007)(66556008)(66946007)(921005)(45080400002)(316002)(4326008)(38100700002)(38350700002)(478600001)(41300700001)(6486002)(52116002)(6666004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ypEUoa0ncaCu9z5NNYrqOBf1slczIEtEYsbqsJLqYL+uFt/rncQfFW8Xhlz5?=
 =?us-ascii?Q?tx8YxyPYIInrYfl6Fl0qNo2HrYPW7w8+epCnAiSeQXHjkR4M2Sg3YLHkTCIT?=
 =?us-ascii?Q?E17f0lkvXi94aKTrU4stFB+/EMRMF/UsI3VZD0UMKvYr9JF6Db5X7TdLcs0/?=
 =?us-ascii?Q?qSTC5PCn06CLrbQ/nho4wwCiz+p6oaasGTt/RWfKdO6P08MpekXPyxZxr0np?=
 =?us-ascii?Q?OLqMNMIWNeem9s8HigIUAswP0alEM1d9bt4wkRgkDSQbehAPzAG2UGy7fm0o?=
 =?us-ascii?Q?YMiPdJMo41yxoLCfi6D3rsibDgQlj0rWjr5H/qi0HnNgjIIv2r/fxLXRMOpW?=
 =?us-ascii?Q?4Gb5DayOfWk0YWu4Ix8Db+lLL9rXxHu85rwnC3gYladpQ0UBgGF/pqd79hdc?=
 =?us-ascii?Q?ad/tRprTwprhmYL0ew8xTirKUiwkMooY+RxaTIfXGGU1/RhXSkQNGKH77aje?=
 =?us-ascii?Q?8gtRkJisw7H1K4UOzrV0irzRUzjToQnl1VdMSFk2vch66xERqBZPhYheuupM?=
 =?us-ascii?Q?QtsCZHU38b8aMD9gAgIhOsBX9R2SyngGnfpk35g0r0ae9/4mM+GDMdkxcL+r?=
 =?us-ascii?Q?iQp6c5XscIADZIA01bhd0CjQqiGLLhr7EUBVImt/i2y9o03HU3frRGy6pQe5?=
 =?us-ascii?Q?Rzc9e+W823WPXzZF6oChMOJdhZeHkAzlOjfeGVmGYr12c/z1OsiREtvwvIs4?=
 =?us-ascii?Q?B2Pg7JRM5H5npws3rtu4WwR4DuGFJd7dMbpS0Z+ahXIPRIcz2Gd/BNY7j8dE?=
 =?us-ascii?Q?F10Pj0kVuoilG5Ef3cdQ+qkw7en1OI82m/XZ0VN8q/5iuDptMVOfVG6orARH?=
 =?us-ascii?Q?zcqpwm4mGM21lY787gQVg/CxU0AVf8ic/qxX98UBnUfBufeNQVqx2lCtJI6D?=
 =?us-ascii?Q?WxvGs/tFWSRjdSQv4nQ13TRexOm7p6xBbipyAZcFc3gpE8mjnQOgqlTPz+PL?=
 =?us-ascii?Q?0vn1rLLsTNqPjvwvG/COQfGiub4Igb8n/sixyVmV5hSnZXGT3LjvS62UU5h1?=
 =?us-ascii?Q?ZO10WF+IRvabkkOyCQdbVRlDN5aOPuS58A0UBj9YYNrSnOzaQJkAfaYdfURR?=
 =?us-ascii?Q?PlhkEjgOnjZ0/zveGCBFECyELt2AgpzYjip8VQf7Tb9/MO7sI3Ye8OTbMD3v?=
 =?us-ascii?Q?QwgbeWkDgNfiV6mT1w3tSnQJT7SMPkaSmZfaTDw7SXL8aH6RqstA2Q5HCgn/?=
 =?us-ascii?Q?k9xkB4P7wD157q7Fi3StMRFQCn7lnRlfXmh2payhu++3FhVDm3FqA+NTiC4A?=
 =?us-ascii?Q?92PQNyRG1p/lXqbHlMiDSVJXfJIPVmyUPkOQHZKf0hcvaTztxK02xiGidu5r?=
 =?us-ascii?Q?jlya4D3C2IkdBxck7Abpnua7ARaL92Fh4yLqM+vWH4StWi+EyojtEax3vFJZ?=
 =?us-ascii?Q?jKQcNhB8f/UsC7is7tHku9y0+j0hN8ILSp8MlH/0pUaEwnJhpoGM37hJKx+7?=
 =?us-ascii?Q?Qq3yj1HrDZYIuP+WFBS4lEeSV8CfYIEGD36lnTk1dvekmzVAYK88zsFiNyy6?=
 =?us-ascii?Q?r2TmYODlqn7T3IIR8YtsrSGjjEC6fXfytYBOWHOlJR9sz0RDd59+pSGBp/Tx?=
 =?us-ascii?Q?dTPS7zwcKYDMZ+nzhP55aRm04KQZtuYnOkTI+9Xa?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98866545-8d90-4dc4-6d5e-08db5c570727
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 13:01:45.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQmkqpVt8yx8v5r6qtnR5QcdC7C6zW/ptG8PRLdacdDch+f1CMucvvXv67bgokU4Ob0lgeX9r52bLVSREjShVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7099
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

We encountered a kernel call trace issue which was related to
ndo_xdp_xmit callback on our i.MX8MP platform. The reproduce
steps show as follows.
1. The FEC port (eth0) connects to a PC port, and the PC uses
pktgen_sample03_burst_single_flow.sh to generate packets and
send these packets to the FEC port. Notice that the script must
be executed before step 2.
2. Run the "./xdp_redirect eth0 eth1" command on i.MX8MP, the
eth1 interface is the dwmac. Then there will be a call trace
issue soon. Please see the log for more details.
The root cause is that the NETDEV_XDP_ACT_NDO_XMIT feature is
enabled by default, so when the step 2 command is exexcuted
and packets have already been sent to eth0, the stmmac_xdp_xmit()
starts running before the stmmac_xdp_set_prog() finishes. To
resolve this issue, we disable the NETDEV_XDP_ACT_NDO_XMIT
feature by default and turn on/off this feature when the bpf
program is installed/uninstalled which just like the other
ethernet drivers.

Call Trace log:
[  306.311271] ------------[ cut here ]------------
[  306.315910] WARNING: CPU: 0 PID: 15 at lib/timerqueue.c:55 timerqueue_del+0x68/0x70
[  306.323590] Modules linked in:
[  306.326654] CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.4.0-rc1+ #37
[  306.333277] Hardware name: NXP i.MX8MPlus EVK board (DT)
[  306.338591] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  306.345561] pc : timerqueue_del+0x68/0x70
[  306.349577] lr : __remove_hrtimer+0x5c/0xa0
[  306.353777] sp : ffff80000b7c3920
[  306.357094] x29: ffff80000b7c3920 x28: 0000000000000000 x27: 0000000000000001
[  306.364244] x26: ffff80000a763a40 x25: ffff0000d0285a00 x24: 0000000000000001
[  306.371390] x23: 0000000000000001 x22: ffff000179389a40 x21: 0000000000000000
[  306.378537] x20: ffff000179389aa0 x19: ffff0000d2951308 x18: 0000000000001000
[  306.385686] x17: f1d3000000000000 x16: 00000000c39c1000 x15: 55e99bbe00001a00
[  306.392835] x14: 09000900120aa8c0 x13: e49af1d300000000 x12: 000000000000c39c
[  306.399987] x11: 100055e99bbe0000 x10: ffff8000090b1048 x9 : ffff8000081603fc
[  306.407133] x8 : 000000000000003c x7 : 000000000000003c x6 : 0000000000000001
[  306.414284] x5 : ffff0000d2950980 x4 : 0000000000000000 x3 : 0000000000000000
[  306.421432] x2 : 0000000000000001 x1 : ffff0000d2951308 x0 : ffff0000d2951308
[  306.428585] Call trace:
[  306.431035]  timerqueue_del+0x68/0x70
[  306.434706]  __remove_hrtimer+0x5c/0xa0
[  306.438549]  hrtimer_start_range_ns+0x2bc/0x370
[  306.443089]  stmmac_xdp_xmit+0x174/0x1b0
[  306.447021]  bq_xmit_all+0x194/0x4b0
[  306.450612]  __dev_flush+0x4c/0x98
[  306.454024]  xdp_do_flush+0x18/0x38
[  306.457522]  fec_enet_rx_napi+0x6c8/0xc68
[  306.461539]  __napi_poll+0x40/0x220
[  306.465038]  net_rx_action+0xf8/0x240
[  306.468707]  __do_softirq+0x128/0x3a8
[  306.472378]  run_ksoftirqd+0x40/0x58
[  306.475961]  smpboot_thread_fn+0x1c4/0x288
[  306.480068]  kthread+0x124/0x138
[  306.483305]  ret_from_fork+0x10/0x20
[  306.486889] ---[ end trace 0000000000000000 ]---

Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c  | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0fca81507a77..52cab9de05f2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7233,8 +7233,7 @@ int stmmac_dvr_probe(struct device *device,
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_RXCSUM;
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			     NETDEV_XDP_ACT_XSK_ZEROCOPY |
-			     NETDEV_XDP_ACT_NDO_XMIT;
+			     NETDEV_XDP_ACT_XSK_ZEROCOPY;
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
index 9d4d8c3dad0a..aa6f16d3df64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -117,6 +117,9 @@ int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
+	if (!prog)
+		xdp_features_clear_redirect_target(dev);
+
 	need_update = !!priv->xdp_prog != !!prog;
 	if (if_running && need_update)
 		stmmac_xdp_release(dev);
@@ -131,5 +134,8 @@ int stmmac_xdp_set_prog(struct stmmac_priv *priv, struct bpf_prog *prog,
 	if (if_running && need_update)
 		stmmac_xdp_open(dev);
 
+	if (prog)
+		xdp_features_set_redirect_target(dev, false);
+
 	return 0;
 }
-- 
2.25.1


