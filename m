Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5964F369D2E
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhDWXMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:12:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhDWXMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:12:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NN7oC3032553;
        Fri, 23 Apr 2021 16:11:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=J/s1FV4vF7o4S4XL+oB9YB/C8BqTZu+RPgJYHcjOpGg=;
 b=St9ERo1Ej1JRJWucsNGVL2xK2fSyppcHhWZeJGBi7Vfd41qgo6w28PhiRNA5QqiUDS1U
 ryHAoMQxajeJH1VjgMV73lpBykwB94gyJoZ5MMucD8qnks1aY+T9IBdP6zhl67ZylQrP
 aj/h67/R4OANSxiqmqrwS5NVKk3YfpLuA40= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3845w5gmp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 16:11:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:11:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QV7vwxU4NwX/khpKD5JUQz5Ben64dQYRwv5x7y7Gd4Z6kem4uCFWDh7q9kD11WeEOHcn/y5+zWs9Gt62IMOA5IW9LwS2gkvS9wFxmbc+2/6Nvpasrov22idANSKdl5m5ouIpgpCqaOxbMNZWyn1fZVdBz3i6KfCzwqlMiESY2qQTUBO7si2ulA0dCAd9UXG65huBzamkZEGW/h/svZRGafUI8OGGTG59OZ7hpIuAGCH8kmE1DnJPFyPeqHI2fzAUctdN71f17IIIDtEPuQ7TAa8PkmffvWFYV17Lxff4QzagPmdanUo4VMwtYJdMMHTnYrBqGhHfCjwRTsEYSZ6HeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/s1FV4vF7o4S4XL+oB9YB/C8BqTZu+RPgJYHcjOpGg=;
 b=BlCmE2szMgU1MmMD5zp2Zlzqfbbm5W7M8bmEQrFnZL4RFrTaC4eCMDOG82TPfzcU/qPNd09p4mOTNFrSiw14wWEpgJqZr/1L7tYFbLfDL3b0Z0lCX6hKBIV+X2DBfH4HkZqrbW0xJ/7Qt88uTsNssRTDXv87OTg0oI354YDVQ9FqaMCUuBhz72GOiuDqgFlCXQRQcAr1XGsyFef7ynXAr/iu8bW/JID4ptga5zCVhZgFbdykoYPpobNSxlYzeMP+NZJLRozwpPfT+6qr6IK+LQe99CRGAlM7xNDU5kJUrRkNPuRFWjWKMFoR0T9WSZI68yj3dSnPJRXE3ePdUezi7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4387.namprd15.prod.outlook.com (2603:10b6:806:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 23:11:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 23:11:50 +0000
Subject: Re: [PATCH v2 bpf-next 6/6] selftests/bpf: extend linked_maps
 selftests with static maps
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-7-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <50759ab5-65ca-4c4c-b24e-38aee568c08a@fb.com>
Date:   Fri, 23 Apr 2021 16:11:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-7-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7ce]
X-ClientProxiedBy: MW4PR04CA0358.namprd04.prod.outlook.com
 (2603:10b6:303:8a::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:a7ce) by MW4PR04CA0358.namprd04.prod.outlook.com (2603:10b6:303:8a::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 23:11:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d9d87f8-43d8-4418-df7b-08d906ad2ca5
X-MS-TrafficTypeDiagnostic: SA1PR15MB4387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB438716FCB14BC860A6C82499D3459@SA1PR15MB4387.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gFjT/bh5L10NvwpUrLb/IOqhDB/Sy1KR9QW+jLJMhAunU/9m8gxwG/cSe+tfh4LxCsrPMNvgW/4n2qzFd/stauqTG8vKj49Y+n+LTQ8C5rfL+C4QU8rIwpmvOHRpN2oPFQ33z0uor52yaYdw/jZf6jgtUGNF+uFAvGDc/p5XsBWjY9gHgXghTeN9h+kO6GQsXcoNUT7/VGJZn0niI1fEeSQvWQqICRZo3osjmViY/NvYvCxnDNr9VM9IaxOLZUVs1qTAQSNaQYL/vppP8hpXoNNEeVMOD/Ff2yPBkrfl/0UCxwzARkZlMGU5iIu6aDrFiZJcMo29S6kFX6UXoZczumSNCNpvIpCl4i4XQdU/Hom4X+MrWcllwP6WJ0U0t8rgRRuRFPqxyqqUTkZecPwZ1wDTxLOgiKQ/5yqbqcP/X/FHppy95wtNYsJSc64CZM5FK8l5KE78q0irdC8SAjJt190tphxiHH2IdL3pwFQfj5jGWWY5N6jLma1hPxSi+unM7RJY/w1kDgfpbjKYjWm1MNo+5bjW4cbxOpaP5+AUDUys+LIw+U8yRVwTe1fW/7/hphiYRODW1p0QgwewWpXtxCK1aZS6COtRc7Aye3N1gL132UO0SOE6dBqwnF5bB2zOGMRfZ4T/NVM1XsulGb+rZ8C1IegKetZDdY4o0hwahGb/hP/tqFYKqQNeK3tJjzUW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(31686004)(66476007)(31696002)(2616005)(86362001)(5660300002)(2906002)(4744005)(316002)(6486002)(8676002)(66556008)(186003)(36756003)(4326008)(6666004)(8936002)(53546011)(478600001)(52116002)(66946007)(38100700002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVNXV2ZXQTVyaGg3dHJoS1Z6TCtOK3Btd1VWUEZCRlBTVUkyWnNKYlBhYTV6?=
 =?utf-8?B?REVKazNxa3BYVWwrYlRKOGwwajU2NHp2SFJwZGpvZTU2VUZPRGVNdFByWXZm?=
 =?utf-8?B?Tm9HRGZFdS8zbFdzbENJQ1B4ZEJZQjZBYkVpdmR4YnA1SzhFbkJjT203ekNH?=
 =?utf-8?B?UDJzZlo3WjdvMHFBZGpnYzhxOS9oZHNBL1huYzN2Z0VXbnc1TmpJTXJURm9D?=
 =?utf-8?B?MFRST0Y5UjhYYzRIUTBDOG9YK05rRDV0YkFQbnBMeTk2M01HMTRPdXVBWWhO?=
 =?utf-8?B?OFgxUll6UUh3WDQ5RWRCUmxZM0puQU9EZnE0ZWtCek0wTHo4N1Bpc0xjYkE0?=
 =?utf-8?B?VmwxUzhkMmxlMEUyblU3SjIxTnZJMDBhSENWNWVKRVdoWjRtanB2Vm5BTnhL?=
 =?utf-8?B?QkJMbW5HRGlMUHlxWHdCRTU3SW12Zk1ybVEweEVsOGdmci90WkhuZ3FiemNz?=
 =?utf-8?B?ZGdrejE3UmM3dSsyMXJzRnNWU0tkcm1ETks0YmsxOFlpUmc0UFBrbFpWYTd2?=
 =?utf-8?B?TFJmbTRseTg1bTBBNHZaMW05dXV4cUpSejFwUzA5L29hY2VJY3c0WUdjTU5H?=
 =?utf-8?B?c0pDZlNaT05NM1VjTmlodUZ2bStpRE5MK1dZQ0FCVjZ2WlJPWlVXNWFmQ0Vw?=
 =?utf-8?B?Y1ZFejVrWVp1NndxWG4vTVBxbUQvY3lCMTg1ZHFESkNFNjgvVkVyVVFrOWJ3?=
 =?utf-8?B?SlNvTk1uZnY0VjhNYUE5WVRJbG9RT2M4bzZrMmxBYS81V1lSWFNhSUZYWWFI?=
 =?utf-8?B?L09hcW1yMFc2cTFydnlGTmdCZ3JLSkRVSm50eVVGTG9lTnBvY050SmRZamhm?=
 =?utf-8?B?ZXZpRFFEeTgrb0JsM0FPWjRKcS9BZHJrUE9MVzQ5UjJIaCtDNW9ISFNVZExO?=
 =?utf-8?B?cWRWTVFQaW5QbzhFS3ZBaFFZemNuczV2MEV4Ty90QUN6ekVqNExkbGxMaVFI?=
 =?utf-8?B?Nk1rUHF1Y3F4UW1ydWJyd3FPS2tvSnlMbjYwa2Z6Rm5OVGNodUZXcFg4YzQ4?=
 =?utf-8?B?ZEwvOU5ZazExZ3FXcmVlTEJrR215dStLSnYyM1FLcXJmZFVzTWVmcFBVWXor?=
 =?utf-8?B?eW1FR0VUSURjS2ZoaU9IUS9VaGx3MDRXSXNOVjlUMjY1ZlJvR1hVcjNoZzhR?=
 =?utf-8?B?am1iSEpVOU5YcDNMUjJJZUlRK1pGT1oxa0xYY3BHWUVYUVVKRFZrQkhreXJK?=
 =?utf-8?B?bmFHVmppb24xT2ZlRTlhY1g3TTZWU1gzK0Z6MlNDOWhPSm55QUhEbTlTdStL?=
 =?utf-8?B?M0xvMFNTYW1oTUtJcEVlNUwwQS9UcXhiOGFKaDNuZ3VvNmVaR3YxUzBTQUI4?=
 =?utf-8?B?Q0gxc05NanNVQlBPMDJBamdVU2NXdjNMbkJiZ1lKUEJPemRwUHpmbW4rSzd5?=
 =?utf-8?B?OXZxNTZ0MXBhMVI4ZW1SSVdkWkd0THRaQkpFNnhNVGRUWCtpSFRnWlZJQmQ2?=
 =?utf-8?B?TGJyaGJYV2lNbGd3a3FRRnk1SFVSUklYVVFrdUhkam1SVmV3TWpFZXMzWGh5?=
 =?utf-8?B?VWt4akFwZkRnZTVrbThGMG1wbXYvUjNmWlZRWFhCNGZLcUE5T0FrTUFPczJo?=
 =?utf-8?B?c1lGRmF2b0VDUHc1MmMxWEFFeGhFVWN6SS9lbW1HSTgzMnI5MTJkcTFIckVO?=
 =?utf-8?B?VEVaL3NVbzdvcXFrWlo5MVQ5R3lBdkRtR2oxSjZ5a21qc29ISk9YMVVBMURq?=
 =?utf-8?B?aGJrQ2o5Umc5a2h4UVY1dlE2OFJTb3A3Y1VvSUNNTjZZVVcwYkZLR2pMbHpN?=
 =?utf-8?B?SDF4US9YaXQvZVZDejZWV0NIRUJsUitYVmU2c09xb1pwT0pZekVkUEZERU1o?=
 =?utf-8?Q?J7AtoHmBlaYTTYuBztWws7pDClzfQA81h46CI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9d87f8-43d8-4418-df7b-08d906ad2ca5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:11:50.1940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJS5d8MAs+a3ENi3w1Ml1AH3ayhJRw32HjimXAU0K85xc5i8D357qYhyZgJpu6FY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4387
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: zr5PcsNYxjJpFhomVw2lWpJ41TA0JAuR
X-Proofpoint-GUID: zr5PcsNYxjJpFhomVw2lWpJ41TA0JAuR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Add static maps to linked_maps selftests, validating that static maps with the
> same name can co-exists in separate files and local references to such maps
> are resolved correctly within each individual file.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
