Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3841912B1B
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfECJyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 05:54:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:50798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbfECJyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 05:54:24 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 8A8414505F37E3B35B3B;
        Fri,  3 May 2019 17:54:21 +0800 (CST)
Received: from dggeme757-chm.china.huawei.com (10.3.19.103) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 3 May 2019 17:54:21 +0800
Received: from [127.0.0.1] (10.63.173.108) by dggeme757-chm.china.huawei.com
 (10.3.19.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Fri, 3
 May 2019 17:54:20 +0800
Reply-To: <lipeng321@huawei.com>
Subject: Re: [PATCH net-next 1/3] net: hns3: add support for multiple media
 type
References: <1556679944-100941-1-git-send-email-lipeng321@huawei.com>
 <1556679944-100941-2-git-send-email-lipeng321@huawei.com>
 <20190501123750.GA9844@lunn.ch>
 <1d7faec8-22f7-0e8f-7e38-9ad600134a7c@huawei.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <96bbc8c7-0e13-decd-dfb5-ce68df143f39@huawei.com>
Date:   Fri, 3 May 2019 17:54:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1d7faec8-22f7-0e8f-7e38-9ad600134a7c@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.173.108]
X-ClientProxiedBy: dggemx702-chm.china.huawei.com (10.1.199.49) To
 dggeme757-chm.china.huawei.com (10.3.19.103)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/3 11:13, lipeng (Y) wrote:
>
>
> On 2019/5/1 20:37, Andrew Lunn wrote:
>> On Wed, May 01, 2019 at 11:05:42AM +0800, Peng Li wrote:
>>> From: Jian Shen <shenjian15@huawei.com>
>>>
>>> Previously, we can only identify copper and fiber type, the
>>> supported link modes of port information are always showing
>>> SR type. This patch adds support for multiple media types,
>>> include SR, LR CR, KR. Driver needs to query the media type
>>> from firmware periodicly, and updates the port information.
>>>
>>> The new port information looks like this:
>>> Settings for eth0:
>>>          Supported ports: [ FIBRE ]
>>>          Supported link modes:   25000baseCR/Full
>>>                                  25000baseSR/Full
>>>                                  1000baseX/Full
>>>                                  10000baseCR/Full
>>>                                  10000baseSR/Full
>>>                                  10000baseLR/Full
>>>          Supported pause frame use: Symmetric
>>>          Supports auto-negotiation: No
>>>          Supported FEC modes: None BaseR
>>>          Advertised link modes:  25000baseCR/Full
>>>                                  25000baseSR/Full
>>>                                  1000baseX/Full
>>>                                  10000baseCR/Full
>>>                                  10000baseSR/Full
>>>                                  10000baseLR/Full
>> Hi Peng
>>
>> If it does not support auto-negotiation, do these advertised link
>> modes make any sense? Does it really advertise, or is it all fixed
>> configured?
>>
>>     Andrew
>>
>> .
> Hi Andrew:
>
> it makes no sense when auto-negotiation is not supported.
> I should handle it differently with the case supports auto-negotiation
> and not supports auto-negotiation.
>
> I will fix it in next version, result like below:
> Settings for eth0:
>         Supported ports: [ FIBRE ]
>         Supported link modes:   25000baseCR/Full
>                                 25000baseSR/Full
>                                 1000baseX/Full
>                                 10000baseCR/Full
>                                 10000baseSR/Full
>                                 10000baseLR/Full
>         Supported pause frame use: Symmetric
>         Supports auto-negotiation: No
>         Supported FEC modes: None BaseR
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 10000Mb/s
>         Duplex: Full
>         Port: FIBRE
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: off
>         Current message level: 0x00000036 (54)
>                                probe link ifdown ifup
>         Link detected: yes
>
>         Wish I have understood your comments correctly.
>
>
> Thanks!
>

Hi, Andrew:
Thanks for your review. And I have replied your comments.

As this week is 5.1-rc7,  not sure if there is rc8,
I'm sorry for sending V2 patch-set
without waiting for your reply again on V1.

Thanks

>
>>
>
>
>
> .
>


