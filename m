Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F219B3521F9
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhDAWHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:07:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231179AbhDAWHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:07:09 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 131Ll97B014357;
        Thu, 1 Apr 2021 15:05:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1ETaSawiMa2aMcGAbnbqvkziWsGvAO8Rmh41ke91RCE=;
 b=Pxz3ct5R4taVrqss8P5tcSkr2rhdPDe4haQ9jSK7w+BDPm4t4PHk9+VdTRHsWRnRzn9v
 2vQ2WDtRTkBsF6G/I7TDeviSlNKlja2uu9EUWucf+MfFMspjQYjCbZRTrWxEIXwtTEn2
 vaABsTEcJVpbwGsUrFn5EJwxQtf5CKIoljY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 37n29nekrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Apr 2021 15:05:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 15:05:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuSdKxLAPCKa1gZN/mK6T/axNgFyNSxk1zC7VlCPIKqyYPjqvOUo/ibnRBr+N3dbK4wuK39ZyUBmmzmSKtyuy/T0G9K2PGNKB0uCn+oxaiIT+c1m9gry+aBsR9f2qzkkfdtUPu7Jhj/+rS6hduFjuqCnBDHFHt3+edDlnT6eNZhDH3V8435RftU6XT8hCeIcM86YZ+NdEI8K/FAFPJeaM6ULmagBWMjY5/Avw67b4DojDQi6FU63aw+Bdzw+tpxfsLIQhTWW47pRiTyPr7M1qw+65rYhzisgkDlDv/YUjhM7Gyh3RvEZ/dmg9CRTM786Idfa8FjlQylDOYG2HGuCqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1M4DfxESRASdXb6bG+ChtsLUHh7tzcHOKxccySz320s=;
 b=Ch2ncFGjc26TPHnDdYdZJsd68d6LnCvltOcxlm39a9XwWOyVGwz1Oq6WrqkEVGyl2u51nCy4HzbPHT5lOSXBqzp88u46nYLnRQUCg+FGh+FplVdWhrIhjYEQ4TYhwhzRb5gkn7ni4EYiFdywH7wxDk0DySmDyLw2eqBvAK9dqwr/LzROePKj+h6zR0iNRQ4ewYVuYYopyOgs0jj7TYJ/laovx3iPFefL1HpKkLzuuA25obK/H/2DVaOlf+CZQRxjWrWpvLyUPcwox5730GBrfR9lrCo71BKpK7Tjjl1+fiDqOQ/rfjqZy5VASrB8WV1utN093ob8n2mDYWQPrlrHxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4420.namprd15.prod.outlook.com (2603:10b6:806:197::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 22:05:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 22:05:06 +0000
Subject: Re: [syzbot] WARNING in bpf_test_run
To:     syzbot <syzbot+774c590240616eaa3423@syzkaller.appspotmail.com>,
        <akpm@linux-foundation.org>, <andrii@kernel.org>, <ast@kernel.org>,
        <bp@alien8.de>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <hawk@kernel.org>, <hpa@zytor.com>,
        <jmattson@google.com>, <john.fastabend@gmail.com>,
        <joro@8bytes.org>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <kuba@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mark.rutland@arm.com>,
        <masahiroy@kernel.org>, <mingo@redhat.com>,
        <netdev@vger.kernel.org>, <pbonzini@redhat.com>,
        <peterz@infradead.org>, <rafael.j.wysocki@intel.com>,
        <rostedt@goodmis.org>, <seanjc@google.com>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <tglx@linutronix.de>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <will@kernel.org>, <x86@kernel.org>
References: <000000000000d9fefa05bee78afd@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <97b5573f-9fcc-c195-f765-5b1ed84a95bd@fb.com>
Date:   Thu, 1 Apr 2021 15:05:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <000000000000d9fefa05bee78afd@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:fb66]
X-ClientProxiedBy: MW4PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:303:b6::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::17eb] (2620:10d:c090:400::5:fb66) by MW4PR03CA0078.namprd03.prod.outlook.com (2603:10b6:303:b6::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Thu, 1 Apr 2021 22:05:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 832976d8-32b1-4c1b-b5a4-08d8f55a3551
X-MS-TrafficTypeDiagnostic: SA1PR15MB4420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB44205E373482855C00684B52D37B9@SA1PR15MB4420.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7C/bxPIesd+7FaQxAlJNbXLOfpG0PbDan2vN+LEIcCsTRhJ64Qe1RRSIutTYMhkQGuqc/u4nbrGY60xth2KayjXWDSvkzzqMI+i5NIc5kFPBGo+PLOw7bOYutw+73Tr1NZgGoxwITRki1feHNLT+r3Vq0KpdZmPl6cvu6cJe2Mn8WM4l4Z3QjOZp4OduzU2GsTYXqbEjaY609iLieMa4DMYEPJJZpY/Eg6XUISDhHgR6oWoyPp+Zk2dwzkf/uFOJfgTK8mpeHCqnG2PThJcF8yesmDlKMEgyC+FtAleNiSoAS7BBcI2KdHwoYn3llBSadX+GTqXCn8V4crcDn5kv08V0V6k17tBdo7UsmGn+GeCpi6ohjn1rV976p4R5f9chEtTPfnaRaSXpggDy5B63u82Nmrzs1WvTzKUD9oHBhULvc+0hXTtv0nDS+3PoeIVqAhJVFyp7BejTCRbwnVfZORYQsIOVySztssLa6Rhl0zmEOYerftB3y6F0JtbF6LjPvKvpwxbJRgaqFKcEShB0lncV2RJBURtugEKcjU1Ev2pD8Q3iCe4POTs+5YVzdlIPSX1yopvGZjgMKYzNhmzgdVSJ5FY7dpHi90r0DfCIMFGTyfzTz20Fd4vcj6HJ0gk8ksrx+nOFvP9o6VTus05tI7v7z0KwaEIq2LkBedosiz9pgrBqvb4VF0DSAo37uINIGsk8ypOGTePg+9+DVm2g+M/sa8pmyWLvfuWJaL4iskKo5cPKYQYn/s1ePAIOEzJKSNRAeAK3aJPvixzzx7DTN+vO7OwrtRAHEJP5ihnXh8V2D+juqGPOI6wCgluWOFtTmi6YCpkAE+lHo9VmeP2ibYS95pJwrL2NB54HXl7804=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(966005)(8676002)(52116002)(921005)(5660300002)(36756003)(2906002)(7406005)(66556008)(66476007)(38100700001)(53546011)(45080400002)(31696002)(186003)(86362001)(2616005)(83380400001)(66946007)(6486002)(16526019)(31686004)(316002)(8936002)(7416002)(478600001)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WldSZWhTTk5LWVAvMStHSys5bjYzY2VSN2xHQm10SlFVT2pVZjhiNjQvczNB?=
 =?utf-8?B?QkkyQlBEN29QeS9oR2dOWnA2VWNPRnpKMldWN2FFOHdJTTVDejdkWkhCVHVt?=
 =?utf-8?B?b1dBZUdTZHpPeEV1V1ZKNUtvcm5VOVM3NkFMQ0VWT25ZamljcGUvSjhKN3gx?=
 =?utf-8?B?Qzl1ZXVyQ3A4YXRMS2E0WTd1VkdKcXJkbHRnQk83WUpNQ1Mrdk42MFVwNCtE?=
 =?utf-8?B?Sy9Eb2Q2YnRPV2crK3NTK1VlZk51ZU9neSt3NUMwUU1CMWxPRDBYcVZvQXAv?=
 =?utf-8?B?d3Uvb2syZHdIemVEM3FZVHhoZm1uYjVSVFZOTFFyQ2JubVlSTUxVeTBib1ZR?=
 =?utf-8?B?c3dUSWlaZDliUFdSQmlZUXUwdXJzb3pRSGZKRkFyMWM5ZGV0VXJIWkZSbWFw?=
 =?utf-8?B?SldJRng0ejQwQ3lqSXJFRGZqcTljZkNnWVd2Qkg3bjFwLy9GZmJvMUptOFBr?=
 =?utf-8?B?TVVWODA0c1NxTnNYdHpCenBZQmJEcUE4UVluTGVvWlpkSDliV2h4WlluYmEz?=
 =?utf-8?B?cDFYSk5nZUU1d3ZpelRiYXB0K0I4NTlWOEVJOW9TcjdzTlZoUkYyRlhLcGwx?=
 =?utf-8?B?K2FjZytnTUdsYWtmbjhXN1N0U2NGbHpzOXE1bVUrM3ZYWlNjYlVxS1NYN1RD?=
 =?utf-8?B?akpxbHNiZ3pmcnNzSlJVNzJkbTFKRGFmUlJGMEVRYVBDMkhLeTVQeUtjV2NK?=
 =?utf-8?B?SllEUWY3Q2l1R245VHRwZ041UWNuTTdZVllkM05TZEhId2U2Mkd3dEFvbjAr?=
 =?utf-8?B?UTFZZFBkSFc1QmppODZVbmxTTjBxY2E0QWp2RkhmVkhGNkcxaHA5Y2xaTG1J?=
 =?utf-8?B?bm1jZkF3RkdXdTU3K3ZhOHNsMjJ2QWwxSy85eG9IOEZkWWpMemVzRWp2SGRh?=
 =?utf-8?B?Nml3SUs4ckd3UVlqZWZYalF0UlFCNXUvYVVoWkZCbW4wMGhXM0dlRmplakZq?=
 =?utf-8?B?dlRmcTBydjNMZW9yc0gzcFpmcU1PMG9ySk5HOHpsVm1xcDJObUlaUjFmUXFw?=
 =?utf-8?B?UnFFeXJaS24ybWd0ZVRQMDZrWW5VWHlXNFV1TnZHRmtzQVZ0ejVrTjQvSkNm?=
 =?utf-8?B?QW1hWitDQk5JSm1NNkptNFYvWVhqV0tRK2xZSVZ3SXpNMGladnFRU0Q2eG0x?=
 =?utf-8?B?RWduaWpoVjFsQVN3cVNmM3grTnN1cUM5OVdvTjJtWnZvNkdMYnVMMVY1OWxy?=
 =?utf-8?B?WkM0UzhVb1ZydmF0S1NNczE1UmtrY1hObXArejNhd1dpakl4LzRRTGxGNlZX?=
 =?utf-8?B?YklrOHN2VHFDc0lrWnhyRmdoc0VGNVBIK1g4UG12ZUFFVDJZY041aUIvR0Fa?=
 =?utf-8?B?MENjNUJYOVVwMTJ0eWQ5WmZnU1JGVUtDa1AzbDN3c2JUUytmdE43KzZ2VFpV?=
 =?utf-8?B?cGRtdDBPbWhta3RRMmpsU2JxUGhhczBTMFJ4QWdUeFB3TGRnV1VwTnprVlFa?=
 =?utf-8?B?S3NTUDR1bVZOTldrdVpzcmZLc1dvczMwbmZvUmNLMGVXU2Rxc0F5U1lUWWVP?=
 =?utf-8?B?cnI5b0VnUlBRWlV4c0FUWkt1ZGI0QlVhUUt6NnRIVVNlRkVFQ3A4NzdUbTZl?=
 =?utf-8?B?K0pwRm5lbllSc1JWSXpCQ05zRHlTSmhXaE9ydmkxOXA2R0JnN05HTTA0R3BD?=
 =?utf-8?B?dHRuUDR1K0RHalJYSVo0UjdvYlBYUEdTL0tIZ0FrUjk3Tnl4QUN3MmZJNjB1?=
 =?utf-8?B?QlJ1a05kVjc1dGJiTDBaVUFzWWhqOExrcEcrMHoyeEFxU0JidGF1OU9LUW1K?=
 =?utf-8?B?bC8wM3R0RjNQWHVsZWh2VGp0dmtQcE8reE5MemE4WmRGWE1scTNFMENiNktX?=
 =?utf-8?Q?KmBBSftFhsrKX8pKcxcoAFWieODoYjjn9DqMk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 832976d8-32b1-4c1b-b5a4-08d8f55a3551
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 22:05:06.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7F+TWjYLzsLzl0skVN/cj+YQQExNvoDygsqqh+mNiQ7a7VQsuvzRw7r/krCrksEP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4420
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: gLdeJW6vo6CAXN7pvhxvJdlnHC-GR_-8
X-Proofpoint-ORIG-GUID: gLdeJW6vo6CAXN7pvhxvJdlnHC-GR_-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 12 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_13:2021-04-01,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 clxscore=1011 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103310000 definitions=main-2104010139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/1/21 4:29 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    36e79851 libbpf: Preserve empty DATASEC BTFs during static..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1569bb06d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
> dashboard link: https://syzkaller.appspot.com/bug?extid=774c590240616eaa3423
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17556b7cd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1772be26d00000
> 
> The issue was bisected to:
> 
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
> 
>      lockdep: report broken irq restoration
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10197016d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12197016d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14197016d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+774c590240616eaa3423@syzkaller.appspotmail.com
> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109

I will look at this issue. Thanks!

> Modules linked in:
> CPU: 0 PID: 8725 Comm: syz-executor927 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
> RIP: 0010:bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
> Code: e9 29 fe ff ff e8 b2 9d 3a fa 41 83 c6 01 bf 08 00 00 00 44 89 f6 e8 51 a5 3a fa 41 83 fe 08 0f 85 74 fc ff ff e8 92 9d 3a fa <0f> 0b bd f0 ff ff ff e9 5c fd ff ff e8 81 9d 3a fa 83 c5 01 bf 08
> RSP: 0018:ffffc900017bfaf0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffffc90000f29000 RCX: 0000000000000000
> RDX: ffff88801bc68000 RSI: ffffffff8739543e RDI: 0000000000000003
> RBP: 0000000000000007 R08: 0000000000000008 R09: 0000000000000001
> R10: ffffffff8739542f R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff888021dd54c0 R14: 0000000000000008 R15: 0000000000000000
> FS:  00007f00157d7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0015795718 CR3: 00000000157ae000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   bpf_prog_test_run_skb+0xabc/0x1c70 net/bpf/test_run.c:628
>   bpf_prog_test_run kernel/bpf/syscall.c:3132 [inline]
>   __do_sys_bpf+0x218b/0x4f40 kernel/bpf/syscall.c:4411
>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x446199
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f00157d72f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446199
> RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
> RBP: 000000000049b074 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: f9abde7200f522cd
> R13: 3952ddf3af240c07 R14: 1631e0d82d3fa99d R15: 00000000004cb448
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
