Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F141DC4C5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 03:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEUBd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 21:33:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4875 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbgEUBd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 21:33:28 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1981816C4F75FA4064F8;
        Thu, 21 May 2020 09:33:26 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 21 May 2020
 09:33:15 +0800
Subject: Re: [PATCH net-next 1/2] net: hns3: adds support for dynamic VLAN
 mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        GuoJia Liao <liaoguojia@huawei.com>
References: <1589937613-40545-1-git-send-email-tanhuazhong@huawei.com>
 <1589937613-40545-2-git-send-email-tanhuazhong@huawei.com>
 <20200520140617.6d8338bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <91bd81dc-5513-f717-559f-b225ab380fbc@huawei.com>
Date:   Thu, 21 May 2020 09:33:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200520140617.6d8338bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/21 5:06, Jakub Kicinski wrote:
> On Wed, 20 May 2020 09:20:12 +0800 Huazhong Tan wrote:
>> From: GuoJia Liao <liaoguojia@huawei.com>
>>
>> There is a scenario which needs vNICs enable the VLAN filter
>> in access port, while disable the VLAN filter in trunk port.
>> Access port and trunk port can switch according to the user's
>> configuration.
>>
>> This patch adds support for the dynamic VLAN mode. then the
>> HNS3 driver can support two VLAN modes: default VLAN mode and
>> dynamic VLAN mode. User can switch the mode through the
>> configuration file.
> 
> What configuration file? Sounds like you're reimplementing trusted
> VFs (ndo_set_vf_trust).
> 

Hi, Jakub.

Maybe this configuration file here is a little misleading,
this VLAN mode is decided by the firmware, the driver will
query the VLAN mode from firmware during  intializing.

I will modified this description in V2. BTW, is there any
other suggestion about this patch?

Thanks:)


>> In default VLAN mode, port based VLAN filter and VF VLAN
>> filter should always be enabled.
>>
>> In dynamic VLAN mode, port based VLAN filter is disabled, and
>> VF VLAN filter is disabled defaultly, and should be enabled
>> when there is a non-zero VLAN ID. In addition, VF VLAN filter
>> is enabled if PVID is enabled for vNIC.
>>
>> When enable promisc, VLAN filter should be disabled. When disable
>> promisc, VLAN filter's status depends on the value of
>> 'vport->vf_vlan_en', which is used to record the VF VLAN filter
>> status.
>>
>> In default VLAN mode, 'vport->vf_vlan_en' always be 'true', so
>> VF VLAN filter will set to be enabled after disabling promisc.
>>
>> In dynamic VLAN mode, 'vport->vf_vlan_en' lies on whether there
>> is a non-zero VLAN ID.
>>
>> Signed-off-by: GuoJia Liao <liaoguojia@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> .
> 

