Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7D68B6A8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 08:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjBFHsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 02:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjBFHs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 02:48:27 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4175C18A9B;
        Sun,  5 Feb 2023 23:48:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLsp8OkfnvgUX+LaCm1Dc+hdKUsiL3axpftCKUHDm1OQkZpSVWKd41QJpSxq9ko55snTctoS/hMmNjRr+itI3WbB3Q3AzmA6538HBTiXXlDO0S3AaJVzGqI3eu5++vIHZ28QtTlNa+k+dSpLAd+wLCU2EFbS1oHBSxKOk5zueaVmKcpYV50EsgXkylZrJGkkEePSOvrV9I/Bsj2oa8vxDvjsc+kGnGm5e5xycHnK4lkQOFyzYKvS14dWfW/63g0BN0S08F1XDTOjdIwd3UKL6vwTI7+T6eKerf0GqbZqLxKFY5wI1baz3a/2JfDv/WRas+jgQG8iAAdpSy/yR16sQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC0ascId9hC0FQ0mqA9gGlsD4Tec21nIaiiKW1ANuos=;
 b=e2vefkFqyA3sW3pHTN46sHlZlBtRrXMyAf4In3Tgp7gdMSg10ziiTG5iwAIpdN+Nv9Oog6rQy/dMDY2dO6w3grxgRGp9gRCGkURF3SWuxdZ5pDPWPjWfF80aA0GfSO+a7RMpi+RETUh04airuQKTuoiT7NdVEbit7kL7o+ESiApp+a+LNO8scmfZwfOWs/wTgyVxb6qqRBkFNcpqOIFrxMM0d+LT8KWcaV3OeF5iSjB1ePBi+f8eg+llIHnurirOEwoKyueOezpUAMsA1l275ngrS9mwcE1qemLfX/zE+eYf570QvCXAfD87djcKO8wu77Flv39WV5CzVvqq2LSVCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC0ascId9hC0FQ0mqA9gGlsD4Tec21nIaiiKW1ANuos=;
 b=A+FFKqJYzlIAVESoxZN19dbMh3tOUmAXg71BZGbiuV4HgT2WwNhXvo9H+EqVd1hYY7W1iy9x2eJ4H3XwaGr2jO5d9GIETU1TZlbpbaiAHeuE5em9pnJ4MNG1/6OKDbNRjYa1RYLSWzUTRajUam0hS8av8ruJv6K2TuFY+X4QQbLJGSDzZBmJnFND8gFdvARudQbQbxKxMrYh7Rhm7JbL033fzE2OtsmZD+IYJ1sO5/fcSIk019OYzNFb21GL+KvbDlEwCq+4mkJl2w71KvdFVvoO4dgzK/vrr1yASUdmbDEzRitZTTs59gTXhfNc79Z05lPOjSUH1lVBxsi65AXCxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:63::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 07:48:21 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:48:21 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
Subject: [PATCH 01/19] mm: Introduce vm_account
Date:   Mon,  6 Feb 2023 18:47:38 +1100
Message-Id: <e80b61561f97296a6c08faeebe281cb949333d1d.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0010.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::15) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: f1f32d26-9f86-4df0-cce9-08db081684ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d9R20AXDYdOn6o7fqjRKlbn88gfGEhrLB0K3l/C7lo/hVvC76CZp4upyM7QvG93ysjuMVTpq/EYzK3rKe+gwBlyHxY43+Hqd/7szzD+TETPh4YIz49dsl8Pco7UcHmIYR1jDb462M2A51jpFSyZ6+sGx3FpEttvQxlIDeCWQn6283qmfDF4QeL0MGLkLR28DA19JymNK1RtyPkmfKZ09MLSCaFGJ3h12WGdvnJ5w7VGFIKFvz5stxIwwdIt0+gYERQCSlt2L26GRq9KV2GcYX8YE/OcLGZSrecKGGipuwqQm8Z7Ynh+TybkKzd+Y+ZdZKAXFYvSW5vAWUTT6n5GHEu+1RV85ersB37hzKHCRBbBjQk2dt2lN4HS7GS390bwhNfyVDFRZjE/rWx/Sf6l81vQ0i636fN5go+YWW9m/Cs2GeJ2kUXo2o5oo3aZ6hLhWLaDc2cMg8f+dO2hQNOm31Wmf2fNIgwK112xrMKjJwP7uMzzPMRVJHnTwtouclvVkulpeSj9ZswUbyFtJMziahx/BcMaIlFXt789djlRAEZlvA5Dolz1bNDtuZdc6P5ZWA0RBVH2YzDo/Bl5+FviW2ege3AA0jp0C20IRSY3uXiO/9yQxMIEjpPmWqNjE32CPYcudf9GcWGjjbN/MTX2aSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(38100700002)(36756003)(6506007)(6666004)(6512007)(26005)(186003)(478600001)(86362001)(6486002)(8676002)(66476007)(83380400001)(66946007)(2616005)(66556008)(4326008)(316002)(54906003)(7416002)(2906002)(8936002)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Q21fH/s4Vq+Fkqt0pEjMYKv/M0hPKFwEmzpwjecwZ8dEKYu6PTd6B1USsF/?=
 =?us-ascii?Q?VIewWV1Iy7hIjEqgKdvNy9XCHb6UCEjDlG2t6luAcyANcpffEfiNXj358C55?=
 =?us-ascii?Q?PHbMpnatLbnb82LSxL2sxcLHQRbRVzZM4h6g/3499Op4qz4eIG6rIq3sP9GR?=
 =?us-ascii?Q?rHx6Tqds5OHj2oy53ycVE3dECU0kComR0bp0U7UTdqpK3MVIK9uKGtcSo4Ek?=
 =?us-ascii?Q?Cbqps8ws+uJxEI5RpRZ5p7iBSlY1ReOPfXul3U6G9MPEBkweNR5Wo4HcAc+B?=
 =?us-ascii?Q?jX1x0G6BMm8BJAXdvBORkAl4CFmowC8Z7E5ZKBPUT5ioGLu+OjJVqhEa8hve?=
 =?us-ascii?Q?ZC2M2WJRwoyMFTyjy2k0f0mQRnvj+PbEIX9nx0SvfTjUFABqKwU2Z/1Fm7Xv?=
 =?us-ascii?Q?9WusQn3HTFnsyEhVU+QqZxtf77029QaAn7uZJvEiblZXE7TUUdcHfTdyjgSV?=
 =?us-ascii?Q?OCgszweWtFLTMBCKcBoMx6yuvAiU7de3NbVmKBBV8LRfJqjM7RFqUHnRfyvt?=
 =?us-ascii?Q?K1pKsfXe4zb2OgYq63aCbk2+0hF6r+nw/5hVzf3oLt+yiapdrUwdK204DQoA?=
 =?us-ascii?Q?k7KTXc0CUaKI+YNGo7bKPIG5cPGui7kSYT8ZHQawvSD5trq1ErBFkeBBXADo?=
 =?us-ascii?Q?ptjHtDfi3Pg7Ff9bjSqv6u42noCshGmM1eBj496JFjjjXcJhMESM0UuKS0F2?=
 =?us-ascii?Q?TKDR4mzK8GH/muRsjSoL0JfMn014g6VRrKHh+a22/xsmKrh3u4HljrqaMeDB?=
 =?us-ascii?Q?4He5JHwM8s6+kyeU3CkKgOVeyN4xgfwHQ6JVUOEPzp4X3pKkge5V1WIX3TkA?=
 =?us-ascii?Q?s/DwB8n2QfUb6ruFRychXQVgfdrAn7N5YcN5N2pPqmatRWTthyyJoTWcZlP3?=
 =?us-ascii?Q?5J8yKRhYIQwQbIQ2MaYqf5KLWk134Bzhxzo196snfUec2RW4rFit/7Kw9A1e?=
 =?us-ascii?Q?mZZT6nrbdKxVMb2x4rLRIxM6jc3snl4WQrocd8r+Jex/vzsh4zSwhhQK/Zei?=
 =?us-ascii?Q?tOfxrewOqeLpG4hAG6rV+1VYTwlTQSKpvx/dthFLHcaIWOWtpB7h22PdCdxl?=
 =?us-ascii?Q?4ctObXm+w4mkFr6WPaoITf8lxJbTwuYTIvy/Mq7HbwmfN07KQI8tkrtcRQ3i?=
 =?us-ascii?Q?ewm7r0HFtWQlYXGN5XBXsek/Aegzb5gF66fpZ5YIsbXbHelBwOnZo3v5sLif?=
 =?us-ascii?Q?uZO8AKQCMFaIOK1Twc761o7A+q72PinuISoun30BXs8bsrh8ysRQpqLPQZ+x?=
 =?us-ascii?Q?f48dz4zs6W4s9UdVoaLqG6poioJSXQUKEZX9xL5SLtn6VQrm9k6GtYtOTt9B?=
 =?us-ascii?Q?qPFEyEwU4aQb7bAr9tjtFNFQyul65a2UajRWmTk8oOjmPQjG+0Na8AIoKRBX?=
 =?us-ascii?Q?DTYolD25NtClc2GWUtxdF/r0g6WMambOrmoQN6PDvnNKiH2Y3LfxvCe/hoG9?=
 =?us-ascii?Q?6VD9Gr2SfaI7ut/DvIDGvS6cWJREA9GsI7fQpkHJD5us1nkC88mmR73jv99T?=
 =?us-ascii?Q?+Zys5Jd8GStZTQDKhn9QFylG+VJvDSWAbh1nlVL/o3r8ujdUkBp+ttAnY5R8?=
 =?us-ascii?Q?3qnC7BMvidrwhW6C5R1H2kqzZKGGZ+24X44EGeMu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f32d26-9f86-4df0-cce9-08db081684ae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:48:21.2970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKLsBrolhjVwe4eRftYA1HkxxQ/SlJh07YGyjddLzMudWGCcOJdVx+UWim/wuIqJ+Bp6tmOMG+wJxI7NtMvsPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel drivers that pin pages should account these pages against
either user->locked_vm and/or mm->pinned_vm and fail the pinning if
RLIMIT_MEMLOCK is exceeded and CAP_IPC_LOCK isn't held.

Currently drivers open-code this accounting and use various methods to
update the atomic variables and check against the limits leading to
various bugs and inconsistencies. To fix this introduce a standard
interface for charging pinned and locked memory. As this involves
taking references on kernel objects such as mm_struct or user_struct
we introduce a new vm_account struct to hold these references. Several
helper functions are then introduced to grab references and check
limits.

As the way these limits are charged and enforced is visible to
userspace we need to be careful not to break existing applications by
charging to different counters. As a result the vm_account functions
support accounting to different counters as required.

A future change will extend this to also account against a cgroup for
pinned pages.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-fpga@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: io-uring@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: bpf@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Cc: linux-kselftest@vger.kernel.org
---
 include/linux/vm_account.h |  56 +++++++++++++++++-
 mm/util.c                  | 127 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 183 insertions(+)
 create mode 100644 include/linux/vm_account.h

diff --git a/include/linux/vm_account.h b/include/linux/vm_account.h
new file mode 100644
index 0000000..b4b2e90
--- /dev/null
+++ b/include/linux/vm_account.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VM_ACCOUNT_H
+#define _LINUX_VM_ACCOUNT_H
+
+/**
+ * enum vm_account_flags - Determine how pinned/locked memory is accounted.
+ * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
+ * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
+ * @VM_ACCOUNT_USER: Account locked memory to user->locked_vm.
+ *
+ * Determines which statistic pinned/locked memory is accounted
+ * against. All limits will be enforced against RLIMIT_MEMLOCK and the
+ * pins cgroup if CONFIG_CGROUP_PINS is enabled.
+ *
+ * New drivers should use VM_ACCOUNT_USER. VM_ACCOUNT_TASK is used by
+ * pre-existing drivers to maintain existing accounting against
+ * mm->pinned_mm rather than user->locked_mm.
+ *
+ * VM_ACCOUNT_BYPASS may also be specified to bypass rlimit
+ * checks. Typically this is used to cache CAP_IPC_LOCK from when a
+ * driver is first initialised. Note that this does not bypass cgroup
+ * limit checks.
+ */
+enum vm_account_flags {
+	VM_ACCOUNT_USER = 0,
+	VM_ACCOUNT_BYPASS = 1,
+	VM_ACCOUNT_TASK = 1,
+};
+
+struct vm_account {
+	struct task_struct *task;
+	struct mm_struct *mm;
+	struct user_struct *user;
+	enum vm_account_flags flags;
+};
+
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags);
+
+/**
+ * vm_account_init_current - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ *
+ * Helper to initialise a vm_account for the common case of charging
+ * with VM_ACCOUNT_TASK against current.
+ */
+static inline void vm_account_init_current(struct vm_account *vm_account)
+{
+	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
+}
+
+void vm_account_release(struct vm_account *vm_account);
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages);
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages);
+
+#endif /* _LINUX_VM_ACCOUNT_H */
diff --git a/mm/util.c b/mm/util.c
index b56c92f..d8c19f8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -23,6 +23,7 @@
 #include <linux/processor.h>
 #include <linux/sizes.h>
 #include <linux/compat.h>
+#include <linux/vm_account.h>
 
 #include <linux/uaccess.h>
 
@@ -431,6 +432,132 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 #endif
 
 /**
+ * vm_account_init - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ * @task: task to charge against.
+ * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
+ * @flags: flags to use when charging to vm_account.
+ *
+ * Initialise a new uninitialised struct vm_account. Takes references
+ * on the task/mm/user/cgroup as required although callers must ensure
+ * any references passed in remain valid for the duration of this
+ * call.
+ */
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags)
+{
+	vm_account->task = get_task_struct(task);
+
+	if (flags & VM_ACCOUNT_USER)
+		vm_account->user = get_uid(user);
+
+	mmgrab(task->mm);
+	vm_account->mm = task->mm;
+	vm_account->flags = flags;
+}
+EXPORT_SYMBOL_GPL(vm_account_init);
+
+/**
+ * vm_account_release - Initialise a new struct vm_account.
+ * @vm_account: pointer to initialised vm_account.
+ *
+ * Drop any object references obtained by vm_account_init(). The
+ * vm_account must not be used after calling this unless reinitialised
+ * with vm_account_init().
+ */
+void vm_account_release(struct vm_account *vm_account)
+{
+	put_task_struct(vm_account->task);
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		free_uid(vm_account->user);
+
+	mmdrop(vm_account->mm);
+}
+EXPORT_SYMBOL_GPL(vm_account_release);
+
+/*
+ * Charge pages with an atomic compare and swap. Returns -ENOMEM on
+ * failure, 1 on success and 0 for retry.
+ */
+static int vm_account_cmpxchg(struct vm_account *vm_account,
+				unsigned long npages, unsigned long lock_limit)
+{
+	u64 cur_pages, new_pages;
+
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		cur_pages = atomic_long_read(&vm_account->user->locked_vm);
+	else
+		cur_pages = atomic64_read(&vm_account->mm->pinned_vm);
+
+	new_pages = cur_pages + npages;
+	if (lock_limit != RLIM_INFINITY && new_pages > lock_limit)
+		return -ENOMEM;
+
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		return atomic_long_cmpxchg(&vm_account->user->locked_vm,
+					   cur_pages, new_pages) == cur_pages;
+	} else {
+		return atomic64_cmpxchg(&vm_account->mm->pinned_vm,
+					   cur_pages, new_pages) == cur_pages;
+	}
+}
+
+/**
+ * vm_account_pinned - Charge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to charge.
+ *
+ * Return: 0 on success, -ENOMEM if a limit would be exceeded.
+ *
+ * Note: All pages must be explicitly uncharged with
+ * vm_unaccount_pinned() prior to releasing the vm_account with
+ * vm_account_release().
+ */
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	unsigned long lock_limit = RLIM_INFINITY;
+	int ret;
+
+	if (!(vm_account->flags & VM_ACCOUNT_BYPASS) && !capable(CAP_IPC_LOCK))
+		lock_limit = task_rlimit(vm_account->task,
+					RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	while (true) {
+		ret = vm_account_cmpxchg(vm_account, npages, lock_limit);
+		if (ret > 0)
+			break;
+		else if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * Always add pinned pages to mm->pinned_vm even when we're
+	 * not enforcing the limit against that.
+	 */
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		atomic64_add(npages, &vm_account->mm->pinned_vm);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vm_account_pinned);
+
+/**
+ * vm_unaccount_pinned - Uncharge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to uncharge.
+ */
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		atomic_long_sub(npages, &vm_account->user->locked_vm);
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	} else {
+		atomic64_sub(npages, &vm_account->mm->pinned_vm);
+	}
+}
+EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
+
+/**
  * __account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against
  * @pages:       number of pages to account
-- 
git-series 0.9.1
