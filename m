Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE51A331EAA
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 06:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCIFaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 00:30:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhCIFaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 00:30:01 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1295OunK004686;
        Mon, 8 Mar 2021 21:29:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=T6fj3MnThQSSucP+V6zuwXyzzI95cPKsS6uJPswBMAk=;
 b=BGn4vSHeBmXUFzUkkVDH+RDGOZ3YaNYDRNXmBWb4oQmDLtoAu1llA8ktEB3JBjHLCrl0
 di0spsPt2VmoPCsbn5rgD8JS0RKdRvsdyJaZGiIGYF7K0MCknXC1Vnu/xjjZxNu1qIeU
 /8TNeNcrpwlf5G9594jaDGDOOaKcckVAqZU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 374t980x56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Mar 2021 21:29:49 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Mar 2021 21:29:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc+ibPnkYnFBAqMxVT5wlWy4+1byeVPrxek5vd2o037wClNeFovl+u9ycJC/StWL7EStLtOoKBajdMHI/xD8eZ1t5fVBB/HWPJq7KS71ZKQSmzagFIzni08nJbiA82NL44FPTZDF5+cP824z5IKNGPItnJq6QUOcWScVHs/oYfAuwq9Hwaj8L+BFPZMbFQH9SbtAyNi7u+RduSytezkgzdNvgQ74emm52npcqs0nXiYbjymEpmIsTSS/stjrpO8z19MUGeCMRmWa7ruMqN9u6OorzAHsn+ZEX178Uln8NPKSIufdzpjnSMuuuMKjr8DCWIJ//Hy/Sbs2VhZzRA2iDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T6fj3MnThQSSucP+V6zuwXyzzI95cPKsS6uJPswBMAk=;
 b=kWl12eNR4/jGrAvSauDbb9A/vNzwIDYeAWmtDCsSySVUmVPAMS06x1t8m5TAsW9JpFPmR+6VxzCajlTq0EqIl721AZ5d6iWhGb4GooJr92bDSbZU2oJhMSY355+xKmg4/ACMfB5Uz8bK7YRh12k5vuqMGosgMmHaNBXCt2UpJumpl9NJqimxQ0q7tjEtd7zf0hw2c3SSCqOkqvwG2SWLRgcohQEsijZs33yV0lNA9lg1m56xEi98ydh1grBOrut2iCgte83ghyf/UNwU8oUMDH29LMO1uCWhycwLw9hgjYBWJMRfKbLtGeaViH6ZUW//wXBFvloYYcc0u4qm3tblqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2285.namprd15.prod.outlook.com (2603:10b6:805:19::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Tue, 9 Mar
 2021 05:29:47 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.039; Tue, 9 Mar 2021
 05:29:46 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compiler warning in
 BPF_KPROBE definition in loop6.c
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210309044322.3487636-1-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5e690d92-f385-6d79-4bb0-6dc8d9103309@fb.com>
Date:   Mon, 8 Mar 2021 21:29:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210309044322.3487636-1-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e530]
X-ClientProxiedBy: MWHPR1201CA0024.namprd12.prod.outlook.com
 (2603:10b6:301:4a::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1105] (2620:10d:c090:400::5:e530) by MWHPR1201CA0024.namprd12.prod.outlook.com (2603:10b6:301:4a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 05:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31db0cb0-f7fa-434c-8727-08d8e2bc5a26
X-MS-TrafficTypeDiagnostic: SN6PR15MB2285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB228544E0E3B9F512CB9F16C9D3929@SN6PR15MB2285.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IDCF1dK+aUCUt7btertNraKFjBu34dMNAB5sOlMqHv11PhKC3aVbYeO9QH1Wyt/0yQWSVdSH6x0Nmy+VuUNby3Ij/DqG69TdAY/LhVICGeNfj8asqhJObJ1RPFdN2d81lD+BKcUUqllk4eP5YXqxMLVEPDt0kqK1nCm0JiW3frY906KGZwdGh1XySqEXcKnB2h88zGyUzCF7Tp8zD87ER5tGqWhrg5vm+PqDArvT0F7A0PB0kHmOTtIeEhaD9CtGi9LfPIBCEU4hKxTUUovxrIw2xaaFbebGsX5vjPpngcGnboKtr8kGPm9svDR8UWouXEtosRz0ZpNT/3qovjFWlDPienT7gGURhcxpeqfG42/iEoXwkWl2b/jObA0BHxCnPwPxmJBovBiPFqLNlPLfNBJtPrwXxueyCryPvYm9vY34EvIqjNAsHQUhzwFX1cq7hA88z8Wa+FseQY+7PMs9yTNE7KniAQKI+/V28VTI7foO1xKbzNqL7zDmKrtFWUBkOSsSUxAPIqjTxkURY8RPHwS8yC9cMNC/yU+hY5I7aivLQqxZ9rdHxeM6omvWKNuQ9zWrEisY9JEFqTc7EjNJrSQIb0uy/a62L565ulCzYA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39860400002)(136003)(376002)(4326008)(36756003)(6486002)(8936002)(316002)(86362001)(66556008)(66476007)(66946007)(31696002)(31686004)(186003)(6666004)(16526019)(4744005)(478600001)(53546011)(83380400001)(5660300002)(8676002)(2616005)(52116002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RXU1ekFxNDF3eEJ6MVdpUXlJc3g0aXl4a3E0Z3NjKzlTamNlZjNxdlZFcXJi?=
 =?utf-8?B?cVkyVy9pRkNHamNidzMrQmE2emNveEcrMGkxNHlQY0l1NWxaL0JwTEowVE5i?=
 =?utf-8?B?WDZ1UWJjd3JkYS9jcmtiWHU0OFdibm00RkF6cmxLdERuVDFGbFo0clN0Q1k3?=
 =?utf-8?B?SEVOQXNhZDE2Vzk1MkVqSWpnK2xXTjNOSFFVRDF2RHJEZG1FNlVoM2N0Um5X?=
 =?utf-8?B?VndZalljZldCc24yUFVqRTcwenNlNE5CU1cvV1VUbDY2aE5ISy9SK1pWZ3Nl?=
 =?utf-8?B?NEg4K1ZkbG1ESjFBRXF4OENyOVNzWm1aN1BVYmN3VFVTNVRUQmJmZzErR3RL?=
 =?utf-8?B?b21OOUVZMTVneTBpQnJ5YStodGl3Rk95M3NvZGFUMmwzWk5NU2gyRnZYS2Ir?=
 =?utf-8?B?ZUxrNVgyNjJYYk9XVlRvUUVXeU5LcGt0SXV3bWhHMXk1ZHFzYm9YcEc5QlQ1?=
 =?utf-8?B?aGgvSzdiT0JKMEwvaGpVZ0doK3dldXAvMEl5U0dHYXhMQUp0bW1XU0xzUnNW?=
 =?utf-8?B?NE5oMjQ0RGJ2YWZKQm01K0NDdUhNRUNDMm5teVhEV1Zrd0Y4NmRvTU5HM2l4?=
 =?utf-8?B?OU84WlBhR2tVRDdHMUtuckdFRDFsc3dGM0oyYjV0OWNpSE9EcHk4aHM1SDhv?=
 =?utf-8?B?SlJIL2NoNGxFdSt3RXNmR2F4VkRhcDBaQ2wyMmU5alFHdmNPc3pKUHV3eUV2?=
 =?utf-8?B?VFlrTFpJWjFVMnl3S0R0ckI3S2tCSU42Ykd4Zm1tSVZiSkRpNGE4T3QxUlZs?=
 =?utf-8?B?dkxKNVJCdUovZTJzSkV1R2NkWDRKQUpUay9kZzdxTzZjdnRTb1BCaUdqMVhY?=
 =?utf-8?B?aDY2L1JwRE1sVkxvVC83dXJ5ZGVSNmkyU0hnOC9KY2toRzVYMWFxUnN5cEJX?=
 =?utf-8?B?ZGk3RVFiN0JTTGhPbDhzWGt1MlBQd2xRRDhpdDBhelVzSktOdFZrM0xnRkNm?=
 =?utf-8?B?ZU5Hdm5TeCsrWVZNb2RneVR0NXVxeHo3YmpVNnBidTZqRnE0ZHZvRkljR0di?=
 =?utf-8?B?ZXlLVzBRV3JYTkN4WXdiRzJGUEtnYzRoQmZqMm9hSzEvbzB5dEVsbE40RlQx?=
 =?utf-8?B?dGJEYWlsME5pNGZ4dGx1T2ROYnBOSTVEeXB6RDQwN3VFaCswWlZWclYzMi9Q?=
 =?utf-8?B?blRUME9Cd3dQZHdITVNac1Y5SFk4Y1JLWThHTmlhNWliQ2V6Q01jNGN4QUs4?=
 =?utf-8?B?aXlYdEZ0d1FIc25YMDZlYWIrNXI2b2lhNlhVbW5pUTNtdDIxSnpQUElORGJk?=
 =?utf-8?B?WDhPTlFjQnZaQnlLeHVEWWlVOURZREpMOXNwM2wveFRnQ2FuUWxKUUJjMG13?=
 =?utf-8?B?cFFwWVdlcFd0d2hkNk9EMHJmaG5xSDloY09ENHBaeEhBWkU5L3dxK2tTUFRp?=
 =?utf-8?B?em16MUtWb1NwelU1QWN0TzU3TXJDeFZEWGUxcGMvUmdLU1RwNE04UUpYR0Mr?=
 =?utf-8?B?ZXFFdUplNTVYYTh3d2R0NEpzcEdLTEM5QVFjK2dNMjRsMmxMa2s1V0YyVGtI?=
 =?utf-8?B?ekd3aWNPUGsvTW16RFlyY0phV0pLdmh6WFZQUnNGY0lLTXVUTUhtcWpSR2dT?=
 =?utf-8?B?S3FYRnVHOWhOYXhFNHAyRVFBby9iRGdCUXJNTXNKdjU4WW1Sd09FRWViUThR?=
 =?utf-8?B?THFPZmxKdENLZnJza3FIVFBVVUhzUnlSMWc5MjB4ekkxT1ZxRk5lWXNuYUcw?=
 =?utf-8?B?ZjZPQUpsNklQNUQxLzkzdlVpL3MxMmJyVFlycEVCVC9qVEZGYzlrQk5KSUhx?=
 =?utf-8?B?OEJsT1dieW4rNnp1UTNGNzVzbEFDUndML1BySFVtRStXNGZqaDdkYytTaW5O?=
 =?utf-8?B?OTlYeFBCbGI1WEVPTEsyZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 31db0cb0-f7fa-434c-8727-08d8e2bc5a26
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 05:29:46.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 437ISc3g0pNnEFtiLpqd1ZGhyJ8xE/sVvruYR+naFwBAcuAzdNXcz95IYovhA4g2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2285
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_03:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103090026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/21 8:43 PM, Andrii Nakryiko wrote:
> Add missing return type to BPF_KPROBE definition. Without it, compiler
> generates the following warning:
> 
> progs/loop6.c:68:12: warning: type specifier missing, defaults to 'int' [-Wimplicit-int]
> BPF_KPROBE(trace_virtqueue_add_sgs, void *unused, struct scatterlist **sgs,
>             ^
> 1 warning generated.
> 
> Fixes: 86a35af628e5 ("selftests/bpf: Add a verifier scale test with unknown bounded loop")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Oh, my bad. Thanks for fixing it!
Acked-by: Yonghong Song <yhs@fb.com>
