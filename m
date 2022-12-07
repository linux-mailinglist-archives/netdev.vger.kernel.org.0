Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F516458C9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLGLTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiLGLTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:19:18 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01olkn2106.outbound.protection.outlook.com [40.92.65.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBED2B240;
        Wed,  7 Dec 2022 03:19:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTZ30kMzq1mxrRDw0p94coAdTyfHiyK5frEiMdpXPgE0ElxK484MndvG7fTF85791Bm/ueFXwtSAwp1hlh3THuAO9tLqKiKfDOBfZbtmVbc3BcXUaXIMqJRSEEUhkennxUrEMO+ATpat57UZtXbMv5PbHo1czDrf7rgNXuuDTVLbFVLKMnWVQGjjoL6txQJ8gcF0uS1fZlgE4nmtQCow8BISfQ1gZRTdSpmBlbr3NtX5yOjhQ9OHsiMNVb2QCB2pqapbPZkCw89Pe2x9+SkujFFpm3NA8u5n4FAqQos5NVMmwuVR8SxgOU4subk2JIB12+H/Rj4QqtII0FIr5hbduA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBfAqGEhZXwQ6K6DDESveyOex8gfR/VhSQjdPa6Uuak=;
 b=PdEkv8Yl60z0xPM2cZt4j9Detd4wzu3DyA/Zz4Y8C6+r7NR9Fef5B+HcEtPKFgyMcD+i1KnYPxEE8vwM5cieGRuTmJPQDDsezRLYL5AhEkBUMo2zq47BD9GuO6lqZS9je4sveGF5uEl4UtRPYeOvJ1C2KxQqHJdjVz50Igx7gZO02WSbFWDe9r3g3k4b8sGrl3TnlGx3Ycr6mdn74LyUgQSgXb/omGJiN9X6kGNmiV0Ubw6J2xhn8RqURv2E7bVV/ZwCEa5YERMbsgm1UP6E3K8sC4Ht2ZSfeKAqNFORNY2bg+uFXgo3/qizibx9j2J3XhQW7h0gbhJs11tnj3SL5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBfAqGEhZXwQ6K6DDESveyOex8gfR/VhSQjdPa6Uuak=;
 b=aWgOQF6v4gxDWXeHSgHVrgIPpXlPXB/8hZR0XuSgqCiY+N+ybVEVzSAe/8a6DZI5GBIIgXN9ADT6XdbXHP6MmZZlA5DNaR/eUsHWiOxjCWOvp5tqDsZZzkF8CFQvJAGbpjwShKk8oBlFO99yQrNGe6a6zTgfqVHuhLZyFB58pCmvMWyapN5GFWNARlhHYImiCnURmarEbH64LIqcOcwGizuklkJv9T0fKe/n3MRKPFGXCTWUZ0vcFEyNVm+TIAG2sT4Kyg3MFo3FhD2XfdLm522KOVglVRCDyWIQVqMj9NS4yja+E02fhrUaWBOB05mDiJIS31LrTWnQoFdvXJsqYg==
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
 by DB8P192MB0823.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:165::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 11:19:12 +0000
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b]) by DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 11:19:12 +0000
Message-ID: <DU0P192MB1547DA9F22139A0B09FF5877D61A9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Date:   Wed, 7 Dec 2022 19:19:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Ji Rongfeng <SikoJobs@outlook.com>
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
 <deb77161-3091-a134-4b82-78fef06efe85@linux.dev>
Content-Language: en-US
In-Reply-To: <deb77161-3091-a134-4b82-78fef06efe85@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [4Sq5dvk9ZC5vE6KKvSddkVjXqSVKAXff]
X-ClientProxiedBy: SJ0PR03CA0351.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::26) To DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:34b::15)
X-Microsoft-Original-Message-ID: <7901fd2a-e6d5-8176-73bd-b910f8abee33@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0P192MB1547:EE_|DB8P192MB0823:EE_
X-MS-Office365-Filtering-Correlation-Id: 3020054a-df48-4339-7839-08dad844de09
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzjwEWQ54CvsIk8PtIQrvt10RnM0vExkm7AkFUTyZRdVESSCTOGwrohPyLw433pvcPJ8/Q0ahbOLN5MmcJ64g37rMgTkm+QS+hNKISRIyI6rjbKIzPLPvW+XHqmRJ1EWITK8LJ3wa3Bw2eRQjLW+lUnHlZMuvMxQLw5/BPDU+lFdGDOMCtm6ojR8ol0Rhph2Rl/yYif5NTiEhY75FXk+9Yhh3l9r7i5zF8pP7T6WtVDtQFvH2F71GLag/uSzF/cr8p14PN1WtSBG/8kxZXOgbDO2pLx6+1CLIlcbIBh0dFzukx1zLxLRX/8NmVCS5SeQFHULzRrU8OgS72Umcs+c8yPf+QJeXKbgbXbJ99pCmkf1HqKrf+7j4PcF4ghrcENDncfnlDsLAsgjdtAIiM+E5xnnIW9OXVPbcme1MeG8tWy9oYdUBJ1B8tsTQb258CPNoAl8jAes/SVbL0U7jTaOc8vKf3UypeIyDO8kDIgB3JlVRgigvxGWJ9wFnvyjus3c9RJCyst61rf4ctEaKdGGeMyAA6oef/8B35G7+EpKq8ajJsjGqnH6clgWFSUlFPDhUWkzpg2+uB4XnU192BBVPtshMpZBaLtoumu4DKtk10IAzA7w/GCzBX7JTROZiQc9Up3xIZ4+27e55Y52KiqeSg==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c25sQUlxNVN1WnZ5b0E0NEl6SGZGVm93N2dScVBlcWlqS1Q2NHNsZ2dKT2pp?=
 =?utf-8?B?ZGVZMGtJejN6cmpRS2dEOGJoODh5NHB3YllDMWRFNm1hSGdTU1pjbVRuUmdZ?=
 =?utf-8?B?cHQxRzVxbjRpTlNQVU52R3U5TnVYcDR6TVFucGxiWXZmRFNaYVlzMXIydUt6?=
 =?utf-8?B?ZFhjYWQ3NlcrMFBoRGJnQnFFVGhCOFdodGJaUzNtYVl3RElpUHZrcnJSTk1n?=
 =?utf-8?B?VFZHV3ZRYkU5NVhqZnZsVDlMMnZkUXB3MkZ6aDU5UGdrRGFRSWJ5YWJoT09K?=
 =?utf-8?B?aFJYQ01xQWZkR2lPQnlLb3ZnWXdubWtRNEFrenlxL3RpR2RxUWlhNCt3dXJm?=
 =?utf-8?B?QmxZMmNZV20rTFNLOE9jSWZSQW1Pa08wNXJxRmR4NzNkSFk3YzVPeGhIWFli?=
 =?utf-8?B?M3kzRnh0WUtvTWNOd3RwWnB6Mng1eG1JdWZZeEgyRWZaNEdoMnhhQTk2czdq?=
 =?utf-8?B?YnhjaFVPc2dvRkt6TzNTd1ViY29jRDFET2tHWjRpQ0FidmxpNFhTUVhFSjlS?=
 =?utf-8?B?UmFNSDAydjFBeE05WS8xRGpHNGZYenJoalRIckl5cWQxTkdPQzdzbE1CUVBt?=
 =?utf-8?B?QkU1OTFJeUdMbk9QTVVRVnUzYUx2YWJ6VDJ6QmVqa2ZZRDN5bGpSdG5qeHJR?=
 =?utf-8?B?aFEybFpnRXE3T1Q3Nzc3Q29FUmtBNnJaMEs0cExJajh4KzVDeGxWTzR3NjZx?=
 =?utf-8?B?R0NOQ3hGTmt4Wk1DWGgwY3lVcktMalJwWkFEMDdzeGVQeXc0T0NZVkpKNjdD?=
 =?utf-8?B?YllnZFNZUWZWQ2JyRlZoMXUwbnd5OUJDamNvZ2M3bHNvY1dBbGdIMGVwWmRQ?=
 =?utf-8?B?M1N6bm1HbU5QeFM5YjdIRXBGUUI3dW9zcEF0ZitnTUFTT0ZISENGTk5DTncw?=
 =?utf-8?B?SU5UZ0ZSdmhKczVuUFRoekg2cXRqcS9ZTnpBWjVhUktKVDloWnBqbDI0RzVP?=
 =?utf-8?B?cUovWk9MZUJuMi9RK2NUNlk0R213dG9adENQWkFjV1M3SU1Fbmk4V3ZHY3d1?=
 =?utf-8?B?OUdQQ1dtS3N0bjNGL3M2MFhQLzVORitjTlJUSWc3ODk1dHQrWVU1Zkw1NGht?=
 =?utf-8?B?bTkvUVNSK1BIbC9HaTZKYXZ5NFNBeVg4MU05eGZSSDV0R1B3MFBBSVArdnR6?=
 =?utf-8?B?K2Npa1BCMW5uamtGdmQ4bGdVUllxckJJMjZxTUJYS2lzUWRFdDBtdXJ2RHJy?=
 =?utf-8?B?RDc1WmpDMDRlN2RWN2FrTU5iOU0xNHRycjRJSG9YZEhQUStLblM3MzFPQkFE?=
 =?utf-8?B?eGQxSyt6TGlaL2crTzZ5OFZITmhWS1R5SFRQZ2hYdU5tOTRhNXNmcHRtQTZH?=
 =?utf-8?B?WjZ0RXZBVnlKazNpenBGci84NkwvMUluVmk0MFdqb2w1WXZ0Y1QzTFNaNmNh?=
 =?utf-8?B?UzNhNVlBZVBTaEJ1VUxrWnV5cnlSQklXVzZnZlM1VERmcUxiaVZNelBRbkx1?=
 =?utf-8?B?b2d5YUhwTVpBS0JSZVhuUGJoVG5QZ1dvVDFZNjI5Rlo3UFZlZGJUMENiL3cw?=
 =?utf-8?B?bkkwdnBGeXlwNnRFRkdNVEhvb1c2dWI5NE1rZW5FVVc5bHlac1F2enh4NkVt?=
 =?utf-8?B?eFB5UHJvVVpZNHMrSWg5TXdrMHFlV29wbG5rbmczWEFMV2hqN21INFpDV1FI?=
 =?utf-8?B?U0xxaStUK3d3YnNuQnlxTHZLWVAvOWRBbUxLYlM1UjAyUDhuUWlFUm9kRGR4?=
 =?utf-8?B?STJYb0JqTzV3UlNlVWczUFEwdGdOaWhtc1JVNjQ3djRkVHBqSmlOTlNnPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3020054a-df48-4339-7839-08dad844de09
X-MS-Exchange-CrossTenant-AuthSource: DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 11:19:12.3071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P192MB0823
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/7 2:36, Martin KaFai Lau wrote:
> On 12/2/22 9:39 AM, Ji Rongfeng wrote:
>> Returning -EINVAL almost all the time when error occurs is not very
>> helpful for the bpf prog to figure out what is wrong. This patch
>> upgrades some return values so that they will be much more helpful.
>>
>> * return -ENOPROTOOPT when optname is unsupported
>>
>>    The same as {g,s}etsockopt() syscall does. Before this patch,
>>    bpf_setsockopt(TCP_SAVED_SYN) already returns -ENOPROTOOPT, which
>>    may confuse the user, as -EINVAL is returned on other unsupported
>>    optnames. This patch also rejects TCP_SAVED_SYN right in
>>    sol_tcp_sockopt() when getopt is false, since do_tcp_setsockopt()
>>    is just the executor and it's not its duty to discover such error
>>    in bpf. We should maintain a precise allowlist to control whether
>>    an optname is supported and allowed to enter the executor or not.
>>    Functions like do_tcp_setsockopt(), their behaviour are not fully
>>    controllable by bpf. Imagine we let an optname pass, expecting
>>    -ENOPROTOOPT will be returned, but someday that optname is
>>    actually processed and unfortunately causes deadlock when calling
>>    from bpf. Thus, precise access control is essential.
> 
> Please leave the current -EINVAL to distinguish between optnames 
> rejected by bpf and optnames rejected by the do_*_{get,set}sockopt().

To reach that goal, it would be better for us to pick a value other than 
-ENOPROTOOPT or -EINVAL. This patch actually makes sk-related errors, 
level-reletad errors, optname-related errors and opt{val,len}-related 
errors distinguishable, as they should be, by leaving -EINVAL to 
opt{val,len}-related errors only. man setsockopt:

 > EINVAL optlen invalid in setsockopt().  In some cases this error
 >        can also occur for an invalid value in optval (e.g., for
 >        the IP_ADD_MEMBERSHIP option described in ip(7)).

With an unique return value, the bpf prog developer will be able to know 
that the error is "unsupported or unknown optname" for sure, saving time 
on figuring the actual cause of the error. In production environment, 
the bpf prog will be able to test whether an optname is available in 
current bpf env and decide what to do next also, which is very useful.

> 
>>
>> * return -EOPNOTSUPP on level-related errors
>>
>>    In do_ip_getsockopt(), -EOPNOTSUPP will be returned if level !=
>>    SOL_IP. In ipv6_getsockopt(), -ENOPROTOOPT will be returned if
>>    level != SOL_IPV6. To be distinguishable, the former is chosen.
> 
> I would leave this one as is also.  Are you sure the do_ip_*sockopt 
> cannot handle sk_family == AF_INET6?  afaict, bpf is rejecting those 
> optnames instead.

-EOPNOTSUPP is just picked here as an unique return value representing 
"unknown level or unsupported sk_family or mismatched protocol in 
bpf_{g,s}etsockopt()". I'm ok if you want to pick another unique value 
for them or pick three unique values for each type of error : )

> 
>>
>> * return -EBADFD when sk is not a full socket
>>
>>    -EPERM or -EBUSY was an option, but in many cases one of them
>>    will be returned, especially under level SOL_TCP. -EBADFD is the
>>    better choice, since it is hardly returned in all cases. The bpf
>>    prog will be able to recognize it and decide what to do next.
> 
> This one makes sense and is useful.
> 

