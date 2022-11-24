Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E26377D1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiKXLlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKXLlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:41:45 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80102.outbound.protection.outlook.com [40.107.8.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75A6B9F0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 03:41:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTRdlmIQXoAzoY3d9Vl+Wllb6kpP9653v7bzp1GN8GBVbi2/7L1wHGdJXIYjKtTan3okY98kN2rRMxWPJxB9cCG21WQLOJsuq8C0WwRUqc4PBZQgbfp8XujvR/LWBliSVzcdaK0Xw3I8BNXdJyg6xL1DtpGoEJ824Ao4p8mKUWnVPrD54VdIXmey0I0TlpeFwr3IAHfJwRJoBJNbHz1IJAOfygU5SpyUXZvIHtLemqVcwiUsPPqZGCAhbgMXZJXyg8hxdH4wUuzhxhYEenSePnU+DAquoDcrQ3muzJLYowJT3+LVJ243YC/1wvCWX8wVmW7L53RfxrxNLp0AR1YSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mHydIzd5ez+KOuMrXkDz85qvm5VHL9oBWbfsADmqCM=;
 b=Az0m2rL188dgywW7aCN0z2pX6dLZOh85jGf5tm6aaequvmaywedrkrpfY/f6v7B5G+kLDRtJRxy/PBbdxXRgzO1Jh/CQZ/hnKckLHPTTUVPMOiY2qIppx4A3r3EVc9wbQwFs5S8Hll4IPAzXvZ4X2HsNbhOmIEKqBDqTISAZzi9LJ2h4eyfYledQibXv/fhhgzbrh9QDxqdu/WdfhPWdC4wiBPprhxuCm3BUAnmUvjBgkXkuJ35+1y7iSc5PwCJ1lRrowdExdfA8drnBVxlpun3vvDDNcm01cWdt1MqN7LF9ZMHk2NIVF9FAaRUmeaJ+dtjPBXRRtBxgHIUj3bXvpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mHydIzd5ez+KOuMrXkDz85qvm5VHL9oBWbfsADmqCM=;
 b=CT+4SbEbEVwDCGyKpSAyu+ybFeWL90x0Jg0AjS/GuPRBzQ15HiY6SUEQh163a1IjU03fCOQynorOekHjedqVWvg6tq4eZ6s6iAxjfs7oM9neFpwMQxIDrG+tAryxe9unv4CcRWBiFwU2iDPhk0HJyYoNXnBYKKore74CmsrgPpVtQF+BwyALKCkaPAiUq8PAJucdTIjBu3PuJNuJc41nLjb0JibtDa+XvOHJjZoIted1X4MY+pYkQzPZnhGSf6z4cHRKU7MwwbSgX99pZlsNKx/8LP1G/1c8tby0bP8jiXw601RqlvnD4Kx7kI76FZz6hb2cOo16mMoYxRs1ZBjdmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com (2603:10a6:102:35e::5)
 by DB9PR08MB6459.eurprd08.prod.outlook.com (2603:10a6:10:256::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 11:41:40 +0000
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6]) by PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6%6]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 11:41:40 +0000
Message-ID: <8c6aee78-2247-bcd5-ea48-b76652745301@virtuozzo.com>
Date:   Thu, 24 Nov 2022 13:41:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@openvz.org
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
 <Y345WyXayWF/2eDJ@shredder>
 <7a8bf56c-3db8-63c2-8440-7bbbfb4901ac@virtuozzo.com>
 <Y35iBgeq5iKyTmfT@shredder>
From:   nb <nikolay.borisov@virtuozzo.com>
In-Reply-To: <Y35iBgeq5iKyTmfT@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0801CA0070.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::14) To PAWPR08MB9966.eurprd08.prod.outlook.com
 (2603:10a6:102:35e::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9966:EE_|DB9PR08MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e646f92-ca19-446d-fe59-08dace10da6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uky8XJj1ESBDPNFSKq8YnNvLCbtEOLIQgtZCAUILfd2WHVjgfs4DeEOILHIiimd1zn65djxGlEmtvyOEtQwk20WAbSRv5506yJKGQHs6EI9K7f8Ke2GzITITRMCQuJbM5bAvLy13CqjpXekX4udpm/D5OFPMiU3wD+tQi9zldo57vq9c/8mclHCLPztE/GD0gRvZqJbeLpZ/y2dvIHkujFvg0CkTmeZyNTrbmH3jnHPFcO/tt/W52Lr+Gcoqs2+StNAsZY3MHG/C5YeQVObwI1zzhR4NV7k4XgvYLJrmg0YyHL/OsWjDojyaKpc5ZbB+8zHKYJUHnYbu9Gg0JBo+d8BF7KCmTWeHyPKSkGiZ254LWw8SfcVsKJbSeJqhzCM/gPjtM8hExXWuc+IyZo21uf9fIMtMDKyX+714Kkc5diHx/mD4/HFA8Yf1H5kg/esB2cZhXcKDnD+RIZFYJTiMrI9wfbstzsjILA7WgCwmC8JABIovOOJwyxKYLU96A048z3VsijIX4uuLpqn82I1KwX2NlYmAA/UGEqLvKTxbPDCe/+YFk3QcjYmeifBUxW0gpkXF+sf+qFzDeySQ9YILI56wQuXjUtlYcXBJGYpAA62kVqPEUbXVOND2FiyUXJMBRUhjXJx2Jq/nuXL6OO7gWPquShPxoTP4wW9VRWFipHPlH9clKBY9JogJvNcUZxJ+K38GasuPhgpzTKB1+dMxTvi/mXs9KkpoL6yu8R/XKhaw6d69/5O6IqVz0l2bKoT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9966.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39850400004)(366004)(376002)(396003)(451199015)(31686004)(38100700002)(36756003)(41300700001)(83380400001)(86362001)(107886003)(31696002)(66556008)(66476007)(8676002)(4326008)(66946007)(5660300002)(8936002)(316002)(2616005)(2906002)(6916009)(6486002)(6506007)(6512007)(478600001)(186003)(43062005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlJ6NWplb0tXQ1BMcTIzc2hHa29hcmJrZkJBaHlaTVI4azNTek15SXNKNEhG?=
 =?utf-8?B?MnI5UVFSSDlHYncvL3Jscktqd3ZiQnlwRFBvUHVYV3VJdC96cmdtbjMrSHpM?=
 =?utf-8?B?Qk9CSHNIVFY5SERTTmQwbWxrNjlTTkNrRDV1enBaenliT0tENGhRdGdTc2Jk?=
 =?utf-8?B?N25oTzdnbWlla3E2VmkycDBHaGZQcStRY1JSamxUWUloc3lVRGlPTXdSSGM4?=
 =?utf-8?B?eHhIYUJQbVQxUGNocVF1V3JCQnB4QmM4UWVZelgzeUlMVkNiRFkyU21ZRTRR?=
 =?utf-8?B?a2xwTWlsbXFhbnBvQ3JIT3RrSVFmMCtMOHZXSGVzaWJ5ZzZsZW9kMmtiRUFT?=
 =?utf-8?B?SWV2SnptK282Vy9KcmhBbDd3bDdsYU5xN3hxenZaa3dHZ3ZNNEN5UE40RjdQ?=
 =?utf-8?B?eGxwS0VzVkZvcm51dmxjRHdVeHp0NDFyeVZvdm1oRk8rMXpSQ05hdUgwTVE2?=
 =?utf-8?B?QmhhUlFmeEZSMlFkemZWK2t0b3NVWXd5Y0o1U2tIeUxxa0ZIeURqT0NFV3k1?=
 =?utf-8?B?a2NUdnBnbVYwWVRoQldraGlmczYreVJFU1R3N0pGMmdUaG43bmYrYzBueXk0?=
 =?utf-8?B?QVA1NlhablVNcTFRaHREZytDMm9VNElkR3YwcENhZS9CYm85N1Q4amZodGFn?=
 =?utf-8?B?ME13U0RreHNrRU9rNVhoR2RjVEpEZlBmY0JqRzdJT0paeTVuT3JWaFRHWkpu?=
 =?utf-8?B?MkJuOG1sa2lUYjZDcU5tZEZIS05yZko2NGhDQUJaWXNZeWR6eDAzMkdzNG5t?=
 =?utf-8?B?YXJlYW5ucGw3a3BLajdlUVpzV09oSVYvSjdkaTY3dzdlSXJmQjVWbC9HS2RZ?=
 =?utf-8?B?QU5JZ01xR21abTZsdWtvcUhNWjdac2hYa2p1V0NnRWNhdC9hTHVacm12dkpS?=
 =?utf-8?B?TE5md2xZRVZJTVFZWjRBOU5tY21hSE5MbHBqZUZmTkJCTmJKVkU3T1Y3TWY2?=
 =?utf-8?B?V2xqbEk4Misxamo1Ukl1Q2UzQVVJTHhOYWFQanRWNll6cGs0SmE5TFlpQXlQ?=
 =?utf-8?B?dW80dE5hMmh6SFNqZFBpQ3A1VC84eFB1Y0lMaTVoNktXWVlwZHFPMXZEZEJs?=
 =?utf-8?B?aVc1RDJJaWJxeSt1OXBBQWp1bERrMThwMzJBTkFtUC9zZ0NqRmExNk9pakpH?=
 =?utf-8?B?OUNqeDgwdzZNblE0VHQxR01QUWFZMnEyei9GSXVmWjNEbUhVdXd1WlBIZkMw?=
 =?utf-8?B?eWwxMktvRWpnTGxKUjhZRXA3THBiUWlNTWNNV3BuSnJJWHdsT1NQTENLdng1?=
 =?utf-8?B?cDE3UENrVUxGYWR3MzdJLzJGd2lDYzJOZDJhNThDWXBnNDZxZ0U4Nk5uaG5Y?=
 =?utf-8?B?MzR2YS9yMlFkMDNsM2lERmdPU2V0Um5JUEhxUEg4aXdRRGI0b3RBVEhUT3Zx?=
 =?utf-8?B?OFh6Q3N5V2c5RGw3YUloUjd5UjFvYkhJRUhnME1hcmwvL3I5eTZtS3pRRmtu?=
 =?utf-8?B?dFNqMDIvb1VVV1NmMmlaclBaYU5NZStpYkF5blh2ZHNjMWwyalZEOHdXcmtE?=
 =?utf-8?B?T1JqRmh2bzIwSjVXaWF2S2doRmIyVWw3ellUTGpCekwwK1F6bzMyWTFnWkJU?=
 =?utf-8?B?QUhxd0NCY3R3TW55czVmZmRhZ2F4WHpXNWJJYWVQYlU2Z0hENytObTlEM21R?=
 =?utf-8?B?OEN4Smd4V2Jpb2ZpVnR4Ti9pb2p0YmtiMnR6NFEwWmxlcWs5ckRRSGNPWUVj?=
 =?utf-8?B?UDZjOWk1OVJOZVMxWjFuNS9PRFIxaXVIU3MvdzlSZ1crYWFYSHZHMEFMYllW?=
 =?utf-8?B?TGZ1UGJmOHV2ZFhWNnUvOXBCWDdYQXBSQXROUXk0dGRqWnRQQTA1VlJxTEdk?=
 =?utf-8?B?TkI1OTFmTXZYd3R2Tml2SDE2aDg4RlZlMmZabzl1dnVMeUZpb2pKRkl3MmlK?=
 =?utf-8?B?L1pTNlpVVFQ4YTdtcHV1ZGpNNVNlNkF5eFhNNkVvNDdzRm5iQndLTE1ZY3pT?=
 =?utf-8?B?SGhoYTlMK0U5cjdsd2t3bDdBOW9FUTBLY3djdTBsZXlmb24wdmd1U2tnZS9s?=
 =?utf-8?B?d1Z5bTg5NkdFZFpjbk80VWRaMUJ2WDJhMG93cWo4T2pVV3dscGluekZpS3Zp?=
 =?utf-8?B?UXRCc3hzQ1BwWWhjVkhpS0RkaTIrbUZBVkZtc2N6Zm05QnBHRjFyNXQwN3Zj?=
 =?utf-8?B?NDVnN0VScS9RMkpzU21rRnZ2K05FT1VKZWxqVkh5dlk5REFDWUFnYTVtbFBP?=
 =?utf-8?B?cWFvZVJva0xuemswUVg3UUlYRnJIT0NQbXU2N2Y5RDJMck92dWVBN2RZcDhI?=
 =?utf-8?B?ZlNCQ2JYTGxRS3JUNGx6VTV6RTZ3PT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e646f92-ca19-446d-fe59-08dace10da6a
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9966.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 11:41:40.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLkwqQCyfkp4b47ia0X2lVhM4QrH8Vz3+TCecwLh9kRzkQ4IC/btbeNK/bW5IXmwqeb90cQomB1ZGnBIMZRG/ihtA2VED8a0tpmSC3QbmQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.22 г. 20:10 ч., Ido Schimmel wrote:
> On Wed, Nov 23, 2022 at 05:21:23PM +0200, nb wrote:
>>
>>
>> On 23.11.22 г. 17:16 ч., Ido Schimmel wrote:
>>> On Wed, Nov 23, 2022 at 04:28:15PM +0200, Nikolay Borisov wrote:
>>>>    static void trace_drop_common(struct sk_buff *skb, void *location)
>>>>    {
>>>>    	struct net_dm_alert_msg *msg;
>>>> @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>>>>    	int i;
>>>>    	struct sk_buff *dskb;
>>>>    	struct per_cpu_dm_data *data;
>>>> -	unsigned long flags;
>>>> +	unsigned long flags, ns_id = 0;
>>>> +
>>>> +	if (skb->dev && net_dm_ns &&
>>>> +	    dev_net(skb->dev)->ns.inum != net_dm_ns)
>>>
>>> I don't think this is going to work, unfortunately. 'skb->dev' is in a
>>> union with 'dev_scratch' so 'skb->dev' does not necessarily point to a
>>> valid netdev at all times. It can explode when dev_net() tries to
>>> dereference it.
>>>
>>> __skb_flow_dissect() is doing something similar, but I believe there the
>>> code paths were audited to make sure it is safe.
>>>
>>> Did you consider achieving this functionality with a BPF program
>>> attached to skb::kfree_skb tracepoint? I believe BPF programs are run
>>> with page faults disabled, so it should be safe to attempt this there.
>>
>> How would that be different than the trace_drop_common which is called as
>> part of the trace_kfree_skb, as it's really passed as trace point probe via:
> 
> Consider this call path:
> 
> __udp_queue_rcv_skb()
>      __udp_enqueue_schedule_skb()
>          udp_set_dev_scratch() // skb->dev is not NULL, but not a pointer to a netdev either
> 	// error is returned
>      kfree_skb_reason() // probe is called
> 
> dev_net(skb->dev) in the probe will try to dereference skb->dev and
> crash.

This can easily be rectified by using is_kernel() .

> 
> On the other hand, a BPF program that is registered as another probe on
> the tracepoint will access the memory via bpf_probe_read_kernel(), which
> will try to safely read the memory and return an error if it can't. You
> can do that today without any kernel changes.

I did a PoC for this and indeed it works, however I'd still like to 
pursue this code provided there is upstream interest.
