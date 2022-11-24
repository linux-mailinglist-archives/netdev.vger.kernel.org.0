Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F0C6373CA
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKXIVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXIVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:21:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C78F003
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:21:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hjq5aqTSX8NF24lMAeybI0deRo0XeMFBoniAhwvubKGa68S5ZtZeuuTJ2Udd9/76mGgmelT7DNhuz+2e3w5mL4B5vCxsPoakzcMmEe6a7o1q5YPntPYz1RpujzSkU62a2z4/RORCCn3C/0zvNif0YeWP7qmqnoTbLefQyIYMBwBX+faHiW4Ss6lmvBurVQwIFl/Mw4wmRZgrMnKf2GbAW2/eQT/ucIzOxsWNXGP6ca6i7NzTW5cqLzfnbGtgYJlqh3SDAl4o4LkKjXNp5zLez7aAoDKGTKcv8ZyI6Fai7I5TTU2p/THnxVcUkw3wJtCSn9rfgS5OcQ5CWG50M/YFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaNz0tHfZodHCz/Ofit6ZOHXge2Ss+5LweiU7WePTcM=;
 b=eoIKZqpv/5porq5q/vVb/S25RkSDg8MKJhKGErmJHlJyQii/hJY68GWPeJK2E3O3WCq2JvN0TCS6xfy7G8WuiLJEB+yJxpglWN5C/zvvhB76UlBIJ8qBwE8xq1L6jD+KeLZn88BVP7GwZpOYkyTGEIx3IamBpYWU13Gl6MjVmlkPJrO6bZ3yu83o07DPqM1bo6judS0x6M+CtlBGhcinQ9pufRrRypUIn6nZPtmkK9xfI+To2Cq09ViGkxYJBvGXGCkrww4XO6bqeOaEYNtSMOM20zB2lLpVudkLrOZXjz/wt29VKI/yiIrd5HfBJIu4mg7ILvPoqnCUWf8X2Hon4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaNz0tHfZodHCz/Ofit6ZOHXge2Ss+5LweiU7WePTcM=;
 b=bE7bVt03ESE2wpH5G3Dgt4jcX4bqKuMHvMTg0FlfWW4nV5I4EmFMmoS3kgZJi/0CV66YI5WadqHmuVUIaUsurJ2UuZABD9wgzGRyFg59OJAyquFpohC34NQ+2BJozD93hOx3+fOQTCfg0lolJAd6IV+miFjWt82qvl+4oUh1rSNXoAj5r9izyAUQJTtSaCH0Wz+JQOiyf6qCf4hlTuW8190c6Wi8qgRbOGLjNNvwPAR9Z+zupSB4XkcCFVUforMUlB7wqlQ9zWW/bEkfNse6ThJQxTrvOq32FPwAVwueWR1QHpj8HMy7nkXEa7u2A3NeM03bX77V/276f7xSeUVBDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DS7PR12MB5862.namprd12.prod.outlook.com (2603:10b6:8:79::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.19; Thu, 24 Nov 2022 08:21:15 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::3ac6:16d8:a679:e262]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::3ac6:16d8:a679:e262%4]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 08:21:15 +0000
Message-ID: <9955e54b-5f97-c35b-12cd-e0764ab2267b@nvidia.com>
Date:   Thu, 24 Nov 2022 10:21:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:108.0) Gecko/20100101
 Thunderbird/108.0
Subject: Re: [PATCH iproute2 1/2] tc: ct: Fix ct commit nat forcing addr
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@kernel.org>
References: <20221116073312.177786-1-roid@nvidia.com>
 <20221116073312.177786-2-roid@nvidia.com>
 <20221116102102.72599e40@hermes.local>
 <5fa2b47a-67bb-6a45-525f-0af9fc15e1ab@nvidia.com>
 <5200b531-c3e4-cd27-ef30-8d4080b235b3@nvidia.com>
In-Reply-To: <5200b531-c3e4-cd27-ef30-8d4080b235b3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::23) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|DS7PR12MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: d22be478-e346-413d-3166-08dacdf4dab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uvyJ3fKU3G0hX6JBhOcF06hGOCk7RXnzvFJC1oHSMvPG75Kv1Yp/pUrS6XNj+Gdzq+iTNzgjInqcSz+W3iLj0ZiGiH0f2J9zgXDzxhbqfomeQeXGKUKZmAYD7hAOXLD1BZekol77RKxqJpRrmFtHPluST5pdjLngtRKyugA8rfGNB2fANuTw0FDIeP+rc2wcWuYhg3Y9wmD4MY1giRcRv5C1HkFZM5GAI4QVCMaYmI30Qd1vJqgvfg5xfIzjqu5LXPXkvNzxR0XkliGuZiHrF2AWv35PHjnkjtIOlVe/ZAG2tyvpX/u8+0XjztxDhDCy9veOQazqZpWQNi2KnLpPY3MNveWaTGjtIPH9sVt4MwvfoAH3pzVMmVbB6g9ChSmHjadBRwxmtLZ0HE55ooynB7DOPvB5IiNlbvb0jTCnVQaa53n6MHqWme3PmIABEhYA4dPWUHEvWIZbNL9Uvp21GrYe3pu7jjxek5uOquV43aagbvBFVwSVvCPZUcSw4dgClGGoKc+misc2pYedY78qc6vqnNWxM4Fao6lGRIAV33K44eOtd1A62KkfgWys0dN1FDUhYT8FgXoL8JV2mm6j2zdxMm/A6YWcPqq7OjujZGYKhTjLoRDUa3fpMg/g4Aakdg4OVNWV4PfP4qwhRplzvKy0GLM5nkp1RmiVcTJks6zzG4ZbY55kUp933iRUgzqXt98xykWaAwv61Xdg2uckUSnTyMu/UlpjUFccZYvF6Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199015)(2616005)(186003)(53546011)(5660300002)(36756003)(8936002)(6506007)(6512007)(6666004)(41300700001)(26005)(31696002)(86362001)(6916009)(316002)(54906003)(66476007)(8676002)(66556008)(66946007)(4326008)(6486002)(478600001)(38100700002)(2906002)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STJZOXBrT1FCR1BNTDlCd0dacjVqbW8rMlA3SkovTHIzS3VUVjVicGc0OTZ3?=
 =?utf-8?B?YVZjZXhuUHRhOHFBekpISUxLMlNqZC93aHVVdWxNNXFHUkxDVGtENGF3ak9v?=
 =?utf-8?B?U1ZyQXczc1ZGamxpUHBBNFJodmJ1bW1VeHJ3eGdKMU5INXRNMjMzeGk3ZWtC?=
 =?utf-8?B?RnZwekdpVEljR2JCeWhOUWRzMDgrdXFxL3dpbDZoMTl5a1pJUkN6dUFLVWhS?=
 =?utf-8?B?Vm5vcWNRc0MzNk1WZU9vM1pqaVQ3dTkzODNJTi9yUEJsS29mQUt3MFlEc1M1?=
 =?utf-8?B?WVJhejkwR2ttaE9VeitneWtwWmhJdEMyenc0L3M0T3IwZklBRWd1dVExSUg0?=
 =?utf-8?B?ek9tcXFGUXFlUWd4RDlkbkc0V1FlZ0FNbVNUQmRHUGdvTFJFQ25ORnRMZ3c1?=
 =?utf-8?B?TGFOYndRL0hHM1VDTFJLNjJHdGtkM2IyMm12T1hXaFZENG1GM3hudUFmMWhx?=
 =?utf-8?B?N2R5NTY0S0FEK3ByWENrNkoyVGZnZ3dnajFObXpwaHdjRGxyOUxQczZZaXY3?=
 =?utf-8?B?TTlRQ3d5cXZJL0s3WWYvazZtL09LM01nTHJ0cnI1Mk02ajJ0T1Y0L1lzUXJL?=
 =?utf-8?B?V3BEWW9ZNElGaG0xcjZQMVA5N3dKOTM2TkdNbWszM3hEQW83TDZNK2hHOVRx?=
 =?utf-8?B?MXVPUWNBZjE1VlBuc2hWQldRVitFMWJoOGFOTGdTcXRFVjl2TE9iSW5hUHZZ?=
 =?utf-8?B?T21XRDBOa0hZaGdhVU5odjhSWHdXWUJmcXNIeVlhbmM3ZStQbFhlNjBpVERh?=
 =?utf-8?B?cnMrMFZ1aytBVDFzWEdiYVZ0ditWNmYxckxtT3BVQ1hrTkQ3VTltaTJxWVRs?=
 =?utf-8?B?bHRRUWdJWWl3V2dwR0p1bFZrbENUM1FYOWtKYm1YNWNWWi9yMGdjWW5lQ08z?=
 =?utf-8?B?Ly80WHpManpxTXY0WGRvN1JwYlEwTjJOcjlKRWxpTmkwaTYyUTdoSzM0Y2di?=
 =?utf-8?B?bGI1S0h5RzdtWmp0UjBEbDRFSnhJaTZWT2s2UGRsY3EzcC9Wd25ZbTdwbHps?=
 =?utf-8?B?NGVxdzRpaTJrZExYMm9TYnpSbDNNY0tVMEV5WkhPdzFFZkJHeFhSMTFYOUFv?=
 =?utf-8?B?UkdjMG8rcU12M0RKU2JWVkw5cUVzTHhld0kzbzFIUE1YWDdOUHl4WEdtdXdW?=
 =?utf-8?B?VVd6eHQ3K1dpQjc5R1dTRWpNanVXZjY0dFU3ZHJDY21WdzBGWW9YQi9YYlFL?=
 =?utf-8?B?VzhrL21pekEyRWVJcEJST0UzUWprV283dXRFR3BrOGtoS2NFZ3M0UG1vMGI2?=
 =?utf-8?B?TnRlWml0N05yaFptTUZHYzB4K2g4bFFiTDYrcGlRNWVvNjk5TStzcmY2Vitu?=
 =?utf-8?B?am5vSGdkVEVkcHRxTTZmSWNobHNzZHVjS0R1aXgwSnVJTFhDYWp6aWszREpv?=
 =?utf-8?B?MjJNaHFEODBPT2x6ZEZZOU1wdG9UeGpyRHpNNE93QWYzQk1MVmVOK0FkbjA1?=
 =?utf-8?B?b3NQc01iQTlVU2FpTFN0azFLU3dEem1LODIyS2orQkd2M2hXQVJtanl6UWdv?=
 =?utf-8?B?QmhWOUk3SzJTOTlEcEpBQlZHQ2g0Wnhsb1BwbXBscTVtZjNaVFNmblhMZ1VP?=
 =?utf-8?B?UlJ1aitsR0tFb1VRZWVHT0thdHBsMUxaLzJXODlwRFBLSHNTUUpjWTkvcXdZ?=
 =?utf-8?B?MDlQVUdFdXdCSGhMZ3pDZVh1L2hpaUpKTmVmdmJsQU1MeGttR2JRWEJxbFl2?=
 =?utf-8?B?VHlRRFhNWXl3RWVKaGJZYkxsRXRqamE4Nlg1M3lZQnpTOTRReXpuWmxCaVRo?=
 =?utf-8?B?OTdZd1c1RzBYcWRvaTVVeThrQUN4QXhNNU43QXhHQllFQktwQzhhczl1dTFp?=
 =?utf-8?B?dEptMDlBSThWVWF4NmU1anMvdFBaTC94NjRtSlpMb2owLzJsWm52dUhrTWZG?=
 =?utf-8?B?Z00rZi9ZeFRFWWNYNnVSVVpuTDd3a1Q0UVU2djluZzRiS1Rkd096YTVuY0cx?=
 =?utf-8?B?MVBxMitXTVUwSGFkcU1VbnN3OEx6czlTb0xwa2dtc2grRzBmLzk2a3NMY2lG?=
 =?utf-8?B?TktHbmFlc1hrUUxCa2dNYUpKaDd2bC9UK3NoTEVSdlFPdWtuclJwd0RjR0RW?=
 =?utf-8?B?WFlrTTNKeFUvNGJ3WXZzVlJvNjhzY3dpVkdSZVUyUzBmdWR5QnVPWGhEckc5?=
 =?utf-8?Q?E5Adh7EfrFDll3s9L9smH6xzD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d22be478-e346-413d-3166-08dacdf4dab7
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 08:21:15.3374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IqZObM8gsb/0Si75wtj49CYnzP79yq38MiqhTIA0uCSt1KUKMscPaxEhiWC4g1LG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5862
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/11/2022 16:00, Roi Dayan wrote:
> 
> 
> On 17/11/2022 7:35, Roi Dayan wrote:
>>
>>
>> On 16/11/2022 20:21, Stephen Hemminger wrote:
>>> On Wed, 16 Nov 2022 09:33:11 +0200
>>> Roi Dayan <roid@nvidia.com> wrote:
>>>
>>>> Action ct commit should accept nat src/dst without an addr. Fix it.
>>>>
>>>> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
>>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>>>> ---
>>>>  man/man8/tc-ct.8 | 2 +-
>>>>  tc/m_ct.c        | 4 ++--
>>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
>>>> index 2fb81ca29aa4..78d05e430c36 100644
>>>> --- a/man/man8/tc-ct.8
>>>> +++ b/man/man8/tc-ct.8
>>>> @@ -47,7 +47,7 @@ Specify a masked 32bit mark to set for the connection (only valid with commit).
>>>>  Specify a masked 128bit label to set for the connection (only valid with commit).
>>>>  .TP
>>>>  .BI nat " NAT_SPEC"
>>>> -.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
>>>> +.BI Where " NAT_SPEC " ":= {src|dst} [addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]]"
>>>>  
>>>>  Specify src/dst and range of nat to configure for the connection (only valid with commit).
>>>>  .RS
>>>> diff --git a/tc/m_ct.c b/tc/m_ct.c
>>>> index a02bf0cc1655..1b8984075a67 100644
>>>> --- a/tc/m_ct.c
>>>> +++ b/tc/m_ct.c
>>>> @@ -23,7 +23,7 @@ usage(void)
>>>>  		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
>>>>  		"	ct [nat] [zone ZONE]\n"
>>>>  		"Where: ZONE is the conntrack zone table number\n"
>>>> -		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
>>>> +		"	NAT_SPEC is {src|dst} [addr addr1[-addr2] [port port1[-port2]]]\n"
>>>>  		"\n");
>>>>  	exit(-1);
>>>>  }
>>>> @@ -234,7 +234,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
>>>>  
>>>>  			NEXT_ARG();
>>>>  			if (matches(*argv, "addr") != 0)
>>>> -				usage();
>>>> +				continue;
>>>>  
>>>
>>> This confuses me. Doing continue here will cause the current argument to be reprocessed so
>>> it would expect it to be zone | nat | clear | commit | force | index | mark | label
>>> which is not right.
>>>
>>>
>>
>> its the opposite. "nat" came first. if matches() didn't find "addr"
>> it continues the loop of args. if matches did find "addr" it continues
>> to next line which is ct_parse_nat_addr_range() to parse the address.
>>
>>
> 
> Got your comment wrong so yes the current arg will be reprocessed
> and this is what we want.
> This will make "addr" optional and there should be some action
> after ct commit nat. next loop iteration should break and
> continue parse next action usually a goto action.
> 


Hi Stephen,

Can you look at this again please?
this is the same as done in other args like "port" right after
and probably in other actions.
If "addr" is not the next arg we continue the loop and parse again
as expected for the other ct args or getting to else and breaking
to continue.

Thanks,
Roi
