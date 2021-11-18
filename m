Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70252456418
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhKRUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:31:55 -0500
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:2785
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231377AbhKRUby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:31:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDPr/t08HLkE2+OZS7T4GI90llVYSftOdqUlL3i+NXMGyXvlfaiWjWyMAKqG7pSkk7TAZPDQXzx6UGnZjsQTiuPq5ghJsUFDsn3bgS7eLSKSwr33zKPMoHimnI2y323t7npZVkyemvYkgzUyl7zSse79JzVqHcC3g8JgarVKtIkHHOnliNszMZCGuIDmWLVrTgu4VOXZLrjZXoP3qOcRwUNzDDTRhPcY2iSZ/ZDZj26QO8XykEGzD+Zy6X/wnYQL2gwgAQNRxpLU5M7xx3PjtIrgmrgHP6sbi+75ZS1rxAz66Se5M5dnjiZ5x13EJFqzh0v+77atHaCNYAhY6abu4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T73Z7+mHYZvKeeLZYHXHafx8/Qc7zeDlNYSdd4qtgbo=;
 b=Yl2q7gAq3wbUdSIUdZZBhLOq478GvdEZyJfp0zx1eFlnq1koS+Txvlg4fyKnRb06mbSBAyhsTTzyHBXjocyCxU/1jGF4wGAzrRK6FfJa7LqO08xQKRTD2idTUPZtiexfoGIyD4mCIX4HPDMiWXts9yrhvze1m1qwWaWkGQYz340ODl+cnJCCDocpsRfCxHyHkEErLd4mhu9Xvc9HiB9auFTRKeRneeNNDJX9va10YRp504j8myjSVI2cdyDi6ggw8SSDJ9RJm8pdeKGLfTf/RilqzcGRMHikY+oZTfgQiC5mgFj8V8fHvJyKw5PPG3rpC+/bBnRSSLP66+nGpAvBZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T73Z7+mHYZvKeeLZYHXHafx8/Qc7zeDlNYSdd4qtgbo=;
 b=wxcAhmkVD9KITXfdrfqNJoaxKdmvkDxIo3OS3l8HuvtFtZAjzGw/9TSEqfMARb6VnPlttvf6EWlkaXu4UHwHgKvnKfewCsdoy65QdKce6TZUCdFLB8g9favxHatOhIdawqe+agtj/JlXRyjfrDIi6aX6ipVSYaLdksWBKbgERd0=
Received: from MW4PR03CA0232.namprd03.prod.outlook.com (2603:10b6:303:b9::27)
 by MWHPR12MB1838.namprd12.prod.outlook.com (2603:10b6:300:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 18 Nov
 2021 20:28:51 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::8d) by MW4PR03CA0232.outlook.office365.com
 (2603:10b6:303:b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Thu, 18 Nov 2021 20:28:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:28:51 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:50 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:50 -0600
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 18 Nov 2021 14:28:47 -0600
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
Subject: [PATCH RFC 1/4] cgroup, perf: Add ability to connect to perf cgroup from other cgroup controller
Date:   Thu, 18 Nov 2021 15:28:37 -0500
Message-ID: <20211118202840.1001787-2-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb775d17-7613-4d35-a35a-08d9aad208b6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1838:
X-Microsoft-Antispam-PRVS: <MWHPR12MB18385944D1553925C8EC169A839B9@MWHPR12MB1838.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JK+oj26aoQC1ub443bHMQHXqzxAoSF2xwS4bFsJwuMTS7mnVFAaxEfGKX6UEyLnaSow3sK8/9cF25HEoQ8GgD1oxo5gBRcRXRABIGSJ8Yp2w5xqwMie4VNAq+/6OyDalEIlNvAO3AG60fknLGy7PFdHJnhSUZL1dZ4IwXDxiXI6T3XrYYkNWq+d55jDBDMyuGiBStfR2iKr4WiYnn8m9YLc9S/0FGebW016lgh45+QagXQz0x25wJU1b3x9spqJY9XtsmdbcT5iEbLzgeGD6MXE3MoH9+JJ2/9cXeqQh3+0tHEsdCY0z9kTEJ6i0KL4jZYWbHRZoSXses3yezEibROzZT8qj4ebO2/QZFkWLA5PFmZe27l4sJWT7z6bRKz23bHpV/YowdI4Q6PQQ5wEwqqdKHlMP+sSma86JuOe6dd6/INKYTWZRbwCBpYF9w/CLIyLV0tMVsZ5X7XIJwfJ0iLTe+YG89/rw6p+yCxnaB+TV0rVbwhExL3SsSuXxhP82Gk/Hb/iTaWMndKohuSyidbytYW+8JGHh0A7xUvjVZ9/FAungfvLH8iLvcKSUZWDUZ2cEiFEh86xyPrTt/Ssfld7QnI11of6TTIVxuI9JSdBoJilkaRc9FNZjUsKYWKwbTKaPrZe8ucyZHPEliLSUtjhRnhbgoWu023mkuTQMeG65HBh936jMYYPEDkKuCYQD54RpzrebBBVOgGe/xdK+XdkWwUvz49DvbgrNyDyuRBGbVSQRGIeBsebtjiENDsMO
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(82310400003)(336012)(186003)(47076005)(426003)(5660300002)(508600001)(70586007)(2616005)(70206006)(83380400001)(36756003)(8936002)(8676002)(7416002)(356005)(316002)(36860700001)(110136005)(81166007)(921005)(7696005)(1076003)(86362001)(26005)(2906002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:28:51.4117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb775d17-7613-4d35-a35a-08d9aad208b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides the ability to allocate cgroup specific perf_event by
bpf-cgroup in later patch

Change-Id: I13aa7f3dfc2883ba3663c0b94744a6169504bbd8
Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 include/linux/cgroup.h     |  2 ++
 include/linux/perf_event.h |  2 ++
 kernel/cgroup/cgroup.c     |  4 ++--
 kernel/events/core.c       | 17 +++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c151413fda..1754e33cfe5e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -97,6 +97,8 @@ extern struct css_set init_css_set;
 
 bool css_has_online_children(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgroup,
+					      struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgroup,
 					 struct cgroup_subsys *ss);
 struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0cbc5dfe1110..9c440db65c18 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -926,6 +926,8 @@ struct perf_cgroup {
 	struct perf_cgroup_info	__percpu *info;
 };
 
+extern struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp);
+
 /*
  * Must ensure cgroup is pinned (css_get) before calling
  * this function. In other words, we cannot call this function
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..a645b212b69b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -495,8 +495,8 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
  * Find and get @cgrp's css associated with @ss.  If the css doesn't exist
  * or is offline, %NULL is returned.
  */
-static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
-						     struct cgroup_subsys *ss)
+struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
+					      struct cgroup_subsys *ss)
 {
 	struct cgroup_subsys_state *css;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 20367196fa9a..d34e00749c9b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -941,6 +941,18 @@ static int perf_cgroup_ensure_storage(struct perf_event *event,
 	return ret;
 }
 
+struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *css;
+
+	css = cgroup_tryget_css(cgrp, &perf_event_cgrp_subsys);
+
+	if (!css)
+		return NULL;
+
+	return container_of(css, struct perf_cgroup, css);
+}
+
 static inline int perf_cgroup_connect(int fd, struct perf_event *event,
 				      struct perf_event_attr *attr,
 				      struct perf_event *group_leader)
@@ -1080,6 +1092,11 @@ static inline void perf_cgroup_sched_in(struct task_struct *prev,
 {
 }
 
+struct perf_cgroup *cgroup_tryget_perf_cgroup(struct cgroup *cgrp)
+{
+	return NULL;
+}
+
 static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
 				      struct perf_event_attr *attr,
 				      struct perf_event *group_leader)
-- 
2.25.1

