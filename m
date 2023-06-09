Return-Path: <netdev+bounces-9452-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDE97292F6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A430E2817F7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11DFBA23;
	Fri,  9 Jun 2023 08:25:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74BAD51
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:25:03 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2103.outbound.protection.outlook.com [40.107.223.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E30A49EA;
	Fri,  9 Jun 2023 01:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjhdVpTgBOHs/vGqzW+9wXod16fyC3ojULwrFQHidpNo2x59cOSzXHpygY3n1EQjDY7cERniv5wCcPUctXOyzVBLNBPf+2M39Y6jKFcD48ItWSNseDHaN77TqplAsbKfe1UYzX+zUAdJ21d6DtVdVgaWDX9gXzsUSXuTWNul0/gLuitb+7O5X6NQEWDATXlvOI3Tjwi9gY+SL7UMnobGRDkuVjx52YzYivDRp+6Zhu09CFf3CBC5hNAvnkPZ3akuCMhDw8m1T0QKoz+Jy4tNHPwZNn6RJof/7dsipQ/Jl78q/Jl7Lx+2lOeQOO900D7gcTfCWqLo62JQCC0BNxQvBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jBWq3F/bgn3Jwk5K89azg3MaHwtb4tLqIHzi5a6KyQ=;
 b=Vbp+jch1oEdMDDtQB5sr8em6O9vukbrNkfHeXdnIkTpki6fyfbGHCwh19mLfmn/gsWZl9R7+wZO8b6mVq5bBOAsa3ed5JDSpZJo0dicvrogyW11Jz8lFy2g0ZHzHJ/0BvczQE5tJm+i9m5CSedOOTm9+lZuNVLoht8c70HUb9qrweUd++QkQX6LuBVxCGL7WJCeoeI+2uXq34yAfFhALV5D624EdwCKyKqXmY1NVxOSF+Q6cEFSc0wezw9MBkxZqoJCa6xPLFGMkroS7MPUwVKQ8IKvjr3Cki7hHdZADJhYgoUHIvpSKWlqsdGeLhZ0ft0gYs+eIqzIZscmwBuaMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jBWq3F/bgn3Jwk5K89azg3MaHwtb4tLqIHzi5a6KyQ=;
 b=XY8MUPooA6f0W2P+xmRDpDCJT8OexZy0EFLp/sKooQV2WPP7KpQFV/relZc/ltPnylDbw87Ni3rTRrtjTrZc+dPdnxHcGlGIWg7Fc/pUvferf/Vli6YQK9wEktYDubHalqQPQDqHAGjK874aid/EYKkLux3mmEZ+MdedBC004CQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4125.namprd13.prod.outlook.com (2603:10b6:806:73::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 08:24:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 08:24:19 +0000
Date: Fri, 9 Jun 2023 10:24:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: renmingshuai <renmingshuai@huawei.com>
Cc: pctammela@mojatatu.com, caowangbao@huawei.com, davem@davemloft.net,
	edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
	kuba@kernel.org, liaichun@huawei.com, linux-kernel@vger.kernel.org,
	liubo335@huawei.com, netdev@vger.kernel.org, pabeni@redhat.com,
	xiyou.wangcong@gmail.com, yanan@huawei.com
Subject: Re: [PATCH v3] net/sched: Set the flushing flags to false to prevent
 an infinite loop and add one test to tdc
Message-ID: <ZILhrPYdQ4qRVDg/@corigine.com>
References: <91e6a8cd-2775-d759-4462-b1be7dc79bbe@mojatatu.com>
 <20230609033115.3738692-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609033115.3738692-1-renmingshuai@huawei.com>
X-ClientProxiedBy: AM4PR0501CA0051.eurprd05.prod.outlook.com
 (2603:10a6:200:68::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4125:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cddf0d5-b476-486c-04cb-08db68c2ebf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JxQDJ4BjEhrFmxk11obNbjW1eUt1DZaKQhZJfDsG/7Ki/3h28MtGV6P3/cWekcUFW1399hySheADodilxcKkqG4qIItMzflajHsnrAnsrAkZUymox3ift2fSPs6rzd6hHYQgCdRx1zEOajyiIip4Z+UCD9TI+5RHxPwMKyPbjBMbL2Uf/7XkgT//gglzpBQqgxAPpff9hjgDo4OUGpX/l5Qpu/HoV3xBbslut5UHSTl9XAf09BlFgGyn/jnZR5m+944COjVnoaqDVnpUtlxGYVtgns4/VOttXIt/xSMY8Gzz4eM1bIs3MHfngQiOIO8tixnEB3DJabRxzuEyaDMFet0nbHG7bLjCLoCPc6NNSupiPGbXlogmqHKfyfug16uHSL1WW1dGnqMMAFLHedj3vMzA6NM6hXD+xbJNIga4NThoNCZvBdZSr6vdQ8fMDbLToZYH8gnTMwmsqZK7wXySvSzf/EMFmd/tiORbMIod/upnMGqMs3NcRpEh0Sc9zMdbv79YNaLQcJZeJMT88AaXg9P8PchG7xvl8TYm8Iqbttk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(346002)(136003)(366004)(451199021)(186003)(83380400001)(478600001)(6666004)(6506007)(6512007)(53546011)(2616005)(66899021)(8936002)(86362001)(66556008)(44832011)(316002)(4326008)(6916009)(66476007)(36756003)(6486002)(66946007)(5660300002)(2906002)(966005)(41300700001)(38100700002)(8676002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lXxlqyX76xDQNB+TWEeRgCQlJu4oISa8MtgOryIBwP1Q0gqSGrtHnzUoxDBF?=
 =?us-ascii?Q?647UDlk7QkNJbwHwNdy0GD2DaHN38rnQV2JUzPXnX+nMWP9v3FwCJNnd06VJ?=
 =?us-ascii?Q?uwQ+9FWo8sVPiFbMwb3fq6zQlMXdpP4ibJZssIx3t8Xpx16sx3tdwSR5PGlT?=
 =?us-ascii?Q?jLCrifOyygB7PoRWihHLIH+XD7dl1hg2zF6vMaWGJQY6mY+SrVwXu99F7PpR?=
 =?us-ascii?Q?/OD0XwlTlv7DfVtN68LPtBVdee3F7ZOOIjOc6s2pwlnuc7E1nnvMj8Xku6eF?=
 =?us-ascii?Q?s6FdGWTnhkYkXDTwOjMBevo1d0Z3mZvCX9N0MH2NFPKDFvqNbyc5YTFtrJsx?=
 =?us-ascii?Q?lg9iSykqUYCQw1ADERQLmnywAxtvR8uEAz9OZNwRs2feKWZzlfvUJQ5t37cB?=
 =?us-ascii?Q?a89LL/Vu+B1ny2oyfqU6PoIYy7JSAfW0T6+xEjM7INMJBYtzPZnlZ4h4pqSt?=
 =?us-ascii?Q?pU0FqJbXSPY1463OVT1KTv3GxJj7S9GYPRdL9c0SKAd2esftEBLt7w0QI+Oq?=
 =?us-ascii?Q?wWuXNeup4cIuKyqN9FuiP4EaNFZ2kMgmRH5ojmM0z/mJngpdMPX8HiT1pSRK?=
 =?us-ascii?Q?VU6LFOfVp0eTo7AJXiNFNBYO8ZqRt5Bgy1TkDyBlO8UHMdn7JKLXqbXjDlxe?=
 =?us-ascii?Q?T6GsMVaDN2RL0YDeybeHiQZnP9Y4zSP3lfMsNflPO4dkvW+PZaLWxV48MbIO?=
 =?us-ascii?Q?X90nd5P+D4MduOvRaqoIhkBqyJUbiRd/t6nlpsHrzsIM2S1rCMKOKNsGL2Lq?=
 =?us-ascii?Q?/DSl5jz673l8+kCBCV91udy5tpzvOdalfnaCDVSNyKupjfK9EL2WKl6wd8Fe?=
 =?us-ascii?Q?PWQv46xaAqJA+oNofbmA7PWmL7PWwacm3DfnSwz1kqU9l3uAJuyYjOkAboDh?=
 =?us-ascii?Q?EKHowlfo+6bdeEP55irfpICyb/0Y5W285rUiCYSeQTcx8AVLQga5/7CeAIv4?=
 =?us-ascii?Q?73vhBoY5n+IHOTYMvHoBKrl6NChef9nYwNZPwUT2sP5esSuWcr46tQUMEOwy?=
 =?us-ascii?Q?13pVPcqNx+KZxqX806sN2sfJEEuFIAg6A9pHUB5BTfFy1EsrMzvB06b4UUlK?=
 =?us-ascii?Q?HzDCAQzkuLABUVBnTOvrbM3xzNQ16f9XLKi3j03zx2cXkcUvkUYGThv5oVix?=
 =?us-ascii?Q?wxU0XXSpHDHyq+9Ef9noATbTJcRerL8UJqkGkH1eqws0qJvVzh7mlz1q78De?=
 =?us-ascii?Q?M5M34znQUJdIZGtmxRrAmWtLdaUJhaCuIj4lBf6UCrxccySQNjbNM7TLsPAn?=
 =?us-ascii?Q?r2D2bs8olA4prYCqgRzo8cj25nSU1ZMe/rnd5AtcH19vShnR84KTO9RDwhvE?=
 =?us-ascii?Q?zys3Usb2qLMQcw+QkenFoiBhFdrWOZkXge0zvqNWMvc9HQ/qZYbTOhrz2j+L?=
 =?us-ascii?Q?wpu9gGOw9daT75UfNtb8UQjjIIUUMNqIKOUKobjwLjqceveG/q6sj1EO2qY8?=
 =?us-ascii?Q?vGw5YnnWpOc3ho2FYE7pp8/2KS4h+YNH/LhWKWJgmbJde8To6BxQl4ot/CUa?=
 =?us-ascii?Q?h4eUVGqzCnXqg1gmwlzUcVoVM8BzyAzW0kjMlqV6aArIuEBEyzyPcn9JwCpE?=
 =?us-ascii?Q?cRg+evvwEbyCS8ByclbHq69/VfYhWa6NwMyJGwAnZHlyVEmhipsaide2KJr8?=
 =?us-ascii?Q?v6mPzTaOAlx42soAZ+ipBrqwfM9SpYWwKm7Wvyaq4wRy1WgMhV37Z2eLJkDJ?=
 =?us-ascii?Q?jEj13A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cddf0d5-b476-486c-04cb-08db68c2ebf8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 08:24:19.7051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zN5xFaLRaciF9cGuqzsxEJ3tMQwj3qL+qaqrP4bf8FRuvbcS0pv5N3Dgmla33bQJdrwmZtoI2urgNKw4qoD44JsHd92gQUMjZqJ7uVsWJ7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4125
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 11:31:15AM +0800, renmingshuai wrote:
> >On 08/06/2023 09:32, renmingshuai wrote:
> >>> On 07/06/2023 01:19, renmingshuai wrote:
> >>>>> On 06/06/2023 11:45, renmingshuai wrote:
> >>>>>> When a new chain is added by using tc, one soft lockup alarm will
> >>>>>> be
> >>>>>>     generated after delete the prio 0 filter of the chain. To
> >>>>>>     reproduce
> >>>>>>     the problem, perform the following steps:
> >>>>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
> >>>>>> (2) tc chain add dev eth0
> >>>>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
> >>>>>> (4) tc filter add dev eth0 chain 0 parent 1:
> >>>>>
> >>>>> This seems like it could be added to tdc or 3 and 4 must be run in
> >>>>> parallel?
> >>>> 3 and 4 do not need to be run inparallel. When a new chain is added
> >>>> by the
> >>>>    way as step 1 and the step 3 is completed, this problem always
> >>>>    occurs
> >>>>    whenever step 4 is run.
> >>>
> >>> Got it,
> >>> The test still hangs with the provided patch.
> >>>
> >>> + tc qdisc add dev lo root handle 1: htb default 1
> >>> + tc chain add dev lo
> >>> + tc filter del dev lo chain 0 parent 1: prio 0
> >>> [   68.790030][ T6704] [+]
> >>> [   68.790060][ T6704] chain refcnt 2
> >>> [   68.790951][ T6704] [-]
> >>> + tc filter add dev lo chain 0 parent 1:
> >>> <hangs>
> >>>
> >>> Also please add this test to tdc, it should be straightforward.
> >>>
> >> Sorry for not testing before. I forgot that the chain->refcnt was
> >> increased by 1 when tcf_chain_get() is called in tc_del_tfilter().
> >>   The value of chain->refcnt is 2 after chain flush. The test
> >>   result is as follows:
> >> [root@localhost ~]# tc qdisc add dev eth2 root handle 1: htb default 1
> >> [root@localhost ~]# tc chain add dev eth2
> >> [root@localhost ~]# tc filter del dev eth2 chain 0 parent 1: prio 0
> >> [root@localhost ~]# tc filter add dev eth2 chain 0 parent 1:
> >> Error: Filter kind and protocol must be specified.
> >> We have an error talking to the kernel
> >> 
> >> And I have add this test to tdc:
> >> [root@localhost tc-testing]# ./tdc.py -f tc-tests/filters/tests.json
> >> ok 7 c2b4 - Adding a new fiter after deleting a filter in a chain does
> >> not cause  an infinite loop
> >> 
> >> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
> >> Signed-off-by: renmingshuai <renmingshuai@huawei.com>
> >
> >Please respin with the following applied:
> >
> >diff --git 
> >a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json 
> >b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
> >index c759c3db9a37..361235ad574b 100644
> >--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
> >+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
> >@@ -125,25 +125,5 @@
> >          "teardown": [
> >              "$TC qdisc del dev $DEV2 ingress"
> >          ]
> >-    },
> >-    {
> >-        "id": "c2b4",
> >-        "name": "Adding a new fiter after deleting a filter in a chain 
> >does not cause an infinite loop",
> >-        "category": [
> >-            "filter",
> >-            "prio"
> >-        ],
> >-        "setup": [
> >-            "$TC qdisc add dev $DEV1 root handle 1: htb default 1",
> >-            "$TC chain add dev $DEV1"
> >-        ],
> >-        "cmdUnderTest": "$TC filter del dev $DEV1 chain 0 parent 1: 
> >prio 0",
> >-        "expExitCode": "0",
> >-        "verifyCmd": "$TC filter add dev $DEV1 chain 0 parent 1:",
> >-        "matchPattern": "Error: Filter kind and protocol must be 
> >specified.",
> >-        "matchCount": "1",
> >-        "teardown": [
> >-            "$TC qdisc del dev $DEV1 root handle 1: htb default 1"
> >-        ]
> >      }
> >  ]
> >diff --git 
> >a/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json 
> >b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.
> >json
> >new file mode 100644
> >index 000000000000..55d6f209c388
> >--- /dev/null
> >+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filters.json
> >@@ -0,0 +1,24 @@
> >+[
> >+    {
> >+        "id": "c2b4",
> >+        "name": "Adding a new filter after flushing empty chain doesnt 
> >cause an infinite loop",
> >+        "category": [
> >+            "filter",
> >+            "chain"
> >+        ],
> >+        "setup": [
> >+            "$IP link add dev $DUMMY type dummy || /bin/true",
> >+            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
> >+            "$TC chain add dev $DUMMY",
> >+            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
> >+        ],
> >+        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
> >+        "expExitCode": "2",
> >+        "verifyCmd": "$TC chain ls dev $DUMMY",
> >+        "matchPattern": "chain parent 1: chain 0",
> >+        "matchCount": "1",
> >+        "teardown": [
> >+            "$TC qdisc del dev $DUMMY root handle 1: htb default 1"
> >+        ]
> >+    }
> >+]
> 
> Ok. The new test is passed.
> [root@localhost tc-testing]# ./tdc.py -f tc-tests/infra/filter.json
> Test c2b4: Adding a new filter after flushing empty chain doesn't cause an infinite loop
> All test results:
> 1..1
> ok 1 c2b4 - Adding a new filter after flushing empty chain doesn't cause an infinite loop
> 
> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
> Signed-off-by: renmingshuai <renmingshuai@huawei.com>

Hi renmingshuai,

the above text, in it's entirety, does not meet the needs
of a patch submission for the Linux kernel. In particular:

* All the context from previous discussion (the bits prefixed by '>')
  should be removed.
* The patch description should consist of just that, a description of
  the patch. Any relevant test results are also welcome here.
* Information about changes from previous versions should be provided
  in the form of a changelog, typically below the scissors (---).

A recent example is here:
- https://lore.kernel.org/all/20230607162353.3631199-1-mtottenh@akamai.com/
  [PATCH v3] net/sched: act_pedit: Parse L3 Header for L4 offset

Also, please consider using spaces and capital letters
in your name in the from and signed-off parts of your submission.

e.g.: Mingshuai Ren <...> or Ren Mingshuai <...>

...

-- 
pw-bot: cr



