Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7EC429D50
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 07:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhJLFqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 01:46:53 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:61222 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhJLFqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 01:46:52 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C5ffVi006188;
        Tue, 12 Oct 2021 05:44:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=OMs8bo9p0zA1QX7WpyX/I+hgX507vOvSmg9es2nex4M=;
 b=jLvFeqBBd8i2WYWxe2MkB7jQXRpsyP8rT90DqKXZGOcIVsqv0KeXYPB2MJtnplcXpsdV
 VSYBXceI0vfhEHh1787xte675/TDHKylB1U9ogS87efpS++Syd0K/mk4H45YB8kQmCwA
 Q+JQuwWgQWgLy4dAzBLFLMqrVsWgv9+tEc68+cgTzuJ6G/ovozkNX6seoOky/b9zJwRs
 66mP3kSQP3FVs9ZqsgJAENVwdZss/YEl8P7FfBPhbU2dKkKhdFdk8YzIhPK2i6W+qaHV
 mu04IMxkTDE4TS/tWvJtMrFIUMXLmYT/yQMmJshmN/uJhkQda7Q+fGHLLx/RpEKn83XD BQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bmpp7rjjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 05:44:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3UfxqgKJyAGkTJEDaIor/jwqiqTk+mvp0A6Xa7l5XwiqlapfZGdsN5FMe57j4R0uDnAqDIxue4IOoBu/CWOPZJJ7f6Q6Gg/L8Hy+MnzjMM6i0VqpGIGflg0VzqOhQTn75Q/fYyjZDOQo9FwQgwNnyNW+iVoq7KsoBOtT4RiFiM+aGmF1xOCkJUhMI+XyjL+gNDuaYKt27hPFhCDfhm5BxMLYIY8r9JagdWqD2Q4j4Y3z2EN5KNGDrruN3yzwF3FmNaEBINP5DH17LyoXupf8E/ZoTJjnEmIWqqTxE2WgMPv5hLVpFvdDHjwpnwGHmcHeMEfKsgf3n1yslHmZLrJyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMs8bo9p0zA1QX7WpyX/I+hgX507vOvSmg9es2nex4M=;
 b=cX+ttbi9JKrtpvaNcHLIEHm7wwWgfU/b4rYat226DdEQqBo1iHUpTK1sBB2XOnr3zl4U/T3QtJ8dqBbqDonRCwb0znSShxz1aq8MBfObYn7Y+XCgloGCQr8Anqiquqdzj1ep2I2BUU7Gor9z1/oM5bwXvq2Iu8kEcxffjw5l2/dq8mza0Il/hLC3I+tOcOYW9LVvpweFUaEuVD+fcAL2djQG/+SF87fypucNnqmuLdKRCRZG3zAhe84pbTKjVx/11iocpCQadfoFBKs+I1dF/zIG7xcrl7cru+9WFAUoVs2XoXrrCuMuQWpgHYAtro2DLfscIAR3BgZsrY78wVE3Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5128.namprd11.prod.outlook.com (2603:10b6:510:39::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 05:44:22 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 05:44:22 +0000
Subject: Re: [RESEND][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Roman Gushchin <guro@fb.com>
References: <20211008004600.1717681-1-quanyang.wang@windriver.com>
 <c4d12954-aa78-625e-3be7-06d4fc906bf7@iogearbox.net>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <6c15c2d5-39c2-5c86-b9ab-d64089e8d654@windriver.com>
Date:   Tue, 12 Oct 2021 13:44:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <c4d12954-aa78-625e-3be7-06d4fc906bf7@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK0PR01CA0062.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::26) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK0PR01CA0062.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 05:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2f9af19-586f-4300-a300-08d98d43573b
X-MS-TrafficTypeDiagnostic: PH0PR11MB5128:
X-Microsoft-Antispam-PRVS: <PH0PR11MB512893FC0FC186675593D6D0F0B69@PH0PR11MB5128.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64lQKLGF44F6ICzlPooGEmRuadmq3I2S8k/HmR0r7bmHnVrNqhUO+zRqfC84vVPQtAv4T9cns7oP2cCVhuKJ2iyP+INenpSgUkSlZvPNdFbi+ZodRW93sBFkzxI0NPTCNtF5w1WOtxnheelmC9AjS57JUtSyWLQLKPqiSGYvs19kZM42L+CqvDzcHcnNTTK4NerkQPG0uIc0WE1kAp1vfIewRGMp+BNJM5pRb0NMQs2g5dlJ2DWNm54e5jmXTe8I0t/mwZygnnuI73zm5r/2TjsF9Dp7C0OmgKY25MzlThPkRLmEUPrgPqkuMEhFoDthIzooPLe5FoczJ9QL2qWemLjcP1tKFI+/npTp1Oy5reL9VVxYXcCxhgxb45Ofz58Jqk7kKAouTzu+X2FGn1r0MWnOSGgKHe+P9kdjj5jExHxXIdOs7ur1Gc52Bm5AZaM/15ZhfsSSvL+CESqeB2F3XsUB2g06+e6cGvNh39tznX+lLewCroy2at0o2J/A0PsBfFx4IdNLqqyyYN5r0Rji/IOb29UKpOLDoLlVMGj4yS4CQNQD7LMfm3lraEilwb9X7b0f+9iFGMG3QDuGzz8M6tDuSXi4wauMIXj1ZGRLLdAqIVdGyeOJhHqmw19KiF8tILtiTLSifkTUH1jlltAHSPI7xlC9zfpM81EjdFIBI8xKeEl9rSb/tRojED7PszvOkX/kajQdTS7x0I9TtIK3fhkWzFSB1fUf2mEZ/527mAu/fsTUmcsfEXCT9fE+KsH3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(86362001)(52116002)(44832011)(53546011)(38350700002)(38100700002)(66476007)(6666004)(66946007)(2616005)(66556008)(956004)(6486002)(31696002)(26005)(8936002)(16576012)(8676002)(508600001)(36756003)(2906002)(186003)(316002)(4326008)(5660300002)(7416002)(110136005)(6706004)(31686004)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW56SzlSTk5lZGZFeUpYeUxTMGZmUDdyeUNKdG1rRjNlS09OTGRkQ0pjN3Q3?=
 =?utf-8?B?d3VQRE9FdTMxbDVmOXZ2a29IZEp6Y0I2SnQrVUFkZEhxY05VbFhIK3RpbkJP?=
 =?utf-8?B?Sndjc1dtNFJNeTN0ZVdMd3FDTXdyY1RqcnBBM1gvTDFTcDEzajk4eFI4QTBK?=
 =?utf-8?B?QkY2R0xVSm9MNWh3VitvWld5RXJSWUpZbHZMQU5BOFV4V0lrVCs0TkxYWEZU?=
 =?utf-8?B?Q3BhazJvcEZlb3c4WndKUzBUQ3c0dHNwQ3ZEN2tNTm1mZXluSEZ3M2x1VGtG?=
 =?utf-8?B?aVdqUGZXbTJ2QlI3VWRJc1poblBaYmczSXBkSVNsbGpDWHo1UHlXRmFEZGlR?=
 =?utf-8?B?emZ6SWdEMUUyaDlONXloMjkzVVFoZ1MrN1FyV2hoVk1NQzdrTmo4eDBPV3Vz?=
 =?utf-8?B?MmFuVUt3cnB0dHF3SHR1QnBtOXNxZGJsOVBmSUFKNXAxUmhjVmpUSlRZekZD?=
 =?utf-8?B?MGlPRy90Q1hQdlJrSGJGYTVOdlQ5Tkw1TzJCQ1ppWHFHSkN2NTR5OVRDRUtK?=
 =?utf-8?B?Q0dtRTQ2akZrY3lHSDMxdnBQUmZ0K0lYeWVaQUZ6Y0NkdFZTc0VaVjAyeHdG?=
 =?utf-8?B?UlZjVHRGSTI5ckNQODNmanNrMnExMU5iR3lWTU9YTGN5dk5zanBBWWhWaG8r?=
 =?utf-8?B?d21lbmRIaWQwQlF0SzhxNlhIY00xdVVmbGJ3KzdaMGMvVU9GK0NZejAzbkk4?=
 =?utf-8?B?V1gydS95SW9Ob2tUQU13dnZNRDlYN0ZKRDFKSGtHMnhFSjllbFFjNDlqU3do?=
 =?utf-8?B?OXEzUGlpSitaa0duOExxR0tPdDV5dS9KcWt1SVZoN3NNN1hmNllEd0lMc1Ey?=
 =?utf-8?B?OWZqNHV2blN2czVUUVJNRnN3aVZiZmtYMGNwL0QrTi9vM0E4Tm9sRlBDVTFY?=
 =?utf-8?B?bzR3WCtRM1ExaGM5WDZ6QTFncmREQWFhVlBLSWZRbXVwelh3L0poOGFIZjZ1?=
 =?utf-8?B?ZVRVbVVORFl3WmpJbFEvN29IUDVwVEJXaVZQZmNIaG04MmpJR3dpOVpTRHZO?=
 =?utf-8?B?d2lWa0JmWSthcDRiRVVpc2lMTitwTVphakFvRUFyVC84NWRyQmR2bzQ1QWZP?=
 =?utf-8?B?dWh6d01SYnc2ZUFTNTR4ODFVRy9rMTU0K0V4Q0M2VEtPenlWalJ5VzZCQnhG?=
 =?utf-8?B?OFBWMTd4bWw3QjUvcUVsNzltdVlwNnRDOUZVZGVuMFVUMFVHakxibnBqbkYy?=
 =?utf-8?B?NlBFTi9iajlhY0plQnVHV25jKy9yTlVoK1RPQU1TRDB4TDhIVEMyemo0a3NS?=
 =?utf-8?B?TVFtOTQyZ3hPZS9BckM3YmVOcmxpYzg4WENHL1I3MXZjR1ExK1dlck1zUVI4?=
 =?utf-8?B?MmcxZlhybGV3L2E3TnVaKzV0YXRQVm5mZmtqdEVLQk5vd3RiKzE2Vjc4Nk1x?=
 =?utf-8?B?V3o2a1ZlT2xJdklMTVhWMUFXQWNwanpxVkxnSE9iWitWOUNsV3VBalQ3UEZy?=
 =?utf-8?B?VTFNcWszQlh4SGluVGkzOXQzcThYaDVFZ1NGdzJndTJmVnRJYVJNUlQ0ZEpI?=
 =?utf-8?B?SXBuWGVIY1IrOXJRbm5nakhTbmg3RFFmV3hPQnpBZmMvZnBzWGhhZkZZSkV3?=
 =?utf-8?B?c3prMnp6NWNLNElSZUZxemYrZFE5YUp3NVdzZGhnc0NoeXc0TERxb0N2ZndX?=
 =?utf-8?B?cWRGM2lYa3JQdHFQZElpY24zRjJyMmlQVkFxZnFqUUowai9Dd0FJSzIzNy9s?=
 =?utf-8?B?OWdVU2JTV0pvVlVqMTdoeFFpNEpCS3N4YkFLb3RKT2tzcWk0NFV4MjhaYnpk?=
 =?utf-8?Q?qCRlO45Di+upv2qKAk2eU8I1DH9kApZ7K2jHAZG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f9af19-586f-4300-a300-08d98d43573b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 05:44:21.7279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1osrOyrj+au2q6W1lReTWXgAFSid6/7XAVmUPXyWTEFKbPgQC/NP6YNywL9YgYFE5xIUpLkK/nWuyelmI5onBQ7DAZBe5uHjYLnkckkhyMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5128
X-Proofpoint-ORIG-GUID: 70GiwvFX0lmEfPHxC3rsoClhdGoOZLbt
X-Proofpoint-GUID: 70GiwvFX0lmEfPHxC3rsoClhdGoOZLbt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,
Thank you for your review.

On 10/11/21 9:44 PM, Daniel Borkmann wrote:
> [ +Roman ]
> 
> On 10/8/21 2:46 AM, quanyang.wang@windriver.com wrote:
>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>
>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>> the command as below:
>>
>>      $mount -t cgroup -o none,name=foo cgroup cgroup/
>>      $umount cgroup/
>>
>> unreferenced object 0xc3585c40 (size 64):
>>    comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>    hex dump (first 32 bytes):
>>      01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>      00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>    backtrace:
>>      [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>      [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>      [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>      [<f85b12fd>] vfs_get_tree+0x24/0x108
>>      [<f55aec5c>] path_mount+0x384/0x988
>>      [<e2d5e9cd>] do_mount+0x64/0x9c
>>      [<208c9cfe>] sys_mount+0xfc/0x1f4
>>      [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>      [<a8308cb3>] 0xbeb4daa8
>>
>> This is because that root_cgrp->bpf.refcnt.data is allocated by the
>> function percpu_ref_init in cgroup_bpf_inherit which is called by
>> cgroup_setup_root when mounting, but not freed along with root_cgrp
>> when umounting. Adding cgroup_bpf_offline which calls percpu_ref_kill
>> to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
>>
>> Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of 
>> percpu_ref in fast path")
>> Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
>> ---
>> One of the recipients' email is wrong, so I resend this patch.
>> Sorry for any confusion caused.
>> ---
>>   kernel/cgroup/cgroup.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 570b0c97392a9..183736ad72f2b 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -2187,8 +2187,10 @@ static void cgroup_kill_sb(struct super_block *sb)
>>        * And don't kill the default root.
>>        */
>>       if (list_empty(&root->cgrp.self.children) && root != 
>> &cgrp_dfl_root &&
>> -        !percpu_ref_is_dying(&root->cgrp.self.refcnt))
>> +            !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>> +        cgroup_bpf_offline(&root->cgrp);
>>           percpu_ref_kill(&root->cgrp.self.refcnt);
>> +    }
>>       cgroup_put(&root->cgrp);
> 
> Doesn't cgroup_bpf_offline() internally bump the root cgroup's refcount 
> via cgroup_get()?
> How does this relate to the single cgroup_put() in the above line?
There is cgroup_get/put pair inside cgroup_bpf_offline.
cgroup_get() is at the beginning of cgroup_bpf_offline.
cgroup_put is called at the routine:
cgroup_bpf_offline
->percpu_ref_kill
-->cgroup_bpf_release_fn
--->cgroup_bpf_release (there is a cgroup_put() at the end of it).
So cgroup_bpf_offline can keep the balance of cgroup's refcount.
  Would
> have been nice to
> see the commit msg elaborate more on this.
 >
OK, I will add description about this in the commit msg.

Thanks,
Quanyang
> 
>>       kernfs_kill_sb(sb);
>>   }
>>
> 
