Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD662563D17
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 02:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiGBAzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 20:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGBAzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 20:55:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AB531530;
        Fri,  1 Jul 2022 17:55:36 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 261Nt5Ok030494;
        Fri, 1 Jul 2022 17:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Nf+sC10BxO/4n9+I8Wtyh+SF0datPkG1O5cpmLbL6dg=;
 b=g2RguzOL57uORzo96cn0DbGgq1djEzfDpTvnToKO0+Muix/Xjqqc9HpOLx9Ii48fUJFm
 SjBpds2MA49cTJ0p+tq8g9sBxsbNbE7gETf2rrDUd6ZfKuMetpmRW3EkhMKay2E0vr4J
 55zqz3AJ8FEJNRt1Y17cSb6S+rYf/T2MGx4= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h195acbr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 17:55:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M60GjlDdQNtvLpKFsNjNXyGfI782vLB67MpeU09UddGaJ6XVHSZ2gLahtM+TXHusl8Ym1dnC8jFucqxnttsoB8BIIXdjXeC2+LfPW/eVF0bl77ayttkzwwyXTYLjn5+79oGzTn4ikR01dPDOakE7V2ux34D5Euu8NwHZWK9IG8sryMBo+BHBrqcaLgTxd7bAJPa4lUty4HmomaDa5UNvn/kewobPphE1WrWCzeZG+u3+4cIO36Ff53DOVSTKuwpWlCsrhpwY3wVX+ywGWPp410dWp57n0DkgxkE7JCQYmG9eczRY/MfSjvvFEbDZxQRB53W0bTy9ksYvZhCSWk4evQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nf+sC10BxO/4n9+I8Wtyh+SF0datPkG1O5cpmLbL6dg=;
 b=Bs988+PlHaAlUvCwzN9qGt5Sz/aBHStnHAZ/UQ4tdbPOXjoWwref3DiKIKCPEJ+dIKM2dlv1yYinBBrvQYQTZ5MAHKi0r/uabDiyvDNAfkCES3Ro3mBETpCFXUNsApO27j01y3URwWDUw9CVdkfLlbDB+9fww8WnkXh6jkhSNkgQZmDZsbMgOAxSF1GU234fNVtly1A72WHGJZt2FKbz0l/Je5Xwa1dX7024rHgquhAbbQEkqmc6W0LOHVe+gfYB0ke3PCyJPVmJqBE79HgQ01B2+OBeFIZ0M4QE1Mo7y3uca4cXEmZX/ZwtKuKCsRQVeZT+FcefcgoAIzd9uPcvxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB4315.namprd15.prod.outlook.com (2603:10b6:5:1fa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sat, 2 Jul
 2022 00:55:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5395.015; Sat, 2 Jul 2022
 00:55:13 +0000
Message-ID: <d144ca6b-7f25-f3fa-def7-6c63a6dfc1aa@fb.com>
Date:   Fri, 1 Jul 2022 17:55:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
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
 <6dc9d46b-f1df-fb1d-8efd-580b7a6a7a6e@fb.com>
 <CAJD7tkYsAyFguCOFCKYCaGyaqipCrTE1Q0ecvnrpY1fwG4j=Pg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAJD7tkYsAyFguCOFCKYCaGyaqipCrTE1Q0ecvnrpY1fwG4j=Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0P220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f31e7091-f3f2-40e9-94c3-08da5bc58573
X-MS-TrafficTypeDiagnostic: DM6PR15MB4315:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZIc/72DKf4/g0OKeLC2QoMktpuvkSBEixWQeyUwnupPCULGbEJMJ1j1wEVT5SGQAtremq071PKwnYkG+kSHE4jsWM3XVMQkSRf84zsrq9q9KIlEfKMcX3T7xmM/MQ1tUmMsJS1RzEMOKgIq+71aDw/KBESJw+8j1RiFwkVrDI7mY3SGLYnc06vuvT/1jNzXfe4IPCp/OPYvDF22reyXKrP7YTtmg3FN69vzBL3q0JlCvAky9KuU+98cBYiwgl9hRr4Bd1+2E3c1Hl3fvT7f6wBQmK/NFkIjWV1nwnaGDgIIkqOAkTHs42YBcwwle9yGTb5LlD8r1LYpJzNPY80GASxQr24eRu94luKM1QagJYPAe9dttvlPgsjRctE2slVCaUnsrYlCoeV+BhO4whF8pYRimqbp0iydc/R8k/lA0ocAjrSUXD+jUxKlNtfY4zdCnjT1pgvb5nuU1fAzag8C0F9ioXfMn368UScocxddxCZZf+dAB8lX/KwKPlWg4wX9CEGRzMDmqFlCaoA1zsHbVJ+ahg4MC8bClqZbTdATEeVwG1PwJ40r2rIANo4HrX/TxnK5fCBiwEjrCkYvolCoN4iXE7CTn6rXs3/sT4/wilKe/MSDbPMcSyZ0drFNWS0VcVZfTKULSGB5zUD1CYAJWbbNSAUO7VZW4i2xuDalpMWzhCaJn+Ko/swuxo2NZdUEsXHqpwLA4++z221oX93af/IpCRuWOIZDnaQLQqvcZGBBJSh1Qn1NdTyPT5/zpu1dW1+chOuxAKRkfTw12fIl7ac49Ym7jvRL65NOMJyJdtT9pNsJvhXLlHyZgooddnrgivN8BDFyFQRps+fDmKlOyeJxaxj1r6ajGXrwH/NGHiQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(5660300002)(7416002)(66476007)(66556008)(31696002)(8676002)(66946007)(8936002)(4326008)(2906002)(36756003)(86362001)(6916009)(83380400001)(38100700002)(31686004)(41300700001)(478600001)(6506007)(316002)(53546011)(6512007)(6486002)(2616005)(54906003)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTgvZG1NeTB6VHkxTFprMFZXMTRvYWs0ZWdWYm5Gb0pjV3ZDVENqU2hQRnoy?=
 =?utf-8?B?TE9iOG5SM2NTSmtSQWZQOTNJdFNRdEtLNncydTI3MU5BRUZyNVB3VjhsU094?=
 =?utf-8?B?RFJ4Yi9sQXczR0NhV0VMT0dTWjhhMUsxeVFvUk5RVldkVHRLcXlVR3BPZ1VD?=
 =?utf-8?B?Y095ZmRDRC9OZm1xZ1FPUWJjQWZnbjRlUDhDOGdwQkxpYkFaZ3VvcjJ2NjEy?=
 =?utf-8?B?VGdFZk9NcThOYmdBQ0xEU1NjSVFsWGFMSlQ5RXdBUHRXZjAxdC91bC9ISG1m?=
 =?utf-8?B?MW9HYnhUV2NWbG45cmgzMW9VZDhDTVEwMnN0Ni9zSUExQk1TOURGZ25jOUhZ?=
 =?utf-8?B?L0FKUFdiUE02K2hvVE1LWG1lL1kwQ3lSSUcvREsrQmN1THVRYVE3T25zK2ho?=
 =?utf-8?B?S0JwVmZmVGFTNnl3NmNibkF1a2hlaXBhV3FWT2MvV2pCYko5YjgvckNZSUNG?=
 =?utf-8?B?bVl4SFAwZ3dkYk1YbEJRMWkrU29YdUpKU1F5YnkvVTVkRCtmcDNqUWY2RzA1?=
 =?utf-8?B?MFltN3d2UmVjSFYwNnM0TmxZYzFIZHRYTFNseW9OTkhubDdpckZYbFJJZFAv?=
 =?utf-8?B?cXVKSWRZK1A0azBubkQvV1l4dHQyN3YyWDQyWE5tWG16Q2JZNm5PZWNEZS9P?=
 =?utf-8?B?a2tsR29tdkg0S1E2R2JZeEVJL01TdHBnaTZGZTkwNnNDQ3k2elJYMW1sNnhq?=
 =?utf-8?B?dmhSSS9vU3VxaDBJcmNvSXlFK3E0QU95dWZDWk5wK0pXUE16RDBrNngxMjZj?=
 =?utf-8?B?ZU9uaGhCei8zd0xwK2lTNkwrOVFxZFA3eWdPZ3dMU0dFWmVIaVQ0L0RhNDI4?=
 =?utf-8?B?WlczdDJRSk8reVlISnN0UTAzV3FucWRGdndPaVRCZ1RZLzdCOEdWTE9jL2JG?=
 =?utf-8?B?SFRrbkovKzNpRFpVMDNpUXhod2tqQ1VucitUQURkTzR4Y1BQNmtOandUbjY5?=
 =?utf-8?B?QnNxUFFKMEdqazNZS1VhalByT0VTK1RSOUNKS094WEc3N3p5OWY4cWRPcW1h?=
 =?utf-8?B?SFF4dU1aRE5qZHphN1RjemhaQktTZ1RmNW1SM0Z0OWd1eGh1L0k3S2xFTGFH?=
 =?utf-8?B?VDZRN2ZNVjF0Tnd6d0FSeGF6dzlJTUI0N3ZONkovVlBXK1V4YXVwaW5lWkNm?=
 =?utf-8?B?QnBETncxSHh2NnRESk1WdTVNZmpXZ21kVEIzTzhud0kxUHJBMlpFWU1UaGRt?=
 =?utf-8?B?SUpndTQvaURhTGk4OUhzSzZDZTArSUkyMUVrMG11VEY5N0d6S0liQTFoMXNO?=
 =?utf-8?B?aEdDTklKVWhaeWRsbitadlI2M2E5eHh4UUlQcTV4WlNMNFZlVXdPZTNBL0NU?=
 =?utf-8?B?UlZ2bllHd0hHN1VHUExZM2E3Um9FRHY0bEVOcXdYT0FyWmtySzNRM1BEaVlz?=
 =?utf-8?B?VE1ZZzdRRGxRVWdmK1cycjkvbmVVa2R2TGtZWndwMzRYQ1JDNTVJYUtwdUhh?=
 =?utf-8?B?clRNb3JOR2N4dkIvdW5QRXN0UHVNbWUybmtVckdNYzVweFV2ZVRQUFJTTUFK?=
 =?utf-8?B?S0lhOFo3SW1MQTdISVRGdnBmUjhRcWlqV0k1S0F5TEhSOVhqQkYvSENhalFp?=
 =?utf-8?B?MlFXb1RGQXNWS1lsYnAwaks1L2xOTG9ERmgxZ1ZOZkFVY0ZLNmFWeGZkQ3hC?=
 =?utf-8?B?bS80Tm1xUXhPTlVxdDNYRkdMQkVDUCtrZFhRVFhGaWhqZzdsSXFVT3N3UzRZ?=
 =?utf-8?B?dzdXYjF1M3BOc1ZiemxiekoxOWZDbmpDL0JCdkpJVWg2MW9NWDVWQ1lUemdk?=
 =?utf-8?B?LzhZU1FaWmw0NkRBRGNWSXJGU3pLOCtubkk4QjJGK0hhMDM5QlpkVXd6VFYz?=
 =?utf-8?B?MTF3dG83TjEzRUtpNENRSXJuekhqeEY1L1kwNjJZTU9OdU5ENHlQRTVpbEFB?=
 =?utf-8?B?R0JuMzVCUVU1VWkxaHUvZGJGUnlxc0tpNWdlUG55OHBpbjE2aStmOWdSaTlq?=
 =?utf-8?B?eUl0M1BJazJzcUFoaHd3c1JBTEFmU0ZoREVxN0R1bTArcFRwNklDSG9LSXJq?=
 =?utf-8?B?clowbnBNM3hoOU1hSTAyU1FxbERLRnRva0xyWEFFelZBUm50ZUZCNFN5WHZt?=
 =?utf-8?B?cERZWVFvYnEzemVuOFI0TmNUTGJFMWVsYUJMUERVTWNQRUxFVG1DeGZEbXpx?=
 =?utf-8?Q?2Q8jh/wL4/5WzbZUgI0bB9NkW?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31e7091-f3f2-40e9-94c3-08da5bc58573
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 00:55:13.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr0/+la6uJZxJ/QGcWu4/VO2PB1TEZgeYsfBzLrxqi+LqdAZRdBdy6s6bUNdDcQD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4315
X-Proofpoint-GUID: uhumkXia-ojxBMoYx2xwrg7Ddv-6tVcw
X-Proofpoint-ORIG-GUID: uhumkXia-ojxBMoYx2xwrg7Ddv-6tVcw
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_16,2022-06-28_01,2022-06-22_01
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



On 6/29/22 1:04 AM, Yosry Ahmed wrote:
> On Tue, Jun 28, 2022 at 11:48 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/28/22 5:09 PM, Yosry Ahmed wrote:
>>> On Tue, Jun 28, 2022 at 12:14 AM Yosry Ahmed <yosryahmed@google.com> wrote:
>>>>
>>>> On Mon, Jun 27, 2022 at 11:47 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>>>>>
>>>>> On Mon, Jun 27, 2022 at 11:14 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>>>>>> Add a selftest that tests the whole workflow for collecting,
>>>>>>> aggregating (flushing), and displaying cgroup hierarchical stats.
>>>>>>>
>>>>>>> TL;DR:
>>>>>>> - Whenever reclaim happens, vmscan_start and vmscan_end update
>>>>>>>      per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>>>>>>>      have updates.
>>>>>>> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>>>>>>>      the stats, and outputs the stats in text format to userspace (similar
>>>>>>>      to cgroupfs stats).
>>>>>>> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>>>>>>>      updates, vmscan_flush aggregates cpu readings and propagates updates
>>>>>>>      to parents.
>>>>>>>
>>>>>>> Detailed explanation:
>>>>>>> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>>>>>>>      measure the latency of cgroup reclaim. Per-cgroup ratings are stored in
>>>>>>>      percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>>>>>>>      cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>>>>>>>      rstat updated tree on that cpu.
>>>>>>>
>>>>>>> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>>>>>>>      each cgroup. Reading this file invokes the program, which calls
>>>>>>>      cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>>>>>>>      cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>>>>>>>      the stats are exposed to the user. vmscan_dump returns 1 to terminate
>>>>>>>      iteration early, so that we only expose stats for one cgroup per read.
>>>>>>>
>>>>>>> - An ftrace program, vmscan_flush, is also loaded and attached to
>>>>>>>      bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>>>>>>>      once for each (cgroup, cpu) pair that has updates. cgroups are popped
>>>>>>>      from the rstat tree in a bottom-up fashion, so calls will always be
>>>>>>>      made for cgroups that have updates before their parents. The program
>>>>>>>      aggregates percpu readings to a total per-cgroup reading, and also
>>>>>>>      propagates them to the parent cgroup. After rstat flushing is over, all
>>>>>>>      cgroups will have correct updated hierarchical readings (including all
>>>>>>>      cpus and all their descendants).
>>>>>>>
>>>>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>>>>
>>>>>> There are a selftest failure with test:
>>>>>>
>>>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>>>> get_cgroup_vmscan_delay:PASS:vmscan_reading 0 nsec
>>>>>> get_cgroup_vmscan_delay:PASS:read cgroup_iter 0 nsec
>>>>>> get_cgroup_vmscan_delay:PASS:output format 0 nsec
>>>>>> get_cgroup_vmscan_delay:PASS:cgroup_id 0 nsec
>>>>>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>>>>>> actual 0 <= expected 0
>>>>>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
>>>>>> 781874 != expected 382092
>>>>>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
>>>>>> -1 != expected -2
>>>>>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
>>>>>> 781874 != expected 781873
>>>>>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
>>>>>> expected 781874
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter pin 0 nsec
>>>>>> destroy_progs:PASS:remove cgroup_iter root pin 0 nsec
>>>>>> cleanup_bpffs:PASS:rmdir /sys/fs/bpf/vmscan/ 0 nsec
>>>>>> #33      cgroup_hierarchical_stats:FAIL
>>>>>>
>>>>>
>>>>> The test is passing on my setup. I am trying to figure out if there is
>>>>> something outside the setup done by the test that can cause the test
>>>>> to fail.
>>>>>
>>>>
>>>> I can't reproduce the failure on my machine. It seems like for some
>>>> reason reclaim is not invoked in one of the test cgroups which results
>>>> in the expected stats not being there. I have a few suspicions as to
>>>> what might cause this but I am not sure.
>>>>
>>>> If you have the capacity, do you mind re-running the test with the
>>>> attached diff1.patch? (and maybe diff2.patch if that fails, this will
>>>> cause OOMs in the test cgroup, you might see some process killed
>>>> warnings).
>>>> Thanks!
>>>>
>>>
>>> In addition to that, it looks like one of the cgroups has a "0" stat
>>> which shouldn't happen unless one of the map update/lookup operations
>>> failed, which should log something using bpf_printk. I need to
>>> reproduce the test failure to investigate this properly. Did you
>>> observe this failure on your machine or in CI? Any instructions on how
>>> to reproduce or system setup?
>>
>> I got "0" as well.
>>
>> get_cgroup_vmscan_delay:FAIL:vmscan_reading unexpected vmscan_reading:
>> actual 0 <= expected 0
>> check_vmscan_stats:FAIL:child1_vmscan unexpected child1_vmscan: actual
>> 676612 != expected 339142
>> check_vmscan_stats:FAIL:child2_vmscan unexpected child2_vmscan: actual
>> -1 != expected -2
>> check_vmscan_stats:FAIL:test_vmscan unexpected test_vmscan: actual
>> 676612 != expected 676611
>> check_vmscan_stats:FAIL:root_vmscan unexpected root_vmscan: actual 0 <
>> expected 676612
>>
>> I don't have special config. I am running on qemu vm, similar to
>> ci environment but may have a slightly different config.
>>
>> The CI for this patch set won't work since the sleepable kfunc support
>> patch is not available. Once you have that patch, bpf CI should be able
>> to compile the patch set and run the tests.
>>
> 
> I will include this patch in the next version anyway, but I am trying
> to find out why this selftest is failing for you before I send it out.
> I am trying to reproduce the problem but no luck so far.

I debugged this a little bit and found that this two programs

SEC("tp_btf/mm_vmscan_memcg_reclaim_begin")
int BPF_PROG(vmscan_start, struct lruvec *lruvec, struct scan_control *sc)

and

SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *sc)

are not triggered.

I do have CONFIG_MEMCG enabled in my config file:
...
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
...

Maybe when cgroup_rstat_flush() is called, some code path won't trigger
mm_vmscan_memcg_reclaim_begin/end()?

> 
>>>
>>>>
>>>>>>
>>>>>> Also an existing test also failed.
>>>>>>
>>>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:failed/unexpected type_sz 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:FAIL:ensure expected/actual match unexpected ensure
>>>>>> expected/actual match: actual '(union bpf_iter_link_info){.map =
>>>>>> (struct){.map_fd = (__u32)1,},.cgroup '
>>>>>> test_btf_dump_struct_data:PASS:find struct sk_buff 0 nsec
>>>>>>
>>>>>
>>>>> Yeah I see what happened there. bpf_iter_link_info was changed by the
>>>>> patch that introduced cgroup_iter, and this specific union is used by
>>>>> the test to test the "union with nested struct" btf dumping. I will
>>>>> add a patch in the next version that updates the btf_dump_data test
>>>>> accordingly. Thanks.
>>>>>
>>>>>>
>>>>>> test_btf_dump_struct_data:PASS:unexpected return value dumping sk_buff 0
>>>>>> nsec
>>>>>>
>>>>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:verify prefix match 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:find type id 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:failed to return -E2BIG 0 nsec
>>>>>>
>>>>>>
>>>>>> btf_dump_data:PASS:ensure expected/actual match 0 nsec
>>>>>>
>>>>>>
>>>>>> #21/14   btf_dump/btf_dump: struct_data:FAIL
>>>>>>
>>>>>> please take a look.
>>>>>>
>>>>>>> ---
>>>>>>>     .../prog_tests/cgroup_hierarchical_stats.c    | 351 ++++++++++++++++++
>>>>>>>     .../bpf/progs/cgroup_hierarchical_stats.c     | 234 ++++++++++++
>>>>>>>     2 files changed, 585 insertions(+)
>>>>>>>     create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
>>>>>>>     create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
>>>>>>>
>> [...]
