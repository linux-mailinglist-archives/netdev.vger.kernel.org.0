Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865413D8D15
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhG1Lv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:51:59 -0400
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:32449
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234537AbhG1Lv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imx/OX9DS/oIVjSS9eVz8ODt+64OZaoGgurHv+MKVDLwyKi+nLQNS4yYKzgLOLlu/kw6JXBBjE7PPDCCC/CnaYsBvJoLpQVypTXcI4B7woCL8t9F2ZLylrmefV074QjeuyFV88XwlLLhgq1PUjeCTU7lR9+NCXvQHxQYueRJzfIA9aMAGSnnHg/vChV7uuQfFlrvc4yxd6hl3/D0fjBGlsch8tuyj3HjC4qAfwMnsTi2P/OH0WDkOEUtSgdtGjzOnWZodQMs0n34HS8vhM5k6x9q/el6kQuYtz5upkEIBVADLm88lAiUM2njy6Qao2z2HdrA4qs+9zonL7Uk9PW9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmC2RZjt0OOqlW1JC+lks1SbLSMo+H4f+pR+34O7AhU=;
 b=Be/KjtGTbbSbCsi+qm1lbwOIeEJl9FczcowAaaAx9X2N2BohYNfusSakLCyWPGZsmmZWK9dapNq5lQ8rAR8vlHBQBe/m2xDgVpL0KpO7BI2cWdQwAAnTXrsZKj5cH7ZVsaA8h+7JUYTRVDrpD5MhIym/tvY8TrsAzpzRJlmE0r4k1c3ADM8L4KOc+L7THNfe/L42hwTvoJQz1CDdicw0tJEYVC8rvZA4RHJM1d4jZfehpzIqExnPe0QeqLHC9PIQo8ZJT8ulHeEjODutMvJzufXMJpcx4fi3uV969kBkWVHgzQcQwP37dlNWRo4X0xa6WDQBhUZROeFkgm5XMRV48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmC2RZjt0OOqlW1JC+lks1SbLSMo+H4f+pR+34O7AhU=;
 b=A0Ga8lH2SKGvTAS6Frus1NRnPMZbhxO8ygGUormZ2T+SGgXTqduzDItZtcVcAKY7wLjiaG5LhnvvqU8WCdUQiHfb2x0SQLTZIVKjytsXL7F1/GuIrRJuSXzZOtDuJEadRnfXcoUwL8MQwK1REtCyjsPyEg7eaVTeCOhwd2vfZ6s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:51:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:51:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 0/7] net: fec: add support for i.MX8MQ and i.MX8QM
Date:   Wed, 28 Jul 2021 19:51:56 +0800
Message-Id: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:51:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60e84ee6-cc5e-451b-8e4d-08d951be17cf
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB3094D33BDC88733AA443D1EDE6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zs2+XSWuwZcjRau8OckMWbOMm5xpg7vUGeUMlQDkJ+6cI+eiRe1FQJCOQ+jkQy/aJVQ92fDpDkqKIm6din1xqI0CNVcf/PORtqFx+Uimv/tHZhjwi84DhW9OZFNWRYRGxb7cjcZfkWhkzYujO6/4aOs5iVWMETwRbAh9BaKCWHcPZK1KiVTw9foofv2xSpjyfzPjN22NnNP3Cy59RSWEhG2f7xq9/K0+SVRU9U4MMATi47ddwkUlXS1FUPeEVgTL7sbsFyMOgInzfHLiMqBXxGEj2zC0EW6+Wy2iohvb/ZE+5i9xqI+h0uzwXdx1cG6RInc+Z/l/EWOpW/ZJXdrvPIWcFqDyqF3FOIpEs7DA1xL8U9NZy64sA8O6s4yaU8rUA30RZuKiagL9aSGwSong7y8RseCL6RuLVtTMb4Xoirk4Kf1eIIl2sW4WQTH1Be/YfgVjpc4KxV4IcTHgpCSgr+m7oaMKkq48WJAhFtg40DHIHCTEhbY58TJiqZB7iV7wqYMZq1j0AG9IpTCHPikO97BfhtcwYiFCVnyGDnp+ZPGPeShOPDw9zlBy6myiAv88X2+/nj6EmeB8eygr+5/I1jQ1+m3gOK7GieELZwBV/YSYGjhNqtUBBqubWMm6An1SQWYRttoql+5k4V4qxh7lHj8NvEkrrxgNE74OCpT+vWKP2P4SZ5K1s3f+hBLxrKGmFIeAVGTbUIszzY4D9ErKAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(26005)(2906002)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(83380400001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9MdR/QEXqA1U9RcTY5dqC0itLeC9kvECmOyYQI5ceCSrY0cm/FA3eqrQq+03?=
 =?us-ascii?Q?SvZavj9o8faUGYDwwI1OrnXI7kVpSuI+yRK9PPae1UXdAicg4pw8v/9IIwuW?=
 =?us-ascii?Q?BOM3Qypyd6YxO5tPbhqTo1NoXo3B5Xqwwaa8IyVxO/RMut9iy3l2ZUYBKFDs?=
 =?us-ascii?Q?PFIjB9qpNPwdnOmNYA3zQNwqtWs51g773JxKFdhKAyWe0siQ52xfEONr/mIv?=
 =?us-ascii?Q?r2YO70LS5F49gY8GBhagRiTkps80B832GTmMqf8Z6KHJK8i3sbVNbm8kpU7V?=
 =?us-ascii?Q?0J/c8X+JHE4TVJPETX8O26//rWQtozNnd8BQMeaT5vm/KVQqwVw2aqG2qk9g?=
 =?us-ascii?Q?dr/sL+3ubjx/KkB246hrtNxsaKTiTghzO51rsWNsjdcQUc4nLVap7+Qo8Dwe?=
 =?us-ascii?Q?HrLV3ip9XwAHLaRGq/dFJF3mxlfPvksh5YZ05RaX51yoQvLGjwbemqRjNvqk?=
 =?us-ascii?Q?lOYGw02GUC/sMEHU20JlfJndEZMpkeqx93MuD/h3pkdsoM+kSJoqUSKbhuyn?=
 =?us-ascii?Q?9S1SLIcP4xJTIk4zU1w0QR3LP1tuyF9MVcV4avpYDjMRxc6cIIPj2mEZfMQM?=
 =?us-ascii?Q?5UFxJrjdI1EqxdSNA590C+752EZAb4CaZ//MbcGJL24aMM05I/CtOnO5qwll?=
 =?us-ascii?Q?5Mbcghdm/EG41FL9Qko5ROyzVe8/TCky3dq5hCr3fipG3DWUMWF1PUj720eM?=
 =?us-ascii?Q?Xcdv120a6b1+o0IEZxcqzKF7OpIZMeAKCWM4Qy79ERjadCGhpA7O0CwUUuqY?=
 =?us-ascii?Q?a0x23IA0Y8Me1nzZGEvR8W3W8AgvKmSK90AJak1SSlnaqdcus6l47Uyu+p54?=
 =?us-ascii?Q?aITjfcfrVcAFZPFmUqCfp+JF/T2dUKrdkO0NyYx9Uq0q2za+2fjRqOthe+IZ?=
 =?us-ascii?Q?OYBni5wum+5EdYE2BA3cl2FWsi/az45RCrU5omwUoeq8Ug9irfNarq94AOyq?=
 =?us-ascii?Q?BPYacP/h2no8OGrG5Ibe88wbadJTcQeTGWZNwoJlWDn56FQsq7BBrTZJoToR?=
 =?us-ascii?Q?98ty3TLo1iWSskRFaQJ2aln7sOXjrylXMi4uJ4RiI0dm1XduUvkrjZ02OugB?=
 =?us-ascii?Q?mVXa04xUPxe68DvJVuzZMD52VTPfUm9GjgHDULSsT0XbzNoShgZtXi83Brzu?=
 =?us-ascii?Q?KfAc+Etee/KjwM0mqa/3khMOEploUYdqd5qFOucHtNxPzJDjqM8VIKt3uSOe?=
 =?us-ascii?Q?wgM2u9QzV1PFncTrgwAtr0mgFwIGNbR7fdELPBn3B4zWMHfu3p6nYp/mCQus?=
 =?us-ascii?Q?eU4VqRYJnzGXTkcs5eLeibutZhv1SunvjlhekhKjz7SZqpSOBvOr/0XuVpIq?=
 =?us-ascii?Q?eNsM517pxt7z3wunYnGrf4Ql?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e84ee6-cc5e-451b-8e4d-08d951be17cf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:51:53.8374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lfa0zgSCjPEaD5jXHwq8gpcf+V3NEYRGzAETvFTzaIEiDKBK4TjLDLLWj+J5GY//0zGSkcYTfkBfENEtIA0oYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds supports for i.MX8MQ and i.MX8QM, both of them extend new features.

ChangeLogs:
V1->V2:
	* rebase on schema binding, and update dts compatible string.
	* use generic ethernet controller property for MAC internal RGMII clock delay
	  rx-internal-delay-ps and tx-internal-delay-ps

Fugang Duan (3):
  net: fec: add imx8mq and imx8qm new versions support
  net: fec: add eee mode tx lpi support
  net: fec: add MAC internal delayed clock feature support

Joakim Zhang (4):
  dt-bindings: net: fsl,fec: update compatible items
  dt-bindings: net: fsl,fec: add RGMII internal clock delay
  arm64: dts: imx8m: add "fsl,imx8mq-fec" compatible string for FEC
  arm64: dts: imx8qxp: add "fsl,imx8qm-fec" compatible string for FEC

 .../devicetree/bindings/net/fsl,fec.yaml      |  27 ++++
 arch/arm64/boot/dts/freescale/imx8mm.dtsi     |   2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi     |   2 +-
 .../boot/dts/freescale/imx8qxp-ss-conn.dtsi   |   4 +-
 drivers/net/ethernet/freescale/fec.h          |  25 +++
 drivers/net/ethernet/freescale/fec_main.c     | 146 ++++++++++++++++++
 6 files changed, 202 insertions(+), 4 deletions(-)

-- 
2.17.1

