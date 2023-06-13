Return-Path: <netdev+bounces-10539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A1E72EE75
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C0632812A3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74883ED9F;
	Tue, 13 Jun 2023 21:56:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C2C17FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:56:02 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00C01FD0;
	Tue, 13 Jun 2023 14:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h62wQ1+00oE687FWb53QRga1QCNZGdsxdLYQ26kVm2DK5rux8apbFFQf6UPzEABWwyIXFlxbA6B1ltktW1+b8xqIpMKhA9fe8NyHEAUrlDJO6Quqb1uORqS5V47Q5phfdF3tWWqe7s77BMRkWymIsCebFRWRlh7r3vmS7uRh8asg/TP9gKWWkgtNDqwdYJ3dCfkRtpALungzMf8hZ7z16oC1njjp97QW5NCE4QaJkLDWl6kMMSGTML6f1TVIizxrq8paZKmiW92lo0O5PMfN77W1u5zhHCCAmvCYB3FsWZqVne4bfnD8AaUAFUVUVRVXDoqEeHU/zJJHk+jIiLiX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TfwPY6ZlTT2N8yXf2xt9pS8vWsn9f2Y+RMcWSUcIWZc=;
 b=nZpa5Gqfd+zlW5E+wpaqpQhaR7JMOodfX4R3GFTZ1dC2/QX83skm0k1bD0TMPaLqCIESKhaSFBNSqrgkJg/fVtmO/Nzs5Z8um/4W2EHF0hwuLQuOWyBqrGdVp5Q8YJyd6pTYajWElardblrXMrKp+vkGdo1uPp1Ryl04OcQUcwuI9YYIHPMf2C3gfOsQMMQPcj6tWZFabAOo/sTWalPZ1AAXmqZDMCpEsgOko3r3Zxpgwam2cbw6ZCo994Gp/r9A2AIqgFyzDIygJ8YFE4L4917WZSazq2jkqjaJLFQdkzk97unfpt5iZlNAGI773aaFDm1YGgUqYlCAI+4QAXh7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfwPY6ZlTT2N8yXf2xt9pS8vWsn9f2Y+RMcWSUcIWZc=;
 b=hc34vlNsFoxpJWPYKOpD9dKu16HSNKQNyuvk/v55dMygn5c2pZpo2+qx2K09fBojY3SDsTktLb8kM9FCcwpXR+O+rTZZl7uDOzI3jn7yQnYc5alJ2OD/CeKz4EpQqGz0CZPdRflXnpsBcskJpmRKgIrPcFey/XnIiZ1JJD7oZ1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8081.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 21:54:59 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 21:54:59 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: [PATCH v2 net-next 6/9] net: netdevsim: create a mock-up PTP Hardware Clock driver
Date: Wed, 14 Jun 2023 00:54:37 +0300
Message-Id: <20230613215440.2465708-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0044.eurprd04.prod.outlook.com
 (2603:10a6:208:1::21) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 3276a6a0-f30c-4411-0606-08db6c58d4df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QAGswmFyL0uMWILtTNxpZE12+si6HLpCoNw+n53HHDqvOpLyRMynOMHUnYg+1Yjpy17om7uS3BNs4LIQOrAAlCyClwEfKWTuZ1GnoMu0Y4OgdLdtmuxXgvT45eD2zvIQPrBPRowdC4ZoJStoEIMrWlf8MMLo/8SygmA7UH1jfwFJobrCIJ2baAAxpXC8f/7tsGo1RDKrr4UmDFkfyQxwlBYw08zrUHFikY1JtsWOXV7TVigFG/yLOQCrR3FWoBrW8/YNPxX0S955cb9vk0dac2akQlMz7P+b9MiBHE8qXZ/kRTvFiHEvoCZlnpKSUL+cf/Xk15mjg/K4bPnLfvtQ7euLC5FEWgP5ZXi97EqiK4/emNyi3ZIhGrEHI0YQ7C3UDCTn6dfsncZVWPtgHidf7sbob68CBKwn5hcd/mXASPKw8ofNfRDDueIm3NRyBnxZzn6am2gm1ncNIiGO6VzbMeq750JN3l6JEbKwa5AMNVqs4Xc4ZGnhahb7gW3D9flpj24ogScRNIYcSkhUg42KUX9ykrQg6zvRxqEaZYG272yuOsNx+Sqkub7ribSw567xlSnL6KGL6Q2+VoPZwPnBHqk7HjsAw5dYHtfhpGIe4QFw4cY3RKcYan9Z18EOVzj0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(6916009)(66946007)(4326008)(66556008)(36756003)(186003)(54906003)(478600001)(2616005)(30864003)(2906002)(66476007)(66899021)(8676002)(6666004)(316002)(41300700001)(86362001)(6486002)(7416002)(6506007)(1076003)(8936002)(44832011)(83380400001)(26005)(5660300002)(38100700002)(52116002)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nBDezOdwsL/CeYx5137Wi0oI/I9GEyPEZ7HNdLo4Han+qz9QQLxEtwnYH2Y/?=
 =?us-ascii?Q?B/nJsSWW2KJXovGwhzuMxLsJsQXFfL62e8tav+niWKugfu+MhscNOmqJOZ9U?=
 =?us-ascii?Q?HUcv0WTgSem20EebX3NL1n0/JH9uHihsOlx+vfoqVMoH2uy09sIElQDOuYJw?=
 =?us-ascii?Q?yxvdjG3Lh0KCxakb81Fbf8FQCRh2qotkB40wCzx7kpHXPQRYH88krqeoUQ5Z?=
 =?us-ascii?Q?M72lv2OQzU8xznabhDywzd6Ppp25BdplySqFl3dfi+TTkXjkrrKdSYd79iVx?=
 =?us-ascii?Q?5b0rvpxns2RZUzPvLjDezNPJhbSkbKyzX0YOI45kODO+brD8blmvRAdBQMIY?=
 =?us-ascii?Q?VXBFN0Fhdrf2ftw0pkHlMKzMPl23ak2N4o8KFqGOxqQqH3qKnSEsyRZRZM8B?=
 =?us-ascii?Q?bIYXrbJeMfKQMI5+9kHGA1hPVc17lgWsPZzZrI0PYkgoKsXUa6JUFfmxPbSf?=
 =?us-ascii?Q?XAX3k3tIvdr0Zbhv4h+moRM48Uo9182qkuKZZLABavAJQr6589T0afCcF0Fu?=
 =?us-ascii?Q?CiNu2XiC/vp1IZu6GjBk3aGMwtCLjjaZcvi75rez38yGjcmvErm8dmE9zJRm?=
 =?us-ascii?Q?rNHZBqECfSt9OY28W3hb7cmfzdNwybq1ys+D4WTt6QDU1QpVn9WBtM7JPfH4?=
 =?us-ascii?Q?/jhTmCwyUKKz0LHSIplEfgRobD0xqK8Utf3O45o1qsRC5dbH1I4eR2gaI0Lq?=
 =?us-ascii?Q?QrcoXInQ1Oy49JQUaWyWdAI1sbWsdOVD45jRyS+qfdO74rQeMBrnWfKYweiW?=
 =?us-ascii?Q?TFtFiwrRKduKF+l4ZzaO2zXXz1fffBM6Uq9os2h26E3IdJQmTPOV/c9/HHl5?=
 =?us-ascii?Q?2SizmJs7cPUULiSBKYn81mTxJEiiVF2q89hJZu5TSlzn3AhkfEiKyafqqDd2?=
 =?us-ascii?Q?3BlmPny4B6fVg2/ho0rsY1gt52x7c2o7X5J5U7lgESevvRshEKZS8i8w13Vb?=
 =?us-ascii?Q?JJ9anIeRL7OjhnUfhWqXs+LuF2ym9ixC7sn1K3IEfbBf8KahBWLGMCwuURZw?=
 =?us-ascii?Q?rd6yt/zcvQBir/Q+PgzYJeRo/wW0jMPWSyKOrtvbG50ZQSzLRFvic5LOrahg?=
 =?us-ascii?Q?xZRNCECrJtejTGwrvFeMwe1LAc/2I6OKeYiD7j6EF/z8UBDWrQxi9g/8eSne?=
 =?us-ascii?Q?i7jJTloXfEzDwY+QIr0ZFDHUQ9YBNGyJYfWITwcr4TxpJecyaw102rAEw0D6?=
 =?us-ascii?Q?XUOlyNCmss9SxvCfuCkZIlx5NkhUtc0pLKKRLu1U7PkBJxjOdC0ZLsyjh/s0?=
 =?us-ascii?Q?dUJYuikEfayFMc65u9UMMnUCX39SEJ8sq8nqZkshuu9Wv8wjPp8A4KOCSiew?=
 =?us-ascii?Q?CBlyAifPAeaqAKpYym8P2E9EOqIpi3qFLTZMvOyAZNGVKDNIJWOSdq09vqJZ?=
 =?us-ascii?Q?ORvMt9wcNoT3pVzk7HYGA6D0Lo1aFcsoDW+G+nk9fAppCN90C034Pvxsy3aP?=
 =?us-ascii?Q?6NnmkPCGFH1rAV8yqCwlZ159ew8E9z2K8PUBZEdDQHldc2vyKaC+qtaGBlxI?=
 =?us-ascii?Q?u1AVZnTKrx/9YKFDPLD7qcUvPZZYCkr0g6oXT9VHEjXr005c91xSYIYMkdhV?=
 =?us-ascii?Q?lLP77q8Ts5WJbk1y6PtnetJPg3JxVMaDa0c0nBSkbem5nUcEXZn9Fs7g9Dm+?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3276a6a0-f30c-4411-0606-08db6c58d4df
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 21:54:58.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L1PveayoQ9xncYi+CwnN8vMVyHlranSs8GJ/KYw/QBA5kr//gt/yyMaCiyzax6vZwt97CNID3bo7QrvRemYvrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I'd like to make netdevsim offload tc-taprio, but currently, this Qdisc
emits a ETHTOOL_GET_TS_INFO call to the driver to make sure that it has
a PTP clock, so that it is reasonably capable of offloading the schedule.
Needless to say, netdevsim doesn't have a PTP clock, so that's something
to think about.

It wouldn't be that hard to create an object which emulates PTP clock
operations on top of the unadjustable CLOCK_MONOTONIC_RAW plus a
software-controlled time domain via a timecounter/cyclecounter and then
link that PHC to the netdevsim device, so this is what is done here.

The scope of the mock-up PHC driver seems to be in drivers/ptp/, since
it is in principle reusable by other virtual network devices as well,
such as veth, and those could even take packet timestamps when passing
skbs between peers (the same timestamp is given as TX timestamp to one
peer, and as RX timestamp to the other, resulting in a zero-delay link).
Nonetheless, netdevsim doesn't support packet RX/TX (and taprio doesn't
need packet timestamping), so for now, the mock-up PHC driver doesn't
support packet timestamping either.

The driver is fully functional for its intended purpose, and it
successfully passes the PTP selftests.

$ echo "1 1 8" > /sys/bus/netdevsim/new_device
$ ethtool -T eni1np1
Time stamping parameters for eni1np1:
Capabilities:
PTP Hardware Clock: 2
Hardware Transmit Timestamp Modes: none
Hardware Receive Filter Modes: none
$ cd tools/testing/selftests/ptp/
$ ./phc.sh /dev/ptp2
TEST: settime                                                       [ OK ]
TEST: adjtime                                                       [ OK ]
TEST: adjfreq                                                       [ OK ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/Kconfig               |   1 +
 drivers/net/netdevsim/ethtool.c   |  11 ++
 drivers/net/netdevsim/netdev.c    |  11 +-
 drivers/net/netdevsim/netdevsim.h |   2 +
 drivers/ptp/Kconfig               |  11 ++
 drivers/ptp/Makefile              |   1 +
 drivers/ptp/ptp_mock.c            | 175 ++++++++++++++++++++++++++++++
 include/linux/ptp_mock.h          |  38 +++++++
 8 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ptp/ptp_mock.c
 create mode 100644 include/linux/ptp_mock.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 368c6f5b327e..4953c1494723 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -592,6 +592,7 @@ config NETDEVSIM
 	depends on INET
 	depends on IPV6 || IPV6=n
 	depends on PSAMPLE || PSAMPLE=n
+	depends on PTP_1588_CLOCK_MOCK || PTP_1588_CLOCK_MOCK=n
 	select NET_DEVLINK
 	help
 	  This driver is a developer testing tool and software model that can
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index ffd9f84b6644..bd546d4d26c6 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -140,6 +140,16 @@ nsim_set_fecparam(struct net_device *dev, struct ethtool_fecparam *fecparam)
 	return 0;
 }
 
+static int nsim_get_ts_info(struct net_device *dev,
+			    struct ethtool_ts_info *info)
+{
+	struct netdevsim *ns = netdev_priv(dev);
+
+	info->phc_index = mock_phc_index(ns->phc);
+
+	return 0;
+}
+
 static const struct ethtool_ops nsim_ethtool_ops = {
 	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,
 	.get_pause_stats	        = nsim_get_pause_stats,
@@ -153,6 +163,7 @@ static const struct ethtool_ops nsim_ethtool_ops = {
 	.set_channels			= nsim_set_channels,
 	.get_fecparam			= nsim_get_fecparam,
 	.set_fecparam			= nsim_set_fecparam,
+	.get_ts_info			= nsim_get_ts_info,
 };
 
 static void nsim_ethtool_ring_init(struct netdevsim *ns)
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 35fa1ca98671..58cd51de5b79 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -291,13 +291,19 @@ static void nsim_setup(struct net_device *dev)
 
 static int nsim_init_netdevsim(struct netdevsim *ns)
 {
+	struct mock_phc *phc;
 	int err;
 
+	phc = mock_phc_create(&ns->nsim_bus_dev->dev);
+	if (IS_ERR(phc))
+		return PTR_ERR(phc);
+
+	ns->phc = phc;
 	ns->netdev->netdev_ops = &nsim_netdev_ops;
 
 	err = nsim_udp_tunnels_info_create(ns->nsim_dev, ns->netdev);
 	if (err)
-		return err;
+		goto err_phc_destroy;
 
 	rtnl_lock();
 	err = nsim_bpf_init(ns);
@@ -318,6 +324,8 @@ static int nsim_init_netdevsim(struct netdevsim *ns)
 err_utn_destroy:
 	rtnl_unlock();
 	nsim_udp_tunnels_info_destroy(ns->netdev);
+err_phc_destroy:
+	mock_phc_destroy(ns->phc);
 	return err;
 }
 
@@ -380,6 +388,7 @@ void nsim_destroy(struct netdevsim *ns)
 	rtnl_unlock();
 	if (nsim_dev_port_is_pf(ns->nsim_dev_port))
 		nsim_udp_tunnels_info_destroy(dev);
+	mock_phc_destroy(ns->phc);
 	free_netdev(dev);
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7d8ed8d8df5c..59526420c78e 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/ptp_mock.h>
 #include <linux/u64_stats_sync.h>
 #include <net/devlink.h>
 #include <net/udp_tunnel.h>
@@ -73,6 +74,7 @@ struct netdevsim {
 	struct net_device *netdev;
 	struct nsim_dev *nsim_dev;
 	struct nsim_dev_port *nsim_dev_port;
+	struct mock_phc *phc;
 
 	u64 tx_packets;
 	u64 tx_bytes;
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 32dff1b4f891..ed9d97a032f1 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -155,6 +155,17 @@ config PTP_1588_CLOCK_IDTCM
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_clockmatrix.
 
+config PTP_1588_CLOCK_MOCK
+	tristate "Mock-up PTP clock"
+	depends on PTP_1588_CLOCK
+	help
+	  This driver offers a set of PTP clock manipulation operations over
+	  the system monotonic time. It can be used by virtual network device
+	  drivers to emulate PTP capabilities.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_mock.
+
 config PTP_1588_CLOCK_VMW
 	tristate "VMware virtual PTP clock"
 	depends on ACPI && HYPERVISOR_GUEST && X86
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
index 553f18bf3c83..dea0cebd2303 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -16,6 +16,7 @@ ptp-qoriq-y				+= ptp_qoriq.o
 ptp-qoriq-$(CONFIG_DEBUG_FS)		+= ptp_qoriq_debugfs.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDTCM)	+= ptp_clockmatrix.o
 obj-$(CONFIG_PTP_1588_CLOCK_IDT82P33)	+= ptp_idt82p33.o
+obj-$(CONFIG_PTP_1588_CLOCK_MOCK)	+= ptp_mock.o
 obj-$(CONFIG_PTP_1588_CLOCK_VMW)	+= ptp_vmw.o
 obj-$(CONFIG_PTP_1588_CLOCK_OCP)	+= ptp_ocp.o
 obj-$(CONFIG_PTP_DFL_TOD)		+= ptp_dfl_tod.o
diff --git a/drivers/ptp/ptp_mock.c b/drivers/ptp/ptp_mock.c
new file mode 100644
index 000000000000..e09e6009c4f7
--- /dev/null
+++ b/drivers/ptp/ptp_mock.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2023 NXP
+ *
+ * Mock-up PTP Hardware Clock driver for virtual network devices
+ *
+ * Create a PTP clock which offers PTP time manipulation operations
+ * using a timecounter/cyclecounter on top of CLOCK_MONOTONIC_RAW.
+ */
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/ptp_mock.h>
+#include <linux/timecounter.h>
+
+/* Clamp scaled_ppm between -2,097,152,000 and 2,097,152,000,
+ * and thus "adj" between -68,719,476 and 68,719,476
+ */
+#define MOCK_PHC_MAX_ADJ_PPB		32000000
+/* Timestamps from ktime_get_raw() have 1 ns resolution, so the scale factor
+ * (MULT >> SHIFT) needs to be 1. Pick SHIFT as 31 bits, which translates
+ * MULT(freq 0) into 0x80000000.
+ */
+#define MOCK_PHC_CC_SHIFT		31
+#define MOCK_PHC_CC_MULT		(1 << MOCK_PHC_CC_SHIFT)
+#define MOCK_PHC_FADJ_SHIFT		9
+#define MOCK_PHC_FADJ_DENOMINATOR	15625ULL
+
+/* The largest cycle_delta that timecounter_read_delta() can handle without a
+ * 64-bit overflow during the multiplication with cc->mult, given the max "adj"
+ * we permit, is ~8.3 seconds. Make sure readouts are more frequent than that.
+ */
+#define MOCK_PHC_REFRESH_INTERVAL	(HZ * 5)
+
+#define info_to_phc(d) container_of((d), struct mock_phc, info)
+
+struct mock_phc {
+	struct ptp_clock_info info;
+	struct ptp_clock *clock;
+	struct timecounter tc;
+	struct cyclecounter cc;
+	spinlock_t lock;
+};
+
+static u64 mock_phc_cc_read(const struct cyclecounter *cc)
+{
+	return ktime_to_ns(ktime_get_raw());
+}
+
+static int mock_phc_adjfine(struct ptp_clock_info *info, long scaled_ppm)
+{
+	struct mock_phc *phc = info_to_phc(info);
+	s64 adj;
+
+	adj = (s64)scaled_ppm << MOCK_PHC_FADJ_SHIFT;
+	adj = div_s64(adj, MOCK_PHC_FADJ_DENOMINATOR);
+
+	spin_lock(&phc->lock);
+	timecounter_read(&phc->tc);
+	phc->cc.mult = MOCK_PHC_CC_MULT + adj;
+	spin_unlock(&phc->lock);
+
+	return 0;
+}
+
+static int mock_phc_adjtime(struct ptp_clock_info *info, s64 delta)
+{
+	struct mock_phc *phc = info_to_phc(info);
+
+	spin_lock(&phc->lock);
+	timecounter_adjtime(&phc->tc, delta);
+	spin_unlock(&phc->lock);
+
+	return 0;
+}
+
+static int mock_phc_settime64(struct ptp_clock_info *info,
+			      const struct timespec64 *ts)
+{
+	struct mock_phc *phc = info_to_phc(info);
+	u64 ns = timespec64_to_ns(ts);
+
+	spin_lock(&phc->lock);
+	timecounter_init(&phc->tc, &phc->cc, ns);
+	spin_unlock(&phc->lock);
+
+	return 0;
+}
+
+static int mock_phc_gettime64(struct ptp_clock_info *info, struct timespec64 *ts)
+{
+	struct mock_phc *phc = info_to_phc(info);
+	u64 ns;
+
+	spin_lock(&phc->lock);
+	ns = timecounter_read(&phc->tc);
+	spin_unlock(&phc->lock);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
+static long mock_phc_refresh(struct ptp_clock_info *info)
+{
+	struct timespec64 ts;
+
+	mock_phc_gettime64(info, &ts);
+
+	return MOCK_PHC_REFRESH_INTERVAL;
+}
+
+int mock_phc_index(struct mock_phc *phc)
+{
+	if (!phc)
+		return -1;
+
+	return ptp_clock_index(phc->clock);
+}
+
+struct mock_phc *mock_phc_create(struct device *dev)
+{
+	struct mock_phc *phc;
+	int err;
+
+	phc = kzalloc(sizeof(*phc), GFP_KERNEL);
+	if (!phc) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	phc->info = (struct ptp_clock_info) {
+		.owner		= THIS_MODULE,
+		.name		= "Mock-up PTP clock",
+		.max_adj	= MOCK_PHC_MAX_ADJ_PPB,
+		.adjfine	= mock_phc_adjfine,
+		.adjtime	= mock_phc_adjtime,
+		.gettime64	= mock_phc_gettime64,
+		.settime64	= mock_phc_settime64,
+		.do_aux_work	= mock_phc_refresh,
+	};
+
+	phc->cc = (struct cyclecounter) {
+		.read	= mock_phc_cc_read,
+		.mask	= CYCLECOUNTER_MASK(64),
+		.mult	= MOCK_PHC_CC_MULT,
+		.shift	= MOCK_PHC_CC_SHIFT,
+	};
+
+	spin_lock_init(&phc->lock);
+	timecounter_init(&phc->tc, &phc->cc, 0);
+
+	phc->clock = ptp_clock_register(&phc->info, dev);
+	if (IS_ERR_OR_NULL(phc->clock)) {
+		err = PTR_ERR_OR_ZERO(phc->clock);
+		goto out_free_phc;
+	}
+
+	ptp_schedule_worker(phc->clock, MOCK_PHC_REFRESH_INTERVAL);
+
+	return phc;
+
+out_free_phc:
+	kfree(phc);
+out:
+	return ERR_PTR(err);
+}
+
+void mock_phc_destroy(struct mock_phc *phc)
+{
+	if (!phc)
+		return;
+
+	ptp_clock_unregister(phc->clock);
+	kfree(phc);
+}
diff --git a/include/linux/ptp_mock.h b/include/linux/ptp_mock.h
new file mode 100644
index 000000000000..72eb401034d9
--- /dev/null
+++ b/include/linux/ptp_mock.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Mock-up PTP Hardware Clock driver for virtual network devices
+ *
+ * Copyright 2023 NXP
+ */
+
+#ifndef _PTP_MOCK_H_
+#define _PTP_MOCK_H_
+
+struct device;
+struct mock_phc;
+
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_MOCK)
+
+struct mock_phc *mock_phc_create(struct device *dev);
+void mock_phc_destroy(struct mock_phc *phc);
+int mock_phc_index(struct mock_phc *phc);
+
+#else
+
+static inline struct mock_phc *mock_phc_create(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void mock_phc_destroy(struct mock_phc *phc)
+{
+}
+
+static inline int mock_phc_index(struct mock_phc *phc)
+{
+	return -1;
+}
+
+#endif
+
+#endif /* _PTP_MOCK_H_ */
-- 
2.34.1


