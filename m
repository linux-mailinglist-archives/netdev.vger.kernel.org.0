Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49A13A12D4
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbhFILhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:37:18 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3923 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhFILhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 07:37:17 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0Q1r16SRz6w4c;
        Wed,  9 Jun 2021 19:32:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 19:35:19 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 19:35:19 +0800
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
 <17a59ab0-be25-3588-dd1e-9497652bfe23@huawei.com>
 <PH0PR12MB5481256C55F3498F63FE103DDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4e696fd6-3c7b-b48c-18da-16aa57da4d54@huawei.com>
 <DM8PR12MB5480BE54D27770DEB39EA009DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c30727a7-49a5-db18-ed16-e96e55ec66a3@huawei.com>
Date:   Wed, 9 Jun 2021 19:35:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <DM8PR12MB5480BE54D27770DEB39EA009DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme720-chm.china.huawei.com (10.1.199.116) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/9 17:24, Parav Pandit wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> I thought the representor ports of a PF'eswitch is decided by the function
>> under a specific PF(For example, the PF itself and the VF under this PF)?
> 
> Eswitch is not per PF in context of smartnic/multi-host.

So the Eswitch may be per PF in context of *non*-"smartnic/multi-host",
right?
It seems that it makes more sense to set the eswitch mode based on
devlink port instance instead of devlink instance if devlink instance
represents a multi-function ASIC?

> PF _has_ eswitch that contains the representor ports for PF, VF, SF.
> 
>>
>>> Each representor port represent either PF, VF or SF.
>>> This PF, VF or SF can be of local controller residing on the eswitch device or
>> it can be of an external controller(s).
>>> Here external controller = 1.
>>
>> If I understood above correctly:
>> The fw/hw decide which PF has the eswitch, and how many
>> devlink/representor port does this eswitch has?
> Number of ports are dynamic. When new SFs/VFs are created, ports get added to the switch.
> 
>> Suppose PF0 of controller_num=0 in have the eswitch, and the eswitch may
>> has devlink/representor port representing other PF, like PF1 in
>> controller_num=0, and even PF0/PF1 in controller_num=1?
> Yes. Correct.

Thanks for clarifying, I think I can see the big picture now.

> 

