Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D445B6B6FFD
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjCMHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCMHSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:18:18 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272E617CC4;
        Mon, 13 Mar 2023 00:18:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdQsnIlzchHnVvaUW+pS5Dpz6xJ/kGGjQQ0KMmMKZM21CtGaps21CHBPGM9jj+IE+oFrH978YR4JyevWC9Ng3kzKH8sMkRoZibo/0lU/W2/xbfGP5AnnGvKs8J8tPvlq2XAx+qgsQJ4rSWJFBU2WwUKYkfJ6XmbUqLe5v7oZ25x9uue5WXjBcM7oK3Mt7Ki/jcL3moMluc453EQpSlqOtxiYCHL/ZaU3FyTolLDTnuILbVK7IRNL/L3ZKGMBRfYh7mUCNpk+KQXc5LCrQVVlJCNW4nb+eDNEJvKVbV/qzIYT/4IODZ9XI4XzuWSnT2hgiyyPTAM7f6BZobG96K33yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccUpOxql5gTGprcT8bsqI8PLdB8QtXn6v+lZm1t8O3I=;
 b=YRyP+IezYTfXo1QhjsqvbM7XtKWg3wlD2K4sV4fsUXAWyho4YZC2pY5pwetMQdSGihget7GXFQrgTPCknsJcmowDWE7603LV/bMbALL82arSsu0z3GKdBW9Z8Tx3n3B6QQMY6wsVBWtqKAefzxVBEFaFEfwqRBZHpZ88kRxOojK4c1A3eTPZ9nu4RCM3A53hCcTXcDrVchkThXLnlOa7+lQJ+U5ordrd8tFAFNpQwtcMA1KkSDzLSM1Lg0BNLpDiStJpAEsowydU0uAGIP2orSM/tpettNYPnbFidsVMtZhO/gJXzVK/CIiypwscw/R68l0IKUtV1MX63V7jqXAubw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccUpOxql5gTGprcT8bsqI8PLdB8QtXn6v+lZm1t8O3I=;
 b=AjTX9+kbd3uK4FBSS+qjhQunqmQkgfOCVsiWp4Bv6ymmtN1CpR0Hrjnpo1qR+Ia2KetN61lXk0UiknbT3J0bEExDra8yMKBcKMYvhCJJgHl0zMEgLS6l0+uksa6pImyxfP0NoKPk2ugCKlOmhYb6ztniSsX69iET5/dMk2nE1DAoOR9MkZz1jeNtHMOXIG88IIZdS9hOG7akTSSmYbtIXb4q9TLI83rEEtxFj2BaOaXkMHlnyoB8Y1m5vGx7HH6llg96l0RN5hcVkot30dq2jabFrDJHYZDRN+noOHRhkOIaXSS2yX23hGJ3nLVIFK158btaGufr7TJJAa75oRTvzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CYYPR12MB8730.namprd12.prod.outlook.com (2603:10b6:930:c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:18:14 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::8fe9:8ea2:52f4:9978%7]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 07:18:14 +0000
Message-ID: <972f5a5f-7bff-5425-c3fb-d842d89897ef@nvidia.com>
Date:   Mon, 13 Mar 2023 15:17:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v6 4/5] ip_tunnel: Preserve pointer const in
 ip_tunnel_info_opts
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        roopa@nvidia.com, eng.alaamohamedsoliman.am@gmail.com,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gavi@nvidia.com, roid@nvidia.com,
        maord@nvidia.com, saeedm@nvidia.com
References: <20230309134718.306570-1-gavinl@nvidia.com>
 <20230309134718.306570-5-gavinl@nvidia.com>
 <CANn89i+k3fcSw58owpr70eM_uSM5QUqEb_4y5wpXOKEz30+vvg@mail.gmail.com>
 <CANn89iKcDNZBerR_2nEp_ryM3BVXuvr64s6tnAvizCwr=SuACg@mail.gmail.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <CANn89iKcDNZBerR_2nEp_ryM3BVXuvr64s6tnAvizCwr=SuACg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0015.apcprd03.prod.outlook.com
 (2603:1096:802:18::27) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 421e660b-ef4b-4d5f-da82-08db23931bc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1lwvYV+5qRg2ixvR+uriRmXA381XQAMzE8qT11h+sshBtCK1WIKc0ltT/EnmzuP1ulbbCV0v7ClbcInfezKPoA4HcC9FlOfc3nFcGtAPQ5Chsf288dRTlBEZX+2ghzqJwJPXAnrSdQ1HHAl+eGBstTyPJL23jUOikXFBTsJT4eEi+vp9MoJ+jK7D0lVTGYMKc+auAafQKr6cpqgBGIc+iHSmDjf1Wv/dWLHzyLdnr35row83ZUeubVVLfJL4yNSjIZAdJzo+Vvy6sDztGr9V6JDb6UP35kzVALhH0e3VCmMKADt5/+BVuzM/wgN97wea100wvu3JQbGaI0vNvieRDbP4r321qGYUQFEk20kjKkXbCZXdv3+6N6TLMxh31ZVXnR1/WoRpsS1gWstzJVTghi5x2XGkXTI0YcbKduNgHwC/aTCNNjlRPVTDSmW14ElMWcoROAdNYvV/wnGYxPHRVKO3K3DzA7MdXYaqLyEyQSdPLlhG6L6D/LtXZRkWwY5A05B0IBJtv6kVD2bKybxa0y+97lVT4Fa4299ix0MNtQQSyfM81Nl0Lo1QWBadGMZtc+Jbkzej4bI5iuR46xunXdrVTeXZ36YbqPGAsqFCpcGS0Uhlxx5xBuSNBF4FO8yGzBGKt5wJQ9uA3Z7skVt7UCeWSzJktKma7olE6M+PH10YrBxRCYm5Vkz+tcitlORMPrTC/pXivmCiZp/pXrFM9X0sooXoXdOTanm9g4S/qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(6486002)(2906002)(31686004)(83380400001)(6666004)(107886003)(36756003)(6506007)(6512007)(5660300002)(53546011)(8936002)(186003)(41300700001)(86362001)(31696002)(2616005)(6916009)(8676002)(4326008)(66476007)(66556008)(66946007)(26005)(478600001)(38100700002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RCt5UkRwV0lWOUc3S2tSNFhobVR5VTlUNEhpdzJZZjdwb1hXODdyOFcweW01?=
 =?utf-8?B?UG8xYU5kKzhhWDg3RWExV21ST0xIUEpvWUloS1JpK1NZKyszL2hCdU5HUTJJ?=
 =?utf-8?B?aTltWnFwT05iTnFuaXhZQ1pNd3AwYTBoWFBjemlSdGVmSndxM1ROSXcwQ1VX?=
 =?utf-8?B?cmMxM0FMZUtXTHdRelllYVQyQ1A5d09CdFB4aUdKdHcraWF2b1RxR0pGMDZr?=
 =?utf-8?B?Yk9tb2VCaTFZbFNiTG8zMm8relpuSldpVnc4VHJpSEVDZXMwcnJOSmtlSitN?=
 =?utf-8?B?cUVidUFOSURQaHdrb3FUOE5IMzAvWTBQSXp5Zk1ucmp4b3ZiMXdkK1MyajJm?=
 =?utf-8?B?akc4MHVRUkVuWHpVZmpHTnF2ZU1WaEt3S2pPamVMWDdiZmZXZmRBL0RLU1VS?=
 =?utf-8?B?emU1SDFtVXJBWU1vdFJIdCs1b3ZvSklJKzdyL245OHNtZGVzSU1XVWZjSnFE?=
 =?utf-8?B?WDdIZE5xeW5ISVMxaW9aSGlMbEwrV0w2K1ErYWNoY2tkc1ozT0RtaUJXU0p0?=
 =?utf-8?B?a1VCeEJnSzltK3ptWFhySGRzS0dDZ0FWQTdwbFhHRzRCRU5uLzRkazAxa3VE?=
 =?utf-8?B?Ry9nVFFYN1BuMWhFSGprcjE3OEN4TTNNZGQwV2RzMG5ONEExakFmL0JRaXd6?=
 =?utf-8?B?aXM1R29DVzhQUWJoSlZGMDNxalFhSmRoS1hpSnRxRXhDa1VSQklGZVpUd3hZ?=
 =?utf-8?B?OG9wc2VhSTVPV04vVWtrOEVzeFR6VysyRmpqUVMrQnJrZW5TeHFTZG1oRFBX?=
 =?utf-8?B?ZzlDL09ub3NRMENDbG9QcFRJNis0NW1KV0FvMFNNSm9yTkQzRm1xNnpVYTRv?=
 =?utf-8?B?UTgycmswN2hObUozMi9jR21MNXF1d3Q0V2pTaWNQWFN3WDRsdjVIZ3NxdUs4?=
 =?utf-8?B?aFIxNERnVFBWZkpXMmxOemd5UHVGNjVCUVFuRGRFQnFCTmJoakoyN0syVDc2?=
 =?utf-8?B?NTJUbG1hZ1RHOFV5Zlc4dklYZHZaaTdBOTB4VDNoV2hBMEMvb1lvaWVsOFdM?=
 =?utf-8?B?V3lkVG5SQy9QYVRVaEJnNUxhQml3bm9BL21VMlBhYnhqU1I4ang3M3RpQk1S?=
 =?utf-8?B?THRkYWE4NXEwamNLTFdrYm1hOG5vQVhIUVFsNm9YWXJSSitNbnBpSTM3YWRM?=
 =?utf-8?B?eHc0ZFkyTWtnV0s1c3RNaW1MQXRyaVAzZXM2N3NoQVZGT3FQb1dNalRSVDl0?=
 =?utf-8?B?SVhRemg1b0wyOWZTTk5NaVZCRjhaRngwMHFFNmZSZVFPZnVoN3h2WjNoMEJO?=
 =?utf-8?B?Mk5vN2gva2xiSUNBUytsUDkzbkwxR2ZwOE5GTXJjd1NMT1lHMVhXM013ZDZw?=
 =?utf-8?B?dkFPQ0kwUm1qRXN6YVlUaW5YZGpzV0ZjamphNVVSTnQxS25vYlJuZ1FLdld0?=
 =?utf-8?B?QUhpZ3V2Q1RIcGhVMW5VYTY2TW9Jb01tTEJMQlNrUjVwaGFYc1JIa2JpSXpx?=
 =?utf-8?B?cHBpQmpScGQ4b1ZVSkUzMG1tVStyWnRiWndwT2VqZnM5T0VWelBTYzlkclhp?=
 =?utf-8?B?ZVBQb3BnUmFyZEJaSHkrNGhBU1RSZFZyRjk5Y1dhb3BseGJGMkxrdkYxTU0x?=
 =?utf-8?B?UEFvWVhZZ1JiMGlFUDg4cDd0QWtvUkFWL0t0aHBqSzFFWkxCd2plcEdJNHVO?=
 =?utf-8?B?Z08wREMxUzlJNzVKU2lGWDFoczk2ODNkTFdYSlExRDdxOGEweWJMdlYrelpT?=
 =?utf-8?B?cnRqOURudlpmSFk4RFliRTNXemhKbVBzbVI5YlFvcDMzWVBPR3JGSHo0aWh6?=
 =?utf-8?B?NXZRMnhqRnZMa1gvSFlZTXJJOTgwVDZmOEh1dVM2RWRoNi94b0hpNkMycTBD?=
 =?utf-8?B?KzQ5ZS9BV1dSeHNYNXFJOXhrR1hldithYjU4dXlCLzlGaXNPbzlUK3AxL2Fx?=
 =?utf-8?B?UVF4Znp5Sk1UWEVNZU9BSFNIYlpDcWxkU29ib1ZRWkxqc2FxMFNoY2xjZ1Mx?=
 =?utf-8?B?UFFGdzd4SFVCbUYrLzZlVFZJYjkydHJYR2gwdFBzYWh5TUk0SlE4ajJ4Nmg4?=
 =?utf-8?B?K1E1VnA2THV4Ylp3MmFReEU3b1pkRU5VUjNFTzMxRUl1V0RmRm9udDFVcyt2?=
 =?utf-8?B?dkJFNTdEbTBlQjNsZXJjYjRpTlF0cUVxNDE3RVowTmRJNmxNeHpsZ2V6WTJT?=
 =?utf-8?Q?lZ9oAsw2eh53r8G9qFI1+0uS9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421e660b-ef4b-4d5f-da82-08db23931bc7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:18:14.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWI1sWXKxeaRsCl9lfnRrWUO4qlO1WRsYUx2cHwXSV0VbOlmtLtFOMRNI3JfEgarueQB9xDY2AEbf095BsFLgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/9/2023 11:05 PM, Eric Dumazet wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu, Mar 9, 2023 at 3:59 PM Eric Dumazet <edumazet@google.com> wrote:
>> On Thu, Mar 9, 2023 at 2:48 PM Gavin Li <gavinl@nvidia.com> wrote:
>>> Change ip_tunnel_info_opts( ) from static function to macro to cast return
>>> value and preserve the const-ness of the pointer.
>>>
>>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>>> ---
>>>   include/net/ip_tunnels.h | 11 ++++++-----
>>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
>>> index fca357679816..3e5c102b841f 100644
>>> --- a/include/net/ip_tunnels.h
>>> +++ b/include/net/ip_tunnels.h
>>> @@ -67,6 +67,12 @@ struct ip_tunnel_key {
>>>          GENMASK((sizeof_field(struct ip_tunnel_info,            \
>>>                                options_len) * BITS_PER_BYTE) - 1, 0)
>>>
>>> +#define ip_tunnel_info_opts(info)                              \
>>> +       _Generic(info,                                          \
>>> +               const typeof(*(info)) * : ((const void *)((info) + 1)),\
>>> +               default : ((void *)((info) + 1))                \
>>> +       )
>>> +
>> Hmm...
>>
>> This looks quite dangerous, we lost type safety with the 'default'
>> case, with all these casts.
>>
>> What about using something cleaner instead ?
>>
>> (Not sure why we do not have an available generic helper for this kind
>> of repetitive things)
>>
> Or more exactly :
>
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index fca3576798166416982ee6a9100b003810c49830..17fc6c8f7e0b9e5303c1fb9e5dad77c5310e01a9
> 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -485,10 +485,11 @@ static inline void iptunnel_xmit_stats(struct
> net_device *dev, int pkt_len)
>          }
>   }
>
> -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
> -{
> -       return info + 1;
> -}
> +#define ip_tunnel_info_opts(info)                                      \
> +       (_Generic(info,                                                 \
> +                const struct ip_tunnel_info * : (const void *)((info)
> + 1),    \
> +                struct ip_tunnel_info * : (void *)((info) + 1))        \
> +       )
>
>   static inline void ip_tunnel_info_opts_get(void *to,
>                                             const struct ip_tunnel_info *info)
ACK
