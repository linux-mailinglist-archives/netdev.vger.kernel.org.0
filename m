Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2DE34D067
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhC2Mu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:50:28 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:36929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231438AbhC2MuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 08:50:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kgg0u0PiSnL5LDsBcxXrUkR18VqPUwXS+dC6ZKFUbu41IcGUz47ByT4LStCI3igqNa3ChlUHWxhKeSjMenOXj/B4UnGDpIkTFQAj7w4LMz8gKsblPmnQtmj8UY2R1YN3dhAGrF8PZ7joHFdI/Un7cHcUhxiJ5Cb2vcJ/8OTttaRN4jfph4ubYOycX67x5U0G+G21s2ONJWjFr2B7Uc5waxPhEaQLBSrowJH2KK46OFeF3wH6KJ93gYAEYkrCeagJlVGHiHpFXfCWa+aTXbBLWK/cuiTnSJBet1gMEXceUNxr1IjqZyCXOAaZGVQlaXjp9r8qY0UT7o/Ijzl6CTqmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gguL7jtAyMBl1bDpM+w45gO2/9qUjwNlV203I561+v0=;
 b=gXL3zsAqAX+ZwdGLYcy71rVyfvyhI9fLCpIOQGQ8AksYreIVol+P9Xq+DHAmKRO/t+QS3854v9rmeesylpNc18d1QRUIofZxPICMA9oRzYv9cYo6D7svzYfDWOwwKRTCt9DNmetgn48PlHDasosckBkOWpbffR6XZaMUXANF27mpw08aKnNKqvmsTsn7DYOAVKoOACYAuT20ON0Psa8uyKsUfRAEh8JvCN94RLAUi+Wx9YHBajdvqAF3phGsAeXKXXVe6UJ0IZRgSYNXDEW0+P1e0rGiGB7NmV/m4lSxt4yUIxeDIuFEr4hAvYP9i+JdhaaaQKUsdlfCEXny++HNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gguL7jtAyMBl1bDpM+w45gO2/9qUjwNlV203I561+v0=;
 b=da9KBP5pjt3GQvCItBf2vy7Ftcllegd9nGVuADCHUxcWSDnP8rDa3Qk3hYzX/M6xuSPnHZ51SaPMYCwUFq86F4SoYx9xrSQU+UYcmDW7pz0SqtR4JPgWmHlA9w/OLQpMxmdtJcFoX9lETlApoH64W4Pw6XWGg8q7Tg9se7gZRGuVthA6epCyRSXPloU1dibCppuoMWsqkoto92BrYIp2o8HzEuqeVXtOsYXjxq5pjpcAjvG35AptJgBwNNO1EQRLujqL11DrL9ztgk42gwUiTHi4sJKiBe1euVsmkoNuyjlW209OeisvN1M8N5VGt4XrNTHRZduI3N7NuhB+PWEv3g==
Received: from MW4PR04CA0247.namprd04.prod.outlook.com (2603:10b6:303:88::12)
 by BYAPR12MB2680.namprd12.prod.outlook.com (2603:10b6:a03:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Mon, 29 Mar
 2021 12:50:07 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::40) by MW4PR04CA0247.outlook.office365.com
 (2603:10b6:303:88::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Mon, 29 Mar 2021 12:50:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 12:50:06 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 29 Mar 2021 12:50:01 +0000
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com> <ygnhh7kugp1t.fsf@nvidia.com>
 <87ft0eta27.fsf@toke.dk>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>,
        <brouer@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
In-Reply-To: <87ft0eta27.fsf@toke.dk>
Date:   Mon, 29 Mar 2021 15:49:58 +0300
Message-ID: <ygnheefygm4p.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca5ee514-ba30-4a8e-0bc5-08d8f2b12de9
X-MS-TrafficTypeDiagnostic: BYAPR12MB2680:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2680E0BCBF184AF6A5ED70C8A07E9@BYAPR12MB2680.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6z21zZ+VQ8jPu3NkWwpIlS9QDeWTaCIdEQKyUfQ16QACF1hFixmI3Fzd2kCvDk1t3WblxNZ3ckx3BTG8QgMN1TY7OmGW+FPl6Nm/GAcD/m99UmqtpooP2c9ScAj28ueimQXBXCTIk+2h/RnTgcjlHW0E1hMeDBIBOm21xSs9f3JDdkGlhIoXaPjmkUSNCI6HG06c4ffstzBrpz6KWqDV3iLibSPUUYllq+xvGOGtJBffVOvDsUBS/HJIXApHeAnosxz6vUr4tDp/OI+mYM1Jljg1NW+YSw+WjVe0i/6/0ln2DaUWSiaGeP4b30ATzE9UtsEPiFjFSXZKRm2Qaz0jLxafEcwJ0BkAsJUeGCfu0lqOIwMfc+lNdAdrDFHCwmzy0qRWthOslwHEWPTKcvl+SrRd1UqmOLMr0QJ2MT+ftqBivnICyYLx0wuPq1qir/kOpEe6ahx6jr+uqhFxun3lxtEj3p+wOpCTxaW9w5zoLTmyxuOhRC+Wstu20staKtjzcOGXNTPs5FPr/yBnbjudiFUhOJdjEv3HLJOQUSvj5GQtf5eyUXoDz0hQw+ZYMWj9F0dRuaYxmBMhvHpUhA4FF5mOFU4lsL8fRZGDS+1tz1odeL79XG4ejO7Ps7WaMYLE1/Sj1eGcw2ss1MZDoZjWSFFg+bbT00pr60eXpnJ+BRw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(316002)(426003)(4326008)(83380400001)(36906005)(6916009)(54906003)(70586007)(336012)(7696005)(2906002)(8936002)(7416002)(8676002)(6666004)(7636003)(70206006)(16526019)(36756003)(66574015)(478600001)(82740400003)(86362001)(186003)(36860700001)(26005)(356005)(5660300002)(82310400003)(2616005)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 12:50:06.5266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5ee514-ba30-4a8e-0bc5-08d8f2b12de9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2680
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 29 Mar 2021 at 15:32, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
> Vlad Buslov <vladbu@nvidia.com> writes:
>
>> On Thu 25 Mar 2021 at 14:00, Kumar Kartikeya Dwivedi <memxor@gmail.com> =
wrote:
>>> This adds functions that wrap the netlink API used for adding,
>>> manipulating, and removing filters and actions. These functions operate
>>> directly on the loaded prog's fd, and return a handle to the filter and
>>> action using an out parameter (id for tc_cls, and index for tc_act).
>>>
>>> The basic featureset is covered to allow for attaching, manipulation of
>>> properties, and removal of filters and actions. Some additional features
>>> like TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
>>> added on top later by extending the bpf_tc_cls_opts struct.
>>>
>>> Support for binding actions directly to a classifier by passing them in
>>> during filter creation has also been omitted for now. These actions
>>> have an auto clean up property because their lifetime is bound to the
>>> filter they are attached to. This can be added later, but was omitted
>>> for now as direct action mode is a better alternative to it.
>>>
>>> An API summary:
>>>
>>> The BPF TC-CLS API
>>>
>>> bpf_tc_act_{attach, change, replace}_{dev, block} may be used to attach,
>>> change, and replace SCHED_CLS bpf classifiers. Separate set of functions
>>> are provided for network interfaces and shared filter blocks.
>>>
>>> bpf_tc_cls_detach_{dev, block} may be used to detach existing SCHED_CLS
>>> filter. The bpf_tc_cls_attach_id object filled in during attach,
>>> change, or replace must be passed in to the detach functions for them to
>>> remove the filter and its attached classififer correctly.
>>>
>>> bpf_tc_cls_get_info is a helper that can be used to obtain attributes
>>> for the filter and classififer. The opts structure may be used to
>>> choose the granularity of search, such that info for a specific filter
>>> corresponding to the same loaded bpf program can be obtained. By
>>> default, the first match is returned to the user.
>>>
>>> Examples:
>>>
>>> 	struct bpf_tc_cls_attach_id id =3D {};
>>> 	struct bpf_object *obj;
>>> 	struct bpf_program *p;
>>> 	int fd, r;
>>>
>>> 	obj =3D bpf_object_open("foo.o");
>>> 	if (IS_ERR_OR_NULL(obj))
>>> 		return PTR_ERR(obj);
>>>
>>> 	p =3D bpf_object__find_program_by_title(obj, "classifier");
>>> 	if (IS_ERR_OR_NULL(p))
>>> 		return PTR_ERR(p);
>>>
>>> 	if (bpf_object__load(obj) < 0)
>>> 		return -1;
>>>
>>> 	fd =3D bpf_program__fd(p);
>>>
>>> 	r =3D bpf_tc_cls_attach_dev(fd, if_nametoindex("lo"),
>>> 				  BPF_TC_CLSACT_INGRESS, ETH_P_IP,
>>> 				  NULL, &id);
>>> 	if (r < 0)
>>> 		return r;
>>>
>>> ... which is roughly equivalent to (after clsact qdisc setup):
>>>   # tc filter add dev lo ingress bpf obj /home/kkd/foo.o sec classifier
>>>
>>> If a user wishes to modify existing options on an attached filter, the
>>> bpf_tc_cls_change_{dev, block} API may be used. Parameters like
>>> chain_index, priority, and handle are ignored in the bpf_tc_cls_opts
>>> struct as they cannot be modified after attaching a filter.
>>>
>>> Example:
>>>
>>> 	/* Optional parameters necessary to select the right filter */
>>> 	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
>>> 			    .handle =3D id.handle,
>>> 			    .priority =3D id.priority,
>>> 			    .chain_index =3D id.chain_index)
>>> 	/* Turn on direct action mode */
>>> 	opts.direct_action =3D true;
>>> 	r =3D bpf_tc_cls_change_dev(fd, id.ifindex, id.parent_id,
>>> 			          id.protocol, &opts, &id);
>>> 	if (r < 0)
>>> 		return r;
>>>
>>> 	/* Verify that the direct action mode has been set */
>>> 	struct bpf_tc_cls_info info =3D {};
>>> 	r =3D bpf_tc_cls_get_info_dev(fd, id.ifindex, id.parent_id,
>>> 			            id.protocol, &opts, &info);
>>> 	if (r < 0)
>>> 		return r;
>>>
>>> 	assert(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT);
>>>
>>> This would be roughly equivalent to doing:
>>>   # tc filter change dev lo egress prio <p> handle <h> bpf obj /home/kk=
d/foo.o section classifier da
>>>
>>> ... except a new bpf program will be loaded and replace existing one.
>>>
>>> If a user wishes to either replace an existing filter, or create a new
>>> one with the same properties, they can use bpf_tc_cls_replace_dev. The
>>> benefit of bpf_tc_cls_change is that it fails if no matching filter
>>> exists.
>>>
>>> The BPF TC-ACT API
>>>
>>> bpf_tc_act_{attach, replace} may be used to attach and replace already
>>> attached SCHED_ACT actions. Passing an index of 0 has special meaning,
>>> in that an index will be automatically chosen by the kernel. The index
>>> chosen by the kernel is the return value of these functions in case of
>>> success.
>>>
>>> bpf_tc_act_detach may be used to detach a SCHED_ACT action prog
>>> identified by the index parameter. The index 0 again has a special
>>> meaning, in that passing it will flush all existing SCHED_ACT actions
>>> loaded using the ACT API.
>>>
>>> bpf_tc_act_get_info is a helper to get the required attributes of a
>>> loaded program to be able to manipulate it futher, by passing them
>>> into the aforementioned functions.
>>>
>>> Example:
>>>
>>> 	struct bpf_object *obj;
>>> 	struct bpf_program *p;
>>> 	__u32 index;
>>> 	int fd, r;
>>>
>>> 	obj =3D bpf_object_open("foo.o");
>>> 	if (IS_ERR_OR_NULL(obj))
>>> 		return PTR_ERR(obj);
>>>
>>> 	p =3D bpf_object__find_program_by_title(obj, "action");
>>> 	if (IS_ERR_OR_NULL(p))
>>> 		return PTR_ERR(p);
>>>
>>> 	if (bpf_object__load(obj) < 0)
>>> 		return -1;
>>>
>>> 	fd =3D bpf_program__fd(p);
>>>
>>> 	r =3D bpf_tc_act_attach(fd, NULL, &index);
>>> 	if (r < 0)
>>> 		return r;
>>>
>>> 	if (bpf_tc_act_detach(index))
>>> 		return -1;
>>>
>>> ... which is equivalent to the following sequence:
>>> 	tc action add action bpf obj /home/kkd/foo.o sec action
>>> 	tc action del action bpf index <idx>
>>
>> How do you handle the locking here? Please note that while
>> RTM_{NEW|GET|DEL}FILTER API has been refactored to handle its own
>> locking internally (and registered with RTNL_FLAG_DOIT_UNLOCKED flag),
>> RTM_{NEW|GET|DEL}ACTION API still expects to be called with rtnl lock
>> taken.
>
> Huh, locking? This is all userspace code that uses the netlink API...
>
> -Toke

Thanks for the clarification. I'm not familiar with libbpf internals and
it wasn't obvious to me that this functionality is not for creating
classifiers/actions from BPF program executing in kernel-space.

