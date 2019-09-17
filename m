Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCD4B4F83
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfIQNlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:41:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2288 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725917AbfIQNlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 09:41:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1183ED23E0891D0D560B;
        Tue, 17 Sep 2019 21:41:21 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Tue, 17 Sep 2019
 21:41:16 +0800
Message-ID: <5D80E27B.9050300@huawei.com>
Date:   Tue, 17 Sep 2019 21:41:15 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     <jakub.kicinski@netronome.com>, <davem@davemloft.net>,
        <anna.schumaker@netapp.com>, <trond.myklebust@hammerspace.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ixgbe: Use memset_explicit directly in crypto cases
References: <1568691910-21442-1-git-send-email-zhongjiang@huawei.com> <98a942fb-0c47-ffa6-4c9c-f30b5d6f750e@cogentembedded.com>
In-Reply-To: <98a942fb-0c47-ffa6-4c9c-f30b5d6f750e@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/9/17 17:59, Sergei Shtylyov wrote:
> Hello!
>
> On 17.09.2019 6:45, zhong jiang wrote:
>
>> It's better to use memset_explicit() to replace memset() in crypto cases.
>
>    But you're using memzero_explicit() below?
Sorry, stupid Oops. I will repost.  Thank for your reminder.

Sincerely,
zhong jiang
>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> index 31629fc..7e4f32f 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
>> @@ -960,10 +960,10 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>       return 0;
>>     err_aead:
>> -    memset(xs->aead, 0, sizeof(*xs->aead));
>> +    memzero_explicit(xs->aead, sizeof(*xs->aead));
>>       kfree(xs->aead);
>>   err_xs:
>> -    memset(xs, 0, sizeof(*xs));
>> +    memzero_explicit(xs, sizeof(*xs));
>>       kfree(xs);
>>   err_out:
>>       msgbuf[1] = err;
>> @@ -1049,7 +1049,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>>       ixgbe_ipsec_del_sa(xs);
>>         /* remove the xs that was made-up in the add request */
>> -    memset(xs, 0, sizeof(*xs));
>> +    memzero_explicit(xs, sizeof(*xs));
>>       kfree(xs);
>>         return 0;
>
> MBR, Sergei
>
> .
>


