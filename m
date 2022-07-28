Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057D0583849
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 07:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiG1FyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 01:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiG1FyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 01:54:03 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C46F56BBA;
        Wed, 27 Jul 2022 22:54:01 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26S17nBP001472;
        Wed, 27 Jul 2022 22:53:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TrvsotiIAMv6WxTEUpaphVsgY98raZZnBK/yyEVpYZY=;
 b=I9ryAaXrYotG6c99+5Xmel6zWjPq7SiVZWQdSgU7o9kmr2cVblS+WTRo8cKUy78tDbCa
 cIwYO93AdhtYZFu4k6kuKc4J6a2rRFubqHPGMppOIletlshEo4Ia52iYkNlK41MIkGK+
 vRPpJ8Ez9L0TUJRZV57yeSIzTZasVdUljRU= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk4stxr83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 22:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxmromB04ny7NHOOjwD16KHgawOAJApAgjxJe5C6oAFOB7ifvde1I2VtVuAPRHos96IpO/CFTVPwfqN5xRvARPYgMc//hRGvDJtzQ/FyiBLGALVOVmYHxmh1MgqnRrVfJva04x5Wv30Zt1LphlCcRsFggfJi4oqybZtLDgQK9D+aObUd9Cp6sPXc5kfDC29dzJKOOXoqS7Oz7adi9nPzZFLKF23mr341odsFxE48/xWkZBWsuU7h8ZRcohtNfCZUi+ti+tgY6swK5LHgcERN6g22WH52dtG9Uq6Wmfd3hWjz2DI3ekEDiaZYCyIL8vUOx8a55yY/fUU9cSyWociu0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrvsotiIAMv6WxTEUpaphVsgY98raZZnBK/yyEVpYZY=;
 b=WapTnZy+0NJUxeYRp3BnaKmVrdJ1Cvm5XoPjRw6DTVCKDJJtlSn6ZRjn97Vw2aleATLmhSWDM5Y3oDO1lrPh2ALgmtfDi7GYebhyQmm9AcUWax9WZPuXZkKu2GyP1Ya8e2Vou9iXs+nucf/mhF7lenpD2k3JRjWAxSbN36vxv+n4PC2zLpoAlOSsO7cnbb8pfcku8cKpaa3cQhCjNA2Rt7/vYGBvuxSBRYNRFd+hHGsMfm2b4wg+DF7WelDYWhDfVUtWRUdUufLdZnuVgIAIDoRtHtFcMMNQKQY/OWQ/gYgdjQsAjTpTejNwrEK6gaYUysPch9+J2VG/RlxBCsUySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4080.namprd15.prod.outlook.com (2603:10b6:806:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 05:53:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.024; Thu, 28 Jul 2022
 05:53:36 +0000
Message-ID: <33b05315-598d-5b6e-a8a0-ae8819ba98e8@fb.com>
Date:   Wed, 27 Jul 2022 22:53:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v5 0/8] bpf: rstat: cgroup hierarchical stats
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220722174829.3422466-1-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BY5PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:180::19) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94cada8f-f418-4dec-995d-08da705d834c
X-MS-TrafficTypeDiagnostic: SA0PR15MB4080:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YOpFn3Jo6xQnTipxWV6gYEWNBZm5mugOtK+smwDr+W2ng+dHXvl+YCUPAKfvXfAqMpxZ76hkWFU+XhhAy5uSl1N/fHysxzj69U/H/MHyqcBp7PFTGuG34MSBJKT4BiR1fWjPlnmNdiViCevNRUM3OW86WhCx4xx2/GiWOop9jynqq4kq/4WKksY/Xv4lDSR4hiogFu6eNMoOBbkin3KF5XZCmMBbs+eU7qqvVRsO3kjEjkyV6pjJ7nvMNknDv34sATM50guxQQCky/UrCOWJ0khmGwU1H32nW5YvmLwaxzc5eOFQoe+itButk9oS/QTEh5XnqguoGpK/LX7fYw2+bGwDKOJ+yr+k+V1L7/brHS62s/yFaKNGOAnJUYWeylvuAKMg9MGM/zFBYrjaM5U87m+M0JlhcqQBMQRSyUU+igcw94lH4D/S5YRmkOWhEaqhVAJQzx9shqqVQDrWHDTxaeQg0EtUEG6akoJ1AM/OIj3xn2Hsft1T+sVAFxzm2OHZDNlYAVNDwJi0Dh/970nEnrk4n9IE9fBnlq7/lG3xIMR0wMAXTGLf5HYvtt66vgQ0N4/jLIv5cRn97jjhIuQlKnuN5S+RWc3r+UdTwpCmpzpxnfVvgtMlDkZV2HyqSlhgUIP6kIR8uEOjWPyJS0fWbMo3lEjRFWcO0uBme0/MG1eYbONNYzed5g+7UvZ4NLwr5s5hK45wjZZpmP6YT0ZdG6P+g0OgnoYN2jKeNp8SfKvdXiCgmf0m50DIx3WxIPQ8NVoohPHeaat+PxeEq9q8FYVwnRBZZwHCbd+8MY6T+MIPR/yzT69L7xTU01yfVyWaOG3yjiejmxtqHUUxnjYX8jXl0KGDCR7Vm2gZGfHv/6xoppPyaGmyvx8dHum+v4/n4yLaUG42gtbtHcmnsITD0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(38100700002)(31686004)(110136005)(54906003)(316002)(66946007)(83380400001)(8676002)(66476007)(66556008)(7416002)(41300700001)(6486002)(2906002)(966005)(36756003)(53546011)(6666004)(5660300002)(6506007)(2616005)(186003)(6512007)(4326008)(86362001)(31696002)(478600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzdXVkdSVEZRVklYWFhOeE5lMTgwMU9HZElLNWM1dnhVQ0FEaUVvTHNKTnBj?=
 =?utf-8?B?UTJWd3RQUlFNOWJHbXBPTGpFQTlTZzU3SnU3WE5FTlh0OHhHRXFUUzQyNW5U?=
 =?utf-8?B?bFdSOTROUyt4V0pMUFBsbEN1UGdab3JRenFlVGp1UDE1dHYzUk9JbysvYjI4?=
 =?utf-8?B?UlVMb25VUk5MT252SFZGMDhaOE45SE14UmJ5a1M3YVYzbmp4TEEwTHRGNDA5?=
 =?utf-8?B?VzVSbHhJWkNoQXN3dDBOVGtsN3RxVVU3SHcwS1dZbldIQkVJVHBBcTBIeXQv?=
 =?utf-8?B?bTk1bmlLUlVLeEdWRnYzNWpTNWt0TGE5NFJpTzZaMDNCeVh0NjROUFkrVFFI?=
 =?utf-8?B?aEE5Mkc4ZEk0TlFDdm5OTWJzcG40REVWSWhYVDBpTUJrNFBCRW1JSm4zdW8v?=
 =?utf-8?B?bXpESXdZK2o5WlV1M1QxTkI3YlY2QVJUUUNFTy9RandZNTlrcjdlb25XTGxU?=
 =?utf-8?B?eUplSmlPVXJ1Y2ZyMmZOQTgzbDN1ZFg2RWNvdHhDZDQ0RFQ3M2o0bmxwYloy?=
 =?utf-8?B?Y2s0aGlMT0E3dk1leWtaWnJLOTBwSzFjNlJaQzB1bERWYkFSTzN1WHY3d3RM?=
 =?utf-8?B?T2lVdHZUcXNZU204S3dEd2o3SUYzVGk1WmdlRnhrWFIyMUdWNU01UUh6d3NL?=
 =?utf-8?B?NUliOFZwdzFnUXcydHM4VkJHS3NpTDNBV3RtMHY2aE00cmh4ZXRIY0tOUTZ4?=
 =?utf-8?B?NEtzUXBwOExLbHVKVmpWUm96L3d6Y0xoTXFrN2k5MzFYckJaS2JDUXVvSWZW?=
 =?utf-8?B?WkJrUUg5dVhOVkI2UmxEeVkxdjR6QzN0S2ZZdXdPMFYzeTN0cDhCUzY0QTJC?=
 =?utf-8?B?bVBHYktzYTkyTXFsTGRwOU4xWHhnR2dpVGdoeGZ0RlJGZmRIZ0d2N1kwNTJi?=
 =?utf-8?B?QkZhRmRMbjFrNzNzVkVJZmdZV21rSFdLSEVYbFByUFF6SlU5U3Rtelp2bWRm?=
 =?utf-8?B?U3hGQTBIaHlmTzlpRGZVcC9lUFVIMHN1UUZSVXdvOGNMZVMrZzN5L1ZQaUlG?=
 =?utf-8?B?R0liZGpNeHR1cUtrcHRTUmlub0FnWkZoRE5Gb2RWYWphc1Iydzl2cEZyclpP?=
 =?utf-8?B?ZGVsUnlnUnl0SDJzU3NLOFNkN1gwN1pYVjVxakFCNDY1ZEhnSnFZclJiQ0o2?=
 =?utf-8?B?VzJLWS9vOEEzUG9tejMxL0p6UHE5NEo4WlRtdTVmSUZ2ZDRjR0JxMEZnbTd6?=
 =?utf-8?B?Nms4Z1JZQ0NsNGsyUnA2SlR6K0U1WmhMTWJtL1JlME9RNFZ6VzlZM3MwV2F1?=
 =?utf-8?B?Z3lhRmhKWTF2ZGlKRDI4dHh5eC9Tem53N3ZQL3dXY2wvbysyUzZtSmdkYTNa?=
 =?utf-8?B?amh3dGVJSzFiNE40cnNGZk9DMzRoejZPYjBVdkxSelduWktMTitsd0xVTkFu?=
 =?utf-8?B?cWlFSVVJeXZ1bDlkSkF1dFl3QnQ0djNSRitnVzRPMGE0WDBMWGdyZXhuZkdN?=
 =?utf-8?B?eGkxajFkK2dodVA2TzY2ZzNxdUFEQjU1QnEwRGROK00wbmhOTmFqWXJjU1pu?=
 =?utf-8?B?QUJ5ZHE2NXZ2RzV6bStRU0lRQzhTdXJlSVZoelhoczZaY2VPUW55U3RmSks0?=
 =?utf-8?B?bDdlWTBYamJOeVBYTSsrOE9PeGpJYXFoMTFJZmhqYzJ3TWFvbi9mK0V0eXBO?=
 =?utf-8?B?VlhId2c2cmc5RTIzWTNmN3JUSWo4THdRaTRxVFYyZFBOSHc0MnY5TkNsZWVC?=
 =?utf-8?B?WGNYZW9nMk5GUStzNTRPaEJOYWNqTy82VkV3enpkb25VeGFWWnNGYncxbXVn?=
 =?utf-8?B?bFNhdlRtdE54UmJRVFBHWjZDamFlcTV1aEFiY21pUzJaTFllL09mdWtrZXo0?=
 =?utf-8?B?MENXdkJ2eTBBbEJCMWExU3ZGcWcybDJ0VkhBcHhWb1Q2MWhOR2hKV0hxSEdw?=
 =?utf-8?B?V29uZEdaVFRpR2F3WldQZDNDTVUvTkRnNlFxc01DUUZxQTNoNHQvS0dxRE5H?=
 =?utf-8?B?T09RcjROemZFMUFkWGlCb1ZlTnpUbURiUGozandiMXROZW9nVzBoMDdqM1BO?=
 =?utf-8?B?Z3hNN3E2cm5oT083ZEcxdGlLZmRBV1BNU0s5MkJldmZ3Z0Vzd0RWZ3JMM3U4?=
 =?utf-8?B?YUlDb0RsY1N3MmNUeHREcnBFKzlGOThwQnBVUU5iTlV1V0tJdElpejI0VlEr?=
 =?utf-8?B?WkcyVjExeUpkbUhXL0lSWE9kdEN2aW1leWhhdm1NeExEWEJHOHo1Q29TK3Jn?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94cada8f-f418-4dec-995d-08da705d834c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 05:53:36.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgYfQzx3mdTa4iQXgHv/cfVX7SMKUgnqoyZgbnpn5HSz7mOdbcdYpsu0bwriaeme
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4080
X-Proofpoint-ORIG-GUID: 8TL01vOo9FBPpbBmr7ax7fnEBFWRTTap
X-Proofpoint-GUID: 8TL01vOo9FBPpbBmr7ax7fnEBFWRTTap
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/22 10:48 AM, Yosry Ahmed wrote:
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats percpu and
> propagate them through the cgroup hierarchy.
> 
> The stats are exposed to userspace in textual form by reading files in
> bpffs, similar to cgroupfs stats by using a cgroup_iter program.
> cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> - walking a cgroup's descendants in pre-order.
> - walking a cgroup's descendants in post-order.
> - walking a cgroup's ancestors.
> 
> When attaching cgroup_iter, one needs to set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk.
> 
> One can also terminate the walk early by returning 1 from the iter
> program.
> 
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
> 
> ** Background on rstat for stats collection **
> (I am using a subscriber analogy that is not commonly used)
> 
> The rstat framework maintains a tree of cgroups that have updates and
> which cpus have updates. A subscriber to the rstat framework maintains
> their own stats. The framework is used to tell the subscriber when
> and what to flush, for the most efficient stats propagation. The
> workflow is as follows:
> 
> - When a subscriber updates a cgroup on a cpu, it informs the rstat
>    framework by calling cgroup_rstat_updated(cgrp, cpu).
> 
> - When a subscriber wants to read some stats for a cgroup, it asks
>    the rstat framework to initiate a stats flush (propagation) by calling
>    cgroup_rstat_flush(cgrp).
> 
> - When the rstat framework initiates a flush, it makes callbacks to
>    subscribers to aggregate stats on cpus that have updates, and
>    propagate updates to their parent.
> 
> Currently, the main subscribers to the rstat framework are cgroup
> subsystems (e.g. memory, block). This patch series allow bpf programs to
> become subscribers as well.
> 
> This patch series includes a resend of a patch from the mailing list by
> Benjamin Tissoires to support sleepable kfuncs [1], modified to use the
> new kfunc flags infrastructure.
> 
> Patches in this series are organized as follows:
> * Patch 1 is the updated sleepable kfuncs patch.
> * Patch 2 enables the use of cgroup_get_from_file() in cgroup1.
>    This is useful because it enables cgroup_iter to work with cgroup1, and
>    allows the entire stat collection workflow to be cgroup1-compatible.
> * Patches 3-5 introduce cgroup_iter prog, and a selftest.
> * Patches 6-8 allow bpf programs to integrate with rstat by adding the
>    necessary hook points and kfunc. A comprehensive selftest that
>    demonstrates the entire workflow for using bpf and rstat to
>    efficiently collect and output cgroup stats is added.
> 
> ---
> Changelog:
> 
> v4 -> v5:
> - Rebased on top of new kfunc flags infrastructure, updated patch 1 and
>    patch 6 accordingly.
> - Added docs for sleepable kfuncs.
> 
> v3 -> v4:
> - cgroup_iter:
>    * reorder fields in bpf_link_info to avoid break uapi (Yonghong)
>    * comment the behavior when cgroup_fd=0 (Yonghong)
>    * comment on the limit of number of cgroups supported by cgroup_iter.
>      (Yonghong)
> - cgroup_hierarchical_stats selftest:
>    * Do not return -1 if stats are not found (causes overflow in userspace).
>    * Check if child process failed to join cgroup.
>    * Make buf and path arrays in get_cgroup_vmscan_delay() static.
>    * Increase the test map sizes to accomodate cgroups that are not
>      created by the test.
> 
> v2 -> v3:
> - cgroup_iter:
>    * Added conditional compilation of cgroup_iter.c in kernel/bpf/Makefile
>      (kernel test) and dropped the !CONFIG_CGROUP patch.
>    * Added validation of traversal_order when attaching (Yonghong).
>    * Fixed previous wording "two modes" to "three modes" (Yonghong).
>    * Fixed the btf_dump selftest broken by this patch (Yonghong).
>    * Fixed ctx_arg_info[0] to use "PTR_TO_BTF_ID_OR_NULL" instead of
>      "PTR_TO_BTF_ID", because the "cgroup" pointer passed to iter prog can
>       be null.
> - Use __diag_push to eliminate __weak noinline warning in
>    bpf_rstat_flush().
> - cgroup_hierarchical_stats selftest:
>    * Added write_cgroup_file_parent() helper.
>    * Added error handling for failed map updates.
>    * Added null check for cgroup in vmscan_flush.
>    * Fixed the signature of vmscan_[start/end].
>    * Correctly return error code when attaching trace programs fail.
>    * Make sure all links are destroyed correctly and not leaking in
>      cgroup_hierarchical_stats selftest.
>    * Use memory.reclaim instead of memory.high as a more reliable way to
>      invoke reclaim.
>    * Eliminated sleeps, the test now runs faster.
> 
> v1 -> v2:
> - Redesign of cgroup_iter from v1, based on Alexei's idea [2]:
>    * supports walking cgroup subtree.
>    * supports walking ancestors of a cgroup. (Andrii)
>    * supports terminating the walk early.
>    * uses fd instead of cgroup_id as parameter for iter_link. Using fd is
>      a convention in bpf.
>    * gets cgroup's ref at attach time and deref at detach.
>    * brought back cgroup1 support for cgroup_iter.
> - Squashed the patches adding the rstat flush hook points and kfuncs
>    (Tejun).
> - Added a comment explaining why bpf_rstat_flush() needs to be weak
>    (Tejun).
> - Updated the final selftest with the new cgroup_iter design.
> - Changed CHECKs in the selftest with ASSERTs (Yonghong, Andrii).
> - Removed empty line at the end of the selftest (Yonghong).
> - Renamed test files to cgroup_hierarchical_stats.c.
> - Reordered CGROUP_PATH params order to match struct declaration
>    in the selftest (Michal).
> - Removed memory_subsys_enabled() and made sure memcg controller
>    enablement checks make sense and are documented (Michal).
> 
> RFC v2 -> v1:
> - Instead of introducing a new program type for rstat flushing, add an
>    empty hook point, bpf_rstat_flush(), and use fentry bpf programs to
>    attach to it and flush bpf stats.
> - Instead of using helpers, use kfuncs for rstat functions.
> - These changes simplify the patchset greatly, with minimal changes to
>    uapi.
> 
> RFC v1 -> RFC v2:
> - Instead of rstat flush programs attach to subsystems, they now attach
>    to rstat (global flushers, not per-subsystem), based on discussions
>    with Tejun. The first patch is entirely rewritten.
> - Pass cgroup pointers to rstat flushers instead of cgroup ids. This is
>    much more flexibility and less likely to need a uapi update later.
> - rstat helpers are now only defined if CGROUP_CONFIG.
> - Most of the code is now only defined if CGROUP_CONFIG and
>    CONFIG_BPF_SYSCALL.
> - Move rstat helper protos from bpf_base_func_proto() to
>    tracing_prog_func_proto().
> - rstat helpers argument (cgroup pointer) is now ARG_PTR_TO_BTF_ID, not
>    ARG_ANYTHING.
> - Rewrote the selftest to use the cgroup helpers.
> - Dropped bpf_map_lookup_percpu_elem (already added by Feng).
> - Dropped patch to support cgroup v1 for cgroup_iter.
> - Dropped patch to define some cgroup_put() when !CONFIG_CGROUP. The
>    code that calls it is no longer compiled when !CONFIG_CGROUP.
> 
> cgroup_iter was originally introduced in a different patch series[3].
> Hao and I agreed that it fits better as part of this series.
> RFC v1 of this patch series had the following changes from [3]:
> - Getting the cgroup's reference at the time at attaching, instead of
>    at the time when iterating. (Yonghong)
> - Remove .init_seq_private and .fini_seq_private callbacks for
>    cgroup_iter. They are not needed now. (Yonghong)
> 
> [1] https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/
> [2] https://lore.kernel.org/bpf/20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com/
> [3] https://lore.kernel.org/lkml/20220225234339.2386398-9-haoluo@google.com/
> ---
> 
> Benjamin Tissoires (1):
>    btf: Add a new kfunc flag which allows to mark a function to be
>      sleepable
> 
> Hao Luo (3):
>    bpf, iter: Fix the condition on p when calling stop.
>    bpf: Introduce cgroup iter
>    selftests/bpf: Test cgroup_iter.
> 
> Yosry Ahmed (4):
>    cgroup: enable cgroup_get_from_file() on cgroup1
>    cgroup: bpf: enable bpf programs to integrate with rstat
>    selftests/bpf: extend cgroup helpers
>    bpf: add a selftest for cgroup hierarchical stats collection

It would be great cgroup maintainers (Tejun?) can look at the above two 
cgroup related patches.

> 
>   Documentation/bpf/kfuncs.rst                  |   6 +
>   include/linux/bpf.h                           |   8 +
>   include/linux/btf.h                           |   1 +
>   include/uapi/linux/bpf.h                      |  30 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/bpf_iter.c                         |   5 +
>   kernel/bpf/btf.c                              |   9 +
>   kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++
>   kernel/cgroup/cgroup.c                        |   5 -
>   kernel/cgroup/rstat.c                         |  49 +++
>   tools/include/uapi/linux/bpf.h                |  30 ++
>   tools/testing/selftests/bpf/cgroup_helpers.c  | 201 ++++++++--
>   tools/testing/selftests/bpf/cgroup_helpers.h  |  19 +-
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   .../prog_tests/cgroup_hierarchical_stats.c    | 364 ++++++++++++++++++
>   .../selftests/bpf/prog_tests/cgroup_iter.c    | 190 +++++++++
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>   .../bpf/progs/cgroup_hierarchical_stats.c     | 239 ++++++++++++
>   .../testing/selftests/bpf/progs/cgroup_iter.c |  39 ++
>   19 files changed, 1407 insertions(+), 54 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
> 
