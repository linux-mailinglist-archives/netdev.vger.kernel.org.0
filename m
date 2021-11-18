Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B416456423
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhKRUcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:32:06 -0500
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:45825
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233918AbhKRUb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:31:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA/iyLG/p0Z8wvtYA+kuFOpL2+XzUsmbM9Nldw57kHLOnW/cglV8hSe2wWokiT+H1d07KCfS/enbYBnZTbZ1OF3iZtjDjINGn/j63EzvXIlIsyhCDDy3yfjQfxfTag6upj/txhR0hJVDw/0Qb7Zs+7Cg/YI+eafiwnG4KFg8vyR7PjXkbcjzF/J7yxY9Nb2wTJlFAOSE1xlOxmL8TXtOB7Ka+6wvG3AHOZHKbxdDh9qYMDEl6UFEqHl10AHoAZjEOSAzY/5kJ2k9hjYqMPmBE5fWk8vU2oPxo8BpCbb6gtcrwQVC9CDwbKk16VRM0odMbcZFxi9kZMolakL6As1kag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LTCxDJv3hxoUKuAs/bDMtp2aWzOrmYrLj1GHD61d7s=;
 b=BaNMWAK86OrCRHumfAzuCfkeAhxmeub4/zVYIcuHNJX79n9XPsM//Raxm11e25EZhSB5vU8ifAHN/0BYAEdmA+zM9KTUSJhGi1EcWS6Uq3bcpf4t61Aux4esoAUXGlq+Gg+q5bZ598UR6nn7v/iVUJqWmSH2xmflHUyNyVVVwqW39s3bwKSeQj4TwNVDz/2lfsNs+BBEeX4t8pvXu+HSbSvFm9NmKReE7kx7uNiIIwz6RXo4NrvoQ0IvFCoBwLnQXgMIPHldszQB2dx5ZWWNb0coMofa7GaI0NlNGYDScsEsCh6S4dwNiYKXgBEJUIsN1EaWDMCOzy/die19zqKdFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LTCxDJv3hxoUKuAs/bDMtp2aWzOrmYrLj1GHD61d7s=;
 b=ApN7FpnWJgqBMOzvj8slk3X08GPp57/v2+cNanaKEgPqjegxvtz3347IPTRrSvrek4f4tL/M5DmZnjC/TFa9HHUAooH40Fo78JPeZERa+z77stRYrNwE26g2gnjX+RQsXBtkab95HUWPTk5ZtbuIsM0SOhOO1NFA5WwS0O+CytY=
Received: from CO1PR15CA0100.namprd15.prod.outlook.com (2603:10b6:101:21::20)
 by DM5PR12MB1884.namprd12.prod.outlook.com (2603:10b6:3:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19; Thu, 18 Nov
 2021 20:28:54 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::69) by CO1PR15CA0100.outlook.office365.com
 (2603:10b6:101:21::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Thu, 18 Nov 2021 20:28:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4713.20 via Frontend Transport; Thu, 18 Nov 2021 20:28:53 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 14:28:52 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 18 Nov
 2021 12:28:52 -0800
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 18 Nov 2021 14:28:50 -0600
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
Subject: [PATCH RFC 2/4] bpf, perf: add ability to attach complete array of bpf prog to perf event
Date:   Thu, 18 Nov 2021 15:28:38 -0500
Message-ID: <20211118202840.1001787-3-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be50af72-0c38-4f0f-df92-08d9aad20a22
X-MS-TrafficTypeDiagnostic: DM5PR12MB1884:
X-Microsoft-Antispam-PRVS: <DM5PR12MB18842DBD53F68C3EA10FCAE4839B9@DM5PR12MB1884.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1WZwLl9IAM2ZRnfg9gPck5Of6ZECwY/ibq3TKbVkdNuKLAX9SZXMR/k2vitWydD5ylQ0712qRpizTCFosrvtLJiEeCc4KdPA4hzHOpKvfGpwsO/LR1bW9VGP+4/aUFfz2UwlLUiWJ0NrPVJHVRYv6AA4UjiV0geERUaENmmxtZ4AuuyhYlIhaD9Hc2LTu7od5rzgg1+2BZEDa/QqC1rICF3ocNb5538sKBq3Z9Uj8AFXK48wHWoRHej0ErZ/SioQcVgowqcJtBiZvwF2qK/LnhmwIe3/Y2HUUk0ddBo5z141uElM/YACQxwwoUPCaHWfS8FgTjI/tOItdKm1BB4PCPxrq5maOdL2ww7VYHVmmZwr0YmVybhQckLsH/fOb2DVz/pOaItajv7OwjK3D/32akzFA3ULou6zXF/1q36SrQi50vqNBizanlSrgZ1L0la88wlGiTrSB1gnmgCKQL+sNNbEA9YovZDexJYR/RRjMahrBxdYaJRasN+MLoZ+vjr56cARr1ZO4RLqk3lLN3kvxSvxlEMnWW68IGZjpdUTp8fOe4PauM/HgzI1DrWdS4Chrcu2bqO9fD9Fsj8o33k7ws0G/HatwZvLlA3k50LlMUhr/NH4PVQRm02t50/RNtPXUMBBhsfUW4BMmOwo3N8XeneT6Z9npr6LKQMpr7u+JueDw6Qwx27CbIrKVRCIibF/pYXHG+pGJ1UShXGJz7OcbihXXj34kq+uZJ88Z+0oMtR4HfX9X+aGS3KokxWrsouO
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(7416002)(36860700001)(426003)(110136005)(336012)(2906002)(83380400001)(47076005)(508600001)(8936002)(921005)(1076003)(356005)(70586007)(70206006)(7696005)(82310400003)(36756003)(5660300002)(81166007)(186003)(26005)(2616005)(86362001)(6666004)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:28:53.8038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be50af72-0c38-4f0f-df92-08d9aad20a22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change-Id: Ie2580c3a71e2a5116551879358cb5304b04d3838
Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 include/linux/trace_events.h |  9 +++++++++
 kernel/trace/bpf_trace.c     | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 3e475eeb5a99..5cfe3d08966c 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -725,6 +725,8 @@ trace_trigger_soft_disabled(struct trace_event_file *file)
 
 #ifdef CONFIG_BPF_EVENTS
 unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx);
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array);
 int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog, u64 bpf_cookie);
 void perf_event_detach_bpf_prog(struct perf_event *event);
 int perf_event_query_prog_array(struct perf_event *event, void __user *info);
@@ -741,6 +743,13 @@ static inline unsigned int trace_call_bpf(struct trace_event_call *call, void *c
 	return 1;
 }
 
+static inline int
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int
 perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog, u64 bpf_cookie)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6b3153841a33..8addd10202c2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1802,6 +1802,34 @@ static DEFINE_MUTEX(bpf_event_mutex);
 
 #define BPF_TRACE_MAX_PROGS 64
 
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array)
+{
+	struct bpf_prog_array_item *item;
+	struct bpf_prog_array *old_array;
+
+	if (!new_array)
+		return -EINVAL;
+
+	if (bpf_prog_array_length(new_array) >= BPF_TRACE_MAX_PROGS)
+		return -E2BIG;
+
+	if (!trace_kprobe_on_func_entry(event->tp_event) ||
+	     !trace_kprobe_error_injectable(event->tp_event))
+		for (item = new_array->items; item->prog; item++)
+			if (item->prog->kprobe_override)
+				return -EINVAL;
+
+	mutex_lock(&bpf_event_mutex);
+
+	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
+	rcu_assign_pointer(event->tp_event->prog_array, new_array);
+	bpf_prog_array_free(old_array);
+
+	mutex_unlock(&bpf_event_mutex);
+	return 0;
+}
+
 int perf_event_attach_bpf_prog(struct perf_event *event,
 			       struct bpf_prog *prog,
 			       u64 bpf_cookie)
-- 
2.25.1

