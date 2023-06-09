Return-Path: <netdev+bounces-9514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC39672992B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90FDA2818E8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0FA16425;
	Fri,  9 Jun 2023 12:11:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88045A93C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:11:13 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2075.outbound.protection.outlook.com [40.107.105.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6DC1BE8;
	Fri,  9 Jun 2023 05:10:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcppCB/O5QL8ZkLDmadepi5lC3AooeobnrXRKDeLpJ1/QXJOtQPcE1EDnSE5AxKV1SZlf8SgvQPGntRcTSJMAq5m7Dxn3Y2UsiqiGs6BqGjem383TbDMjlyGeptqqgCGH2IUJngr/FkbmNhr+pUt8ZMJR6BW9erzfmZMeo/+xnjkVMcwHtEs4Hlq76KlsoW99kvfZC9f9cie9VjfMWfBbdSzcdFp9f/3JriNUgxFU3wbDybTtPSSoa4qeTyQlUdNO8wtxtzd/c9UM36NJSWQkh2wSJspTzWBsPEH8tLwTQG3hvvFv6C+NUEjb+Btk6llwgP5xtKw5OLkrPX5WfX1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D83M5hAjUOwe3EL6UbrSzxwaVOdEv8G4SyQI2rMu5fQ=;
 b=Foo5mkxKi0aVj9u0AHvt+MAvxyQF69hqMjeueNMz0tTpokzMP+2DKgs4lKIznVZ3GBsSLyZsub2M6FNcopBElU99MuPUysynfdjd8WmyCJUk12DOa9un++6TCId2jJDYid08lpxwuRqgc1jQfd2vgNaeGMClY6sbqAWptPYmUa0YBgr/nBYGaqLeMt3tu9NFv+DYWcZfSuU5Et8O4MAvvCxgYnWmwv2csf05OUM73NTwkRSAsUxpgaIeRRbMeYYMncU6aYipqivM4pz6II2l29ksDAVj8+l65Ia7IQW8PjnHbyN/Aay3kl4VvkROt0w9V1A7ao/QkqcUSXQ8KH3HvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D83M5hAjUOwe3EL6UbrSzxwaVOdEv8G4SyQI2rMu5fQ=;
 b=kmsK9pBOr2yVmzrjR9yK6BRq+DJ32D27Au6VVAXVyZd3rY1P6qhax0zaw8jTIey8GWQHZSJmzh7oDzmRnxg6X1YSU90o9mVOvGhYRd2nS5lJ18eAUcz9CNDJi+PyCg+hngOF4Lc1mvK+ATb6C8Gv1IMZW6xntu3hGj7iU59Y1gM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9105.eurprd04.prod.outlook.com (2603:10a6:102:225::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Fri, 9 Jun
 2023 12:10:48 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:10:47 +0000
Date: Fri, 9 Jun 2023 15:10:43 +0300
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
Subject: Re: [PATCH RESEND net-next 5/5] net/sched: taprio: dump class stats
 for the actual q->qdiscs[]
Message-ID: <20230609121043.ekfvbgjiko7644t7@skbuf>
References: <20230602103750.2290132-1-vladimir.oltean@nxp.com>
 <20230602103750.2290132-6-vladimir.oltean@nxp.com>
 <CAM0EoM=P9+wNnNQ=ky96rwCx1z20fR21EWEdx+Na39NCqqG=3A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=P9+wNnNQ=ky96rwCx1z20fR21EWEdx+Na39NCqqG=3A@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9105:EE_
X-MS-Office365-Filtering-Correlation-Id: b81ac534-10e3-4b6a-054a-08db68e28e84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nBD6BmaIj3YKec2A2YzeXdhcUdh4qq3DHje4lD05g1+SFCxHpcZqgCEsjWF+FItuSecJ0EZmBQm0i3gietNtbMok01uStX2HneOwdwlwtzaVGC4KEDycxWLwiiSlqJcRZr2suRcRWc9vzqnBue1Ly9T46tUM3thtWchKTAAxlsRCSTSYqNB2LGPlZqwGvKBGhoG4rkQ73UnNO1OxbN4nMKPDLIfUSYCnj+7feLavIyrI7jfpS9e+N8Ij1fQoC139yifY1kMewtFcjUQmRjUUtb9VW2OdRTfXOSzu8fZ+/4VngeDWGRi8VtDh7iRrKaDkvlDn7cxE8ED5lUQ38esaij88cHNkUvVVvKgxvqY5txB6UKaE5M0jtPI9SYkNGx0ZoX0lzYYMOSJ/Xzkb1lQ4u1aCoUhl4D8fYodx1V3uNdYkM0f2xlwsvZYtmFJQGF6r26ej5taNFTF7IbDvhwebo4Xo4774gmeYSu+h1GTq7XbiaY/CdY+etXmXD6pGw1wvOtAntpvsHzIsi5E7pW8f4hQrky747CjiL1cxba7vmLf4yqf2nEPPucYuiB9IYQZN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199021)(54906003)(478600001)(7416002)(8676002)(2906002)(44832011)(8936002)(5660300002)(86362001)(33716001)(6916009)(66556008)(66476007)(66946007)(316002)(4326008)(6506007)(41300700001)(38100700002)(9686003)(6512007)(1076003)(26005)(83380400001)(6486002)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZcBesPfbs5NN5LX+HwZFrnhgkpperEs+uF9dIqXx362vD62gMqngK4LqFgiw?=
 =?us-ascii?Q?B00844st+IzELEz3XcbluIHyHyL3NLLwlbAG8hqSaCrGJ0GXdEYgfOOkPjDL?=
 =?us-ascii?Q?45bA6xaChmoeE8lfqltRtHysdmvKi3HRNSDXO7ozKEYGRrOaj5YxpD/28+ow?=
 =?us-ascii?Q?nhMbGYWmcLgIJIKYL5lU5cgBUQ2BeRzlLt0X9eqdJl8hARbRt/jKF+RlOp1q?=
 =?us-ascii?Q?FkUubgVXqtGblOMmFPhgzxCsmxz/ARwWnIjI9d9gwvMp6XGwuyCQx1mm9xqE?=
 =?us-ascii?Q?0ie/YEmwy3CMvNFMrNLEyOObAcv+2tPp/aiNn7yRFuLbGOs0pH0hdRqcpuqu?=
 =?us-ascii?Q?m+7xdgV+Gfv8bmETJFa9P7PJEpofCIO2avkit/hOBictMEpnArPkx2G9TGlV?=
 =?us-ascii?Q?UeRb40chHoD9RFt/+G4skOx0pvZQ6SRfjger43frt4P3Cy94KrqUECGj1Gsy?=
 =?us-ascii?Q?/RqJ7+AQCxmMpRLfC7LOcG81qN1iVt555iYvvsP/d/V8BR59LkKztTMj5IuY?=
 =?us-ascii?Q?fsQ5yNsn/RYE1UoaWDxCJceEs5i44sDsn5PyDeTFz8Q+2ICIKOGJZ/o4D2HN?=
 =?us-ascii?Q?sxPinHASBvv24wGbusR1g42fvp039j6l1G7vEsAeqPr6YnfYCR/uWpokeqzE?=
 =?us-ascii?Q?GP4K7CZDoad9+HeW9sXkIgD9s3LlHhlNvnAHlbjZlyLH20mJyxnHQfloOkWE?=
 =?us-ascii?Q?h/SGkSKNIUQPgqC5ilnvLRAb3WAoiKQW16Bp+Y76QK0NEwLOfih7oQOI8bgF?=
 =?us-ascii?Q?U+UODaxgpJIH6P6b6ZOokJtxuOM/cB0gx6t03Wa5fiuFQvH3X45mHhSQU4hq?=
 =?us-ascii?Q?ZuR/7T4Gd8V2ZlJKCEou/Jw/afyaWYnW+E8vHrPqAC3kfTMRsI+OOScP/6ZM?=
 =?us-ascii?Q?PXhIzEcaHGxa8IZ1COtbKYYwjIcH/BsPG2kCD6weJZ179HoGHSgHPSPlcWDn?=
 =?us-ascii?Q?HzuLmaYHQQCvpja6wHQ/FsqvZfNy4kmHVj+wYFyq3UdZseUj8QkmP5wavuM+?=
 =?us-ascii?Q?FDRdrc4ga5KMfgRZeui0RyYjY7aVIlmIIEz3iY5Sg5X74bhHggnrlPwZDymw?=
 =?us-ascii?Q?xQ2Fz6NXjO4F1IzxOFGs8BukmT4IvGZdyQ9h2KLR82iQzuorLYDTSZDfpx/W?=
 =?us-ascii?Q?kDR1I+2qkMgICtC7gQvDKpa90sATHgU8SEWaOhpvPUzt/iX1Hp2eFqvFVIIz?=
 =?us-ascii?Q?jGHnL2lzmwOX3tgsRUW31a1md30d9gBTh2wPIBlyD/Rfdr+tyFy0jPKDC9dy?=
 =?us-ascii?Q?+deXMqbCL4DpowR1uYpxgHoohb+zKQkBAgK7NJKRWnOaKrmoH+OCyVh7Qnge?=
 =?us-ascii?Q?aAtICd5RmvXgOPCDt8/ZKmJGfOzoYnYulzeM4gwQowMiYOVuXUwVXwFpHwi1?=
 =?us-ascii?Q?OO60KL9Ly3t565oDhS3OUYc85MC+XuEaYOqqkDWK6gNIXxU4+xQAvfyJk085?=
 =?us-ascii?Q?mo3L8xtgR/TBTsiejP2lkXe39qF5Dxapn8RZxypUN6rTrJZ8PwkelC1hCjrp?=
 =?us-ascii?Q?GGb3PfNxdI+Eug9+0Fv+suPmHr/TT+4BVNYaXvLCnqIu4gYrSPIJNmwJTVRr?=
 =?us-ascii?Q?uTmvST1fAbhH2qL56IR42i77r+s06utqdd2Ek6nTskO8QFk+/0Y7J4X/KZ6T?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81ac534-10e3-4b6a-054a-08db68e28e84
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:10:47.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsWlBAojayvsAjcBXhjJuV7Gqg3IEW9fe13ghYZ/yDsYcWjaiqJ24Qu0Og2usc9LymO4TPwfvCjmiMXM1YEDww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9105
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 02:44:46PM -0400, Jamal Hadi Salim wrote:
> Other than the refcount issue i think the approach looks reasonable to
> me. The stats before/after you are showing below though are
> interesting; are you showing a transient phase where packets are
> temporarily in the backlog. Typically the backlog is a transient phase
> which lasts a very short period. Maybe it works differently for
> taprio? I took a quick look at the code and do see to decrement the
> backlog in the dequeue, so if it is not transient then some code path
> is not being hit.

It's a fair concern. The thing is that I put very aggressive time slots
in the schedule that I'm testing with, and my kernel has a lot of
debugging stuff which bogs it down (kasan, kmemleak, lockdep, DMA API
debug etc). Not to mention that the CPU isn't the fastest to begin with.

The way taprio works is that there's a hrtimer which fires at the
expiration time of the current schedule entry and sets up the gates for
the next one. Each schedule entry has a gate for each traffic class
which determines what traffic classes are eligible for dequeue() and
which ones aren't.

The dequeue() procedure, though also invoked by the advance_schedule()
hrtimer -> __netif_schedule(), is also time-sensitive. By the time
taprio_dequeue() runs, taprio_entry_allows_tx() function might return
false when the system is so bogged down that it wasn't able to make
enough progress to dequeue() an skb in time. When that happens, there is
no mechanism, currently, to age out packets that stood too much in the
TX queues (what does "too much" mean?).

Whereas enqueue() is technically not time-sensitive, i.e. you can
enqueue whenever you want and the Qdisc will dequeue whenever it can.
Though in practice, to make this scheduling technique useful, the user
space enqueue should also be time-aware (though you can't capture this
with ping).

If I increase all my sched-entry intervals by a factor of 100, the
backlog issue goes away and the system can make forward progress.

So yeah, sorry, I didn't pay too much attention to the data I was
presenting for illustrative purposes.

> Aside: I realize you are busy - but if you get time and provide some
> sample tc command lines for testing we could help create the tests for
> you, at least the first time. The advantage of putting these tests in
> tools/testing/selftests/tc-testing/ is that there are test tools out
> there that run these tests and so regressions are easier to catch
> sooner.

Yeah, ok. The script posted in a reply on the cover letter is still what
I'm working with. The things it intends to capture are:
- attaching a custom Qdisc to one of taprio's classes doesn't fail
- attaching taprio to one of taprio's classes fails
- sending packets through one queue increases the counters (any counters)
  of just that queue

All the above, replicated once for the software scheduling case and once
for the offload case. Currently netdevsim doesn't attempt to emulate
taprio offload.

Is there a way to skip tests? I may look into tdc, but I honestly don't
have time for unrelated stuff such as figuring out why my kernel isn't
configured for the other tests to pass - and it seems that once one test
fails, the others are completely skipped, see below.

Also, by which rule are the test IDs created?

root@debian:~# cd selftests/tc-testing/
root@debian:~/selftests/tc-testing# ./tdc.sh
considering category qdisc
 -- ns/SubPlugin.__init__
Test 0582: Create QFQ with default setting
Test c9a3: Create QFQ with class weight setting
Test d364: Test QFQ with max class weight setting
Test 8452: Create QFQ with class maxpkt setting
Test 22df: Test QFQ class maxpkt setting lower bound
Test 92ee: Test QFQ class maxpkt setting upper bound
Test d920: Create QFQ with multiple class setting
Test 0548: Delete QFQ with handle
Test 5901: Show QFQ class
Test 0385: Create DRR with default setting
Test 2375: Delete DRR with handle
Test 3092: Show DRR class
Test 3460: Create CBQ with default setting
exit: 2
exit: 0
Error: Specified qdisc kind is unknown.


-----> teardown stage *** Could not execute: "$TC qdisc del dev $DUMMY handle 1: root"

-----> teardown stage *** Error message: "Error: Invalid handle.
"
returncode 2; expected [0]

-----> teardown stage *** Aborting test run.


<_io.BufferedReader name=3> *** stdout ***


<_io.BufferedReader name=5> *** stderr ***
"-----> teardown stage" did not complete successfully
Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'Error: Specified qdisc kind is unknown.\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 14 3460 Create CBQ with default setting stage teardown)
---------------
traceback
  File "/root/selftests/tc-testing/./tdc.py", line 495, in test_runner
    res = run_one_test(pm, args, index, tidx)
  File "/root/selftests/tc-testing/./tdc.py", line 434, in run_one_test
    prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
  File "/root/selftests/tc-testing/./tdc.py", line 245, in prepare_env
    raise PluginMgrTestFail(
---------------
accumulated output for this test: 
Error: Specified qdisc kind is unknown.
---------------

All test results:

1..336
ok 1 0582 - Create QFQ with default setting
ok 2 c9a3 - Create QFQ with class weight setting
ok 3 d364 - Test QFQ with max class weight setting
ok 4 8452 - Create QFQ with class maxpkt setting
ok 5 22df - Test QFQ class maxpkt setting lower bound
ok 6 92ee - Test QFQ class maxpkt setting upper bound
ok 7 d920 - Create QFQ with multiple class setting
ok 8 0548 - Delete QFQ with handle
ok 9 5901 - Show QFQ class
ok 10 0385 - Create DRR with default setting
ok 11 2375 - Delete DRR with handle
ok 12 3092 - Show DRR class
ok 13 3460 - Create CBQ with default setting # skipped - "-----> teardown stage" did not complete successfully

ok 14 0592 - Create CBQ with mpu # skipped - skipped - previous teardown failed 14 3460

ok 15 4684 - Create CBQ with valid cell num # skipped - skipped - previous teardown failed 14 3460

ok 16 4345 - Create CBQ with invalid cell num # skipped - skipped - previous teardown failed 14 3460

ok 17 4525 - Create CBQ with valid ewma # skipped - skipped - previous teardown failed 14 3460

ok 18 6784 - Create CBQ with invalid ewma # skipped - skipped - previous teardown failed 14 3460

ok 19 5468 - Delete CBQ with handle # skipped - skipped - previous teardown failed 14 3460

ok 20 492a - Show CBQ class # skipped - skipped - previous teardown failed 14 3460

ok 21 9903 - Add mqprio Qdisc to multi-queue device (8 queues) # skipped - skipped - previous teardown failed 14 3460

ok 22 453a - Delete nonexistent mqprio Qdisc # skipped - skipped - previous teardown failed 14 3460

ok 23 5292 - Delete mqprio Qdisc twice # skipped - skipped - previous teardown failed 14 3460

ok 24 45a9 - Add mqprio Qdisc to single-queue device # skipped - skipped - previous teardown failed 14 3460

ok 25 2ba9 - Show mqprio class # skipped - skipped - previous teardown failed 14 3460

ok 26 4812 - Create HHF with default setting # skipped - skipped - previous teardown failed 14 3460

ok 27 8a92 - Create HHF with limit setting # skipped - skipped - previous teardown failed 14 3460

ok 28 3491 - Create HHF with quantum setting # skipped - skipped - previous teardown failed 14 3460
(...)

