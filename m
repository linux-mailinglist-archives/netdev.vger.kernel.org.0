Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF35F1A49E7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDJSah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 14:30:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36458 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgDJSah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 14:30:37 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03AIOaco026127;
        Fri, 10 Apr 2020 11:30:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9MmObEknsVSQLrfKuTRSx0qFihBmU+MUkgc/jKi/R3o=;
 b=OQCvFe2vfjWEvGz5Q3YKPB4/rofnfJRzWmubLO5Yh5m98P6Fwk6E51blBsmEocu0kLWE
 sbY7ROgjoAbIArwfCF5gbJv1TqCHhEIRmtsOqrykwEFHFMK4z4KCRZFnt2MSlA8j5zPj
 1TKOMhD4r7bJzbAWhmgkUodvb4ligaGGQVM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30afb83e62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 11:30:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 11:30:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8131ltIz6BYUec7/JtGTv4jhJhyMZ6ySu5e4Mr0rMEGZ1ur72UOLrJ+kRlMpCuLkUrjZ46iWEZ26i234qaznKja+kVo4q876I+96qfKpdIG5x/esWNQDBt2of1jCwSCqOu5wxkP67pp8fVbxcJvQ0ZFbJTe4zWXTRKGx5mgxKeoLTye75DifL727/KuCSofJy5upXn1Hcn4gsE9u5GO8/36PywBBgp1h1uC1g6wJKKwt18VrPbinws8y+lpmhKY9Hb5WPpvCrDBvX09bDT19b6gtMhE15ltCVXo8qeJCeMO7BnCAZwCOMrdi6rbFHM97zCHAq2dew3ncQeDRpZffA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MmObEknsVSQLrfKuTRSx0qFihBmU+MUkgc/jKi/R3o=;
 b=JuMXcarGGhQVa177AzZzdd6U4g9rqpQcjzJESh76eGp/ETgnbhPozhysTDhhxBi/6ofJL9WCZ05v3sWz8lbaHUp+xZaZfBBO/CxlPzZUntNc63qv25+bU9VODlyfHDd6ZfPu2C/NTR0enWWP2aPkQVHOMVCjPtkXzbVCOyyCksE283d/vLBPKkqG4LlejOJCFqc8ztJyQdCDNDtL36C+MUlnZkNg4jm4eyzST7+dTOwPlHtRQMrnzt7kt5S03PV7dAnn/VEEjSDbeZEpTpQKs0/YrnBjaxEByGcg1o0aQoCFzc8kY3eW8bNFQU/84ZDdxjjsEuYbeaCdWdREeJuZ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MmObEknsVSQLrfKuTRSx0qFihBmU+MUkgc/jKi/R3o=;
 b=OQqJ9pGR9LinUWmfuNS9ZaXQ+aKI/JsH6IcDhdLw4vA1SP3yn3Ml1EzeGv5iey8Uw3kJuhj6FHl6AixLsMiekevEvKJKWlliIZi4FR1akbmgehJfdOUhLZajL8X20pqophD2ppkX5xEmsvfTV+pTVY6tiKEBziTkXkxZkPBRHU4=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3929.namprd15.prod.outlook.com (2603:10b6:303:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 18:30:20 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 18:30:20 +0000
Subject: Re: [bpf] 1bcd60aafb: canonical_address#:#[##]
To:     kernel test robot <rong.a.chen@intel.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <lkp@lists.01.org>
References: <20200409092024.GF8179@shao2-debian>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <02ad51bd-9924-af89-67ed-5894084827fa@fb.com>
Date:   Fri, 10 Apr 2020 11:30:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200409092024.GF8179@shao2-debian>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:300:c0::15) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2973) by MWHPR08CA0041.namprd08.prod.outlook.com (2603:10b6:300:c0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Fri, 10 Apr 2020 18:30:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:2973]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4370fff1-8c32-4c2d-c545-08d7dd7d39ac
X-MS-TrafficTypeDiagnostic: MW3PR15MB3929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3929FF88AD0CCDEC067FBC36D3DE0@MW3PR15MB3929.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(346002)(39860400002)(366004)(376002)(396003)(66476007)(478600001)(36756003)(6916009)(966005)(45080400002)(4326008)(6486002)(66946007)(316002)(6512007)(53546011)(8676002)(2616005)(8936002)(81156014)(6506007)(31696002)(86362001)(66556008)(186003)(16526019)(2906002)(54906003)(52116002)(31686004)(5660300002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7B3l7oJ/7ROTyNrYIqMbF8SRtTqK/qP6Y2jwUkYCB2fC7Ed7j4YpeAlvpmf/9V+eVo7sHzxIiMGCNS3LpPz6fO79fvChSJNnBK4S3/zDZWwu9WuZON8u5GCv/o3kZdE3WCmpIfJBEbHJoTBu6xTDXCDamrdGO+3gZih8rCgBQxMMg2gW/4IQxnmTVhBpb2Qtdw4qTQOp9q00pTkYocIlCMAu5mcTZEHGSzxUCeTjZ8lVvXSdmAVCCdCpdnD6ezZeJNfgagPy4kXMYN8j5Nkl2YYyUG0bsiIBNWAwHUz9gwgcJb01DxNOoFYXQnKjBOCqiVURGs/r44BeX8VpTVB+Xqg6T9Y0rUhH+lKiGAjV7EHsOCKCaTOCJ6fjUiTXM17rr1kMAuSEuEU39uZIpxFYsiqY98akbcpyIiRX8Q0/jVmXjToHivJSorV+BG0k6d11f+klW+Cy5yHIHkjgtmgS0iwsYmdbt0U86fr2o9MARnNzulk6qyaQZErS16nnFqv18FGqDyxxNJLKsrxIAlu51A==
X-MS-Exchange-AntiSpam-MessageData: qgJgK5M0AmvkKhuJHDTebf8bUGW9YkAHKQFU+PlB6z5KUliYCmtMXKXZMxKYt8+tqvrQ0UYZFQrwgzUKOriCNReVuO/rdNyWJxMh9MfUachIx7ouLo2VL30ISEn6q+xkwyhpjZlqAPu06iZs0UJbTmQevvmgyow1tg5gg7JjwR4czD/58PpC4bmPM88MJ7UY
X-MS-Exchange-CrossTenant-Network-Message-Id: 4370fff1-8c32-4c2d-c545-08d7dd7d39ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 18:30:20.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/4d/hHoh0REFlBGE7Z6tGFgZhqG2m0JgxW5ETie9fxVo+LD1RtbETHMSU89LRXM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3929
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_07:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=972
 mlxscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/20 2:20 AM, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 1bcd60aafb39b0258603f63d5f451d51ecad245c ("[RFC PATCH bpf-next 03/16] bpf: provide a way for targets to register themselves")
> url: https://github.com/0day-ci/linux/commits/Yonghong-Song/bpf-implement-bpf-based-dumping-of-kernel-data-structures/20200409-075105
> base: https://git.kernel.org/cgit/linux/kernel/git/bpf/bpf-next.git master
> 
> in testcase: boot
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +------------------------------------------+------------+------------+
> |                                          | 034a45e60c | 1bcd60aafb |
> +------------------------------------------+------------+------------+
> | boot_successes                           | 4          | 0          |
> | boot_failures                            | 0          | 4          |
> | canonical_address#:#[##]                 | 0          | 4          |
> | RIP:mntget                               | 0          | 4          |
> | Kernel_panic-not_syncing:Fatal_exception | 0          | 4          |
> +------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> 
> 
> [    0.701420] smpboot: Total of 2 processors activated (11999.99 BogoMIPS)
> [    0.704085] devtmpfs: initialized
> [    0.705366] x86/mm: Memory block size: 128MB
> [    0.710473] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.711845] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
> [    0.713988] general protection fault, probably for non-canonical address 0xcb7b8adb56376100: 0000 [#1] SMP PTI
> [    0.715820] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.6.0-02317-g1bcd60aafb39b0 #1
> [    0.715820] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [    0.715820] RIP: 0010:mntget+0xd/0x15
> [    0.715820] Code: 65 48 33 04 25 28 00 00 00 74 05 e8 9d e2 e5 ff 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e c3 66 66 66 66 90 48 85 ff 48 89 f8 74 07 <48> 8b 57 28 65 ff 02 c3 66 66 66 66 90 53 48 8b 47 20 48 89 fb 48
> [    0.715820] RSP: 0000:ffffc90000013e48 EFLAGS: 00010286
> [    0.715820] RAX: cb7b8adb56376100 RBX: 0000000000000000 RCX: 0000000000000000
> [    0.715820] RDX: 0000000000000001 RSI: ffffc90000013e34 RDI: cb7b8adb56376100
> [    0.715820] RBP: ffffc90000013e88 R08: ffffffff8209b97a R09: ffff88822a456370
> [    0.715820] R10: 0000000000000044 R11: ffff88822a04efd8 R12: ffffc90000013e84
> [    0.715820] R13: ffffffff8226c380 R14: 0000000000000002 R15: ffffffff826d566d
> [    0.715820] FS:  0000000000000000(0000) GS:ffff88823fc00000(0000) knlGS:0000000000000000
> [    0.715820] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.715820] CR2: 0000000000000000 CR3: 0000000002212000 CR4: 00000000000406f0
> [    0.715820] Call Trace:
> [    0.715820]  simple_pin_fs+0x75/0x98
> [    0.715820]  ? stack_map_init+0x48/0x48
> [    0.715820]  __bpfdump_init+0x5a/0xd7
> [    0.715820]  ? register_tracer+0x14c/0x1ac
> [    0.715820]  do_one_initcall+0x9d/0x1bb
> [    0.715820]  kernel_init_freeable+0x1c1/0x224
> [    0.715820]  ? rest_init+0xc6/0xc6
> [    0.715820]  kernel_init+0xa/0xff
> [    0.715820]  ret_from_fork+0x35/0x40
> [    0.715820] Modules linked in:
> [    0.715855] ---[ end trace 1e6dc54c74784c94 ]---
> [    0.717664] RIP: 0010:mntget+0xd/0x15
> [    0.719174] Code: 65 48 33 04 25 28 00 00 00 74 05 e8 9d e2 e5 ff 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e c3 66 66 66 66 90 48 85 ff 48 89 f8 74 07 <48> 8b 57 28 65 ff 02 c3 66 66 66 66 90 53 48 8b 47 20 48 89 fb 48
> [    0.719837] RSP: 0000:ffffc90000013e48 EFLAGS: 00010286
> [    0.721734] RAX: cb7b8adb56376100 RBX: 0000000000000000 RCX: 0000000000000000
> [    0.723831] RDX: 0000000000000001 RSI: ffffc90000013e34 RDI: cb7b8adb56376100
> [    0.726052] RBP: ffffc90000013e88 R08: ffffffff8209b97a R09: ffff88822a456370
> [    0.727834] R10: 0000000000000044 R11: ffff88822a04efd8 R12: ffffc90000013e84
> [    0.729939] R13: ffffffff8226c380 R14: 0000000000000002 R15: ffffffff826d566d
> [    0.731834] FS:  0000000000000000(0000) GS:ffff88823fc00000(0000) knlGS:0000000000000000
> [    0.734900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.735836] CR2: 0000000000000000 CR3: 0000000002212000 CR4: 00000000000406f0
> [    0.738028] Kernel panic - not syncing: Fatal exception

Thanks for the reporting! This is due to an uninitialized variable. Will
fix in the next version.

> 
> Elapsed time: 60
> 
> qemu-img create -f qcow2 disk-vm-snb-ssd-31-0 256G
> qemu-img create -f qcow2 disk-vm-snb-ssd-31-1 256G
> 
> 
> To reproduce:
> 
>          # build kernel
> 	cd linux
> 	cp config-5.6.0-02317-g1bcd60aafb39b0 .config
> 	make HOSTCC=gcc-7 CC=gcc-7 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
> 
>          git clone https://github.com/intel/lkp-tests.git
>          cd lkp-tests
>          bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
> 
> 
> 
> Thanks,
> Rong Chen
> 
