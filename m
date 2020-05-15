Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D021D547F
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgEOPYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:24:14 -0400
Received: from mail-dm6nam10on2118.outbound.protection.outlook.com ([40.107.93.118]:49121
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbgEOPYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEOLUHMa2UoJi0CEe2LxxdHB5IMJ4t88cPDIRObJbEtymzC3VnTzySi71FSCm8/OhWlFUD8lg2gAuBxJPHdN1jKr2X9W9qgGcI9Ll2LtmBGtftORXVVxF/dxfADTTBKe65VCq3Oofcq8fJltBvjZHhcGZwOlVd2mTF0cnXABqaZu3RvyVVTzIlicYNtqyIJb0MwJkz6Tew/Ho2Q1Hok2NdF0RKdQEkzhGs14BXKzNf+l4asgisM7Ecn2akCmOo9I+RcYq22kApXqO2ZxNEXl+wbT2JIYsJp+YuviPxZxnNtMgyFRX2IxfEa6ve/TcIGGqfCi6dNYsgS95etYi0vzbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQjMj+RVOA3gQhcB59BEGhR0ZVZ+DwBiLoZN26WeP4M=;
 b=EnQ7F8I84B1XsrDk63SJa357gqcbxGVl5v5Lci6yN+wEsFDBOk+mTnu1zFZ2vZg2BARJkG0Z9ifDACBamySlpskckp3DHOVK2hBw/ianuD3qADgpN+DkmnG1TqOF32DOwVjGKwocqY4QOuCJrk+DN+63eBEeOmYGmy17+aF4nvVg1AGAgrZtifrFaczREBDc4cTeJMflAbhatvmBcX5vdq1imRdvR8Sdq9KovjmgBD4REdjEMXqNS54XYClcFmms2z1Cs2mDuIwS8bsAYkrSU2wC9AMXknMK7RuAekeRfpwGxmHi7Hyc2Y1nSHXSvnOBfk0AhfdLjRgrqqUzBqdzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQjMj+RVOA3gQhcB59BEGhR0ZVZ+DwBiLoZN26WeP4M=;
 b=k1K/A5BFIPA6wU8Lo48HDz6BHwBdHsIzMjinzCgUvwl59wiBoMpEdaOSCoPcVbWz+RlxH/7gERj2HhmZzRZkaY6ocb7r+sDlQSfKgxWSWSl3h7fLlvtCQFxLdD7HsrsqRHc6xtJZA8HEF6l6wsroBJ74SPTXiWteBV0iRVJk6Sg8Ppti0agvIW38+cQ4UocVmyqbWEfn5+sWOuH3381MGNYWUGUpvVmw2Npe/WOm3AQJZawO3dT7+j8iLloMCe+SWM0/r+sSw0GxgG/yj4lSnRP+PYxFOP4K8GkxRitL0xHgd8BsdxJz5V1Rs0razZB5ytjBZ1cRiJ9eco9FkYea9Q==
Received: from DM5PR04CA0054.namprd04.prod.outlook.com (2603:10b6:3:ef::16) by
 MWHPR04MB1119.namprd04.prod.outlook.com (2603:10b6:300:72::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.25; Fri, 15 May 2020 15:24:02 +0000
Received: from DM6NAM10FT013.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::54) by DM5PR04CA0054.outlook.office365.com
 (2603:10b6:3:ef::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26 via Frontend
 Transport; Fri, 15 May 2020 15:24:02 +0000
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
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 15:24:02 +0000
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
Subject: [PATCH v2 3/4] fs: Add F_DUPFD_CLOFORK to fcntl(2)
Date:   Fri, 15 May 2020 10:23:20 -0500
Message-ID: <20200515152321.9280-4-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200515152321.9280-1-nate.karstens@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.000
X-TM-AS-Result: No-4.203000-8.000000-10
X-TMASE-MatchedRID: 7BIPnr8mPjQY5XJhZJs6SDCMW7zNwFaIvj5VWb6CNmV+SLLtNOiBhgml
        i9Nhz+dFfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkzNIobH2DzGEEa8g1x8eqF9uykrHhg4PdNFZ
        RXtDJ5V4dF/1KVDvFSVHD52u9u0z5m71ITw4wJLGeAiCmPx4NwGmRqNBHmBve38LauI2fxt4qtq
        5d3cxkNS+oniWV7avzmcqybxBa2+C6QCDPhlLtQhPpmZ4cQhq+T2ylkfPFK8WScp9O5U1lNmTUl
        UcmTofyMAfmDr1ydimGukhCAALSJVVbZb5kmRl4XyZ6pl/oDQ1+Az0rNWZh1oK3xHwHujePaS3X
        XfcxpZY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.203000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(376002)(39860400002)(46966005)(478600001)(8936002)(8676002)(5660300002)(7416002)(336012)(426003)(70586007)(44832011)(70206006)(54906003)(1076003)(2616005)(26005)(36756003)(110136005)(7696005)(186003)(316002)(6666004)(107886003)(7636003)(47076004)(82740400003)(2906002)(356005)(4326008)(86362001)(82310400002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe1ea777-cec6-4b25-bdf6-08d7f8e3ff5c
X-MS-TrafficTypeDiagnostic: MWHPR04MB1119:
X-Microsoft-Antispam-PRVS: <MWHPR04MB1119A1D396C2ED4AEC4D825B9CBD0@MWHPR04MB1119.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KegLR94YNgJIwrJakop+vn4lw7A96sDvjjeVEfiIAlOdRundn75LJsuVvJMoDze88+LuwKCEcY0X0PRxvI9eHWHr4tyVT2HG4PDAdaE+/404WLeTZVcX7Y0+o+YW4J8GJb6Ze7sS0yBossnuCfoSrfyAbbvW11MaWjfGIafoQ2Zv/trf2/dYlLK46qLES+H1cyyv94lAgvXP6iGqAe5529u9pz7dzBBFrO5ZDNUgsGAVI/lY3080YHsd7zW3UZEUpZe7/C6t4JDaHXtuK79JmS6e98yJaTkLkBVtDe56FvyUtX8cFH7Xmot5ESArKIhXzTGJKpyn2Ho1BhfcTzlSkQYa0B2E33iCDUKVtjHqpvibFyRMeWwIbewrwC9ON6Pw/UqC0PwN//hEwZeU+c2v0iD22Yd5vGni12yfKFDmDez7R9f6j4u1gI8/8rg1p10x9kl+FcM1W7VUd3JglBnXzqlYXUsedz+zV5TcyaUnwEEAwxhDmLfyteX5KygZHCq1VfkTG/fqXG+L8nLUmmO45w==
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:24:02.0777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe1ea777-cec6-4b25-bdf6-08d7f8e3ff5c
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB1119
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
index 40af2a48702b..e15cdd77b1df 100644
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
 		err = f_getfd(fd);
 		break;
@@ -437,6 +440,7 @@ static int check_fcntl_cmd(unsigned cmd)
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

