Return-Path: <netdev+bounces-11706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BB9733F58
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D08D281945
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43FA746C;
	Sat, 17 Jun 2023 08:01:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B511C33
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 08:01:33 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C2D2720;
	Sat, 17 Jun 2023 01:01:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QjpM53p5YztQTP;
	Sat, 17 Jun 2023 15:58:57 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 17 Jun 2023 16:01:29 +0800
Message-ID: <961f4d1a-6756-0a09-f578-5bf5791a1a64@huawei.com>
Date: Sat, 17 Jun 2023 16:01:29 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] selftests: tc-testing: add one test for flushing
 explicitly created chain
To: renmingshuai <renmingshuai@huawei.com>, <pctammela@mojatatu.com>,
	<vladbu@nvidia.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <liaichun@huawei.com>, <caowangbao@huawei.com>, <yanan@huawei.com>,
	<liubo335@huawei.com>
References: <20230617032033.892064-1-renmingshuai@huawei.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20230617032033.892064-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Hi renmingshuai:
On 2023/6/17 11:20, renmingshuai wrote:
> Add the test for additional reference to chains that are explicitly created
>   by RTM_NEWCHAIN message
> 
> commit c9a82bec02c3 ("net/sched: cls_api: Fix lockup on flushing explicitly
>   created chain")
> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
> ---
>   .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>   1 file changed, 25 insertions(+)
>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> 
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> new file mode 100644
> index 000000000000..c4c778e83da2
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> @@ -0,0 +1,25 @@
> +[
> +    {
> +        "id": "c2b4",
> +        "name": "soft lockup alarm will be not generated after delete the prio 0 filter of the chain",
	 "Delete the prio 0 filter of chain" looks better. And adding
  test result in comment also will be better.

Zhengchao Shao
> +        "category": [
> +            "filter",
> +            "chain"
> +        ],
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
> +            "$TC chain add dev $DUMMY",
> +            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
> +        ],
> +        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC chain ls dev $DUMMY",
> +        "matchPattern": "chain parent 1: chain 0",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY root handle 1: htb default 1",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]

