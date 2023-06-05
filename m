Return-Path: <netdev+bounces-7849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31095721C9B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 05:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 375771C2097F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 03:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE60137D;
	Mon,  5 Jun 2023 03:40:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00BB17E3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:40:15 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B7B1;
	Sun,  4 Jun 2023 20:40:12 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id AFA5228027E;
	Mon,  5 Jun 2023 11:40:01 +0800 (CST)
Message-ID: <f6ad6281-df30-93cf-d057-5841b8c1e2e6@sangfor.com.cn>
Date: Mon, 5 Jun 2023 11:39:59 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
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
Content-Language: en-US
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <20230604104718.4bf45faf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSEhIVk5PQ0kfSR9OQx9OHlUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a8889a3ff7c2eb1kusnafa5228027e
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K1E6MSo*Nz0BFDAyOQgtHlY*
	CjQwCjRVSlVKTUNOQkhNT0tMSEhJVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFPS0JDNwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/5 1:47, Jakub Kicinski wrote:
> On Sat, 3 Jun 2023 15:11:29 +0800 Ding Hui wrote:
>> Yes.
>>
>> I checked the others ioctl (e.g. ethtool_get_eeprom(), ethtool_get_features()),
>> and searched the git log of ethtool utility, so I think that is an implicit
>> rule and the check is missed in kernel where the patch involves.
>>
>> Without this rule, we cannot guarantee the safety of copy to user.
>>
>> Should we keep to be compatible with that incorrect userspace usage?
> 
> If such incorrect user space exists we do, if it doesn't we don't.
> Problem is that we don't know what exists out there.
> 
> Maybe we can add a pr_err_once() complaining about bad usage for now
> and see if anyone reports back that they are hitting it?
> 

How about this:

Case 1:
If the user len/n_stats is not zero, we will treat it as correct usage
(although we cannot distinguish between the real correct usage and
uninitialized usage). Return -EINVAL if current length exceed the one
user specified.

Case 2:
If it is zero, we will treat it as incorrect usage, we can add a
pr_err_once() for it and keep to be compatible with it for a period of time.
At a suitable time in the future, this part can be removed by maintainers.

-- 
Thanks,
- Ding Hui


