Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EE1D547A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgEOPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:24:11 -0400
Received: from mail-eopbgr700119.outbound.protection.outlook.com ([40.107.70.119]:43540
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgEOPYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuZT9xaQszvCMxzm1kOCMxt39RjxZxfaXz1Pz2XkmWxkYJ+U+1jfgAA4FSI5OFMgtPSEvDwOhgdY2LJv4e5SvmSZdwHfMC+n8uuc4PAE3DZFM4IzDyWC+faun0TqnS1QakiRGZiCEs1LRB3chT5bHZin++TtAC7W08PdB93GjCoZDxd3IhuK3+oi9ytZK+w73poA59gwlHQO2Z4hqCDmNcIUgAXazVTksfkwcwyqnuDqC540JHTE4CFiuXgm1Wl92C+hENVRNVln2Nq92FwdoGaBpMnIt5Vjoev/WZs97OprO4HyFrHc8TdAWaoWidIrMfCUgc3mQJ7pZFLTkvFjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsGNsjYsI8F4KJql4yZYX+Vqvvff2TzQBu9X3M2j3GQ=;
 b=KrDIn/IRlMTZjRVkQ4+q4+mw+d+K0vZ3DF5Z7kV7NrIAZ0HWr9+r3YHK6STB+hBmegr01Mj/mFLMTq1S0eWEbv+QBl2OhsMa+0L7TKCqCJdp1FCCzqaAwzElCRolYLzqf+N4AzvpjnEVnVLlnk1jPj9jN82RRKB6rq+iHLKzfiROGnTSZNXwNBbQdhQDgMMOMg5QUGd6Ob6Xqlh+Jpkeu0uOofJjNRXI6QldPoDOs+YmLlysvrbOyRtq2hhrd/xJPyhv+mFk4Gtrfi+Vt1SNgvbeBiDxu2C4q1acVHP5a6JhyD+pCVWLL2z4M80Xivj1YaWUGX7A87jZrrnWuU09Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsGNsjYsI8F4KJql4yZYX+Vqvvff2TzQBu9X3M2j3GQ=;
 b=iaqAUjEVMMV9INxTJ3Xj15oXJ2Tr5dFVM5el7qG7ey1YtMiGvxnTkc7ctZat0LK/7MJK/GY1Mhgl6fWBRkwdM1/mX/sbvessuM36KeWxxCTGlTLJJX2HwuYKolqe4EI7t4al97FeQu25kP0WvqDaf08zkXw7NrXWAu9w1ovbvE1VASNIJkiuqJDsFlJ3iaJex4036VIbQbElJD13XACMvEd7GUVWye7K30jR5jHHRfEX51RPOrB6KkETvb73euazNOHrBbfdAsUfbXe2dkC3cq8/1hoEhK3LtPiFlgcNeSfDh/1msuI/vGK5U3goKd0ngqFkR+LoE7BY19pg73ugiA==
Received: from BN6PR11CA0046.namprd11.prod.outlook.com (2603:10b6:404:4b::32)
 by DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 15:24:01 +0000
Received: from BN7NAM10FT028.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:4b:cafe::1b) by BN6PR11CA0046.outlook.office365.com
 (2603:10b6:404:4b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend
 Transport; Fri, 15 May 2020 15:24:01 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 BN7NAM10FT028.mail.protection.outlook.com (10.13.156.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 15:24:00 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge2.garmin.com (10.60.4.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Fri, 15 May 2020 10:23:58 -0500
Received: from ola-d01c000-vm.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 15 May 2020 10:23:59 -0500
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
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-alpha@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Changli Gao <xiaosuo@gmail.com>,
        Nate Karstens <nate.karstens@garmin.com>
Subject: [PATCH v2 1/4] fs: Implement close-on-fork
Date:   Fri, 15 May 2020 10:23:18 -0500
Message-ID: <20200515152321.9280-2-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.000
X-TM-AS-Result: No-8.366000-8.000000-10
X-TMASE-MatchedRID: zU8/ga22QnsY5XJhZJs6SDCMW7zNwFaIGiQ8GIEGP38y2ckJNvUX+HzK
        3Q9zSFL7ATYOMR69+dqRXQsE2URVLPpC5SMG+P7XB8FxO/BQHsIacZilk37ECL95OdmJ178BjL9
        k66lsprSFCmd9YpPXsWn9q4aEyPwAwsZtKo32enS7qoPZRcH3U8tDHw9RrCNbx5B+7qLBJ+xAHO
        g8qEtqyI+pAn19BHXOF/tIpAzU+Bdk5pVuCWjzQc36paW7ZnFor4ukWaaTegCfuM4lD6uC8TECc
        rZ55BeGF9v+Dr8BUC0xFzy2mxela8ctxF7vDKgQiVJZi91I9JjgXnxE81iysQcB7juZygIJyVBW
        8fUk7pM1wU4Zygz0SnW00rbMu3zpYwDOL7t3RyEPe5gzF3TVt1OMvMY8acYWSg8ufp5n3T4n4FP
        RjzsKxkuD8yJMtBEu7I0yDuih8283KXWd30Ii3RRFJJyf5BJe3QfwsVk0UbtuRXh7bFKB7k/MEt
        SMvTDCLLLAiOOemOylwObsQibNC/NFVcbL+CYQsBTJSD2iAW0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.366000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(376002)(396003)(346002)(39860400002)(136003)(46966005)(8936002)(54906003)(107886003)(8676002)(316002)(7416002)(5660300002)(110136005)(44832011)(2616005)(186003)(26005)(4326008)(70586007)(2906002)(336012)(356005)(70206006)(6666004)(86362001)(36756003)(478600001)(47076004)(82310400002)(7696005)(426003)(7636003)(82740400003)(1076003)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 067c2890-a865-47dc-8f3b-08d7f8e3fe64
X-MS-TrafficTypeDiagnostic: DM6PR04MB4154:
X-Microsoft-Antispam-PRVS: <DM6PR04MB41546728BDD013066DC28B0A9CBD0@DM6PR04MB4154.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iAS3Sor/+udiXNczVDCj21/aQvEvRwLXCCH+me6ncNHBIFwrfxz2RnIVbkKs9Q2LIHgQdxwbTMlmyP252bqhGZ+vrD6DjnbxwaEVx9WuQQRxfFVx+CdkxAVT3Oe9u0Z2cDKgqVQlYVmzjbSGMYbTt8lKiKzxbFjWR7lOhc6MQQU2BgbQB0RG7GdA9gHU6HhRZCaaeQ41Lodzx4QfUCEBMCoITQK60g2eS2ASZ1kbj5TgSJhXlSXzuviL+pCl23NRNXjCGcN1+kb2rlTfhAYcRvaeiUGb7tG7VRiMAFI6AqKV96iBB2dswyosrI3k/CgIEhlgITy2qa098gS1HBoRw18IwJg6hJlCDTuAwwGnqDPJNxa7JCdRdFY/lqc8xMunKlqpFMHyiXh56Rckm0UJlUg5Kkid7NW7r+wFlYSqRD4cIZakVQj8/raxSEWIvxYVeU+oMFks7YFJ6lPFb6EgUtP8HWupkLDlU1ui1lNWSEanr3e3vgKsSeYEPNLGGuX02kmEopRfG9VQthJdxWnzmjko2i1E+/CWarOcP9je/c4=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:24:00.4392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 067c2890-a865-47dc-8f3b-08d7f8e3fe64
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
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

If clone(2) is used to create a child process and the CLONE_FILES
flag is set, then both processes will share the table of file
descriptors and the state of the close-on-fork flag for any
individual file descriptor. If unshare(2) is later used to stop
sharing the file descriptor table, then any file descriptor with
the close-on-fork flag set will be closed in the process that
calls unshare(2).

execve(2) also causes the file descriptor table to be unshared,
so any file descriptor with the close-on-fork flag set will be
closed in the process that calls execve(2).

Co-developed-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
---
 fs/fcntl.c                             |  4 +-
 fs/file.c                              | 64 ++++++++++++++++++++++++--
 include/linux/fdtable.h                |  7 +++
 include/linux/file.h                   |  2 +
 include/uapi/asm-generic/fcntl.h       |  5 +-
 tools/include/uapi/asm-generic/fcntl.h |  5 +-
 6 files changed, 77 insertions(+), 10 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 2e4c0fa2074b..913b0cb70804 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -334,11 +334,11 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		err = f_dupfd(arg, filp, O_CLOEXEC);
 		break;
 	case F_GETFD:
-		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
+		err = f_getfd(fd);
 		break;
 	case F_SETFD:
 		err = 0;
-		set_close_on_exec(fd, arg & FD_CLOEXEC);
+		f_setfd(fd, arg);
 		break;
 	case F_GETFL:
 		err = filp->f_flags;
diff --git a/fs/file.c b/fs/file.c
index c8a4e4c86e55..81194349e980 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -47,7 +47,7 @@ static void free_fdtable_rcu(struct rcu_head *rcu)
  * spinlock held for write.
  */
 static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
-			    unsigned int count)
+			    unsigned int count, bool copy_cof)
 {
 	unsigned int cpy, set;
 
@@ -58,6 +58,13 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
 	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
 	memset((char *)nfdt->close_on_exec + cpy, 0, set);
 
+	if (copy_cof) {
+		memcpy(nfdt->close_on_fork, ofdt->close_on_fork, cpy);
+		memset((char *)nfdt->close_on_fork + cpy, 0, set);
+	} else {
+		memset((char *)nfdt->close_on_fork, 0, cpy + set);
+	}
+
 	cpy = BITBIT_SIZE(count);
 	set = BITBIT_SIZE(nfdt->max_fds) - cpy;
 	memcpy(nfdt->full_fds_bits, ofdt->full_fds_bits, cpy);
@@ -79,7 +86,7 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 	memcpy(nfdt->fd, ofdt->fd, cpy);
 	memset((char *)nfdt->fd + cpy, 0, set);
 
-	copy_fd_bitmaps(nfdt, ofdt, ofdt->max_fds);
+	copy_fd_bitmaps(nfdt, ofdt, ofdt->max_fds, true);
 }
 
 static struct fdtable * alloc_fdtable(unsigned int nr)
@@ -118,7 +125,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->fd = data;
 
 	data = kvmalloc(max_t(size_t,
-				 2 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES),
+				 3 * nr / BITS_PER_BYTE + BITBIT_SIZE(nr), L1_CACHE_BYTES),
 				 GFP_KERNEL_ACCOUNT);
 	if (!data)
 		goto out_arr;
@@ -126,6 +133,8 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = data;
 	data += nr / BITS_PER_BYTE;
+	fdt->close_on_fork = data;
+	data += nr / BITS_PER_BYTE;
 	fdt->full_fds_bits = data;
 
 	return fdt;
@@ -236,6 +245,17 @@ static inline void __clear_close_on_exec(unsigned int fd, struct fdtable *fdt)
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
@@ -290,6 +310,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
 	new_fdt->close_on_exec = newf->close_on_exec_init;
+	new_fdt->close_on_fork = newf->close_on_fork_init;
 	new_fdt->open_fds = newf->open_fds_init;
 	new_fdt->full_fds_bits = newf->full_fds_bits_init;
 	new_fdt->fd = &newf->fd_array[0];
@@ -330,13 +351,17 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 		open_files = count_open_files(old_fdt);
 	}
 
-	copy_fd_bitmaps(new_fdt, old_fdt, open_files);
+	copy_fd_bitmaps(new_fdt, old_fdt, open_files, false);
 
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
+
+		if (close_on_fork(open_files - i, old_fdt))
+			f = NULL;
+
 		if (f) {
 			get_file(f);
 		} else {
@@ -453,6 +478,7 @@ struct files_struct init_files = {
 		.max_fds	= NR_OPEN_DEFAULT,
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= init_files.close_on_exec_init,
+		.close_on_fork	= init_files.close_on_fork_init,
 		.open_fds	= init_files.open_fds_init,
 		.full_fds_bits	= init_files.full_fds_bits_init,
 	},
@@ -840,6 +866,36 @@ void __f_unlock_pos(struct file *f)
  * file count (done either by fdget() or by fork()).
  */
 
+void f_setfd(unsigned int fd, int flags)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (flags & FD_CLOEXEC)
+		__set_close_on_exec(fd, fdt);
+	else
+		__clear_close_on_exec(fd, fdt);
+	if (flags & FD_CLOFORK)
+		__set_close_on_fork(fd, fdt);
+	else
+		__clear_close_on_fork(fd, fdt);
+	spin_unlock(&files->file_lock);
+}
+
+int f_getfd(unsigned int fd)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	int flags;
+	rcu_read_lock();
+	fdt = files_fdtable(files);
+	flags = (close_on_exec(fd, fdt) ? FD_CLOEXEC : 0) |
+	        (close_on_fork(fd, fdt) ? FD_CLOFORK : 0);
+	rcu_read_unlock();
+	return flags;
+}
+
 void set_close_on_exec(unsigned int fd, int flag)
 {
 	struct files_struct *files = current->files;
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
index 142d102f285e..0ee15ee24010 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -83,6 +83,8 @@ static inline void fdput_pos(struct fd f)
 
 extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
+extern int f_getfd(unsigned int fd);
+extern void f_setfd(unsigned int fd, int flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
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

