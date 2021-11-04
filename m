Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB8445CB6
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 00:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhKDXhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 19:37:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229970AbhKDXhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 19:37:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1A4N4Xfk013799;
        Thu, 4 Nov 2021 16:34:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lkcWE85pZAIENYYG5yK0ezPLIhFIMZgKJEB62iDT0CA=;
 b=lzhhQcFqbV5+NAULkeobv4CMYe2GuYtMI0cTdQVqEGyUqkMztcQbG9ZmsFL/GS6AR2s1
 A32e+j5D/zZiJBYlSNErRh4Ez4rw2kdlsUAIBvzCfR8ie6TEzTIxKGBhiyZRRUskBsff
 hR39udlNWluLmZXfOm8rP6sRsjJh7MgE4ec= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3c4hdnuvkc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 16:34:33 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 16:34:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vju5XNPyEDRXQrL1BObCjlS/H645nKTtBpslbXkoNTXZmZr321bEAAINY76JTjtaGC4ObhhXbmMKHoTrNrNmk4cX9N2mqiMxkP/6hHGt5x/WleCo5xVT/UhYiX5xFMMEGoQeKURAgcnjNLfTemE2Ei5wRmKvkb8X7oDESPSd+/z9llEOioslZZwF+ltFJf1/XC5Wqka6OZAf3UpX8t0fEDj9+7Bqesv+0KZZmRZ/PD6YS/WP7s4U1stjgzWOpUGRQWzEVJ4NZxGyirlO2ke5CdKMkt/kduxY7nAPTrnHSsMcRMl1sMzfhJmbnowoyPr50ejchhlo+U7Ppi6/YXxjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkcWE85pZAIENYYG5yK0ezPLIhFIMZgKJEB62iDT0CA=;
 b=EwtlJNLqvIxVhSY9kCmr3Ko4/5pVcnmnsE2OGXUOfjj5Qu3yz041j4mG0NsesRuP3ISQzEg7cRjfEVbmcytCCebJiefEpZSSbnoZyVl6dRbyxZ/Z8F/6CT5aawBpZTCq0u2/voaYijHqFPX0WEfqoJmL+8zEveDXaO0/OMYh2yKugmZ6xgmtDlTFC9dB+Vzqz3WcYVIs0wkZRmJsccJSkxtR5QG/xqUfK/kutg6Fl3BLosBcekzy8AtkdsHM++oggbzVb+JIE5y5pgUbCjTKR1OksxJpmKQAQrmP1C2kqRozZY+mfGnZTMN0kOmgNzgzVF+UQLUR+HHh13PherLI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4159.namprd15.prod.outlook.com (2603:10b6:806:f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Thu, 4 Nov
 2021 23:34:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 23:34:32 +0000
Message-ID: <da07689d-d7be-5c41-fcc2-f4f14e0f97be@fb.com>
Date:   Thu, 4 Nov 2021 16:34:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v4 bpf-next 2/2] selftests/bpf: add tests for bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>
References: <20211104213138.2779620-1-songliubraving@fb.com>
 <20211104213138.2779620-3-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211104213138.2779620-3-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR21CA0050.namprd21.prod.outlook.com
 (2603:10b6:300:db::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e1::14ee] (2620:10d:c090:400::5:1851) by MWHPR21CA0050.namprd21.prod.outlook.com (2603:10b6:300:db::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.2 via Frontend Transport; Thu, 4 Nov 2021 23:34:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0967036-2da9-476b-cc64-08d99feba701
X-MS-TrafficTypeDiagnostic: SN7PR15MB4159:
X-Microsoft-Antispam-PRVS: <SN7PR15MB4159D050EA533C0113840460D38D9@SN7PR15MB4159.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 39CRwid70HmzgVH3+Y3F+wcN95QWKNz0zzIA7oYMUbLJGHqQkG84R5g+pOllGQS7sq/T8IMdN/RwIJhdNloXagbNVMK+sZd/Ij4lhndaB7t7EUe+MyQqzsrYw32cVIZqMhSMVHUuKJrlRhDGbMhZV1Owc2Ax5We8OhnwB/8Fc41R6MEuWRI8Y4oJq0Fp6M5ibVjjodWf9gu4x0c1ZMtRQMFA58A9A44MaJRcdz6Mf1VXF2X6Oy4T7uekZ+/9r8tDS5ksgZ7CBs5Udn8IGZN1qHdE+Wyphj1PU3rJ1OwjGt2pjfgxeTVsG8+5/JpfdNzD2aeJuxPlKv6VjSsGCn/0mNcXlGsBCOXgOt42IIEQ+Na40vlxHNep1WgJQ0eqesBDYLWByW/3BAn9loo6JmOs2CCpuacL8F6QrOyWJqRwMiG++x2OVWZIHA3gxIkVb1dXESag1m70SAo8A0bH9OnSz9La4djt/iPlYWdaIjIO/behk1tPr+dc4DpfD0bXVQPTbPEqIf7pVESqsM6Y5ab+QvQYWx6tHjQNuKMMIBpTYan9QD02GHb/8iEb6M6vDon70FJY8LzHHFzScn2XIRO1/SdNSwwtoQqjwr8uXU5xb7FQlX3dHSSw3tJ/kVN6m1rXLvbpP6TpxmfHAct2uy/2QqDTy+oqghFfhxeTLNVUzCxLcLVebZu+fOteoOFpTpyedfOlz/SdK8inbto4uYwlxutWqrCMg+t+ybLfUISDKZKNut+faHiSNSeXRsvYNOUY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(4326008)(52116002)(36756003)(2906002)(31686004)(508600001)(31696002)(8676002)(2616005)(6486002)(5660300002)(66556008)(66476007)(316002)(66946007)(38100700002)(186003)(53546011)(8936002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NElFbzNLQ2ppWVBkUnh3cHUrN2o1cnhHaXh4SHZDU1Y1YmYvSDZmZmp6VGxO?=
 =?utf-8?B?aXBuclJQcmJNWmhyaGJJSVRpWXowUDc3VlUwOE8xWjhGRFdldUxORFN1R3ZU?=
 =?utf-8?B?MU81aDJZYWVHa1ZtaER1N3pkakRyajZha292U293TklhcVdiUVVYRzZKRXJ1?=
 =?utf-8?B?UWVUNlZTOU03amh4QnYxbWEzRXZHNS9ZUEg0UFY4VUVUeGpBMkd2a0gxOEVR?=
 =?utf-8?B?eDREY2JyODhMeFlqNGMwZHRENm12WFdUZUNvdjlIcG1rQkR3aGVlZ3Zud3ZZ?=
 =?utf-8?B?TlFWbW9CWTloUCtjcGpMNEJhcFhnYXZpNVJOWXZBUTA0MmpKNC8yaWY5aDZm?=
 =?utf-8?B?WlJweTJ0aHRuS3dBdnNadUNoWG9uYjZDM08xeVJVUUpQMjltV21PVHlDeGdM?=
 =?utf-8?B?cmlRaCtYS0p1WnVzK3I2WkxvMER5V2t1REM5LzJvS2V3b053cTdVOWRiVEpq?=
 =?utf-8?B?TmIvQTFHdm53U29mWm1NZmFDQlJ1bVprMkYwUk9mVVE1NHpDY00zS2d0enFp?=
 =?utf-8?B?R3RvNnB1NHJEeml0eFRCM0lwOVRkNFE0L0pLRmYrVHlBUjc1UEpYNk0veWs2?=
 =?utf-8?B?MHZWeElRTVVpY1FaWWcwb09FR2ZweDNQZ0QxOWVsdDY5aU5DN1doL3dtKzZW?=
 =?utf-8?B?MFhTbXZTWlhzemFQeGdiWHN2UmVSb05kOS9xRUJHN3p5QjA2ZCtqWklQQWNR?=
 =?utf-8?B?L0RsNDdZdS9QVUhTaVRaK2lnU1pqK3ZoS25kYXhoK1RaYXZZUS9YdjYzRUsx?=
 =?utf-8?B?ZkJzUlQ4SjFYdmdYblVXa0lJOHpwWEFtS2d4c0kwb1phUmVYZ2ZLTEtoQmNu?=
 =?utf-8?B?YkM2TVBjNkRSUm9LcVdNenNCTGNjdnc3VklGRTFoL2R6ZGYyV2dJV3NFRjU4?=
 =?utf-8?B?a1B4ZTdGa0JVYVlNTkNxR3BYQ3hUSmpRU2RiMXRCTFA3YkVocER3dDJQbC9M?=
 =?utf-8?B?cmRXb1lXaExBalJMSk9iY25XNDlLU3pubms2cGpuYmFCeTdhNkJueHJKZXcr?=
 =?utf-8?B?M3Jyblo4SVVOTE9ZVmVrQ1NQb1kveDkrSHJCQjNacTZ1U3Vnbk1vZlJjNmsv?=
 =?utf-8?B?bGQvMXhiQVo4cmgwcUN4R3Z3bHE2OWNORTEweElBbmxMdFQza2RsME1ENE5E?=
 =?utf-8?B?RFk3TUVtNy80aVE4VEo3RW5WeEg4Nm1KQ0pyMEpOY1NFZVBvQlFJN08rM29T?=
 =?utf-8?B?K1FGdHd0d2JUN05kY3ErSTgxOE1ETUNtOVByVEswRXgwT2RseGd0VkxqQ3F5?=
 =?utf-8?B?NW9FNXBVV1IrS1MxRHRNd3Z5OFhVb2w0RXFjeEFWSnVrWlhFam84ZkE2UVJG?=
 =?utf-8?B?RHBybkxZN2pMVVFJOExqSFZ2cFdwdDhQTHhmRUl5WWpzQWFBeFBlSCtFS0o5?=
 =?utf-8?B?QVRXTHBEVG02bEJMT0N0a0x5Q216ejdZR2k0am55TmZhaXBVYzdidEMyVlI3?=
 =?utf-8?B?bFc1cHIzcU8vc2FWOWNEcmlJMWFNNktPRGZFWkV2VVEzMSt4bEZZajRNSmJF?=
 =?utf-8?B?dTFvaEU0NTVoTkRVN3hKRjBpMTlSWm5wc2NZTUppQ01OOHJPa01PMWhHL2o3?=
 =?utf-8?B?TElhSVEyTDF5Z1UzTjNuUkE4K3NwdTQxUEdBWnVGcHdId0oxbERSTmUrZmQz?=
 =?utf-8?B?TVM2SEJ4dk1jc3BPaEdDMElDOGRNNmZjbzFMTnRBNitGN0RTYXQ5akN3ZnhI?=
 =?utf-8?B?Tmx1VDVucCtHQ094dDB6Syt5NmE1MlZ3Tm43OXZDaXltSDM1UmhrNmJGMlN2?=
 =?utf-8?B?RDY5V2Q1aEs3V1oxbWxsdzhVQVVHVE5UT0lRWEc2VXA4Qm1VZURrTnZ5cEph?=
 =?utf-8?B?N1FKZThHSWIxU1MzUXFRUm9WTWJSL0RYcEYxcnpOZy9mZjZHZy9GQmtpR0Yr?=
 =?utf-8?B?cE0vWVI3NEZmVzJ5aDJvN2VZc05wRFdHZy9tWlR2OThodmZCSFJ1YWhLM0NR?=
 =?utf-8?B?V29QL21NeHhrOEFLUThRZUdLUXZCZmhVMVhZUXQ5WmFlV3hqeVl1amlXU2Rw?=
 =?utf-8?B?SllzMWk5STFEOHhKTFdPUjEvWGlLYUpKYXhSWXNteHhsM0xkZVZZdndQckJq?=
 =?utf-8?B?NElJSkN6bktHSjh3bG95bjArMTA2Ukw2Ri96ZjB6Y3VuVThsUXpzUVZHdkhk?=
 =?utf-8?B?alJHN0s5MkRsYUwvb0YrR2xiRTFrdmdZTkVyNDRTV3RyZG4reW4zN2pHZEpQ?=
 =?utf-8?B?RVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0967036-2da9-476b-cc64-08d99feba701
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 23:34:31.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eU6T4KmXp/UuSIc+0Iz2A58aaGOzYxBMMLJkLUWDyXciwGjySOfqjOLXAJ4rHomH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4159
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 17PkGHAYYeJgdjFF15WANfGa_tXiJeQA
X-Proofpoint-ORIG-GUID: 17PkGHAYYeJgdjFF15WANfGa_tXiJeQA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_07,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=785 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040092
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 2:31 PM, Song Liu wrote:
> Add tests for bpf_find_vma in perf_event program and kprobe program. The
> perf_event program is triggered from NMI context, so the second call of
> bpf_find_vma() will return -EBUSY (irq_work busy). The kprobe program,
> on the other hand, does not have this constraint.
> 
> Also add tests for illegal writes to task or vma from the callback
> function. The verifier should reject both cases.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
