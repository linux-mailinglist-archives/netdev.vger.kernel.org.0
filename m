Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CDC220F20
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGOOZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:25:38 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:37474
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728142AbgGOOZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 10:25:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MP5ZHpBZb+Oo5FVrBtVqBXOEhoTi91HE97uJt/XTL0AQeS6LkC1WYow2xcLKETqgdwrGZsY8exVzaFjhHtYNgSX4iBcr5Y7nYs/B4Oq1IOeAfxpLaOasjfq9JtP2woY4YRKJvcX7GMRdFxQp8pHzmkpPX4AkcTjIV3pzVTKFiER+FhD+C7lEQLRiEB3vvpywa4yswiTOUepMxnwpvcQ7dtGl7YIDwKLpSOrEAGBmsK9q8xHWLzPbPWJrpPLMspQ2ofODFLKrE8qtGJ6cJMdvMp9sQfSD1MyILEp52Y6fqIL5psOvns63/iq81SCBy9Oxnm6WSNal4x8r0Qw9EhvEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eIUWBMrjg0gYpUaMQXmRD2A20FD8Q+IjGRyqY+G9qQ=;
 b=V+hsnimdDty7mmn2DQUi8DjFpTyqW5YXM5PuymbckmUp/N0ZqiUYQ77QpjvVYLLNSSGbfOYvOhIJzMLKlOh56FWTMLv6+ay2tSlXc0cEwFJfutmrf9Yv1LXMoWe576POuKkrqO5dValhx5R8nq0XKTA9G26SYNS9qoUeZjwzl1EyWzxf9shw/fqvImGXXoDCDOAZKqQ0XlnR9hmCwQZwFhCOiVo9m5XqN9tATcpA3eZDT7sMnnnYR/VCuxoFQQqqIzU8ym19wlxGcLGI/33FOTgOp3lLq1qyG5EmvmLSPony7m9GRs9/Fp7u/MH43ZKVzL39Kgw0bUAINPUlRyQ3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5eIUWBMrjg0gYpUaMQXmRD2A20FD8Q+IjGRyqY+G9qQ=;
 b=ByCgspmHwKiTIdk1KMZr2CMmbFqrp8FDPngRF8in4eAI41PSOtxrvyRhz8A4h23BAMEfXhX3NWweEIOdFHI03Oed8v4W3uzMnWo4KjKWH/Pbj714qO/TLAMh0VB0KoBet8IyYDwjlO6Kzj16cSSiT0e4p0amn8GdmDJPdW9+5kE=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com (2603:10a6:4:80::18)
 by DB7PR05MB4458.eurprd05.prod.outlook.com (2603:10a6:5:1a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 14:25:34 +0000
Received: from DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08]) by DB6PR0501MB2648.eurprd05.prod.outlook.com
 ([fe80::4468:73d7:aecb:d08%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 14:25:34 +0000
Subject: Re: [PATCH net-next v3 1/4] net/sched: Add skb->hash field editing
 via act_skbedit
To:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org
Cc:     jiri@resnulli.us, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-2-lariel@mellanox.com>
 <69a3407fa53431bebfd937a579b4f270a129395c.camel@redhat.com>
From:   Ariel Levkovich <lariel@mellanox.com>
Message-ID: <5ba341b6-dd8d-9861-7bb4-4d8b900f7d56@mellanox.com>
Date:   Wed, 15 Jul 2020 10:25:29 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <69a3407fa53431bebfd937a579b4f270a129395c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::20) To DB6PR0501MB2648.eurprd05.prod.outlook.com
 (2603:10a6:4:80::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Ariels-iMac.local (2604:2000:1342:c20:a873:455f:b003:ffde) by AM4P190CA0010.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 14:25:32 +0000
X-Originating-IP: [2604:2000:1342:c20:a873:455f:b003:ffde]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 933b99e9-bd2e-4c73-3a69-08d828caef89
X-MS-TrafficTypeDiagnostic: DB7PR05MB4458:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB445874EF8E79AA7EAA032A46BA7E0@DB7PR05MB4458.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGQyki+QfVA2k/CGjEogfLlhmknkeD3xBoiAatQMsVQgjMRDAmYEhyIKs3pQSvqpcfih00jvJVC0qpefAY676r5KD3MABauhbEm9YpGUNWuHtJF5N/0jKXeNz0dctM0sSGeiZ8WZWkAstGcyT7yXDe4/ACV3f5mJgipFB96p+PdJU24OTVNk9LaXRNWWWIEOZswTMVLzXOx9vN3CdFmtSmb+IBvO1sWMYqmN4iLG9drFyyCY8fYE19/kkCxYscIXT3nteh9JywAlzjjy8gChwG1cNmge5t+HxGknN0XrgvREVLf4llfIEHcSE2OQLkMVViTwcL+XwXsO+VvBjOl3pMs8f3bip5dxkzFwbCp2b1i0ON00R7oSWB6lqwW282Lf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR0501MB2648.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(86362001)(2616005)(31696002)(5660300002)(36756003)(8936002)(478600001)(6486002)(8676002)(107886003)(2906002)(53546011)(6512007)(6666004)(4326008)(316002)(186003)(6506007)(66476007)(66946007)(66556008)(16526019)(52116002)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fCgE4gqMHLhFfkcQfvKsoCDfQYv1C5+JYj06tnmY3juKKQhZg+B0dS5t7usWO7D9U6d5uvlY31muz/E8uz3UEKeSTZdTPAp7LUXIz+qU/QmdFx0SywL2aDGaKpZ/I8JUNatbG9mPcP27NwkCmhzPy68kfRUERw3sAW1Q5nAedzPciSJg78C+jhmo17KIEIwXZsv4w+TqUN8Nzjc7mW3KvVHc2knvorAWx97TmbEMwg1P0r/+QZHpNlR52q3INKrBwm8vzh8QFHU59jqEQqUqzlrNUCtINKbWcxnFMgzF3wW6w76gbjpi6TDnwMPkWVI/z4I8hZwBPlN4lP+C1+RpfVmNizdvstbwXtYgbo9vjnMbC/hhErjlEV1Od/zNp58IkHnr08+XA3Py5VLXP0KTwGnwQeDiEt7oYDLBQB6253W6G9FIhHgBCqa371mK514nteQ6YA5Oicsyw9TyhPHsdAzBZaKeILJb/5S0cKuTgKAtmxP1QGdW5DfdbZHdJSvJhRuxNWfX0u+mb8l+lbK/8ofD0FNkjC7ZYKJY0oc8jEZWCDnHiF02vLndIoHw+Evr
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 933b99e9-bd2e-4c73-3a69-08d828caef89
X-MS-Exchange-CrossTenant-AuthSource: DB6PR0501MB2648.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 14:25:34.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CVcwN6AbH8mXxmyNjGd14eTkWo6idMD8Li+k4dam+UfYo5UWG7vUhkJcKUr1apqVUhev4FGQIWoQg1yCXxzW7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4458
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/20 1:11 PM, Davide Caratti wrote:
> On Sun, 2020-07-12 at 00:28 +0300, Ariel Levkovich wrote:
>> Extend act_skbedit api to allow writing into skb->hash
>> field.
>>
> [...]
>
>> Usage example:
>>
>> $ tc filter add dev ens1f0_0 ingress \
>> prio 1 chain 0 proto ip \
>> flower ip_proto tcp \
>> action skbedit hash asym_l4 basis 5 \
>> action goto chain 2
> hello Ariel, thanks for the patch!
>
>> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>   include/net/tc_act/tc_skbedit.h        |  2 ++
>>   include/uapi/linux/tc_act/tc_skbedit.h |  7 +++++
>>   net/sched/act_skbedit.c                | 38 ++++++++++++++++++++++++++
>>   3 files changed, 47 insertions(+)
> this diffstat is ok for l4 hash calculation :)
>
>> diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
>> index 00bfee70609e..44a8a4625556 100644
>> --- a/include/net/tc_act/tc_skbedit.h
>> +++ b/include/net/tc_act/tc_skbedit.h
>> @@ -18,6 +18,8 @@ struct tcf_skbedit_params {
>>   	u32 mask;
>>   	u16 queue_mapping;
>>   	u16 ptype;
>> +	u32 hash_alg;
>> +	u32 hash_basis;
>>   	struct rcu_head rcu;
>>   };
>>   
>> diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/tc_act/tc_skbedit.h
>> index 800e93377218..5877811b093b 100644
>> --- a/include/uapi/linux/tc_act/tc_skbedit.h
>> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
>> @@ -29,6 +29,11 @@
>>   #define SKBEDIT_F_PTYPE			0x8
>>   #define SKBEDIT_F_MASK			0x10
>>   #define SKBEDIT_F_INHERITDSFIELD	0x20
>> +#define SKBEDIT_F_HASH			0x40
>> +
>> +enum {
>> +	TCA_SKBEDIT_HASH_ALG_ASYM_L4,
>> +};
> nit:
>
> it's a common practice, when specifying enums in the uAPI, to set the
> first value  "UNSPEC", and last one as "MAX":
>
> enum {
> 	TCA_SKBEDIT_HASH_ALG_UNSPEC,
> 	TCA_SKBEDIT_HASH_ALG_ASYM_L4,
> 	__TCA_SKBEDIT_HASH_ALG_MAX
> };
>
> see below the rationale:


Agree. Missed that. Actual enums should start at 1.

>
>>   struct tc_skbedit {
>>   	tc_gen;
>> @@ -45,6 +50,8 @@ enum {
>>   	TCA_SKBEDIT_PTYPE,
>>   	TCA_SKBEDIT_MASK,
>>   	TCA_SKBEDIT_FLAGS,
>> +	TCA_SKBEDIT_HASH,
>> +	TCA_SKBEDIT_HASH_BASIS,
>>   	__TCA_SKBEDIT_MAX
>>   };
>>   #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
>> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
>> index b125b2be4467..2cc66c798afb 100644
>> --- a/net/sched/act_skbedit.c
>> +++ b/net/sched/act_skbedit.c
>> @@ -66,6 +66,20 @@ static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *a,
>>   	}
>>   	if (params->flags & SKBEDIT_F_PTYPE)
>>   		skb->pkt_type = params->ptype;
>> +
>> +	if (params->flags & SKBEDIT_F_HASH) {
>> +		u32 hash;
>> +
>> +		hash = skb_get_hash(skb);
>> +		/* If a hash basis was provided, add it into
>> +		 * hash calculation here and re-set skb->hash
>> +		 * to the new result with sw_hash indication
>> +		 * and keeping the l4 hash indication.
>> +		 */
>> +		hash = jhash_1word(hash, params->hash_basis);
>> +		__skb_set_sw_hash(skb, hash, skb->l4_hash);
>> +	}
> in this way you don't need to define a value in 'flags'
> (SKBEDIT_F_HASH), you just need to check if params->hash_alg is not
> zero:
> 	if (params->hash_alg) {
> 		....
> 	}
>
>>   	return action;
>>   
>>   err:
>> @@ -91,6 +105,8 @@ static const struct nla_policy skbedit_policy[TCA_SKBEDIT_MAX + 1] = {
>>   	[TCA_SKBEDIT_PTYPE]		= { .len = sizeof(u16) },
>>   	[TCA_SKBEDIT_MASK]		= { .len = sizeof(u32) },
>>   	[TCA_SKBEDIT_FLAGS]		= { .len = sizeof(u64) },
>> +	[TCA_SKBEDIT_HASH]		= { .len = sizeof(u32) },
>> +	[TCA_SKBEDIT_HASH_BASIS]	= { .len = sizeof(u32) },
>>   };
>>   
>>   static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>> @@ -107,6 +123,7 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>>   	struct tcf_skbedit *d;
>>   	u32 flags = 0, *priority = NULL, *mark = NULL, *mask = NULL;
>>   	u16 *queue_mapping = NULL, *ptype = NULL;
>> +	u32 hash_alg, hash_basis = 0;
>>   	bool exists = false;
>>   	int ret = 0, err;
>>   	u32 index;
>> @@ -156,6 +173,17 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
>>   			flags |= SKBEDIT_F_INHERITDSFIELD;
>>   	}
>>   
>> +	if (tb[TCA_SKBEDIT_HASH] != NULL) {
>> +		hash_alg = nla_get_u32(tb[TCA_SKBEDIT_HASH]);
>> +		if (hash_alg > TCA_SKBEDIT_HASH_ALG_ASYM_L4)
>> +			return -EINVAL;
> moreover, even without doing the strict validation, when somebody in the
> future will extend the uAPI, he will not need to change the line above.
> The following test will validate all good values of hash_alg:
>
> 	if (!hash_alg || hash_alg >= __TCA_SKBEDIT_HASH_ALG_MAX) {
> 		NL_SET_ERR_MSG_MOD(extack, "hash_alg is out of range");
> 		return -EINVAL;
>   	}
>
> WDYT?
>
> thanks!

I actually thought about it during implementation. Dropped it eventually.


Thanks for the comments.




