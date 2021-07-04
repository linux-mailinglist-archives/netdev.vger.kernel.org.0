Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602B23BAAD7
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 03:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhGDBkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 21:40:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5951 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhGDBkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 21:40:22 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GHWZP467Dz767g;
        Sun,  4 Jul 2021 09:34:21 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 4 Jul 2021 09:37:46 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 4 Jul
 2021 09:37:45 +0800
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
 <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
 <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08395721-4ca1-9913-19fd-4d8ec7e41e4b@huawei.com>
 <20210701085447.2270b1df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <a5d42bf6-d71f-978e-b9ae-6b04f072d988@huawei.com>
Date:   Sun, 4 Jul 2021 09:37:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210701085447.2270b1df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/1 23:54, Jakub Kicinski wrote:
> On Thu, 1 Jul 2021 17:03:32 +0800 huangguangbin (A) wrote:
>> On 2021/6/25 3:25, Jakub Kicinski wrote:
>>> On Thu, 24 Jun 2021 22:36:45 +0800 Guangbin Huang wrote:
>>>> In order to know reason why link down, add a debugfs file
>>>> "link_diagnosis_info" to get link faults from firmware, and each bit
>>>> represents one kind of fault.
>>>>
>>>> usage example:
>>>> $ cat link_diagnosis_info
>>>> Reference clock lost
>>>
>>> Please use ethtool->get_link_ext_state instead.
>>> .
>>>    
>> Hi Jakub, I have a question to consult you.
>> Some fault information in our patch are not existed in current ethtool extended
>> link states, for examples:
>> "Serdes reference clock lost"
>> "Serdes analog loss of signal"
>> "SFP tx is disabled"
>> "PHY power down"
> 
> Why would the PHY be powered down if user requested port to be up?
> 
In the case of other user may use MDIO tool to write PHY register directly to make
PHY power down, if link state can display this information, I think it is helpful.

>> "Remote fault"
> 
> I think we do have remote fault:
> 
>      state: ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE
>   substate: ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT
> 
OK.

>> Do you think these fault information can be added to ethtool extended link states?
> 
> Yes, would you mind categorizing them into state/substate and sharing
> the proposed additions with Amit, Ido, Andrew and other PHY experts?
> .
> 
OK.
