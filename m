Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2340EDA3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbhIPXAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 19:00:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23562 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241340AbhIPXAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 19:00:40 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GFguq2031837;
        Thu, 16 Sep 2021 15:58:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jbr/NEsymIoomjPKa0e0ollki96SeoblOWMCI/w0Rog=;
 b=M2fWi2HuUIwp69wTsYL7FLoj7qxxjgmZ4ryzC2qDm4ir9KDng0VowFh0qZSo6CfC8gDa
 2J+k8L3ayXtJUcnGcGdMvZgn31FSVxwoBTaQCM7vR2ub45lqQ7PQYWI2U+i2+kJpHJQa
 ztRpyoR0tbuboX9+FxfKtFmJCkHJA6tcYAI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b3my2j4gx-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 15:58:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 16 Sep 2021 15:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WliEvHxvBBADnGPa/E/Dzo4Krls+SCb1vrKeKS0VOfDHacH84Ety12T0jRmZfHl8HOe0WEUdjY+RmyoQljQU5l5jwt5E4nfwaKXXIcrPdgV9KLntk3PJsY7Gob/f8SHyPtus9Z7gFVU6/iZiM2MQhC8n5ihOcP2gHcn6arAAFGueWiNKanGw44flw4HoSBiH5rhoz3qKbTKmysxaHMCstMs8nRRQZew78qmMqwS/bxu2Kt0ZOD4bgPZZru9oULERzAIwBtXuL0KPS8FMLdaFfTlVIp1hTNx0NZ28aOAZkgZDX+nmM6GJeGtNfFIPUG/6HZVrxPmeluakyBKJZ/U8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jbr/NEsymIoomjPKa0e0ollki96SeoblOWMCI/w0Rog=;
 b=N3uU2mGSgToqDLPcTL9LkffRRS6kt22yk42BVFktjNROMrxYpOuhcXWI6pGF9Ngzb+l6FmSpwvzjCQ2bBAz/DangiQ/lzJiewcNNFIikYubcRNPDL/+2+kKnwSg6xd9tk9d38jXIu/Q1EdXPWvSzrOJ+2V2CD94bGsR148WyoJYDhzd5HyottBMdmbHJ1Sh9UnF46V0S2ZhX54m1661b0xb2ybNUnxnA/5cPAe/xif9HdBFzLscx3ebIJC3JpKthT2C1ufrxNapuhGhCTO3THRR0p63h3kSSk+o/wOfw6z4BYCrRLcFpbSJE4UIsX9HDuj9j47AF49EBiI5gGYXq8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4643.namprd15.prod.outlook.com (2603:10b6:806:19e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 22:58:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 22:58:22 +0000
Subject: Re: [PATCH 0/3] add support for writable bare tracepoint
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6b0aaefe-aca1-f0d6-fbb1-406456a017eb@fb.com>
Date:   Thu, 16 Sep 2021 15:58:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210916135511.3787194-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: MWHPR21CA0067.namprd21.prod.outlook.com
 (2603:10b6:300:db::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPv6:2620:10d:c085:21e8::1426] (2620:10d:c090:400::5:fd5b) by MWHPR21CA0067.namprd21.prod.outlook.com (2603:10b6:300:db::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.0 via Frontend Transport; Thu, 16 Sep 2021 22:58:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84abc3d4-4ffe-404d-395c-08d979657b65
X-MS-TrafficTypeDiagnostic: SA1PR15MB4643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4643051BA9EEF680C50753A3D3DC9@SA1PR15MB4643.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMW30AZ/KZ/2SGYCYRzYFxsIIpt3CGsCPXPt2Ex/AAPQ1wUu/esR+LWakUJRj2kiPtTghXbC6czryIviJhjSqeNQMuyUMzAFU1p7xilfD9B+R1L6QRb2TGEjVBNvaMtRSNry7lU9o5uXQXMn2BgU7CEbkvEVfrmuBoUKxWocdGYOcR4uNgsr28l67o5OPbaWdyCakCjTRGjH9GkVQ41wiW7M/byyE1SizDVb3O+l/mwXfX3gFbecn41rVFAo3wWqjwzeyH7BEic9LMvn0sfsGcHN5yl4zjam3nxawz/4Ir3yEM8m8ynx0iHgivMzAr7qxljBCy7ryNl48/R30uwDF8H8sq+V8KweK+PyTAmqE2VeaY2iTdqJZijzxVpcEiuQ71m2LCOBWD5vN6BGHxFVDgN+0JdV5qYf3uYIVHG5EMCBHSpT6yPuSFJCIgF+UuOqnmGKjMC6ZkEYqGtRugCac3uhrzd/RVPsvV1FcF9jRfDTpscZAeI0trJxeR8bZBIJ/bOA112F+0HveoA6+jYdsuvtfsIVvJzjw/8E180MayW6CE9w9J/i0CaFEO8tlXiO4f8sleD2btGUJH3PM8ITD3EWwip2QdZS9SzuvUPcFBoRORLOSBEaIDQNuYHR7SHTo+7FXLFEefuAolUc9SnS6hex8WnA6UNItgvPxRQN7P65aBX+FWpsITN4QruxwbCXGUR9MZYNLIL/pzuoM7RR4NPfYBBe0g/mXQ19rlF58S5deFSQdxeDjkQz1UrX18XTsajibUOKwWSCU/XcU79wDwpQfInevGE4dvS4aqmPBxD7vT2CCVqeDaWfpPYjNRht
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(38100700002)(53546011)(36756003)(966005)(66476007)(2616005)(52116002)(2906002)(316002)(83380400001)(4326008)(5660300002)(31696002)(6486002)(508600001)(8936002)(31686004)(54906003)(110136005)(66946007)(86362001)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFBtMzhTZjB2TkFsQ0xRQnhZVTkwYnNXY1dJbDR4Q3dwNUFGV0tQbEFqbEVj?=
 =?utf-8?B?TUViUjFSTjFCYk5LTjBvZ1RZTmxuMGdOUzh1bGZBL2xXazhab0VGcHF4ZkRW?=
 =?utf-8?B?MTh1SG1WdllzM3JTMVdQSW9CZWltSGFZaWNmNHZwakdYVE1UdEFpSGFzTVlT?=
 =?utf-8?B?bllQRzFoVk5jNGxadVJIVXBwU1hEaUsrMVRpcUtGeHJFZ0Z3ZEFhM2dyMUlV?=
 =?utf-8?B?VjB5TjNncFVUQmFBTWdKM3p2U0dRTzBnWnJrRk8wS0wxOG9IaDBSMlZ6M1ls?=
 =?utf-8?B?VlcrNUpTUDhHWm1rQ2dkN0FMUWhscndTV3RNblBXWklNT2NzM3dyWXJYQitQ?=
 =?utf-8?B?YjZFdzVwdGdjbTh1Z3Z6SzNvbytTVnBGZmdLTFZVc2dNWFBjMWwrajBvQjVk?=
 =?utf-8?B?TEpPTFROdG13UjgzTVZBQUkyekhnVGQ1ekZHVDVLM05OOHdZOGNFdWYzcFJn?=
 =?utf-8?B?QTk2VERtUmxvSmFKakFyYVBnMnNkVHhaTTE4aGN1N3JoK09BbUc4WE96V3RN?=
 =?utf-8?B?SmJYTE9VL0ZlU0RIN1NUamlCMHk1a1JxQVRHQk0xUDVNSHN6WkZIQ1YxaEZw?=
 =?utf-8?B?VmlJci9TWHRrUmZRbFdZd2VuWEZyL1IybEVjcEdZTGE0dExvdk1NaS8wYnZn?=
 =?utf-8?B?S0FsSWtlZURmdktEeDRITW4zeE1sQmpkaHNmeFhtL3g0ZURML3E4SUE3QWw4?=
 =?utf-8?B?RGxtTUFwRUcxelFSa1VqZitJdTZVbHZCOUkxaGdybWZYWm1JQTN0STdtUm8z?=
 =?utf-8?B?anYwczh4VzdqZktNNzhQVmFpNUVQZkN2SzREUUxDUmlkVHo0eXd2NUtCcU5O?=
 =?utf-8?B?RjMrc1NFa1BYVnFaWWRWaHhIbm15Q2NTUmJSMnFteW9RWHFXd0lDWmR3RGY3?=
 =?utf-8?B?V1hOcjNxTFZQdGMyK0lWQmtBeTlXSHVwWWlCS05WV041QmkwLytqYmVWc3J1?=
 =?utf-8?B?OVFrMEdLODV0VDdoRHVVaXlDZUN5bERoUVFYdWxhRkc5eXJkc09xRjFpWTVl?=
 =?utf-8?B?b1Q1V1ovVW9YL0lYS1RUVG9URHRIYTIyckVmTVBaQlVGUzJSbmc5THB6Ritm?=
 =?utf-8?B?OXBLMXM5ZFh6UVZBTXB5YmlzblJVNnBaYU41bEtNekdYSDZUd2hieU1SZE84?=
 =?utf-8?B?RFVYbk1Qd2ZGZHg2c243ZGRnWGFJTEdhTFJIb3pqT25uVkR0bEZHUlN0ek5S?=
 =?utf-8?B?Uld3bldBTEFVUHE4NHlXWTlBNCtodVVrWlVmUkRDaURUNmxzT2NBWHlKZTFk?=
 =?utf-8?B?eVV3WXJVbmV0QkFaa2N1Ly9UZFNZR3hWVXYzR01BVWcrR2s5Qm1hSVY0a2k5?=
 =?utf-8?B?NXNhK0FvWWMwdWJmM1kxSVZCaGVPYTUxTGdTVkNicXFDNUpkSUpybDk3YjB3?=
 =?utf-8?B?Q3J3dkZTYTJRZ1ZVYWhTc3dIdzhra1E5Smp6NGtZMk55TjRpcElLS3I0ajhw?=
 =?utf-8?B?K2ZUZUNVOXh3b1pUSWFubHlrNVRhNVdvKzlyZ1dVREZMNWhLYmVUSUxIRGF0?=
 =?utf-8?B?WCtRRkMxY011MXdqZkxPYnc3YURRSHYxNUNodGY0ZUJaYzA2SDJZajJ5RHVw?=
 =?utf-8?B?UWdkUGRhSllBVlU2TEJnVUVncW96NTdKSGdkU29QM04wbzJOM0xIby8zMzZk?=
 =?utf-8?B?OXdlR3g5RmxZRFYxSXhoSTZxcytxckZaRTJYeFR6SkJZQUhKNUhFbE9EaG1L?=
 =?utf-8?B?RlNVWmVlb1JxeHZUcld2cWJlclpSQXdiSFQ1R3o5OFBVUGVUaWdTOGZ3V2lB?=
 =?utf-8?B?VmlkWkhVSU00YUNSOGJDTnJaa3VaQVp3cFJmYXltcm12bzQxODVUb2pYR1FZ?=
 =?utf-8?Q?PkiwYvUc7JokLe2kHG83b60K1vnYIFetFD7Us=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84abc3d4-4ffe-404d-395c-08d979657b65
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 22:58:21.9394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eV4j7kTQQzpByGBEhE6YJU9d/ZzAJywsbPcfni6UXV1U0V5kY1unY//QHrECvV9A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4643
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: bJ-YD2NZk7BS4W_XDFmc2q_AHeQyfpa2
X-Proofpoint-ORIG-GUID: bJ-YD2NZk7BS4W_XDFmc2q_AHeQyfpa2
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-16_07,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 adultscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/21 6:55 AM, Hou Tao wrote:
> Hi,
> 
> The patchset series supports writable context for bare tracepoint.
> 
> The main idea comes from patchset "writable contexts for bpf
> raw tracepoints" [1], but it only supports normal tracepoint
> with associated trace event under tracefs. Bare tracepoint
> is more light-weight and doesn't have the ABI burden of
> normal tracepoint, so add support for it in BPF.

Just curious that do you have an actual use case for this?
If that is the case, it would be good that you stated in
the cover letter and relevant commit message.

Also, please add bpf-next to the tag like [PATCH bpf-next x/x]
to make it clear that the patch set is for bpf-next.

> 
> Any comments are welcome.
> 
> [1]: https://lore.kernel.org/lkml/20190426184951.21812-1-mmullins@fb.com
> 
> Hou Tao (3):
>    bpf: support writable context for bare tracepoint
>    libbpf: support detecting and attaching of writable tracepoint program
>    bpf/selftests: add test for writable bare tracepoint
> 
>   include/trace/bpf_probe.h                     | 19 +++++++--
>   tools/lib/bpf/libbpf.c                        |  4 ++
>   .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 +++++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 +++++
>   .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
>   .../selftests/bpf/prog_tests/module_attach.c  | 40 ++++++++++++++++++-
>   .../selftests/bpf/progs/test_module_attach.c  | 14 +++++++
>   7 files changed, 101 insertions(+), 6 deletions(-)
> 
