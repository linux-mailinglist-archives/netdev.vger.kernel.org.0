Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7554455F687
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiF2G1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiF2G1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:27:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3101248DF;
        Tue, 28 Jun 2022 23:27:18 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SIOccr013119;
        Tue, 28 Jun 2022 23:26:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A/sEaSIpioHKs2Bbfr4HKimR0DcmMDLF9iK8j7qY+eY=;
 b=Ww9LpyYmmYKTi3My2zLD3ESJKjaAoFOU+865EhcOpMfUMhvJ9TqikzC+9esTiFbjyjg+
 3AKzhzja8+V0SoSek+6/4TBRbYvb5y1re2wbSVFgWbqLDn0K7Vdk+JG9h5uR8+w1LW6d
 2pgyLQ9DBakkNts+kLe3HfIUaDQ02WBAsXo= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyxx3783p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 23:26:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKVWgeo6bUYRkLcFkYCoTfFLsYbH3VK1Ot0sl4tRDTEVxo4q+OXBAGFFyJ7sbn6s0vhaedhReI3sCKGbQrzRrS4Pa2EsiiLKXG3k6+z31hjWx4zq6VwOYHTt3Rz0F68ygjQWtSmgnTklGzrAXDaLnJe0fJikmYCD9z/HyWhNTMhsCjpsgyEG6bS58u33UsybBbdFDIJ1/DR4S4tPzGW1RywmyWcSUcm6vdCDilg/y6hLJYICGVELqnwmjZjPCeXlIG5DzpaZYfZaogdkRtAQbJ2C41i9G7meIPJVm3bvtMKKtjyjTk2U61tdtdViFPSNuikyvrn3zHx/ly4QFHOg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/sEaSIpioHKs2Bbfr4HKimR0DcmMDLF9iK8j7qY+eY=;
 b=RdmpIilfIdWLE7en3h9btuETiOTvpMaCYbVpPDPXVnboMC6iZAU7OKa7n9ZuANms5vKp2iB2wVUheHC4wI94wvsS50kgApPB6u47H/89ArAHA6LN4P/cWBlYJ3Hfb0TrypFvPmyW8uXbGSCmD63FcY4b8wMxiuMITFpDWFWMtTK/W3UdY+oTHxfias8aLsM/l9HXp3ZgvmM6oc8Cf663wtV5+ysRAsamSXmjMqVFSEFjsz6ezXsuiKNU4K9gW6STnLnbELNtxrV0EAA7lWEnmCjn+3MEB2YGYfBQD03jNyR70UzxUHFtpAI4PujTX6Oi5qYYuN3/4sPCWQOn0Xxewg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL0PR1501MB1969.namprd15.prod.outlook.com (2603:10b6:207:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Wed, 29 Jun
 2022 06:26:54 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 06:26:54 +0000
Message-ID: <59376285-21bc-ff12-3d64-3ea7257becb2@fb.com>
Date:   Tue, 28 Jun 2022 23:26:51 -0700
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
 <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkbOztCEWgMzoCOdD+g3whMMQWW2e0gwo9p0tVK=3hqmcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 717c14f1-251f-47d0-f3d8-08da59985c38
X-MS-TrafficTypeDiagnostic: BL0PR1501MB1969:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dizRMfLAP5Bh5kPm27HtmKrIGSZw4QWlb58pC3DyAwXQ1Xz3GGidv/6McFmCXGwouPLq8FEJuszILUGGe7BgEStR/yp4hb+q0+AS8R+57bNq5pmbiD3A4ZMgu6AhlZIMQ21KwQJxUrEz/Mz4pald1IFz7rlpiOEaMNR2qM91G/rrSPth0nzuRDZxUslW/FY0tGIKqmVg/WTdqDNnAXfL3sixE6mAeBhFSwYXzPymaJ1iv760CZ82XnDVmAIUWUMWmQwKodj/yJyHf/RXP9uspgDq18croPfSaswzHS8ZefuAcgfvnEs1h8wZ5aWLe7vXa/bdYcAVfYJeaIDPt5aPF+7c5RyDL3mJv8r/sd91aVjce0XBW3sqdEh7kU5PbnN2M9i996hSHWjfv16y7QtCyowjKps+qvB9OwT9l5RhtDjtxPADuVrh2S6rMcRtZIEqWQxBfkoncP6XNNyRXvUV8HDAYsfGgqpI1JfkNahUtw1q05YIi9KB28CzQmCSvW6A7QLW4xaLwAoedgSSTPcMUVbG/35WmVTi0qE3QvTy1WkMRfV78Z3KfhRz+/SBc6rkIRCJaz4uKbLzZ1orx9z1bJp1Cm0G7uPQX6kNmST0mIAimOMvkg+Dihn3hnCNukeO8BlCNzlYm9oxoaZC+7um9qU8FDRgqkDUXklY0hLXMtSW7ey1zEgJAS/uksEvJe964BZMKZBWdFMAAY/iQF6WJGSPlLBmxnGEEGQPsH21lvd1HYjcT04ktUoW33oK5Zjz8pSYhmi/w4aPDI2uxzTwT/qITet2J2SEA9phL+Yru1ww0AQAkLwMmUtRTxFy5XmPGGYaFmpJllh4tIgwzEEf+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(316002)(53546011)(4326008)(2616005)(6916009)(66476007)(66556008)(66946007)(8676002)(6512007)(86362001)(186003)(31696002)(6506007)(478600001)(54906003)(6666004)(36756003)(8936002)(41300700001)(38100700002)(2906002)(5660300002)(31686004)(6486002)(7416002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUd4QkkyV2Q1SGl6aS9HbVgwKzN6U2RRYmlUSkpWWFlaRTg5WW5EYUxPSjIr?=
 =?utf-8?B?WmV4QWJLRTI2S2hKeXhGMXBUT2FKS3VNdndrSWhETEVDZUl2L3VwS2toeStq?=
 =?utf-8?B?ellES2RPRUxlcmRsUjAydnhvU3VMV3BRWVVkNzZIbnZZcHZuTDdnYzJuVTkv?=
 =?utf-8?B?OW9wZmJJcTNLR2wrdkFYUHZac3ArRCtFcWRNRWt3bElJemQrZmpVemM5NDlo?=
 =?utf-8?B?ZlZRTks5amptVmIwQjBEVElLcjlXSHI4MWFJQmEyMWx1QjJoYVdwL0IyY204?=
 =?utf-8?B?UERwWWExYU9UVEZOK1c1bTExc2Nua0FWY055SHcyZW1IYnRFVWRiKzBWeEhD?=
 =?utf-8?B?TTNhck5zUkpMUFQ5NUFzekNCeXFzelN6ZksxNjdlWDY4SEs2NTdkdC8zLzVZ?=
 =?utf-8?B?cFhFcnFkcTBKVE1MaVJXZlJkbW55Q1dWWTBUWm5yaEhVcjdKVW5udDdrU3Qw?=
 =?utf-8?B?VGNuMGtDRFB3SG04cnNPTkEvRUJIRGt3SFR3bWhFOWlpa3BLWEkxMnB2TU01?=
 =?utf-8?B?dExBSHlDSTJDT3YwMEJablZqejZjejJQRjVVSVphN3ltaEZQRmdJd1dVUy9n?=
 =?utf-8?B?b3k2cUYwWlFmVEo1dG84MGlmeTgrTElYRk9WT25qOXdlVloveFhnK1AvTWp2?=
 =?utf-8?B?WGNzUUk3bm1jaVJCMkU0THJHS1R1MzJiM3p3MDdoZWhRRmt5MDA0TDBuODBn?=
 =?utf-8?B?V051RnBkWTNpVEZXTUsyaFVhZHdsajJ0M3dwaHhNK3l5TlB5eGZ0ZnlpYytN?=
 =?utf-8?B?Uk9TVjhMazVSbGE3V1RXTmlwZDdvVW85VVpBRHhTTm1Qbzg5OWRrWU5Ockxt?=
 =?utf-8?B?d3JoazNoL3pPelRScDlzUnVQdG1IbFo1RUcxQnROdGVBVGVhQVZEdzNueTZU?=
 =?utf-8?B?V1gwRWphTUN6eDZVL3FXZ0duVFozczBzSXlhanRlaTE5SklnVnpTV2ZVdEFJ?=
 =?utf-8?B?U25yOWQzQUhrRzFSeEFqMWt0dUlHTHV3MkZHK29XQmtxRjJvVlovbXY2eDlz?=
 =?utf-8?B?OVNXZEtwN1UvQk13bHhaZVNlanBkbjNPNmt2SjlmZHdxN2lwM2ZXN0FxNUJl?=
 =?utf-8?B?N1VwS2tlSFVRb3ZhWVN1VThicHpIZTM0K0FnaVFqMFZBSWgwOTRBR1MyTlQw?=
 =?utf-8?B?U1ZyYU5yWEpqWFFIdjBWTjFuMEszRUVYcHlTN3ZNZ3ZndjhOV3krK3FxNko2?=
 =?utf-8?B?UFc4cVU3dzc5L3BQNjgwSE1FTG1ibXdIZlhac3Z6NGUvZ0dLOExBQlhwQmV4?=
 =?utf-8?B?aE1HcFIyMlk0QmVOeWxZRXN1TWd4K0toKzFZNHlraFJpd21JQXo2OFhUaUJv?=
 =?utf-8?B?QTR2Z1QvRUVMN0hKMTlINnViYktSdUh2djZZT3o3MXgzTEo4VExuc3I1cXly?=
 =?utf-8?B?QVJGSGlqbEFqWHBENS8rU0hzVVlDQTZJRElMNmtGUnI0V2E3MFhSSmh4NkRv?=
 =?utf-8?B?K3NxOU1oVTQzYncvY09uaTJTclJzaWpoSmJLdWZHTnBxYWliL2szNFJwRW5E?=
 =?utf-8?B?SkFjLzhPSlRoVkh2SkpZaU9HM2NtQi96TldzV3BKcmZCUmVKWm1FMzB6UVQz?=
 =?utf-8?B?Z25vU3pYTlRMaEMwUlFlVTVRODRKNmg1VEVWQk5iT2JYS2s4R0FMdmdBQ3NH?=
 =?utf-8?B?VTZ0RHIzcXpjTGpKWk5wdWpKbjhaL0JFRmtSQUdkZFdDclZvMFl1VjYxeEhl?=
 =?utf-8?B?TE03djIvREJmbVdLeFBjL2tGb3pOZzlOb3BjMVk5Wkw0U0FzaFRJT0tBc3lq?=
 =?utf-8?B?QytCRDRKMGFCNjVHcGEyRGttNGdNd2NORnovTFZEWFZoWWVaTDlYTmM4NUFs?=
 =?utf-8?B?VC8vTlBCSTdxU2hkYUhJWCsrcHJkTzlmdWhUK0s3N2RmYkNQcVU4bkxxYTVJ?=
 =?utf-8?B?MGpDdDJGcVEvNTRuS0xPcmViSW5vczVCT3JvTndzMlZNbGNoR1JYQTVsMVZv?=
 =?utf-8?B?TlJpSDFtMDdzRytxU3FaR1RNemxDWXpJZCtlTFJoOWRsLzlod2M2bU03dnNF?=
 =?utf-8?B?WDlZZWZ0QldydkdEOWJPZjYvVTQvZWREZjRSeTRqTmdMdy83UHQ5ZzBrY0Jm?=
 =?utf-8?B?dlpSRDAweWJuaVRlZ29nZ09oNmFVUlRqT2d1UTN2RnRBclpyWVdsakFKTHFJ?=
 =?utf-8?B?TlRvZ1lhUnlQWGlEMml2eEVWZ2xBL0o4cHJNOWw1YmU5K1F2UlY4UlZlMG5N?=
 =?utf-8?B?ZlE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717c14f1-251f-47d0-f3d8-08da59985c38
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:26:54.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNmGM2nfy2O/g/UEsan7QVfc8x1jEjS5i8ID8KVusDt+RU/ystvaeE0P0i/LqTx9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB1969
X-Proofpoint-GUID: vdgNmPmwzp74JD51HcpHrgzbFDEvoEQZ
X-Proofpoint-ORIG-GUID: vdgNmPmwzp74JD51HcpHrgzbFDEvoEQZ
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



On 6/28/22 12:43 AM, Yosry Ahmed wrote:
> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>>
>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>>> Add a selftest that tests the whole workflow for collecting,
>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>
>>>> TL;DR:
>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>     have updates.
>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>>>>     the stats, and outputs the stats in text format to userspace (similar
>>>>     to cgroupfs stats).
>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>     to parents.
>>>>
>>>> Detailed explanation:
>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>     measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>     rstat updated tree on that cpu.
>>>>
>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>     each cgroup. Reading this file invokes the program, which calls
>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>>>>     cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>     iteration early, so that we only expose stats for one cgroup per read.
>>>>
>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
>>>>     made for cgroups that have updates before their parents. The program
>>>>     aggregates percpu readings to a total per-cgroup reading, and also
>>>>     propagates them to the parent cgroup. After rstat flushing is over, all
>>>>     cgroups will have correct updated hierarchical readings (including all
>>>>     cpus and all their descendants).
>>>>
>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>
>>> There are a selftest failure with test:
>>>
>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>> actual 0 <= expected 0
>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
>>> 781874 != expected 382092
>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
>>> -1 != expected -2
>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
>>> 781874 != expected 781873
>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
>>> expected 781874
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
>>> #33      cgroup_hierarchical_stats:FAIL
>>>
>>
>> The test is passing on my setup. I am trying to figure out if there is
>> something outside the setup done by the test that can cause the test
>> to fail.
>>
>>>
>>> Also an existing test also failed.
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
>>>
>>>
>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
>>> (struct){.map_fd = (__u32)1,},.cgroup '
>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
>>>
>>
>> Yeah I see what happened there. bpf_iter_link_info was changed by the
>> patch that introduced cgroup_iter, and this specific union is used by
>> the test to test the "union with nested struct" btf dumping. I will
>> add a patch in the next version that updates the btf_dump_data test
>> accordingly. Thanks.
>>
> 
> So I actually tried the attached diff to updated the expected dump of
> bpf_iter_link_info in this test, but the test still failed:
> 
> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
> expected/actual match: actual '(union bpf_iter_link_info){.map =
> (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> (__u32)1,},}'  != expected '(union bpf_iter_link_info){.map =
> (struct){.map_fd = (__u32)1,},.cgroup = (struct){.cgroup_fd =
> (__u32)1,.traversal_order = (__u32)1},}'
> 
> It seems to me that the actual output in this case is not right, it is
> missing traversal_order. Did we accidentally find a bug in btf dumping
> of unions with nested structs, or am I missing something here?

Probably there is an issue in btf_dump_data() function in
tools/lib/bpf/btf_dump.c. Could you take a look at it?

> Thanks!
> 
>>>
>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
>>> nsec
>>>
>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:find type id 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>
>>>
>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>
>>>
>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
>>>
>>> please take a look.
>>>
>>>> ---
>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>>>>    2 files changed, 585 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>    create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>
[...]
