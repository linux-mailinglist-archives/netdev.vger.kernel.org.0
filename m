Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ABF3E2391
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 08:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhHFGxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 02:53:53 -0400
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:32097
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229635AbhHFGxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 02:53:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLQ8cDHnFdbFspIZCISJXnx4tVi7fMg51sbfYB12vOZchkge61tfaobjtqY0beZPO46RA9+RZw8YUzqyoNQGxcGbTR4r53R/EJ4acnL0c0l27qrWZV2dnipLdICd7YZhYd2F+MkqMFmYiSdV4xbbspw2yoUdDK2qvfWUtkuAJQMNCdMk+gBT4mmhfxja1dRxj3vW9fov+h7Nyjbu8OjMpyLXEmaomfithFdzsTaGhGLs7hpWaoY2wcPsWzeU9Pn9I0RNSvNlG5DKHS9KGs3m9/LdH96wGUYriRObqW2Etnvmcv+RANF/UAv+EPe+POHDJADa3kM9P/8dZtltth7g7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDUQk891/yzCAmBUgUjNk4g+NqLk1QEetLUqMTpYQMY=;
 b=gZ0fUSUGl3lZU1kiRNS2URBQVYl1RC4fiYfT2VxDKJmEgBCEfBm0/U76biHCp2fSC1NGyEAGlTklRIVMIhQfHoGC6YGZEF6516pBMLMgjUXTf4m7M6H0+dy4i5ExltMS62hiRsNSA5zRrCLJfK8DoGdfJxv7MGHmT65L3rB6m8huiWKP21h5cT6qeGWwrZXxGqglOKo/neSRafWUD3ki42ZgXWSpe4dFaGwB7R4g2nqB++5Q1vYAZHn6HOMXa17jIPKzIAY3/dYHy5CwCtWYGooawhn54DuWzvPtPw9gWm12w0nL7UG4UM6jRCuHGDZYCzAWKCRPXLitatvZz6ql6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDUQk891/yzCAmBUgUjNk4g+NqLk1QEetLUqMTpYQMY=;
 b=r2Fs+jbgcugJyKt0UB5vR28iuztcEDm7yjG7J+Fs4RSDrqg3XzOUutUx5B8DXabF3EXMKG8ENoFrQ+4jUBACOEl27HSaVNSFDrZUwY1j8EFgFtifuPW2ZTnEBFsPc1Q7CuV7SrcTJMXygBfm5NzJT5tHyvtuzQx+AXWeTeP8NnmFDIeZ/f6iJ2tddV+yIVfol9vQnIXxwTTqa/7lHKIRfH+lbywzixSHCXbqADxPpD9Pe8lHH/g0jxVUT7srX7jSTz30A1EGOTgsfr1+ncD48DBQEDX3X/CcnuYzr3eM7ngGbKo7aaDlmha2g0ocySHZXwnklCiUZbY0F+EiQ30Jew==
Received: from MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28)
 by DM6PR12MB5024.namprd12.prod.outlook.com (2603:10b6:5:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 6 Aug
 2021 06:53:33 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:2:cafe::af) by MWHPR12CA0042.outlook.office365.com
 (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Fri, 6 Aug 2021 06:53:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Fri, 6 Aug 2021 06:53:33 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Aug
 2021 06:53:32 +0000
Received: from sandstorm.attlocal.net (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 6 Aug 2021 06:53:32 +0000
From:   John Hubbard <jhubbard@nvidia.com>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
CC:     "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "Sven Auhagen" <sven.auhagen@voleatech.de>,
        Matteo Croce <mcroce@microsoft.com>
Subject: [PATCH] net: mvvp2: fix short frame size on s390
Date:   Thu, 5 Aug 2021 23:53:30 -0700
Message-ID: <20210806065330.23000-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11c2c6ea-8a12-4256-239f-08d958a6e846
X-MS-TrafficTypeDiagnostic: DM6PR12MB5024:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5024CF7EC7564CF4BE6B0371A8F39@DM6PR12MB5024.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:56;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4oxJ3gAfeE1dsB2mdmDHjUalV95m5UF7Iwhe95/LiIQkkNW3LJ2bPEFrd1SaeI4+NcLvCcE7Sj7XNP5IAMbc02XAtipA+e6/eXkU5UlpBKNfVaJDe0uxM9iMDkdyBxM16mTmHWEmcPeloUy/O/tjtod6Rj6m06/w1S89VNcRjbxIgPsIv2oEUJ0+12ar13uqgO5lOQ4n77gMsOtITzkaqiCQ5nCUNqnwIRL42dyJ0etE08CqDfRT65VS+BjsuERUniNQj9+F7ZjsQdCUGelSzNYsORW6jqz8gTeoB/X4Wx1jyleBGckmnaTv/CIOLrpcIwW9OHECOUvCB0NOkdX7/QtO4S7VupLzHXVSTFGjRal2D7ZeBXntFU7u8fPHP0vxXTEzP1jNQrtP5t7KDvP2CA6PObqEi34lNY8LpagR3B12P+6lNIhfsi9gle8JiVHznasisA7e+ImwFEhBZ+xw1WxlvZ65Bt6tTWEwUyJlqtxiF9VpQAbsnV6qROUKTOkBeHXuHvWigWMmQeNjO4xnxW4xOeCjgOOFrFa8zt7FvNP3yii9dbFBi+NAa2HSQxCKSszvpoloGKfb9281BsRov+V/4ARKaf6HscVm/bRExbaI53M1CL2mYUHUOjjmM6yEfnka1WUzapHiBplra6YyjFnrgABug/VVPfmJxhf0/aZjHcenaTLw2kw9sxKEidow20Hi9s6IHvUoUc3TYduAA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(7636003)(54906003)(110136005)(5660300002)(70586007)(186003)(2906002)(8936002)(8676002)(336012)(4326008)(26005)(316002)(36860700001)(45080400002)(36906005)(508600001)(1076003)(356005)(47076005)(83380400001)(36756003)(86362001)(7416002)(426003)(82310400003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 06:53:33.3262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c2c6ea-8a12-4256-239f-08d958a6e846
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5024
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On s390, the following build warning occurs:

drivers/net/ethernet/marvell/mvpp2/mvpp2.h:844:2: warning: overflow in
conversion from 'long unsigned int' to 'int' changes value from
'18446744073709551584' to '-32' [-Woverflow]
844 |  ((total_size) - MVPP2_SKB_HEADROOM - MVPP2_SKB_SHINFO_SIZE)

This happens because MVPP2_SKB_SHINFO_SIZE, which is 320 bytes (which is
already 64-byte aligned) on some architectures, actually gets ALIGN'd up
to 512 bytes in the s390 case.

So then, when this is invoked:

    MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE)

...that turns into:

     704 - 224 - 512 == -32

...which is not a good frame size to end up with! The warning above is a
bit lucky: it notices a signed/unsigned bad behavior here, which leads
to the real problem of a frame that is too short for its contents.

Increase MVPP2_BM_SHORT_FRAME_SIZE by 32 (from 704 to 736), which is
just exactly big enough. (The other values can't readily be changed
without causing a lot of other problems.)

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Cc: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Matteo Croce <mcroce@microsoft.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Hi,

This patch is based on today's linux.git (commit 902e7f373fff).

thanks,
John Hubbard
NVIDIA


 drivers/net/ethernet/marvell/mvpp2/mvpp2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index b9fbc9f000f2..cf8acabb90ac 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -938,7 +938,7 @@ enum mvpp22_ptp_packet_format {
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
 #define MVPP2_BM_COOKIE_CPU_OFFS	24
 
-#define MVPP2_BM_SHORT_FRAME_SIZE	704	/* frame size 128 */
+#define MVPP2_BM_SHORT_FRAME_SIZE	736	/* frame size 128 */
 #define MVPP2_BM_LONG_FRAME_SIZE	2240	/* frame size 1664 */
 #define MVPP2_BM_JUMBO_FRAME_SIZE	10432	/* frame size 9856 */
 /* BM short pool packet size
-- 
2.32.0

