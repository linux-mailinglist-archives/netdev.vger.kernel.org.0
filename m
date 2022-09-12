Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF825B6111
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiILSfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiILSeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:34:04 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22EB13D3C
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5xyl/49ITiuyMzXxJsFkzGKRVv8dS+n66tpFp0VzqcF6qMF+SupHpSR/og3HDe/wLpqvjna94kPisgogTXA5H3i6h4mg0+vqcL5JZj/QRqyqbY0S10fgkFSJirW03zfVC5Qlp9SakV1VEDX7GvqFTKPaG9SJNWSVZvAmE9i8EkjBaoBfr8Q0zfeb7io/HlyoXIdIp+qhw5XNeLMSA6TPc1Mhd9UuSHy3BtOjzSGTnHpKOfIomoriz5kbbwNP/+gJdAEBz4Ab2+K8HE8vcS/zvWI/47BauJb4K6EcpdNZUfF4QywNuS4ZD2UTeg2iVcN2wkNICczeJfz4F0pEvCSAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTvX0k1E1OYFNl8+3566ymcyyQINpRotYyv32eaaLyE=;
 b=HZOJZ8/7Bmnubk43BEfK4TxtUs7jaLVVOZ39nlmdMGRyBIMqLz0iMWI658COcd8VF/nZZa0/g9wgfbFiOzXKNqXG8HRcFBLW92B8RK6T26B3rvqCkj56ixd6uYD+tgLe62k8+7w7+r2dqtDWHClyzHUjDDaegXqsJHvNEXOU6nBZg4v9cbKe1sX5XPRB9qGjqHEpvW3AYPyfuYLSKF1N0uyfik1BvUAGjBtYHsR3/Cvv3w/ZHyy4l8zTBovxEu10zovLlB33U9sxmKSYFyQ2UewrsOABpxxnloqxuUdLpjttElP2qyC1IgZYEdEZjF3fZdYSmFpi+tAH8PxX38MmXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTvX0k1E1OYFNl8+3566ymcyyQINpRotYyv32eaaLyE=;
 b=M3EDlxOiXe63MS8Lj5nT305XWe+kRDbojYPxhkw6BN66w66PFbirvglWVpQk6/yJZgRNbepa2zxqQDtYJyqYlYAoXhay02S1Vk1tjxAUuhn97cSB4PcGp8MJGNlw9OLG7OxJe0lT+KBmM7uvYc0uGw/+howOhvl3NZWapiArhi0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:29:03 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:29:03 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 07/12] net: dpaa2-eth: use dev_close/open instead of the internal functions
Date:   Mon, 12 Sep 2022 21:28:24 +0300
Message-Id: <20220912182829.160715-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d76e35-4d1c-490e-826b-08da94ecab1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+KW3+ncaunxEY+1PYca0GmUktRLx1ktyxlmxCwCJVuyuJMK7Z4LOkwjTjA5HczeLfX3GvLFbB6IIwGOKtVPagPQc5Ny7bo+13RxfZkAFignS8T6ZPpJqGFImFw+CBLjog04xE4Gqb5GtiaOKqbGw20ujY3Dz4r/34Eo+xhlBP/mE50ZjyRpiZ33wwcQBCCtlv6If63yeO9hmKFLg4f/7uVjZHvBtHIEaqAzQZEXkPkOxQ5cGw2mpxjKWV0TbNfNR8AHo8Yu9OOcHouj4YuOwNPXvbh98E/Q8+kJ0sQ08O9MQh1pX8u0gECcnGxSmXopkQcNs1lHcPnCuole8pNiyugH9POx+Kou8Wz0F1ELNGWFiY1vd5JD9II7If8qQPuvG+49lfFN++yNr+w9qtInnYyYcNlx9yt4VpwB7S9Ts3u+G5OvymFJSk3W/CFsAVBwWI1j9rO7uVjPHLb2hZScoyjDVWD1e0SLxL+2CaD8NefEfPbcMl7/voWBjH69N/Ww2yPvrBCaZjoD6XSvn4yoTnMa0aJpBnbqry/t0GzE4aa429m36Z8naEXuHcIsOvFaTwftSorYi6etbVrHZWheN6AJ1GEbmAdBSL7erNy3IQfZs+x2vMdw22hI9meTr5dX1uT4aCEvIA3Z7Kx+dmKnG/IIhw/2l+gzuRhsrUDr2oJrJtO0MxSXjsHrVbi5+EtD+O/rPw7/pVi/vMKPhexVE1pnJx9+mh2TPLvxFYIBZjtxgAorK3nVZft2M63I99P/WgUfO0q0WecoAIfAN6ZbFumoqjwR140tNgOR4weDMqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CnUqAJghX5Z0+qJxGebrr+jkWvS6qeUvIBf+u6zruX1oOK54nnJm/0AeGHR5?=
 =?us-ascii?Q?pYknRGFzxRDU5camBC6NOv1EH9DexZxWLUhGF6ULyFlv9erbQZHeiMkNxSWP?=
 =?us-ascii?Q?WDp0pnYj4K50fyY98k3EaBhBUSYMt6X+PQteVPOuV5ESJnd4iAsaVwqP+9jq?=
 =?us-ascii?Q?xFsEVKbv5kw3JemW8FkAS1X9QmPd2zl5pWDOcr0bdDV+qJY+1znXSJpL7x8x?=
 =?us-ascii?Q?v3TFpbBNT8EyzPn0cmyYIe5mjebdmcXIXFsA1H3JwOhNCgMeA5+pzsvlJpYp?=
 =?us-ascii?Q?I8azTtkaywP9tEwQY07aevx8cvnMiOF48vkKJoW+yPo1XwmyhciP5810ppXM?=
 =?us-ascii?Q?U+eI2FrnJfw+/qFntgJPD4NvY/mEMRBAI1oVUVhZEh9DPmUyfDcaxSWTio/w?=
 =?us-ascii?Q?Rziaz/S+iN6z9HlYXBaMCIncBmorrSFyvSXCKdM2Zzv9121qIoDl3TcHX67n?=
 =?us-ascii?Q?RZP0kx8MQ+kAGNNhHLuayUE126PURJ0aYtnc5iBgY+jvhcAfU/UnHK7RRM4N?=
 =?us-ascii?Q?KXc4fRxV+ARaJCe8RhPKMMYwrwyYSmcd4Qu7K+qKJLjt+ahziy7hWkzKnNZk?=
 =?us-ascii?Q?tEqgC1C6pco7uC897FmLFYH7N9jFEBuBT8EDaOeQ9kppMx/hzg8D7TKU52wE?=
 =?us-ascii?Q?aczCORdpkmShu29nT1/pVLEc3kiVqJcOi20FGQXWsM3GFyNMNpxnU08iJ3Yy?=
 =?us-ascii?Q?FqkQWN6xtnHb/04jvNGAEXvTyUxARfC+ZwYwZPwVR/3zyy7zk5h0DU4ZfdpH?=
 =?us-ascii?Q?yFW4l9EaIlh9Pp/FUoYqYz68gfo6TPlqztnElxTWVUS1z5T7tZUIIQt2Jhkv?=
 =?us-ascii?Q?XdWGBx0+Rn32lHkyObL8uwwBu/stE1gTNa9QFFlhRXBQK2D4IjY8SNZpl7u3?=
 =?us-ascii?Q?KXJmgdMVqLYAlk6L1AaWuYqup9/qVxQRf7cxTviSCwcl4U75XOlDzAtd7vLE?=
 =?us-ascii?Q?zgnf1ZMvK89ygBA56uFDIlpmsD4RZBUqEv86yiaDtcxTHoeFdQ66YvvOKpnw?=
 =?us-ascii?Q?jr+/PI6uilGVyyjvy+BoA/qTFzikN47anZy58ogTTGcmGlzqKqchv3xaj7qI?=
 =?us-ascii?Q?2tGOJkZBO51KawYCS1qEijg0KiuBbBaIX/+n76c/6eNW0hJNGEqtwXfiKIgB?=
 =?us-ascii?Q?HdG8SL+5AafrIwR32iIpwLJyRZfJzSBOtqJSBXuQvvWYVBHjg8B8ltapAAmY?=
 =?us-ascii?Q?JqmodyVWM4GivSe5iW1QseVrB3khiPfzbuVMzt1+Ou0DNqiN5+Snhm6yB/vO?=
 =?us-ascii?Q?LikMhxAJQ6hFar6VpIeFzwo8JpsNFRyUigI7spgy9Kv6cFoqYK/VsxzZ6JLC?=
 =?us-ascii?Q?8zXYlgXIpOd4K3havNcLbRbIqMwppcDnfp8XQkEDM1S7LTHZXBo6jxnIOtiJ?=
 =?us-ascii?Q?yBTQ2w2lMItzas32Z9XsF8UTutrRmt8dqudbHL9NVeiwXftg/LLbHjUDFS3H?=
 =?us-ascii?Q?9Evp3zjwcd/MHJ6lv8+UkNh/utvC6DxBe9MBm2Ar/IpN34WCgANZ5bUv1JVS?=
 =?us-ascii?Q?t1ZQJP127zJhjfr4Mjxui5pJqbcO2DTD7QMkni63gsB1x7aoGHusxxPxGusQ?=
 =?us-ascii?Q?fk0aoZ1g/1mKDzN8KN7Zq1Ot0ksABU8WP1WeVRB2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d76e35-4d1c-490e-826b-08da94ecab1c
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:29:03.2186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RMppssFOp271PRSwwiUHlRJ6Csa1SBHzNxgBUt/TjdSuXIdAlyC0CLd/u43Vtwbjo4cPATK2ysSSWV6SnYomw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of calling the internal functions which implement .ndo_stop and
.ndo_open, we can simply call dev_close and dev_open, so that we keep
the code cleaner.

Also, in the next patches we'll use the same APIs from other files
without needing to export the internal functions.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 83b7c14bba53..244a8039e855 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2622,7 +2622,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	need_update = (!!priv->xdp_prog != !!prog);
 
 	if (up)
-		dpaa2_eth_stop(dev);
+		dev_close(dev);
 
 	/* While in xdp mode, enforce a maximum Rx frame size based on MTU.
 	 * Also, when switching between xdp/non-xdp modes we need to reconfigure
@@ -2650,7 +2650,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	}
 
 	if (up) {
-		err = dpaa2_eth_open(dev);
+		err = dev_open(dev, NULL);
 		if (err)
 			return err;
 	}
@@ -2661,7 +2661,7 @@ static int dpaa2_eth_setup_xdp(struct net_device *dev, struct bpf_prog *prog)
 	if (prog)
 		bpf_prog_sub(prog, priv->num_channels);
 	if (up)
-		dpaa2_eth_open(dev);
+		dev_open(dev, NULL);
 
 	return err;
 }
-- 
2.33.1

