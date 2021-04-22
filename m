Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4921E3684AC
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhDVQUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:20:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43564 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235232AbhDVQUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:20:04 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MG85kg000317;
        Thu, 22 Apr 2021 09:19:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=FdKsSVu96wHk13n4NsPIY5bsNg7k4+pxrcAG33uX0IY=;
 b=VWMtOJ7qMuThEjC6auSnW1izcNs2OKhDXG3XJpBS6mRfekX2hRzqF7LfhziGQn+gsLaT
 00CGhhl1+8NbIKpTMJz+9u8egN51kz3V0cfihf9hxA6SKJBhvUvBRlzEkrOPXJxF0X7c
 5GFBLnzTKYiemOuzgUOvLLApRXC+/A8GLGw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 382kqp0q2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 09:19:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 09:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnmRBYDYaes1WqtgAYJ8sxSaCwsnZO4dqPhO9fKHjMSUNOURAX+DiUai3A9fnMl/rdvI/iWXK1YsknJ1efWjZkjWMl7Gol3hH/eB22kwgFVuREFVVWSemHIRO55NwtayIyXY5aNS39uTb1828/EBAqxzkSk45jQcijgV0UrSQbh3dAkmTbg06Dm5QAHH+bt4qlDmynEBjb/w58NLiM1KLlZ9TbBxFSdhpvT/W1/onELNUreseU2BuqeBcwiCqu9wshW1uQ8ZQO9hDKzrcdUMb/dFdBzXAmJENr9gwf8qaQXKnebk8vJRRFxGLZJc5DxdWWJs/jJ8x/8zVaTEaevBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdKsSVu96wHk13n4NsPIY5bsNg7k4+pxrcAG33uX0IY=;
 b=OMc0+mhVkYTjNSzs5X1ieCZE9tjVfffPe0Bcz09/ieavoMy2+KH9XAIwCuCM2AjqQwjFu5hV7xdozf8jqfLPcfFIa3tvkk84TBlwut2SCgx48l6dtah1kg64wpfldVLoKeSzyXG7NzBERAmLFqfqEKas1gLRNLHo1HqEoRf3s91mRRs6zNukqqFtFxVLKEZ2+4vC0JxvpPM/6DWGHfu1YwekyqlRzNyUEqLvWWrkAOQM1vKsHcLhaPCX/cxaOwbkSg637El46Y7B6wmQPxXq8g/WnXez9leIv/LPxRBXv0BJoo/vSdZ++N6cT+ulUVh+sxSOigtFsPCzA/rRn4L1BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 16:19:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 16:19:14 +0000
Subject: Re: [PATCH v2 bpf-next 08/17] libbpf: make few internal helpers
 available outside of libbpf.c
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-9-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e0ef3df5-6a29-843f-6a4c-b41c27aee720@fb.com>
Date:   Thu, 22 Apr 2021 09:19:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-9-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: MWHPR18CA0033.namprd18.prod.outlook.com
 (2603:10b6:320:31::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by MWHPR18CA0033.namprd18.prod.outlook.com (2603:10b6:320:31::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 16:19:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b6566ac-648d-4478-66d1-08d905aa5e8d
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49192A24E52A7030F7D3DEFED3469@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d6kg/uQgVnx1rwfC9Vn2D7CGg+Duv76wpLkHUWdjosmPJVQHMGDfT6xTdN/xcRZyVqZ70zLtWu/yBQtA1aCJJNzvn2nuqxs5MilNhDA0tQFivMwy9OMV0uTRx3ddrxNPKlQ428U4fjpXTCKlOkk3gK6KH4hfc4oh3yPJgdWB5dkIXBCJGKulsa/12JKB5T0zJexPuExyu9T60+PhgoM6prDXC2Z8rKezljYf2bVCsHax3/HdnqtvD2aQY4MYmx+UJYn/xIDKuOAiy7Y2KtzV+zDYLWWSQ/Z+HKq7ZXo95PwZrv4SzlTThBwA321mIQR/E9nkpRDcUe12dE6DLoW+hrKmfLysMfaYcNl4jBFlnKOHAzWS/989bEzmCi6EpJe2GlXdT6FpyG+Ptp+weilZ8ngm/VaKr7Tdb8Suf4tPD0Eq6anFDkr1iAjE4tiWtfMP2cxHQzZLnHjmTzxPvB68epLvgoXWz3evJdC3GwxBX5hkKfaDHCWSnwzxV4cqHESB9y4XaQsT9z9MHYUk0YppM6TIgDkcvbTi1+MVfgxeIeqq48ncKUQMzqwWszSttQrJpnJuJdoKeLmH8yctNXTe9RAT6sHPerBEHOa+JRNUUHywd6LPG9xUFH8NoRni7SzrAisl6WCNKmkptFRygEk93zhRGhQVLhkCyOiQnAglTA1V64hmMsilaxlzKigusnw1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(31696002)(4744005)(66476007)(86362001)(2616005)(2906002)(5660300002)(36756003)(498600001)(52116002)(8936002)(8676002)(53546011)(6486002)(38100700002)(186003)(66946007)(4326008)(66556008)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1c1aHN5eGoydENmZlpLTFF4S0ljOGxlc3NJYjU2VU01M2o0RDY1blBXTlFM?=
 =?utf-8?B?NmxPU0lWVGM1RjVCYTF4U1d4Y0RVR3AraDAyNHJlc2VBSStuVFdPZzg4aGw3?=
 =?utf-8?B?QUx2NDB3eHd6S2pMejd6Q082NysxN2xacjIzWDdtKzIyZkpJTWZoTnAxUFdV?=
 =?utf-8?B?Ykw0ajZnNlBFVUI2Y2lwZ2hjSk1GOWJJWm1PMFdxUHhkUUh6LzdubXM2a2VO?=
 =?utf-8?B?V2s2NVFrODBBUnRYRFNybXFsN1YybHQxaXZINWFXMHJZVTkvTDE0ZlNiODZ5?=
 =?utf-8?B?eEtlU2UzcDRZNjd2WDV3QU9sY2tlVlV0U0pRbEFReDZzcWZmZ1dIeTN5RDV6?=
 =?utf-8?B?a2dZbFVKYWt5TVFuNWpYT3o2UXA2QlJIOFVxdVN5TkxDU2ZQY0U4eCtzUVFH?=
 =?utf-8?B?WFF5d2VYd0xTdDhzbm5oSWgvd3FXU1pFTW9uR1BZSGFuQjhmWUZVQmdTYjdx?=
 =?utf-8?B?aklPRVBEd1gyTFdaNjFIeCtRanRzOTVmSGZSOGh1aC9vbzFjZ1VtSmxrb1RX?=
 =?utf-8?B?Um9Qcmh1WnRMbzJVOEtkSXJ1WmVHclRJUmMrMm5JMnZsY1dXVSt3d24zNUNq?=
 =?utf-8?B?a1l5RjBmWjdMb1JmdU5KNXBXcWVJaEZzYUtzQ0dQZTBOMDZZaENXNDdqM3Rk?=
 =?utf-8?B?bDY4ci9zQ1hIUUpuU1RHVEl1S2EycG1oN3l4bG5lSmJlTWFiYmhGdjdQVlVw?=
 =?utf-8?B?cE0vQWJlNWY0bmgxdWlEMjRCSmdvQUpxMmYzTFFSNlAvUG5OMzBmemlWMjVo?=
 =?utf-8?B?NXFnc0M3ZEdrdS92MUMyOGxyaXlRNytxb21uZkdWaDRzbjRvL0YwNFZpZ0xQ?=
 =?utf-8?B?SnBSeDlncmtQTE5GQlNiMytUZmViWUVkZkh4QXBDcFFhS0lOOTRFaThNcWhm?=
 =?utf-8?B?UmFLNlRueWtrK3ZXcnJMSVo1R2hrZHZYZ1F3YWNReXNOMmhLYzNNbjloNFhG?=
 =?utf-8?B?Y2RjSlBVK0V4Wk1OU05ndlQ5NnhYVUlzSXpIOUtCeUpMUGdabnlIZ3NUdDVw?=
 =?utf-8?B?RUxLTWtWbEpGcFE1S1g4MWF1WEVaKzNKV3ZQMENPVjFYUnJvdEI1RVVRZE1q?=
 =?utf-8?B?WkliczYyYTdyM25icHhyZmt4KzlLMUxDT1RHR1diRVJMd2RjZDhpTjNFQ2Z2?=
 =?utf-8?B?VFVzK3lycUw3SmRLc0diU3AvV0RETXFGdmxrSzJ2ck9XTm90R3BGRktpaGgw?=
 =?utf-8?B?SWt0MnY0S2Zyd2RkaHJ0dFJiYk5ZK1N4azJPdDV0Q3I0RGg2aTRyMlZ1Y1hC?=
 =?utf-8?B?TTJNL3BFYXFUQWN5bm9XNDBOUzFXamtwOHloSWxBdmhDM2hNdUtyb1M4YUh0?=
 =?utf-8?B?V1UzTUJPWkE0SlRNd0VrTVZoRytEMnNnRDhBZWVBTU9KQTlCWXpqOVJXVEVo?=
 =?utf-8?B?L1VCODc1dUdNNlg3K3FPR05SQ3NBbkp0VVlRZXErb0pyUDFYM25jZzhibmZV?=
 =?utf-8?B?V2VsYUVZNHphUGZTNXdvVTRHeU0rcWttYUJBWjdsM2FUTEJFeWdib29IRWFv?=
 =?utf-8?B?UWZsMTVaRFZUVFBDYkdESnVNeU0zN0xLcEMrOC9uMDlEdkxkZGlFK1BhVGk4?=
 =?utf-8?B?UW0yVlJ4SWlOZzB1Z0lNRE5nTStKa00yTmlRb2JQUnJJYk44T3Y2RnNrQ1Iz?=
 =?utf-8?B?R1YyK2VENFhLZ21mT1lDc0tFVUFKNXhBbVAyN0NQMEk0N0ExbzZBeEtGeUQ2?=
 =?utf-8?B?VDhTVU4vQXdPb1QrazJmZTRMdStVbzJod3cyM2pVVU5tSEN6UTFxYUNFTllK?=
 =?utf-8?B?QURra1k5S21EODlPNVc2SEYwMVlSM0xZT0JsK1hzUXBvZHpCK0FpWkdUWUtD?=
 =?utf-8?Q?Y7YFZ5lB5M7a1qHClKFkNJPBZD8DUaNhWC5Wo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6566ac-648d-4478-66d1-08d905aa5e8d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:19:14.0169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGkEnYob6kv2GDtOZWOF0WUbdi+CCjmMog54uHr0jWX28FaffUL2wo0gT5LOn++g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Kdl5q7iHLji4Q4BhitGhUAtzTjPq-shh
X-Proofpoint-ORIG-GUID: Kdl5q7iHLji4Q4BhitGhUAtzTjPq-shh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_11:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Make skip_mods_and_typedefs(), btf_kind_str(), and btf_func_linkage() helpers
> available outside of libbpf.c, to be used by static linker code.
> 
> Also do few cleanups (error code fixes, comment clean up, etc) that don't
> deserve their own commit.

In general, a separate commit will be good. In this case, we already 
have quite some commits in the patch set. So it should be okay
to add some minor cleanups here.

> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
