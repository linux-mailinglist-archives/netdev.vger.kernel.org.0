Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08D320AC08
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 08:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgFZGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 02:00:15 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:6064
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725801AbgFZGAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 02:00:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFIdenhuQWVaXBQmXAinTspCue+jM63xWtcgYomx1wj4cvajfRS5OkQVmPUStBBxoBK2EjiAqRtRQ1muxWvRTBC3CvCAlWjmHdClRU2MMlIMoBvrJUElszHWivxfIY6UI/hclzj+0d0ZtBwRHTu7b3g5jx5VN5cd5zY4EVO6Kl+dy1Uye9vmWs1A8JX33U7nf1mwcANwGtUd7zWsjexs5LsXM8MQN+Vd1fuA0TiwGeT5KheA8ylluiWqHibFU1bY6rPoxeXHr1fweZ3Y14Ks+umjh3A0T0+3UxCNQ1VPP/h9VTOl3h44VsPaPmX5A7t+xDKRmSOf9Hl8v4mlphiVYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noPbSr6cFO/4LRp7fiuaKhuFSprsb75eQLZJB3q9ykk=;
 b=aO475bM5KYlIXkdpjYQ9k0g08q3lMfu9BaEt4qQFO6cPuMNmftO9PCveBBV56306j0qt2d5DyKDorVkzdcsrrsOTDLcoaypkF/sl9xideTexHQ0CfylInCw2wr0lv3CjQW/evqd3qJcrQuJXB8qAVdpcdaTLtpLWnovPzpJMDdn4GBfzc0Aa1zoicJ8Uf6X0Y1lCit/LHHatMyxlP4wNPrlcjDJJOh+v6Yv6njk/BrSV77ShODJSFLgiOfMsTnv/84gyN01no+JR+Ba9TH+j0EyxE1ic8y1LQQvrLTBuwoj6SeztbXmq+qPUxCb+Tes/TAU9sjW7msgiCFKJsp4CcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noPbSr6cFO/4LRp7fiuaKhuFSprsb75eQLZJB3q9ykk=;
 b=P4+KEUnGVW8777cHcP7VUOhOlfdPAfBp0yDSdq5n2anZVEzCOB6GZnu5t21BlcJH77Lx2G8cdSN8FsKvBZBCD18Djtl2C3sF3Fwg3EaF7ampU42XfYaSPFqbs+O2dgIoKb6GKNYcTAfL4UWJFzzvdN1O/gP+JTTGh6sqT9Wu7KI=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2445.eurprd05.prod.outlook.com (2603:10a6:800:6a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 06:00:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Fri, 26 Jun 2020
 06:00:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Avoid RDMA file inclusion in core driver
Date:   Thu, 25 Jun 2020 22:59:41 -0700
Message-Id: <20200626055943.99943-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:a03:1d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 06:00:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dfd5c27-e1ad-4ea9-6e3b-08d819962f78
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244535A7FCB9230BE6FA33A3BE930@VI1PR0501MB2445.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yV9oE+76vKhac3kDkXZ6g9B1UXFeu7ZCN7+lRFy71nhl7fTI1L+nwg/tCAugjHriR2cqDp/pI06stWBz308v49IwjGxQ7q8GzyyX2xfh4dfFbC3HQB8AOElJ65YgTZKL0Kj6oIWhPzXrLX2eLkrWZs9tvmikspW2b4I2d1TLjrwsZm0mLr/t9gg5KDD+jmZBBAn3xALRHR3UW5GCyvHhtUH4/C9aMSgMy9KjLJ5o1mn3d5kd7oFXRqSCMUIFiG5oQ0E77V3SvMDG70ZMWXUzQInlqbYAUEShJ+M4H13WReRGFjOdB1EiVen+hze/9fUya0kAsiY9J0BdrvMAV6anlDrVfxzYjPQ/pSFqxYA1KfPRa8m8RHftz8PD8wPGmQ4T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(4326008)(8676002)(8936002)(52116002)(6486002)(186003)(1076003)(36756003)(107886003)(26005)(4744005)(2906002)(83380400001)(66556008)(86362001)(6666004)(6512007)(110136005)(66476007)(5660300002)(16526019)(316002)(6506007)(6636002)(450100002)(66946007)(2616005)(478600001)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U3aJr+/UDtga8YlifcoNxhFDXC4V9+gf5g36qQWhjckww/L2mekhHBExQBpx3su2OToc8+kTioa1IHuUSkC6+FIv632Cnsh3giyEq7KEFqt+/QAY0RnqxIVYqVj1xna86DnUT6oFn7l87eIfV5I4oX9NwDEHnpP0hjjWYUlMqi/FHh+P/aduSfquxRY/kAYCqfNp6yK9DJS066U5X3VTz81wmF2mtTNj/dYvoAB0hSZI6dRx6OOrjsV17fS4foMusx7MSL96MmzWZH65O4KGYpHVyfKZSF0hJOLnJo/n4ReClBoOuRRBaVaG+wG0UiDSNKMJZ3pe0laxWvaZZOONYdU2Zy7hg2DVS/Z/guIF4KVlkr6w8tHijeSbfcMngvFKI9V9Q9ifeteq1NDpi5G6UnR3yAWJhhYlVWZPFdbt1tStYp4TaLA0PG5CmPuGJFLlxeOqiusxS4RWwrxadfyn3lJ8BegxAfpmxORe3ywMot8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfd5c27-e1ad-4ea9-6e3b-08d819962f78
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 06:00:10.8633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiC1TSoU8knou5nlcNH7LNcL9iYsch9EEF7/kyo5Em+8y2Yer7k1jT8L7zMgcLAXgccQTDFm3079iPcoRDcKyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5 cq.h does not depend on RDMA verbs.
Remove RDMA verbs file inclusion.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/cq.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index b5a9399e07ee..7bfb67363434 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -33,7 +33,6 @@
 #ifndef MLX5_CORE_CQ_H
 #define MLX5_CORE_CQ_H
 
-#include <rdma/ib_verbs.h>
 #include <linux/mlx5/driver.h>
 #include <linux/refcount.h>
 
-- 
2.26.2

