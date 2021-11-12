Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC9744EBD2
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhKLRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:12:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54236 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230051AbhKLRMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:12:30 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACGvLAn019896;
        Fri, 12 Nov 2021 09:09:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AMt0hbSCH3hnH8klMyha8uwzGwuoaFdDky5pYVVFFHQ=;
 b=MJ/4xDhC6CkzFLISXgMrK00aVh/v4pJVPK5yffeimJYmPv8RVwOj0UpfQCB5TTQIpqqI
 v18g6u1nc0kYnV+z/ajkFTl7RyocBo0sxoxk5hkKvVWrdhSxSxiPyVyxX6CJ9Xy4k2oo
 9dOCRMaj+IFBhPOLthO9z0QolIl309ciFbo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c9jt9vbnw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 12 Nov 2021 09:09:25 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 12 Nov 2021 09:09:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJWwciTyUtF7dbHOU6pXiLyTyZhHsBksYICwQMno8BX+Z3KOmvABYBROTIa1xj12hWX9RFUwwgeOvyaC8xiwqOjKYLliwhqEQBoR0eSQEfHPnj7tpH31shn5unem/VrMxpZiJSx/KVlBHPncklOT5e+Gn6gSMYma9CR7HiKedcHIfdlVnZ84nu2IG1RUVnapoHSl0ACwf3j+SuKaCjFS9xC+Aury8lx8OFvrzL+Fp3AuyrxnfIbCCnUKA6vy/vqB5W/PUQ2NIDG2p/iszOmfHzlIXLmDUgJgV2nPjrnxzwK6E9HwsOUdbEZsK0a9WN9NjTsO/l3rQW1O+7tj2kndmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMt0hbSCH3hnH8klMyha8uwzGwuoaFdDky5pYVVFFHQ=;
 b=LaFaieYC+6ZBDT1VCcpUNmwzNISktr9xczqiQFKGJue3pTzT3Irmlc/KNkRSqmFilMtvRIAgdgf5sOyH5YdQA0qxvKYlR14yFR02Ni7vJai3Qy0EIxnvyWnV2Nlq+9q5i8qJVVxl8gcszjKXZox84qz18ixmjuHFDBgFtTtC7YH+wvK00ZmwhKYehAIt4XHLsmQvMHh1HTW0IK9haubcdhJ6hPuzCNhjzcLq/OHxdz/qEHSo5JPlwwFWxTKfX/2/l9SYCYvS5HQW6Sv2xurDLP7fVRHY8XwiJfbxXWCmRQ6Cf76pzIt6Ozgfx9YapVHRoAFp+Y47P6yedsllMuVDfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2285.namprd15.prod.outlook.com (2603:10b6:805:19::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Fri, 12 Nov
 2021 17:09:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 17:09:18 +0000
Message-ID: <bf49cbe1-2bf0-1411-cebc-df255810e299@fb.com>
Date:   Fri, 12 Nov 2021 09:09:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: extend BTF_ID_LIST_GLOBAL with
 parameter for number of IDs
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>,
        <syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <20211112150243.1270987-1-songliubraving@fb.com>
 <20211112150243.1270987-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211112150243.1270987-2-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0072.namprd12.prod.outlook.com
 (2603:10b6:300:103::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21cf::19db] (2620:10d:c090:400::5:4b3e) by MWHPR12CA0072.namprd12.prod.outlook.com (2603:10b6:300:103::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Fri, 12 Nov 2021 17:09:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5667dc5e-e26a-4c83-f239-08d9a5ff296f
X-MS-TrafficTypeDiagnostic: SN6PR15MB2285:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2285D3DD8DB58C28055004D8D3959@SN6PR15MB2285.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+JK70Cv4ogql1JAM0+XcP89HpY6d2py7eyoIhraVCNFTz7puV3lHqQkkZTYSU0hKTKONJ1LMwPLL5KkfsBgZW5MMdThMZz/Yxf2aSsxnSJv2Xcd08yJwSlsXCN6955JbmSy850n6LbLc5lJqKbwQn5oucfY3fYAxysuBMMJcB2A92jlwKYtl9wuUrGZVix/83L8gy7ByMN7EVzuEOg+XBtfwtOC+17DVzlVs1inkgFWxBeXgxSAD05FjuBo/Rf55GCjUgnoKDKQ8A7WG3QfHSFXnpA8a5H3QlkNqmWB+XgCl+oSlGW6yTPgGOv5t/AdISa7EeeJXSf5KAtc+YsuUjEGobLydefarTEWM5EeFD9rPlcXATE0tgFVfH3DpzaBSiKONY44F/ak9GQC0LWP3xwYJXVEiQD+DOXGlV9/0U87bu/Azwb/JLQmfJKBGnQP4eudRweIQCJEIg/knOA9iRcoZ5J6fqZpAC9XjJOgOncizV3UIWNqxUgxIh1k0iY1nyn8rXd3f7NQP20g6rpFABpgeD0Nzp83dmTeUjqWKKKFdLTbNYDhQHEufqbz9Z3Chm3S/CL4vfkGQVO+s8pN5OoqxkP00DmDNRWk9TKE+PEJoizRqYeWcwQbOsZuWKzw1HhiOk5GFFmpdy7Tf3Kq+87biJwGpHeBWnb4DQlRPpdtU5yjq3eUGHlELIeiyGLB/ZouwBF7IA9oGmn0X+IrwgLlaMagCfpr/+YMfRDvTMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(4326008)(52116002)(2906002)(66946007)(66476007)(36756003)(31696002)(8676002)(2616005)(53546011)(5660300002)(8936002)(86362001)(316002)(66556008)(186003)(508600001)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjBWNW1WSzhqdFZ4YlV6VWNFVVpjOUdQUkJjbkRKcHBGaTU0bDlUR2hXU1FK?=
 =?utf-8?B?UFdGYThldmlzMzZmK3grK0wwZUNkcWl5cjlzT05FM1cxMU1ieWROU1pCQlRn?=
 =?utf-8?B?TlR6amlHcHlRcENMUG1MU0JyVVhOd1dBc1c5cytHR0NNVElOWWR2SEhuYjlu?=
 =?utf-8?B?eXhlVmZRa1hMejc3amJ4bXk5RWV6alJSOWFwYUdaK3FkOXRKQnpQZ0syRHhD?=
 =?utf-8?B?cE1NQ1VMVHJXQ21aWm9GNWZ4RDNWNWM2QlIwLzBrZFJkekdLRGk0OS9FanE5?=
 =?utf-8?B?c0t0dDNkTnoyMmRUMnVIL2h4QS8zYXV5VUxFbkRMRWxNaGc2ZDVvOXh2clFr?=
 =?utf-8?B?UmJTVWwzcnBnbFFqRGJ4b1JWUlQ0SXBsMlpmMUR4N0RHN1RhN3pPenJ2VVBx?=
 =?utf-8?B?Z1Y4ZFU3V1NPZ2NFSlBrT25RNVVjcTAzVnRGSG5LZXl0NkIvMnVxa3pVWEIy?=
 =?utf-8?B?WDdpOG9mWXkxb3FudTRDaC9TTkZkSEZscHZkaEM2dWYwWkdDZ2M3dnZobXpj?=
 =?utf-8?B?VThLODRpY0o1U2FxSEpHSHNnKzcyV2FlVUlBRXh1MXd4TzJacjdMekhYdWF5?=
 =?utf-8?B?aVFYZDBhR0luWjRGempkVEdxSWo2b0J2cXdVVzI5UnVzRU95aFdDSjgzV1JQ?=
 =?utf-8?B?bTNFMk9ES3pWTzZTci9RSFZ1aWxMekVCRWs3M3h5bmk5aXQ3ekVTQTVYbTVC?=
 =?utf-8?B?RUQvMngzL1NIclUvQUdIQ2lYaDlSNzlaVVlENWpkTHpnU0JNemNvZGRrZTZW?=
 =?utf-8?B?aC9wUi9RNGk4VkFMd1pINjNZeThCTmNjd3JTeTVSc1Q3a3g0NU9JdzB5aFNM?=
 =?utf-8?B?RVY3bjdQSHlwb1JXVnJsTURzVHBET2Z2N1BScjBLY2duekVZVW0zL0I3Umxj?=
 =?utf-8?B?NGtNRDVGZU1vOE04MlQ5N2E0Y0xLNGwrbkc4NGZ2YkJQZTlxYVI2M1ltNVBz?=
 =?utf-8?B?cVR2M1BmajBJdWdzSXZPWlQ1OHYvVWxzMWttbUNsK29Ed3dOQXcxek9lNGVh?=
 =?utf-8?B?anNjNCtINVc4eWJmb0I2L3M1aXRubGg4dTBSNGhJelM3WjA1SGJTSUNVZjAr?=
 =?utf-8?B?U1NIU0FCSkt4UWpmT2dQTHB5SlZINHJ1ZVhXSXhMczdxbkJ5VGhqTHNRM3kr?=
 =?utf-8?B?akpjSTJMNnFLRXQ4RUloamx5TG43MEEzNldCSVpjdXc0MmtrR2pPWUZxand4?=
 =?utf-8?B?WTJMTHdQRG1UcXhNZktURG5pVWdXV01kQ3dOWG4xSENaZjIweTZDeW80R3Vw?=
 =?utf-8?B?Z1VKYWNvL2ozMHROdlZablIvb0NaeEZ4c1l1Um1kckdPL0kvTU9GTkxyU3Nw?=
 =?utf-8?B?S0lJOEtnYS81SEZLL1NHV3hGMGJNU0d4cTNnMVJiRFpGWUJhYm5PVVFVVE1M?=
 =?utf-8?B?UGxWZFZPc05UV2R6dVB4VGhRd3dBVTczY2hNNXpZT2FiNFJzVnliditrRlY2?=
 =?utf-8?B?N2g2bStMbTA2Nm1acjZualdsd1RQMC8ybEd0dzI1Q2NCanN6MjkwWUk2VVpl?=
 =?utf-8?B?WnhTYTBFM0ZwZGxoaHY5Z3BQc2FnQWNWTXJKaUdtRjV4dVJhWFJ3UnVKaGxQ?=
 =?utf-8?B?QXFKbFo1emk4NTlsSFdMZlNIRjdCeDRUcEFDQmpNQW5ya21BQXplY0FOVjB4?=
 =?utf-8?B?S1FBUkxUR3VoQ1o3U1gzUWZFMjFQbk96VUxPZGJXRkxlUkFDRUJMRTVRZ3Jh?=
 =?utf-8?B?MjltZU1qYmhtbXRtTDBZOHpubjdpNWsrb3VnZHNyMStEWWpFT0JUS1AvTndp?=
 =?utf-8?B?RXJHWEdVdFJuWWNGUEtjZC9tTzBvU3BBci9VYktEa2EvbkpUbWV0a0krbkoy?=
 =?utf-8?B?aytPcVBDcVpsNVhTbU5GbzhqMmt4Slo4a0VIMGFsSHhWVXQ1WEhRejNVclRw?=
 =?utf-8?B?V3BmbStTaVhYbTNSNGROSjVjTlFBM0FTeEZLamp2bmRsdXAxTzYxVklFTnBM?=
 =?utf-8?B?ZWl6ZEQrV0s3Z0I0Rk9aUHBxL2lkWlBYVkQ5OFp3T3BFWGlBUGhZdnMzUHlr?=
 =?utf-8?B?WlU0Y3lkdkVxdWFEdDg1MytvTWtVWmpMc2FiS3llMDNkWDhvUEcrSUF0TWta?=
 =?utf-8?B?UEJzbWw3ZnY2UnRxam4vYURaQ2c1UjM0R2hoL3ZmVHVGZDRyL3ZGOFp2enBk?=
 =?utf-8?Q?KSU1RTY5sbp/BMHDeHGpfLNA+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5667dc5e-e26a-4c83-f239-08d9a5ff296f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2021 17:09:18.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbeETnXp4AWeW4bN5w9HSl27/I33Hl/ChKieM6gtKl8/VoMAIro8t4zeFr5vimee
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2285
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: d6d9xUFuX4XEgX_g8EiRtBEw6Cvhbx0C
X-Proofpoint-GUID: d6d9xUFuX4XEgX_g8EiRtBEw6Cvhbx0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_05,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=0 clxscore=1011 priorityscore=1501 mlxlogscore=793 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/21 7:02 AM, Song Liu wrote:
> syzbot reported the following BUG w/o CONFIG_DEBUG_INFO_BTF
> 
> BUG: KASAN: global-out-of-bounds in task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> Read of size 4 at addr ffffffff90297404 by task swapper/0/1
> 
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.15.0-syzkaller #0
> Hardware name: ... Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> print_address_description.constprop.0.cold+0xf/0x309 mm/kasan/report.c:256
> __kasan_report mm/kasan/report.c:442 [inline]
> kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
> task_iter_init+0x212/0x2e7 kernel/bpf/task_iter.c:661
> do_one_initcall+0x103/0x650 init/main.c:1295
> do_initcall_level init/main.c:1368 [inline]
> do_initcalls init/main.c:1384 [inline]
> do_basic_setup init/main.c:1403 [inline]
> kernel_init_freeable+0x6b1/0x73a init/main.c:1606
> kernel_init+0x1a/0x1d0 init/main.c:1497
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> </TASK>
> 
> This is caused by hard-coded name[1] in BTF_ID_LIST_GLOBAL (w/o
> CONFIG_DEBUG_INFO_BTF). Fix this by adding a parameter n to
> BTF_ID_LIST_GLOBAL. This avoids ifdef CONFIG_DEBUG_INFO_BTF in btf.c and
> filter.c.
> 
> Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
> Reported-by: syzbot+e0d81ec552a21d9071aa@syzkaller.appspotmail.com
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
