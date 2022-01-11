Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B78448B14F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349696AbiAKPvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:51:10 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:39355 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbiAKPvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:51:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V1afDFU_1641916266;
Received: from 30.39.146.113(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V1afDFU_1641916266)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 11 Jan 2022 23:51:07 +0800
Message-ID: <72c440bf-8fc9-8371-3229-bee0aa02c65f@linux.alibaba.com>
Date:   Tue, 11 Jan 2022 23:51:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net 1/3] net/smc: Resolve the race between link group
 access and termination
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
 <8b720956-c8fe-0fe2-b019-70518d5c60c8@linux.ibm.com>
 <ee973642-6bae-e748-cea9-ed18bca461f0@linux.alibaba.com>
 <3897d6e8-1191-b42b-9553-c2720f3a92eb@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <3897d6e8-1191-b42b-9553-c2720f3a92eb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/11 11:46 pm, Karsten Graul wrote:
> On 11/01/2022 16:36, Wen Gu wrote:
>> Thanks for your review.
>>
>> On 2022/1/11 4:23 pm, Karsten Graul wrote:
>>> On 10/01/2022 10:26, Wen Gu wrote:
>>>> We encountered some crashes caused by the race between the access
>>>> and the termination of link groups.
>>>>
>>>
>>> These waiters (seaparate ones for smcd and smcr) are used to wait for all lgrs
>>> to be deleted when a module unload or reboot was triggered, so it must only be
>>> woken up when the lgr is actually freed.
>>
>> Thanks for your reminding, I will move the wake-up code to __smc_lgr_free().
>>
>> And maybe the vlan put and device put of smcd are also need to be moved
>> to __smc_lgr_free()?, because it also seems to be more suitable to put these
>> resources when lgr is actually freed. What do you think?
> 
> Keep the calls to smc_ism_put_vlan() and put_device() in smc_lgr_free(),
> thats okay for SMC-D.

OK.

Thanks,
Wen Gu
