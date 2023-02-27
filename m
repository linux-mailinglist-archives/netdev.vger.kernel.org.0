Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE96A4323
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjB0Nnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjB0Nni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:43:38 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2095.outbound.protection.outlook.com [40.107.247.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1E31ACF0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 05:43:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0LXndNoNVa+bHgukE6KMUHPUXupQhYNEBmjgObkAXuuu1qE/DexUYGsu06O72Pj/oW+gVZqOyNBuNW8QWP3Kv8KVoRLa+9Owav61caLQ6O0QfF7BYMdZLwSkSmBqTwC/yDrpKWeXHhj/Kk6aJ0ATAvGNDoTU3motDrMie4BBydnc1EA8qBya7cc3MOj4+3fboHPWU2y/9xuz7/u1NJ1qGPxLzPc1m0Jyv8t+Eo1Jsa+sFk7F0qAji1VB6GIFaE5aMCo2CpzYtBZvu4JyTZ6NwbS1AtZIT6eyfu3E3zu+l3wCf3OGFH5q17lq9ekzenwtceA1zdlSj0SF1vYUY6WVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzaL4DF0O+fZyl1JRXVf12kLljISBKDU89cfLtwilVg=;
 b=jX4NT3e+rvYDdKze0nn34tChf5aZu/rG9G38d9D0q/Tlbm1zaGxVTWXCy5xDbFhtZDA6RgRxpX7q/l4kr0TcZRDHQPz0vf2dhw/P+lfLKTLM6ePHJOkjZ6YpKunYPLg3lnJciedxBS/oiljcAkZky+iQTesYc3Iu+dfnfIcvUKCD3fMYSXlWsSXDBSrrHSFK+ZVurJpXvqDJcDwAv0H9hXhXiIMp1LlH0lysveSFBIb1YRrw2LUuHcz3DpH87f29z0lUw7G1lH8dT5o5melKnuA7oCqgK2MuU0KTqz0jgxldJdjBlRQErwFj/j2GR8/WkoCKwVioLzdXiaiNIhCN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzaL4DF0O+fZyl1JRXVf12kLljISBKDU89cfLtwilVg=;
 b=OXhZzccN+k8gY1J2I5/8ASSAk+UsSsQKTdZ2k9KEGBd+qmLmONbLQ6CTFnOOi3wd3Jxk7QaRliT2zjbcjMCtqHBhGc/tvRtBnRmKSmB7OpD8H3+NKKjGDkDfZfRzrxrRmzJQ5ElWS4998ygkehj41ZpCStDGyjrE/r/32xy4wKdHbkCvUMYKQqOnoY3BqVf5+3Lll0gz8ZD/RTzdRdt470H5+62Un8QXw4najp4zjhG9Vxu1S30jYcBxh7psVUkW8+gnRbDYgPr6aQsrxkO+wr8aA/G+T7zd3IrQj2pu1+c9oAyR6gHkWQU5ZFphHOPs933Qn5Zyn+LeLjd+HdpH8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com (2603:10a6:802:a5::16)
 by AM9PR08MB6641.eurprd08.prod.outlook.com (2603:10a6:20b:306::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 13:43:35 +0000
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343]) by VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343%7]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 13:43:35 +0000
Message-ID: <266de015-7712-8672-9ca0-67199817d587@virtuozzo.com>
Date:   Mon, 27 Feb 2023 15:43:33 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, ",Pablo Neira Ayuso" <pablo@netfilter.org>,
        ",Jozsef Kadlecsik" <kadlec@netfilter.org>,
        ",Eric Dumazet" <edumazet@google.com>,
        ",David S. Miller" <davem@davemloft.net>,
        ",Jakub Kicinski" <kuba@kernel.org>,
        ",Paolo Abeni" <pabeni@redhat.com>, ",kernel"@openvz.org
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
 <20230227124402.GA30043@breakpoint.cc>
From:   Alexander Atanasov <alexander.atanasov@virtuozzo.com>
In-Reply-To: <20230227124402.GA30043@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::6) To VE1PR08MB4765.eurprd08.prod.outlook.com
 (2603:10a6:802:a5::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4765:EE_|AM9PR08MB6641:EE_
X-MS-Office365-Filtering-Correlation-Id: 45abf970-3394-4687-e5ed-08db18c89f44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1oZVfbBNsCJHlhRuswIBmzVNvYMsxpoI0A6KLdpMg5wWJRmWYB4DMroOiLB+I4+47AckGSnmt+aVP7lzxFzo7dpXkmQH2G8aqJVFNN7GIErrYMWv26kg1vXPfM6xSPzp2MWm9AwgVlg4s2xy+pmBbv5m6GiPkGOgFzvrAXv3p43pftmlhPSBAHC/5Kwxvhgde9m+qO/zBeHkeGvStu6Uw6uLikkWwDHYPJ8LVztYHXzNzQlADHD5gOT4x6tktr4wy+N4kw7pVHNk37LxifIkjhlu08R0LT/6Av8kIrFXmY7dGasYb/l0BPZ5QnFZb+T2ka02meXCnMjYOGvcfi0pVxAICgAWe3URw9EN2RgJFM0bLSHpkLkvDOVrYGnhUGOA8c7j4ZP3xAE3Xcj/3SDCDUM5AG0xBJbvIBdCkwwcuLePi3Ni3F32iIn9gyWokAqw7vQK0B/HHuEbmomWv4mCGwP45Zpxt1x+Q9UFU2J3hBbccy3rMZHi0HaL9F6ydQC9Fp3QZmFxnHmYxugguZvZ7CCSRurAR67amKvVTJ+Q9Uxf/XJ1/Dk6Td0VxY6s8O+zAakP+yBlKh2zs077tBE+T3mFWQDuUZ4nrwov60zkLMYt40fxhFz1qLQxzFfsgftojxxNTRYEbHN9GP6zwGN68pBY9vSw8RtdUdW/SOR+lwNU3cRdAxpgCmuFbcBFQ3hs1mMEkmVG7uVQN0ohohEcntwVd1qnKu9tUdUQnAK35tE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4765.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199018)(316002)(2906002)(31686004)(31696002)(36756003)(44832011)(5660300002)(8936002)(86362001)(6512007)(6506007)(66946007)(186003)(8676002)(4326008)(6916009)(54906003)(38100700002)(66556008)(66476007)(41300700001)(2616005)(83380400001)(53546011)(478600001)(26005)(6486002)(107886003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzFuZjBEbERKckhpeC81dStqUXk3Um9VTWdZSUc4QzRWNzMwNFdjU01HT1py?=
 =?utf-8?B?bXd3aXF0ZG9IUzF6SE4rZmxXMzJRYzJ6dzdJQ3Fmd0U0YmNEeEl6aEZOM2Qx?=
 =?utf-8?B?bUlLcEF0S3I5ODY4L2R5QkpqUnhnTFoyZFNXYXg3eGMzNDkyOE4yOWk4ZXhH?=
 =?utf-8?B?dTJFWGRieU1sYmxhS1Y2MWlHY1pOK1lRa2F4WUJjZ2QyTk5uZmo1TThmY3Bx?=
 =?utf-8?B?ZnpYNk83ZWZUT1YwSHpyY1ZLWHFYQnZ6NXJvbmNxVGptWXROQU1kQUhjZkxO?=
 =?utf-8?B?cFYxYVd0VjBmcC8reTYyTENmckpFVm9GOVp5Z0lFS0Nub3NyTS95Q3F3ekh2?=
 =?utf-8?B?UEV1M21lNWFlclBTK2V0UEdtZk9YOWpzajBTcTVzTlpFbGY2WGtCcEwyaGU1?=
 =?utf-8?B?T2lKMXlsS0c2bGdEVHlET0hONGZpY3R5ajlZcjRxNmJrYmtSbWJDYTdJbzNj?=
 =?utf-8?B?TU4rWmZpNXBBbjQ0WlNacG9PNDNMS05ZNkxoWmdhWERHdmRrQU8ydWh1Nkc4?=
 =?utf-8?B?bkVNOUhtNWs2Sk1MUGxCWnBhWFFSTU1aVkd6Q3JwMm9EeWhtUGRSdjlMTnJ5?=
 =?utf-8?B?ajFUTFdwM0ZXZG9JelBMaHpPd01wYVhMWmhlRmlyUFlla0hIV2MxUkM0Rmdv?=
 =?utf-8?B?eUFXblZsTkExMXZjZDhCSS9MdkRkazFnd0hwUU9nZzRvSWpnaHdZSTE2NVNj?=
 =?utf-8?B?QjYzZDRsQllxcnJ1QUpBanNlMEJ6YzV5bGVWdnZaWEZuQUt4VWdqL2g2dEdE?=
 =?utf-8?B?cnlCQS9ZS2E2YnFIVVBPNUdjUEN0cFpBellUbEtPdkZ0T2NMeHRydmlOTWNs?=
 =?utf-8?B?QkJiU3lxZlpuclNQTHdwWXVFVEthVjVDd1ZXNTdUTzQ4TTJMQmcydlM3OHUv?=
 =?utf-8?B?S2NySkpoTkd1M3FEcDBtcjRRam5hanBhVlA1V1pmVGVzU2Z1RXRSUzdzZ0NJ?=
 =?utf-8?B?K3hkcGFuRHVsYTNoZGFCN2NXUCt6bnpjY0EwS2NrYzduOE4xUHU4elhualdJ?=
 =?utf-8?B?YndjWW9NOU5VcXNwZGNXbGFmbHRjZFFFcTlhcDdGTVI2Q0xHNEVoRURHNkhq?=
 =?utf-8?B?QmN6Mjd1SHc4eXlIUVBXU1d3M1hZWjVxa1pkeWswRUtsTUYzd2xpSzRjZElN?=
 =?utf-8?B?SndsMDBpLzVIdnppUlc2ZnV4UjN2MkY1YTI3VE9SeVJrcklrTUtDUmszVWh0?=
 =?utf-8?B?TTF4bTFXSU91YjVGQnU1SDBYakZGcXB0bGNrTVgwQThtVWg4RGpKYys4RGZW?=
 =?utf-8?B?QlNMNTBPQ1NKQ3c0OGppejd5bnFzclN2c1UwOGlFa1k0eGRUN2JOL0RhM3dK?=
 =?utf-8?B?ZjJoalQrY0dNQlB1VVlZZXNnQVBJb08xeW9ROUdEU1psWHg0SG9yR0F2Q0Rm?=
 =?utf-8?B?c2pXRUFhMlQwN291b2VLZk9nUlBjZnFpWkZDK0s2QU9mUDRsdVhrcE9TZ3Fw?=
 =?utf-8?B?S1Q4OXdTdWNyWnZ2TnpQa3NWUXVlazZtT0NkNC9CN051ZC9VL3hCV2c4VitB?=
 =?utf-8?B?ZFJ4NVB3WGFidHFlTURxNkptVkNpYVZhUWhDandYTmcxMkprbVBvNW5OTFEr?=
 =?utf-8?B?MFF5aURPTEQxR1ZqSEtRM1ZXbThxSlF4bXh1Q01PRHgwdm55RGVVWnhqcjg0?=
 =?utf-8?B?UWk1akE1YytHRG5YZ0N2eXIreGpFZjdTZGwrOEQwQ2cranduUzh3UDdicUdm?=
 =?utf-8?B?RUF2bHlKMm40dzM0WnUxYWlGRmhFMjRIK096L2RoN3l1MDc3MDA2MVBuS2l2?=
 =?utf-8?B?OFBHK3l3K0ZMYU1kUUV6Vm9KWEZCRHVndXI5RlFvejNVTlArUEI3eFFuKzJO?=
 =?utf-8?B?dUVaRDkzNXljSVhUN3hBSFpFWXRzZTYyS0VoeDVDcFhWMzUrbUJNV0xSamRO?=
 =?utf-8?B?VjkyVGJMNW5JR3o2L2pmbmdxeHhSc2FIUGFISCtGVW0rNFc0RWs2NTVteVdI?=
 =?utf-8?B?UGFWVmZsK1N4bXluVDNabDJ2TzB2WlFmVjMrWExyUTFjRmNtb0RKa1hoMzJn?=
 =?utf-8?B?LzAyRVJHUU9aUmhRbmM1czN1TlU5OU1DeFE5cVlpbi9KSldRZzJYN2JORCtr?=
 =?utf-8?B?YXN5TCtVaENaSnFLVnVJUkJkeVBJTmlsMGoxTERFdlBDdnZpeDNjTm5TWEhD?=
 =?utf-8?B?c1VsemI5NUZVWlpuaG56UWt5bUZSZmg0RzI0dGlJOFdPaFJZWWVoZlpSa2tG?=
 =?utf-8?Q?0sHjM9IVBOP+3+BBokCQDBo=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45abf970-3394-4687-e5ed-08db18c89f44
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4765.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 13:43:34.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ii4Z9VGqAYQiN7kJD+Oq1UczNpWqM1rt9aDCtopzap6K9sxACwdYjCvuzKfXHSCMYDy/6CD3j9UphszMnf324AbiRFnZdHPXV+kaV5kgHb3nwQkaURuEqF2lkySf2dJr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6641
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 27.02.23 14:44, Florian Westphal wrote:
> Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
>> general protection fault, probably for non-canonical
>> address 0xdead000000000115: 0000 [#1] PREEMPT SMP NOPTI
>> RIP: 0010:__nf_tables_dump_rules+0x10d/0x170 [nf_tables]
>>
>> __nf_tables_dump_rules runs under rcu_read_lock while __nft_release_table
>> is called from nf_tables_exit_net. commit_mutex is held inside
>> nf_tables_exit_net but this is not enough to guard against
>> lockless readers. When __nft_release_table does list_del(&rule->list)
>> next ptr is poisoned and it crashes while walking the list.
>>
>> Before calling __nft_release_tables all lockless readers must be done -
>> to ensure this a call to synchronize_rcu() is required.
>>
>> nf_tables_exit_net does this in case there is something to abort
>> inside __nf_tables_abort but it does not do so otherwise.
>> Fix this by add the missing synchronize_rcu() call before calling
>> __nft_release_table in the nothing to abort case.
>>
>> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
>> Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
>> ---
>>   net/netfilter/nf_tables_api.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index d73edbd4eec4..849523ece109 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -10333,9 +10333,15 @@ static void __net_exit nf_tables_exit_net(struct
>> net *net)
>>   	struct nftables_pernet *nft_net = nft_pernet(net);
>>    	mutex_lock(&nft_net->commit_mutex);
>> +	/* Need to call synchronize_rcu() to let any active rcu lockless
>> +	 * readers to finish. __nf_tables_abort does this internaly so
>> +	 * only call it here if there is nothing to abort.
>> +	 */
>>   	if (!list_empty(&nft_net->commit_list) ||
>>   	    !list_empty(&nft_net->module_list))
>>   		__nf_tables_abort(net, NFNL_ABORT_NONE);
>> +	else
>> +		synchronize_rcu();
> 
> Wouldn't it be better to just drop those list_empty() checks?
> AFAICS __nf_tables_abort will DTRT in that case.

Ok, i will drop the checks.

> You can still add a comment like the one you added above to make
> it clear that we also need to wait for those readers to finish.

Ok.

> Lastly, that list_del() in __nft_release_basechain should probably
> be list_del_rcu()?

I am still in process of untwisting that place but so far.
Simple change to list_del_rcu wouldn't help as it wouldn't in 
__nft_release_table:

list_del(&rule->list);
ctx->chain->use--;
nf_tables_rule_release(ctx, rule) {
	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
	nf_tables_rule_destroy(ctx, rule) {
		kfree(rule); <-- freed here
	}
}

List traversal would work but instead of crash it would become use after 
free.
Adding synchronize_rcu() before list iterattion there will probably do, 
it is already under commit_mutex when called from nf_tables_netdev_event.


-- 
Regards,
Alexander Atanasov

