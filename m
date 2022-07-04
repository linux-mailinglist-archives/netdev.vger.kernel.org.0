Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FC15657A9
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiGDNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiGDNq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:46:27 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417F92711;
        Mon,  4 Jul 2022 06:46:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy7HYtg46hwGl90rVqv94mSic7GvMk8S2uFH0inOZrlpcorOBqJ0h+o7+qDYQS33jwohmc0lYcVA5wSLrP+o34jsFV1NlO3fEvEdMDrdJ39JGUVN+EYUUYDqV/HZTB/ndfeHv+K87p4hPRZl9QCiiD8TGaBH8CmLWKFRE6SRwfGkfNi4qVDiN3ZpmdBjqRSCCrUOIoeRFq+FRC7abK1QinvoPF9TBH48VSkU1EUvgMDmeEuNdvIWoYgcE++AaYiFKPzn+gfemTyHYyVegWNYPNumnKxQ5FBlepxpYjxAWunm4Iiho5TSQGb2Cy+jxv21cEi71CnjIdJr7r7qSVH+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSCw9UveokqK7A/T0RdCAooQD9XFAgNGWxN7KFh6bww=;
 b=HUBuZdsf8hBofNjwmxy0KgCFqWPzS80lyLMcxrNeVNQxgZhl59gFw5xbxBNdgoXonmkwho6qbPtwlQ0zOhBUwndqLPmqYJJ2iQEtbvNNp/HVJgs7ROKi0DaJ4o3t5mtDW+Nbj9/BiVde58ccVN5U4Rrh7UFii2H+vEuFWmQNFQPvbtpdw8NXIj8dzb1gJUHhl6I/10AUaa9o2phHAFgAGS6qKmyRNxtKWuucVg18QfUJp3c7WDQnODZrxz42XGO6GFhWHqxTTUMy7AHgOuC+UQ3W9KJS7nGRFYwEB7up60r/XgTIS3ID6zm9qp6OamPa4O6EB8Y0YHqVMp+yGi+9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSCw9UveokqK7A/T0RdCAooQD9XFAgNGWxN7KFh6bww=;
 b=Ye0DmtWBZs2SnYBHfOERFAQwCn37hlMPKNBFBxPaODqMdGBUnbyfld6Pmvykw8pg79RNRgjotc8Z6kfr8yP0sSvV5l/I3wQNMO4LxhFcKGM4Lj9XMp8gwtUqbX3J3L87dZ1Ihu0jD6aynCCQf/aCFz9XHRnxvO0Uc+DqY0WQoP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by PA4PR04MB7887.eurprd04.prod.outlook.com (2603:10a6:102:c9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 13:46:24 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Mon, 4 Jul 2022
 13:46:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 0/4] dt-bindings: net: convert sff,sfp to dtschema
Date:   Mon,  4 Jul 2022 16:46:00 +0300
Message-Id: <20220704134604.13626-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::20) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ae78289-32ea-404e-6c94-08da5dc395a0
X-MS-TrafficTypeDiagnostic: PA4PR04MB7887:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4UDPFdNoDfGVpo+jA6qZl4G8N7/Zw+yJhw3qPEb1ZP631bOGDilAllv0Ix3TWfvzdQuIjEkACRUCUIuh/oiVu8cJ+1GzH4NQtffRlGAnRNoYaVbJpyZdxUUPbJ5xDg07NK5ymRP74HnojrNIs2VACu/OqgiRcH+Lh+0/SsAbAHLHeHg20nXcZD0IHU1QTGUpGXt7xtsi0pOl9OsAYqh1WXGCeRfkne+WfrnF4RsbMELhyWE5zVl+1m0WZTLL9rUPtOn3YusirbCTAIaMA05yv97LgQjOieqLuOG+3u31ugvzbz9FjjqhkVeH2MbQj/okVR2EqI4QhalhEFN6dP2mlmVllM9fpVgLxnOKJl2mbRvvNHqwz7LqWUCjcOzoZ0WLDmputN/1OCJOTxv71AY7RAyN2RAFNwugXWkJPGH+gXwU7M5Pgr6xSrWhGQx917dJdtR/nNSN2mlczuSpYBS2ewa15/T6yXY6qFBgiZY3TqTArsSfffWmQwcqbxoX6C3RNvX3QkSTcQvEpP9heCFeRzxawd7m/u27WYXzAouTWU12K5H/JQ+PkqWHO6RBKHhiXtcbVw6+v1AlbK6aPshJ66q/LYbIckHNm/1ekGcC49EwNVkpUGNNylBLsXNy2eg8Zs33iw/9pZYb9C0Vlx46bst1os39u0a5wDKY4kLF2lyKW+WXxK6ZQWX+oySZtry17DMKghvvyLhYJ2tSHgvQlf9jDGn/z6jFsNCKDFxrL9aWIVTiwgVo4y81w3xMpJhocNcDWBEK8CUsF8AMOlaML2Y4ospOJmlSeSZ/xTQl5230ef60UonNRl8A/t7wPto
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(1076003)(4326008)(66476007)(86362001)(66556008)(8676002)(8936002)(66946007)(6512007)(2616005)(38350700002)(38100700002)(316002)(52116002)(6666004)(41300700001)(6506007)(26005)(44832011)(186003)(478600001)(36756003)(2906002)(83380400001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ae84AiXiIxlCtingo7v/QDMzw7yZoJBJmXYggqUZ0ksDGPWvpLhlzAONjdME?=
 =?us-ascii?Q?jT0KYH8GNPl8/TiifKn4YOH0b+oxtUnz7B8nhfc5FwBajSOyiUwt/9YH1VCr?=
 =?us-ascii?Q?CKjdzla0tgXIFsv0eWFIpJui3U/GWri3PKOzANNgSV/rk1eWluFYGzqtTPb0?=
 =?us-ascii?Q?vT4orLu47s2SAMMhU1i571pFSY89XxvDzvftodxs7RfMeqIcf4OYS4QFvlRK?=
 =?us-ascii?Q?+rYSDqPaTBwnW0cW/n7+ihMC78qIsHelfnYVQIkYa0ZyXGg366+uZLHEIj0Q?=
 =?us-ascii?Q?fsII2QxmceMhz9w8/ilDHWm1Yt61p3kZciebGDuvK71PZRNKh0+be9iPkHzM?=
 =?us-ascii?Q?6OSsXENB5bmnOPmg6AxuCtljStlf/HgzpYdRZzBjbGtBTC1C7douS3dVQBbo?=
 =?us-ascii?Q?hXUMZwGACZq53Z02rDA2iL8XgvxB39rfEgn79tlz/MCCYQ/KY8jdyQWIhNKU?=
 =?us-ascii?Q?JqC+GkPC4C4gO2hTtHhULc7Kpjnh/zZn+VoEL8/z2M4rCYrgUcrNI5gxcJts?=
 =?us-ascii?Q?GM1gsWqbJZptvCal12GDUfjAuDePZawQMoq8Jf+JAkxiHgSz6uw5QtcOqJmO?=
 =?us-ascii?Q?7jZq6Yw71Wo6fT9HNMnfeMKeX1KmBP6LEbR3U0449s3DsYmPVcU+TxEjcoeV?=
 =?us-ascii?Q?51RG8YuLhzXrtC5ocr2bGbaNLPKMe4r4adDgeAZLJmFqElY9E5VCooJblz/9?=
 =?us-ascii?Q?GER+sJAkY5E3I9I5IanI4a8L0Hp6zioqSwCUxmMl5eEcx95TAKfk1gKusS7f?=
 =?us-ascii?Q?KVge2kUDZ2RSOnhmtZgIOEiU+cs/hqU0vpzccrdPL3sYTv/d5m4y/fwbAoBE?=
 =?us-ascii?Q?Me3kFTsIVRuvPJONyDLNw0amMdzacJedFLwtB+IFim98oGucPWrQxD5HCjyu?=
 =?us-ascii?Q?nN2uSZSAk1Ia+cc8YSiyntHSfWZhY2Sp7s5NFNkcwxYCi2iOOx07qllJgAXf?=
 =?us-ascii?Q?LVRw2cxz/rTkergVPiDnklVCzhrpPhpmv2WYDgV89ryx1y+XY+2ZRibNVWXs?=
 =?us-ascii?Q?U+KFeRPDG1bfjJaroZFFCrnsz3nNGS7b9Yl/jUPY5jyCiEK/bN2KBG289N4B?=
 =?us-ascii?Q?yDepL/DpTDCxIGNYLD6j+j/kQe8fhuCB7D0gxZCW8qVCwgyB/KB12RsS69Y2?=
 =?us-ascii?Q?l7ZkA/Qhjr3CHPy8gBOBBQUOGJM9VJqLOGDomJ4Ol+pYnSY36CdAqLggTjid?=
 =?us-ascii?Q?tQYslHRF5aQwpGrXoTavkHCHsiZMNeYd5CyUDfyhd1nC+NqYRdLiiiP3z5bC?=
 =?us-ascii?Q?JLHhOpw3VczhB/Mjw1a/eJrF/B+7WX9pmEFXDm6HCW7OUyP5a/gDYyl8NFKs?=
 =?us-ascii?Q?wYxcGvFES5u5Je/ru4VwvbfvO1GU+RiwX3ExFkYjimPhi9+0tZZXKSABOnG7?=
 =?us-ascii?Q?7F354aK2EcxylH1xLpg64v7VGGjqYHb6asuyisYLsIJdVjoNWOWteC8qhnLQ?=
 =?us-ascii?Q?OkGf0DJCqI+bsHY9t+pOu5SszPPHC+EPWvL5peS6A36InKjlCbtVMz8AREL3?=
 =?us-ascii?Q?6/tALo3RKF9HAqFLedrE3GFiKar9ESdUQSKoixUs0wwuEGSo2AfrjXfcgcpZ?=
 =?us-ascii?Q?JYyPYkp7gaTprDny6cFKqnEK59W0xGqVVkdWNc7z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae78289-32ea-404e-6c94-08da5dc395a0
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 13:46:23.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZACIx8zaUR0kXXvMjdYmX5is/dq0PIa1oHgg6w6HSGa8Bm9yus6HxgK1mh9cUdxjM0pVYK+KebWPr2pn3h4p6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7887
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Really sorry if you are receiving this patch set twice, I forgot to add
the netdev list the first time.)

This patch set converts the sff,sfp to dtschema.

The first patch does a somewhat mechanical conversion without changing
anything else beside the format in which the dt binding is presented.

In the second patch we rename some dt nodes to be generic. The last two
patches change the GPIO related properties so that they uses the -gpios
preferred suffix. This way, all the DTBs are passing the validation
against the sff,sfp.yaml binding.

Changes in v2:
 - 1/4: used the -gpios suffix
 - 1/4: restricted the use of some gpios if the compatible is sff,sff
 - 2: new patch, renamed some example dt nodes to be generic
 - 3,4: new patches, changed to the preffered -gpios suffix all impacted
   DT files

Ioana Ciornei (4):
  dt-bindings: net: convert sff,sfp to dtschema
  dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
  arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
  arch: arm64: dts: marvell: rename the sfp GPIO properties

 .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
 .../devicetree/bindings/net/sff,sfp.yaml      | 143 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |   8 +-
 .../dts/marvell/armada-3720-turris-mox.dts    |  10 +-
 .../boot/dts/marvell/armada-3720-uDPU.dts     |  16 +-
 .../boot/dts/marvell/armada-7040-mochabin.dts |  16 +-
 .../marvell/armada-8040-clearfog-gt-8k.dts    |   4 +-
 .../boot/dts/marvell/armada-8040-mcbin.dtsi   |  24 +--
 .../dts/marvell/armada-8040-puzzle-m801.dts   |  16 +-
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi   |   6 +-
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi    |   8 +-
 arch/arm64/boot/dts/marvell/cn9131-db.dtsi    |   8 +-
 arch/arm64/boot/dts/marvell/cn9132-db.dtsi    |   8 +-
 14 files changed, 206 insertions(+), 147 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
 create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml

-- 
2.17.1

