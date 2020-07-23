Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE2722B5BC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgGWScr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:32:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13148 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727844AbgGWScq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:32:46 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NIBv2X017808;
        Thu, 23 Jul 2020 11:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Irk+3+L9vCylPy4uogjYO1Ua/aHfdD0+DH/FDG9EBD0=;
 b=koD6A8HlPgTccmpe4xvKkUbi5LYuMQ47V63rVrktanMkEdo1lHN95IeG1ohe4EEzn0lO
 0LPsvfzVRy8nKr6qOx5O71ZPz91wdkLeJDwex91isr8Y1KIEgciCnRGRN0E5U/9a/K67
 FvC4cA0iGZNZcmGous69F/PMLJwHlc1fQBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32etbg5k49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jul 2020 11:32:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 11:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koU8Z1mM5IGKDSNf4nwOXBQz6eMzGEkVpZ+peDrPGdfoVnTKPJop3ECHBWsXuxp/2NgJS4zc5y0gOWdFVf/X4mkCJyflXBcNVE4oawtKmME8u0UI4/WQbnes0bca72rkEASd9Gjqvt9FJ1+xzN8W1rcrrXhZL/89KUFFDG21iqgWL9XoCMwfbcv1g/d1epRi1CfcQ8Kmxu9lpRyFCC6mQoWSbAtJKw6QSXO9Jq+v9HCgTq6r35dKDOhYfHLRdIkf7yiR7jr8llNDM8DPqgSfHKi2jMBiZxzrCWBW7fU2VpW3TDNTFdz65XTN5EJhFpqyi1aqm/vqdvQNw4WybUNr7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irk+3+L9vCylPy4uogjYO1Ua/aHfdD0+DH/FDG9EBD0=;
 b=gxP/O4rNtPq8tpyR6ZFtUOdojCAyLjtORobJQJofge4cUD+hn9bYU3TCiuaAsvop1b+PkqrF/KixcAVxpcC38KCm5lu8VWjS5ef988q/IyzCZVpALQX6spgRHU9vctb9t2VFf8JIm0TxQ3s2s1lKohULIkOKPFA9j09K8mq5LOcjEmxWc5n9RLics9JiSoZMn4XTTdZqRtqeP1XBFezUqTeTaqqJIMkopxcCUHlJ/mrlErSoFgeWCa1DZpvWmR7P4w2wQarDv2/jUI+D3L6E2x+NhSzMYuz62g8uU1qfALDhqIENpTRdIrtHUr3OoCRkxAX698yKkBSOOQiCJAbAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Irk+3+L9vCylPy4uogjYO1Ua/aHfdD0+DH/FDG9EBD0=;
 b=Vrfm5MznCuxyrdHsrHVPcjZ2159pMEK3EptgLIdhQcGls7Q6EUf61N2yQRiGjhVJUrIcAsD9mI4mVdOcnzR5vSLabQJiezUZyXgtWmqQO2TfN6Ugsp2zDSoccUWLo2utQIMoxhaipCSoIk0jtBvjuA0OkngMEXxPcsXLEwQnihw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 18:32:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.021; Thu, 23 Jul 2020
 18:32:30 +0000
Subject: Re: [PATCH bpf-next v3 00/13] bpf: implement bpf iterator for map
 elements
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
 <20200723065329.yuw4dey27n2w5a4i@ast-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <331af4d8-5479-39b0-b835-a0e7144135e7@fb.com>
Date:   Thu, 23 Jul 2020 11:32:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200723065329.yuw4dey27n2w5a4i@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:254::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1888] (2620:10d:c090:400::5:aed) by BY3PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:254::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Thu, 23 Jul 2020 18:32:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:aed]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b4838b6-1bf7-40dc-7ba5-08d82f36c1a8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566C90C4D85B00063D17558D3760@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EsTrNHfX/gz421OLfHUXMa2qQm/sytNtO49F1VAjeGrvfyfBmihLNbhuwAIjQT5eeyP6rfYyt+yzp813h+5JqF8CBc4knPwXRqIXGwXYWqiuaTPzxjJC4P+Vj/O3vamZWwrbjd/JoWwCxTHrhpvEgGQO3JC2PRwzMcfiOM7ayrYvgbFeb09XEXiasnWkRiA3K2nJmztM4nPEusfaekJGrQ2mcdUFbGLuCIMs8kWn8OqSwchOuYEiKKgRXaKrTHuTVeU2571jjysrbUfO0a9B6uQqdzKF3pV5gNajibmb8KPUi8Go43PpZ6RP44zQBqsw8vWPy8kM68MFOwT4eUHrgTUStWxzy9O0s14gSdjcnQYZHYeYizNhOWqT43wfpU4y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(31686004)(2616005)(478600001)(186003)(53546011)(52116002)(6486002)(66476007)(36756003)(66946007)(8676002)(6916009)(316002)(31696002)(54906003)(83380400001)(4326008)(16526019)(5660300002)(8936002)(66556008)(86362001)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sBEI3QqxcGqsChi3MbAcD32mTSf/apMt2UghSfKxFRh5D5FVlKHOGatnXoPnI0thLdKJ2hKYJ7WqcjVhPvxaT9+ZI/ltn7UDx7FJVXPG04e6WB45ObVBCtQeE2ivqgFCd56XpVreyRaQK1HcQYUDBarvhtWd436GLBllpTpacyzzY+Kr1ZLj/vbIQS4sZluFI6mYtUlnAqBJovoX3MY49F+aXHnzIlWZPB0kSEZ0YFfUXUAH+KZ6CJ2DQI670iA5i90ZgISolBB2S5woTCAeh1jcYgcHTA6uXpUev7tPHMqKY2Ym2QQFt3F5UcdRSglTxY7koelvOLfg3LntR/3uDrsKMYga3/lYjyAiJ0/73Lb9vGGYepGL8ZRHKa5e1BhN/+/xyTu0PJrhgGgv7uDu/2KvSbavxzPsw0UH9GhgchHfhP+bnIRJCWKgzgGS0ozMzhf3OVCRsd1c2q1tjhTrZ0kcu7A4Y8SqM7SKX064H7Wj/lrBeGIUA5jU05YNEX48E0XKZP4YjUIRD9NjjHJaGA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4838b6-1bf7-40dc-7ba5-08d82f36c1a8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2020 18:32:30.1875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M48bgZF2/k7UoVz2CmyfTB8cVBrSC84WdP7DdN/Uw0PGGhrX0VSXwFve67E9J+GO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=2
 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/20 11:53 PM, Alexei Starovoitov wrote:
> On Wed, Jul 22, 2020 at 11:15:33PM -0700, Yonghong Song wrote:
>> Bpf iterator has been implemented for task, task_file,
>> bpf_map, ipv6_route, netlink, tcp and udp so far.
>>
>> For map elements, there are two ways to traverse all elements from
>> user space:
>>    1. using BPF_MAP_GET_NEXT_KEY bpf subcommand to get elements
>>       one by one.
>>    2. using BPF_MAP_LOOKUP_BATCH bpf subcommand to get a batch of
>>       elements.
>> Both these approaches need to copy data from kernel to user space
>> in order to do inspection.
>>
>> This patch implements bpf iterator for map elements.
>> User can have a bpf program in kernel to run with each map element,
>> do checking, filtering, aggregation, modifying values etc.
>> without copying data to user space.
>>
>> Patch #1 and #2 are refactoring. Patch #3 implements readonly/readwrite
>> buffer support in verifier. Patches #4 - #7 implements map element
>> support for hash, percpu hash, lru hash lru percpu hash, array,
>> percpu array and sock local storage maps. Patches #8 - #9 are libbpf
>> and bpftool support. Patches #10 - #13 are selftests for implemented
>> map element iterators.
> 
> kasan is not happy:
> 
> [   16.896170] ==================================================================
> [   16.896994] BUG: KASAN: use-after-free in __do_sys_bpf+0x34f3/0x3860
> [   16.897657] Read of size 4 at addr ffff8881f105b208 by task test_progs/1958
> [   16.898416]
> [   16.898577] CPU: 0 PID: 1958 Comm: test_progs Not tainted 5.8.0-rc4-01920-g6276000cd38e #2828
> [   16.899505] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
> [   16.900405] Call Trace:
> [   16.900679]  dump_stack+0x7d/0xb0
> [   16.901068]  print_address_description.constprop.0+0x3a/0x60
> [   16.901689]  ? __do_sys_bpf+0x34f3/0x3860
> [   16.902125]  kasan_report.cold+0x1f/0x37
> [   16.902595]  ? __do_sys_bpf+0x34f3/0x3860
> [   16.903029]  __do_sys_bpf+0x34f3/0x3860
> [   16.903494]  ? bpf_trace_run2+0xd1/0x210
> [   16.903971]  ? bpf_link_get_from_fd+0xe0/0xe0
> [   16.907802]  do_syscall_64+0x38/0x60
> [   16.908187]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   16.908730] RIP: 0033:0x7f014cdfe7f9
> [   16.909148] Code: Bad RIP value.
> [   16.909524] RSP: 002b:00007ffe1d1e8b28 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
> [   16.910345] RAX: ffffffffffffffda RBX: 00007f014dd27690 RCX: 00007f014cdfe7f9
> [   16.911058] RDX: 0000000000000078 RSI: 00007ffe1d1e8b60 RDI: 000000000000001e
> [   16.911820] RBP: 00007ffe1d1e8b40 R08: 00007ffe1d1e8b40 R09: 00007ffe1d1e8b60
> [   16.912575] R10: 0000000000000044 R11: 0000000000000206 R12: 0000000000000002
> [   16.913304] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000002
> [   16.914026]
> [   16.914189] Allocated by task 1958:
> [   16.914562]  save_stack+0x1b/0x40
> [   16.914944]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [   16.915476]  bpf_iter_link_attach+0x235/0x4e0
> [   16.915975]  __do_sys_bpf+0x1832/0x3860
> [   16.916371]  do_syscall_64+0x38/0x60
> [   16.916750]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   16.917338]
> [   16.917524] Freed by task 1958:
> [   16.917874]  save_stack+0x1b/0x40
> [   16.918241]  __kasan_slab_free+0x12f/0x180
> [   16.918681]  kfree+0xc6/0x280
> [   16.919024]  bpf_iter_link_attach+0x3e3/0x4e0
> [   16.919488]  __do_sys_bpf+0x1832/0x3860
> [   16.919915]  do_syscall_64+0x38/0x60
> [   16.920301]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Thanks for reporting the bug. The gcc on my system is 8.2 and the
requirement for kasan support is gcc 8.3. Using clang, I am able
to see the issue. Will fix and re-submit. Thanks!

> 
> To reproduce:
> ./test_progs -n 5
> #5 bpf_obj_id:OK
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> ./test_progs -n 4/18
> #4/18 bpf_hash_map:OK
> #4 bpf_iter:OK
> Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
> 
> ./test_progs -n 5
> [   37.569154] ==================================================================
> [   37.570020] BUG: KASAN: use-after-free in __do_sys_bpf+0x34f3/0x3860
> 
