Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8259D68E674
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBHDIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBHDIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:08:53 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2087.outbound.protection.outlook.com [40.92.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCD224C86;
        Tue,  7 Feb 2023 19:08:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xew1f1q3QHbGNFt1zOPquC8qF8pJiKyq56d8Rt9Jyrbw0B9i5j/YOn7LDcRnnbTYdrnqfG9mzdfbDz4nnqvjyZFvfdMg8m+FR74tpCcEH/SxTawzkkeZK+/owlnCb9Y2NNpvB6N7Bary692Uud6006li4I+6FR8wJsmSYVXkW5ppTD2xkveA6R7Xg4YuKoPaofZlz6Oh2UOkKMr74Uiyd3zHaTYaUEoE8njZBPZhLEyVMOP/C+l9B/U+NmoFJm9jVRwBMcPJtMowcJSnbdkK5TEzP2I6QrfxjS3y6beB52BtcvP4V0MF6+WsX6348N2aoQOY1R6DiEyjudngvWN6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXZFFPj1KSoglBgH/1sb6TZL/j2Sgo9KPffVwzB/KHM=;
 b=ZDrhNvYV/l2fZTJZEfVTY075pQicIP4C6oQAgiFH3IGCdu7tPJNFMsCuCD0NzeQ+v1UUX4BsgkIgB4Gj83ypLNVw0KmnEl5iI5ShNYqEdySN/n3Rs8Ci4J0lLkrbld6TCpHF8Ng5aIdY/IdBrHNNE7YC2L045F6TxTj0FPjd6n1+J4xw9mTdZudGmCdxwKyiQ0PZtBZzupCO676acSyS6CS701/+SQQJ77l/srOjNXKfcdUHm+iTylQHzQqeXsDYKBerbEx/A2xRMyl0fhhA+4O8p3BZ6DAbXr9dOkfSt7zftg65+1QREu29emW/WTcKlj0GPBYb2CkHQrwrR3jMjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TXZFFPj1KSoglBgH/1sb6TZL/j2Sgo9KPffVwzB/KHM=;
 b=RUHGlhvScnwg+zyfcG8Mz6pu+J8kP8boSZBRe3KIJgfQTqIoMcgc3jGCuJ+6HcCnJsNnkHDsGGHV3Ow6kkjv5dipWR4k3Ns6VQBCfFlLrl+SkZsTHinbzauO3OY0IwjBwGwBGlqsZn7PtcX35cEAg8To6drjJ6vzDBiPdB9+3xll/3psT1X0Ga0m0nprCc0mNOpwtBYb3pHX4oQ6qrxIvlqCF4hs5AXqb15V6H9fwLt4QRbXZEhuz3Bm+gkPnv6ggVd8xNSzGU59ZAJC5LztAnPDazlXzOWYSSquSsefXDoPbX68AQBZBtkfLUdUm5E0/BjzaPN2Q8SFHEPwYlVVng==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB1616.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:161::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 03:08:47 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 03:08:47 +0000
Message-ID: <OS3P286MB229533DAC2CF9CE98C54B428F5D89@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Wed, 8 Feb 2023 11:08:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: remove unnecessary vlan
 init in key_extract
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229551D6705894E6578778DCF5DB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y+KIr5Pwlpoy/sn3@corigine.com>
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y+KIr5Pwlpoy/sn3@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [0b/Asg8PzFJoq5tFbRNU1QoGdW5EjVsl]
X-ClientProxiedBy: TYAPR01CA0204.jpnprd01.prod.outlook.com
 (2603:1096:404:29::24) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <833d2808-e35c-9b4c-823e-c01195b3f1f7@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB1616:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c10686a-d01e-4547-f54d-08db0981cba1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WZeoLUR4lZtaXO+G6eSIE625R6aUAcgJ+ef1mhON54+APKaSWyweO1+9FekGUCjNpUaftG4DyLCPchE/GVD9CH/IkqLKze30+kRTEVtvdaCMBBNRDPW95R3ffvqYx3xmbMAGchJsRhW1+ufP0UTRqtY6kvbzQ1BmHclfmlVSTc9kxiM2US+ximCkqPY4k/OfYLYbwi+tWC6oTznJP4s6+Rvdt+NacsanTcTwQo7IZovFipcRUwJMy3uyqEhLfb20Qt6sKOPm9SeVIma2Ya4gNuFoKxDSyNnFn0p+qiULAlY/RYNdfk2oIA9TU5QMtFMrtrmaH209lZbmVjGWgHgK/Ff9o4PHnm8hDjWLZiPdzsiD+r8F5hDgC5Tw1SOLp4DSw6dKQFyZ2BbCKU5jmFcQLkQe2dhMpVy0hyZqwwUeaED55wRSTsikvfTv365V0M42KZS8toENmjxUUrqMAcTuQMbt6RfXWBN/ket4/YAF/Xc7gk5tWSSQfkRwclYKpcVdopJnPq5w1GmcgFJdqo8yoQ3h30uwDZ6fv4ENbwJkjgjQm7+xrsGBLtyGVFJHqLQgbAGZP8VzQbl4kPBpYU/6scdrmIvuPpaem9tLWcU+cSrcmpYeJlrAJ5Ma1lfoxbsqNgIi60uet91xmn+2Na/E0g==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3pVUHV3dlM5ZjJLSGxoRGt1MUN5Z0FZOHltcnpFUUFNNVpNTHpOdFN6bjND?=
 =?utf-8?B?UjdRcnlaMlIzRTIrYU55VzkybFNQcVhqOFJZSFRwTnpYZktSaVdYcE5RV1Vw?=
 =?utf-8?B?NUdVeXJGdzhjcUhiekRxbzF5L05YWnRxSnpCMmhJdmZZZzBKb3JZb3BFS21S?=
 =?utf-8?B?emhYSUhUdUNpWVdNVXJIT1Q5eDk4ZVJPN3VEcXZXNXdrclB1V0h5NVY2MXpz?=
 =?utf-8?B?QVJTcWRFQVV1UGd4U1NFVUJvN09HOTNMVUp1T2QwbVcxZjB2K1Q3aFZYakhz?=
 =?utf-8?B?RlZldDYwZjJPSGxKb2dZdjhoZG4rdDFZbmJ0WjV4RUMxdnh0ejNaTFlvbXlW?=
 =?utf-8?B?VzdnNzdKZzVCTm5pNWJPWE1KakFoMzZjWmlpd2NmNXZvNEJLNWlocHRUZ0xY?=
 =?utf-8?B?WE83R2hDY0doK2t2andKT1J6MlNlRGc2dHVVejlVTnpPSDY2N3JpWmhJNVVu?=
 =?utf-8?B?MGVqMHo0dVJJQmlJTi9xSVBPVDU2M1JlMFB5TGpwRC9BeGNOR2tnRGlNMkNv?=
 =?utf-8?B?eHFXeTM3SWk1bFlsYU0rWHlDRy9qRHY2MUd1NlNlRVZvQ3R2MDNXeXVBRkhC?=
 =?utf-8?B?RzZrTU9kaHRDUlNRYndnNzR3ZEVJbTlHaitsTkZOSmFIcGc3WTNCYlM1cWRH?=
 =?utf-8?B?MHArTlhORVovRWFvVllVaWR4bS9qNFB6L3FUQnhuS0xqbzlnZFpvb00xOHo2?=
 =?utf-8?B?UHNUaGZVcDZLd1ZJRTFoejVncFdtTTAyTW1GQlJHQXRySTdhNXFXZHp5WTJv?=
 =?utf-8?B?TTA5Wk41N244bUFZQUlpUGRheWppNzZNVHc1M2FSVTMyeE1hcUVtK2lHc1Fs?=
 =?utf-8?B?SU01MjhCNjltaHFyNjZPTk0xWjJJMkdTTWpjYnlsMEtoME1HZUxRZWM1Z1VP?=
 =?utf-8?B?UTllei9VTzd5ZTYrLzFqQzl1QWxjS2tVdlhrSEtSNVJ6L1hNVVVtaW05Sm1u?=
 =?utf-8?B?K1BSOXZWb1dtV0FqLzBzOEY3K0lBalU0Z3ZNcWJUbUNYVzVkS0Q0dU1IWWdX?=
 =?utf-8?B?Sy8rREVZL1FsM2ZsbWswcDc4NzdsT0tNNVJyQjdvZXBmLzV0dnZ4dVMxUUl0?=
 =?utf-8?B?cllJbTV2akdpV2ZzQy82SzV4bVJqRWxkbVl3OVhDNStRNXRJTnhUdHpDWE5E?=
 =?utf-8?B?SnJhRGhFWDJYTVl4dDE3ZHdxQjlhMnNCaXJzbndGa01yZ0liZlJ2SGtmVE1O?=
 =?utf-8?B?TnNuVlVOMmhFU0E0UGdPOE1GeFJDY1lFZTlQSmtzNzVjR1JUOUlUdGpoR29K?=
 =?utf-8?B?dUI5VkpqdmZub2ZKME9lWnp4aUNxL3c0dDM1ckViaVBSOEEra0hyTU8zZTZv?=
 =?utf-8?B?Nk5GUFlBWWNDWVVPM2x1UFZRKzFFa0FhbGg1RHl6ZDVsbThHRjFzZEVtT1po?=
 =?utf-8?B?ZklrRGY0d0V5bXdXWEpBcjRkUFA4UGVZOEVacU05dWtkTnVuYmNFWEZYcWJW?=
 =?utf-8?B?UWpPRlJHMFlkQVV3a2RTVlFGUEtmVk5oNmJkeGdFTHhDZWsxMVdSaFhSNFdW?=
 =?utf-8?B?RHNKeWJ2dXJkUzVNNFA1amZrRlFmUGR5VmlhSkJycGhSZkpQNlAzRlB4MS9Q?=
 =?utf-8?B?SDhMRFgrbW1NeFpOOHZsNy9FVVY1WkZnZTc1SjcwWk85akpHUU5EUkZiUHBo?=
 =?utf-8?B?MVAzUnBic2ZyTE5sVjBqcVRYRVVWTFlSazdwZTVZN1RXdUs4QWVPRXQrQ21p?=
 =?utf-8?B?cWZrRDI2OHhqVXM2T2dBSGVoc1RwRC96UCtQQ0hwZUdLSlFCRmlYKzZ1L2Nw?=
 =?utf-8?Q?tq9SxgBUHuKofLXxZ4=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c10686a-d01e-4547-f54d-08db0981cba1
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 03:08:47.8001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB1616
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon:

     Thanks for looking into this. by looking into the compiled 
instructions, i am convinced the patch is logically correct but not help 
in performance, and it adds complexity,

Below function is actually optimized to one movq instruction with no 
special -O settings on my centos8, which seems good enough for me

static void clear_vlan(struct sw_flow_key *key)
{
     key->eth.vlan.tci = 0;
     key->eth.vlan.tpid = 0;
     key->eth.cvlan.tci = 0;
     key->eth.cvlan.tpid = 0;
}

optimized to movq   $0x0,0x158(%rbx)

I am withdrawing this patch

About your comment below, since it is after the parse_vlan handling, the 
code looks fine and does not affect the logic of the patch

 >>I think you missed the following case further down: >>>>if 
(unlikely(key->eth.type == htons(0))) Have a great day

eddy



