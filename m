Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5498D1B0294
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDTHQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:16:23 -0400
Received: from mail-bn7nam10on2139.outbound.protection.outlook.com ([40.107.92.139]:45312
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgDTHQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 03:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMZxtmgcFEwXlOQN3NZJeESwjTXvcSk21FrnNGhcOGc0NXebgv4RWmCkM5mLCFzTZVKo7ZZuXWVs54ctysP+ut+LeEHnDmRu6qILSPRi4g2Y6g+t5FAor/l4BoMal22ZxuXZ0o8lcHQ09S8TdINTN7glhWJoZfC5wLaxl7LrGry7HbTIdWsPS6WH5qOY6IW/9HI29J0ti3+GYmGjwUE8abuFzEwR7yE6/A8BOc+mszyNxBkwgFAxBMRSsvydfRLs71QogTGjNvYpi/Adhp/KkfZA/eZlVUmeKk8y/gXSizIVvdROasCWjhSlgk0ubM1aelL4S2ItxqLNz28mtOQXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOYvnp7bJqq5anIhuffI1wsXH6vHP2jlj1SDx9yGSv8=;
 b=LZuEPUzNXJ4d6Dn29tTBbittAhHKB3bmEc4JDeiQThUd8ZloiuIqiP67h3xhl+ckigFxWfm89MxiGMYydLE/nk5JPTjyRwIgeyUrrYAxJ8DB8aMH2G+KsaIUYU6gAAgxb2rXgQHQmB0fB/PegCis6MViS2HASLBEc9OK6BbJlvabZzadeA2tsFjQX44u6297TnRGjK+QTK0aQWN0FHqwxOu/zLN56ADiItLK9p9wTYcGsQmyZiORRzmvcV0C2h2wj3FgkB7o0JwW3IKLBjG1JUmSyAm4ddibKihD3y81Rkr1ACMnuj6oOvl0LAt7Ka/U2ePpw2RCtJeDFUsXiGzQ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=20)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOYvnp7bJqq5anIhuffI1wsXH6vHP2jlj1SDx9yGSv8=;
 b=GD2rUKFQHpPI28/vU5DE0lbVWY/TIq+0dJEorFtSomb/XynkllZxnl7ZWTTS+j4xyGLZJGtvaMCiGgPJYsCgS8vluppKNGTPjwGC11P7PzDoyYRx2bvQQIQERPl34wklBe2w/QDB++AaLOaNM+JtwggExobZ/zsD4xuLd9LH5xz5FgnclvH1cSpx1QXGHXGd6TSWaWkmxJlbdujLLMNldZg7V0to2fk7e6kkRyOp26ajHt57zPh6zhEWdp2X41bwN896tsiKDaDBcDsce4pgdWvyBAy/gDAwbLrLwRz+Cl+6JuVjdXW1Hnfo8UHb7jC0wZBnMQwa9MXgO0tqM0jCDA==
Received: from CO2PR05CA0089.namprd05.prod.outlook.com (2603:10b6:104:1::15)
 by MN2PR04MB5630.namprd04.prod.outlook.com (2603:10b6:208:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Mon, 20 Apr
 2020 07:16:18 +0000
Received: from MW2NAM10FT016.eop-nam10.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::fd) by CO2PR05CA0089.outlook.office365.com
 (2603:10b6:104:1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend
 Transport; Mon, 20 Apr 2020 07:16:18 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT016.mail.protection.outlook.com (10.13.155.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 07:16:17 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge2.garmin.com (10.60.4.35) with Microsoft SMTP Server
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
Subject: [PATCH 3/4] fs: Add F_DUPFD_CLOFORK to fcntl(2)
Date:   Mon, 20 Apr 2020 02:15:47 -0500
Message-ID: <20200420071548.62112-4-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420071548.62112-1-nate.karstens@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.005
X-TM-AS-Result: No-5.713000-8.000000-10
X-TMASE-MatchedRID: eeq60RTJBf0Y5XJhZJs6SDCMW7zNwFaIvj5VWb6CNmV+SLLtNOiBhgml
        i9Nhz+dFfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkzNIobH2DzGExgXFacxiSBt9zZd3pUn7Kg7l
        N9LOvFDucmKqWNzxVSaWKPIetqooLqNz1cokKoAVCOHkvZleP7OuLFZZYlisfHxPMjOKY7A9qHX
        ONfTwSQsRB0bsfrpPIXzYxeQR1Dvs+lQOfpVOOU1nQzOr+jM9o0Y74GdR0vcESeUlcAF2N8EW/6
        xYikolL
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.713000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.005
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(46966005)(110136005)(54906003)(86362001)(2906002)(8676002)(107886003)(36756003)(47076004)(70586007)(70206006)(1076003)(316002)(5660300002)(2616005)(246002)(7636003)(7696005)(8936002)(356005)(6666004)(4326008)(44832011)(186003)(26005)(478600001)(82740400003)(426003)(336012)(7416002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 890b902e-1863-4a1f-367e-08d7e4fab838
X-MS-TrafficTypeDiagnostic: MN2PR04MB5630:
X-Microsoft-Antispam-PRVS: <MN2PR04MB56304E8E37277EE48279BD689CD40@MN2PR04MB5630.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 03793408BA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63nbtYsEnWbgMp1mOgFKnp2HufTuWZry0p8SAGgeBNVv6Chc4EGItGv2W+jfFI8nNl0Fb0yvc//pYPuK6ZfN7gOSNzqc2FqW9fzK+KOZzA4K0T0PZZzO+9PH3I0NLkPifP8RkcdjSJgGLEnKuWm253bJJyeU99b2S8v4b8oTuaUMhoNB+CjXiHiYo+vuvxebtfwuKPfS/S/6AYaWU/RCO2wV9HnP4OFJepRfniCxL2D5jlPMZP/bif0nNJdgB3jXGkDf/GR2GZn6XRDvxIeeUu+aUDbW4LViaECJtHj5YvwEJuNHomD12vCsyBAwPe2OUrGsTK+OHTzcICPWUWMF3X9gMsBIRlIqI/l0MayalY2CR4u3/ulfVuvQ66lkZHzGWBhsa95eejQ4BgWmtI1WoRiJM+/vN5O+3Vk2e8kNV365PBdFwRzVuaeJumljpjEiFXRPCWOoCqUBUEkIaNK1clTYDJaCxn3c4Gx71Z3sAmofIsTUaRBjw+aTHs/EwtZqxooIohIItFBvv9440dPEog==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 07:16:17.8533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890b902e-1863-4a1f-367e-08d7e4fab838
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5630
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement functionality for duplicating a file descriptor
and having the close-on-fork flag automatically set in the
new file descriptor.

Signed-off-by: Nate Karstens <nate.karstens@garmin.com>
---
 fs/fcntl.c                       | 4 ++++
 include/uapi/linux/fcntl.h       | 3 +++
 tools/include/uapi/linux/fcntl.h | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index b59b27c3a338..43ca3e3dacc5 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -333,6 +333,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_DUPFD_CLOEXEC:
 		err = f_dupfd(arg, filp, O_CLOEXEC);
 		break;
+	case F_DUPFD_CLOFORK:
+		err = f_dupfd(arg, filp, O_CLOFORK);
+		break;
 	case F_GETFD:
 		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
 		err |= get_close_on_fork(fd) ? FD_CLOFORK : 0;
@@ -439,6 +442,7 @@ static int check_fcntl_cmd(unsigned cmd)
 	switch (cmd) {
 	case F_DUPFD:
 	case F_DUPFD_CLOEXEC:
+	case F_DUPFD_CLOFORK:
 	case F_GETFD:
 	case F_SETFD:
 	case F_GETFL:
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index ca88b7bce553..9e1069ff3a22 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -55,6 +55,9 @@
 #define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
 #define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)
 
+/* Create a file descriptor with FD_CLOFORK set. */
+#define F_DUPFD_CLOFORK	(F_LINUX_SPECIFIC_BASE + 15)
+
 /*
  * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
  * used to clear any hints previously set.
diff --git a/tools/include/uapi/linux/fcntl.h b/tools/include/uapi/linux/fcntl.h
index ca88b7bce553..9e1069ff3a22 100644
--- a/tools/include/uapi/linux/fcntl.h
+++ b/tools/include/uapi/linux/fcntl.h
@@ -55,6 +55,9 @@
 #define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
 #define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)
 
+/* Create a file descriptor with FD_CLOFORK set. */
+#define F_DUPFD_CLOFORK	(F_LINUX_SPECIFIC_BASE + 15)
+
 /*
  * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
  * used to clear any hints previously set.
-- 
2.26.1

