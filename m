Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350E555F714
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiF2Gs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiF2Gsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:48:55 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F66F2DA94;
        Tue, 28 Jun 2022 23:48:54 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25T5l8kb025262;
        Tue, 28 Jun 2022 23:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qWj3O+CuUFnJ/qU+OQ+GMrZ1CDnCXB1Qs2dYuJcAL/M=;
 b=g36swh321KjzpZ6XOSEfhZoGABt7niH1Vj1Q9M73vGTpR0YTF2Lt61plzLjt0ZgRkvdc
 lUSGUP10JmT8dbOLOv7xryu4FU7roTn98QUiVj6DG1XimoqciaaHMO4qDIXoB4sVnQcn
 B5DloVXc+c0rlL24uqq3K60PMcGMDMpDoU0= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h0691bxkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 23:48:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxuZMTXR3B8aDmBO5aSqUy/wmJdxPcuJJw8XvDiCNCKh+tFlM+zGUHnvA2hTBm2xsNzDKwguVE8zXOwoKgR7eM/S5tMXPDjYjByYHYj4fefeenuk/YwdgeAsqO0VnjRGRyctw7qcU8ZFRBf0G73YC68lXJjtOxbTL3WijF8IWtCJesKyiLR79KTfmoHhHzpzgcJXHox0s0qIi8zNVN50/oKjBBuZSt02uiXMRf+wISqCSNMDTv/OzPdw/dKRl6kRVJbpKNxbHe8nl8H0I5BHarh7iqNFKOFBPO4tg695e96e3EuQR+5dvnwptdJ1FXbwGCsfQmWrq4AxYuMdVpawZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWj3O+CuUFnJ/qU+OQ+GMrZ1CDnCXB1Qs2dYuJcAL/M=;
 b=N0BQXeKwRC3NBAYWaqMWEhSYZSeNzqMpD4cfyDtGoyPrabgXShprjm3qaO/TAI8srbRNgdKUGcPMBfqCTLryldGKKWisAlD0T2+ngVO6i05AcwuAXfJevZ6Kt0reGsovklUVR9QpOF/iYFmZLhln7AeDClDbDisfVKOyElEN4yVD5ljGUKoNYOEHlHA+vILZuWn9H2FuSnbGyoFDiHFcCMyqgr8MYYj8ykwGIEscjJZ70PwfGL1rZT8fhJ9egO7dWzbKcCRzkc1db5uLaCRg1Hw7lf2i53rE7qCiNzIOBCI1Ow1VENibn9IvkndRdhWaJoCetPGYzAqvzkwg5fRTJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CO1PR15MB4905.namprd15.prod.outlook.com (2603:10b6:303:e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 06:48:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 06:48:30 +0000
Message-ID: <6dc9d46b-f1df-fb1d-8efd-580b7a6a7a6e@fb.com>
Date:   Tue, 28 Jun 2022 23:48:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-9-yosryahmed@google.com>
 <00df1932-38fe-c6f8-49d0-3a44affb1268@fb.com>
 <CAJD7tkaNnx6ebFrMxWgkJbtx=Qoe+cEwnjtWeY5=EAaVktrenw@mail.gmail.com>
 <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg@mail.gmail.com>
 <CAJD7tkarwnbcqR1DUN-iJmt0k_njwBfDMd=P8ket8DfEfRRYjw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkarwnbcqR1DUN-iJmt0k_njwBfDMd=P8ket8DfEfRRYjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR05CA0068.namprd05.prod.outlook.com
 (2603:10b6:a03:332::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 288bedee-8f7c-4e53-fb22-08da599b60c9
X-MS-TrafficTypeDiagnostic: CO1PR15MB4905:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4vJtAiqDc2VVXsdxr94ihaz84XSFqC13nhDzhrfXiIVpNcT9yepsmpapB3r0tqiyWcLhqBYS2K4sxBaeV/lmXND8DPiFovJIgU2pSscg4E/LmCSwOc9OlelvbADRB6sfnWZQM5GReFX6ZJJ13iO6tCYPmAWCJkgWZGC1ciR7h2l0VtRoZqzEm9GgOP7ObXzE0+HrI0s6lR7KgGSTfZeHXqYO1k65LXpiAb9dojI6RL6yiG2cirDYojFo68PVuBV5cCMd6won1p8E1L+jXC0h0Qfdu/okuw06wJPEx665yr7PZth4OhS2SnHkrcKlNWfnhpmRzKNoOISkq/W5lEJZmgJDOSh3ZIm13Tf9W5e3e4uiw4UjnE//fFpo9wdossBEIm9mnIjhkUZ4oBJM2MjJJMArshrrQNqgj7DJthPXebuMDx6pI/Ok9HMXcpYMXgrRpGX8o+Svg5bmqtFk8lfQ8OyNo3WVxtwqheRTCNJzk6SbZFrGu1Jh4jnflWSEQHGRBDE7mx3zNkdtb9YmcN6eGRzkCu8q1lUjAbaxKxO0ZtClxDeGWrKsSpIB21W9FEIlci2O+OsuNyoTysuv2dqeYBrkZN0wLp6YJ1ONQXdoF0MoNXKF+1d1dFlx5+uXVyUGMWJKIotsOI2ODr3kijITQQgCxalf3hzrNEWDq6pnLjlDtK5BgH/iUZpqZmM6KD5vQcE0BJ9crKqCuMfJKrjRq48sNY/TTeUMM/nd1ojENpLVy5ZH/nTCmUlQtVIYZ5HJzjE+ArPyYdVEj2N3y2t1HumrBo3EJHLdLS+t6y80ADx7DQThMMhB1yttzzLiGvpSRV84BQQnN4rvMQyvvRub3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(31696002)(36756003)(86362001)(38100700002)(2616005)(41300700001)(53546011)(6506007)(6512007)(83380400001)(186003)(54906003)(6916009)(478600001)(8676002)(4326008)(316002)(6486002)(66476007)(66946007)(66556008)(6666004)(5660300002)(2906002)(31686004)(7416002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0IvY3ZZNlBub2Urbk5aaUE2RUg2d01CRG9QUDdwYzVPWFd2NFBjRjl4QlRn?=
 =?utf-8?B?RGd4VHRkM0NZVTlqSytaT3FRUTdZWFd5Skd5MmM1NWFWWnQxc0dLMWY4V2tO?=
 =?utf-8?B?bkdGK2hSRVlHaGNWTThaZXRhTXk5OURXbnIyVmlnSlY2MTdnN0dNK2xNbXRL?=
 =?utf-8?B?MldYUmE5cTEwci9lMmhHcFRiaktLVnFLcVhrTk5QZThSWUhMQnEwOXlBeVh5?=
 =?utf-8?B?RUFnc2tzOHNEeU9xcW9KSXdZaEhxM0lUOENuVWtVWWs3RkZoVHRPbFhYMUJL?=
 =?utf-8?B?a3ZRenBoV1RxbW9PRnExMkJNeStpVmh0Y09ZT2xvNEZMTVUrRHdPeDZ4dFJa?=
 =?utf-8?B?bEExWkxWZVZ2bHZJMnBKL3h5ckJyQTZKSGNEQWhUb1pUOGlWZ3NHVkJDbnlX?=
 =?utf-8?B?QlRrUEdTRmo1MHRiSjM5d0VvNklvU1JIenczbnk1UVZFUVNmazNaWFYwaG5o?=
 =?utf-8?B?amhCczNpNm82bGR5NTBYS1AxbWV1aFJTbW9wck5NMlA0TWNmY0kwM1ovZmZT?=
 =?utf-8?B?V3hhM1NMc1VxUzNFV1N4UWhJa092KzFYQjlRd1JSMWJDbkhKMC95MEt4Rno1?=
 =?utf-8?B?WGdQeXpZVjZISDhDbVBROHNoY0FMUVY4U0hrQnVWZEFqMC9QcFlGZEl3QTRO?=
 =?utf-8?B?Yk5GRkZQUzV6QkpiL3p0cElkVmR6d2VCNTJodWFNRG5BMEI5VjlEUkZDcS9j?=
 =?utf-8?B?VWFiYW8rbGsxdm44VG9XT3Y2ejI3QXlPai9SYWNhdGFESzQrZVpGOXVrcFNI?=
 =?utf-8?B?eHU3OWx5YkRSMXRLQlNTaTZWSXBRV0l0L1RWQTZjU1dsaFQvVHRacDZXVEdj?=
 =?utf-8?B?cldkVGNxK2gvTmRKQnNSSWNiTWFQUkRRVVptRVJ1YkJCcHVuSnRQdkFoTjNv?=
 =?utf-8?B?ZTFOaGtZYjB0bTI1UHU3SHBKWGFpeHFHSk1DSWhTcTVmbGxwOVNOTms5ekRX?=
 =?utf-8?B?MktSRFJmRzVxTWFJRWpMTWJtRUQ3UysvdWdtem8rUkpRZkVaL3R5d2VsTzhk?=
 =?utf-8?B?UTZVWlIwRXVFN0twMmNya2pwMk85aG1heEZJL1ZISzJOSDNMNks1aGpmSmdB?=
 =?utf-8?B?eUJmaWttRGVBY2lZVE5Md0M1eDVQV0VKSEIrQVBPcWpMUm0rN1lDSVhzRVJ5?=
 =?utf-8?B?NTBGRlBwWkM0bGUvSWJ2Y0Y1eWtBMEpzUXRBZVpOd2RuR1plOGZ4WGQxd2JO?=
 =?utf-8?B?V0xJMzhUa0pLUFQ5R292TUNIZFU0Y3NVZGpDKzRUVFNMZSt6QitFTzdOY2l4?=
 =?utf-8?B?MkcvZ29hcXhCWVVib0ErUUU3WW12SjFHYnBGSGljVFJaVWhYQXRLOE1xVEdR?=
 =?utf-8?B?bWVubmpXeWF0VFpGTiszMWorMk56VnUySmFkOVZsdTg2K0NEb2dqcWY3UTZW?=
 =?utf-8?B?dkFrbDM4TDhtMlFjK0tXTmxGN285VXBpYUlLRHdzV1IwMlR6N2JKZDVicWlV?=
 =?utf-8?B?NEdHdENCS0RhaTJUdHY2VTMzeFVkdHgwSG5LZ25abEVnd0lyQVY4QUVPUG5r?=
 =?utf-8?B?enYxRXg3MXdWNlM1TlpRbnliKzkrNEJaVzVsTHNXWkptdzJIdDFraFRaaEdD?=
 =?utf-8?B?b1VwRzk5Qm85cFM2YzZaTThpTGZHc0xYZ0tqNlVITlNaQlB5KzRSemdJNWs4?=
 =?utf-8?B?S3BQK2NMUktjK1ZwbU5YTHNHVGNZM0lMZjNudE1mZkVtZlRDTTNVL1RrTE5L?=
 =?utf-8?B?ejRpOUdKaWdISENnZXFEUW9NVjAxcS93TkNSZXZINVc3TXg5ejhMRDRzMGpy?=
 =?utf-8?B?WU9jb2lmMkM1VFJISzZUS2lXRmtOUTVZakZNa3BUakM0eGNVbTc3VXJFczhQ?=
 =?utf-8?B?OW1LbnJ4KzY5aDhWcVhnK2dtZnUwUHhZNW5kdzNVSXFoYXZDK3c0cmVieWpn?=
 =?utf-8?B?SGZxSkZXbll6ZUJqQ1NudENDaDR4YlIxZXN2VldUcktKV3lEcjJqUW0vU25B?=
 =?utf-8?B?ckZhNStUMm5xUXUxNGsvcUd0U2RLSmRUMTViR2JnQ2c3TG9RR1k3MkNLVlk2?=
 =?utf-8?B?a3R4MTFBRTNQTDJ3VE93MFlKRTFKYzJkcmtZd1JqRm51Q3QyRmVkN1IwdktU?=
 =?utf-8?B?bVhFN0JFbHZWUWVxVFZWWStJekhTbUwyOHBjVkE2N1pHVjFMdGk4dFlUQzRN?=
 =?utf-8?B?ZXVDSE9KQWFwZ3kveWFRVDZpeEFiNG8yQm1yaENXS1BoQmt5VTFFZXFKdHIy?=
 =?utf-8?B?d3c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288bedee-8f7c-4e53-fb22-08da599b60c9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:48:30.7499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gjdMmfuh+Nb5kmfzs4+KUp0WSyb0dNrsaY04Qymiy2QK9mV6w6x+dI5NxYEuxqh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4905
X-Proofpoint-GUID: uvrCCJzcg8SGjrH92XfdTlurd4Q4PA13
X-Proofpoint-ORIG-GUID: uvrCCJzcg8SGjrH92XfdTlurd4Q4PA13
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_11,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/22 5:09 PM, Yosry Ahmed wrote:
> On Tue, Jun 28, 2022 at 12:14 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>>
>> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>>>
>>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>>>> Add a selftest that tests the whole workflow for collecting,
>>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>>
>>>>> TL;DR:
>>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>>     have updates.
>>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>>>>>     the stats, and outputs the stats in text format to userspace (similar
>>>>>     to cgroupfs stats).
>>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>>     to parents.
>>>>>
>>>>> Detailed explanation:
>>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>>     measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>>     rstat updated tree on that cpu.
>>>>>
>>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>>     each cgroup. Reading this file invokes the program, which calls
>>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>>>>>     cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>>     iteration early, so that we only expose stats for one cgroup per read.
>>>>>
>>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
>>>>>     made for cgroups that have updates before their parents. The program
>>>>>     aggregates percpu readings to a total per-cgroup reading, and also
>>>>>     propagates them to the parent cgroup. After rstat flushing is over, all
>>>>>     cgroups will have correct updated hierarchical readings (including all
>>>>>     cpus and all their descendants).
>>>>>
>>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>>
>>>> There are a selftest failure with test:
>>>>
>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>>> actual 0 <= expected 0
>>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
>>>> 781874 != expected 382092
>>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
>>>> -1 != expected -2
>>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
>>>> 781874 != expected 781873
>>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
>>>> expected 781874
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
>>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
>>>> #33      cgroup_hierarchical_stats:FAIL
>>>>
>>>
>>> The test is passing on my setup. I am trying to figure out if there is
>>> something outside the setup done by the test that can cause the test
>>> to fail.
>>>
>>
>> I can't reproduce the failure on my machine. It seems like for some
>> reason reclaim is not invoked in one of the test cgroups which results
>> in the expected stats not being there. I have a few suspicions as to
>> what might cause this but I am not sure.
>>
>> If you have the capacity, do you mind re-running the test with the
>> attached diff1.patch? (and maybe diff2.patch if that fails, this will
>> cause OOMs in the test cgroup, you might see some process killed
>> warnings).
>> Thanks!
>>
> 
> In addition to that, it looks like one of the cgroups has a "0" stat
> which shouldn't happen unless one of the map update/lookup operations
> failed, which should log something using bpf_printk. I need to
> reproduce the test failure to investigate this properly. Did you
> observe this failure on your machine or in CI? Any instructions on how
> to reproduce or system setup?

I got "0" as well.

get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading: 
actual 0 <= expected 0
check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 
676612 != expected 339142
check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 
-1 != expected -2
check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual 
676612 != expected 676611
check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 < 
expected 676612

I don't have special config. I am running on qemu vm, similar to
ci environment but may have a slightly different config.

The CI for this patch set won't work since the sleepable kfunc support
patch is not available. Once you have that patch, bpf CI should be able
to compile the patch set and run the tests.

> 
>>
>>>>
>>>> Also an existing test also failed.
>>>>
>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
>>>>
>>>>
>>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
>>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
>>>> (struct){.map_fd = (__u32)1,},.cgroup '
>>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
>>>>
>>>
>>> Yeah I see what happened there. bpf_iter_link_info was changed by the
>>> patch that introduced cgroup_iter, and this specific union is used by
>>> the test to test the "union with nested struct" btf dumping. I will
>>> add a patch in the next version that updates the btf_dump_data test
>>> accordingly. Thanks.
>>>
>>>>
>>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
>>>> nsec
>>>>
>>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>>
>>>>
>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>>
>>>>
>>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
>>>>
>>>> please take a look.
>>>>
>>>>> ---
>>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>>>>>    2 files changed, 585 insertions(+)
>>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>>    create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>>
[...]
