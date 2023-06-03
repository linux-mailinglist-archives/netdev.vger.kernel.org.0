Return-Path: <netdev+bounces-7605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EDB720D0F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 03:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48BB0281B58
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 01:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE76816;
	Sat,  3 Jun 2023 01:51:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3633187E
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 01:51:50 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428B8E45;
	Fri,  2 Jun 2023 18:51:48 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id D42C928025B;
	Sat,  3 Jun 2023 09:51:37 +0800 (CST)
Message-ID: <44905acd-3ac4-cfe5-5e91-d182c1959407@sangfor.com.cn>
Date: Sat, 3 Jun 2023 09:51:34 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
To: Alexander Duyck <alexander.duyck@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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
Content-Language: en-US
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <CAKgT0Uf+XaKCFgBRTn-viVsKkNE7piAuDpht=efixsAV=3JdFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCTR8ZVkJKTBlKSE9KGEJCHVUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a887ef4098b2eb1kusnd42c928025b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pwg6Mjo5Pz1DPjMOFC0TC0Mp
	QxMwFAFVSlVKTUNOTE5MSktISEhKVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFIQkpPNwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/3 2:02, Alexander Duyck wrote:
> On Fri, Jun 2, 2023 at 9:37 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>> What this change is essentially doing is clamping the copied data to
>>> the lesser of the current value versus the value when the userspace
>>> was allocated. However I am wondering now if we shouldn't just update
>>> the size value and return that as some sort of error for the userspace
>>> to potentially reallocate and repeat until it has the right size.
>>
>> I'm not sure we should be putting any effort into the IOCTL
>> interface. It is deprecated. We should fix overrun problems, but i
>> would not change the API. Netlink handles this atomically, and that is
>> the interface tools should be using, not this IOCTL.
> 
> If that is the case maybe it would just make more sense to just return
> an error if we are at risk of overrunning the userspace allocated
> buffer.
> 

In that case, I can modify to return an error, however, I think the
ENOSPC or EFBIG mentioned in a previous email may not be suitable,
maybe like others length/size checking return EINVAL.

Another thing I wondered is that should I update the current length
back to user if user buffer is not enough, assuming we update the new
length with error returned, the userspace can use it to reallocate
buffer if he wants to, which can avoid re-call previous ioctl to get
the new length.

-- 
Thanks,
- Ding Hui


