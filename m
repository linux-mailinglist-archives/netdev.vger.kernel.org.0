Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1497636346
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbiKWPWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiKWPVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:21:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2103.outbound.protection.outlook.com [40.107.20.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A0B682A4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:21:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRwRJWoO8Et7oc7yHNDCxkftQRiuBNlC0zSMfgtVG272a+zMPLKJtZT08mNd3SsRfsc24j8bye+8On9PW+Lggnht4Ri0TSzhOqXDsffvzMapHjMzVrWzj2o6vRhPvRH7PbkbwZ23rp5ZARqx1xaG4ay3I9PZWGezXeTcEwv4R9XVNSnigQmqmcyqnUQQRVPfh8c4Lxi4o4aAGViY2N+8kLniLAhXLgnFcomcJVboq6fnFbqPloDELzKoBCNBZefJXNm/pOJ8IM+KzyRgkpPj8nlsVhAVq0Y1nGPnQzsynjvexp7GwOf19mu64OQ3PBW2+pBga8a4UCcY24BLlv+WDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjfTv9RYieQuxHm4Rxv8ijraK4NgjpBTKInz5Yx/tMw=;
 b=JL/vrzSgQuDYHf5d4V54xR2fIYxKb6MLPWDleyibwVVUHa3reonV8lnJ0bZtk+7kxa/63lJ0bFK4dhbC3vJn94T+QtBklD/yrj9C/8lHPN90l6ff87MMgwDhIbp03wR5JfIgKGHLMn9cJDzxw/bTmxH2p2rg6h36Ob6HR83foaEeviDFEQ/dqNXpXcAdDTwvAijfxL48Y/kDySjHFLBwP8dsOl0exWxOzO0l9A4nZGbqg1KUlzv4BD3aAEKKqrtByHDgftwaxw+zqdm79fW9InfS1O7O67dO8ObOyajt5Ed7hBfC/ihwYnNyJKwcxzbYbStrsqkPCqFOdjGlMlx7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjfTv9RYieQuxHm4Rxv8ijraK4NgjpBTKInz5Yx/tMw=;
 b=qZ02WN3mfgEwRykyz4v8G5mKZgolaBFaHj9+RAXjNlSQDh6Y9ixsGityATOt4nWIE3SZ61mGbkTmMVWAOVoJ1z4k3wSSu76NSeUgr7YtEUkPkOZE0Gokn/1FsY+7Zwgm32aIp5AzRgfr8dqfxuLJiAM3fqFoqI0YwmXx8ckGmKPt/O94r+62cgdi6X6ItKSuAGhJphG+VYY7jCyTS13a4Hw5KHgKgPc1IdsD+aJzQSQ2xNdpJ+hRPknIGv8bwmcIaYJKrjiLxwiZGD26/s1kOVkhngU0RN4E2sBlSVPDl9vjVc1klmfWSF95RkpYaW5c4eOAfqA5QPC2lembTCHSog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com (2603:10a6:102:35e::5)
 by AM9PR08MB5986.eurprd08.prod.outlook.com (2603:10a6:20b:281::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 15:21:27 +0000
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6]) by PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6%6]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 15:21:27 +0000
Message-ID: <7a8bf56c-3db8-63c2-8440-7bbbfb4901ac@virtuozzo.com>
Date:   Wed, 23 Nov 2022 17:21:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@virtuozzo.com
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
 <Y345WyXayWF/2eDJ@shredder>
From:   nb <nikolay.borisov@virtuozzo.com>
In-Reply-To: <Y345WyXayWF/2eDJ@shredder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR06CA0224.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::45) To PAWPR08MB9966.eurprd08.prod.outlook.com
 (2603:10a6:102:35e::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9966:EE_|AM9PR08MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: a5915b6c-5716-48ca-cb5e-08dacd6662c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo0z+DPkE5mR+7vOIGiW//L62pBCTf4OOWrzeNZ0zGFAsLzNvx5zAiy5eLLKVXqaj++8Yslub+D1Rvj8gyWaDRklyKofoSrcmnnfJAvPoOaiFaZL09wq9hqQccrJ0s/c+wNm2vu2nJNVa5DBwdpOoV2SAHSpbCe1iNBYep9ZUaueyLc6SHvhZyGoPPRqrtL1O6okLjYk645RmLR3SkrJRy2w3Bs6wCbkUrMgDeI0zEbrIkBV2r1Ypt/qdA/ZssOc3YOYMhhqFm/7pVBOub3g0wg57CUe2y4tT3RYvcMt33A8DdrqcbVQlkKq/8rMuWtdA6/pZH/yrgN6YdAUTcWaHJscpvCC3FUGoIP1lXevmp+KdveMJzGc0PY7/n3LinBMtVR8gdJZ9RLt+p4iZPiO9vbn4yw1vnrCqbLfPWoUCO/fsgT6kAzcJk+iuolWBMFalet3RiRUljhdaZ3Jx2BPYWpuC2JJlm5MAIKMN6ioIt/yUZSoSPbQBgI4LfOk4eGFLczE1t6rR+06sHkzNt1kdTj0RgBLeID1TAfPPBdi5V+wkzDM+9D9M+thsFP9HEQwyMkjPOpUy8AXgd5TRbTxhGtOEPQcQmT4VRJIJZXTNJPROhYcDpdEaqtr3kgnlhY/fZa1j4pkItN1KaaGwi05biNFi28LU2nc3+pIYAvEX1vFS2g4UzhCOZ4UB6a9UqJxhMXGL36sie+IpnYRI+GLR/Q6V1NalgDBFRk5BWwtp5JZh8SthxbrZcP1C5TbUmaq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9966.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(39850400004)(136003)(376002)(451199015)(6486002)(6506007)(478600001)(107886003)(316002)(66556008)(6666004)(6512007)(31696002)(86362001)(4326008)(8936002)(41300700001)(66476007)(66946007)(6916009)(8676002)(5660300002)(2906002)(83380400001)(2616005)(31686004)(38100700002)(186003)(36756003)(43062005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1ZycTdJTFg1QURPWkNORjYxb1ZUc1dDdlhnb3hMMDZCaVNRRm5FM2hZeEl0?=
 =?utf-8?B?ZFdyTnFYV0hGd1IwUVNYY0ZPU1Yyd2U4a083Vk84TDlWaVh5ZkJ5Zkd0UGVX?=
 =?utf-8?B?NDJtMUt5S3lUTHpSUlozRXZVS2tVUUIyS2plOTlRa21zbXVWMjVGZVljOXc0?=
 =?utf-8?B?TkxvQmR5TjRSN1RGb2lqbDNyZmZLemczVkx6WDZRWEovYlZUTURHY3BCNUky?=
 =?utf-8?B?RkpGVFFEZ3RiVGswblcrTW0yWjhHZ2hENjdpZTFqQlErbHFwUTYxSGcrYkp3?=
 =?utf-8?B?eTdQaGRNanB4MVVrUXVSTEswSFR5Qm1yRnFtSXE1MjBSSUs4UUYvcHNUWmVI?=
 =?utf-8?B?Z3ZiWUNBR21vaSs3TkRoSEgwb25VVGFpdm9rRisrU1dLUkNxejlzS1hOTFpB?=
 =?utf-8?B?QTd0clVkeDEzYkRHbkxoSE1UdUNiWWxqVDlYOXFGdUdzekFIMDlnOExOdnJ3?=
 =?utf-8?B?ekFVZU9rY0x4R3Jnc0dva2ExMWlrSFBrKy9hZDR2bWRSeHppNTQ4Y3VvRHVE?=
 =?utf-8?B?aVdGNlJPUzd0akR0cWsrSkpYRVFnR2JtejZRbWNGcEVhVDlGZmZTTkVRTC90?=
 =?utf-8?B?YXRoY1pKUWpYTk5UMFBKdGZlTHhuUTRMM3BtcDlKM2ZvS2dxN3Q3c3paQyt0?=
 =?utf-8?B?QmRRcUdQdzBoM0JFaDVMVVBDQTJnWEZlT3JPNzhmbHlmb0FkVmxZWEpHNEFV?=
 =?utf-8?B?YUhyUHNnaERFcGdSTVNYVWJjM1R2RTBpUkJ0czc0ZFFrTS9CVTZjSWVtSmg1?=
 =?utf-8?B?eHVpdTB2eWo0SW13RS9rKzZ1alhNUE41c01lbFArNjFUMzlTbktIOGhDU2pQ?=
 =?utf-8?B?V0ljTTViSTBxK0dycC9rRHFoMENIM2U1WHFhYTJlOGoxNFF4ZTVXSzZsVUR3?=
 =?utf-8?B?d0pyVVlIVzZ2TEZuWElTUHV4OGJVdWZ1b2pRN3I4ZndxMmlzejBIdUp1SnNP?=
 =?utf-8?B?NjZBTGhkNE5CVkdySzRaNzcwQWZhMVRiRkdmcy9VdjhHMTlYcGdyWFhRNHc1?=
 =?utf-8?B?Q1U0SEFkZ1JoelpkaVpscXViVEpmUGY0MUcxVm5tTzMwNWN3MGtFbUNVeFYr?=
 =?utf-8?B?NUtLOFJoWFpPN2hIY1YvZDd6dWZHbjI1b1c0c3JVeG00TFRwaUk1dEZOQzJJ?=
 =?utf-8?B?cEcvZnBwcWVhWVIvRGRXVHhZMG9xSi8vWmJjSXlsL2V6WTBkMUtZamRlTFQ3?=
 =?utf-8?B?dlRwN0tQeGdtbnJoSlVlRGYzSTFhQXd0dExnMFlLUWhMRFd2WlBqbVkxMUFn?=
 =?utf-8?B?RHVEQWpRVmVHMEtKWmtzb0FGSWNzYzRIcjkxWUs1MzFqVy80bVhIYkVneGIv?=
 =?utf-8?B?SVQwdTBGSXFyZ0R3K2NQdlhPZlF4SER5OVZuMmJ0WlQwbkRHTVBSZVVheUZO?=
 =?utf-8?B?WGVjT29IaEw2dGJYcW90QjJCbVlpNWlsSzF0VkxWM0xNV3JaU2N6cmdRV3FY?=
 =?utf-8?B?TGk1S1E3L255R3oyTGY2ZXJnQVJuSDRIMS9LU1hSaU4wT3JjWlI1azkvY2RH?=
 =?utf-8?B?YXJXNHJ1LzgxM0prWWkwdUU4SC92NmJWSHY0WWxhVUNzYThpN0JqRmprSkpm?=
 =?utf-8?B?Z3QwbXdqOFZsVUdGcUNUNlMyZzY2TVNXYzkyT05PN284OWdhQTNXckNEeVFk?=
 =?utf-8?B?RUQ3Yk1XbzZRenhTdEJsellWSWduQlpXR2cya3N5UExSdlNxK0RPdUJQSTlV?=
 =?utf-8?B?Q2VqWm1oS3hmeDRJcjYrWnkwV0NENHkxcld2a2EvVXdXbGFTNFUycXd0VDkw?=
 =?utf-8?B?WUVlK0Q5QzE4dWtTZDNoTjZMKzJ6ZHl4aVY4VU9SYjZPZThTbGJ2RktFSWdq?=
 =?utf-8?B?ZGVFTmlBK0I3V0E5V0FVY2ZXeXp5SGNhOHBhQzVLWi92OFpJd2FZU3lndVBC?=
 =?utf-8?B?YVRYdHdDTjBqTUdSbWN4YWI2czhiUXVaS3g0eUg5WXhKOU43YmFxSUZwcVJM?=
 =?utf-8?B?ajNaYUhxM052QWtFVUxnb1FWTmNVQlpSbWljc0x3Wnh6dk9KRUpqSzJGcnlI?=
 =?utf-8?B?V1UyTEV0b1Rhek02RTlCaEJSVG5hVlNJOUdWaEdHQVdtYzcxc3VMUVdPQXJM?=
 =?utf-8?B?TG5DRysvY3RWYldEYTh1NWRaMWxjNlVWWjdGL1lwUHJmVjdVNVE3a0JINzVN?=
 =?utf-8?B?RjcxdzcwdDVjbHozMVlITGI2cGFVSDUzcytSMExGZXNvUTlqYm5CZkhmbzEv?=
 =?utf-8?B?d0FrZFdhaWU4SDM0Y1FZNUVJL0VUWDBmb0JjNTFiRCtlR0pLSXdneGJYNGlw?=
 =?utf-8?Q?kEB5XZiaoNo4gl6ydQ1QtFFREkj8SGKI+2TeJ97oDQ=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5915b6c-5716-48ca-cb5e-08dacd6662c5
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9966.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 15:21:27.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3z1iR+CqwajmKbp/EXg72rB3PPKjuSjRNqQ0vuIzHLVcV+M91zbGMnxhh2VUm7rvGQyx6m38RlvMhCjdftWDHCGmOBAAjtxzb1x1ZymCE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB5986
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.22 г. 17:16 ч., Ido Schimmel wrote:
> On Wed, Nov 23, 2022 at 04:28:15PM +0200, Nikolay Borisov wrote:
>>   static void trace_drop_common(struct sk_buff *skb, void *location)
>>   {
>>   	struct net_dm_alert_msg *msg;
>> @@ -219,7 +233,11 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
>>   	int i;
>>   	struct sk_buff *dskb;
>>   	struct per_cpu_dm_data *data;
>> -	unsigned long flags;
>> +	unsigned long flags, ns_id = 0;
>> +
>> +	if (skb->dev && net_dm_ns &&
>> +	    dev_net(skb->dev)->ns.inum != net_dm_ns)
> 
> I don't think this is going to work, unfortunately. 'skb->dev' is in a
> union with 'dev_scratch' so 'skb->dev' does not necessarily point to a
> valid netdev at all times. It can explode when dev_net() tries to
> dereference it.
> 
> __skb_flow_dissect() is doing something similar, but I believe there the
> code paths were audited to make sure it is safe.
> 
> Did you consider achieving this functionality with a BPF program
> attached to skb::kfree_skb tracepoint? I believe BPF programs are run
> with page faults disabled, so it should be safe to attempt this there.

How would that be different than the trace_drop_common which is called 
as part of the trace_kfree_skb, as it's really passed as trace point 
probe via:

net_dm_trace_on_set->register_trace_kfree_skb(trace_drop_common)



