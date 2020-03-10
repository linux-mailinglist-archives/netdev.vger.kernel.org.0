Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6A17F410
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgCJJs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:48:29 -0400
Received: from mail-eopbgr20056.outbound.protection.outlook.com ([40.107.2.56]:50691
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726211AbgCJJs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 05:48:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnktH0mXWtRTghUwHqVAriaAWxAoyYweueHxXTWycFqWLeYoKPe1g3T9vGWV7ldOfbBHuInP1ZLh+MJbRQaForEmw/GLjTNj3UgtVbH8gp2yea5ZUaFBw4Du4Zynna9txandpCR5NIx5nHnvBhGyY53eJkJkGeYrtCWxg/llqHgWfolvB0TmPsfWTOuoXO9T54B0sYwJcaPgQewUgl2KuH+5CLbw1F29tCoh1nSegCNb6pvST/A4vXsPLcL+XLN4tXZmV/gp9dOlViBrtj1Sqwbl+u4MNEs8TpjeyTbwKAkzURkQrWKvxGin8b8c6WGnTt2CDouuZ2qTd7VNbPn07Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yG9JfYB6pu1NQXFWHHhDF3ZjZenIwhw61hnIA0qqNBA=;
 b=aHHjNLItt75PZztw/lyRynnkISQF0ahqjsBXpeDXVd5ORj/tFaun1rxn6W4rsBTUzN4Y72OqrTTZEfRJE91WhBAyi0sJKSBx8mAfD/XcPHWGe8iksVc/qNqlcWo2s8VO6tndfpE9izBxS9xn5cLdiz52xmG+fJkarCVX5m3rEGuq0HYeBlaiXdFp1JTWjDUlf+O78sQaGvDPggef+YU/nGZLnwPntYkMUqtGu7kLcolmvrfooWFjayhgxVgeOZ2gGQ5MX1/v1ZamT/4Nu326C6VYQnq6sFsO9aRjX3oSTstONMxkwWasoWvXroPaja+dLj5tvRvD94+9w1uMO0v0hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yG9JfYB6pu1NQXFWHHhDF3ZjZenIwhw61hnIA0qqNBA=;
 b=jxGbuDZyXLF3RBAXoMWOR2oBxve8etDQSkIc433wXgxnmQq91zmaUxgJPWgFV/i6wErZoVYa6jbQ/HGfzrCx+P2cpSiXFZ2fhEks19in87jOyxTUhvcTBBt7M92ALn+DY84LvI8cCVN2W6juZYfECMWEYtT3NDR1tmazw3Mu2Wg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4635.eurprd05.prod.outlook.com (20.176.164.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 09:48:19 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 09:48:19 +0000
References: <20200309183503.173802-1-idosch@idosch.org> <20200309183503.173802-4-idosch@idosch.org> <20200309151255.29bb3a4b@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
In-reply-to: <20200309151255.29bb3a4b@kicinski-fedora-PC1C0HJN>
Date:   Tue, 10 Mar 2020 10:48:17 +0100
Message-ID: <87tv2wy1zy.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0084.eurprd07.prod.outlook.com
 (2603:10a6:207:6::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM3PR07CA0084.eurprd07.prod.outlook.com (2603:10a6:207:6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.5 via Frontend Transport; Tue, 10 Mar 2020 09:48:18 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a14df12e-27e4-4e3e-9bbe-08d7c4d82a13
X-MS-TrafficTypeDiagnostic: HE1PR05MB4635:|HE1PR05MB4635:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4635EDC1D17762BC22311081DBFF0@HE1PR05MB4635.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(39850400004)(396003)(189003)(199004)(66556008)(107886003)(26005)(66946007)(5660300002)(66476007)(6916009)(2616005)(6486002)(16526019)(54906003)(4326008)(956004)(186003)(8936002)(81166006)(81156014)(478600001)(6496006)(36756003)(2906002)(52116002)(8676002)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4635;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3o0FdEqEKhFQR1orO5jFDPfaBAgq2cfHKJzxaxKXVNW+X21+lGk4BklXLk/iFrqDGy+Kykmb3EtjSOk5USZ2+pt5l58VNWKLqtss7FLHlUYeE1FTHuYmi0ksUjclFN46836q1+stH8QDma7kOSFFUal6/lbGFT0XjSZcx3zBiLYAlNtW0quSukctBagWIrQZliyUDSu3KHcDsvHWZ1PNjKrDVSUkyFLW04ytqiO20jaGoNvtwO4QUGlJihI7LTLuGheDnIgKw0v+w2LxUN1I3haqnrgDzuBNdxlWWNUiHM1SjroFx/1Spm61RYarzcy3BlLm7vk6r5/dpRuU7vhiMEmgO/l29sOz7UELlhd4LPM56LPPd1wcdT9lseI+VzLt5SPVXrd+Vzi1ZdUT8ecvEj2iVw8M5LB7/JXUSG5OOE6E6/NIGOuzT52v/vY3N8TO
X-MS-Exchange-AntiSpam-MessageData: dLFCs0KClUQgnVOV+eb2WKrbnht2QhAUcN35aLqf4xZT5exOReJU0LgMtDYSra/mkOg4R7MqsmpBdYYv337TV7ZP9oewBbNSw8udP5nlzEjTWDgN7NrzDkassIqLgODvr5kF+JZoCXVwY0h8kRmV/A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a14df12e-27e4-4e3e-9bbe-08d7c4d82a13
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 09:48:19.6481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNBBYvmDB7DxH5SbIcH+/5dmP+v5I18ADm0By8gFBzF1Z6EQjHkVtIkJCuC/773ClqWTsVXagRmOtTa/AC5Jig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4635
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Mon,  9 Mar 2020 20:35:00 +0200 Ido Schimmel wrote:
>> diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
>> index f9839d68b811..d72db7643a37 100644
>> --- a/net/sched/sch_red.c
>> +++ b/net/sched/sch_red.c
>> @@ -44,7 +44,8 @@ struct red_sched_data {
>>  	struct Qdisc		*qdisc;
>>  };
>>
>> -#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
>> +#define RED_SUPPORTED_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | \
>> +			     TC_RED_ADAPTATIVE | TC_RED_TAILDROP)
>>
>>  static inline int red_use_ecn(struct red_sched_data *q)
>>  {
>> @@ -56,6 +57,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
>>  	return q->flags & TC_RED_HARDDROP;
>>  }
>>
>> +static inline int red_use_taildrop(struct red_sched_data *q)
>
> Please don't do static inlines in C code, even if the neighboring code
> does.

Ok.

>> +{
>> +	return q->flags & TC_RED_TAILDROP;
>> +}
>> +
>>  static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>  		       struct sk_buff **to_free)
>>  {
>> @@ -76,23 +82,36 @@ static int red_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>
>>  	case RED_PROB_MARK:
>>  		qdisc_qstats_overlimit(sch);
>> -		if (!red_use_ecn(q) || !INET_ECN_set_ce(skb)) {
>> +		if (!red_use_ecn(q)) {
>>  			q->stats.prob_drop++;
>>  			goto congestion_drop;
>>  		}
>>
>> -		q->stats.prob_mark++;
>> +		if (INET_ECN_set_ce(skb)) {
>> +			q->stats.prob_mark++;
>> +		} else if (red_use_taildrop(q)) {
>
> This condition is inverted, no?
>
> If user requested taildrop the packet should be queued.

Argh, yes! I was meddling with different ways of coding the if-else
after Ido reviewed it and screwed it up. Thanks for catching it.

My tests have not caught this, because they all hit the hard mark case
:(

>> +			q->stats.prob_drop++;
>> +			goto congestion_drop;
>> +		}
>> +
>> +		/* Non-ECT packet in ECN taildrop mode: queue it. */
>>  		break;
>>
>>  	case RED_HARD_MARK:
>>  		qdisc_qstats_overlimit(sch);
>> -		if (red_use_harddrop(q) || !red_use_ecn(q) ||
>> -		    !INET_ECN_set_ce(skb)) {
>> +		if (red_use_harddrop(q) || !red_use_ecn(q)) {
>> +			q->stats.forced_drop++;
>> +			goto congestion_drop;
>> +		}
>> +
>> +		if (INET_ECN_set_ce(skb)) {
>> +			q->stats.forced_mark++;
>> +		} else if (!red_use_taildrop(q)) {
>
> This one looks correct.
>
>>  			q->stats.forced_drop++;
>>  			goto congestion_drop;
>>  		}
>>
>> -		q->stats.forced_mark++;
>> +		/* Non-ECT packet in ECN taildrop mode: queue it. */
>>  		break;
>>  	}
>>
