Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51D256AAD
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 00:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgH2Wrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 18:47:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgH2Wr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 18:47:28 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07TMkB0n006464;
        Sat, 29 Aug 2020 15:47:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gMwL0N3pNkdhqXjzI+zaBurIyJexsvWk1fopIwu4qrA=;
 b=B/zWFLe4vRrdEyyVRkKAxUiWIBkpCOvNp0dKy9SglPUfLMvqQR4diJtuGaCqWmZE3+4e
 r6Y2CEjgbRCz3Y5XwFssA8eD6hpppV0Kx9TdHBt8A/QAbpNLcBEIvNE0TPP2Sgn/F/+j
 le9GSALQ7+h0l273+HxLK1gkDkHWCitB1cM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 337jbct8j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Aug 2020 15:47:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 29 Aug 2020 15:47:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqM7fY1CtJ3L2IUOWBgvyo98qTNjgRWGM5aUTfAIvHavFbfm+hTlX/dvMcvHR8O6I/yG+Jc2aS/WbHd7GM6lhIoV4R3P1A4VNMTw4v78/BzOIOK5I387eoam11mlFYweOd18bX3XhD6DFNkV4eGzEgUFoW1UYnVt4HpEUAPk8xGAgWkS+KoVTe4AGHatLMZ2j7gWX611Ktvf14XMYJJdQRJe+1m0M+uLZcr3fP8atH30jtdSmRUQRDUlMGOnOZNP4Lu2HLYGfULb+d4cS9nGxtDTu5g7qiyNBd8Fcbu8Taw7Atf5IT6H0K7jooXUHrd695PDHIhVxW8CU028RC35pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMwL0N3pNkdhqXjzI+zaBurIyJexsvWk1fopIwu4qrA=;
 b=VGPIOSHi+4ALcKZdqpU7neldON4zDTKC/papSB9F8QAsqn1lp9mQ+SvkrKrR1EaNfmXPT5iT6FNxZsyrcXL+/jnj/W2buzxBjJgSm6QIYpuGLuMnR7XtSY0iyCH8xH/b9E+cQqkfJtmfAnQcxDuQNSCRmmCQEgZwGkphdRlDHMYCLJpURzituE4AdhkWKCTOyD+jBjHv5kiMMiKkKVs9+pk/mr7c/F2fdJf8T0YEY0pYxOAoy1Jh42/SJJhwmMGs9k4tP7ziPhL67I6W0dD04K3D9oeN4pYUaaFwZ1clENSAsDcW/dlpSLCeMf1hQuECS/VS7jv4B88FgFxl36FlLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMwL0N3pNkdhqXjzI+zaBurIyJexsvWk1fopIwu4qrA=;
 b=iOwCNZHKfZd7cK2dSttfFtBXBerUPkNvwpQNvQ+bcO/lL2fzyRH8LSCc9F7V2fuE4iXbnt2M0MMWxI6f1RLUPTY9jU7kYcHq3X4bnVBGiN9ZAHeExnDsJiuaXpbQbCdkNfSqocao0E/MehCiONyl4FIaQpy24EiHgy/IgJ7snFo=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3786.namprd15.prod.outlook.com (2603:10b6:303:49::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sat, 29 Aug
 2020 22:47:05 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446%3]) with mapi id 15.20.3326.024; Sat, 29 Aug 2020
 22:47:05 +0000
Subject: Re: [PATCH v3 bpf-next 1/5] mm/error_inject: Fix allow_error_inject
 function signatures.
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <josef@toxicpanda.com>, <bpoirier@suse.com>,
        <akpm@linux-foundation.org>, <hannes@cmpxchg.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-2-alexei.starovoitov@gmail.com>
 <d6eae293-5427-d5e4-73aa-4df7a493bb89@iogearbox.net>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <25d82549-c793-6e2d-d7ed-1dfb3f77e447@fb.com>
Date:   Sat, 29 Aug 2020 15:47:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <d6eae293-5427-d5e4-73aa-4df7a493bb89@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR06CA0061.namprd06.prod.outlook.com (2603:10b6:a03:14b::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sat, 29 Aug 2020 22:47:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:9043]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cba8c73d-7c77-4f57-7006-08d84c6d7410
X-MS-TrafficTypeDiagnostic: MW3PR15MB3786:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3786C8C9CEB8CC3DACD29599D7530@MW3PR15MB3786.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9M7wipVvTXkoXh7X6JcrB5+eNNaX1vnrex+zvI0/XpLy+XChRnDpAgdFcPSAJ08Qh8QoOd+OjeTe+jCAf4EBxFYC2yIId+SvGeR2WS9AbJ8ddz3yo8d0PfF/RTuAkHAt4owMxjpHLrk0xE7O/2y6gVx5qwre+s3peh7TYwBL85qjiazD+pb5AkXA9DoxZPpTMD8Mi3r+QdCIaiR9V6w9WoZlNh3u0Mre5LBFAKR6w/VbE+Oobv/ouKgZCOfrshj9S9ziwCz5MdemSzvU3J9kLto+qz4LJs9fQY5v1Qc2ZZ6PwfSLA8E0qf++8x4PMBsHEOZlEGp5vhHJ/usXgXY30IY8oWK9n0Wo3a8+78v7z9vGshofvaSLVexYm4GeEcW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(396003)(39860400002)(2906002)(66556008)(316002)(2616005)(53546011)(86362001)(478600001)(6486002)(16576012)(956004)(110136005)(31686004)(83380400001)(36756003)(31696002)(4326008)(52116002)(66946007)(66476007)(5660300002)(8936002)(8676002)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Myy/GYc2FmuJy4bNaWKTqYSyV5/NHg9ogSCI/VZWTdmTuOcOzJrBgAjxamz9yNKcrpBM35jH31ghBF8TxvzhjQOpos6xrmdliR++xRF6aCQ/+sIaR+swVHvXMhsse7tOScyljdkoiruBc09nUJX9uyQTngwaFBhQ+SlbvBmYe9wXTNvf97MMez8i2EYxviC5fAhsowxZ8nkIL1AIy2NpHbC61p6DukaDOcBxgf2LymKLuVW9eD2KONdgasOe6wwxvED8PkdEzeSNF7Q9Ig87ijTpkFfP7LcMnApz5iwukJKtDH4okCnxEjSBxPLOCXY2m20Jcq7Kta6nC/h344cXwV0XB+s9Nl0wHAm7iMJ4kdXNIp91C90WoblSqPO/qfVyyFcIW60Bkc3e2z7BAUD49ozle7qOmNXsBhgmxVedikkicVF6jDtnEjVtwJArT/h5+UDANpmGcf6/WATV8+SkHQWUGmEV03XUFnnBh1FDxBBDNeRAtaaxuAdJMKkgxA75FbIhFaxNkoc8GQz0/tQBQDfJEJXoGcfPUrtfI4H0ldWzS4pw4/ecfa0iwY8+GeVLyYVqXJEUAfL3IfZSxW4qxGcNXMMtCaYcfc58Vp3zBOKh2nKZptoUb9nnRCADLMQo/DFw4wHFfbf7AWqznBsfoU0oW8rpPP75jZ0rcgowrb8=
X-MS-Exchange-CrossTenant-Network-Message-Id: cba8c73d-7c77-4f57-7006-08d84c6d7410
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2020 22:47:05.6629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BfvSSTh+kRjepdN04Ve8OJr6dz61TPmIvzKpiTmy0zx618hsl9Dpr+kn4/M68Q5s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3786
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-29_15:2020-08-28,2020-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 1:27 PM, Daniel Borkmann wrote:
> On 8/28/20 12:01 AM, Alexei Starovoitov wrote:
>> From: Alexei Starovoitov <ast@kernel.org>
>>
>> 'static' and 'static noinline' function attributes make no guarantees 
>> that
>> gcc/clang won't optimize them. The compiler may decide to inline 'static'
>> function and in such case ALLOW_ERROR_INJECT becomes meaningless. The 
>> compiler
>> could have inlined __add_to_page_cache_locked() in one callsite and 
>> didn't
>> inline in another. In such case injecting errors into it would cause
>> unpredictable behavior. It's worse with 'static noinline' which won't be
>> inlined, but it still can be optimized. Like the compiler may decide 
>> to remove
>> one argument or constant propagate the value depending on the callsite.
>>
>> To avoid such issues make sure that these functions are global noinline.
> 
> Back in the days when adding 6bf37e5aa90f ("crypto: crypto_memneq - add 
> equality
> testing of memory regions w/o timing leaks") we added noinline, but also an
> explicit EXPORT_SYMBOL() to prevent this from being optimized away; I 
> wonder
> whether ALLOW_ERROR_INJECT() should have something implicit here too to 
> prevent
> from optimization .. otoh we probably don't want to expose every 
> ALLOW_ERROR_INJECT()
> function also to modules generically...

I don't quite follow the concern.
EXPORT_SYMBOL() only takes the address of the function.
Just like ALLOW_ERROR_INJECT() also takes the address.
Taking the address doesn't prevent optimizations.
The compiler is free to inline the function, but it can keep an
extra function body with the address pointing there.
Also ALLOW_ERROR_INJECT() doesn't make the symbol available to modules.
