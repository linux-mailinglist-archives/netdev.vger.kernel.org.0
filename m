Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25C8583843
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 07:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiG1Fvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 01:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiG1Fvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 01:51:47 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6954C85;
        Wed, 27 Jul 2022 22:51:44 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26S3TpfV026873;
        Wed, 27 Jul 2022 22:51:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wkxOQHgGT4k2jPe4Si8am0cE/jsE4UHpNi3tOzBsKb8=;
 b=JKgq9S1ui3aDosWiq2hYIcl3hPa+sxUYv1skyfVkyoOhNE/VVwX1INB/5MXKH7XQuthD
 G8AJo0Zld4hluIoLAu+d9xGiCGa0wCn0V6jeemFuKHp+NBDAOkovIEf24TpfIJGf4vyJ
 8wd/hI1sbaZ6guZUGGVQtT+mNd7lPW4IYBQ= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hkjkmrha4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 22:51:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2OTjejks4Wrbi3pDjIKaKzdQuJg5wnLnlnHOeIMSEGuPaf1KZ75TTWQt9+YH6T7K26QMQzBcEZjl8CoUSSfKw1Wp4kLcKXv/orOluI/lIGynJxlz0FDDljxSnnv7XlcHrGMgaDn2Pqeazze9zFiQcwkf7HHlV/uYCj3POVCEAR8+iwwmQBRN2FBh5qIii7qeH+/XJBF8buyiAAEwUWDs4qhNUDc3QMde8K12+ahYZXZkrB6MxUjxdA0sjTnD8Zc2+QnLeJkkES1nL3ItOlv0ArH9eU1dU8tct8FuYiH7n+vwtFvFbgGFJVUoEmzKDY8EqRc9KmyVhxfjbYgZQsWHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkxOQHgGT4k2jPe4Si8am0cE/jsE4UHpNi3tOzBsKb8=;
 b=Xu1ZL/04m1IRDxNgWo+E5q0U9rRj0bWRi/s4OZ/52IaTx27xp7bTOQWfCqcnJ0nS1WbObTNJGe6jGmUqX4Esn7JhgSn0skec5IP4smZmtcui9SoD/4DgSDTyD/QxWmkda6J19m4PFH3+WfEUCAjqabg2OyL6Go+gvB0dn6PRdrECWze55z3tTCRCHf1Y6+Iz/46/mS6DuCJoxnDcyS+k8B4ha3Y14dUFbG1iMN5oWnXDYtiHniPfpYvTMSj9d+s8vr20quN5VVsItc58ctD0do8fMOK8XtmuHADNE3z/hbwi1jWRig6eO29OEX9Fn6orLP2g6wK0kQFhWbfTU0ukyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY5PR15MB5416.namprd15.prod.outlook.com (2603:10b6:930:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 05:51:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.024; Thu, 28 Jul 2022
 05:51:19 +0000
Message-ID: <8678322f-01e9-862e-9c6e-1ada1c6badf5@fb.com>
Date:   Wed, 27 Jul 2022 22:51:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v5 8/8] bpf: add a selftest for cgroup
 hierarchical stats collection
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
 <20220722174829.3422466-9-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220722174829.3422466-9-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0039.namprd17.prod.outlook.com
 (2603:10b6:a03:167::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a3416e8-aa8c-4082-56ff-08da705d3192
X-MS-TrafficTypeDiagnostic: CY5PR15MB5416:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouU0YrHaKuCjd6hJ2ru0bEqTfeOD0naPxTepj8f9fGkXbzsmNjwBZi0BiDAQ43P3zvNWLjKCY0Ffu855ozrZGTVMsuQ+4iwkY8tMYWOqPG+uCm63jxJ6VM+84U7zA7w/weNNIaut+BZPPDDFi9J9SiWP0Xc4SlDCRut/bY7Hjf971jYQxpzyIprNxan0+i+TkSMH6dZpbARxlNJzXwIjasA03d4eVVlnLGspJanmp296k7nHuqbjCFiJGXwsvUi9DU7aBk8iBPHInZDBtkumJ5GNeyoadfNQF34vcnbUk878JtIdCodpJcOLjSD68UldZLqIKqDm6yeHNIOlrJRDnksIUBpxirW9/0i+20lFJluEBP1nM552pHKf4u+WVZvod7fRHvACHQowYFLNx0diCHEOnzHbGqLqUwpE+mFP8zQPUR1Jk7n5iRTun8DxeBGOcTMM7/2BFj6GeVlJoCLWZUlKf9S+GDarttTgaXs80bYo1P/xv0ogob5IWcwI43rWWJdKvZO3qMRL43d99z/5Tx2qhsKpBdU9oRS1X2e/emK/bk9LPu4/E78ngAruXe2dg6nIs29W3cxcKNTSIHbSYqKhytfOuovzLMF6kObYA8o+Q+juYe0G8kPoTZK7MwyD4RwMQl90g5qZm2YFFpHSg0A89MPOM5yAzalJLoEaXOn/1pWegrAHQvekncljCGkXxL42O48FHEOXlZocomqQRMtfvH728RHpU7HU/kQtF9WmxMNjkZc4eTtF3A4HlZCi2WYNG1x+ys63F9n/xSE4GnmZIMubS5fOpG0KfMMgCdzGBn+4/O9SgVdzcBde6f8YGqrWzzGaV58etc7lwCh7yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(53546011)(2906002)(2616005)(6512007)(31696002)(66476007)(66556008)(41300700001)(86362001)(54906003)(66946007)(8676002)(110136005)(38100700002)(83380400001)(4326008)(7416002)(186003)(8936002)(478600001)(6666004)(316002)(36756003)(5660300002)(6486002)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHJIZ1FJRjV6a3BKOTZnZnpXL24zcHhRNlNJeDRBL1NzaTBqdW1TS2o4WlV3?=
 =?utf-8?B?aFJoVWpFL01qMjIyRnY2dXRhWXk0YmJPaTMyN0VjVG56amp4R2IwTnpGZXhk?=
 =?utf-8?B?QnVTdkZ2eGthWkJxNDcwZG1pTyswb2tJdDJFd1IyT00rY2pYeGZXQy8wb1Ni?=
 =?utf-8?B?THB0SGJFL0E5QmlsQUs5aGQyZVVUMEkxRTU4bkQrZXdxeHlmSzdHVzNtMWEv?=
 =?utf-8?B?QzNGMjI4NVVmNVhnNTJLZThEY0ZTUzdGbEZ4dnluSGFQYWNIRDM4L1ZyZ3Fx?=
 =?utf-8?B?NzRzaHh6OGh2ZklzMC9tbHV1VitLeXpDL2JNT3RkVkdPeEN4U1dGYkpjUmxY?=
 =?utf-8?B?bHVpN0ZKTGgyUTFQNnN0U1NuTWw2MlFVVDdqc0hnQXp1M0o5KzFmVkhZZlNZ?=
 =?utf-8?B?d2hYRmx1SzVOT0FXWVh6ZnhyOWNodzV1QURRd2ZpdXA1NG5JNUZ4eDN4cW4y?=
 =?utf-8?B?aE9vdys0OENiYlgvc01FOFM0c3BVODNCVDJ5MFVhYVExenhYeVpRYlp3Rno3?=
 =?utf-8?B?RVVWdVNlK0VHMVZpdzdBZWMvQzhNcGtsallVc1I4c1VvVllSblE1WFE1ZitQ?=
 =?utf-8?B?ZDhBM0IwNXI1dHZaOEVCRnM5cjFxQlRralZ5SHVuYmpFUGdYcW9XQXMvTVd5?=
 =?utf-8?B?WGNIa3JySk5UVWVMUXRPWlRxNU04NEVJZThRRHVaZzNZY0dtNVhnNytOTlpq?=
 =?utf-8?B?aU12S2cxdHBLVk4wUzh0ZDlQMTdzRUpoaFJPRHBVZi83cGRFdFQyZnpYeC9C?=
 =?utf-8?B?b3FncmpXc29rb1JyOVNNcXlXZTlDWXk1QStyZzdiY0M0K0tFSTQwa0t6VVBo?=
 =?utf-8?B?RHAydFJhKzdIYW1uWHBtQ1c0NGwvYnQyenZUU0VlV25UWURlekh1U29BZko5?=
 =?utf-8?B?WjRMay9YTDFTWUhDODNhZ0F1V0pId2lsWU05WWViOVdmR3ZPV1UxZ0FOT0l0?=
 =?utf-8?B?dWVRZndXN3l6dGh1R1d1V1NhWnhvdCtYU2xGK05IaEV4REJqaVRCUGtXQTFy?=
 =?utf-8?B?Y2RTZlV4K2phanN5RVdhSDZPd3grSzhDaHg0cWRtc3h3VlBwUkFJQUkzS2hC?=
 =?utf-8?B?cjFxMHZwZHlQZ1B3bGtRWDAyWU85RjM4ODAxNnI1cjZIS3VDYURtOGE5TWRB?=
 =?utf-8?B?dndoL0ljQXRDTHNLTXljRFFTYlpGZzBRbVZJOW9yai9aNGpBcFg5MTJhUkwx?=
 =?utf-8?B?YTZiQlRyL3pBVktDNUpQbFVESEswdUUrZVV3dW1HaFpIc2pqVjRMMis4KzA3?=
 =?utf-8?B?TmdveGRaVk1aaEtScHVyZHh5cGxKbFRiYmtEbFVDOHJpQ20vN2lyWGY3dVFC?=
 =?utf-8?B?VHR2OGRHSEJrc2ptbVYzNFRFNlNMQUJkclE0bzhHVkc5b0NabzJXY0JmdThQ?=
 =?utf-8?B?aG1uckp0Wi8wL2hpZk9aMEE3aEFHM2JaNmVzTjNqeEI0dUJ4WHdKd0NCZXIx?=
 =?utf-8?B?WnNuT3JiRU9MRjRmWnhMRm0xUTFobTB1cVBYWU9zSVNSSHJiWUcrcGpGcmVm?=
 =?utf-8?B?SC9WRGdLSk9VM3NFRVZnUnVYbHdMV0xnd0c3TlN0ZmwxODA5cUcxQVh3WlRJ?=
 =?utf-8?B?ZHdMdzVTQ2xoNFZsSWJ0MjQwbTdIa0Z0Z3dNSmZvakorYy9uT2JMUUhjOVRN?=
 =?utf-8?B?LzFvWU9ZS3JYenVkQ0ZJOW5KZm9Ec0FKcFpqRGE4T2RYczFJNFk0ZGgrcGRW?=
 =?utf-8?B?NnhCN0dMRGNSV2dvWDRRQVpBUGtXdFVVNnZrN1BEVkN4UHM0NmFtZEFFS05w?=
 =?utf-8?B?Wnp2Z2hreXJUZUJ6dXdnZlRxSGVVMExDRXpTVTBZRU9aN0tGbUtYV1phWGIy?=
 =?utf-8?B?WnI4aDRMb1d3cEhNbWpQelB0ZlIrLy9zTTQ5R05MVjNaWURsbHBhcnUzS3Bw?=
 =?utf-8?B?OGpBUnhrWFF0TmFVS2NHVnY2U1Qvam1rSE45bjdnUUJneWk1UUVueHNoRE1j?=
 =?utf-8?B?U29PcHdjVkhUMzBJZzgyYzEwL0RkcmlmUHRqajh6SzZKakhFMUNidkcwanFm?=
 =?utf-8?B?R1c1b2tmYUtQKzl5d0FBWCs0ajRpaEROczJ4NFl4cWFycEhHeExPcGF5dGww?=
 =?utf-8?B?cGhzN1ZpM1ZZenFrNnd3aUJTUkZLdmlkOVc1bEdGQWo0NXNrQnIrTkd6RzJN?=
 =?utf-8?B?OTdkYnorTjZhQWY1UitjSDRINVZndXBpVGJPVVZ2aFArOGRZeHQzWTlabUlM?=
 =?utf-8?B?NkE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3416e8-aa8c-4082-56ff-08da705d3192
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 05:51:19.4477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXcW0X+SK5lLl3cO/dNXnAth4MVOcLb3ulPuBSVcmEAqW2KYd6riBRwXAWjuy/7V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR15MB5416
X-Proofpoint-GUID: ONtMkau17rQRlTdK9wEXuge4rfH6Lj4K
X-Proofpoint-ORIG-GUID: ONtMkau17rQRlTdK9wEXuge4rfH6Lj4K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-27_01,2022-06-22_01
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
> Add a selftest that tests the whole workflow for collecting,
> aggregating (flushing), and displaying cgroup hierarchical stats.
> 
> TL;DR:
> - Userspace program creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it.
> - Whenever reclaim happens, vmscan_start and vmscan_end update
>    per-cgroup percpu readings, and tell rstat which (cgroup, cpu) pairs
>    have updates.
> - When userspace tries to read the stats, vmscan_dump calls rstat to flush
>    the stats, and outputs the stats in text format to userspace (similar
>    to cgroupfs stats).
> - rstat calls vmscan_flush once for every (cgroup, cpu) pair that has
>    updates, vmscan_flush aggregates cpu readings and propagates updates
>    to parents.
> - Userspace program makes sure the stats are aggregated and read
>    correctly.
> 
> Detailed explanation:
> - The test loads tracing bpf programs, vmscan_start and vmscan_end, to
>    measure the latency of cgroup reclaim. Per-cgroup readings are stored in
>    percpu maps for efficiency. When a cgroup reading is updated on a cpu,
>    cgroup_rstat_updated(cgroup, cpu) is called to add the cgroup to the
>    rstat updated tree on that cpu.
> 
> - A cgroup_iter program, vmscan_dump, is loaded and pinned to a file, for
>    each cgroup. Reading this file invokes the program, which calls
>    cgroup_rstat_flush(cgroup) to ask rstat to propagate the updates for all
>    cpus and cgroups that have updates in this cgroup's subtree. Afterwards,
>    the stats are exposed to the user. vmscan_dump returns 1 to terminate
>    iteration early, so that we only expose stats for one cgroup per read.
> 
> - An ftrace program, vmscan_flush, is also loaded and attached to
>    bpf_rstat_flush. When rstat flushing is ongoing, vmscan_flush is invoked
>    once for each (cgroup, cpu) pair that has updates. cgroups are popped
>    from the rstat tree in a bottom-up fashion, so calls will always be
>    made for cgroups that have updates before their parents. The program
>    aggregates percpu readings to a total per-cgroup reading, and also
>    propagates them to the parent cgroup. After rstat flushing is over, all
>    cgroups will have correct updated hierarchical readings (including all
>    cpus and all their descendants).
> 
> - Finally, the test creates a cgroup hierarchy and induces memcg reclaim
>    in parts of it, and makes sure that the stats collection, aggregation,
>    and reading workflow works as expected.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Let us tag the subject with "selftests/bpf: Add a selftest ..." instead
of "bpf: add a selftest ..."
