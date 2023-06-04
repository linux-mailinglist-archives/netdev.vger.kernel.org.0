Return-Path: <netdev+bounces-7745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5977215A7
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F86728115F
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3C03C24;
	Sun,  4 Jun 2023 08:55:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B63815C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:55:09 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2067.outbound.protection.outlook.com [40.107.21.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE098DE;
	Sun,  4 Jun 2023 01:55:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YM76X41ySPTJAO1nj+3h5ohG8SKGWmRF01508Zsx89EO7BIOosi0xuCrBE40natMq0k7DMNAKLPVD3Ay4OK70IBc72wgXPKyoVr7uW4laVjWTw4QLSqFyvlmFKJlgovYrXa4SQXHqDqz4Mz/jgDE+QUUaO7sw0pse2Vyz8yfhd2xwcD2rCSBwD3ZTssI2wgLXyOnkNPgenhq6+00dIrvcCrgVXyg7JmlSDKBdborUM+kHb3cy6u9tiemG6EEZFmIgvzATnkXpK2iyY3oO1W8qFIc83MBZHRtlgRJ9xwYBtYcGrKFaZc/TwBHxLyQEDy4x1pRMxkYtsrllOtg4G2tVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVYttsFzMyXiLpUlDopX0VWy8Q52QzilvYMC5DUnBa8=;
 b=MhSbcQTbaqer9F7GAW95GGSIhlvrOlokYs4/DEBZVCnMmrmYpnE/lRwtN59VSoEAsQ7JEa2P/PBHdanrBuubg3uLBKMyVbQQLcuwUY5P4gdilcXIMEvDTKxM6rrrZhJo55UeOYoF7PHYyJvsGqSoxeyFJn35pnoTLNowFe8+G6xHP33d57BXgxd8P9NNNiGT2B7Qo1I9XZN/kGVAWdo1rWill9VfaYnQKfsKP/5MW85UScSplFyMy7F/oRzybW1onVhxCY3NZLd49c/iRMPzJiyAiAykqd9noWC0AMKwVezzr0DXChcF0rmPm/AC8JWxXHDI5/1u+uKNqlBN0VBj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVYttsFzMyXiLpUlDopX0VWy8Q52QzilvYMC5DUnBa8=;
 b=f4PdjxswpCl+qWSBU82V3MU5saSpOq9u0ib3o8WeK8rpxsaqBZXWd1fD9yDgH8Vl1UM/9H8wnydPbpTaus3PfdIYyjMWAF+F3KOLud5ice/OXxX+8pGQ/639LB3Cpaps0OA8uWw9FGZfHA8LqMj+rbsCpayb48shu31UWBfFUig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB7618.eurprd04.prod.outlook.com (2603:10a6:20b:2dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 08:55:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 08:55:04 +0000
Date: Sun, 4 Jun 2023 11:55:00 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jianmin Lv <lvjianmin@loongson.cn>
Cc: Liu Peibao <liupeibao@loongson.cn>, Bjorn Helgaas <helgaas@kernel.org>,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230604085500.ioaos3ydehvqq24i@skbuf>
References: <20230601163335.6zw4ojbqxz2ws6vx@skbuf>
 <ZHjaq+TDW/RFcoxW@bhelgaas>
 <20230601221532.2rfcda4sg5nl7pzp@skbuf>
 <dc430271-8511-e6e4-041b-ede197e7665d@loongson.cn>
 <7a7f78ae-7fd8-b68d-691c-609a38ab3161@loongson.cn>
 <20230602101628.jkgq3cmwccgsfb4c@skbuf>
 <87f2b231-2e16-e7b8-963b-fc86c407bc96@loongson.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87f2b231-2e16-e7b8-963b-fc86c407bc96@loongson.cn>
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB7618:EE_
X-MS-Office365-Filtering-Correlation-Id: de2ea75c-1825-451b-23e3-08db64d96363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VyOS81+gBKJgsD0vdnhW9vkxW2eEYiADJzbPnUyl6jiXMhy5paRqN3HRSc9IwPhUz9VA7QAsS/lJkEo0571bqk8d2b5uPgjspriAc/2oGz/X7rZytvZpuO6jwq4io6zBYrOip9LwzjEUY180g2NwoB5wTYck9pZiKc6j6oAnOgtsT/xgKKbW8kbk7xHg9w2qRafAfxWEHVHe801lHQxClB4SeaUxCkKkvWMka5298dwMJsGiO+sXdXBxVL08HLUs6Hay8k3dil6GWqfYHQQ4uComtxF7sGmO5hxAHg3zoWqOv1NmmjmCj4TCjyowX4XU5NSu9C8Lm4kNGiIIty6cojHqjH4119l7/x/fPOpY1FhSa+Az8hwxWB09CWJynea6PtM0JalhFnDvUNmllJkL9ccqhXpj/IXqDG5ArvOZ/WP4U3ahjFytg2kaqC/pFoxZfBf4kspDZK/8CDJ4tKuRSbkQr2p94dIsfS7deaSsDlw8+1rjCDse0dZ+j9xPRPKhkImI7CGOejd4dScwjyLY3iCw/MboqBS6EUU4b5pGwB7QOj08zmtQPUTeREtKIW3o
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199021)(54906003)(478600001)(5660300002)(8936002)(8676002)(44832011)(7416002)(2906002)(86362001)(33716001)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(38100700002)(41300700001)(83380400001)(6512007)(6506007)(1076003)(9686003)(26005)(186003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dDsxJmHSMo46tnRSanYbW1mBv5yu2U/nXD4+3z2gzcQFL9vETbzgJohcXP02?=
 =?us-ascii?Q?WwwwyF5rAZAZwsXXVvGDCnHBJ3vpDuAglZnCSgJyQV1aLTl6N8/vCIJo8I1N?=
 =?us-ascii?Q?xggb/TgbB/Bmw2bbW7SnYgbMiSqTgo3hGOTWyINIMpBk8PQdR942hRr9aRCT?=
 =?us-ascii?Q?bw8+4wdneLgzUvMBidL2dKInICNamwdZBcTgdDEY7ZsmB0Z0iflGwQ+w9Sng?=
 =?us-ascii?Q?4MxvkTIxIkrUK9Jq0F7+I4DaPgLI7tKmcxJRTuBvfR8edAL1IsKLkhatiup2?=
 =?us-ascii?Q?l+VQoZU2mMiv4plw3okyrewVZZAfpje2GDIYm0ImFphnB7kA9WWb1nBv8CWd?=
 =?us-ascii?Q?F1jbwqlOV40d1tmWUl/vF8Zq24iWhWi6d2ttwXe3etQRgzdhnHn7vODtcOfp?=
 =?us-ascii?Q?uH697DVlmZdEaVA2zQRM/Oz5sFis5Bb8Hjhb3JBqQrGGggnSQ/YYO3jlTAni?=
 =?us-ascii?Q?RQo19tJvjChdHyn2qUhQqZufyA90Ke+yVKbuzzvsoLUQMxg+j/4nOpj+LMCL?=
 =?us-ascii?Q?Fv4FOhMwhTKtRyXULq9IG/WLQHog+Xsix7pAXeKHXo8tFgwqfBHHQWzNhRx9?=
 =?us-ascii?Q?mIAtalfrP9zJOOjuFFns/VEp7BaDHG4nczGHoOZ8kihfy4rXcx6GOG+YDrEE?=
 =?us-ascii?Q?N3hPLqqULKh+ImTtUmCtdqqXMgFAgbjapHr8M2QY+bxGxQM9s3kXjOaQBcDc?=
 =?us-ascii?Q?t3ITF4/5DSyqSFIH5ONiWm3gEKAWEOkiEjwnXd3Ji0uaXX3PHrNM6qXvaIHJ?=
 =?us-ascii?Q?wpGhFa1yQaxu2vu8gbavCNLKeuysThULKSyy64faQWhShocItTv3EmevpFDs?=
 =?us-ascii?Q?apw3JBwEbMs+qiHVAvT5WYHzk6YnDnp3GZ/8xFcffjMstjGWaORHERdtZRb2?=
 =?us-ascii?Q?bfj7x+mAPI+x19kLrS7bh+GcvI+GSGl8Aom5ZDlKLKES9T04eLOweDLQz3Go?=
 =?us-ascii?Q?dkXXcPU20ML4MqrPo6ktAjOfjKpmXWfmIetH99xpoWZk+o9bWBBW14d2BETw?=
 =?us-ascii?Q?aCSQL3brEt/NmpAtDoT8o7xgq2/ImP5rnplB8/YG7m46B19Try4nPLovvSPD?=
 =?us-ascii?Q?Ayc+vZV1263LiydLC7F2fNJHYFl+qZ640GIdCQs3SWjTwL8xna76bof+XEpI?=
 =?us-ascii?Q?1/LDTPasloZcrh12ciXatEFjBpXmM83rcj4eAkg1f/7iC3QGPw8DtiPk29sn?=
 =?us-ascii?Q?9hLXTh9idu1zh7BUa0gb199ceSck0k3TluzXMsPp3u2pWcUdYE0dHc6kCdFl?=
 =?us-ascii?Q?qc/BwAZOVDA2ynkgYk7zhZryudW6fesKb2MD/sDXFdB7lda27y8ku+mfFjr7?=
 =?us-ascii?Q?HWVdycmURdCE4JqQsjFdVDAHfaJhFVKSiIx97gROF24wq0uzm++a3FlOaeNs?=
 =?us-ascii?Q?k7W7PL0IC0nWiHedUPg3xw1aje+/yP43BfGRnBbQvLDM2ANZiFdD6eFVj002?=
 =?us-ascii?Q?Dn1gYF/2G+YWNnNMM3iz5a1/eK0FN5lqDNEyR0WsgXJt+LKkeNWwC9bu0C72?=
 =?us-ascii?Q?fMA6/TrFwaoC9/TbGW4HoU5YLK+t/18H0VCBDZASFhMM5UMoHy4YjDU3IROt?=
 =?us-ascii?Q?MVZzOWLS58KNWWU5VQ5zJVY1ZAGnq36SrGf3FAuz657WomEbqe/TgZ5FQo8C?=
 =?us-ascii?Q?ew=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de2ea75c-1825-451b-23e3-08db64d96363
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 08:55:04.4484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvKje3EF9+qiMbOnUBVGWlGko6DWlSPJipJw4xUmU4HSu9Oix5MhhtuEtHDnt0IuKuu6Cv768fP7uavW/OiXGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 10:35:50AM +0800, Jianmin Lv wrote:
> > How about 3. handle of_device_is_available() in the probe function of
> > the "loongson, pci-gmac" driver? Would that not work?
> > 
> This way does work only for the specified device. There are other devices,
> such as HDA, I2S, etc, which have shared pins. Then we have to add
> of_device_is_available() checking to those drivers one by one. And we are
> not sure if there are other devices in new generation chips in future. So
> I'm afraid that the way you mentioned is not suitable for us.

Got it, so you have more on-chip PCIe devices than the ones listed in
loongson64-2k1000.dtsi, and you don't want to describe them in the
device tree just to put status = "disabled" for those devices/functions
that you don't want Linux to use - although you could, and it wouldn't
be that hard or have unintended side effects.

Though you need to admit, in case you had an on-chip multi-function PCIe
device like the NXP ENETC, and you wanted Linux to not use function 0,
the strategy you're suggesting here that is acceptable for Loongson
would not have worked.

I believe we need a bit of coordination from PCIe and device tree
maintainers, to suggest what would be the encouraged best practices and
ways to solve this regression for the ENETC.

