Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9217D369A65
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbhDWSuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:50:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243499AbhDWSuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:50:09 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIPBhF008758;
        Fri, 23 Apr 2021 11:49:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=22sysrwpxJCYEO/wUTdbYCU8tXV7E+LAKFStq/hI/aA=;
 b=Wdw/H1TY6K60IigErq0tO891YuBl/4mvK3b/yrsCeOi4U6ukIg2LQFZGS2hi9MOjKBqi
 eQuBKoxvxtiyms7PgrT4r9ZwVcDLmLLAbqbm3j/+sDCZlocKyzSvwAX1cWZGiUsN/W0G
 B9E8MQYfboN/83+iiPwllp8cKkqgjmAI/68= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383nvs46wx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:49:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:49:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU/KzbHZiLfJ4bOdWpP3TRNO+ouCcYGzg328v/hw6bjfMvMnobbG8x8olYCplAIsqO0LpATLPtXjinOvOg+E8oxmwjeHe/L9R788cthJKZvZVF/qhTxpPG1NCWbJT10gRFfKbIUP0Q/VNViCj027hkSZnQvnLlV/M+ScR76JfIi+DuQtx2t39vGhE9cHFkGzqmtbbKahEabK0TvSTV+xUUQNDLLXSaDwhiGGPoPS6ELkwpmOwhDXz/h8VQPubDG05NpyE5cIRT9m1tiqBV8eWpUkStwWr2rdpufEgeuWHxV6lY4VEhX1RZr1bJhnbODQIf/1CYG+ud/31xv0llzJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22sysrwpxJCYEO/wUTdbYCU8tXV7E+LAKFStq/hI/aA=;
 b=YMGPRr2dW3LCXNWpknuj0RlcsqUpl/5Nms2G2T+sZkE1RHrZN6N09gkdquFy8MuoNwtTrCHh3mQQaqC1MlkJe1J33FYc8fueKrBBrHOANYrj5N/JhqF8qhoK1TyJ/dta7mP+ytoChfw+SSbXY7yKAwTckBd0EyNpey53y90w2qTEtrk27l5+mFGMIyu8Fuk6XT99UvwtqzsepVoUfedPzPqmhQxCF7BE/JrTFzxo4uW3HOfoMKNL51mCI3/0abmX7Ey80JuyctT6ReiDfBvcdYlvx9Jr0s6SJfB1lqjUJcBOy+lT4cJhzEYfHUgnitkkqW4n9kROqy57173lB4koRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2032.namprd15.prod.outlook.com (2603:10b6:805:9::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 18:49:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:49:19 +0000
Subject: Re: [PATCH v3 bpf-next 12/18] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-13-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <df3be1a8-a8b7-b79a-2264-b5ccb2d5a105@fb.com>
Date:   Fri, 23 Apr 2021 11:49:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-13-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW2PR2101CA0013.namprd21.prod.outlook.com
 (2603:10b6:302:1::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW2PR2101CA0013.namprd21.prod.outlook.com (2603:10b6:302:1::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.7 via Frontend Transport; Fri, 23 Apr 2021 18:49:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90768a1f-f91d-4ba4-3e7f-08d906888058
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR1501MB203294B40206F43FC9CAA64FD3459@SN6PR1501MB2032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxBcW3lpUXoppYN3fXs0ab8Adi3pgejhW3WQUeUO8TIyIiwW2gniazyG+PPBlvb5dZQZgQ0gCIJ/3xFrOClUNHjlQ4cM1K0nxUni1PDtwsepPIqHkfMM9Ph6g/iwQ0BbS6R6690K6eZFuXkeMPNRSVYAsFBVQnEwHxIJhTdwpp6ptfdayzAQcI+JacNyta41dLn1aWu5r491IiUWq9teEBenyRgYNoIuLIDO3omlfiTgtkI7bAzQp5MdLFj5iID/b/vQzJEMxs2wiV/1fUVg5QMJ9K/P1wk/Ri2x6l3QtAu0ukG6zDAzqSCjriYK247onf4fAlM4uXCCz1//EOtlbGUmFIapz5zMkqcvWuHMumLw8bCHCYw87C9kdGDWd8zWMNh2eFTrp472u88yXph1TuXRu63RVQ3B25AuWibE6Q3M4intTDQI3s8YWbpPImD8r+LThK8LN8ZkN6yP9loZfvzTrZmaIyqCDk4UG/YdQBH+tJAduJtM+CgbQJiCiSP7Dqgb6WlAR14tocc1VqyX5DdwCyaVySqlmClpZkvP4tiuAwHIzW58iQIuB8niOrqpTv8u7+ylQApjoixfFz8fYNiPvzlKyL0Z9A5JKsl9e2QblJKU20xDV18oQbp+ks6Py7hyQZoQwYS91xrGTqWBIfsfSapJxS7o5p9nsGLFezZRrib43Pk2crrb/3cnVlJHKbCODU5kRIhisvolHMlehaYx7y4IJrBJP3Ti+ce1juY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(2906002)(2616005)(5660300002)(6486002)(6666004)(16526019)(52116002)(38100700002)(478600001)(186003)(8676002)(53546011)(86362001)(8936002)(316002)(31696002)(31686004)(4326008)(36756003)(66556008)(66476007)(66946007)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d2QwRmxNOVhiS2p2RlFWY0ZKL1ZwY0E1RUJ6VUxPT2EvWnovVVkwc3NIOHFp?=
 =?utf-8?B?cnJrSjdCbEhkVjhhbS9xWnBxS05kOVRCL3RxNWVyZDZCMWNyeHBLR3hYeGVH?=
 =?utf-8?B?QmpJUkthZVBGMUZWdUpJQis0NkZDaDBCeUs4UDVOMy9sb0k1b2dYbW1PL2dk?=
 =?utf-8?B?dmxreXRtd3AzQUkzckhXbW5VUVpZektVQnRMTHhDeHZVMDhzV2pTNW52ODgy?=
 =?utf-8?B?TEJlelJnVFJmcUhCa2xNMHBSRGxzS05CUWJHOENKc21mKzhMNWpkc2Irck9w?=
 =?utf-8?B?UzNubVBWMmxtUWlGU0Z2dDZsM240U0FlMjlDSU0vRTl4NE9IV3BBeUszVWNl?=
 =?utf-8?B?Z2krYVZvZ2JWTGo4bk1rT1RqY3FxS1NGREpVTmM1cEcwSHNxK2YxcUVuUmpV?=
 =?utf-8?B?SzVqN1pFeTBjUzUyN21UQ0FRYTRKamlzd200dkhCbk5Jd0ZrdHhDSXVlR25i?=
 =?utf-8?B?amcvNys2R3UyWHFqMTJFbTdzODdhQTJ6UEw2RmpxVVZJRXFsY3ZybFAvV2Zx?=
 =?utf-8?B?cHBzM2ZiQzJ5bUc5bUdFcUlPNEVtN2l4YUdUMCt6RVFGL00wV1hTVVk3N3lI?=
 =?utf-8?B?blN5ZWtyS0tyeDFRakFudVczQ3hwZ2JZS1BHVWdxSFRaY3h0bnVIM2N2bC9E?=
 =?utf-8?B?WGozb3cwa1k0U2RvcXBaQ1dldFFwY09weVc5dHpGVi9tdngzTjdLUjRuN0VM?=
 =?utf-8?B?aGRZNW1qbGxMRDh4U05FYzZtMkVsaWxLeTQwSEtRemxaQlROWDYyWW5TWmgx?=
 =?utf-8?B?SzVYcEFOUkdJZ3J1bXkvTE1taE5LUENGK3Znc0E3RjRmYThrZHgyRWcxcVpQ?=
 =?utf-8?B?QUVNMGR4c09tdHg1S3lKY0RkYXNWUVRIQ0FlTGExUjRCRkE4ZFNVbG9ucTBa?=
 =?utf-8?B?dll3WXFTeHRtQ1pLbURSOUZtdTJHS2YwQlZRclJKbmZ4RzVFTExTNWd4bnpa?=
 =?utf-8?B?c2tyV0RaeFJLVEV5Ykp2cUZDa3dDMnZOc2RvU1VSbk1CV04yYkQ5ODZvSHlV?=
 =?utf-8?B?UWNUOVJoR2lXdnNqRGdBSkV6N05WSTd5eDg0eWU1bGh3b1lMdXVWVHJjcEhl?=
 =?utf-8?B?TVU5Q0VDcGsrNFZnNEtkQlFZa0lndFlqOCtzdjFXVWowcGQwaTNEQjJwMlVq?=
 =?utf-8?B?WE1EOUVGMlJjcGIrdXZJMHcwUGE0TUNXNmJobnVualBzdWRqN1BsSzZMdGRF?=
 =?utf-8?B?SWJnU3piRXhSZks5V3o2Qk03S2JSd1p6T25NM1B3NDlJUlBSTUlnTmMzaTJm?=
 =?utf-8?B?SGg3N2dWUWlQdEd2b0pWVGsyNndOeHh6bUVCanBLalFxM1JqZ0E1NDU4a3dw?=
 =?utf-8?B?dG1vMW90QU13YmJjMlNhUnRxTklWR2VXRVhiTFZHelhDU3NEMFgxN0VPUnJF?=
 =?utf-8?B?M0UxN0hhWnhtRTB6VHd6YnYya2hnVzdUczVUeUlOTm8zZ2JSWUdSNzF5YjRr?=
 =?utf-8?B?L1Yyeithd0JNWGg3MlpFdnNHVUFpclJySWZlN0hPWHVMRU1rMmpFd3NEZ0Jh?=
 =?utf-8?B?dXp1ZE81Tms2U2JMSVlXNWQ3d1RyeTZQcW5xQm9zLzEzOWFuYzdWU0pKS0hF?=
 =?utf-8?B?M2V3UDEvbEZaZk9vT1hnd0VmVkN2QTRWSzZpMEt4dTB6cHR5a3ptektsY0R5?=
 =?utf-8?B?L2J0Z0p5Vm9wOWJnRGRFcHhpaHZlNkhFblVXUjVoQk5zcUFXUkI4aGdNVmRK?=
 =?utf-8?B?WkRoM3ZISlFPRVF3UFdGais1a3o4MWt2Q3h2NUtIVWc1MW5NZ3Z4QUljZCtB?=
 =?utf-8?B?TXdTTTNRclA0TUVGZkdFWjBwNnpLU3ZlMmNidVhCM3JRK20xemg3QkZWK1pv?=
 =?utf-8?Q?9pmcoREERMxrpxxz7Dzt2Ly7GL2vWNMcV7M+4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90768a1f-f91d-4ba4-3e7f-08d906888058
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:49:18.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lg4rCgOtzAMwHFIJQTc9HCE/TCWmsNmpOzjs7deF5TdU9zYQZpqTpZICmaC9A59r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2032
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: -_smtmLhD8nnd9xIet0G7H_GARJDKbWw
X-Proofpoint-ORIG-GUID: -_smtmLhD8nnd9xIet0G7H_GARJDKbWw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Add extra logic to handle map externs (only BTF-defined maps are supported for
> linking). Re-use the map parsing logic used during bpf_object__open(). Map
> externs are currently restricted to always match complete map definition. So
> all the specified attributes will be compared (down to pining, map_flags,
> numa_node, etc). In the future this restriction might be relaxed with no
> backwards compatibility issues. If any attribute is mismatched between extern
> and actual map definition, linker will report an error, pointing out which one
> mismatches.
> 
> The original intent was to allow for extern to specify attributes that matters
> (to user) to enforce. E.g., if you specify just key information and omit
> value, then any value fits. Similarly, it should have been possible to enforce
> map_flags, pinning, and any other possible map attribute. Unfortunately, that
> means that multiple externs can be only partially overlapping with each other,
> which means linker would need to combine their type definitions to end up with
> the most restrictive and fullest map definition. This requires an extra amount
> of BTF manipulation which at this time was deemed unnecessary and would
> require further extending generic BTF writer APIs. So that is left for future
> follow ups, if there will be demand for that. But the idea seems intresting
> and useful, so I want to document it here.
> 
> Weak definitions are also supported, but are pretty strict as well, just
> like externs: all weak map definitions have to match exactly. In the follow up
> patches this most probably will be relaxed, with __weak map definitions being
> able to differ between each other (with non-weak definition always winning, of
> course).
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
