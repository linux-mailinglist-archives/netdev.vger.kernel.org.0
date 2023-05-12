Return-Path: <netdev+bounces-2123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C231370057D
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:29:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EB43281767
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D60BD2F8;
	Fri, 12 May 2023 10:29:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB40BE5F
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:29:36 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEE9213B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n67ORYbUYK+1QMCtLhJOUCr1HXrFkdSckqIXg4b8ZCdj5iVjO6ZxZPX8tF+jtfG+yr/hM+DhIsd3F0glTWcAdZ8mPJDtz+uurtedrgjV61HimE/oc0jkise77hLH0nuz4w8O2MuO0vhRjou71UPZVTVvQQ6vRcbOhn0G8/j1M/gQ9CS/6E/ZlpNlqNBsQISApy3MjPiwYzlDQwb1UnhWu8yCjOEQj8wTUhT/S5mbRZTovydtQXoVWvuwL1o/JmDnM9s/0xkLv34DRGRFxuVF9fozIsYznC50TMeKLUATMM+aoF+bajLc74vhM3lrPOa7/7i/e3JYe3+o4PH/BiNagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/Uj5ns4r8gSyWJNVqkCyrrhFDODe8aBN7/Q671jAYg=;
 b=N7sGaMooDw4wUtXpICOLkFiH+uE2QfE6gALIwKtcWGxiSCa221Kv4dzjF4mCYdHYxBrSzsRpA8Og4OzY6Fj+dqFqWLSryfIYGZ/+TrefYfnIM4XZTmjwO7nOzTZw4CNCRoci/jjwK2XOCDPm7qozYV5caBcmT2ibHx+OF7w9+IR188DEvFMBZ3QhoCgTD7lG7BAyp5QByImeWw1rdusAFiWuBd4cYnctVp+RguJxxrDoeqia8fDkM5Onl+3nBT393cEYa8Y7o629ZtodPUmP9DDSNb3b4ZMUue57xTpdTe4iaMNH+yMkf4YbtEVIQDgVnwozJDOxjXH4cnZJgikosQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/Uj5ns4r8gSyWJNVqkCyrrhFDODe8aBN7/Q671jAYg=;
 b=So0Z3mEXl7MAl89X9zdERd7AlyWD1cU2lKW1YQ6kX0IVZdq9VfEZ0KmuctJgMmyP817p6uqAMa8A1fV1hpx/2BfX5NKWho/LHfxAjYbOGU9qoE9gC7XPVlPLkcm2QcgU3hpZYnfU6JPUtaHc9/HI3X8k+Ve0fiPAdtqlRnt3/IA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DB9PR04MB9626.eurprd04.prod.outlook.com (2603:10a6:10:309::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Fri, 12 May
 2023 10:29:17 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::c157:e89a:e0f5:f85]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::c157:e89a:e0f5:f85%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 10:29:16 +0000
Date: Fri, 12 May 2023 13:29:11 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	=?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230512102911.qnosuqnzwbmlupg6@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
 <20230511203646.ihljeknxni77uu5j@skbuf>
 <54e14000-3fd7-47fa-aec3-ffc2bab2e991@lunn.ch>
 <ZF1WS4a2bbUiTLA0@shell.armlinux.org.uk>
 <20230511210237.nmjmcex47xadx6eo@skbuf>
 <20230511150902.57d9a437@kernel.org>
 <20230511230717.hg7gtrq5ppvuzmcx@skbuf>
 <20230511161625.2e3f0161@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511161625.2e3f0161@kernel.org>
X-ClientProxiedBy: AS4P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::11) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DB9PR04MB9626:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c7a4c16-a88d-4a8d-fa3d-08db52d3bd0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Xmganj9DS1Vc8sIpLw9klAleCtIOPZAFG52OMwAcVq7IsmDK9SPo0ENh7fzfR/LWEOqJdnZufiVA4hMDMuP5fVLM1EhUTXUeV1qWy78muXrDiG7iwA7ntWV0eoZlXpjfPZIiZ2W00LNdE/qh7qEueGGvh5rccjzn4LeLMKl4pAxnrVr3atQYLz1H/PRP//RcGGGLh/Ard5PcQzgRj6DcZecstXvMJQQkS4/Qdcgqx/hjZeo0uY4RvAdCOX5+Be7+FcgK4WGglGZIDklG5eqt8Bci4AEUWTW/QGV55k7qItxg2Yx/WCC8/b7ctml3FRxEXnONtXRIOvcJkNyGF3bfTqc9TFo8JlzBcgl2At4d5NCPHWAYlvl+iK+1ddL1MDTJaxgACgBUj0DL7lq+V1stQFSW837nRQkXABINNeFb1/t2/zJAJQc9G1Ldl+cvOk7CZ9EuBAN5Xp8PzSbG4PDML5A+CGulmW9tH52/oLpD7vvySbaPL/Y3SFgNHzoW+2jGXSEBS84EqtpIoHh8Xg2K2igMmwEQu9i9MQWW1utcJA6JIfiS+ZfDOsfmsuz2+JaX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199021)(6916009)(2906002)(66476007)(83380400001)(4744005)(6486002)(6666004)(478600001)(66946007)(66556008)(8936002)(6506007)(1076003)(9686003)(26005)(6512007)(186003)(7416002)(8676002)(316002)(4326008)(41300700001)(5660300002)(54906003)(44832011)(86362001)(38100700002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BzUsjLTvhzOgUE1X9KOjXEsjcmf3rfHAzCVywSL1y3DZnWkIrUi6ZENZgOnV?=
 =?us-ascii?Q?OpznY81Ef/e/T3VRBL6J1z4VXOc0nX6PEUmRvcXBbc/yQ2ltFAbsYPz1PDD3?=
 =?us-ascii?Q?ssbJihsSx5hTqZXdbQPcPURjttmf0I31nzj5MLn0K7QlKGk8sS27bF3y/Dq7?=
 =?us-ascii?Q?aGz/Pl6TbP8vBDxeTPooo0v3BkbaNHO9dWJvSx66KfDTUhuFMZyhFywBzFiK?=
 =?us-ascii?Q?caIhSqRQ25HmkaJ5xSBzPtKuV8RRMcuSXAQptx2o25Ef1cuyeicEISjQdniv?=
 =?us-ascii?Q?it/BXG2l/Kid7c6Z4bTFvKCkX4va7L23NIHBhF96BRlkRc9CiZ/Pv31oyZdN?=
 =?us-ascii?Q?Mmr5LZWhPR/zaj9aQ+JMK+enmc3mJL4LRiU3smUb9YhZnQT86YNjwikRPA0J?=
 =?us-ascii?Q?2oTmW+PFcCbG3abGoD/HLjTHRScNfYxRt87E02LekfS47NGEYKr0fLjwrt+9?=
 =?us-ascii?Q?8xI5TWrLpv51qqUQ98hjOV9xpsUc0KwRQJEIEA1N0VoDBWn7a129PKlyV1b5?=
 =?us-ascii?Q?brkR3U5kTt2Ca1FtBAV5yZ+HPaNhDw/lHP+x+/sjjmWnVd1EvTjZz5E9qdfG?=
 =?us-ascii?Q?H0B2oSBI2XCDbC4PTiSazCe5BJXxCwyW+9Tzj1/dicQR8qzAv2E1IBhN6tEC?=
 =?us-ascii?Q?aZVa6fmhyWjwSdHmm9llngznqnX1tY9TCPs0DdasBwTeYZdj/pIH2lYMIPOl?=
 =?us-ascii?Q?ISQNHUaWNj/qljyxjVei1fx5EtnOq+ABCytf7XGySG102HJfAqEhLVC1hk9h?=
 =?us-ascii?Q?BptENnYJyT5h0nHrL58o93t6mRvvTTxf5cp8/bHINQmGncvSUZbsulH7oGqr?=
 =?us-ascii?Q?ydIpAI7wjHv90RxbO6DbvCjbFlT2yU48m5fSZNA3rwnMjh9b1/abuHuLAbZ2?=
 =?us-ascii?Q?94gvipumNWTG63RKLqpllJwkNvx+40PYyjbTgumsuMIF4tGxbWGz3+yjHvvs?=
 =?us-ascii?Q?uYMuZmX9I3Cqp9C74X0I4Sx8sEPYZG6bzpRjM7+yfnWTo7Socjw/jOnJSWlh?=
 =?us-ascii?Q?lZJavMKpMUgEPZbeJ0XPgl5tGR4jqnxi6MiBCaYgnERIPGoM99Zn52ntNEGl?=
 =?us-ascii?Q?6oalwaD+37HwOagKWSKpcnZfLlVCoKaqkR9T9A5/NR/x3Rt2gKEuz41qE0Xj?=
 =?us-ascii?Q?fgBaV6w9t5N4jUfpW5gKdU1Qi6gdyonwj7XOy4mhEXhAa77qBnKngsHIkPBf?=
 =?us-ascii?Q?9ufGC+Cr6q6NAzUz8oB4Sjgw+8q5Bk32tbKOn8+6Ew5KdY4Bal5ItOHle1Ts?=
 =?us-ascii?Q?VTZ/kDxbjMgoDFvZRWmeD9H/i+gdQjLR7iWJTjRmzVKhiREbxA19qRSehVRv?=
 =?us-ascii?Q?5a9fI3QmdlDrTSBcrcWjVjOpavnNUwQEx6ENPhctFqtLZfallfDdelHcFsrP?=
 =?us-ascii?Q?xwU+7TOrbiUkPR1IlKSiwEN0On/EMeznU6p3FOMXoZIxoiueu2WA2ZD44kXp?=
 =?us-ascii?Q?U5HeisZgpMEL5zaJttQyX2YOFcFAFMc8O8+7LmhLksafbV68EZzovLEIyRg5?=
 =?us-ascii?Q?AojIiD4jf7pSkMW/DHYdqZMpdxpeS1EUCyDJvFTEX5YERqgKt8gaYR2QVyYU?=
 =?us-ascii?Q?hPIHotA8rT/2HtXH7KDD/dQDV7LHKEdhFF+Rz49N0Oml07vs9P9OaiJgNvS8?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c7a4c16-a88d-4a8d-fa3d-08db52d3bd0b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 10:29:16.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KakgVnWzMgmUdszpyzF+etpuppDUffVGCr4S+/c8h1kDiosriuAgSQTWfH5FO4MNXRoU+4KWgkdD8WT3SFFWIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9626
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 04:16:25PM -0700, Jakub Kicinski wrote:
> > I mean, I can't ignore the fact that there are NICs that can provide
> > 2-step TX timestamps at line rate for all packets (not just PTP) for
> > line rates exceeding 10G, in band with the descriptor in its TX
> > completion queue. I don't want to give any names, just to point out
> > that there isn't any inherent limitation in the technology.
> 
> Oh, you should tell me, maybe off-list then. 'Cause I don't know any.

I hope the examples given in private will make you reconsider the
validity of my argument about DMA timestamps.

