Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187871B02AC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgDTHQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:16:32 -0400
Received: from mail-co1nam11on2138.outbound.protection.outlook.com ([40.107.220.138]:53754
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726161AbgDTHQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 03:16:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBAnFg/mCOz+ErpHv2NSOBQWOptEUcUQGn7EOcENIW+lCIarPUF5LrxXfQKEAVD2V9m3Yx8gw+isTHG8tL1BCU1iXXgcXHdBC4X4yp8UzRgbJ6kaJzeTcjnS7YfOs4Tl86XHtxpGJgmIO+GBl85p2wBPg5RBTB6PKNaUb/OlNX1j75JG2fnGIWhRdPcjFrqud7S/TFhj7I+iOBfrgZG4qpuBeY0G+k1EpJF6NWvjHR5FbF0AHB9bsy+JQGyZyFKMBUTavIXq7Emu2srr8avo1wHx1BmcnGQLzX3851kONjaG21RlKhxhvnhm/wdvntVMq6IDrWcvTisu4vafNNBdwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yYEsRUYimhigxmNAl7hxApckYLbS26D6tFLpPrG/lo=;
 b=Zon1sozQeDM3YBIMPfViOe3LN10WhMF3SakUUohxP5ezfqhUL9s3qwkiqqWDJUqmXqk+hEP7hLXqf867h7zEwfruRdaPPlYs7bq01XrpRctEoaXc/G/p31UmGsf3QJg47WDw9adaneWqUi/qA9JsVKAp3cBBglm8EKfogp7Greff4VrCXFS5d+IGhoVXm6qFfrQvRzIZgwff0+gxIIh5smezPhi0t9i9aad1AfMtuGAU0Uc3/4xPEqCV8Zec70X+HhCRT9O+MePimuWd8JBxmdZjX146GyfFBhCbV5bLX47Rmy0uAxZY313a/4L/Lijuom7MFZzX6y97rmAKfntHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=20)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yYEsRUYimhigxmNAl7hxApckYLbS26D6tFLpPrG/lo=;
 b=M2rMcKlo4LyEmZNQpHoBi/g0BzY22mToxCtY0yoGAc5rF1HaOWRD1NK9R5pZPSSwHUushgRVWnn5EBHAtEu71forlt5lzGveAPDUoClFPD7FpBGoJiS30/iTJ3OclenMMfwqM5mZ+YIspiso+7Uo09TsWJU4uZ5mcNdwuZJ9xpvt9xeUstKdB7AmF/Wb2MNtnTwKGoyJl/67inseffQoO5E6FGf95vfih38vuqFRB10V3OCS279+X3vpnFMSLsB5xEh0Ai0ddOP8mh6HdliBqLG/7SLtyYZdGF3igJvvwJ0p1K+tBFteujhgE6eR5Jppb58hjdjWxT3Zn5Gx0iPbfA==
Received: from DM6PR03CA0044.namprd03.prod.outlook.com (2603:10b6:5:100::21)
 by BN6PR04MB1202.namprd04.prod.outlook.com (2603:10b6:404:92::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:16:18 +0000
Received: from DM6NAM10FT049.eop-nam10.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::d8) by DM6PR03CA0044.outlook.office365.com
 (2603:10b6:5:100::21) with Microsoft SMTP Server (version=TLS1_2,
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
 DM6NAM10FT049.mail.protection.outlook.com (10.13.153.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 07:16:17 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge1.garmin.com (10.60.4.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Mon, 20 Apr 2020 02:16:17 -0500
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
Subject: [PATCH 4/4] net: Add SOCK_CLOFORK
Date:   Mon, 20 Apr 2020 02:15:48 -0500
Message-ID: <20200420071548.62112-5-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420071548.62112-1-nate.karstens@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.005
X-TM-AS-Result: No-5.988100-8.000000-10
X-TMASE-MatchedRID: 3IdSvgGCM2OSsyjfsjrH/tKhw1CGAxrILoFHmcx3krwAIXlMppp3Xw5a
        yixA3COc1+Otxunw83huL3ESIrARlyHhSBQfglfsA9lly13c/gHaKQ0GLhRPDxh58BVvx3LmF5J
        Ui8H1I3XP8poBdrWc73VybJRFpSevgRZdz333xpBJUdgxNDUXWmf6wD367VgtDs0BGU1luwj6p1
        jlhLAJAsAhMlHsyVwnkA7KM/+6n4wylv9EjaWo1Q97mDMXdNW364sVlliWKx8fE8yM4pjsDwtuK
        BGekqUpOlxBO2IcOBbnd1hvM4M+M/Oj3yVarJf2NRETSGY0whj9UjqKN8S2I8jQVQJrd8Qi
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.988100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.005
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(396003)(376002)(136003)(346002)(39860400002)(46966005)(478600001)(8936002)(70206006)(8676002)(70586007)(7636003)(107886003)(82740400003)(7416002)(4326008)(6666004)(316002)(7696005)(86362001)(26005)(110136005)(2906002)(44832011)(356005)(336012)(47076004)(5660300002)(1076003)(426003)(246002)(186003)(54906003)(36756003)(2616005)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ab779eb-5e35-43ed-9d80-08d7e4fab828
X-MS-TrafficTypeDiagnostic: BN6PR04MB1202:
X-Microsoft-Antispam-PRVS: <BN6PR04MB12023E2A07EE7DB67768D0F19CD40@BN6PR04MB1202.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 03793408BA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0CcKh8Qf3FddEbi5nhFMe1VjNNcgSCdxvxgYKQ0r8QLp6udo80abRk9RAM73VPsVotqQ5hMJQ+Y9jQnYZv93duqDQj4t4HAhGnhwdZKZbrwulBDWqLHm4oFlodAX1DxEYVDFsfmRkT7zTVdzv//mDk7HYKvDA2zc5YtyrVAcxYtmkCj4V83xUnmzcp8k3Zou/Chtri2EbJ37H+3Xy3xR3Ow1l25NxHf5HLZtHFySl51u6naoWhPFm0NmTIdDlJHThvHNdqP1zhWTOaQFv4WuxRTyuaeGZrdqK0V0o3Bp2UqxKH2Yj01ylctsK+nXszGvzi8ftQnEuHrbpqgtr5ady6lYsiKe+yXOGk37Rj8xRqD3njbWF8YlfoEiupOIcNr//YR8TJhfwX8diaZ1Zrz8DFgGmvIgrX9Et/Lz/Jq1QdlIMWGUYDasnW4I4rjLSCY10yLXXL6qhHrB4BMMoUUIY1JWu/Gq46QK2Zj+aOE75r8rseRvCy4qc2sZ5z+T6duX872YkGq8ceuSUXC7KeM9HQ==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 07:16:17.7851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab779eb-5e35-43ed-9d80-08d7e4fab828
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB1202
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

