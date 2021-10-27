Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC2243C70B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241321AbhJ0KAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:49 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:54592
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241316AbhJ0KAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKKsfqbK6B8Rpn1gNiBhSQLp1fUg8LN3VBPfahfscHlzlBI47rF0tq2r2xt/0Z0ygJbnlcs4j9bDYSRil5gJDNeTPjYkRgehPIWbFWPtOGZXZVrGlUmgBTYSm0LL9qAQi+WKnTYHqeG6NBI9SWtsSey6z4pi3nc1cUDPd+WuxTqOB/QDlf2h/irvUvcMTjMVuUrydZBZJrZsLZTc6pSj20PV4zwYRu8f09dLrT0O3BVhdK2qfPlqMMrEkMgYoCSyHDPFW7tJRAyuGEwcgYHv7GmemQ3GDZzcX+g5yoZM6TEbF/31QnqGhja3aBtrUlRi6jLxXf2w0I84hDmHnxp6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIcenR7D/1n/5tfmUSe4ryMHmH3CEgWy3oi3ms6Ckjw=;
 b=Ws2YJX3e4LgMvzsJTGrL6iytCfavz6jVncJ7+GbH1wwuz7ngpYEsw4OoiSibgvgAOoB5nXO9ZbkRFlTxznHGNGxNlhONde8DCxMfwDAqDOgPuHmmkrGLqv/S3jG+m6kqgcEdp+QulzgNHbfmyZ4aWtxiQbClMuzpwhcJ3f9TsgZeHpfTPsZyYmKtlzWI6xC0H3UrmXUew2Z7UVNzl0JvalL2FbAU4PEuG8xua2Y5J51vsJCcvArydfzYSsOamuZ4Jlo9O4y3opPwtXU7ESfJ70c1ytFCEcrbjmXFoQ+TcLwmALOgWj7XE9XX+Qxwm7bfGjNjSOcK3EMyyTsN03G1og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIcenR7D/1n/5tfmUSe4ryMHmH3CEgWy3oi3ms6Ckjw=;
 b=EYtKLpOSTSJimg+8iQ7VeZo2aPL+eW8o0NBm3jWI8XFKnEYafEpl/z/CjOUXk13/WarY5MMwPCpexxjxFxTQq6WJmmDS9BpakKUuIS5lX6A07EvBGl+30iLXWOJBA66QnVl7Uuz52D3gwkfu6W1tCueNkj2qfZ5EtuE/l7oV1MjDNUy5EWXfdW/A80Urrwvti7curA5TWMgLB59WYWVyTq05vzLEA53fiGbDk5r3KDc4b92QqL+hteNX59NXWUBzm33WCGtbrmeOe+lL/VSN/I3AZKMZmRhL2ijcpfd695u0i+HZJMH3szdkajcAHuk3s++28OMqsAXbTmYBKNDFgQ==
Received: from BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::26)
 by MWHPR12MB1293.namprd12.prod.outlook.com (2603:10b6:300:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:12 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::26) by BN9P223CA0021.outlook.office365.com
 (2603:10b6:408:10b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:12 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:11 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:11 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:08 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH V5 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
Date:   Wed, 27 Oct 2021 12:56:51 +0300
Message-ID: <20211027095658.144468-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36cf6434-e606-4eb3-db70-08d9993049c7
X-MS-TrafficTypeDiagnostic: MWHPR12MB1293:
X-Microsoft-Antispam-PRVS: <MWHPR12MB12933FE4B4BEF028B6912F6CC3859@MWHPR12MB1293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNz8DMzOqwlt88VK4GUFc8A7P5c8wr7RPt/ZIST4Bhix36wGgHtvv03FxOkxfcn9KQnclbwncG1rPcBiHiybjmTVeOMsjkNT5/Vdm5SVPQu4BTwHoH8pb2qqDRRdU777IgIrSXc/djZJCWbm5rHYTN4ZmLdN8TI/looVT5kEWRFivwthSo3+i/jrjdfMmpuMgs9Un96/yXnGN+ecI8iZIBQHO+a20Fq4DtMC2OtG9eJzg7T9yn+8RV8HPMr2zzDj8LV9QQMLPl36ZZgGfEZeQBkbMxRB6uVM35nG1UcskDatpRtVfCvukHEjRsoDb3moVvuH55uNqmIaqoMu8PpeXFdCF6LST3z4ZU/Lqi5JBLHcyRtUbG0xh/qD+N/ndYJAQsim5QwWFi40tUReluH/ZxE+N3dDtOrBXyT+klQBUbOXCuBgDvurZLFvdSBj8UHpEPEjk+nbl1H/0O2Y8aXAzLFOdwid+JYTeEH5SHVaYBG1BU2l8KwNmjRnsUnILL9q5VJmL6reEohz92XbXxxGfbl1Tgsp0Ov9ThiHAonw+yWk1bXKTIEufjBfkBkHOuBgOWmtynYzDnvZXxPTZJz7UdgKHmYq9hQX9bwD/7D0uajYB2K+L7w14ll4POUINbiVRIMgybJBO8cdJPSiKfZDWZaJjfsGND5v9FMQpSJ/QTpw83xXW+A0jR8hwKmCNbHUv6MuIQyk+gbCRVeVrLnh/g==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(70206006)(47076005)(2616005)(110136005)(36906005)(356005)(7636003)(70586007)(8936002)(6636002)(7696005)(508600001)(83380400001)(6666004)(426003)(186003)(316002)(54906003)(8676002)(4744005)(1076003)(26005)(82310400003)(4326008)(36860700001)(36756003)(336012)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:12.3341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cf6434-e606-4eb3-db70-08d9993049c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
instead of STATE).

Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/uapi/linux/vfio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..114ffcefe437 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -622,7 +622,7 @@ struct vfio_device_migration_info {
 					      VFIO_DEVICE_STATE_RESUMING))
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
 					     VFIO_DEVICE_STATE_RESUMING)
 
 	__u32 reserved;
-- 
2.18.1

