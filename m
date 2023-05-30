Return-Path: <netdev+bounces-6574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67444716FC7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85CAC281357
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D8C31EE7;
	Tue, 30 May 2023 21:33:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6517D200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:33:01 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2080.outbound.protection.outlook.com [40.107.15.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D847DE5;
	Tue, 30 May 2023 14:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBwCCThBf7Yo9uQ5veERtBEgULP0trIRZSPM0YhfHTq5frELzEGAmwEVgL1u50GRoapHKf1bSLY75zTDEbMKzn1JGoIMfGIfU3GMUaXShvp4IR5Kq41gqgt4zXmapHVZlRxSrWSzCcFbNGem918q9xOGVoYAhooo4ptrrzzDo5PgTO1wXTdQgaefoaEhm2pD4mUwiYT2q3lXqLLFGf7izq32508ttg9UM/ej4MKAG5M6FNEukdNi/3q7DyImi4ZjfXGH/pODGVaR/sO3EPVMQ/96lcsSAv2FODqOl5IhvVP1SQpMZIyyRVaZDOhItWNkJXyfYHdz6LwMV0ZgZQp5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ylZyePCCTjMbSoCPQZhVlAHOBxRVv1JrYxv/O2WWfMU=;
 b=Qsj+g83VjONTNzeVhqn7+bM8q6Q803SNG1YP/gb5ADzfnZwx3haa46GJ8q5swZKYDQSILvuVPoixQtAhDSAIsheAW6mQjPByo+QDD3PvbUg8nkPqvjPvIYgNMXnpdazr0Hn3W/WxGtO/om8XyxpejKXmvie8NHg8+y2Q5P0bwmPhlNrAeJvYlsQ/b6U+swP4UoOmbNWIkNpGSoj5IjdYhMy4MKKJT5mbRQQEqRQWVwh1Blrgt1LOkEplVCAI3vLeHn7KYHaA2onBK82av76YRu0f5mzs7FVa/CyyA+CtsbJEYbFfLr7NuBkITCdR3Lhlu4ykB5sfZaqxgoMZPeRj/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylZyePCCTjMbSoCPQZhVlAHOBxRVv1JrYxv/O2WWfMU=;
 b=er+ofbeoQ+2xMFP6rXorCm29gOKpFnjDU4H3HYIVduLpqPh9v4BVSStuJCM5HSv+cq3efCKAblcuDNlan3ZYF7g1o1V+EPd+qIVuljSksmlXMhfpvORES/PqdEXE+obRVHEYvshZ2bg3QyXfDsRzGFrYpC0+HpjcAdfkIIHP8NM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8838.eurprd04.prod.outlook.com (2603:10a6:10:2e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 21:32:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 21:32:57 +0000
Date: Wed, 31 May 2023 00:32:52 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next 1/5] net/sched: taprio: don't overwrite "sch"
 variable in taprio_dump_class_stats()
Message-ID: <20230530213252.pddrmwgppneawmht@skbuf>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-2-vladimir.oltean@nxp.com>
 <87edmxv7x2.fsf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edmxv7x2.fsf@intel.com>
X-ClientProxiedBy: FR2P281CA0042.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:92::15) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8838:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2e2069-b931-4070-1289-08db61556f2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	plHa4AmhraxAvXixGV1XgiQQ5lfEtbGPFMvlL5SbNp+tZf0Vp0ifkCePJHDvI5QeVk61TOXbnNcUAfnLpTMHj9t8Btz5hE1alIbESbe2L+uCmOr7oR/G6vWQCy8ubjVdm2IYsInMbJoNufOcnQZB/9PIZUl1bJ7ERqyz+3MkMPhtzYeWcFEswhxmWvRChzxoVQ8yNJFgVga+yVjh5ty9NWBqkq+z9OysHEg0rDKPyU1EiqJeOnVI68jtx3bS61UohU3YGk8EtIC8paM6QffHkRU/j+eM7gMIbZU3FMWwW9Esn1Lr9XcxhilnffZ3T4EIAx2GK0s3IgmE+H+UZfZjXggkOPXdFUJbMK+oNLXMC9By/VeYnEHC0AwxkKOF+ZH1tYzwH09I43pTOiuwAcyNxFzYJIU0f8fcV5oJ2eXiiaXa0njO/s9EZqe4VNRax45jM+w3E4shRptP63ZskO6RdUrlSLFQIonycXRaqwulIaNxoShPGVE1HhOJVoff4q5glxim8l6H57QCJHiTOYZWgav6M0Tm3mDdWnJvPSf9J1ZifAYresUAkWcbXXbM4Rzj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199021)(38100700002)(41300700001)(6666004)(6512007)(316002)(6916009)(3716004)(4326008)(86362001)(8676002)(8936002)(6486002)(2906002)(4744005)(7416002)(66946007)(7406005)(9686003)(66556008)(66476007)(54906003)(44832011)(6506007)(26005)(1076003)(478600001)(33716001)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IE9XI14G+gn/IJvtCEyGxzsmFrd6F2vjHurKZk1YtXIngYo3lAGwiSNpzzZK?=
 =?us-ascii?Q?c0qzmF8Kp44c2XcbU/wG42mmWvS0bWI4mndv0ntTRXBMbt02AWE9w3KnuQ9i?=
 =?us-ascii?Q?SadeIwz0jR7JsXlndn9vo112upXIZDM5WAs7fYn/1Y6d6e1qylgxhtp+CazX?=
 =?us-ascii?Q?e0YHaMe77D2EeTrPJPJWRsM4KVqI04OiIeuWOzaqeDlQVmB8Yjoi8JTS4IiC?=
 =?us-ascii?Q?gUmhvoFa8MUFhxrLEW61iSApDRcYrRIOjpRUSKepwvXPYLTCyKxQ81OPQ7iL?=
 =?us-ascii?Q?qjbp9HWZkFPgnqTsJvJM7WueWZaXSy73LKwCC8gpWWesqwOnVj/coi24QalV?=
 =?us-ascii?Q?v2698VOxCkiUj/V9fFGhL9RxEu4k+z5Qwi2ffwyAveEVKL1LNRqIjmdCej4A?=
 =?us-ascii?Q?5NB9c6ecKkuFQ9bfynd5NIxHLaqrqH0+aXqfEn1MGEJCsfErX1k28FQrNvMg?=
 =?us-ascii?Q?tmxxwwDYqRyE0OwRx1ayW/kIBiSeRyFGigSWVXqLBc2xRQPIVEWqOBQ5jLsa?=
 =?us-ascii?Q?S7KrbEhr6HURzGAMa7QS5HWNBpgsNvaxtYVcOlUcG6Iz6sE4S0BpqwX+qKpn?=
 =?us-ascii?Q?q2rqAlZ5ISOIwUW/wZp596L4tu5KlIqa5LpV/Sc1v+vp6/K6R+39SpZoA0+0?=
 =?us-ascii?Q?sWwwjjUiylZANMNMU3/01Tuqti/+6aQ7skfc9REGvRmtlKaSRkt5eaeqRwy+?=
 =?us-ascii?Q?4S4mbwn9FFn+FfGWfk82ncplUrZFec+pEu4puNWT80emXD4ERLXH5njn22bA?=
 =?us-ascii?Q?fXDX91mEN4TVw5DZOKqYZX8PY0HRrCNipyUg/tfQ0ghSBmN2pNW3OnypZo9S?=
 =?us-ascii?Q?ssitUV3khXe92Tiu8JnPr6ijc9UUGrSBkCN/SqKFurH2WFlkig1gy80Y7ysj?=
 =?us-ascii?Q?YMK1LzCEkSG8dVsyiGVeJjxRvyy2DuEz19wPEMU7+kzPyXgViAFrdVzgLBaH?=
 =?us-ascii?Q?Tbjp6upFtJShud1hHXsQ2c7gRoYeB4mvaoW+CKgwj+d73IiqKeBuUpwYs6K1?=
 =?us-ascii?Q?rq5N3J9fj8wh3oLP2SiWYKSMZCA9Ty64ZQsED3Xm+icJrFDRETvS1e0eUTct?=
 =?us-ascii?Q?NiQr56IxQ1wXOg18ALx1DnxjhFZH4epiJMAo2ZJyiGjBtLRC4AdRGBBIOau2?=
 =?us-ascii?Q?/xTeiXyfwiAtqh68RkSrJivUCILULMFNjnuiddca7YwwzRlI12+0umFnFXF+?=
 =?us-ascii?Q?u3Vs4t6c9GUlUQek9hbpgv12g430+iGl7JvLASrNcDyZ35kSkU+tDQ4rRxdn?=
 =?us-ascii?Q?N1mJ98o6Cj3fuMHAf17VnIOrGmwPkaSXQ3Dc1XS8burI3lsw/TtKTRiHtHEp?=
 =?us-ascii?Q?uZzjaoEhN5+upadgR+E5JACFaioTG5ZHB9zigFTod7i1ecz3MMvV+y5wDZYf?=
 =?us-ascii?Q?VDUbFnd+d7WbsA+R/68Vz7MAHLLpqN86v4CDMaw57J/MWewpP0sibH07lc32?=
 =?us-ascii?Q?XX1gOdu+/7V7US5Xdw+vQSjB2RHVULT9jP4KkqgWV0oWtM2BBnk+hcIGrJzg?=
 =?us-ascii?Q?AqpBHnm50DNHaGcYPTKHaoCAjg9cQwGLUBpdLPw32Ug1p7yq0Bqbp2+LxLkf?=
 =?us-ascii?Q?SAZHPOuIHflJcGeVBCde5L0N+4rDHyhbydR7NikSHO2kQhTQDAyphA7Dzy4j?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2e2069-b931-4070-1289-08db61556f2e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 21:32:57.0645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xL18dFdIK19zvuC1WTLCUcMj9l5TAerdzCwzHWTcuhjPvK43J+Md7SunVlFSGsbNDCKP2UQZgxQmc2SN+TQwKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 02:14:17PM -0700, Vinicius Costa Gomes wrote:
> But I have a suggestion, this "taprio_queue_get() ->
> dev_queue->qdisc_sleeping()" dance should have the same result as
> calling 'taprio_leaf()'.
> 
> I am thinking of using taprio_leaf() here and in taprio_dump_class().
> Could be a separate commit.

Got it, you want to consolidate the dev_queue->qdisc_sleeping pattern.
Since taprio_dump_class() could benefit from the consolidation too, they
could really be both converted separately. Or I could also handle that
in this patch set, if I need to resend it.

