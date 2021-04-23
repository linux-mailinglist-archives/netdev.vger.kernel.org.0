Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1A6369B14
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbhDWUEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:04:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243798AbhDWUEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:04:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NK0wNB022328;
        Fri, 23 Apr 2021 13:02:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KDqY+P3o/0n1egIpsb1BiPJdysBUvvzdxJaWJWnoNJg=;
 b=h5EUYvbw6ZZck/Wrf8mFqeg+4wa20tIfhuKsDZPW6LRzUXeHuI7FEYKAcrQVgtZgUffO
 o7617jIZ5iEkGiP2KtAah7Ydnf9SdiYXeodrSwq2rN4xrDqhpxUq5taYzF7WaeTqYFZ3
 I1tJ4Jm+5PCvrHsDdc7O19z6O3EymMq7gCQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383nvs4j4f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 13:02:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 13:02:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYFFrdGKG0qeb3RwBmDPwHBBufPnGWdAvdFM9jeMyrOnh9wkT2+Ya+VvdutFkwU238Dm45ka8XAq0Tn87a2mef6JmOmMcOpW2OVeyng4WmWsLV3iNqDBk6A1JpOZzFOm6TZ8DqB/icg2S0zyi6UwrKw2L/txASX41Bvh2SoX6IJGOU6Ewiv8TXrU0bZF9EFiOpvvAOuMcQlN2KR4whUiUp71HrROI0/FC6rVoymlb4Qy3SZgdS8Q9BD/qnsHxHWumZ+VPIUCzK+JLPq+gYhwst4N4ns10eaW3UO3Nj2A9UFkPAPToNveP17vHwZmuFbNqAwZsK/MaKMTFQYyD8Eejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDqY+P3o/0n1egIpsb1BiPJdysBUvvzdxJaWJWnoNJg=;
 b=mF//EtUELQMIOkiDEKeRO5JRGbkufnqpa1UTdKlGg3sv//kJDNBPgZDB84wWd744Rd9O6qUXh40hlcFCFj9jeGLhtQTNVHDdnDLLCWJ7Fq+4QHn1xacjQUxecPqc9pP9V/395iCXmawICKc/WxdcK9/3COw8qdq7mCtIIvZVqd47GFZFycmkLIeJYxEBeL+zhq6bjnvLAZTEbnmoOJmsiN8d59jiMh6Ro4cTkLZb4VrGOsMiEVLDwU5YfbbYe8Y1dUpAK/4l4X3smt3NelVTGgjaCEMZwEKMnBxt8ZI202M/swCBeGVdDoJuUuUWLA2XfBUyAqlyRlsKLqsIBp0FFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4419.namprd15.prod.outlook.com (2603:10b6:806:196::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 20:02:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 20:02:36 +0000
Subject: Re: [PATCH v2 bpf-next 1/6] bpftool: strip const/volatile/restrict
 modifiers from .bss and .data vars
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-2-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8bc69408-86ad-bf3e-3007-a80d95be6a61@fb.com>
Date:   Fri, 23 Apr 2021 13:02:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-2-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW4PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:303:8c::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW4PR03CA0137.namprd03.prod.outlook.com (2603:10b6:303:8c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 20:02:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 349f7da8-9a21-4de9-c6b9-08d90692bd4f
X-MS-TrafficTypeDiagnostic: SA1PR15MB4419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4419DFBB6CAB3D74B719EBF7D3459@SA1PR15MB4419.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g7MbClpVHSFUSo75Dc3lIyRzmCZv1V6BBWQ7Nmhqs0yG93rS/mdD+MP8fY1S3fHps5g3lIRE1mt+ApG78vVmPgEj6W4K9P/s8QIWTcf3Otqhw+Aa3IgYbHlBX4AXwpQ7HbU+f5107zAu9F4tNs3fYfHPgbOJaFQGerbkbMv5+C1mti+V8IBQLmQXJP2kWO9qW3J9ASy8RsgeO8Tcgh082zPPQ640lI4gvoxVngJOx4dUykUgodh75qZMplg/RljFp3S4RzWnt+xvKVdPSryNd1vM6T1jzKNx8p4VOvWyte+bR8tNoGJK2IllRtFtX+9tmuy07MGqz8MjYHexDozvGP47+ADMJP9HggGTT6iFyBA2OpevU4qMwtXu5o/zGiSpme+CyVAAA23J9Y11LAeu2HmZVOyWOAhocWerPZw+VQYJabF/q6PcBU5bzLtPGkyL2uCbm5PksPV7L8nqAaTmf67vWCQtIDBGNsYE8fz4GW6onKlp6qQ0NSAUuabsmAeBuCO5n5usw7+EniDKukUegb4WC8iF4IiFyNMh1HIF/U7su5CU6bilSb+g4Quu5s1TnKT2rWDCGnh/vq4SZ0ZE6qkHkbQYiMxJN4KN5gmDq+u/pZBEKLs4EArc4Rcep/eM1hkTI/PAoZ6FRUT6oo6f/n0HO8lU3nLovzKqDcvX5OJcp+jcLDg8t1caVRA9wypBcsyc1PvI2rPTlesdnfvfjpTX/yYPQiYm2p+iagVtlk4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(558084003)(66556008)(316002)(52116002)(86362001)(8676002)(36756003)(478600001)(38100700002)(4326008)(16526019)(2906002)(31686004)(66476007)(6486002)(53546011)(186003)(2616005)(31696002)(5660300002)(8936002)(66946007)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NDNBRERoSXBFRWdHRnlIUGgxd1RIdEJ6OHpuL2lkRHN6MkJMak1kVzJTZEdN?=
 =?utf-8?B?OUczREN6Vmk3MWdEQ25hVDdpdUxIMnZoSGwrWXFHUVhOL3JwTm84VUcwSDNz?=
 =?utf-8?B?dzhhVUlJemQzK3k2VGJESktja3FwL2haSG4rSTc4a1BHVW9LaVoyWjJiRXpl?=
 =?utf-8?B?NGl1cDNKNUY5NENXcVZwZm84Z2R1bmxoOXUwSERzWEpUR3IyMGg5NUhwRXZP?=
 =?utf-8?B?RTNzRTJjRzRtK2tjcDYwb3Vianc4Rk15S0JYdnBYaktQK2xqSjI0MkZ6dlQr?=
 =?utf-8?B?RmJ1VDMzL3RXVHpra1h5R1NHQm5obWtwWkRHZjU0akNuMlQxZzF1WkwyaVh5?=
 =?utf-8?B?bnFzZmxPWWk2amhnSExkU0ZHYS9BbE0xcG1YOW42MlFRUjVNeVp5dktzRysw?=
 =?utf-8?B?Yy80dGhGM1pWWDV5NFRKVjV1WVp2MkR1NUZZc290YzBONG5nc2NWL3QzMHlo?=
 =?utf-8?B?L0c0WFdHKzhIR1BFNUNjU0lGR2R5emx1bGxGUnBCcEgzUGR2ZWIya25qdkJS?=
 =?utf-8?B?OGtQR28rQXFHKzlEMk80dnd6T2pHeC9oSmVOQlQ2Vi9taVNwaEFRaDE5MGNq?=
 =?utf-8?B?TlNtWXAxdk1WN3hEK0lORi9GZkY0akI2MC9lMUdPVk15R0NPNzZtM3RHUkVs?=
 =?utf-8?B?Y0ZaVFJ0TFZQbHpzUHVuSzk1LzhjZmdaZkJkOGluN0h2QXEwM1Z6YXZEOXFT?=
 =?utf-8?B?dVJyUE8yQXdPQ2JQMGlKUUdtcldDUmgwOS9KWkZHNzBhZ3NOZmh4NUViNlJJ?=
 =?utf-8?B?MTUxalVBY3d3QWYraXh6VDdKNEZod1VRQ3pob2lzaFAvamxaZkZUNVRZWG1i?=
 =?utf-8?B?cU14cFM1UVN2R0ZGRW9keW5LdWVQQ0NKR2R3cmJJZUowdDZlZUkwZHVoelQ2?=
 =?utf-8?B?KzJuVDQ3WGk3YWpHQUdmYjNFaGxTbWwzS3FBdkU3aXZRWFgwWXNXanBHdnpU?=
 =?utf-8?B?aVBWNDFpMGROZmhxaVBLTGZQQzRVR2JldHg2TmdQUHB3bzh5VzVTNFVZcjk2?=
 =?utf-8?B?amFWYWtvMWtrK0E0aWFlZmpCWlV5Q1lMQXBvRjRlQTRLa0s0KzFkdHRTSVhF?=
 =?utf-8?B?ekpDbFdyUFcyb2tiWWs3ZDZ1eFlmRlhGY25MSmNFRG5acjB1bEJ3eWpSeC8z?=
 =?utf-8?B?UXZ5RTlzZE9qczRJMFVZWWlOZ0J3WFNWWGM3T1F0MlhidzMxVDRibkQ1c1dW?=
 =?utf-8?B?U04zdHV6YkNxMkFTK3VQa2UzajVXY2tFemdCMnBkM1JLZ3JMMm1kQm5hNElz?=
 =?utf-8?B?bnN2MjJTcm85SkRJaG40KytRVmtiZzhWcU13RjdzUGE2TlJ0bVc0OW9RN0k5?=
 =?utf-8?B?L3V3ekN3NGRZbDYrSUZjYm1TYk90Q2dxV1BteVdVWkFmU0hpYVFhdG5IdWk5?=
 =?utf-8?B?aW5TV1Z2c1hqTTVKZmRBR1V4SlJiSlg5TVhXQnRzZXh3RnJPR2JUZ21wM2Zt?=
 =?utf-8?B?ZC9SM3drS3ZaV1JyWjBoZkcxcGk4SXFQZHc5REVxeHhsY3FONTIzR2dNbysz?=
 =?utf-8?B?KzFxYlNHM3g4Y25ZcVYyZWZNMkY2NUZwbjlZN2xlUytJYitIUGU5STg3SHZS?=
 =?utf-8?B?dW9iZ0NOcmh4WlV1K3dkalZoK2JteXFzNW0zVzY3dlNzejFjck1lZXl4aTYw?=
 =?utf-8?B?QVdPaXAxUmpNNDM1eTdYY0VINXhOM0xWM1ltMjFkWEpLT1c1amQzYm1xM1lW?=
 =?utf-8?B?NmwxdVBZcVRDZk8vb0lFdmtqTk1YZzF5RUxSeCtxVjlUenFaVlo5S0Z4OWhj?=
 =?utf-8?B?UWZFU1JteExJV0h0MURqR3dYSkpDekI0U1loZEYzdnh4TW1RdEVYVlRneDVr?=
 =?utf-8?Q?EscJSaoYcD90bt617XfaAN2v9AABOEIZj/TNI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 349f7da8-9a21-4de9-c6b9-08d90692bd4f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 20:02:36.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkWYsxXiB4/TxheatkFQkd/01l9Xsny6K/X282OLjmZfCF12shsroJTJz07Xg/if
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4419
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OY-SAHhkyRfgnKCCkSFRq2VDNAl81zBA
X-Proofpoint-ORIG-GUID: OY-SAHhkyRfgnKCCkSFRq2VDNAl81zBA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_10:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=848 malwarescore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Similarly to .rodata, strip any const/volatile/restrict modifiers when
> generating BPF skeleton. They are not helpful and actually just get in the way.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
