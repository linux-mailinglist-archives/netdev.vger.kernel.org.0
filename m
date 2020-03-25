Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7653019313E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCYTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:38:46 -0400
Received: from mail-eopbgr20083.outbound.protection.outlook.com ([40.107.2.83]:8421
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727355AbgCYTiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 15:38:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZMJ2FMJeVObIZGmsolMptIQBmuQ4AxvBMGdWfj/wK4Sa4C0Dd7xyo0fqEoXlQ5HW/75Wfq+Hi1mGORSeFbtIMV9yk2ewdCo9uVC2kKPQ074RKrakuFDMIVe8+E2w2UVXl3OtyJHVDaNJ7DC9LtSqPo7hZDX0g1VP0MOMy1Xb+R48dBQjzYyafQ/AEEvTlXTTVTILfgiP4GjaON4vuO70knZAXjMntgLwaEkQlQs2WbvxKaQCZyq9vbaqKhZYN4/IQmoHqMTXfR45ouQoQL9rvBXNsEpPCJYwJrDnnlEnEw/Ec8Z58cuAf8Cw/L3lk4CUiwoPG0pS78LDr7rLJ32pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaMSfx+rulcDyqoIaSiR3Hb1O3jdzQUMC4mtPAWQX/M=;
 b=TXM92ERXZQNOh3+RdP4eN+AeQW4O9YKrSS6vRwSTAbBBQ9Marrm/g626Z+aa/6NhkvcO2m2kX9zye9HrPILaMR0fKTDfwib8WSvG+QmqaoTei5LJh80dET02JNigQMDxYW2t4F7632/NDDtX6d0bHgGl5tmaevj9q1MXCQLgp1QHyCVZFKAi2wWanLS89EGM7HAshQY4z7A3/kMrQ2vYE+QdS9j15J+hIOY4mw3OyLFjzHN8F/hB6ZZPoatdjz63nWaH+jnVhEFXh9/Tvy4yBeX3HhcP/jWZV1Bp/s0/01nZKMrg8UOwJ15z+ClPd9qedHbIq9973AvyyuJmi0sldA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaMSfx+rulcDyqoIaSiR3Hb1O3jdzQUMC4mtPAWQX/M=;
 b=tSHksn2ALvi0Qz7/6jfIPA4bSXgUXTYsbwnoxRNJ6iX2uxFMSpfFi/Xpi0WgvjyTSovXSbvCN0oTiDvKXIswQxBK+3pQzpQqxov85/Kp08O/pQMUWZW3mYNf+bgX3jW4KjR2BJAgPVQqmQRp5P3VC1OvUn9NY8TOe7AZFGzR+9k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3732.eurprd05.prod.outlook.com (52.133.50.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Wed, 25 Mar 2020 19:38:41 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::ecea:a698:2e87:97c9]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::ecea:a698:2e87:97c9%7]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 19:38:41 +0000
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
 <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
 <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325190821.GE11304@nanopsycho.orion>
From:   Eran Ben Elisha <eranbe@mellanox.com>
Message-ID: <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
Date:   Wed, 25 Mar 2020 21:38:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200325190821.GE11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::12) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.15] (77.127.74.159) by FR2P281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.24 via Frontend Transport; Wed, 25 Mar 2020 19:38:39 +0000
X-Originating-IP: [77.127.74.159]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36b008f6-e7c7-4983-b85e-08d7d0f41f4a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3732:|AM0PR0502MB3732:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB37329D3580FB83DE15B0CAC0BACE0@AM0PR0502MB3732.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(316002)(6486002)(16576012)(2906002)(36756003)(31686004)(110136005)(54906003)(66946007)(478600001)(66476007)(66556008)(5660300002)(86362001)(31696002)(16526019)(186003)(6666004)(107886003)(52116002)(26005)(4326008)(956004)(2616005)(8676002)(81166006)(53546011)(81156014)(8936002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3732;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgh0EmjhW6K+CklxdNFbU0Sa1k5sfvbUHwc5t5DK00f8KTGPVIcQSDM6oY03IezITx8fJDFrZTQEI7hIjDkAq+2U48jwsvS/AAwBU6LC6SaFjQ1vodWYzsrYFj+qvoQM4UWD39U7c+ytWqOq794xIzD3BBj2I2jBwG8DPXaClJXZ4v1CFTCzfqWA0+myENzd23lH0uzLEtdftG4y4W1MOV1TmVY1hRYqyG+Tt5suiIYXFR4j1mk7TNBsYSMw/0GnN39ozn192zD3SGKbZnD1o7aSB1iJF8nDHZmZod3MlyEXBzRTaAtvxXDTRaFHI9KgcVGURkis7jeDXWQK4CLRrIvkCJ5pGVX2s27tTUr1y5/J/KtfSRbeoMv6K1Js0Cw45ndHTFb7bZHB/sJtA77kPZnnBtJ6EcyuRf9HbxZqi/8lo/QVb/Ifc1K8mBmccCio3U2pc/2q1jbAhqUgpZ47Ws2ymcgv00flTW06SS9D7QJpI83yXyZQss+qeZP8WDbi
X-MS-Exchange-AntiSpam-MessageData: Ifp4fk4cIdB+4EwG3tP1pJLvLmsOyR41bAsKIQGUU04+WMCD8kE+KwJStezy4x3cO++w3XeX2jOzm3rAFQK5jrUwMoHCy40ABJ5LKO7nWqqwNOEAz4MTYjw8ecD/8EdSb19xgaCAIn1myvp/h3FgGg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b008f6-e7c7-4983-b85e-08d7d0f41f4a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 19:38:41.3611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQbXIB8Pbi1+2xEsX+qdbN6nB5oYJa6BPxT9kllQ58QUgapFF0sboogYAyTyawL9+tbnN+UssFRRJR3lp8vVmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 9:08 PM, Jiri Pirko wrote:
> Wed, Mar 25, 2020 at 07:45:29PM CET, kuba@kernel.org wrote:
>> On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:
>>> On low memory system, run time dumps can consume too much memory. Add
>>> administrator ability to disable auto dumps per reporter as part of the
>>> error flow handle routine.
>>>
>>> This attribute is not relevant while executing
>>> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
>>>
>>> By default, auto dump is activated for any reporter that has a dump method,
>>> as part of the reporter registration to devlink.
>>>
>>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>>> ---
>>>   include/uapi/linux/devlink.h |  2 ++
>>>   net/core/devlink.c           | 26 ++++++++++++++++++++++----
>>>   2 files changed, 24 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>>> index dfdffc42e87d..e7891d1d2ebd 100644
>>> --- a/include/uapi/linux/devlink.h
>>> +++ b/include/uapi/linux/devlink.h
>>> @@ -429,6 +429,8 @@ enum devlink_attr {
>>>   	DEVLINK_ATTR_NETNS_FD,			/* u32 */
>>>   	DEVLINK_ATTR_NETNS_PID,			/* u32 */
>>>   	DEVLINK_ATTR_NETNS_ID,			/* u32 */
>>> +
>>> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
>>>   	/* add new attributes above here, update the policy in devlink.c */
>>>   
>>>   	__DEVLINK_ATTR_MAX,
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>> index ad69379747ef..e14bf3052289 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
>>>   	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
>>>   	u64 graceful_period;
>>>   	bool auto_recover;
>>> +	bool auto_dump;
>>>   	u8 health_state;
>>>   	u64 dump_ts;
>>>   	u64 dump_real_ts;
>>> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
>>>   	reporter->devlink = devlink;
>>>   	reporter->graceful_period = graceful_period;
>>>   	reporter->auto_recover = !!ops->recover;
>>> +	reporter->auto_dump = !!ops->dump;
>>>   	mutex_init(&reporter->dump_lock);
>>>   	refcount_set(&reporter->refcount, 1);
>>>   	list_add_tail(&reporter->list, &devlink->reporter_list);
>>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>>>   	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>>>   			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>>>   		goto reporter_nest_cancel;
>>> +	if (reporter->ops->dump &&
>>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
>>> +		       reporter->auto_dump))
>>> +		goto reporter_nest_cancel;
>>
>> Since you're making it a u8 - does it make sense to indicate to user
> 
> Please don't be mistaken. u8 carries a bool here.
> 
> 
>> space whether the dump is disabled or not supported?
> 
> If you want to expose "not supported", I suggest to do it in another
> attr. Because this attr is here to do the config from userspace. Would
> be off if the same enum would carry "not supported".
> 
> But anyway, since you opened this can, the supported/capabilities
> should be probably passed by a separate bitfield for all features.
> 

Actually we supports trinary state per x attribute.
(x can be auto-dump or auto-recover which is supported since day 1)

devlink_nl_health_reporter_fill can set
DEVLINK_ATTR_HEALTH_REPORTER_AUTO_X to {0 , 1 , no set}
And user space devlink propagates it accordingly.

If auto_x is supported, user will see "auto_x true"
If auto_x is not supported, user will see "auto_x false"
If x is not supported at all, user will not the auto_x at all for this 
reporter.

> 
>>
>> Right now no attribute means either old kernel or dump not possible.
when you run on old kernel, you will not see auto-dump attribute at all. 
In any case you won't be able to distinguish in user space between 
{auto-dump, no-auto-dump, no dump support}.

>>
>>>   	nla_nest_end(msg, reporter_attr);
>>>   	genlmsg_end(msg, hdr);
>>> @@ -5129,10 +5135,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
>>>   
>>>   	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
>>>   
>>> -	mutex_lock(&reporter->dump_lock);
>>> -	/* store current dump of current error, for later analysis */
>>> -	devlink_health_do_dump(reporter, priv_ctx, NULL);
>>> -	mutex_unlock(&reporter->dump_lock);
>>> +	if (reporter->auto_dump) {
>>> +		mutex_lock(&reporter->dump_lock);
>>> +		/* store current dump of current error, for later analysis */
>>> +		devlink_health_do_dump(reporter, priv_ctx, NULL);
>>> +		mutex_unlock(&reporter->dump_lock);
>>> +	}
>>>   
>>>   	if (reporter->auto_recover)
>>>   		return devlink_health_reporter_recover(reporter,
>>> @@ -5306,6 +5314,11 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>>>   		err = -EOPNOTSUPP;
>>>   		goto out;
>>>   	}
>>> +	if (!reporter->ops->dump &&
>>> +	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {
>>
>> ... and then this behavior may have to change, I think?
>>
>>> +		err = -EOPNOTSUPP;
>>> +		goto out;
>>> +	}
>>>   
>>>   	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
>>>   		reporter->graceful_period =
>>> @@ -5315,6 +5328,10 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>>>   		reporter->auto_recover =
>>>   			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
>>>   
>>> +	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
>>> +		reporter->auto_dump =
>>> +		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
>>> +
>>>   	devlink_health_reporter_put(reporter);
>>>   	return 0;
>>>   out:
>>> @@ -6053,6 +6070,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>>>   	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
>>>   	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
>>>   	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
>>> +	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
>>
>> I'd suggest we keep the attrs in order of definition, because we should
>> set .strict_start_type, and then it matters which are before and which
>> are after.
>>
>> Also please set max value of 1.
>>
>>>   	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
>>>   	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
>>>   	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
>>
