Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CD81D5457
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgEOPYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:24:00 -0400
Received: from mail-bn7nam10on2108.outbound.protection.outlook.com ([40.107.92.108]:60595
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgEOPX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 11:23:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnfNi5yKilKMleoDfh27zMhVRE6DLyV+iw5RDp9CuNS7T34M0neMomjIos3y/fBeIAcEVgoQyMv2hURmr0oSVdHOVEoJCRUvDoPuQr+sCkE6fKydh0bQlDWxV5EwIxJ/7JPnuokMUrRQAK6BzC7crm2q0iGW+gKpWViGWjvMvpPMCXo+Dtd7Bsz69lGJSF40+jNnylnCKhm/TAmHUhfiU8466KOpEO/WWPo6XeBj0s6IE3P3hyXvovo957XDiEGFU0cnW84Xxy8Kkyfe4ZDC/v+YEzdawc6XoVDTbSmspo8gEdVUTko55IO1CSsSdMZNijk8svECBjsPUHQlTPmM6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ilk8yXGSyYiOz0awkgNVn6KxziVdemqlAeyIHcDCoqc=;
 b=DQ7cl7M0nYyFFwzSv3uYMNVZdfVuBIWen2FA7JE6AZaL1Caq1m6Q5wNYJb2SWXbd6xz3xX0sSoUmkUUu6yuAThe0CCe9k//jOpyJI7asRPM+/4YvAWDK43J/YMLHSdABh7Dn4s5rtJZIdhpLhdpg1W5kmN5iXKSOMhGugOgOfWdupnyWOVlOfg/PUG7EjFSYrBl6H1ENCaU5JQQ6kdnQhNDBWbgeZoOYWe7Vo2P87WuDPU7D3AGPX53pe4FCLeg/yuOpBQgIHHEcw/wyzY/T6aM7cLj2qi2fEUR15EDacOaVGg2V5Fyad1Xo0jzxrIGWzxwPA9y30aj0O3+m9s4jhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=zeniv.linux.org.uk
 smtp.mailfrom=garmin.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ilk8yXGSyYiOz0awkgNVn6KxziVdemqlAeyIHcDCoqc=;
 b=lqNHJDrwIGl2wEs7E1f2nqvZucWEYwWGbJpANNjOipQwsd4GPUjx2kENPzdl5+jSyA9dJgvTw+BfjWS6Jm0SDgDfEyEB05gVNTrxW4/L5YU3bBjBRGTZJWIobKF9kp8KDwEy71PwGmu2vlAa+B4zcE7ZpqAGDZYMZeeV3YKWziOZTxB5MT0a8kzvwzG/b0q1qAjzSJ/3681y7uMsDx/dq68/SWnfVPgqFLSO6O035wqxAe7qFuZQxqBSpXovKsssaM3JZEJRk4DJ6xwBMI4K1aPJm4xZ5m5U7yRtx+We+aoivDKlO2GNOTCIB6O78j4Ztpi0qFKd+oi23v9Myb6FhQ==
Received: from DM6PR14CA0061.namprd14.prod.outlook.com (2603:10b6:5:18f::38)
 by BN8PR04MB5633.namprd04.prod.outlook.com (2603:10b6:408:76::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Fri, 15 May
 2020 15:23:53 +0000
Received: from DM6NAM10FT011.eop-nam10.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::a4) by DM6PR14CA0061.outlook.office365.com
 (2603:10b6:5:18f::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend
 Transport; Fri, 15 May 2020 15:23:53 +0000
Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=pass action=none
 header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT011.mail.protection.outlook.com (10.13.152.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.19 via Frontend Transport; Fri, 15 May 2020 15:23:53 +0000
Received: from OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) by
 olawpa-edge3.garmin.com (10.60.4.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1466.3; Fri, 15 May 2020 10:23:51 -0500
Received: from ola-d01c000-vm.ad.garmin.com (10.5.84.15) by
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 15 May 2020 10:23:50 -0500
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
CC:     Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] Implement close-on-fork
Date:   Fri, 15 May 2020 10:23:17 -0500
Message-ID: <20200515152321.9280-1-nate.karstens@garmin.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) To
 OLAWPA-EXMB7.ad.garmin.com (10.5.144.21)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25422.000
X-TM-AS-Result: No-13.985100-8.000000-10
X-TMASE-MatchedRID: IXhV89UCBiY6Vyyhf+5DyNnDq+aDZjGZopGQY5bbP3IS39b8+3nDx2yH
        arFSgTJkrAcfB2a374DHQzCkIEC0MCXWu5LW+2slttAWxuM5sl4MoIRV9JcRcMAkyHiYDAQbe/7
        cxerWwk9dE4VPub+akrZRvD7ck6n3Qvmpg0wnSLNIkDvKxvWt/sPHY2htBa2bt2rjS6M+VNmden
        40SZnzP+nmptgQI8s0Ybr1wIpI4EVWSqhPlGB831D5LQ3Tl9H7ekMgTOQbVFsurUcwuzZNE6ajP
        ZFMk1nHs8gqOsWgajKJfU10X8ghjdhG27sGev85xVtvemNbkyejDWAh29R3WgGfIv/fwf55uCiL
        r1XhSf1O2zwC9+COqXuPZJ1vRHBhMDvZPMbvTD6cxB01DrjF9zsgUw68UQrY4PdcWsl+C/PKmnu
        HRSucyphkL8KXkZk1p5/Il/dAvJmHbsX/GOLqdoZAUzvhoe1TSuH+GfgmQGfHg+01BR0lp4R/LZ
        ztAiL/3sCrH2zrbRbih8z9AblAgxt445IfplOKolVO7uyOCDUEa8g1x8eqF7Ee96bzLpOvblTlt
        k7oaowCP4PWwXxfsfh941Sx72KBqicT/Ai+cAlhXXywTJLpfOdppbZRNp/IMTkWY9HYyZF7IzUF
        yCuNEEMfE3d94vHd42WC8ffme7UfE8yM4pjsDwtuKBGekqUpI/NGWt0UYPBO91OWsR4zA1MFbch
        rTlu21gtmLk8Eyf6K9JFdhRVepfO9MJDeh2W+
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--13.985100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25422.000
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(39860400002)(346002)(46966005)(36756003)(316002)(7416002)(2616005)(7696005)(110136005)(426003)(82310400002)(478600001)(356005)(966005)(7636003)(82740400003)(70586007)(186003)(6666004)(44832011)(70206006)(1076003)(4326008)(86362001)(5660300002)(47076004)(2906002)(8676002)(26005)(336012)(8936002)(921003);DIR:OUT;SFP:1102;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0128c414-a6b4-4edb-b0bd-08d7f8e3f9fa
X-MS-TrafficTypeDiagnostic: BN8PR04MB5633:
X-Microsoft-Antispam-PRVS: <BN8PR04MB563313ADCF486E724E40E63B9CBD0@BN8PR04MB5633.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qfgXT7kaDU1eLZzOlrNoWE7dCvP/70MqO9H41T/ZoxwH6WcFAIDI7/T08I+fmWk/Lxasp5vpfVpDoLA38onehzHyawaTGFtoVY/WF8CKuX7bifsI5tYMarDLqlYiLC8/DvxByGlSS880yV+kpwPn+gURczQ2o8VpFwSpzSVUFsuUcU2xe+xWoMQRiHYMEa9smL/PcWxn9XIAyKXZIgNEArkOS8+EqHu+pNzphD2kbOXnWL81yPeTc29DTWlQZRmP3g9vBg/0tO8zuHrZ82mjRp/1ZRixLBZvRdwrGtDMor/w9AFp0gsUhmxbDBoypLtpBPPDCSzsYSeTD8BmhIqqp1lXpxpDnU9usPH6EQvfX9orLxaO8gjiK27lle/BztJ+SoOZQtkViT98BLsicYBzBQdUtm419OlJHue4Z84uRP/NB/FozO2wgj4svVd0WXD+Fv6OiPTwJwms6/vrXAqiy21nBYqraKmLWEPigpTVbMtufdLfwp6Sy/DcXxXpY+UStloyxN8CsGqzEM4WaerShttNqI/Qkq5FQHemnlFgnji4YbjjegiO6e2PAJTqcdwSRU+fYnflTo+wEkqQJqam/UrZgLJpXRLVTKYxiumki2o=
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 15:23:53.0395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0128c414-a6b4-4edb-b0bd-08d7f8e3f9fa
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5633
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Series of 4 patches to implement close-on-fork. Tests have been
published to https://github.com/nkarstens/ltp/tree/close-on-fork
and cover close-on-fork functionality in the following syscalls:

 * accept(4)
 * dup3(2)
 * fcntl(2)
 * open(2)
 * socket(2)
 * socketpair(2)
 * unshare(2)

Addresses underlying issue in that there is no way to prevent
a fork() from duplicating a file descriptor. The existing
close-on-exec flag partially-addresses this by allowing the
parent process to mark a file descriptor as exclusive to itself,
but there is still a period of time the failure can occur
because the auto-close only occurs during the exec().

One manifestation of this is a race conditions in system(), which
(depending on the implementation) is non-atomic in that it first
calls a fork() and then an exec().

This functionality was approved by the Austin Common Standards
Revision Group for inclusion in the next revision of the POSIX
standard (see issue 1318 in the Austin Group Defect Tracker).

---

This is v2 of the change. See https://lkml.org/lkml/2020/4/20/113
for the original work.

Thanks to everyone who provided comments on the first series of
patches. Here are replies to specific comments:

> I suggest we group the two bits of a file (close_on_exec, close_on_fork)
> together, so that we do not have to dirty two separate cache lines.

I could be mistaken, but I don't think this would improve efficiency.
The close-on-fork and close-on-exec flags are read at different
times. If you assume separate syscalls for fork and exec then
there are several switches between when the two flags are read.
In addition, the close-on-fork flags in the new process must be
cleared, which will be much harder if the flags are interleaved.

> Also the F_GETFD/F_SETFD implementation must use a single function call,
> to not acquire the spinlock twice.

Good point, done.

> How about only allocating the 'close on fork' bitmap the first time
> a process sets a bit in it?

I looked into it and there are side effects I dont't think we want.
For example, if fcntl is used to set the close-on-fork flag, then
there is a chance that it cannot allocate memory, and so we'd have
to return ENOMEM. Seems cleaner to allocate memory up front so that
we know the file has all of the memory it needs.

> You should be able to use the same 'close the fds in this bitmap'
> function for both cases.

I looked into this and I think it is more efficient to prevent the
new process from having a reference to the open file than it is to
temporarily give the new process a reference and then close it later.

> I'm not sure dup_fd() is the best place to check the close-on-fork flag.
> For example, the ksys_unshare() > unshare_fd() > dup_fd() execution path
> seems suspect.

I have a better understanding of clone(2)/unshare(2) now and believe
that dup_fd() is the appropriate place to handle this. clone(2) with
CLONE_FILES set intentionally shares the file descriptor table, so
close-on-fork should not impact that. However, if unshare(2) is later
used to unshare the file descriptor table then the process calling
unshare(2) should automatically close its copy of any file descriptor
with close-on-fork set.

> If the close-on-fork flag is set, then __clear_open_fd() should be
> called instead of just __clear_bit(). This will ensure that
> fdt->full_fds_bits() is updated.

Done. It falls through to the case where the file had not finished
opening yet and leverages its call to __clear_open_fd().

> Need to investigate if the close-on-fork (or close-on-exec) flags
> need to be cleared when the file is closed as part of the
> close-on-fork execution path.

Done. The new file descriptor table starts with all close-on-fork
flags being cleared and dup_fd() gets the close-on-fork flag from
the old file descriptor table.

