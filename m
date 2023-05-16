Return-Path: <netdev+bounces-2961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38596704AFF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7802281666
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6922E34CCE;
	Tue, 16 May 2023 10:44:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D634CC9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:46 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2079.outbound.protection.outlook.com [40.107.21.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AFB3A9C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 03:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=As3wNXuzfFFhA89aaxXHiRwh4Fbq6V067W17EzX+ieFotg5TjXlDCoDKIh8Ol78P9W8K/2IyGAig8ccMOCR4SyOmgfbsRzRSe8yWmNEimfnov0PZfwsMe7lWoYuzxJWXQDftfQ6Ti1ieQK+oF6ibmV2FTBkw2bxQICcNmtcSnuiSjaEKxIJHa/y6FspvQIxmgJlavD6UoX2jBHwkeScE/J6bomuzVfquKp3bR0oKIXm8/qNePHjy9DigMXaCC5lIxfgvnlmVstGPvjcOh85jJI2+v/MmNShRhbOZafPNCoDUQ7tXTn+qXdcdmibqEMLfZVGWxNWrCTO1KNEacGnKCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IldUzgigZGpLqvOtuZQF8FxGmnj4lSM0S4waVzxMh3E=;
 b=bKUUFRioBteWdSyB0CnMEVs4HhfLGnsnZfwQX2bT4uxZsPtfXUWahhyyPqP52MEPGkTLB7hCi2aZCFXhkQ2ZgpzN9DK6vHOYv8wp+ggzEO9TFy7D6q6MfxGHjaWisfV0h3pEXkFW8ocredYQojeZzKsQ6Vnl/J9kIPEZd+aAHuIe65g1hqvx3rP1j8NJj3N96eiV6klhUcQKLfQbVO7KujJSWshivFHj24dXUOKH35t6U5uSUNAAmcsaFFY3No5JgeEHn61RxS34gbxKnykktreMcYA/0MRp4xdaEN9L6QAvn9ICiKzUhizWQwAizx2PNuMR3LkDzYLtCHyjlJGvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IldUzgigZGpLqvOtuZQF8FxGmnj4lSM0S4waVzxMh3E=;
 b=W0JTb3T23ACG0KONrYo9g2b2zLcsvhdJQBbTH2isfNFefGQ5+I1OLsKMnSQJEsFXZJtLZ2tWHH0HzPhMf7YXQ10kfL9jVhC1VI/mvNNCL4i9ilsbCW0hb20+sz1KGRtsfdE+61Yw5xj3bLke4UAXF0lLXcwO9Qv9fBvHQR3j+gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9962.eurprd04.prod.outlook.com (2603:10a6:10:4c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 10:44:32 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%5]) with mapi id 15.20.6387.032; Tue, 16 May 2023
 10:44:31 +0000
Date: Tue, 16 May 2023 13:44:28 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org,
	bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Message-ID: <20230516104428.i5ou4ogx7gt2x6gq@skbuf>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
 <ZGNEk3F8mcT7nNdB@u-jnixdorf.ads.avm.de>
 <f899f032-b726-7b6d-953d-c7f3f98744ca@blackwall.org>
 <20230516102141.w75yh6pdo53ufjur@skbuf>
 <ce3835d9-c093-cfcb-3687-3a375236cb8f@blackwall.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce3835d9-c093-cfcb-3687-3a375236cb8f@blackwall.org>
X-ClientProxiedBy: VI1PR0802CA0021.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::31) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9962:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df655d8-38b5-4c27-01b6-08db55fa880c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0d/ZFjTWgMy9mM0W24J0BT8ovmJcRiRyE5VGpUM7f1EsMF0fU7C0FMN7LDeiCmvzjC72+c14Gi1WXv+L5g3M9kOduwVqD/5EAhBER37+UEafx0vtV7USs+CEJOaSzvDLeiEwcPeasdqyGRhPBOX1PyLkn7lisE76eaJdhj17oQvEee4NwlxsdEFDVXA6wvjzLBrojUOLbeHb8lYFCyQW4w0AMuv29rNXb9D7hk/F+YY7qU4gUeToPCZSxvOSWwGuNHPzjBsmoN7hg5gFLzPXzk4ozj5AnfukHQRS6jEdULcfG0s6x5FT7L8UQp86yYwpEQLbZ2I2+/+rxkBsSxrrPA1ZID6Tb1zKCPMg2WgfwRBrlSdvYZ6vDvF4we0rDhrSApcdw9uAkrvQvw3mu4yI/4GkqTKBqyPd9Y/xtI4xI/ZTewGk4HE45lxXyHfokHM+ROH4voeKotwa8ppMqXgap2NwiCcX1jPSmE5QkvxaBsLaUr7LAZ86zzAveljZVVVxh7QqzniCrKC3GRu1SaOtwY9EXxav+9SMBiwjvKowJF4ja3ngQRbC0HmX3VKcibhc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(86362001)(54906003)(478600001)(33716001)(9686003)(186003)(6506007)(6512007)(1076003)(6486002)(26005)(6916009)(4326008)(8676002)(66946007)(66476007)(66556008)(83380400001)(8936002)(6666004)(41300700001)(38100700002)(44832011)(316002)(7416002)(5660300002)(4744005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oXYut8PQgZvlB8xISyOr3cVn9RS0xinYL0KrY8Ti7HN68DqRBKViGw0Vmg61?=
 =?us-ascii?Q?G1UQZH5D/g5/1AqSc/Z0RtXdkpGMVkHxmOi0kOoH0Q17LehBQOBLER8WA3Hx?=
 =?us-ascii?Q?JVcGYHH4RtzQXtjJ2zWSDKaQaTOjm335LRlZgcUf4GJYd+QGgpvp4lfNjVN1?=
 =?us-ascii?Q?kcacfIAbyzJd6b5vkw/J6Lxd1GQa45QuGGNKxb7gjzODC649LWrQbgFAJNTp?=
 =?us-ascii?Q?hJogwJrvEtLj+HnxAJ/qrCHiO6BF9PDibtkZXReHQD65kCe4kfkPI7jSgqD4?=
 =?us-ascii?Q?RKS78stTwXhyc4IrBuJQA5aExdrCGwtT+1NO0icFV7B1IExhIDWidzuEh15X?=
 =?us-ascii?Q?VxBrCqPqinD29Drrpmqjue1mT1CZQzNuCrzl65qNpNtZ7UY2o1yAZvA3y1Jq?=
 =?us-ascii?Q?QRUhsPoNwlMSsQQ75RBdQbT/hPFc34AWNkE8/9JPUFCnf9dhh0uoqA6N5iGF?=
 =?us-ascii?Q?lubfYag8gXPAphatqsHkelsIGiuUiq86Rgy+ge++AyhY6G5Rl82+sddNl8+t?=
 =?us-ascii?Q?3IRGu9ETzMdj/c14ZQgcIFmlpFkAFrUqdMNmuM8WKqh2rp24jBa/LtYIIZbg?=
 =?us-ascii?Q?ERuL62C00/xP/AiJ5ohCqf1t/j/GdeB8K0R04llanviVidImJEHSfllpsDWe?=
 =?us-ascii?Q?6U8oFneerP9k3s4AFpbRxx/SLzR93eq1KOLDIxFYmxLZrLkNJqzzui/DbA7S?=
 =?us-ascii?Q?SdSizi1lP1bsVVleMy/5Hl069EHkdonyMyS/mxr/+nmZdILiiDY/enL+Y+53?=
 =?us-ascii?Q?Okq87VfLP6AadRg07p2oZ/CAnWdNxSLtOnKZgQZz9QHnTslgraDtU6Te5RXO?=
 =?us-ascii?Q?HHZN5UmqXL9UpDIwU5PcMxG6wtXMzfmw8p4PY48m2AA0rWN/7W79YDLZPbwr?=
 =?us-ascii?Q?OQLlqW9LBtMCJU2xR3EwqE/cUj8nuL1McJGIRgLWTciFS2gw5uarnosGPbT2?=
 =?us-ascii?Q?X+pY448GZU0TT4QrI+B/ruVW1fgqlxEniYm2GjxTj6Y9eIzJI2rPhcgq2vW4?=
 =?us-ascii?Q?Yp3KSVp4vjU3WAoDfxH4bDguR0d/9O0hiNaXsLsDPm26eZ9XH3Iu3DjohofR?=
 =?us-ascii?Q?iLd6s5sh86hdT2sbjqZ6zkEGvDBhJa3LTa0vB16oJx5yhax1ejoip0FdP9aD?=
 =?us-ascii?Q?tXQnUFA3iE2DXmZjSaTC59gS9H3I6JG/XSDzcE2YEyz2Ih2ROx0G8d32MgLn?=
 =?us-ascii?Q?4EoOBkqvjeaAooCkuJ8kU0EmammooVOOrYcTB/pMznNOwUEbnYbBAYbhx4iz?=
 =?us-ascii?Q?DxC06IT5QDn3Qr+k28Pq3XA3NPjBsO9w4miHo7STv3crvZEd67J2cq5rVIJQ?=
 =?us-ascii?Q?JvaxjXSUAT9NysoV834/9v6dEqvPjSXmejaE5LzIe+AndDv3SJCel48qJLiE?=
 =?us-ascii?Q?C2sI3BWz+sDw0eFO9YAhURPg5ku/bvQktyQH/M/xQfF20zRoVAWnrQ7j+7yG?=
 =?us-ascii?Q?nWaIetiLFjBLWPSXbXUVng5oO/AeplqIAt2gDPPMZpi9R8h6awqziFf3mky9?=
 =?us-ascii?Q?KjfbzijC5GF6jjoGivPSi5VF8iGlURXSsgIPZxyab+MPRE4tpm0D9hv7gdo2?=
 =?us-ascii?Q?KmE4mlh1nOS/6p5aSvN3ksbFmMN5lNuF/5iGARWNGoZHMFJoFs8QsNrn1Lsm?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df655d8-38b5-4c27-01b6-08db55fa880c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 10:44:31.6871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saobof0wdc08oWbG+2V+R/073EoFdoseFGKFMEJqAe7G5CqCYDRiHzuDTFI0UHQre+P7aafXnSzmO/n4Owhdvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9962
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 01:32:05PM +0300, Nikolay Aleksandrov wrote:
> Let's take a step back, I wasn't suggesting we start with a full-fledged switchdev
> implementation. :) I meant only to see if the minimum global limit implementation
> suggested would suffice and would be able to later extend so switchdev can use and
> potentially modify (e.g. drivers setting limits etc). We can start with a simple
> support for limits and then extend accordingly. The important part here is to
> not add any uAPI that can't be changed later which would impact future changes.

I guess adding a global per-bridge learning limit now makes sense and
would not unreasonably hinder switchdev later on. The focus is on
"learning limit" and not a limit to user-created entries as Johannes has
currently done in v1. I don't necessarily see an urgent need for
IFLA_BR_FDB_CUR_ENTRIES, given the fact that user space can dump the FDB
and count what it needs, filtering for FDB types accordingly.

