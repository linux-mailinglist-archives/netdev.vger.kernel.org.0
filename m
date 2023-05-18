Return-Path: <netdev+bounces-3678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5798708532
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:42:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D40761C21063
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170AA2107E;
	Thu, 18 May 2023 15:42:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053DE53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:42:09 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2069.outbound.protection.outlook.com [40.107.22.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0CD2;
	Thu, 18 May 2023 08:42:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pj3XMs8SAbM5yPYGddj2JsOP6eq+JjVKDG2NmO9ipMSN4Oh3lLn/dIS7rsTKRB0oWGqwenU9Bb0bFltZ9TKQX3Ikx7feNjY8JQIFJ6X5pb0dQxQg0K6RN5sCnuTAPrDud+8+oEYVfb4eZxDKWbxsHSp2Hevi/iWOfOv67yqJKLSQZr1+RXXXOzuyKTeNhe364APOP8M65yK1PMjzo12F/xjFee33kLP5NWHzXyIicFlRgvmP4GKwLV1qWSH3mtewgEIa7QlkTF8KN0MDrd0EEyCiWbGKTD/FdeUpMVqX+3rnWzmQZ3g4uyjRe5Xb+KpwIN0V/VISjp90bA8dMyH/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G9pYWDNeM51hLex17p79DyV3gWyeKtKK5xrcM+1ezJA=;
 b=KezSSS7F0tvJ1IswaJbZroURazVLT++MSR8KR8M2E2QCSU+S12HPVYwPv/gc8jORc7+WDvlgdPVFKp42zI6btevo54471Pxzdy7Pc5PnXX7ss2RNJ18cCx+qOAQFAYrvWky6EsAVZYMCAO0oZzxY6XNIq3s/I/4z7MEcuFIKRECySE8DVPcpNX8qe8SdUS+wKlYpIUolaAXQtKxMe7+BDsIj2duu6sAS5I1BztN+imrk7vDo0EvSl3IlBW1qOFmFgz3AOsfL4SJZ6DtMQi5Sih7k54HisWEfvBU5Fx0w0KclF3+n/L2QV2YNDGdPiEqjfyZ3BkVojEvz6dhF2xW4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9pYWDNeM51hLex17p79DyV3gWyeKtKK5xrcM+1ezJA=;
 b=aq2D2yjmm6J9tbrEEFw9BHk5nKvabDfvUtcFu5Y/GiGJ6YRK4F+6gaXRFxkE6G7qDvTVm8eE+lTlp8v60A+2K+bbx3Oqa+8pBtBdzGu8FWiY7im71ZC3xPR8zzP3qShw1Ncguhy/DXv4IgvHljET7M+FrHUtT6uRC866nnWjvkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6784.eurprd04.prod.outlook.com (2603:10a6:803:13e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.34; Thu, 18 May
 2023 15:42:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 15:42:04 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
Date: Thu, 18 May 2023 18:41:46 +0300
Message-Id: <20230518154146.856687-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0026.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::36) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 85acac7a-6347-4086-d313-08db57b66d93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xIkwXyI7MwtecMLLR2cJBRaU3KGpbdawW2kNK8EgjizW0uz8RYtL5zoli7SuTzKVig0txg0K+ZF99i77iXG6UtmYA54aUbnKURfk6sMwQ2J2Vc0vGlKjyh/xj1NeKqOqXIi8Rwqn/QcA0pu1stxaoompx7jKmstFapCAwy96kvl8Zp5/2AaIvfanKfip2rfp6HheGiFZv21VsQwp2qYhdJAZOoo46Es1Ad8Kf2b3hSi2lUiq4/08APYJfv8slCg+ZIwiExYbO2oAZCt8rL1tiJ8BWPYsW0SZmy6am5HZ/5zPmNDJpZTFhQ/LqLMrNeuMEDdzRZ5Y9VlA3/+dRAUoONs02bxlYAB4xTnUzVngG7UuUs6E7KZJTV6rfOV5pUOSxJVRH3BTpP7WNCoSbk73n2fuKXe+SQr6GklxaQYrEwyEjdbHkT+g+gR6YqqcOVkLQJULXa+AKV4JVYhy503nLSGu8O0Uii1Eiu6gvCR174IxEeZqVKdkkZeaonJUTVIJ7S47ZQvQ2J8ncZfSExxtiRMgVwRHa5sa/qMgweF6VQ4qy8BJjKcqtkhlTqjGEWQgIudlmMeIq2NkSGKi+iSJFS0104z1cV3kLCDRPdjkdypOuzxoajFuY61LGql33nNy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(5660300002)(8936002)(8676002)(2616005)(4744005)(2906002)(186003)(36756003)(38350700002)(38100700002)(86362001)(44832011)(26005)(6506007)(1076003)(54906003)(316002)(6512007)(6666004)(66476007)(478600001)(66556008)(4326008)(66946007)(6916009)(6486002)(52116002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fJik5IPGLC9GrsqPxG5dpiVyB7sRKCgSW4zN8oKwmQof7jpuozewBItUU2Kt?=
 =?us-ascii?Q?lzDFaa695UiY7safwq2Z7NcWMUiqKyGiuzhmG8bGoVdqewqyNoHtMGKQSMzZ?=
 =?us-ascii?Q?PJfOQcHdCO7aDoU30tRm74ktW5R9ffHv4+nw7PqQe8XOnO3bwxYzeoiT4UtW?=
 =?us-ascii?Q?6ixuNBgbOnu50UliZnm4Hwd4NMgFkgmJSf9ju6n0BREjc8qXmn6tnztMa4Vg?=
 =?us-ascii?Q?McisNGZPOK+Jck8urXRWMpO5OzV91iIPmYniJ6RXj+5I4NY8MfNzSZ7Rrp1c?=
 =?us-ascii?Q?P10/wQ9vp16/LjbIPPIdYuPLIgHfkGwx61YIkaIJXfzxuR9Vd8tlgLeQBB+8?=
 =?us-ascii?Q?rypQgsGIO8jI5B+PLawYL6IAyiHQdtvBQ3arMz4nridGTg+3Q4Z5O/RkFF74?=
 =?us-ascii?Q?ix8xVpaBA3asBzDA2HqIBXYV3N9LyE15GCJe5raeFS2tQ6KMp+QZD+8Z7bFN?=
 =?us-ascii?Q?slYZ3/RCLh6xTmK5pSqyWp6iP3qNCu/awwHveqaKR9TQDrXNOrja25nkuyl3?=
 =?us-ascii?Q?jpfe0BOTMhb+c5XIe+mzCj3HGEnhApWEjYp3UNyEdADiy5tfb8MUGPyQvHGu?=
 =?us-ascii?Q?UDsnM0JUTX2Jt1kJU0thSx3VkbiOZm/d0rjwjes/vx81iS3UrXweDYvI+C+q?=
 =?us-ascii?Q?QPacypjiD/ZCJ//Ifdt7T3gPsj71WS0JApE+j0unc6mioGyPJHQuRsxqesmV?=
 =?us-ascii?Q?3LUR5BXY0rOaAgAc7Tyi5Gm8R77OYXHzy+kJoD2y+LSrSsOE4lc6TOhV2LaU?=
 =?us-ascii?Q?Ea3rSX9pRrAo665CXIqa9vyD4/5+LkQQC2ePj3Ol4lqsE/bXNL/kS3UNbkeY?=
 =?us-ascii?Q?UbjKD9qmu6HF4aTtD525rwqjVG+fI974Vsh3/Fbc5OLjXnqbU2KfYQUcYcMM?=
 =?us-ascii?Q?5gxPO2D0bLxleqzjeuO3FquxWSnLOeNKdQXvBTyIEx4gIBW8M2f/sSs0j/eB?=
 =?us-ascii?Q?WfPmNV8LMJSV4NBcJtAI9lLr9SdjmHVFXS7ADa0ZEErqtCY+IcMD2yasQswQ?=
 =?us-ascii?Q?+PV2olio0ZV8voLQ2suEZEwFVdnf7uSQc4FC7gLEGmldeuk2yUFFf16sGrB4?=
 =?us-ascii?Q?AGulSiHiyCgMPHhFoLWcYCWeUvPmtP8zoPJlqEwSJbwihjI1mvTJ2GIf4Kz3?=
 =?us-ascii?Q?NKKiO6XKN5UVSLysxDSHIB+xIXREArh3J5Mr2TSa7ktq0OpOyvwu3Wee0Z49?=
 =?us-ascii?Q?O8OPD+mjiCNLNNORxH/kik5a5goutUBEh0EgBSNWYYyqBdnKzO4mJ0ol5GIb?=
 =?us-ascii?Q?G5oN5dTzYsJGgoGIGxo+5cu1VP1rpvBt8+AtA2PrxhpOusUQO3S+O0neXoft?=
 =?us-ascii?Q?zdJRE/VFtPaak6Nv2Iq2W6s79KkF+R4Pq54WCkc/QMGkALBie2Z5/vscpVLo?=
 =?us-ascii?Q?BZCOLX0SvUFDeNCjX+s6/FxP7rXbyf4nxAjvxPveBirdyRAPgUgdxcvqKQzO?=
 =?us-ascii?Q?zQmCd/YXIhP0w2fwqJXaZMTaM8HLjCPxYKp0JkNfceurIPObXZz4MQSUTNYt?=
 =?us-ascii?Q?oebv+buj+c5tmiaKednj4pOyGecJ5lcwhivfrXtz1HsrPXy0NA3uYHHtQ5Vu?=
 =?us-ascii?Q?quNPVo+Ve+toMVYOwCKRAdfPTOjDC5S0KdG51WjtlBN5AYsb7x2feLLu2iXt?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85acac7a-6347-4086-d313-08db57b66d93
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:42:03.9516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8dMTPPiHae1gE+rQD8w9beeK31IlEVcI1vJzehYD+Oi2qvU3uTqriQn8v1XpO/SQqXb4LAjzhLswvaOmSLrRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6784
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I would like to be copied on new patches submitted on this driver.
I am relatively familiar with the code, having practically maintained
it for a while.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a83be7caa468..e9da431fbdba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8164,6 +8164,7 @@ F:	include/linux/spi/spi-fsl-dspi.h
 
 FREESCALE ENETC ETHERNET DRIVERS
 M:	Claudiu Manoil <claudiu.manoil@nxp.com>
+M:	Vladimir Oltean <vladimir.oltean@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/freescale/enetc/
-- 
2.34.1


