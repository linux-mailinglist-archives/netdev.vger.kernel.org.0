Return-Path: <netdev+bounces-8784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAF70725BA2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 749D1280D63
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361C035B51;
	Wed,  7 Jun 2023 10:30:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504F37324
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:30:08 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2055.outbound.protection.outlook.com [40.107.247.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3700219AE;
	Wed,  7 Jun 2023 03:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UokrlG2+gKK01Tk1RZR3sXN2mFsfc+pykTywuDcRa/jlwu0zhEIy63x9VWSdb+m+17orTuiZSX8amQL5srCM0u2yoBJruzf0Yui7Sf1cfiKEUVuhV8kXCeRnHnYWYQArnMvEKnIaNs2gDW4K9AHpzOQe7RS2eRj+bNhy8Yw3EWY9W32W93pLvlXNV5qFaCqyM1GM1/vmFj5aG0wjXRjyhleWGpyACapWQ1e0a8HJONWCTCKJYJcy1VHZWAR/m6lK39Ev+V2gPpLBHb6P4QjnlSnJEj81H9jl8kluD+2Z1FEFaJPYd8f1xTAD2n7ZNLMjr2I5TrC0zCObnEwQdURDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16FEzq1b0AE5tBouwKjRHNaPltVo4vyz9yyvIq30tMQ=;
 b=LO4m9hY2+d3gWa4LKmKHsatz5LurYddvpmHnxL1nEfUg3RPPe1B2KFhs/ER9O1HF1pouiVxTNkfCMZAc7YFj7meL+PrjwST8KIvRqkQQy/7DpvPHD1WuKzDST6r0qkhdiiq/tceRZoePwClIcCfi4w0eBQDWGkU8YZI/z28qtYPXUm8U49OiMlEIEKF2/JETysfzu4AsAghGTlSOUmwk+gzm6nAW8DzyM7ckP37n8laQ94W1sQK+JeVuCQ1kmEs0O6rDmJ4Y8FL+pMZHC7kQgsoGuRVXmVegTXgRRfytGXDBOk3dTfcSKLz1JYsLofysiQx5gASPtcyUrh0jTImLbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16FEzq1b0AE5tBouwKjRHNaPltVo4vyz9yyvIq30tMQ=;
 b=b9OLP8NItVElrZJ2c4hzVE4MOYx/JJjZj8BEKkCizFTPnYGBvAyPMwgflZ9k7cqnl/OKPrVQlhyXqMuR1nLcOF2+tgLIvB9zWoreyH6/IY4IrW+ipUt9sqzYB9goMTir30gDKAMQI6Ly2qvLS05tl0cMwdxOwgR5/9lFTcmBp6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU0PR04MB9561.eurprd04.prod.outlook.com (2603:10a6:10:312::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 10:30:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 10:30:04 +0000
Date: Wed, 7 Jun 2023 13:30:01 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH RESEND net-next 0/5] Improve the taprio qdisc's
 relationship with its children
Message-ID: <20230607103001.p62au4e2cztv5xut@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com>
 <20230605165353.tnjrwa7gbcp4qhim@skbuf>
 <CAM0EoM=qG9sDjM=F6D=i=h3dKXwQXAt1wui8W_EXDJi2tijRnw@mail.gmail.com>
 <20230606163156.7ee6uk7jevggmaba@skbuf>
 <CAM0EoM=3+qwj+C9MzDEULeYc3B=_N=vHyP_QDdhcrNsyaQQODw@mail.gmail.com>
 <20230607100901.qpqdgv6nbvi3k6e2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607100901.qpqdgv6nbvi3k6e2@skbuf>
X-ClientProxiedBy: FR2P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU0PR04MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3239fa-e388-4008-f58c-08db67422846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d0lhu6jK3jB5qGGMdkW3QBwNUNzv4cBmpLgqLDtnwUyF8s0xgk0e4p3IBeyzQfZxvh6kSBgycIqlqFbnbCxRVbX9uOVhsJxfFwryMxFki2k0ugGv6eFPShCwrKei2N64Whm5X39qqaJuJQgM04NKt2IA3917MbgT9jbFNxlZbJ+Tb43ONfnrV26N975H+jIeyzCrKtoW+bunYS1PbRVsQtvVSIcqOVKCqljysyZMH3S9drj1y+hZuu7uf/4lKKSpDsNsIve6qAlnL3rKbQNCUMI/g9Z3UDPfhHa1uBRhAPitwgUgJS4onwQqtIIhY3mZXs8w+Rzybp6KOaZxmNbx44F1s7mKqtKPE2qYKajrQ43cs7m18dT3hTA3RqVZzzNvFsTxPrsvOw3c1pi+Zl+wcRlDwmepLSsQCcWziEIg0c4JdfC3qLzko1Fkbk8I96CsaPve3m5iGq5fnGWhKKPFpb6APi79janjaWPeoBqADjBuHle4MjM61AR1rbbAUvpLO4W9aMmaNcI2bVCW02Htw8RiFBPB6IxFWWP4EKF7837aM9cQ3FCKfOvLUU40SB0e
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(8676002)(8936002)(478600001)(54906003)(41300700001)(6506007)(5660300002)(6666004)(316002)(6486002)(1076003)(26005)(44832011)(4326008)(66556008)(66476007)(6916009)(66946007)(9686003)(6512007)(186003)(7416002)(2906002)(4744005)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P9YEgFi69oaA912wzZ5PWCD98hZHZuKjUNIVUE4328ZLi1QokVUye82YF0B7?=
 =?us-ascii?Q?IrQgkgsr4AX3spvrCTkby5A8nC71BK4lKMDQS0VVa60PWl/eYJCL1SMLzqvU?=
 =?us-ascii?Q?PX4kRhk+fgq5Bh145AewfEiJUbz/VQOIfpgPybdZf6+uOqx57bTNyLCAobsa?=
 =?us-ascii?Q?2pHyh5QkfgGtVs3XI3D2zkYsZ5nVsP4Pey2SN8C9tA+2gpiyBzRi3TgSQUd7?=
 =?us-ascii?Q?vFwnhGqlH6U89iDmaAEJ8PCDZfP5BHekCe/gEg9SthU1AsNNuQyzGmWmOUif?=
 =?us-ascii?Q?fzNX//NQZN+vDOdLrlZoAaWEoL05AtsP25QEHo6makjeAkd7xFxBDWVckeWb?=
 =?us-ascii?Q?uP3jcdVg5hjzB4B/z4+YJbzSVX2XCrK8NmOdI8IgtW7/zmKjddqxS0R4fLaV?=
 =?us-ascii?Q?jrSkQVo7LO+Oy2d4zWtXwB3lclnp4yvu5QbdPWi/K2UbZu2PPTeoStaaL7oP?=
 =?us-ascii?Q?5qn6vWqHitw5WoWq/ehgKqILDjNJH+QrXtcAycx3OtYrx1TG8ZH2igfkyD9A?=
 =?us-ascii?Q?VowZYQzFFnFQp45GZPwK4j/92AdeJQfDHNMl1uBHppS/4VkUW7MX7e6+uO/1?=
 =?us-ascii?Q?qyHnZyIH0MfGXkbAK0a98AuVo/pqxOjQ8sI/Fgshvqi4jZMK/2YOpr+b7iUB?=
 =?us-ascii?Q?WRd0JR+4922luoDIDb/HVvq1OKBAHGJUluqiyq7vrUsXVgL3iZFrS0xDaOyw?=
 =?us-ascii?Q?ubsz5ZGNtP/mv42VWAQ5Xuul3yjIM+qky/pOANLW8J7jZAJxbJzpLUp2EnTY?=
 =?us-ascii?Q?ayDp/DbN7beAM2aQBok4j7radLHkJbwu35CatJB/+4lbFMG34H1tbscpUFFI?=
 =?us-ascii?Q?K5kQTRvmHctovp3+y3l5uL89ZkHde7FCJPvaPBW1UTWYs1up76UTb869N7Yr?=
 =?us-ascii?Q?tGmSOACNDP0xPt1Hn9l6Gv/iMBO0RIYLsnAMFOPN80xsln9tXTearpFrNscj?=
 =?us-ascii?Q?NcWHvSdKJiLZniU31aOwTJkgxw0mPUFW+jeGXWh8A4fElmD8r/L6b4P15QZY?=
 =?us-ascii?Q?8UtCVbJ9LKVOkM7KuX8WKbEx2UcKbYC1HGJZUB/+sLcCzFUUGOMF3hzHy1te?=
 =?us-ascii?Q?c/XPaA8VdBASHiyfK+BoHESzlb7CCB10bO83pToawUDUehxsUgnvg7Xw9xkP?=
 =?us-ascii?Q?D2IIRlnrAmEgkts/9egiB28YPazSflqrGDUbXCxQ0AyWZU5C0qu/uLzahm2R?=
 =?us-ascii?Q?aG7hzBZVDbopPdJhZwSMCGiqpslH5uCriMFxqfy4c7VqnQU+QX08xjnk0xMg?=
 =?us-ascii?Q?OE1uMy2VRzvVojYv62LW3VUzQm1AfNrRRwh3JpKoMgo5FrWmE7uEMgwlcg3E?=
 =?us-ascii?Q?Odj52aBjIth84ie7EN1prHs04hws6ft4gg1o9gEj/2gXInsbwuzHzNw0LunX?=
 =?us-ascii?Q?5qEDE3FxFdO5l3Y2UyjxtDswSmwzhSNadPdlXS/bjOFMuF2r1Ck0FKBFBAo4?=
 =?us-ascii?Q?pf2W4+DMEAdVScBMSoO4y5lWD5bQdVhrc50fou2gB7+M1nS78WN90EzlQHUB?=
 =?us-ascii?Q?rwnguifSyr8TO2yBoEIG86r8CLvPVm36R4C10nJb1uHI1hTfvOaglhjYEcAS?=
 =?us-ascii?Q?1RzY8LSehEP6aH7z57KGK7Mu+8g3KAzXhKyoeNJq1TRUzVDHlaBQNdSRb2Ms?=
 =?us-ascii?Q?vg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3239fa-e388-4008-f58c-08db67422846
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 10:30:04.5899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QA6dZ27bOxM+oLGfCzVbrK8r17N15mqVYcUhFCWqMkY56TjNU5yvH+GhEgq8ZkPWNNyKKpvp31vu+WcX/t314g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9561
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 01:09:01PM +0300, Vladimir Oltean wrote:
> That being said, a non-offloaded cbs/htb will not work with an offloaded
> taprio root anymore after commit 13511704f8d7 ("net: taprio offload:
> enforce qdisc to netdev queue mapping"), and IMO what should be done
> there is to reject somehow those child Qdiscs which also can't be
> offloaded when the root is offloaded.
> 
> Offloading a taprio qdisc (potentially with offloaded cbs children) also
> affects the autonomous forwarding data path in case of an Ethernet switch.
> So it's not just about dev_queue_xmits() from Linux.

Ah, no, I said something stupid. Non-offloaded child Qdisc should still
work with offloaded root (shaping done in software, scheduling in hardware).
I was thinking about the autonomous forwarding case in the back of my
mind, that's still problematic because the shaping wouldn't affect the
packets that Linux didn't originate.

