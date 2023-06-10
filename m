Return-Path: <netdev+bounces-9840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2212172ADDD
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 19:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B8B2815AA
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 17:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C971E50D;
	Sat, 10 Jun 2023 17:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198723C5
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 17:49:20 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2045.outbound.protection.outlook.com [40.107.105.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0A33598;
	Sat, 10 Jun 2023 10:49:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eV8KIzulkrY6EZUnlvR3o0ZBj6S1H7hZH9TwFrYnb7dincWVIbBblXwSzHoNyRpUCzPipWREAbPGJkyoX+XuL2ERtog6k2Qxn/u4eJMRcaV9GsmtzMo4B9ySdseu7/yeUQ0i8I68nuQj/iy6DqUHyPbJ4HvuBE5Ke0JTgBWmOQeRW1ne3pJs7hPbevB9LwO3ojamzglSxRH4m78oeCJ6bC6mBO1LbLaamIseFFLveVGlxbQmO9wQPJRw4hxSm+kCngBiMj3vOu6roUDu6dMXShpwJlohIYSgc3AE/aRC9pODWuneRyMKdgDQNjwf7C6L/oISe3kJzN0rNQqw8PnlfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7ygBqSsENyI6AsrNVqAwcBO5n9Mu8wEhIApx3UlutQ=;
 b=LCrJpil560rPW7ddzbefGgG5+95bSQ8+N1Mke25ZLm/JnRWodN/2YEo4Ft9yg5xHhvkpvqL9tpoUFv/l8iUU22jaIrZNG/tb3rAMdRuJuaeNMqczVIdSRxav0TCrxOeeiMRp01cgxF802KVRr+xta6TSrSfvxP1DV4NkgqQ8qTRQXE589eXn3/s/meeYJ0fRlZJPEgoiiSgOttlAuTbjchnQpUv9rHP7QtC2oF8jvuOJL+h+fttuWA1EgqWSiVXWmhD0D49jpFsjwW3vZnXgdCz7I9iAiQimURJJzHbzV8b6qRKjqBZnU3MRbICCxyAy9t1LOHwHIzUWGu418WbvMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7ygBqSsENyI6AsrNVqAwcBO5n9Mu8wEhIApx3UlutQ=;
 b=DtwnbuU59jSgBA7IK0Ok5gbnsh+AjZXBmyWTuhbdvjM4pGnGbBXZ+K6xvgHD8ljYjKfMCe6hTTOMIEnFLcEHNwt1bOiKZ4bX3NGJBOpjdXkRVmeUNL8Or1WNZSlp50bUijraqYa1/evvA0mdFtkiGXCFRXYc3aq1sFN67kT4d0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB9067.eurprd04.prod.outlook.com (2603:10a6:10:2f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Sat, 10 Jun
 2023 17:49:14 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Sat, 10 Jun 2023
 17:49:12 +0000
Date: Sat, 10 Jun 2023 20:49:11 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH RESEND net-next 5/5] net/sched: taprio: dump class stats
 for the actual q->qdiscs[]
Message-ID: <20230610174911.vf637wy2fwjvbfvi@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <20230602103750.2290132-6-vladimir.oltean@nxp.com>
 <CAM0EoM=P9+wNnNQ=ky96rwCx1z20fR21EWEdx+Na39NCqqG=3A@mail.gmail.com>
 <20230609121043.ekfvbgjiko7644t7@skbuf>
 <facdfceb-fe2e-795b-ea89-1b67478eb533@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <facdfceb-fe2e-795b-ea89-1b67478eb533@mojatatu.com>
X-ClientProxiedBy: VI1PR0902CA0044.eurprd09.prod.outlook.com
 (2603:10a6:802:1::33) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB9067:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff138e3-c633-41f0-d043-08db69dafff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T+f9NfvBAHyXUxpx+DBnTXSb4+kOnvBg8G3BRQ+Bpg9oZmhqvIevKxdonUOAYJjlnP27rlRC6giZRbnUGYcQGsA3gNgFGtml1wHdq//sJ9kdzwiw97sMAA+ygx7Lm+Hz6xsVd7S3gN6YocJrvjT1TIgfYdUaZx/VRSmD0VlN/VNr+xjRkmF44Twi7QiHH66rZNtfwi0n2DBQd3lqKlPqfGxVg1FPrajDpXk2Ln17HmdUiD6vS+XefHw80w2HYpgAa2tRv2Opbu0r2GG2wXSTih7uC8Sd8O5HhT/JJTO1u8crzz5EjWlrcXkk32kAgtXTmqE2RYYMyggSRotg7U5OVuXnQn8gzOzVvZCPlwnFe3zniTthEOLJmD63hWgLfxBS0GX7GygwtFZHBwUh/PCbUKd+aS+ajGxhPRMIE8kjXdsmEgYVDUcFKdBs0MJxwCvcpj1hB3HIGGaRNFW3TLPXWWENIoXGayk77apTdBr0i0U2zwO3484HKIVOEcqgc3Hp1u+zZyRZwm0UEXkF99MdGeRNLcVSx+nR7EuVz7QLuGcJjfVEARBaHN64h5O97Zf714EYcd9NYylXD+/CDpF5bQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(396003)(39850400004)(346002)(136003)(366004)(451199021)(44832011)(4326008)(66476007)(66556008)(66946007)(316002)(7416002)(41300700001)(186003)(4744005)(2906002)(110136005)(54906003)(478600001)(8676002)(8936002)(5660300002)(966005)(6486002)(1076003)(6512007)(6506007)(9686003)(33716001)(26005)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gJ4zC9fHziGoLjs1iwCkPDifHqRdVY7BWH+G2e6XQKRz3wYfZ06x7y7YskjA?=
 =?us-ascii?Q?3lfs3xp0Q+jF9EvkILQgqa9Z5GY5QANp74tqyK+PvBc9vwqiXvwj//ChfiRX?=
 =?us-ascii?Q?j48SbkLFBl4gf1muKFnVSUdpDUZmsvoNPrZh8QbbK3s10Qsa+kar/K9azQYr?=
 =?us-ascii?Q?yzuPaJiTt4S2e+A87+6/j/V4iXjjTDGx69JsKctlqnjn/pVJCeH6czAb9Ohx?=
 =?us-ascii?Q?QNOELYfYaDsk7IobqQog/Ud3sNxIiftfXu4VnPzja3PlQ3eFVmVYhlcOMWVM?=
 =?us-ascii?Q?hMaoFry05Ki44sIEKNpexb8e+GNtzlp8d0YZq4BAB/YxYzaybWUMDuezhu23?=
 =?us-ascii?Q?/ETBzFs5Va+PtjcPuxGxSim6wo6hEYGG6Ne+iiPadE3EtWhIdENHLDcFELZJ?=
 =?us-ascii?Q?/qHuJDFxEq7oTg519XBJxAxJ0ft8AxLeAfs+rFC2vMRiXNNV4bUxssb4vke1?=
 =?us-ascii?Q?gCVY8dFJ9O8POPw6px4ytWy6pGXTIdg7x7VQnowf14UFq1soxGqT89X8VKFS?=
 =?us-ascii?Q?meFqXm0bRDMbeJ0yoIzq5foS8CNTQ2hYhH8T8SVseYvSv9n82moyhOGyJyEg?=
 =?us-ascii?Q?K9Xrdrld20RkSxGT79Xn06CzMQwEENxr51MZi3r9DH0pJssvYRGIB7ErUbmQ?=
 =?us-ascii?Q?h6ZzJQvl/zmXR+Hx8YHj8+ic69jPJJ96CUQSeiud2iHTMQZpAdQDWjrgN4Pq?=
 =?us-ascii?Q?a13UJhp0KN5slRqYJ9NNO4k5QLVVecqd7nueupmlKC3inOyWV0SpcMUl1IYd?=
 =?us-ascii?Q?U+iNYRtciU5fXIDR3Rw65SkkvO/KsxWQ6l33u9BFtnN28ynlfbJjPPrICYJ9?=
 =?us-ascii?Q?VabBPNMS2E9scWlClj8X4ZPgr6my6ZoP0N3Dw263mpPett44RTRBmcu8Sgr/?=
 =?us-ascii?Q?xy5fcPoS59GBFxAq4i1KxENo7catE9nqSavZX7Y3lZarW3T8iUtfg6rUUBUW?=
 =?us-ascii?Q?iAPpnNwfAJbIKq718eHJok9Cq4VfhjhJwhjVbuUQQ6rlH6fJxr/f8X1X8m+1?=
 =?us-ascii?Q?2Eiey4A5p/bPiGhtLUV6USIDiPnphL7FkTjXLstc2bBFrN97geFzXqwMivvl?=
 =?us-ascii?Q?vtvft3aRAqyhhLezI2Z0cwBO8pCKGE0R01G4N0exLmDPsCKDkAfe0gDvE4rJ?=
 =?us-ascii?Q?fSKq0kxv+A8/djTew4Iterv5HxgtDnEKIco+0USJOY7lnK9Y+5lZLAOS7VUJ?=
 =?us-ascii?Q?5P5YVTP8TqpCVkQeKnJH0MgErEcaJzgMvf52SylCTsIFTJHRdE/QheohyhQ7?=
 =?us-ascii?Q?yLN8WIrVURmCaufcm/sBkKlP6NV9EbaJjJxKCAvoThcZG7hL0cs6CJJntQNR?=
 =?us-ascii?Q?yGsyzsQr1wdo6VfoHYSrt1Z7ybXbs5Rrywo8OfRjdD8om5KZUoQzddhmYkBG?=
 =?us-ascii?Q?j6KvLNHx+b8kdv4jrcjuTPUJMKGYvfeqApGGNe4fOKcMYNuMyNypW01tgKwP?=
 =?us-ascii?Q?k0Z6fX9fAfcSAiHqqS5tc23Kr0v1CRvcuDf2JMA6Tmyzi/O/tKWiAlVJ+MVV?=
 =?us-ascii?Q?V44w7s91GMKH8KhNs0ZPcqkx9A1/ybHaLYITqLTvpu8lLsZVIsRa6XGnfM9u?=
 =?us-ascii?Q?7gQzY1V1PnhRR/7RXtmZmmi2wvlZLSL305GSeDw1nGQ/SAsWwTFccKtrpwJ/?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff138e3-c633-41f0-d043-08db69dafff0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2023 17:49:12.3609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDwa8pHORNNNc5MEET+f6T8YCkeAG9WsH2y1MUAi9PlM08NfDVXjw80I4j8Ck/vYjViiKX4RldYtkm6unGv1AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9067
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 11:56:35AM -0300, Victor Nogueira wrote:
> You can tell tdc to run a specific test file by providing the "-f" option.
> For example, if you want to run only taprio tests, you can issue the
> following command:
> 
> ./tdc.py -f tc-tests/qdiscs/taprio.json

Thanks. I've been able to make some progress with this.

Unfortunately the updated series conflicts with this in-flight patch
set, so I wouldn't want to post it just yet.
https://patchwork.kernel.org/project/netdevbpf/cover/20230609135917.1084327-1-vladimir.oltean@nxp.com/

However, I did add taprio offload to the netdevsim driver so that this
code path could be covered with tdc. I'd like Jamal and Paolo, who asked
for it, to comment on whether this is what they were looking to see.
https://github.com/vladimiroltean/linux/commits/sch-taprio-relationship-children-v2

