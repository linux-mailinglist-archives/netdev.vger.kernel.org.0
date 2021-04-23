Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96EC368998
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbhDWAGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:06:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235302AbhDWAGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:06:10 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MNwNo2017082;
        Thu, 22 Apr 2021 17:05:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=q5VDNZUzgj5fDf4QXdJdQF/dFCf8JtrQlHrkEEEdipw=;
 b=HqkCB7QidQwpe3ya/Q8phM9dVnRRZxmf3zYSwM3/bxioyAjnG6CioaFZPPho3AH3WYSx
 u0bD8thPojbD0sqHQOoE6DKx9q8I1uNprEn2C8oFbfA9x4evS5YhY/zPZkpXt4Q+KITJ
 FEy8961pz5yeYPf3I2HgZD+wpgVMkYYOfVc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382kqp3buf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 17:05:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 17:05:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3f3S3/x+UUwtMByKFqLSlpLExoUNWMwtvI2KU6IW6Gag4ybzqaKX4Q/kKQ6B8WpDZHqbORBnwC1BTZgBQsjl+t5ohtdOSm8iWe8docW4MULf+cTj/iaGTExjuc9g24MpT3cgAnVbTuYlilQBWh3emUXKSKKiBwwuoU/ACdP11V9YDDzHc+58CVKANtDUg95HQnWxClDfolSfKNA9aicNxodWewZJ2vXUV00+gX4u9hantQoFFQX10YiZnrALqjBbGnCd+CVgi41mi8iJ+RTMEnDqJYWUyLQ6uNWFtAxBK1sJgMIukXy9z3zOT1kLxs26yFxhyiy7MVEW+KwZyPaSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q5VDNZUzgj5fDf4QXdJdQF/dFCf8JtrQlHrkEEEdipw=;
 b=Cxeez1C0ifqmVdhdBOfBuV5ixQMMMfYW+yg7se40ywrE2fK4bbb/HdHdy9VGW1WR/acZUViet3nK0FgltNtIxeHXjnjTe0lN87tXIkNWflDZGCZXNWAePCY15Zcb6ZaI3HJQzbSdyy+YBv0x2iGNlSvCc1ItqNZ5DH/nID8CYE+nSH0ScUwFRSi7xG+ejZFZza7ATIbcMZ9APJtx9DZf3RXUXluWbU3+ucAvfr6Xu1kIXvLw21ueIH/khxHjJa4xsuTULBxo5urJfVIDjpb3+Hc6zRgyUtEwzqjWLDQmG5ejYKaEpTYUTO9kLH1fu7KLX8KuxSNMmGYFGlc5JXEzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4434.namprd15.prod.outlook.com (2603:10b6:806:195::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 00:05:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 00:05:20 +0000
Subject: Re: [PATCH v2 bpf-next 13/17] selftests/bpf: use -O0 instead of -Og
 in selftests builds
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-14-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac701563-69aa-5cfd-8875-69cc5fae27b4@fb.com>
Date:   Thu, 22 Apr 2021 17:05:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-14-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:83f]
X-ClientProxiedBy: MWHPR15CA0039.namprd15.prod.outlook.com
 (2603:10b6:300:ad::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:83f) by MWHPR15CA0039.namprd15.prod.outlook.com (2603:10b6:300:ad::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 00:05:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37285c81-1396-498e-bf5d-08d905eb7b97
X-MS-TrafficTypeDiagnostic: SA1PR15MB4434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44342959C46933E390601EA7D3459@SA1PR15MB4434.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/kR6DByFP9ONGqB1H6FfRSIQhuLb26Os3YK5PvhdowHtaYDwRR2Tk9rDqNOTndK6zV5j52i0iSCQf3a37XfuxN5cqoMBpjRw1Je0PorrxCsyuh5tPGhdinGeJtCCiaDODlK7kelc0r+dh6EmMJPIw1FB36jLkUVLPbnaqc9hlWhZ3d8n8E2I2vSohhkizZaZRH6vQY02YoiPPDrzsHlu+jAf5WagswsOrBrzMdJZR2ql+Zc8f8/mm73l6SrYxr6Awz5slQpFVsRAVdKt3eyOyZ1v8E4Ulk1ZFVQj6zd20QoAKOBxIiflt/YBj+bZt9FN4iRrBK6/jwCVpq7h0BZwezBUf+fHx/uHxz/cMTTn8R/D/FjPrqexc/Ar/fRon7Rm5mRJRizgMyzVr0+bWzndVUOOrVBuVHvqwuUH+rFYdgRvVQN6+ex5TLXy8OoFJWA+WpkxHoPOOTS8sjBah5Eh1z9zW4g7FKL43C4XvK4kIN6zBYLOpw/Qk04vA7wGvCpIJYgUe6EBPpunc08OJ6ShGZZ7rysX4Ja83k6QIlLuDnFQ4DuIkFCHY8p/XARUoi/RUXU2poFS/MIk1OOeQa1l91jgBDkkaCbI7R8mdpuh3fIflZOrSA1HpSHzX4rDOUFQFs2fV+cpBbP66v/X0avI4oOKEAxDmueo6fFNEPX6eJ0U31AedePE0VBdtoH5ite
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(2906002)(5660300002)(53546011)(186003)(8936002)(2616005)(16526019)(31696002)(4326008)(66476007)(8676002)(6486002)(66556008)(31686004)(52116002)(66946007)(38100700002)(36756003)(4744005)(86362001)(478600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTRBdmFEamQ2V0FkOTRTblNSeFozb1ZFQTJhajAxZm82VnA1OHhvM3ZrM29v?=
 =?utf-8?B?dHBLSmZOT1Ava0ZtKzRVQ21aOFVla3I5YXdHdHU1QWhaWFRPRi9TUlNtcXJN?=
 =?utf-8?B?Y1FNVEFvNmNtZy9CK0Q0MFUwcHh0a0J3L1ozV1YwbndkNXJla2MzVkZxS1VZ?=
 =?utf-8?B?R1FpcTg5ZFJKclYyaW4vOFhXYVRUazJRV2NhN1JIa2lBdW9HcDRDSzRTendn?=
 =?utf-8?B?bTdGSmk2c2ZKY0J5Vm9JVHdMaDFkUTB4RVo0VTYvNjJiSHl3VDFIZitCL3hS?=
 =?utf-8?B?Q0hsemxWVDQ1S0hIOHB6U2pzbnpJS1cwR2dZSG4ycTFnWU9EV2MvVVMwYkND?=
 =?utf-8?B?SEgxaEpaUnY2NUlmU3pYNmx0dTBzWlcxTXdZNkNhSUp4dTVTUFg3NHFYVEhZ?=
 =?utf-8?B?eC9tS2NxNE5XWWp5aUlEcURLMnMxVXhvbmFzRmZlMlAva2pFYWZtMGtRZTFr?=
 =?utf-8?B?K2t5UTI3Rjg0QktEa0hKNVdxTkREVXN2VmZzeHdJOVh2V3FibXhuUGlYTkdQ?=
 =?utf-8?B?eTFtZkZONEFvVVpuZXVSdFFUYW1OQ1pELzZsdUE0QTNlTm93Snd2d2NOU3N3?=
 =?utf-8?B?dUJENW12WHM5OHdwMXpaQy8za2IzWFdxS2YybmI3K01DRURjTU5NMjRwZG83?=
 =?utf-8?B?TU5ld2xKQUt5LzRvNzJua2tSOFNuay90YmpmTXJzOHpYUE9FMU90eHQzSFJh?=
 =?utf-8?B?QVpDWVY1K29kaXdzemlOQmhMend6aVl3TDNWRzZyWjlMQTY1UEIrbVZVRGw3?=
 =?utf-8?B?eWJqMUlNQ2ZVYXRjWDVER3hZMlZESk1aM1UyeS9icVhaUzArWWtGWjVxTmw3?=
 =?utf-8?B?TGw5OHkrU0NIcGEvTWpkRkpTbi9rUDB4S0prZkt4NGdFY0twNFdmN0p3dlYv?=
 =?utf-8?B?U2RLZCt5SGlFOENUeEdoaWYwWlhJMlhRR0hrOTlXUUtBWXRxUS9kcENZK3d0?=
 =?utf-8?B?OE1MdmI1dnpEcS9YbkdZZE1zY3lCYVlYTmxzVVgwUFh6T29SWXgyRXE3RXBY?=
 =?utf-8?B?bklROFdWa1NIZ05Nb24vRDdDSzhXUjQzc1lPSVhsZVZkVnBlVE04L1R2NW1M?=
 =?utf-8?B?eCtwbksrK1FnaDFibkh6VVF3N0ZZL3c3QzZqaXEreUszMFZoL2U4SHpMMmU0?=
 =?utf-8?B?L0dGV3k3MGgwQW81QzEyOS91cmdCUXpOS01mY1VYMVZ6dC83eHRmYVdCUFg4?=
 =?utf-8?B?czRsKzFKY1FnSGRodW5BZGNVZDkyUlc2K0IvRXZlYk91SmZETEdTcXd0NThx?=
 =?utf-8?B?T2paYkhRcnBhcXFGZWxEbWlDdnU3bmsxYlBmeGpPWVQzc0lJUzhwdVRhNDVa?=
 =?utf-8?B?WWdjRGRpUnZXaHpsTSthUnVzdjk3bnVLYWd2Q2lHc2hNZHdodlh2QkdXZE4r?=
 =?utf-8?B?ZTREbFdiVVdUTmRXNFZhWHk0WmtuN3BubXpVYVJnNEgwS2M3RmZRRmFGMVpS?=
 =?utf-8?B?cmlOYk5sVjFSelN0MndSRFdidE5QS1lldkttOEU2dENRbmpscUNmQzZlNTBN?=
 =?utf-8?B?c3JWVm1PV3V2NzA0U2U1NmFUaDhZMVRtemZ6K2RHSnBHUTdIekIreEliamZR?=
 =?utf-8?B?bC8wQlRaNDAxRTB5Y2VESnFEV2t2Vkp6ellhdm5rTnJlZmVwdk84SlBuR0la?=
 =?utf-8?B?ckpDc1MzU2JueG02cmx1WFhhZkQwMkZoUDlXQzRWR2lXQ1doT0pXNitFMFll?=
 =?utf-8?B?cXF2YzJrVDd1cmdKb0xIWktIbnpuOTFUVVYvQm5xUmZTTTlkRW5WR3RVdEsy?=
 =?utf-8?B?S1AxbHB3b3FNVHpYM3JaMkNSbmlQRHJZMFVFU0VWdGZvTWtrM0ZqSlJJTnVy?=
 =?utf-8?Q?7cCwpJiQmo2DE+TozY673dcoHAm+5U/b8HAjo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37285c81-1396-498e-bf5d-08d905eb7b97
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 00:05:20.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ag9L1rYmoZp8EtnJm09b7pyMNob4jwkisVeH9vM6Yzd41egRuycpmOdahID765Iu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4434
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: a7qdtFzdaBMT3Uq6-H8ALoqgSCVbrKyf
X-Proofpoint-ORIG-GUID: a7qdtFzdaBMT3Uq6-H8ALoqgSCVbrKyf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_15:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=930 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220177
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
> While -Og is designed to work well with debugger, it's still inferior to -O0
> in terms of debuggability experience. It will cause some variables to still be
> inlined, it will also prevent single-stepping some statements and otherwise
> interfere with debugging experience. So switch to -O0 which turns off any
> optimization and provides the best debugging experience.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
