Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41B9395907
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhEaKiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:38:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2480 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhEaKiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:38:02 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fts833qvtz67cd;
        Mon, 31 May 2021 18:33:23 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 18:36:12 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 31 May
 2021 18:36:12 +0800
Subject: Re: RE: [RFC net-next 0/8] Introducing subdev bus and devlink
 extension
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <1551418672-12822-1-git-send-email-parav@mellanox.com>
 <20190301120358.7970f0ad@cakuba.netronome.com>
 <VI1PR0501MB227107F2EB29C7462DEE3637D1710@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190304174551.2300b7bc@cakuba.netronome.com>
 <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
CC:     Parav Pandit <parav@mellanox.com>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michal.lkml@markovi.net" <michal.lkml@markovi.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        <shenjian15@huawei.com>, <linyunsheng@huawei.com>,
        "chenhao (DY)" <chenhao288@hisilicon.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <76785913-b1bf-f126-a41e-14cd0f922100@huawei.com>
Date:   Mon, 31 May 2021 18:36:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0501MB22718228FC8198C068EFC455D1720@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi, Jiri & Jakub

    Generally, a devlink instance is created for each PF/VF. This
facilitates the query and configuration of the settings of each
function. But if some common objects, like the health status of
the entire ASIC, the data read by those instances will be duplicate.

    So I wonder do I just need to apply a public devlink instance for the
entire ASIC to avoid reading the same data? If so, then I can't set
parameters for each function individually. Or is there a better suggestion
to implement it?

    Thanks! ~

On 2019/3/6 0:52, Parav Pandit wrote:
> 
> 
>> -----Original Message-----
>> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Sent: Monday, March 4, 2019 7:46 PM
>> To: Parav Pandit <parav@mellanox.com>
>> Cc: Or Gerlitz <gerlitz.or@gmail.com>; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; michal.lkml@markovi.net; davem@davemloft.net;
>> gregkh@linuxfoundation.org; Jiri Pirko <jiri@mellanox.com>
>> Subject: Re: [RFC net-next 0/8] Introducing subdev bus and devlink extension
>>
>> On Mon, 4 Mar 2019 04:41:01 +0000, Parav Pandit wrote:
>>>>> $ devlink dev show
>>>>> pci/0000:05:00.0
>>>>> subdev/subdev0
>>>>
>>>> Please don't spawn devlink instances.  Devlink instance is supposed
>>>> to represent an ASIC.  If we start spawning them willy nilly for
>>>> whatever software construct we want to model the clarity of the
>>>> ontology will suffer a lot.
>>> Devlink devices not restricted to ASIC even though today it is
>>> representing ASIC for one vendor. Today for one ASIC, it already
>>> presents multiple devlink devices (128 or more) for PF and VFs, two
>>> PFs on same ASIC etc. VF is just a sub-device which is well defined by
>>> PCISIG, whereas sub-device is not. Sub-device do consume actual ASIC
>>> resources (just like PFs and VFs), Hence point-(6) of cover-letter
>>> indicate that the devlink capability to tell how many such sub-devices
>>> can be created.
>>>
>>> In above example, they are created for a given bus-device following
>>> existing devlink construct.
>>
>> No, it's not "representing the ASIC for one vendor".  It's how it works for
>> switches (including mlxsw) and how it was described in the original cover
>> letter:
>>
> Sorry for the confusion.
> I meant to say, my understanding is Netronome creates one devlink instance for whole ASIC.
> Please correct me if this is incorrect.
> mlx5_core driver creates multiple devlink devices for PF and VFs for one ASIC.
> 
>>     Introduce devlink interface and first drivers to use it
>>
>>     There a is need for some userspace API that would allow to expose things
>>     that are not directly related to any device class like net_device of
>>     ib_device, but rather chip-wide/switch-ASIC-wide stuff.
>>
>>     [...]
>>
>> We can deviate from the original intent if need be and dilute the ontology.
>> But let's be clear on the status quo, please.
> Status quo is mlx5_core driver creates multiple devlink devices. It creates for devlink device for each PF and VF of a single ASIC. 
> 
