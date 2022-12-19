Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15101650671
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 03:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiLSCb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 21:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiLSCb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 21:31:26 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C81AE75;
        Sun, 18 Dec 2022 18:31:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSxJIy8E5e+WbxJd6+dpab3yntTAnK5nz7T3IRhP+Q7jv0kymbywKX4I/HKLA7OIMjPip9Q4EDAPC/S6RI1GWpi44xWDxVp8dyaSh9C4f0DOxsyDM6Y3BrOq0RF3w+1/UkolZwg3+Z4YVfEw3IvXoFq6CEgi8h7l0OJbkOl8ef0ir3AGmUOXnUA7f7bX9BMQxvnovamPRFSPBLR2HNprqqAxgvWLbusdAX/FIVUI/nybckYlsGDH1KXmmu6ZdgmsuU45B+3/2X15L2hOzot/iZcptjFuu+shFZu1bE7gfSZyL8TaxzXiwMQHodORNeP+9LIUfNIcV5/NZveOKeOb2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXWN+d6DK7fFS9SI2is81D8obGB65din31uk1cltcd4=;
 b=Aa2u0vo270sGv8KAzP0VWxk+fqnz/RYCIlDu6b7SDj35J4v12AbgtkZ0veAmOpIwC7q0NmG0RE7FLiF8k40nVAoDJvzbupMcxYHM3lMVx4fLQJEWpRqV6IExVeP4fr6l+dcGr0igDy0l1znsb89rjEB6krxGiuCCFzj63/ZZTUdtEnvBJvaKIE/aXG8w3ZML2UrhealsLyBLrjJ1xc6Up5+QMmpBWeuZilXVoaXiwFtk3w3hzH9IZN+97HnGnqhC0Zl07UWjkqwUCgTS13YGnvMZZI2R15WLO3ivzBajULbU4neeazhMSeoh2JWA4NTXupQb9xy83dqWm5LvNY8JUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXWN+d6DK7fFS9SI2is81D8obGB65din31uk1cltcd4=;
 b=YcpKx0HTYczpWxCf430WNQsFsjuzIKGZ6Wxkl3GqHaZb5aU4c3zzXEQeKzoJthPDwhGkfB2H1a91O2BkZIT+v7HbOIdzY7/yNjWz90MHnLYvsrvxzGZ4qOsO6G04wTvbjAqm2RXQ/pzrklVKskflpLLX5exywUvF/5+tAMvdD4g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB8PR04MB6953.eurprd04.prod.outlook.com (2603:10a6:10:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 02:31:22 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24%8]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 02:31:22 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiaoning.wang@nxp.com, shenwei.wang@nxp.com,
        alexander.duyck@gmail.com, linux-imx@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net] net: fec: Coverity issue: Dereference null return value
Date:   Mon, 19 Dec 2022 10:27:55 +0800
Message-Id: <20221219022755.1047573-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|DB8PR04MB6953:EE_
X-MS-Office365-Filtering-Correlation-Id: f9049480-6be3-49b1-a9a3-08dae1691e1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmoEGrjTD+cBFWZ9rUd7AKPR3oPhMch+gEdRxz+sqRc82TklAELvFjAmjtzoVhzmq2vEM74EJCS2KWxQmxRRZ6Z3jJxXqVYqDpSduYCpsKXzzEPAl2/w8ANI8pGBhGezjub0LII9ieGCFhMV3KRQlru1x+PsuJDJOY3cGls5b2YFZN8ZpXL0omIRKL6TFLMf75W0Vl0siGVSJVzAfmU+cI9uNbnCyozGw2bUMk+DHcmFn8yWQKdovWM0+mbYuJO27tWgcqT6gQdXE0W75vp7LUtwulBm/twcKKxhVoiX1YSNj5IgkNbYPUfTmp7ZrumOzosDTN5DQ+3TvEVqA4tJgjkjIMmxxUdsxQTUxIHrUdFe//aVGcOVBntdelujtKV/Asnk9dAaeqguKYNzcELIKjpEg4Ssv87TPHe3EKjKI6jEibpo+y3y0nqoh5F2B6/F9gBZe8jWGxXtR0bne4BUXYo3fkD713+LDtSep0ZDfou0ChQzsD1WCn3WoUzDXiGEWgYKpNAMi3eINvC/udGoqrGLekNCaLmE7Df9hl0dzgR0Wgx2lcUO9usI2CbhSIUCBLWq/E4JE2Yu4F9i32bWLPbs5sXF8EhQ5xfb6m2rJ3oyfcL/CC5xluUVjwt3C6qhzsQJII4zax/hkdEqwLJJ0/5NbUSWNtxg0iwXqQxGRyHB3e0FE8UxKRY7/BzTTFQw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199015)(5660300002)(66476007)(66946007)(2616005)(66556008)(4326008)(38350700002)(8676002)(36756003)(38100700002)(186003)(6512007)(26005)(9686003)(83380400001)(1076003)(316002)(41300700001)(8936002)(86362001)(6666004)(2906002)(478600001)(6506007)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cnQmNGwOYu9USZms0qpJX6Wm53uuFGPu3o77s/yYPJ1dOq7TN0DD6H33/8kz?=
 =?us-ascii?Q?WbIg5geW91Ej38L317JzZNMeuNUYNHffqBUVWn/NvzHo+T1MECtKv7FWvkT7?=
 =?us-ascii?Q?Id1u+GX1KK6v7K7yJ9RrG7W3YnJdjWGBE5jyO2d1rPFzveX2oTgZ8if8ExOU?=
 =?us-ascii?Q?EZwrzSK5hQBHitUdUY547K8cHY3esaOamZRBTkqtTSUjEaM3xZtNH3sQPIye?=
 =?us-ascii?Q?m6M6/L53uN4nmp8ZEy/xplIpXphy7XmYW7KRVk0T5P1RWuUnKpbAVD0tjn88?=
 =?us-ascii?Q?0nsovAG0f53uAAKhzJI639pPzlNTu3kZVrIGzapHFjsi3efREfXAfbW7B1A2?=
 =?us-ascii?Q?Gz0doJPQNnytfpKYU9CDLFwhhDNobNrbUotRDSchupe7NGByfjB3b9dn19K6?=
 =?us-ascii?Q?lyy1aYop1g7xJpjpG8XTtPFF6lByZLvzmrw+cTcTRDk8YevHJNFfk8BtrFHy?=
 =?us-ascii?Q?iWL/VoBSUVTceUHgW0FfW4Ds8oEFbbF5E2osPk0nTm9/O3NFTtxJnZ3yexOg?=
 =?us-ascii?Q?mQmly5Sr21W2Gmv3ZAPlaeSlpZw5CBdtNnnpGc/xm/cCViaOek3kfcyT3rl0?=
 =?us-ascii?Q?pPkdYWp/yR8RNqggA33xrCaAUEZJJF1vWij2P3rUKSrhK5Cu4hmcTAg7E2U2?=
 =?us-ascii?Q?knGzFooXgJkdaaJNGMjft71/z0HWv2Qarthtyd//vj++Xf2AAC8YPPKO78Vg?=
 =?us-ascii?Q?vgbEWgZ1TGu1p7C4uoZtsKv+HoT5HrEmWQdetEZ/S3fSnqt/2vgfVwzk1cJJ?=
 =?us-ascii?Q?iX143Y5E+Ty+CtfSIGgbSyNlmKWgLLVfGaLcGB5LnnYpnoeY3DSus8xvYrvi?=
 =?us-ascii?Q?E0FqaVGqTZgnJu3YSHdNlGcNOnfj+YGeu9o1Dw+r1jabJ5s79zIRjW7fOXvg?=
 =?us-ascii?Q?hKssILe/iRHA+8aC5Um0zjD+aQu+o0JEtRbFeG+fauwhawcs6o/miSs1DF36?=
 =?us-ascii?Q?nmQYJOIc2suTl8ouUv1KmbrD0TLmni2Zpof+7KLSqHdmC0p1iwVi9ilv+Urs?=
 =?us-ascii?Q?EGUV9K/KhEBfVGjHufN5LkMCryn65IddcbYNEb/vhwqW6P1Od7dt4MxOClKN?=
 =?us-ascii?Q?VQYYUXm9gJqv4QAUk/xtbXR3SsvTE8X8q1Y1s/FpojkrbWReNkaGUWl+JtjV?=
 =?us-ascii?Q?8Yz+G22isUJVMitHV6zloGDldKr2XMX1MW9mndd7AcIKzj9Puk0TvCdnB8sA?=
 =?us-ascii?Q?Bsy1sKUJZr2IAGWNOPUWXHlh6He8jkFmJHrs10zq5gsvlsCxSCvCyL9Ng+Tm?=
 =?us-ascii?Q?pvAuiMeOLFzbpopmkin5XQtx9wgJehgWO1RUVNHNIF2wnzes3xRj+/C+hRVm?=
 =?us-ascii?Q?4oDT0ILUqklAa/9C7VoDM8LJjLPQzIBIhXW4nlaWlrmq566E0rrq7qR4rKdR?=
 =?us-ascii?Q?kQTEC2eoG4sHZs3V1DtPYdwy3xgHTK8m1snUpf8UlHpxxnUUFsDQojkfALbi?=
 =?us-ascii?Q?f+wGLpb2D6IHJtLq9BdV+JUNkvLIwMbR3T2n4Famjhvsj+5OjEXFvpJZ+N0Z?=
 =?us-ascii?Q?rBX+AUrH5Ii0CdNfkDqW8wfoOM4ApEugn5mhJcFjML3ydP+bd8cTQkpWw4JN?=
 =?us-ascii?Q?YZx3jYgj4lMn5S0AaQGvtUtarmYJNh+t4LpZG/dL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9049480-6be3-49b1-a9a3-08dae1691e1d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 02:31:22.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3Ke2uQMzzfiAgeWaRX/KWgq1Xlymv6PtdlkvDCexULYoJ4cpNyXWIDY3gVmzS4ixz/nJBCQC3qOdDNi/PiuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6953
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The build_skb might return a null pointer but there is no check on the
return value in the fec_enet_rx_queue(). So a null pointer dereference
might occur. To avoid this, we check the return value of build_skb. If
the return value is a null pointer, the driver will recycle the page and
update the statistic of ndev. Then jump to rx_processing_done to clear
the status flags of the BD so that the hardware can recycle the BD.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>
---
V2 changes:
1. Remove rx_packets and rx_bytes counters.
2. Use netdev_err_once instead of netdev_err.
---
 drivers/net/ethernet/freescale/fec_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5528b0af82ae..644f3c963730 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1674,6 +1674,14 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * bridging applications.
 		 */
 		skb = build_skb(page_address(page), PAGE_SIZE);
+		if (unlikely(!skb)) {
+			page_pool_recycle_direct(rxq->page_pool, page);
+			ndev->stats.rx_dropped++;
+
+			netdev_err_once(ndev, "build_skb failed!\n");
+			goto rx_processing_done;
+		}
+
 		skb_reserve(skb, data_start);
 		skb_put(skb, pkt_len - sub_len);
 		skb_mark_for_recycle(skb);
-- 
2.25.1

