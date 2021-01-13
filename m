Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF822F54B0
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 22:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbhAMVyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 16:54:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729217AbhAMVu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:50:56 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DLnb0K002870;
        Wed, 13 Jan 2021 13:49:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DEJOzCqIeepJk5FGhQuvBfNrWYlPBu8pz/PQq0XZVWg=;
 b=N7zZQSSJesofwTWBj+VDm6i+ynE0UMxVmbtS5Dt+wf4qxv9pvdeknqDsShPyLv89yE5V
 wVCFeLHIBXNDg0cW/31NOV4uoXOHT1x6wlMLJbf8txJugsf5qq+4uS5Z6luRjOjYcCKk
 v8c4fAIleg8heEXa+EjqqBJAHPH8Bi6LQSM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpufkvm-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 13:49:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 13:49:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRqZ1qzatircKszfy1X+zW/hQvhCgEufFoTl/5KmWShNYrhr4Li6M/h1F+qYfTR2qDzKx0NCt/5qhbYqoP5O1pUUbxQLAXLXMn7TucNbIMbYElq44eF+ysReCmte3kilOXWikPN1Wso1yUe5hYPlK+1C2QYVMHZOjGdn4sGPy+JKWNN6HD67s+d61x+lm53e0cyqIFpvAYtu26CeQrGcS6D1c49JTin147pPxhC2xn7AeE4JztnnbWep4kpdiVAtjsfK1oCkL2il3ZFBviUvAL5vSllBoMIOpFVNvBsHKuiA12VziPNV4kmswiat+djfDQ4UQk0ODiGBYjtmfIDHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEJOzCqIeepJk5FGhQuvBfNrWYlPBu8pz/PQq0XZVWg=;
 b=YEAC3XLQ167Brws/l0eWeiocsXfV+Y4HpkAH4sI4qYfeWS42cf7+ewnWbAsHfpcFxnO+Tb1qCdFhWl82PV2AvRTGHlNuouZzhUaHdeMlQbvbwiI649UHUrIZyDh6X7tRXRN6mcExzBGhP3hmgElIWCURD44quUWqoEhl9TUMKZLpm876XMV9EjyW3NJGc9MJ2iExpWM1wnGg6OtyF2kSG5yhh8BEF6oJHt6U50vjK2Sr5zAgITUszvONgVc1rTjctG0G51zvaQwLGKMh5qr9Dfzn8Kqwc4mGNibAjh1ovGflwGFRoEqVBqDyNfRFVbGFkmT6yaosBKS3oe59oTjWmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEJOzCqIeepJk5FGhQuvBfNrWYlPBu8pz/PQq0XZVWg=;
 b=QZNzJXjoSHuF164kvWSUPuAIPVun85TrtPaTHVvpjfKqWrWwg9UUxwKcIZ/lP/U9oaLG+Umgl64sNpFu6ZoCJJiMbAG5utt5JZcT9+7gk8g1YKCJT01CdXzOEbfxbL9+VJtaqPvZMzT1UbMKMO+WcKn+cZHe22cBSLZIlVX3bho=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BY5PR15MB3572.namprd15.prod.outlook.com (2603:10b6:a03:1b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 13 Jan
 2021 21:48:58 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 21:48:58 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>,
        "syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com" 
        <syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test
 run
Thread-Topic: [PATCH bpf-next] bpf: reject too big ctx_size_in for raw_tp test
 run
Thread-Index: AQHW6T0UQ8EFV61Bn0G7hjqBWgnEBKolBFqAgAEU9AA=
Date:   Wed, 13 Jan 2021 21:48:57 +0000
Message-ID: <2DAED411-C65F-4BFD-A627-1EED4823168B@fb.com>
References: <20210112234254.1906829-1-songliubraving@fb.com>
 <b8b16115-4fba-265f-b0a5-33af02a75bbb@fb.com>
In-Reply-To: <b8b16115-4fba-265f-b0a5-33af02a75bbb@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
x-originating-ip: [2620:10d:c090:400::5:f14a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a87022a7-ff67-4d82-74a4-08d8b80d07fb
x-ms-traffictypediagnostic: BY5PR15MB3572:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB35726ACE52A9F09A11ADBF9CB3A90@BY5PR15MB3572.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zTdlagpGfVWXtHQNm1gC6ZxbvcQBXBMypa5INaATYX0Ojr+wHCfirTvXWE/QuBLrFaypW45ZVU82sZiSmMtFdEikwUd/EQ6yFFIkS5+EiUw5AkZoiokuHw5F5R6yYhBnuy6hCOYQwi7l+p2HjUzwOPsGO8FJcP3Cr+VE05VafUABjfpQ7pls6CfjNbg5TZVKMQEZzN2jZRGHAtEDa8A1ZizTeztx87zmpa/vG4Pff/tSAV/5BQR2ccoZj+f5DpDIUVpsIkwzS4cZihZkOp9pwjVqvINmjTAt7eIbaHzTQO0Vvb/c5EB7LtXO3VzudGHtil6NwGAqZsfAZ3zL7Z8gz6OG4yZThJO79IBVMEEf5nK1oR7sbR3usp3FL+E3adAvqLFhFjmigAXKNdGjevcKjvR4t/4WRHiVfwkU3pJ1G4x8c2OZksg3crJe8ELaqSDr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(396003)(39860400002)(6506007)(37006003)(316002)(36756003)(54906003)(6862004)(33656002)(4326008)(53546011)(8676002)(8936002)(86362001)(478600001)(45080400002)(6636002)(6512007)(76116006)(66946007)(66446008)(2906002)(66476007)(66556008)(64756008)(71200400001)(91956017)(5660300002)(6486002)(186003)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?b8LdCFRJCdgjvNaxAgtPF+03D6aIZSjRYnszCdx99Hkxmz+0678oUb9PAYkd?=
 =?us-ascii?Q?uaSXUuRSFUlWmFSJbTbUOsXB5b+xe79Y0tU/E/noEG3NnNfC49xoyleD/96X?=
 =?us-ascii?Q?Xqy89DKSk5ZtJ2Sg0QzXMaGpdZlEnPJal0sH1Lj/jRaNVCaKzEIfTtlESZMl?=
 =?us-ascii?Q?7jHDCnsgUMAZJNNW+cN2GCoGBogTj51jyApy8WTETUeRp6W6Y2oSMh+aVhn2?=
 =?us-ascii?Q?qdaI9PHtGKBh8MRcECmd+E3ey5963hLXO0Aqo8xj8VKt7798AYodOlf7YcYh?=
 =?us-ascii?Q?HgTAac+/me5rCHJ9SOh39RN37tCatHWgEw69ZLeI3HGDIOgUM/B97RJiVcOY?=
 =?us-ascii?Q?qJ92GKMyPjvtisQG5Sp4ZyQ7nteu2TvP0yFw0pvxf9jg3erLWZ/7DKwV/Tog?=
 =?us-ascii?Q?AIzPQ+xXNP2oWQqYBTXvV2Z+llo7Kt5We/pHqdukAfy5BDwTTI6wGAnxYRl3?=
 =?us-ascii?Q?p8sjGesS9el0nPhWXq09U+JSSWYEAq4CKhWA2ojIB9qo0Zqd+6U8JElH5Zzu?=
 =?us-ascii?Q?rjpQrTGTFFuF3JPYzkiv6AAqqXvlI6PDXLHMMEu2w9OMvvvGUl1Ql4tAAvVl?=
 =?us-ascii?Q?bpqvqTbLglnB2UZFZ4075dbiYGt1Ah6lIKucPbAmQBj3MLf1Nr1dcTiHeUUa?=
 =?us-ascii?Q?G8KdCXlMgYMMHn3vlR6O5oAj7dYl/y5sfMqss6rpfbL9xzABXRJO7CzpudD5?=
 =?us-ascii?Q?axk4Sl59JpqkvurR2K79COjrR+K8yxyb3HFJoX51svn1jytWedPLZ+YAYFas?=
 =?us-ascii?Q?1MSYXER9Cq4eaxcItxas+A2BEeOS4bup/Y8/NaccKavMxMFnq1nK1CyMFEEO?=
 =?us-ascii?Q?5Ho2URg4kGAUmj5rz09oq5+3FZdOzT1CKOB8zZKv5xT6njZue5iSiIs/hMtG?=
 =?us-ascii?Q?jds1X0pEp/xxIQPGzM6DuKcXfbjexIWjAwtMSqYc5YjHY1nsbzxX84CGKWfI?=
 =?us-ascii?Q?eM6aeCn4xC/U+9CLP6BAuk+B9QtvciTe3ku9/uZ6Mog7tPwhxmDyi9NoUcbS?=
 =?us-ascii?Q?iZsFaZAassBpu1FKhzIBBZd7XSydzAU+eDNGEQ/V7h8FuJo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94B9DE00A05C814D8AC339D97A304574@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87022a7-ff67-4d82-74a4-08d8b80d07fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 21:48:57.9611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u3mkFteInd3cARgccnid7yWMBmiUi81ktO7SeKObllCyoxhlUa3YTzGF3NF0x85Cgs7JwokKC9oo4B1V3IUC+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_12:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 12, 2021, at 9:17 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 1/12/21 3:42 PM, Song Liu wrote:
>> syzbot reported a WARNING for allocating too big memory:
>> WARNING: CPU: 1 PID: 8484 at mm/page_alloc.c:4976 __alloc_pages_nodemask=
+0x5f8/0x730 mm/page_alloc.c:5011
>> Modules linked in:
>> CPU: 1 PID: 8484 Comm: syz-executor862 Not tainted 5.11.0-rc2-syzkaller =
#0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
>> RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
>> Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 =
70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 f=
d ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
>> RSP: 0018:ffffc900012efb10 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 1ffff9200025df66 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000140dc0
>> RBP: 0000000000140dc0 R08: 0000000000000000 R09: 0000000000000000
>> R10: ffffffff81b1f7e1 R11: 0000000000000000 R12: 0000000000000014
>> R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
>> FS:  000000000190c880(0000) GS:ffff8880b9e00000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f08b7f316c0 CR3: 0000000012073000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>> alloc_pages include/linux/gfp.h:547 [inline]
>> kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
>> kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
>> kmalloc include/linux/slab.h:557 [inline]
>> kzalloc include/linux/slab.h:682 [inline]
>> bpf_prog_test_run_raw_tp+0x4b5/0x670 net/bpf/test_run.c:282
>> bpf_prog_test_run kernel/bpf/syscall.c:3120 [inline]
>> __do_sys_bpf+0x1ea9/0x4f10 kernel/bpf/syscall.c:4398
>> do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>> entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x440499
>> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007ffe1f3bfb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440499
>> RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ca0
>> R13: 0000000000401d30 R14: 0000000000000000 R15: 0000000000000000
>> This is because we didn't filter out too big ctx_size_in. Fix it by
>> rejecting ctx_size_in that are bigger than MAX_BPF_FUNC_ARGS (12) u64
>> numbers.
>> Reported-by: syzbot+4f98876664c7337a4ae6@syzkaller.appspotmail.com
>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
>> Cc: stable@vger.kernel.org # v5.10+
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> Maybe this should target to bpf tree?

IIRC, we direct fixes to current release under rc (5.11) to bpf tree. This
one is for 5.10 and 5.11, so should go bpf-next, no?

>=20
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks!

