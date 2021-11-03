Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253DA443EC1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 09:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhKCI7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 04:59:00 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45937 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231968AbhKCI66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 04:58:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UurtQi5_1635929779;
Received: from guwendeMacBook-Pro.local(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UurtQi5_1635929779)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Nov 2021 16:56:20 +0800
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com,
        guwen@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
 <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
 <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
 <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
Message-ID: <bb84bb0a-7b9d-12c6-86a3-8e5c4eea1ba6@linux.alibaba.com>
Date:   Wed, 3 Nov 2021 16:56:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/2 下午5:25, Karsten Graul wrote:
> On 01/11/2021 07:15, Wen Gu wrote:
>> Before explaining my intentions, I thought it would be better to describe the issue I encountered first：
>>
>> In nginx/wrk tests, when nginx uses TCP and wrk uses SMC to replace TCP, wrk should fall back to TCP and get correct results theoretically, But in fact it only got all zeros.
> 
> Thank you for the very detailed description, I now understand the situation.
> 
> The fix is not obvious and not easy to understand for the reader of the code,
> did you think about a fix that uses own sk_data_ready / sk_write_space
> implementations on the SMC socket to forward the call to the clcsock in the
> fallback situation?
> 
> I.e. we already have smc_tx_write_space(), and there is smc_clcsock_data_ready()
> which is right now only used for the listening socket case.
> 
> If this works this would be a much cleaner and more understandable way to fix this issue.
> 

Thanks for your suggestions, they are very helpful.

I will try these ways and send a new patch later.

cheers,
Wen Gu
