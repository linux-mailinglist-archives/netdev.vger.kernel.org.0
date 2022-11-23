Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76063653F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiKWQEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiKWQEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:04:31 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2139.outbound.protection.outlook.com [40.107.22.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD31F615
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:04:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chUkWxqcnTWo9PTTplJnu0CKDgBKQ8Egdae1PsQfPzsGkTG3P6G9dj1o8klZy8HorjwDFK5K+vDAqK7JwFxRUuqxSs3EszkVGu/XDZfzHWOCIbYznfEqgp58TX/0TQ/mkzUTwaia+7ub7Mc09M2UnKQZVsNbofRg5XW75Um46xPcEluqK2ORI1QEBQ0n7YkK3A7AWR+m+0BYUBZgu+RXO/kS/GC5TKoSd7rGa+eytPUWjvoIqQeQq11cJk5ptNSqwg/6vbzEdZVPbyvhOWIgorcC2xFWCCZ3cxdxHXR9rOujxp2cdwL+bNxwuLeZq0lPsh0PWOLknRDiQUoK1EX8WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWv1Qv8UYyygC5sKcrXoqWmpTYCgQXKbfPOypO3yaeg=;
 b=hKDJjU1ZKUFCIEmpFt1pG7v0CMWliuw+Ux7Xu1KuQkee6Ty1jm/XHbKoLkg4iNKheVGSm6nvZFBahufJwkud2OyXg4qplN9o7z5yqPfag8A72gcZnerSGHA5sF/qKWLYYwP2xXLm1JqWXd0qKEth7/apLtyOAHcwVPWwFXf+U9iqxu1adurXFNz5EUkdziuHZqe+T/GK1UXZ2Uht/CFFAvoIPfr0FXa8xFeEMA6vm3n8SgqMm5iPaP0VIlMwA+y9IMQnNEe24CZfB91n3ZJrUI+7WyLLzaqAkDCoCt05VBAxeOnxyo0kFJRTdLDr9TXEnocTGAmm92CEnr1IA3u2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWv1Qv8UYyygC5sKcrXoqWmpTYCgQXKbfPOypO3yaeg=;
 b=S2KzZDK1jgaw1wHFnjZ2IynqreYMunSFMMwosD7sHWYC0vY2w0Q5d0/NZRHONq67SB22L8ROzyEb3Xs2b7CUFYjrIWhH1sKF9bCFOy0ANA5mZz4SUde8UM8cv3vcwl7twkSmPp4xV2nOrFBflb74Xb8ErfODZfoSef89RPG5QOdRFdUazl2AytgLpA/7RM94R8jm1Z8V/ENSQp56e4ZyEgU/QZ6IbNqHL+z4gj0+QDbXP84Of7kAvy/XFQFB+u9S5KbWi0PR+l5C9CbcUR+XA6cqRLC5RZ6ft4VWGAD5dy1Zlx7NtP/9TAHh1MPsWFzmjnHJkiq/mvaFGxMmoq+k9w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com (2603:10a6:102:35e::5)
 by AS2PR08MB9367.eurprd08.prod.outlook.com (2603:10a6:20b:595::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 16:04:27 +0000
Received: from PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6]) by PAWPR08MB9966.eurprd08.prod.outlook.com
 ([fe80::6a1a:5231:bfac:d7d6%6]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 16:04:27 +0000
Message-ID: <a5a38555-b784-0eee-edcd-38509994ae81@virtuozzo.com>
Date:   Wed, 23 Nov 2022 18:04:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, kernel@openvz.org
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com>
 <20221123142817.2094993-2-nikolay.borisov@virtuozzo.com>
 <20221123153314.483642-1-alexandr.lobakin@intel.com>
From:   nb <nikolay.borisov@virtuozzo.com>
In-Reply-To: <20221123153314.483642-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0045.eurprd09.prod.outlook.com
 (2603:10a6:802:28::13) To PAWPR08MB9966.eurprd08.prod.outlook.com
 (2603:10a6:102:35e::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAWPR08MB9966:EE_|AS2PR08MB9367:EE_
X-MS-Office365-Filtering-Correlation-Id: 96400a57-cc25-495c-26a2-08dacd6c65bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GqqyTd01QsFnJS6Agn8JGCgzNOWVEF11zi6lc6jf1NRs7sEdQHTDMmWNbfecMfjsylggfJ6cjV9P3cmc0uTJV2KczHSZ9C8yABGrbDC0AbxvnsZrdLnrqTlT5Jc92K4bNvDCMw2Dtnb6XtrtSsHEAVjl9XCRgHkr2tx2/5OoxlzdDU+t7vicclDIrAxNQiGCLjXRUe8CvabnYZd+pUpQ3O2E4gVLI9RTxU22MecWdyPtA3CYJlgxzLKVzCk20YWxFu7OgP6iqrytWYlntVIC7/XXiOgY9sJfjQu6dSVRD41mYsMQkYS2JEKMxorH41qQOXMhV7y10gvKyX5WQ/QqctBbi3J1KyzIVH49Kbh/dvqcPKz4654+LE1KBq/9eNFOQsEP9O5/IfwOt4ev0zBZ2cqYnn0eE8/Z6cN/mH3hlfCofb8QMPiblhoSrvPihpsRkQfWq1HyGfA2LDKgv1/5Cmwc47MQhI1/bIVT48R61ZY7J6fG6CQThy4piBx9J+Vwy4bCFZGs4XbF+0skTeFBuqbHH6MFje+zvXgMGl38DFFxBYKJBWWFJFiOn/bghabeExjdvuD8gzjVSuJZJgSCADoybJ4BiL2wiTfUmKlR9nZpr+JIcYdohOyWO8ZLMNfqS5ocRSdqlh1SJLQS/n9xurSEV2C6TpQK0Bd8tu2BJvl9g+WwqtQzVsn8oG5gn37r1lNTLDCx6af6HJg80kd18JvOXay1v3nbDYu6JA0uPNuPvu0tvzxtXoYgV34YWnH5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB9966.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39850400004)(346002)(136003)(366004)(451199015)(31686004)(478600001)(36756003)(38100700002)(5660300002)(31696002)(8936002)(86362001)(4326008)(6486002)(186003)(6512007)(2616005)(107886003)(6916009)(83380400001)(316002)(41300700001)(2906002)(8676002)(66476007)(66556008)(66946007)(6506007)(43062005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGpIQlNtTVFPZ3NWOTFWb3pZNWtCVnpCbEkrYU1DZkh6eDBQSEJTa3ZvK0xJ?=
 =?utf-8?B?NU5kcWlVc2M0bFpPREtZNzRObE9XOTJ3NGR5TDVQa0dibmd6VkVHdFhLVm1x?=
 =?utf-8?B?dWxqVjIzOWsvSzg2bFJqbE1idDlKQ1I3dEZVZGt5UDlrY0VsR1NwbXB2MHhQ?=
 =?utf-8?B?VDJhSHEwRzFQb3FNcHRVeWpLdkdtQVh5ekZhbERLZlV4TURYaUU1SU9yRTlG?=
 =?utf-8?B?aW1GSGNlZFcxWmZVSGJmeGg4ZjREMUIzQUlFSGpDTzQ1WnBkY2hlOHZiSDNp?=
 =?utf-8?B?WXFGVDJJcmtWOFRVVjZjYTJsMDRhdEpienpGMktEZHJQbk56amFpQmMreXNL?=
 =?utf-8?B?cDF4TFZlWXpndnNMN05zRkZUUmcvdUlzdWJSa1ZtVUJoMzZWL2hTVGlUS0Fs?=
 =?utf-8?B?cjltbjZjdjV5Vks2N25VOUNweEg4dlc1NStkWXBWU2I0dk82SFQ4bCs5eXN4?=
 =?utf-8?B?dFpWMkdMbGd1RFFTZVVRSzE0RzlMcjQvcy9MNldRL2gyemtqV2dTUUR6NjBy?=
 =?utf-8?B?WGVEZUN0b1NFMW5rMkdaYTIwaG0zV211WkYyVUdZNUpxQ3ZFcGZMTjIyQXlF?=
 =?utf-8?B?ckVaMXlob1FKMkR4SGZYNnZPdk1hNmtBWWRCeThralJmd3JhWjA2WkRhbjha?=
 =?utf-8?B?QUFiRTI0SXF5VDZIa3pzck5DQ3BSYzJOSWV4Um1MOXQwcGFnS0U0aFZ3TW1L?=
 =?utf-8?B?TGVmSjgxZEZCVUZtcUs2M1l6bzFBNS90bW96SUxDNUYzUlQ1YjZ5VE55VW1C?=
 =?utf-8?B?S01nUHhnTWlYU1drY08yb0JaLzlrUnkxenI0ZTZrNE96MGdxL0IxK1pxSFg1?=
 =?utf-8?B?UUorcDlVOElhdWhWQlBtTDN6Um03ODR1UFFQZkhkMU5EZ0kwazdObjRJY1hD?=
 =?utf-8?B?K2UxSWpmRFZsVm9YWlFUMzB0S3BwYTBhN2dpMzBPejNTZVdKUVZlOW5TMDN3?=
 =?utf-8?B?WTZvNkNlRkJWMGNlbGtEN1BMRVNSYXhWVE9XMWErYkRFd0swQ25Za2dNT2ha?=
 =?utf-8?B?Sk5NL1VacHpMNDdzSHh3V0ovN3d1L250dVpzeXlKMXd2d0pxYkwxTDZ4eFpo?=
 =?utf-8?B?V3ZZNmhnck9iV1FjN3lzY21lOEs4aXRrYm9NUU85VDVKaStHTUtEMlpKb1Zl?=
 =?utf-8?B?Z0JVTmtiaFhxWWZmM2lVMzU1UisvRHp3SnhLU01nbUplWlZpZTBFQS9jZTM2?=
 =?utf-8?B?U0dLUThkM3ZIYUVrdEVDck5SQWxlRmVaeExlbzYzUGliby84RW4rMGRxMVlR?=
 =?utf-8?B?Zy9odnM2eDRQMnB2OTVNbTVEZS94eFowcUR6OWlMSWhKMkxuTnIwUzhjSnJ2?=
 =?utf-8?B?U0YxdGV0a09HYW5oMUZRcUx0NGMzZE5tSVdjeDExYTZMN3p1L05iUE9hVEZa?=
 =?utf-8?B?N0VmOXBmYjVQV2MyN05JelU1YXc4aVNxUXFBVXR3c1ZmenZiZHcvYVh6Rldn?=
 =?utf-8?B?S0VVSnZMSkN0WkhGdFNOcFl3Rkx6cFZhcnNjcmF2NUtDajhUREs5N215NTRC?=
 =?utf-8?B?SnlWa2E4QXlLVHQrWlpscm5vOXA4N3JxUmp2MVdTaWNmZGZJTXgySHZwVHpi?=
 =?utf-8?B?NGc0ZzFwYUxFQnpsNlZSK0JRS3VBU2NnOGl5TWl0UXllRFNvYmM2aGRMMmti?=
 =?utf-8?B?N0ppTlVKSHZLWFZlWTVsZ1hrTGUwYUFqSFJPR0p3dXNUbDNGVTJ2T0tJa2kx?=
 =?utf-8?B?K1dQbUNoVXpNSGlzRzFRNnk4cXo2SVZ0V3RKczdVdE40RnFKNHlOSC9CNmx5?=
 =?utf-8?B?M2Rud2VaWTJIMkF4TWlmVXlUZU9oNmdYL21JTjkvVWZrTmdES29GSkRqb2R4?=
 =?utf-8?B?UjlzRUR0VnA3TURjc1BZYldiRjZtSlp1aC9VcStnaHVQeEdnMnNCdkdhTTRj?=
 =?utf-8?B?dWo5cHVMRnhVMWgyT052M3FYQ2NiZ0ZYU0NKQ1VXejA3NVQxRHh6Q04za28z?=
 =?utf-8?B?RU9Od1lzaEVCMldERjV5YlhIWk5LeHhBanRhcWVnaE95V2ZjcjBCb2RnOXZl?=
 =?utf-8?B?STJNYnZTamdINWg2T1ZsMnZmK2grcjZ6QnBmcnVUZVEwcmhqTjg1Z1Rsc1NH?=
 =?utf-8?B?QlNRZVBXME1iZFNYTW1ibGZVNEtISG5sU21mMzBteGJ5S2xwa2tRTXUvdXlp?=
 =?utf-8?B?RGY5VTQ4Tld4Z3kzY1NVZUk4NUk4MjZEdzEyL09HVkZ0aDdwTjM2RVRkTTNa?=
 =?utf-8?B?a1l3Q0w0OGQ1cFNheUo0ZWVZTkw5bmwxaWU4UVEyZldvWEl4aEc2Y2p6YnBn?=
 =?utf-8?Q?8/3l/yuFTpY2bQUVqHK7Aq7QSSvPhjoPsDKwxukIJo=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96400a57-cc25-495c-26a2-08dacd6c65bc
X-MS-Exchange-CrossTenant-AuthSource: PAWPR08MB9966.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 16:04:27.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/Vacdf58CuCn/MFdGTCzEc1dfYb1Uz8A/S7Ap2Ywx/uqMuik/DzPxhUkmt8qtKOEQEenOfzWXMKO7333qfdpem2OkJE2v13itxnajNDF9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9367
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.22 г. 17:33 ч., Alexander Lobakin wrote:
> From: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
> Date: Wed, 23 Nov 2022 16:28:15 +0200
> 

<snip>

>> @@ -1283,6 +1304,14 @@ static void net_dm_trunc_len_set(struct genl_info *info)
>>   	net_dm_trunc_len = nla_get_u32(info->attrs[NET_DM_ATTR_TRUNC_LEN]);
>>   }
>>   
>> +static void net_dm_ns_set(struct genl_info *info)
>> +{
>> +	if (!info->attrs[NET_DM_ATTR_NS])
>> +		return;
>> +
>> +	net_dm_ns = nla_get_u32(info->attrs[NET_DM_ATTR_NS]);
> 
> So, if I got it correctly, it can limit the scope to only one netns.
> Isn't that not flexible enough? What about a white- or black- list
> of NSes to filter or filter-out?

Can do, however my current use case is to really pin-point a single 
offending container, but yeah, you are right that a list would be more 
flexible. I would consider doing this provided there are no blockers in 
the code overall. Do you have any idea whether a black/white list would 
be better? This also begs the question whether we'll support some fixed 
amount of ns i.e an array or a list and allow an "infinite" amount of ns 
filtering ...

> 
>> +}
>> +
>>   static void net_dm_queue_len_set(struct genl_info *info)
>>   {
>>   	if (!info->attrs[NET_DM_ATTR_QUEUE_LEN])
>> @@ -1310,6 +1339,8 @@ static int net_dm_cmd_config(struct sk_buff *skb,
>>   
>>   	net_dm_queue_len_set(info);
>>   
>> +	net_dm_ns_set(info);
>> +
>>   	return 0;
>>   }
>>   
>> @@ -1589,6 +1620,7 @@ static const struct nla_policy net_dm_nl_policy[NET_DM_ATTR_MAX + 1] = {
>>   	[NET_DM_ATTR_ALERT_MODE] = { .type = NLA_U8 },
>>   	[NET_DM_ATTR_TRUNC_LEN] = { .type = NLA_U32 },
>>   	[NET_DM_ATTR_QUEUE_LEN] = { .type = NLA_U32 },
>> +	[NET_DM_ATTR_NS]	= { .type = NLA_U32 },
>>   	[NET_DM_ATTR_SW_DROPS]	= {. type = NLA_FLAG },
>>   	[NET_DM_ATTR_HW_DROPS]	= {. type = NLA_FLAG },
>>   };
>> -- 
>> 2.34.1
> 
> Thanks,
> Olek
