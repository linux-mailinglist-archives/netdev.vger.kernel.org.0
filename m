Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC743DD1F7
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhHBI3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:29:34 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:47004
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229917AbhHBI3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 04:29:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX6+V8TgSWYW+qU0MCjzgFjhL7I1vYPJSVmaeSEDceWuuBp/NuHpjLmUub492Jk5ti8hCKWyUBQT6/uZE6MC2HOEmkahfdQ3UarsL80F04kr5bUybanFA4NEMKJG+aRb6EEy6Sk1NS5p4Nh5EBR3vG6kson8KwbOf1rAiGGP0CVZEA5lY9O7/255JaWaiH6zksolkMrluBOctMh5u1F6dve6tYD32uaERpWeSTNhi6JV711Do6JOtbyVjocOOBNDaUK9Qy5iV9AFuarzyS+bb9ZPdr41b6zXYwZdZrkWmGfZTe+5Py7+LqFhyBEq0z7RvPBVA459cdKUT8M/hvH5Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SgChE1/Tk0ANwL+qashItnlcpR56R4qP1RnylNcp6E=;
 b=RaMbrJUtpLhBvw/ehvyeedilxRXswExJ57n3fsOWZTsbHN3/A9B9H9ZrZNRpacwGE0NKzwB6AR9PzXkKdrxkkmTuPZkTQlGM6GvQaZ9fgfeQThRSsdUgs0RCvkFihacckEpEBr5o0bbdp24+rTl3fyGQZ3C3hVsveMOMN9iQsoPSx572Tf9mzLp/eMGVjqMYFUOk08l8uShLoKSnscYoPACrQuEBLwl6o6ms7K1+238HzCNKEeB80V7vxbqvZuySMLJikCVTwW4GlxqFQ2vT5UTmyLGOQ732yUg8FcsuVJW0PED3dbH69xvJq54sKOWLMbk3weJ4Gra2qe9StLV7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9SgChE1/Tk0ANwL+qashItnlcpR56R4qP1RnylNcp6E=;
 b=nY2JdbwL53t0+7UQO4qE/sQeBNSAk5ncu797u6A0Nl8VmLg3abQKiAlNmV7XtCVROdz9lqIOs71Qv8WQ+VRTfI5QaZavilcHflKqDxj3uhEE5y72VtOVWyADq8wWHqo5L7UjK6dlaNat+AvEHSw93Upd8ZFEQxMXV6pgqyyE1mQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR08MB3341.eurprd08.prod.outlook.com (2603:10a6:803:42::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 08:29:18 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 08:29:18 +0000
Subject: Re: [PATCH v2] sock: allow reading and changing sk_userlocks with
 setsockopt
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
 <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <9ead0d04-f243-b637-355c-af11af45fb5a@virtuozzo.com>
Date:   Mon, 2 Aug 2021 11:26:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210730094631.106b8bec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0014.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19e::19) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.100] (46.39.230.13) by PR1P264CA0014.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Mon, 2 Aug 2021 08:29:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0951f286-a107-4cd1-fd8a-08d9558f9e97
X-MS-TrafficTypeDiagnostic: VI1PR08MB3341:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR08MB33419D3072394F7CE0F708C7B7EF9@VI1PR08MB3341.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtJ7JSZ55AN6morDiZnafJWz+Jb08ea7e7h34cBXE9zkIQ+CbsVp/aqQy2T7AutlLlZ1uZNUVBz/4ev9RemQGN6FuC5MQrbE8FJ4XUpVi6L/V86TntHSwy2q07Y9bqiHZXCVsGiY/YxO90s8x23KUwnYJhnADdtKotdbkttSZLr4Oj+PNBLDjxqshw89cEVbsYA6BW/w1SLyOPmlV2YBp2M+gV+Fd2kZzHj9fvvbrM3yoJIvqQmfsRr6WcgGAJ06EdNKqEBpGvSYEXp6OUWKn8mweX2Qxe+mYUMsKbm93UpZvuJ1A5Eyh4+3UzVj1ZicaCOEsSJY43Y3qjbmcGIyrW3d2BnW2V3pyeWbsX5kdwDSym9zjNOisR/cJ6KXeNFbxA5F9LW6iqgvxd3xHn10XskTQ0uGTaRQHIZr6jTimMm8DGKm4Arp2kXZkARNNg1aIYfWR6YNlkWBXBUcg8jMMNEKt8Mj51teYrigQuyQfu3GAPcinQ5EoU4Pdj9qLReXthnHkz9ZGfDquEIkHwALQWvdaB5gzQ1r+p5ZvDSn/g0ZEeCQ2pYbrK86aj3RhWNxiiDBw+rN776OEI4piEhsARK0io1frP1vWmSgJhW29IZ87ejPDhYu1eH2fKTQjfmpVf8jSEQhQWct1dHPCDVwRoSwa+3wIrmRX+u0TOKxDPPYvMbmcA1eix94mD99LrdRb2ZX4xGjB4d5PDmGW9BfXa2oeHT+cPBRdmpEwYt3YhpzOldZStaviFlOeNrEkde6v1xuG0LP8NEApKvZSbDx1Cae1+iPaL4CGxTyMzk5iC2VHx7QyJVAGoh0SCUQFgQh10g+nkuVfddHQkfW/dzrJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(53546011)(8676002)(86362001)(5660300002)(83380400001)(2906002)(186003)(8936002)(36756003)(6666004)(26005)(4326008)(38100700002)(66556008)(956004)(316002)(38350700002)(16576012)(6486002)(66476007)(31686004)(508600001)(6916009)(966005)(66946007)(54906003)(52116002)(7416002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVVDZUlUdTdUZlR4S3dvWTViZk9CQnRDbzVSTSsvL1BCdHRLK0o0NjN4WUhk?=
 =?utf-8?B?WlVFUThsNWpRd2oxNnBEZE1nbnRaenBHUTQ2NmJBcnA3VmZyVGViZjFnTTBm?=
 =?utf-8?B?SmpVckEwdnVFZDhNUFI4TFh5V3JTRklEUkdtYnFaREY0U3BIVjlXdzhPKzhz?=
 =?utf-8?B?UU5BNFJsdXR0cFZHZ0VsZDdCM0owc1FlYzV5WEVwQngrMDBHbTRDcG1meTVB?=
 =?utf-8?B?N3VhTXBrbTdieVlYSmJEV1hYNjk2eW9QbFN0dHNabHJjbmZKcUVLUnZzVHNz?=
 =?utf-8?B?UkZUREdobUZ3NXU2b0x2UTNrZVZ1T1hZNU1qNkh3OU5Fa1hZQmF1Z3YwTXZr?=
 =?utf-8?B?MkZ2enB2L28rb1phcTg4a1JUdFIrOGRxVE5MS1RpWkhpYjFGZnJkVThvcmdw?=
 =?utf-8?B?NUpxK29COWdySkNqRTRRQ1VraUt0ZE1ROUNaSWpZcCt2aXR3RnFhYWdxTVhv?=
 =?utf-8?B?K0VhVjQ5MTM4YkU3QkJTWDBHK1pKZEtaZ2Rvem4zSDdSbmh3Q1hvWng4MkFo?=
 =?utf-8?B?Ly90N05YMGVSKzNkMGRjZnJUUkkxN3ZaNjJBdUpBVjFYaklGUjE4V2FiQ0NV?=
 =?utf-8?B?bmdrUTF4NUlmZU9GWXZBUGFBcis1MnlLNURLUUlFekxGd0ZON0lZaHZIUzAz?=
 =?utf-8?B?dDF1aDNTc3Ryai9ZTnZGSkx1Znhtc1AwQ2l4RWh6QWZEMW9VTTFwdi9QQ1Zh?=
 =?utf-8?B?ZVdHOTZuRjJRdm1JbWt3S1hRS3E1ZThScXdlYTU4cWRmcTlGVGplWmhSWFV4?=
 =?utf-8?B?ek1DMjBTZ2FTTy8wVjN1RHV0NktRUmYvTE5YVnRBUS9kSENKNHdRdnI3QzR6?=
 =?utf-8?B?TkRMTnhtM2FNQ2RVajdaRzd0Z2N5OEFqb0Y0VHVoa0R2RCtDRDJWVGNvNzlm?=
 =?utf-8?B?cnRsM2duL25OZUhFblVPNWl6UGMzMmFkcndUM09NbzBkR3Rmdnc2K1dzTDN6?=
 =?utf-8?B?ZDE2VUVoaXF1eFUwc3pkVGJjbEMrNmNvV3pmdUJqbFlkQnVUUWlLRFBLWmQ1?=
 =?utf-8?B?OWNiY1JVRlpSaUtuNVhrNkNxNWhUUGRpV2FORXRwb2ZFWnkycy9JbHJoUHp3?=
 =?utf-8?B?QmNaNDN5azNmZFNobzNqZnMyZDZnb0VYcmxlOXNBZlVrdWhIMkVOeDRtb2Vq?=
 =?utf-8?B?Tmk0T3RhZDJsbjNHU29NTHNYT2c0K3hxd2FNbFcxcStuLzN0RmFhZzBPRDFF?=
 =?utf-8?B?R2Z4RjF4TFZKVENSSGhDSzJXODFIWUZFcVZrWGhjemJlam44akh3dVZZeTBK?=
 =?utf-8?B?QlJLTWZXbllrMldHN3JiNkZkcVV0eVRNc0h6YTdXUlYyVjI1S1Qvc1JwQ3ZT?=
 =?utf-8?B?SDBDaHU5ejgvbGpEQ04wQlpNMjBEZ3ZFRmRsSkZtekNORCtxcjRnWjI3N0xD?=
 =?utf-8?B?M2FPM29YZjZtZk1nOGNuQ2gwbDNvNi91VEdaUjBVczZ0amZ3TmhnZEJRSHlB?=
 =?utf-8?B?OEVmdDErZXdUbGdMSTR1RmxCVk5xV1ZXT1U4bFVEKy80K3pob09ocHZsanc3?=
 =?utf-8?B?UU11ajZKN2U3WS9KendyQWZNSTlLN2tBc2NCRU10ZnErRnpRZ1VsVFduMUtp?=
 =?utf-8?B?ZCtJTGo3VU1HYVJRWGVuZS95SGNSSW9KK2xHSlEwMld2Uk80aG9xY1lKY1gy?=
 =?utf-8?B?RlpzcnVWRFB5M2JZL24rZktjY2UzVTYvbXJjZ2I3VFh6cjA1QUpBVkZPM0lr?=
 =?utf-8?B?NHNmeU0zSDVxYUJpaDg1b0E0MTh5MXBQK01uV0szcDB3VXJCYWszSTdNS3RQ?=
 =?utf-8?Q?Zx+nH8HRgj0G6W2fn29vbNyk3RL3uzC9zv8+K1L?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0951f286-a107-4cd1-fd8a-08d9558f9e97
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 08:29:18.1049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eiaCSeDsTPGuhUOH1bKO7e9pr3OqRMzXsREqEdHzNF3PQVuU1NuVPL7z1HVQZvabei574sLNCz4pX82z0MDK1maPMOYDVaY2lATdhE1zmnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.07.2021 19:46, Jakub Kicinski wrote:
> On Fri, 30 Jul 2021 19:07:08 +0300 Pavel Tikhomirov wrote:
>> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
>> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
>> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
>> is enabled on it, but if one changes the socket buffer size by
>> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
>>
>> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
>> restore as it first needs to increase buffer sizes for packet queues
>> restore and second it needs to restore back original buffer sizes. So
>> after CRIU restore all sockets become non-auto-adjustable, which can
>> decrease network performance of restored applications significantly.
>>
>> CRIU need to be able to restore sockets with enabled/disabled adjustment
>> to the same state it was before dump, so let's add special setsockopt
>> for it.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> 
> The patchwork bot is struggling to ingest this, please double check it
> applies cleanly to net-next.

I checked that it applies cleanly to net-next:

[snorch@fedora linux]$ git am 
~/Downloads/patches/ptikhomirov/setsockopt-sk_userlocks/\[PATCH\ v2\]\ 
sock\:\ allow\ reading\ and\ changing\ sk_userlocks\ with\ setsockopt.eml

[snorch@fedora linux]$ git log --oneline
c339520aadd5 (HEAD -> net-next) sock: allow reading and changing 
sk_userlocks with setsockopt

d39e8b92c341 (net-next/master) Merge 
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next


Probably it was some temporary problem and now it's OK? 
https://patchwork.kernel.org/project/netdevbpf/patch/20210730160708.6544-1-ptikhomirov@virtuozzo.com/

> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
