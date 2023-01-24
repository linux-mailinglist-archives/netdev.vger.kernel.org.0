Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD82679017
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjAXFns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjAXFnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:43:46 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16CD3B0FD;
        Mon, 23 Jan 2023 21:43:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFiXQfbvBkmWql4u3YiSkcsVXxx4fdxDzFh+cfG0F7YG8RKF2myht+SFIZWPiJ90I+y1/CVQqAgI0vhDNpGIJz0XjEoBz37W/5V8S7cisFLFCvVaqLctGASNfBvYQvgM6t2zZmoUQNV9mmMg8MkP5VXod+lriaP92oQcMXTyqj6OsV8yyxcnC3Phl4VT+c+APnMGU4Uq+SPs/v/KQ+O550bl1MhAmXjlUFPbDMFi0GJW0ZRoc2d7VpmIa3N08a8bztR4bmhdkD3kh9siSvj+Sm5EKd0HARzz46HJoEUBQ5G8J2JwaILF0SURY0EpY42U1VgVoQmSYxIvTIF3DjFHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MtXqt5AI6xt4ICbluiJvN2UYWO1rvf+ghlewsHqu9o=;
 b=Lqn6Uk7KNBKGCHzoBnigDNo1RiNUI8Hb/hygwqIRZayF1fZm0PeeQoBCWA9nipmIFQ9O6sDUYWZCryEJ8xlpLY6HMZYu+Fmi1cMAqM3Jlg6vvGhq30PYRoqrEtycC3aRavYUAMnlMhFnDUBpc4tyvtadjwPTU0KA5nUGvEj1RjMV0KryOFZFiVcQKdGtcUibr5k9n1TRN1pn0f8V6kJOcFGWueZMv3skF2iCKaPbkGb0MMRXa4hMMHja14TyZGSzd70Bp2QtBQRqIEI7cNFX859fy9XvJkeSMPzklr8FUU+nm8AkIfFemdZj3DX8ag4ZAujP5wCUtmEMJ/8PURug0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MtXqt5AI6xt4ICbluiJvN2UYWO1rvf+ghlewsHqu9o=;
 b=bQbX4+VEqdrv0T+n3h6V6HKNVTnrJLoLgKshMGWPDjRq+Be3ItoR2iOEfJU8l91nO1ej+Qx7LNgn6gES/pIh9BOzUDP6NL0vmAHEyYxWI9g6rU+TN3EXswdvJL+ZIGEElHreUTXi4GDqPmJXkp/rNTr051kR+aUGHxWFhc1uIw3Oqc81W7WWfX30n5aTOYTvtM2Biu2z7mj1uEVUIn4TnlUlldMEU2ywLWoUl2asaa0LzZg4b2zfIbStdb35n4e9D/vlclBBG8r9NfLa5kYRgze837+mJQO3/Qptnk6Yt8oBp6DBreUwxtxoJS4KcAXc26StmTMiZT3dBMoU8H+/2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MW3PR12MB4540.namprd12.prod.outlook.com (2603:10b6:303:52::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 05:43:38 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::465a:6564:6198:2f4e%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 05:43:38 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        Alistair Popple <apopple@nvidia.com>,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 01/19] mm: Introduce vm_account
Date:   Tue, 24 Jan 2023 16:42:30 +1100
Message-Id: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SYCP282CA0018.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:80::30) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MW3PR12MB4540:EE_
X-MS-Office365-Filtering-Correlation-Id: 949f3254-124b-4c17-6368-08dafdcdf107
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMmh0azBbDX7+rL+BE5BEHNjFZdAqJn47L6YKbnxs3D7TsqxrUTQx2RSCUk3jZThDL42O5RGyuwH8zpvTaaLcOekSn4NVxKfSwSxRDATckJ/zWVIPqmuFSlgCVOonXKwtxpTwN1omoNXUf9FGHoaM9MxMnZ2w15IS/57C4DkJPJAlPOxG4ND1JVCtSVxP5K5MV6xFqVsVvrgy56/sKfAKBQdvPbVKI/omxH9zkik6NzSSXsY0fzHd1QTbpYr8sVHLVVCDgb7VA3AdOZUSIEaesfXlSVYkw3EchIllny8q8jD3x0bOdk7FzQVwHxfcXEVeeWJxJLdHoLJJRZs2hHdCT+sImwmAY9nSEE2OyMPhMChDjSCXO7tjAfKmy3I6TxDv6oa/TbXajFwGAbtXr7yTAav86G8TJ7anCZX5Rg8wLUQZM5NTm+tL7CsdosPro8EUMDw3Y37M+N5P5/Tva6u2OvPFeIcqtJwjyYAN1HbpxEVsaK0AkiZI0y5DXwfJow2IaIkLv0djeJUZRxfWusx8xSjt9EGndEsQuEoVc5uGYhZbIs9OgHm9KHFlSm6z8iQf+O+kNdXH+N7nzD+JBy/zgYzeNgm8ao//zRWixl67VmgGTUH/03nhbyX+5GhLzyrA6+f/T6I+iHfINFXU8Hpmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199015)(36756003)(86362001)(5660300002)(38100700002)(2906002)(4326008)(8936002)(7416002)(83380400001)(41300700001)(66476007)(478600001)(6486002)(66556008)(6506007)(6512007)(8676002)(26005)(186003)(316002)(66946007)(2616005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j5U5QqlRpm/Gik3sp+z+oKUI1HHnjDZEA4OFtF3hAjU3mL9XzunDP3p9FVmz?=
 =?us-ascii?Q?dc7AYMqirmc+EwX01nM+UL6Va9Qt8dzQr/HKEZPZdyPwz1AZF8tS8qY9AV1p?=
 =?us-ascii?Q?I442Z0Df88RUPMt+VWzZkND6qan6r06X/eAu39uUHw/eVW6jQRbgjSw0SV5M?=
 =?us-ascii?Q?CYWUklPKU2UaJ/5RHBoNnUTtZFrtigudjmyEdIek0jtqqIOp5QsDafeV1vUk?=
 =?us-ascii?Q?PoPcElpHS8v8SOnMklNkkoBYkshtlC9CaGS2qb/DjLMz7hvvxz7KNCtJ4ySV?=
 =?us-ascii?Q?qxEiaV+GM5UK8w3UZRftuefpBb/dek3LIF8RgY3vjiTTnjNNE4LuLLKT8jVg?=
 =?us-ascii?Q?8VsQ/QV3NWyRV6lHrhuVPOjjjVckgokD1HVffBtuVxFGG9Gq7UBCWTOF8O7M?=
 =?us-ascii?Q?M+ayDF6MVDmKddQmxdIWpgy5tKhwPV+y0IZT+LnY8w/DkkvKUK+5I0q6gsqK?=
 =?us-ascii?Q?i14EDz7V7tpIto4QUwYasZ7e1ZCVcbMW+dVTPL8d7h/mZ23Ue3UenIO3VzjS?=
 =?us-ascii?Q?5L88Yq4eNLIdcOWE8B4znTMJu570YAx4Qmxz80zQIUYp23iBgByjNfITPJ3P?=
 =?us-ascii?Q?d/hVafLEcYXQ17b/SyDimpsDTD8ZC4zPjO5yxiy23pKXSgoYkPRBstRPUDsZ?=
 =?us-ascii?Q?K6cho2XfYlDq7338t5Wi6nSBx+D8/0ETEvAFHmxit2H3wqktgA4YYzD43azO?=
 =?us-ascii?Q?K4EMt7f5cuthU5krTGsKnTYQ3+/Lk5vaN6+gIJTXHvauTOdYpHQNBMU6k+B2?=
 =?us-ascii?Q?TGyIIMR86LrtFu2pdyjwmIV945IvAA7HmwvN7jsKjaewpK/tmzBgabRSPg0Q?=
 =?us-ascii?Q?3WZLYbyPSYwqIqUOx8yxB21fNXe6eA3hzFrorABOkoZS1jOGmgo1MCV61ulF?=
 =?us-ascii?Q?EMkwSMrtE1zoPOPcnbB1LFDJWk+TXPBMqewFDcQCvi/Ntiazm8iR6Rg2E5tz?=
 =?us-ascii?Q?omKQ42Dj6L5TGfG5QZjGbf91kV+oI8lWdBxzve+vS2uPQ+KEsLB0DtP7yPfO?=
 =?us-ascii?Q?vIGcyT/nlDXCfDYQF8obLAgsRb36HHqlttTASui5EzGFokjNVp0oj29zBYD4?=
 =?us-ascii?Q?T/LBce33RBhN39V7wgATxPS4Fc4N7vh98uz1EGDLvMRyJe9cu6gdGQdHp4ri?=
 =?us-ascii?Q?SS5mqB9MittsgVLeB9TP1R1NFA0RnvOIQdYzxS2zP2PzJ6O9teQYZzFbuxRO?=
 =?us-ascii?Q?saeqg9JxT8fcmCIpmzYJc1NQK0Czh2LALiWJ3S7feot3MQOBwrfJo3FbIGJS?=
 =?us-ascii?Q?YGGWoM3juiDkZ0F9RLR0+T7CwRuada/tWH8cRMO8hGypN7GELE75lheA9jRk?=
 =?us-ascii?Q?afV85GnnMy7uRqRodSp3LKxtlzbYY9wzpV6LrBubYD5ZV0rNorAuBK4v/76y?=
 =?us-ascii?Q?B8mlW3jc+dbAsfVkmcmM00ED40e0zr35seRfbe0iFtT+4qUOfnhWhY6JQGbl?=
 =?us-ascii?Q?Gbtl8TCYEQuXfNTjisSHSXLJcpkRQa0fkSAFa8Zo8TyMq96w9gNyOivNcOGp?=
 =?us-ascii?Q?dAmHEnmSVeGrFbvR32gtRkftbUeq7R3YF3F73v7vWIB1n+GnUTQuRCz49pDf?=
 =?us-ascii?Q?aKVxzGq7t2I113W3R3C0c+rT1iX7AMaDutlmuub9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949f3254-124b-4c17-6368-08dafdcdf107
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 05:43:38.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uIP4ouzbfWVCa0XUJTot9rM9L+PhLKwqPJg7yXDOHet2Jme+y1DQ/VxC+ZGllQMyEfpyeIVZtQ1TVWuxyBQR6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4540
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel drivers that pin pages should account these pages against
either user->locked_vm or mm->pinned_vm and fail the pinning if
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
 include/linux/mm_types.h | 87 ++++++++++++++++++++++++++++++++++++++++-
 mm/util.c                | 89 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 176 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9757067..7de2168 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1085,4 +1085,91 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+/**
+ * enum vm_account_flags - Determine how pinned/locked memory is accounted.
+ * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
+ * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
+ * @VM_ACCOUNT_USER: Accounnt locked memory to user->locked_vm.
+ *
+ * Determines which statistic pinned/locked memory is accounted
+ * against. All limits will be enforced against RLIMIT_MEMLOCK and the
+ * pins cgroup if CONFIG_CGROUP_PINS is enabled.
+ *
+ * New drivers should use VM_ACCOUNT_TASK. VM_ACCOUNT_USER is used by
+ * pre-existing drivers to maintain existing accounting against
+ * user->locked_mm rather than mm->pinned_mm.
+ *
+ * VM_ACCOUNT_BYPASS may also be specified to bypass rlimit
+ * checks. Typically this is used to cache CAP_IPC_LOCK from when a
+ * driver is first initialised. Note that this does not bypass cgroup
+ * limit checks.
+ */
+enum vm_account_flags {
+	VM_ACCOUNT_TASK = 0,
+	VM_ACCOUNT_BYPASS = 1,
+	VM_ACCOUNT_USER = 2,
+};
+
+struct vm_account {
+	struct task_struct *task;
+	union {
+		struct mm_struct *mm;
+		struct user_struct *user;
+	} a;
+	enum vm_account_flags flags;
+};
+
+/**
+ * vm_account_init - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ * @task: task to charge against.
+ * @user: user to charge against. Must be non-NULL for VM_ACCOUNT_USER.
+ * @flags: flags to use when charging to vm_account.
+ *
+ * Initialise a new uninitialiused struct vm_account. Takes references
+ * on the task/mm/user/cgroup as required although callers must ensure
+ * any references passed in remain valid for the duration of this
+ * call.
+ */
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags);
+/**
+ * vm_account_init_current - Initialise a new struct vm_account.
+ * @vm_account: pointer to uninitialised vm_account.
+ *
+ * Helper to initialise a vm_account for the common case of charging
+ * with VM_ACCOUNT_TASK against current.
+ */
+void vm_account_init_current(struct vm_account *vm_account);
+
+/**
+ * vm_account_release - Initialise a new struct vm_account.
+ * @vm_account: pointer to initialised vm_account.
+ *
+ * Drop any object references obtained by vm_account_init(). The
+ * vm_account must not be used after calling this unless reinitialised
+ * with vm_account_init().
+ */
+void vm_account_release(struct vm_account *vm_account);
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
+int vm_account_pinned(struct vm_account *vm_account, unsigned long npages);
+
+/**
+ * vm_unaccount_pinned - Uncharge pinned or locked memory to the vm_account.
+ * @vm_account: pointer to an initialised vm_account.
+ * @npages: number of pages to uncharge.
+ */
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages);
+
 #endif /* _LINUX_MM_TYPES_H */
diff --git a/mm/util.c b/mm/util.c
index b56c92f..af40b1e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -430,6 +430,95 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 }
 #endif
 
+void vm_account_init(struct vm_account *vm_account, struct task_struct *task,
+		struct user_struct *user, enum vm_account_flags flags)
+{
+	vm_account->task = get_task_struct(task);
+
+	if (flags & VM_ACCOUNT_USER) {
+		vm_account->a.user = get_uid(user);
+	} else {
+		mmgrab(task->mm);
+		vm_account->a.mm = task->mm;
+	}
+
+	vm_account->flags = flags;
+}
+EXPORT_SYMBOL_GPL(vm_account_init);
+
+void vm_account_init_current(struct vm_account *vm_account)
+{
+	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
+}
+EXPORT_SYMBOL_GPL(vm_account_init_current);
+
+void vm_account_release(struct vm_account *vm_account)
+{
+	put_task_struct(vm_account->task);
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		free_uid(vm_account->a.user);
+	else
+		mmdrop(vm_account->a.mm);
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
+		cur_pages = atomic_long_read(&vm_account->a.user->locked_vm);
+	else
+		cur_pages = atomic64_read(&vm_account->a.mm->pinned_vm);
+
+	new_pages = cur_pages + npages;
+	if (lock_limit != RLIM_INFINITY && new_pages > lock_limit)
+		return -ENOMEM;
+
+	if (vm_account->flags & VM_ACCOUNT_USER) {
+		return atomic_long_cmpxchg(&vm_account->a.user->locked_vm,
+					   cur_pages, new_pages) == cur_pages;
+	} else {
+		return atomic64_cmpxchg(&vm_account->a.mm->pinned_vm,
+					   cur_pages, new_pages) == cur_pages;
+	}
+}
+
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
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vm_account_pinned);
+
+void vm_unaccount_pinned(struct vm_account *vm_account, unsigned long npages)
+{
+	if (vm_account->flags & VM_ACCOUNT_USER)
+		atomic_long_sub(npages, &vm_account->a.user->locked_vm);
+	else
+		atomic64_sub(npages, &vm_account->a.mm->pinned_vm);
+}
+EXPORT_SYMBOL_GPL(vm_unaccount_pinned);
+
 /**
  * __account_locked_vm - account locked pages to an mm's locked_vm
  * @mm:          mm to account against
-- 
git-series 0.9.1
