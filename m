Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8A62305A5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgG1InG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:43:06 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727950AbgG1InG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 04:43:06 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 55916A64C772A4D794EE;
        Tue, 28 Jul 2020 16:43:01 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 28 Jul 2020
 16:43:00 +0800
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
To:     Joe Perches <joe@perches.com>, <dchickles@marvell.com>,
        <sburla@marvell.com>, <fmanlunas@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200724130001.71528-1-wanghai38@huawei.com>
 <2cdef8d442bb5da39aed17bf994a800e768942f7.camel@perches.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <ac99bed4-dabc-a003-374f-206753f937cb@huawei.com>
Date:   Tue, 28 Jul 2020 16:42:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2cdef8d442bb5da39aed17bf994a800e768942f7.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/7/25 5:29, Joe Perches 写道:
> On Fri, 2020-07-24 at 21:00 +0800, Wang Hai wrote:
>> Remove casting the values returned by memory allocation function.
>>
>> Coccinelle emits WARNING:
>>
>> ./drivers/net/ethernet/cavium/liquidio/octeon_device.c:1155:14-36: WARNING:
>>   casting value returned by memory allocation function to (struct octeon_dispatch *) is useless.
> []
>> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> []
>> @@ -1152,8 +1152,7 @@ octeon_register_dispatch_fn(struct octeon_device *oct,
>>   
>>   		dev_dbg(&oct->pci_dev->dev,
>>   			"Adding opcode to dispatch list linked list\n");
>> -		dispatch = (struct octeon_dispatch *)
>> -			   vmalloc(sizeof(struct octeon_dispatch));
>> +		dispatch = vmalloc(sizeof(struct octeon_dispatch));
> More the question is why this is vmalloc at all
> as the structure size is very small.
>
> Likely this should just be kmalloc.
>
>
Thanks for your advice.  It is indeed best to use kmalloc here.
>>   		if (!dispatch) {
>>   			dev_err(&oct->pci_dev->dev,
>>   				"No memory to add dispatch function\n");
> And this dev_err is unnecessary.
>
>
I don't understand why dev_err is not needed here. We can easily know 
that an error has occurred here through dev_err
> .
>

