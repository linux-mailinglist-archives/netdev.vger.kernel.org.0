Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB24362D2CD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 06:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiKQFgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 00:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKQFgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 00:36:06 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88445BD6A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 21:36:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LudhipIX0rex30nZKsRM0UaP4Z9jfZ3m4qNtgi47nnjiJgNkmkaf7h0vdanOha5f/+7M5CE7sn+TlfTgAmNuRCQ8IocXwOGBrY355dH89joaD+ID64906v+QdxBDiEnGYVqeO5GTlXbdr2z9Uz1AGCgFxUq5+O9J0YiztA4p6lD5l+ZkUank4/QPb1C7Oo2Q+9ur/CmxzAau3TPKRuzT87EXxTmoZJZVab2c+JfIjIOA/CDF2CGXM/36Nr/EsAqZmgGGkdcQMmpV21h3+D2cdIzJyFOjTYRXJlnHPI6I72r/R8aSRnYnqwvrwSQmMLfQ7bKC1z/pLk6htbnkMAZMSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDyQLSDMmMHIBBhEOZ5cXOpFxyc6eFB4MW0G9uh1Ev4=;
 b=aa2wCk90Kf5zIOMbXEryiroG3dnZxNjlHuk6nF5BFTDrL9uxCdGjZo+qxm1VMzxLtD/lbwG0gBglkbpO6SL5rXbFzqF9ILzx1lI4zZ+/yPP9YV0os0kbcvJ01tWsKMDiHNzDpHJziIz4lQF+cNGZlSraEvt4/1KaMLx3/dZVZP1TWlhs4IkXVfWZl+78peKczsLjvP/eO+NDDF0WRqiy309DzfOAGy9fq+XZQ4Rr+3wffwl1Afr8IdCT6+ReNz+GOGGhFSYaWOSJ2bmamJwJhfO7FrUYaEoOhGqTkr4JqM1DLSLFFnkctKZSMwfBAH+BtisnC2K/bCpC62wJ0UaccA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDyQLSDMmMHIBBhEOZ5cXOpFxyc6eFB4MW0G9uh1Ev4=;
 b=Y18NoBVzku4hFBHbAqdVKw+GeJ/XLkHcoylRd99ef9n0QBExpMeJ1Ze/6kfkjQ+VS23Se03AgWxkyXJjj9GPHp8e3cGofQQyuObHnaXzjBvbT/2Q84M2KQYYsFjcgC6rbxLiNIbVEQLftfyfawUzo6scFQjhdt5WqYoACfumWgg79oZYDCA+ZTo2eqwR40L/4gpWEoVk1F//dPDXfs04M9VgjQ9RyVY2vbO64vYL8rFGNGOrzikbYtbsIwDiQxxUrcNSKW31ns/KmgcTvjUz89q/TjT0eygurWZM2QNBn7ngOXba4NzJRRq4JUvMrV1I9vmjUmgZ2o2xeM3tgQPP+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DS7PR12MB5837.namprd12.prod.outlook.com (2603:10b6:8:78::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.17; Thu, 17 Nov 2022 05:35:35 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa%5]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 05:35:35 +0000
Message-ID: <5fa2b47a-67bb-6a45-525f-0af9fc15e1ab@nvidia.com>
Date:   Thu, 17 Nov 2022 07:35:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH iproute2 1/2] tc: ct: Fix ct commit nat forcing addr
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@kernel.org>
References: <20221116073312.177786-1-roid@nvidia.com>
 <20221116073312.177786-2-roid@nvidia.com>
 <20221116102102.72599e40@hermes.local>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20221116102102.72599e40@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0415.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::6) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|DS7PR12MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: f03c6387-14e5-4a37-62f6-08dac85d8ced
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/ZuymPMPrvUcLnIpDTrJw1AcQYpkRsV4AUoUn1QSe5rpQzTcJ2gTRFLsNhR/OQ5H2958c1dlFDCHqaaB8QgiuSnvtIfLzw8EmlFR7v1WYh+k0fEugx7row8klcnXGFUTJNhmieQ3dE+Vo5FIG44/hj1HkmgI0W0BOLlMeVqz8REWHKPbQvCBKi/3oNymgQJkrLwKILmJvz5Syd8BFcuDzfdEQbnL+Yl8bXulbMIJ6ej6tQH5trU0HzrEaWKKuUulJjFmSlFlArEU0twulJgZWBXRhDgnN4gEMwh8+sXQk+u9D381wiEFyrq9K0bYIqoCgGmaTAGASk8b4Od7Mdc0PE4bd7Iukp8mC2UgWcQJhKUi4JEAxSzLKyrK+Dgk6dITsJXaBZlaIltERlZaURc+PbuTvNO2XMODX02kIuUVVKDPeADhsygyPVj8u+iX45QLA2AwDiFALiq1ZMKOvYNQCEdtoEazVH/76Ea8RVmXiXxMqoMbJc525IFQk38kheqvdqt0qf2TBjzOUrwZncgs0uhk9/Bn3qJBWVPu4SrO0lq4DWzPLjaI2D6bMGqPFSck3QH05I1v+evE9nSDyVApDP5iBrnCUza4E3gSfyXTxVVTBMHG6i6hInNc5zo4QQS9izsGp3AqECEkAY9Z1jVZrMZZVCr6Rjj8gJsKOs5/t1vt/TzbxKr4TWZ0IWjTv/DoPCkGT3vQEEkQGCdJez73XItfw0cNG0aRha7AoM4g1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(31686004)(86362001)(2906002)(31696002)(83380400001)(8936002)(26005)(6666004)(186003)(6506007)(6512007)(5660300002)(41300700001)(8676002)(6486002)(2616005)(6916009)(316002)(4326008)(66946007)(66556008)(36756003)(54906003)(66476007)(478600001)(38100700002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmVqcVgvZXZ1SjJJZUwvRTFGZExsb0FoVjFJa3RvUmdlTHlSZmZuUzRBa2xK?=
 =?utf-8?B?bHViWDg3VnVxMTlNbWdKQWtCQXdQNDRHOVpmaGMxNTB5TFVTZ1pzY2Z6MnBt?=
 =?utf-8?B?UHorZ2JGVkVXSGpjZkNHd25QbGFQY0ZQdzJ5emRERmtlOVEyVUZBc1JJU3ZS?=
 =?utf-8?B?U1owNnM5YzZVRGh4ZUxIaXVqVjVwUWpYWEd2NlFXTlZWMmhadUt0aE84MHpt?=
 =?utf-8?B?TDFHaEtUKzNFR21TQTROYXZndjFzZHZSMVlHZ0hQMExEc1c1ZllmNkhrMEN1?=
 =?utf-8?B?UGpGdkVrTXk4clRKRCtyK3NzZ3lXemxrS2RiNWJZWlZjMnFiSzdVTXZiZk5V?=
 =?utf-8?B?MDNVOXFIRUN3L0ZIVHc5SnlDT1lkSVFZVHNLdS9CcnZWLzNkV1hxYldWb0th?=
 =?utf-8?B?dlQ1ck41ZkdvV091QUlpbkUrTGJBbnJ5V1F2eWRSQm8wTHFzamc1ZUJ2OUx5?=
 =?utf-8?B?SjdOMXJuSUo3K3RhWTMyczdQUWJBZU9XSnRvYVRraHdYVUxKSGtCS0Vtazhv?=
 =?utf-8?B?b3hLV2psdmhXdHRyT2tXeGg2aUxCbnkybFJoZTVDZUlUZEhOSVExTzZNS0Ey?=
 =?utf-8?B?RkpHMk1Zb1JPTU84YUxLZ3VQS2dXT2s0Zjg0Y1BjanRnbHBtU21RSEhTTkMy?=
 =?utf-8?B?T1hSM0FqWGZZdllWTm4rWkx5KzRlNm52L3FoTEdMVS9wa3FKSmlVZVdIazE3?=
 =?utf-8?B?bXltVXRMREhTVTg5bVpPano4YitGMkx6eTlXZlQ3WVFudXNSSzhaNnMxSnJC?=
 =?utf-8?B?WGkrUWsrZWdSSjEzWFVzVUtQZUpBVG5OT0pWcDBiLzgvUFdKRVRVakhzNXBx?=
 =?utf-8?B?MWpZTFZUSmtqdDYrTlZleVNwSlRvcURmZWV4ZlgxV0dnNWJWcm0wdkFaRnE3?=
 =?utf-8?B?aHF4aElmZjloUHk1enE4aytSUVhRQWthTUo4M2NXeEt1RGpCSGZzKzJyLzNX?=
 =?utf-8?B?c2dTcktnVmJqck1CRU5UY0pVN1BSamZXUkxuMWZKZlJNYjR1NGcrM01sa01Y?=
 =?utf-8?B?ejZBR3RFRzhYK1RLNG8waktFRm9sVEgzMzZZTTdFbEg4Tzc0VmZScEhUcUJT?=
 =?utf-8?B?UUhGSUlxNmN3ZHA5MkxQNENxc3NwblRzalVuaS9MUWIyTk9STncxYzFWekJC?=
 =?utf-8?B?UHZyblArWGR5bGdNVEhHQzYzTVY2WkFBME5scTR5Uzk3MVNkUzU0bzBVUll2?=
 =?utf-8?B?TFlHSlZUU3RHR1N1NytXMS9ybVNSd2FPNk42QTZSZlRHTFVlVGZBSytQblY0?=
 =?utf-8?B?N0IwRFZhazd0RStyYUthNEF2ZU9JbFB6emtJbS9NbklENWpCRzRuc1lYOEts?=
 =?utf-8?B?Q2hFdE5qMnRtZytDTitNaHR0WHRTdWp5NnRnRnI0aFVEVDNCYXRmNGZHN3pn?=
 =?utf-8?B?VFBWUTIzdUZVNFBuOTNvNTNEWEZqMG1GZG5sMHExVFlBc1lTZHlBM3JmbWNS?=
 =?utf-8?B?Q3FaMkVCN1dYWnNqbjkyYmd3K3YySXlycTBSc1RyY2tnVzhaTnoyUTBnblJV?=
 =?utf-8?B?ZElOV3RyWkI0TUVNb0JGd2NGaXZibGpwQmg5dkNJZDhPMzVGMUJPM3FCeThU?=
 =?utf-8?B?UllveCtoeG5Wd2Raem8rUDcxVFpKM3Z5OWFFclJXM3hZQXJURUVCVWpqd1JI?=
 =?utf-8?B?ak50ZEJDN2NNTDFuM01MRFZvc0xHNXhuS2tXRTQ1Y0s2UkdqOHlySUlOSGZn?=
 =?utf-8?B?VXFHVUZ4N0RCTTNuMjF3WW53YlpkdEJGb1VvK3g5ZHZiU0VVdkVVWFVHcThp?=
 =?utf-8?B?OW5pd1NYUTBQK2JCbTJyZmUwZlhNR2dsZ1NUaGtMb2ZOZTZZVlVpWFBId0Jo?=
 =?utf-8?B?Syt3RWtKSmwzZ25VMkpCRWEwZTByZzZxMERUeWxoNXZ5N05TOW5IMWxkR3Y0?=
 =?utf-8?B?OFNWSENzVzNLZDAxQ3IvWm9VQjFpa1BuNk8zelBFUytFQ29ZMHFDcmNyaGF0?=
 =?utf-8?B?aDB4TndETmNHZU92QWlXUXBLSURqNGVBTGt3R21kSWV6dXlZQ09MMXcwS1pa?=
 =?utf-8?B?TUpDRDhEclVFVlZTY3A5eG16YmMvaUtVbVRhL2ZiOEltMURaVWN2R3ZVN3JC?=
 =?utf-8?B?OWpzQlEzTllENUhYWGtxeEgyYkM1ajhkLzJnSW56bTQ2QlRyYW94S1lsR1BU?=
 =?utf-8?Q?wqIXvKrcwuazT17ioICvSzTJK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03c6387-14e5-4a37-62f6-08dac85d8ced
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 05:35:35.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uH9j6N9tRTwrU8FTnhDr11uAK8FH3pckgoRf4VOXlkdfOJJmrpbOg4Up1NGOBe7L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5837
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/11/2022 20:21, Stephen Hemminger wrote:
> On Wed, 16 Nov 2022 09:33:11 +0200
> Roi Dayan <roid@nvidia.com> wrote:
> 
>> Action ct commit should accept nat src/dst without an addr. Fix it.
>>
>> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>> ---
>>  man/man8/tc-ct.8 | 2 +-
>>  tc/m_ct.c        | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
>> index 2fb81ca29aa4..78d05e430c36 100644
>> --- a/man/man8/tc-ct.8
>> +++ b/man/man8/tc-ct.8
>> @@ -47,7 +47,7 @@ Specify a masked 32bit mark to set for the connection (only valid with commit).
>>  Specify a masked 128bit label to set for the connection (only valid with commit).
>>  .TP
>>  .BI nat " NAT_SPEC"
>> -.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
>> +.BI Where " NAT_SPEC " ":= {src|dst} [addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]]"
>>  
>>  Specify src/dst and range of nat to configure for the connection (only valid with commit).
>>  .RS
>> diff --git a/tc/m_ct.c b/tc/m_ct.c
>> index a02bf0cc1655..1b8984075a67 100644
>> --- a/tc/m_ct.c
>> +++ b/tc/m_ct.c
>> @@ -23,7 +23,7 @@ usage(void)
>>  		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
>>  		"	ct [nat] [zone ZONE]\n"
>>  		"Where: ZONE is the conntrack zone table number\n"
>> -		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
>> +		"	NAT_SPEC is {src|dst} [addr addr1[-addr2] [port port1[-port2]]]\n"
>>  		"\n");
>>  	exit(-1);
>>  }
>> @@ -234,7 +234,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
>>  
>>  			NEXT_ARG();
>>  			if (matches(*argv, "addr") != 0)
>> -				usage();
>> +				continue;
>>  
> 
> This confuses me. Doing continue here will cause the current argument to be reprocessed so
> it would expect it to be zone | nat | clear | commit | force | index | mark | label
> which is not right.
> 
> 

its the opposite. "nat" came first. if matches() didn't find "addr"
it continues the loop of args. if matches did find "addr" it continues
to next line which is ct_parse_nat_addr_range() to parse the address.


