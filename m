Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684BF4333C1
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhJSKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:44:30 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:25858 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235178AbhJSKo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:44:29 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J962Nj024191;
        Tue, 19 Oct 2021 10:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=R9WzwAsfHJdXo2agfuKGPT29kGt1urdRgBEDxIyXQEg=;
 b=hJ1OC15jYdezq5aK/K9oYrIdRaUjQose+7JFuKLgKmuOhuyerZQ9UQK+UsCP3ZgVJ2I7
 HdLaA+m00IzjL2DwsPEeW5pLQ9EYldO3G5GOH7QUJp++6Li1fYNsOQ5hiIjiMDAQoM0g
 zxITxhKRmcB4vHtVPBwdbXeGAmZZNo+pXw8eu8r6EjPaIbRnqn5gCgYz3R3fF9vCQP+S
 cT4jwcRDrJjxazozDXphPMegIZ3+7AG3/WW5NWc+mwkbXVaKSKADr+eWuPAQKuyP5quz
 dZY/uIuZzeiuDHxiZNdzY09iF3LWWe/m2tYqWH5Sb+8jCDAW/NBKBCncDqDegAwoGfhq lg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bs9apguw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 10:41:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrC2EC3bdE/x6EQbKVOf3IW9EH11j6QTAsTcJ2VNliEwnCks/tuupUceA7jQ3+XGaJlSrkFxZvJzGuj5wvRmLkSBj8gXQug8H48TfyyQGXWzyYADNX/HtUJf0dXf/hZmx6wYagElbbWqLSD8LvHMqZ2OK29hCrdby/+Z/gUKr0/qsusl8OR4oc4nIc3Whd3siwNfcyK/2YK0SWECoM0hDwgVjMg6uyj3GOY+b6rT1hwXNCkR0+CC/DdT/P2/0cFY7ViQe4RUUB6w9RxaFFwhsU/YjzVkrbjRkPmhreq9fpWDTglkXNftmjc7rsqv/naQxSMXmkEDlxmC2qCPTJZs1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9WzwAsfHJdXo2agfuKGPT29kGt1urdRgBEDxIyXQEg=;
 b=HPIcC6VQZAA8kKRxjT0ysyN3+YPtAAr0TmYAJHvRrrhaVnKm/o9EpJE+s+lj3xGjknPHvvsWqKsMkTxpj/H908NADGYWQ0Tv3rsrCdukCtDf7colZN5ZcTph7dwXA9bmCixSNEUQMsNn1i9/xOtKRK+aRHMbOSstqC8PfKE9CP0IqRDSCSLRYaVVhDdpTWZ+44QvCPElxsRNI47TQ+JjXADQgydXCNcml2tOyJFCR9b3+xoQ83HEkUwyYX0G6swrAHlL4DbWgZWRrHPIccSbU0HLXYlZ1hryDz7ctib9lDHAkkqiUnDzxTE9ddIgsRiqb9Qz0ug7nU13ljPFvCZatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5111.namprd11.prod.outlook.com (2603:10b6:510:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 10:41:26 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 10:41:25 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
Date:   Tue, 19 Oct 2021 18:41:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YW1vuXh4C4tX9ZHP@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0048.apcprd03.prod.outlook.com
 (2603:1096:202:17::18) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR03CA0048.apcprd03.prod.outlook.com (2603:1096:202:17::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 10:41:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13fb41c4-338d-4df8-e3a0-08d992ecfff1
X-MS-TrafficTypeDiagnostic: PH0PR11MB5111:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5111AA92EEB881C62E7FE867F0BD9@PH0PR11MB5111.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyWTuo08b3BUlHUTHxO7Idu/8OC2qkG+rTeEBpOI+4y3svqjs7ZHVOt/RJbG0rfsHeDqWGXfjJrgOdSEIXDom6ZFOrB4tJKqzMJ7GLyP7WIEK4peVzfp5qlLnVZaHuBfauokiKyWOPgljDAdnZAqc1csQDco1ZsLDqNwYcmRMrInRx3hKcPWgb5UMTfHf4MqcwHKfL4jITYKNOYtSaHEsUfMreY8yFRpDi0fAK5MjN1J7wYgJsaCmZYtQt9XIOnee4zWSxdoEUyeuf4G2pokNvAXCJyn84bqfE1eZEaZLlRM0e+OyjnVNbLxdMWd6hiTJuKX3RD+2laeoAh9Bdbu+RWV30sM+3QJeCcTGF8v9fzf3Q5N+R7Dl+InqiFTzFVcahbx2rNxIPjVTrlU3ud+9QC7Jz57Gf/CUqyX01wtHTfC5aN8yVNAc5q/nxNWvu1jLKt7HZv9fZ/X1vIYxAO3NHrC2UvCLSAaaeQpVElKIKKN51zPTxzmZffFY1TWlF/rsXgocCeyeSC3egz6085LbuU4w5JAaJoVRl18JGCGQif3OII+GbOSc69xPvjLOCZLMtuTmq9qM2VxtoKin16W+9jbq59vL00TJxv9T3m0H/qTghjuWbFesctFn7NZ6oHRkfLa/9b/lOrDoPjuZgePMa8EesgnkK6x3VnRhupjN6Fp3soQoUSVB1CBER0o2Up0b0lcTbH3AOyn36W4FIliHGuFFONiPAc96t3Eo+IGx3QycyNz8a+hdcBwyLt9ZpyyUOrnGNUBazDRcF+AjRcE8q3fVfzDIuvWxXNnEb1sQC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(7416002)(2906002)(4326008)(6916009)(26005)(6706004)(508600001)(31696002)(6666004)(956004)(66946007)(5660300002)(31686004)(36756003)(316002)(44832011)(54906003)(6486002)(66556008)(2616005)(16576012)(52116002)(8676002)(66476007)(38100700002)(186003)(38350700002)(53546011)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S25jVzhRc3VzbEtoOThpc0FWQTRMLzhQNG1adVh3Rk5JZ3hRaWNrdlFCNUsw?=
 =?utf-8?B?dThGd2J2S2lpc0ZPeUk4NGFlenUzUzNWZkErQUVwR3dldU15TW9DWkJ2QVZZ?=
 =?utf-8?B?UmZqdi92YmFtdkVrZjdRQVJXU2FKanVKbTZBWEI2eG5JL3BYaEFiZ3VSYnB1?=
 =?utf-8?B?eVRBZkwxTlczUHdNVjJwVXdJalcxU3Z1T2REcEJ0S2laZ3lqUVNKOGE5U1g3?=
 =?utf-8?B?clZCaTlOdHB0azVDSHc0cC9yelNQMWIzZFJjYnhXbGxPM2NsU203eFpVeXJu?=
 =?utf-8?B?TkFuMkR4eklrajlQYWt6QUF0Y1BHd3BUeFFuZVM4UHEvN1lWcTFMT3Zub0RV?=
 =?utf-8?B?czU5YnBvZU00ZGdlejNNSnZDdFZabFEyQThxZ2gzNXVyVDRRUzh1eU1SWXkr?=
 =?utf-8?B?RU5hOFFBazNSSUw5TGVyczNURVdrcE9od2FFTzI4eHRtMkJqbm5qL3A0TXYw?=
 =?utf-8?B?dUgxMk1iUGplUWJ1ZkFleWtUTWNBaUxpNTd0Zk5lWFlTeUJRZWFleHdJY3NB?=
 =?utf-8?B?cXdqL0ZVWWVoL25palVjR2R5TmxzNnlSanQyQzBneTFUL3JCbm9OdExRVnRp?=
 =?utf-8?B?MjRkdUtGTVliOWdlYlJiOGpncWZqOHFrWWowZXlDQXowZmYrQ3RGNFVITlI0?=
 =?utf-8?B?OHloR2xUYTJGdzZlN0pPTGYwUFVQVjhSemdML2cvT2ZoREJNczV4RzJOdWNa?=
 =?utf-8?B?MldMTlNOaGVmT3A2RXpxaE9vSkR5UzZKN3FpOXd0b3VPM2pQNEdtaVZNVmtQ?=
 =?utf-8?B?MjNRNUJZelVjaWxpb2ZSZGZpcWxtMzlvdkRTQlVjMGV3OENyV2YzTUpZY0h0?=
 =?utf-8?B?UzBSZWlndnN5ZXVzNk9TWlhNdUxzWGZDOG9RbUFaSnE2Rys0cWxoakxJK1RJ?=
 =?utf-8?B?dUU3V1U5eEF0WjRNUitDb1M2cGJZbVJ2SndBakt5RWI2d2xRWjY0SWlNUmtJ?=
 =?utf-8?B?MklPeG8zY3oya1dxdEUvbVh0UHRqVyttM3hMZ3ZXa2dGTzR6Nm84REpkNzdY?=
 =?utf-8?B?V0ZGQ3k1TVlhemIxZ3JmeFN6ajNXdjJwQ1kyMXl4M2pPVVJqR3VlRGx5SFRJ?=
 =?utf-8?B?RlJ5UEpXTEtKTU0wcHFWcklIbXFtdzFZYmVrVWEyZFN1bTBLMENqZlFiamZt?=
 =?utf-8?B?bHIxNkhZTzRiUzVPcVB5UXUvMXl6Z3NQWmZERUY5eWJEU0lIYmlTSzlFSGFC?=
 =?utf-8?B?bDVtMlcvOUZKb0M5YjRWSjBTZW1BVm9GaGRrMWl2Uzdic3RHMXRJYzN4N2VF?=
 =?utf-8?B?MVFKKzRmcVF0QlN5YmVKdlord2h1Sk1PMy9lcXZCVDV3UHJQcHNYOWlKYkwy?=
 =?utf-8?B?VGFCam50em40cEMwSjEzc3k1dmFsRUdITE1rUTd1RjRNN3hNSWszanlUUzl0?=
 =?utf-8?B?aGYzWHFVejNmWHhIRHlrb0VHK3lSTlNWL0htMnRENU1yc1JQSVRCd1FHR05K?=
 =?utf-8?B?NExGaWhlQTB6blhWQmwrZnVpbGhxS2E1SkxnU0h0bk5KSnUwR3BzRlFxeWh2?=
 =?utf-8?B?Vkh4dFo3L05NQ1ZqOGNQL1RVOEwxOUZaUGJLRGdGS09SR1V6Q1gxdWloTHVs?=
 =?utf-8?B?TVA4S2llOTlEdzJZemkvdGVOcHRRK1ZVK05rNTZBNk1kWk5PZ2JmTUxXb1g2?=
 =?utf-8?B?UHBsTE1CQVk1OGdOb1dVeHQ2Zlh3elhMdjBsWXBURE5vYXAxekNOcnBEenRh?=
 =?utf-8?B?aEppSXFKbXhFL2JpckJjbzYzRGxPc1FtV2J4eVJpREtnZkpIMFpGNDlyK1Fq?=
 =?utf-8?Q?KWyCZkIEFysNbDpJ9dYNPzQuWq1Xh5oXjcW2LP9?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13fb41c4-338d-4df8-e3a0-08d992ecfff1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:41:25.6652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oi9GFEUBEO7EsNaJhA4DuId3ChCQ7iE9tQk+GUt4Hmv0sOF1SP7Wg5fTDZTIu3QuKJSc3aN5CJBDFRklpl9oaRAZmnVHp8U4OucPTZ/ygMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-Proofpoint-GUID: U11iwTWZkC-0Uzs8jXtPZII7heDasCPk
X-Proofpoint-ORIG-GUID: U11iwTWZkC-0Uzs8jXtPZII7heDasCPk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_10,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=992 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ming,

On 10/18/21 8:59 PM, Ming Lei wrote:
> On Mon, Oct 18, 2021 at 06:06:28PM +0800, Quanyang Wang wrote:
>> Hi Ming,
>>
>> On 10/18/21 5:02 PM, Ming Lei wrote:
>>> On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
>>>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>>>
>>>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>>>> the command as below:
>>>>
>>>>       $mount -t cgroup -o none,name=foo cgroup cgroup/
>>>>       $umount cgroup/
>>>>
>>>> unreferenced object 0xc3585c40 (size 64):
>>>>     comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>>>     hex dump (first 32 bytes):
>>>>       01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>>>       00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>>>     backtrace:
>>>>       [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>>>       [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>>>       [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>>>       [<f85b12fd>] vfs_get_tree+0x24/0x108
>>>>       [<f55aec5c>] path_mount+0x384/0x988
>>>>       [<e2d5e9cd>] do_mount+0x64/0x9c
>>>>       [<208c9cfe>] sys_mount+0xfc/0x1f4
>>>>       [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>>>       [<a8308cb3>] 0xbeb4daa8
>>>>
>>>> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
>>>> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
>>>> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
>>>> is called by cgroup_setup_root when mounting, but not freed along with
>>>> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
>>>> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
>>>> umount path.
>>>>
>>>> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
>>>> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
>>>> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
>>>> in cgroup_setup_root.
>>>>
>>>> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
>>>> cgroup_put is at the end of cgroup_bpf_release which is called by
>>>> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
>>>> cgroup's refcount.
>>>>
>>>> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
>>>
>>> If I understand correctly, cgroup_bpf_release() won't be called without
>>> your patch. So anything allocated in cgroup_bpf_inherit() will be
>>> leaked?
>> No, for now cgroup_bpf_release is called to release bpf.refcnt.data of the
>> cgroup which is not root_cgroup. Only root_cgroup's bpf data is leaked.
> 
> You mean that cgroup_bpf_inherit() allocates nothing for root_cgroup?
Yes, cgroup_bpf_inherit allocates something for root_cgroup.

The earlier commit 4bfc0bb2c60e ("bpf: decouple the lifetime of 
cgroup_bpf from cgroup itself") introduces an imbalance that call 
cgroup_bpf_inherit(&root_cgroup) but not call 
cgroup_bpf_offline(&root_cgroup). But there was no memory leak here.

When the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of 
percpu_ref in fast path") applies, some data is allocated for 
root_cgroup and not released with root_cgroup, and memory leak is observed.

So I add 2 "Fixes tags" here to indicate that 2 commits introduce two 
different issues.

But it seems that 2 "Fixes tags" is misleading now.
So maybe just fix earlier commit 4bfc0bb2c60e which introduces imbalance?

Thanks,
Quanyang
> 
> If yes, I agree you can add 'Fixes: 2b0d3d3e4fcf', otherwise please
> remove it.
> 
> 
> Thanks,
> Ming
> 
