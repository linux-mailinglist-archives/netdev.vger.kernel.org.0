Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C114367CB5A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbjAZMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236434AbjAZMyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:05 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2059.outbound.protection.outlook.com [40.107.241.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87FC6DB14
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaIQe9Pr418qLIxHDaaLcevgKjX1pspSYMuvjYDs9q98jx6ccD9AkDBm9Ga1tP4Oh5wTnmuDpKG5J+8f5Wvq+j8g7fWUgimJ4vWNWLDIqT9Z4GL7a2EOYp43tRlqENXYw54hc9mUQE21wjxXQuCNHbrNn7uOY8xiIlqvjJBAEMOtzIYTqnpKtrS0n/YxFkuUwvaVOTx59AB1TvFZkHt+vzh0M3OxArUACMULgJLtxH5yRhwnAiduxsijTs8XHWEIUH6kLwd8gk/TYwIbShTr0JuALJPw7ZP3jVo7wToy4Cy2yZF/yTPl12e/65+T5xZSb0ypJmVJcCnAh7gg1KnUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZ/ulVWNB6k8gUGwNBjka/zTSLrqvlpzqKvFcFmUuHQ=;
 b=EpiR8zLICHz626ApEmlCEmV31FLBSyhpEaCoZcQCA9KrgZKAjrxnXN93PBug05lqT1SejLQbLR0scy3aHiSpGIu3mPRc0X1wREuLUHISG9uj59UiZJcjpqVQ8flKtwDDgZIFwBTf3Dn6WfHU19tQel99gObcldUjmcM2z9EvEk0WkTicL/ablO8p5ZrLitM8mNARq6FD2GgnXizXj7QcDOPCnAMQPiEL7wWaWibtQv2ZSNrGQN8oeYiSsGhteXu3WecbR63yT1XS/aKDJbyk9n68q4n4UQNQK/pgX2kzg9vCP8Q0/IsL47s8mzS3CNTypNyYs+kte8jyPm0kHiU0JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZ/ulVWNB6k8gUGwNBjka/zTSLrqvlpzqKvFcFmUuHQ=;
 b=s5IXt0DUqB4dGxFEbzWtGMpjoYxd2HaAVYDVHOLEAvbU0RIwAZIKpLvQMKoe4+dvbsm9On7KSSo01Qp4cDY/qvIF70iY+69a+yP2yRlAItxs7yl/r0ekm2AxeiMHBvjoUweQk/1HWi4oUieRGzcwLiTCNphSJ64RWxXOxJFdGDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 10/15] net: enetc: request mqprio to validate the queue counts
Date:   Thu, 26 Jan 2023 14:53:03 +0200
Message-Id: <20230126125308.1199404-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 74ac7b92-1c7f-436d-92b2-08daff9c5be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlU4Jp890yC0ac3xC1FbBWv8iClOd2ktjzOYUtNmBGopzVHiBwR2PKZ0wJmR3U+p+mUQ+NEpTG4S+7X5mnSF/zOD3Kybhg+O27o1gO9WIcgZOc5Dc3yCE1ZAJB+ldkAjM6oQJ6TZm18KvpOJbvDzdA/375zld1kq1uzrN5EpUyxcGSq9FlJdcBE7DMcuNnEeOFLa0pQDE5E/DhNLliHxYRmrST18Joz3QU7tG+jEeFsoFdWKenPQqfkLJeBF0p2A9g5oz4JYG60Ji3NNACjWmgybhalT9LhqFcnCvqQZR7jV5jmKyyUfQh0DH0XSWVSesvw36hLFtHsUzuEtR8YD5RdBTaXRFb8WCPVrTH4XZiKfgzjppAjgMwuQ4i1QGzoRM7uVjH0D5jbGTVSBzpINfGrhtedhI+5Sj0TVf6dEF4yjghAaeAx/jWk/iXn0XtHWckvKzdf3Xn2dd7iStzPH6oLW4qv0LKeQozGmfRAKmxGaliDEc+7Obrv36fUaIJ6ofu9g0vaCeFQQUoFU8PJN2bXWytcX8lJ2TDXE0qYfinJmxtmCldhdBS8IkU6DZ6wCPFeKA3/ukArPEvFy0rlR5LsN+XS/asojW3gtzXXyFJce5MFyqsaM874GK7N6f5RpGucxzVp7FwRoNkF3gKNcdtYKBiGPP/yy0OjTN2zvmlm4LB+/sPg8fbcpLWaImPNyaPF4/j4y90oUsCAIzLqmAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(15650500001)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LGbn7YXNa1WhNemn6fevm3uI+SM+FOWYL6Q4wuNbmac3VFspscWrAatbMfmA?=
 =?us-ascii?Q?2Jg18AojgrJpJbYknQupGNLSn7PGWjrTZNqysxE431OgDXx/faBKqFuhPFUh?=
 =?us-ascii?Q?fgr+Oe2edFw0iLTcbOEANtVUoMPmEbmgvWLNDSFb99RW9wauPs0d+Jwdj4QE?=
 =?us-ascii?Q?/6rhmeoIogWT/e0vmOtgWQvEL9pD4Uv47tf2Sr1DJiCqzT2WzF0gFFbWFGTr?=
 =?us-ascii?Q?ObUAS31blWQKBakFlE8KR8PBChoROk7TMh5UM7rz7t90nouriPFy3iwlzZfs?=
 =?us-ascii?Q?pEanMDuXF4dSweQjGcAoTpix9G5nU435N3hJ1bbUf/qX7Mn+EgSg3Gyw9BAD?=
 =?us-ascii?Q?b0jNoa2E18ei1a19V/fCImnYozbQkhr6WznGc5oLV6yL87AY2r8Rvrf0aMq7?=
 =?us-ascii?Q?UjukX1axJkJzvPwc9qx0vTdjW15yoDKSUFn8gQoPIxmDF2MgU+qim0+IknVF?=
 =?us-ascii?Q?bMs7eKzDcxGNKpPVcXC0ilGTL2osxXBQgJ6fxTVALxcEC/+jcwE8b175SvVn?=
 =?us-ascii?Q?jqF6KAc1w2zbW7wa8Jn298PFw8wZ7m2EDTCuTTr2SGL1whfgI2caUUev5Vty?=
 =?us-ascii?Q?5Jmy6qVET3JxLUVmuU/Sz7lB+LkzFh21uY2AMzKEUKEagzWpu6uZXx51Yhlb?=
 =?us-ascii?Q?/CseygHq/chkQjt47gnGBO8Wcr0a6w4WFVIrvAVoOk4t24nPdP1nZi1PLPrf?=
 =?us-ascii?Q?Rx9PVqav8r+RNZWpEi3k+RKxgzUwVZqyOiHF/PL87DAyFLxqhqqdJ6rNAzut?=
 =?us-ascii?Q?tUQjQu1jl6dcNALrMQumBYRW6EIRdOBu/xbcf9GpOhmEnLDd/Ec9HEw2RN/J?=
 =?us-ascii?Q?Y60mqUzApiWXdoWgX710VKf0CS87codVsXX1/mCDaZdN80le9QMKB+Q9KRoo?=
 =?us-ascii?Q?hU1kMpy9bImMe91OGc7AHQDPdTbjKzfcLlrkxMY6sXD+bv7C0z9NY/rFkhyG?=
 =?us-ascii?Q?nKnu40du9C8Y2yYoFEMcVM0OivtrNg85+x+/1+EVyKxJbagd/isqx4FbGpMN?=
 =?us-ascii?Q?EgaSLauxEwiTbjK+wOEljCFRG/DTU/wfiusGgn1UkE1uTBpQNE/mTOS+r5xf?=
 =?us-ascii?Q?ic9Yn8r6p7IobqPJ9U1ZSRpVblE7lmktBmNr1kQT+i/LScORGcMmcDDJxPfy?=
 =?us-ascii?Q?ihcnRCyqqk3vPKA+9Q//4qbO89xvzI73jdw4fraturvgJxPtBhre0ZWgtBEv?=
 =?us-ascii?Q?Cz2zjGHjysXfmHde89x8wB01TYCujgd6HmV+jlLBgyNV58cpI0daQodd0/LA?=
 =?us-ascii?Q?TcJGMwrWAHxKlZSy97ip+hC1ajp52JfO9gTxK2dDDa8o8q6d5F7MLfolgn4K?=
 =?us-ascii?Q?tm+43H1gfGPTl3G8cVf+6NBuxobv5+grREuKs/qidv2C9/auVkojGTfduvVW?=
 =?us-ascii?Q?GACH7O/0dD9FYZELInP7XemYBP6GxxjaAaWgC8EPP9Oa5pMSqXxVe+5/y6OR?=
 =?us-ascii?Q?r8GG6HSer8PK6lgdtUAgIcKmNKGl5gcr7We6y+CM8DqJo92pxT3vFJOIQPcG?=
 =?us-ascii?Q?tamlhk5qyMepFwS7XXByx3wkociiHbPEhRBSqTel7ULPgSSkBoPYqzY9gzhN?=
 =?us-ascii?Q?QxIS2YjSZ8KU9JymxBZ6Ty7ZzJaRQkSb9+g+kQ87AqM5yNgUMpwznmjU2ptD?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ac7b92-1c7f-436d-92b2-08daff9c5be1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:45.0024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uy2mXwp6pOfF4PlIB4AF60xKThW/+8aG7EeZ81eXkNmCi9IZU1qhdOG4YTJKwHxuWrMbzdNHJ/V1cvwsjLiODg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enetc driver does not validate the mqprio queue configuration, so it
currently allows things like this:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1

By requesting validation via the mqprio capability structure, this is no
longer allowed, and needs no custom code in the driver.

The check that num_tc <= real_num_tx_queues also becomes superfluous and
can be dropped, because mqprio_validate_queue_counts() validates that no
TXQ range exceeds real_num_tx_queues. That is a stronger check, because
there is at least 1 TXQ per TC, so there are at least as many TXQs as TCs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v2: move the deletion of the num_tc check to this patch, and add an
        explanation for it

 drivers/net/ethernet/freescale/enetc/enetc.c     | 7 -------
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 1c0aeaa13cde..e4718b50cf31 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2638,13 +2638,6 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return 0;
 	}
 
-	/* Check if we have enough BD rings available to accommodate all TCs */
-	if (num_tc > num_stack_tx_queues) {
-		netdev_err(ndev, "Max %d traffic classes supported\n",
-			   priv->num_tx_rings);
-		return -EINVAL;
-	}
-
 	/* For the moment, we use only one BD ring per TC.
 	 *
 	 * Configure num_tc BD rings with increasing priorities.
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index fcebb54224c0..6e0b4dd91509 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1611,6 +1611,13 @@ int enetc_qos_query_caps(struct net_device *ndev, void *type_data)
 	struct enetc_si *si = priv->si;
 
 	switch (base->type) {
+	case TC_SETUP_QDISC_MQPRIO: {
+		struct tc_mqprio_caps *caps = base->caps;
+
+		caps->validate_queue_counts = true;
+
+		return 0;
+	}
 	case TC_SETUP_QDISC_TAPRIO: {
 		struct tc_taprio_caps *caps = base->caps;
 
-- 
2.34.1

