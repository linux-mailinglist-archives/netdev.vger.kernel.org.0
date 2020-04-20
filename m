Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC21B02A7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgDTHQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:16:28 -0400
Received: from mail-co1nam11on2115.outbound.protection.outlook.com ([40.107.220.115]:9664
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726147AbgDTHQX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 03:16:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYRtlngSVn8ezUrM5WryFSIT6hZhPdfuuiX/ktGIGMx7XpmXczJKfli6ORG7i4x6yuLtekpW7MGXa8P1qF+DtqhfGm6qks5k+ugeFrRZZ2S24yd19+uNFRayok+NybW+nLCxM2nn3Vi0m54kFpNDx7ab1w+4NLfXoZg/CRrWFdmEHyIjbYYUsKS6yD1XwTaateGi1f2iyhLX6BL/PHN6EDQAjl6wzTrHo0e0uEjvq7HJJ3gaqnc35IQXnKCxppxWYGZ6xm/ENrCrhAM0SMH7pMRkwd+951J1ooJ6ej7PnAP4EVxVW7vRFHovW3N9TGvm/ZVkqxOL4uD4cC8Rh9eINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxGBEzQn5cuKkX7mLr+s7bTq6EpNG8Hh4TggrLFv1+M=;
 b=ITod/aAs8rFqpygPAAt9e9jX6rmKrGPNVLBWJp9gfvDBPlzBqU7oAOxcnJCQqcP51X9GcEQ6o80LGuMovOlYrlj/sPJi91Y/iY6w3I6YcgZCwFd7Oks5dXPesk++NEgcGsStsBioUCDnnqn1DG7+68CRgi9w8MiMJmVIJK4pmsNgVfkuVjN/seRnYW0CWZeE9WVktKDB9/Ia/5Z3VlJWUkWhHzkWlkG/V+8EXnc/pyyBf0GWD4RfT4Ey9YBJ7lC8qCytatKAoS1QzVbsEF/gPKQwmFSwuSOP0lTEwHjzpq8beJTmSDGaSr5gOxb8Nf7e5+HZpOX0a7phjjYM5Wg8Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=20)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxGBEzQn5cuKkX7mLr+s7bTq6EpNG8Hh4TggrLFv1+M=;
 b=k9EENX3dnEjzvCQU8w4pSxPqAnh9dg+h4xshaAGwTaL/iWcbiLyRlRo+pkVA7zbL2rX0mSiyFCEe4qiuTVomoc5VOO8km8+tLm8+3igRz6uU1gW/eb8UuHYsnhZf6gxYvHJ9jAGR+L1cHBnVmU+auSJwC1SN1D9oLIcAZB7W3o2a5eR8Do39A8XChO6kb+8AHZjksGailV8OhAJsQEWQjLtLMIEa3UOZvL/Di7H5I6u5Ecnhy5qkg2EAjWOzxcEL1CqI1ldVKrSQmXb7nLB5+HlYpfHBRMbV6KgZAZwxgHU2ZMulaZRut8/+4xJYLirPUlp1BmhKMRJeP3EbfB6M4g==
Received: from MWHPR10CA0052.namprd10.prod.outlook.com (2603:10b6:300:2c::14)
 by BN3PR04MB2242.namprd04.prod.outlook.com (2a01:111:e400:7bb8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:16:18 +0000
Received: from MW2NAM10FT022.eop-nam10.prod.protection.outlook.com
 (2603:10b6:300:2c:cafe::d2) by MWHPR10CA0052.outlook.office365.com
 (2603:10b6:300:2c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Mon, 20 Apr 2020 07:16:18 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT022.mail.protection.outlook.com (10.13.155.101) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 07:16:17 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Mon, 20 Apr 2020 02:16:16 -0500
Received: from ola-d01c000-vm.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 20 Apr 2020 02:16:16 -0500
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
Subject: [PATCH 2/4] fs: Add O_CLOFORK flag for open(2) and dup3(2)
Date:   Mon, 20 Apr 2020 02:15:46 -0500
Message-ID: <20200420071548.62112-3-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420071548.62112-1-nate.karstens@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.005
X-TM-AS-Result: No-9.399500-8.000000-10
X-TMASE-MatchedRID: 9FKQq2Ubc8b1HKFnt7/e8tKhw1CGAxrIlHLUcNM85doAZTQQTIkkc93N
        NJQDizxeGDXccV5w1UP1q35E6lDQr2+4O3SBmLlW9u1rQ4BgXPIBmf/gD11vZAaYevV4zG3ZQBz
        oPKhLashZ3hT8koiLOx4fZrHGL7yoEVfyWRZcVuVZMZ6MZ0H1UhACJh4BWAPePTublrdV/SPAgD
        8QYQcBsjk4XrS69X2i0/NbBMSkGddoWWTS0CIqzlgUnyU84hcfquFC73XPA2ffc2Xd6VJ+ym9Ih
        irTclUbTnj5SlaoRXUaH2v8HV+LCsBvT9NZRcVl4vM1YF6AJbbCCfuIMF6xLcK21zBg2KlfFAQv
        QYa7pIOjr4CAOuztuw1Dkx0IaMzoPwR95aMFg0Nbic5W0OLHgw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.399500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.005
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(346002)(396003)(39860400002)(136003)(376002)(46966005)(2906002)(86362001)(5660300002)(4326008)(82740400003)(44832011)(1076003)(478600001)(186003)(36756003)(26005)(356005)(7636003)(426003)(2616005)(336012)(54906003)(70206006)(70586007)(6666004)(47076004)(7696005)(110136005)(8676002)(7416002)(246002)(8936002)(107886003)(316002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2505f673-7eb2-4b32-c190-08d7e4fab80a
X-MS-TrafficTypeDiagnostic: BN3PR04MB2242:
X-Microsoft-Antispam-PRVS: <BN3PR04MB224227376F5CE68D10F125D39CD40@BN3PR04MB2242.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 03793408BA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Znyy5NvGD3VCN/zcDlmuOhWEz7295J1Hw0NUT2P895wP7PAC7bn//oggDs3kB6EhF4+qSUr8Fzy65VyDmgNKUye7cBwdSw9CG97N5CcUMTiUqQFM1anq6SMNhcNM6+rQCgsF1YNcXJDKgNXpPfwHAShZwguNIp0bIfqdhRWER1ZQwpwMLzcsqeaOH88axEJ6L2LwN05E0RZaCWsa1WmMPRT0AZSzJfwaKsRHDpvX0fA9qCeu5UPMUWrGpGHy3pf/l7ntGTt7EHTjYBiKpUI32rw1v2Uj/351M9agkiRwasVbMoh81wX3RKl99QXLgsKLUVW3ZFnonykTjzosBkF13qSqjJ2yJfmOCYc8mbhWv8aAKXhmmTwqy6KNyh3DtRs56Gaj92+MsBvYsDpS5SJcz4zt0Y/WwG86R6sEzi0fFbEriSQFV9IHAvH4SdlR9lmQ0ieBewan2mQidqglo7SOaeKSQkOOcIAazw3TCWOrUHxG+Rwk+XhqRQYEPl2U2JSE51VYLyO0ARotpwYryzlfw==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 07:16:17.5554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2505f673-7eb2-4b32-c190-08d7e4fab80a
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR04MB2242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the O_CLOFORK flag to open(2) and dup3(2) to automatically
set the close-on-fork flag in the new file descriptor, saving
a separate call to fcntl(2).

Co-developed-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
---
 arch/alpha/include/uapi/asm/fcntl.h    |  2 ++
 arch/parisc/include/uapi/asm/fcntl.h   | 39 +++++++++++++-------------
 arch/sparc/include/uapi/asm/fcntl.h    |  1 +
 fs/fcntl.c                             |  2 +-
 fs/file.c                              | 10 ++++++-
 include/linux/fcntl.h                  |  2 +-
 include/uapi/asm-generic/fcntl.h       |  4 +++
 tools/include/uapi/asm-generic/fcntl.h |  4 +++
 8 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/fcntl.h b/arch/alpha/include/uapi/asm/fcntl.h
index 50bdc8e8a271..fbab69b15f7f 100644
--- a/arch/alpha/include/uapi/asm/fcntl.h
+++ b/arch/alpha/include/uapi/asm/fcntl.h
@@ -35,6 +35,8 @@
 #define O_PATH		040000000
 #define __O_TMPFILE	0100000000
 
+#define O_CLOFORK	0200000000 /* set close_on_fork */
+
 #define F_GETLK		7
 #define F_SETLK		8
 #define F_SETLKW	9
diff --git a/arch/parisc/include/uapi/asm/fcntl.h b/arch/parisc/include/uapi/asm/fcntl.h
index 03ce20e5ad7d..8f5989e75b05 100644
--- a/arch/parisc/include/uapi/asm/fcntl.h
+++ b/arch/parisc/include/uapi/asm/fcntl.h
@@ -2,26 +2,27 @@
 #ifndef _PARISC_FCNTL_H
 #define _PARISC_FCNTL_H
 
-#define O_APPEND	000000010
-#define O_BLKSEEK	000000100 /* HPUX only */
-#define O_CREAT		000000400 /* not fcntl */
-#define O_EXCL		000002000 /* not fcntl */
-#define O_LARGEFILE	000004000
-#define __O_SYNC	000100000
+#define O_APPEND	0000000010
+#define O_BLKSEEK	0000000100 /* HPUX only */
+#define O_CREAT		0000000400 /* not fcntl */
+#define O_EXCL		0000002000 /* not fcntl */
+#define O_LARGEFILE	0000004000
+#define __O_SYNC	0000100000
 #define O_SYNC		(__O_SYNC|O_DSYNC)
-#define O_NONBLOCK	000200004 /* HPUX has separate NDELAY & NONBLOCK */
-#define O_NOCTTY	000400000 /* not fcntl */
-#define O_DSYNC		001000000 /* HPUX only */
-#define O_RSYNC		002000000 /* HPUX only */
-#define O_NOATIME	004000000
-#define O_CLOEXEC	010000000 /* set close_on_exec */
-
-#define O_DIRECTORY	000010000 /* must be a directory */
-#define O_NOFOLLOW	000000200 /* don't follow links */
-#define O_INVISIBLE	004000000 /* invisible I/O, for DMAPI/XDSM */
-
-#define O_PATH		020000000
-#define __O_TMPFILE	040000000
+#define O_NONBLOCK	0000200004 /* HPUX has separate NDELAY & NONBLOCK */
+#define O_NOCTTY	0000400000 /* not fcntl */
+#define O_DSYNC		0001000000 /* HPUX only */
+#define O_RSYNC		0002000000 /* HPUX only */
+#define O_NOATIME	0004000000
+#define O_CLOEXEC	0010000000 /* set close_on_exec */
+
+#define O_DIRECTORY	0000010000 /* must be a directory */
+#define O_NOFOLLOW	0000000200 /* don't follow links */
+#define O_INVISIBLE	0004000000 /* invisible I/O, for DMAPI/XDSM */
+
+#define O_PATH		0020000000
+#define __O_TMPFILE	0040000000
+#define O_CLOFORK	0100000000
 
 #define F_GETLK64	8
 #define F_SETLK64	9
diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/asm/fcntl.h
index 67dae75e5274..d631ea13bac3 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -37,6 +37,7 @@
 
 #define O_PATH		0x1000000
 #define __O_TMPFILE	0x2000000
+#define O_CLOFORK	0x4000000
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 23964abf4a1a..b59b27c3a338 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1035,7 +1035,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/file.c b/fs/file.c
index de7260ba718d..95774b7962d1 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -544,6 +544,10 @@ int __alloc_fd(struct files_struct *files,
 		__set_close_on_exec(fd, fdt);
 	else
 		__clear_close_on_exec(fd, fdt);
+	if (flags & O_CLOFORK)
+		__set_close_on_fork(fd, fdt);
+	else
+		__clear_close_on_fork(fd, fdt);
 	error = fd;
 #if 1
 	/* Sanity check */
@@ -945,6 +949,10 @@ __releases(&files->file_lock)
 		__set_close_on_exec(fd, fdt);
 	else
 		__clear_close_on_exec(fd, fdt);
+	if (flags & O_CLOFORK)
+		__set_close_on_fork(fd, fdt);
+	else
+		__clear_close_on_fork(fd, fdt);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
@@ -985,7 +993,7 @@ static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 	struct file *file;
 	struct files_struct *files = current->files;
 
-	if ((flags & ~O_CLOEXEC) != 0)
+	if ((flags & ~(O_CLOEXEC | O_CLOFORK)) != 0)
 		return -EINVAL;
 
 	if (unlikely(oldfd == newfd))
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 7bcdcf4f6ab2..cd4c625647db 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -10,7 +10,7 @@
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
-	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_CLOFORK)
 
 /* List of all valid flags for the how->upgrade_mask argument: */
 #define VALID_UPGRADE_FLAGS \
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 0cb7199a7743..165a0736a3aa 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -89,6 +89,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_CLOFORK
+#define O_CLOFORK	040000000	/* set close_on_fork */
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
diff --git a/tools/include/uapi/asm-generic/fcntl.h b/tools/include/uapi/asm-generic/fcntl.h
index e04a00fecb4a..69d8a000ec65 100644
--- a/tools/include/uapi/asm-generic/fcntl.h
+++ b/tools/include/uapi/asm-generic/fcntl.h
@@ -88,6 +88,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_CLOFORK
+#define O_CLOFORK	040000000	/* set close_on_fork */
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)
-- 
2.26.1

