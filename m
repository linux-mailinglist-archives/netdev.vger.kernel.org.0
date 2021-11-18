Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033544551FE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbhKRBMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 20:12:39 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.227]:39136 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235976AbhKRBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 20:12:39 -0500
HMM_SOURCE_IP: 172.18.0.48:51592.85767161
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.93 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id DF2A628008F;
        Thu, 18 Nov 2021 09:09:20 +0800 (CST)
X-189-SAVE-TO-SEND: zhenggy@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 80432f6858924d939d5209d0796bb61f for linux-kernel@vger.kernel.org;
        Thu, 18 Nov 2021 09:09:23 CST
X-Transaction-ID: 80432f6858924d939d5209d0796bb61f
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: zhenggy@chinatelecom.cn
Subject: Re: [PATCH] ipvs: remove unused variable for ip_vs_new_dest
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        pablo@netfilter.org
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <1636112380-11040-1-git-send-email-zhenggy@chinatelecom.cn>
 <25e945b7-9027-43cb-f79c-573fdce42a26@ssi.bg>
 <20211114180206.GA2757@vergenet.net>
From:   zhenggy <zhenggy@chinatelecom.cn>
Message-ID: <97494860-f9d3-44e6-7515-0031ea64f86c@chinatelecom.cn>
Date:   Thu, 18 Nov 2021 09:09:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20211114180206.GA2757@vergenet.net>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for review.

ÔÚ 2021/11/15 2:02, Simon Horman Ð´µÀ:
> On Sat, Nov 13, 2021 at 11:56:36AM +0200, Julian Anastasov wrote:
>>
>> 	Hello,
>>
>> On Fri, 5 Nov 2021, GuoYong Zheng wrote:
>>
>>> The dest variable is not used after ip_vs_new_dest anymore in
>>> ip_vs_add_dest, do not need pass it to ip_vs_new_dest, remove it.
>>>
>>> Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
>>
>> 	Looks good to me for -next, thanks!
>>
>> Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Thanks GuoYong,
> 
> Acked-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, please consider this for nf-next at your convenience.
> 
>>
>>> ---
>>>  net/netfilter/ipvs/ip_vs_ctl.c | 7 ++-----
>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>>> index e62b40b..494399d 100644
>>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>>> @@ -959,8 +959,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>>>   *	Create a destination for the given service
>>>   */
>>>  static int
>>> -ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
>>> -	       struct ip_vs_dest **dest_p)
>>> +ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>>>  {
>>>  	struct ip_vs_dest *dest;
>>>  	unsigned int atype, i;
>>> @@ -1020,8 +1019,6 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>>>  	spin_lock_init(&dest->stats.lock);
>>>  	__ip_vs_update_dest(svc, dest, udest, 1);
>>>  
>>> -	*dest_p = dest;
>>> -
>>>  	LeaveFunction(2);
>>>  	return 0;
>>>  
>>> @@ -1095,7 +1092,7 @@ static void ip_vs_trash_cleanup(struct netns_ipvs *ipvs)
>>>  		/*
>>>  		 * Allocate and initialize the dest structure
>>>  		 */
>>> -		ret = ip_vs_new_dest(svc, udest, &dest);
>>> +		ret = ip_vs_new_dest(svc, udest);
>>>  	}
>>>  	LeaveFunction(2);
>>>  
>>> -- 
>>> 1.8.3.1
>>
>> Regards
>>
>> --
>> Julian Anastasov <ja@ssi.bg>
>>
