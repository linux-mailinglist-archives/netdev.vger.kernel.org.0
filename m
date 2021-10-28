Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A88E43E1C4
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJ1NQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:16:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13985 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhJ1NQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:16:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hg5Yx2J4VzWZ1h;
        Thu, 28 Oct 2021 21:12:05 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 21:14:02 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Thu, 28 Oct
 2021 21:14:01 +0800
Subject: Re: [PATCH net 1/7] net: hns3: fix pause config problem after autoneg
 disabled
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
 <20211027121149.45897-2-huangguangbin2@huawei.com> <YXmLA4AbY83UV00f@lunn.ch>
 <09eda9fe-196b-006b-6f01-f54e75715961@huawei.com> <YXqX7z2GljD6bxTr@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <41ed2a6f-b9fc-4806-72d1-1e65f946fe30@huawei.com>
Date:   Thu, 28 Oct 2021 21:14:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YXqX7z2GljD6bxTr@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/28 20:30, Andrew Lunn wrote:
>> Hi Andrew, thanks very much for your guidance on how to use pause autoneg,
>> it confuses me before because PHY registers actually have no separate setting
>> bit of pause autoneg.
>>
>> So, summarize what you mean:
>> 1. If pause autoneg is on, driver should always use the autoneg result to program
>>     the MAC. Eventhough general autoneg is off now and link state is no changed then
>>     driver just needs to keep the last configuration for the MAC, if link state is
>>     changed and phy goes down and up then driver needs to program the MAC according
>>     to the autoneg result in the link_adjust callback.
>> 2. If pause autoneg is off, driver should directly configure the MAC with tx pause
>>     and rx pause. Eventhough general autoneg is on, driver should ignore the autoneg
>>     result.
>>
>> Do I understand right?
> 
> Yes, that fits my understanding of ethtool, etc.
> 
> phylink tried to clear up some of these problems by fully implementing
> the call within phylink. All the MAC driver needs to provide is a
> method to configure the MAC pause settings. Take a look at
> phylink_ethtool_set_pauseparam() and the commit messages related to
> that.
> 
> 	Andrew
> .
> 
Ok, thanks!
