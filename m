Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F3943763D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 13:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhJVL6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 07:58:49 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:9020 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231308AbhJVL6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 07:58:48 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MBjueW026317;
        Fri, 22 Oct 2021 11:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=wsab649gLJGi//T9euidn7LFas7vqxiCVMXZVelw0Hk=;
 b=Y0pe9BFIgvOEXDVaPg6DF3ET1J6Tv1QRgyfhSyv6TvzZFvzyCg60erPSmc1EdU7H6mj6
 +mcfOUv3iCsAQt52dVx8TKm3iO2S9ye45PE5P+pCvufdgRT2yqzL4EZgHIo5Ic27WmWk
 dnMfxk/0pPgOwVn3T9A5wu6ev85ytjuKCBm/NCwZBKase8FwziUGQ2YtgCY8621Z7vnX
 Ghy22ubYvFxMlYSsmCj0wg+XlqSBg+tL7wWQg6iCSak+Enh9hLZo/nX0o2Xaw5h8psYa
 Y5QnL6ayl8Pf0L0W6sGITFOyff4K8EX6AzXXsmNllGky8xu44hWOyVM8WKb1wZcuCsTo YA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bu0uk99jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 11:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPwwcZPGptPLkYxz+LqIjciU1s0D5U2jqACDTVq4eHjb3YAOoVLWNd6lmebwjYErv4l1cLy33ZfbSoe0izUoN36POcfX6I7WhMEqn//UMdGmyaapc3/o8QmM4ZFnWVjHSNhGH9esWbpTHeS2GfzmJROS+gliNC0l+289VUjum4OtyUoPYmbF5sae3KX95tnLOeJlecvpw6HMbAPIJTyTVX/bRkj+cwkNqT4HT7LVWY36nObAorBL6Qf3KUkVLAK3fz5B+hFq4oUQVF+0ofznbZHU7oZNib7A0dVYjNDIO8lJ7t/ZGD1ZRZnHxAty9DAOUxu5429KRrlDIOtrJWnRPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsab649gLJGi//T9euidn7LFas7vqxiCVMXZVelw0Hk=;
 b=CuV4NMoRvCmayCia7pgNOVWTqZrvjYC04zH18FQn6I3zqH9uwcSS3VyrkTdRpbrQNxWE2NA2rugbR2emKg9uf6yPlwypprVEaXiFLp6W33dxyXgh+3Oa0SWNcgaIWuwEfwuVYU6MXwTJg32rurgsCVuv3XXpFgwRAW0Ny6G1+083zKZ/PatBtuYzEGS1Y4rErg30ZhrRZlVVryV+IEFor0lWPzAXyg+v7/d0cwuaOBdoOfTj2p9ugx/3xNfokqs1ACOXhhIaSL6yloZR5yYYyBqde7o1hQKcspnPRu6zDWZE5NGbZJNyc+pbQyg1oFanYIScKz2X+wJviJ2T1uU9ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5079.namprd11.prod.outlook.com (2603:10b6:510:3d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 11:55:59 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%7]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 11:55:59 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     Roman Gushchin <guro@fb.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <35e9e89f-d92f-06f9-b919-ef956d99d7df@windriver.com>
Date:   Fri, 22 Oct 2021 19:55:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YXIUMJWrXUcrvZf5@carbon.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0211.apcprd02.prod.outlook.com
 (2603:1096:201:20::23) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR02CA0211.apcprd02.prod.outlook.com (2603:1096:201:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 11:55:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b27e513-685e-44f4-8ea8-08d99552ea02
X-MS-TrafficTypeDiagnostic: PH0PR11MB5079:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5079827D4709540AE3891BC8F0809@PH0PR11MB5079.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfYZUHy5lMlj2TNC/zvjsCeH2F8u/UeSBK9ioEd8cV03cv/8l5FYIK0nIsy+5cchLBLpIteLwhDfH7Mav49bR3YskkmQx3Frcw6q9XqTAaJbuEa7nonRdBV5NQ5b5pB8cIo+cQSIHaSkjOz+a1qmsL1ihvOOx6wqn0X76sLa3kAVk6aXVQR7RWtv+l9GaXNtxJhyhL2krnFCpGVP7RHtm7xaGfSTu/tujR7hjxf32J0Noawf/MlcwDuUPSdcsfQkU0bVSnFH8H4HPcdZXL9UhlUNIZsSC4ySrfZS04mT/WPBQvPdiQCe6UvnKzWRjk+GxESvB5w3BswnJQ6sbJquhsGpuyJikroEjP+kdnePxLOATlR8JctoCfpPUjPhIolV7TlYUap9NSR3fxZtJfuGJ30Sw1rQrkQdzo5b0VG3P3Zq2FxJuBBKlXsfSYjjSkSp/boui0dDNYEu/ZTMKq84SYJoUJIcRKA8MtukysS7VE3qCQQfdZaDASVX7IPvsYPXxc7Yjwt9xB0710HzKnpbHr6SEMBSPUtRycRLA30/ZMcvlyC6Q8Nee4uDsGUKIlpzjY6LLslMescm5+VPErUURE/+OOi8tkfbscB0REbWx6o2FJ4tk+B+y/WFQuhuqpXp5GC+wJ3as3r110ePuIX8Q0OThyMCzxCILVGfYF7oBAtI0zXxFMpLur2N6WBoVZyBxnsX1+lgWd7djuR6Qe06JVDLqUTeOEYx3EFP+3KSMUMJ9ORMo5HA5N+9xaA7nKmbD+vVDdMhljE3DAI+NgXirrF+6lohxxkS9BxwkQlFO60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(4326008)(6706004)(508600001)(6486002)(186003)(26005)(8936002)(66946007)(66556008)(54906003)(316002)(8676002)(6916009)(66476007)(7416002)(38100700002)(2906002)(86362001)(5660300002)(16576012)(52116002)(31696002)(44832011)(31686004)(53546011)(2616005)(956004)(36756003)(38350700002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTROU3B1MjJuTmNTK0QySWNvZ0NLSElDSFJtVDlGTWZJOXJTQ25UaGZLSURU?=
 =?utf-8?B?YmlZc3Z1cDB4bW9Ma0FhWk9iejRxaEVDTmhRcWxTc0RnVVB6Z2dibjZlckJQ?=
 =?utf-8?B?U3BEck8waXp1MlBXc2QrZkFsZWdWNXdONWJiU3RPTlpuN2ZnWmJJSGl1cWp3?=
 =?utf-8?B?N1RQeGpBQ1ZLTVJER1E5SHEzQmhTenNtUUhrYlV0b1hGVFBiUzlNdUhMSzJ4?=
 =?utf-8?B?QW4rWDIvaEp6YzNTckJEYWtUQjY0NFNaQ0VGMDcramQvTmZ0RFRBSTN0b2JH?=
 =?utf-8?B?RXFtTkp6Qi9XOXNlL3RwdVpOaFFaYzVaTitBLzhvdW5WeUppYW9lVitpK3pR?=
 =?utf-8?B?aGhFYWVNUEpCZkpna3k5dGJWeTlaQkYrL3BJTHpRbDVPazdmK0NvMmN0UldG?=
 =?utf-8?B?cVpIbUgwVlYrK3AxUGxIMEllMzJtOGN0REVIY3dGVitIUmdSbEtvbVg3Ly9C?=
 =?utf-8?B?YlhDcW40cUYxZ2FLNStZclYxUnVvL2prMnNCTE9McE5XR01iNit1eUdraFQr?=
 =?utf-8?B?RWFOVk1QRjFKaFFwQi85cExBM3F5cTBDWTA3OEp5U08wbkZrSmZWRkdnS2x4?=
 =?utf-8?B?Rm5Id2U4bkJ2N0VUemlqY1pLY0FPUkY3Y1lFWXpyVXljUWhLTHRJOTlzczh2?=
 =?utf-8?B?b2ZpUnN6QVMyNTJhSld1Um1JY2drbnZ5NlZaQk1IS2NZSGhlYW1pRkxkaGov?=
 =?utf-8?B?cDNRQ2EzYlJMbThHMm02QURPUkRZS3hBMjl0NmgyeENSL3AvRFVIdytCOXd2?=
 =?utf-8?B?Ymlad1p4YU1qZlBITG1WU2swUys1Ykt4TFRPNkhUeUxTQWQ3bVhWejJDaVNn?=
 =?utf-8?B?NzVtRVd4U3BPWEhzemJZV1BIaGhMMUNLdGdseEwzcEY2R3JHTlF6Y0kwUlFR?=
 =?utf-8?B?SmF6ZWRpVC9HdmMxNzZVMjJFYW9vd0Y2Q3pQaVRGaCtKMUxQM1ZvWjMyVGV4?=
 =?utf-8?B?QWMxZEVyK0VhRjR3OWZOVG9sZ0FGM2xLckxicFgzTXdmR29KY3ZwSU8wcHN2?=
 =?utf-8?B?SjIrbU5qRTR3YkczKzFub0hJZGxnQkhWSlhuY01sTWNKZXhFMjVnWjJiNVh4?=
 =?utf-8?B?WDJQL09lYkJDenRKMmlzVjBTM1JuSkZUb2p5RTg5SlBCd3Njb25sTjhtTW01?=
 =?utf-8?B?c01CVXk5NGczbXJjSnVScmd3aTBNRFFWcFhqTWpwUUNPaUthY0RCcUxCZUM5?=
 =?utf-8?B?bFhuRldwN2tJa3BGNUVuWHlERFE0SzUxZ2ZZMmpmaFJRaEZCRkpiNC96QU91?=
 =?utf-8?B?R3FsSEUyald6aHdGa2JFeFVTRjlXTHJzcXVoQmVJd21GTGdCWTdTdGNJTzF1?=
 =?utf-8?B?dUtoODJBMUhBcitiamd4dmkza2VjVDlQbm0zcG52Q2I3TzFjeHRLQktpOWZW?=
 =?utf-8?B?aHB1cVh3L1kxQUdyNWxrV3h2RmJKaVpMMEQ2em9XejhDYXl2UlVXdUZjZk1J?=
 =?utf-8?B?QzZnNno0U1lzZTEwNm0rQ0FiVDE5NHBCcU00bmpSQ21XRVNnNEFOeno3NzVP?=
 =?utf-8?B?Y3YwWlpJWWhYN05KZDR0c2oyUmloU2ZrVFVlNDAwYUw5WGVNQUYwM1ZBZkti?=
 =?utf-8?B?cEtLSVY5OEJzRndha2ZOalp4eG4xNjdZeVAzeUFueVZ6T3Y0V0VrU21rSmRD?=
 =?utf-8?B?dU5KSzI4SGxURmRzeWhhT20ycGRYQ3pXUDJva1c4M3hzanhLRHhKMmVleWNY?=
 =?utf-8?B?aHptUjIrTnVFTENFenpyN3dXNlp6Q3NUckRNTk9BRGJZQThhcVVHY3dJbXVF?=
 =?utf-8?B?dENpTC9qbU9YcEw5M0gwemtmaGxJMjZyc25vS3NXQ1NDM0I1dGFOcVV5cTN6?=
 =?utf-8?B?TENxNWZKdk9vcWpQL24vU1AyR3I4Tm1QZEY0R0FiTTRPU3JHVndhTU1lQlQ3?=
 =?utf-8?B?VlpwWGo3SlM2Y2FsQzNTVjMxNitMY1k1TTlDdmttOVpoQTV2d3c5L1BTQms2?=
 =?utf-8?Q?E/XuHbtfQPVrYxwGakjsgu4yufL+hYqB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b27e513-685e-44f4-8ea8-08d99552ea02
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 11:55:59.6683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quanyang.wang@windriver.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5079
X-Proofpoint-ORIG-GUID: tcCL2iwepCNZnbn30kZrOukyDroWkb3H
X-Proofpoint-GUID: tcCL2iwepCNZnbn30kZrOukyDroWkb3H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roman,

On 10/22/21 9:30 AM, Roman Gushchin wrote:
> On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>
>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>> the command as below:
>>
>>      $mount -t cgroup -o none,name=foo cgroup cgroup/
>>      $umount cgroup/
>>
>> unreferenced object 0xc3585c40 (size 64):
>>    comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>    hex dump (first 32 bytes):
>>      01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>      00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>    backtrace:
>>      [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>      [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>      [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>      [<f85b12fd>] vfs_get_tree+0x24/0x108
>>      [<f55aec5c>] path_mount+0x384/0x988
>>      [<e2d5e9cd>] do_mount+0x64/0x9c
>>      [<208c9cfe>] sys_mount+0xfc/0x1f4
>>      [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>      [<a8308cb3>] 0xbeb4daa8
>>
>> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
>> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
>> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
>> is called by cgroup_setup_root when mounting, but not freed along with
>> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
>> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
>> umount path.
>>
>> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
>> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
>> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
>> in cgroup_setup_root.
>>
>> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
>> cgroup_put is at the end of cgroup_bpf_release which is called by
>> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
>> cgroup's refcount.
>>
>> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
>> Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
>> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
>> ---
>> V1 ---> V2:
>> 1. As per Daniel's suggestion, add description to commit msg about the
>> balance of cgroup's refcount in cgroup_bpf_offline.
>> 2. As per Michal's suggestion, add tag "Fixes: 4bfc0bb2c60e" and add
>> description about it.
>> 3. Fix indentation on the percpu_ref_is_dying line.
> 
> Acked-by: Roman Gushchin <guro@fb.com>
> 
> The fix looks correct, two fixes tag are fine too, if only it won't
> confuse scripts picking up patches for stable backports.
> 
> In fact, it's a very cold path, which is arguably never hit in the real
> life. On cgroup v2 it's not an issue. I'm not sure we need a stable
> backport at all, only if it creates a noise for some automation tests.
> 
> Quanyang, out of curiosity, how did you find it?
I ran ltp testsuite to find this.

./runltp -f controllers -s cgroup

Thanks,
Quanyang
> 
> Anyway, thanks for catching and fixing it!
> 
> Roman
> 
