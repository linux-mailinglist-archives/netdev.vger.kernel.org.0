Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193EC4375D6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 13:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhJVLGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 07:06:45 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:35340 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232560AbhJVLGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 07:06:45 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MB0sBK024418;
        Fri, 22 Oct 2021 04:03:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=JLn/mpF5qC5l+4kKG099Pvi3u0/i7Y4TFUasdJD2oa0=;
 b=kDoEZgjHwAdhi1TAWv0Lp3FX5S0k/eVNdxXEc57PgSVgT0ip26VME8ZxdjtyCxPzwZot
 2TWhiIC++PKq5nq3LDeF2egVi0B7SArFyeIIUWTj0eEAfXvqqB1gg3E4Gfv6mn7qOx0W
 J0Gq0mLDeoJpc7gtRssW/tt25cDyIZw89ts4gEvHBJtrgmyh7gWvJ5vsgKpPoxbam9fF
 S5JZAqeNAm6t+0Kk86kghO76j82XULkt3qTOtK56aHUOro/tvR/qGzWwptgLqL41HPJv
 Jj4BhUd7uUxHQ7HaRUlDnkRBWgUitWDPCFxGkIvrtmnbJF0xAAOm6gPe90Cvo3ZJJYfd Bw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bu07t19se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 04:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N789g/MZdfFIcWiv1r8WUakGfTh0Hw1uc9QIX6sjGz+23l2GP239Kyi/DPNrATrBgPCM5rvLArgdPxdx6g4cFq/VOqdFGQTnZHWl0UWPe0sSLAjDRNdDUumXzuVJORWT4Gziisp72VbIx+353pw3ALOFs/kVRFa99T1psT3apV93yH+O8Fq3kkj7Ix8/IZiKCIqxokYJzWr0i38HX/+d4TRMy8eMwILKTYPykMRhiqH//wRLGSuKTyyUln58xAE0ttZjeyS+tGdtku2urw47/HI+xZhXjpDM17bSTKxQLx+JcMy+Dfoc2Yqd5RYV7fQoRtSyZ97uXB9if22lnbv0Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLn/mpF5qC5l+4kKG099Pvi3u0/i7Y4TFUasdJD2oa0=;
 b=YapzHEJyd172llHQ4akkj0/QdqfFTcDcEv0mqqhtMskPGl3ax0ZhZm6FA2CD1J9Fc8YYoNranMiojm4+jQ/htnm/EoEla/Rqe3+vUQxYHcFyQXKTU3lMbkFnE2H3zzp9CPk+yEuxC72ABMxbLtcdINrzo1yqhtc5F/FqOnDbTWEY++9I1MGBhOxOSNRY8xZlhXSaDzU3MHi38Z7K/+WLU9TUDF+t/EQmDdfTqmapHIUfiHh4cmAaknReuWrbnuTjZYDKcRZtSSM26hdk/BP+hyd6lwe51fsQUEENOHpfNw6cbOBPS7qQrjtUl3H2XvWXsa9Q16WR67HmRSHGvXsXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5157.namprd11.prod.outlook.com (2603:10b6:510:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Fri, 22 Oct
 2021 11:03:52 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%7]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 11:03:52 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590> <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook> <YW98RTBdzqin+9Ko@T590>
 <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
 <YXBRyJMru/RbUQK5@blackbook>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <cd4d0dba-6818-12df-1d90-3ef5121e342f@windriver.com>
Date:   Fri, 22 Oct 2021 19:03:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXBRyJMru/RbUQK5@blackbook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR02CA0194.apcprd02.prod.outlook.com
 (2603:1096:201:21::30) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR02CA0194.apcprd02.prod.outlook.com (2603:1096:201:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Fri, 22 Oct 2021 11:03:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37908364-5268-46ed-2dfb-08d9954ba1fa
X-MS-TrafficTypeDiagnostic: PH0PR11MB5157:
X-Microsoft-Antispam-PRVS: <PH0PR11MB515704D3A6B86E01290D378AF0809@PH0PR11MB5157.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JmjpQzOqdBrbFodIWoqJ7ly5TyDZCyCUQDjH8ZA/T387fvYMdc1xM9Kz8k7TLsqjOC8A7l6QGHp6uKiXagqxATdc5VbiG2JvjtRUtqKV8qz9TA+f0p+8H/z4IMNowIEtn2pCkPulrDXzzWJEtiQMYZDnvNHbXeb8I4WJ5qn3LximzutnqANJt95bXXB2Nax9xyp7hD68bMvHy2RxLFODNFkh93g8PL/+pmGvHJn0t0A6g7+EkM///tqAcaAGcfV0g2Njz5grZ3nWTbb6F+0WZ9jMCrPZJaJ1Q4vew2YgRM74X7LgTCqZFBBt9aMoRjN8GqCxlwzZ9L4zoJkkiUGC0x8uo86xLI2MFaG2IEiIEXRnGeHH6jbI+9gXH6fiikkKwTjrHtc+1rW8wqnT4no1jZF07aNSetKwl3dJEy3KQVMK8+RfkLbcp+hgwEbs5AToYSKCFS4M2HN0o7GEFKHCz+H1yJVoMbPs9BqiohPFlRi8YClT4w4WESy4rCil7Oo/w01sDy3vsbjf9ssXcU7co3BpbCo8ZrvLAHAmWbo3D6eKUp7zL5FeSAf1ZeJppd2KaBeLxPYpfBfubnsrP5fKiH5ZgCzdZ9/MXoAiVvfMGNk+I9wTmXIRST4icamS/DKBx2goFoxFu9XXEzlloOi9yx7ewSsDq4SGt5YT49OqYJD/ZfCFilj/zvCk0UCPrI8sEQZjVBXBggYGBcPlWI+A7wKgOhETxliSSnJXikCtDwhtTlMvg3bkQU5nCVpN4v/GQa0vdHZ2aJwc5BHS/yq1IL3zbRIsgvz+UPHS7H7iazQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(4326008)(31686004)(186003)(8676002)(956004)(2616005)(66476007)(44832011)(31696002)(53546011)(86362001)(6486002)(66946007)(52116002)(66556008)(6666004)(6916009)(26005)(7416002)(38100700002)(38350700002)(5660300002)(508600001)(316002)(6706004)(16576012)(36756003)(54906003)(2906002)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWs4czJCSUhOY3JaMG5oTTFlcjFtaGt1WXl6S0FkQWJPUWdxZWs5N3grdmNy?=
 =?utf-8?B?ODUrWDR3ZWhZNnB2SmU5QlhlVytyb25UMmVZTVNHMEpvZ3E4cGF0cHU2QnRJ?=
 =?utf-8?B?dXFlYVRLSFRNSU0ycmJuWnJ2QnowVTU0dmhxWllLSDdvRGREYlJUOHVQcEo2?=
 =?utf-8?B?Z1lYWlhjRVNvMzgydlZRWExQQkNsUUFiSnNYaTlxeDUwVGVpU25EMGs3bmJH?=
 =?utf-8?B?U2FHQzZod1FmTFNEVzRMRzhXSTErNTE3QUNhYWtqT29hc1IxV05Za2hwT2xW?=
 =?utf-8?B?c1U4Qm81MTR5QzVNcEYwQmtNTVRITERsTDQ2aTJDajdCK1MrNXpaa3BTOXd1?=
 =?utf-8?B?dGFKL1VuME44aUt0VStiTEF6WldSMlVjSi80SDBSZjRxYmFFdUljb2dxWWhR?=
 =?utf-8?B?aEY2aHRnZVVXajdKa0JsTzA1cUlVdTVDN2xlekQ5V04ySkQ2YUY2bEVuS2d3?=
 =?utf-8?B?dG10QVFyd1pGNXAzc3FKdWxJaE05eUxsZ3RLNU9jVEdGVlZJcEFLUC8wM3pr?=
 =?utf-8?B?M0V2bXNQQ1Q2eFZPdkZhbnVFZHF4Z0pBWGQyNkZPTjFqVk1KUmViVFFEVDZw?=
 =?utf-8?B?cmkzL05LZE1yQWRHRXRaaE1mbS9yWCtvUGdDQWx6MENxRFRxM3ZEOUZabStH?=
 =?utf-8?B?WUxDNWVRcUVlaW1RdnZqTWhhbDVvSUVoYXVTUUdXYXREaElEbFBDYUNiL3E4?=
 =?utf-8?B?SDFTb3R5UkRNQkVpUmtTY3RWcFFieXBpMG1aM2t0M3N4dnBHL2JYdDR2MWNJ?=
 =?utf-8?B?REdCTjljcDVxLzRnYTJ0RjA3eE5TMXI3M3ZFNkF3N2Z5T2k2Mjh0WlczamN4?=
 =?utf-8?B?cHlmZzVxRWFRanh0N2ZTS0gyL3RGSTVCOExBUm1MSVVFdFh5SzMrcEJWbTZp?=
 =?utf-8?B?cnkyT2RMNzYxNGxKbXJtdTlqWiszYXV2K05sU3JVRE1JY2dXQTNkbkZGczlW?=
 =?utf-8?B?Wks0bWZ5T3d6VmZEUDlJOExnVzZaZEVncmFwY0FKVFhDMmo4bkI2TGY0M1pZ?=
 =?utf-8?B?dC9OSjdROFRtR3JlZFNXOHNXaEtwZlZVL3RxeU1oVVpQVFB4aWdEVkludlBK?=
 =?utf-8?B?NFowYmc4QVk0Mm9EV2NDeElPQzF3aFowbW42NURkMkpmSmw3M3NBcGRqbE1V?=
 =?utf-8?B?S0V1Y1o4KysxVytKZ2hVb1Nmd2poRVdNd3hVa1IwSHdTTk9Bei91dmUzRy83?=
 =?utf-8?B?SUp1U2ZLcWh1UGwwcS9OY3U4UjV4SUFaSllNdTdST2Qxa3dkV2RYMUd3YUgw?=
 =?utf-8?B?NEFseE5JSG1PcFl2QlBuNVlIclNydTNSdmU0TWNTMkE3bk5RS0NBbFREYTRh?=
 =?utf-8?B?WldRSngybms1eHIzMXREZ3QrcjZVSXI3TlpqMUJVaG9QSUlDbHhvRXNmVVRO?=
 =?utf-8?B?MmhEd284RE03K0RhUmtJc2VzR2orVi8xUFVjQ0MwMnZCb2o0RjV3TWFqK0Fx?=
 =?utf-8?B?N2pUaUlUUHZIRmRqOE9NWmREMlZIWm1IQ2hUd0IvTGxybzRFeHIzZTF6ZEx6?=
 =?utf-8?B?RXI0UkQzV2N2V2dUeXI2aG96Z1FsVkNMb0FLdUtpTFRQbWRKb0lpMmZkaVhR?=
 =?utf-8?B?T3lmY1NRV3NIdThWYitES3VNWW1nSWpTRkhvSzRaanVUbjQwM21RcmpETGgz?=
 =?utf-8?B?MnduZC9qTERGcUZFY0FNRVQrbkxwc0FWV0w3S1B6VDZyNUU4K0Y1T05RMFd0?=
 =?utf-8?B?NCtXS3VGcnN4RSt1YzRuYWN6VmRJRW4wRm12aTByZ0JKZFV0aGFueTVXbjRx?=
 =?utf-8?B?aXNNOWxqZDJTaGxsTUFETTgyNERJR2o5NXdRRkpvL29rRnFma3RaTG1FM0xF?=
 =?utf-8?B?aUhBOFFkN3FFQmtXeWlCZnNOd3ZadE9Vdk5LN1BwdFRobXFsaEZUQUxZOHF4?=
 =?utf-8?B?VHNGbGovZ1NkM1lEQU1Ya3dXWDJqRDUrRkFzd3h2WWJaU1lqMVZ4V0RRb3lF?=
 =?utf-8?Q?QBSSOv+WKLBtl6lxd4zAChXdIXxFzbkB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37908364-5268-46ed-2dfb-08d9954ba1fa
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 11:03:52.4429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quanyang.wang@windriver.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5157
X-Proofpoint-GUID: KQsF89PY93PzsWAsrdecEEo7TbjNs41t
X-Proofpoint-ORIG-GUID: KQsF89PY93PzsWAsrdecEEo7TbjNs41t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=906
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On 10/21/21 1:28 AM, Michal Koutný wrote:
> On Wed, Oct 20, 2021 at 01:22:06PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
>>> If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
>>> I thought cgroup_bpf_release() needs to release more for root cgroup, but
>>> looks not true.
>> For now, I can only observe that precpu_ref data is leaked when running ltp
>> testsuite.
> 
> I assume you refer to ref->data. I considered the ref->percpu_count_ptr
> allocated with __alloc_percpu_gfp(). Could it be that kmemleak won't
> detect leaked percpu allocations?
Yes, kmemleak can't detect percpu allocations. I find some message about 
this:

commit f528f0b8e53d
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Mon Sep 26 17:12:53 2011 +0100

kmemleak: Handle percpu memory allocation

This patch adds kmemleak callbacks from the percpu allocator, reducing a
number of false positives caused by kmemleak not scanning such memory
blocks. The percpu chunks are never reported as leaks because of current
kmemleak limitations with the __percpu pointer not pointing directly to
the actual chunks.

Thanks,
Quanyang
> 
> (The patch you sent resolves this as well, I'm just curious.)
> 
> Michal
> 
