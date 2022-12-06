Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A014A644970
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiLFQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiLFQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:37:15 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05olkn2033.outbound.protection.outlook.com [40.92.90.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8897631219;
        Tue,  6 Dec 2022 08:36:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eoXPFSfvg3KXvZjiXr9VV4IOJ0gnxM+qO59QqP4CoaBc3tz9NRvtou66lponp5SxlFLyTKHg7xf/XXgWBNrrMaQ/KptyxcvJjmGiUFMwRHWwXtVjqztauXeh4yGBPXnzzz5l/IIEMBONBTq9lkt2IK6gULieaArkzyCxQ7UT755g93N9wl281vgHPWoCPzd1vAnC13O+nXrcxSoSyfvC2ykp/vOFP2GrhhRRbLgrNPdO1DgR0X9mykXZ/Mle+GgM5WB5mH59LbKeyKTEmyDRRxk3xc3T5tdtwcbOnRUMb1WQeprIhnOd3k4fUhsh8EQKFgZYVukEXYVwNKx2mBjJCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHGc7tJCyAKmW0iGIIhdwLC/B3p5nAc4v/7Z9moyA84=;
 b=TyRGYgiuVPw5D+Jp+nnqr8psasXk71m285NntBLu1XFDv5sccTUECfopafnYxoqOUuCoqjeG6lMvgZxuQUank1kHx4dqks62oNiYBqt4xjauvxbsVBZQIqsZo8CNoNoy3DIXynS6Wih89xCkgkWSyTtzgoeDb8C6OlOUc1lwSF9QB4hOpG48gAYLYglTykqE5wKwChx97lW3Jw7AHawFTWUjiVEpc4usCk3fO9h96QPCM8VVmz9Ac2+cMVRSWqgTqiYhv/oFKn39HaU45Lel60XhUApyORziMMOjllD5PMTNQ6qq+x1ZesJazHiz85uH+qg8/bhnR5Sh5OnjtvqCPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHGc7tJCyAKmW0iGIIhdwLC/B3p5nAc4v/7Z9moyA84=;
 b=Q2SKDfYACAnGI3lXnUIYnZxn00l/oiOY5ps3cRLQ8DneVxKeRsouhlM9ISKHZMfG0hyxfSmLiOF2sXQrMEsZLe7cnRByoSRErD/S2RrD2qNwkNr4G9jGvpCsC807KyGsmgoFlNqcxXcyRmX1cDIKr2sUW8kr/jFRh469nz7ogfVtE6NqWeFxMZv7miPEnQuyh5QbrP3TYoVatqVuPLoHRm0Yuzm0eSXr0yWEXdf64tZMrds6/hXWz/22o+I462R/URV1aVoxtpvC8oRrDV+cfwj8sN0mrAloE9XZ74dgYTV/7nrchLFLbUxRDGVmQnsOedrANHGIIXvf4+wQrsFT7g==
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
 by AS4P192MB1671.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:506::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 16:36:07 +0000
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b]) by DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b%9]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 16:36:07 +0000
Message-ID: <DU0P192MB154719A31758750149418C73D61B9@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Date:   Wed, 7 Dec 2022 00:35:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Content-Language: en-US
From:   Ji Rongfeng <SikoJobs@outlook.com>
In-Reply-To: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [rlAlxAieDMT+2av4wguQOhZwk4Q+k9Ps]
X-ClientProxiedBy: SG2PR01CA0188.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::10) To DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:34b::15)
X-Microsoft-Original-Message-ID: <59f3904c-202d-75ca-e7e3-7ee0c9d7692e@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0P192MB1547:EE_|AS4P192MB1671:EE_
X-MS-Office365-Filtering-Correlation-Id: 298ea64b-f90e-4031-9b30-08dad7a7f957
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo5VMk02+wJrNo7TjdjuClf8rRxFTcJ0ymPEO9H5QAUE2Ltfu9O8C/5EFovnfhANf2h/ySZ/79a9RZ0+tRr+Rjl51Lb/jBQOBDjbq8LRU2my9tc5/tnHQ9Oe5/Y5zaITNP10wZ7L4NP7HhL6o3TjJQKy113Mgce3tRAS7wnVrDK2iXadfqsqYtQ3UsVMOq9R+OALchiURLEUA5xMGYSRoRiCahu9liQaKNjo9hX7mcKnPpqZRspmksJHPPzZKOdNoLALl+I+jEUVgxahuCMfwHri2hLeI06+jqodAEzR6H1YlwZawuJHwB0nCsiJPo1F/6UFjCffn1BGIMDc8D2pjz1ctqfJAZROkeUtR7rcs+IO27iPt3nciyJQSsMBxxcGXCw8sqdHYFa2dvn/88Cgo4UDcOG6Coj/oQ2PME2WgAWQEFJav3LOotKhl4iZH3DIG/YGAtvb5eeZfzlqHIP9lz0KhiyLUF9j/qrnLlW5Xp+wSom6tvIZ4AcnIhSpUh0g2AKyRDdZ5IAsp/yCqIdl7GCYi30nAHaeMBAjrE9YXQnVeMRYsmBCv9OsLOdEyGtDDZeDgXfE4FP1cMP8hKWUZdkdEdeZnJ9EVoN9x3ttzID8moEYFRGkEWyUNLvUVmCv6QfpEz2vNhUHJ0njE9AOVw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0dBakRvMGFIT2FkWm8zSVVIU2ZxWlpsa2xYcGR3b211TExzTHNaMmRtUTF0?=
 =?utf-8?B?TWhXakNoRmZZVnlsSmVyNk14ZXFpUGlMOWlCYXVqSC9yVHpMNmd6dEl2YnVr?=
 =?utf-8?B?S1N5WTE2d3lDWUFnVTZOZmVnZk1XcFJvemkrd3dKYm5VZDlzcVV4eU5Vb0Fx?=
 =?utf-8?B?Wm9oUldDamZ4N1FjTEJWeFYxaTc3TzQvOGk2K2swYzVrTTJJMmhTbUZTSGJn?=
 =?utf-8?B?aVZrQzFtSktLWG96Q2wxSU9vZ3JsclVXaDB6THEyY3RKOEUwdFRENGJiVXBZ?=
 =?utf-8?B?WlhjT3RDWWlZWFhVZlpKcmxQSHBqdGJoU0ZNbWloUjNPUUYxb25yN3l0NUkx?=
 =?utf-8?B?T2R0VStFNSt0Y0xSWFdLSmdjUTluSmRyUTZFZnZUZVh4UkM2QXV6NkxSYjJv?=
 =?utf-8?B?M00wb20xNndOenRIdDNWVFQ4NEtTNXJYbkh1Uk9GMHptb1pYOFdnM2pFcnBR?=
 =?utf-8?B?dE1OZldHbE02NG1Qa3ZtVS9YeHh3N3h0YzZOQVlmQlNFeElYTTkwclV5b3Vh?=
 =?utf-8?B?Smc5ZVBaTTR4anJJR3FDMWpFMkIrUSsrSHh5OHZocDBRV0Izd3pvc3dTZVdo?=
 =?utf-8?B?MWVaOGpoNE1vb2FHYXhxMS9tWDUySFQvRVpGcWZUc2RiYUJ4V09QZnhwbHNs?=
 =?utf-8?B?ME5SRURDUllWT01odHBzTnFPcEZ0d3VxRkVDaXJtZENHMGxlcUpqT3I2d1pG?=
 =?utf-8?B?ejVqZlVJUTNDYmNCSWo5eU5FS0t5UzdySHc1S1M2WExHNDlEbUZjalFCelhW?=
 =?utf-8?B?L09oSEpBdi9CSlEzWDNYTjYzQ1FBZHNMOGwzZDlGN3dXYzdyMXhFV3dqV1p1?=
 =?utf-8?B?SzI3b2FIc2pTdk1Ua2drL2ZEcmJPQzVzVjdYL3dHOTU5K1d0WDA3QW5BVVhj?=
 =?utf-8?B?R05BSGlnNUNnVXhOOE5Gb0Vtb3Z4aElUc0IwSkNBY3MvQi80MTFmNDl6RGlC?=
 =?utf-8?B?dDRjakQ2M2pRMXY1TlhGQ0hTZmZndlRxREs4SUdiQTdhaFNZSGhuSUVBSkwx?=
 =?utf-8?B?R0tKSktHbnd0aW5ISDAxdHRrOW14cFJWMkxUWHZPdFMyN1F5RXhvNEh1MDBl?=
 =?utf-8?B?dDlFTUVkbDdPVHVnQm1RQVU3RE9ibGpWdDVySjRnVldPTHgycDhBbjJyMmFF?=
 =?utf-8?B?M21xNnBnL2YzczRJMXZBeWxBeS9MK0xTVkx0MWdENWFqVU5LeGl5WHpVQjhO?=
 =?utf-8?B?eTdBbVhtYm0ybzlqUzIybWhxMmlTd3dKaG1MR1BVTHdoWi84dlhqaUx6dFJt?=
 =?utf-8?B?NW9jTkNhYUtZS1J6a3pvck8yb2JJQU9FNi9TQ1dmQmlObWFSTmRaUVNpRGNx?=
 =?utf-8?B?RzhOaXA2OFFsZzhGR0lQYmNkMmdXK2NGTS9YdjQvZXlHZE12NVlFVWluSXFh?=
 =?utf-8?B?TmJ3SS9jSUhFNm5IaStRZWZwNVo1djJBSnF5VXliRGRMUldjK3ZQSk9kbCt3?=
 =?utf-8?B?NFA2WUQ0RUo2ODhOenZIVmlOaE1oUDhSYndBN0pIR1dkMXhWQis4U0VMREZS?=
 =?utf-8?B?MnpKZ1lGaWI1bFN2cGY1cmlid3ZaMXhqeThGOE9lMFZoNVJ5QWxvL0pxUWRP?=
 =?utf-8?B?eDNYelJ1Zmw2M0FMa3FMeXhxNlRod0kyQ0taMmJWaEhVUk9YNU1pOU00K1hT?=
 =?utf-8?B?cjB3bVNmM05hQk9Rc0hnbTA2QnNkQ2tQYzJ4a25CNnFDVjVMR1dxL0xjR2NB?=
 =?utf-8?B?clJNOTZiYk84anoyMGlnaWFxcFMzeC9LN20wQ3c1Y0Nxb243TmwrZ2VRPT0=?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298ea64b-f90e-4031-9b30-08dad7a7f957
X-MS-Exchange-CrossTenant-AuthSource: DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 16:36:07.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P192MB1671
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have noticed that this patch has been marked as "Changes Requested" 
for a few days, but there's no comment so far, which is abnormal and 
confusing. I will resend this patch with updated documentation a few 
days later. Please let me know if there're any suggestions. Thanks!
