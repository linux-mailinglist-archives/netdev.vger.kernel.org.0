Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7EFE0F45
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfJWAjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:39:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfJWAjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:39:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N0d2IJ175532;
        Wed, 23 Oct 2019 00:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=HeLtUS6zZievQf+rv7Xk9YxdHIv53hGtlxucCQjRiY4=;
 b=Rs9/bID4TrXJYt+OvzypZiYhgKUzsJGlH80o6/68J4yJD+3SKwZmXR2SrizYvC8cz3rL
 7uALs0hmS0YerfD6CFgFM0qOz4Y+ai+h1/50VVlwVEWBC2GK6sXqOiteg1evNbpgJjf2
 yjOqVzs6dhq2zSEYdpSujcsKTv2YqIfaj0tEWqXC5/2LTdQ4tXq6QArr6/Oxd9vhF/KP
 NkLIF1Q6rMYbFz1Qx6wfc/Iupy16DKTeC+s4P0a0coWJH2oBlNhHjb3cRHJQlC1grSk3
 6LHwZ7qQjWewppW9xpdbgTTV22FxLBO0W+hJlyiUTZd3RTFEbxgmpJc7UNE3Xe4I99hE XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswtj6c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 00:39:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N0cxcB191032;
        Wed, 23 Oct 2019 00:39:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vt2he4vjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 00:39:46 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9N0diiD003932;
        Wed, 23 Oct 2019 00:39:44 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 00:39:44 +0000
Subject: Re: [PATCH] net: forcedeth: add xmit_more support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     rain.1986.08.12@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>
References: <1571392885-32706-1-git-send-email-yanjun.zhu@oracle.com>
 <20191018154844.34a27c64@cakuba.netronome.com>
 <84839e5f-4543-bbd9-37db-e1777a84992c@oracle.com>
 <20191021083300.0fea8965@cakuba.netronome.com>
 <c728e606-c449-d72a-5b3a-fb457b0c34ff@oracle.com>
 <20191022084019.72c92347@cakuba.netronome.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <84f704d7-0547-aa9f-cf29-073bc821be10@oracle.com>
Date:   Wed, 23 Oct 2019 08:45:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022084019.72c92347@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/22 23:40, Jakub Kicinski wrote:
> On Tue, 22 Oct 2019 13:32:35 +0800, Zhu Yanjun wrote:
>> On 2019/10/21 23:33, Jakub Kicinski wrote:
>>> On Mon, 21 Oct 2019 17:56:06 +0800, Zhu Yanjun wrote:
>>>> On 2019/10/19 6:48, Jakub Kicinski wrote:
>>>>> On Fri, 18 Oct 2019 06:01:25 -0400, Zhu Yanjun wrote:
>>>>>> This change adds support for xmit_more based on the igb commit 6f19e12f6230
>>>>>> ("igb: flush when in xmit_more mode and under descriptor pressure") and
>>>>>> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data") that
>>>>>> were made to igb to support this feature. The function netif_xmit_stopped
>>>>>> is called to check if transmit queue on device is currently unable to send
>>>>>> to determine if we must write the tail because we can add no further
>>>>>> buffers.
>>>>>> When normal packets and/or xmit_more packets fill up tx_desc, it is
>>>>>> necessary to trigger NIC tx reg.
>>>>> Looks broken. You gotta make sure you check the kick on _every_ return
>>>>> path. There are 4 return statements in each function, you only touched
>>>>> 2.
>>>> In nv_start_xmit,
>>>>
>>>> [...]
>>>>
>>>> The above are dma_mapping_error. It seems that triggering NIC HW xmit is
>>>> not needed.
>>>>
>>>> So when "tx_desc full" error, HW NIC xmit is triggerred. When
>>>> dma_mapping_error,
>>>>
>>>> NIC HW xmit is not triggerred.
>>>>
>>>> That is why only 2 "return" are touched.
>>> Imagine you have the following sequence of frames:
>>>
>>> 	skbA  | xmit_more() == true
>>> 	skbB  | xmit_more() == true
>>> 	skbC  | xmit_more() == true
>>> 	skbD  | xmit_more() == false
>>>
>>> A, B, and C got queued successfully but the driver didn't kick the
>>> queue because of xmit_more(). Now D gets dropped due to a DMA error.
>>> Queue never gets kicked.
>> DMA error is a complicated problem. We will delve into this problem later.
>>
>>   From the above commit log, this commit is based on the igb commit
>> 6f19e12f6230
>> ("igb: flush when in xmit_more mode and under descriptor pressure") and
>> commit 6b16f9ee89b8 ("net: move skb->xmit_more hint to softnet data").
>>
>> It seems that the 2 commits did not consider the DMA errors that you
>> mentioned.
> Then igb is buggy, too.

Then if igb problem is fixed, I will follow.;-)

Zhu Yanjun

>
