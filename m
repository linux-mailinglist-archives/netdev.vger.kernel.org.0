Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6624AC84C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiBGSGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346159AbiBGSEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:04:00 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE5AC0401D9;
        Mon,  7 Feb 2022 10:03:59 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217H9Z5K009304;
        Mon, 7 Feb 2022 09:24:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yWBT6xgztT/xbZVl6bnBjsRXCtHbH1Iy0YYSswWCZE4=;
 b=PgA4KxKJCYNzrXtJb+NlD7h+A7yZkV7LmCWPkBACskJsY3ac7vHHbH2eZoU7yEKWu7Om
 E0kyLUleDn9GHoCsYITnqCS8lO5PWvgP8RXvMDHTN1oOly7TLzmcRKhoFTfDw40l5SVO
 OZfQWGgqrEQGJLKDhOlmv4CNJc3bEWXXtMc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e365cgu4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 09:24:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 09:24:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjqbxGsH/TlGPP3wFGUtPmhPVTFNrZZBx/0w3EWvr0jFpbTvFx4li2xgW0fY3WxEt2E98VKQvxx+cWBvvWFEWWWKI+bGIuVhJ34huplTt2MZBsyXMpy+N7zoz+wPkn8Hjc+u1NoetHX9MoKTgX3IHV4kKnaHKGJ/5j3hwSV5UUZHa4fjG6Fw6uaVxDIKbxKP+7Y2AKCe+VR5PISd44V+6jrLVFMljewDKyfR2AgTArR1B27qpiu/sSpR4cchqJIq5B8cIc6avYE2ZGVsat2dRD6Cragrb6yglBsV8uAZlmNdftgUp5T0mQQ4ZoQ35XUKR5xiX7Aup8kw9/WVq6zI6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWBT6xgztT/xbZVl6bnBjsRXCtHbH1Iy0YYSswWCZE4=;
 b=SZGmjBK9jsVSYSyIKu6IP5tta+7REI7yzn0yPanTKBESObRv7eO4vWukJXAo8QfTuEXUK1i2T/zI/MMYXx7YESdwW85An/KlIx02njDYfqn5Fp3vh3eeQYN/FlksnNo9AEobpTWnao5v+Ph3ZsCd/Ry0WSY+139HLRBb3oPVQeTXfbKJ2fjjj8BCLt0FLmIi3l2QMVxJnxxyW5SYMtoivsZEe6JpaNi8h60H5vL5QswBamzewTpgPdL1hi6cOeNLweCzd6evdklqa40ZhtnsPrdUd86ZlxCMwDA4XZN41N4WGZfLcYLhIEHT/DFttkOk03MWIBvMEtYQ0EEg4ObpGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB2753.namprd15.prod.outlook.com (2603:10b6:408:c8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 7 Feb
 2022 17:23:59 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 17:23:59 +0000
Message-ID: <b87a7735-3303-3797-535e-a7753cc21ba6@fb.com>
Date:   Mon, 7 Feb 2022 09:23:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next 1/2] bpf: test_run: fix overflow in xdp frags
 parsing
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
References: <20220204235849.14658-1-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220204235849.14658-1-sdf@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1701CA0023.namprd17.prod.outlook.com
 (2603:10b6:301:14::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ed4511d-01f8-4b40-84be-08d9ea5ea091
X-MS-TrafficTypeDiagnostic: BN8PR15MB2753:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB2753D6E241E0829FEAD67445D32C9@BN8PR15MB2753.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+i8Lmg7hUL2p4OcyIlYYp1jx5XjFUH47wWFsipQo+2Da8nTpv1wqBhgccZ3735MccXESywoTGcKj+99YAHWZL+T8KumS/b1GRWgtpRSYlfXrZbRFZHtZ/IP+gCtekrDoVn102u5DKn2a4L7kWVE3zs6R2LE4MkYggAZbWWT9Jx/Qb748mCDepvvLt0LtC3xswXm6DYuiccDAaVM2C4bv/PeNqQfecrsT2D60OD37NBc4afspIyWJHruPFCKLYhrlPB6fmFOWSFdw6lrL436rcP4axV8o4p9uED1L+RdHkquTLvFm8++QMRfzGO4zUeImbKhSLzXNTheUPHiPE4MQXaWAIgjcPV8B0919NO5RUtHlc+WwpraezU0FmTBaAoZyDLsnzTJOlKiT4efLrAls1SdDQIsMF7HrA+lGJcKH/70KoSYC9jZgc36xj7QADgs9nUwL2IZ2gUqvzTC828KzNRatPsXMntEoW+syJwcUO6TWQKp24FNK5zrEV/u8HnuoEPXLrNJ6oT2r3EmX0Sz58VSVU7F2FJIK4ZWcsuCotQc0F3fLUYp3mIdbBJNqyL5U17NFordaW6P+lEChWPccXG7HcQ//XpO3TE0KCXCDrW/bw7r4Jshz6CTxiYiSQgJJb2w2WHfmI1VHH2h6BynhQRoSLFFvbpvmTQKLUpP4/mfPQpd0HOAKEUc0QycG1SHwEqSh/2lcwH6c0+Lqyp7SUFG30oHDCFf38NAHXo/Hn0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8936002)(8676002)(66946007)(4326008)(66476007)(66556008)(83380400001)(6666004)(86362001)(52116002)(53546011)(6486002)(508600001)(186003)(45080400002)(2616005)(31696002)(6512007)(316002)(54906003)(36756003)(31686004)(2906002)(5660300002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1gwcXdMYjIvbVhOUHdGRDhXMHhoY01YdUs2VmsvMFREVHp5SnBKbllyV3lx?=
 =?utf-8?B?Wm5RcGNnRnhkamQzVzlqaXBKNmhrQVVUTTZyVUNzR0NDWGt4RXg1QlZYWThp?=
 =?utf-8?B?dzhUV1p0TTl6YVJ0cit1alFrYVBxVFZzK1pEZzFnbjVyckJtZzBva09tbExF?=
 =?utf-8?B?YzVGTDllY00wYUxpU0pkOU4xSGhMbjVzdExXamdNQWlSTDNVVGlFQk9BUWt0?=
 =?utf-8?B?cU01QWRYd2JmdFhrYjBVc21SZGRpcXByaThySWZIMlVqTTNDZVJkRnFMVW51?=
 =?utf-8?B?SXM3ZTlheVUvVEMrY09IMmlYZmprcGxuZkQ3Smh5VXhpc3pvd1Q1S3hpdzJl?=
 =?utf-8?B?OWUvUkJ6VTZCOUJhNVAvSGhIazhiaDdWYzJyMnVKT1VFcVNPUnU4dW5wbkpp?=
 =?utf-8?B?NVRJTzdyNDdrcXYva1ZBSFJGSlFLU01JZ3piSzFLM2dJR09WZlVoS283TlBV?=
 =?utf-8?B?cmZTeE5xbDJUQkRBNFhZeFJ4bEFEdWUxdjNldENEY1Bla3EzZ3JkcHVLblRI?=
 =?utf-8?B?MzhhYkkrRG16SG9NMmp4SndCaUtIOXRtYm15a2UwSTBsUmVkRkpqb2FGbGsz?=
 =?utf-8?B?ZTlKNis4cUdlRzhvdUZPZ0g1YTNxbmhQU0hCSmhvY3ltaU4raXVlZk1LMy9K?=
 =?utf-8?B?R0xBaUJmZ1pBMmFFYWdIaVMybk1kWkNJcERCOXAvM3M2ME5xbVFhdE5SUDZs?=
 =?utf-8?B?Yy9OOXFpaFI5T2F4UHhud0QrTU53RXFValRBWktYRmtUOFd3NUJOR3JXOS9l?=
 =?utf-8?B?Qk5XNmRxMlJ3YmdsTi93OWsyWnZhdlBjVmZtMHkyZ0RFcDBHeGJESk1VVEx0?=
 =?utf-8?B?cjdOOW16dUtPbWpCODNwaGxwU01rWDU2bm1EL1BndHl3Nk9VNzNxdVA4Z0Vo?=
 =?utf-8?B?RkxiL0hTeExrYldpODhXM0xkcEdZSDlESFpGa0JqK28rMFY4QUlpWGlEbUtC?=
 =?utf-8?B?YXpabjh3MHZNVHF5eFo5Z2J6d1ZsVXNzUUR2Wkl6cHdWbGUvaWo5YTNoWk1B?=
 =?utf-8?B?RENGR2UvOUc4WnR5ZmdjVlYwZTMwUHRtMnBiMUxTN1djYThzWEVKOWdXZTNU?=
 =?utf-8?B?aFBINS9mVEdYWUt1TWgwcXRpUnc2T2hhUHAyY0F4WkNNT3lGT1h2L3VqREU4?=
 =?utf-8?B?OFdER1V4dE8yWi9XcVUzSkJOWTJDT1hVcjZwbnZKVmlsR0FsM25EU0lOMjRu?=
 =?utf-8?B?T21WYzIrQXhUZ0xwdVdTdTYvKzVuTUhweUk3QmtSY2xHUnVXOWhDQlZzbDh2?=
 =?utf-8?B?bm1GOHUyc0psRzBiNkU2U0xUVjFobFAvaHl5dkN1MVZaTEo1Q1Zxa2kveDlG?=
 =?utf-8?B?SWJER3B2U3ZTb3dZTC9KOFBBS0Zrdi94N0FKQUw4S2NrbzdaaG4wR1REaGpB?=
 =?utf-8?B?UGQ4Y2pkRjQ5c3o1SERvalk5ZFlZVVFvZFlVa1BMY0svcG9IWmU0SXhsT2xY?=
 =?utf-8?B?bWtTaDg5TEQ5ajhoRFQ5dTVhZ09YVk9wTEkzV1pSVUdsQWZKUkxyNVZsNzIz?=
 =?utf-8?B?RXpPeWdEbG9kdGJIVWhtZzY3aEcxOVVDWEcrYU1rNWdWbUlNdHlrRndwaEJy?=
 =?utf-8?B?YzhHMG11RE9JUjBPaGxCbEloM1pJUGZmUjIwSXF1T2lIMVQ4SFp3REJNVXJC?=
 =?utf-8?B?ZDRVNzgwM2FnUzIzL2F6Wk1oaE8yYXpHb2t4cExyQzMwRFpFN1ZuYkV3cmI2?=
 =?utf-8?B?L2pMMjdxaHF4cG5Jdm9tTnVMb0dJc0o0S3djL3EyQ0JyVi9aTlRYdTl5TUIv?=
 =?utf-8?B?QkFTWXNOUG9NaURrNEF5TkVqSWdlT0hLSXpjTE4wbUlNalE0UFJqU094R21R?=
 =?utf-8?B?ZFdZTVY5ZEwyUGM1SkY0U1BwTWR5cm9yTjQ0bEFaNWwyWlBrQ1NQMThMWExE?=
 =?utf-8?B?VjhoVWxiQ1hwSkkraU9MMjQ2TE1aanVXalBCUm9GdzZ6TlEreCt5VWR1Z28w?=
 =?utf-8?B?TU03a0sxbVFCa1JhVEJWNEY0djk3cUJtZnA5SFR0cTFlTzBBUkdjZ1VuL21Z?=
 =?utf-8?B?Y3B4ZkR4c2x0TFpVdWh2clp2THhsZFFHZlp5MnZXZ1JCRVoxSEFMVWlUSmJk?=
 =?utf-8?B?N2t6b3RYakVXT0loVXNrRm5ZcGNSaWYwaG04VUxjRkVQZTdjSTh5OWhxMHI1?=
 =?utf-8?B?c004OHA3UWlOeUw4cHBxNkZTVWtUeDZjRDhnWDlKM3V6Y2oxTHFiT2M4am1j?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed4511d-01f8-4b40-84be-08d9ea5ea091
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:59.2602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vyGE3ODeI646Z+Ddhm40IyL3tfX1YIJnJCLnL5ZKYM6dunSnO7GTGdGX6XycKTl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2753
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: dy3cIuIRlWffrkqYgIpqY8-RxiVEyf-A
X-Proofpoint-ORIG-GUID: dy3cIuIRlWffrkqYgIpqY8-RxiVEyf-A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1011
 phishscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=701 malwarescore=0 priorityscore=1501 impostorscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202070108
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/22 3:58 PM, Stanislav Fomichev wrote:
> When kattr->test.data_size_in > INT_MAX, signed min_t will assign
> negative value to data_len. This negative value then gets passed
> over to copy_from_user where it is converted to (big) unsigned.
> 
> Use unsigned min_t to avoid this overflow.
> 
> usercopy: Kernel memory overwrite attempt detected to wrapped address
> (offset 0, size 18446612140539162846)!
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:102!
> invalid opcode: 0000 [#1] SMP KASAN
> Modules linked in:
> CPU: 0 PID: 3781 Comm: syz-executor226 Not tainted 4.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:usercopy_abort+0xbd/0xbf mm/usercopy.c:102
> RSP: 0018:ffff8801e9703a38 EFLAGS: 00010286
> RAX: 000000000000006c RBX: ffffffff84fc7040 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff816560a2 RDI: ffffed003d2e0739
> RBP: ffff8801e9703a90 R08: 000000000000006c R09: 0000000000000001
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff84fc73a0
> R13: ffffffff84fc7180 R14: ffffffff84fc7040 R15: ffffffff84fc7040
> FS:  00007f54e0bec300(0000) GS:ffff8801f6600000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000280 CR3: 00000001e90ea000 CR4: 00000000003426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   check_bogus_address mm/usercopy.c:155 [inline]
>   __check_object_size mm/usercopy.c:263 [inline]
>   __check_object_size.cold+0x8c/0xad mm/usercopy.c:253
>   check_object_size include/linux/thread_info.h:112 [inline]
>   check_copy_size include/linux/thread_info.h:143 [inline]
>   copy_from_user include/linux/uaccess.h:142 [inline]
>   bpf_prog_test_run_xdp+0xe57/0x1240 net/bpf/test_run.c:989
>   bpf_prog_test_run kernel/bpf/syscall.c:3377 [inline]
>   __sys_bpf+0xdf2/0x4a50 kernel/bpf/syscall.c:4679
>   SYSC_bpf kernel/bpf/syscall.c:4765 [inline]
>   SyS_bpf+0x26/0x50 kernel/bpf/syscall.c:4763
>   do_syscall_64+0x21a/0x3e0 arch/x86/entry/common.c:305
>   entry_SYSCALL_64_after_hwframe+0x46/0xbb
> 
> Cc: Lorenzo Bianconi <lorenzo@kernel.org>
> Fixes: 1c1949982524 ("bpf: introduce frags support to bpf_prog_test_run_xdp()")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
