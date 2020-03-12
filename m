Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1C182621
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 01:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbgCLAMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 20:12:25 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:20416
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731418AbgCLAMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 20:12:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLgQ9fOjIcD+n0gkM9SMRz0gwrOlaZzUnuBDm8QVrN99TJZi/sXFtsyYgDVN7bbRnFL68zSBQUQo8r0a3D/GfB8me6gYzGGyeeKqXtldDpydaLQkNcJ24LnnhBk5xMp/a+bZIonxdhMOJ7znPq7WkWiMUoQYlvsGkWXFfZVG2yXMdhQLq9gdUmMU28gZOPCF+5BLIxYJqhhxy6XYBUwTk47p56fM3VBBFoCjZRSvZxxWMmMA2IAtianAM/o9ewYCoB0xtpHrxGm71bfo1GsStECCzdAj6GUTeNnqjfQzu0TRuaZzZ0AvuACgFvgLI9zq4uTXJP9J3CzMeMFxEVIhXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIOhjBaTpfGs1UP3o7gqm6IREKuoqtSYgRK9pYRwkj8=;
 b=DWXTefErMTGXzjJsihD01aNO8tb2AHVFIvkOMf2W1j30CSbScyuevwPucyyxxl/30cGuaVx7Efi54joEgY1hgNxLfmnUOW2FjVJWd3gt/lhwAHpR0e9HrX5t6ZkiKr8KVg+Zx06VJjMmt8N4aWKpU0lnEwxeLCtEJNw+1dQfDl+6L5eDa1imWzb/pqRZ9r45pC7hPOqHsBs2IWzv0z4dTHr0ECkxIbzIYBdN+QWAGwr/dDH/wbH1vuNNPDs40I57+Fbl8R9IvzuP7/NKAsgO1jBgE2qxWTAXxmk0uvu3dWYmVYlWj72JUKvEa97r74MrvcMPlCEf2mkT1Vl3fhA3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIOhjBaTpfGs1UP3o7gqm6IREKuoqtSYgRK9pYRwkj8=;
 b=nWt3Zh2TxU8g9s+bSjjOHMAG6qcLAkssXASTkwWUtq+4WQw9cnr/2hr2fHCdW1LAeI28H8Fk8WTBUXeJKszhuEZ5Lfccmra4b/io4yFSJa3f36cBZNmUja1PdHP5dfXhKTuMFXKxr/bSKfM2DI/EElJFaGmQYcUFM1o/wIU4oeA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3434.eurprd05.prod.outlook.com (10.170.245.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 00:12:20 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 00:12:20 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200311173356.38181-3-petrm@mellanox.com> <20200311150920.306de7c6@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jiri@mellanox.com, mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 2/6] net: sched: Allow extending set of supported RED flags
In-reply-to: <20200311150920.306de7c6@kicinski-fedora-PC1C0HJN>
Date:   Thu, 12 Mar 2020 01:12:16 +0100
Message-ID: <87k13qxwgv.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 00:12:19 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08553171-b44a-49c7-07bc-08d7c61a07ac
X-MS-TrafficTypeDiagnostic: HE1PR05MB3434:|HE1PR05MB3434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3434B338A8BB17EBEB65C628DBFD0@HE1PR05MB3434.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(199004)(36756003)(6916009)(52116002)(2906002)(86362001)(6496006)(316002)(6486002)(8936002)(4326008)(107886003)(5660300002)(26005)(81166006)(956004)(2616005)(478600001)(66476007)(81156014)(8676002)(16526019)(66946007)(6666004)(186003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3434;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9TisZZw5/lYxkNMZ82rux9XTh4Oh7BGNqLWWmQ1OlM8vcmxRAgzBZPBB7jaouQPBP2MyxzF7FFle+TcmCcQsutGlSqFR2SGeruu/FgA7Cw+gN9BiekitMompxJwKkwSv6b9c283RYn4zCxKwJ7w3hYuwX6IrXwvCFturf6q+9WbvAUAYdNs50dUZMgFrfq0QiY2LmNwrWiO1ws4SNSGtoibbgSwKKfXvVq1NqwHNncT7GhWISyCxMc1/ontODD5gggH9nqI6UnqBbGXRkMymjgsWTx08qwwDVzAHjgtPmdNSAY3EjXUsD+SQvlzizvhgXhsFywivBd1oL+/gybPniZdmnIwCZJThcQcMucG/poVTo+FQCI5XBBQwoWuEuVDfPh7iZg9ej2KArVamDK585NTlJuC3CALTMkcp6wCF/5TBUUYWIipu35HfuXzmpC33
X-MS-Exchange-AntiSpam-MessageData: 7f9/70xJLB5F4+ZaDsYlD+MdruW8XgEKkpgaJvtlPID+tEuynOJc/rRA1Bxavgv0Mni21cv1Bi8J86LNakuu0LPT5UZrxuLnPxScHhQKy03z7q0MC+iNszZJYP1OjAV3FI3uYzLpt/9UjSsBEWc48A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08553171-b44a-49c7-07bc-08d7c61a07ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 00:12:19.9746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MgU6b6tRK84uA78tqvvfdQesl1n4AfENw9LhwuoAZBB2tM5IqvS87HZQPAYGxFEs6Eh8s6lhyjVF6CEKYGxGdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3434
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 11 Mar 2020 19:33:52 +0200 Petr Machata wrote:
>> diff --git a/include/net/red.h b/include/net/red.h
>> index 9665582c4687..5718d2b25637 100644
>> --- a/include/net/red.h
>> +++ b/include/net/red.h
>> @@ -179,6 +179,31 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
>>  	return true;
>>  }
>>  
>> +static inline bool red_get_flags(unsigned char flags,
>> +				 unsigned char historic_mask,
>> +				 struct nlattr *flags_attr,
>> +				 unsigned int supported_mask,
>> +				 unsigned int *p_flags, unsigned char *p_userbits,
>> +				 struct netlink_ext_ack *extack)
>> +{
>> +	if (flags && flags_attr) {
>> +		NL_SET_ERR_MSG_MOD(extack, "flags should be passed either through qopt, or through a dedicated attribute");
>> +		return false;
>> +	}
>> +
>> +	*p_flags = flags & historic_mask;
>> +	if (flags_attr)
>> +		*p_flags |= nla_get_u32(flags_attr);
>
> It's less error prone for callers not to modify the output parameters
> until we're sure the call won't fail.

Ack.

>> +	if (*p_flags & ~supported_mask) {
>> +		NL_SET_ERR_MSG_MOD(extack, "unsupported RED flags specified");
>> +		return false;
>> +	}
>> +
>> +	*p_userbits = flags & ~historic_mask;
>> +	return true;
>> +}
>> +
>
>> +#define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
>> +
>>  struct tc_red_xstats {
>>  	__u32           early;          /* Early drops */
>>  	__u32           pdrop;          /* Drops due to queue limits */
>> diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
>> index 1695421333e3..61d7c5a61279 100644
>> --- a/net/sched/sch_red.c
>> +++ b/net/sched/sch_red.c
>> @@ -35,7 +35,11 @@
>>  
>>  struct red_sched_data {
>>  	u32			limit;		/* HARD maximal queue length */
>> -	unsigned char		flags;
>> +
>> +	u32			flags;
>
> Can we stick to uchar until the number of flags grows?

No problem, but the attribute is u32.

>> +	/* Non-flags in tc_red_qopt.flags. */
>> +	unsigned char		userbits;
>> +
>>  	struct timer_list	adapt_timer;
>>  	struct Qdisc		*sch;
>>  	struct red_parms	parms;
>> @@ -44,6 +48,8 @@ struct red_sched_data {
>>  	struct Qdisc		*qdisc;
>>  };
>>  
>> +#define RED_SUPPORTED_FLAGS TC_RED_HISTORIC_FLAGS
>> +
>>  static inline int red_use_ecn(struct red_sched_data *q)
>>  {
>>  	return q->flags & TC_RED_ECN;
>> @@ -186,6 +192,7 @@ static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
>>  	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
>>  	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
>>  	[TCA_RED_MAX_P] = { .type = NLA_U32 },
>> +	[TCA_RED_FLAGS] = { .type = NLA_U32 },
>
> BITFIELD32? And then perhaps turn the define into a const validation
> data?

Nice.

> Also policy needs a .strict_start_type now.

OK.

>>  };
>>  
>>  static int red_change(struct Qdisc *sch, struct nlattr *opt,
>
>> @@ -302,7 +317,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
>>  	struct nlattr *opts = NULL;
>>  	struct tc_red_qopt opt = {
>>  		.limit		= q->limit,
>> -		.flags		= q->flags,
>> +		.flags		= ((q->flags & TC_RED_HISTORIC_FLAGS) |
>> +				   q->userbits),
>
> nit: parens unnecessary

I'll drop them.

>>  		.qth_min	= q->parms.qth_min >> q->parms.Wlog,
>>  		.qth_max	= q->parms.qth_max >> q->parms.Wlog,
>>  		.Wlog		= q->parms.Wlog,
>> @@ -321,6 +337,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
>>  	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
>>  	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P))
>>  		goto nla_put_failure;
>> +	if (q->flags & ~TC_RED_HISTORIC_FLAGS)
>> +		nla_put_u32(skb, TCA_RED_FLAGS, q->flags);
>
> Not 100% sure if conditional is needed, but please check the return
> code.

I didn't want to bother old-style clients with the new attribute.

I'll add the check.

>>  	return nla_nest_end(skb, opts);
>>  
>>  nla_put_failure:

