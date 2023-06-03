Return-Path: <netdev+bounces-7637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 237A2720E71
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C4C1C21085
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F88AD2C;
	Sat,  3 Jun 2023 07:11:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8779E0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:11:45 +0000 (UTC)
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B0EC0;
	Sat,  3 Jun 2023 00:11:41 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
	by mail-m11875.qiye.163.com (Hmail) with ESMTPA id AD5ED2802D9;
	Sat,  3 Jun 2023 15:11:32 +0800 (CST)
Message-ID: <5f0f2bab-ae36-8b13-2c6d-c69c6ff4a43f@sangfor.com.cn>
Date: Sat, 3 Jun 2023 15:11:29 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
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
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <20230602225519.66c2c987@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHRpCVh5NQkwdS0hLSR1CGFUTARMWGhIXJBQOD1
	lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a888018ecd22eb1kusnad5ed2802d9
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PU06Nio5KD1MMjMzNRA*Vk8*
	UQgwCxNVSlVKTUNOTExNSUJDS0hIVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFPSklONwY+
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/3 13:55, Jakub Kicinski wrote:
> On Sat, 3 Jun 2023 09:51:34 +0800 Ding Hui wrote:
>>> If that is the case maybe it would just make more sense to just return
>>> an error if we are at risk of overrunning the userspace allocated
>>> buffer.
>>
>> In that case, I can modify to return an error, however, I think the
>> ENOSPC or EFBIG mentioned in a previous email may not be suitable,
>> maybe like others length/size checking return EINVAL.
>>
>> Another thing I wondered is that should I update the current length
>> back to user if user buffer is not enough, assuming we update the new
>> length with error returned, the userspace can use it to reallocate
>> buffer if he wants to, which can avoid re-call previous ioctl to get
>> the new length.
> 
> This entire thread presupposes that user provides the length of
> the buffer. I don't see that in the code. Take ethtool_get_stats()
> as an example, you assume that stats.n_stats is set correctly,
> but it's not enforced today. Some app somewhere may pass in zeroed
> out stats and work just fine.
> 

Yes.

I checked the others ioctl (e.g. ethtool_get_eeprom(), ethtool_get_features()),
and searched the git log of ethtool utility, so I think that is an implicit
rule and the check is missed in kernel where the patch involves.

Without this rule, we cannot guarantee the safety of copy to user.

Should we keep to be compatible with that incorrect userspace usage?

-- 
Thanks,
- Ding Hui


