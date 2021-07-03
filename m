Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78053BA89A
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhGCMBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:19 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230259AbhGCMBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6de2vP6yirytl024TVOVRTiSIripxEEeLveGmdrQX4ikEUKwgEJaZaxhZZGz4P7/kuiJicKYfOoXMhZh4OJp+xqdduzJQI46qQSJKGiqQ75iCsjhnMXUDXK6cQZ48WQniHJXi1WtjC0wdbHyhIwBreIYx3KYfLPhszA95ZVhe6/At7Q5ESCyEyZtbiMeYN6BhsbHO2Qy7jKkLlLsPl7GTsuvdXV8Bcn7YE1ztrrhKRbCPdFW423t59xKN/rX3BWQIyeHbn7N4wE1TkjaMoW83mawHlDDb0f8tskv4XG5zr3pFlhHDt27mGDHrdNRVBbq0e1xJ3PfenhTS1sLrX2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sm1suUrRTUxN1sONyMB0D5Ren6HKrOyLt+PgKB8cvag=;
 b=lRt6TQmNFMa7HgD1PqgFeuR3O+XvRs7r5ziukwRaN6ky2m4S4fBHUdmsrChtCA0QJGZ+VNRGnFFbRfefFAvYtdpkOp24Qnzx4pJJSZ2swtSI3KWVspdD7pC0GmpvhHMk17UUGgaHU5p19bCmk4/YufmAgu4itakbZLUrCEstgkqFWInVHerUNA5M4e9rw8eLeQfR2Bt9+ttgpiHTjK4itz6i7E/xKYaRl2yeMO4+L7Gpbdvv/SAvDy2/PEiDDZ5iWqGTwgrGU+bpo+D4QoGC6YfHk4I2N+WKlp8iUURm0kc0af1wZfDIjLzHVT6A1VIdYCKncM9Rehf2wcEv0AeLkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sm1suUrRTUxN1sONyMB0D5Ren6HKrOyLt+PgKB8cvag=;
 b=ciUe7vBXnBuXNX8XgFbFxdjeVRn5EwFa8aMZ/9nJP5+6PuMWIIreDUbjgB9kC3Rm/5StM0r/Eyb9y97v5uFbR9n9e/DvomSQvqBl9QmH/6KUB+rp0OSEQ34ZSheftnTchmS3DhRMqwN604bH8h41KXAedfDPhuMYh6w/qpMpOYE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:35 +0000
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
Subject: [RFC PATCH v2 net-next 06/10] net: allow ndo_select_queue to go beyond dev->num_real_tx_queues
Date:   Sat,  3 Jul 2021 14:57:01 +0300
Message-Id: <20210703115705.1034112-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 701a467f-8dd5-493b-827b-08d93e19e2b4
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2509597DE85AF96951289FB1E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oqFYBV7Wr43rpuidzpq1oRXOtqlkHEpMt3PRXtGN1VQWZ4Hek4naAPJKQP7yNchoepWZ5mDkVGnaXve8jn6b9oexpO9HZkUFh0npwety7EtpAjs401+Zdand3Hbzifq4ptMSLta3ZGYKf54GsYYzbKRK7bo+YiRR2q02zWNt7nnHC1AZ4LluHBJF0Mo2M+3F71xlNx1KtWIZwNRT5DIvla7GgSoV4tbJHl9sqTJFCmEvOvPPxirvh29mb1oGx3xmpHC/P99vNvS4A6ypirU4W9l8CIe+4LKI2fqV4o9oiyfoGsGBxZiBdZbGF2ZJaX3T8XAdtBnuOfEpi1UeIaC7W8R7VtmoQTA+IYpaVnPSMQoY6vZHph4qZGxrKDKYAVj69hFrShkK08wkVtdaA3cAkmiF9guCIGXvcv7ec7NPAKUmFkrI8iFzJoNp/tmDDGS4fDK/rdxS/VjLKubJAY+/4mpDXGU+axkyLQPdaoRJN1s7fkEb/MePNoxgVb6MeAZMxlNdYSD8p/aJtdjQlr37zFMLXkm+Pa5iPi2tFQWVGnL4PU998ngIy9wxlsBeRHkblGYJT/6yOrUR7MBj4TIFelZknj2SApcYwkRFA0Bs6IaTPY0Vp1D/klTm0L+HZmE76gJ4VW+ObKdoY+PfmUJn6gLfZomM37lEzmjyaHW2ZE1x2hyiwifVAbArpKTcZ4fSMSfhHNlhX0Mk2x+PP0ZINSdTlVqgme3ZyxvTxJggsGWDbAnUtHahuhl30+2YF5td
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1FMVbIKn6hAwdxzHvOOQaRv0zS6rcFdIcyCu3wwWfTtqHofIVCz27/ogizRY?=
 =?us-ascii?Q?m/ivS7fjC1kGaCCG1sFtRGM9mSXbOzsHpN3XJ2j7LiVATizA/hoGnNUFs5gQ?=
 =?us-ascii?Q?wtTamg6XcxVkYmq/+fdwqSN5h/OEZ3lLI71O3su/IGWh16dId8lvDQwlt1WN?=
 =?us-ascii?Q?6paVpi2GbsBOUeLyYxgCBeRK1bsoCO7huGbLV69/JOC8Uur/KaG6hocq1I0H?=
 =?us-ascii?Q?mj/GZKFX49ZhdDtZXQRzsYvjMyRFysU+X3oyMIoXYRzV4nfUxdt9t8aM5hoT?=
 =?us-ascii?Q?6XzvBAjSPkaOZNUer2CFOpZzFNMbjqPXRWcEqqEh2Dm8IHbr3p8XkWWJQ6CU?=
 =?us-ascii?Q?hgBWRO30Wfd1jhaiGlgVGcNqzvPmd47DwB5o2hfJo6+3xrtKKtsHVPqTq+v2?=
 =?us-ascii?Q?rTWg58NEMe1WNGSUgEbFtktGbMQ+Lw/2yicvUWuv7Eilt7RMi24+FhtiYm8h?=
 =?us-ascii?Q?8XJ2BKU+rNCWPAUszfDggO74EMMqdaMJEYQjYXD2kZnmLP9SUQ7/fsHMuljc?=
 =?us-ascii?Q?r4YU1hGda/Okgjekpa0iJbLpLCzr18OgyHDq7iC/5Hki2AWIQfcB5IO8x9ND?=
 =?us-ascii?Q?h6HYFcGPoMuG5apukcvM/jeH9LEdG3PrDcFUgWUfFS9sl6HG1C9qcAylxpNP?=
 =?us-ascii?Q?FpusJPjKTAL4R7168478Nq9N7sE3bUuX3h1MTSP9Y2/GiZcJzq62C7DIPaWm?=
 =?us-ascii?Q?ylBodchc9/sL6YP7p6AhjXrC2dduVHcGF4oaPBE3RHnf7+5gBAyscBEKcPst?=
 =?us-ascii?Q?iIANP4Toz3eYehqcf+sxJey3qk8CD9xLk6bWD2YSdIx5a6Av2TOutxyUB/Br?=
 =?us-ascii?Q?SCY8ak53o16v2vPOA4XsfxaXWimqmsofCzGS/rBPGe0WpbHUFX7yrUeTDEGk?=
 =?us-ascii?Q?6YZUUsdmjgaBe+jha+/4JRZ/dhUejsBnJ4CjVcbGmdtfGwST4JCeRBjVuYsJ?=
 =?us-ascii?Q?toqxFGd1rCHtgEtQpx59QrJi89I4Qn7rc5EPcfQpwIoHKyPg1GFaomwaMgnV?=
 =?us-ascii?Q?rlvFMht1Ctbb/NgH8bFAi92UZZW9jcx7CFG2E2l8cqqGvGdTLjNMau3rMgLU?=
 =?us-ascii?Q?x7LLmIbg2BhYNLkwu34uLh6dRivWV54IwWV5A2Vs/IsrVJ/hU63z6M95nlQi?=
 =?us-ascii?Q?zCHXMB+aAHVocQDVvPkmj6y4iMGiaaLsy/qHMQE2H0NvZA76xQHL+gWAfzEc?=
 =?us-ascii?Q?ikxKXVP4kEvtSqgVc6a2vNjRAd0eX1tCgHU+9ia+DqPpP345hVJb6NtOpYuD?=
 =?us-ascii?Q?pJ9X4Wm72zqJy33vBp5VjfSvOPI4V8UreWvZl1TO+TQHJVvG5NJ7CtULfX36?=
 =?us-ascii?Q?K6DfR7IJ844rRFuljhul8olY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701a467f-8dd5-493b-827b-08d93e19e2b4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:35.0419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CltoVNiseAva5MfMv5GhTTDkoENMfiwV6ou8FLf4097JITjcY7FTkThwV1OlLb1gWuvgcf4IExAPtfml+swQ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using a bridge upper as a subordinate device, switchdev interfaces
must allocate a TX queue for it, in order to have the information needed
in .ndo_start_xmit() whether the skb comes from the bridge or not.

The dedicated TX queue has the ->sb_dev pointer pointing to the bridge
device, and the only assumption that can be made is that any skb on that
queue must be coming from the bridge. So no other skbs can be sent on
that.

The default netdev_pick_tx() -> skb_tx_hash() policy hashes between TX
queues of the same priority.

To make the scheme work, switchdev drivers offloading a bridge need to
implement their own .ndo_select_queue() which selects the dedicated TX
queue for packets coming from the sb_dev, and lets netdev_pick_tx()
choose from the rest of the TX queues for the rest.

The implication is that the dedicated TX queue for the sb_dev must be
outside of the dev->num_real_tx_queues range, because otherwise,
netdev_pick_tx() might choose that TX queue for packets which aren't
actually coming from our sb_dev and therefore the assumption made in the
driver's .ndo_start_xmit() would be wrong.

This patch lifts the restriction in netdev_core_pick_tx() which says
that the dedicated TX queue for the sb_dev cannot be larger than the
num_real_tx_queues. With this, netdev_pick_tx() can safely pick between
the non-dedicated TX queues.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 16c88e416693..d43f6ddd12a1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3697,10 +3697,10 @@ static inline void netdev_reset_queue(struct net_device *dev_queue)
  */
 static inline u16 netdev_cap_txqueue(struct net_device *dev, u16 queue_index)
 {
-	if (unlikely(queue_index >= dev->real_num_tx_queues)) {
-		net_warn_ratelimited("%s selects TX queue %d, but real number of TX queues is %d\n",
+	if (unlikely(queue_index >= dev->num_tx_queues)) {
+		net_warn_ratelimited("%s selects TX queue %d, but number of TX queues is %d\n",
 				     dev->name, queue_index,
-				     dev->real_num_tx_queues);
+				     dev->num_tx_queues);
 		return 0;
 	}
 
-- 
2.25.1

