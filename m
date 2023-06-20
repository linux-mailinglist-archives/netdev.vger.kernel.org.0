Return-Path: <netdev+bounces-12096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D093C736158
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E9511C20A4C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E541119;
	Tue, 20 Jun 2023 02:01:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE410E3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:01:56 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F287118;
	Mon, 19 Jun 2023 19:01:54 -0700 (PDT)
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QlVHb1Zffz1HBdR;
	Tue, 20 Jun 2023 10:01:47 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 20 Jun 2023 10:01:51 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <shaozhengchao@huawei.com>
CC: <caowangbao@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>, <liubo335@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <pctammela@mojatatu.com>,
	<renmingshuai@huawei.com>, <vladbu@nvidia.com>, <xiyou.wangcong@gmail.com>,
	<yanan@huawei.com>
Subject: Re: [PATCH] selftests: tc-testing: add one test for flushing explicitly created chain
Date: Tue, 20 Jun 2023 10:01:13 +0800
Message-ID: <20230620020113.2040080-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <961f4d1a-6756-0a09-f578-5bf5791a1a64@huawei.com>
References: <961f4d1a-6756-0a09-f578-5bf5791a1a64@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.137.16.203]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Hi renmingshuai:
>On 2023/6/17 11:20, renmingshuai wrote:
>> Add the test for additional reference to chains that are explicitly created
>>   by RTM_NEWCHAIN message
>> 
>> commit c9a82bec02c3 ("net/sched: cls_api: Fix lockup on flushing explicitly
>>   created chain")
>> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
>> ---
>>   .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>>   1 file changed, 25 insertions(+)
>>   create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>> 
>> diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>> new file mode 100644
>> index 000000000000..c4c778e83da2
>> --- /dev/null
>> +++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>> @@ -0,0 +1,25 @@
>> +[
>> +    {
>> +        "id": "c2b4",
>> +        "name": "soft lockup alarm will be not generated after delete the prio 0 filter of the chain",
>	 "Delete the prio 0 filter of chain" looks better. And adding
>  test result in comment also will be better.
>
>Zhengchao Shao
Thanks for your advice, and I have add the test result in comment.
https://lore.kernel.org/netdev/20230620014939.2034054-1-renmingshuai@huawei.com/T/#u
The original name can describe the purpose of adding the test case, which would be better.

