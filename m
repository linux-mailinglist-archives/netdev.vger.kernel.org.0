Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF24450D784
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiDYDbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbiDYDbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:31:00 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2136.outbound.protection.outlook.com [40.107.255.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E04B1D2;
        Sun, 24 Apr 2022 20:27:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDA2LAVCYgNKaOoWz9omAQT5JSi6A6BxqqHkxIO3kMfc94JKwRXsS0FkUMivbdfIjEuSG5y+1cb9FBKNmtPkLJf8kXgPdjv8T7bkeqxPJ7olIUS+hAjuI3QK4Hzi3YzIKUxG+oKeoByB3g9c9tb68pC/jW/VaPquELC9RDBN3+QdsCygDop+hwByHA6Bju2oKyP6lNzxIf5LKyzvckAPLPDKDbuZ/gfRi6vIvezdEsksGQWxJqrsQzvceP/eYDBi2Z+ZhnjSS2822anSttkpSyT0hVVL9PoIP1oMO9oMpUZKCgCUBqAjFCIU63EOZ4/ZCVePFSQZdwGPVhetxPYTuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAtlWiVY074IN3pdTHcUvGOVrdkmqr1rwdcIPZ3kxbA=;
 b=g5+uAeEwu13uTvJoSVT5gCBP+uWta6zsD1TjPOjhYCFi/4N6mUu7xZneMVDZNiaR8p9/VRMAOURa8lZOLX9V5cWX5MPYkYTiF7A7o2RAPix3wTwieTeEXnDj8EfY4E/OXtCOfnqObYlTteQlfAhS4SDdlpCc0zToHXUPOKsCxUsaoqTkj4Qj5HIMtnYtS+weCrIXsDdJW+1eYqK3sJaZskcbb5iKfBwb26CovxTNvxRL8w1DDrIbylYZiVNxNnTOtMj5aSlhhB9HeK7cUT2KN/UW3QI1v1Sq+ZKV9xIAUFJ3qrn4WqM4jJU9yLyhxbdN4dcpVOjyfxxgryjugr3EjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAtlWiVY074IN3pdTHcUvGOVrdkmqr1rwdcIPZ3kxbA=;
 b=EBBUh6m2UNzMhb7b4y33XBG++5QFwMrASHaiUJP+PionK/OUREne5UWpF3Ou+bXMYyNLf1oKflPLSvpYmQD9Gp5eo5p1fFfv6aN3+GotL63O9cwdNr8rtM6AP+w7vWeVreU/outkl9bwqcHlYZ6lShyEKNlLowNWKaFgey9OANY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TY2PR06MB3374.apcprd06.prod.outlook.com (2603:1096:404:a4::10)
 by SEZPR06MB5342.apcprd06.prod.outlook.com (2603:1096:101:7e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:27:51 +0000
Received: from TY2PR06MB3374.apcprd06.prod.outlook.com
 ([fe80::b13e:aba1:b630:a14e]) by TY2PR06MB3374.apcprd06.prod.outlook.com
 ([fe80::b13e:aba1:b630:a14e%3]) with mapi id 15.20.5186.020; Mon, 25 Apr 2022
 03:27:51 +0000
Message-ID: <6568e274-a013-4ab0-2c6d-228014e605b5@vivo.com>
Date:   Mon, 25 Apr 2022 11:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] FDDI: defxx: simplify if-if to if-else
Content-Language: en-US
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
References: <20220424092842.101307-1-wanjiabing@vivo.com>
 <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk>
 <YmXMcUAhUg/p1X3R@lunn.ch>
 <alpine.DEB.2.21.2204250009240.9383@angie.orcam.me.uk>
From:   Jiabing Wan <wanjiabing@vivo.com>
Organization: vivo
In-Reply-To: <alpine.DEB.2.21.2204250009240.9383@angie.orcam.me.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To TY2PR06MB3374.apcprd06.prod.outlook.com (2603:1096:404:a4::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ef73cde-66c9-46c9-3439-08da266b93e9
X-MS-TrafficTypeDiagnostic: SEZPR06MB5342:EE_
X-Microsoft-Antispam-PRVS: <SEZPR06MB53428C4A359D288F8D313CD0ABF89@SEZPR06MB5342.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e42obSmyDihsmaa0CINW7KbPrmmYYHS8Rm8ZGuMBA9+M46Df3/KP+rOOXrOfFzw9Ww05zjS3T+ViIJqwFvqlTxkEg/W4aUnGtjkYrQ1IwmtvZB9y9P66ylNtFtM6aAB6e6Gyww3gCPADOgCWfZgNtAwrUAWXalz4GGkSqGLbtUcgCtel9RQKOPbcFons7qnUqJMFw5gOvQLYfRFyui2yO01m+Ru86YtoLmByk6q5cGW/buAJm36v2FyVNSAtUXq6sg+Vxe00b5ZAl2l10thj3Cf1Q0Z90R0O4DptHTUstHb9J2ku/i1I7e3SFKpTUi0S4WOVayM24Qc1aagj83p0b4U8VER4QxNCPwh36NlSkGovtxwcsD+H1HkshGlJli7g94H6UeFPPfH4BsfHCs04ag8TU8Zqg+2iuxYqKRrN018LJNLD6ySxNkI/Qaw7K5dGpyF+2UqrQZ3mD+VobprlLxonrOnYn8C0CA/qzG3nuASgumFbBX6jbDKIsrBQZNqI9Cpr0eGJoywN98FCj88zdmuwGdbBLMWYD7CSQBRh2ptXGdsXgenEaoABO3nm9v4pOVivI9Pq7njLoi97dfMJNgLKX2KM4V4RLUcdWosurv8jwHTwHgvqYTUiNaYCIyIWSrz2xKs35bseZHg8w8a1F7N268rnSkNO6aPLeD5kYoAWaTcBZ8hOnhDHqcOz6ZuVLCmlR2YcPYc7NFDF+ydF3GK9l2K/CxOama380g3sDSFetxq0KPK4EoKDktFSi5eV/H5J8+KdGXzqtmOJmMJrlkjLGeLK7CZwxSP6+DQe+9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3374.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(508600001)(316002)(36756003)(5660300002)(8936002)(110136005)(54906003)(31686004)(186003)(49246003)(38350700002)(31696002)(8676002)(86362001)(38100700002)(66476007)(4326008)(66556008)(6512007)(2616005)(2906002)(6486002)(83380400001)(6506007)(26005)(6666004)(52116002)(36916002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vi9QaCtsMkZ6UnJ5ejN3ekQzTStOOGhpVkp1djQ0QzR2UC9ObVBsd2VWWlJ0?=
 =?utf-8?B?RDZkeUR3RnNDZzFVODFwcFl5cnI5Sm82R0l2RzdKdU5VYWNLQ2l0YnU0eHJS?=
 =?utf-8?B?ZjNEVk8xbEhadkd5cXE5SDNIOSszTnhlUzkvbHpGTE9vN0NUeUdvelpvTDNQ?=
 =?utf-8?B?YTlBUGR1aU42Rnc3cmRna0xVZk9CODBuUGpzckIwTDljSnh0MTVVeTZsODZq?=
 =?utf-8?B?K21vaWhYeVJ5VEIyUUpKSVgyN3A2eDIvMlZUZmdzVkp6N1JyK2Rqai9XemVm?=
 =?utf-8?B?UXRySTY5MFV6V1VRMTVuaHBRdzNNOVptemtieXljNEFLOTJYajZKajJWNWpH?=
 =?utf-8?B?SXRWUlVRd1VqTnFGeE52Zk9PNnVLQjlNSzNMTUpOZHo1K2ZYUjJiSWV5L1Ir?=
 =?utf-8?B?SHJMNzlBR2dVdGllMHlLbUhqdWN5bDZEcElyY2czdEhHKy8vYUVuMGdQVlBT?=
 =?utf-8?B?YlZjcFhkblFQRGJDVSs5dUVUQnBJQVFueDRGc0lsZlEyU3pOMVM0RzlVNTZ0?=
 =?utf-8?B?aGVTSVlBemQ0OUxoZXZhVDNGcWxLUm1aL2tDK1hQVmt0akdXMmhTbmxybEVO?=
 =?utf-8?B?NVZ1MEJ3d0NIY3dpL29LeUhzMC9XVk85Unp0dmRlTWRCQ0pYTXpYUWZyOVZx?=
 =?utf-8?B?RjJJNXRTSElFWkk5NWJab2lTS3dveUFrY3hGeXlkRGlLNXQycWtTNTd6blVv?=
 =?utf-8?B?NWJvbkc3WExLakhGZjA5Lzk1alNLT01LYmM2Z1lER09xMU44c21mcFNaS3dl?=
 =?utf-8?B?aDdQdlR0UmNDVzdJUzZSWkhmbGliampEVVF5c2oydnhnOHl1dVJSNDRIUHkx?=
 =?utf-8?B?MXA1VDllbmZIT0JpdzZhdWlkOEJBeDNYQTJsSVZmYkV1ZmRwYkM4UlB5ZGE2?=
 =?utf-8?B?M0hrdzVTakl5UFYwKy9EWklINUZVU0dLcHRrMHRRTUJnNDd0dzQ2NU5MR2VL?=
 =?utf-8?B?eEdUK2xXaUJ1c1p3bVA3UWZ2U2NUMUZSR0RlRmJNa1NGY3pCTkQvdkg0cDBX?=
 =?utf-8?B?TmlybjFDanZJRXdMc2RRS05HTTc5UXliWHE2UUtZMjkwbUVKd0RiejBkYVFF?=
 =?utf-8?B?Vm8ydE1ybWhPUisvckVoT2FUUjY1Wm1qTHlTREJKTVR6cXI1NG5zdzFzRmYy?=
 =?utf-8?B?T05MMTZ1a1FGMnhiODhneDJGK0hVVG1HZ2s1TFBJc2tRamp4UlFMaXVVVGNy?=
 =?utf-8?B?Y0xlL1ZJUEFuRXduczRmc1lmdGg3MzEzSHU1dlVINzlnd3Jrc25PV3BWaU5S?=
 =?utf-8?B?WFpwK3p3OWR4OCt0Z01TLzBVdVhUZHJOOGNjVTZjQmdtenhxK0ozNDg0d05v?=
 =?utf-8?B?NnhtOXQwQjUwMzZ2SDdlYTBFSDFVYjVyZCtkQS9lNjQvc2hSalZlTTQ4TVN6?=
 =?utf-8?B?MGhseWJJUzc3c2Y4L0N2ZmZaS2kydWhSU1FWQVJLaUlRQkkzNzNUNCtWZmll?=
 =?utf-8?B?VHVWZ0RRVG9Xb1VZWW9pSnFnNmhXRDZVZXA2SHptUlFkK1FodXp1ZkdvbXcr?=
 =?utf-8?B?QmtKaC9iUUw4SmpuM2VVZVpzWWc4VmpvbXhiS3hFRzFKSjM5ZW9xaHB6R2FL?=
 =?utf-8?B?eDlxekxGS2VWNEYydUZWMVdNZkgzaGxUZGk3RUlrVkhWZmNNUmM4RVJ5NGk2?=
 =?utf-8?B?VEdyZWlwcm9FZzczZTZXbHBVYTQxT1JJRjk5OHNxckJPY1YzdHpTa2N5aW1V?=
 =?utf-8?B?TU5XTWZRMi9mNzUxNEN2bWtTNjl1UGFHS0UyV0hHeUl4VDQ0ejZ3cWI4NGF1?=
 =?utf-8?B?c1UyY2NIVEdQVU1QWTdHNk9ReVJXZVJWKzd0ZUxCNzJkcFQ2ZzZoMnFVODlT?=
 =?utf-8?B?dVlaVWhITXBWaWFvZVEvdTdpdGdqd3BaM1BCNHBtRFRONHYxMjVMeUFaOE1S?=
 =?utf-8?B?dnVxdXJ6aG9Bb2lyYjM4MlZzM3dQSmpxTG9qMURRVkpXdGxFaTArK01CeWhm?=
 =?utf-8?B?d0xidDlpWDcwQ3NWN3NMd0xBZVZGeWVUaG50bitpY3MvMzl4VjNrSm1xaEQx?=
 =?utf-8?B?dUFza0R2Ukk0di9FdERyNzRqOUE5SXNhMThOT295WE9lRXNUdVlGU0dSYjM4?=
 =?utf-8?B?R0c3Rkx4ekRtZ1JsSkFyQzJmYm5XcDdCRXp4d2s0eWxwK2pOSm1ycDQ3em1p?=
 =?utf-8?B?T3ZoellKbFUzSm51aklVTm8zd1V0Mi9lTnNYSUZJQzJhNTFQSE5RWGNld09h?=
 =?utf-8?B?RnJhTm5iTjk5VVZhd3duOUYzSjh4UElVcHNNNCtlSjlaVzI5U0srNi9YUktZ?=
 =?utf-8?B?eDNXRE5kSkFvN0VuM3p4YmtrYzhvbzdHK2JCclNncVVKVkdGUU1vazRNbWk3?=
 =?utf-8?B?T1hocUNwV0htZ1RzaEJrTHBWT3M3b25UVDJuOXN4SUtSc3Z3dmk0Zz09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef73cde-66c9-46c9-3439-08da266b93e9
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3374.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:27:51.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7lVLF7XZPXd0MykHsdOXIOBxmRRpq81VDKY6oA2Bm4btf8u1O30QDxf9MncfoJVs79KE97w6dgG5ApLAngfUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5342
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/25 7:26, Maciej W. Rozycki wrote:
> On Mon, 25 Apr 2022, Andrew Lunn wrote:
>
>>>   NAK.  The first conditional optionally sets `bp->mmio = false', which
>>> changes the value of `dfx_use_mmio' in some configurations:
>>>
>>> #if defined(CONFIG_EISA) || defined(CONFIG_PCI)
>>> #define dfx_use_mmio bp->mmio
>>> #else
>>> #define dfx_use_mmio true
>>> #endif
Yes, it's my fault. I didn't notice "dfx_use_mmio" is a MACRO,
sorry for this wrong patch.
>> It probably won't stop the robots finding this if (x) if (!x), but
>> there is a chance the robot drivers will wonder why it is upper case.
>   Well, blindly relying on automation is bound to cause trouble.  There has
> to be a piece of intelligence signing the results off at the end.
You are right and I'll be more careful to review the result before 
submitting.
>
>   And there's nothing wrong with if (x) if (!x) in the first place; any
> sane compiler will produce reasonable output from it.  Don't fix what
> ain't broke!  And watch out for volatiles!

Yes, there's nothing wrong with if (x) if (!x), but I want to do is
reducing the complexity of the code.

There would be less instructions when using "if and else" rather
than "if (A) and if (!A)" as I tested:

Use if(A) and if(!A):
         ldr     w0, [sp, 28]
         cmp     w0, 0
         beq     .L2
         ldr     w0, [sp, 28]
         add     w0, w0, 1
         str     w0, [sp, 28]
.L2:
         ldr     w0, [sp, 28]   <------ one more ldr instruction
         cmp     w0, 0       <------ one more cmp instruction
         bne     .L3
         ldr     w0, [sp, 28]
         add     w0, w0, 2
         str     w0, [sp, 28]
.L3:
         ldr     w0, [sp, 28]
         mov     w1, w0
         adrp    x0, .LC1
         add     x0, x0, :lo12:.LC1
         bl      printf



Use if(A) and else:
         ldr     w0, [sp, 28]
         cmp     w0, 0
         beq     .L2
         ldr     w0, [sp, 28]
         add     w0, w0, 1
         str     w0, [sp, 28]    <------ reduce two instructions
         b       .L3
.L2:
         ldr     w0, [sp, 28]
         add     w0, w0, 2
         str     w0, [sp, 28]
.L3:
         ldr     w0, [sp, 28]
         mov     w1, w0
         adrp    x0, .LC1
         add     x0, x0, :lo12:.LC1
         bl      printf

I also use "pmccabe" , a tool from gcc, to calculate the complexity of the code.
It shows this patch can reduce the statements in function.

Use if(A) and if(!A):
pmccabe -v test.c Modified McCabe Cyclomatic Complexity
|   Traditional McCabe Cyclomatic Complexity
|       |    # Statements in function
|       |        |   First line of function
|       |        |       |   # lines in function
|       |        |       |       |  filename(definition line number):function
|       |        |       |       |           |
3       3       8       4       17      test.c(4): main

Use if(A) and else:
pmccabe -v test.c

Modified McCabe Cyclomatic Complexity
|   Traditional McCabe Cyclomatic Complexity
|       |    # Statements in function
|       |        |   First line of function
|       |        |       |   # lines in function
|       |        |       |       |  filename(definition line number):function
|       |        |       |       |           |
2       2       7       4       16      test.c(4): main

So I think this type of patchs is meaningful.

Thanks,
Wan Jiabing


