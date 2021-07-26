Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631553D5353
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 08:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhGZGGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 02:06:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21316 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229658AbhGZGGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 02:06:30 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16Q6isnK008310;
        Sun, 25 Jul 2021 23:46:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Pk8U0+uBLK2HJuwEm6xsXX2nL8TFaL68IsVbEJEe2Vo=;
 b=BK8GcCHPYUjodNAx5jOlU8tyqZJgQrRJl5nrygRX6n5oTB8txub/XFe5kJC4uoVop3Bz
 zQz5CywWB7//DgUpyvkNVnx9g+RxHyNOl8tE4m29/Mj1WxQeE9jlJcs05fVKEvchu7jN
 gQCbQd3BvQ2EJoLIm7KXBA/NrYz+L7Hc3CI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a0gjn7pgq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 25 Jul 2021 23:46:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Jul 2021 23:46:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V63IIzM6T7TodldmUu4HDhn9YijIxq0vxkgHXR1nuU9cycGGezw3dGOt65IZTYtZSRIVouUCy/SWkkU2RtpEnvPhv+gCSh+xQLaSS+7FieixEtS3BYqgGmv9jnBzSsBtzZVGsYss2Ri8P77WsOg+l3SodWak7RjGGCy4SU9hiIx+TmjOaPSlWVPmg1N70hegbN+YkH/Orr7YBoAOZGnsR7CTYwCnBBpLQAJHCQWw1/+vh2Uefw83vLAdNVW0Nq9acm5PTXHAYphtGfLwnNF/2AQ9SwVhN1jmk7DbRJe59L4K7rqeR++SvyLFgiu3ftGhuDfqm1K5JwEPgNheuhuXvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc/xOHeAq8j8PSBn9r5uRs7ytajtG82DclEuF8BWZrE=;
 b=gedtv6fH14885xdzhyK4A17+pHu3Y6CUGG0uDTgFi7ztuHvZsAlQU4cY8V5wpHxMbzucBN8cgBRGq6yiYLmiddzGgOmLQP+a1qP9YZSF7TvSeE5mJug8if4FlmFsL+sUkc/VKSI64pQEcMhlmD24jSdNi81jE0YS6WBtVEin/n2hAKEou0xwYuM5P5BLjqiypzZnoeklDDc09oaURZvF16R53Dvg+nIrrvKpLIQszy91jcyJ4hbR6kWmhqto6MHyoRZmzyik0q/naqCdaPXbC4nDa1GN90A0sFNVGFjlSUBzUPSA9hJjooPvy6qazaxDOT+fAu/c9AXZgduyi+FP2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2288.namprd15.prod.outlook.com (2603:10b6:805:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Mon, 26 Jul
 2021 06:46:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 06:46:34 +0000
Subject: Re: [syzbot] WARNING: suspicious RCU usage in
 bpf_get_current_cgroup_id
To:     syzbot <syzbot+7ee5c2c09c284495371f@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>,
        <syzkaller-bugs@googlegroups.com>
References: <0000000000006d5cab05c7d9bb87@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3daf6488-c57d-825c-2a0b-d2f7c38992d9@fb.com>
Date:   Sun, 25 Jul 2021 23:46:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <0000000000006d5cab05c7d9bb87@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-ClientProxiedBy: MWHPR01CA0040.prod.exchangelabs.com (2603:10b6:300:101::26)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::10b9] (2620:10d:c090:400::5:64c5) by MWHPR01CA0040.prod.exchangelabs.com (2603:10b6:300:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Mon, 26 Jul 2021 06:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7b539cb-7497-4e6d-802f-08d950011baa
X-MS-TrafficTypeDiagnostic: SN6PR15MB2288:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2288BC819B604B713E7ABA54D3E89@SN6PR15MB2288.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6zvENfSSHB9Q0wNHlDmVgazJ2Y4hKvHig0uElTs+gZhDKwrBv3tTvFNvmSCK6PqPWn0ip6G++xNzY1ywB7tl38WUqX1zEkiAbWcgV5V+duGw/n86IwdHA+MCabXPAxd30b6xfUdZU0iy9POEM6xBtIkVsjTd5vF0Arf1mZxhcjB4TcYR5k5NUJZv3NhNfYJVUat+4ThUK8el7wPNSh7xS6xP1hUerhdeBGOnyVA7d9IYgXbgeGTK0kcruNYpXI5OjWgUtXBsEoRU2AC/LCieOawVsSNufw+LTzQCp2iocojqCvQ/w3OaXZjmvZN0k8wSZHDnxZ3GIHWD8+7YI9yWLpFZ+bVYj+BV2aWgiVVPzSiV2VA1b8HmGohqmyISuriAIFLDdjQCRuur1eqnci2Z6nBsbHEsYgFh4l0wegnvdMUX6MAEn85jFyoKUZ4SzrgOPJae+lK8wFqMu9OGCIPYDT4zK2uJprJD3PYbN7IPOwjVsSgR/7Ei0Qtv16ya0QDTT9ij+v1b5z0vB+aHNAIBVzQb2QtIj0YhxhiQvuNy996WKGrci/L8o8W4/UQrMmzXYdHisf36XaMwaglPRAAQlBOCupIXV23InUe0VSarmCcsUmdacF7u1xy6XjP/j1GdlEskGiqK4XaDkWLfE38ALdkC9+lKypq2uTKXBPOcKWtQWarqC9UU1lEjRlc0ylI37FJjqTzbY6KZJAzHPCj7qUlzswgSZh+G6DJopNC8brvquLwMo0iqVLPTY6hstvhguXKrgx79pKpffwInOeNds8P5GrLO+ju0GAVrt+P1FISOMKt1K1OSb3Vc5R9g04Y2gl24McmCQhuJz48lY4pAE3DQaNbqkoale/f8tx45xKD1SYQyvN2wEMgvFvi271WF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(921005)(31686004)(86362001)(38100700002)(83380400001)(31696002)(53546011)(52116002)(2906002)(8676002)(186003)(66946007)(36756003)(5660300002)(966005)(66476007)(6486002)(66556008)(478600001)(2616005)(316002)(8936002)(7416002)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEJLRWFBdmRDZWZlbjUwNDBxSVZCa3l4R0ordG9BZVV1ZWFIOUxtbm5ZQTl4?=
 =?utf-8?B?MGpMZWk1blFuRFAvSXhzRzFrbTZwRnZYWFlRcGxsSVRDeXM2SUlVUHBQYzBZ?=
 =?utf-8?B?VFhUVHFuMEY4eDAwRCtnOGlEV2xXSFRQZ1dpdDlGWStPSUg5RWU3cjI4SGZt?=
 =?utf-8?B?TnRwZjBEWHkrTTZoeWRETU1HNTNYa2M5Ukx3czk3aUtQTW5Pa2NIRVdNNDEv?=
 =?utf-8?B?RmZyR3BHSEcrRWFOUmVBQ0pHWFBGVnRXd1QwTXI4VnBZUjhmZlN4Q1NCNXpV?=
 =?utf-8?B?YUh1bkxNZmJDVytXMGJHdERnbS9ZNUQ5ZnVyMXRINkJWYmN3T0lmREErRXh1?=
 =?utf-8?B?L3VlRytNbW9ZZmZLMEdRRkVuaG92blIrNm9GYmlIMDk1QW5neWpicjdSOEhi?=
 =?utf-8?B?a0NlNUh1aWVJNmtuQUpMSWduQ1BLSkN0Nnc5TjkvSkxWTmpvSXkxMDIzOGJj?=
 =?utf-8?B?VUhnaUNyWTQwNTRPemdvQVpKcTRRaHhsRVp5MlB0SlJUZG1vWXg1T0JIYWJ6?=
 =?utf-8?B?UXIrME81VlBtQ09iWUN3QUJpSkx4RVdqSnFjb1FCNVZwV0FSVllFaHdHTUw0?=
 =?utf-8?B?N1BoQVl3T05DYkN2dWdzaEovK25QaUZGakk4a3IwYjFKTFFBNjlneEJraTdq?=
 =?utf-8?B?bmFvd08za2lVOEVpQ0J1MkNmQ2IvTHNpeWxLY2F0NXRob281ai9ycXdmaUNa?=
 =?utf-8?B?S1lEcmdqS3pFV1JaUjhMcjVOU21IMldCUjVLNmFaRnc5MUVWWWZ1R2NBcVhz?=
 =?utf-8?B?UzFlOGJUcFBFNlZnaTVKSVdJVExBT0RyQlROcTNsakNWRmtlSEZWSmVxVDJW?=
 =?utf-8?B?cEk5bEFOYTA0NDI4Tzc2dGpsUXRLMVQ5S1ZaSFc3NW9FTys4NjlzcXNUNHds?=
 =?utf-8?B?K1hybW81dXFrZXZtRmJQZTZGeWJiRTRicFZ6TTB0WWkxamJUdWNnZkZWNW5O?=
 =?utf-8?B?VXlHTndvZHMwUlN2T2VtNUdISkt0VTN2M1Vlb0ZJSkd5NExHM2xBa1h1cVlT?=
 =?utf-8?B?cWwzRTljc1M0d1dyVUI2WEFlTHRIZjdwVU1TbmdJUFFNSjlJb001T2RBTTVh?=
 =?utf-8?B?bDVFNHlqaFVOVE5OazZmVEI3MWZ4WmV6akhZbm5zdkc1Q0E1SUZaS291MzBk?=
 =?utf-8?B?TW9kdnZOc1hGN001V2pualkvVCt6T2ZNMHFtK295c1N5b0w2bWtaOGszcE9l?=
 =?utf-8?B?Tnk2L3p0Ulp4NFFTNlNHbFlBTW0wS1hFTjgvMmQyczJOL2M0SFJsem9wZC9O?=
 =?utf-8?B?ZlZwOXUyZSs0T3FyRU5xRldoUHVxdFROUUZxY3RCVm5SNnlCeWxFRkNWcGNN?=
 =?utf-8?B?K3NKRjFjejNuamtaMW1hV0ZlYXJpN1hKaFFWSFF4aXN1dlZ4c2tIZW16YXgx?=
 =?utf-8?B?LzJMVkUvWEU4bngyTTZSRU9JV0JucHNnVUI3MEdDMGY1TWxKdEZnTzJEUFRn?=
 =?utf-8?B?V3pYRUZIL2RQTmFsNTF0SDNvNDFmcEl4VEQ0VXE5b2prV3FoQ0Zjemd5dWps?=
 =?utf-8?B?UEFFam1PZW1aWmxOcnN6czA3U2MxM095ejRFUmZIZE8zcm04dEd2WFEwb2Rt?=
 =?utf-8?B?R1R1eEphYUlHcFRIZHBRVXljUnRTcmZBVUk0TGx5WmpUa1drNUMxbmpMczJr?=
 =?utf-8?B?MzNnZ1JtNWhRNEtxREN1OTVDek1kdmxqdlFtUFRIZG9EZTIzTzR2K3FxZnlF?=
 =?utf-8?B?QlBkN1JXWkMvbVIwaFpKK29PRUlrNm93ZXphWDU1MGNlZ2lVVVcrME9PL0M0?=
 =?utf-8?B?akhtWnQ1ZFd1M3J1U0NGK0RVN3FmK2pXbkR0WHNTVDYwbnZBbFBjRTRhUEM0?=
 =?utf-8?B?c3hoY3h5ak03TWtQMGFkQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b539cb-7497-4e6d-802f-08d950011baa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 06:46:34.0922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AajYJN1iF0SzFf/UYeoPZpvClPoTaMIekRjbBbj8Nr6TQcT6IEo1vLrDFeJDYmx8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2288
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _I8uLz0Z71iGvHb9JaobRX5VKld6i_vO
X-Proofpoint-ORIG-GUID: _I8uLz0Z71iGvHb9JaobRX5VKld6i_vO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 12 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-26_03:2021-07-26,2021-07-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107260040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/21 12:47 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d6371c76e20d bpf: Fix OOB read when printing XDP link fdinfo
> git tree:       bpf
> console output: https://syzkaller.appspot.com/x/log.txt?x=146597f2300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6da37c7627210105
> dashboard link: https://syzkaller.appspot.com/bug?extid=7ee5c2c09c284495371f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126b7c40300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1616cf6a300000
> 
> The issue was bisected to:
> 
> commit 79a7f8bdb159d9914b58740f3d31d602a6e4aca8
> Author: Alexei Starovoitov <ast@kernel.org>
> Date:   Fri May 14 00:36:03 2021 +0000
> 
>      bpf: Introduce bpf_sys_bpf() helper and program type.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a73112300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a73112300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a73112300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7ee5c2c09c284495371f@syzkaller.appspotmail.com
> Fixes: 79a7f8bdb159 ("bpf: Introduce bpf_sys_bpf() helper and program type.")
> 
> =============================
> WARNING: suspicious RCU usage
> 5.14.0-rc1-syzkaller #0 Not tainted
> -----------------------------
> include/linux/cgroup.h:481 suspicious rcu_dereference_check() usage!

Looks like we may miss rcu_read_lock/rcu_read_unlock in this function,
static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
                                           const void *ctx)
{
         u32 ret;

         migrate_disable();
         ret = __BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nop_func);
         migrate_enable();
         return ret;
}

Will provide a fix soon.

> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> no locks held by syz-executor499/8468.
> 
> stack backtrace:
> CPU: 1 PID: 8468 Comm: syz-executor499 Not tainted 5.14.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>   task_css_set include/linux/cgroup.h:481 [inline]
>   task_dfl_cgroup include/linux/cgroup.h:550 [inline]
>   ____bpf_get_current_cgroup_id kernel/bpf/helpers.c:356 [inline]
>   bpf_get_current_cgroup_id+0x1ce/0x210 kernel/bpf/helpers.c:354
>   bpf_prog_08c4887f705f20b8+0x10/0x824
>   bpf_dispatcher_nop_func include/linux/bpf.h:687 [inline]
>   bpf_prog_run_pin_on_cpu include/linux/filter.h:624 [inline]
>   bpf_prog_test_run_syscall+0x2cf/0x5f0 net/bpf/test_run.c:954
>   bpf_prog_test_run kernel/bpf/syscall.c:3207 [inline]
>   __sys_bpf+0x1993/0x53b0 kernel/bpf/syscall.c:4487
>   __do_sys_bpf kernel/bpf/syscall.c:4573 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:4571 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4571
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x44d6a9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f32119dd318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00000000004cb3e8 RCX: 000000000044d6a9
> RDX: 0000000000000048 RSI: 0000000020000500 RDI: 000000000000000a
> RBP: 00000000004cb3e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 656c6c616b7a7973
> R13: 00007ffeb7672e8f R14: 00007f32119dd400 R15: 0000000000022000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ  for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status  for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
