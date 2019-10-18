Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8A7DBB61
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 03:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409506AbfJRBsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 21:48:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728754AbfJRBsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 21:48:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 77FA2C8CAD8018DAC87A;
        Fri, 18 Oct 2019 09:48:21 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 09:48:20 +0800
Subject: Re: [PATCH 4.9.y] Revert "net: sit: fix memory leak in
 sit_init_net()"
To:     Greg KH <gregkh@linuxfoundation.org>,
        Ajay Kaher <akaher@vmware.com>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <srivatsab@vmware.com>,
        <srivatsa@csail.mit.edu>, <amakhalov@vmware.com>,
        <srinidhir@vmware.com>, <bvikas@vmware.com>, <anishs@vmware.com>,
        <vsirnapalli@vmware.com>, <srostedt@vmware.com>
References: <1571216634-44834-1-git-send-email-akaher@vmware.com>
 <20191016183027.GC801860@kroah.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <d0cbd39d-9fb7-dad8-b951-12aa299f13e8@huawei.com>
Date:   Fri, 18 Oct 2019 09:48:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20191016183027.GC801860@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/17 2:30, Greg KH wrote:
> On Wed, Oct 16, 2019 at 02:33:54PM +0530, Ajay Kaher wrote:
>> This reverts commit 375d6d454a95ebacb9c6eb0b715da05a4458ffef which is
>> commit 07f12b26e21ab359261bf75cfcb424fdc7daeb6d upstream.
>>
>> Unnecessarily calling free_netdev() from sit_init_net().
>> ipip6_dev_free() of 4.9.y called free_netdev(), so no need
>> to call again after ipip6_dev_free().
>>
>> Cc: Mao Wenan <maowenan@huawei.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Ajay Kaher <akaher@vmware.com>
>> ---
>>  net/ipv6/sit.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
>> index 47ca2a2..16eba7b 100644
>> --- a/net/ipv6/sit.c
>> +++ b/net/ipv6/sit.c
>> @@ -1856,7 +1856,6 @@ static int __net_init sit_init_net(struct net *net)
>>  
>>  err_reg_dev:
>>  	ipip6_dev_free(sitn->fb_tunnel_dev);
>> -	free_netdev(sitn->fb_tunnel_dev);
>>  err_alloc_dev:
>>  	return err;
>>  }
>> -- 
>> 2.7.4
>>
> 
> Mao, are you ok with this change?
> 
> thanks,
> 
> greg k-h
> 

Greg, ipip6_dev_free has already called free_netdev in stable 4.9.

Reviewed-by: Mao Wenan <maowenan@huawei.com>

> .
> 

