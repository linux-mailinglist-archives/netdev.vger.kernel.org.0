Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8687241C6FB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344498AbhI2Ole (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:41:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45024 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344516AbhI2Ola (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:41:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 18TAEKIU003459;
        Wed, 29 Sep 2021 07:39:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=pIDkCu/H5Kvj5LQN5eRf1b9GsjT9DHc+p5UqMuCSabI=;
 b=MEaJ2dVqIp/eCGU8XusdygJ8M/z3Dz4QJZIokST4ODpA5I0Az8z3F1zsYr97gWQ5kfLT
 Cy5PeKwvqS5+t7f6PLCxjODz6vjpeXfGRwdE6r2300Gcsra/9g51OI+qm2IFxbfsJIB+
 rRnHNwqdjU/jmXzJHbrIab6Q9PUbfBbLywk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3bcbfjnbrk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Sep 2021 07:39:49 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 29 Sep 2021 07:39:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fie5gDVqAk5/Q1y6JXYguWijRjyRuqdXcCJlecH8qM1jDKPn7X6i8CL0MxViIQbf0fLyr4c0Pbad0no992t1xz9TRAhpXdnHIX3+UWy40lW4sa50S6DvaCnzEpts6XFFF67nt+GgAsQwdB+whWvhvzgeT8hBhBihy0UkjUIJ3NvE3r69ZLmcarJHD4AAXq4mHL79xakS2lO0MOkiDg/+O4Xl6HiIY3LroQ5LqJsiqgESwhaTY3lM45Plnx/2T4ntgrtaF9OlToF6jAGC56uT5Tbe8RMZUvDDq7ioJ1buBpcL8GOOMeWEHj+iC2HI/uasx/Z5fLgtjk5FzQjw5AjfEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pIDkCu/H5Kvj5LQN5eRf1b9GsjT9DHc+p5UqMuCSabI=;
 b=J41XVZG5PgD9nWpMKGHGyFxc+DFlWleAS5O7bwNphCYmtDwfVEs4QMg9uHL1bBClfAec383t8fwclBiSprHp6qO4a3SnDAMVPsgpAy3imvsNlRRfIik7iCMnEZe58J/KKtsJOfSfGyaCQVMNTW6QG/fg3dDqBh90aygWTzRt5brOKoVdv8DF+a1JCyTYjyngsGD/1+9q7AO0BvSeCDxWsunhYtDNkPkClAOx7640Gx6gR1ZIkcTaKlRTmoOnIPVZg5YMnHLD2md7IQc9Zy6BeYghpaQRJyNxcFClLno511HRiX/bI0etjI7RjYmPocJnXTa4T0grHeNFMcNMYNWo5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5063.namprd15.prod.outlook.com (2603:10b6:806:1de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 29 Sep
 2021 14:39:44 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 14:39:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAACsegA==
Date:   Wed, 29 Sep 2021 14:39:44 +0000
Message-ID: <04BD2D70-62C1-4ADF-B437-E0D720E04B6B@fb.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
In-Reply-To: <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cfdc3cc-c0da-4ebc-1c09-08d98356faa4
x-ms-traffictypediagnostic: SA1PR15MB5063:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB50639EF7D31F6CB53C9293FBB3A99@SA1PR15MB5063.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eS/lJAGCyj20BvAkgOsWkHcyYkRb7e4tPc6u9EkyHGWu8Gp+wDnCWoclPevoln9QpLy+1mJplOhS5Q3dobKuhjjnsTXab2/xlGodtdGSs1LI4kTJxdad4zNfqID9pAZmE6UIV5WdV9uTIfuWea9yLBRMc2vnjh4rJSn1sUIUYErwVwzo6hbhVa3Smb/rSqv+y36f/PquZl9ZyB09lIzVCXAgLdQIgw5l40EcAgw6oj42ZSsEGQSNSB5CLNwFefu3/7dO/z8AWrAGuSZMrrVcgnC/vRqe5+FFYIZJno3OnIfJFvO/cMrYLXA68/Atm+5Ovos6gBT117p8a3bd4MgD+ArtMrRpRyDMI8LiGxlq11Ru6Ljwxr1sFFMm2r8h7CFKkNYoDYw5uFiwauBWqQZawr2Il7mWbCPCHzVMnOYNK/A3YAITmd2bj83K1eiVUd8+zfZBG38H+5R8GLa0GpCwYOE8yTzewm0Kj2aDiafD0zyh3zEQPBEO+6voSxXdar9cgRqo0OPc0z91U7aHVAy6slPLlxYv+BLePgVA9UzV7vifUWlfZayV5BHQsHKrwG7KMTxgHw6yXX2qxjgqBYaGeS/m2wAydmmqsEUEQHvGy+jILTZPoHlkh8R63FTajllIjBjmvBjIBbfD7iqy+YuF68PqDtdn4GSUZQtHDy9NekzEms1DPjZKUsggtKjkaz3t+D/I6Z64089ehtclGGaYVq8vF+9ZD71tuG4aKBGqPBDNCCrg+13l1Y1oUOlBtHxOyEk5eEVwQoqnimF2Na+090strSikvekUe5XbxRfmxzADROcN/NF7jYbh9OqQjzeSEFO/9iaamIWrJQxoYIrTcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(6916009)(66446008)(64756008)(66556008)(71200400001)(122000001)(76116006)(2906002)(91956017)(2616005)(33656002)(5660300002)(83380400001)(966005)(38070700005)(508600001)(66476007)(66946007)(38100700002)(6486002)(316002)(54906003)(8936002)(8676002)(186003)(53546011)(6512007)(6506007)(4326008)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DO66H5Xaj4mP8JWcOlxy/q8nbeVFcpMT92PPg8o1BhdxHuUAb0mJWXnwTShu?=
 =?us-ascii?Q?N1aH/LdMEWfkPXPzlaTtafeRMQpUex4cDplhWTNXvEmu6YRFTHzjp6E/mFw1?=
 =?us-ascii?Q?mJ4PD6RF5TZUsnY4XZ8kIKi317WtY3kHaBOuot+FCP1h0qcb2OqaCKLqeSne?=
 =?us-ascii?Q?eRB5N107Ei+MfuRs6mtNWbvw3Xgy3TDqG5FHlBDNDpbcLUGBEIuy+U+RC2JX?=
 =?us-ascii?Q?6sqCxv+F6AEUS86OD5Y84ZN+7DwdkQvh8Rp/C+1xMycgoDJmTRzBm0G122bw?=
 =?us-ascii?Q?5xpdj16Z9RmFx9yu4c/EIzk7/QFDm7CmQWSWyLGslKnCZ9ED8Ou3PxWi33ms?=
 =?us-ascii?Q?SAVHFSG2LzuTIuvzjq6c96JlhlVADGbBr8ZqM8L2tCtGsyagjXd4b5hDIS9m?=
 =?us-ascii?Q?A13+4/iDe9cDdMIybFEa3LMoCDK3j78Me+p2OvlGlvX9avyNjYBa1jaDV0XZ?=
 =?us-ascii?Q?byXBiAtV9cBziVLmkJaH3q7MS00TlrR97RydI7Lrt2fiAwKxyOvlsYFpU5Ef?=
 =?us-ascii?Q?f49SsFOqjUxDj091dPOSocsfLmzQML5a/DdIRZjKj00OvEhjY7ENtaxRNYce?=
 =?us-ascii?Q?+iT4XqTsVUXtJ//PJZ5AEQ0XjDLzY6Gka7e3rRnPVHlQ88dK5G7SSz+aihO+?=
 =?us-ascii?Q?q7+IY+zbrw8dmBSYBUoVuCet3wLEs4Ldas5kTYNw6BlhIx7vCxEBACIiJypP?=
 =?us-ascii?Q?Bh9I7yP24HPQ0nhZBc+0JdLYNsyvuSCc/Q/adcX808z1rFwygpTflKMlPd65?=
 =?us-ascii?Q?3LZziWW8lYijFE/lECaexTh9yN+fsX11d8Rk9T8jJcYwlE1OxRjCY7eiwaa9?=
 =?us-ascii?Q?4p+O5stNNdYLpoeim8oGdMmEE3WxbMPMmEkPWMWeFrOAyht3V7SaighiP2cI?=
 =?us-ascii?Q?VmZnT/nCycVlFM7x3buzft1qg2VqomoHtCS6FvvQfQ4PPwgV0yHwI9YlKRW/?=
 =?us-ascii?Q?A2ES+CVh27PkrhkvypEnuyySeY+Y76KvAGXXE5rLNlPzKu6xtwDVxuGLcs36?=
 =?us-ascii?Q?rnWKxax1tmUKdTU77UE+eWQQw8dLKiOZQ4NqZYoY9ANhPrDbvrBfqNqvVnXM?=
 =?us-ascii?Q?V4tnOUmLMucnvIbxjkqPniIXjhdU0joUyVK5m49ogVS3f75CE5WFtQtb0hez?=
 =?us-ascii?Q?F7stfZKp0byca0M32pT3Z2KFjhmUbo0kBRFpr4zYDlnR9uvmVEArvs6RwfuQ?=
 =?us-ascii?Q?LgS8Hnr236obecxYvv+U/w13fCNvJG5vfQuHQfR1PyrdFrNmh4eWYehE7KTm?=
 =?us-ascii?Q?xwB0gIQnbHGiBdw0auaZTpcUnD7qVLurfznb7ImcqAch+6L6OF7QDFDvjY3r?=
 =?us-ascii?Q?x4dSzeU5UVv/QT738IkjgQ8GK+C5uw7IfYFDrbqKjQg8mspXXaRy4+lyQLNx?=
 =?us-ascii?Q?20HxdA4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C971659300939047A2AF2109919FC167@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfdc3cc-c0da-4ebc-1c09-08d98356faa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 14:39:44.4603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c2MfITX/8o0dWkQ7V6BQOXhcVnqkaYad88AJr3/Gaa+ofG1hIZbsJv2ZeecgaW8nauaz3XJnRm4zw+6SG+zR9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5063
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xxz5DTtMoJaKPAMSA0OlXGIUaO2fxoSH
X-Proofpoint-GUID: xxz5DTtMoJaKPAMSA0OlXGIUaO2fxoSH
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_06,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290090
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Like,

> On Sep 29, 2021, at 5:05 AM, Like Xu <like.xu.linux@gmail.com> wrote:
> 
> On 29/9/2021 3:35 pm, Peter Zijlstra wrote:
>> On Wed, Sep 29, 2021 at 12:04:21AM +0000, Song Liu wrote:
>>> Hi Peter,
>>> 
>>> We have see the warning below while testing the new bpf_get_branch_snapshot
>>> helper, on a QEMU vm (/usr/bin/qemu-system-x86_64 -enable-kvm -cpu host ...).
>>> This issue doesn't happen on bare metal systems (no QEMU).
>>> 
>>> We didn't cover this case, as LBR didn't really work in QEMU. But it seems to
>>> work after I upgrade the host kernel to 5.12.
> 
> The guest LBR is enabled since the v5.12.
> 
>>> 
>>> At the moment, we don't have much idea on how to debug and fix the issue. Could
>>> you please share your thoughts on this?
>> Well, that's virt, afaik stuff not working is like a feature there or
>> something, who knows. I've Cc'ed Like Xu who might have clue since he
>> did the patches.
>> Virt just ain't worth the pain if you ask me.
> 
> Just cc me for any vPMU/x86 stuff.
> 
>>> 
>>> Thanks in advance!
>>> 
>>> Song
>>> 
>>> 
>>> 
>>> 
>>> ============================== 8< ============================
>>> 
>>> [  139.494159] unchecked MSR access error: WRMSR to 0x3f1 (tried to write 0x0000000000000000) at rIP: 0xffffffff81011a8b (intel_pmu_snapshot_branch_stack+0x3b/0xd0)
> 
> Uh, it uses a PEBS counter to sample or count, which is not yet upstream but should be soon.
> 
> Song, can you try to fix bpf_get_branch_snapshot on a normal PMC counter,
> or where is the src for bpf_get_branch_snapshot? I am more than happy to help.

bpf_get_branch_snapshot is available in the bpf-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/

To repro the issue:

1. build the kernel and boot qemu with it;
2. build tools/testing/selftests/bpf
     cd tools/testing/selftests/bpf ; make -j
3. copy test_progs and bpf_testmod.ko from tools/testing/selftests/bpf
   to the qemu vm;
4. run the test as 
     ./test_progs -t snapshot -v

This should trigger "unchecked MSR access error" in dmesg. Please 
let me know if this doesn't work. 

Thanks,
Song

> 
>>> [  139.495587] Call Trace:
>>> [  139.495845]  bpf_get_branch_snapshot+0x17/0x40
>>> [  139.496285]  bpf_prog_35810402cd1d294c_test1+0x33/0xe6c
>>> [  139.496791]  bpf_trampoline_10737534536_0+0x4c/0x1000
>>> [  139.497274]  bpf_testmod_loop_test+0x5/0x20 [bpf_testmod]
>>> [  139.497799]  bpf_testmod_test_read+0x71/0x1f0 [bpf_testmod]
>>> [  139.498332]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
>>> [  139.498878]  ? sysfs_kf_bin_read+0xbe/0x110
>>> [  139.499284]  ? bpf_testmod_loop_test+0x20/0x20 [bpf_testmod]
>>> [  139.499829]  kernfs_fop_read_iter+0x1ac/0x2c0
>>> [  139.500245]  ? kernfs_create_link+0x110/0x110
>>> [  139.500667]  new_sync_read+0x24b/0x360
>>> [  139.501037]  ? __x64_sys_llseek+0x1e0/0x1e0
>>> [  139.501444]  ? rcu_read_lock_held_common+0x1a/0x50
>>> [  139.501942]  ? rcu_read_lock_held_common+0x1a/0x50
>>> [  139.502404]  ? rcu_read_lock_sched_held+0x5f/0xd0
>>> [  139.502865]  ? rcu_read_lock_bh_held+0xb0/0xb0
>>> [  139.503294]  ? security_file_permission+0xe7/0x2c0
>>> [  139.503758]  vfs_read+0x1a4/0x2a0
>>> [  139.504091]  ksys_read+0xc0/0x160
>>> [  139.504413]  ? vfs_write+0x510/0x510
>>> [  139.504756]  ? ktime_get_coarse_real_ts64+0xe4/0xf0
>>> [  139.505234]  do_syscall_64+0x3a/0x80
>>> [  139.505581]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [  139.506066] RIP: 0033:0x7fb8a05728b2
>>> [  139.506413] Code: 97 20 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00 00 00 00 f3 0f 1e fa 8b 05 96 db 20 00 85 c0 75 12 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 41 54 49 89 d4 55 48 89
>>> [  139.508164] RSP: 002b:00007ffe66315a28 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>>> [  139.508870] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8a05728b2
>>> [  139.509545] RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000010
>>> [  139.510225] RBP: 00007ffe66315a60 R08: 0000000000000000 R09: 00007ffe66315907
>>> [  139.510897] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040c8b0
>>> [  139.511570] R13: 00007ffe66315cc0 R14: 0000000000000000 R15: 0000000000000000

