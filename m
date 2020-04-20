Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38081B02A9
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDTHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:16:29 -0400
Received: from mail-eopbgr680105.outbound.protection.outlook.com ([40.107.68.105]:20708
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbgDTHQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 03:16:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaBuw2ak3rNv7v9bAUrwvrLhsz0014+m99ijR/1xTVtTEqfYmG0XqAyva+hSWxcp66RZI2gDGBH2KG0sTiRJwTxObeRothHyg85izPxh49qAlYOHpvYx6kVYIZPI9VUZs7/lR3DCF5FCliM08EgZAvMI8NbpdNSvgicEPLVM/lVezlDTIixUG1BPb8F41QDahTkg+jgHW9mx1bD7yuv31ZYussC4djuQmvvL1SbUKjYzrJUNHPl8pelF4Ge2edXh0eQCeYHyZPrGUbFCZ3lq3BHMz2A3NkfJ9ZdhMhhHReydxJ6spuwaFcKi4UgqLpT+5szQZkWJeaFgFhdOM8uW5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dAWobLvVWrE8yxfuLtMfva9SmJ+ZqWnqRTNKx+Qvng=;
 b=FPJR4MQTh4yu+n24iGOoJOwamZnCFxTL96+yQgaYnBHigSy+ZdyLNx1O44UAV0yHe0kpPHTdvAopszfnzv20QEQnd1WGCoMPlFpwFhmc9Sw9eViTb25KheSum1rPWFN2y7Kd4ia+BPKwxC08WFf9juhC2lTD1Cj+pA4MOs5Wt1ytdXr+Pps3M1jIUViA4O78V35kwR3hpcH4990//m8UwTQ/jqd0PPAIWXHeNcAUiaxM+Qa2+6mM+mgobHTZSX4kCdJYk4TYTzm3Zt19xKemcY92HcABJAe33aMhhmLJsd1Y51rVoxG6Z6kYfLiuwLMjaYfPYnmPk/ntRbr+VNEXgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=20)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dAWobLvVWrE8yxfuLtMfva9SmJ+ZqWnqRTNKx+Qvng=;
 b=jHgtKMair2wI2r01/1ks3F4CAd1GOOAoZVOgmiRWczyN/0EKuQmLE2DX0hmY3wfqKGLzb5qQaf28yhmgyOVxy3M9qudrpDwTdlznRq5TcmRPUGVsJXeGERzREdO2xHDUxMwgWtaUvBT0rzEayjJ07NurmSouSuyRI7v7PxHV+tXsYY57P9EPvZUzABkXEaW5JgVs7ckRtdedkypOUMbKRr4tCZvjs5G2WVNAFSFzni2zMkB6K6KvhyTzmS6+n38CjzIjWk6n+nBGAxTGisS+VqJkVSvW7sqEPNPySCxjnBvMUL0W9NhG6/KulzGaS8hiXh4o7XrEHXUjJBd8eKS4DA==
Received: from BN6PR06CA0018.namprd06.prod.outlook.com (2603:10b6:404:10b::28)
 by MWHPR04MB1102.namprd04.prod.outlook.com (2603:10b6:301:44::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:16:18 +0000
Received: from BN7NAM10FT049.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:10b:cafe::5) by BN6PR06CA0018.outlook.office365.com
 (2603:10b6:404:10b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Mon, 20 Apr 2020 07:16:17 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT049.mail.protection.outlook.com (10.13.157.3) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 07:16:17 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge4.garmin.com (10.60.4.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Mon, 20 Apr 2020 02:16:15 -0500
Received: from ola-d01c000-vm.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 20 Apr 2020 02:16:15 -0500
From:   Nate Karstens <nate.karstens@garmin.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-alpha@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Changli Gao <xiaosuo@gmail.com>,
        Nate Karstens <nate.karstens@garmin.com>
Subject: [PATCH 1/4] fs: Implement close-on-fork
Date:   Mon, 20 Apr 2020 02:15:45 -0500
Message-ID: <20200420071548.62112-2-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420071548.62112-1-nate.karstens@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.005
X-TM-AS-Result: No-8.450200-8.000000-10
X-TMASE-MatchedRID: BPEQoO09kToY5XJhZJs6SDCMW7zNwFaIGiQ8GIEGP38y2ckJNvUX+HzK
        3Q9zSFL7ATYOMR69+dqRXQsE2URVLPpC5SMG+P7XB8FxO/BQHsIacZilk37ECL95OdmJ178B3A8
        rIQHSOzD6Pp/0inv5dXDlPghqPnfyYlldA0POS1IaPMGCcVm9DgKflB9+9kWVlaO5BvPDtzcxAn
        K2eeQXhhfb/g6/AVAtMRc8tpsXpWvHLcRe7wyoEIlSWYvdSPSY4F58RPNYsrEHAe47mcoCCclQV
        vH1JO6TNcFOGcoM9ErGBkuRwWcFOGi8YU2giSiPutvHF25zoU8r9gVlOIN/6mcBMv0Fvtzl0dsY
        UxvcQZcuI35yUPSOFqkquW+P/OwXo8WMkQWv6iXBcIE78YqRWvcUt5lc1lLgoGRyAacnhaaAxBo
        6LHbCgebkD1AsfOCTGhoVV6XcNT7hO5URK+drpH7cGd19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.450200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.005
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(396003)(39860400002)(346002)(136003)(376002)(46966005)(110136005)(246002)(8676002)(7696005)(186003)(54906003)(70586007)(44832011)(36756003)(2616005)(70206006)(8936002)(5660300002)(107886003)(26005)(2906002)(86362001)(356005)(7416002)(6666004)(47076004)(82740400003)(7636003)(336012)(426003)(1076003)(316002)(4326008)(478600001)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6563c99-e5b1-49fc-6a0b-08d7e4fab7cc
X-MS-TrafficTypeDiagnostic: MWHPR04MB1102:
X-Microsoft-Antispam-PRVS: <MWHPR04MB11026E7775EF9345F78969939CD40@MWHPR04MB1102.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 03793408BA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9cmivBsdETlNUdnyu40HEPW/ndezmSP0HeTdSRoCicfy4opYVORQq3X2z1Y97aD64c/lCl/sFQDIqXUfWmUSUAZbMSSrIbGa1kbgZcMZg+sNM3ghYkSJv9mZHZFZJ52D1NugxvyPQ8TocABi6leyQHhrCRBV2qhzMVXLL/R/PPZMMargyGafiRu4iyNPdnkM6K+MWW+sPzs8vEpeWfvFQYt+mFPP6R6aQtALgjPIyZPZyeduHBIBCoRv0s2UHR4toXpNjx2qPXP79H/IQ492kmIsQblhHC9O+luS+zHIMPSDHwWRTIu/vgCUajsrXZbjWFDCABxHzwT+RS2zORkt3WWXbenUEkU1mc44z4i5wORwKpkomJIPy9GexahHfqQUOhT/ro9YHg7/XOD2Q/P00nMRha2Oy1jOTTCECuXXC5kAgHkqtd3pOHkt9YfYFJ2N2hnQpNOSR+i1zIDTUxnG5DPhQyiA/jen/uGnCWSumwSMY65ujShgmLe8zqI0sX0kb/cT8QUbfHX8WtK6Q427YCxCL08paxh7qOP92cG8sc=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 07:16:17.1749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6563c99-e5b1-49fc-6a0b-08d7e4fab7cc
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The close-on-fork flag causes the file descriptor to be closed
atomically in the child process before the child process returns
from fork(). Implement this feature and provide a method to
get/set the close-on-fork flag using fcntl(2).

This functionality was approved by the Austin Common Standards
Revision Group for inclusion in the next revision of the POSIX
standard (see issue 1318 in the Austin Group Defect Tracker).

Co-developed-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
---
 fs/fcntl.c                             |  2 ++
 fs/file.c                              | 50 +++++++++++++++++++++++++-
 include/linux/fdtable.h                |  7 ++++
 include/linux/file.h                   |  2 ++
 include/uapi/asm-generic/fcntl.h       |  5 +--
 tools/include/uapi/asm-generic/fcntl.h |  5 +--
 6 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 2e4c0fa2074b..23964abf4a1a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -335,10 +335,12 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 	case F_GETFD:
 		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
+		err |= get_close_on_fork(fd) ? FD_CLOFORK : 0;
 		break;
 	case F_SETFD:
 		err = 0;
 		set_close_on_exec(fd, arg & FD_CLOEXEC);
+		set_close_on_fork(fd, arg & FD_CLOFORK);
 		break;
 	case F_GETFL:
 		err = filp->f_flags;
diff --git a/fs/file.c b/fs/file.c
index c8a4e4c86e55..de7260ba718d 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -57,6 +57,8 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
 	memset((char *)nfdt->open_fds + cpy, 0, set);
 	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
 	memset((char *)nfdt->close_on_exec + cpy, 0, set);
+	memcpy(nfdt->close_on_fork, ofdt->close_on_fork, cpy);
+	memset((char *)nfdt->close_on_fork + cpy, 0, set);
 
 	cpy = BITBIT_SIZE(count);
 	set = BITBIT_SIZE(nfdt->max_fds) - cpy;
@@ -118,7 +120,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->fd = data;
 
 	data = kvmalloc(max_t(size_t,
-				 2 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES),
+				 3 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES),
 				 GFP_KERNEL_ACCOUNT);
 	if (!data)
 		goto out_arr;
@@ -126,6 +128,8 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = data;
 	data += nr / BITS_PER_BYTE;
+	fdt->close_on_fork = data;
+	data += nr / BITS_PER_BYTE;
 	fdt->full_fds_bits = data;
 
 	return fdt;
@@ -236,6 +240,17 @@ static inline void __clear_close_on_exec(unsigned int fd, struct fdtable *fdt)
 		__clear_bit(fd, fdt->close_on_exec);
 }
 
+static inline void __set_close_on_fork(unsigned int fd, struct fdtable *fdt)
+{
+	__set_bit(fd, fdt->close_on_fork);
+}
+
+static inline void __clear_close_on_fork(unsigned int fd, struct fdtable *fdt)
+{
+	if (test_bit(fd, fdt->close_on_fork))
+		__clear_bit(fd, fdt->close_on_fork);
+}
+
 static inline void __set_open_fd(unsigned int fd, struct fdtable *fdt)
 {
 	__set_bit(fd, fdt->open_fds);
@@ -290,6 +305,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
 	new_fdt->close_on_exec = newf->close_on_exec_init;
+	new_fdt->close_on_fork = newf->close_on_fork_init;
 	new_fdt->open_fds = newf->open_fds_init;
 	new_fdt->full_fds_bits = newf->full_fds_bits_init;
 	new_fdt->fd = &newf->fd_array[0];
@@ -337,6 +353,12 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
+
+		if (test_bit(open_files - i, new_fdt->close_on_fork)) {
+			__clear_bit(open_files - i, new_fdt->open_fds);
+			f = NULL;
+		}
+
 		if (f) {
 			get_file(f);
 		} else {
@@ -453,6 +475,7 @@ struct files_struct init_files = {
 		.max_fds	= NR_OPEN_DEFAULT,
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= init_files.close_on_exec_init,
+		.close_on_fork	= init_files.close_on_fork_init,
 		.open_fds	= init_files.open_fds_init,
 		.full_fds_bits	= init_files.full_fds_bits_init,
 	},
@@ -865,6 +888,31 @@ bool get_close_on_exec(unsigned int fd)
 	return res;
 }
 
+void set_close_on_fork(unsigned int fd, int flag)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (flag)
+		__set_close_on_fork(fd, fdt);
+	else
+		__clear_close_on_fork(fd, fdt);
+	spin_unlock(&files->file_lock);
+}
+
+bool get_close_on_fork(unsigned int fd)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	bool res;
+	rcu_read_lock();
+	fdt = files_fdtable(files);
+	res = close_on_fork(fd, fdt);
+	rcu_read_unlock();
+	return res;
+}
+
 static int do_dup2(struct files_struct *files,
 	struct file *file, unsigned fd, unsigned flags)
 __releases(&files->file_lock)
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index f07c55ea0c22..61c551947fa3 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -27,6 +27,7 @@ struct fdtable {
 	unsigned int max_fds;
 	struct file __rcu **fd;      /* current fd array */
 	unsigned long *close_on_exec;
+	unsigned long *close_on_fork;
 	unsigned long *open_fds;
 	unsigned long *full_fds_bits;
 	struct rcu_head rcu;
@@ -37,6 +38,11 @@ static inline bool close_on_exec(unsigned int fd, const struct fdtable *fdt)
 	return test_bit(fd, fdt->close_on_exec);
 }
 
+static inline bool close_on_fork(unsigned int fd, const struct fdtable *fdt)
+{
+	return test_bit(fd, fdt->close_on_fork);
+}
+
 static inline bool fd_is_open(unsigned int fd, const struct fdtable *fdt)
 {
 	return test_bit(fd, fdt->open_fds);
@@ -61,6 +67,7 @@ struct files_struct {
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	unsigned int next_fd;
 	unsigned long close_on_exec_init[1];
+	unsigned long close_on_fork_init[1];
 	unsigned long open_fds_init[1];
 	unsigned long full_fds_bits_init[1];
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
diff --git a/include/linux/file.h b/include/linux/file.h
index 142d102f285e..86fbb36b438b 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -85,6 +85,8 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
+extern void set_close_on_fork(unsigned int fd, int flag);
+extern bool get_close_on_fork(unsigned int fd);
 extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 9dc0bf0c5a6e..0cb7199a7743 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -98,8 +98,8 @@
 #endif
 
 #define F_DUPFD		0	/* dup */
-#define F_GETFD		1	/* get close_on_exec */
-#define F_SETFD		2	/* set/clear close_on_exec */
+#define F_GETFD		1	/* get close_on_exec & close_on_fork */
+#define F_SETFD		2	/* set/clear close_on_exec & close_on_fork */
 #define F_GETFL		3	/* get file->f_flags */
 #define F_SETFL		4	/* set file->f_flags */
 #ifndef F_GETLK
@@ -160,6 +160,7 @@ struct f_owner_ex {
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
+#define FD_CLOFORK	2
 
 /* for posix fcntl() and lockf() */
 #ifndef F_RDLCK
diff --git a/tools/include/uapi/asm-generic/fcntl.h b/tools/include/uapi/asm-generic/fcntl.h
index ac190958c981..e04a00fecb4a 100644
--- a/tools/include/uapi/asm-generic/fcntl.h
+++ b/tools/include/uapi/asm-generic/fcntl.h
@@ -97,8 +97,8 @@
 #endif
 
 #define F_DUPFD		0	/* dup */
-#define F_GETFD		1	/* get close_on_exec */
-#define F_SETFD		2	/* set/clear close_on_exec */
+#define F_GETFD		1	/* get close_on_exec & close_on_fork */
+#define F_SETFD		2	/* set/clear close_on_exec & close_on_fork */
 #define F_GETFL		3	/* get file->f_flags */
 #define F_SETFL		4	/* set file->f_flags */
 #ifndef F_GETLK
@@ -159,6 +159,7 @@ struct f_owner_ex {
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
+#define FD_CLOFORK	2
 
 /* for posix fcntl() and lockf() */
 #ifndef F_RDLCK
-- 
2.26.1

