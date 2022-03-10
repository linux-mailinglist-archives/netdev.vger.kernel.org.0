Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C392C4D5367
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbiCJVHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 16:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiCJVHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 16:07:54 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3468190B7D;
        Thu, 10 Mar 2022 13:06:52 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AIBEv8029882;
        Thu, 10 Mar 2022 13:06:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1DuT8Ar5T3uqn1vCJ4f5hM+afxAPiaJyBtsLSwlB4+0=;
 b=al7lpVZAFN6UKtdNU8NbpsCCXLfdyMY9ucXTyGjUF/TzT6MI8sg45fRPLHMCNYasyTqC
 v+6E5FN2pcWr7yguZwO0mYqlcw7Oc0Btlf1HHye2SFWD80qfglk20lYVzlcY4vkrhyui
 KTONRJ0COioEKY3C7hwla7BX+si09tNXfKI= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqee3cvtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 13:06:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsBpo6QWLhvbmpPg8vdilIt4wyRQGlobySuRq+l/vTuaRLe8t+grQWQrshoHhAYaq6l5eJ0/buOWJqhozJw0gakyEQRyOebY8uEyi4wHbMntOTXcS4+qz7wZyH6n1pd3/DvsXE6wHKS2xRa/lmsWWcg+XSG+zBnJ8T4z9smKz1TqTyxaseS8WxORK3B2Lw1rXepOqlHZNQBwLJ3A5HXFgmSdnFKRgKiWCcBqncHrS04eKkXCjmbE61XGW9NQexwDVLM5heTDTObR87RsOr7b31kRqxYETGvDVuPyTo4AKrBOi6pJF/2IwX7iSQ36rbgEwB16ROySAYvS2CcyuVSM7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30DIo4dzd9DnvR0UCrpQHS+GgJmHhUaJ8M9OKConSho=;
 b=lnfUcglx1QMUHJ3BRriBsFhoaXgevU26c44TA8hPpl4VGybpNsX06wrJnnlU6eLmzwUI5+i+RM74SADj1Z/8JKVqQkIDLUQ1/sEMKkBGEnRz20OsLFRZCqwfKC6JOF8+JVIyRHtxN2h+ExgmTK/ivj8d9/91AYEE5rEDf47uc2s+WGu89IrXTTZjv2WvxiJOakhF2PEy/ybSC4dLLTTJg0ieTx2gYP+fNh+dOnav1krote1goznBdhEyWI6FcXTttDAMSXd/4vggPgGa34vFg62AY7NiySuVNd1PhqJxoOVYexIfha5fEIgEAiaHylZKw6IbQ2he13Oozbcr+bp0Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MWHPR15MB1440.namprd15.prod.outlook.com (2603:10b6:300:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 21:06:30 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 21:06:30 +0000
Date:   Thu, 10 Mar 2022 13:06:26 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     toke@redhat.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        syzbot <syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: missing reserved tailroom
Message-ID: <20220310210626.25o2mll3jmp62swy@kafai-mbp.dhcp.thefacebook.com>
References: <00000000000019c51e05d9e18158@google.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <00000000000019c51e05d9e18158@google.com>
X-ClientProxiedBy: MWHPR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:300:95::15) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d69b8865-f657-4f79-07ba-08da02d9d947
X-MS-TrafficTypeDiagnostic: MWHPR15MB1440:EE_
X-Microsoft-Antispam-PRVS: <MWHPR15MB14408F829F64C544C5A3DB12D50B9@MWHPR15MB1440.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p5ZFXZGPazga2a9N88J8qBL82qql/VHz8jLVgd5t6py5CvzTg6cNByCmjzb/g0FbFAXhwLpqdtEZDm/jA7fZ+jKSn0l8NZTbgCKqROfgu/Ryn8MLtzj+8YYZ05U7N3ApK849Km13Wa4AQ2O9csyvT1KRwAu3QShsiYJ5mkXpRskxRYUxIkGaA2NRnEtcju+2yuKkM+XbLT5izSK7nyAkczLWMM0NcTXBxsSNqqbIf0CYt32eB59R+gx9xW1aDVJlWroGFBwU3+ZseLTWA5GAL+1qzWtzik2AOoc8OtbeXBIMmcO4yeSjyMRGXBY/Ryo4C19tU5jrYAZvR/U9O6xLoOt1sK5o2rvql4Kz9eN5qkYi/qzwlu/QDdQTGtcRaUsaqtDWRQz2r6S3LDC7gVEhOafKctjnPf2qTdNBf1xc9Ngfz9UlbR637hqtm4+45EeDedLsFHKJ1VaedwHnKQ2lIRqMvyyEklTfrX2yCrGFiVDUj9rETYG4YlvHKaece5fnUqd+OuQ4LA17/kmRhY2urdXdkGwJVLIdwQzaNw+ZXc7T1Qt0z9vZfnc2uQXhV+6mIlW/i/vZoCabW+OafbjJKvL3nhtkwl1iHnHoKf+Hhh4LNZLINpAENEWeT+J/hITnT7VQUBpdwapN/92EA8f/s3XluOT077Fpt/xcu8RqDK37aBvGzHq4h8d+elsR45+yH53bABHfrPMat9QfjUDUIcij0OkPFMtUTc49M3Gzhg2Co/3o3FbAsNg7fkKPrOsAkOi5y1RU7w7cXyCsidPlLSCgByeV0rf9duxILdKCYWdWXWnN+oR/Av//3/+0bLy1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(86362001)(966005)(66946007)(186003)(45080400002)(6506007)(66574015)(83380400001)(1076003)(52116002)(6916009)(316002)(66476007)(6666004)(508600001)(66556008)(2906002)(38100700002)(7416002)(5660300002)(8676002)(4326008)(8936002)(9686003)(6512007)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?G3dxou50/4g6Nm8aG/Xrtt4Pvsw+DCmezbJcNuDHn7DFrnlN74V+0GIuRV?=
 =?iso-8859-1?Q?tMYCkqlq4nbg92jYaid72Dd/+P22OqyiFhRb+SFUwQOBDMUj3fbuejZbOh?=
 =?iso-8859-1?Q?OfsVvBkJibMvYtSwsY5k1WxPURjBCKt/DzYFGtFxQRnqiQECQLDdr5UoVa?=
 =?iso-8859-1?Q?yZ/Bm44NAudtNyQCa2mme0pr3XvDMHan/XDiOCzxduLvaZ0bPQ+l1r/jNC?=
 =?iso-8859-1?Q?BBlPdj2310Gcd7Ws/bK116icAY3JLA8Y2axWjni01BAs1MfOq472lOLIKO?=
 =?iso-8859-1?Q?N+hqpePI3KOTx+GAJXrTqi5ubBlC1etD/45bsAx1JKXlUjL9aJbtY7eNMg?=
 =?iso-8859-1?Q?lHNXoMhTV1f+ywQO3ifzw+RncRNgZMorPPIu8QmTr7me8YJG9c9cv6QaRx?=
 =?iso-8859-1?Q?FCrHYb6cA21coXr8avnKJUxWoqzz+QgRb9CYJkuBMAvpAtPFNIhdwn6/Ny?=
 =?iso-8859-1?Q?VRhJvUULgHQKJJpCHqJ5O2WJ4jGMjQWsJSXt4rzIjPBuQxO1FGjIQFJ85h?=
 =?iso-8859-1?Q?VPLqe83qut+g5el/9qToxvd558S1aWPtFgHPiR33jmsrVBzjTXh/N27J++?=
 =?iso-8859-1?Q?U9QahD/HRziEabRfFc7S09g4DfEjAGp6izSytNM3tgXK77ftVDtY8caZTe?=
 =?iso-8859-1?Q?2pbQ+e/3iqsM/MwV8+Aofgd0mhYXa2Ivr8nNRYdR9JFQJPrL1MiqtY9w3R?=
 =?iso-8859-1?Q?3MZqwetNSQYq3R2euL1dnQSrg3+3pyT5yWbh6Mww+7zTHN2c1oUY/B5bpJ?=
 =?iso-8859-1?Q?8w39F5Zs/mBZq+Rckdv/71NcD8rkZGbgaBfVFCEkIh2RgC5dzpfrLuAEwD?=
 =?iso-8859-1?Q?/1wKRt819PtAo08NRNa0wZVpR0FubpOcfXyreRg8W4+3U2FjP5s0+CCAbE?=
 =?iso-8859-1?Q?xgbNgg/UMeyl4Aii+9mtxS6OI6isPaKgTptPCryVf8JIkLzqVDoARPOe3c?=
 =?iso-8859-1?Q?UEprifZinIVsuQBTFZ7y1umP/6287ejKpoiPL5umZ2m7ctuzvq0qzzpeD5?=
 =?iso-8859-1?Q?qdusuLJ0JQ52R2cS25JS+JZJbHt4Z+h6K6V66U09UJnnSjfAsr7tkv2uhD?=
 =?iso-8859-1?Q?I+YouoaasFzTCHhfrZpf/4pPFWHuHkAMCV5pxek/7kc9Q0DAsP1F+/dRnS?=
 =?iso-8859-1?Q?cY2g3QXI2p5f830ubcsuD+vnCypDTzQV0mDCx+OBLNerXw118dgKPKdLpj?=
 =?iso-8859-1?Q?DXfRcs0+jyjp4+mc6X1ncOhsoL4LMTAMdgxvzwNHxY5erR4kinCCIYhiu5?=
 =?iso-8859-1?Q?F7SL8QQd4tth3OQL480M/Llpwoup7EdvwqKnGtOVDco+aXsGPFVjv3VVr6?=
 =?iso-8859-1?Q?KqvH2pc1tpIgjMTxqhGbdArTvApPKM6RGiwMmKuFI04Z49cBtrgNFz0Kt7?=
 =?iso-8859-1?Q?vNqUQP52AXmCJ5I8Cgf87I6w0fd1yFQI5VtnAONa18fXNryCQ9fsF4hPee?=
 =?iso-8859-1?Q?3mkc4yOXFKnFZURet0y4PhhxVy3RpvhgpJ3Unm5Z1TFKnqqEpKe5RY9osE?=
 =?iso-8859-1?Q?XhY7uO9HdfvzwZGuZTdMMn/26HqmPEvhTloM/XVOFJUA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69b8865-f657-4f79-07ba-08da02d9d947
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 21:06:30.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5Af5J7ySOohKhqfmPpy5IAaQZsoSWP4ATTpM5uU19q7b0BYj54PK39k6homUCHq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1440
X-Proofpoint-GUID: j3cuDDQLVj1ynVDOwrQ3nJV8ZFsoANIe
X-Proofpoint-ORIG-GUID: j3cuDDQLVj1ynVDOwrQ3nJV8ZFsoANIe
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 10:37:20AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    de55c9a1967c Merge branch 'Add support for transmitting pa..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14ce88ad700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2fa13781bcea50fc
> dashboard link: https://syzkaller.appspot.com/bug?extid=0e91362d99386dc5de99
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f36345700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c8ca65700000
> 
> The issue was bisected to:
> 
> commit b530e9e1063ed2b817eae7eec6ed2daa8be11608
> Author: Toke Høiland-Jørgensen <toke@redhat.com>
> Date:   Wed Mar 9 10:53:42 2022 +0000
> 
>     bpf: Add "live packet" mode for XDP in BPF_PROG_RUN
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17696e55700000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14e96e55700000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e96e55700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> 
> ------------[ cut here ]------------
> XDP_WARN: xdp_update_frame_from_buff(line:274): Driver BUG: missing reserved tailroom
> WARNING: CPU: 0 PID: 3590 at net/core/xdp.c:599 xdp_warn+0x28/0x30 net/core/xdp.c:599
Toke, please take a look.


> Modules linked in:
> CPU: 0 PID: 3590 Comm: syz-executor167 Not tainted 5.17.0-rc6-syzkaller-01958-gde55c9a1967c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:xdp_warn+0x28/0x30 net/core/xdp.c:599
> Code: 40 00 41 55 49 89 fd 41 54 41 89 d4 55 48 89 f5 e8 2d 08 3a fa 4c 89 e9 44 89 e2 48 89 ee 48 c7 c7 80 ea b0 8a e8 ef c7 cd 01 <0f> 0b 5d 41 5c 41 5d c3 55 53 48 89 fb e8 06 08 3a fa 48 8d 7b ec
> RSP: 0018:ffffc9000370f6f8 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff888018d8a198 RCX: 0000000000000000
> RDX: ffff88802272d700 RSI: ffffffff815fe2c8 RDI: fffff520006e1ed1
> RBP: ffffffff8ab54aa0 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff815f895e R11: 0000000000000000 R12: 0000000000000112
> R13: ffffffff8ab54780 R14: ffff888018d8a000 R15: ffff888018d8ae98
> FS:  000055555694a300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001000 CR3: 000000007255a000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  xdp_update_frame_from_buff include/net/xdp.h:274 [inline]
>  xdp_update_frame_from_buff include/net/xdp.h:260 [inline]
>  xdp_test_run_init_page+0x3f1/0x500 net/bpf/test_run.c:143
>  page_pool_set_pp_info net/core/page_pool.c:268 [inline]
>  __page_pool_alloc_pages_slow+0x269/0x1050 net/core/page_pool.c:339
>  page_pool_alloc_pages+0xb6/0x100 net/core/page_pool.c:372
>  page_pool_dev_alloc_pages include/net/page_pool.h:197 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:280 [inline]
>  bpf_test_run_xdp_live+0x53a/0x18c0 net/bpf/test_run.c:363
>  bpf_prog_test_run_xdp+0x8f6/0x1440 net/bpf/test_run.c:1317
>  bpf_prog_test_run kernel/bpf/syscall.c:3363 [inline]
>  __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4665
>  __do_sys_bpf kernel/bpf/syscall.c:4751 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4749 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4749
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fc3679a71f9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdd3b6d268 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc3679a71f9
> RDX: 0000000000000048 RSI: 0000000020000000 RDI: 000000000000000a
> RBP: 00007fc36796b1e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc36796b270
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
