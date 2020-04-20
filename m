Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453231B028D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDTHQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:16:15 -0400
Received: from mail-dm6nam12on2117.outbound.protection.outlook.com ([40.107.243.117]:57049
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgDTHQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 03:16:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITQS8bQSZfEkBfWEqYRoeO2K+t6He4hAkgoRaLbGJc5NrDcsVGlqf7ArYa2fMkNGTd/2Ja2YLlYCR5OQVvqQEmWSHb6/A33igGJU/x8RKWpLJvlKrkXZQNc6C2Mgn+IePd38rFHY5Xzjh1XtasMfPVAkDjdAboLIvrJdCuNjQP5kZOu6ydJzXGt/KPZ+Unrm6ZWSl+JKAo9mEP7q1RMd9MEk45gThuPNZ6D87mA+lbkCREcShDBODivuhuHz2ldEmufUGBdgG4g0CU2iie9oJ93U7p8w62bQhwN73thz4dYqE+HRo9ChBMI3/jaY+zjbuDEUFl9Uh11jK00ezfJ8Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Obf8vJL6eB5UeU879i1Y2ZaUrwAqXiDjQeosQo0DGk0=;
 b=OsGF/OK4v8EurgiZItl4OzhHFoWVhbgKRzGMy8beoVzBs2VvkVKDXUtMoB0bTyWswkNgrkr6r6d8f1vjAUlJ4g8KUP5RYtvpY8+ID1DiDVycBnKsa64ahobGYWxWqi+JCIZ1HzcZNw0EKnHDHVJlU7JzzLmTp7/b0C2nS9oAT2/VE02sYGrnZnOvCGaVhZQB4I+Egu//xe3EiMoS3o/e2sD2Z7Qx4GVHaQLu6eDpv1xhX1rmkW9DT2IYay14jNQsl39NFTSY9Xm2VG7G4s3IsNZ2BSvo2/h9TBYrw1aaKIS2lsPXrJcvdMbLDIUm9dVsJUYZdgcBHZV0XUNOo94iNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=temperror action=none header.from=garmin.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Obf8vJL6eB5UeU879i1Y2ZaUrwAqXiDjQeosQo0DGk0=;
 b=CU8fPaE/YUAdbdWZNiws63RKc4CHYrpnREhetAoYNuj88hjKb31Zgo4wug6abVk0ATDgU0K/WgcPkTIWwdC7LVF6cCeDRQkku1Uv08k4aXLPkjM/G8iFRe1lBiRSKVOGDS28kTsE6qRj0q8q7xEngOsqdnDnZSU8Ta7wkNv3rtiAUERKkd+8lr9JavZYo7YC22mHFqXKuS/QFUfq2Otc0PApoHuebMBteRW6dd8m1am8sOuMP9KmT1jM1yIKrercv/L63wvjGnSeHxdpIMxtr9qGIONXmAs/niGUo0GKb5GCP2S0IiYelHeijCgb18AAQ0v7J//lc/CmN/BwdXCyTw==
Received: from MWHPR1701CA0021.namprd17.prod.outlook.com
 (2603:10b6:301:14::31) by MN2PR04MB6943.namprd04.prod.outlook.com
 (2603:10b6:208:1e8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 07:16:10 +0000
Received: from MW2NAM10FT023.eop-nam10.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::73) by MWHPR1701CA0021.outlook.office365.com
 (2603:10b6:301:14::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend
 Transport; Mon, 20 Apr 2020 07:16:10 +0000
Authentication-Results: spf=temperror (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=temperror action=none
 header.from=garmin.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of garmin.com: DNS Timeout)
Received: from edgetransport.garmin.com (204.77.163.244) by
 MW2NAM10FT023.mail.protection.outlook.com (10.13.154.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 07:16:09 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Mon, 20 Apr 2020 02:16:08 -0500
Received: from ola-d01c000-vm.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 20 Apr 2020 02:16:07 -0500
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
CC:     Changli Gao <xiaosuo@gmail.com>
Subject: Implement close-on-fork
Date:   Mon, 20 Apr 2020 02:15:44 -0500
Message-ID: <20200420071548.62112-1-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25366.005
X-TM-AS-Result: No-2.672700-8.000000-10
X-TMASE-MatchedRID: C0yCreAKqhU6Vyyhf+5DyNnDq+aDZjGZopGQY5bbP3IS39b8+3nDx2yH
        arFSgTJkrAcfB2a374DtuEV8riQqnUL5qYNMJ0izSJA7ysb1rf4MoIRV9JcRcJgEXULQnZA+REq
        3u7TSlyQQjJKRYDGkqiLlzUWeMnOUG9+YWBtn9f02Kcs0U8NADwD4keG7QhHmkaEC8FJraL9VBT
        xVtaxF+PJULsnDyV0omyiLZetSf8nyb6HMFK1qexQabjOuIvShC24oEZ6SpSk6XEE7Yhw4FnGVL
        azt5ExJKPeGqR8ehy43+ClJRg1TEJQKb8/efJar62rAP15pkWFJxvTFjNlhWphE9dJLY+2Ccilc
        ogl42gi8ddZeVE3wUqPxvuJPX7GvZjWfMVA8wvMfAjFbCsqQWX7h78xQkeMv5UQ9TF0JjMw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.672700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25366.005
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(10019020)(396003)(346002)(376002)(136003)(39860400002)(46966005)(44832011)(8936002)(82740400003)(356005)(426003)(86362001)(8676002)(63350400001)(2906002)(63370400001)(2616005)(7636003)(4326008)(36756003)(478600001)(5660300002)(4744005)(3480700007)(26005)(7696005)(110136005)(966005)(47076004)(316002)(336012)(6666004)(70206006)(70586007)(246002)(1076003)(186003)(7416002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cebdd2a-378c-43a9-2eb3-08d7e4fab32f
X-MS-TrafficTypeDiagnostic: MN2PR04MB6943:
X-Microsoft-Antispam-PRVS: <MN2PR04MB6943FC5329299259A807F4529CD40@MN2PR04MB6943.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03793408BA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m17TNnMaRIyO1oiSpiZwXGsMZvV085XaKj6cIq9LcdAlPse18AqAT5jmB0Pfph+DE56qOp/ls93+OtaHM3hDYWXM+t9Livwz4yaMr2GHRexfElAHXNTtptwdUqo+GBAP6UOA/8mrI+JsuFhJ+cEsJ60B6Kv9y/0U5nxiZ9z+9Jkboy3r86s5FILAAsXrApz76dvKLmFju84NLojir1cFDfFnJ0vGyuKAxBLB86VFqjejN5MVr85F7lv96hIDS0jEbovGBEOzeIlGDejU0GCf3yU4SnBYsqdUw/QreLKxdROMNl0LlqioduW57/nDuNw41Na+fixQ23Mzhpvzz346TRClrROBj49KhxrfZMN4F+elyaz2PYIii8ZawTgV6F8wyKu1l/9OuOXv0Ym5izUnJyGPOFvmR+N/1E70r0lOtn1Ov590XsxkCIWe87pEECs7pDdVjb7In1DTZSL4pdxIgZED15l9BuPj1qk1MLkhMxi5RCzvEh9apnYKIt3Q7Kgtjv+ppO2ILGqERXHWWH5T/MaYJLpTk8H/9OoA4/90Pdqo8DCmgIjCU501LVzhTSJc+PoWshGTD4yCyImwWvO5wYxpxVNAhQk3Hu57meqGmEk=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 07:16:09.4056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cebdd2a-378c-43a9-2eb3-08d7e4fab32f
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series of 4 patches to implement close-on-fork. Tests have been
published to https://github.com/nkarstens/ltp/tree/close-on-fork.

close-on-fork addresses race conditions in system(), which
(depending on the implementation) is non-atomic in that it
first calls a fork() and then an exec().

This functionality was approved by the Austin Common Standards
Revision Group for inclusion in the next revision of the POSIX
standard (see issue 1318 in the Austin Group Defect Tracker).

[PATCH 1/4] fs: Implement close-on-fork
[PATCH 2/4] fs: Add O_CLOFORK flag for open(2) and dup3(2)
[PATCH 3/4] fs: Add F_DUPFD_CLOFORK to fcntl(2)
[PATCH 4/4] net: Add SOCK_CLOFORK

