Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36A3621A4E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiKHRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiKHRV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:21:26 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03FF13D23;
        Tue,  8 Nov 2022 09:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=At2YIKswCnHv29QfbAGF3CGKAQBL9LdFky4Ln/VkSAHccJzhB68AsaEAVRQxkKjCJm2nB7ZfHWwspOcMXair1BzjALTCHky5o8O7e1HjQKvRGHdV3x2skt8zpO8WucZANDLsEhZb84CVNo4ZnAULzklcYysZe4cEV29plKqhDHWMSUh/1SsxP0Bu1WiOooU64HsgyTCplCHT1qNOgLcmH3p1MgN95rDti6cO15L9U/97cVBkt2r9/WCMgDsOJwk9oB4p0p0URsnGCNKP2hUrTm/uAUwlmAGpZeCquFVm0q6J5VZWGkqt9lwAzqs3kGAcijpY2x180NZp9ZAVN8TBzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBopWqSQzCAPj6JgejAUQ9BnwQft7V19ynTbW2caEfc=;
 b=esjbkSqwuN3ZlCvMpMT8/X0k0VUj3c08y7I2FTjLBRG1VXFpz1szPkYX+q++yraf4CmF0CtbF8XQScpqVQiw9D+pwkQK8KFpqz4/Q91vXk4Jqp9ekrRpfvuZqPiHCdznR8c0+C+5F0HBpEHGRv437fL6SWW9U++YUurFtmH7l15KgpCZUPPbBW+V1gYBIybY8V6dOrH7RjSXciCxNQmYYl9qWmRLmxU8KcNFWEJyH9gnWYFDyVpVz9GmFbqpe+tZPGVv7zPeGYhpchlplHMPTBUSbwzdlza/YOmUJzyNLU3tVYQB1Cc1Vsous9h3oD35phUQNd/dpLJWuJjRdfOCDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBopWqSQzCAPj6JgejAUQ9BnwQft7V19ynTbW2caEfc=;
 b=E5bBjdBrY10uxeWU30RZagRfkCRRwy6mVx8JNwC10CX3avEnk0+IF0gShojOgBvgkxSGPoKYeHFYo4+IoXgHlLKImG7G5u+R6djx+HHv7A6XN1RrOwrQ4cnB2n65ZvyvVv246oU/3eLVoZnhwcffXMZTo6DBrTp5F74nFJ1+AD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DBAPR04MB7334.eurprd04.prod.outlook.com (2603:10a6:10:1aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 8 Nov
 2022 17:21:20 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 17:21:20 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v2 0/2] net: fec: optimization and statistics
Date:   Tue,  8 Nov 2022 11:21:03 -0600
Message-Id: <20221108172105.3760656-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:254::20) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DBAPR04MB7334:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf6bf4f-2de1-43e7-2e54-08dac1ada732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H9Kk7gAPi9sPFLme6t6yuN6bzQ/iaRH7h/LpuELBmj3dI5CxEfRMnDjYofXE2Ev4mVRH6VxeP1peO9GtGEH9J+VeqIKeC85aeDGnA5Mt9cuLhM6Cd6AUvSmYgSvp6nuUozTwBnrcIRT2wHLDz/sSwmQlITn+Cx5q29cV8TrqoLJVMbJaiRFId7O02ZqoJF6QsEZH/tZTkc9gAshdgfQbQ5Xqint4AQo9CkKIHYrtNZflQrU/w57qkpl/lXuZbG3cqULSiYCQwekNKn6OsDkchblaWtix6y0BBw24E4hB1NzQJJpI9z6Mf835AHndNe16S0S7GzKxsqcK6i6tiJpUdVJQPBu4UXcGk7EcHsQo+mzHI5KF5RWkQYo105gzWjEdyDIq4T2aCqi30EyZKspYwYKYYk6gdDFLbZ7ifw8Jzkyt+vV5j5UjnTiYGEm2d8Fv1lJNzcQzL8VKhNBfFJX9UsdKrxGdqAAvl6v8NnA0mXbWa+l0uDvYeMUcVBSgh5Al/ipHfJ28ja9eR3TLgxXkhPV9mG4LJ1RD5lDPxwvC+KGrf8/NWBBaAX2/sF+u0/yVBhbaCN4J5PcXTNL1aS2QeSLT9O6/To4AcmdRZmpQ45Xo6aTJDvE3ujymjEWkGHAGmiGz0q+/Jhqa049kf1J9Pth8/R+Nc//+jLfh9lljRatPNA6knQWCRdkkq+3DEekvCGxA/W+dsf1RhNEf88WZgpV6Hp9yuRP0upNw15Ydm/BlI+K/pWNWpYP3yqDCtxa6ZcGP9YbtU8xuSUP38Xlpax4H5TUhgaseM1Ql2lEtJNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199015)(36756003)(478600001)(38350700002)(38100700002)(83380400001)(86362001)(2906002)(6512007)(26005)(44832011)(4744005)(1076003)(6506007)(52116002)(55236004)(6666004)(6486002)(966005)(7416002)(5660300002)(8936002)(54906003)(110136005)(186003)(2616005)(316002)(66946007)(4326008)(66556008)(66476007)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qr67TJCaexGO8neVOy67kGw/Abw83MQTAybGvBxaUZHcW5xmmPFo9zoGz+H/?=
 =?us-ascii?Q?35PAjjm2H4NgDfnAK/YXNrss98k19AeTnaGTKDKM8SHfG8JYyybee9zfyIls?=
 =?us-ascii?Q?70S7LkIBobUzQjZ1pkeWXrgLpfF9R1ul+e5ViDLMeYI0ZYcjom23xgN56vLj?=
 =?us-ascii?Q?PPx0Frlr030W9gVuSTLw8o/y8HvdxoNmQfbQtHLIPWLfRM2qbCI2MbHp5NCo?=
 =?us-ascii?Q?dPmg/wDubZqAcmdv/qXJv8blRILLOYGotMPeBm4AgmW7NfVn/Gd4exidwMvK?=
 =?us-ascii?Q?z3zsclI325CgbKz+v3j0hGOyEeiZitZDanYmTzsvujpsJ5gNiS+h1R3CAHu1?=
 =?us-ascii?Q?nq1rijUt4BEpI4lw7weOESdwHDU8Ql1FHsYzeNTwXj0dD1tJraL/1p9tMH9S?=
 =?us-ascii?Q?WXzsx7lDeX4+yhLxIdAk6b4dOsTnzI0ZgXMfRxMW4dMsVjuoKBECN1VVE6yb?=
 =?us-ascii?Q?3Fre0UtThdSS5V2gYtJRsByHchwLhKGz0C5llT1xws4aMDixMrs2eye+rjWQ?=
 =?us-ascii?Q?wHZ65Zy0U6bUn1Mi+kmiOkOy/EZRw+czPbOe/cx6ad65FkmkpId1ueM5d8Q2?=
 =?us-ascii?Q?m13VrSMhOq3MjMcKcAPxKn8Q9og8gHLDSVym/A4Ep/duI9Db7DWRTKIstZ7A?=
 =?us-ascii?Q?T48lcayU4O7OdUBiIJx1oiCQ3cb02ShAVTBnPm4Aqc8Zeved+f6jAaeMKHlM?=
 =?us-ascii?Q?CkZ0g32pDj5M8bbtOdDpDICRXy/gktT9BKvveiw2uZZ1ndQOp/lqS0TIc5pO?=
 =?us-ascii?Q?I3trKLgzCEA+M/Sp1s1yvJDKrSl0tVw56ldyyJgcbfzVjHw7s36NpctrvXsh?=
 =?us-ascii?Q?EIkGKfFaDkSX6TazCWoDrPHZ+mwAS7BfzCPVELCf4VYyGYVIIzCqBCGnsmqj?=
 =?us-ascii?Q?c9rIz8YEzbOKlgCMfGyji26lthU4noT0LksxBny2SicGZf9WawKCc4fEz0OX?=
 =?us-ascii?Q?F2tRTcA1Ui83Wv4ZH0NQlDWcF/bpm5PQaxXVIUqAUkHmJuOKUJPb0pQ9Jv4Q?=
 =?us-ascii?Q?43B/khZE1gh/TI/ucHxmwhBzAuomxHWFgIcwuiZ81XhZRE/OHIqRfPZURjst?=
 =?us-ascii?Q?z885JGirf9xsTHfq9tXtG43ERGabCytsIolfOE3HxP5rovPd3Y/TXHt9EOqB?=
 =?us-ascii?Q?pYUymtH9xU9MQi03jjwhosos65cVWMr9qkp0btFZpBf30Mci0OsvXz3VL5aK?=
 =?us-ascii?Q?Nugjr18jAYIzo6ZDC3+ng8tMxOkPNltYPfMM/tMHdVVSKJVmvZwLJh4nzmZu?=
 =?us-ascii?Q?W7gzqa2WOr8cfyJSLNotFmPeanCUn5iQhkBfAiOFyNF4A0yr6AZn5bNz5pJx?=
 =?us-ascii?Q?tdBn9ejBiTkuE8AtjxdR6g09WuWDrijzrJVtld33fTZimFOew5/AZhoIzaGg?=
 =?us-ascii?Q?qP3Cxytp2j8GpH0ATdBuissp+xTnneoDZemEz1x7VZz4OtVgghkwxiyLr3AA?=
 =?us-ascii?Q?ovhlBwKcJtnNDiuDQpKIdxLpcpBQrc70m1iFBNJXqB5NPCPwyuYJm3x/Ygcr?=
 =?us-ascii?Q?iG96aW+Gf62V9x5anSEpz124WLr3g4uEL5xiUp1oSB8VHw/ib6CFU6bRZW04?=
 =?us-ascii?Q?nrmJvs5/7mIxtnbbdBq75sjpahqV6UkZsnlCMbkb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf6bf4f-2de1-43e7-2e54-08dac1ada732
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:21:20.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACMJtSF8s+tRGBarZTffKg2Q6TlpqOuxcC3hLn75SLK0Wk8FP7GSQ2fMk8I4M+xQAbej/OPOdw7GEchkwKbJEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7334
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the patch to add XDP statistics is based on the previous optimization
patch, I've put the two patches together. The link to the optimization
is the following:

https://lore.kernel.org/imx/20221104024754.2756412-1-shenwei.wang@nxp.com/

Changes in v2:
 - clean up and restructure the codes per Andrew Lunn's review comments
 - clear the statistics when the adaptor is down

Shenwei Wang (2):
  net: fec: simplify the code logic of quirks
  net: fec: add xdp and page pool statistics

 drivers/net/ethernet/freescale/fec.h      |  14 +++
 drivers/net/ethernet/freescale/fec_main.c | 134 ++++++++++++++++++----
 2 files changed, 124 insertions(+), 24 deletions(-)

--
2.34.1

