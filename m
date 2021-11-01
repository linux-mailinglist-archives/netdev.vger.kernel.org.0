Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBD4412A2
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 05:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbhKAEE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 00:04:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229462AbhKAEEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 00:04:25 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19VLYqB6013185;
        Sun, 31 Oct 2021 21:01:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uuSJsbp4Pg2wvA51PqyAXXcR2zWBs7l3/1v/284lUA8=;
 b=L6mZFwiqV17Qsy0Eu8VFSYNIdoIUuKAUIXvEAneRovsNXKDSaDm0vV8WkuCsHkEWy5VH
 /mIBvxotz9I6ndQNxFR3jAAdkjPGSvwdTEJKo3211Hrxp1SgTTYkpioVw7CbmcNAIOST
 YRPAGUITT5UpHX9ntSKXBPCOKf1Z+6ZtfE4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3c1ns7482u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 31 Oct 2021 21:01:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Sun, 31 Oct 2021 21:01:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6tEssdNLryOhY3h0uuOjfpdZlCsS7Xfo6ja7EX6n7JMldoqpQlK17Gsb+Rfpp6zhBAtCJ++Jiz8nmdgCh+HA7UWN1RCnNwrj1zqZwkKCKI9oxrEmCuwmDyqe/saqAGbZplbBK4kZYvL/SPoChBnFXOgHmjbjvdGmwLreNELx3bd4uouUEiiFbBxTN3INqsZyd1pqJcAAXys28nqaqDPftBpn99PYqTBW1NShAqfOsZ932933j5jnyy27TvYj4EIByrdAsKOPgQRe/TloqbsgnrGUd7beWpt1QYlMI5kQIAqkEGQyvZebpLuXLXHtn+K9aXBuQUOg9jSj5+3S7bjrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuSJsbp4Pg2wvA51PqyAXXcR2zWBs7l3/1v/284lUA8=;
 b=MLlk5Ez0iB8CNITpyEKRw24CY9frbIzptI7RTieinUWc0WHoBhYRSPAVQTHMNkfeGDyMFNdywMsJdnlgYcdw7h9c5lBso7E5dHIQoMK397QqgKoDm3OoF0ar1NPCMlIl4ClUbR7lHGCgvHUsfiyRHFz0miQwl0VRnII123uDIcAC29ZC2Gt4AzDCKjK44CjEX4xGlIQBr1KFeyaEPW7W8WeZi5ZmyUtmsIfQZbDiu9Ls6Dbnncsq02HOr4b5RIaJNTFeQcDMqC6dHI2V1DeFPnvOUPCM7e52yd1l3mvEII7TVPXWwnRofmYZCsqz/5WQ7T/n52XXFNgUQ49ePoVpNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4062.namprd15.prod.outlook.com (2603:10b6:806:82::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 04:01:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 04:01:33 +0000
Message-ID: <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com>
Date:   Sun, 31 Oct 2021 21:01:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom
 filter map
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Joanne Koong <joannekoong@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
References: <20211031171353.4092388-1-eric.dumazet@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211031171353.4092388-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:300:6c::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPV6:2620:10d:c085:21c1::17cb] (2620:10d:c090:400::5:ee01) by MWHPR04CA0070.namprd04.prod.outlook.com (2603:10b6:300:6c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 04:01:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c64e609-c770-4e81-1784-08d99cec4b1e
X-MS-TrafficTypeDiagnostic: SA0PR15MB4062:
X-Microsoft-Antispam-PRVS: <SA0PR15MB406251C806670D24D2FF8CA3D38A9@SA0PR15MB4062.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uhx3DiDhpzxL50F9eEfhVLHdsNlYsk5zjNuB5hmp2uA8lJNNXZfuBi6blxqE8ipALtLa6zll1O2fqGHSthjX5w59G+xcEB1F9Z/4zRm3jD0m06NjLKaP73mb4f0JQb5w4O3YxAHgk+ZMBNoImnLwr3Wc4mpxEpyGAX5qqw7tszdSW6ZWTZMNwbRNBa4jaKCU4wEUgo6ja0GAGgQrlg5fB9GtkXjtpZCqYSxDKO1Ys08pTo+JfTladGIC4ytttHiyMb7JxdaCvkIRy4fXHhwB8+siyr6K4bcafQ079xP755gijR6HjVAh/ZUqkONTGAmj9PnsOTeWTSpXjdP4bC4SIvjvsVws/Q/5ueJwi26Pw4Eok3/InEZboKMBg5KiXe1PfxBhsxmrwyFINq6Tjudq1az2Wm1wFRI+Qtzl/zW1fpVmIMF6mVeCT5BtWpULIxcNwBgoy72oBnNcYoh51C0mf98T0Sbuk6xFCfKmMpJTxzYAcOisRVtMp1d7UQWR18z3Tw4mfYhM4C6dQsys6ktXZV0CLlEhAxdtzFrdu8pPNTPRCwcJ4LU08sOGpzo99mB/zI9c9ouMsDtBsZ4YDcvLmzKTDnMNnvaOsfh2WT6UDfQ1p72XCcpJ6++PL+/ji/b7/T62L+B+AzKZeb8fl+60/4YVvLb0FfVJRUGXYSshaI8kd/iSbEOX5YUlaIyGOHhEZDr9kLvVba8c7vRHL07bSHW8ILYus41CX0hs+yes+h0qxtjothlEGmxM0K/SdCbqy+rF3nwtMRkTkV6NRfa/8civJjTykNNH7ZORtdQ0BAb8mWnrh0vB+O+cdXW0i+3f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(186003)(316002)(31696002)(4326008)(508600001)(110136005)(54906003)(86362001)(2906002)(8936002)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(2616005)(8676002)(966005)(36756003)(5660300002)(53546011)(52116002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T05qZlhLT01ueDFFNVMrVUs4YWlzK1c2cGl3bVBDSEVXMXErNUtRcC9OTEI2?=
 =?utf-8?B?YTMxK09QRXBZQ2YzaVBhZTB0eStkVEEzbElvOHczbDEra2s1NXRHSkc5OWJr?=
 =?utf-8?B?aHJvcG0rYnV3MHAwWjN0R0gzS3BtL3dJSjd2V1FEYk9kYWJDV0JFR0VtOFdq?=
 =?utf-8?B?d3kvL0FheEEra05kelFNbmRNYmlMVnV6YVhkWDlTbGhvMzdqZ3RtdFhoamJG?=
 =?utf-8?B?aTg2Q3ZWd1dNZUg4cTd1YTN2TzBFekJlS25ON3JNM2UwZWFjbEV0MWFKTjhD?=
 =?utf-8?B?RnZjN1RIZTJzdG1lVlcvdkJnQ0RLTEZCZ1pYb2hINXZrSXQvN3NHeHgrbWI0?=
 =?utf-8?B?TEdWK1UxZGdVSzhITlA0UVR6ZXgxbDZHVGpuS3hZV1l1M3dJdTNRSjIzMG9F?=
 =?utf-8?B?cWRhZm91NUY3eHFqa0dTMVdiL1ord2FvL3RxZlJXMjVOWUJrTkFOcXNYY2x5?=
 =?utf-8?B?ZWtxdjc1OUtDVUQ5SERLK3pETHRnMElEM2k5N2FvaXlydmJOVCt0T3cwWk9H?=
 =?utf-8?B?NlhjNW03aFpzalViQ2tNQkd2OCtTL3MzeWxYc2tQNERDbFBYZDNWcnU3UzFW?=
 =?utf-8?B?YjltY1YycHVXbzU0OUtlQzZZYVc2RHJEWEQ2VTlpbzRJa0VDd0tBS2ZlVHIx?=
 =?utf-8?B?ZWhad0ErK1J5ZlhpUW1IbStjVlhnblNkT1JISDBwbGUwdksvcHBuRzJvS2JP?=
 =?utf-8?B?bWl4Z3dIUktpangvK3pzc0ltNnlnNGlmYW9iVmRqK0lidzd6Mzg5SUJzZGxS?=
 =?utf-8?B?RnpaOERUa0RMMUhOWWI4VU5HR1pOY0pzbktpMUVzaFhyQW4vSHpIUFVkcWkv?=
 =?utf-8?B?WWErdUtDcldnT2d5RS9PbzRxTlpTWFJsNGgwdW1iZ1RHcGxPaHBwbzQzNlNm?=
 =?utf-8?B?dXpjclgybGd4Z1ZxM3dhZGhkQlVYZmdBSEw3K05HMzJlanRrM2xxd0QvRDBE?=
 =?utf-8?B?L2M2WG13aHZlY0Vxd1pIYzh4NGVBVFFBeDRwRk5MVUgxa2RuK1hJTmNjWXdj?=
 =?utf-8?B?ODczUlJ4VTY4YlllYWZTcSswMnVsRXIyWFFlWkwxYWdUM0ROajl0elNVVkU5?=
 =?utf-8?B?dCtuVTE1Yi9sZy9sMURld0pCbkt5djZjRnFjUXhDOFE3UlhMK0JkS2Q3RU55?=
 =?utf-8?B?aUNJaVBCN3JNM25DUXpCNDFZLy81TXhlUWFsT1FPYk1xR25JUUE4MldsT3p3?=
 =?utf-8?B?Q0lEM1pCdTloRllFUExmTWpDcGZSSzV2enJnbFFhWk9TZ2F3aHpGUjl6Qm90?=
 =?utf-8?B?YXh6NTFIL0Z6OW9XMW05endiTStpZmFybUY3NndIbmFScDMyRDZaamtqQlI2?=
 =?utf-8?B?ZlZQRFJ2UWp3Y2F5bnJ4ZUs3bFY4c0lNdkFGMEFaZHBaL1poZEVaYVJRZytL?=
 =?utf-8?B?ZDY2MkovRmsrZDlKQ1J1UlBRV2M0L2hyUWFxTysrYVlXNkNPSTF0N3VyMldN?=
 =?utf-8?B?cDFWNituS2xuUXduaTFwQXM2MmxXOUtkRTB6T1lZREZNNHZHTlNXcVoyTXc4?=
 =?utf-8?B?NjNjZ0dNTFc4VWxFcVZ4R0VXSDI0US9XQVdnOTU0S2hpczZxTHFVQ200Nmpi?=
 =?utf-8?B?Y0Nvd0NrUjNCcGxPdjNHUVU0L2huRm5WYTJ0ai9YYlFBOWJ6MSt4QmxyTjBs?=
 =?utf-8?B?UldXL2dwWmpMZXRqOTROSTZ1MXlPM1ZobE1kUi9iVzdOT0xIQUdqRktiRk5z?=
 =?utf-8?B?NUtUajV5OVFSblAxZUtudjluTWhWRHByM013VWNkYWlJcnJNeC93VXNwaHFK?=
 =?utf-8?B?WjQ1N1UvbnJDeFU5d1dWcU9ubHJTb2J5TDJ6VU15bFdNaHVUZjFuendyREto?=
 =?utf-8?B?RTM1N291ZGZ4TU14QzlwRkV2M2tydUJJaFh6c1dGaXowOFhhVnFBY0FCRkZj?=
 =?utf-8?B?ZHBzTmE5QTRTV3FDaC80THBibyttQTFIbGZsSGtXWmtqMnJnOE1UcjhVL2w4?=
 =?utf-8?B?bCtOTXp1Y0ZneElkc1NmWEpZSjZUTUt3YmpOMG50dXlkd0FvZTVQMjloNDFM?=
 =?utf-8?B?Z2tFa2dnRVk1bXdLa3BKMi9UR0ExT2ViekFrOTdMaEd6QktHM3hwZWFYM0Rh?=
 =?utf-8?B?VFEveHhPbjBBbzlxL1ZEZEQycFNROVpmOFhGV0JTRFB6RWtiU2pTTEk1ZlNF?=
 =?utf-8?Q?1VwQXvV7HEjS28sXqCl48C5sR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c64e609-c770-4e81-1784-08d99cec4b1e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 04:01:33.7883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9BiRW6UIdcn1+C69cM7k4pbyKjdjbANvBgVyRJwAb/f/0os6r1nKxMwMKRi/kxa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4062
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: _ScH26BKESU9EVmFQ08raWMcYNuBOXxL
X-Proofpoint-GUID: _ScH26BKESU9EVmFQ08raWMcYNuBOXxL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_01,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 mlxlogscore=898 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111010023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/21 10:13 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Without it, kernel crashes in map_delete_elem(), as reported
> by syzbot.
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 72c97067 P4D 72c97067 PUD 1e20c067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 6518 Comm: syz-executor196 Not tainted 5.15.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffffc90002bafcb8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff92000575f9f RCX: 0000000000000000
> RDX: 1ffffffff1327aba RSI: 0000000000000000 RDI: ffff888025a30c00
> RBP: ffffc90002baff08 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff818525d8 R11: 0000000000000000 R12: ffffffff8993d560
> R13: ffff888025a30c00 R14: ffff888024bc0000 R15: 0000000000000000
> FS:  0000555557491300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000070189000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   map_delete_elem kernel/bpf/syscall.c:1220 [inline]
>   __sys_bpf+0x34f1/0x5ee0 kernel/bpf/syscall.c:4606
>   __do_sys_bpf kernel/bpf/syscall.c:4719 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:4717 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4717
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> 
> Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Joanne Koong <joannekoong@fb.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andrii@kernel.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

LGTM with a suggestion below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/bloom_filter.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
> index 7c50232b7571f3f038dd45b5c0bd7289125e6d43..31a7af15a83d74af1d88d04cc8d71aa7d403b4ef 100644
> --- a/kernel/bpf/bloom_filter.c
> +++ b/kernel/bpf/bloom_filter.c
> @@ -77,6 +77,11 @@ static int pop_elem(struct bpf_map *map, void *value)
>   	return -EOPNOTSUPP;
>   }
>   
> +static int delete_elem(struct bpf_map *map, void *value)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>   static struct bpf_map *map_alloc(union bpf_attr *attr)
>   {
>   	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
> @@ -189,6 +194,7 @@ const struct bpf_map_ops bloom_filter_map_ops = {
>   	.map_pop_elem = pop_elem,
>   	.map_lookup_elem = lookup_elem,
>   	.map_update_elem = update_elem,
> +	.map_delete_elem = delete_elem,

There is a pending patch
https://lore.kernel.org/bpf/20211029224909.1721024-2-joannekoong@fb.com/T/#u
to rename say lookup_elem to bloom_map_lookup_elem.
I think we should change
this delete_elem to bloom_map_delete_elem as well.

>   	.map_check_btf = check_btf,
>   	.map_btf_name = "bpf_bloom_filter",
>   	.map_btf_id = &bpf_bloom_btf_id,
> 
