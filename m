Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498BB3F6D65
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 04:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhHYCUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 22:20:54 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8766 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhHYCUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 22:20:53 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GvV6Y2gXzzYtM8;
        Wed, 25 Aug 2021 10:19:33 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 10:20:06 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 25
 Aug 2021 10:20:05 +0800
Subject: Re: [PATCH RESEND ethtool-next] netlink: settings: add two link
 extended substates of bad signal integrity
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <amitc@mellanox.com>,
        <idosch@idosch.org>, <andrew@lunn.ch>, <o.rempel@pengutronix.de>,
        <f.fainelli@gmail.com>, <jacob.e.keller@intel.com>,
        <mlxsw@mellanox.com>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>
References: <1629771291-31425-1-git-send-email-huangguangbin2@huawei.com>
 <20210824173614.mkv5i72sutxtdvrk@lion.mk-sys.cz>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <be3ebe2e-4783-2a1e-2b37-d6d5bf332114@huawei.com>
Date:   Wed, 25 Aug 2021 10:20:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210824173614.mkv5i72sutxtdvrk@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/25 1:36, Michal Kubecek wrote:
> On Tue, Aug 24, 2021 at 10:14:51AM +0800, Guangbin Huang wrote:
>> Add two link extended substates of bad signal integrity available in the
>> kernel.
>>
>> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST means the input
>> external clock signal for SerDes is too weak or lost.
>>
>> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS means the received signal for
>> SerDes is too weak because analog loss of signal.
>>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   netlink/settings.c   | 4 ++++
>>   uapi/linux/ethtool.h | 2 ++
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/netlink/settings.c b/netlink/settings.c
>> index e47a38f3058f..6d10a0703861 100644
>> --- a/netlink/settings.c
>> +++ b/netlink/settings.c
>> @@ -639,6 +639,10 @@ static const char *const names_bad_signal_integrity_link_ext_substate[] = {
>>   		"Large number of physical errors",
>>   	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE]		=
>>   		"Unsupported rate",
>> +	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST]	=
>> +		"Serdes reference clock lost",
>> +	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS]			=
>> +		"Serdes ALOS",
>>   };
>>   
>>   static const char *const names_cable_issue_link_ext_substate[] = {
>> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
>> index c6ec1111ffa3..bd1f09b23cf5 100644
>> --- a/uapi/linux/ethtool.h
>> +++ b/uapi/linux/ethtool.h
>> @@ -637,6 +637,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
>>   enum ethtool_link_ext_substate_bad_signal_integrity {
>>   	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
>>   	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
>> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
>> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
>>   };
>>   
>>   /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
> 
> Please split the uapi header update into a separate patch and update all
> headers to a specific commit (preferrably current net-next head) as
> described in the last section of
> 
>    https://www.kernel.org/pub/software/network/ethtool/devel.html
> 
> The patch looks good otherwise.
> 
> Michal
> 
Ok.
