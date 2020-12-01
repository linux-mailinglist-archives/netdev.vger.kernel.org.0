Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A708C2CAFE6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgLAWX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:23:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgLAWX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:23:27 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1MJx4w006806;
        Tue, 1 Dec 2020 14:22:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qS1AfrGTQhD6BkrPIkkITuGY3FmHm8UPV6wAmVmOa/Y=;
 b=RsiDCg7jbWBB49kiU/lnWvvjyBZ4uNC4ZLLzXEt6k6QrIdoY04DXgovFtQMifa/JCNSd
 bsTRu/43HprE2f4AeQUHXqyOu3ewnwRVPOjIih7XZYXx+Dbo91XdS5HpLy7whvijgr7h
 Oskkyv2bvSJu6tkuL1kTRAWwmYXQQQPMtPQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355wgw0fau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Dec 2020 14:22:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 14:22:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2iacGw1JVwzjooukW1vcnZtyMsxoleMxu4nwRdJpRslcU2l6SL6AwyiGSAXYwzJW70l8mAgd7XI4rfU6Isc/GmZYboAXAheJCRlmqnjSlLllXYZFjVNcIQ1aXSvsmHBZNIWb5YC2o895fBQoSQitN9d0/P/HnMrE6nJRKTldZ2pOReQh75QXpzlHZ4pZXRKrBAS7zon6jPWagHEH703hFbooPC2Q2wBiSXbYZM7iCWeD8oBdavG+fvqgjwrbdFpNYq8U+jwPwONX5d3kVKakvpRfD285UNm+AmOKfbqlIZUxaKjEjauZ1VaSt8SWiQcYTar9GC0BR0Uk+c6J2j0kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qS1AfrGTQhD6BkrPIkkITuGY3FmHm8UPV6wAmVmOa/Y=;
 b=Rh40Ei7nPI5tzQtwfWs3Yq1aA7d7RDpSKMvflENhbUnZwIFKG10OAxose5kEhLg/xcwMdalBf0rezOV82F/Cg1GJNTOTua6uyQvq7eJ4Yid0j95cIHNJjMASphns/pzkRfCeTNafzw1c+6hpuIXwFJq1lXfo+0v9Gfi5LydGYChH295WgOWJMt6L209QlExwuS5yREj3MUQn1RyaaZr8eAoj0O9jcj/Totpzwk/A+VbQ2f0WeUhOIQNjV+zlzCZbkQUexxlHlhWwihI6/JVDfwKP0Eo8XojZcfjsNmQG5s1Fq/9FQw1HZ/qdoPiMmWsetBwHFV116KtI5nXP155ivg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qS1AfrGTQhD6BkrPIkkITuGY3FmHm8UPV6wAmVmOa/Y=;
 b=DG8QwlvLGsPtrDl09uYaxdlH7HNHC837bv0RqFqjOdE9gaGeY5OHixugjLerZ6ZhvAEbeQ822IyydndV4mD9u18kGtoNDpuE81hXz3Rhf8VuHwF/u5CoMEu9+t1cLt+qEk0i/NPcXxirSuyM2AiuDl5FJmuNgVh3zXP0pwyLE64=
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN7PR15MB2466.namprd15.prod.outlook.com (2603:10b6:406:8d::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 22:22:29 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::99d5:a35d:b921:6699]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::99d5:a35d:b921:6699%7]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 22:22:29 +0000
Subject: Re: [PATCH v3 bpf-next 0/7] libbpf: add support for kernel module BTF
 CO-RE relocations
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20201201034709.2918694-1-andrii@kernel.org>
 <CAADnVQLCrXZtrHKCZgLpDvy1F-Q1gubJuhiiHs6a1Z5ZPM9CwQ@mail.gmail.com>
 <CAEf4BzZAS71B6AQk2WCLA3d_vtsyYrA5bYT4YF0Wz7H=0XP8Fw@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <728b74ef-70c6-0031-fefa-804e290bdb0b@fb.com>
Date:   Tue, 1 Dec 2020 14:22:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <CAEf4BzZAS71B6AQk2WCLA3d_vtsyYrA5bYT4YF0Wz7H=0XP8Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:9017]
X-ClientProxiedBy: MWHPR17CA0079.namprd17.prod.outlook.com
 (2603:10b6:300:c2::17) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:9017) by MWHPR17CA0079.namprd17.prod.outlook.com (2603:10b6:300:c2::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 22:22:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40cbea7b-6c69-42d1-bbac-08d89647971f
X-MS-TrafficTypeDiagnostic: BN7PR15MB2466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR15MB246680BDBBC132927B8AEEC3D7F40@BN7PR15MB2466.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxMTVeNl5R2i8msQcbmT8lTT8DYhGQMsXxJ+P6naYaoDYk0+ndEKY9TMXHw3YNA71QuBT842iFAJK07Fv7m4C4aUTewd8E+zNfvo68Bv0J3n5ZHX/BfKpqYKP50ISsshbDCnaNqL11YhOHlTHPbOOkgn6EQx12YH+hy+p0/i67+M9OEdk9GpXMQKob3oKErV71yVBZCM1ILPErcVWmyrzV2p7VqVXA0bqGer/qacTmCSLxVMhUpEe9Lrzp2ZXMUfbWZgVX41MUJuPHj2ofgi5RlkiUsNDJe4kOnoLutp17WxP3HuFix/f08jN73vQQUg4KkUPELHzGBxfk4VyQQmmh/4lDx70jqi/i0UcP2uDZWXFSS1xlr/s/25xdlMrnIZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(39860400002)(396003)(136003)(53546011)(86362001)(5660300002)(2616005)(316002)(186003)(110136005)(66946007)(66476007)(66556008)(54906003)(8676002)(2906002)(31696002)(6666004)(8936002)(83380400001)(16526019)(478600001)(36756003)(4326008)(52116002)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ek9JdnhLSUxIc1A0bmFneG1GdTRyWDhZcmpPVm9FWEFvN21XMlNCOEgvdys0?=
 =?utf-8?B?RDkyNVoreTV0TzBua1BKbTJCSUFHczN3Tk01Mi9oRkQvRGNGbld0S1R6KzJw?=
 =?utf-8?B?WG1yMlQ2cEx1UFZyUCtQR1RqYmNuNlVoTXhFbFZLcUxmSkRHMTRtcklQSy9I?=
 =?utf-8?B?cTFCdC9CY1FzMnVRNUtRT3p6NDdraUxPWXFqOHkvM0xWUTVPbU1hbWNvUk8v?=
 =?utf-8?B?Ny9nT1luY1h6ZlBhYkN0L2xvOWE4V0JDbFR0V3I1MUtDazZ2L3dESmhoalhx?=
 =?utf-8?B?Y0tOcXdRRXBpaGQ0M04ybzNNbmdhR1VPU1hSMUFmZXAvYndPeXI0RXJCNllw?=
 =?utf-8?B?cmo1TW9jTnRjZVBZV2JsbUlDMEFLQ2JqcnRNRzJhUFNZMXJxc1FKVkppM3Ey?=
 =?utf-8?B?RG53R2laT1BnNDVBaGpVK2k4MzQ4ZWVNWGdGaGMveXI4UTdWYWN6Z1FPQU8y?=
 =?utf-8?B?R1h0NHZ4MkI0S2xlL3VtL0dkNzU0Z2FkMzdMQm56bEY5QUp0WGFxT01paTBh?=
 =?utf-8?B?cUFOdVNSanFhU2R1NzFQRjVSdWh3ZmErd2Y1bHJtN0VDSE9GMlRvUGgzOW1V?=
 =?utf-8?B?RDh3WDF3Nkc1SDZSeXFYVDAzYTlNb2Z3cmc4ZFp4TjdWMis2azA4eWo5VWta?=
 =?utf-8?B?L0pMQ3pPUE4yRmF5QVF1UXM4Tm8vd0lyNElnSWZyOEpnL2ZMdEpoSFgvNGlo?=
 =?utf-8?B?KzhINmdudGxnU3JjYlhBRmQ1Y2QyMVhNZUc5MTdGb0FpbjFxYlA2dFZLRHVs?=
 =?utf-8?B?NFVkSENWQ0UxbEZpOXBqRWJSTWlFK1NFMllOamI3dEhqWSs4ditJVlE3N0po?=
 =?utf-8?B?YVU0V0xyYzlwRGtPVUVaZi9CaGdvdVduYUtRcXlLZERueE9HUUp0UGlIZEhI?=
 =?utf-8?B?YTE0VldSN0lBa2RTUmJGYlBzUHpVVXRUeks3VjZiUGFrVmFoMERxY2cySzh0?=
 =?utf-8?B?eUhQS1NLWjMvTVRqZVBqY2gzWTJleHFNZ3Y2aml0RllTR2hWOGRZSXNTT3o0?=
 =?utf-8?B?cHN3Skdkb2lwaVFuYys4bTBkRWJHUTFlMzJUUDJJOW5CaWFZc1E3S2ltSGFC?=
 =?utf-8?B?UU51ZTRkSzBQNnUrdmN1ZTRHZGtjTE9BRENyUUpZUGk4dXpvc2YveFRKb3Rl?=
 =?utf-8?B?dHhra1dwc1VPSk84dFp2RlJqYWlBaFhCeVZhQWNkZ2FZeDIyVXVCaUFySWpH?=
 =?utf-8?B?K3VtRkdZZmFqQ2pSTkVpUTc5MG43dW03UlRCK3M3YkpaWHd4RmwxU2FVc1Bs?=
 =?utf-8?B?dGp2UmhLY1VXbzNtRk1EWUhUSXFvK1FGL0J5dmRkSjFYQUFqcE1uUDJzZGY5?=
 =?utf-8?B?aTNleUg3MVQrY3NyT3pJUitsODl0a2pDbzNpb210YmM1VkxZMktnNERJZGZN?=
 =?utf-8?B?L1J1YjBpa0ErL0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 40cbea7b-6c69-42d1-bbac-08d89647971f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 22:22:29.6957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: claofiUGdzTBS1NthECRjEJgKxd1bV9N0+AI0ZER+xLHeFqH5j9vUZJLE9u0YjjC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2466
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/20 1:49 PM, Andrii Nakryiko wrote:
> On Tue, Dec 1, 2020 at 1:30 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Mon, Nov 30, 2020 at 7:49 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>>>
>>> Implement libbpf support for performing CO-RE relocations against types in
>>> kernel module BTFs, in addition to existing vmlinux BTF support.
>>>
>>> This is a first step towards fully supporting kernel module BTFs. Subsequent
>>> patch sets will expand kernel and libbpf sides to allow using other
>>> BTF-powered capabilities (fentry/fexit, struct_ops, ksym externs, etc). For
>>> CO-RE relocations support, though, no extra kernel changes are necessary.
>>>
>>> This patch set also sets up a convenient and fully-controlled custom kernel
>>> module (called "bpf_testmod"), that is a predictable playground for all the
>>> BPF selftests, that rely on module BTFs.
>>>
>>> v2->v3:
>>>    - fix subtle uninitialized variable use in BTF ID iteration code;
>>
>> While testing this patch I've hit this:
> 
> Right, I ran into that while testing the second patch set
> (fexit/fentry one), and fixed in patch "bpf: keep module's
> btf_data_size intact after load". But I've mistakenly added it to the
> second patch set, not to this one, my bad. I'll move it into this one.
> Or maybe I should just combine those two now for easier logistics?

whichever way. Combining is fine by me, since I've looked at both sets 
already.
