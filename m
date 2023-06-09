Return-Path: <netdev+bounces-9477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4904B7295C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0EBF2818A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA59313AFD;
	Fri,  9 Jun 2023 09:46:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A720C12B9A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:46:28 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2068.outbound.protection.outlook.com [40.107.6.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B16769D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUey7IZhlt4+/Z2o0hwYg8vEBb4/uqdTZ5jABOUPUQFGGiN7wBTtRbhKkhqltVcGDf+JFFDbvEkuasYzaXNdHwr42r0Le9yRx5ZAaM7zeQ6P8OogjjFJERBX9YsSXr5WNPbYe2juuFix5gNM6T2vBQ7RPpKBQOOAVt1PoqYdu8poY4FGigBVg2k2jmzaNnU7vIDHGLXTVrtQOkpa7KNi0JftLHykaM+6Kj/1YGSKZ8vFCP/d0CknE2p/dU9NAEE1vbkaFPwVzPykf5SG4OpLgJAjLUuQ9jZDlr3jbFl8N7Uz/EBSiPvQnwBbSlcB1wrWUD8DOJ2wH79J72lbmwhOhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/iofrl6e2hKz3oUjhxC8tpxO8q9O5yqtGn/fH4yeTM=;
 b=SrZwPUbmyLlfXZeLMlH51uzidE7cMKaRttU2CUJEd576mB/zmTKsy5WdlaYMqZX4syOrpCL9lrA5oVWAymK/jDqTQYTJssZPniP85M81v6YpPs0HOC/lo6bwRv3M3P9U2MVwBbTj6Y03f/O+Hff/TvGcil49ap1EqUDmW7gOtnTMARRKzzzqlXlroDk1kzhiqMJ9Y9I7w6P3+XSe/7BPoUsWp/r9e0MXUrleJjhLZO86JwCnUUaIxmLuXIFv3b7gz4EWT2ILIP6JJER3Lc8p4WeGvvyji/temmvUrIbDY1Rv2B6lJY/6UOu0XGAz1hTQJSH9Io/gjOnMLmt4aMTq4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/iofrl6e2hKz3oUjhxC8tpxO8q9O5yqtGn/fH4yeTM=;
 b=gxKeytZSwZbV3+t4C7GhSrPFEvtisrJOz/5VwESn6ORjPyLG42je1Ezseqf6C8ZB9N6wMBL7AcsVFkmPpY42IiMFwxLHl89RrICqKylxP74LHtCgozeWB8gSY9t40rvf/4NE4mUEKVGIV9Hc7Jjd/hLABWBNzXf2OaLSmsFs5xE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7787.eurprd04.prod.outlook.com (2603:10a6:10:1e3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Fri, 9 Jun
 2023 09:45:46 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:45:46 +0000
Date: Fri, 9 Jun 2023 12:45:42 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: shaozhengchao <shaozhengchao@huawei.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>, netdev@vger.kernel.org,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
Message-ID: <20230609094542.y3doavs6t4qk2jlo@skbuf>
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
 <87zg59sbzb.fsf@intel.com>
 <e01c0675-da18-b1a9-64b1-4eaa1627fcb8@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e01c0675-da18-b1a9-64b1-4eaa1627fcb8@huawei.com>
X-ClientProxiedBy: FR0P281CA0170.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7787:EE_
X-MS-Office365-Filtering-Correlation-Id: c57951e6-dfd8-49b0-1e8b-08db68ce4c60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZAzAFL5m3dBvN3tnaNGF/wRyMuFepKewUIxhcnoMoHDRRd01b6UTndertHTAQDrPQiLlknlBOIZ1wO5aWv69JA+/g1kAD4MMjUOF/mqU+I4DjcawLxRXVGdWEa82HNQ81ov6uI5r2T8LgBK0U6Avop8VTcw83mTC4AbZ4lM9dYqxS7k7mHAJP87nUzetijwh8QyRfC25DWKRp9CfzfiTzadBw1bJXP8jbV4khcgV2AE6lRrsLNxUa4sucudrqhNbxvv0mOg4eFg+9o9xHZvzqxbU9irpZ3EFXepTA4hhO84JkBSkFqWHKKRj8Fj92qo8TlvSApVZ4qTzOeNJeF/ku1cO1F7s+2F1eu7ScWSi/4/LsppbHKPf00Z4gup8IhAUjLyOcvKMZ10pBdI6c3UlxdB6ATXay19j7B78kvSyrGyraW4sAOxn1VL27gVSdWkXDmRM3Ir7PDwwkgQU2twft9vQKf9yN0RTOH19mTA6OzgA7ImPRN6WpmaqyR/NAzsRtWCazHNiXppEnz3OgChyjPGtSQ3ILAV/X0FhyuLAru8zgHudY0Ec7MrnFXe5NTXP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(66476007)(316002)(6666004)(66556008)(6916009)(4326008)(478600001)(86362001)(9686003)(6506007)(1076003)(26005)(6512007)(186003)(83380400001)(41300700001)(8936002)(8676002)(7416002)(44832011)(2906002)(5660300002)(6486002)(33716001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+W1E4H/qXBLm982+vcPtSrgNdY1LfJiXH1hNVJKbN4/TjomNi3koRD2n7jx2?=
 =?us-ascii?Q?Z4n+/5izc2L/Z6jglulG8/NiSQnru+WX9XV5PZBI0klBuewhU3WDwr7g7GQC?=
 =?us-ascii?Q?nfgxNS6ZIRokrL/MvMdApbcqS/Ar2IAwHa7WL0wK2TQHrneHIFfv/sN7sDjM?=
 =?us-ascii?Q?B74vLIrlDUAG51de8gg8ZrutKrNPTac7pxvjgyQS5JShBfpXZmip4teMrz6j?=
 =?us-ascii?Q?oKwRiewe/E5I/G77GHzmdgHCp1YnKZrkOr6xotycpaplmCMJhWcv5gVZc+xf?=
 =?us-ascii?Q?nEDQvktloWqkL5nF8Vtcbp4bHHK4Y3wraROeV725xXmtpCDP8HiOrgAXJaAE?=
 =?us-ascii?Q?8nyu8OvN0D6cDYcFiBenb8rXIkMBhaCCB6ToJSqG+Q+3wf193xc23mNXBRNi?=
 =?us-ascii?Q?xGmATU/i7xN1XgTNyyUaIRJTjsaLNSWKYgy/voVurnMY6qFqTL8vInT833Qh?=
 =?us-ascii?Q?uBUN+tr2pZ9YG9UASa8mksYZttu7Sy3zxVP4hnrz6bKCqfvjiwy3ezl7jt/V?=
 =?us-ascii?Q?O6FGdq6an8MyJvGfY4QGDiJmDhqMOKdE2N1sX5U9Xe/jWKQvv1Bh2s87HhlD?=
 =?us-ascii?Q?fPDK1JZRyaGlRc/r8y1ULhz/x/8dQtK7lH04zfm/7urjspmZQIZ2RvHbXY5z?=
 =?us-ascii?Q?UnOGLjjbUnX3sJyXSS98M3kbc2VPojjA4oH2/dfHRUbUZeLxX10vdKbNgmi3?=
 =?us-ascii?Q?1HLflp41U6eo5Ei2JPNtTHcV04Cvf+6yNiXv9OSFNPe0xrOkWh3XaC6Yk0Zp?=
 =?us-ascii?Q?46pQPFKrMWYpAZgSYlXwrMSAsQEcC7Pk7G33OzyEL4tMVfoj1yU4DC1Lr169?=
 =?us-ascii?Q?US2q9qiUjPEOwp7sGpN4yML1t8sEF5PhHbu5WrH5LsCPY5nalMK3PaN6U69d?=
 =?us-ascii?Q?wNeAq9HHEW64FDTOdsG9RkOFV6dAtNoHppaTLCs/KqKGiHpjZDaKsbqCGSnX?=
 =?us-ascii?Q?EbBtZ5+PAvPZ72NeY07xIr4wJzfV6qCRQMlFshEKTO8z1h4815KONrGvVaRI?=
 =?us-ascii?Q?M55mlVLyrOmlN0OfULkRS8LtnLdep9W0M24Fa8sy/XhjyYl/IHek6cEMAIGb?=
 =?us-ascii?Q?lRA+1e9frwi/nPK1x/Bk84TvbRoITX97WZ1eDF8Gh3t18gzVKRSC6itlxvt4?=
 =?us-ascii?Q?L63CSs4iAHcLRo6fx+SyA/egLPZPO8EV0PvaIIOAr9cHcGR2wRHLDCHbrFx0?=
 =?us-ascii?Q?xFqwA3VWcQ67iLZGPHKsX8lK1I9NUKaLnmIzwY3yu2w6/mCpg3q4hOySsZS9?=
 =?us-ascii?Q?/n9X+lfPkfkBt5yUwjBc92yyE2IBkHYXVvYw8aQGcSouWSQAqcouE9Rgi9hR?=
 =?us-ascii?Q?Xo5ozx3gDtj4L9iewdMD4D94UlcC6OgRjUr+PNgN9sfnIQ5Sx1kgBY1NFcVx?=
 =?us-ascii?Q?NZQ16mkAT9+QxpAXDCGBFzBd2sQOod7q4lqa5i08x22z9MPv+IwwrQapp3AE?=
 =?us-ascii?Q?2HGi5hrZMzdaxRbYD03nBMG0qarvLJgHOnVoU8QbDT4Fud3eBEg4oWP4mqEj?=
 =?us-ascii?Q?VOkuq7gMTaRM6iPWbLWApx0aFzwGDQdrmwZJSeuwN1jCnsYiGO+DgnE5IueJ?=
 =?us-ascii?Q?C6Zv/OmKHeUwRMlY7C0fpW5BXrI74MXQm01kbmv7R/pHZQ5puIEntB/TCUOk?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57951e6-dfd8-49b0-1e8b-08db68ce4c60
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:45:45.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vXmfce5oeYH+nLpbV885S/hq8Ok9UbwV/rqtbikrMWu8DBF7ZmtX78vCiVG1LYe2c8ojiw/Qz5R+GWuxLb+dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7787
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 09:57:20AM +0800, shaozhengchao wrote:
> > btw, (2) sounds better to me at this point.
> > 
> > Or is there another valid/sensible interpretation to '0@0' that I am missing?
> I think I know what you mean. Your intention is to make judgments
> simultaneously during the enqueue process, as shown below?
> 
> static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>                           struct sk_buff **to_free)
>  {
>         struct taprio_sched *q = qdisc_priv(sch);
> +       struct net_device *dev = qdisc_dev(sch);
>         struct Qdisc *child;
>         int queue;
> +       int i;
> +
> +       for (i = 0; i < dev->num_tc; i++) {
> +               if (unlikely(!dev->tc_to_txq[i].count))
> +                       return qdisc_drop(skb, sch, to_free);
> +       }
> 
>         queue = skb_get_queue_mapping(skb);
> 
> Is it like this?

No. If we go down this path (not saying that we should), you should only
validate the queue count of the packet's traffic class, not all queue counts...

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 978c3504fbaa..d1d10341278d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -633,11 +633,16 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	int tc, queue, prio = skb->priority;
 	struct Qdisc *child;
-	int queue;
 
 	queue = skb_get_queue_mapping(skb);
 
+	tc = netdev_get_prio_tc_map(dev, prio);
+	if (!dev->tc_to_txq[tc].count)
+		return qdisc_drop(skb, sch, to_free);
+
 	child = q->qdiscs[queue];
 	if (unlikely(!child))
 		return qdisc_drop(skb, sch, to_free);

> 
> > 
> > > 2)When packets are dequeued, taprio can be deleted. In this case, the tc
> > > rule of dev is cleared. The count and offset values are also set to 0. In
> > > this case, out-of-bounds access is also caused.
> > 
> > This looks like more like working around the issue than fixing it, and
> > it just happens, it's a coincidence, that both issues have the same
> > symptoms.
> > 
> There are many trigger paths for this problem, and I worry that there
> may be missing scenarios after I modify taprio_change and
> taprio_destroy, so I modify the dequeue process.

Many other trigger paths like what?

The main code path leading to 0 TXQs for a traffic class that Vinicius
seems to worry about ("queues 0@0" in configuration) should already be
rejected by mqprio_validate_queue_counts():

tc qdisc replace dev eno0 handle 8001: parent root stab overhead 24 taprio \
	num_tc 3 map 0 1 2 queues 0@0 0@0 0@0 base-time 200 \
	sched-entry S 80 20000 sched-entry S a0 20000 sched-entry S 5f 60000 clockid CLOCK_TAI
Error: sch_mqprio_lib: No queues for TC 0.

We should thus concentrate on the other (involuntary) code paths that
can lead to there being 0 TXQs for a TC. Modifying the data path because
we can't figure out the control path seems desperate.

Is there a reproducer for the bug?

