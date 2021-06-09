Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C393A20E1
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhFIXnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:43:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64856 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFIXnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:43:23 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159NeR95000705;
        Wed, 9 Jun 2021 16:40:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Du0sY51MRIhSmoiC+kepXyELz0s0ft0Wd/yNkGn481Y=;
 b=btRwceTqg2s+CO8K/RvYXYbkh1zebeQYYGWw+LGYVFJlXpkr8lqts9u+fWzQkJpdwR85
 f5RCk3hxRBrxz44rwn94hxt1udgTf2tM4euIcwLCO7K27/iW9SlcFhC1y1cn4QxCLwoi
 L/JSWQIYcg2Sp+xBALR+tPqFgh7sVG7J+pg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 392qx66003-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 16:40:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 16:40:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVWS9CSEa9tqQptxbuLExNxBfe8n1tX118Kqy80E8dOtnwpXvqN/W4E0EqkkCAY7cW3HmEq55vf+gphYzL4vkDwyr4rsVg+uBYmPjcEPuo2jZAlCoEg9wyyag6XGhTdktB92hgUrirPPzcj3tHLO37uUL9Za0Vg75Obk3xqPFlUp2HgfyWzgiJFbhDx6aYxttOm1XlXt6lL7Bxx+hYHU4F7+q0jnvkQPrO++9LJSrocUkcsK9W0Bql6+iWXTsQFRltYemcxVXrYUMjCttOs16oA7P5if+xWSvU+zGDnQuMeCPzoZGQLw4JqsKBPkgmQMXhpYfP63rf+wt4/++t3GtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLm8UJJcf/u86UsQdjfqIjRuDBg9IUXiPfmTBObf0II=;
 b=EZe9CI0AD8yr6bqL2enilfiN6ody00kIj4GU4clJ7j84rQbCyaeU2vDm8NEBU2ryo6teAzJn7TmOjbAQAxfv+ECfdLKakCjsC8EtNUs7i9SvTWrBxefoPLENnvR1U3mlqFlQw2FJ4qufC3DDZNfCKVlFL9bwM4/71/AoryBYFCEGCCzzgOdtaKd1Txj/qcFaIcEMgomKzID+kUUnLBMqg/tRwn/s63I8ZmgpUVyGsY8jFatySY/NYL6yW0fcxi3V6RoJnznlbBYW5fMNtw7OqCAYXfCr2+kEm1LhBDh+fFMC83UZHhfWX1zo+E0JlWFIpW1DJ133EOftU5W1b8DnwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2335.namprd15.prod.outlook.com (2603:10b6:805:24::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 23:40:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Wed, 9 Jun 2021
 23:40:50 +0000
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Kees Cook <keescook@chromium.org>,
        Dmitry Vyukov <dvyukov@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        <syzbot+bed360704c521841c85d@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        kasan-dev <kasan-dev@googlegroups.com>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com> <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon> <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
Date:   Wed, 9 Jun 2021 16:40:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <202106091119.84A88B6FE7@keescook>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:92ff]
X-ClientProxiedBy: SJ0PR13CA0218.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:92ff) by SJ0PR13CA0218.namprd13.prod.outlook.com (2603:10b6:a03:2c1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Wed, 9 Jun 2021 23:40:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46b54bda-eebc-4982-d77a-08d92ba00324
X-MS-TrafficTypeDiagnostic: SN6PR15MB2335:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB23354308084B233E35B8A367D3369@SN6PR15MB2335.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dtUXY5I1KLPmhWRbz1tYU/sQO+1ugYnzL0Gkd6VPHszBac4SK3AwFr3RLQ5v8sJw/x86rjKkMzoTNMDSDwJ1cSXrarYJw/BMxSObWH718AFxDhKYU6Zz/vdf43TNO0B65UcLdzrig75BnwEsPw2JI/qGo4HOzs8Oep8ZadttE0EsY/zT9rb4CXaue8IxoclYxMEEl4DNkqdnegAZHSlrSdXBPQz1OHZOzjQt4b3+VLjwmtU30cMW2iouCh8f1a/9PkfNiYs4quIWaP3EQTA2yayaNEMiGsU8Kk00C5JNM6+wkf1sls8iljmyU38a0PHAcutW8YyDs9ZnwDnYv6t45IL2fK2Ai0t9LB5AFNJn0uoDeGX86Trys7F/xYx3Z6tjR9ayzFuuY/lZQ+IAjKfLJT0UnB//3es5nYNqwicx6z0RTuXoSXZyyRwN+RHDbnLwoI2Z0WYpFOOCEwUq1/Rx4n1uWYIAcfifLg7jJUGROo1DeMLujEaAf3Yx+T/co3Hw1+issd96A5YF+mnsteFn0a5k9esf/xjf3GR/j1LWkNDB9Rs37WORB3ieb8VtryCFO7+c4wTCwzB0So0UK0Bxm42kjiVUe9LjF5ZkrKg+tgYuu+a13lug+PAxOlNH8UUEHBOPZc/xp7VO1TVMSTRjCMAFrRtWt9Gi4xuZELwWQ0i/kmf5cMbqpQ2pIado1e8tI+xfPIZmNdyfAOKKtKs++VEL58IGftQeHiBsOQznDtHFRCoys5YNMWUG/LMyEioqXj2Q9C7vDh7j15inHvoHAm94vzfKMscVEClKtHIAzRksBpq5ZteMR6rQfIeCMQJaH8d4ttIURa0isnB/93uDZq+hGtinFMN11PWALmrstg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(316002)(2906002)(2616005)(52116002)(6666004)(54906003)(110136005)(5660300002)(36756003)(86362001)(38100700002)(478600001)(966005)(31686004)(53546011)(7416002)(6486002)(8936002)(8676002)(186003)(16526019)(4326008)(66556008)(66476007)(83380400001)(31696002)(66946007)(101420200003)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnNKWWlCRkpQb0lBWk12M3YxR3I1SUNCUDd5ODh1cklNUDRlNUYrREhBWlV4?=
 =?utf-8?B?eWtEWkQ2eUx4V2x3eGRpc1dKY3ZnQUJxMGg4VnlaQVYwZ2tkbGVwWDd3KzFS?=
 =?utf-8?B?eTh2THlSdU9qczRJTERTek02a2szcXJ6M0MreGtkM3p4UFZTNjN4SUdvVW93?=
 =?utf-8?B?WWc0b2NjZm9IeExjMURzZ3ltUXNmMFlpbzdORjZIbTRCbzZncjZRZEdsdndT?=
 =?utf-8?B?Wm5GSSs1K2hDZnB5QWw5aVFRdk1sQ0ViZDROU2VaakJUZGZlYllrVFIrTFdK?=
 =?utf-8?B?TDN0RWlrUVVCWURjY2kySW93THJzc0ZPT0Z3TVErMk5rREpESExIc0UvNGYz?=
 =?utf-8?B?WER6akJYY3cvVWx0YXFIeEZzaTlVVDY0c1JQZXVWV1M4ek45d3RDcmM3SU9r?=
 =?utf-8?B?VXFoTWs5MDFSdGRYNnZYY0NqOTQzZnNjc1hnb1RTL1c4ejhJQjZDV2VqcFM0?=
 =?utf-8?B?ZldPeTBKdDg3SGI3K0hjd09SV2JGZVV4Y2lyZlR2dVVUMHJ0RWEwamhGK3Qw?=
 =?utf-8?B?bnp6SzVhS1l3R1BWMW41anlKT0JVSGdSa2hRTTJuMjU1Uy9oZWlzN0RiRS80?=
 =?utf-8?B?dGZQaVVDdCtmY1p2R00wdVlobDBzZDg0MHcxMGFTSXI2YmovV0RqcmZJR0ZM?=
 =?utf-8?B?QmFKQWZKWHUrRHJZYjUzZmNQdVc5TmJubXlHQ05id0Q5bCt6NWZGdHplRUZq?=
 =?utf-8?B?cjNodVU0TVBRdTlrdHFVL24wN0x0MzZFSXpCdDdsOUkwT0IzWTloUmttNmpi?=
 =?utf-8?B?K05idTh6TFViTm54YTd5RTRDU1I5RGVPekphd2tFYXhOT2tJWTV0UVN3bFMx?=
 =?utf-8?B?SFBqMFl3anhPalcwWWFVdkRqNklyNmVoWEpGVlduK084NVlHT25jZnVoc2Rp?=
 =?utf-8?B?bFpKL3VWUzFLTlR2ZXNDVzhTbDJaQTVCSnFrRFN0WHNIREpOMmNpWGRPMTBB?=
 =?utf-8?B?cERNeW95RjZQRlh0d1JsWFJKTlN3TkY3aGhTUWpoQU9LYitVT3NKTWFSd2lE?=
 =?utf-8?B?SHhLSVRFazBCTzF4UjRXS09XeWpObCsyZlZPZFpYKzcrckx3YVRLTm11WktI?=
 =?utf-8?B?d1lMSC8yTnlxMmdtQ201ZXRnMUVEQmlJTVpBdXVHYnlvNklWZzJlZzlRR054?=
 =?utf-8?B?MHRaekdVRTVscE8rWFllbnRwaDNERUF0SG15cGdOWUdLNU02SjB3SXBlT3Nl?=
 =?utf-8?B?ZFJlU215RHUwaC9pQngvTUtKSXRra2d2Mkd2My9IQ1NhRDl2UzNETW5JVVlm?=
 =?utf-8?B?ZVdKSVZqaGI5dHZ1VDNoc0NPY1RZT0xtR0dnY0NvYmRxV3BqRjN1YXRTYWRs?=
 =?utf-8?B?MmxlS3l1L1BoRzF1WHMyOFViSno4d09DMTRaZ3ZmTHdkbW9rMTcwczYwd3JW?=
 =?utf-8?B?WjdjZXdRV0ZpbllpSWN5dWZ1Q3BndU9jeCtlRlpuanFEUHhZVXZmbitva0hN?=
 =?utf-8?B?SFBGeitKZ3Y2b0pSdEpCRm9tRGxJUXRFenZ0UHBUM2FYa0E5dFI0OFVqOW15?=
 =?utf-8?B?Wng1cXIyakJHMVZ4WEhNN0M2R0dsRmlad3FHR0VNcGFpYTViL2RvOFplelRP?=
 =?utf-8?B?NGNsdU5CVHNVYjJEZXIrUGlhQUlwMTVwcnVBSXMycURyTzhXcmdxTXE5bE83?=
 =?utf-8?B?a25XNmZyWVEwS0dQTEdKQllGc3hpYUpxNWNhZmRhMjJiWVpickhXNFNCZHNl?=
 =?utf-8?B?cG1UdmRxdTh1ZCtHclZieXpiakFFTXJhcDhZSXEvOGEreDVxQm82TU11Rm1u?=
 =?utf-8?B?aVIxZ1NpYllRZTZZQlpKVlVac3AvSFd2aTVET0xpay9xWG1kSmxsRkdtejRo?=
 =?utf-8?B?STRkRzJadmtHKzJFMmxaUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b54bda-eebc-4982-d77a-08d92ba00324
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 23:40:49.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnoDSh0OwdjJ71c9WomxDCp+9Gj2RNfj1PPyapwN5OE93fB15+rxccyiUL4h55oJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2335
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KGs3Q8Bz63QtT7jyWOzz7jUOq8zatVY8
X-Proofpoint-GUID: KGs3Q8Bz63QtT7jyWOzz7jUOq8zatVY8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 11:20 AM, Kees Cook wrote:
> On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
>> On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
>>>> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
>>>>> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
>>>>> kernel/bpf/core.c:1414:2.
>>>>
>>>> This is not enough. We need more information on why this happens
>>>> so we can judge whether the patch indeed fixed the issue.
>>>>
>>>>>
>>>>> I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
>>>>> missing them and return with error when detected.
>>>>>
>>>>> Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
>>>>> Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
>>>>> ---
>>>>>
>>>>> https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
>>>>>
>>>>> Changelog:
>>>>> ----------
>>>>> v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
>>>>>        Fix commit message.
>>>>> v3 - Make it clearer what the fix is for.
>>>>> v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>>>>>        check in check_alu_op() in verifier.c.
>>>>> v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>>>>>        check in ___bpf_prog_run().
>>>>>
>>>>> thanks
>>>>>
>>>>> kind regards
>>>>>
>>>>> Kurt
>>>>>
>>>>>    kernel/bpf/verifier.c | 30 +++++++++---------------------
>>>>>    1 file changed, 9 insertions(+), 21 deletions(-)
>>>>>
>>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>>> index 94ba5163d4c5..ed0eecf20de5 100644
>>>>> --- a/kernel/bpf/verifier.c
>>>>> +++ b/kernel/bpf/verifier.c
>>>>> @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>>>>>        u32_min_val = src_reg.u32_min_value;
>>>>>        u32_max_val = src_reg.u32_max_value;
>>>>>
>>>>> +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
>>>>> +                     umax_val >= insn_bitness) {
>>>>> +             /* Shifts greater than 31 or 63 are undefined.
>>>>> +              * This includes shifts by a negative number.
>>>>> +              */
>>>>> +             verbose(env, "invalid shift %lld\n", umax_val);
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>
>>>> I think your fix is good. I would like to move after
>>>
>>> I suspect such change will break valid programs that do shift by register.
>>>
>>>> the following code though:
>>>>
>>>>           if (!src_known &&
>>>>               opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
>>>>                   __mark_reg_unknown(env, dst_reg);
>>>>                   return 0;
>>>>           }
>>>>
>>>>> +
>>>>>        if (alu32) {
>>>>>                src_known = tnum_subreg_is_const(src_reg.var_off);
>>>>>                if ((src_known &&
>>>>> @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>>>>>                scalar_min_max_xor(dst_reg, &src_reg);
>>>>>                break;
>>>>>        case BPF_LSH:
>>>>> -             if (umax_val >= insn_bitness) {
>>>>> -                     /* Shifts greater than 31 or 63 are undefined.
>>>>> -                      * This includes shifts by a negative number.
>>>>> -                      */
>>>>> -                     mark_reg_unknown(env, regs, insn->dst_reg);
>>>>> -                     break;
>>>>> -             }
>>>>
>>>> I think this is what happens. For the above case, we simply
>>>> marks the dst reg as unknown and didn't fail verification.
>>>> So later on at runtime, the shift optimization will have wrong
>>>> shift value (> 31/64). Please correct me if this is not right
>>>> analysis. As I mentioned in the early please write detailed
>>>> analysis in commit log.
>>>
>>> The large shift is not wrong. It's just undefined.
>>> syzbot has to ignore such cases.
>>
>> Hi Alexei,
>>
>> The report is produced by KUBSAN. I thought there was an agreement on
>> cleaning up KUBSAN reports from the kernel (the subset enabled on
>> syzbot at least).
>> What exactly cases should KUBSAN ignore?
>> +linux-hardening/kasan-dev for KUBSAN false positive
> 
> Can check_shl_overflow() be used at all? Best to just make things
> readable and compiler-happy, whatever the implementation. :)

This is not a compile issue. If the shift amount is a constant,
compiler should have warned and user should fix the warning.

This is because user code has
something like
     a << s;
where s is a unknown variable and
verifier just marked the result of a << s as unknown value.
Verifier may not reject the code depending on how a << s result
is used.

If bpf program writer uses check_shl_overflow() or some kind
of checking for shift value and won't do shifting if the
shifting may cause an undefined result, there should not
be any kubsan warning.

> 
