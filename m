Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC4E286204
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgJGPYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:24:24 -0400
Received: from mail-dm6nam12on2040.outbound.protection.outlook.com ([40.107.243.40]:42049
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbgJGPYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:24:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a72I6WY55tsoBtD7KDcoFT5dSphUeZTM/NxLVNSQnaHp1ULfkRX7ogS9hu3F3tyRofwU5WjRliGNB9uLPwEuzQo9g2P7JnBgJPxY/CFHY4rCtqgFrMGiKY52XT8A2qM1L85ILfxw7n8WJpUi0npvwJ3+SHLm+ad0tFF5dSQuk9eNlg9euxgYtxhAIYneaQbe2k6VpgqeoN6FLsfSnYNvy7By/OJQAbJ+JrHNidq2kUUKq5VggrTk6SEIPpIJx5UD/nWmwGpg0I0uHSZimnmWs9c3vvrWXS55Q31Ar7yM2plPY37LHQRw5Fj4I3MOvLcQ9FcEZToOJuuDS3kD6qGVAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMdkDw6WGKvuQR/64AXppGlMZ9L6qEooQ89iwyuWPgc=;
 b=lhMS50E78KY6Q15+gJIBSiGggTf50gDzUqR6vHsxJCQ1E8NvpRBDjQju1bWztxtmquMuMnrqtj24tTRpCiDD0U9uwpU5NZ+q3k0VDUrKbQuswUaL73LUmjzsaVlk+KFNGJsAfO9CsOsAN1TELPwyqYPnu0X+v1blfp3lIFTzSw15US1893RFcDaN4/CLhgEJrqBXqTGfaQf7kHOp3UPHsjNEH7i0FL0ys0Z6ubeN9OqSYS/dm89zwasiNsAodF0ellw78Hvq+chg/j8CLj5jT5E7JDEFhKDTAi+aLdGh+2Ziy/GMdqQPXmHBMg3AVYYDgcqC5ahPRaoV4V+nk/obzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=none action=none header.from=amd.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zMdkDw6WGKvuQR/64AXppGlMZ9L6qEooQ89iwyuWPgc=;
 b=f2PrxOfJnT6B9/xG15CxrA/b71smdvHPxCXYOQDHtfCmFmmKyki0Zr3TxgWHGxbUZm3mHB0t3FclH/G54xWzBjEHTeSvPbCrlVE+lbiOWO/+L7n0zcOU+vqURIWzAJg5jZ3y34uHHL8j4eX8DudQhRIdo7AvWFGm//RI1z1OwW4=
Received: from BN7PR06CA0048.namprd06.prod.outlook.com (2603:10b6:408:34::25)
 by MW3PR12MB4428.namprd12.prod.outlook.com (2603:10b6:303:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Wed, 7 Oct
 2020 15:24:16 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::64) by BN7PR06CA0048.outlook.office365.com
 (2603:10b6:408:34::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend
 Transport; Wed, 7 Oct 2020 15:24:16 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB02.amd.com (165.204.84.17) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 15:24:16 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 7 Oct 2020
 10:24:15 -0500
Received: from SATLEXMB02.amd.com (10.181.40.143) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 7 Oct 2020
 10:24:15 -0500
Received: from yuho-dev.amd.com (10.180.168.240) by SATLEXMB02.amd.com
 (10.181.40.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 7 Oct 2020 10:24:15 -0500
From:   Kenny Ho <Kenny.Ho@amd.com>
To:     <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <alexander.deucher@amd.com>, <amd-gfx@lists.freedesktop.org>,
        <y2kenny@gmail.com>
CC:     Kenny Ho <Kenny.Ho@amd.com>
Subject: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date:   Wed, 7 Oct 2020 11:23:55 -0400
Message-ID: <20201007152355.2446741-1-Kenny.Ho@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2d70dde-348a-4899-4293-08d86ad50d93
X-MS-TrafficTypeDiagnostic: MW3PR12MB4428:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4428E83C19966FAE8B7E4A4C830A0@MW3PR12MB4428.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E28xFklBCKzHf8bishkOhzE0jUJTiCVTcu2/5kpuNo/UB1xJ4xVITiOQQPkxRVUzYHRemUdi3UlbACTNR9ntv8xwM1fR42+ZWfdtS1CyotQEMyOEzFNBpypXK8zti8QFgwqGVeG4qJtFlA77VWtcfRHTEvtMNv3FDzl74awIdztPrho3Hh9dJ1mXlidYtbIM7Bfvg2igXkgHKilZXNxrLg0Q8opPi/Qie9w7dW621YBDZIubbaI4DBYZMRLjwBhrEr03HASAK9g0lWir3rxiSMve6VTyfsGBpzAqSnXXwxc/MjEmkKHJax+qSk3zJaHlvmkBcDc0XzQts3k3LZADyai6LK+sj44DC2Eusv/gafe6ot7FihiI0vWHgLJHYfuhUvAEgGuSo+2D+CfGO/w7zI32KU95TM0h/G+4SvMyy8A=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB02.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(396003)(39850400004)(346002)(136003)(376002)(46966005)(4326008)(83380400001)(1076003)(6666004)(110136005)(316002)(82740400003)(81166007)(478600001)(7696005)(8936002)(47076004)(2906002)(36756003)(5660300002)(2616005)(356005)(336012)(8676002)(26005)(426003)(186003)(82310400003)(70206006)(70586007)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:24:16.0828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2d70dde-348a-4899-4293-08d86ad50d93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB02.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a skeleton implementation to invite comments and generate
discussion around the idea of introducing a bpf-cgroup program type to
control ioctl access.  This is modelled after
BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
write bpf programs to block some ioctl access, potentially in conjunction
with data collected by other bpf programs stored in some bpf maps and
with bpf_spin_lock.

For example, a bpf program has been accumulating resource usaging
statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
block access to previously mentioned resource via ioctl when the stats
stored in a bpf map reaches certain threshold.

Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
ioctls are not blocked if no bpf program is present for the cgroup.) to
maintain current interface behaviour when this functionality is unused.

Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
ensure attached bpf programs cannot crash and always terminate quickly.

TODOs:
- correct usage of the verifier
- toolings
- samples
- device driver may provide helper functions that take
bpf_cgroup_ioctl_ctx and return something more useful for specific
device

Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
---
 fs/ioctl.c                 |  5 +++
 include/linux/bpf-cgroup.h | 14 ++++++++
 include/linux/bpf_types.h  |  2 ++
 include/uapi/linux/bpf.h   |  8 +++++
 kernel/bpf/cgroup.c        | 66 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c       |  7 ++++
 kernel/bpf/verifier.c      |  1 +
 7 files changed, 103 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 4e6cc0a7d69c..a3925486d417 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -19,6 +19,7 @@
 #include <linux/falloc.h>
 #include <linux/sched/signal.h>
 #include <linux/fiemap.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if (!filp->f_op->unlocked_ioctl)
 		goto out;
 
+	error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
+	if (error)
+		goto out;
+
 	error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
 	if (error == -ENOIOCTLCMD)
 		error = -ENOTTY;
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 64f367044e25..a5f0b0a8f82b 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -134,6 +134,9 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 				      short access, enum bpf_attach_type type);
 
+int __cgroup_bpf_check_ioctl_permission(struct file *filp, unsigned int cmd, unsigned long arg,
+				        enum bpf_attach_type type);
+
 int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 				   struct ctl_table *table, int write,
 				   void **buf, size_t *pcount, loff_t *ppos,
@@ -346,6 +349,16 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
+#define BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg)       	              \
+({									      \
+	int __ret = 0;							      \
+	if (cgroup_bpf_enabled)						      \
+		__ret = __cgroup_bpf_check_ioctl_permission(filp, cmd, arg,   \
+							    BPF_CGROUP_IOCTL);\
+									      \
+	__ret;								      \
+})
+
 int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog);
 int cgroup_bpf_prog_detach(const union bpf_attr *attr,
@@ -429,6 +442,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 				       optlen, max_optlen, retval) ({ retval; })
 #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
 				       kernel_optval) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_IOCTL(type,major,minor,access) ({ 0; })
 
 #define for_each_cgroup_storage_type(stype) for (; false; )
 
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index a52a5688418e..3055e7e4918c 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -56,6 +56,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl,
 	      struct bpf_sysctl, struct bpf_sysctl_kern)
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt,
 	      struct bpf_sockopt, struct bpf_sockopt_kern)
+BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_IOCTL, cg_ioctl,
+	      struct bpf_cgroup_ioctl_ctx, struct bpf_cgroup_ioctl_ctx)
 #endif
 #ifdef CONFIG_BPF_LIRC_MODE2
 BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b6238b2209b7..6a908e13d3a3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -197,6 +197,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_CGROUP_IOCTL,
 };
 
 enum bpf_attach_type {
@@ -238,6 +239,7 @@ enum bpf_attach_type {
 	BPF_XDP_CPUMAP,
 	BPF_SK_LOOKUP,
 	BPF_XDP,
+	BPF_CGROUP_IOCTL,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -4276,6 +4278,12 @@ struct bpf_cgroup_dev_ctx {
 	__u32 minor;
 };
 
+struct bpf_cgroup_ioctl_ctx {
+	__u64 filp;
+	__u32 cmd;
+	__u32 arg;
+};
+
 struct bpf_raw_tracepoint_args {
 	__u64 args[0];
 };
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 83ff127ef7ae..0958bae3b0b7 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1203,6 +1203,72 @@ const struct bpf_verifier_ops cg_dev_verifier_ops = {
 	.is_valid_access	= cgroup_dev_is_valid_access,
 };
 
+int __cgroup_bpf_check_ioctl_permission(struct file *filp, unsigned int cmd, unsigned long arg,
+				      enum bpf_attach_type type)
+{
+	struct cgroup *cgrp;
+	struct bpf_cgroup_ioctl_ctx ctx = {
+		.filp = filp,
+		.cmd = cmd,
+		.arg = arg,
+	};
+	int allow = 1;
+
+	rcu_read_lock();
+	cgrp = task_dfl_cgroup(current);
+	allow = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx,
+				   BPF_PROG_RUN);
+	rcu_read_unlock();
+
+	return !allow;
+}
+
+static const struct bpf_func_proto *
+cgroup_ioctl_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return cgroup_base_func_proto(func_id, prog);
+}
+
+static bool cgroup_ioctl_is_valid_access(int off, int size,
+				       enum bpf_access_type type,
+				       const struct bpf_prog *prog,
+				       struct bpf_insn_access_aux *info)
+{
+	const int size_default = sizeof(__u32);
+
+	if (type == BPF_WRITE)
+		return false;
+
+	if (off < 0 || off + size > sizeof(struct bpf_cgroup_ioctl_ctx))
+		return false;
+	/* The verifier guarantees that size > 0. */
+	if (off % size != 0)
+		return false;
+
+	switch (off) {
+	case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, filp):
+		bpf_ctx_record_field_size(info, size_default);
+		if (!bpf_ctx_narrow_access_ok(off, size, size_default))
+			return false;
+		break;
+	case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, cmd):
+	case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, arg):
+	default:
+		if (size != size_default)
+			return false;
+	}
+
+	return true;
+}
+
+const struct bpf_prog_ops cg_ioctl_prog_ops = {
+};
+
+const struct bpf_verifier_ops cg_ioctl_verifier_ops = {
+	.get_func_proto		= cgroup_ioctl_func_proto,
+	.is_valid_access	= cgroup_ioctl_is_valid_access,
+};
+
 /**
  * __cgroup_bpf_run_filter_sysctl - Run a program on sysctl
  *
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 86299a292214..6984a62c96f4 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2054,6 +2054,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_IOCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
 		return true;
@@ -2806,6 +2807,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_SOCK_OPS;
 	case BPF_CGROUP_DEVICE:
 		return BPF_PROG_TYPE_CGROUP_DEVICE;
+	case BPF_CGROUP_IOCTL:
+		return BPF_PROG_TYPE_CGROUP_IOCTL;
 	case BPF_SK_MSG_VERDICT:
 		return BPF_PROG_TYPE_SK_MSG;
 	case BPF_SK_SKB_STREAM_PARSER:
@@ -2878,6 +2881,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_IOCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 		break;
@@ -2915,6 +2919,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_CGROUP_IOCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
 		return cgroup_bpf_prog_detach(attr, ptype);
 	default:
@@ -2958,6 +2963,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
+	case BPF_CGROUP_IOCTL:
 		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
@@ -3914,6 +3920,7 @@ static int link_create(union bpf_attr *attr)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_CGROUP_IOCTL:
 		ret = cgroup_bpf_link_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_TRACING:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ef938f17b944..af68f463e828 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7419,6 +7419,7 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_CGROUP_IOCTL:
 		break;
 	case BPF_PROG_TYPE_RAW_TRACEPOINT:
 		if (!env->prog->aux->attach_btf_id)
-- 
2.25.1

