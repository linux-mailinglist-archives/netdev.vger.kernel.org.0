Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12059431416
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJRKJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:09:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:22122 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhJRKJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 06:09:22 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19I9Wqoh029365;
        Mon, 18 Oct 2021 03:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=e6mL/tcgbZqVrGO/gRpWCz2Ek02OFJyMV0YVhGADKC0=;
 b=UmIiBjWXLZ1lM4fT5OemfjBSsyP3wjy3qmyGgW6wSyvZBNbwSxExxo5XtDgTCsrEarkY
 N/iAS7QCA/95NJ/duJwmbf9IDEC2bRUBbCrKT9MwEKhXxM/0yi9VhaPMfsyRugW91Z3W
 VWlGJuR78FWRBONixmnK8BDXvBWfQWCd1rO2NTrvRvn6mB77oZ7Ipya8ly8WYCOBFPqa
 KDHSHaxx4lKo+2b4Eh3lCkRBJxLh2pRqppiDZrsmbV9b4LZQ/vQcvSOvnKjh43dgKu3G
 191OW7JRD5+uQluEGVCrpdiQrBip67db8vAB/BmfBVwUdiflHWo8G4yTnfCeC0i4VojN 1Q== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3brn13ggbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 03:06:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVLOCyaDEfSC469bV0JAAIgbP2VZo1ymM6GTQsJv8KbiZ7U4cZpFPHm04V8Ax7AC3x69gPIF9Rhy46TGeOTQdcYwFqWCd6VVWm19iqBM0JXKVxpsFA0JNl0TCOIn462l0bRTAZaWyVFfppL4jz9v6u9tBOcRlqwkg2vk7DpNoMihkvu3DSrsPvVwVR/ehp6IV67yp2mBW3SmGIi+ZCsZBMAr/HlwpEJNsepBsnbauvAOnu9l490vL/szE5B9d/6TG1aKpNs73QZZNwX1cCoDkKoHZi4j93EOrfhSKA4SmLsuHByf2nRNymRuL9DbGDmAkc6969jJ4dWLCMj7QXM0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6mL/tcgbZqVrGO/gRpWCz2Ek02OFJyMV0YVhGADKC0=;
 b=XJAcgNnXtdWzCylmHIlPSAl5qY81Lfyk+SME5+yrzt81osiHjIMisNeso1FnI5PfetF74MnSiZS0k1ME8cGMcb/DcWvRheGUvczC4LblhnxpCGzh/XRrw1NWicQg5kz5J86LjzLtC9kmn99w2bWfxLF3DletmJgISTX+lgQIckjXTR12FScNGcZ4jIjEhmop6WcN3wh8V7tdyiGZNxZVZB+ykkQxFk6Qfld+ulNRxLxImGFyd5eabamcrraghZS896OB8+5gmP7DyKyefYaPWaCd9nm3Qyt0O+76JimxJAVHuKGHtvYQAUIzjwp5CY2gHhHoSW3C2v5+cD25huERBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB4821.namprd11.prod.outlook.com (2603:10b6:510:34::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Mon, 18 Oct
 2021 10:06:38 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 10:06:38 +0000
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
 <YW04Gqqm3lDisRTc@T590>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
Date:   Mon, 18 Oct 2021 18:06:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YW04Gqqm3lDisRTc@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0401CA0020.apcprd04.prod.outlook.com
 (2603:1096:202:2::30) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR0401CA0020.apcprd04.prod.outlook.com (2603:1096:202:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Mon, 18 Oct 2021 10:06:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88320268-e3f7-4a28-17e9-08d9921ef963
X-MS-TrafficTypeDiagnostic: PH0PR11MB4821:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4821D4EF86DB1A6CF9B12A87F0BC9@PH0PR11MB4821.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rYvjr1Z9dNDr51VPzG+h8rb7Gx2SeQCR2ngFCq84f0BDMxOLgMF0ucyGn8b91it/kWU/+swTycI02C5XXkSioFbRse0b5WwEb7Tl0KK5G86kkGbwgy7jRJddrL9UrCCgWLhXKyJ+jRBx1j0Fte0G1cxwpblWdgQq1euJZBJRwxqghv42m/o/f7wEFJ11yR4tcVHETp3EgTrnoyvkB0QJ8zPmPhM5Srlfo+do5m6V3tt5qMSz6v9s4wRwLGatC/kwU9p5prz2fx4RkhhUqvcrPQjlo5QRHRUJznSGqgY8mrEOMoLspAV9LEio3qXIsrwgopkx2H7YgtDmZWdjC1y2uxbiD+GT4DoYz6fFD2hPy4YL5n+zPzrjovU5zoZyhEBopFjSXQ7jXGytNCBzJV3/EjM+0TZ091NKCJi69ecVNmnvx9srTiCUrh0GKprrBLvl3LnpU25Ls5TazeppCnbwB7pPj6SNf2Bl6vUA7SpaveV8Crthx8qHgJi6PJVN6Cn2Arsm2kQqlErfBlM764XVuAgHlBJkfb2gbq+F5TBQoUf+ARhUNc404n/h/JRKr2QljJi66D7lh9CLGRNI++xMowIuaerzIx2mb7DgKp+sJ16gY0ot+4TZOcZjfPSVHKH5LV+9g6HoOAZ0QyC+a7xJzDzxVFGFllcd0faUu95zfk1sGOqelxcFo8wsGF5GJmxwpDn8jCqGPWU89FuuTUkMVFUFSH7jY9dsdtxowBNL+EhRNZhantc4O8pD4c+vlOdGET0Pc4VrVD/NOaZRj4Jk5PvI8YxRWxVyNouQg2ZnJFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(186003)(66476007)(66946007)(2906002)(31696002)(7416002)(6666004)(508600001)(44832011)(26005)(6486002)(8936002)(16576012)(8676002)(83380400001)(316002)(53546011)(38350700002)(38100700002)(5660300002)(6916009)(4326008)(66556008)(36756003)(6706004)(956004)(52116002)(2616005)(31686004)(86362001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGZ5SndHZTZWa1FPWUt3NEVjb3ZEL0J1T2ErSkNZYk1MUXliYmhHcmt3T0Q5?=
 =?utf-8?B?eWNKNytiei9hV2hIaGVPa3A0eVA5VEM4UWlNUERpdnBqUGV4eFp4ajFMVEUw?=
 =?utf-8?B?N1hIdlVOekpBWXBnT1BCcFFGcW5SN3luNzFyNkJ2ZXFkV09lQVpmNFNURVBL?=
 =?utf-8?B?VVVHaUliWHl2TFFodTdpeVhKdlBoc1YvR3dGV044dlVxWlVkV1NLMHh3My9J?=
 =?utf-8?B?MVJyVEgxbEcycGY2Ukdjc3ZSa2x1bEp4eTE2Sm1TKzdKTlFKRXg4c25ZMThN?=
 =?utf-8?B?N2E1Mmw3VlBVYjBhVXpmNktVUDZZL3NLbHhRWWFFVU96dGdqSEIzM3RjTko2?=
 =?utf-8?B?dUZDVmxLTlVtU2hadFM3cnVpRzhWNEZpMmd4cHgycC8xTGFCM05XeEhKOGhB?=
 =?utf-8?B?b0FYQmdoY1JYNDJ6ek4yV0Y1WS93UzZJdFNvbTlQMnhjOGZEc04xUEptM1Vu?=
 =?utf-8?B?dk9aNitPMzFyNUtaV0xqQm96dWJTWjFzU0lON0lYdjhDOVRqOU9RbDN5V3NQ?=
 =?utf-8?B?Zk5SaTNxa1E2WTlhYVk1d0FIRVVEMHc4ZjMzN2VBbkdZV09VVVpaUmNvU0Yy?=
 =?utf-8?B?dWIwNG5wQ0Yyc1poclJZWjV4ZHhuUXNOYWZUaWVxend3akhYZ3ZXWmtmQXJB?=
 =?utf-8?B?aUdLOHl6ZzY5Y0M0QXRuUkhKR3p2ak56dHRtSzdpMzhxSXFZS0dBdGtLZXhS?=
 =?utf-8?B?clpjeVNxd0NmenE2OWxFNlZuaytoMXVndVpXazZjaGgrOFUzRUlNeUQ0MWJv?=
 =?utf-8?B?SUQ0MGFiS2hnbUZpTURldHhHYnhnalRyRkIvUS9KbW9yV2VwamlOd3lWL25o?=
 =?utf-8?B?eDdKSklsRmtHSTlsWDkzV1U2M01LckJ3YmQydHlaNExaRjhkSFNIK1YvcElX?=
 =?utf-8?B?MjlLazl2cEF6NU5qeTlkU0V2alY4RVFEdW9Hb1FmR29BOUY0aElzcjBtQXRh?=
 =?utf-8?B?WHBkaWNKNGRaRHNIZEFmczRWMWJMRDVROVN6NTI5c29TeG0vSmFoVWR1VHFq?=
 =?utf-8?B?SzRSS0JOS2NQOS9RQy9TMXVPT2lmc21MaHFkdDNuK0lZUDMzQ1J1NytMc2pB?=
 =?utf-8?B?bEFFUjJ1U0dxY2k5Y3g5cXpGSzRGd2xRZWdYVnMxSkFxblBybDFQaStucUli?=
 =?utf-8?B?VS9neTlMZXB6ZW9IVDYzd1FpQTJsdk81citDekMxRW9nU3VsN0prWkR2aDNV?=
 =?utf-8?B?ZFlCYUl5SDlBVW1IL3RrRk1odUR4VHpvdjdYQ0M3bEE2U3VjeGpUYjdGUnkr?=
 =?utf-8?B?WnRXOVJoa1NZM0tvb2xZVXdXQWlmN1hIV2JkSDN1aDRsWnEvUmtHaTRVWll0?=
 =?utf-8?B?a2Y2U0VNK0tvVDliSTR6c1JVMnkrcnNId3hiSDZjZ3NIU0NkUzVvVTBCMEh6?=
 =?utf-8?B?bWI1TEFCemxOSEdjQ3kvL3VYWXVpYVQzKzM0QldXQm1sM01nTUxOQXpUTjh3?=
 =?utf-8?B?dkFSTWR5NUpxTlNCbzR1cWVDcjh0RjRwdFlDZ2ZqTXBONGQ0cks3Vk4yeCtL?=
 =?utf-8?B?cGpoVzB4dUw1eHg0K0Y2cnNzNzI4ak1USGROb3JGRG1WNDZnTU83RUd0eVhn?=
 =?utf-8?B?NTBrVUprQ0ptUzB3Ty90NUV2TFV1MnU0bkVNZ1Z3RFN2cjNLQlErR2VXZDJP?=
 =?utf-8?B?Q0hzc1Q3RWYvbVRRdmFGazN1aEQzMkc0cFRlWHdsaHRiVjlzSVUrMTc5UHpi?=
 =?utf-8?B?dzZMTnZnQ3lRanZLc2V3dkFhNDhGbnd2QldjdlVqUGN3TEdJVENOM0IwejVy?=
 =?utf-8?Q?QZ4ii2sgFTz6ZctC71oGXWo3Thqf87loV1vzSMi?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88320268-e3f7-4a28-17e9-08d9921ef963
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 10:06:38.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3WrhpzfxCb+CqOiPT+Rd5idUnCTPMfaWDofLy0LlAg7f7SWJj+pgMBBZURldqbfeNexEjgATC52OM6uoGEg78DqRV4UMuGAD3eKOwJKhTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4821
X-Proofpoint-ORIG-GUID: jfT_8gHnwXYnPhtQX_ppCC8_ymuL--96
X-Proofpoint-GUID: jfT_8gHnwXYnPhtQX_ppCC8_ymuL--96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_03,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ming,

On 10/18/21 5:02 PM, Ming Lei wrote:
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
> 
> If I understand correctly, cgroup_bpf_release() won't be called without
> your patch. So anything allocated in cgroup_bpf_inherit() will be
> leaked?
No, for now cgroup_bpf_release is called to release bpf.refcnt.data of 
the cgroup which is not root_cgroup. Only root_cgroup's bpf data is leaked.

For non-root cgroup:
cgroup_mkdir
-> cgroup_create
-->cgroup_bpf_inherit(cgrp_A)
cgroup_rmdir
->cgroup_destroy_locked()
-->cgroup_bpf_offline(cgrp_A)
So for non-root cgroup, there is no memory leak.


For root cgroup:
cgroup_setup_root
->cgroup_bpf_inherit(root_cgrp)
cgroup_kill_sb:
-> (Here should be call cgroup_bpf_offline, or else leak occurs)

Thanks,
Quanyang


> 
> If that is true, 'Fixes: 2b0d3d3e4fcf' looks misleading, cause people has to
> backport your patch if 4bfc0bb2c60e is applied. Meantime, this fix isn't
> needed if 4bfc0bb2c60e isn't merged.
> 
> 
> Thanks,
> Ming
> 
