Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D057A416
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiGSQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 12:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbiGSQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 12:18:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761865245B;
        Tue, 19 Jul 2022 09:18:14 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JDR8vC031230;
        Tue, 19 Jul 2022 09:17:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yi+Tsyy1Q94v4lg7rzQXwSCA5dLF998Ti/DlLPbUjp4=;
 b=o/tgisskvdt3Eo+W9Qh4HNqdFOf3FudK3U718zBTkMXukwjNQWxSBOEXaLT1IJuQ70il
 RNVmYWc/wKs+Y4poZJ0+TaxeWt4Te/FYfn9VliUpY2hgtuJf43RElszOOI+McwqkT73A
 wD/oUOo43xix6E5vmbyXgXnu7b7G0AsO2o0= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdvdrsqhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 09:17:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEiPGONkYWmwDeJDiQOBX8mYGS+LsURkPUJHpg5VaXMUA+Xkk0tn1UxbCwFqblguCvMv7QmLD3/gSkDn0Xww0jF6W5bFloRWDNkRtWCn2k9D9yhOmQO4nWJCyImgLBh/AfK8CBL0d6cvzF9wXNd7GwB8zTA+lRoiyTKVQ2uMwJpEurW3N3SWC+7nc3Dv4FliQ+adWgKVHTdF5L5dJWSFBPqrkc8S0OMWHVj/eI+M5wrmOVPui6iVtGf/74wdNI/U3h3/+rle39jFUMypG7G7pYOhqOd1m0eU2dYe98nOIZRRu/+l0uf//kodmkRhl2oG4/XkK2OwXgP+TMWBngQDbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yi+Tsyy1Q94v4lg7rzQXwSCA5dLF998Ti/DlLPbUjp4=;
 b=ViSWOOV7xbRA0cO2raTueHHVajfBJ3OfwpZkFrIXVNseb9+zwDpWo+AHxZcjbYoNxEgIfavea8oAt90Dt3xqjiC7VYLW9ifKQ2xqM6MQS9VJAIPqYiCk51Wx+8c/GAYdeEuLWMM3mHjBzAuQWExWQZRorZtmLZcv5QI62uB8lVgD4AOmMNIJxctPECMM0Z/IXOTx0oI13VCOUZn8L9tAog7HHMd9VfMcqt9tmdZQDSPX/InVTx/KuAII4hlG9/raxvH6Y5vk53BvZsQbe4t2CNLoxEpo+RXQRDW9Mp6nxoayu2LZtKPqRX+ZxCgkgySEUtxJZRSC7fmhLu4seNp+Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB3156.namprd15.prod.outlook.com (2603:10b6:408:a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.24; Tue, 19 Jul
 2022 16:17:43 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 16:17:43 +0000
Message-ID: <670999ab-69c8-9692-4d73-da4f96c63e64@fb.com>
Date:   Tue, 19 Jul 2022 09:17:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v3 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-9-yosryahmed@google.com>
 <b4936952-2fe7-656c-2d0d-69044265392a@fb.com>
 <9c6a0ba3-2730-eb56-0f96-e5d236e46660@fb.com>
 <CAJD7tkZUfNqD8z6Cv7vi1TxpwKTXhDn_yweDHnRr++9iJs+=ew@mail.gmail.com>
 <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkb8-scb1sstre0LRhY3dgfUJhGvSR=DgEqfwcVtBwb+5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MN2PR10CA0010.namprd10.prod.outlook.com
 (2603:10b6:208:120::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7006f29b-7a7b-4c2f-33d7-08da69a2356c
X-MS-TrafficTypeDiagnostic: BN8PR15MB3156:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXDPZFoZIDhW0UD3ZHri3FTVe/s+1uVmPuostbWKtGjx/uj71eWwdzzLTECpt6wZOIu7K6MQkFXNxxS/jRpoWYjYoCzc+QxqBG86tGBXxkTGwn0gqmWDJSriAkkVWI8jmH71+ewwMHEj1qL7IRVMCvWzsKzteqW1U/0z+cEISWuARXBP7FEWtfJ+ObV6EBEoUo53JQEtxtZBYydtuUZocErZog2lx6ASmHP0S53X5WyXASLnulyBVfVQIAmeqtepm+2j4MqovXKrEjsC1C6JxEVtFshbS9bMJizXp113AIVPKN9TkaAVPGXxvU+e8k1HhQ3011WB2AUZVs8K9iC40ifEKX+SqGDCfJiH6qr/zUj84quJp9hUELB4b18UT+9QuKkQMLQh3RIUaffR81WcGoxHmaZvG0HVNP5jw9mXVk8Vh+icDNG0hze+Q8lmaF1YZPjY6gTG1+OawXfmzChMVgz2iq/P7yP83axXSFLWrU5V0mgZNxLuh/TWBsaWfeEv3lGcI4ou3R/8ZRZ3XiBahxXk/2lQxFz3g/Z0awTJKQZAADznA1pzQs18JyxLOsCQ2CBActdlA2bBTAdyrT2kKMrHpHgIup/3OiiYrlhmeEcoYzVZ1q5SN+fudfuscKuTIbOxOdtgg+1oNJZ44QZMA3xofTdq4vGP8Y8Y1li5rajin3C1dYZiJB4hlKnyESqkqnko8jRj/YnQQD7svUIcLwg72G/50YFU+3mZKCldrBRIFw1laVeAUV2uBISdWXaNL9mp4mSXRTpJIsdRi4SHwlwE425tC6YqcYZj2gycblG43K0MEMO/4Nqtktxdc+4dJD0pHRI7bJfMd0XkpwwSl49WNuGD+n9lZKLZL1FpzsvppEYk8ayMDIuHr33kLGpM+X09dV8yylfkRh4xaVjojA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(8676002)(5660300002)(66556008)(4326008)(31696002)(66946007)(7416002)(8936002)(38100700002)(66476007)(2906002)(36756003)(966005)(6486002)(2616005)(41300700001)(478600001)(6666004)(316002)(86362001)(54906003)(186003)(83380400001)(53546011)(6506007)(6512007)(31686004)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE1CUWswRG9CMnlHbGJoWnNWMjVRT3FOeTAyN1FCRHg1b2NYd0dLRndESlJ5?=
 =?utf-8?B?RTMzU1VhYmp6b0ZBUDlKRTlGZXcwdVBHM2FubElsSEZhYTNJNnc5L2k3MTJ6?=
 =?utf-8?B?WUgxbXFpTVlOd2MwRWtueEdZbmVNdTIySld6dXY1OVNkKzdvWGFsMGgwS3gv?=
 =?utf-8?B?UTJjZTJwNHdURFVCWVZSd21WRmd6aDlmWnFGVSs0aEtRbmpITW91VWNWaXpG?=
 =?utf-8?B?NUFOMDM0QzJldUUwaUFqcE5rNFlnZ2ZyekZXWTE4RTNYQ3lRMHMyek5UQXds?=
 =?utf-8?B?eVV6RThOV24xYU03U1lyYmRlY2ZjSlhtYklJMmhzMWtvdThpdzBkZW9XQnVJ?=
 =?utf-8?B?MUdQZnd6YXVEOVpjRVVVMU5GcGptMllJZmNMWVh0bVJDRXRndk9DNWNrTU5T?=
 =?utf-8?B?RWhDampmdUNNT0dPS0NiWElsRUdzTzU2NVJyUFdLZk4ySm1BMG5YcDV4UzB0?=
 =?utf-8?B?QnZaTk9VNXhsYVREdk1OK2UwK1BWek5xTlFyemt1dnZMME9aejA1aVM3WVhQ?=
 =?utf-8?B?KytXUWJaZS9VM0VXejdLTkdBY3JnOER6dUV1U1pWV1IwUHhudUk1aXhqdnBJ?=
 =?utf-8?B?ZzA5MGJKc05VWk5mWnV3QWN5aTlxZmF4a2hLbWFIY3RheXZZWmVjNGczUVdV?=
 =?utf-8?B?OVZ2K0YvMEFxZy9FN1B0SW5Na1ZHZDdHbUVxT0RmRWwxQy9IRnNGcTgwdFl3?=
 =?utf-8?B?SlJEK0plQmMrTlppWVNQZlRNdDhhWEdiYk9malVLKzN2UDBEbVVxMW56RzBL?=
 =?utf-8?B?YnNjTGRIeHFkQ3g3K2w0NmgvOXJoaWNrSnViVjJHQXBDSlY0dTQ1bG5JSllm?=
 =?utf-8?B?c3E3VnRyODIxbkF1ZjJGUG9qSUlDK2FiM0lUY0dGK2tYR2hIUHJqS0MydEpD?=
 =?utf-8?B?dGFSdytOY1RVSzZBYUNvNEx3WktqOUR0enVRTVU5T1hDY1ZneFA3cDJaQTlv?=
 =?utf-8?B?MGJWaE50eUhDbWNuTHlkMU9ucDVKMi9oQllyLzEvTlpLejlsUWcxRWloOUhS?=
 =?utf-8?B?S2lXcTRDZk90Q2gwdDJBRTZHYXpNRWhtcjJYM0hWaHJDRGpkc3R2NmtxVy9X?=
 =?utf-8?B?c2IrRXdYTDlqYUw4TWp5REo2UkROVUU1aWtuY1FwcGZKbFdGNUlac1Y0VXRB?=
 =?utf-8?B?MWFGd3ZjWGczR081clg2a3VRZ1pUTjk2MGJ5cXV3Zkd4dW1JbElGOVprMnVt?=
 =?utf-8?B?Y0lsS0ltenhaUFJibWlWVXk5OEVBZHQ1bzVyamdVWXpMcXI5OTR0T2ZuM1RX?=
 =?utf-8?B?STdxZ2grR0FYVHJWK2lzOE51NEtNWWt2ZVBkZ0FnQ0w0UWRHM0hkRE91U2RI?=
 =?utf-8?B?dDBFRER4ZjVCVm9DWWg1VUgyVklKMXJNZUJuM05Leno1aVhtcis3cElYR3Nt?=
 =?utf-8?B?NGhadXdodlFiWDV3blpxT0ZOT2Y0RVpxYlpTUWVZYkNlY2VqSmZCbFRTQzJu?=
 =?utf-8?B?TDhYRGxMdEh6QUhlOGtJdEU4a2kxTjVMTmh1RkJtaURTRkJEK2ZLN3QyWUtv?=
 =?utf-8?B?amNHTlBQd1g5c3JkeVFKN3dlUUt6b3RJM3FCRlNyM3hNcS9VYTBxRm9jVGN6?=
 =?utf-8?B?Y2prbklYbmJUV3JLMlE0VExYb0VhTk1VbzI4STA2clp5bzczY3h0VnpGaUl4?=
 =?utf-8?B?SjZOL0NIZFdMa3FDWEF4U3ZFTmNEcWlWMm5HdC9Fa2x2RDZZWlpERUQ4RWJV?=
 =?utf-8?B?NlpNdFZPc3Y3OFRDMzNJWDZDYnVoQ3lYT09PNGxISmw2Qk8rMkhENjhpYldh?=
 =?utf-8?B?MlVhcVZ2ditYcnE0OGw1TmlIWXZEZ0R4RW5jQ042bmk5WndrOVlCNWFMWEJC?=
 =?utf-8?B?ekoyd3pHdFRyU1NoUm55Rkx3Y0NoaThZNk5sM1hFdys4L0dnb3hnR1BwZGdQ?=
 =?utf-8?B?RnJtOHZweE92K0pJTWM2dWhsQW1sUTdTU1QrL2c0R011QU4zZ1VRWGxGdDQr?=
 =?utf-8?B?bzlqTks0cG5nNHV1TE55enE0MSt0K3JzU1NwVFhkR2NOWU81SC9za1AzVDRl?=
 =?utf-8?B?Q3gvcG9BeEpRMTJnZUlCaW1YMEpDa0xZMHM1TmZnQ1hoWTZ0SHZHd3ViSXUr?=
 =?utf-8?B?ZGRjVGhBcXhYeGZ0REZ1WWdnT0R0SDAybllDNmlSbWZpc0NEQ0EzM2dDc2Q2?=
 =?utf-8?B?ZWhsbE9NVmhpSmlUR29oblV4dkJiWklKK3pST2tDN3d2cEgzM3dIS3BnQTR2?=
 =?utf-8?B?dmc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7006f29b-7a7b-4c2f-33d7-08da69a2356c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 16:17:43.1685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8Y+wib+U3XTOC23DEs0CbT/Pb5ioWXugZY6NSTVs9oKvjnqWu4zd5vXaLnk25RQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3156
X-Proofpoint-GUID: lXGFH_8JvF2aAjiMM-871-bj9adhnJn8
X-Proofpoint-ORIG-GUID: lXGFH_8JvF2aAjiMM-871-bj9adhnJn8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_04,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 12:34 PM, Yosry Ahmed wrote:
> On Mon, Jul 11, 2022 at 8:55 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>>
>> On Sun, Jul 10, 2022 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 7/10/22 5:26 PM, Yonghong Song wrote:
>>>>
>>>>
>>>> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>>>>> Add a selftest that tests the whole workflow for collecting,
>>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>>
>>>>> TL;DR:
>>>>> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>>>>>     in parts of it.
>>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>>     per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>>     have updates.
>>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to
>>>>> flush
>>>>>     the stats, and outputs the stats in text format to userspace (similar
>>>>>     to cgroupfs stats).
>>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>>     updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>>     to parents.
>>>>> - Userspace program makes sure the stats are aggregated and read
>>>>>     correctly.
>>>>>
>>>>> Detailed explanation:
>>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>>     measure the latency of cgroup reclaim. Per-cgroup readings are
>>>>> stored in
>>>>>     percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>>     cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>>     rstat updated tree on that cpu.
>>>>>
>>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>>     each cgroup. Reading this file invokes the program, which calls
>>>>>     cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates
>>>>> for all
>>>>>     cpus and cgroups that have updates in this cgroup's subtree.
>>>>> Afterwards,
>>>>>     the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>>     iteration early, so that we only expose stats for one cgroup per read.
>>>>>
>>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>>     bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is
>>>>> invoked
>>>>>     once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>>     from the rstat tree in a bottom-up fashion, so calls will always be
>>>>>     made for cgroups that have updates before their parents. The program
>>>>>     aggregates percpu readings to a total per-cgroup reading, and also
>>>>>     propagates them to the parent cgroup. After rstat flushing is over,
>>>>> all
>>>>>     cgroups will have correct updated hierarchical readings (including all
>>>>>     cpus and all their descendants).
>>>>>
>>>>> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>>>>>     in parts of it, and makes sure that the stats collection, aggregation,
>>>>>     and reading workflow works as expected.
>>>>>
>>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>>> ---
>>>>>    .../prog_tests/cgroup_hierarchical_stats.c    | 362 ++++++++++++++++++
>>>>>    .../bpf/progs/cgroup_hierarchical_stats.c     | 235 ++++++++++++
>>>>>    2 files changed, 597 insertions(+)
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>>
>>>> [...]
>>>>> +
>>>>> +static unsigned long long get_cgroup_vmscan_delay(unsigned long long
>>>>> cgroup_id,
>>>>> +                          const char *file_name)
>>>>> +{
>>>>> +    char buf[128], path[128];
>>>>> +    unsigned long long vmscan = 0, id = 0;
>>>>> +    int err;
>>>>> +
>>>>> +    /* For every cgroup, read the file generated by cgroup_iter */
>>>>> +    snprintf(path, 128, "%s%s", BPFFS_VMSCAN, file_name);
>>>>> +    err = read_from_file(path, buf, 128);
>>>>> +    if (!ASSERT_OK(err, "read cgroup_iter"))
>>>>> +        return 0;
>>>>> +
>>>>> +    /* Check the output file formatting */
>>>>> +    ASSERT_EQ(sscanf(buf, "cg_id: %llu, total_vmscan_delay: %llu\n",
>>>>> +             &id, &vmscan), 2, "output format");
>>>>> +
>>>>> +    /* Check that the cgroup_id is displayed correctly */
>>>>> +    ASSERT_EQ(id, cgroup_id, "cgroup_id");
>>>>> +    /* Check that the vmscan reading is non-zero */
>>>>> +    ASSERT_GT(vmscan, 0, "vmscan_reading");
>>>>> +    return vmscan;
>>>>> +}
>>>>> +
>>>>> +static void check_vmscan_stats(void)
>>>>> +{
>>>>> +    int i;
>>>>> +    unsigned long long vmscan_readings[N_CGROUPS], vmscan_root;
>>>>> +
>>>>> +    for (i = 0; i < N_CGROUPS; i++)
>>>>> +        vmscan_readings[i] = get_cgroup_vmscan_delay(cgroups[i].id,
>>>>> +                                 cgroups[i].name);
>>>>> +
>>>>> +    /* Read stats for root too */
>>>>> +    vmscan_root = get_cgroup_vmscan_delay(CG_ROOT_ID, CG_ROOT_NAME);
>>>>> +
>>>>> +    /* Check that child1 == child1_1 + child1_2 */
>>>>> +    ASSERT_EQ(vmscan_readings[1], vmscan_readings[3] +
>>>>> vmscan_readings[4],
>>>>> +          "child1_vmscan");
>>>>> +    /* Check that child2 == child2_1 + child2_2 */
>>>>> +    ASSERT_EQ(vmscan_readings[2], vmscan_readings[5] +
>>>>> vmscan_readings[6],
>>>>> +          "child2_vmscan");
>>>>> +    /* Check that test == child1 + child2 */
>>>>> +    ASSERT_EQ(vmscan_readings[0], vmscan_readings[1] +
>>>>> vmscan_readings[2],
>>>>> +          "test_vmscan");
>>>>> +    /* Check that root >= test */
>>>>> +    ASSERT_GE(vmscan_root, vmscan_readings[1], "root_vmscan");
>>>>
>>>> I still get a test failure with
>>>>
>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>>> actual 0 <= expected 0
>>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual 0
>>>> != expected -2
>>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual 0
>>>> != expected -2
>>>> check_vmscan_stats:PASS:test_vmscan 0 nsec
>>>> check_vmscan_stats:PASS:root_vmscan 0 nsec
>>>>
>>>> I added 'dump_stack()' in function try_to_free_mem_cgroup_pages()
>>>> and run this test (#33) and didn't get any stacktrace.
>>>> But I do get stacktraces due to other operations like
>>>>           try_to_free_mem_cgroup_pages+0x1fd [kernel]
>>>>           try_to_free_mem_cgroup_pages+0x1fd [kernel]
>>>>           memory_reclaim_write+0x88 [kernel]
>>>>           cgroup_file_write+0x88 [kernel]
>>>>           kernfs_fop_write_iter+0xd0 [kernel]
>>>>           vfs_write+0x2c4 [kernel]
>>>>           __x64_sys_write+0x60 [kernel]
>>>>           do_syscall_64+0x2d [kernel]
>>>>           entry_SYSCALL_64_after_hwframe+0x44 [kernel]
>>>>
>>>> If you can show me the stacktrace about how
>>>> try_to_free_mem_cgroup_pages() is triggered in your setup, I can
>>>> help debug this problem in my environment.
>>>
>>> BTW, CI also reported the test failure.
>>> https://github.com/kernel-patches/bpf/pull/3284
>>>
>>> For example, with gcc built kernel,
>>> https://github.com/kernel-patches/bpf/runs/7272407890?check_suite_focus=true
>>>
>>> The error:
>>>
>>>     get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>     get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>>     check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan:
>>> actual 28390910 != expected 28390909
>>>     check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan:
>>> actual 0 != expected -2
>>>     check_vmscan_stats:PASS:test_vmscan 0 nsec
>>>     check_vmscan_stats:PASS:root_vmscan 0 nsec
>>>
>>
>> Hey Yonghong,
>>
>> Thanks for helping us debug this failure. I can reproduce the CI
>> failure in my enviornment, but this failure is actually different from
>> the failure in your environment. In your environment it looks like no
>> stats are gathered for all cgroups (either no reclaim happening or bpf
>> progs not being run). In the CI and in my environment, only one cgroup
>> observes this behavior.
>>
>> The thing is, I was able to reproduce the problem only when I ran all
>> test_progs. When I run the selftest alone (test_progs -t
>> cgroup_hierarchical_stats), it consistently passes, which is
>> interesting.
> 
> I think I figured this one out (the CI failure). I set max_entries for
> the maps in the test to 10, because I have 1 entry per-cgroup, and I
> have less than 10 cgroups. When I run the test with other tests I
> *think* there are other cgroups that are being created, so the number
> exceeds 10, and some of the entries for the test cgroups cannot be
> created. I saw a lot of "failed to create entry for cgroup.." message
> in the bpf trace produced by my test, and the error turned out to be
> -E2BIG. I increased max_entries to 100 and it seems to be consistently
> passing when run with all the other tests, using both test_progs and
> test_progs-no_alu32.
> 
> Please find a diff attached fixing this problem and a few other nits:
> - Return meaningful exit codes from the reclaimer() child process and
> check them in induce_vmscan().
> - Make buf and path variables static in get_cgroup_vmscan_delay()
> - Print error code in bpf trace when we fail to create a bpf map entry.
> - Print 0 instead of -1 when we can't find a map entry, to avoid
> underflowing the unsigned counters in the test.
> 
> Let me know if this diff works or not, and if I need to send a new
> version with the diff or not. Also let me know if this fixes the
> failures that you have been seeing locally (which looked different
> from the CI failures).

I tried this patch and the test passed in my local environment
so the diff sounds good to me.

> 
> Thanks!
> 
>>
>> Anyway, one failure at a time :) I am working on debugging the CI
>> failure (that occurs only when all tests are run), then we'll see if
>> fixing that fixes the problem in our environment as well.
>>
>> If you have any pointers about why a test would consistently pass
>> alone and consistently fail with others that would be good. Otherwise,
>> I will keep you updated with any findings I reach.
>>
>> Thanks again!
>>
>>>>
>>>>> +}
>>>>> +
>>>>> +static int setup_cgroup_iter(struct cgroup_hierarchical_stats *obj,
>>>>> int cgroup_fd,
>>>> [...]
