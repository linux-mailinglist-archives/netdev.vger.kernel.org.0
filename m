Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A706817A6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbjA3Rcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbjA3Rcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:35 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2066.outbound.protection.outlook.com [40.107.21.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7F344BC9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiqGKLhtjAmM9ewvca7C9o9MqHbgbgSksplmS73d5+nUmQdj8Cv5L3kRGru0LyzXj2GNU0ie0T1RzbxE+W+Duy/OxQ0FD5ABD1q2kSbACDWPwY+FxNjLdbtvPRIGJTSH5A9VivVc1wq2WrJuL5cpAEYuwLNu/dSC2b2HikM+Yr72AXqJ2Lo4xsmKNSxJzaPCKPDphkBNXyZH0vTKdariTeo1LQV1EnG8NIOE1aU86WSjnOC4wP1L3IIbB6quqmxWvyZrR3bMaDpBmZyj5ZMB6s9IcmQppCVNf1ifXinKTKVNwBlVOQE+IpC4hqKvuRH7NyDMf7pGTcjJ+1rMdd9ZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xvl6BY60vanE5T1YCmT0ozsmm6s80ixjIQphDZLf9OQ=;
 b=Si5n/2xZGJCb6O/SlUuiRV3kBwc9+85zaLdkIJtjGfkvnxNFi4OtvnrC4VMOSHAH/pQY7+qaGm3uVfJQOHSX9ZJtFbrKtmjssA+UVGtY6hksIhY2Yu+AH7jomxu/XDOT+MXp6Z4ty/zhg+66objfDzwXjhMaLcEjRgXYw/BFcpUcAtyMphmXQg05WPFzDIPez06nmMbxBu/jas9q3OXX77g/YT2gbhy1uohAXpsSXEQyYpQDCqeLlZnCwOHDp/vfZu8BsJkgmYuAyLHSPovr03r/DTsZ8oRyRZShtrtetLJDQBRslDx1XTcj3zWSfonzDMIv9Rv9M/Acx2KYzFP//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvl6BY60vanE5T1YCmT0ozsmm6s80ixjIQphDZLf9OQ=;
 b=J7B74bd2n+vY+bgyO751Jkqn4b0nT3qlAzUi78w2nsgA2u6SwMwbYP8psjPLdfjFRO3/4uIuHAdXkJ90j9wLw1SHzcEEWd3TKwBPjGI7FEwm7QCPtKmKIMQiiCDdFxKtcInGldB0mOTxiHFoDO+DmL1GHPJ53PCrhhMO/6VAh5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:11 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 04/15] net: enetc: ensure we always have a minimum number of TXQs for stack
Date:   Mon, 30 Jan 2023 19:31:34 +0200
Message-Id: <20230130173145.475943-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: ff448e0c-a7de-4fbb-9b87-08db02e7eb92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQfeICkx7t2DrFTclElHft5GlMTS/m4o3kZEtMvBFlvFQTD+Dz+FXS/qL+gqwxFkvTQEGSuciC73TCnmuCSyxGrbb9lyd0rflbHo/RXnEoKUV+AM+Pz4mRgCHdeXB+ly+0NhV4vAu6AMOFIqzbD64jxercvWC/dkB5Du6/rJddYCQ+HNl33YuoAYdPWQUtHZ1cFq/7QcE+lgU+bCzvsUsxB8oIE477ujCt5s5jdst+yf1YyAKkINjNJlemDQQOlVkHFnnWw0U1RFZDxySY1hzDBToa+fTBPom43Lb8EwRbytwusF9sQvRb3XUsJz2GJCVqDVjSrcTXPIC7eGlRJ18F6WWSTytfWtAAJ0vbh4zfLxVjYVvQuBJQZfxLdmIHgMvxLzN63VySejmB0/UOsvYwizqLi02d3s/k8VsV+Hd1fEgjr5GqzlvzEoZR/q3nhyZl5PZ5VoL+8Qof9PxOmkJeyyMq4UTUljJV6mU7sSDW8M49gKeLstoXWXcyheym+n7nICNe0j6bh1fairyNf/jh4Jq+uWV3aLiO/6TgWqW237oFw9W71cECVeQKBe5tg9rffhn+9Y8juy8pV3XxEJLyDxqIacr5c/mi0+J1mzjh8Vwc3RpbcfAdED0EbUG0Ee/SKA+7efbIH0Hb/YMpwI8LqZ1Gtm7RI0vN0xwVq7FioQQDfET3yeQQDVLeTAb1kCofkmHN1EWXD6G2O02EPhaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXNUHpc+4NP/f+/pyI+Lef+OTAeo0UEhg5d0kYSYcUWb4bjKPY2vvvY6YkNV?=
 =?us-ascii?Q?ZUw/GpUmFyurVBXXXIJF5vCxXF0zCF2yqrM9oeo0gaGcWdaAeCLYZ5AKBjlj?=
 =?us-ascii?Q?AV5A5mPOmuSDl27WlYUdP/V3wL2ZbwGGSNochU0s0xO+1Y+Z1fbtqu3v9Gia?=
 =?us-ascii?Q?43jGb48XmcXlchoUxy1JrvHiHNgPYDXsppxUFmjPDayZosfP1Vpm7EB3XEo7?=
 =?us-ascii?Q?AWcZn/+ykrlQbWMkdTulB+bkNnWRBStBw1qOwoxmb7FHTwTtumcGezxXI2VI?=
 =?us-ascii?Q?OfnHEneVxmDLohVu2O/pFPfYGJvvI+jrCf6FCLQwYvwVX5HhL3nnuVqoIspZ?=
 =?us-ascii?Q?Ik6IP78PfUWB5EPS8IOk06lU8gRi+B1l8CljDZwsHGkDqd7rf+XPDjuPWWzW?=
 =?us-ascii?Q?lV86pmlMbPyiZge4q+uDzvMbxeJvRLCYtx14odK3LaBBmV8pa4cx93LoMyUC?=
 =?us-ascii?Q?voxXhdU0znRFRKcXRXWGJd9ag52s4lfrIFbYd15ABEVRzYP1FNKQU7zRi9xe?=
 =?us-ascii?Q?jdwD6huHpOBsoqPdDfGkuUSypB4canb50Aus2V7Hly0DP7gIkPmLCQ87sVa9?=
 =?us-ascii?Q?FKihbhfqQ8Nkgxxi1lBVOiGKISK1sdohA0LS9hL40wnoO/24pdZ3/ITDt0qY?=
 =?us-ascii?Q?4Kqc7r2Bu43iOGys6WQ6MKhHaWmv/iyuFfYzUMfZftw8UB4wvvrb6SwoteF6?=
 =?us-ascii?Q?dKoFR2+eFgaLu8cG12RbMOjF7mx0i5rTO4PiThzZCNb1oO4o6tIIRTLbKca2?=
 =?us-ascii?Q?Gyn3XVR7UCROTEzGTutBMnQOOz2NB12QoV1hg9pCTaaP4IN+GZW9Oq7/uCZI?=
 =?us-ascii?Q?3h3JxVDysv9Q2S7BnBghlGwJlUnsk34/J5TLANhbxkFVAfyzw27uf+Se1a6i?=
 =?us-ascii?Q?vf7umkUnhKVso8XSZmqkeQbjx6TKuIH22ggDEtpuJnPFvqmGvwRCIU5O9yMf?=
 =?us-ascii?Q?bcz8xUaBVkkv3fWf25AsD9wV/5pV7+vJ2y2Zm/7vCod/EDI2CUbUqOKGBtsc?=
 =?us-ascii?Q?+Sw0kuC86TcmbKiWnuWpgQuF4eOU07Abmx9XX/ok+q5tMQpK4E28N90M6S8M?=
 =?us-ascii?Q?ecRQx11SZaPeXfNNOy3QzvcvTayBi69cGDZJt51Lk/Vkz1dxn++a6c0e/EbQ?=
 =?us-ascii?Q?4sbiqTvjsAIXAUfMZZML9yEz0LcESV5S0IrJRP8+G/u+WkGM8hDSVuMPelKl?=
 =?us-ascii?Q?fCod4E5yulQ3GePSd2NFnBZz6lSCMPrpLZNEYim789w69EW8CS/gxHb4GpaY?=
 =?us-ascii?Q?aa7Ov2h15Ay8KnlP2yOZ7mayzwRBN22pP3/k7k4HKFWq1mHX+FWXyOo0lEw3?=
 =?us-ascii?Q?Ylnfiba993Ucpq/eny3TXcAl2CVibYtNIjCIPBfT7Fu+qvCT3MQ41wWKTpsq?=
 =?us-ascii?Q?Wfso3iBC7VOijA7uEVSwhQAKGok2A9bJCvNNo9UnCoMrQcmK3CfmP0h9Xrvz?=
 =?us-ascii?Q?r89LgbGn6bQftdU+FqIzHDulXvd3MxWscnhe6i9hKxBxs23O6r1s2kU4hdr+?=
 =?us-ascii?Q?KjMjsQ2j/z4352IxrTo9emb23LityV7HHxxvaKqHwvjCXbEo2JiTHBuDV7BY?=
 =?us-ascii?Q?qfkDjNF+P9LV+Z60I0x9lHPc7EAG3Ik7HqMQ0x0Yjw8JJu+wXOhE81d/z+Ic?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff448e0c-a7de-4fbb-9b87-08db02e7eb92
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:11.8667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAh2Dv4r3oUwLNw1IQa4RfW96mxASSEN1OUB0I04eaf6YcrHjVcyreG7Z2+jzgfP9RUElGr8we8se0FM9dQ3lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it can happen that an mqprio qdisc is installed with num_tc 8,
and this will reserve 8 (out of 8) TXQs for the network stack. Then we
can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
mqprio. That's not what the user requested, and we should fail it.

On the other hand, if mqprio isn't requested, we still give the 8 TXQs
to the network stack (with hashing among a single traffic class), but
then, cropping 2 TXQs for XDP is fine, because the user didn't
explicitly ask for any number of TXQs, so no expectations are violated.

Simply put, the logic that mqprio should impose a minimum number of TXQs
for the network never existed. Let's say (more or less arbitrarily) that
without mqprio, the driver expects a minimum number of TXQs equal to the
number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
mqprio gives the minimum required number of TXQs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3: move min_num_stack_tx_queues definition so it doesn't conflict
        with the ethtool mm patches I haven't submitted yet for enetc
        (and also to make use of a 4 byte hole)
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e18a6c834eb4..1c0aeaa13cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2626,6 +2626,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+		priv->min_num_stack_tx_queues = num_possible_cpus();
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2656,6 +2657,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	/* Reset the number of netdev queues based on the TC count */
 	netif_set_real_num_tx_queues(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_tc;
 
 	netdev_set_num_tc(ndev, num_tc);
 
@@ -2702,9 +2704,20 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
+	int num_xdp_tx_queues = prog ? num_possible_cpus() : 0;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	bool extended;
 
+	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
+	    priv->num_tx_rings) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       num_xdp_tx_queues,
+				       priv->min_num_stack_tx_queues,
+				       priv->num_tx_rings);
+		return -EBUSY;
+	}
+
 	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 
 	/* The buffer layout is changing, so we need to drain the old
@@ -2989,6 +3002,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 	if (err)
 		goto fail;
 
+	priv->min_num_stack_tx_queues = num_possible_cpus();
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 1fe8dfd6b6d4..e21d096c5a90 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -369,6 +369,9 @@ struct enetc_ndev_priv {
 
 	struct psfp_cap psfp_cap;
 
+	/* Minimum number of TX queues required by the network stack */
+	unsigned int min_num_stack_tx_queues;
+
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
-- 
2.34.1

