Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8041455F66A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiF2GRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiF2GRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:17:42 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981AD1C113;
        Tue, 28 Jun 2022 23:17:41 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SKo9YG006741;
        Tue, 28 Jun 2022 23:17:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ooy3Gc5a2eb+IgnWx6/fKAomiRpDs+e4kGIE6Z8bdDw=;
 b=oK2f9j4QxapxxrAyy/2x+l+PUgUlvw4nlLqT0jhx6DSXNk43eNC9ch8GOIO9RTe+J/qo
 JWVXdEeEXJECFbEYPwTCzDCzj1uUCDHW+tcqMqt0JMgKKIBKKTiHVStWnmm1Fv61CTBU
 Qozr4BEo2Djbt8wwmmSLdQcLxAPD9b3ZClI= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h03ax5sqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 23:17:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJ2YgbfmtdKkqCrAUYj8YWfSSX2PmuXVKJ/HeKiq4MYJ8B3Wk5n/OMleMmF/8iy4kF8TWKzPYgoyya+89u8fmOfpOohGC0KqV/T2RjSsH4qaAnCOpjRh85RYTUAFdmusvt88lahXD3tQzwBpKftZnrR2yKRFDIQu9td7/E6TcyEWPIzvzSJPA1sz78v4Zy9T1ADtgnIXqpFZm0JnYxBJCCxttMQAVITiU6nkdwA6fA1ncXb8UqLtg60gIzZMnEymgIlyak/B+jZ3b/Gib9qg9UBGd6rVY/Lx+egIg91O5GzL08TH28JQ+LVA+fPlSWYWtFisMj0vCZxovEyzqSj4cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ooy3Gc5a2eb+IgnWx6/fKAomiRpDs+e4kGIE6Z8bdDw=;
 b=K/eA8DWoCH+iYw/wxJtNLWbs2EQ44X+HLx4KHmqIWYv4LjaehWUk3ee2VpblyrH0VWkpZuLYVfB9ptjIuaFRC/ZJn7FYdtk6sHUqBpfphodcEalCfmUgCiS1uhMw7Y18tk05PyayXDQxaP6XGt01EQM4jfEufbgtbjIkjcKnfQUT2eNlnDMSYctfaNi3Ex4jpcLA6tehGxxbGtoWOzwDFBbEfzMwsvsZye5i2kZMtul2OPo0V86eSFceLogIoF2vqYDqbyicFlnu+IH65QlQgCck0i1AFpYAN2//+B/YGOMEJpojcd09rDqYtna/YJyHjRb9FgUAmS20/khoSdggvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DS7PR15MB5327.namprd15.prod.outlook.com (2603:10b6:8:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 06:17:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 06:17:19 +0000
Message-ID: <5a28a1c7-0420-ca93-0b92-fd54e726ed8c@fb.com>
Date:   Tue, 28 Jun 2022 23:17:16 -0700
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
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkZ3AEPEUD9V-5nxUgmS5SLc6qp50ZyrRoAQgdzPM=a-Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0108.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc0e00cb-c9e9-4e88-9f04-08da599705a3
X-MS-TrafficTypeDiagnostic: DS7PR15MB5327:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRbE0hj/2ITjVFN7EIyGkRMaKkmrTahPOOwVC88n7qKZWQtMhRyl7Z0F1xsTbbN4ZaHxAEie6fbaL+nHqEqlx7bM7VMMzMd4DDEO7YOuEeW+7flQBxtXafTKkXr9qrb3a/pYxovOk0cET2S4y620FwwaAD3w85F+DEnhebSirPEuv2BO4nZYgeKPs+rXPzxHjZYWCBhtln/IN9Eob7cO/tzVhWz3FPql/hxwT4budGKQPZXFFAFwMVciVN6jNA4ZH0QYKKsob0eW6o7iIXWMiBP6Oa29XrwFlmDRPePTBoD9oxp11OimRAvvjpEgJjr7RuvChuTZZY2PjZ+eD3v8gvaPDTN4k9R1yFWabbZ2GTQM2aYckcJ3n+EAziCE36WzKzmxZqZa4NPZRC8UdQfAZ3ij7QvWGilnYhTC6fegOGf5zTHG6XymwVcTPvhILTYNg4wpCk1tgzHOaMBSXp94c0uffsKm2a7Qag9csWa1rcV+RdLjGxNu6DqOVtK13zWemlIHalGE55QeNj4GjZXvp4XDAfP8o/ZlAOLoLsgC7LI+fYg1tQyvneQQSVxKntlvj29KemIUXhlGg+G00Ig864WF4urupQGvrgAYC497y0NDD2Eju0emmcJ5Q/XW02+SpgLT3JBSW9JqqJ17921Gb08N96zovXuSZZLGKxvOwXK61AP1Gi/G91fKKAvZ6O8jl3RsDcf8sSRnuVUi1CMRz5y7h6staoAmhR2BJ/UcHG32KCvzV42A1FioaXZqsM3V4H2YM92q497yamVTA6VP8K0E+rJpiYTHU0oTQUPz1miUlC5QdpEpWHPkw6y7YIhz2MflofVu/mqgJbNIhJHaXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(8676002)(66556008)(66476007)(478600001)(6512007)(6916009)(53546011)(6486002)(66946007)(4326008)(86362001)(7416002)(36756003)(5660300002)(54906003)(2906002)(316002)(8936002)(41300700001)(2616005)(6666004)(186003)(31696002)(6506007)(38100700002)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWhnY2RvYUJGSktrdnRlaTV0NUNGVVRRdVE2R0RGQVUydmlqZEJnNnFOb1pk?=
 =?utf-8?B?YVBrd1hSMkpiYnRxZFFSWmdSREdSWXo2M3R6dWN1TjE1VGFJRVB4dUgvUlpB?=
 =?utf-8?B?VFc2eWNyQTRWNUNWcWhveTVma0VaelUraGI1UmN2eE5jeUV1U0dxcnpkbytu?=
 =?utf-8?B?SlRGcVlyWWwxM2N2N1lpa2ZqSWFiM29JWUtyaVNwbXlmVFM1clZtWVNwb29Y?=
 =?utf-8?B?SGx0d05ubW0yYUdJNnU5SGRKZ1hVbmYvQlZab211SVNPQ1UzemhiZk5Odmc1?=
 =?utf-8?B?VUprKzZ4KzlXdFNmcngxblNQdWJlVlpTV1JiVVJjTnlyMTBYSUFvY2dGeHg4?=
 =?utf-8?B?S1FUU280VWNNYVdKUGJSZkxkbWpSRmU5aXd3aDk2eDMvcUl4UzdBNGFJV2ZK?=
 =?utf-8?B?STM3cWRBbEtTZDU5K2NDbHpYNldUcjJieE90bk5jSWM1aFlXMFJXUnl2TVQw?=
 =?utf-8?B?Q2hoNlVucXMvY0dNZVkyamxLVGI4NHFwUmtkVFFLbHZOVEw1TVBFOWUyNUFs?=
 =?utf-8?B?TFZzcTZNTmJncHZsLzI3MlhVcGNyUjd3ZUZTN2N3OVJHTmxWZ1RLeS96ays5?=
 =?utf-8?B?dnB3K09lM1gwSVZQYUs5c0V0VjdDMUhOcktrTElWOUlmeDRTZW9TSFpOR3Y1?=
 =?utf-8?B?eS9oelVRK3A1Tm9Zc1pBTStSR2dRL0tVN0hsRFdFdVVNbm81aks0bEdzY2xW?=
 =?utf-8?B?OVFjcGRmcm1MYUJmNi95c3dvSERyMnBpcDFhUmpuTHIzK0tEdUNQSXQ0a0tp?=
 =?utf-8?B?ZUVGZkhzR0x6MkxlV2RIZHlKQ3c0QnpGMU1TZ0ZmK29wNy9laVlTajZMeERu?=
 =?utf-8?B?a1FsQmo4QkRrNENKM2tHQ3FuclM5U3htWDhYOXlkTUY4Sys3QTBQNG14QTVS?=
 =?utf-8?B?bHY0UjNwd2JyYk9DNGFOTUpRRDhHWWtXbzlWazN0V3BmbEdNY1ZYaFBqbGpM?=
 =?utf-8?B?SlkxYm91ZWl5S3kxSWJrZmF0SlVHTjRZRXo3d2kwSHIvdWhxRWw1TVdoVHhS?=
 =?utf-8?B?OG4rcjlXS2YycVkrcFdweld2Q3VvdVowVlhzMGRvZmN6QmhhcnZRbU8xVU02?=
 =?utf-8?B?TXd5N1I0ditjMlFWVkdUSjFtNlRud0V5amxuUVFpTGhPWWlOL29zOUw1YjVx?=
 =?utf-8?B?dFlJVHpGaWphU1hrMEw1VncwSnBsQXltcXo0Y2pNalcxOFBLM29raFJ1VGtU?=
 =?utf-8?B?TVVHd3BpdUNmeUxUTTZFV3BTTC9HUXI4ZEJmWWRQTU4xZmVNTy9KNWNoVGJo?=
 =?utf-8?B?MGcwaktQRUlGV2c5S2VpdUdBWldyU3hmL3RBN0UxWmIva1FTV3BQT0hTS2lr?=
 =?utf-8?B?dlhXblgyOFNlNW1KbHdrQ05oUUZ2QldGcG5CTzhNVlU5cGZSdTJ3Z3VOcTBV?=
 =?utf-8?B?d1FJSGllMytYR3YreFlxYVJLNU9CbmtYWFJjVmNFaHVFTjdScmo2T2tJWEtt?=
 =?utf-8?B?T1BtR0pDeHJFR2VNR3BxWG9lU2VWRmc2akYwREV5YzEyeDdsSmgyUGNiQVpN?=
 =?utf-8?B?Mkk1TTNUdDVxVytaMVRTd3VqZ3FQRFBDbjBqN0I1eVJRSlU0UzFqZCsyOVRF?=
 =?utf-8?B?WGVKYVE2anRQbFpQZnVHS1hxNGpUMVFRUnpFQVBHMVZnaTRXT3YyR0dXVDUz?=
 =?utf-8?B?L1FyUWxkRWNtT1pYdmF2SjJ1elFrNlBiNlpWK29qN2xEZnRyVDd4SytpQStp?=
 =?utf-8?B?THlLOG5CeW5WNzZpSVIvcVlXVU1CTmp2MGVkZ0xzenR6WnUxanlwZ1hPUi8y?=
 =?utf-8?B?Q3FvdHIzSi9wckZ6M2kwdFc0Z3l4Y0YrS1kxbVBGMVRCTEh0UldsbWhtRWUz?=
 =?utf-8?B?V2NFSVJpNUh6bGhKSisxQm9oNnFLdUJEZ3RFTTFYbytjMnc5cXF3bUtSdXlt?=
 =?utf-8?B?TWZQUkl0YVZkYko1Z3cvYWVtSExwMmFJYVQ1UU0xajFuakl2M0NDemEwalZ2?=
 =?utf-8?B?L1Y3RDBKaFFtcEJUNDZxUmZaZmNzZVQxZDJwTzFLblpsblEyL1Nkbkg0L2Q3?=
 =?utf-8?B?RFlYb0x3dDV1Q2IvdENPbW90dmxoOWllcnd2eThzWkJJQU9waW52ZlEvVGNF?=
 =?utf-8?B?OGRmVHRSL0N0V2w2UzZobW9ZTS9seHRqL1BXTGthRHRxbmdiMmc1SFdhNmpI?=
 =?utf-8?Q?pEkYB2IDF9q2NJvTZ6LJh3vOu?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0e00cb-c9e9-4e88-9f04-08da599705a3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 06:17:19.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uYc6iiGrFtihTH09Ro8cpx3wKJrdXLYwLKWOXJmozFFKAuwZO1HkJRa6mUwcVoWH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR15MB5327
X-Proofpoint-GUID: VfG7NVLU6GLgbM9SJROKZTHtx668qeGe
X-Proofpoint-ORIG-GUID: VfG7NVLU6GLgbM9SJROKZTHtx668qeGe
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



On 6/28/22 12:14 AM, Yosry Ahmed wrote:
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
> 
> I can't reproduce the failure on my machine. It seems like for some
> reason reclaim is not invoked in one of the test cgroups which results
> in the expected stats not being there. I have a few suspicions as to
> what might cause this but I am not sure.
> 
> If you have the capacity, do you mind re-running the test with the
> attached diff1.patch? (and maybe diff2.patch if that fails, this will
> cause OOMs in the test cgroup, you might see some process killed
> warnings).

The patch doesn't help. Still failed.

get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
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
destroy_progs:PASS:remove cgroup_iter pin 0 nsec
destroy_progs:PASS:remove cgroup_iter pin 0 nsec


> Thanks!
> 
> 
>>>
>>> Also an existing test also failed.
[...]
