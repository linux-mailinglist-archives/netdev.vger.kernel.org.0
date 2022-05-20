Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92452F0B1
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351619AbiETQaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiETQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:30:12 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C54217DDD5;
        Fri, 20 May 2022 09:30:11 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KBkbuP001324;
        Fri, 20 May 2022 09:29:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fGsFNDkNpkR6u/tuKX6mNBPRx9n46xT/nZMY0JZx3HE=;
 b=lHu7coBS/AJOnzW88jaIAct8BD0AW9O6nfHUuSnAooLwH4jc+9zGJtF1FsJUOLeH1PA5
 uLfKhGeakcZd9ZVnZMN+3yRf0rBRlCSLw/2wnHSfVwNBaGU8ht5+ZaziCGGXDokam7hn
 mEehEMRHz3jtJ4UjDqqK7gmooGYIIKRE/b8= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5rgj7y69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 09:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chGulurWMVr5XoteYpiCz767iltSIXgyLQNpanCo//kW6UYq5HGXFslDPrMNUBi7SIZKwByLo1t1vh6aePob/vxcNfUiuib6E2FX2RGXBYlsyqyVCtr+5KCHs34vSm6ULw5Hy2me/PJG9aSFFOsmF+ihOL9bsE9WrjdEoTbVmCNrlJUh2auyfCtrpQzzDzyybLKL8K4+RdjX9vZf1NWhC6Ys74QkcHdK8VYF0MI8wA5QjCgTbFfmomkxTvL4gOjFNwfysBnwBwWu+kZNz7v5p+Rbwsibn4tuG2B3KihXXFU73H0H3EYHMwjiZIIO0ZkyVVoffnTBhEnMvwqXlrN6fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGsFNDkNpkR6u/tuKX6mNBPRx9n46xT/nZMY0JZx3HE=;
 b=ipu2GNX77bpvM8DaF8Fx8esLEs46HBL06TXm3DS2kbnVcGwtU1wrPdpSS1lNeHDXikNkbEwUPcqZI37wBOQIxqT2xZ7CDJMiNy0f6F+yWWEhDj8iX/vj8zOUeR+NcPxGKJqyJ171nf0rkpY36Z7daDuF+XsMtbDGZ8WbymNKAMw2lXrJ2MrLWXLsbysEwGJPjf2HJ9kGw86KfaEaXbA4CjSW85MkGXV4f8Ug96UVeAjKHFAotL+Tl57nz25LeR3/ExBxeNY5QeKqc9VdEPgvGsY6+rgjVBoFp9XM6yaEAiNzi70rYlSxSEUFt/iMl47MsJsO9A0qqM4DUaHm7UxUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1457.namprd15.prod.outlook.com (2603:10b6:404:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 16:29:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 16:29:46 +0000
Message-ID: <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
Date:   Fri, 20 May 2022 09:29:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>, Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YodNLpxut+Zddnre@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::35) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 865f9b61-dcc3-43e8-3a42-08da3a7df3e2
X-MS-TrafficTypeDiagnostic: BN6PR15MB1457:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB14574279758B56AD5B40FC4BD3D39@BN6PR15MB1457.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tscjoFmopZa3y3AyNgs0uNPFts95L/Mkpq272scxsEogH+dw2mSsfsSK7aAdSF6XgVzAMPRC65q9QsoZhJF4GN9izXlVvofzZ6tG5thIQyl/qQOFFKp+u7QJdI+h8Sclbn5ztsMXplbRyoMschE9Ti0inbyhyLLt+/1L13Me0RLEiOYZO97CxAUMMjKNWBspZevsxTjesGoLx8xf5K4I6buV1dEvo9MgibvwPiYPiQp9pX2X4JO116U9VHotzt+6SvfuARM7t8gHs1NBRYpJqHWc4Kryuz21lM3bxFrlj/qV7WawDqMEJwWZQwkrbLd09D0PANGdJRejB+OCYmcy8mvTAcCWiysLqRsuXGhiB1dGK7/x5V/LjYT3+gS66h0RyazO/qNh7FlK8JYLl90n45Wzjc0ng2fT0HBc+k1YhPvUKCprvXfRsHfS5Ue6073eGm+MIVNLJZW2u/XlFNG0+NFoAGdRMHtd/Lq+74cTFz4NCBR8tfJZPV6Sp/YOjjcbEOUa7sankxaavPXwUXuZR1pt82Yc98u0JNh5FCVtbh7fe+F8jYnTpQD2JPKcnSv3ZqJa2lKZOjVos3AlSBfMNhGYPVAQ1+fNXUAbThcrY6UNs+C1ptQAftYfANlRTkKwzVMxa1ETfnIsa9hcINiZDihktx3wAjl9durjsuBu4unkq+MgGsGU+u1n07NVvG8YLSgP007VZfm62XWPmmvRBrqs6uf1hHjN+JECjulvPubGOm/0WyboS2dHiyvJh70M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(53546011)(6506007)(6666004)(6486002)(52116002)(5660300002)(7416002)(508600001)(8936002)(83380400001)(186003)(31686004)(2616005)(86362001)(6512007)(31696002)(38100700002)(36756003)(66476007)(66946007)(66556008)(8676002)(4326008)(110136005)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekVvVkJFSUV0NDJEUmpsYndOTWoxaGJMNTR2Z3U4bmFZdFNxc2hTL1lxc0s1?=
 =?utf-8?B?UjZQekFhV0c0VkEyS1E2b0s0QVcwUmNTVHFHSFVuS3JrazRuc21TQUoyS0RM?=
 =?utf-8?B?SnV1M0NYb0FpN25PMm5ENFdGcVhFQXdKM1dpMUw0RXNHY1dpK2l4eVdVTnBi?=
 =?utf-8?B?QmE3aUp6OEt6NHdqeHZ3N1FieTB4NE9Id3VUY2hDUFI4Z0IvcXRJb3JUOUk1?=
 =?utf-8?B?TWtkQmZ4VTIxOVo2T09oOUdISmdkYUlLN3RONXdVWkVJM3hTaVphM2U0QkF0?=
 =?utf-8?B?QzQ0SmhHYm5ENE5jSGNYSGxyQXdRMEFCejlqb1A1Q0EzL1BkcDBJd1RqZlNN?=
 =?utf-8?B?NklwcDZFV0NVc3ppYkRLUmdoeHdxdFVZZVV5elJCZ1dKNHh5S3ZVanMzV2k1?=
 =?utf-8?B?NXAvV3pMeFZrMng5ME4reXA0TWZrWTdaa3ZUSTZ0QW50Q0NxRlkwUlFEck5L?=
 =?utf-8?B?dEhiUHdHdTVKanp0MjNPRzBJeHRHdkRZMUNRM25nQ3EvZUhuSWVxekZWR3FK?=
 =?utf-8?B?eFFuR05HU2QzUmJ1L1MvTmdtUUVzYTJJQjJJL0J5MW1rOG56NDYxajgxTUNo?=
 =?utf-8?B?Q1dDNURUVXhFVnZoVFRYRjQrMWtGTnZ4ZWViSmJCU1E2MGhBQlZaRTV4MmNx?=
 =?utf-8?B?bTY3RHFsdC9KcVVXVnhVa24ycnFiRHNReTF5M1BnaHRlVUpDa1lmQjNuNkpI?=
 =?utf-8?B?S3RRZXZGdW1NTXhqNWo2OXBMZUpVSmh2TTFuNmwxemRUbVpwbHV3NjV2dlor?=
 =?utf-8?B?em41OCtuUjBhMkdRN2VBM1F6cWQvd3BJcTVMRHZVOUJXakFhclIxMnpqN2xY?=
 =?utf-8?B?Q0JCSS93ajU4NjdaaGY2UWhLUVZrSmlHV2QvTys1NklPNjFwaUlHZG5MTFVv?=
 =?utf-8?B?bS95MG9vOVVWWkZpRHdicFl6Y0dQbWpGbE8rUkN0MGRqbTlZbHRrRGgvRFc0?=
 =?utf-8?B?QnczSlFSeWhmbU4vVVErK2x4RW94WGMrdEpNZVQ2UENnOGY5akVZd2oyYUdP?=
 =?utf-8?B?TUR3TnQzNzBudXlZeEFXc1JWT2ZsbUhPdkF5Nk8wZVF5bEtOeUxxK2RNdG56?=
 =?utf-8?B?aVFxV2h3RVVrMFZ4bHR5ekt0YlVNeWNEbXVENVFBZkhOOGpRSnY5cXZBckJP?=
 =?utf-8?B?VmltUHAyb1JKRHdUT1dIWDNGdXppOFBHNGQ2Y1VTT21IUTZ0RnRXYy9YNU1P?=
 =?utf-8?B?YmRBL1V1Qi9ZV3NIL3Z5KzgrUDBNcVFjaXJyR1UwUkFodzRwWFNvLzRJRm5k?=
 =?utf-8?B?WjhBOGl5MXUrdm5sck9qdVF2NGhjZjU0c1hnbE9RWWt0UXh5KzVURk9idVF2?=
 =?utf-8?B?MlhieENtT1gyV1VnU1NKUUs3RWM5cUJ2VW5wRFRWS3gzcUh6YjhOdHNidmI2?=
 =?utf-8?B?Mi9ueFZZYkc2OTZwcjkvQzBTRGRJQ2duM2ptR01Dd2wvM1RRSTNpeUozNDlQ?=
 =?utf-8?B?Q3dQb1l6Ni9xeFNBcitOeEtrdXk3V3NyaTN5RVZ2TlBBUTZmbkFMc1hyS2xh?=
 =?utf-8?B?N1ArK2pHRDlRYy9teUx3ZUpqcDlqcDlVeFFlNU1mN1BrdDlEanJ2OE45a085?=
 =?utf-8?B?K3BnY1FmN1pueERkcDJKRDlRcmZsRUZJeVhlRXBIQ2hkMENQNmsrM3FoMnhD?=
 =?utf-8?B?VTFtVldTaTdMYVh1Q0ZyMG9QMFU3SzN2VDQyczNZbXZZWDgvVXEraDFxR0pS?=
 =?utf-8?B?cVBpZkNxblB4WjJpbjRyZllyNDdTdWFIdENBUEswZmlDdUtoZHliTnVNNmZJ?=
 =?utf-8?B?SXhkbGpqc1ByaDhsMG5iNW41cU5hSTZYNW91eTduL2VoYTVFdGc1RWxEZnBM?=
 =?utf-8?B?cEFDU20xRWtkZGE3REZsalF1ZVJ3ZGt4dDk4bkEwYjBUU05sdkRKcHJ2R2Q2?=
 =?utf-8?B?RTh4T2tMT1puWXNLRGh5ZlMrV281S0gwS0NxS1crV0k2Y1c1WHdhWHhrOEUw?=
 =?utf-8?B?NE5IYVhGcHRFM3ZhWlVwZnRvTGhPUkluV3F0VEkxUHNMb1VpUnh5bFozZncv?=
 =?utf-8?B?WEs0QmMyOFdHY3ExMDdKMVRyNEZIREo0TjNncDlDRTdEOVpieFZQTDduN2hL?=
 =?utf-8?B?dW5MNVhFS1p1emNkM1VZaFJrRUxIN3REL1FiODBSaG1RcGVzRnd0VVUwT1Bt?=
 =?utf-8?B?c09RbkVxelJtaGhScWp5QzUzcmFaeFBhS01zQ1FSaVJVV1hMU3Q0TlVhMEVr?=
 =?utf-8?B?dlpJMzFlT1F3Nmh1QXA0R2tzNTJYdWtrRGRsUjQ5eHNRa2Z5a1IyY096bXdo?=
 =?utf-8?B?NkZ2Tjk5VklsOTNlSWJqWExpc01HYTRsdjB3VmJBVitJdFhaM01EcitaZ2hx?=
 =?utf-8?B?VEd0Q001N3lrTE1FcDNRSk9EbGlJNFVtSFlHWHdDVC9NZVhIc0JsZEpPWG1Y?=
 =?utf-8?Q?UD90dGIKMq4ry1SA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 865f9b61-dcc3-43e8-3a42-08da3a7df3e2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 16:29:46.4765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wdVlcCYE3NS6Z86tOrIZSSrgQAvYqOpfuBWZs5gKFBceguScordFInJrePm1uI88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1457
X-Proofpoint-GUID: J41bxRbDb3jf1ck88GY7uOeZ6KJtuwft
X-Proofpoint-ORIG-GUID: J41bxRbDb3jf1ck88GY7uOeZ6KJtuwft
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/22 1:11 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 20, 2022 at 12:58:52AM -0700, Yosry Ahmed wrote:
>> On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj@kernel.org> wrote:
>>>
>>> On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
>>>> From: Hao Luo <haoluo@google.com>
>>>>
>>>> Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
>>>> iter doesn't iterate a set of kernel objects. Instead, it is supposed to
>>>> be parameterized by a cgroup id and prints only that cgroup. So one
>>>> needs to specify a target cgroup id when attaching this iter. The target
>>>> cgroup's state can be read out via a link of this iter.
>>>>
>>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>
>>> This could be me not understanding why it's structured this way but it keeps
>>> bothering me that this is adding a cgroup iterator which doesn't iterate
>>> cgroups. If all that's needed is extracting information from a specific
>>> cgroup, why does this need to be an iterator? e.g. why can't I use
>>> BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
>>> rstat, retrieves whatever information necessary and returns that as the
>>> result?
>>
>> I will let Hao and Yonghong reply here as they have a lot more
>> context, and they had previous discussions about cgroup_iter. I just
>> want to say that exposing the stats in a file is extremely convenient
>> for userspace apps. It becomes very similar to reading stats from
>> cgroupfs. It also makes migrating cgroup stats that we have
>> implemented in the kernel to BPF a lot easier.
> 
> So, if it were upto me, I'd rather direct energy towards making retrieving
> information through TEST_RUN_PROG easier rather than clinging to making
> kernel output text. I get that text interface is familiar but it kinda
> sucks in many ways.
> 
>> AFAIK there are also discussions about using overlayfs to have links
>> to the bpffs files in cgroupfs, which makes it even better. So I would
>> really prefer keeping the approach we have here of reading stats
>> through a file from userspace. As for how we go about this (and why a
>> cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
>> Yonghong to explain the rationale behind it. Ideally we can keep the
>> same functionality under a more descriptive name/type.
> 
> My answer would be the same here. You guys seem dead set on making the
> kernel emulate cgroup1. I'm not gonna explicitly block that but would
> strongly suggest having a longer term view.
> 
> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?

The current bpf_iter for cgroup is for the google use case
per previous discussion. But I think a generic cgroup bpf iterator
should help as well.

Maybe you can have a bpf program signature like below:

int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup 
*cgrp, struct cgroup *parent_cgrp)

parent_cgrp is NULL when cgrp is the root cgroup.

I would like the bpf program should send the following information to
user space:
    <parent cgroup dir name> <current cgroup dir name>
    <various stats interested by the user>

This way, user space can easily construct the cgroup hierarchy stat like
                            cpu   mem   cpu pressure   mem pressure ...
    cgroup1                 ...
       child1               ...
         grandchild1        ...
       child2               ...
    cgroup 2                ...
       child 3              ...
         ...                ...

the bpf iterator can have additional parameter like
cgroup_id = ... to only call bpf program once with that
cgroup_id if specified.

The kernel part of cgroup_iter can call cgroup_rstat_flush()
before calling cgroup_iter bpf program.

WDYT?

> 
> Thanks.
> 
