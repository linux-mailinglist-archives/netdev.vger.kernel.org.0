Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FBB494E05
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242644AbiATMex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:34:53 -0500
Received: from mail-dm3nam07on2080.outbound.protection.outlook.com ([40.107.95.80]:10593
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242590AbiATMeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 07:34:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXEjJ1uWiLF4fOO+itkb1dUgWt+ulGXU2biQFxKcjLXez7LB3jNNQFj7iHjxuCsap7X6ZflHBxjD/68fE3xyOS7MEdIbWrAbJLi86VrTINiwFNTuPE1nkTEzh/hZtMgvQMf11LzR3Q2T6hk9QsxQxsxJGNE2w3ywa3gyauiaRA3XqvssztZc9C54JuzCuThHjDDqLpZiBt7+qT7kBBNz+/UNS6a9fc44tsvT995sTgHrkqJEDpvoS13pXqXZHsS5U24y17mGLJ7q5y/masesngU5pGAOMxXQ8tqAZVYkczEWEB0cjxV75LMg0mwh42ZsnFubQd6VT40tIBETs1eUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iE5Y/Jqx0ezYCzTe8bDNywyoAZfV2cQGoSf27BPhqIo=;
 b=gYe7Kbo4Rg8IoeW/67QkAFcqBQoPIzPGxwGi5Mo08sk9omsOZEqljM8NpGeKa8fJr7mN/04yEsd/JTyLgZxwqogF6fRxvSigAxzWmfmTp1SVu+GzIDnfakpHlellzUkqE0klQfmlqrHqCV03Jo6QMMvAZnQMpqd0bbNCpxPohl8NAhj33ApFAx2ZGhBQF462X2s3d6vyhb8SsAp7erCy9jR6AeOu9y6BgtC/3XlEkb8awvCSl/fHbngZBt/eMzKkd+ncoYQqSZER8SKEQXyQ8QNObazNdLhbtEj+2Jho3HlMJpxAz2q66mDGIrBIsc20nmQhXRclMfKA2Cz8YQBljQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iE5Y/Jqx0ezYCzTe8bDNywyoAZfV2cQGoSf27BPhqIo=;
 b=EbJ/sa5JwB3zzALp/hn/71Siefu+9xIYwojVj7fXK9lc0KYGu2mN1OtnAXZmJUFTLmGKlX5CAe6RsxDZYdVd7q5qvIMs7WOaX9YhM170P0OEyAfdGCEz2ZSRbCfsXPlBixEY/dlovHlvJ/tZga0k7VpfEWY1tufkjRZEw33ZKHQA8KpS2Xkob/1+AozZ9TQvnCaybZxc+0NIwBZoqw6ysnAkO7vwtUbzNozzbnF44dHDNFPXx9ONdtOCsQJVbc4g+vQACaD/7DSkMs4HMV0gfgFpnsM3/jWFRIaI9/8fFHyNAy4CYQDGBMosYy5gRh0snQDg0eKYLnKxb0o96n79Ig==
Received: from DS7PR03CA0263.namprd03.prod.outlook.com (2603:10b6:5:3b3::28)
 by DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 12:34:48 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::40) by DS7PR03CA0263.outlook.office365.com
 (2603:10b6:5:3b3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Thu, 20 Jan 2022 12:34:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 12:34:48 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 12:34:48 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 04:34:47 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (172.20.187.18)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Thu, 20
 Jan 2022 12:34:45 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
Date:   Thu, 20 Jan 2022 14:34:40 +0200
Message-ID: <20220120123440.9088-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4d7edaf-d065-497b-bf3d-08d9dc113f7e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4385:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB43852E34EFFCA61EB5DFF837C25A9@DM6PR12MB4385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJ7BZwKSlV19nUZfb8sum95+S/+MxsUkpfoyXpUaiJv9rolthOMUFW+ZysAwx5RIBr11i9GH3+Ly1kkE/+5Ng/yXXO/zwltQhJAwBFGg+5JWirbVnLVkP/gco8512wUkjKq5dVWdE6qalyKk6A3vJ0SfyxlKgn+Rvh97rfyRSaoPoHn+KErvVGjWxAOMehhlNreVs3cB1uFHW44B6khh3lynIHlZOb5NxuHaOtq10ba+j4zu9Fc/puuBiREBWf3nmT8LHVn/N/dOxGRwjOcXW95M3yolN2zEpeAfz4CWwdz2+bEHa7xDvInh6DPGTzkOeqO1c9OeGqWr7SIgZ9nfLoYNVPZvfnVvE0Oz0+4eaQtEL8HAURlPgLuf6B4G2vY9Tr3kUk0SqPM/3/6B83j7ZOGsYWzfnNbho85VPuVSdBMsZKWEWRTJgD86HLwCjD/AbgfBPxwYdIWe7jnDB7Qb2k55IHnit+Or0RySj0UhU+4wsKvyaPaeDwaBG5zIgku/dv9wT79ufj4RsNjVE5seT1aFf/9xi/TwYZD9MSXQwHf6MAIGL1kw+Ht5wmmgTe2QJMS6glvSv11VlP9UFO69mE/4rdeyEZheimOSSzHMM6xkm0cEJxiT6gWTgw5CMPE3ISkVei8phD8LwLUK+jfMxm4OG9tfphEiLkBB86251G9HREuTO6lAmIVPQ35xPaZkytys/7R5JNr13CIMp+K/Db5EN5R9c1cksykBIuCaYsmYvWMlDIM86GBsSXxKi397qN23Mhq6wWobKMdWBJb5NFe0DVZ3aREg3DjoK8TzKqk=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(36756003)(1076003)(82310400004)(186003)(36860700001)(81166007)(6666004)(508600001)(356005)(47076005)(40460700001)(2906002)(7696005)(26005)(5660300002)(110136005)(8676002)(86362001)(336012)(316002)(4326008)(70586007)(70206006)(2616005)(8936002)(83380400001)(426003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 12:34:48.6211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d7edaf-d065-497b-bf3d-08d9dc113f7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling the kernel with CONFIG_INET disabled, the
sk_defer_free_flush() should be defined as a nop.

This resolves the following compilation error:
  ld: net/core/sock.o: in function `sk_defer_free_flush':
  ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'

Fixes: 79074a72d335 ("net: Flush deferred skb free on socket destroy")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 include/net/tcp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 44e442bf23f9..b9fc978fb2ca 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1369,6 +1369,7 @@ static inline bool tcp_checksum_complete(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb);
 
+#ifdef CONFIG_INET
 void __sk_defer_free_flush(struct sock *sk);
 
 static inline void sk_defer_free_flush(struct sock *sk)
@@ -1377,6 +1378,9 @@ static inline void sk_defer_free_flush(struct sock *sk)
 		return;
 	__sk_defer_free_flush(sk);
 }
+#else
+static inline void sk_defer_free_flush(struct sock *sk) {}
+#endif
 
 int tcp_filter(struct sock *sk, struct sk_buff *skb);
 void tcp_set_state(struct sock *sk, int state);
-- 
2.25.1

