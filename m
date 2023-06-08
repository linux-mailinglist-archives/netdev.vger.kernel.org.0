Return-Path: <netdev+bounces-9166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E89CE727AD0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CD6E281622
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 09:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E4FE9471;
	Thu,  8 Jun 2023 09:06:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E1D8F77
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:06:51 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACA3E50;
	Thu,  8 Jun 2023 02:06:44 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id ADB3928086B;
	Thu,  8 Jun 2023 17:06:34 +0800 (CST)
Message-ID: <034f5393-e519-1e8d-af76-ae29677a1bf5@sangfor.com.cn>
Date: Thu, 8 Jun 2023 17:06:31 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Andrew Lunn
 <andrew@lunn.ch>, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230601112839.13799-1-dinghui@sangfor.com.cn>
 <135a45b2c388fbaf9db4620cb01b95230709b9ac.camel@gmail.com>
 <eed0cbf7-ff12-057e-e133-0ddf5e98ef68@sangfor.com.cn>
 <6110cf9f-c10e-4b9b-934d-8d202b7f5794@lunn.ch>
 <f7e23fe6-4d30-ef1b-a431-3ef6ec6f77ba@sangfor.com.cn>
 <6e28cea9-d615-449d-9c68-aa155efc8444@lunn.ch>
 <CAKgT0UdyykQL-BidjaNpjX99FwJTxET51U29q4_CDqmABUuVbw@mail.gmail.com>
 <ece228a3-5c31-4390-b6ba-ec3f2b6c5dcb@lunn.ch>
 <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
 <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
 <20230602225519.66c2c987@kernel.org>
 <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn>
 <20230604104718.4bf45faf@kernel.org>
 <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn>
 <20230605113915.4258af7f@kernel.org>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <20230605113915.4258af7f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTEgYVk9IHUJOGhhNShpIGlUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a889a420a612eb1kusnadb3928086b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OAg6Nyo*TT1MDC8qST8tLUkD
	Sw4KCzNVSlVKTUNNSUpOSUtLSUxMVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFIQkxNNwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/6 2:39, Jakub Kicinski wrote:
> On Mon, 5 Jun 2023 11:39:59 +0800 Ding Hui wrote:
>> Case 1:
>> If the user len/n_stats is not zero, we will treat it as correct usage
>> (although we cannot distinguish between the real correct usage and
>> uninitialized usage). Return -EINVAL if current length exceed the one
>> user specified.
> 
> This assumes user will zero-initialize the value rather than do
> something like:
> 
> 	buf = malloc(1 << 16); // 64k should always be enough
> 	ioctl(s, ETHTOOL_GSTATS, buf)
> 
> 	for (i = 0; i < buf.n_stats; i++)
> 		/* use stats */
> 
> :(
> 

Sorry for late.

Now I'm not sure what can I do next besides reporting the issue.

>> Case 2:
>> If it is zero, we will treat it as incorrect usage, we can add a
>> pr_err_once() for it and keep to be compatible with it for a period of time.
>> At a suitable time in the future, this part can be removed by maintainers.
> 

-- 
Thanks,
- Ding Hui


