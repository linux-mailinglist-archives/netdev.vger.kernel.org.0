Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA1F6819DA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbjA3TGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238045AbjA3TGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:06:37 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2087.outbound.protection.outlook.com [40.107.249.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D842C39B85
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:06:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfHfcpFtc6/ppmOhQ4AYguqu4C/t28dA5ae5TuxdPsBfpNRrE9MU/zWwHA4a9sqW27nifFvIN8JgiKcJdgch6qX7U2HlE/DQqI4RxQ9qn0u17Epm1hJnrWWUDtP4//fodBLkgPWRaSkddmOkyhLexGbVuYXq+MRrZcTgMxNsL+qHOtDcabLQCLR8aB4Gs+RcfgNHeidX4fmausQ9RKI3v/Iu52zp4ZCXC9aT8Tbg74x0BByr1zSSQxLsviFrbzrToy5efnZIwKph3knJGsv3WEL/PUfKO5M59Xncb126gN1FWSL97tQK3O74VXGflp0UN1R71ttmZQ/YcVrq9Pt50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ld3zj7xT/ZvN1Z/wV4VvBeKESFBFak8JDSIhyrFObA=;
 b=jHem1SSuXVNEUrsKIzQuzrwhW1dVArbj8ScbaPcr+Dabp05P+Ywiq0yW8ZnwPIysQQDjCbBg5pPiFddlw4SUILcoTzD443jkH0ZF28dB+wBvYUdxQKSPgvcZPbxdnLf0/fieWxWOihTtW1uSpRsEXIiW4+OMb8MwXzPOYqEFzaMv8X/xccU14IAB5dFNbSroeZW7BlegrWGzw+e0cfsyMMJLpfBP4A8izD/67T3YKPAyQL+/8UhonviC1C0PhS6RCXzw6L5P36N+QiClKrOeyK7mH/5IILaK1SaIMMl5uAKRuF1glMMNud6csdl2ypjTB17OTljlSh86iFj//FIrnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ld3zj7xT/ZvN1Z/wV4VvBeKESFBFak8JDSIhyrFObA=;
 b=BbUe8fYS49q7/1JXSGcbHIOJAkFkHY/u1eKi9MMXOTAXXLRM3TW3NBQqJEsMdMcJ3B1HBfHlrAnLeqfqMr5XeGdjS2GaHikW4YBegsOuAcWRrFKn4ovtsYgyn3QoZz3hgEijs6s5srX4a4+eNZsRVxzRrm104NB6LLEGEz6OLk8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AS4PR04MB9550.eurprd04.prod.outlook.com (2603:10a6:20b:4f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Mon, 30 Jan
 2023 19:06:32 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 19:06:32 +0000
Date:   Mon, 30 Jan 2023 21:06:28 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading
 drivers to request queue count validation
Message-ID: <20230130190628.5jaa2st434f2vfhj@skbuf>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-9-vladimir.oltean@nxp.com>
 <AM9PR04MB83977621774954ABED31037896D39@AM9PR04MB8397.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB83977621774954ABED31037896D39@AM9PR04MB8397.eurprd04.prod.outlook.com>
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AS4PR04MB9550:EE_
X-MS-Office365-Filtering-Correlation-Id: f2924f8e-6425-44d6-17c1-08db02f51962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJmMALzAxdKzOmof21bUnxNOk8d4l2a0bK38HMKTrmttoiwd+8Ns7ojphWAfYDc5+wxLc0dm5VVguqbU35Sn257r3hRMY7ABIgz0Atf20dOiQC+Tj6t0tup9PzyU2RndoVGOqCAsM90Vot1wgtgIXx6nbLLstdJQMqgfOXuxyC7f2WMWTIx7KAtYXCqwrIXUnMOs0nc1F480Sc0mcDF/RW2JSZfEnvhcFPLhNswRzwnjwAp18eCiayRmAb9zGJYFRI1S6Q0nrDr8YGUQH9XClv2IaVWXbctH4CXWoh41+yJlLgf592edCcI+zvu+lAUlksElD89jtvKGml2Ml1z6/7WRIfp9qWJE/RZ757Flnx705I18Y1Yt1W61tkoFkeRYGa2wW+yKhbc8wB1RWSP2EuY3ajti730ySrvel+OWS2eJiB9+x7pqkESy/zN+UWTelZrv1NJGSmQYGN/YDkN5iLXf9IbbF5eQoT3K/Tu38+Yy4iQVLDH+36XBLJzDjDdxXnpYzQuyWPe1Cxern+VKFRkMyqRGzZESYFF0beZVSR09fBH2s9IxGNkTPtNZNqIyfsRBR6pagce9V4qvBHHw2WD1AH0Sv6H6Xddn02g5k2ZUAbl/nXEY1IpBpxNOMQlNLWfmTqyzEtqPALWLUI1j3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(44832011)(2906002)(5660300002)(7416002)(1076003)(186003)(6512007)(38100700002)(9686003)(6506007)(83380400001)(6636002)(86362001)(41300700001)(6862004)(8936002)(8676002)(66946007)(54906003)(66476007)(4326008)(316002)(66556008)(478600001)(6666004)(6486002)(26005)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vrN86UIpb/3vXvN2vhqXa80ZfEiaw232gucnnpQ93leVZWy5cx6tOuvKnegF?=
 =?us-ascii?Q?vGI1br10T2HXSnF1LuUfgVefkyQhTE4szj2YU/Lftp34BvnZZ6UD69FKoFpg?=
 =?us-ascii?Q?E6jgzlHXKgOZ6HSN8Rnx8i0prDYwUjoS3Cjo2XbiUOwOHbAkMQOA2cmZPCG9?=
 =?us-ascii?Q?XbXGIti4FhAJEW3GQicS1e+No/mCMWLvH4w5ValfjrcvVVUZUJKIFHgG4ra3?=
 =?us-ascii?Q?vvaT1NnDBfVR6TRNhT903PLqokPzY+p+dOOJKbrQL7BRnKe4Nw8fiNUK7gv9?=
 =?us-ascii?Q?oFprg/oMCPra+mFV5a6DCaZQ3hWBNj57m5mbyqVVLmvInSHpdCZi1VBAc/q9?=
 =?us-ascii?Q?CFdFfP3sLGd2DYfA0tHM3xnnFUseWLGN+b0P9Q3FsAn9+PpGa25Ea0lkJu5Y?=
 =?us-ascii?Q?cM5ufzegSVmcLr19xADp2or7UI2zcsaEP7b9VftPbd1kU5AU3G9Aeu6I9WwJ?=
 =?us-ascii?Q?Dhx/lzx1AeCWOVp+u8AOxTwwrXThw+xnvDcU9jha1d9phLzmccamKLU+gsDx?=
 =?us-ascii?Q?1HEEXDKp5P0zduVHB77s+p/ZYTq3dGe3xwF2Bu26EL7qbyNRd+kX11xL/vsa?=
 =?us-ascii?Q?+D8vh9X1dA4zx9Sr5Bbr6CRzTK17nd33dtn+0cpf/FRWFNvLJ8yWLOiXaDHz?=
 =?us-ascii?Q?Ljtrz7P/GC9NBubgjaviuUSzhNjGJ0Jq/WcCRsnxe9wEXkg8PbZmg2TDYhjI?=
 =?us-ascii?Q?vvBY1uf9XOZvOc3RyOIxDEPhNE2jrMcqnQdRe9UyfX1kzQ6BuMUyjd3KMLY9?=
 =?us-ascii?Q?tLx7LoBZDKzPEc2WQKbEaUf4v0/DWHVfYtlFiFuSkLMgqHGByU/GThRZ/BM8?=
 =?us-ascii?Q?9vZtQFK+394j6e7loOnYVSTK/A5y7wrPJgHn71M3+IFWwyub/8c0+G6WVBuP?=
 =?us-ascii?Q?NUY5y87zurfqAQnP+58VV/c2UiTR0kwfULnWazKyxtrZNWmdaHlyo1kC8OjF?=
 =?us-ascii?Q?JYn8Bja6Nsc1W/16f1npf9A/osmuGatWeTVFjcFEYBYExT9nHi1hmQ3LI/Yt?=
 =?us-ascii?Q?Z0PJuYIdQLNJZ3oZGpzeZf7fCgjqpvzUrRXkCXEzEC/juByyP8N7tS9p8nGo?=
 =?us-ascii?Q?075RPX5jfCYQlhDSfu4QpyepZP5GJO5HBlW+2+O6ugM3icuOH9UDVJ9VBmZc?=
 =?us-ascii?Q?QXSJSqn1gBFJIx8Hd2pwXhuKq8Czo0G/38tqjjoZvbh+wtUPKwGWYyTfJAX6?=
 =?us-ascii?Q?vbfxnpqyuwInfOro/VTA3AjCWWGJiO6Ee2rIP51U55b/dKxMt89LWiXPWWPb?=
 =?us-ascii?Q?UBlePRDwErRuiyeAwkRcrj8RggcuStF8tSDn/M80zW+2W9h+8OVe8KecGXHS?=
 =?us-ascii?Q?w4lVJMdDAwt23wZ8ijkRJpptZcHwjBk3J3xqEFVzVi5pEVCB8rIU7tiUP++R?=
 =?us-ascii?Q?NXyD7jVN2KEZSbAn4wwd9V+rPisFjqgpjMhpOojmxLj2W1RR564lnUv+rzUo?=
 =?us-ascii?Q?mPT7qeu7AhI+jzKij4l9BbMdYG/k2BZT7Obvm51gmXcWmEUk9FS0ZHuTOVQB?=
 =?us-ascii?Q?S6FmE6cA0HfoIAk6HhJ1gKLoB5euqEgJxtPoPoG2VTlBw7lG3O8HQWwhj60m?=
 =?us-ascii?Q?a8R7rvPKXRJiMCqVeroAdKExlhnPXcfQ2TToyglZqNI3Ql1Fx5ZI3vP1iR4p?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2924f8e-6425-44d6-17c1-08db02f51962
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 19:06:32.3690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AS6ILk7cxf/nPnSu427HsjXMLtCAt0g8AHeDHWBhbdfoYs9MAolMPX6LyjHHxfjXNguxfC6YvbFn5OxOKfCIKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu,

On Mon, Jan 30, 2023 at 08:37:02PM +0200, Claudiu Manoil wrote:
> > -----Original Message-----
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Sent: Monday, January 30, 2023 7:32 PM
> [...]
> > Subject: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading drivers
> > to request queue count validation
> >
> 
> [...]
> 
> > +static int mqprio_validate_queue_counts(struct net_device *dev,
> > +					const struct tc_mqprio_qopt *qopt)
> > +{
> > +	int i, j;
> > +
> > +	for (i = 0; i < qopt->num_tc; i++) {
> > +		unsigned int last = qopt->offset[i] + qopt->count[i];
> > +
> > +		/* Verify the queue count is in tx range being equal to the
> > +		 * real_num_tx_queues indicates the last queue is in use.
> > +		 */
> > +		if (qopt->offset[i] >= dev->real_num_tx_queues ||
> > +		    !qopt->count[i] ||
> > +		    last > dev->real_num_tx_queues)
> > +			return -EINVAL;
> > +
> > +		/* Verify that the offset and counts do not overlap */
> > +		for (j = i + 1; j < qopt->num_tc; j++) {
> > +			if (last > qopt->offset[j])
> > +				return -EINVAL;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> Not related to this series, but the above O(n^2) code snippet....
> If last[i] := offset[i] + count[i] and last[i] <= offset[i+1],
> then offset[i] + count[i] <= offset[i+1] for every i := 0, num_tc - 1.
> 
> In other words, it's enough to check that last[i] <= offset[i+1] to make
> sure there's no interval overlap, and it's O(n).

Hmm, actually you bring a good point, which I didn't notice.

It looks to me like someone had an idea but never went through implementing it.
The complexity is O(n^2) because it's actually only the overlaps that
the code is supposed to check for. It's not necessary for TXQs to be in
ascending order ("last[i] <= offset[i+1]" isn't a given).

I'm pretty sure that TXQs can also be mapped in reverse compared to the TC,
like this:

tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@7 1@6 1@5 1@4 1@3 1@2 1@1 1@0 hw 1

Which *should* be allowed (at least in hardware, it is), and which would
indeed justify the higher complexity validation function.

But with "hw 0", the existing code indeed doesn't allow that.

We would need this change first, targeting "net":

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 4c68abaa289b..4f6fb05a4adc 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -101,7 +101,8 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
+			if (last > qopt->offset[j] &&
+			    last <= qopt->offset[j] + qopt->count[j])
 				return -EINVAL;
 		}
 	}

then see you in a week from now, with net-next merged with that patch.
Oh well.. :)
