Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FC830180B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 20:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbhAWTh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 14:37:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbhAWThZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 14:37:25 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10NJYGZU016573;
        Sat, 23 Jan 2021 11:36:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RaVTqKz0xWxBirUg07uWuuws4YBZCrbnLawxpQdC/3c=;
 b=Zj3OrUWPm8jUnlezUwZi6ZuQ2h4oKbepma6hMfS7Rl7K0CBe+XV3GrWRsHGFybAe0tac
 uL9DubtPxbfI2m2sXhBdC8ZZsk4JaevI1WpGMcCWfmBD4508gD9MPWwUMQreRTnQsN6j
 z+TFXugoKGfBu/8J0H7aigA2OuXy/3kJRcY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 368gbv1upb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 23 Jan 2021 11:36:00 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 23 Jan 2021 11:35:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDPX/eOs7OekxQ13EbXtjuZl+blTW9nHUsLYkKyWwmJFOV9ILidiJ/ejGEm2h9KtOpc5HZ/uV6LFiLeAMtQCOdQWerHSaedaz6VrRhFocpTLVoxXt+SO/HMB3W4IC9k/HtWss6Lti0RzqxWlzFrHRnHmrjEJNNlvMutgKkWtOuE00+mXuxbe2OERPWBwndbLEaBmtSOCdxScF7UYXk1LJtFEOSwsbUobArXiOOrcB96qRv0OVbEhIwMWe95WMQUhlQXbf51pNrKO9sP5Np3tk+IIqEN6jAVKlz3CzjSDbVsEaMpCyF4MM8IVOJjwFR7PKRb5ptJARu5NvQ1HjaGGCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6GsQiluMJBxu+L5UEPZ1idoc6Lju46UFywgpT2dxMA=;
 b=mJr4a0ejWDkUuhE3SoZV9z8q0EM+OdbwBnNYPx1DR4v0C9B0uwcYKnpvQ/eR1Ls9RTLM1/GROWRm5NcGL6lGTM/Z5zX9lE8onz+1lbfecX1e9UZhL7sHa7K9vnXhlvWapaBJdE/WEbUimFEHWvSEElhlW+51AvHI3ldTeO/C528zyxJwibAH4K30Sy1Mz8EqfOuyki3FPVSUn+n8JWGQqO4i/zce49OISa/TZGiXmVjER4KhmAK51zMa/qKAiHQun/hk2oYVWCR3qr8DtIf/5lAOxa37+qJ0Av4JXVOg4BRN5xo27Gq62mqWxezND4Jsxe1mfLavG1hc8+X2NbwXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6GsQiluMJBxu+L5UEPZ1idoc6Lju46UFywgpT2dxMA=;
 b=fascZ35CGZ15mgku7Cigp0o/jR4xrg+Mm4s4HDsNtwUiZTWQIROQNXGEy+jx+oo4LqsuXpzpMVTozuRMXbQpCI25nwHhg3kzuz3+akhVRPM9a/PGETPRyppLVvcYITvMrMOCYHR6PUJWWmRfDxrYnbCQS+gFk95h4EZYIxYqy14=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 19:35:57 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::61d6:781d:e0:ada5%5]) with mapi id 15.20.3784.013; Sat, 23 Jan 2021
 19:35:57 +0000
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run7
To:     syzbot <syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com>,
        <andrii@kernel.org>, <andriin@fb.com>, <ast@kernel.org>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <hawk@kernel.org>,
        <jakub.kicinski@netronome.com>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <kpsingh@kernel.org>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <netdev@vger.kernel.org>, <rostedt@goodmis.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <xdp-newbies@vger.kernel.org>
References: <000000000000891f4605b963d113@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d967ff2d-e272-b966-407c-82dca9a08e04@fb.com>
Date:   Sat, 23 Jan 2021 11:35:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <000000000000891f4605b963d113@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:250c]
X-ClientProxiedBy: MWHPR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:300:d4::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1946] (2620:10d:c090:400::5:250c) by MWHPR19CA0018.namprd19.prod.outlook.com (2603:10b6:300:d4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 19:35:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 276666e4-7aa8-4ecb-ce68-08d8bfd61b29
X-MS-TrafficTypeDiagnostic: BYAPR15MB4086:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4086399638E974664E14EAA5D3BF9@BYAPR15MB4086.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:269;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GbbULZvbQWsVgzg37prHhDEIFjTsR9JsUhA+MsZ4AxjNpe4tQmgvUUDli6mhVf6rJFOfpaPvCPuy0B3oMMGcsmC7KvkDPmSlz+edCfcHmQCQovOFq7fbGgrNJBGJ8eZJ/olQbGX9+5T9TNSkfPiSew0Q64RI55mX2kJdAVAn5oYJ0rmz6osIwWJwNWlTSXtNCyuT1rYtj64kyJiYCpInuRzjJ0SFzSgAWvSA4VI2vTTze1hKhj+t3CJXeX72MIGCqTzCXD3WoxRI5ufaw0MQqrwePX9IStNs/6HBfGl5pAdY8bppGywxNkEx0gakfasUfQaS4lLzrzEJxpkinQLd0ijo0jxvvxO5v+Uu6wHIL+VUeJN5Fh5g8nKp2DXUN1PWPW84NQzEpwm0CIoBmgzAy0XzkVXXK8UXHpvNfjlgtvCVRPE/JD7zw8FHK3DWjYGrdtfodqm5fz+rANw6BX5OzdV922Kiyv8kGPPUHZUpp5GrcFF8k/HJ4umtF5cHtlT+OPYJFgv86zmWzeshs6oZ9NGGJM3YUkslTCJETHdWuyxc/mfYOQVYNooPxPa6c20gy+Zux6nic//lmT+jdA3hWmvOpA3ixjZ5Rpj36dhAKrM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(316002)(8936002)(53546011)(36756003)(52116002)(6666004)(8676002)(66476007)(16526019)(186003)(2616005)(66946007)(5660300002)(83380400001)(966005)(6486002)(86362001)(478600001)(921005)(2906002)(7416002)(31686004)(31696002)(66556008)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bWJKdW1oQmF0eGdhcHFpalRBcC92L0hGbzVrL2dQMWZIZUVDU0tiMDdNaTNT?=
 =?utf-8?B?OVRLNUdycDZaTUk4V1pKREhzWk81dS9lZVN1ZXZmbDdjMVl6K0dwQlovY1Np?=
 =?utf-8?B?WXg4OUx1dDFhZi9MZC83WlN1MXVWQ2x3UFlldGhNYnRJTjVMU3hUMEJpOU9N?=
 =?utf-8?B?UldIL25PSUE1Y2xUZzhzMVdVcVd0M1NTQ1l5YU1HSnl2UkF1VVdVdVprYW9w?=
 =?utf-8?B?eHlIai8yWnIxUnBHcVdyVjdFYVZOMGsxc1Arc2pVcmVBcnVLQ1hsNkIvUTNK?=
 =?utf-8?B?SkRPenZsRDlSa3lLV2YzMDFPdkJiQ0tGdW1VQUtvVFFESWxUdnE3eEo1d1Ez?=
 =?utf-8?B?V3RsYWtyQU1WZHg4b2xnOHdTMGNEK0xIc01qVDNEdzRDMThnZGhkNmM4QmdR?=
 =?utf-8?B?cnlIajZxV3ZkdmY2dUJmNnk2OThBNHZWZURRSVhXWlJnbjN2MkM0OFpJeEFr?=
 =?utf-8?B?SWs3YWJsdU9Ta0p0dW5tUjYwWFJxdjI5THlPR3hTVEQrRmdwaTNQZjBjb2hu?=
 =?utf-8?B?Nlc1WjRKUDA5cVdYbTlxUUh0enNhUkpmLzZ4YzNPVUMyMW5tbXVmRlFXZkRQ?=
 =?utf-8?B?YWZZSU9CNjYxcFhsS1ZKdlIzZ3pEQ3RXb296MEF6cVZhOTNwWmgvR3NsNFJQ?=
 =?utf-8?B?L1FEUmorWk5zMnlOQmhvSHVJSHk1M2UwSGZZWXR2NEhocXhnMVpqUSs2aksv?=
 =?utf-8?B?dlhnYktGczJDc3NxME9ZdDk1ZVkrL0ppemFXSEMvL0FUT2lZakZZREx0TDBl?=
 =?utf-8?B?Zkk0dXM5T3o3NDZQRnEwLyt1eEhzVEQ0aE9ZdnhZdGwvZklMd3M2UXRaVWsx?=
 =?utf-8?B?eUF2OVFZUkVLajRUYVR5ejRqNjNUQ3RWcGZva1NyS0xKMSs4bnE5QXh4VWxT?=
 =?utf-8?B?TzZPbXRVZ2x0MXArbkxqM2dKYXR4TVY2c0o1MTQ2ZnZTM0pYY3VFN0JuZnVl?=
 =?utf-8?B?dVg4UE4rRitJaTkrR1o3TEk0d3FFQllCT3ZBaThGZmZKK3NYQ01PMmxzTFVO?=
 =?utf-8?B?MEtSR1haaWJMNHU3Q1BsVXA1dGhaK0RWVHZYZ2x2ZEIraDJFdlJaaFQ1Uzlo?=
 =?utf-8?B?ZFpjZE5RYXdsb1BsVkhNZlpWaG12d2Y3SE11dG5aeHF5Ym1mK0ptNC9LS3hh?=
 =?utf-8?B?eWFhSmMzaXBaYTdrSWN4RmQ3cFh0NVUwTDE2d3F1dmlBZmFrN2dhNHNoazhY?=
 =?utf-8?B?UlJJMW01Uk40dnNVc2hxeEpCaFBXS3hIMWY2Z2FuYi92QVoyRThicytRRTE4?=
 =?utf-8?B?N1M3VnFqTDlmM1pBRnRWSnI4Qm5sY0hvVjZCc1pydzU4NzhqdUFyY0gzSVVh?=
 =?utf-8?B?cDh1d2lWUW9GVlcwNHZtaFlycUZ4YVRkRmxzRzhoVEt4MDlGVGxkL1dnV0lU?=
 =?utf-8?B?ekMvRW94NVNSaFpLaU9ESHJmcWkyWGFZQk9wRDFPVXcvSmZ2Zm5oWEphbkhI?=
 =?utf-8?B?b0RjOEZoZ1dOdVMzTFdyT1FZazBjdi8xQWN0am5tZExkandETFNhM0ZoTWhQ?=
 =?utf-8?Q?wbM+BA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 276666e4-7aa8-4ecb-ce68-08d8bfd61b29
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 19:35:57.6374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9DE7hfgvOwr80bgb0BcpxH1CRQ5sd1D9eZmWE9DcC2Ipl2jkrv+cSouKAq5G4RA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 8 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-23_10:2021-01-22,2021-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=846 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101230111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I can reproduce the issue with C reproducer. This is an old known issue 
though and the failure is due to memory allocation failure in 
tracepoint_probe_unregister().

[   40.807849][ T8287] Call Trace:
[   40.808201][ T8287]  dump_stack+0x77/0x97
[   40.808695][ T8287]  should_fail.cold.6+0x32/0x4c
[   40.809238][ T8287]  should_failslab+0x5/0x10
[   40.809709][ T8287]  slab_pre_alloc_hook.constprop.97+0xa0/0xd0
[   40.810365][ T8287]  ? tracepoint_probe_unregister+0xc7/0x2b0
[   40.810998][ T8287]  __kmalloc+0x64/0x210
[   40.811442][ T8287]  ? trace_raw_output_percpu_destroy_chunk+0x40/0x40
[   40.812158][ T8287]  tracepoint_probe_unregister+0xc7/0x2b0
[   40.812766][ T8287]  bpf_raw_tp_link_release+0x11/0x20
[   40.813328][ T8287]  bpf_link_free+0x20/0x40
[   40.813802][ T8287]  bpf_link_release+0xc/0x10
[   40.814242][ T8287]  __fput+0xa1/0x250
[   40.814606][ T8287]  task_work_run+0x68/0xb0
[   40.815030][ T8287]  exit_to_user_mode_prepare+0x22c/0x250

Steven Rostedt has the following pending patch
   https://lore.kernel.org/bpf/20201118093405.7a6d2290@gandalf.local.home/
trying to solve this exact problem.

On 1/20/21 11:14 PM, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 8b401f9ed2441ad9e219953927a842d24ed051fc
> Author: Yonghong Song <yhs@fb.com>
> Date:   Thu May 23 21:47:45 2019 +0000
> 
>      bpf: implement bpf_send_signal() helper
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123408e7500000
> start commit:   7d68e382 bpf: Permit size-0 datasec
> git tree:       bpf-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=113408e7500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=163408e7500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
> dashboard link: https://syzkaller.appspot.com/bug?extid=fad5d91c7158ce568634
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1224daa4d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dfabd0d00000
> 
> Reported-by: syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com
> Fixes: 8b401f9ed244 ("bpf: implement bpf_send_signal() helper")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
