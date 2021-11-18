Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840C5456424
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhKRUcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:32:07 -0500
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:8577
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233954AbhKRUcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:32:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKw7arrQDSXkNb9FrD0yev+FIbggyh+5MXM3ke/FlnbhfVk/CO5kVCXVVe/gU9MNJ6msmH6RgLOOpC39je7kIUkFQLw9ARt0+MriigJUt0GORh6Vqz5gdmj81n4OfLUaHndIDsHCtjZ+F//jqwlvgpbilCjen+kcMFTQs5ga0vpwZjxmzFUp5bx+A6Lo+bN3QNHL2t7I0W1INpHg8QwOgbYqfIR15N6qjgsQlTv1N31Ug40VjlqcR1Mv4vWmruDcuY/fso4cs6Rw5qFuD/+FWbHUwXErt7kvTldUKJI+k/Ok2lCwZwHE2+tsG3APPgkd4IL80DOsxSlvT72M+LCQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHKhQbOAr7Mm7h+PoDJFTwWLZ8WOF7rmrZsjJYFpFsc=;
 b=YY+PRWsWCgU2XmCbwkAXclxnp/srqGkoO62V6tAOvvw2SOn6CAa5IWnhwcvd0fGf84fyfEgIrOAlhQniPO4hNnZdJWOSa1QqPWQlroYeyFCSYOkRbRx1dr4GncxvjMZFqC2XVnAwu3Lmw1e1hRhVOJuD/7h4d0GhAMQORGJTWtUhoIcjXrd2I4IE1AQcZGCY71H4jJlhtbZQrgCY5gA9ebnV9pVgLutqo5qGytHypyFCfEsX+oNvn1878lfc4wlml8KgvNDSIQ1AnzFfFNvOY+KzfzuNSBSG6YyJqsFVIxypeRCrx/Y1XMz3sp+LmKtjB23x4Pg6SMMnHgewslxheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHKhQbOAr7Mm7h+PoDJFTwWLZ8WOF7rmrZsjJYFpFsc=;
 b=rPxETzrKb9U4nxyEatf1AHRYpnXTHjHKNcBdovdowIUL96wxaNdUcVPvVBxqtYyfIMFGFt/Y5Qrdw4gAnBatwntYFsU+0r1MIHZTbjbx/T8TSQ+VjM+MMQP752e8h9igtt4pILIy1+hBrAGnWzYvF/O32jV5UOrTxyXckpXd1Ws=
Received: from BN9PR03CA0446.namprd03.prod.outlook.com (2603:10b6:408:113::31)
 by MN2PR12MB4125.namprd12.prod.outlook.com (2603:10b6:208:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 20:28:57 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::65) by BN9PR03CA0446.outlook.office365.com
 (2603:10b6:408:113::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend
 Transport; Thu, 18 Nov 2021 20:28:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:28:56 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:56 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:55 -0600
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 18 Nov 2021 14:28:54 -0600
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
Subject: [PATCH RFC 4/4] bpf,cgroup,perf: extend bpf-cgroup to support tracepoint attachment
Date:   Thu, 18 Nov 2021 15:28:40 -0500
Message-ID: <20211118202840.1001787-5-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6322ec77-87ca-4ded-f98a-08d9aad20be5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4125:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4125F4173A1F7DB4511294AA839B9@MN2PR12MB4125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ckTjSvKwirqerWSm1wep54SJO7m5glFpWd/uMxNQjGRbZ6nlquZ/frxFP49UpGfRIAv7rDkoxmmKPqnxqJmE4nfu8IPh3q62/G3Er9N+gyNV8cnPfJxkwkMucMK4a5KbY544gEaLxQzLXUPatcaQfG8g9D/r6S/MYGPKSXFdI1M9Ub0TeoLmKj2nlNjLzvEO7EEVyTvHrP7rpo1NMHsQYWlI+GZ78p129KDhK18B791fWMbF1Ce7uLeOKsJIwFTEsNuCGVzXFpe3+Eq5iQoUU08k7YfWp48vlW9voDNGdEOOJneAGbBoqqiS6mjJYBLxQt10tY7SWnIufDQE2FRiXNJdgj1Mjj8q0Q1remwcKlmfyzh8CYMym833QY/0nAtiT7zuhmHUGN9hAdkQtvhfmwUE/LlGza7yhS4BAdCS24LNq/mYqY9FuwzWM3qPM6p5HeFiBnkHwmMicSzSWgh3XSXRwNNZ0+esbcpT0kajc6Q9yaMil1VLZ5nRmG/EZsIR5Y6BuTaaTzp1EwBhXSkzg0VslWC9YGSTqOE7i/7GUQ3r8lJBhTIt4nyQytddonPEjMRVsEcCkJwFQeyVqRnVu3KxME3Ga/kuDg3E5eSUK6DsymtC3/lvArzVu/J95B6QkdWNcXWT/qSPAKc8KwSlK+f5Zj6c2Rj6j5puSSUdEs2UgrCWiRLYKiXH75MMhad7nOwoaSLYENUv26QL/UUXXZPzYpoPHQdEsbuiJzt2vfr7irhJLfegsBqfVu9jw/A
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(921005)(186003)(36860700001)(2906002)(36756003)(7416002)(1076003)(508600001)(26005)(8936002)(8676002)(356005)(81166007)(83380400001)(86362001)(7696005)(47076005)(316002)(30864003)(336012)(2616005)(70586007)(426003)(82310400003)(70206006)(5660300002)(110136005)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:28:56.8691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6322ec77-87ca-4ded-f98a-08d9aad20be5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf progs are attached to cgroups as usual with the idea of effective
progs remain the same.  The perf event / tracepoint's fd is defined as
attachment 'subtype'.  The 'subtype' is passed along during attachment
via bpf_attr, reusing replace_bpf_fd field.

After the effective progs are calculated, perf_event is allocated using
the 'subtype'/'fd' value for all cpus filtering on the perf cgroup that
corresponds to the bpf-cgroup (with assumption of a unified hierarchy.)
The effective bpf prog array is then attached to each newly allocated
perf_event and subsequently enabled by activate_effective_progs.

Change-Id: I07a4dcaa0a682bafa496f05411365100d6c84fff
Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 include/linux/bpf-cgroup.h | 15 ++++--
 include/linux/perf_event.h |  4 ++
 kernel/bpf/cgroup.c        | 96 +++++++++++++++++++++++++++++++-------
 kernel/cgroup/cgroup.c     |  9 ++--
 kernel/events/core.c       | 45 ++++++++++++++++++
 5 files changed, 142 insertions(+), 27 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index a5e4d9b19470..b6e22fd2aa6e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -154,6 +154,11 @@ struct cgroup_bpf {
 
 	/* cgroup_bpf is released using a work queue */
 	struct work_struct release_work;
+
+        /* list of perf events (per child cgroups) for tracepoint/kprobe/uprobe bpf attachment to cgroup */
+        /* TODO: array of tp type with array of events for each cgroup
+         * currently only one tp type supported at a time */
+        struct list_head per_cg_events;
 };
 
 int cgroup_bpf_inherit(struct cgroup *cgrp);
@@ -161,21 +166,21 @@ void cgroup_bpf_offline(struct cgroup *cgrp);
 
 int __cgroup_bpf_attach(struct cgroup *cgrp,
 			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
+			struct bpf_cgroup_link *link, int bpf_attach_subtype,
 			enum bpf_attach_type type, u32 flags);
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			struct bpf_cgroup_link *link,
-			enum bpf_attach_type type);
+			enum bpf_attach_type type, int bpf_attach_subtype);
 int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 
 /* Wrapper for __cgroup_bpf_*() protected by cgroup_mutex */
 int cgroup_bpf_attach(struct cgroup *cgrp,
 		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link, enum bpf_attach_type type,
-		      u32 flags);
+		      struct bpf_cgroup_link *link, int bpf_attach_subtype,
+		      enum bpf_attach_type type, u32 flags);
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type);
+		      enum bpf_attach_type type, int bpf_attach_subtype);
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9c440db65c18..5a149d8865a1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -776,6 +776,7 @@ struct perf_event {
 
 #ifdef CONFIG_CGROUP_PERF
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
+	struct list_head		bpf_cg_list;
 #endif
 
 #ifdef CONFIG_SECURITY
@@ -982,6 +983,9 @@ extern void perf_pmu_resched(struct pmu *pmu);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
+extern int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
+				struct cgroup *cgroup,
+				struct list_head *entries);
 extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 03145d45e3d5..0ecf465ddfb2 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -14,6 +14,8 @@
 #include <linux/string.h>
 #include <linux/bpf.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/perf_event.h>
+#include <linux/trace_events.h>
 #include <net/sock.h>
 #include <net/bpf_sk_storage.h>
 
@@ -112,6 +114,8 @@ static void cgroup_bpf_release(struct work_struct *work)
 	struct bpf_prog_array *old_array;
 	struct list_head *storages = &cgrp->bpf.storages;
 	struct bpf_cgroup_storage *storage, *stmp;
+	struct list_head *events = &cgrp->bpf.per_cg_events;
+	struct perf_event *event, *etmp;
 
 	unsigned int atype;
 
@@ -141,6 +145,10 @@ static void cgroup_bpf_release(struct work_struct *work)
 		bpf_cgroup_storage_free(storage);
 	}
 
+	list_for_each_entry_safe(event, etmp, events, bpf_cg_list) {
+		perf_event_release_kernel(event);
+	}
+
 	mutex_unlock(&cgroup_mutex);
 
 	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
@@ -226,13 +234,16 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
  */
 static int compute_effective_progs(struct cgroup *cgrp,
 				   enum cgroup_bpf_attach_type atype,
+				   int bpf_attach_subtype,
 				   struct bpf_prog_array **array)
 {
 	struct bpf_prog_array_item *item;
 	struct bpf_prog_array *progs;
 	struct bpf_prog_list *pl;
 	struct cgroup *p = cgrp;
-	int cnt = 0;
+	struct perf_event *event, *etmp;
+	struct perf_event_attr attr = {};
+	int rc, cnt = 0;
 
 	/* count number of effective programs by walking parents */
 	do {
@@ -245,6 +256,21 @@ static int compute_effective_progs(struct cgroup *cgrp,
 	if (!progs)
 		return -ENOMEM;
 
+	if (atype == CGROUP_TRACEPOINT) {
+		/* TODO: only create event for cgroup that can have process */
+
+		attr.config = bpf_attach_subtype;
+		attr.type = PERF_TYPE_TRACEPOINT;
+		attr.sample_type = PERF_SAMPLE_RAW;
+		attr.sample_period = 1;
+		attr.wakeup_events = 1;
+
+		rc = perf_event_create_for_all_cpus(&attr, cgrp,
+				&cgrp->bpf.per_cg_events);
+		if (rc)
+			goto err;
+	}
+
 	/* populate the array with effective progs */
 	cnt = 0;
 	p = cgrp;
@@ -264,20 +290,41 @@ static int compute_effective_progs(struct cgroup *cgrp,
 		}
 	} while ((p = cgroup_parent(p)));
 
+	if (atype == CGROUP_TRACEPOINT) {
+		list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list) {
+			rc = perf_event_attach_bpf_prog_array(event, progs);
+			if (rc)
+				goto err_attach;
+		}
+	}
+
 	*array = progs;
 	return 0;
+err_attach:
+	list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list)
+		perf_event_release_kernel(event);
+err:
+	bpf_prog_array_free(progs);
+	return rc;
 }
 
 static void activate_effective_progs(struct cgroup *cgrp,
 				     enum cgroup_bpf_attach_type atype,
 				     struct bpf_prog_array *old_array)
 {
-	old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
-					lockdep_is_held(&cgroup_mutex));
-	/* free prog array after grace period, since __cgroup_bpf_run_*()
-	 * might be still walking the array
-	 */
-	bpf_prog_array_free(old_array);
+	struct perf_event *event, *etmp;
+
+	if (atype == CGROUP_TRACEPOINT)
+		list_for_each_entry_safe(event, etmp, &cgrp->bpf.per_cg_events, bpf_cg_list)
+			perf_event_enable(event);
+	else {
+		old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
+						lockdep_is_held(&cgroup_mutex));
+		/* free prog array after grace period, since __cgroup_bpf_run_*()
+		 * might be still walking the array
+		 */
+		bpf_prog_array_free(old_array);
+	}
 }
 
 /**
@@ -306,9 +353,10 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
 
 	INIT_LIST_HEAD(&cgrp->bpf.storages);
+	INIT_LIST_HEAD(&cgrp->bpf.per_cg_events);
 
 	for (i = 0; i < NR; i++)
-		if (compute_effective_progs(cgrp, i, &arrays[i]))
+		if (compute_effective_progs(cgrp, i, -1, &arrays[i]))
 			goto cleanup;
 
 	for (i = 0; i < NR; i++)
@@ -328,7 +376,8 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 }
 
 static int update_effective_progs(struct cgroup *cgrp,
-				  enum cgroup_bpf_attach_type atype)
+				  enum cgroup_bpf_attach_type atype,
+                                  int bpf_attach_subtype)
 {
 	struct cgroup_subsys_state *css;
 	int err;
@@ -340,7 +389,8 @@ static int update_effective_progs(struct cgroup *cgrp,
 		if (percpu_ref_is_zero(&desc->bpf.refcnt))
 			continue;
 
-		err = compute_effective_progs(desc, atype, &desc->bpf.inactive);
+		err = compute_effective_progs(desc, atype, bpf_attach_subtype,
+				&desc->bpf.inactive);
 		if (err)
 			goto cleanup;
 	}
@@ -424,6 +474,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
  * @prog: A program to attach
  * @link: A link to attach
  * @replace_prog: Previously attached program to replace if BPF_F_REPLACE is set
+ * @bpf_attach_subtype: Type ID of perf tracing event for tracepoint/kprobe/uprobe
  * @type: Type of attach operation
  * @flags: Option flags
  *
@@ -432,7 +483,7 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
  */
 int __cgroup_bpf_attach(struct cgroup *cgrp,
 			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
+			struct bpf_cgroup_link *link, int bpf_attach_subtype,
 			enum bpf_attach_type type, u32 flags)
 {
 	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
@@ -454,6 +505,14 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (!!replace_prog != !!(flags & BPF_F_REPLACE))
 		/* replace_prog implies BPF_F_REPLACE, and vice versa */
 		return -EINVAL;
+        if ((type == BPF_CGROUP_TRACEPOINT) &&
+	    ((flags & BPF_F_REPLACE) || (bpf_attach_subtype < 0) || !(flags & BPF_F_ALLOW_MULTI)))
+		/* replace fd is used to pass the subtype */
+		/* subtype is required for BPF_CGROUP_TRACEPOINT */
+		/* not allow multi BPF progs for the attach type for now */
+                return -EINVAL;
+
+	/* TODO check bpf_attach_subtype is valid */
 
 	atype = to_cgroup_bpf_attach_type(type);
 	if (atype < 0)
@@ -499,7 +558,7 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.flags[atype] = saved_flags;
 
-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, bpf_attach_subtype);
 	if (err)
 		goto cleanup;
 
@@ -679,7 +738,8 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
  * Must be called with cgroup_mutex held.
  */
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_cgroup_link *link, enum bpf_attach_type type)
+			struct bpf_cgroup_link *link, enum bpf_attach_type type,
+			int bpf_attach_subtype)
 {
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
@@ -708,7 +768,7 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	pl->prog = NULL;
 	pl->link = NULL;
 
-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, bpf_attach_subtype);
 	if (err)
 		goto cleanup;
 
@@ -809,7 +869,7 @@ int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 		}
 	}
 
-	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL,
+	ret = cgroup_bpf_attach(cgrp, prog, replace_prog, NULL, attr->replace_bpf_fd,
 				attr->attach_type, attr->attach_flags);
 
 	if (replace_prog)
@@ -832,7 +892,7 @@ int cgroup_bpf_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
 	if (IS_ERR(prog))
 		prog = NULL;
 
-	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type);
+	ret = cgroup_bpf_detach(cgrp, prog, attr->attach_type, attr->replace_bpf_fd);
 	if (prog)
 		bpf_prog_put(prog);
 
@@ -861,7 +921,7 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
 	}
 
 	WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
-				    cg_link->type));
+				    cg_link->type, -1));
 
 	cg = cg_link->cgroup;
 	cg_link->cgroup = NULL;
@@ -961,7 +1021,7 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		goto out_put_cgroup;
 	}
 
-	err = cgroup_bpf_attach(cgrp, NULL, NULL, link,
+	err = cgroup_bpf_attach(cgrp, NULL, NULL, link, -1,
 				link->type, BPF_F_ALLOW_MULTI);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a645b212b69b..17a1269dc2f9 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6626,25 +6626,26 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
 #ifdef CONFIG_CGROUP_BPF
 int cgroup_bpf_attach(struct cgroup *cgrp,
 		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link,
+		      struct bpf_cgroup_link *link, int bpf_attach_subtype,
 		      enum bpf_attach_type type,
 		      u32 flags)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
+	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link,
+                bpf_attach_subtype, type, flags);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
 
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type)
+		      enum bpf_attach_type type, int bpf_attach_subtype)
 {
 	int ret;
 
 	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
+	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type, bpf_attach_subtype);
 	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d34e00749c9b..71056af4322b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12511,6 +12511,51 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
+				struct cgroup *cgroup,
+				struct list_head *entries)
+{
+	struct perf_event **events;
+        struct perf_cgroup *perf_cgrp;
+	int cpu, i = 0;
+
+	events = kzalloc(sizeof(struct perf_event *) * num_possible_cpus(),
+			GFP_KERNEL);
+
+	if (!events)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		/* allocate first, connect the cgroup later */
+		events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+
+		if (IS_ERR(events[i]))
+			goto err;
+
+		i++;
+	}
+
+	perf_cgrp = cgroup_tryget_perf_cgroup(cgroup);
+	if (!perf_cgrp)
+		goto err;
+
+	for (i--; i >= 0; i--) {
+                events[i]->cgrp = perf_cgrp;
+
+                list_add(&events[i]->bpf_cg_list, entries);
+	}
+
+	kfree(events);
+	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		free_event(events[i]);
+
+	kfree(events);
+	return -ENOMEM;
+}
+
 void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 {
 	struct perf_event_context *src_ctx;
-- 
2.25.1

