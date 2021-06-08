Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E939EFA6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhFHHhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:37:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4508 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFHHhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:37:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fzhm04RkTzZdwx;
        Tue,  8 Jun 2021 15:32:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 15:35:37 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 8 Jun 2021
 15:35:37 +0800
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
 <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <338a2463-eb3a-f642-a288-9ae45f721992@huawei.com>
 <PH0PR12MB5481FB8528A90E34FA3578C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8c3e48ce-f5ed-d35d-4f5e-1b572f251bd1@huawei.com>
 <PH0PR12MB5481EA2EB1B78BC7DD92FD19DC379@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <17a59ab0-be25-3588-dd1e-9497652bfe23@huawei.com>
Date:   Tue, 8 Jun 2021 15:35:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481EA2EB1B78BC7DD92FD19DC379@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/8 13:26, Parav Pandit wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Sent: Tuesday, June 8, 2021 8:58 AM
>>
>> On 2021/6/7 19:12, Parav Pandit wrote:
>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Sent: Monday, June 7, 2021 4:27 PM
>>>>
>>
>> [..]
>>
>>>>>
>>>>>> 2. each PF's devlink instance has three types of port, which is
>>>>>>    FLAVOUR_PHYSICAL, FLAVOUR_PCI_PF and
>>>> FLAVOUR_PCI_VF(supposing I
>>>>>> understand
>>>>>>    port flavour correctly).
>>>>>>
>>>>> FLAVOUR_PCI_{PF,VF,SF} belongs to eswitch (representor) side on
>>>> switchdev device.
>>>>
>>>> If devlink instance or eswitch is in DEVLINK_ESWITCH_MODE_LEGACY
>>>> mode, the FLAVOUR_PCI_{PF,VF,SF} port instance does not need to
>> created?
>>> No. in eswitch legacy, there are no representor netdevice or devlink ports.
>>
>> It seems each devlink port instance corresponds to a netdevice.
>> More specificly, the devlink instance is created in the struct pci_driver' probe
>> function of a pci function, a devlink port instance is created and registered to
>> that devlink instance when a netdev of that pci function is created?
>>
> Yes.
> 
>> As in diagram [1], the devlink port instance(flavour FLAVOUR_PHYSICAL) for
>> ctrl-0-pf0 is created when the netdev of ctrl-0-pf0 is created in the host of
>> smartNIC, the devlink port instance(flavour FLAVOUR_VIRTUAL) for ctrl-0-
>> pf0vfN is created when the netdev of ctrl-0-pf0vfN is created in the host of
>> smartNIC, right?
>>
> Ctrl-0-pf0vfN, ctrl-0-pf0 ports are eswitch ports. They are created where there is eswitch.
> Usually in smartnic where eswitch is located.

Does diagram in [1] corresponds to the multi-host (two) host setup as
memtioned previously?
H1.pf0.phyical_port = p0.
H1.pf1.phyical_port = p1.
H2.pf0.phyical_port = p0.
H2.pf1.phyical_port = p1.

Let's say H1 = server and H2 = smartNIC as the pci rc connected to below:
                 ---------------------------------------------------------
                 |                                                       |
                 |           --------- ---------         ------- ------- |
    -----------  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
    | server  |  | -------   ----/---- ---/----- ------- ---/--- ---/--- |
    | pci rc  |=== | pf0 |______/________/       | pf1 |___/_______/     |
    | connect |  | -------                       -------                 |
    -----------  |     | controller_num=1 (no eswitch)                   |
                 ------|--------------------------------------------------
                 (internal wire)
                       |
                 ---------------------------------------------------------
                 | devlink eswitch ports and reps                        |
                 | ----------------------------------------------------- |
                 | |ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 | ctrl-0 |ctrl-0 | |
                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
                 | ----------------------------------------------------- |
                 | |ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 | ctrl-1 |ctrl-1 | |
                 | |pf0    | pf0vfN | pf0sfN | pf1    | pf1vfN |pf1sfN | |
                 | ----------------------------------------------------- |
                 |                                                       |
                 |                                                       |
    -----------  |           --------- ---------         ------- ------- |
    | smartNIC|  |           | vf(s) | | sf(s) |         |vf(s)| |sf(s)| |
    | pci rc  |==| -------   ----/---- ---/----- ------- ---/--- ---/--- |
    | connect |  | | pf0 |______/________/       | pf1 |___/_______/     |
    -----------  | -------                       -------                 |
                 |                                                       |
                 |  local controller_num=0 (eswitch)                     |
                 ---------------------------------------------------------

A vanilla kernel can run on the smartNIC host, right?
what the smartNIC host see is two PF corresponding to ctrl-0-pf0 and
ctrl-0-pf1 When the kernel is boot up first and mlx driver is not loaded
yet, right?

I am not sure it is ok to leave out the VF and SF, but let's leave them
out for simplicity now.
When mlx driver is loaded, two devlink instances are created, which
corresponds to ctrl-0-pf0 and ctrl-0-pf1, and two devlink port instances
(flavour FLAVOUR_PHYSICAL) is created and registered to corresponding
devlink instances just created, right?

As the eswitch mode is based on devlink instance, Let's only set the mode
of ctrl-0-pf0' devlink instance to DEVLINK_ESWITCH_MODE_SWITCHDEV, the
representor netdev of ctrl-1-pf0 is created and devlink port instance of
that representor netdev is created and registered to devlink instances
corresponding to ctrl-0-pf0?

I think I miss something here, the above does not seems right, because：
1. For single host case：the PF is not passed through to the VM, devlink port
   instance of VF's representor netdev can be registered to the devlink instance
   corresponding to it's PF, right?
2. But for two-host case as above, do we need to create a devlink instances
   for the PF corresponding to ctrl-1-pf0 in smartNIC host?

> 


