Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1FF55A03F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiFXRq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiFXRqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:46:48 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02153ED3A;
        Fri, 24 Jun 2022 10:46:46 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OAIZp0017219;
        Fri, 24 Jun 2022 10:46:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OyNrN6EyO8Pf4UvdxqWA8vntjORPiHd3hLyWhsOiVsg=;
 b=bSwKBPVzbcWI0bA7Rrsx2p+C6Ba7QGdDnjzUU0VNgxGVlXPFNu4COkvNkoaCrK/l7B/R
 bHR0W18zvw6wqclwDf+2UvT7P8Eh8qb08uPw3VK64vosa+WuE7BhOlBcjjRQJ+WM4ivg
 QOpQ9Pc1xUsjLUdrTKnk2hKVLz1mzI3LgP4= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gwbd8ak2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 10:46:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kji0MgsZvNeT5d0KXkf9D5uDk4Jm7YstHYMtDh/d8o3hVBwM1r8tcM1hPCS1w20nWYUlvnHz3/jKqhkNzD/B6CgXAfLiAYggzx29yQpYFpU6E6+r2rU//7H8ZIypnQ69zOFy/O71bheAqSDBgddoq5xvUNiyAP0tg6RkbGOHrvBNVDth6ehcR7Fx0116Fm2r2sAHOqHqZJaA91yXytZVTUWxEdgn6Ygib/HdcBDzh8pHVBauvPmAKXfrUnidUE+feApsHcHqO7me3GZlbkNpGwt8mGvFBvNL/NoHRp/ZSKTT1wtN7fkb5U9bymdg65JTtRX1JFs6mdyh2cFDFZjJOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyNrN6EyO8Pf4UvdxqWA8vntjORPiHd3hLyWhsOiVsg=;
 b=hiwYt7U6GVz+cAkqdEBaLamfbB1VZWIflLGx+oLgh77WyChMA3DoR+SDaUrLFu4ay9cDYuC1wb8kmYWZI4mH754V1kDIPQv69ANEiMnrLstQD5C28Fj7IKSyG8xyDztvB+7LNRaRoSlaRcYfiImOiczFedFnopflIVFDLL7EvMSxqFwod1rbhXtu5CJTrBcj4956tEeoVtQ9RkJ2IdCP3GJClPPNqEJF04AsoDsXcmTlDCiTOJohXp78AjQAdit7+RPRdWisbyl5W5psgy3IMUHBLVfCIH7tcGU/6hZW41Z3ibMqRmmkt0rkxe9ih9aNkqV4puZFXEP3SbM7dznMYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4767.namprd15.prod.outlook.com (2603:10b6:510:8d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 17:46:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.015; Fri, 24 Jun 2022
 17:46:21 +0000
Message-ID: <dc5aca8d-16c4-a1fd-a2f1-fd3008c10e02@fb.com>
Date:   Fri, 24 Jun 2022 10:46:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-4-yosryahmed@google.com>
 <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
 <CA+khW7jU=Fqt49jxG8y5n2YtRu4_C1gFUW-PqZGY_Rt8PGrGEg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7jU=Fqt49jxG8y5n2YtRu4_C1gFUW-PqZGY_Rt8PGrGEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0200.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 587d18af-5af5-4d69-c96e-08da560972de
X-MS-TrafficTypeDiagnostic: PH0PR15MB4767:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RsH4wad1rb5X9WbcrKhj1+VVdERxUus9QEiMdk1t5eBh652qq3ITexkODR+4w/670ucvCw84G67p5m2X/5pKKOltVwSQddpW+mFXZDXUVS6kZyTk2SilWWBIC3CMT5J4EsFQsUWMXjegEQ7fL3R29+sKx5EAM9Ec+UbA0dCcHu2bdLoTSyEoTMOzUsJpav2NK0GvV2CMN90yBfkllQxGGNfrsAoxqkpv5YhSmS+L8SP39qTbzv0wGa8wsowRuTmznvJj4vW2nkYVNNgYtYN0hrs3sNg6HsP2Ut6V1g6ntZMc+nojRryDp737cQC3vtFcHto4BZpxg5d6pMbQbm8jVntv10wDKLh+3UL6YVvEmbcPkAX5Y8CDrGdYiqoBpyfy8vwAHlvp1XdnlRnVKeMfr+oO5HEbojUcVxH3psT3BLaq4SWA/XdlhQPO+errhEGmUd812YZ0+Hr+3I21fhChfruGpqib4dx5P4/cz++v1+PwAFII+ot1rkNe7t2PYR9b5O6nsmU3pWhNq8kUe+HTxlebKNvPYQCh1/giABMV2zhJ6XcW4xAh5H/65CkaK+DWFUo3v9EDA5jxkrjNNS6Z/tSnAuFcC+JbihiAIERy2C6A4GEmQ7JibjoxApa0e95wmIV7+BBa1nt+Zu37D/CDrZJGnkRYj5qQr2v+cX74oVwIOOFMrABrdjze70ko/0FblS6guPqlOd4fYPTf5RTM7vBB3gX/Y9WVe0l9WZg96zCgVN7vAy+86aDWVK6FFEoO03R1gHJomMtuA/PouRtmc0SLfaWCo6skWwdecVYKhzvU3pJaiponHr5rJd8Xb05AOXvOhaRSRfnTS7t3mCupPccd613Y5+8GeeXH074Qx8RKVHoB48wveei4s7D7kWVLxXsb2qqJGVUxGGMh0YWwNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(478600001)(6506007)(8676002)(6512007)(53546011)(6916009)(6666004)(6486002)(316002)(41300700001)(66556008)(54906003)(966005)(4326008)(2906002)(8936002)(66946007)(36756003)(7416002)(31686004)(86362001)(38100700002)(186003)(66476007)(31696002)(2616005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnlZOExkT29ucWNZWHpvaEM1QzAweDJRWmVFb1hnYndKVDdCWGp3T0JQb0FQ?=
 =?utf-8?B?M3dSWmF6eVVGeEg2Y1ZFTGxSRWg5V1B4UGRrVnlZdGRvSEIrVEtiWXI4MUNS?=
 =?utf-8?B?Z3pkTFFGbFAxNGtoQ0NvTzNUVDNrcmQ0WWRTeUUzZ2JCWjdNZ3JlZ3ZEQmM4?=
 =?utf-8?B?U2N6VXVIQmVsaTkxWkFhby9UN0FITXZCMDlEVGhVNFFoR0xneSsrQmxXS2FB?=
 =?utf-8?B?VkVpSFNZMjNULzFaN3Q4Zk9TTVNHRTVZWHZ6b01jb2tVYUZkd1lOb2RqdUpE?=
 =?utf-8?B?SDFQaUNvTXd4QmYrUGxaV0hKbC9zd0g5aTJpVXoxRXcxWGpLYkRVcmYwQlU4?=
 =?utf-8?B?UkhIOFV6VWNabk9pZW1CU0pYSXIwQUJ0M2FZamp6OW5vU2VDSUl1SXcycXc4?=
 =?utf-8?B?MTNiaGQ3VnAxdlVZbUNSK25lTTNvLzh1V1JPNVpMWGRXU1Z0bENrTzE1Tkdv?=
 =?utf-8?B?c0pXZjdxcGFFYTBSeDhLejVoRlFuMm1VamFVb1QvYlFqKzZYaHJoMUtndVAw?=
 =?utf-8?B?RWlCSGdjMDhZMW9KOEZWc3V3RGVidjBRNlVibEMrc0FYcGYrZWtnbGVyZ1VL?=
 =?utf-8?B?T1NkYmw0bGdLczdlWW4wOUtWTXZOWVNwWWFzWjl4SHdLeG5LU2ppR291L2Mx?=
 =?utf-8?B?RVFSR2g4cXduSW1rVjJzT0lzN2d2WnhIbXhGa1dXUENrNytMN0Z0L3NmL1NN?=
 =?utf-8?B?eTdFRG5HTytZRTVxVG0vZnYySEt2NklERVNJQzlZVXBNVk04ZDVQQzVIczRH?=
 =?utf-8?B?ZTJVWU13S0N4eFRCbXoxUkxvOXI4ZDIzdURVbmtZV2ZNNmFScHdYR0dQdUcy?=
 =?utf-8?B?Y3NOMU9QOWFGWnNXNWxLK1FId01wbURvczBEY1llODQwYzEraTFBM3hacm53?=
 =?utf-8?B?dUZLRmF1Z3JnTXNJTHZyN1cwSSsrRERUTXFLZ0d2TnpNaldOVDJSczU3WDNK?=
 =?utf-8?B?bUJoYlE3TUdYY0NDb2ZyNHhkWnc2d1R1WjlFaGljMXhoZ0N2bFNHM0czWk9p?=
 =?utf-8?B?SVdXVC9haGViRFI3OFF0NWFDTjNJSXdxV0hqSWY1VWlXd3ZJUjJaSjlDSnRi?=
 =?utf-8?B?MTU1UnhGVVByWkM5N01jbENlRVFuUUVMMjRNeXBNMjg1bDZqd0NkRUlubXZ2?=
 =?utf-8?B?YnJkR3AyZjZRVUl5L1pOUS9LVUJiWGk1WVdPa1BCdm11ZXpKNXBXSTJjKzMr?=
 =?utf-8?B?SFhhWUxLSFlsSzhJRmVUMVZnQzVMamxMamtieHJEeU5ENmFHb0NFcVNmSEV5?=
 =?utf-8?B?QnE4Z1k3dEdheXVES1J5SjZrcFkyOWRUaTRUUytidCt6VzJ3K2thUnJUNEN4?=
 =?utf-8?B?aHNVbkdzcU4yTGcrc1E2eDZvemtEUGxNVE5GQnJGMXJCL1J3NlVKZlJ2a3dV?=
 =?utf-8?B?aW9zZW8zSlY4VEhkWkZycGhQbUlZNWQwb2h4YVNiekhNVGVoSHh4MlR1azJh?=
 =?utf-8?B?azVqbmVTNCs4TDJ1UUFkcmlhT3lFS0FncExrSmluS2RvVENkVngzeGNWYThr?=
 =?utf-8?B?RTI4ZE9ZT0QyQ084SU1pODNwM0NnbXN2NTRvdTJJbnZ3RXBlL1JlVGRvS0ht?=
 =?utf-8?B?Q2Evb2hhcVRWYjl1T2RnaUJhVUQ3NHlGdmo3SlFDWDFwdkk0T3BjdkY0akZ4?=
 =?utf-8?B?aDFjc2kyR3hxcGp1YUVZZVNHMU1iMVNiQTNMVzkrV1AzTTVud3g1NEF5eUV6?=
 =?utf-8?B?WFdwdG1MMFZ4YXVBNTEwNDdxNzZoZjFnOVp4RmhoL21YT0RsV0twQVljK3FF?=
 =?utf-8?B?a2h5d1VWaTB5d2QwTUpGaFlNWUZlODMvM2VmR3ozS1NjcnJ3UTRTU0pMZG45?=
 =?utf-8?B?VFlaMDZaQjcvMnY2QVlIc2d2TTZUYXhkUEN1MU1yL1hDYlQyRjZkc0FZQ2dT?=
 =?utf-8?B?RDNmT3liMTkzR215R0d3N2ZBa0VsQU1zTzFQdVBnNU9NS2NJMnFhYTJCV3FB?=
 =?utf-8?B?bXE3SHRjWWpTVkVESk0yeGllVEZLaU40U3hJODJYUHZSK1hpNDdLeUdIbVYx?=
 =?utf-8?B?cWlsckw4dFlnRU1pcndwVVJwam5ENldXMTZldUtta0tkNXRLQ0UvOVQ0UnBh?=
 =?utf-8?B?U2pnT2Y2RUJsVmJySmlxdlh5a2RpT2UxeGVNcEVWY0ZMR055a0wyTmJYb3NI?=
 =?utf-8?Q?UyG6tODR+d3kK9SGeqAkR2OcM?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587d18af-5af5-4d69-c96e-08da560972de
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 17:46:21.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij1ElTteVCJlZInZJlvFCnMqMkA/kZm2AqWYUGxFYLzYqzxD9mzTIzcQxkFgfx8R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4767
X-Proofpoint-GUID: Y2A2YVQmfXCwM7xhF3fmO4dgIiRswwHP
X-Proofpoint-ORIG-GUID: Y2A2YVQmfXCwM7xhF3fmO4dgIiRswwHP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_08,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/21/22 12:25 AM, Hao Luo wrote:
> On Mon, Jun 20, 2022 at 11:48 AM Yonghong Song <yhs@fb.com> wrote:
>>
>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> In bpf_seq_read, seq->op->next() could return an ERR and jump to
>>> the label stop. However, the existing code in stop does not handle
>>> the case when p (returned from next()) is an ERR. Adds the handling
>>> of ERR of p by converting p into an error and jumping to done.
>>>
>>> Because all the current implementations do not have a case that
>>> returns ERR from next(), so this patch doesn't have behavior changes
>>> right now.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> Yonghong, do you want to get this change in now, or you want to wait
> for the whole patchset? This fix is straightforward and independent of
> other parts. Yosry and I can rebase.

Sorry for delay. Let me review other patches as well before your next 
version.

BTW, I would be great if you just put the prerequisite patch
 
https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires@redhat.com/
as the first patch so at least BPF CI will be able to test
your patch set. It looks like KP's bpf_getxattr patch set already did this.
 
https://lore.kernel.org/bpf/20220624045636.3668195-2-kpsingh@kernel.org/T/#u

