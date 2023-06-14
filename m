Return-Path: <netdev+bounces-10693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9332072FD67
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA0361C20C48
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A859B8821;
	Wed, 14 Jun 2023 11:52:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9FB8463
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:52:25 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47291BF3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:52:23 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qh3cD2rM7zMn0l;
	Wed, 14 Jun 2023 19:49:16 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 19:52:21 +0800
Subject: Re: [PATCH net-next v2 2/4] net: hns3: fix hns3 driver header file
 not self-contained issue
To: Simon Horman <simon.horman@corigine.com>
References: <20230612122358.10586-1-lanhao@huawei.com>
 <20230612122358.10586-3-lanhao@huawei.com> <ZIiqMMDMAV+asw7o@corigine.com>
CC: <netdev@vger.kernel.org>, <yisen.zhuang@huawei.com>,
	<salil.mehta@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <richardcochran@gmail.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>, <cai.huoqing@linux.dev>,
	<xiujianfeng@huawei.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <bdf02dd1-6251-8eb6-abb7-61d3e16e0cda@huawei.com>
Date: Wed, 14 Jun 2023 19:52:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZIiqMMDMAV+asw7o@corigine.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/14 1:41, Simon Horman wrote:
> On Mon, Jun 12, 2023 at 08:23:56PM +0800, Hao Lan wrote:
>> From: Hao Chen <chenhao418@huawei.com>
>>
>> Hns3 driver header file uses the structure of other files, but does
>> not include corresponding file, which causes a check warning that the
>> header file is not self-contained by clang-tidy checker.
>>
>> For example,
>>
>> Use command clang-tidy -checks=-*,header-should-self-contain
>> -p $build_dir  $src_file
> 
> Hi Hao Lan,
> 
> I tried this with clang-tidy-16 and src_file=".../hns3_enet.c"
> but i get an error:
> 
>   Error: no checks enabled.
>   USAGE: clang-tidy-16 [options] <source0> [... <sourceN>]
> 
> I feel that I'm missing something obvious here.
> 
> ...
> .
> 
Hi Simon Horman,

This code is checked by our company's internal static check tool.
CodeArts Check can be used outside of our company for this check.
You can use the link and you can find CodeArts Check.
In the ruleset codechecknew, you can find the CodeArts Check C
recommendation ruleset, which the clangtidy G.INC.05 header should contain itself.
You can sign up for a new account and have an one-year try free.

Link: https://www.huaweicloud.com/intl/en-us/product/codecheck.html
Link: https://devcloud.cn-north-4.huaweicloud.com/codechecknew/ruleset/9e43befe8c2611edab16fa163e0fa374/config

