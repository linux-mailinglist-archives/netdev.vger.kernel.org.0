Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A8C33FDD6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhCRD3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:29:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27478 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231149AbhCRD27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:28:59 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12I3ONwo004574;
        Wed, 17 Mar 2021 20:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LE6VNZLtkVruZlj2y9wtFu3RmcyoiRIZMqvI8c6D8kE=;
 b=MhbaZ+mkAX6USCISxRXkPTxorJaA0R9mdLgOwFIgPozyMYuj/c+kx8E6XrFc1O6aWjqy
 sCf/hSoRKy9ERc/siSWrvHp7u8dsZS0R2KNAJjZofg7VE1pXg6mtPtooHAI8uRbczY2E
 SEnYvHtdF+7OIcGDGGrNJhbBSJyRbe37YOI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1ehpk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 17 Mar 2021 20:28:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 20:28:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SF4IzrK2CkCtiyPTTxPAhR6oWGfcDA0JR4ZY8QTYNtFTSchvghdkFtnFe1jlnIugrzQbRm582RI6D8HwpexgNmsqaHrzrSQmcV5aQaDDaluwsGWJEyiny/BGKlV6X9oQitgML/xNHatfgy/p+xeoztcl9uaUjM8QpvoNTWJOv6UE56gPeQv9S+2TgtuWQ0ceki38+/u/s7CxInFzKCK9ETG20qASkqoPvCCxhZbR1XX3C0Piwz5H2vunILxozDvQUQSkoHWQyFGpovRv4t2fE3R09XGcmEl8w4j4H/LNelX1L7Pijay5G32BPxwLY55YILaggvQgJH0CPiVuQNSHHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LE6VNZLtkVruZlj2y9wtFu3RmcyoiRIZMqvI8c6D8kE=;
 b=FgwUr3H9VrrNcJHZ5wpHkLN+h34o41WSvgLLFyec+RL6+Qi665ZLWBruu4ovFtlYMmBXeZ1229IIe3VIihCcxP2GEJYQtmFEDTqiT11kjWrZKb7zGdjXiSiWgbCxaEqDpF/uSxXhd+GyHtRPYcGZ1Jw2jzoE6vhUgMLoFWwe89n5ai0pMovnJBeUEgi84JPTsEP717kNoHlL4mSGMVl9p+CJEBNW9SRd14N16zlRl9KbbA8jMNmF79wYmSX9JkMEiCXupKBaOywJuCBrSTEF/9n/IyrPQpk0aJ7x+2EscvoSUKmEilCZXIIS5wpbr80WRLAn2QD/t8h/y609CP58LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN8PR15MB2722.namprd15.prod.outlook.com (2603:10b6:408:c2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 18 Mar
 2021 03:28:43 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 03:28:43 +0000
Subject: Re: [PATCH v3 bpf-next 0/2] Provide NULL and KERNEL_VERSION macros in
 bpf_helpers.h
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210317200510.1354627-1-andrii@kernel.org>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <703950e4-af38-bd15-24bc-c151cb20a733@fb.com>
Date:   Wed, 17 Mar 2021 20:28:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210317200510.1354627-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:38a2]
X-ClientProxiedBy: MW4PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:303:8c::21) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103::3b8] (2620:10d:c090:400::5:38a2) by MW4PR03CA0136.namprd03.prod.outlook.com (2603:10b6:303:8c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 03:28:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51fed244-8618-4141-270b-08d8e9bdee0d
X-MS-TrafficTypeDiagnostic: BN8PR15MB2722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR15MB272291A7AEED860F6307E4BDD7699@BN8PR15MB2722.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +HOPhzaHCVqjMnza5UYenJEnZ9Ylr4PPE9O6BXxS45OB/xMgzqNNi9tFYAp17Bif3MOsf1F01KN6ecJf/W19QXxVUBWYoNgkMK9mYqYSEnknDZV9icIk7OjXzLjQy6s2THfvBgsedMBxu8romN7CCNDafh1lduhqW8jX6Mf2dSOsSM2wYpPwUnnJmppkygH42Rq4bOUNDAAUSIGtuMYIRNvLtCqcQId4grnsmMILg/Mj68YZHd5KozBg75Eu7tBwWfVFXh6i82JmljR7DhAcgYP1Y3G3caXds7ynF/7jsaX7ZJdZTY6R4zC52J49NmE7s8REfya0veKEfYIlT4YsKFxWQrx5niE6XDCvH5+EaV7SP/kOCp4N1Mz3FnZhafInc1Ju7IYtRHjNrcoLCTu+4qmv5ThwIlRaHCQ6grWrB/nMOv5JqKyWTWiww75P/yXlHFugJYO83MMYAVoSUanqaIHVbwfRwAz6o6CO0NIlo5lnPmHvki1uFiemq3RwYxVeP+n+5h39vr3vLu2cwxKGlmCaOuMLdDPaB1aO88MFDaj+wft8yZMtqmPPFU0LsgknGkkCMLfGtctsYvHWVJag5rP9g+rbpGF6lcwuTVz/e9zrCcRGAxACWqIfNmuwINB2tTiTT2GTJrwFVZRo7RjviMEcu2ChbnIXH9/WC339hi3FyWGKvupuGznq6kbRo+Ef
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(31686004)(478600001)(4326008)(5660300002)(6666004)(31696002)(86362001)(38100700001)(66556008)(2906002)(83380400001)(186003)(52116002)(6486002)(2616005)(316002)(66476007)(16526019)(8936002)(36756003)(8676002)(66946007)(53546011)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?REZKNnJ3TUFuNTA4Unh4QTdpQ1p5RFkrc1dkUm1rQkFOcVZBR3pERFhkcTBi?=
 =?utf-8?B?OWR6UTFBTXhRTWFQb2ljMGhaUnF6cjZtTXNZSzNCTVZ5NWJBL0t4MU92d2hU?=
 =?utf-8?B?WWNGbGxITFFSblhDdVJLcU5WSlRJcUZDd0xWZlo2L2drSDRQdC92WjdhRkhk?=
 =?utf-8?B?NEFHZWRCdVJaYTZ2SFJxclNBNmpycU05RFB2ZHFQUzgzd0tFRWk3aWIyQnBq?=
 =?utf-8?B?djMxVXBXRFB1ellpWlRmU2tybTl2aWJ3cUJRK0RzVnNSRDhoL2YzM2xoT2NS?=
 =?utf-8?B?Vy8vRm90dVZ2bmhmSHRHZTNYR21jbURlaG1DMWpZWUdvM094N1d2Nm1pNEtQ?=
 =?utf-8?B?VCtyWEZRaVUvQzFOb2dVaWR5WWl2NDVTZUo5b3JGbWk5aWRhRVhNSDkvM3pE?=
 =?utf-8?B?Z2VoVUxjSitNaENJMS93Y08raytnbFBmTnN6R2ZqRmVUek9VWE5xckVSU28y?=
 =?utf-8?B?UXltcWlQZ2NiM3YxblhSVVNMV1dxcWk0YVNsZDh5VHBnVXo1eXlLYjAwNzdN?=
 =?utf-8?B?QmVkWXVnejlxN2tKTFJtTUUyZnh2Y3M4dWdCVjVkZTl6b2lsQkx3UXRNbXFL?=
 =?utf-8?B?OGVLa3JES2RBK0xIUkxXVHdqVzc5OUNJRmpZa1FGTk5SUnJRV3lJaTFPYndr?=
 =?utf-8?B?by9SQ3RwR21WbTgrcVRHanlDcGRmTVpEck9MMUcreFZRQU1IcW1ndHdlNDJp?=
 =?utf-8?B?bm1qMCtvc1RUYjZDdFlDNGd6MEZuT1BGc0tUUEdVVnJHTCtnK01QZUpQSUNa?=
 =?utf-8?B?Nnl6ZUljaytzMGl5Wkk5cWM5SzBsenJlZlVCMnF3VGV4UnBabDA1Y3hNbmFZ?=
 =?utf-8?B?RXloOTFtek9NcDZvZDNTUFFsLzViSUU4U3lPSXE4cVNPRkFXa2FFdG44QSt5?=
 =?utf-8?B?WVcrUmRwc0JoQXB5WENrT0tuRXp6VVJVU05MeDY5dGVNSzZCaDRRN3FxSU9F?=
 =?utf-8?B?OCtydmRYaDVacTNQMGF4U04vajVaS08wVnpJWHpuaEcwMkFjQ0FZaUlTQXpB?=
 =?utf-8?B?OXpEUEdMeXZ4MlVjTlRZUGNEdGt6N1RvcnpuREMwT3FPdVFmU0QvTnNWVnFV?=
 =?utf-8?B?akFGdjI2UU1mbjd4K3dPWkszamFyWFI1R3JpNml4cDBrSy9zT29aOG9semRB?=
 =?utf-8?B?SWpDWVBRR3R3UWU2ZmZKc3hBRmxxY0sza2NOaXNwM3NCTEM5L1dPU0VuT01V?=
 =?utf-8?B?dDl6SzdKaTNnd0xWN1FETWpVc1E0c204dE5xTWVPTWJtMThvSzJFNDY0Wlo1?=
 =?utf-8?B?U25vQmozMEpIQytrZ0RhektDM2xsUVdJL1MxaXdDV3p2YzdsaDBVVmpXbUN5?=
 =?utf-8?B?VGxHSFR6STBWeVhyWk50eWpBZ3FySlpTcVFsU1FtWVNHaGV4OG5LOHhBdWtI?=
 =?utf-8?B?MlNObEw0RmYxeWRqTWJXOUM2TERnMHdHNVZXL0owS0pveG11S3VzUDRkS0FS?=
 =?utf-8?B?VVI3OHZkTjBEendEbVRUc042dUlrWmFsc1NiRFNtZEFNTVRYazA4Z09QUzBa?=
 =?utf-8?B?VXZUZUVOMkdLdXZ3TFYrdjQ1T0VCd1FkWXp4dVg2SnQ5UTF4N01jaElCcWtY?=
 =?utf-8?B?OEhmTjhTbVpLVVltQkhWb0JDc0o1dGhQL0d4L0RNWGdYY3NzM0NPRytKRXhv?=
 =?utf-8?B?V3RrVy9YeEZ4QVdCYlFpSXlSOVdNM21DNDRseWVqK1RxQ09ZVHlhNDF3N3VC?=
 =?utf-8?B?aWdJYnd0N09PbXNYQTR5dTlLSGk0NVR3RXlnYWpqdGYyQU9LdkZMK1ZMbUdV?=
 =?utf-8?B?TU1YMlRhdkVzc0VqUGhiVXg0Rk1yYmk5c1kzVDRxeXp3YWkwTFUwb3FwbHFw?=
 =?utf-8?B?SDl0OGwySG1vUlV6R05RZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fed244-8618-4141-270b-08d8e9bdee0d
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 03:28:43.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3wEUmgEUTbEWUqAQ31xUyeNcUOPpwgfyUkjuin80IvmcSb0apvYdpQ+w3GKaICZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2722
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_16:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=917 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 1:05 PM, Andrii Nakryiko wrote:
> Provide NULL and KERNEL_VERSION macros in bpf_helpers.h. Patch #2 removes such
> custom NULL definition from one of the selftests.
> 
> v2->v3:
>    - instead of vmlinux.h, do this in bpf_helpers.h;
>    - added KERNEL_VERSION, which comes up periodically as well;
>    - I dropped strict compilation patches for now, because we run into new
>      warnings (e.g., not checking read() result) in kernel-patches CI, which
>      I can't even reproduce locally. Also -Wdiscarded-qualifiers pragma for
>      jit_disasm.c is not supported by Clang, it needs to be
>      -Wincompatible-pointer-types-discards-qualifiers for Clang; we don't have
>      to deal with that in this patch set;
> v1->v2:
>    - fix few typos and wrong copy/paste;
>    - fix #pragma push -> pop.

Applied.
