Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC569312761
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 21:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBGUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 15:16:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34808 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGUQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 15:16:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 117KFPws138170;
        Sun, 7 Feb 2021 20:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n9FKvLQAeczvZoswT61qOyu+7DB7dC4v0hm4srGbWLw=;
 b=DxBWega8JtxbrotR/g7lUJFNMHpkcMS6X0K6pRhUF9UAlzH6J7xiv//LIuN9L+SIxZ8v
 7aMkD/RIdX1OETmH6p1E/vLQk8Rm6gICYp67vaPXr1tiYR+Y+EhZInJUfwd4AnsDoACM
 B20r9Ylg5Q6rwed5U3lPHG+AP+F9teCkDYoyex6ZOwvR5ZMBaN2z4SdvfzFlW/opRIRf
 s12/kHqtYZhCpvnTaD7gx1c+RMCryteVjU3yx4+9nM9YIjvb3qBwY0hw0EQQD44B78LY
 YRDYTVMf+mmcSmyghccYstv2RUv8DaPE9FhH7vDYArhm1Vz7dVPdxOZuiRphfDyFKnhM gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqj988-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 20:15:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 117K6WbJ139925;
        Sun, 7 Feb 2021 20:15:55 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2052.outbound.protection.outlook.com [104.47.36.52])
        by userp3020.oracle.com with ESMTP id 36j4vp3a7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 20:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mto68rbIBmhEvT27m9lXhE3u6WC461JFsV8PDuRLb7EBwdnugSNzILLzmwG6Z/jsgxvu220T3yAgo915kZ5/oWA+hgbfSFv86ingUyHT/A75xE6Dds35nLl+NVazKFz9SRlmECgQ1f7CPqut6+FAKfwR3toVFjL8KLogYumthTv6zDrYeBRexIEZgHphMb54ZydIAWyzU2CPnHnei21l7hbbdEIxWlBHoUwepU6nQZ2L9kMdK9YU4ES+uKO9bbpBS+trS5rlxAjWSAcyaVUTBWK3aUiYpojTVju9IHbAljleAirfrn9yNlsepou9Sjo2t73uR+gik96aaYiE9pduTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9FKvLQAeczvZoswT61qOyu+7DB7dC4v0hm4srGbWLw=;
 b=ZzcLJJYr2Moxy63pAk60QVTHWaKyXGg37XAVd0HLH97Ur/sJlwBMpSyODvVwtCbS2iTSVKSv3Y16vMpvxEGcvHZXd1zoXqVJ6rtRwRNW2HuKGQDuqL0HD0lK8r3L9BTDeVS2NsJf3uHPrxddF/6yMqe2EzjtyLEqlkkXO8erStP6XMjlVJ6u/fJiEUY3Ao5r5I5GA601UC2ZRmt3BTbJ6w6/NOukIAyaK15PzYQkI3yUCz9FHqrqjdvKebcnAn7j+au+gr0lHVfAbVBQ0ogrLqe6Sw/p1JbSW35yk7pUf/E+5IMJBJXZWveQtQn6DelIvzmiIG9WQQ9SQz9QlPLVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9FKvLQAeczvZoswT61qOyu+7DB7dC4v0hm4srGbWLw=;
 b=xsG3Z9DIf5RLV+VCqXtE5MJonwkoBGQRk3ssx+h1WAG9Apxutt8+i+Vjsb4yIkY82Tt6J/VT4xuJu8DbXlxg69q9qrm3mSHJu9cYmIX6/UJW1j0P+RV/oeAoiV0QCvBFfvHxVbiRbNQHeRA0tI4Uo4RNqnOsr4WnbNhpzCZQw48=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SJ0PR10MB4590.namprd10.prod.outlook.com (2603:10b6:a03:2d1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Sun, 7 Feb
 2021 20:15:53 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::b52e:bdd3:d193:4d14%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 20:15:53 +0000
Subject: Re: [vdpa_sim_net] 79991caf52:
 net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section
To:     kernel test robot <oliver.sang@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com
References: <20210207030330.GB17282@xsang-OptiPlex-9020>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <3f5124a2-6dab-6bf0-1e40-417962a45d10@oracle.com>
Date:   Sun, 7 Feb 2021 12:15:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210207030330.GB17282@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700::a4a4]
X-ClientProxiedBy: BYAPR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:a03:54::14) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::a4a4] (2601:646:c303:6700::a4a4) by BYAPR02CA0037.namprd02.prod.outlook.com (2603:10b6:a03:54::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Sun, 7 Feb 2021 20:15:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3edfe2e2-6469-4590-fe68-08d8cba52b29
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4590:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4590C20388B0D4FFB2CB089DF0B09@SJ0PR10MB4590.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8bDo9aVN3sQpPWTrEbNCSrsr1YoteL6k4MuJjrgQbg6Q6pqj4qVyJ6VmH0mTcrC7XznChmkyM615s1IetZ7MRjuJ273rUUO1TljsO+6RHC33b8Guu4zLuR3b8JqR1L0rTrbQ+huOdTocHrVCMMeNx0Y4JDBVd6zoFw+lmF35DuhwBhwj4CERWorzWbJCat/3suTe/XzdvNXyb5zKdSZzzwHmz4DId4tc2wjqritELIN5Bz2aPNBJS5U9wi/8l4vQujKSiauBlaOep2y+/wqa/0MnovHrEmB5V/2QnLpTNMHkBJuP1Vy/WsSgffrh24psUkZz3EdpVelgL8V5DYkWqQ1OVEvRU/+9l8KxAtoTHp4Fdb3CYJJKdPIRYseSrO8z8gVSNm+E7suAQuDe4IlKArzbjDz8KyG+LMdxynoHro5FJEmiOivteC8+mRN7bjamjK0bxocn+kBvwpZ8hOStDMGYNUygqd6dH49ekapyIBbDltZ6mzJk4gt/wa+Bj2RRcLdjkId3OAJTO/lgvsIcDQsptCOYfRE4faeGDTkhjlfU1r07umY6S3zRXc4trq00lzy9qvKBAE59kiTkdT6QYFYRTHlubkY0COeMmXlvWTAXOcTv3vqCAxe2/BRPlpVa0ITNT6ZgzCbkurT2nG4ic5UuM7dVN77/5mcrjeu166TYISi815p4In0ls67DW2V3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(16526019)(478600001)(4326008)(66946007)(83380400001)(66476007)(66556008)(966005)(186003)(86362001)(107886003)(8676002)(31686004)(44832011)(6916009)(316002)(8936002)(54906003)(53546011)(2906002)(7416002)(31696002)(5660300002)(6486002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?ndbBgHnGJpRApKE9pSQxHkuMv2B9c7oOwrw9pj9xnnbGdLvV66ufJLLB?=
 =?Windows-1252?Q?qmvY4SBVQ20KDvxGLkr6WeT7fPcCoKQiqhUxcsDepZqUxGCJwM/KMu2R?=
 =?Windows-1252?Q?gSprvDDqddt2tOvHahtzncsDarcWouCWPv28tEtqLJxZZ1sLYTiGgkN8?=
 =?Windows-1252?Q?M4tmCCrz4uvQz8qZMeXgCqc9pTYkRfMzfkAKIKRaGj6QvciKDBhQiP6E?=
 =?Windows-1252?Q?L1pBXg4EM6meDD24xR87WdU5FFsjqoFi1EjQ5NXoZI//zmJVgwTOibxg?=
 =?Windows-1252?Q?CxxDANxbxCqZs7XJAzvmfrxH31rRPHdkBghTfF9asevsqOuqPBWlU72z?=
 =?Windows-1252?Q?7+p8HgRywyFEpLIZTzM01jiUsWXkg6eyo2nzC3Yu4ZnP4HZCLlfRMAvJ?=
 =?Windows-1252?Q?IHYjayoVkyGFN9/xiOKgHLPZXcTI6xlP3URT+wVKQN7LJGUrhXnv74q1?=
 =?Windows-1252?Q?DiVK0PMpzJxUJUEkE1kF/Tg6C1wMsAaF0fzDWrU5Y4NCuBTMpS9AV9OT?=
 =?Windows-1252?Q?E+tRfWAwjZdRAMz+5PBypD6MiyQaqMS7VkBjYFrPOwKJyP8x8cUjlca/?=
 =?Windows-1252?Q?VnfwfU7qMi4a8aHSVezOzewQmn7XZNxaV3w4Wine1XlG8i29zC9GZECV?=
 =?Windows-1252?Q?x+wTKsiEVBFDWhZur/+Osypvssx6STrIKeRtzeFFpnEODndfOBGOz/sv?=
 =?Windows-1252?Q?FDszEpd5/DpSRtanfqYmhhVSp+I3pp4SvddWpN68MWaeQUIOK+QpiP2P?=
 =?Windows-1252?Q?mzCrHIYP4/ylcP8/9RTfY8bbPRGwxV4ymC1SuOHo11e8Fr0GzRbDkq3h?=
 =?Windows-1252?Q?UI0ulBSjoWD8oLbuogGx4jT285thkj9oIuJXGncSZ+Z7n+7PEqBPF6EW?=
 =?Windows-1252?Q?DgjlKV9X0HlrEWKtGnvAwSuQRbM5iZixil5TSU2RB8h2Io4Gj/cqCyU7?=
 =?Windows-1252?Q?lnR/LKIwcgq1YUGHm4iDUAqYEmHFgLJ+m3SdSboRELESe6Qyb9C4DoGh?=
 =?Windows-1252?Q?JMpXWOZMg2BvZzhtN4zUSsxsYS9+pCKQhIhylzU3mA2NRsScOc7/Dr7I?=
 =?Windows-1252?Q?1RHyz0QvF5Ck6lgaWeVRCk1E5BHdGthcfwCzTTJlNsEI4YFDKCzTnKr5?=
 =?Windows-1252?Q?fabRtCk8YlDprnWPdS++avdto7GK6ONrLp6zqy+kaLy/wx5UvsEkwVb+?=
 =?Windows-1252?Q?DzYQ6n1Pan2NUpiZtTmKxmYDc1ScuAv7RZod7qq0u52Czzt+GzPN7exP?=
 =?Windows-1252?Q?RqaM/j7DSAIo8aEu98l/xR2xGxDDJa5Wr48hEa5xXSuBn4kumcDBWmPY?=
 =?Windows-1252?Q?SvFUN5ZiPNx+Ncqm2ChffYkIvTSCvcBIZbfTyqByYqHt7opQlktWV6S5?=
 =?Windows-1252?Q?DwStnunpKJTnYYoVlZ6adZvMNCsqT8srfBXQQJ90wEKH2huSPiPNDH7j?=
 =?Windows-1252?Q?9VWV6LbyE2tT34DXVqU+Hg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3edfe2e2-6469-4590-fe68-08d8cba52b29
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 20:15:53.1937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oSkubPpBqTRHJoRL/mLm0VVcoJTxC955durJMKR5Yc5ksEgCAGMS/f/lzXdlu9hUT+iOGFONEvd4ro8aDme3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4590
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102070145
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070146
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is it possible that the issue is not due to this change?

This change is just to call different API to allocate memory, which is
equivalent to kzalloc()+vzalloc().

Before the change:

try kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);

... and then below if the former is failed.

vzalloc(sizeof(*vs));


After the change:

try kmalloc_node(size, FP_KERNEL|GFP_ZERO|__GFP_NOWARN|__GFP_NORETRY, node);

... and then below if the former is failed

__vmalloc_node(size, 1, GFP_KERNEL|GFP_ZERO, node, __builtin_return_address(0));


The below is the first WARNING in uploaded dmesg. I assume it was called before
to open /dev/vhost-scsi.

Will this test try to open /dev/vhost-scsi?

[    5.095515] =============================
[    5.095515] WARNING: suspicious RCU usage
[    5.095515] 5.11.0-rc4-00008-g79991caf5202 #1 Not tainted
[    5.095534] -----------------------------
[    5.096041] security/smack/smack_lsm.c:351 RCU-list traversed in non-reader
section!!
[    5.096982]
[    5.096982] other info that might help us debug this:
[    5.096982]
[    5.097953]
[    5.097953] rcu_scheduler_active = 1, debug_locks = 1
[    5.098739] no locks held by kthreadd/2.
[    5.099237]
[    5.099237] stack backtrace:
[    5.099537] CPU: 0 PID: 2 Comm: kthreadd Not tainted
5.11.0-rc4-00008-g79991caf5202 #1
[    5.100470] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.12.0-1 04/01/2014
[    5.101442] Call Trace:
[    5.101807]  dump_stack+0x15f/0x1bf
[    5.102298]  smack_cred_prepare+0x400/0x420
[    5.102840]  ? security_prepare_creds+0xd4/0x120
[    5.103441]  security_prepare_creds+0x84/0x120
[    5.103515]  prepare_creds+0x3f1/0x580
[    5.103515]  copy_creds+0x65/0x480
[    5.103515]  copy_process+0x7b4/0x3600
[    5.103515]  ? check_prev_add+0xa40/0xa40
[    5.103515]  ? lockdep_enabled+0xd/0x60
[    5.103515]  ? lock_is_held_type+0x1a/0x100
[    5.103515]  ? __cleanup_sighand+0xc0/0xc0
[    5.103515]  ? lockdep_unlock+0x39/0x160
[    5.103515]  kernel_clone+0x165/0xd20
[    5.103515]  ? copy_init_mm+0x20/0x20
[    5.103515]  ? pvclock_clocksource_read+0xd9/0x1a0
[    5.103515]  ? sched_clock_local+0x99/0xc0
[    5.103515]  ? kthread_insert_work_sanity_check+0xc0/0xc0
[    5.103515]  kernel_thread+0xba/0x100
[    5.103515]  ? __ia32_sys_clone3+0x40/0x40
[    5.103515]  ? kthread_insert_work_sanity_check+0xc0/0xc0
[    5.103515]  ? do_raw_spin_unlock+0xa9/0x160
[    5.103515]  kthreadd+0x68f/0x7a0
[    5.103515]  ? kthread_create_on_cpu+0x160/0x160
[    5.103515]  ? lockdep_hardirqs_on+0x77/0x100
[    5.103515]  ? _raw_spin_unlock_irq+0x24/0x60
[    5.103515]  ? kthread_create_on_cpu+0x160/0x160
[    5.103515]  ret_from_fork+0x22/0x30

Thank you very much!

Dongli Zhang


On 2/6/21 7:03 PM, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 79991caf5202c7989928be534727805f8f68bb8d ("vdpa_sim_net: Add support for user supported devices")
> https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-p61PJtI$  Dongli-Zhang/vhost-scsi-alloc-vhost_scsi-with-kvzalloc-to-avoid-delay/20210129-191605
> 
> 
> in testcase: trinity
> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
> with following parameters:
> 
> 	runtime: 300s
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: https://urldefense.com/v3/__http://codemonkey.org.uk/projects/trinity/__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-6Y4x88c$ 
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +-------------------------------------------------------------------------+------------+------------+
> |                                                                         | 39502d042a | 79991caf52 |
> +-------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                          | 0          | 0          |
> | boot_failures                                                           | 62         | 57         |
> | WARNING:suspicious_RCU_usage                                            | 62         | 57         |
> | security/smack/smack_lsm.c:#RCU-list_traversed_in_non-reader_section    | 62         | 57         |
> | security/smack/smack_access.c:#RCU-list_traversed_in_non-reader_section | 62         | 57         |
> | BUG:workqueue_lockup-pool                                               | 33         | 40         |
> | BUG:kernel_hang_in_boot_stage                                           | 6          | 2          |
> | net/mac80211/util.c:#RCU-list_traversed_in_non-reader_section           | 23         | 15         |
> | WARNING:SOFTIRQ-safe->SOFTIRQ-unsafe_lock_order_detected                | 18         |            |
> | WARNING:inconsistent_lock_state                                         | 5          |            |
> | inconsistent{SOFTIRQ-ON-W}->{IN-SOFTIRQ-W}usage                         | 5          |            |
> | calltrace:asm_call_irq_on_stack                                         | 2          |            |
> | RIP:lock_acquire                                                        | 2          |            |
> | RIP:check_kcov_mode                                                     | 1          |            |
> | RIP:native_safe_halt                                                    | 2          |            |
> | INFO:rcu_sched_self-detected_stall_on_CPU                               | 2          |            |
> | RIP:clear_page_rep                                                      | 1          |            |
> | WARNING:at_drivers/gpu/drm/vkms/vkms_crtc.c:#vkms_vblank_simulate       | 9          | 7          |
> | RIP:vkms_vblank_simulate                                                | 9          | 7          |
> | RIP:__slab_alloc                                                        | 3          | 3          |
> | RIP:__do_softirq                                                        | 2          |            |
> | RIP:console_unlock                                                      | 6          | 3          |
> | invoked_oom-killer:gfp_mask=0x                                          | 1          |            |
> | Mem-Info                                                                | 1          |            |
> | RIP:vprintk_emit                                                        | 1          |            |
> | RIP:__asan_load4                                                        | 1          |            |
> | kernel_BUG_at_kernel/sched/core.c                                       | 0          | 1          |
> | invalid_opcode:#[##]                                                    | 0          | 1          |
> | RIP:sched_cpu_dying                                                     | 0          | 1          |
> | WARNING:possible_circular_locking_dependency_detected                   | 0          | 1          |
> | Kernel_panic-not_syncing:Fatal_exception                                | 0          | 1          |
> | net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section               | 0          | 8          |
> | RIP:arch_local_irq_restore                                              | 0          | 1          |
> | RIP:idr_get_free                                                        | 0          | 1          |
> | net/ipv6/ip6mr.c:#RCU-list_traversed_in_non-reader_section              | 0          | 2          |
> +-------------------------------------------------------------------------+------------+------------+
> 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
> 
> 
> [  890.196279] =============================
> [  890.212608] WARNING: suspicious RCU usage
> [  890.228281] 5.11.0-rc4-00008-g79991caf5202 #1 Tainted: G        W
> [  890.244087] -----------------------------
> [  890.259417] net/ipv4/ipmr.c:138 RCU-list traversed in non-reader section!!
> [  890.275043]
> [  890.275043] other info that might help us debug this:
> [  890.275043]
> [  890.318497]
> [  890.318497] rcu_scheduler_active = 2, debug_locks = 1
> [  890.346089] 2 locks held by trinity-c1/2476:
> [  890.360897]  #0: ffff888149d6f400 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xc0/0xe0
> [  890.375165]  #1: ffff8881cabfd5c8 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xa0/0x9c0
> [  890.389706]
> [  890.389706] stack backtrace:
> [  890.416375] CPU: 1 PID: 2476 Comm: trinity-c1 Tainted: G        W         5.11.0-rc4-00008-g79991caf5202 #1
> [  890.430706] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [  890.444971] Call Trace:
> [  890.458554]  dump_stack+0x15f/0x1bf
> [  890.471996]  ipmr_get_table+0x140/0x160
> [  890.485328]  ipmr_vif_seq_start+0x4d/0xe0
> [  890.498620]  seq_read_iter+0x1b2/0x9c0
> [  890.511469]  ? kvm_sched_clock_read+0x14/0x40
> [  890.524008]  ? sched_clock+0x1b/0x40
> [  890.536095]  ? iov_iter_init+0x7c/0xa0
> [  890.548028]  seq_read+0x2fd/0x3e0
> [  890.559948]  ? seq_hlist_next_percpu+0x140/0x140
> [  890.572204]  ? should_fail+0x78/0x2a0
> [  890.584189]  ? write_comp_data+0x2a/0xa0
> [  890.596235]  ? __sanitizer_cov_trace_pc+0x1d/0x60
> [  890.608134]  ? seq_hlist_next_percpu+0x140/0x140
> [  890.620042]  proc_reg_read+0x14e/0x180
> [  890.631585]  do_iter_read+0x397/0x420
> [  890.642843]  vfs_readv+0xf5/0x160
> [  890.653833]  ? vfs_iter_read+0x80/0x80
> [  890.664229]  ? __fdget_pos+0xc0/0xe0
> [  890.674236]  ? pvclock_clocksource_read+0xd9/0x1a0
> [  890.684259]  ? kvm_sched_clock_read+0x14/0x40
> [  890.693852]  ? sched_clock+0x1b/0x40
> [  890.702898]  ? sched_clock_cpu+0x18/0x120
> [  890.711648]  ? write_comp_data+0x2a/0xa0
> [  890.720243]  ? __sanitizer_cov_trace_pc+0x1d/0x60
> [  890.729290]  do_readv+0x111/0x260
> [  890.738205]  ? vfs_readv+0x160/0x160
> [  890.747154]  ? lockdep_hardirqs_on+0x77/0x100
> [  890.756100]  ? syscall_enter_from_user_mode+0x8a/0x100
> [  890.765126]  do_syscall_64+0x34/0x80
> [  890.773795]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  890.782630] RIP: 0033:0x453b29
> [  890.791189] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
> [  890.810866] RSP: 002b:00007ffcda44fb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000013
> [  890.820764] RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 0000000000453b29
> [  890.830792] RDX: 000000000000009a RSI: 0000000001de1c00 RDI: 00000000000000b9
> [  890.840626] RBP: 00007ffcda44fbc0 R08: 722c279d69ffc468 R09: 0000000000000400
> [  890.850366] R10: 0098d82a42c63c22 R11: 0000000000000246 R12: 0000000000000002
> [  890.860001] R13: 00007f042ae6f058 R14: 00000000010a2830 R15: 00007f042ae6f000
> 
> 
> 
> To reproduce:
> 
>         # build kernel
> 	cd linux
> 	cp config-5.11.0-rc4-00008-g79991caf5202 .config
> 	make HOSTCC=gcc-9 CC=gcc-9 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
> 
>         git clone https://urldefense.com/v3/__https://github.com/intel/lkp-tests.git__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-Qkr9TyI$ 
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
> 
> 
> 
> Thanks,
> Oliver Sang
> 
