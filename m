Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711843998B1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 05:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCDse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 23:48:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4289 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhFCDsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 23:48:33 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FwWt41BlBz1BHPK;
        Thu,  3 Jun 2021 11:42:04 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 11:46:44 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 11:46:43 +0800
Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
To:     Jakub Kicinski <kuba@kernel.org>
CC:     moyufeng <moyufeng@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20190301120358.7970f0ad@cakuba.netronome.com>
 <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190304174551.2300b7bc@cakuba.netronome.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
 <20210531223711.19359b9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <7c591bad-75ed-75bc-5dac-e26bdde6e615@huawei.com>
 <20210601143451.4b042a94@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <cf961f69-c559-eaf0-e168-b014779a1519@huawei.com>
 <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <857e7a19-1559-b929-fd15-05e8f38e9d45@huawei.com>
Date:   Thu, 3 Jun 2021 11:46:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210602093440.15dc5713@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/3 0:34, Jakub Kicinski wrote:
> On Wed, 2 Jun 2021 10:24:11 +0800 Yunsheng Lin wrote:
>> On 2021/6/2 5:34, Jakub Kicinski wrote:
>>> On Tue, 1 Jun 2021 15:33:09 +0800 Yunsheng Lin wrote:  
>>>> Is there a reason why it didn't have to be solved yet?
>>>> Is it because the devices currently supporting devlink do not have
>>>> this kind of problem, like single-function ASIC or multi-function
>>>> ASIC without sharing common resource?  
>>>
>>> I'm not 100% sure, my guess is multi-function devices supporting
>>> devlink are simple enough for the problem not to matter all that much.
>>>   
>>>> Was there a discussion how to solved it in the past?  
>>>
>>> Not really, we floated an idea of creating aliases for devlink
>>> instances so a single devlink instance could answer to multiple 
>>> bus identifiers. But nothing concrete.  
>>
>> What does it mean by "answer to multiple bus identifiers"? I
>> suppose it means user provides the bus identifiers when setting or
>> getting something, and devlink instance uses that bus identifiers
>> to differentiate different PF in the same ASIC?
> 
> Correct.
> 
>> can devlink port be used to indicate different PF in the same ASIC,
>> which already has the bus identifiers in it? It seems we need a
>> extra identifier to indicate the ASIC?
>>
>> $ devlink port show
>> ...
>> pci/0000:03:00.0/61: type eth netdev sw1p1s0 split_group 0
> 
> Ports can obviously be used, but which PCI device will you use to
> register the devlink instance? Perhaps using just one doesn't matter 
> if there is only one NIC in the system, but may be confusing with
> multiple NICs, no?

Yes, it is confusing, how about using the controler_id to indicate
different NIC? we can make sure controler_id is unqiue in the same
host, a controler_id corresponds to a devlink instance, vendor info
or serial num for the devlink instance can further indicate more info
to the system user?

pci/controler_id/0000:03:00.0/61

> 
>>>> "same control domain" means if it is controlled by a single host, not
>>>> by multi hosts, right?
>>>>
>>>> If the PF is not passed through to a vm using VFIO and other PF is still
>>>> in the host, then I think we can say it is controlled by a single host.
>>>>
>>>> And each PF is trusted with each other right now, at least at the driver
>>>> level, but not between VF.  
>>>
>>> Right, the challenge AFAIU is how to match up multiple functions into 
>>> a single devlink instance, when driver has to probe them one by one.  
>>
>> Does it make sense if the PF first probed creates a auxiliary device,
>> and the auxiliary device driver creates the devlink instance? And
>> the PF probed later can connect/register to that devlink instance?
> 
> I would say no, that just adds another layer of complication and
> doesn't link the functions in any way.

How about:
The PF first probed creates the devlink instance? PF probed later can
connect/register to that devlink instance created by the PF first probed.
It seems some locking need to ensure the above happens as intended too.

About linking, the PF provide vendor info/serial number(or whatever is
unqiue between different vendor) of a controller it belong to, if the
controller does not exist yet, create one and connect/register to that
devlink instance, otherwise just do the connecting/registering.

