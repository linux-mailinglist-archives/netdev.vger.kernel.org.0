Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0C94A5792
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiBAHQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:16:33 -0500
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:29925
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234551AbiBAHQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 02:16:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+HBwXzHXB2B3Mzeex1Qk5XFoBO4khm6gf80k0sFOL0tPaZ5StGCjZgAGKUo3szh+9BCjGW01qviLYquI9WNwo4MeHAKRwM98+x/e2/A7SwD7HeLx/KpgEn2vkEeA/3xyJW7aUcTmXD5UZoYJD0Nvr4MdT2q0TG99BQzlwHeqgXggevswkHSwzwFOcqL+NxK35DVAAvQIY4twpUbUxvBDU84v9T5Pq1P5OyqMxDlBZAIyCuPI+XRSxy9lV1EAefHBiP/d9zrGXlJt1cJZwSU9WmlFPbbYrgkqqHgdKG0froveEhT7tQC8n/BbUHDxSTihqtPQqIxC0YTqDgXOUBTmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qktoBEk+PBVVfcIFKrSYG+XBLORJezyLPV01s1TU3fk=;
 b=CvmD2t0sjcUPM0k+XXaIJel2DVpWm9j4RgMofN/0dk2Mr8wRc2E43WEqukGv6lZ0iUq90Y6M3Hr35Su6SE2eamndG9zZvSRPmZFAaCiCn9oVrkJsAb4STmTzXjMeFeOuYDeyp2y0J8Wuk40HyfBuTC4y91I4nJwBNReFHX97enXcqne+tL6oZN5VwrEpDhSv3gy7KrrgmT3IIEyxoFjua25VUt9MWphXfS7VBVMVpIbOLIsxmQz2TWt+6k4WWVlEKUiUug2OS0U6CQ1/kMZDI3DnnNfkXL3qUOrtTLs93yJ/dPsAzRT/LB5LdCfdBnw+Galw4PddmJZii/z/u4RaPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=kernel.org smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qktoBEk+PBVVfcIFKrSYG+XBLORJezyLPV01s1TU3fk=;
 b=KL7/+zUB6t7PhXaTtG/44u0OQU8QrFwA9GLTyrfQDSupkS6D2hUhi4qPxjaw2q1UzAsEA3TYrw31FJyMHVDqAX03K4MJY5HRq3OlnAzWygy9SqdJv42yOli450q7D8p8dYNh182TkUyEIhEyA/WJwu7/6ST/iPE7TlRYDHfOTl88jnnnf+zZm8ff29CurKq2R03Uj82+mSkY7114V6ojm4TeI7s+RmFpUV+EhyhchdWHi9dx/3HF3KBwkURj1WsMjbeMi24TSVkJGSCC+GrNq4Kc/nz81ybutMkT3zurRODMf/ZdVlOX1HIvkYTBqcJsYe6cSPzY2SrqxTYiuLH2NQ==
Received: from AM6PR08CA0018.eurprd08.prod.outlook.com (2603:10a6:20b:b2::30)
 by DB8PR10MB3241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:115::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Tue, 1 Feb
 2022 07:16:30 +0000
Received: from HE1EUR01FT056.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:b2:cafe::f4) by AM6PR08CA0018.outlook.office365.com
 (2603:10a6:20b:b2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Tue, 1 Feb 2022 07:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 HE1EUR01FT056.mail.protection.outlook.com (10.152.0.229) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4930.15 via Frontend Transport; Tue, 1 Feb 2022 07:16:29 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 1 Feb 2022 08:16:29 +0100
Received: from md1q0hnc.ad001.siemens.net (167.87.32.84) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 08:16:28 +0100
From:   Jan Kiszka <jan.kiszka@siemens.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Georgi Valkov <gvalkov@abv.bg>
CC:     linux-usb <linux-usb@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "stable @ vger . kernel . org" <stable@vger.kernel.org>,
        Yves-Alexis Perez <corsac@corsac.net>
Subject: [PATCH v2 0/1] ipheth URB overflow fix
Date:   Tue, 1 Feb 2022 08:16:17 +0100
Message-ID: <cover.1643699778.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [167.87.32.84]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de7e0cbd-c1f3-4d6e-2b55-08d9e552c4b2
X-MS-TrafficTypeDiagnostic: DB8PR10MB3241:EE_
X-Microsoft-Antispam-PRVS: <DB8PR10MB324192F64AA6C0B35EDDEB9A95269@DB8PR10MB3241.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3r5r24gCFgcpBIyHeGIijTRiXM9aneQYWKPbm5tTb9B/H7kcdXh5qovnwK40C2AIGmohwYEmtYdMu3YElh67hVfx+pQ6diITkd75JqbUyeDxRBrg/VHNBv8T5Sz2QOQf0/qouusDTjSPijYcyNOcb5XmIAn56rxtPuFJH0fMmuqcfwIuext1zMiEW4B298mW/Gqq9gXEc/S3zBoDW0M5sLdJ+4aQDHQ87JeBh7+4mklHVV9ApKJ1kpDUPvXMEphWBCVjcaLSVlDdCtol+EO/rhRyZ+1ST7VUPma5fuqyr1/Q29sQ6F0zWnyfX6mDTv3URmCouhCxb08Ltx8ka0wTiOjVGjxt4cVyp3BQ5J8+MUtnhT5PDwebwsWSAhzcI8ZidOBOfDFVDwJ3j67hKTazazP722OOqPErTSh546Pqf2/DKewflJQuAtep4KW70PxXgdhB40Z557+oCPzAB4YSPdZ6tRKTeXAwuDivjTtbyVd9hzudjb6v3cJ3/zdfze/TH3cbcLt8VWyk10RaA/pRY5kfReMqa7k0gXfnOpdE8CdaJkRjAT+z2VcXUMpcmZ/6cKXPwIIWkoyhDwVNTt68e3dUDlxr4qHClFSAIKSa8Q02uKRVyhDP/Hx4I5QawfixSN5L+/GnGYUrEvfoPxBzLE3xN0k41BE5BYtmTFCXQFBibGEVKXv12beKoYywAAt7xJ+mrZgiqub7pdiX704htQ==
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(336012)(54906003)(83380400001)(558084003)(6666004)(82310400004)(110136005)(8676002)(86362001)(508600001)(186003)(16526019)(26005)(8936002)(70586007)(4326008)(316002)(70206006)(956004)(2616005)(36756003)(82960400001)(81166007)(356005)(40460700003)(5660300002)(44832011)(47076005)(2906002)(36860700001)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 07:16:29.6391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de7e0cbd-c1f3-4d6e-2b55-08d9e552c4b2
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT056.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3241
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resent (v1 was mangled).

Note that the "Fixes:" tag is a strong assumption of mine. Speak up if
you think that is wrong.

Jan

Georgi Valkov (1):
  ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback

 drivers/net/usb/ipheth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

