Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD712259EE5
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgIATAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:00:44 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2867 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIATAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:00:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e9a2d0000>; Tue, 01 Sep 2020 11:59:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 12:00:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 01 Sep 2020 12:00:43 -0700
Received: from [10.21.180.182] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 19:00:33 +0000
Subject: Re: [PATCH net-next RFC v3 03/14] devlink: Add reload actions
 counters to dev get
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-4-git-send-email-moshe@mellanox.com>
 <20200831104438.GA3794@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <433acc88-14bf-d0d5-e3b2-72356d79fe16@nvidia.com>
Date:   Tue, 1 Sep 2020 22:00:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831104438.GA3794@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598986797; bh=Q9jRw/xYyHx727EjCr3fkfyiXCo5RUPXowYslPw+a34=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=OGVo3G66SktdaMmLRDCei7cfQTGrDsJp4C+1MH+bekBmhJjqqq0ZwZcOd+UGHKO5b
         +Ar2UoIvKEiZ9zg8QBtl0EoduJ78dUaQDHn3hZbp8f6ACm5JzGpILGb4bdtwtGKMm+
         9G5RebXkYo/X20qcfVYfpI3T7DzH1MH8o9agRBorwFFuzp/yiQE5+A3yFenogp4ST9
         6tx1qsutn0bQDRLje6uSK60rDVB4Rn5hd27UxN/5EsTEPghilvnLVgIknYBbHV+Vvq
         wb3ej1NoyZwNLCjGonWwdEOBbw6gIiA1D75WRmJ2nW3eqoTr5eOBjlMq1oBZWe7rFK
         alEdGXtPc7O0w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/31/2020 1:44 PM, Jiri Pirko wrote:
> Sun, Aug 30, 2020 at 05:27:23PM CEST, moshe@mellanox.com wrote:
>> Expose devlink reload actions counters to the user through devlink dev
>> get command.
>>
>> Examples:
>> $ devlink dev show
>> pci/0000:82:00.0:
>>   reload_actions_stats:
>>     driver_reinit 2
>>     fw_activate 1
>>     fw_activate_no_reset 0
>> pci/0000:82:00.1:
>>   reload_actions_stats:
>>     driver_reinit 1
>>     fw_activate 1
>>     fw_activate_no_reset 0
>>
>> $ devlink dev show -jp
>> {
>>     "dev": {
>>         "pci/0000:82:00.0": {
>>             "reload_actions_stats": [ {
> Perhaps "reload_action_stats" would be better.
OK.
>
>>                     "driver_reinit": 2
>>                 },{
>>                     "fw_activate": 1
>>                 },{
>>                     "fw_activate_no_reset": 0
>>                 } ]
>>         },
>>         "pci/0000:82:00.1": {
>>             "reload_actions_stats": [ {
>>                     "driver_reinit": 1
>>                 },{
>>                     "fw_activate": 1
>>                 },{
>>                     "fw_activate_no_reset": 0
>>                 } ]
>>         }
>>     }
>> }
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v2 -> v3:
>> - Add reload actions counters instead of supported reload actions
>>   (reload actions counters are only for supported action so no need for
>>    both)
>> v1 -> v2:
>> - Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
>> - Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
>> - Have actions instead of levels
>> ---
>> include/uapi/linux/devlink.h |  3 +++
>> net/core/devlink.c           | 37 +++++++++++++++++++++++++++++++-----
>> 2 files changed, 35 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 0a438135c3cf..fd7667c78417 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -478,6 +478,9 @@ enum devlink_attr {
>>
>> 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>> 	DEVLINK_ATTR_RELOAD_ACTIONS_DONE,	/* nested */
>> +	DEVLINK_ATTR_RELOAD_ACTION_CNT_VALUE,	/* u32 */
>> +	DEVLINK_ATTR_RELOAD_ACTION_CNT,		/* nested */
>> +	DEVLINK_ATTR_RELOAD_ACTIONS_CNTS,	/* nested */
> Be in-sync with the user outputs. Perhaps something like:
> 	DEVLINK_ATTR_RELOAD_ACTION_STATS
> 	DEVLINK_ATTR_RELOAD_ACTION_STAT
> 	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE
> ?


I actually see it as counters of number of times action done, but 
generally counters and stats are the same, so I am fine with that too.

>> 	/* add new attributes above here, update the policy in devlink.c */
>>
> [..]
