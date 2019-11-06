Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411A4F0DE2
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbfKFElK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:41:10 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34024 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKFElK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:41:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64d3di089996;
        Wed, 6 Nov 2019 04:41:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=AIgX5FTCjknVF/pQJJbduCor5H4n++HgZ6KCzHfei0s=;
 b=EazvssRPesYzXSAATnxmq86wydIw+0VkZAlXnhYBCU8ob5UE/9vNU1CuVuaJ3l8RLXYU
 C9t5O89hV1DqZaoEFF/NRDU11rOFSLASbKXc62bsQNgtSMHzwsS8yIGIbN3SydpJxCuZ
 f5qELqM1eSUuNkVfEowR5m9XPdvdScfQkR8urtPctpNOh2OL+BKiR1/mfCg5rBanrJ6m
 qJiXF/zXxtJfELWgXhbomWJQ9KqCerdikNA5OXLYXeX+9UsBWrS4RydjiyxMfY8lGtlk
 rG0MS7jzkVR861A/EzsvifigqH99vXmHISv1uI1WE8JGhBUSofJIW/RZgWbRs+Cd9JQ9 JA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rq33kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:41:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64d1Ff013753;
        Wed, 6 Nov 2019 04:41:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w2wcnn98d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:41:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA64f1WH006613;
        Wed, 6 Nov 2019 04:41:01 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:41:01 -0800
Subject: Re: [PATCHv4 1/1] net: forcedeth: add xmit_more support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <1572928001-6915-1-git-send-email-yanjun.zhu@oracle.com>
 <20191105094841.623b498e@cakuba.netronome.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <f389d645-384f-73a5-4d15-af388520446f@oracle.com>
Date:   Wed, 6 Nov 2019 12:47:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105094841.623b498e@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/6 1:48, Jakub Kicinski wrote:
> On Mon,  4 Nov 2019 23:26:41 -0500, Zhu Yanjun wrote:
>> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
>> index 05d2b47..0d21ddd 100644
>> --- a/drivers/net/ethernet/nvidia/forcedeth.c
>> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
>> @@ -2259,7 +2265,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>>   			u64_stats_update_begin(&np->swstats_tx_syncp);
>>   			nv_txrx_stats_inc(stat_tx_dropped);
>>   			u64_stats_update_end(&np->swstats_tx_syncp);
>> -			return NETDEV_TX_OK;
>> +
>> +			writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
>> +			       get_hwbase(dev) + NvRegTxRxControl);
>> +			ret = NETDEV_TX_OK;
>> +
>> +			goto dma_error;
> You could goto the middle of the txkick if statement here, instead of
> duplicating the writel()?
As your suggestion, the change is like this:

@@ -2374,7 +2374,9 @@ static netdev_tx_t nv_start_xmit(struct sk_buff 
*skb, struct net_device *dev)
         spin_unlock_irqrestore(&np->lock, flags);

  txkick:
-       if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
+       if (netif_queue_stopped(dev) || !netdev_xmit_more())
+dma_error:
+       {
                 u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;

                 writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);

The opening brace on the first of the line. It conflicts with the following:

Documentation/process/coding-style.rst:
"
   98 3) Placing Braces and Spaces
   99 ----------------------------
  100
  101 The other issue that always comes up in C styling is the placement of
  102 braces.  Unlike the indent size, there are few technical reasons to
  103 choose one placement strategy over the other, but the preferred 
way, as
  104 shown to us by the prophets Kernighan and Ritchie, is to put the 
opening
  105 brace last on the line, and put the closing brace first, thusly:
"
So I prefer to the current code style.

Thanks for your suggestions.

Any way, it is a code style problem. It is trivial.
>   Actually the txkick label could be in the
> middle of the if statement to begin with, TXBUSY case above stops the
> queue so it will always go into the if.
>
>>   		}
>>   		np->put_tx_ctx->dma_len = bcnt;
>>   		np->put_tx_ctx->dma_single = 1;
>> @@ -2305,7 +2316,12 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>>   				u64_stats_update_begin(&np->swstats_tx_syncp);
>>   				nv_txrx_stats_inc(stat_tx_dropped);
>>   				u64_stats_update_end(&np->swstats_tx_syncp);
>> -				return NETDEV_TX_OK;
>> +
>> +				writel(NVREG_TXRXCTL_KICK | np->txrxctl_bits,
>> +				       get_hwbase(dev) + NvRegTxRxControl);
>> +				ret = NETDEV_TX_OK;
>> +
>> +				goto dma_error;
> And here.
>
>>   			}
>>   
>>   			np->put_tx_ctx->dma_len = bcnt;
>> @@ -2357,8 +2373,15 @@ static netdev_tx_t nv_start_xmit(struct sk_buff *skb, struct net_device *dev)
>>   
>>   	spin_unlock_irqrestore(&np->lock, flags);
>>   
>> -	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
>> -	return NETDEV_TX_OK;
>> +txkick:
>> +	if (netif_queue_stopped(dev) || !netdev_xmit_more()) {
>> +		u32 txrxctl_kick = NVREG_TXRXCTL_KICK | np->txrxctl_bits;
>> +
>> +		writel(txrxctl_kick, get_hwbase(dev) + NvRegTxRxControl);
>> +	}
>> +
>> +dma_error:
>> +	return ret;
>>   }
> But otherwise looks correct to me now, thanks!
Thanks a lot for code review.

Zhu Yanjun
>
