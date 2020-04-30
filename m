Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A9D1C026C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgD3Q0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:25 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727065AbgD3Q0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePkUteEw5WvFjh2sXh6QneMLBGZ1GbWCIH57utmufaLVbWznS+x4jRQ9Sj1sgqC4lopHERYefTy166+vf4Dk7k3nCq7nHP/8bqQAtPJpStjaxoDZljRAx/m3BYvixSZ75TIny+5Sq4nOZLYISBFUVnOW5agVW3guPj7Gk5cIK2/ZSoMYlCBigJ6FKk6XpzxLQWl1Z0PH7MYJZDmytYtlvinCZrTypHcLI7ZudDXCDGobKddh8eONcs57Y937vKwVd/6Sad9W3OjIxmWYYMp59AwiwNvPMYkNOMpMwVnDqNRcc2U8NncipEcVni3zb1YZvT1Z2/yGKuPD2Z8/y6GevQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUUfQGm9dEFRtllrurkLra+TvryAZHLiXCxBc7Xzj4I=;
 b=NzIH5FLjy/1XHu3ZRf9sMuO5n8ZOeSSMXURuTw1QV7cjewqBI0WuECckiXPVNgeimab356JU/XO06YUD06CVi5ayzocCs9hnQFrmhQ00Kz2H/jR/13HeDlCQ9H9FG6PLt0nHPZ9W93z4UeksCJN4Z61N9J7McEWvGFaK521B5yb5v6TE4mT+i51gZz9xAnXScKMQ+CLvcVq0qLDfvJJZ5y0YMQm7cik1hrBvP87iAXl0SXeKa8+huKxygAbJgjJf2xJSp13bWAGHe4V69vKEA8tUhHjd0HbikAyKcMliDIh8lZPfvCy2tBx0+zpppx52wFBi4A54oN5ETo1dXbGeNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUUfQGm9dEFRtllrurkLra+TvryAZHLiXCxBc7Xzj4I=;
 b=MX7SM6OaUUEoOG4Oi8epR+Vpgfza96mVyhZ+QOX1/Lat+ztOxK8tLqsYtckVp0gD8f6oe/WXu/8Whw3u0CfcJalm9zoJW3O0gEhN1wxQlcKRATih0R2v1wdARn9LndYWtkiD+yKahbPdyFEO/AGdnDdLeH59i5d9el2oInCMwnY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 2/7] net/mlx5: E-switch, Fix printing wrong error value
Date:   Thu, 30 Apr 2020 09:25:46 -0700
Message-Id: <20200430162551.14997-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:18 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b4d83cd-3bea-4fa3-aa0e-08d7ed2336f0
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376C46C5EDDB157469090D1BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dmJJdq8zl004NvfEQ7Jh7GbO4Hr0QLWEVKnYMr+swPntU8zjsZjBzFifRCSce2b8tfJOOhRl3REVunFICO3XN3fXD6GIrzSP8a50OGmDX4qH/KqbxY4EVQrnGcKV3dR8c1eeGYeqcnUy3fLk+D/nJlKNsa0z3/ujASDZpLkkS6A64wcMeNreCFsM6GHiAl33GoPl3LJg+h7Gzun/t/geKl01vCR+WCRJZ9mfSlH0l7OMOM7WUOLBFBkrvm6bj+UKwuB1wiafenXqjEYmj1miPh0puT0lexn4cKMuLvPh5em7Sjy2t6zSIejlnSlXCHNyT4lQeW/VDhTf0PjPnNTWJnw7kIzmnPpPqtXiTqhObwHiwQwCXELlB9KX8u8H42JGsBWJtCkAbcU4Xfkq0rVCCEOa5wXSJKQh2GLtaPbDv1uF61nEBcZBKpV8p3R9Z4sNXVfUawdZFb9GFAzxiOefLzhCHZG1F2j94DDjpSqOqfJK3K38wy4dhR2Ki1mNtPl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BJLgnf+hOT6FfO3i5jWMdI+yj1TZppSrmBAPyx0jWQ1uBFwN9RDYeCgUBBytLUtpHaIKcoIeoo2vNs7qj3i+eZ2w7V1/GLZJ4v7Vh8TWeg277toJ/6+lFGg50UsV7SUkMRjAidc5tOa1wVe+eqJlrKyFc4ktZiKm3e5adRqRx/dndvueKInXORrLooi98ltFsacSlOGICSIp1rcm4SEGl6pQbTabaKfza9r0I0LBhLLioU5N1NppEMi2aUB70IDeqGNLOrwUbQoYqYMt6tCkN6R+HWSwMGypUx1AQuiKKr4+a6Si+aN5LcHFNBaQUvlstwAB86G0f9ob8SEWRX9/4WhZMWc/EHVh0MdLS7u2Dla4ljKRAlYarHnMeN1fCgYlCtEm6hEy1k7XtxxUXf+/W9O6pQQTJ0vhkkZRkJV3DSKZyChcWV5yD4+UBBRLCUiWt9il9Lds/OE4wQL9Iyc0D/SstLfXs818D8FU1EL0k4XoPLBViDyk7mQqr+zhg1NUce3Dgk07W6zn6x6wd6Fc26SbiuW3YK2xLHUbd3qo5LhY5wEIEMdEj2jG0+Z/JyS8NAOPMasynMtJE2vrhmTzwhVfRXMnFZOSRY62Q4bmLfss8JIBpNn42XfPGLdAm9F4RJLeQkH0knN5rjSWHwQY8jaDtMHi80UCMUOhStS6bQvvbS1/gZ310EFViMAPrJVxVtyV+rYcPuGI6yjJ3n8ibEevxCg0u+mqROrtzcmtR2pi6LYWQXF6DFCYVnmm/T+RuF7KeDbsJV214gt2Xn+ZSJ3vXvGXG/oTrvyP2bZvVcc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4d83cd-3bea-4fa3-aa0e-08d7ed2336f0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:20.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLjUlMprN/aJ0LheFnPm4rf8VRF8Qj3qiW+8IWZ5Zbrhxn849QFuwxbtsVuQi8vHWfIxzA3KUDlAic2uSorG0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When mlx5_modify_header_alloc() fails, instead of printing the error
value returned, current error log prints 0.

Fix by printing correct error value returned by
mlx5_modify_header_alloc().

Fixes: 6724e66b90ee ("net/mlx5: E-Switch, Get reg_c1 value on miss")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94d6c91a8612..8289af360e8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1550,9 +1550,9 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 					   MLX5_FLOW_NAMESPACE_KERNEL, 1,
 					   modact);
 	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
 		esw_warn(dev, "Failed to create restore mod header, err: %d\n",
 			 err);
-		err = PTR_ERR(mod_hdr);
 		goto err_mod_hdr;
 	}
 
-- 
2.25.4

