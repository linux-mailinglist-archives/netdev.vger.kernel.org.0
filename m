Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A705B1D5482
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgEOPYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:24:17 -0400
Received: from mail-mw2nam12on2125.outbound.protection.outlook.com ([40.107.244.125]:36832
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbgEOPYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:24:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKWk43z0x/KZF0sywx67657Mk/F8H2nUgKfPToS5d0m6mD3k5QjMX5xh0SDs4kKaTIEzZYCkSCHy8gISxLycUtgNH2bdO0s6+kYrxvjY3eBbKWlZc5MOSVwxiaygZeQHtiT0psOUceCmDENUOaTywAvCf8BO8+UDJH9KR6Akwc1BAhNMTvfDunFePyzMSvjKYYSLC5F8xrA3UOWoBdM4vMY8Jfe0gzOI24JP2dyQID4xvYNZQwrgiTbsK8qMe+JwQoUtwvrWigbuzz+wrDCwAm00IqQVR3VbstEr6VvBK3aQAy+Vf3Xo/3smpjYAdptiaK89lwzLIwoM0U+4kpbzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yYEsRUYimhigxmNAl7hxApckYLbS26D6tFLpPrG/lo=;
 b=l+ouHhsp451FHJBTOLo6AHmJn/Z8ZZ6pB15LJGDN4svF0t4K6WY6Ufv6xfV9bHz+I/Xb/bHKjCrIMOgWFLiXZY6gOtYTm6F/6mlRHaOw3B8cexM955slX/vEgyA6NB3ykzqa9w1WOnb8ZLpREgO1JLJ8O5llyKUvRSjE7LJfMRdNWUjIvjPOZiFSrzQgoG4s42qaGl9qeOCXupjb7EZQTmTnI0l46F3um6rkTjuzPm/26APxIG6CLx0nMllEp97Wmjx9SHHZfRXBdVcsVADTc4vZWzEjgOVxxDxootHkVVCJ5WXUzDtix3SPS/wahF8GG+nvqDEECJb+DCh4qjJdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yYEsRUYimhigxmNAl7hxApckYLbS26D6tFLpPrG/lo=;
 b=I457xqBnoCfDZc1z/TFtT1RPicEoDHm/6daPC0MAomONzYLNPttcgdh1DVSV4dCi5QWkglYuWH2zjeRQLBgIVHo9XVI/Oo1iR1HJ6B2zKcHQJ5e5Pd6/rfHdyuP5a3hA0+IMj6Qf5AHje0lpCg5p6CgNNxm/OGSntK/I/gyiYMbfn24JCi5RKjXtxvj0xJ2W74Mr6OeUW8zjtLGBfNHLBxDfBxVYGxq0ptPhqPKYEOomcc1AOv280AEktZFIDq+CXTYxrVrLstnzPhHDv15fbuzpdM5d8giKRXfxxKDLfSlZf8cdAEfLUpb3Sx5r+Z/nIm/jvgzvk9fYZlYOaQGX+w==
Received: from DM5PR04CA0059.namprd04.prod.outlook.com (2603:10b6:3:ef::21) by
 BN6PR04MB3714.namprd04.prod.outlook.com (2603:10b6:404:d5::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.24; Fri, 15 May 2020 15:24:01 +0000
Received: from DM6NAM10FT013.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::ca) by DM5PR04CA0059.outlook.office365.com
 (2603:10b6:3:ef::21) with Microsoft SMTP Server (version=TLS1_2,
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
 DM6NAM10FT013.mail.protection.outlook.com (10.13.152.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 15:24:01 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge1.garmin.com (10.60.4.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Fri, 15 May 2020 10:23:59 -0500
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
Subject: [PATCH v2 4/4] net: Add SOCK_CLOFORK
Date:   Fri, 15 May 2020 10:23:21 -0500
Message-ID: <20200515152321.9280-5-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.000
X-TM-AS-Result: No-5.988100-8.000000-10
X-TMASE-MatchedRID: KFRUM/mjxGuSsyjfsjrH/tKhw1CGAxrILoFHmcx3krwAIXlMppp3Xw5a
        yixA3COc1+Otxunw83huL3ESIrARlyHhSBQfglfsA9lly13c/gHaKQ0GLhRPDxh58BVvx3LmF5J
        Ui8H1I3XP8poBdrWc73VybJRFpSevgRZdz333xpBJUdgxNDUXWmf6wD367VgtDs0BGU1luwj6p1
        jlhLAJAsAhMlHsyVwnkA7KM/+6n4wylv9EjaWo1Q97mDMXdNW3fS0Ip2eEHnz3IzXlXlpamPoLR
        4+zsDTtifGCYEa4Fxczqf0EmDYqY85HeDGrYmKjUdmnIsreROaomPe8FsDc1A==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.988100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(396003)(346002)(46966005)(6666004)(47076004)(1076003)(356005)(2906002)(4326008)(82310400002)(54906003)(110136005)(36756003)(7636003)(5660300002)(107886003)(316002)(82740400003)(70206006)(426003)(8676002)(7416002)(336012)(7696005)(8936002)(26005)(186003)(86362001)(44832011)(70586007)(2616005)(478600001)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b1dcac2-3342-4c05-6a03-08d7f8e3fec2
X-MS-TrafficTypeDiagnostic: BN6PR04MB3714:
X-Microsoft-Antispam-PRVS: <BN6PR04MB37143A63D1E08B5B9D1C4C809CBD0@BN6PR04MB3714.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8EAb2hOELFGUpmq8+gtw26g0bqFwWv6HdRImt5NfSPkxaxbn9e+49dQ88Spz+vequWoudfOinphxbm/wSw4FSPh4j3p9OCmtbTAF7JVxKVecUTSfIwzvsAWcR7IPUHXReftWswk5Mu/xU/2QaLe7Grp5KgLANV3fzuBF9VxKrdzVd5o1rb130542COHjBSHsaVBhhRNukZG2qKh7nuZiFK7EsEv+C6tHfg22h/hHzNm6uLlWEYH6fzaVMVP/pmSau4h2nl2lhlwnX9l7sygvS0bavNtbFk/n46g3cfMCtLVS4Ryoufr9GEuacOfDhbncYK75LrhO6L5gmlnysRHTXPidh2p7GXgL0ANXBPRVkNO6hrSGLHPD18yQj4aX0HUH2uVP2VqRWI3EjTLCA4bS35EasOX2EF8+HNFOkMR3IIcT285W+a/zHEnWeD93FvN1WKkhCDZ/jxIPAwNVUdilbpuXe1jC4ixok6xDRF/zH9KLu8+kAwQLWE7NTU0rM+ly5V9eX/g9XoO9dFjES1Q5Q==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:24:01.0673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1dcac2-3342-4c05-6a03-08d7f8e3fec2
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB3714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implements a new socket flag that automatically sets the
close-on-fork flag for sockets created using socket(2),
socketpair(2), and accept4(2).

Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
---
 include/linux/net.h |  3 ++-
 net/socket.c        | 14 ++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 6451425e828f..57663c9dc8c4 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -17,7 +17,7 @@
 #include <linux/stringify.h>
 #include <linux/random.h>
 #include <linux/wait.h>
-#include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
+#include <linux/fcntl.h>	/* For O_CLOEXEC, O_CLOFORK, and O_NONBLOCK */
 #include <linux/rcupdate.h>
 #include <linux/once.h>
 #include <linux/fs.h>
@@ -73,6 +73,7 @@ enum sock_type {
 
 /* Flags for socket, socketpair, accept4 */
 #define SOCK_CLOEXEC	O_CLOEXEC
+#define SOCK_CLOFORK	O_CLOFORK
 #ifndef SOCK_NONBLOCK
 #define SOCK_NONBLOCK	O_NONBLOCK
 #endif
diff --git a/net/socket.c b/net/socket.c
index 2eecf1517f76..ba6e971c7e78 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1511,12 +1511,14 @@ int __sys_socket(int family, int type, int protocol)
 
 	/* Check the SOCK_* constants for consistency.  */
 	BUILD_BUG_ON(SOCK_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(SOCK_CLOFORK != O_CLOFORK);
 	BUILD_BUG_ON((SOCK_MAX | SOCK_TYPE_MASK) != SOCK_TYPE_MASK);
 	BUILD_BUG_ON(SOCK_CLOEXEC & SOCK_TYPE_MASK);
+	BUILD_BUG_ON(SOCK_CLOFORK & SOCK_TYPE_MASK);
 	BUILD_BUG_ON(SOCK_NONBLOCK & SOCK_TYPE_MASK);
 
 	flags = type & ~SOCK_TYPE_MASK;
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+	if (flags & ~(SOCK_CLOEXEC | SOCK_CLOFORK | SOCK_NONBLOCK))
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
@@ -1527,7 +1529,7 @@ int __sys_socket(int family, int type, int protocol)
 	if (retval < 0)
 		return retval;
 
-	return sock_map_fd(sock, flags & (O_CLOEXEC | O_NONBLOCK));
+	return sock_map_fd(sock, flags & (O_CLOEXEC | O_CLOFORK | O_NONBLOCK));
 }
 
 SYSCALL_DEFINE3(socket, int, family, int, type, int, protocol)
@@ -1547,7 +1549,7 @@ int __sys_socketpair(int family, int type, int protocol, int __user *usockvec)
 	int flags;
 
 	flags = type & ~SOCK_TYPE_MASK;
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+	if (flags & ~(SOCK_CLOEXEC | SOCK_CLOFORK | SOCK_NONBLOCK))
 		return -EINVAL;
 	type &= SOCK_TYPE_MASK;
 
@@ -1715,7 +1717,7 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
 	int err, len, newfd;
 	struct sockaddr_storage address;
 
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+	if (flags & ~(SOCK_CLOEXEC | SOCK_CLOFORK | SOCK_NONBLOCK))
 		return -EINVAL;
 
 	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
@@ -3628,8 +3630,8 @@ EXPORT_SYMBOL(kernel_listen);
  *	@newsock: new connected socket
  *	@flags: flags
  *
- *	@flags must be SOCK_CLOEXEC, SOCK_NONBLOCK or 0.
- *	If it fails, @newsock is guaranteed to be %NULL.
+ *	@flags must be SOCK_CLOEXEC, SOCK_CLOFORK, SOCK_NONBLOCK,
+ *	or 0. If it fails, @newsock is guaranteed to be %NULL.
  *	Returns 0 or an error.
  */
 
-- 
2.26.1

