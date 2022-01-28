Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF77F49FDCA
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349974AbiA1QPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:15:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1349907AbiA1QPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:15:50 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20SDsF71002503;
        Fri, 28 Jan 2022 08:15:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Xp8G/cI3scwR9gNy4zFcnEF4j1MfxI4aS6tZf4ftm6A=;
 b=V1qfvLaHvu+ekLXWFHMwEcJzkU9z1817FZ06EwvJEZxdWxpK1ZvigtBEjungBu8m1Ymy
 CnUptZES3Adgnial7zG2GajaF/JBUl60iMo+vVDtBF9PJUh3t990yCk2gWL8U3uYbgU3
 /2gWtbdht4jGJUc7LCMeFGbmRFYrSJEIgfo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3dvhsfgwyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jan 2022 08:15:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 28 Jan 2022 08:15:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3cOfTFi8ZA9MIbVvUZz1LKk8eeYB7JJ27IyCUkBL7iZO6v+IeHeQsEtDCRlJFbsV5BBmEPizOV6roWfXuVzpj7gVZyylUUBhW7woG6W0B8mz8EMUksQRTaSyB7siuv1w4Mw2i8pZIPTkqLiHTcP7p25P4EJHPUZB+/2AY95DPdcSCt7/NB7Uu3XTSJDS+V7ipEg4+246JfeHbv0mUrjhaD7X4jgf/Me3ycXZFSyuHPS8cIr2sF0a9ahnWnXbkUK1JeG2gULt7qwN18v4Qf7OOzohA7Y9lRFSmPxw97AfKK46zapr1WtXolwlC6xkkdniPI0hpOumvs5gGnE4KyEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp8G/cI3scwR9gNy4zFcnEF4j1MfxI4aS6tZf4ftm6A=;
 b=EaVk8u5lgt8b+eH17mnHfr/StHIyTm2bD9yzKaeprV6gbQxVReD2V2DDRZaRZVcOIWddZ/EcN8p/9lh3RR1H2IbUHH5nqVVHhl5DQhK1/u4RNC3nu4Moc42Z4lMyv4pVRJ0fwShDEqO/8fyGwM5qz3NXRlS5GHbNRwG7phTJqScGq23+eL4CkmMLGUOyj5ryKKH5FdbXrkZ6BhMRaXpA8+h36kQBSRt0xpTw2kPX0WV936euJpYRvY81AWywWKVs81d6WjxXH/P0xu1UN+djxQxT+1aQKJaFOHuCub4B1GqbM0YARWQpw1E/TfgJNXPAOuwqvOT+Q7zkm+/jiii2nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3085.namprd15.prod.outlook.com (2603:10b6:208:f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Fri, 28 Jan
 2022 16:15:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 16:15:14 +0000
Message-ID: <03a72767-37bb-2d6f-0553-5a55571e09bd@fb.com>
Date:   Fri, 28 Jan 2022 08:15:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next 2/2] arm64, bpf: support more atomic operations
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>, Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220121135632.136976-1-houtao1@huawei.com>
 <20220121135632.136976-3-houtao1@huawei.com> <YfPCkUW4XIHGTZ6z@FVFF77S0Q05N>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YfPCkUW4XIHGTZ6z@FVFF77S0Q05N>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0061.namprd15.prod.outlook.com
 (2603:10b6:101:1f::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be1ecf72-6e80-457f-99bb-08d9e2795dad
X-MS-TrafficTypeDiagnostic: MN2PR15MB3085:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB30854B95AC247537B09E83BBD3229@MN2PR15MB3085.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EAoUJRVBTavDQJuHvSOYiPC5/9YWcOefgLdRGLnpQqK7lD2VtD/EbgZOFhG52+RoHWL5j7u/CAMKqRW1h67/eEnPIokpBeCDoTjr2Ikd3l9q5/21sM1bwKaGDL1Dz2bSVAlk5ei6HGCNQkACcsbJ1rtNE9p9O1XQLj9NdebP25FBrWkwRKEhcsd+WcM3HpHAGD7gez/wIGkiDzkbrnugeNxUTpHNKhMh/Ob+kHlPi2ktl92ssT3L5pqY0okmWfSpaf9nKI14A0fQNvQUP9ZgdAQaOd7/hG5nEeKYIPcKS5w1Mawyb7OUxI5UBnKWiemLqQog+qH2arRESs0UrahUXlU0A3hcVPrtG5kK3lRT4Hcgq5nWBEnSyp79ZbhL4Us6kuQxAjoaNTomgwzADB9zg34u//AkyQhfkTcM0gtL5qrebfBKZFkLaygUrcHFlWTnxANDP3hq2JP20UYw45GxRXXmf0i8iFjr8Qgf9/ehl9tn3KMx5t30y7Hva6Dn5T3QZ+x8R9cdrS938XpUXk2P+/83eozJ9Uq5lBLV1UupNnUomI47WXX2JDDMyBDOsJIcD36j0OJsa6W2q0HMV8D0LR5xwVSmVhxSQoCLBphShbB/AZ8zvQ3l+NexmkPR0nnilMeVRq1lbT22bkXdup/wX8ex3ZPI+zUkx5NEJZHl9NkDW6THoFqhqXRHQuWLw+wKE9MnsL10iLoqVkZRg4lsu0J1ONwtxS5wQxeOwh9px+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(31696002)(36756003)(2906002)(7416002)(6486002)(6666004)(6506007)(2616005)(52116002)(5660300002)(508600001)(53546011)(31686004)(6512007)(110136005)(54906003)(83380400001)(316002)(186003)(8676002)(8936002)(66946007)(66556008)(66476007)(38100700002)(4326008)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTFnWGRHbXhGV3pPUDlVZDZnbE9XanBwRWRmTFNiY3JTUVpzaENKOVdXamxR?=
 =?utf-8?B?MnpvdTE5SDhHOW0yY3locUZIOTk2VEtQcjNlU3BMQm9tUnJFaEQvczNXY2x2?=
 =?utf-8?B?eklqbnFGMlJKelpVZ0pFQ3FZeGVpSEw0VFU3QWhocUhwUkkzUDlscy8zNG44?=
 =?utf-8?B?ajdrS3FHSkYreHU5OUk1eEJ1RkpHeFRwUDgvQ204Yi9CVkQrZlRjckwvdzJE?=
 =?utf-8?B?cWdJMTZ3N0xBaDFFUm5ETXNGTHk2aDBOS0I5SXgwSjdvYnlVWnB6K1hjbzIv?=
 =?utf-8?B?S1BGYmNpK3FNdFFHZmdGT1Q1eWRvZ3pNb3F6cHZVLzVrQ2FLNkgyMUZ5WGhi?=
 =?utf-8?B?dWJZVlE0SEFsN1dtVGVLaEFQOHdpUW5lb0w3bzFyUXd5R1dLZXpGUGlBVk5V?=
 =?utf-8?B?YXJYL0hsOUxpSkZNL2hyMGhxR3pKV0dCdDdOMHE1NWEvNXNGRUtrdE4zMmF4?=
 =?utf-8?B?NjdGYVlZdWhYWnhjNlNTdEZ0eWM1YmdFRWw2UEkyTmVzamdGcjJuS0k5R3Ja?=
 =?utf-8?B?czZVV1VwNE5PRVg2YkU4S1o5TUx2aTlKQzErc2dGWkovbjdSY29RMjJzbkk4?=
 =?utf-8?B?ZitiODlLWWJnUis5QkpZdDJMYkVMOXk4TTBmQTZvSXlEUksvTHJtbWVoQ3M5?=
 =?utf-8?B?OVRHamhJRkhRK1FYanNsZVJFZ00xWjVoSEZsc00zVU4rZGx0Ym5DL2tGa1R3?=
 =?utf-8?B?LzVGeFh4NHlacUpkYkVsbTFVUndZOHBHbWQzS3ZOcjBoS29nZlgxbHk1MGhi?=
 =?utf-8?B?cEM1VDNVdXZxL2lFKzJpQy9qVXVpYWFBbnBQaVFvMjU2aUNUU0RjaWhTeTdE?=
 =?utf-8?B?b2x3ak9GKzAzZkhPSElMcDFWQ2JJTVY5MlVuNldFV09uOXN0bWh6UWtTdVNh?=
 =?utf-8?B?SWQzS1ZXdEtVMmZIYjVQU1lwTGEybnNrYVliK0pNbGszMTY2Uk12ZWhxOVhz?=
 =?utf-8?B?WkhjRFdmcWpXYlMvOE9UZnpmWjVHb0tMS0Q2MWNwRWQyenI4LzhPZjdVQmhh?=
 =?utf-8?B?a0pYVU5jNUhCYXNqRjhucU5FK1Y5VW9pRktWTnhkcHprYmpZWHRyMU1MaFRp?=
 =?utf-8?B?ckdwSlhjcXJUOEJFU1hnZExSRXRrTDN1VU1yeU90akFZNE5KdmpFRkxDQXk2?=
 =?utf-8?B?QmhRWXN2S3VQWlp3WWJtSmwzWEZVcUVwTVQ5dlNjU0pwb3R2L2N2ZTVPSEZn?=
 =?utf-8?B?Ui9sbWNMQ2taY01YS2NMcGIyVEsrYWdtblJtSlpiK25WTFNDV2RDUUZ2QUtq?=
 =?utf-8?B?SmdIQmkvdzF6VExpY1FsQUt4TnAxQkNqcUJiK0tVbVcvdEg2TUszcnBNY2ZM?=
 =?utf-8?B?cTVOSzVOTmJ4dkxRQVFqbzRaaVlvRWZwdGV1Y2hneW90KzliNWdhRUxoSmE4?=
 =?utf-8?B?aTdPSHJ0UTU4a1hQMmtwdTJDa2lhcEkwZ290ZGNrMFl5Kyt1VlJvYzRCVith?=
 =?utf-8?B?ZlMzOHJuejhXSlpmTzI0VEhqL3dBdzdRTCtCbGMzWGhwNlZ0b2JMV0wzMncr?=
 =?utf-8?B?S2FGOU9wTTd2dUU4ZVJRemJlRC9KSmxxbGRlN25ma3c2Rk0yVGI3T2NyQjRO?=
 =?utf-8?B?S0JsRUZvTGNLNGVoeXdYemZsQ3JUT3lORGZhTVcxYTZJampzK1VPMzMyQ0ZP?=
 =?utf-8?B?Zy9GZUxrb2xJbTRFTVg2azhtT2dobGNXUVJjdWx5dHg4VzZaVGl6TTR4STRB?=
 =?utf-8?B?TjVuRjE1ZDRmM0E3azBacTFJdVBQS1dsMTdUa1N6aWdTbE1USENUeUp0dDN3?=
 =?utf-8?B?Tm15MlVFNmdyU3ArT1VsbHZhOHk4RUpLbGRQT040SUhjSFNXUzVzMnlqM1Z1?=
 =?utf-8?B?M2RCM0tzbzBEVnhmVFZMaXV3QStpVXZHMm42VFVkdkZKU1p1TXZnM014Lzk3?=
 =?utf-8?B?em9JUUVMZklQUzJ3SU1zZ2tsbklHK0pwN3VqV3VUUlA0eC9nZHloTEhrWGU5?=
 =?utf-8?B?Q0hnZW9uUTZxVU4zSzdZQlpRNVhtejlYb0pqdUM0S21rNTIvZXcycnMzM0Ft?=
 =?utf-8?B?OEhJL0hsZzhiWmY0NHE2cUYvUERObDFVQVFFTk82OGwydEZRdlJOeU1Vampr?=
 =?utf-8?B?YnB1cU90VTNrSlNLOHYvNVA3SENTODcwZEdoRTJGKzVnU2t2UnlHMXVKSTVj?=
 =?utf-8?Q?5tQcfyw6PmYM1/fyhGWANSjtE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be1ecf72-6e80-457f-99bb-08d9e2795dad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 16:15:14.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9N6zNVSxnwp7LX9HNDFFRNUYc0g0vJRiCE1WtAG4l2NtTgP6Wir0iLBO8xamzraL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3085
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: AWG0prl0zeEvdB549XEVD1qhqongd7pk
X-Proofpoint-ORIG-GUID: AWG0prl0zeEvdB549XEVD1qhqongd7pk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-28_05,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=853 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201280101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/28/22 2:16 AM, Mark Rutland wrote:
> On Fri, Jan 21, 2022 at 09:56:32PM +0800, Hou Tao wrote:
>> Atomics for eBPF patch series adds support for atomic[64]_fetch_add,
>> atomic[64]_[fetch_]{and,or,xor} and atomic[64]_{xchg|cmpxchg}, but
>> it only add support for x86-64, so support these atomic operations
>> for arm64 as well.
> 
> What ordering semantics are the BPF atomics supposed to have?
> 
> e.g. are those meant to be sequentially consistent, entirely relaxed, or
> somewhere imbetween?

The ordering semantics follows linux kernel memory model. Please
see interpreter implementation at kernel/bpf/core.c. The kernel
atomic_*() functions are used to implement these functions.

> 
>> Basically the implementation procedure is almost mechanical translation
>> of code snippets in atomic_ll_sc.h & atomic_lse.h & cmpxchg.h located
>> under arch/arm64/include/asm. An extra temporary register is needed
>> for (BPF_ADD | BPF_FETCH) to save the value of src register, instead of
>> adding TMP_REG_4 just use BPF_REG_AX instead.
>>
>> For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
>> both ./test_verifier and "./test_progs -t atomic" are exercised and
>> passed correspondingly.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>   arch/arm64/include/asm/insn.h |  45 +++++--
>>   arch/arm64/lib/insn.c         | 155 +++++++++++++++++++++---
> 
[...]
