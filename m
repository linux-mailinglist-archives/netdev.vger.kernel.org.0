Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B026352489
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 02:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhDBAnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 20:43:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231160AbhDBAnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 20:43:01 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1320SCcF025269;
        Thu, 1 Apr 2021 17:40:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/L0cNspmMiVU0Kr3lZon3qvuSg8ZABJijdvU+srOk8o=;
 b=X1Xhz1pNuVt1/80FaVRl29gpYijpx3le0Ec4oI8TISHTaSgenssIa5b0iIJ7Syx+T1jK
 +FkcA27uA4rks4ouow0Tm6wPSQFdYFa4hMiFZVrUKfLvnYhNy4nT5ScOKMfJ8/9WIoHv
 naNkzN/Ifxem9/k5fb60mdTtfk3saBg3T20= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37n2a67jh5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Apr 2021 17:40:53 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Apr 2021 17:40:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY781yq3U12o4qoBRLcYhlquS6WNAvBSL6V5W/r/s7g8Gerkxl7AuqLa8DZcojQnTuh5nAFdqvNs9cL+/4PjVL2uv4wOgFB+0JizTwc1VzgYAx8x7zdynxDpPbvffFTuwifWQag9lw74YWO3Fzmjt0iFu9llEpoyn7aoVi3Q6TkOg7oAG65wOmGWQw/wvhdZWpdSo0z3/42/HNhQOD1bAIaNsuy9MVrWmnOFXjdaQy8ZcLovELrooxZDMpqdAcFaBdAC3KAcXRngEBM2WLC9Sy/8BqfPP5BNK0CeLUi5+mUlWgqNDErMD/rVofUiSeCnO6UOZO3QheA3bKwyyKZIGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tk9ikXg5LatUU1+Ge56zEOZFerIjJueuMp2fhr98oIk=;
 b=iZjOme0zHktmxeAmQVv5WPlZMGuYEcO7kh9jd+jh4bQI7jGFuNM0tbmu2o7Zd5QNEJFL5hUbxHhovHMtuCC0lR0TsNSFAPaP7CgIBNcsNT9t8UAykprrgwVseHae6pHbDqXCW1ICoII+GWrTHbTY3ceeTzKWhp0MPWPC56TCn18Pv3M2pGABrSZP2r/PFMeJm1sKJOPqJD+XCUplr47hkS3UYZ7u1XiPyRnabz8X7K1qLc6JCp1ihsYqU3qW0k2ITGQ9J+DPHhQgDKP6q/ur2QtMWeJFwwvKzawnB/36R+DGeAbvUJmsPAdlY8ETBZIOFoU9oybYFzcUB2wgDisv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2288.namprd15.prod.outlook.com (2603:10b6:805:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.27; Fri, 2 Apr
 2021 00:40:50 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 00:40:50 +0000
Subject: Re: [syzbot] WARNING in bpf_test_run
From:   Yonghong Song <yhs@fb.com>
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
 <97b5573f-9fcc-c195-f765-5b1ed84a95bd@fb.com>
Message-ID: <d947c28c-6ede-5950-87e7-f56b8403535a@fb.com>
Date:   Thu, 1 Apr 2021 17:40:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <97b5573f-9fcc-c195-f765-5b1ed84a95bd@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:fb66]
X-ClientProxiedBy: MW4PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:303:8e::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::17eb] (2620:10d:c090:400::5:fb66) by MW4PR03CA0038.namprd03.prod.outlook.com (2603:10b6:303:8e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 00:40:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9304c47b-37be-410f-2f50-08d8f56ff675
X-MS-TrafficTypeDiagnostic: SN6PR15MB2288:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2288B68D2CC606E5AEF0FB67D37A9@SN6PR15MB2288.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nY0VAgq2FNHVyQ2EgfEyD/iWM+o9mSRn7dB8qlLaEoQ03/6NWDuvcMCEQdNPY3srjt/slFFCrI3ah/Aqp4GmANF0YqjN6AceSbHfY2M/u2qFgRF5c7gpE1zn2LL9IT17CGDcFXeyxYeRMoIkCQGyrK774j89dLOqZ8LQIiVRwEj8YAV+TZquUoalJINb4VcUPHO5M3PjZVtzhNzvs6z6v+fAiWn2m03aS9ucfbCIOH7thv1aonyxbPISUxXeJTGOJFBH+DjSuyOvqu1kjlnyR05L+h78qC6X3InRq+rWZtLuUXgoTZ34CPrX9CucbZ9bCsYMR4aYZUNUwI7KOrHNbuJnizm28f5P/DewCDQcNQEzIpSuneZOobLXCvdMEfN7l6FOTPYtyEVCk/lJwxpXR701NAluwIrViVVuXOF+vdtY6j1968vY65Uir/uYhxslmb7PLdldnXcKJRja6DagDEBdqtkNjcvo1CsRApIcY43cnBsSsA1LjHaBYTJkRz3d1Jy85oz7YBoIhegWTQbcZCVX7txYgrLlLJpO3Bmk0MfwiW/5GzTbRHnqt7CJTesbJqWhM4s+y4kd54kl9UIsttkcvSKabXB12GoPa2TEpiWWmLEibMk+nT2MtXjOxCjHUUmiHxcjHy7acOQvvy9EnOZe6vDwzICp8tcqEZ9BL+73kzXJSak6CWBJTFAu6tUn4pMwdNRfYxyuzr+fq5h0sux04qqiicmVa8Sir2+tf8OrBZ7IaJhDEtt71Kddc0I61G09JIFFbTNv74oeHyUVB63Sw358vt4+b2Wog1KiyEJKi/DdGvAKWPC4ku/76fixMbx+tE4zhTsysX1zwcn32w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(346002)(376002)(921005)(186003)(7406005)(478600001)(52116002)(316002)(38100700001)(6486002)(16526019)(36756003)(8676002)(5660300002)(7416002)(8936002)(83380400001)(66946007)(2906002)(66556008)(86362001)(31686004)(66476007)(31696002)(45080400002)(53546011)(966005)(2616005)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmh0aytheE95Z00yT3RHc3FWZjJoTHRKZVByQ1F5Q1lDV0J1Y0tYS3RiVTRB?=
 =?utf-8?B?NjJXR0hSYk1vbHM0RnNiREI2RXo0K2Y0UnVjU0h1U3ZVc1k5VkIwMzFwd0tR?=
 =?utf-8?B?MDdVQWJycm0wa2RIK3pUV3pWdEMxa25PT0tiOE5xQ3ZUYWtXVEE2Z09ZRE1J?=
 =?utf-8?B?SkZOL3A3TngyV2lLcFlUMXJmMVJNWE1xTWdwalJNWUNkb2lRWUxvVnI0QmNI?=
 =?utf-8?B?bHIzNW5kVjhVakxGTWVpWjdkcWsxeVhJQnovMFF3SmVqV2ZFaTcxOEtKSkd0?=
 =?utf-8?B?UVBoT0M3R3ZiSEpBUTJRUXh5YkRuK0tPajN5aHlmWkY5YXA3L2d5dUpDL3U5?=
 =?utf-8?B?TmpFdTY2U1RVQS9pYjhlMFBOQVNIS0xqL2JQYU1NMGdHUXJTVFROeXI2QXNj?=
 =?utf-8?B?ZXZLeGpkQzJPR2FROTY0M2REcmhNQXZMUzFSL3FNRjM3NlFLOEtHVm9aNHJL?=
 =?utf-8?B?My9EWHpwNlVod2hUS3RDZHBnZ1lkYzJhZTVINTAzWWkxV2g1L1A2MU1ja2xM?=
 =?utf-8?B?MERGc1BpVHBSMkhjQ1Z3VlM2b3JiZ1dnemZGMUtrUU16UW5NZjAzc1ZNUGov?=
 =?utf-8?B?R2xxWDhBblpqcUdFaS9uVTZvSHlpUUxuSkNvd1YzeWZENnZNdFZGY29RZ3c0?=
 =?utf-8?B?Y1dKUGNobzVKOTFWVXlaM0FQVVJFbCtmZ290L1dpTEVjRE4rR2xFeFJEcmta?=
 =?utf-8?B?empuUnY0MWpIT3huZnBWK2plUEc3K2syVitEUEdQQjNsSlJGZWdwM2NVVzB1?=
 =?utf-8?B?VW1GTWFaZHBqNFgvSjVMYkszSmdVdWMxZGlNOVp1ZHlVemczUnhuNEVTb2hh?=
 =?utf-8?B?anA2L3E1WHhtVVFJVCtqcUtYRDl0aW94QW45M1FURGxmQkQyV3BOdGpRMHFj?=
 =?utf-8?B?TUtxK01RRmJCaDNuZFV4TmxITi9uWVJGNDd5eEZlVCs2aHF2dnRsYnkrWDJR?=
 =?utf-8?B?MVpnWFJyajJWalo2NWJVaEFsUTVFQ0o5ZUtFSzkxak8xUkFzNU5ia0lXdnFu?=
 =?utf-8?B?WWFPdGVLRnZBQWVOY2FYRlFLMlNCN1FrVU5LaW4yVitzSXFFT1YyZkNZd0U4?=
 =?utf-8?B?ZHFPckVBRjE1MUQrZTVBcDhlV1F0a1lNYzkxMTdHMFdyVGZKZ0ZkNHJTRFBL?=
 =?utf-8?B?aHl0L1NUT1VseDVvL09IeEs0Z3hGb3VTcEQ1UUEzTlc5VEtMTE03bTQzUTRF?=
 =?utf-8?B?VS9IK0hNS2lMM2ZrcjJDUlFML2s5UDZlTzZPOWd0QW1CelZjWWZhUWxaelJK?=
 =?utf-8?B?UE5wOER1QlFabHZvTzd4MEdsUjVHM0t1QUtCeENtcEc1UUxIR2RYRFJuQU5N?=
 =?utf-8?B?VWxWZVhqMFpwOVI5dDRkSlAvakk1VHNIbDUvNHBiN1pUWXZHaFA0QkN4SFJJ?=
 =?utf-8?B?SHpCZVFEVlVqWTNSYU43VU5XSVBQbVlvNzBiSzExak9ZRDhrSGdsSVlvUmY1?=
 =?utf-8?B?cnFvbzRwOUMySEQraDFrWU9hdkhDakJ5Z3ppcW9BS1dzWVB3ZXl1OUpRbW1q?=
 =?utf-8?B?MU9lRVZJdmIxSmM3ZTVUdG1jbXBZRGxwaFY3UXAwUkZubk5vL1VxYlhvRlNE?=
 =?utf-8?B?bEhTeDlCTGkrd0VZSW9mYlhGWCtPSXJOZytQU2djNXVHWW9ZNnVUWGZnM2lN?=
 =?utf-8?B?OXhiMXdsMDhSenBldnl6dnNXQUd0K3RLMFUxbkc1QzdyUXRTb01RM2xmUjRX?=
 =?utf-8?B?aGdDTUNvdFNFeTdhTVd2MWFNQ2xBNVp3dnJvQ0gxNDd2ZjVrTmtnVzRYYU5G?=
 =?utf-8?B?OUMrSFJhVDBCTGU3U3FRalNqNk1CR2VSRUNwM29wT01OVktxNDNPVFFzT1ZY?=
 =?utf-8?Q?Rrov4MKukgHf9XLYTIWx+CHMzAVQdr6bC2j+o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9304c47b-37be-410f-2f50-08d8f56ff675
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 00:40:49.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvPv6OsSbbpL7JnVVvMSt3l4/jPhPjWw5b49bcGWSzk4rXteWjJXpc/SniJrGVDG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2288
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: whYYOKGMS60rlpSJEHPqNRGB6nMqQYTY
X-Proofpoint-ORIG-GUID: whYYOKGMS60rlpSJEHPqNRGB6nMqQYTY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 12 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_14:2021-04-01,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 bulkscore=0 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103310000 definitions=main-2104020001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/1/21 3:05 PM, Yonghong Song wrote:
> 
> 
> On 4/1/21 4:29 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    36e79851 libbpf: Preserve empty DATASEC BTFs during 
>> static..
>> git tree:       bpf-next
>> console output: 
>> https://syzkaller.appspot.com/x/log.txt?x=1569bb06d00000 
>> kernel config:  
>> https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f 
>> dashboard link: 
>> https://syzkaller.appspot.com/bug?extid=774c590240616eaa3423 
>> syz repro:      
>> https://syzkaller.appspot.com/x/repro.syz?x=17556b7cd00000 
>> C reproducer:   
>> https://syzkaller.appspot.com/x/repro.c?x=1772be26d00000 
>>
>> The issue was bisected to:
>>
>> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
>> Author: Mark Rutland <mark.rutland@arm.com>
>> Date:   Mon Jan 11 15:37:07 2021 +0000
>>
>>      lockdep: report broken irq restoration
>>
>> bisection log:  
>> https://syzkaller.appspot.com/x/bisect.txt?x=10197016d00000 
>> final oops:     
>> https://syzkaller.appspot.com/x/report.txt?x=12197016d00000 
>> console output: 
>> https://syzkaller.appspot.com/x/log.txt?x=14197016d00000 
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the 
>> commit:
>> Reported-by: syzbot+774c590240616eaa3423@syzkaller.appspotmail.com
>> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 
>> bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
>> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 
>> bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
> 
> I will look at this issue. Thanks!
> 
>> Modules linked in:
>> CPU: 0 PID: 8725 Comm: syz-executor927 Not tainted 
>> 5.12.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>> BIOS Google 01/01/2011
>> RIP: 0010:bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
>> RIP: 0010:bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
>> Code: e9 29 fe ff ff e8 b2 9d 3a fa 41 83 c6 01 bf 08 00 00 00 44 89 
>> f6 e8 51 a5 3a fa 41 83 fe 08 0f 85 74 fc ff ff e8 92 9d 3a fa <0f> 0b 
>> bd f0 ffff ff e9 5c fd ff ff e8 81 9d 3a fa 83 c5 01 bf 08
>> RSP: 0018:ffffc900017bfaf0 EFLAGS: 00010293
>> RAX: 0000000000000000 RBX: ffffc90000f29000 RCX: 0000000000000000
>> RDX: ffff88801bc68000 RSI: ffffffff8739543e RDI: 0000000000000003
>> RBP: 0000000000000007 R08: 0000000000000008 R09: 0000000000000001
>> R10: ffffffff8739542f R11: 0000000000000000 R12: dffffc0000000000
>> R13: ffff888021dd54c0 R14: 0000000000000008 R15: 0000000000000000
>> FS:  00007f00157d7700(0000) GS:ffff8880b9c00000(0000) 
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f0015795718 CR3: 00000000157ae000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   bpf_prog_test_run_skb+0xabc/0x1c70 net/bpf/test_run.c:628
>>   bpf_prog_test_run kernel/bpf/syscall.c:3132 [inline]
>>   __do_sys_bpf+0x218b/0x4f40 kernel/bpf/syscall.c:4411
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46

Run on my qemu (4 cpus) with C reproducer and I cannot reproduce the 
result. It already ran 30 minutes and still running. Checked the code, 
it is just doing a lot of parallel bpf_prog_test_run's.

The failure is in the below WARN_ON_ONCE code:

175 static inline int bpf_cgroup_storage_set(struct bpf_cgroup_storage
176 
*storage[MAX_BPF_CGROUP_STORAGE_TYPE])
177 {
178         enum bpf_cgroup_storage_type stype;
179         int i, err = 0;
180
181         preempt_disable();
182         for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
183                 if 
(unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != NULL))
184                         continue;
185
186                 this_cpu_write(bpf_cgroup_storage_info[i].task, 
current);
187                 for_each_cgroup_storage_type(stype)
188 
this_cpu_write(bpf_cgroup_storage_info[i].storage[stype],
189                                        storage[stype]);
190                 goto out;
191         }
192         err = -EBUSY;
193         WARN_ON_ONCE(1);
194
195 out:
196         preempt_enable();
197         return err;
198 }

Basically it shows the stress test triggered a warning due to
limited kernel resource.

>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x446199
>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 
>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 
>> 01 f0 ffff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f00157d72f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>> RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446199
>> RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
>> RBP: 000000000049b074 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: f9abde7200f522cd
>> R13: 3952ddf3af240c07 R14: 1631e0d82d3fa99d R15: 00000000004cb448
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See 
>> https://goo.gl/tpsmEJ   
>> for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status   
>> for how to communicate with syzbot.
>> For information about bisection process see: 
>> https://goo.gl/tpsmEJ#bisection 
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches 
>>
