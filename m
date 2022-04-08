Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E564F961E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbiDHMvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbiDHMvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:51:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCDFF65C7;
        Fri,  8 Apr 2022 05:49:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCtuyTgd+1qB1yBvkEqtuqZn7WtE9Ypb0wZuCnj4Gm1y8XGZ61CHmvIjYZtzxtJpijQjilq3F3ft6J7hOCqbIvD23fJZj5tiHruLOEz+xbcYDssZ+n4G5Zc4L8qZ22MsjKHvmK3wEsM8WDHyqumqRC80yjPKYfWTnBxFiJN3+78Zf/0+D1RNa9cBlR10ZG1WzfpyqH1sYoAO/VZMPzQyAByKbPzWyDXGyHqyV6IHyUJRJnLvzsTGN1+YwI8MB5uUMSUIU7MNCGEOXXgVQFCnzcaSRggPf4E1c621CPTOBh42kT+cOMA/kuy5UjCPRF7H+cugWc/HEGoJlJAlygltfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3x70QqPJnKVmlnj0UiW2y+8QX0FmYvkGx71FrKpOa0=;
 b=BN0WumR9IcPn/gigepq4aHij3TYi4xS2OpAa3vjZCWaAUeyroANYpEPz8qSAkoSIB51ERQ6TI46QrXSj9UBjl36p5v+q5fgDi1rYh4Kdw8lcTIuEuLJdJrUJq6OTNinXC7cwPogI6R9b1Sc8MWxOnRSm1B1iyyD5X4MldxgMQ8nsOcV6/mdxwWRxef7EsNXQv8a7Blw3jD/tKpC/0AwIszruHBADoJMoBhFq0yHmW2rbF42x3kanoM57GSvZWDpCMGdo0iCg1av2EQQB5zuMgivKXMMYfdK+jiTagRB837/ofENFDUCWIca0WQvKm5me9bn7nG5Jgh7uvkOFA2TZbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x70QqPJnKVmlnj0UiW2y+8QX0FmYvkGx71FrKpOa0=;
 b=KyslfBt2gmXJN4UJH045uHrFaIpJ8RDqXEPIw12OCrDcGCJ372Tfe58H2yPSYTThVsVp6E53UqMod9oke25+8S36kOklNu8g2BCSby3QGzinoqvFABcY5d/R0q3UNgFqwLo1gjk+rJk2rkvXvWRHzSjXP2lWoEzFPGVdLUsVyvrD48NNBz9hbGaoZjEOMkg0M+yrHpEYp2epXLG3nwoePPsbhJRf2yUOSEJj9wTIpCzu58WOv2hkiCBhp1SDc9xXGF0l0z1WR+ZdYdGAMtjnQtYV63xsDnksfk8j+QZrtWc+/zfhb0PfJx6hw0KypvIlGREzoK2+shrCBHdsYm13VA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB4638.namprd12.prod.outlook.com (2603:10b6:208:ff::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 12:48:57 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 12:48:56 +0000
Message-ID: <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com>
Date:   Fri, 8 Apr 2022 15:48:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com> <Yk/7mkNi52hLKyr6@boxer>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <Yk/7mkNi52hLKyr6@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0258.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::11) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50c1cfcb-b449-4bea-65ba-08da195e24d3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4638:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB46386E39E9F25118E6CE9702DCE99@MN2PR12MB4638.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9l8Qwrqoov55tNxbimUuN/D+lTg4o30IowiOW6W6kO9R7gpbBfTmHIDX+0PowOUIenY1xeKoJS9goBlgvXaO1v0tnKr+WQ0P4EoS6p/4b949tMHXjOj2sxaXSsm4jVad0flr0/ngt7DgfjqyQhDZXCy5FsLCKlLdis4Nf6lsG1U0pTFdN1Ket4r+Sa7QLgL4ud1BAQ8fp2Y4N1Cx+a+PVyCMfozGm68UUjdUQwblgEcthL51Pr9J+MTFSEYtSfKB5V494kbNxbzjp3/pEr8Mue1DcWNoVR1Jqq6QH1RLzoV7SnixPDByvoYc9uD75qEX4dBux7XepioOV9mCrHvkbjuOoVpo6aLOupbcjyj+hMd3Vu3hlD0q0XJgs/aphbKAcKqsNt0WpMJKYpaczl15bW5Ev4uKnPAS7wniEhbOgtHaVhkvNp+J/52Z1hMAmcneUA3cOkf+2xT7h6DHOV+TKb95mIbd8Arv48LoZdbXaCpaSkdpA8cR/37xcPEoTtypkHLdER1q5u8o4xrFN+WJsvYmze6b0n2Km4kYlcTC6jZAep+JshqEU5+69TKZq1IxC3pSceGQl7bEgYnrsBkjhDR7YJHwVETfxOxVP8e75lL78VSYvkdFLLfmz6KzN8PKmaybhwx3PhLJBJ+495ioXL/R3wCC3xzmrB05NFoK/Jv+vGbaPNA5cN2FNgB5kqsFThjKNxRFsaSFTOOP6ljDXQS9xc+cxexrgUoHWTeXFUVd/P6YxPSpViBExkM0lSpuMc+jKSTG1Rjk8/bwA7EdFFcwv0Cb1IDSFZVusnxnRMZnqt59xmPLTzrdzadm56BpCviLaqj5+4N8qc5jIVkY8UHZyu32NfNQ4zW1gUzOqJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(26005)(316002)(53546011)(6506007)(107886003)(4326008)(186003)(66476007)(508600001)(36756003)(31686004)(6916009)(966005)(54906003)(6486002)(45080400002)(2616005)(8936002)(30864003)(38100700002)(66556008)(86362001)(31696002)(66946007)(8676002)(2906002)(6666004)(83380400001)(66574015)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aE1UcHZsWnd5Q0N3ZmVzQ1NRMUVDOWhKMHcrWnR0elFSZTRQNmxBcjFpRWg5?=
 =?utf-8?B?d1dQY0xLSGRrdzFCU1QxcVY5aFFTZ1F6cTFlaEIxTDNHSGgwaUtZZ3dXckM3?=
 =?utf-8?B?Qm5qWkVTUW04VUFKd1MyNWJqZFMvQkJWNU4yYUhxVHpJbjFXNjk1cjNpY1FC?=
 =?utf-8?B?NjZEOGFVTU5jNDh5cTRXU2E2SEVKY1BLVE00ME9kbGtUQ25SRnVRNTFrenhW?=
 =?utf-8?B?RVBhUVM3V3BHWG1Qc0EvckpmNFg5ZTdRQ3owbnNiUG96V0VSQ0hOTk5jd1hy?=
 =?utf-8?B?MjhReWlOWUNTODdxR0ZybnBnRk16dXMyWnJxUWdKaksweGZyWTNDZXB1RWhT?=
 =?utf-8?B?Z3dtMGN0KzNXYVJvNWpJemxzUXRUeDZnTkdEUXZYQW5SU3EycytSUWY2TVpP?=
 =?utf-8?B?Vk9xek1EUW83TEJjenVzTHdPN3RKMTlta1EwSEx5ejluOWpxOVZaUW11UDNz?=
 =?utf-8?B?L1lsL1JwTXJ3SjJXM0RiUUpQa2ZFZ3BFWUR6MnRlTmlsVHRiNmpSQmVnb0o5?=
 =?utf-8?B?YUVGdFVyakNKVjViM1BZT2xoWEczQ2xhVlk2T0xaZThHVUpER1d1LzRGRjd4?=
 =?utf-8?B?UkQ4UWZ3d2JVTnhHVVRGSk1pSERERkVFa2dCbzVRTndZTktiNG11alZBbGgv?=
 =?utf-8?B?bDVoRmp6RThMV1FjUVE1SU1ka0JTM3ZLRVNLTnFyTCtrS2FnT2lZUUFLdFFW?=
 =?utf-8?B?L2xwZUU2WGh0SFp4YWM1YldIcndBOG9qUGVlWUk5czVITisxb2xXWjdMc0tp?=
 =?utf-8?B?RnFLL1dMOXU1L2dBUUNUYzJpcWdmN0lBNm1zTHptYjlFMVdaYUlOU0t1ZEtJ?=
 =?utf-8?B?T3hqQzQ5aXp2MGlBR1ZoMnFXRFpCMUMyOFNFZ2NOZmF6VUJDWXd5MTFKQnRO?=
 =?utf-8?B?Slc2bjYvNGNKd2hlZVdzaUNBZklVb0t3TlJ6K1VCelR1Yk1vZTZYdmdSdWNu?=
 =?utf-8?B?SUk0MEMrdW44TEF2V3hQeEd2WWhCZ1A4Mnc1c2NxWkZ3MVg3anBBeE9URTFy?=
 =?utf-8?B?WDEwQXI1eGZCSjVleXQzak95NnI0NzdBQS9tNElNbXJWUEZzcWJlWXVDV0F4?=
 =?utf-8?B?a1dNWXFvSENDV0Fla0ZXRURoWk9kaHJrOEVJcVZKZVBQQlU1aVJ4UHhLcEhK?=
 =?utf-8?B?T3JkMStkREtSVFlqYU1LMkFvSER3MnYvbTdMZmxhb3FlUDZwVnBJOFdSRW1i?=
 =?utf-8?B?clREemxFUXVnQXcwb2hDbHNuQk45cTQ1WTBFempNcnNLNWJYUWYwM2Z1OE8x?=
 =?utf-8?B?S3NwNk5lQmZyYVF6elVuVkQ0ZDNiRWRUeVB2YlVkVGRmVyt5NWRyRmF5MDMw?=
 =?utf-8?B?QXhjSGdHblFBUWdiNXYyRGV6YXJNVk5Ub0dpSVVWYXJiVWdZRDV2S0F3dExQ?=
 =?utf-8?B?b0JtaXA1QXNlZDRNT2J0M1Y1Vm1SYmtkamhucUo2MllrQ2xHdlNQVHNsaHFJ?=
 =?utf-8?B?T0E2NXlSdEt0SldoNmxyY1FWcmtsaDdrUU5hWUIxZ2JyNStQaXkyYStUQ1RT?=
 =?utf-8?B?SjNHVXE0Sk5sWUthUlcvUGc2OWVmQ1pKbjFnUitZNSt1SENTekg4U0d1dExX?=
 =?utf-8?B?V1ZpRkZhNS9yMWNEb2tSMXJhQldWME00VDIydmpPcTJWN2hpalhKdmt6UUtF?=
 =?utf-8?B?cWtEV3B1cXVaQW5BOXg1czdPZlBneGd2anhYLzcwVjI0eE5ORkY0bFFxdnh3?=
 =?utf-8?B?MDdCa0xRNXFOdjlEWUVMem9wZyszV012MXE1dlo1NnRpRlJHdXB1SVFxQkcx?=
 =?utf-8?B?Z0tpMHFTakVLc3lNZDM0cXFkZERyS1pDU0l4WHBRT0V2MmZ4TlFjblIwWGZC?=
 =?utf-8?B?WkNxcnd5L1FRUStJNzhxTHRqODFHY1J0cnVuc1Y0MUxFWFZyR0JEWGY3Z0Zs?=
 =?utf-8?B?VmRwZGZ4QUtsVXV1TGZ6U2tMaTJIK1RkK2FYL1BMY0ljK3dOMGtHc2FoSDhK?=
 =?utf-8?B?aWVlTFE5aGIvd1JJcDVwbEtEQ0FpZTRGK1l5blVMUmVOUG1GSVk0b0o3YSth?=
 =?utf-8?B?SzJhY1U1YUpoUEc1Z0w2MTlzdG5jdS8xMFI3U2ZaUDNteHFYRG4yNHhTSUN2?=
 =?utf-8?B?bnl3Q0dVUjNObldqWHBSdUZmMEJtdTdPR2dBbGd4SGZ5SUZPUHlTNlFXRDdU?=
 =?utf-8?B?MzcrSFNFdTlCNUNEbFBEZ3lEZzkwdjNhTDZzQlhjYTB2WHd5eFRqWGRsQTVZ?=
 =?utf-8?B?T25rNm44L1E4WFNNV212YlJyZlRYcFZRM3l6WEIzWkFzcXRHaGpKcHlQYjhN?=
 =?utf-8?B?Zi9rNEZkOTBINmFRSjJSbzhzZUZuQXpCR0lUbC9HWWtjTk1ReGlUU0JUVnIv?=
 =?utf-8?B?cTlKempOT1hWSmFWQnlWdnlQYmdYTk83eVBkSWdxbUVJYm8zL1BxZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c1cfcb-b449-4bea-65ba-08da195e24d3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 12:48:56.6643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jW0tEB0cfP5QbWKRYZWC0PN52Uqqw4QY+DqmgomfjiWNDNTUk6ThvAdCLadyKc6wfU+kqs3mA1EpWvtN+M8+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4638
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-08 12:08, Maciej Fijalkowski wrote:
> On Thu, Apr 07, 2022 at 01:49:02PM +0300, Maxim Mikityanskiy wrote:
>> On 2022-04-05 14:06, Maciej Fijalkowski wrote:
>>> Hi!
>>>
>>> This is a revival of Bjorn's idea [0] to break NAPI loop when XSK Rx
>>> queue gets full which in turn makes it impossible to keep on
>>> successfully producing descriptors to XSK Rx ring. By breaking out of
>>> the driver side immediately we will give the user space opportunity for
>>> consuming descriptors from XSK Rx ring and therefore provide room in the
>>> ring so that HW Rx -> XSK Rx redirection can be done.
>>>
>>> Maxim asked and Jesper agreed on simplifying Bjorn's original API used
>>> for detecting the event of interest, so let's just simply check for
>>> -ENOBUFS within Intel's ZC drivers after an attempt to redirect a buffer
>>> to XSK Rx. No real need for redirect API extension.
>>
> 
> Hey Maxim!
> 
>> I believe some of the other comments under the old series [0] might be still
>> relevant:
>>
>> 1. need_wakeup behavior. If need_wakeup is disabled, the expected behavior
>> is busy-looping in NAPI, you shouldn't break out early, as the application
>> does not restart NAPI, and the driver restarts it itself, leading to a less
>> efficient loop. If need_wakeup is enabled, it should be set on ENOBUFS - I
>> believe this is the case here, right?
> 
> Good point. We currently set need_wakeup flag for -ENOBUFS case as it is
> being done for failure == true. You are right that we shouldn't be
> breaking the loop on -ENOBUFS if need_wakeup flag is not set on xsk_pool,
> will fix!
> 
>>
>> 2. 50/50 AF_XDP and XDP_TX mix usecase. By breaking out early, you prevent
>> further packets from being XDP_TXed, leading to unnecessary latency
>> increase. The new feature should be opt-in, otherwise such usecases suffer.
> 
> Anyone performing a lot of XDP_TX (or XDP_PASS, etc) should be using the
> regular copy-mode driver, while the zero-copy driver should be used when most
> packets are sent up to user-space.

You generalized that easily, but how can you be so sure that all mixed 
use cases can live with the much slower copy mode? Also, how do you 
apply your rule of thumb to the 75/25 AF_XDP/XDP_TX use case? It's both 
"a lot of XDP_TX" and "most packets are sent up to user-space" at the 
same time.

At the moment, the application is free to decide whether it wants 
zerocopy XDP_TX or zerocopy AF_XDP, depending on its needs. After your 
patchset the only valid XDP verdict on zerocopy AF_XDP basically becomes 
"XDP_REDIRECT to XSKMAP". I don't think it's valid to break an entire 
feature to speed up some very specific use case.

Moreover, in early days of AF_XDP there was an attempt to implement 
zerocopy XDP_TX on AF_XDP queues, meaning both XDP_TX and AF_XDP could 
be zerocopy. The implementation suffered from possible overflows in 
driver queues, thus wasn't upstreamed, but it's still a valid idea that 
potentially could be done if overflows are worked around somehow.

> For the zero-copy driver, this opt in is not
> necessary. But it sounds like a valid option for copy mode, though could we
> think about the proper way as a follow up to this work?

My opinion is that the knob has to be part of initial submission, and 
the new feature should be disabled by default, otherwise we have huge 
issues with backward compatibility (if we delay it, the next update 
changes the behavior, breaking some existing use cases, and there is no 
way to work around it).

>>
>> 3. When the driver receives ENOBUFS, it has to drop the packet before
>> returning to the application. It would be better experience if your feature
>> saved all N packets from being dropped, not just N-1.
> 
> Sure, I'll re-run tests and see if we can omit freeing the current
> xdp_buff and ntc bump, so that we would come back later on to the same
> entry.
> 
>>
>> 4. A slow or malicious AF_XDP application may easily cause an overflow of
>> the hardware receive ring. Your feature introduces a mechanism to pause the
>> driver while the congestion is on the application side, but no symmetric
>> mechanism to pause the application when the driver is close to an overflow.
>> I don't know the behavior of Intel NICs on overflow, but in our NICs it's
>> considered a critical error, that is followed by a recovery procedure, so
>> it's not something that should happen under normal workloads.
> 
> I'm not sure I follow on this one. Feature is about overflowing the XSK
> receive ring, not the HW one, right?

Right. So we have this pipeline of buffers:

NIC--> [HW RX ring] --NAPI--> [XSK RX ring] --app--> consumes packets

Currently, when the NIC puts stuff in HW RX ring, NAPI always runs and 
drains it either to XSK RX ring or to /dev/null if XSK RX ring is full. 
The driver fulfills its responsibility to prevent overflows of HW RX 
ring. If the application doesn't consume quick enough, the frames will 
be leaked, but it's only the application's issue, the driver stays 
consistent.

After the feature, it's possible to pause NAPI from the userspace 
application, effectively disrupting the driver's consistency. I don't 
think an XSK application should have this power.

> Driver picks entries from fill ring
> that were produced by app, so if app is slow on producing those I believe
> this would be rather an underflow of ring, we would simply receive less
> frames. For HW Rx ring actually being full, I think that HW would be
> dropping the incoming frames, so I don't see the real reason to treat this
> as critical error that needs to go through recovery.

I'll double check regarding the hardware behavior, but it is what it is. 
If an overflow moves the queue to the fault state and requires a 
recovery, there is nothing I can do about that.

A few more thoughts I just had: mlx5e shares the same NAPI instance to 
serve all queues in a channel, that includes the XSK RQ and the regular 
RQ. The regular and XSK traffic can be configured to be isolated to 
different channels, or they may co-exist on the same channel. If they 
co-exist, and XSK asks to pause NAPI, the regular traffic will still run 
NAPI and drop 1 XSK packet per NAPI cycle, unless point 3 is fixed. It 
can also be reproduced if NAPI is woken up by XSK TX. Besides, (correct 
me if I'm wrong) your current implementation introduces extra latency to 
XSK TX if XSK RX asked to pause NAPI, because NAPI will be restarted 
anyway (by TX wakeup), and it could have been rescheduled by the kernel.

> Am I missing something? Maybe I have just misunderstood you.
> 
>>
>>> One might ask why it is still relevant even after having proper busy
>>> poll support in place - here is the justification.
>>>
>>> For xdpsock that was:
>>> - run for l2fwd scenario,
>>> - app/driver processing took place on the same core in busy poll
>>>     with 2048 budget,
>>> - HW ring sizes Tx 256, Rx 2048,
>>>
>>> this work improved throughput by 78% and reduced Rx queue full statistic
>>> bump by 99%.
>>>
>>> For testing ice, make sure that you have [1] present on your side.
>>>
>>> This set, besides the work described above, also carries also
>>> improvements around return codes in various XSK paths and lastly a minor
>>> optimization for xskq_cons_has_entries(), a helper that might be used
>>> when XSK Rx batching would make it to the kernel.
>>
>> Regarding error codes, I would like them to be consistent across all
>> drivers, otherwise all the debuggability improvements are not useful enough.
>> Your series only changed Intel drivers. Here also applies the backward
>> compatibility concern: the same error codes than were in use have been
>> repurposed, which may confuse some of existing applications.
> 
> I'll double check if ZC drivers are doing something unusual with return
> values from xdp_do_redirect(). Regarding backward comp, I suppose you
> refer only to changes in ndo_xsk_wakeup() callbacks as others are not
> exposed to user space? They're not crucial to me, but it improved my
> debugging experience.

Sorry if I wasn't clear enough. Yes, I meant the wakeup error codes. We 
aren't doing anything unusual with xdp_do_redirect codes (can't say for 
other drivers, though).

Last time I wanted to improve error codes returned from some BPF helpers 
(make the errors more distinguishable), my patch was blocked because of 
backward compatibility concerns. To be on the safe side (i.e. to avoid 
further bug reports from someone who actually relied on specific codes), 
you might want to use a new error code, rather than repurposing the 
existing ones.

I personally don't have objections about changing the error codes the 
way you did if you keep them consistent across all drivers, not only 
Intel ones.

> FYI, your mail landed in my junk folder

That has to be something with your email server. I just sent an email to 
gmail, and it arrived to inbox. If anyone else (other than @intel.com) 
can't receive my emails, please tell me, I'll open a support ticket then.

> and the links [0] [1] are messed up in
> the reply you sent. And this is true even on lore.kernel.org. They suddenly
> refer to "nam11.safelinks.protection.outlook.com".

I'm afraid I can't do anything with these links. Our outlook server 
mangles them in all incoming letters as soon as they arrive. The letter 
I received from you already has them "sanitized".

> Maybe something worth
> looking into if you have this problem in the future.
> 
>>
>>> Thanks!
>>> MF
>>>
>>> [0]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fbpf%2F20200904135332.60259-1-bjorn.topel%40gmail.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sLpTcgboo9YU55wtUtaY1%2F%2FbeiYxeWP5ubk%2FQ6X8vB8%3D&amp;reserved=0
>>> [1]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F20220317175727.340251-1-maciej.fijalkowski%40intel.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OWXeZhc2Nouz%2FTMWBxvtTYbw%2FS8HWQfbfEqnVc5478k%3D&amp;reserved=0
>>>
>>> Björn Töpel (1):
>>>     xsk: improve xdp_do_redirect() error codes
>>>
>>> Maciej Fijalkowski (9):
>>>     xsk: diversify return codes in xsk_rcv_check()
>>>     ice: xsk: terminate NAPI when XSK Rx queue gets full
>>>     i40e: xsk: terminate NAPI when XSK Rx queue gets full
>>>     ixgbe: xsk: terminate NAPI when XSK Rx queue gets full
>>>     ice: xsk: diversify return values from xsk_wakeup call paths
>>>     i40e: xsk: diversify return values from xsk_wakeup call paths
>>>     ixgbe: xsk: diversify return values from xsk_wakeup call paths
>>>     ice: xsk: avoid refilling single Rx descriptors
>>>     xsk: drop ternary operator from xskq_cons_has_entries
>>>
>>>    .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
>>>    drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 27 +++++++++------
>>>    drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
>>>    drivers/net/ethernet/intel/ice/ice_xsk.c      | 34 ++++++++++++-------
>>>    .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
>>>    drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 29 ++++++++++------
>>>    net/xdp/xsk.c                                 |  4 +--
>>>    net/xdp/xsk_queue.h                           |  4 +--
>>>    8 files changed, 64 insertions(+), 37 deletions(-)
>>>
>>

