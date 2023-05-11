Return-Path: <netdev+bounces-1949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5117E6FFB5B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 557521C210B9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:36:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3395E947E;
	Thu, 11 May 2023 20:36:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F506624
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:36:56 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2050.outbound.protection.outlook.com [40.107.247.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0741106
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haiVn16PyEK3JHr6hVeqaW6jstWW1C6Z/WPXLaPDtd7Sw2KkHJ/B4ypDnel4RNzREHgGk0yV6R+5TUIFzkx2EUMVWPu07I4poc6eSdyeQUWcrGofbgCdmHKG9OON7J1PQ+AX4zd6wRqnYLlhp+95cF/1lbMe0o0Y1GbXxW8qsy+DzmxGQOgBBlhqfJ34c1K+Rxr/q8Jl424eiXkS1huCxXioGNAX7qYnhlNpdud+4V+WKv0C+hTmaoxTvLhXtJMHk5HNQOPPj+VR3qSmk60jjcLLE0KNYPhbXjJP7WeajQZo4BbVWY2Qavv/xI3vR7QQojVYY8p2shGr/l4eV3reNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIeYpECge/26c6Un61GlqFlHVLyDh1I5zNCpTSPMoWM=;
 b=FSBNAltzjqqtfjqzqXf6Vx26Mll5Y/NQVO+JIJ6hPSW8T16XtHKR452gadXx7FQR9ynsPFu+pYSYBAsf30NL/U3AEN9oK6CWTsZwevPG8FzstvJFmliXaol0m/Ju7UvwjOgGX7oNd9+VO/zPUyI2uTii0XAK1Y8/KidujW6GcBD16SgUz8HMiYqrPLELIePb875qnDpy0dwisPjglXQ2z8BWxH4sjNVRlLOV0ToFk1chXRURCHwpYLOrPRi5ITKZ7Apape/juF+4UXDQxZiVb/15amzj2wLE0HZ4JPiosJp0M4XVWPFM+O7vV362z3RMVLS6DHA0DDRCfbPIJXIVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIeYpECge/26c6Un61GlqFlHVLyDh1I5zNCpTSPMoWM=;
 b=riRBFpfnT0ituBhkj/35opeK+/lWBtVgo2Bvdqk+WEVoSTzQoqIsfiuXZ6Duxh8aPWv5xImPaUq3C+kmdVY9+fy2PrgsmlTLRciuUoMBzGDXSgENtN8Cu1o6NszBvcr5RMc2KQZLFJcH1cWW0b8IK0JMLUKKcGjQylQziQjUJ2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8627.eurprd04.prod.outlook.com (2603:10a6:20b:42a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Thu, 11 May
 2023 20:36:50 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:36:50 +0000
Date: Thu, 11 May 2023 23:36:46 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: =?utf-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
	netdev@vger.kernel.org, glipus@gmail.com,
	maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
	richardcochran@gmail.com, gerhard@engleder-embedded.com,
	thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 2/5] net: Expose available time stamping
 layers to user space.
Message-ID: <20230511203646.ihljeknxni77uu5j@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
 <20230406173308.401924-3-kory.maincent@bootlin.com>
 <20230406184646.0c7c2ab1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406184646.0c7c2ab1@kernel.org>
X-ClientProxiedBy: FR2P281CA0179.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8627:EE_
X-MS-Office365-Filtering-Correlation-Id: 5edc7f12-8bbb-49f8-ec2e-08db525f7277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ASYYMi3VQtZHQSNMayl3Ia9+ZUjCrSwBzobWIZhB4yyfIL6EDBuKgJ4ADCRzK35Ps8dRjNv3hI31Eq1NXfqgeesCJZqpufLIWAI7UHRVVALD3DKNkkv2UP9TnrnpjQ86Y/sw/siVBNnKaIzBKWiCgXLKRc00HL9akwup/yA6uQNYLHv3ptNO6cg8l4LgT0J1bcYGzMtWQvPQlKMOLLvmS7dgxdRo5BRH9JmKLwKG6AA0K42dGR2lDaCzFAZ6UY1lmzjGC4rNy3bql4MwzIACmYC5QaE2oBT+esLKlJWw0m3w0jJbQa21IdQ5s/6vtYlJjroo5g7z5Sv+6E2GPzx3ADG0KVz2s95192VAFn4dC5UbohkWPHX38Nrz3vOLsm+Yah7NWUqaSFUSDnxg0FVrEaF/wL96Ms89mhzS1QALwyDpspuASU6BsUYCUii+Mn55VFSJvMo2Z7pzI+IUIZj4fNqJ6UFmVK7DidXupHSS816noqiYM5L1FDVK29IbR+LOMF4oWahden3f0YsiYPiPu8xvNvoo/mgE4rWlJfB7p0Cs/QuY21uWC0Ke0JHIyuGr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199021)(6666004)(6486002)(38100700002)(33716001)(86362001)(6506007)(6512007)(1076003)(186003)(26005)(9686003)(4744005)(478600001)(2906002)(6916009)(66946007)(66556008)(66476007)(4326008)(5660300002)(41300700001)(44832011)(316002)(8676002)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mm/4luQ/6A/o4PbSn/YoWRKpbwAG2Wl0f5MeKBHPDhOzOLS5qrRvYqGwRzVF?=
 =?us-ascii?Q?IzPDH++NCgv/QLplCs3a/AoIYiax0bgIxh3YGzjTSa25tmZ7VqJCF+qL9f4E?=
 =?us-ascii?Q?/x2KlH8NFHhXtB5AmULLKBARZH1TN8iT4ELdmi5ztz1jq+Vbrzn62YnNT1iN?=
 =?us-ascii?Q?yXy+JEMhhrRdaoeQRUG4dwn++g12mIARSrZ1n5PiWfklD2f4WHeh62FO8A8l?=
 =?us-ascii?Q?PR1ut0V/qPbtsT/+Dyk5bcEzmlbdR9ZgPbcFJtkPoP5NzhdostpPK1Ts1yqa?=
 =?us-ascii?Q?IaI3/b+LXRi0b2Skio0nzjgE+S4MpY8sMziDiam0MsUihunbC7KYpv3znkkC?=
 =?us-ascii?Q?+05dhymgO5ltUTz4oOXeKFno7vLJG9oG6iwAW0lMB9m6updZbz/TWeUWJxBe?=
 =?us-ascii?Q?x2P6+ObjC/qmGX5+uUWqFUJLe1G/FX4I/gaBMlbKk/fzyEPdz35klXERLyl+?=
 =?us-ascii?Q?kzUdAIpyif/MEY5PpiH3YcHjZQAYXR1tO8D4ew9IPqzBCpvtv+dmjyMg11EO?=
 =?us-ascii?Q?1RwmKD0YelXBZjVEcu8vjBBaFM7COYv0OzfkK/MhEtPO0gvy8934wc6A+Hgs?=
 =?us-ascii?Q?kVUEUnPYsR2/jtgZgKsoeJsSdO97myheO+upv8/8mnrk9KPFW8UHb4FvEaD+?=
 =?us-ascii?Q?Lz5d6kUMKeogOXv336kwiZZK1G+kQc/zQ7Vg/3qnGOKlrgHYUo7dsSo/egiq?=
 =?us-ascii?Q?SYMJw6W2CeHseJY9gBpLYUZHp+Vs09W7HxQaNO4JDJ2Jh+4LGFq5D9TWjoui?=
 =?us-ascii?Q?ueHzaiVLF0YFmRMiCJ8L3TDisBhFvroReL20HwOC4Xqb8j0ohXeYAg4/xZ38?=
 =?us-ascii?Q?B3rbduw/BgFitQ1kh7VdXu/hSqlh36oE4zRJIaxsG2MXSi/by94fRU6MBqcE?=
 =?us-ascii?Q?92E+745lY1XRnIhcowJjgQXTcMzEkG+mxYV/GvJUjt/n/IdcZqMMrtMOl5C4?=
 =?us-ascii?Q?8pMiwb0E+66B7nHAkj8JhrCxP/YDBJ4+kbIjn6ZGCmvCpO4zUbtBC064C8Pn?=
 =?us-ascii?Q?lpyg/LeD/ek1sXsk22VnJ/r60GkbCZE/f4Cal+LLw5zS0LJnDOoe1l6/pWY8?=
 =?us-ascii?Q?ftMSNm8DfUGXJfZ7W5PbDaOlDBCukEptC5DLrMDi47aOaS9KdTAIhPSLmR2c?=
 =?us-ascii?Q?NmHt+V7QWdanndmLcIlu5XZJDuEtIiNOgStttu1Can1AKalIxFRkAa9mrRaq?=
 =?us-ascii?Q?9RMY9iHHK0fBDAQtu6L71atu532HZyxT2wgt3j45+CWTuL/3bAUT7KWQwm8n?=
 =?us-ascii?Q?2ZGWFK6Il69Y2E0TcUfku4ItR2BgYGRdS4jXzwc+24LYulCWEuTCuMv0xngY?=
 =?us-ascii?Q?n2r4sTr/fZfDR+3q3FcxhluqrkTHM9s15fnFpChDTJT+2N4sNPvilJTkqYg+?=
 =?us-ascii?Q?N7a1uiwEfb67HPBu+jk/7EUgTKXNEs+HDqdnjQo08qUjJC3+IDb13k1zO6A0?=
 =?us-ascii?Q?5qs1CMvHABr8IheGWgG6KwE/4NoXr92WFiRBx03O91jbyzfDp4EC5p/1b6MC?=
 =?us-ascii?Q?j/xZg2HqR9S4goM+3c99pFL23B1xfyWY8/uOdHHD8sRY+g6LKRHkDneqsHE8?=
 =?us-ascii?Q?8La66s0iJ0iBT9nM1IU84WbfAO6ai0XjVkP11RzebBQYZE9MSrZGUrzUb4YX?=
 =?us-ascii?Q?8A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5edc7f12-8bbb-49f8-ec2e-08db525f7277
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:36:50.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/cu3ukNRxrQLn9cxpCxk1rrLYpfdxZKC8tFy6xPKo9+O0jbwCfnAtqSkZ0OYRaUB0iXx6AUx6tNcGOcBVrSrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8627
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Apr 06, 2023 at 06:46:46PM -0700, Jakub Kicinski wrote:
> > +/* Hardware layer of the SO_TIMESTAMPING provider */
> > +enum timestamping_layer {
> > +	SOF_MAC_TIMESTAMPING = (1<<0),
> > +	SOF_PHY_TIMESTAMPING = (1<<1),
> 
> We need a value for DMA timestamps here.

What's a DMA timestamp, technically? Is it a snapshot of the PHC's time
domain, just not at the MII pins?

Which drivers provide DMA timestamps, and how do they currently signal
that they do this? Do they do this for all packets that get timestamped,
or for "some"?

