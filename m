Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74072193B7B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCZJGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:06:48 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:57504
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgCZJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 05:06:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kl09BMsRCP283EoHIlziSlHBvKGkCTPpgNbplT7rW+82Gi6qWCfMqfm4q51yLv0ycCvnXD0XvBylLDRNrP0JvKM4bxfP1rWq5KiOPTZD6yRGwWsCZLM/jqGvS1Rc6z1GjXCfWqe63cqjrKTdC7Wg5Ri47XMV8UgU0zeqPMb6Aa5wCgSl/mfxaHyWtfWNXVrR6mV2+itMbu7Y6/qaULLIZ++uAG5V5ns563YQDwVWAUQSOekiLgjGJqY6Kx4PnzjTwJXmBwrEbkStfjKAeYBZVtBfxXDZhEHMQJtVIEnwgJh6mWkPU5Hnjg64LHcGzzdsYxSweFPkrwyp1qI0dtD1zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJMSukIhdsqLzaCSZrQf4AEphNQC2pdZc2AFAiodNT4=;
 b=iWXL95cr1TnzCzHGitHoUKd0pH6u2Py57RnQ3FzrbsyaOrH2TC18B2QecOEtrFD0zEJcv2iC9W20IKMdr0/yUooMQ+BwBb9zOtgA9tjnFM059dvWHFHuevzUxvnpFDg/8qFusWbHU9SQv2+MFchdPjKMysMMtOwAGHR6QKzExLtD26M37NDZhM2lO+IkSo7oKSn9Ob7hsQsbVgHE3OxxDLjkml3pR+KlnOzco14249jbAGs6YEt5OKwoYmDav2G3gyVn/2cDc/sABtXEHvwj9ETahQf1PQTZuTRbEhOT8W2ija23rFoy/+awJiJM4eZz6x7R/eTbb3s5S5NwKpgQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJMSukIhdsqLzaCSZrQf4AEphNQC2pdZc2AFAiodNT4=;
 b=JWiGlEutv15nhGVLl6OzS+Wl67Cof8FUcwiBk/HedxLfw58yfo9M9DisHHk7JIJPaiGoCOtc3UuNksXqE7FckAJ6ncYBkCDDrEmCYzfXvZBXmbi4Cpql0KBDVJ9V6ZOEXPABGykFVsY5kZpvWFSJUrs4wJoWHZ3WqVRCau5QXvI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3700.eurprd05.prod.outlook.com (52.133.44.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Thu, 26 Mar 2020 09:06:43 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::ecea:a698:2e87:97c9]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::ecea:a698:2e87:97c9%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 09:06:43 +0000
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
 <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
 <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325190821.GE11304@nanopsycho.orion>
 <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
 <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eran Ben Elisha <eranbe@mellanox.com>
Message-ID: <d0f13b04-8742-a2d3-09d8-5a572c7910ea@mellanox.com>
Date:   Thu, 26 Mar 2020 11:06:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::49) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.15] (77.127.74.159) by AM4PR0101CA0081.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Thu, 26 Mar 2020 09:06:42 +0000
X-Originating-IP: [77.127.74.159]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 488346a6-91bb-4a02-d04b-08d7d16500e0
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3700:|AM0PR0502MB3700:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB37006A74AC4F912A13E502B9BACF0@AM0PR0502MB3700.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(86362001)(5660300002)(31696002)(54906003)(66946007)(6486002)(16576012)(81156014)(316002)(81166006)(8936002)(66476007)(36756003)(4326008)(478600001)(66556008)(2906002)(16526019)(6916009)(52116002)(31686004)(186003)(26005)(956004)(107886003)(2616005)(53546011)(8676002)(309714004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DwbSFqwJlu03laYl2/2ODMQypDPYj9/OcgeI842pg+tELS+5mm5OCYgChFSnNHUtNX89hOSVzrvAudsUJ0tY7UKH2D3teHcHlf+7Sqk0ieU6GFHrXe1Kn7l2I5MWafpk7PeVanpHCp+gYJHHiWg8XXC0PhYEnmtcM6bSh1vCnOfkF/mFkafwzu0psm7qyHJHWxXOxyJsNaJUkn+7vsNvxkv+F0DT75GT4lVJsCynuI4wPcE4gOv6YnzrewiFE5fT8fs1mxCVpQVbEoU9fW++jZLk5Rh5Dkoi+e/kS9y9zhSXyne/xybEW08u5UP5jQ6N22ZdTQ6tHL7t1lf4WIBP5bxvThK3YY7tINRGw4XbWr6Nwiylxh2UufC3p2IO1xv1bm+nPjtlA5f9VfvFqFPmYQoJeRd+EIqgjnQwIhapbd/je3FMot45pqtUzVBefAoTokm0KQOhlDvYdi+WMa8YLttobnrWKquaZo9NYfUaKSQ90ml63NDK1GjlWYhHHQu
X-MS-Exchange-AntiSpam-MessageData: 2mOA4A9mhYftrd5dBQzZ6xNAwGVDOLxsoEqFpb4T1mGFet1sofx9CVTQMEi8ze9YAPLZMDWuLdHOgUe3xPOpz3oPGznTv4nXYmXrsCxvBPrUsaXJT/WqyrmIsemNOFIyHj1O98o5tTInqyZs6AgZOQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488346a6-91bb-4a02-d04b-08d7d16500e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 09:06:43.4179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tc1FZwTH8+kUjYm8x6ilq3QbMO1lFRdDyVHEcIMcw1lvkHDlvYvHhQp3drgn5V6Su28Bu0891BT7UwHmjtVAMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3700
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 2:01 AM, Jakub Kicinski wrote:
> On Wed, 25 Mar 2020 21:38:35 +0200 Eran Ben Elisha wrote:
>> On 3/25/2020 9:08 PM, Jiri Pirko wrote:
>>> Wed, Mar 25, 2020 at 07:45:29PM CET, kuba@kernel.org wrote:
>>>> On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:
>>>>> On low memory system, run time dumps can consume too much memory. Add
>>>>> administrator ability to disable auto dumps per reporter as part of the
>>>>> error flow handle routine.
>>>>>
>>>>> This attribute is not relevant while executing
>>>>> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
>>>>>
>>>>> By default, auto dump is activated for any reporter that has a dump method,
>>>>> as part of the reporter registration to devlink.
>>>>>
>>>>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>>>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>>>> ---
>>>>>    include/uapi/linux/devlink.h |  2 ++
>>>>>    net/core/devlink.c           | 26 ++++++++++++++++++++++----
>>>>>    2 files changed, 24 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>>>>> index dfdffc42e87d..e7891d1d2ebd 100644
>>>>> --- a/include/uapi/linux/devlink.h
>>>>> +++ b/include/uapi/linux/devlink.h
>>>>> @@ -429,6 +429,8 @@ enum devlink_attr {
>>>>>    	DEVLINK_ATTR_NETNS_FD,			/* u32 */
>>>>>    	DEVLINK_ATTR_NETNS_PID,			/* u32 */
>>>>>    	DEVLINK_ATTR_NETNS_ID,			/* u32 */
>>>>> +
>>>>> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
>>>>>    	/* add new attributes above here, update the policy in devlink.c */
>>>>>    
>>>>>    	__DEVLINK_ATTR_MAX,
>>>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>>>> index ad69379747ef..e14bf3052289 100644
>>>>> --- a/net/core/devlink.c
>>>>> +++ b/net/core/devlink.c
>>>>> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
>>>>>    	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
>>>>>    	u64 graceful_period;
>>>>>    	bool auto_recover;
>>>>> +	bool auto_dump;
>>>>>    	u8 health_state;
>>>>>    	u64 dump_ts;
>>>>>    	u64 dump_real_ts;
>>>>> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
>>>>>    	reporter->devlink = devlink;
>>>>>    	reporter->graceful_period = graceful_period;
>>>>>    	reporter->auto_recover = !!ops->recover;
>>>>> +	reporter->auto_dump = !!ops->dump;
>>>>>    	mutex_init(&reporter->dump_lock);
>>>>>    	refcount_set(&reporter->refcount, 1);
>>>>>    	list_add_tail(&reporter->list, &devlink->reporter_list);
>>>>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>>>>>    	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>>>>>    			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>>>>>    		goto reporter_nest_cancel;
>>>>> +	if (reporter->ops->dump &&
>>>>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
>>>>> +		       reporter->auto_dump))
>>>>> +		goto reporter_nest_cancel;
>>>>
>>>> Since you're making it a u8 - does it make sense to indicate to user
>>>
>>> Please don't be mistaken. u8 carries a bool here.
> 
> Are you okay with limiting the value in the policy?
> 
> I guess the auto-recover doesn't have it so we'd create a little
> inconsistency.
> 
>>>> space whether the dump is disabled or not supported?
>>>
>>> If you want to expose "not supported", I suggest to do it in another
>>> attr. Because this attr is here to do the config from userspace. Would
>>> be off if the same enum would carry "not supported".
>>>
>>> But anyway, since you opened this can, the supported/capabilities
>>> should be probably passed by a separate bitfield for all features.
>>>    
>>
>> Actually we supports trinary state per x attribute.
>> (x can be auto-dump or auto-recover which is supported since day 1)
>>
>> devlink_nl_health_reporter_fill can set
>> DEVLINK_ATTR_HEALTH_REPORTER_AUTO_X to {0 , 1 , no set}
>> And user space devlink propagates it accordingly.
>>
>> If auto_x is supported, user will see "auto_x true"
>> If auto_x is not supported, user will see "auto_x false"
>> If x is not supported at all, user will not the auto_x at all for this
>> reporter.
> 
> Yeah, makes perfect the only glitch is that for auto-dump we have the
> old kernel case. auto-recover was there from day 1.
> 
>>>> Right now no attribute means either old kernel or dump not possible.
>> when you run on old kernel, you will not see auto-dump attribute at all.
>> In any case you won't be able to distinguish in user space between
>> {auto-dump, no-auto-dump, no dump support}.
> 
> Right.
> 
> Anyway, I don't think this will matter in this particular case in
> practice, so if you're okay with the code as is:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
Thanks Jakub.

Dave,
I see the patchset is currently marked as Changes Requested. Can you 
please modify?

