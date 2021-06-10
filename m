Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E423A2441
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 08:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJGJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 02:09:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62050 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229773AbhFJGJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 02:09:09 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15A65K88022881;
        Wed, 9 Jun 2021 23:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2TLIOumftGs+ZZQASQc/HGCK3Iyy8Bve6Kuybwj/0+k=;
 b=SPRptoVyYGGO56F1DahN6puYHnQdmUy3k4FP5VZLDsZCbnbiGGyFa26f0lhb/jgL8rPX
 tQZ0drtc9Pp/Vo75LR3pY4ZltaH64rPKAdDYrcBgPVA3Cu7b3a+Q9OpjudbVr/wK6Qzg
 gtDgZW9Y+QhbRUK/ACy1cSmgYU7p0bP6efg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 392ta76ufj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 23:06:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 23:06:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6UH73Eu0Fz8LGsKGegdoiAQay0wLTPNtmuF00eeXwNEb3ns04kA8lj9Bxv/Q8hQ1b5pev7+xkks63zsW+sYbF3xYz6l2PhW4heHSYtxfF/Wn5fjt+YRHCrj4Po3fjz3Jtx0LS4pgOykqxijIMm4RVVHk3KUgIq5mBoaQnW2U57ALu4lpHPI4bV6JWJWbX051tma0T9LkPbZ3jyJML75UfZZUYcnjcm7cjw7T1UNb80OQZjliu4GZbKziH2jhPygV1mUvdelEeeC2dYS3ueJ9ZuC8aMdiE5My0lGxc3mMI6S05Blgxfro+VCE9s1Nssle4l2X34xRL5WRzi46YJBuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxHJPZyg/OOzCZ8Lx+wZvUE6Oqpasi6reYxz8sqv6vw=;
 b=Us3hxxwnGdKbsMTdHklyIlRTwQL7xP840m4tCOiVZGG8IcSXc0ryN/eJMLa/or28bbpniZHZCh2WUigfWvmCJY5WH7pcQTZ+gCZN3Et4WJf28qJUdNeTFueF51nG1gJyfHUcmxr5XORG5Z4zzRRLcOjqmrKB2pbPJuvnHlY1SHA51XRfmKdJbnK67vBx61gbPPgQ5rfuZTu8Pdp4r0xstaKYO5IMJ84UuKBpa3L0HvXQZrxBp4vBZZp/pO24oqGTRgMf3hKxgF3yT7Z8BHWuaG9slP7ZIl5jqe29tXnMGtAfj3f8zUwS8dbwptXN+FF81oAI9SmzJsctQ9CuM/jcDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4419.namprd15.prod.outlook.com (2603:10b6:806:196::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Thu, 10 Jun
 2021 06:06:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 06:06:35 +0000
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     Kees Cook <keescook@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
Date:   Wed, 9 Jun 2021 23:06:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:333]
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:333) by SJ0PR03CA0114.namprd03.prod.outlook.com (2603:10b6:a03:333::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 06:06:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edb7a764-088c-4276-a457-08d92bd5e6ef
X-MS-TrafficTypeDiagnostic: SA1PR15MB4419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4419C1ABA35CDB999F938D3CD3359@SA1PR15MB4419.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+Jxww8dSTYTSmSuliP4QO9wsUIXtZjQzVsk/nLc3ZYZSbO+n4eDmIqnke9PTmo4bw4lYmh3H9pLQtzEDW8WpGvIux4O+VIqvPlFukfY8epore8cNI/DNWVmcikCWS3426l7onVwY/0qebCkEz8/Q6B78ZHgvJTkg7/GzJbSoBloManyiZCurfPJLC1ur9q7WanjBCzUnh8YCYE68m/mlnfsXnW9kzQ4WbPhzDI0Jtmx5sjJ005K02q+emFeGGO+0JkaixXbPsd/pOzoLozKke7gB2N3t8sRu3Zqw1Y3qfisuvAU6enBC9Hzm2h//ioQ+od5z2WHivjVU5Wzl5cTQfmeBAIdD7VYBSctu1CcFJ7s3feQ3IJG79arM3ws09qbrgY7Yh+KPE9tK3pUY5LVSKnHDix/Hongqc3HA3abXjhbA7iWuV2bXFBLVZjDTgm6987HXO8PHFDtbo3Wnycg9t7D9XbBqsOrIvz3EsnU9Ip0p0pQCKN4Pbl8CTaJDZNAXF9b0bnNe/uK76yc5hupZ+n5n82ev8LvSRGi9BL+CESkw3aMIBjS7KCP+YaF417st6E3QrYPvxPGc8nW8H15c1Q6+qysYt1VJfOodtN1PgtxfMJQEhoWPJh1IeJ9ZwCcM8FL1OouuIuv3js0XkdvUw6O7e5fr88+0D0YmhJnKfA4SBZSCZy4uGR/dh2ZApXCOE1DFgu1jiIlfzTd+KCktZv5oMzMLCTDS4lgVtcsjyK5XxI5tLpDdWHprJNMakpRwG5gmvBJS0U2FdjKnapmk7i3c/bUk2tacXTUpwG0POszexDW2UMOV4mOoGRYhcBkqCwcDGSojVmZA7J2uOGGSo2a0ihbKlH+71TXDTsvSbk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(346002)(136003)(66476007)(66556008)(966005)(38100700002)(478600001)(6916009)(66946007)(5660300002)(36756003)(83380400001)(8936002)(31696002)(4326008)(86362001)(8676002)(2906002)(54906003)(31686004)(6486002)(2616005)(16526019)(186003)(53546011)(7416002)(52116002)(316002)(99710200001)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTJhSGxic3hDcmk4TXREeU5QMnVocURScFIyMU1Cc1plRnBVTDhqTXlXV2hI?=
 =?utf-8?B?R0VhR3hKbG5XUUx6eGFnUDl6V2dtT25kVTFhUitYZDBIb2prdEdiNlRzMHhR?=
 =?utf-8?B?NGdTNGc0WHdwRE90MVlzTStRMHk5dlhhVk9uVnYzMUtoK3N5LzZPS25PWnRQ?=
 =?utf-8?B?UkdFT1R6RWRHZVU5UzFnQWgrNG9DYnRHOVVJd0FVc1JlcHRidlVneDlWZjRK?=
 =?utf-8?B?TVkzTXFuaEtlMCtKanFXNFBmeU5xTU92d0dwaEM5eU11dTdVWmFMK1RpdTJi?=
 =?utf-8?B?VElib0todUdmbWppZWxDRjVwZmNoU3Vra3NuM3Bpd1lEUElRMGpiTHNLV3ZO?=
 =?utf-8?B?bmNvVW5jRkRDMEdxWHdkWUJUcjBZM1JDZTUyVnVwcFRmc1pSRGN2WjhGQTlT?=
 =?utf-8?B?bmxTQklSZEFqUkRPcUpsTytlRkVQZXR3NWZhT1dFYWFwR3VzUVROV2ZuZ01R?=
 =?utf-8?B?cjc1TGdJQ2Z0M1h5cUxBY1NUMEtuN2NPTllVNHBFcVdDR1dtNUU5OUdSamlX?=
 =?utf-8?B?dXZ0QW9ZZHYxUnZ2UU1OeE8xMTRZUjN6UnlJc0RIeFZNSkV2R3Rzd2VOdjJ2?=
 =?utf-8?B?NEVvMStmUzF4SVVsSHFkSmlodFVpZ2tkTE1qdmNwYTRoczNsb2VZUzJGOTFt?=
 =?utf-8?B?RVlQaG9jUnNaYkkySjJlZ2RMTDJ2MUQ3dmlnR0NLa3czUDBjaU9xMnZzKzRM?=
 =?utf-8?B?SERWWVBkL0haQzZHNU1vRDBPSnl3dUx3YVhpQ3lmTkg2YVlETG5YcENYSnlm?=
 =?utf-8?B?UUg3d1dVTjlCeWsraU5PdUY5MXRNU1d5UytpVmpOZXVZaldFYmRtUWRXMERp?=
 =?utf-8?B?SzdrUVQ3L2lUUnNLVlArR1lNVXJPMmRlYWU5dDhBVFB2LzVEZHcwZEVEZFBm?=
 =?utf-8?B?NitERDllQThJZWUvNFNZeVpocUp5eDZtWHZoc0p0SlNEblVjUlg3ZzlnbGNI?=
 =?utf-8?B?OG1FbjBsczN1ZTJyZUZMYjFYVEFkNXM2L3kzaXViWUVjcWhDQmJOWjJKa2xk?=
 =?utf-8?B?NUwrUEpQVzFtSTRkOVFXS2JsZnpSVS9pN21VcFJvbFAzckZZYmN0Nk5ROUU3?=
 =?utf-8?B?b3NISmpacVZCN0ZPR2ZDTkJJUnJjdkFWdEJTZ1hpVjMxTHhPbjZHTnVNaHBI?=
 =?utf-8?B?TnEzb05JaDhwUnpCL1JjeDA1OTQ5R281ZDlpb1hGRThpTEJqK01mZFA1YTlq?=
 =?utf-8?B?aFd5RDNjaEVOUWtsYUFkLzgzOUd6ZlNhNWtrMmtuNjY1RFZDYUI3MVl3RkIx?=
 =?utf-8?B?dWlnYVJxTHZwS2RqSXU5U2JpOG5SOFNiME9wYUZ3Rjd2b0xwTnhYZkJrZXZI?=
 =?utf-8?B?NERrOEk0Q2p1QWl6YlVFUEttMk5SSnZIMEJUU1QxZzN5VG4wTklsWUxsOERj?=
 =?utf-8?B?cW5acGJhSVlCSHlWWmNwelU5clhQSXZleFpheDM0SFJZb2R4T0Vhb3ExNENp?=
 =?utf-8?B?dldYV0hVMzBtNTArcHdFL1lJUDNTamJuWlRWT3I4YThSKzJla1FWRFVmZWRJ?=
 =?utf-8?B?R0NCWjI3V2cwK09lS0lTUkhZMXEwblFqV29aNDVZc1RwdjlOOXp4VFh3U3JS?=
 =?utf-8?B?bkFTNUFzU0RVRnV5cmNhWVluMUZQd1l3N0E2RnlxVEx5aDlNRkUrMGlQc2xP?=
 =?utf-8?B?alorVWVldmhTZ0Y3bXIvd01Bd25zYXBQeElHT3dRZnlEc0xLU0QyWXFndDZ5?=
 =?utf-8?B?VEFYQjJCMzMxbDk2R05hZTZDckhSZlQyMDVJZ09ROEo0a1RFaFQ4UmhhV2hQ?=
 =?utf-8?B?bnBndXN6R0ozWW1xNzdTemd5YTkwVHl0dHJ3aGU1eGo4OFpiZDhobDE1K0dJ?=
 =?utf-8?B?VUxSdEQ3UVVlaFpQTGlUUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edb7a764-088c-4276-a457-08d92bd5e6ef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 06:06:35.4397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1j8LpAel0I4nhGf+lxbOGgl1WBs3nESX9YyfTwNbcu20XJbp32/YWPIdDkx0SGga
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4419
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: BjpEQc7zHqEBLa20VDeWbNqJSV8yMR9t
X-Proofpoint-ORIG-GUID: BjpEQc7zHqEBLa20VDeWbNqJSV8yMR9t
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_03:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100039
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 10:32 PM, Dmitry Vyukov wrote:
> On Thu, Jun 10, 2021 at 1:40 AM Yonghong Song <yhs@fb.com> wrote:
>> On 6/9/21 11:20 AM, Kees Cook wrote:
>>> On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
>>>> On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>> On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
>>>>>> On 6/5/21 8:01 AM, Kurt Manucredo wrote:
>>>>>>> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
>>>>>>> kernel/bpf/core.c:1414:2.
>>>>>>
>>>>>> This is not enough. We need more information on why this happens
>>>>>> so we can judge whether the patch indeed fixed the issue.
>>>>>>
>>>>>>>
>>>>>>> I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
>>>>>>> missing them and return with error when detected.
>>>>>>>
>>>>>>> Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
>>>>>>> Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
>>>>>>> ---
>>>>>>>
>>>>>>> https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
>>>>>>>
>>>>>>> Changelog:
>>>>>>> ----------
>>>>>>> v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
>>>>>>>         Fix commit message.
>>>>>>> v3 - Make it clearer what the fix is for.
>>>>>>> v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>>>>>>>         check in check_alu_op() in verifier.c.
>>>>>>> v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>>>>>>>         check in ___bpf_prog_run().
>>>>>>>
>>>>>>> thanks
>>>>>>>
>>>>>>> kind regards
>>>>>>>
>>>>>>> Kurt
>>>>>>>
>>>>>>>     kernel/bpf/verifier.c | 30 +++++++++---------------------
>>>>>>>     1 file changed, 9 insertions(+), 21 deletions(-)
>>>>>>>
>>>>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>>>>> index 94ba5163d4c5..ed0eecf20de5 100644
>>>>>>> --- a/kernel/bpf/verifier.c
>>>>>>> +++ b/kernel/bpf/verifier.c
>>>>>>> @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>>>>>>>         u32_min_val = src_reg.u32_min_value;
>>>>>>>         u32_max_val = src_reg.u32_max_value;
>>>>>>>
>>>>>>> +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
>>>>>>> +                     umax_val >= insn_bitness) {
>>>>>>> +             /* Shifts greater than 31 or 63 are undefined.
>>>>>>> +              * This includes shifts by a negative number.
>>>>>>> +              */
>>>>>>> +             verbose(env, "invalid shift %lld\n", umax_val);
>>>>>>> +             return -EINVAL;
>>>>>>> +     }
>>>>>>
>>>>>> I think your fix is good. I would like to move after
>>>>>
>>>>> I suspect such change will break valid programs that do shift by register.
>>>>>
>>>>>> the following code though:
>>>>>>
>>>>>>            if (!src_known &&
>>>>>>                opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
>>>>>>                    __mark_reg_unknown(env, dst_reg);
>>>>>>                    return 0;
>>>>>>            }
>>>>>>
>>>>>>> +
>>>>>>>         if (alu32) {
>>>>>>>                 src_known = tnum_subreg_is_const(src_reg.var_off);
>>>>>>>                 if ((src_known &&
>>>>>>> @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>>>>>>>                 scalar_min_max_xor(dst_reg, &src_reg);
>>>>>>>                 break;
>>>>>>>         case BPF_LSH:
>>>>>>> -             if (umax_val >= insn_bitness) {
>>>>>>> -                     /* Shifts greater than 31 or 63 are undefined.
>>>>>>> -                      * This includes shifts by a negative number.
>>>>>>> -                      */
>>>>>>> -                     mark_reg_unknown(env, regs, insn->dst_reg);
>>>>>>> -                     break;
>>>>>>> -             }
>>>>>>
>>>>>> I think this is what happens. For the above case, we simply
>>>>>> marks the dst reg as unknown and didn't fail verification.
>>>>>> So later on at runtime, the shift optimization will have wrong
>>>>>> shift value (> 31/64). Please correct me if this is not right
>>>>>> analysis. As I mentioned in the early please write detailed
>>>>>> analysis in commit log.
>>>>>
>>>>> The large shift is not wrong. It's just undefined.
>>>>> syzbot has to ignore such cases.
>>>>
>>>> Hi Alexei,
>>>>
>>>> The report is produced by KUBSAN. I thought there was an agreement on
>>>> cleaning up KUBSAN reports from the kernel (the subset enabled on
>>>> syzbot at least).
>>>> What exactly cases should KUBSAN ignore?
>>>> +linux-hardening/kasan-dev for KUBSAN false positive
>>>
>>> Can check_shl_overflow() be used at all? Best to just make things
>>> readable and compiler-happy, whatever the implementation. :)
>>
>> This is not a compile issue. If the shift amount is a constant,
>> compiler should have warned and user should fix the warning.
>>
>> This is because user code has
>> something like
>>       a << s;
>> where s is a unknown variable and
>> verifier just marked the result of a << s as unknown value.
>> Verifier may not reject the code depending on how a << s result
>> is used.
>>
>> If bpf program writer uses check_shl_overflow() or some kind
>> of checking for shift value and won't do shifting if the
>> shifting may cause an undefined result, there should not
>> be any kubsan warning.
> 
> I guess the main question: what should happen if a bpf program writer
> does _not_ use compiler nor check_shl_overflow()?

If kubsan is not enabled, everything should work as expected even with
shl overflow may cause undefined result.

if kubsan is enabled, the reported shift-out-of-bounds warning
should be ignored. You could disasm the insn to ensure that
there indeed exists a potential shl overflow.


