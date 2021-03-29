Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7604634CF4B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhC2Lr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:47:26 -0400
Received: from mail-bn8nam08on2044.outbound.protection.outlook.com ([40.107.100.44]:21361
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230454AbhC2LrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 07:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgBcDXW0rJAu9rI9tRhvBok2wWhmVjkD5UktuO0gUAS4+xanDAWTa1CXrUVXiEr3B8DqiMjaTXe6evoyLal6U8FYLFJ/K7c5zIZFX7g01m5FuKnlukvSh5XkTWz+2iaYnqgfLs/h/uQSn/3AVOYzu8GYGNfHrrmaxaT8FRhuAo2ZvMcXid472YrM+r5mdt/aRhcfsGwjHaf9ObL5yMI1J4UdgLQ9wJ7lGbdR/Sl9ON5z6NiM/kXuSySsNjtFLfkTF5Zj2LgHW89OF6UrSFK9+IdED37KsDdzKmF+GbrK7Td/rrGzK+B2pQ+77Tw2Gjf49s+VLoLvUEckRDpGTGvQ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4dZd0eSHcnMBdRfQqYM83OCM3cu+kEuptaTBARQYTc=;
 b=XHewe3Sr2HiqkWf32TtZnM1xSXuxoGefzG/AGp7PC0Mcy6jAzKJcPPueZaUSdDtuuGHrwCbZU4dCtSfRvMW6OWC1sNNPQMKT3QXwh2tdmwf6nyqZXX3Dhc0qoq3ghT35dNB1Q9ZT6yIql1XrN+13Z5YxXyyN0KkUtxAdvu74wmt1IHjExsT1J/Ugo5iZktMarnnFtLHLZgmQD1Ze02I5Uv9pv3jnRyNKykm+ZGNyUFfx1EY1ukS0pXudjHQUUVjz0fW9LQBVHIfgmmLU5L9QwQ/42oPs1/LL2dWyUXFJ530QVFPy68Q482piviDp56d+4JmzogpxcisntRrfdw7IHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4dZd0eSHcnMBdRfQqYM83OCM3cu+kEuptaTBARQYTc=;
 b=UxvGBrlj6u8mL3M+cGFtUkhHa+tsc/v0mVSOvuNuq22PDg1AXG5GKHIx4oLope3OYL/Tp9CwOLlg8BYAiAu+7Achu2VLj+vVo4E2AWSIIlmhVLefXNm8G9FaZbr85DAftBeDM0BkhE7qfG76Ts7drw7t+JGB3NzRoHijaHo5pcodaqVAqDPd6xhGM2IpJIULsIIQCCioPV72A5uDNsWYSwmGUz2OkC4bc9qjxceo0cYYUtxgsMjSWVTeL/oxOAjJ0fwsg6+ZeghOZdoTcRBAVFKnum8BRwW3PZYLoPtHUYWFfMSAtM35RaXP3d1mjrXkJfMReXWsL8/c7ZWUX/jKeQ==
Received: from BN6PR1201CA0006.namprd12.prod.outlook.com
 (2603:10b6:405:4c::16) by BN9PR12MB5113.namprd12.prod.outlook.com
 (2603:10b6:408:136::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 11:47:03 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::54) by BN6PR1201CA0006.outlook.office365.com
 (2603:10b6:405:4c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend
 Transport; Mon, 29 Mar 2021 11:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 29 Mar 2021 11:47:02 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 29 Mar 2021 11:46:57 +0000
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <bpf@vger.kernel.org>, <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J?= =?utf-8?Q?=C3=B8rgensen?= 
        <toke@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
In-Reply-To: <20210325120020.236504-4-memxor@gmail.com>
Date:   Mon, 29 Mar 2021 14:46:54 +0300
Message-ID: <ygnhh7kugp1t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44e0f7ea-d396-4790-6668-08d8f2a85ebd
X-MS-TrafficTypeDiagnostic: BN9PR12MB5113:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5113F7D4667345483AEDE40AA07E9@BN9PR12MB5113.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgQFEFQQv29J2el3UJdMJSSyGPZYjLj8obKFSGbF829SfZgBUrTOyJJ7EBK0Rl7VX5jaVi8Aam6Hj1YTdi0mS07IURG05+KoAMiqwPhHYoerR8aEchacVpSRXOuXd6q+oY5zSqfTk+yf0iIUocWpR4+Ni9coD4L8w0ihW1CiDUlx2JEDc+O9PMs5olCeBeQgfU76j88BsuQy8DCH6chzzdDhdNsIQcqbYnrxW7znmHFx0ckGyXtuIkm+pNyadP0I/cvgEs+oJKWy41XtPmYOoc/CZ/inBmrxDxO5Wa/4YMGkyELL3UZMm7EPbSxtw1P5EWA1kgOMP671ACRNVKjc6/SbNVMReU5fk1lhi2yc4M+K0ptkuD7U8rR/GfyraTC7jH39tfYd06KKyRz2TcXiAgr12dOs1iNVxaFGPKa0cgDJri5Hqjd6PN+VXVN9ulBuUQ5jtKqgy/X1mA7PYSUQYUwkQWWgGlDuB4W7MIX8whzCnCgDPSExaPLLbn6jxcR+3n8q38muoTOHGmzqB0n6OlBP7IAx+dPe6HYb9RMMZr5hYQo18gvKewY259kL3zChkjSVnRnk/ytwImkCLKoGW91Rlsoh7x3sR/6gOIR10t3K5XFDNuzo53SNIVz+RN29uXua5YgDYrZeyjGMjRn+bka3JARKqTG5mTn7yOBhLuo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(46966006)(36840700001)(7636003)(86362001)(426003)(356005)(186003)(16526019)(82740400003)(7696005)(2616005)(5660300002)(70586007)(336012)(82310400003)(70206006)(83380400001)(8676002)(36860700001)(36756003)(36906005)(47076005)(8936002)(6916009)(54906003)(2906002)(316002)(6666004)(478600001)(26005)(4326008)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 11:47:02.9134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e0f7ea-d396-4790-6668-08d8f2a85ebd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 25 Mar 2021 at 14:00, Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> This adds functions that wrap the netlink API used for adding,
> manipulating, and removing filters and actions. These functions operate
> directly on the loaded prog's fd, and return a handle to the filter and
> action using an out parameter (id for tc_cls, and index for tc_act).
>
> The basic featureset is covered to allow for attaching, manipulation of
> properties, and removal of filters and actions. Some additional features
> like TCA_BPF_POLICE and TCA_RATE for tc_cls have been omitted. These can
> added on top later by extending the bpf_tc_cls_opts struct.
>
> Support for binding actions directly to a classifier by passing them in
> during filter creation has also been omitted for now. These actions
> have an auto clean up property because their lifetime is bound to the
> filter they are attached to. This can be added later, but was omitted
> for now as direct action mode is a better alternative to it.
>
> An API summary:
>
> The BPF TC-CLS API
>
> bpf_tc_act_{attach, change, replace}_{dev, block} may be used to attach,
> change, and replace SCHED_CLS bpf classifiers. Separate set of functions
> are provided for network interfaces and shared filter blocks.
>
> bpf_tc_cls_detach_{dev, block} may be used to detach existing SCHED_CLS
> filter. The bpf_tc_cls_attach_id object filled in during attach,
> change, or replace must be passed in to the detach functions for them to
> remove the filter and its attached classififer correctly.
>
> bpf_tc_cls_get_info is a helper that can be used to obtain attributes
> for the filter and classififer. The opts structure may be used to
> choose the granularity of search, such that info for a specific filter
> corresponding to the same loaded bpf program can be obtained. By
> default, the first match is returned to the user.
>
> Examples:
>
> 	struct bpf_tc_cls_attach_id id = {};
> 	struct bpf_object *obj;
> 	struct bpf_program *p;
> 	int fd, r;
>
> 	obj = bpf_object_open("foo.o");
> 	if (IS_ERR_OR_NULL(obj))
> 		return PTR_ERR(obj);
>
> 	p = bpf_object__find_program_by_title(obj, "classifier");
> 	if (IS_ERR_OR_NULL(p))
> 		return PTR_ERR(p);
>
> 	if (bpf_object__load(obj) < 0)
> 		return -1;
>
> 	fd = bpf_program__fd(p);
>
> 	r = bpf_tc_cls_attach_dev(fd, if_nametoindex("lo"),
> 				  BPF_TC_CLSACT_INGRESS, ETH_P_IP,
> 				  NULL, &id);
> 	if (r < 0)
> 		return r;
>
> ... which is roughly equivalent to (after clsact qdisc setup):
>   # tc filter add dev lo ingress bpf obj /home/kkd/foo.o sec classifier
>
> If a user wishes to modify existing options on an attached filter, the
> bpf_tc_cls_change_{dev, block} API may be used. Parameters like
> chain_index, priority, and handle are ignored in the bpf_tc_cls_opts
> struct as they cannot be modified after attaching a filter.
>
> Example:
>
> 	/* Optional parameters necessary to select the right filter */
> 	DECLARE_LIBBPF_OPTS(bpf_tc_cls_opts, opts,
> 			    .handle = id.handle,
> 			    .priority = id.priority,
> 			    .chain_index = id.chain_index)
> 	/* Turn on direct action mode */
> 	opts.direct_action = true;
> 	r = bpf_tc_cls_change_dev(fd, id.ifindex, id.parent_id,
> 			          id.protocol, &opts, &id);
> 	if (r < 0)
> 		return r;
>
> 	/* Verify that the direct action mode has been set */
> 	struct bpf_tc_cls_info info = {};
> 	r = bpf_tc_cls_get_info_dev(fd, id.ifindex, id.parent_id,
> 			            id.protocol, &opts, &info);
> 	if (r < 0)
> 		return r;
>
> 	assert(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT);
>
> This would be roughly equivalent to doing:
>   # tc filter change dev lo egress prio <p> handle <h> bpf obj /home/kkd/foo.o section classifier da
>
> ... except a new bpf program will be loaded and replace existing one.
>
> If a user wishes to either replace an existing filter, or create a new
> one with the same properties, they can use bpf_tc_cls_replace_dev. The
> benefit of bpf_tc_cls_change is that it fails if no matching filter
> exists.
>
> The BPF TC-ACT API
>
> bpf_tc_act_{attach, replace} may be used to attach and replace already
> attached SCHED_ACT actions. Passing an index of 0 has special meaning,
> in that an index will be automatically chosen by the kernel. The index
> chosen by the kernel is the return value of these functions in case of
> success.
>
> bpf_tc_act_detach may be used to detach a SCHED_ACT action prog
> identified by the index parameter. The index 0 again has a special
> meaning, in that passing it will flush all existing SCHED_ACT actions
> loaded using the ACT API.
>
> bpf_tc_act_get_info is a helper to get the required attributes of a
> loaded program to be able to manipulate it futher, by passing them
> into the aforementioned functions.
>
> Example:
>
> 	struct bpf_object *obj;
> 	struct bpf_program *p;
> 	__u32 index;
> 	int fd, r;
>
> 	obj = bpf_object_open("foo.o");
> 	if (IS_ERR_OR_NULL(obj))
> 		return PTR_ERR(obj);
>
> 	p = bpf_object__find_program_by_title(obj, "action");
> 	if (IS_ERR_OR_NULL(p))
> 		return PTR_ERR(p);
>
> 	if (bpf_object__load(obj) < 0)
> 		return -1;
>
> 	fd = bpf_program__fd(p);
>
> 	r = bpf_tc_act_attach(fd, NULL, &index);
> 	if (r < 0)
> 		return r;
>
> 	if (bpf_tc_act_detach(index))
> 		return -1;
>
> ... which is equivalent to the following sequence:
> 	tc action add action bpf obj /home/kkd/foo.o sec action
> 	tc action del action bpf index <idx>

How do you handle the locking here? Please note that while
RTM_{NEW|GET|DEL}FILTER API has been refactored to handle its own
locking internally (and registered with RTNL_FLAG_DOIT_UNLOCKED flag),
RTM_{NEW|GET|DEL}ACTION API still expects to be called with rtnl lock
taken.

[...]

