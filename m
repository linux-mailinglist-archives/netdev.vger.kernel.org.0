Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C645640F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhKRUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:31:56 -0500
Received: from mail-bn8nam11hn2202.outbound.protection.outlook.com ([52.100.171.202]:19007
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230013AbhKRUbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:31:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhtKXf055qMpGDQIxQk+zH6jxcFhW2bnMpJYdXuHBKA0WrvUuvFbVwM8TvtYZYhmwX1Xpk35dZkS1mCqExtQ5mb01WZ2E8J8dK/M8sC6q3irF5tbITZT98JzoKo+akpI2b9Vl7EkTtDlKMazhojh+Lfz/eqlU9ecu7VtVaV1kVma7/3z/1M7+TpRLgK00SgvdB0q/XgyaJOhh2Y17t+ch+JR9XxX4CDJ2zFdWKKMtKSuw4Vmva1vwW8vpfYF3Gq4YaDWv/mbDDpgcOw8Tr5u9RphC5ZvZ7lxq4HdaDNVdtNuR2rvXA/uV5Y893X5RKzaHx1Sq2m0g/wyDKELQuOq+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Bemx6QLhgKhSDBo3I2D4fFXgf9muLskl2EoJJes6X4=;
 b=cKmgxG0z1ksUai2WjsYNgXgTzqKjsqUjqwPV7jOn6q9mIwiXQsVU8Qq4yjUV7PF1f5QfVvxK9agsMPo93jT54vOHlN0+QViGoQTROFv/0luIfsJ2EmoirP6pTe9O80D+bQsWGFuZJFsN15ezMffPQ7Rpulx5ByEOo2mSVydNaxFbc2JF3JkyzDTEHC957RIGwE++kCBBvPkfwpqBDNk2V0EbNHQkt9xkBF7v1B4kGrVE6sezSBwGH2HhqnG7jG4Ifjq6U7/8k7m0wZw0DOiC8eOg/HzLNK3JuVreQx6Mu7ntWS2iWm/hcvI0EP++NuvypWYeZ2usZOLSfoJisS+qhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Bemx6QLhgKhSDBo3I2D4fFXgf9muLskl2EoJJes6X4=;
 b=tEjp0YOqIHIPK+3S5MXJrEePEHMNu5BECso0gwG4zAmNMt4tW8hg52G7uGfX/SLWDNQkokz6f7eFOpnrgB8Oq4URzLVT99mJIYDLtFNi/fJvmVfCXmXwmCMnQ8HVtrc46zKZjfeb5LFHD5/cdYE6YHJFa23NBBuWc39YUvn7w/E=
Received: from BN8PR16CA0003.namprd16.prod.outlook.com (2603:10b6:408:4c::16)
 by MWHPR1201MB0029.namprd12.prod.outlook.com (2603:10b6:301:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 20:28:51 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::47) by BN8PR16CA0003.outlook.office365.com
 (2603:10b6:408:4c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend
 Transport; Thu, 18 Nov 2021 20:28:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:28:51 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:47 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:47 -0600
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 18 Nov 2021 14:28:44 -0600
From:   Kenny Ho <Kenny.Ho@amd.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <y2kenny@gmail.com>, <Kenny.Ho@amd.com>,
        <amd-gfx@lists.freedesktop.org>
Subject: [PATCH RFC 0/4] Add ability to attach bpf programs to a tracepoint inside a cgroup
Date:   Thu, 18 Nov 2021 15:28:36 -0500
Message-ID: <20211118202840.1001787-1-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 892a928d-b93e-4c9b-d3b1-08d9aad20881
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0029:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0029BF8CE418CD17445DD605839B9@MWHPR1201MB0029.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1wf/H3SYvm7UbzmigTCwR+DzZB6nw87vx94yyhSXnyEG6WQE5zooa7WpTCsv?=
 =?us-ascii?Q?yi57gTeuaZnAxA8VYMgL7pkC2MAZf6upyoGbzcj4fBN0wYiPf7qAftSWpyhb?=
 =?us-ascii?Q?1MJsTlydYSXHSdqkmwMumds1arB4FVbL7NoB6/kvpk8eQSN9fL/xH6+ew4PU?=
 =?us-ascii?Q?Q9jsgdWG28ZJmRf6/NH0UOjzdvPm8f110aRdKMywDLANg39sJshw8nDmY9g4?=
 =?us-ascii?Q?3u73QtgeTjs6Oh1Pud7+bexr9QQnYR7mdRPVbEk1UA44Smg8WXv0VvMs3zAn?=
 =?us-ascii?Q?VRYYRmWuo7fQ5lf37q55OPveLvXS9RV+rN2CQZim/Pd4PjdoLTQAL13ZdbaA?=
 =?us-ascii?Q?oib1yCg8klZIS/QeB43xtPHbH8P/uRJkqjvrs0EXlR9F7fNco8I2xBHpjlQq?=
 =?us-ascii?Q?FSnlgexQ0fydpH+aPjZE9lC9D2ZLQEwRzoxCcv+wWlB2qMNfSVLEI05FR5eF?=
 =?us-ascii?Q?vFPCKkASLGEH4AThYhScSXNNRHBN+HMQ10n0F4O7M1NfphquXr/WceDGOFWl?=
 =?us-ascii?Q?qTqLoxzowCY4p30O1oPw7hVujMqG9BiTVglhbpptS8m5r3JyBtHm/oMvD0fa?=
 =?us-ascii?Q?IdJckRJOlb/bEBkZHVoaDiGe3wysw4CBAUtoVdIW/cxCBP5rJ6novmdPudVu?=
 =?us-ascii?Q?Bb1aRDwL5N11fcfaQWhkNyf5Z9ImDcOg/nd0uG+ESFYlK7TeuKC99KAmqsR9?=
 =?us-ascii?Q?bdS7uXQC+nGSuUEmZJDwXymJ4KAK7peu/th49h9VkuaQ9cHEd1mKhwg+8Kfa?=
 =?us-ascii?Q?Ipm9Dm/mTYNz9fkqjH67ahS9sut2uhNVrJzJC8SIz/0js1iMv3A7M2b2Gjtt?=
 =?us-ascii?Q?7PxuD+E26okP2UdCTsw02wxSxNnSyjXwOqJMgZiCCaprMRDacwwRgYNkDg1V?=
 =?us-ascii?Q?dJJ6Lz76rdl83xOknfrv2wqVbhwn61McecswkZqJ3DuvebqlctXNU7HTtuTc?=
 =?us-ascii?Q?Z/cnt2Dn3xtXggZqECE6W4OBGTWTptDa9GUiuYX/arHZPce4T5OImE6ZMyB/?=
 =?us-ascii?Q?7frwqE3N/Mry+ftqa7uGAN59E+jVA3BlRNezCbKhb2owo3dMj2Z7CzxDmd26?=
 =?us-ascii?Q?MWYxQSx1yTHL4emu1fY69ZVlrT4zuUniKmkGPtJGodiQx5ViYKodIhpUoaXU?=
 =?us-ascii?Q?uywO5Tmq7UBBtOJFQOYnreeiIh1L9KQy9NO5OF9VaDSYGB+OnuWlkgQQhD9c?=
 =?us-ascii?Q?mcwE6j0toRJqoWszRaN38YX0YbuydqMbCAPMezJJTltpbDD0Jz1VcZY06Lc?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:5;SRV:;IPV:CAL;SFV:SPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:OSPM;SFS:(4636009)(36840700001)(46966006)(2906002)(336012)(6666004)(508600001)(316002)(81166007)(7416002)(2616005)(921005)(426003)(1076003)(86362001)(36756003)(5660300002)(8936002)(110136005)(70206006)(36860700001)(8676002)(70586007)(186003)(966005)(26005)(356005)(83380400001)(7696005)(82310400003)(47076005)(87590200002)(36900700001)(266184004);DIR:OUT;SFP:1501;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:28:51.1636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 892a928d-b93e-4c9b-d3b1-08d9aad20881
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0029
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per an earlier discussion last year[1], I have been looking for a mechanism to a) collect resource usages for devices (GPU for now but there could be other device type in the future) and b) possibly enforce some of the resource usages.  An obvious mechanism was to use cgroup but there are too much diversity in GPU hardware architecture to have a common cgroup interface at this point.  An alternative is to leverage tracepoint with a bpf program inside a cgroup hierarchy for usage collection and enforcement (via writable tracepoint.)

This is a prototype for such idea.  It is incomplete but I would like to solicit some feedback before continuing to make sure I am going down the right path.  This prototype is built based on my understanding of the followings:

- tracepoint (and kprobe, uprobe) is associated with perf event
- perf events/tracepoint can be a hook for bpf progs but those bpf progs are not part of the cgroup hierarchy
- bpf progs can be attached to the cgroup hierarchy with cgroup local storage and other benefits
- separately, perf subsystem has a cgroup controller (perf cgroup) that allow perf event to be triggered with a cgroup filter

So the key idea of this RFC is to leverage hierarchical organization of bpf-cgroup for the purpose of perf event/tracepoints.

==Known unresolved topics (feedback very much welcome)==
Storage:
I came across the idea of "preallocated" memory for bpf hash map/storage to avoid deadlock[2] but I don't have a good understanding about it currently.  If existing bpf_cgroup_storage_type are not considered pre-allocated then I am thinking we can introduce a new type but I am not sure if this is needed yet.

Scalability:
Scalability concern has been raised about perf cgroup [3] and there seems to be a solution to it recently with bperf [4].  This RFC does not change the status quo on the scalability question but if I understand the bperf idea correctly, this RFC may have some similarity.

[1] https://lore.kernel.org/netdev/YJXRHXIykyEBdnTF@slm.duckdns.org/T/#m52bc26bbbf16131c48e6b34d875c87660943c452
[2] https://lwn.net/Articles/679074/
[3] https://www.linuxplumbersconf.org/event/4/contributions/291/attachments/313/528/Linux_Plumbers_Conference_2019.pdf
[4] https://linuxplumbersconf.org/event/11/contributions/899/

Kenny Ho (4):
  cgroup, perf: Add ability to connect to perf cgroup from other cgroup
    controller
  bpf, perf: add ability to attach complete array of bpf prog to perf
    event
  bpf,cgroup,tracing: add new BPF_PROG_TYPE_CGROUP_TRACEPOINT
  bpf,cgroup,perf: extend bpf-cgroup to support tracepoint attachment

 include/linux/bpf-cgroup.h   | 17 +++++--
 include/linux/bpf_types.h    |  4 ++
 include/linux/cgroup.h       |  2 +
 include/linux/perf_event.h   |  6 +++
 include/linux/trace_events.h |  9 ++++
 include/uapi/linux/bpf.h     |  2 +
 kernel/bpf/cgroup.c          | 96 +++++++++++++++++++++++++++++-------
 kernel/bpf/syscall.c         |  4 ++
 kernel/cgroup/cgroup.c       | 13 ++---
 kernel/events/core.c         | 62 +++++++++++++++++++++++
 kernel/trace/bpf_trace.c     | 36 ++++++++++++++
 11 files changed, 222 insertions(+), 29 deletions(-)

-- 
2.25.1

