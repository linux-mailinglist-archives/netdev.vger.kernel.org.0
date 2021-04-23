Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31427369954
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbhDWSYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:24:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhDWSYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:24:45 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIGIFG029821;
        Fri, 23 Apr 2021 11:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BTnh5yBgfKZN+yGq9kscy0L8cO6zrHQZ6/D5eea/d60=;
 b=oipRzbKX4fNci5y3ZNfIceyMnetdfHARJbQnaw/g6JmvMSq0AjTRoMoxkHUgsvq6irBf
 zv8xUGxXswCksDl/5La051w4VvOnkRmdma7YrtCYIMDzO7Vvm2knFVred5EOBoWoQm9H
 r7Zq3myjsvGV9kcJfQRJAJ5iNkOKH/L3Xp8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383an289du-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:23:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxR9w925gbnw7zbOermwrIKywOXWQajdaklh1/QvHtXibt314T12aF44sLUy+dHJNjYV1fQ4gVuiY/Io2OG+hNyJtCCZTCur/fjqZsI/kkcaokz8tg6ZijHlgZplbAeBv8O1KK0bIiDP9HWKEPDKJKAfn8uuthIqLz76JkhUpe8SKtoDM8POu27c9P5vrM7uTH5Lj3dVU/t+4NCdXAWC8GZWKRm1WPV1OkRZncjUlzEn+J2bHr+nGGg8fIIn+kLLvLSfK31rxqMmU94zgzzcAEKTfUEwZEsAFF5miGxpMjmenHNpwZL6yvA6xdPBmauKVGKUazacPgFtHzyH3qQKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTnh5yBgfKZN+yGq9kscy0L8cO6zrHQZ6/D5eea/d60=;
 b=WsKlDpYyBdidECVsi6pQSM/FrPur1EznmEINzqATX+XWSsIFArlHf5RRFCXrmBtSmF1grh358zNbCZQdWizhxA3oMK1PJa7soa9mcVem5darf5IAXAuBXr7+YxL/or6GZdL0T/XjyQJC4iLJu77T3V4qterw93SITlKHWKhm69sWflp9hMK+q0q0C0EThJyryE7smRmSPXoL5w6d3l3lyzqTnfp465TCxycghMMFFIPCa9lsLpKm3NOk3fmj2AUSJK334ZIHxihiMxsKpHNgPu3hQPcrjQOKTsw9L5eyPcae5uUR76bzMipc4jfNowdiaakX+NUeii0NO9wN3XOQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5031.namprd15.prod.outlook.com (2603:10b6:806:1da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 18:23:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:23:53 +0000
Subject: Re: [PATCH v3 bpf-next 04/18] libbpf: mark BPF subprogs with hidden
 visibility as static for BPF verifier
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-5-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f432afb4-6077-b456-bab1-1484ddf5a44e@fb.com>
Date:   Fri, 23 Apr 2021 11:23:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-5-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MWHPR14CA0013.namprd14.prod.outlook.com
 (2603:10b6:300:ae::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MWHPR14CA0013.namprd14.prod.outlook.com (2603:10b6:300:ae::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 18:23:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bf08db2-03d8-4838-b72b-08d90684f304
X-MS-TrafficTypeDiagnostic: SA1PR15MB5031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB50317C6F3703FC198E9C034BD3459@SA1PR15MB5031.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PNRkTMn1DSrtBiHNKQXCbbm1XkeMrme6Gi+xEt4wm+Acposu94shSwUohINzhhsCGfvZIyRCJ438XFw7ywKWzkNt2vJv8bK0FantaWMx/Cug2ZObPxBekOhEkGvy0w6OtGN7NvxNmssTJJhGzCGEKawd/ytPe0HGHd7V/SS3AB0RuL2Uzo7NIreUAzky75ZIrctkCCjauLkVZgnFyPc4Ge78AcKX9/g+y9x5AgqochPNrYBKoVGV0DFXBdHinZLhaN6kSbBBh8Qwft2gYIAO6ONIxdOSmC/a1MdMjdd4HCmEHuRtoLSCP82GiqxEflazC+JYcThzZmRHI7Y/hTpThEfncK1c02AK0mtsr/cyngs3gALdEBdO9yPUfqK0C47am4/o7iY2ABFjb6nq9XaKjxMT7SLK8AXNzgqjce4NsARnaHft4YDRcFVHi0xukCeW4m534uIQJpEzsnRUagGvk5kZsIDfHPJZeV8MvsPBrSaokVX318sEFmiMdJkCJCivf/g8iMouJu4VLS2Dwh9BvaDZe6fQTo5uwMNEbi9dRhJ3rvfavkE52HIDREzrLV/X5clgtSkRgppuGWrQ5PYZCjG1RCD2DeMrqmNa/FInNUd6p/0lqphkn0pivRLG49Mv9f2alSS7tl+JhzDuszpmY1+9vTGJG4uxYcTdbwreRPkw35T0KP1beJRbdxA0JRVG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(4744005)(53546011)(8936002)(86362001)(31686004)(52116002)(66556008)(38100700002)(498600001)(4326008)(2616005)(8676002)(83380400001)(6666004)(31696002)(5660300002)(66946007)(186003)(36756003)(16526019)(66476007)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NWNSRTBUWThFelpscW12RFZCL1I4Nkc0c3Y3MHJYV0F1MUJwSmlPZkN5T0Zj?=
 =?utf-8?B?Y0puTHhuby9zb0EvdTZRdWtJcGJTeFprQ01HWmtKbTQ3R3NoK2duaXV2Qmhy?=
 =?utf-8?B?N1VvbEFOVFB4T1NFVDdNNDNPWGtQU0tiKzgwaVBReStVNEx5VUxyMzFHMmNv?=
 =?utf-8?B?ZDl1UXFnak5mT3RMUkpPRGpaczJDWTlLUGZENlNRQ2hxZ0ZqQkU4cEd6bEpY?=
 =?utf-8?B?MzM0THBmcmRjMnZPdHoyRXh0Ynp2V2g4TGM2OU1aZDJrL1gvbG9Gb1k1aEhz?=
 =?utf-8?B?aHdVQlJtRFhuREtmS09hcnFvcTBYK1N0UTVqUVpzSjlqQlNGc1pCelRWeS9Q?=
 =?utf-8?B?K1cxUFpCSk5aNncyTEUzZXV6Zy9sUXJOaTV0Umo2a0lFamxzOU1udG1nWTA1?=
 =?utf-8?B?MUoxYXVlbTVZWUpwZTBlaWc5NHdaTG5odnJjVWQvWFVTdlIwdXRaZ1NaMmJr?=
 =?utf-8?B?MEw2eS9tQ1ZBc1VNakw3a05iUkJTbnRKaDFLZEZFaFlqdlowTE9OWHpLaHEx?=
 =?utf-8?B?Rml2MWVDYkNyNURDaTd1REtkeXJ5SmYyL1JsNGpueFhIUTlCenpmTkJhT1dY?=
 =?utf-8?B?bW84ZGZjK041Q3RsMS9ha2JsZGI5SndaUlJWbnZVQmNxcUMyd2JzeDBKOGV0?=
 =?utf-8?B?QXFITUI4U1FqQm1pVlVNWUpBd0pRbER5U0ExREw5Mi9TSzJoY1VsYVdkd2hD?=
 =?utf-8?B?UFBaK2ZGeVc5TWtCU0pVK1pmSHhHbFphU3U2Nm9QVWJhSDhJVmUwZHllbkVh?=
 =?utf-8?B?bi9hVVIrYkxNbU1ja3MxYm85WU9WY1AzNm9jdkhLVHl0OWxRcEJWaHBuMkc5?=
 =?utf-8?B?SlI4UGZ4b1hpUmpoTE1kRk1JOHEwKzhyeEJyRHNodTRpQnZTaStYTUo5c1Zq?=
 =?utf-8?B?ZzhYczZWdis5NGdHRXJVcFNaNC93eEhkQ0N6KzhPS2NGOU40amRjVmxydzlJ?=
 =?utf-8?B?MWt0R3pBVEg5YzN3VmIwWEZHUFoyazBEa1hIU2JidGplWlFTcFFNNFV1YVhu?=
 =?utf-8?B?N1dydTFUU1JQbkFPTWZNNWt0bmxRbmZ3NHlQVzV6QW03a1JTRDBiMklQcmtG?=
 =?utf-8?B?bDduQUpXL1hZZmx5K1dERFdBYzV3TVBUWkdWWFV1SVdsbThhNFMxWW1EN08r?=
 =?utf-8?B?Tm90Z2tjaE9UeE5HcTRWVDJwemhGZExOdHZzcUQ5UTQvWXFGVlpKdFh3enU5?=
 =?utf-8?B?eUt3UmkxYlphdUY5MFlWMWdQU0M1V1diZEJid09ROGlIbU1nQjJUYnJPSDV3?=
 =?utf-8?B?TkxtZkNtOEVHKy9wUjlVSm1uYSs1MUs0a2dxbTJ2L3l4blo0SkVCRENZbHlK?=
 =?utf-8?B?TGJ5SVlKQkttT3RqTU1Iamc3anVWSE9SMWhKRDdHVm1HZWY4RWpjblRuY2lE?=
 =?utf-8?B?YjFxdmcydmxtdmVScFJ1Vzc0ckg5V1ZIL2J5eHNqT0xWV0cwWXRCaElKOFFm?=
 =?utf-8?B?VkxoR3l4d1VvVDV0bmhOVTh3Uy9vRWNvTlh3dHNPaHNROEN4cm5XdWRBZFc4?=
 =?utf-8?B?ZGRFT0lDRHMrZU1tK0pSN2pVR3BDUHhpSVBUYU1NbEp0Sitqd2kyVE9YNXlk?=
 =?utf-8?B?UE14M2ZHZUthZXBDbG82OG9scE1vOGl2QlhoZFRzRVd4bDNFZVFueXluUFhU?=
 =?utf-8?B?RCs5RDc2QkpKa3UvS1M2QTZ6RCtkbW4rRW1LaGNRdWk2ZU5jUk9TVWVsdW92?=
 =?utf-8?B?eVluMGJmOU9XaTQ3aGN6dllQK1NxMVVFekp0QVR1NVhKakZmekFrNVJZZzJY?=
 =?utf-8?B?N2R2SC9ldWJSbHlhWGJ6ZXo2dFU3YTVSbU1xZDIxVFh2MWZ3VTBpTFJzM2tX?=
 =?utf-8?Q?w/LBfw3jjt2seN5zxteMNCOUdnsoVhC+y48jo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf08db2-03d8-4838-b72b-08d90684f304
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:23:53.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boX2Avw8vgfQsEvFiLSqg2zTTHE5+1XgvJwEDvENDe73wDevwfyYQ1/3iOrtlJQq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5031
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: aK0tKNX847_WzesXhNBqAmFtvIDYUsKK
X-Proofpoint-GUID: aK0tKNX847_WzesXhNBqAmFtvIDYUsKK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Define __hidden helper macro in bpf_helpers.h, which is a short-hand for
> __attribute__((visibility("hidden"))). Add libbpf support to mark BPF
> subprograms marked with __hidden as static in BTF information to enforce BPF
> verifier's static function validation algorithm, which takes more information
> (caller's context) into account during a subprogram validation.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
