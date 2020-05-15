Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57E61D5463
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgEOPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:24:16 -0400
Received: from mail-dm6nam12on2130.outbound.protection.outlook.com ([40.107.243.130]:13665
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbgEOPYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpCzqUyVeV2MvPjtPnTHWxXpInR2ZxrpN3w8YrKdU8ADXrHViGAST2BvR5SfOKL7FhzJX92pwRt/pur2ET0XZLLUtFHL0Wjj1UaTc5oUOVK9/RQyVc7qa9kHy8V6trBt7vQ8lKwPwsIm2Y1pAr5Qhp51Vz0wEdbRlhyubWccjvVF+U24mtrurL0PN/DffwX+dZWOx5oJQs29AH3Jd/1CLtL2ZLx74isuoqHrGlrDvgQ0tezd/KqbczyPAoHrr1wBeH9Az/2W3WFiMoODZcmqdrn9t9bx1Ovt+Lsnl91x4NymudazFie91Pf4XcWjyimKLvgD3htX+LbDaWGe0RmFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6T+uyYMiAVhFTnmHkr8vkLx5ezWonx48r5TGpN5qqI=;
 b=fwAxDaz5qKMhm2DjNcx/bjGNV7UqLJFqvq8bBDPLvVQFSL6UhE3fbnyv/a6Nir1bX4xLpL19VSGrCJYr6DuMY7IhN6Vc6ZcP/DrjO2bno0rRX7uIqRoYOA2wtCKWnslxltcDT0rRMjQg+xrKCqvX7fLoOWDLKpjtG5OC4vSDYdszFYZPfbVCLxIliGtGkwRwBt5FO8TOVEMP/rSzLvwms2FhqCbntbRtcQslJAc91a6YxashWnxBUx9DK/yEWoobT2subsqUnmXmwmXTAx+IN60qB1AFJFTIM4mQ+ZPTdBaMp7yvdxGMxNZzsvg5WkeAYpu9HpHE1QwH26baacOyuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P6T+uyYMiAVhFTnmHkr8vkLx5ezWonx48r5TGpN5qqI=;
 b=I1vGgzFiGU/0aLcS3d/oYtnPnxb26RqNmWF3xMLGgilO5VGa0DNbecRNC9CbjRV+Rctaq4ehfF+DWXed3QeYlrTbjJbfo1rr4CPWhE2o3X3ovNg1ONAHgPeaC9OnkYbmcKorMsb2GFqFeNSqKjq43JQ9L7OFIEbrjshHgrNQH4Vwz0P18WZifgOmcTqePAxEHpbHJKlfJxOBKsn6PRG7/rwvkkpBaYjfbbRCf5rVeD/VdxPPS7vzwAT7TEcNrItFNebh+CtOnID4Y0aIDjkdSOt2z8I/wVmh1hRmbC2aUUhJ+HhWp3NfvYJegiLcX5QZhGLEG0E36h7PJne/9sUy8w==
Received: from BN6PR11CA0044.namprd11.prod.outlook.com (2603:10b6:404:4b::30)
 by DM6PR04MB5100.namprd04.prod.outlook.com (2603:10b6:5:16::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Fri, 15 May
 2020 15:24:02 +0000
Received: from BN7NAM10FT028.eop-nam10.prod.protection.outlook.com
 (2603:10b6:404:4b:cafe::3) by BN6PR11CA0044.outlook.office365.com
 (2603:10b6:404:4b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend
 Transport; Fri, 15 May 2020 15:24:02 +0000
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
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 15:24:01 +0000
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
Subject: [PATCH v2 2/4] fs: Add O_CLOFORK flag for open(2) and dup3(2)
Date:   Fri, 15 May 2020 10:23:19 -0500
Message-ID: <20200515152321.9280-3-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.000
X-TM-AS-Result: No-9.399500-8.000000-10
X-TMASE-MatchedRID: g25QWLQyM7v1HKFnt7/e8tKhw1CGAxrIlHLUcNM85doAZTQQTIkkc93N
        NJQDizxeGDXccV5w1UP1q35E6lDQr2+4O3SBmLlW9u1rQ4BgXPIBmf/gD11vZAaYevV4zG3ZQBz
        oPKhLashZ3hT8koiLOx4fZrHGL7yoEVfyWRZcVuVZMZ6MZ0H1UhACJh4BWAPePTublrdV/SPAgD
        8QYQcBsjk4XrS69X2i0/NbBMSkGddoWWTS0CIqzlgUnyU84hcfquFC73XPA2ffc2Xd6VJ+ym9Ih
        irTclUbTnj5SlaoRXUaH2v8HV+LCgzyMxeMEX6wFEUknJ/kEl7dB/CxWTRRu25FeHtsUoHuXl//
        B5rrV1RVFUQEIC0/f+wk1G5ssoeQZd0ZOVOHZfRYKVgm72vjJg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.399500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(39860400002)(376002)(346002)(396003)(136003)(46966005)(7636003)(36756003)(107886003)(1076003)(82310400002)(2906002)(54906003)(356005)(478600001)(70586007)(110136005)(70206006)(186003)(44832011)(336012)(8936002)(2616005)(8676002)(7696005)(26005)(5660300002)(6666004)(4326008)(426003)(316002)(86362001)(7416002)(82740400003)(47076004)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fecd949f-3720-43d5-58c1-08d7f8e3ff2a
X-MS-TrafficTypeDiagnostic: DM6PR04MB5100:
X-Microsoft-Antispam-PRVS: <DM6PR04MB51006B5CC2A77C92AFF746DF9CBD0@DM6PR04MB5100.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isZu81VyAfRY+lWWSVPUDfl/Tmz7AWp5v1jxqT9bx4yLZ+kMYkZgDxR2oKI524TqHwZ86G53Cf0h6tcL1w2TUhQihdZee6HpT8kVEf/CZeLJW6U3tdZ5qft73Bu7OXQFu+/5yUvTDH2w4kMBt6I4efgDw41fJ3HHx5bzVnUNsS/9x8Z3ok/gT6iedlctSNinxj+w0ZVocGVYSoJ10k6Wqb43jk0eqByFi4T52qeieNprz4oAoz9l24YZfHaJLT7M5oHZLi8TgyFRhFHUYok3XiUyHRskdOG2vuklgRTIRgiH/NGirjBkZiQSEseUWMGLM7MF6RxYHTUk2oKDLY0ZotkKMKmolCjFE6DMHF+IrHHpJeaOjvWE39FHTvG21VH5IwhdlCWRJ6bhto0luBr38vNxq7JnkG1lsFPRPkQ38uUEOdXUYTign1P085L1t5hZpPi1TqiIPHSng4VSqCj4r9Pq/SJeKvx/KyTBgXXECTakWr31+ftQ5xfd/J7Nrd59p7GsHeJ/Jxw821/LbQhG/A==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:24:01.7355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fecd949f-3720-43d5-58c1-08d7f8e3ff2a
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5100
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
index 913b0cb70804..40af2a48702b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1033,7 +1033,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/file.c b/fs/file.c
index 81194349e980..4a1b84eecec6 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -547,6 +547,10 @@ int __alloc_fd(struct files_struct *files,
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
@@ -953,6 +957,10 @@ __releases(&files->file_lock)
 		__set_close_on_exec(fd, fdt);
 	else
 		__clear_close_on_exec(fd, fdt);
+	if (flags & O_CLOFORK)
+		__set_close_on_fork(fd, fdt);
+	else
+		__clear_close_on_fork(fd, fdt);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
@@ -993,7 +1001,7 @@ static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
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

