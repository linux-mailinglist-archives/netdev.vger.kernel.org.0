Return-Path: <netdev+bounces-8122-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0856722D07
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF4A1C20AD8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA973A949;
	Mon,  5 Jun 2023 16:54:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46F38F41
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 16:54:01 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2083.outbound.protection.outlook.com [40.107.14.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7706D9;
	Mon,  5 Jun 2023 09:53:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InYckdXtAH5e9c0XS3L8PW/RGGlwSvlDeGtS9ZVmRuG+xwAN78lYzTCtqwmtpAEj+JNdLdISCPAaueH4TfPYA0A05W08pIFHSF9TWI+8WKCjlecwq7M4hWsj02UhHOg4itTzh6mdQK9GAgD5LEAGORA+ZV2maNu+uqrnOUZwitLAU17NMQNTv8ezzsBAZLtbpM0zO/UfDu8hxlwCicohx4U3JqKIKNff7l3KMWhqKo8La9Yo2EfkjLyJHSPOm2c+ZNCt4GBp7zx1H9dScaddTQdkVIe4/5MYp/8YK0+b7yf1Vuv7QqnRH+NRRxLVL7LhMwe0gkO4wRM0t2Vjqcs+Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/I37h1wdQdMlWmVfYGS2D1bKJaz84k9+bazyms3A1IE=;
 b=HxekCOHACSY13a02hNpf0TdASTvg5aH5jLUH18xw9uSM4ffrMw5pKCGhcpq6AYPpWAv6tbA/BhJqh0kFyO7C90e8ZVf9X7K7tCT9yOFyP4IJhNWWM15y2YFwZetDhszngxuFmfRxoX5lBRWAP4u8O2+uCy4E65mtmZug9IXgn91elbSc/Bm62sYpzcHpTE9tqn8BChQUmO33lJBn37cB0h/X8PO9A0GrcxbNZyslabg86JbMT99OEAUYijSf/4MDSYqYCOKa7jgigAm/0RnZFOEY3WGsNmwtLYb80vpXU5kbBU65XTE/h3XEhWfsZisNKWmVE+ct75Zxs/lNBXQmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/I37h1wdQdMlWmVfYGS2D1bKJaz84k9+bazyms3A1IE=;
 b=Y2u+kvT9u+GmlDy+RoFiTzJpUI55jLiS0GOCYCfD3oFC93KZjkeMxw1so4TzYK5oaJ0NDXi4eApCtzNE5tokv8+2wfYEK9HgG7SkkH/vRwUSeP5hZtzj+IgVCH8Jr/7JJji/0COgvZbNWhWJK4DsK8JMyJWruBoDT8v7PdghjkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8981.eurprd04.prod.outlook.com (2603:10a6:10:2e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 16:53:57 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:53:57 +0000
Date: Mon, 5 Jun 2023 19:53:53 +0300
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
Message-ID: <20230605165353.tnjrwa7gbcp4qhim@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMnqscw=OfWzyEKV10qFW5+EFMd5JWZxPSPCod3TvqpnuQ@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8981:EE_
X-MS-Office365-Filtering-Correlation-Id: a132e6b5-2244-4968-c202-08db65e573c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F9S8fe8vHI6sRk9NePWVEAA0L4hFHm9l/xDNRtOZwrhbIeLj/aE6FmX7ig2BfecJ8JpjdBBMKxpOc0By+l8uoW7EwH1C5J4uEHln89/9X3ctbBmAS0MNFpsTH3tHppVn5a+cIpXnIr3O/bQxARdlJ46s5ojMy3W9zL6Yx84SeJ20VlEJxDV9GmsD3Esg89jV996NV6M2u6lvHQ8lzuIsiIgqD4L09+L3Fj/T1D42z/PmKOoXd1VhQFwHb2ivF7TErtvMf3jUiZqdXAceb131VlvgIIWFoB+wLzf/3PA6nOyrc+ENcCagp6CwztCHyOwUm0McQ2OsmWJCOEdkALLYhPdCNiV7gS3BF9z6ltSUtBz+twsoGRjW/kRYup+o9fJAnI81zmV/TISCzjL60x8oVm0usP5Nwe4vhJMWm+VlJVNrsHOFblfMOhVfYUwKYZ6lyX9sDoyTBLGOnJ8tiFDheiJAnCqhIAWBMKL8N3aGRSMoM2YqUfqiK1hXvSHl1yykEIEZMz4DFTtnSVZmUzyopKU3eWfbou84nygpQuCEF+g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(2906002)(478600001)(966005)(6486002)(6666004)(83380400001)(6512007)(26005)(6506007)(1076003)(9686003)(86362001)(33716001)(38100700002)(186003)(5660300002)(316002)(7416002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(44832011)(54906003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rZxzD9zQO5yNdHgeR/xDG++OsMHDqEUUAfjcHDPHYohSezIOGqugLtSfveRl?=
 =?us-ascii?Q?1V7VyK3UBsFhuNdouDToVvzXZwJA38ukZL2q59w6yTDyETYUm9rfh25bveTx?=
 =?us-ascii?Q?s8joCyR4s47+vCi1+PmvFHZmlAHIfELMJ2sRztW0Zk4S1P3m/ZsEc/3bTucr?=
 =?us-ascii?Q?PdV4tU8VnS33AIHsUgJbveCfTR66lrVadJzY0GyDFnKJchUZzPze/JBi0uYy?=
 =?us-ascii?Q?iCHhGbnN0WdWPxfiUnuLHNQnsN+o1YVgkMDsIubj3T+aYHBzmzlEANCbnZeg?=
 =?us-ascii?Q?Mxq4aB3FLzMBqb3lZND6BLfObFic7SCSvtr4gYatIiWO7F7a9zHSjufrwEtc?=
 =?us-ascii?Q?sUbtKLFW+95XLzBo2mkWSPNznNI2CQ+jUujVnMXXoNAhUfE5ZJqXFecHPMEX?=
 =?us-ascii?Q?+TPznAiePzqBeF4LkZOOysbYQ+K6wSCX1krN7gnVwCzl+qO7DdypWVMgW0ZB?=
 =?us-ascii?Q?H7ZoHiGTB6+4JRfT+AFkfxFmfKS7Ci930g+yVE/06ubn7NFPS9ZuPF6/S+mZ?=
 =?us-ascii?Q?CH6xwag9dcwg+KtoDpf0KvOTcrauuz2GZDdKGIMU7NActZE2gTyRgUL3Jb9n?=
 =?us-ascii?Q?o3pdd/jjBerIDYKATbQ8IpYN3H2L2F5DeJ6IUkcSTXX3mbpdLJuQxlYDU7zR?=
 =?us-ascii?Q?J+Zbcn3fA6MgkH51tQLeaWF6/kXrhwG3vL8WxzNgTC25kS6dcrTdyyW9Lq8V?=
 =?us-ascii?Q?Am0HUgCYSbzTfRkSzSSo1Ph/hMnELtpvtYV2wyRMRbRnF0nDZBOkVI4J4pUm?=
 =?us-ascii?Q?K7f2kAhs//Olf6sakFR36ttcsAWfv6h73JCBmRFGJ0xB6J0m0qtaAmqaew+U?=
 =?us-ascii?Q?miP1SgV8ENrrhuJ76S1Y0DchaieaOURgppBfqSINzIVTcd9npD2yFj3Tc6Ay?=
 =?us-ascii?Q?qGgK5mAkbrkP18CfsP04XMgxAJCVklTYXwQaw/SigsEQgqD2z4e+RUWlrjyK?=
 =?us-ascii?Q?DB+zJ+SVuOHBGVMwC2+ERPkYWpcxG86k9SmQlUFGFLavo5Q3pZmcEurw+cD2?=
 =?us-ascii?Q?In9bw+jJueakEaxdtXJq4FX1BtN1AQibrUKkA4e+BdhggZVhUIgUNF/h8cis?=
 =?us-ascii?Q?sVnhUESJz9dg8brvrKJ0v17uW+WGZjTMZXbtqk+jfYxY9CbOI7wpMysGm8Sa?=
 =?us-ascii?Q?WFGdBW2xc9Uq5R70stw2ldh0mkT/uXnKorUWeJe7Ioa/wit4cpqEvW9SVOSY?=
 =?us-ascii?Q?PiNBI6aZVs8MC7y6K2FXYBK9rt/evHTX4XFGga0sBPX0YtpFxtYqeOpaJt8G?=
 =?us-ascii?Q?ImPaL0UkBCh5cgwJyUhxcoV9OtRcTVV9dCx9eqf8xDjt0G4m2d6IU+YDfySi?=
 =?us-ascii?Q?8PxiPMN/GYsMP12/+I4zY2psymUSyKeA2t5d9hlwdkJuV6BVhdTVst5OYbfs?=
 =?us-ascii?Q?XgHGTqeqjEX6tbHfBh6jVhP42Nz2nhbYh8Wq6bxQjMWZlfoE0vEamBrm5rIv?=
 =?us-ascii?Q?aXYK2WFJaFWbftXqGAaYairtt5Bh0Va+rf08KSik21fXgGi4I5XfvAfqSIUl?=
 =?us-ascii?Q?hnAhkpJ9x4pERZvDRWc6fjEtIpYNMuu1AUa1+lwU9vqq/SRbRtetWGfl6MXK?=
 =?us-ascii?Q?2Ca8YDi2tapRchEeqnXii6W/vqphHxQ7miLwxPChAsB4IMx/8Z7hGRMeMxY3?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a132e6b5-2244-4968-c202-08db65e573c1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 16:53:56.8775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j87EKMfRCiY8KZ9eqKQBFJY1W6mqR2L/m/b97aYX66PL6alI6Sp46OqyL38isRysvhCsX3X5gbKMZMiqpz++dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jamal,

On Mon, Jun 05, 2023 at 11:44:17AM -0400, Jamal Hadi Salim wrote:
> I havent been following - but if you show me sample intended tc
> configs for both s/w and hardware offloads i can comment.

There is not much difference in usage between the 2 modes. IMO the software
data path logic is only a simulation for demonstrative purposes of what the
shaper is intended to do. If hardware offload is available, it is always
preferable. Otherwise, I'm not sure if anyone uses the pure software
scheduling mode (also without txtime assist) for a real life use case.

I was working with something like this for testing the code paths affected
by these changes:

#!/bin/bash

add_taprio()
{
	local offload=$1
	local extra_flags

	case $offload in
	true)
		extra_flags="flags 0x2"
		;;
	false)
		extra_flags="clockid CLOCK_TAI"
		;;
	esac

	tc qdisc replace dev eno0 handle 8001: parent root stab overhead 24 taprio \
		num_tc 8 \
		map 0 1 2 3 4 5 6 7 \
		queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
		max-sdu 0 0 0 0 0 200 0 0 \
		base-time 200 \
		sched-entry S 80 20000 \
		sched-entry S a0 20000 \
		sched-entry S 5f 60000 \
		$extra_flags
}

add_cbs()
{
	local offload=$1
	local extra_flags

	case $offload in
	true)
		extra_flags="offload 1"
		;;
	false)
		extra_flags=""
		;;
	esac

	max_frame_size=1500
	data_rate_kbps=20000
	port_transmit_rate_kbps=1000000
	idleslope=$data_rate_kbps
	sendslope=$(($idleslope - $port_transmit_rate_kbps))
	locredit=$(($max_frame_size * $sendslope / $port_transmit_rate_kbps))
	hicredit=$(($max_frame_size * $idleslope / $port_transmit_rate_kbps))
	tc qdisc replace dev eno0 parent 8001:8 cbs \
		idleslope $idleslope \
		sendslope $sendslope \
		hicredit $hicredit \
		locredit $locredit \
		$extra_flags
}

# this should always fail
add_second_taprio()
{
	tc qdisc replace dev eno0 parent 8001:7 taprio \
		num_tc 8 \
		map 0 1 2 3 4 5 6 7 \
		queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
		max-sdu 0 0 0 0 0 200 0 0 \
		base-time 200 \
		sched-entry S 80 20000 \
		sched-entry S a0 20000 \
		sched-entry S 5f 60000 \
		clockid CLOCK_TAI
}

ip link set eno0 up

echo "Offload:"
add_taprio true
add_cbs true
add_second_taprio
mausezahn eno0 -t ip -b 00:04:9f:05:f6:27 -c 100 -p 60
sleep 5
tc -s class show dev eno0
tc qdisc del dev eno0 root

echo "Software:"
add_taprio false
add_cbs false
add_second_taprio
mausezahn eno0 -t ip -b 00:04:9f:05:f6:27 -c 100 -p 60
sleep 5
tc -s class show dev eno0
tc qdisc del dev eno0 root

> In my cursory look i assumed you wanted to go along the path of mqprio
> where nothing much happens in the s/w datapath other than requeues
> when the tx hardware path is busy (notice it is missing an
> enqueue/deque ops). In that case the hardware selection is essentially
> of a DMA ring based on skb tags. It seems you took it up a notch by
> infact having a choice of whether to have pure s/w or offload path.

Yes. Actually the original taprio design always had the enqueue()/dequeue()
ops involved in the data path, then commit 13511704f8d7 ("net: taprio
offload: enforce qdisc to netdev queue mapping") retrofitted the mqprio
model when using the "flags 0x2" argument.

If you have time to read, the discussion behind that redesign was here:
https://lore.kernel.org/netdev/20210511171829.17181-1-yannick.vignon@oss.nxp.com/

