Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515956A4A50
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjB0Suw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjB0Suu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:50:50 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2111.outbound.protection.outlook.com [40.107.247.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A18F24135
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:50:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APiXvIEjHFKc9zLoz7cFAvZ8WnDthSAT/OEx6o2J2y1AYVF6BVTp3UH+Gr/cndL1FQeh2IrNqlkMcI82tkZxyAyPrbL1w9sM3XTbjv6f9Geb/Jtc457OT89XQ84ROkaHRg94vU6PzWnFNwNXeksOoURNnbQUACnx/wInrjQiPdASHg/H1+4oOMV8MeohlNTURcLQGNby7FwIEGP8D9uXZoxQsgIEILSr60YldSN1iuiaKo85aHvwVnzJqhoOhjFII6YtAS7FPNOlj9YgKkkhkQRMBEfi8eql85oDlua6cY/Oz99E2BvYah/XCqbsx4pTr6Z9n3mHnfkBZtF4Tk30mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCrpr6jWTXns+QQvMe2W0XDaEg3hhW+xvVig26njSdc=;
 b=G6+DqctAdwmPFntTQmY8N/9wXHEmzrYe4/WozNKgETabioz2XgeLdIWGKSPPh/qpnl+9ru9koNlHArNS2KRDHEIOyTBim5vQiNbANxzHi8MqtALr0aPOSagEKaSo04Qq2+iluQPTazLyGW2uIUN5oqD63FGbJoX/3oMHeB5GjP2mA+WW2FFK5MlfT1eMsm0lxHbeUQ9rWyNNamj7EJ1EDoD852SSkUzWGwZVeR7in7IRlw7knpnz/NXusen/lKFvkhnFex2ELrn7ZEtHwXLqWJrvYHW49mgw/ZMRaqI0y/frLPgd7mV9HC9lsv0gKUfnzguQMUizcP5gCGvgpMsLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCrpr6jWTXns+QQvMe2W0XDaEg3hhW+xvVig26njSdc=;
 b=Dh1WUX5DzvPrA5J+tNtK21+lh3OxZAq2YzmlGz1yKQEfVHaz6Ct/b5AzO/qYfiIhGFiNd2QFzUSueIw1u3ZmdJWNqToezWmO+EcD18PSBWtVgElKFdPmuwAgw3MLe65k3mO+pBbZuyx2Vw3TT+KXD+I0DgBPxRtwu45bR55kbZ/bcPce6Tn9I+mqYx3RUv8yHgrC3eC5eACPmmMaQl2Ns6ywGsQOxefO1gP8MZA0sQmNPj+ZWudg1goW21rqCb8sUJsRctxVr4AvV+GbN1+uZMmkF6dXdzEaOBiIVtDVBGSgL4Odue0FEyvfCyVkBwGw83wf10M1BfTAZ50h6FWb4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com (2603:10a6:802:a5::16)
 by GV2PR08MB8169.eurprd08.prod.outlook.com (2603:10a6:150:78::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 18:50:46 +0000
Received: from VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343]) by VE1PR08MB4765.eurprd08.prod.outlook.com
 ([fe80::de4d:b213:8e1:9343%7]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:50:45 +0000
Message-ID: <28a88519-d0e2-7629-9ed9-3f9c12ca024b@virtuozzo.com>
Date:   Mon, 27 Feb 2023 20:50:43 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] netfilter: nf_tables: always synchronize with readers
 before releasing tables
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230227121720.3775652-1-alexander.atanasov@virtuozzo.com>
 <901abd29-9813-e4fe-c1db-f5273b1c55e3@virtuozzo.com>
 <20230227124402.GA30043@breakpoint.cc>
 <266de015-7712-8672-9ca0-67199817d587@virtuozzo.com>
 <20230227161140.GA31439@breakpoint.cc>
From:   Alexander Atanasov <alexander.atanasov@virtuozzo.com>
In-Reply-To: <20230227161140.GA31439@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR07CA0160.eurprd07.prod.outlook.com
 (2603:10a6:802:16::47) To VE1PR08MB4765.eurprd08.prod.outlook.com
 (2603:10a6:802:a5::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR08MB4765:EE_|GV2PR08MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: 2085aa8b-0dca-40d5-6bbe-08db18f388a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K0H6rGKmToeFEkUhEzw1NEuo9cNPj3i7X6MzB7AWkkIJLDtWr4/U07OXwXrnZvrfgmyuNoqy/Ai6XQKfPcrV38eG9thrKbjE10S5c80ylZsDCYt67yEtqHqYQt+8u/V/h1mLbt8TQJb47yNigMquosD/1lUiXQ/kdQHyHU9foeDMaZ16aW/r/2KVwZR5thkVLYoFmYp8NnfgPJ88N2ZV3LTg4ROVxAvf0KFHnRZlFbN4oDEkw0+l3EO4rBTJiTLOj86B6QAhwzLLHTvgstkFq2dpr8lOnZithdK6AkYtP4xlqZKQiryr5MhBpNSjwPs/HfQqRq69mE464BvEyuGTadH4tHvxb8M67/9S2LJ6+sogPNd7CpCVDmn4jw/42RcPGM7ukmXHQ3bl/lQAo/09IJFHKQwueutsBWWu4tIjtbYtbFRjfc/rbSKRdFPuBujnQrz4DoocXImVZhoyz8UFxcpj1M7y9Tau/tWCm82k01CyOEOLAL7EEhGmzKDR/xps77xedvy4yZWS4mKIZ3Fd4Ndola2y0OiuMKQLZ9FJOAtH3olRp1tQpW2TuaqWMougS4zEtUweMyyX2GYF/ULTvilthoK9tryd4gw95LqOFn7o25gcK7bh3yB1Nk6klGbvTo1CAizI70/6TJ7XHHy6jvCZBpYFjsQG5DSNZnrZy5Ji4x3g5f5DkcNZt7WkWZpz+8eO575UAMzPd7AyR+aBaAkSGSfsrqzvWh7vWcqikmg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4765.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39850400004)(366004)(396003)(136003)(451199018)(31686004)(54906003)(316002)(36756003)(86362001)(38100700002)(31696002)(6506007)(6512007)(53546011)(83380400001)(186003)(26005)(2616005)(8936002)(2906002)(6486002)(478600001)(5660300002)(6916009)(4326008)(41300700001)(44832011)(66946007)(66556008)(66476007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWdibjZuL3BuSE1mUnVNeS9Bdm5mWnFHMXc3R0lHZDh6SWtLY2dJazlpVFh1?=
 =?utf-8?B?TVhIMUJEbGJ0bzNwZkVMNlFQdUlSaTZMYXNFenA1UC95aTlJbzY2citpZWNM?=
 =?utf-8?B?RjNOUlY1bXdBQnpKb090Qzg1TExIcDdsL1hjMnZvQUZvNVEvNjQ0NHNZejVD?=
 =?utf-8?B?Y2dEbVRiU0xGNW1CMitnLzNSN2RIV05BV1g0SHV1Mk9odHZmK0EvUU5QSkZQ?=
 =?utf-8?B?Vk54TG9qcWJObHZBZ3V2U1ZLME1ieW9iN2hpTjJFL0FibU14MHVreG9kRk5N?=
 =?utf-8?B?bTA0TGsyODltRlZEL1Iza2NnQWRXNUlpRjE1ZGh5UklWVzlLZDFxTUlwTno0?=
 =?utf-8?B?VkY4VmtUeWlHZXA2eDNEVGxnQkJQUG5ndDkyaXh2UktvbVNvQkpTdkEwOThl?=
 =?utf-8?B?NlV3Tm9mMlBjOExDcUZXYkdrZTZ5QUFqNElTT2czYVArelJleEZ0Y1RUd0tr?=
 =?utf-8?B?S2svQXNScis0c1VFbkEwUDNZTlFKZ2lZMzJETVVXZVl0M2VvaVlQcjdINDhz?=
 =?utf-8?B?WXNWaHBRZnkwdTMxZHR4N0xqWUF1aU9IbUs5d2FXSEMrTGpsNDQ3Z2Fib3hI?=
 =?utf-8?B?eVl5ZkpjcnNHM1RiTW9LUUNqUE9WREdhNHpnSUNsV3laZ1h2S2N4WStNOWg5?=
 =?utf-8?B?WlptOWRmYkdRakc4anNpaWc0VU8yR0o2YnRSeDRhK3UySlNZbWQ4M2dhdC8z?=
 =?utf-8?B?TTZvaUtWazRzKzJtQitMZi8yV0JHS1czakd1NmFGdVB1a294d0ZGZ2xWL21F?=
 =?utf-8?B?OEJOUml3a1FxWDFlcHBlRjdsZlJIVXlJYklVUVRqamcxeUlYNmZ0UHV4eWpi?=
 =?utf-8?B?WGx1NkhsMFNtc0xLWnByaThkVzNFd0c3RTZXYU5EcGFZUWxvU3VlSzFYd2or?=
 =?utf-8?B?UTVCM2xOaWg0WmtOak9ITUdWKzMxRlBuRVgyaklDaDRvd3JLZDhibWJDc240?=
 =?utf-8?B?ZXJzZkg5U2kwaW1YL2gvc2xYN3BtdFZ0RmU2TFQ2TFZNNmFwekdVYkVxdFdT?=
 =?utf-8?B?Q3l3cGkvTmpPTFpVV3NzR0VDM25UL3V5bDdEVEZlWmhTTEtzL1hsM2lvRCtm?=
 =?utf-8?B?VENCU0ppYXB6Tk15MWd0cnhwOFFyd3Y1Nms0UzR1VlliUmxaZHpGSFk0SUpE?=
 =?utf-8?B?WXNwS3N1a01hWFFvVkk4aVNhRWsvNGRLdHFtMXBYZnpEYVpNbVIxUHMyVWNj?=
 =?utf-8?B?YmpweHdnMUtaZGgwaW1ISTh3cFVtQ1FlQWFUZXROS0hIZGVHa3JnU1RiT0po?=
 =?utf-8?B?V1ZZNDRTb1RNRlRqYnk4dlhkR3hzbkVQLzBHVG03MDR1cWZURThnUlAzQXdz?=
 =?utf-8?B?ZmNTR1BHMjJCRUZiTlN0dmdRS2RsUzZvTmJYcVlzT0lUakJrcjVTNnFTY0Rw?=
 =?utf-8?B?VmdDRXAwbWphRDdMQzFLQm1pVXV3clNFQmFhTk5QUmJCcWNuWW41UEFPa3cr?=
 =?utf-8?B?TUxJN1RIejdRRHFtRXE3NDVaT2U2M29xc2dlTmZtNG5kU3B4L29XYXBDemZK?=
 =?utf-8?B?VDY5alZ6UTBaQTRwZGRtaE5GaTJ5RzYyOWpPOTJDbm9lQlVIZWVLU3dORnNN?=
 =?utf-8?B?SzlsUmVIREh1SjR4dXd0cms4QldSS1ZvYXVqY2V0WlllYkprN3BCRzlTeWpG?=
 =?utf-8?B?MWt6ZXRPZTVYUmFGR3hrVkU2SHBBMC9UOW1zdXJ6TDduR0dXaElQUUViangw?=
 =?utf-8?B?Qk1LRStoZWwwTmIybkZHb3JESllTZWc3eElpQ2dMMDMzdGtZVTdJTTJUSHA2?=
 =?utf-8?B?N085QTNiZmpqZmkveGNsc0ZoT2xYN09nS2Z6cmVDRnhxR3dDUnBQSU9JOU0w?=
 =?utf-8?B?OStka1F0WmVKRENrZkVVVGRDSytZNXBmdjBLOGs0Skpuc0Q4bVhjRGhpVVNB?=
 =?utf-8?B?TEFpZGZTM0pObGF1M2x4czBNeE0zRFB0T0p6L25BSEw2ZjJsTUZnQ0R1c2NB?=
 =?utf-8?B?WURoc2cvS1RiQ0UvRlpqNHFyamtUdHpIb1BNV0lBNmxiNFlkbWRRUXNESHBy?=
 =?utf-8?B?eTMxbmZTUTJtU0J2bG1tV0hkMjI0T3V4WTVlaEYvNHBmYjI2eGJpZ0RwWVN4?=
 =?utf-8?B?T0JIUWZpV0ZwYWxRLzBNZDNsMjI5b3RLQVpCbnNJbTl3SCttTlVFc3hGRjlE?=
 =?utf-8?B?bytzNnFKYTIzQ0hZZDllRGtwRmVkb1VoS2M3VXlVa2RxbC9BQ1VWU0xUTEVK?=
 =?utf-8?Q?k9BHNo2ZreQyiBf3y97zfkw=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2085aa8b-0dca-40d5-6bbe-08db18f388a2
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4765.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:50:45.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1UfiqotivUaEc4+1SVBRc123BJvUpj6krA/8hb7W7iFxmg8YUq03pEp0NrCsfHKN8kD9/azLZN4EvyqIakyjZPq6Gc8WqzwAZGwvZ0Tb9EHQOaIoZgNX8q+lzyruhId
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8169
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.02.23 18:11, Florian Westphal wrote:
> Alexander Atanasov <alexander.atanasov@virtuozzo.com> wrote:
>>> Lastly, that list_del() in __nft_release_basechain should probably
>>> be list_del_rcu()?
>>
>> I am still in process of untwisting that place but so far.
>> Simple change to list_del_rcu wouldn't help as it wouldn't in
>> __nft_release_table:
>>
>> list_del(&rule->list);
>> ctx->chain->use--;
>> nf_tables_rule_release(ctx, rule) {
>> 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
>> 	nf_tables_rule_destroy(ctx, rule) {
>> 		kfree(rule); <-- freed here
>> 	}
>> }
>>
>> List traversal would work but instead of crash it would become use after
>> free.
>> Adding synchronize_rcu() before list iterattion there will probably do, it
>> is already under commit_mutex when called from nf_tables_netdev_event.
> 
> Hmm, please wait.  I have to look at this in more detail.
> I don't see a race conditon in the first place.
>
> netns dismantling already does synchronize_rcu(), so I don't see how we > can have this uaf in the first place.

As i said i am still trying to figure out the basechain place,
where is that synchronize_rcu() call done?

> Do you see this with current kernels or did the splat happen with
> an older version?

It's with a bit older kernel but there is no significant difference
wrt nf_tables_api code.
I will prepare a more detailed report for you. Unfortunately there is
no reproducer.

-- 
Regards,
Alexander Atanasov

