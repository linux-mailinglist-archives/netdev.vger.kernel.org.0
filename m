Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265F81A2C06
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgDHWv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:51:59 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgDHWv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6C4UNAGDxKSR0IYhz597ghT3zLu3Z2wx9t5PPc9RV48TUMOwi9DnN5ojmeD8L4g6oSVGsG3owmxki1I2R35s8QPiBQrIHnFQzIJ91WYARw7IfNQ5pEYZJZmMnmy10bQsKNg+lnvajEv7BiaQOIjUwx6GZSDfcU8bEr+XIvgKIVDcAOhhMFFCx2T6zOupNojyNafjuEjWqxoElajJkHLocF3Q7NZ04RNNHlsfCsJeQWoqDaYJe8q+qUdz6mkQXATnY2PX8Qe73rdAFddeimByojAQ8PyC7D2A+/GdpaE4uYS45rhNmKQB0vcbRwad7GyPMoqMnOU+HXkMU52YnX6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UKYvM+YRgl0+t7i549hH+IsKsBUcDYEWKnWIj8c2oo=;
 b=Tge2R2ckELSFvk1+V42cvVS2EaIjfDW9FPtEj5DV19V7tLiJ1nhkbBV79F+/aJZv/thLlx09Fa+g2I35s6nPToQFfTsblsW7hRExc7MfCIezEk4RnTl7AoEZN9b7KKCtvCdaZqwzX1RuS7QENHYagJW940xeGk5VUbwvEBhFFOiXVKjK8DOP9/6qAaXjsux2oJ9IAFhW8eAWAQ24YpQmCXPp2fsYt20bniEKvOsPvgOSVwLChQEuoIyaPGfJxN9ogJXu8t78DQtLgSulocKUUgjkqAONa0FTBP8CgsvnPIQ5J3XfQO7P08i0ewuivXr5C0wRjd7wwafLIMilr6G1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UKYvM+YRgl0+t7i549hH+IsKsBUcDYEWKnWIj8c2oo=;
 b=gZYodSG6POWezmpR8J6Ivd6+cKyDlhY+ZP3agKUxgXEGn5O4NjTv2xYaxe6g/pnDZ02WYgB7verFYj0HZKZZDjKnD2G0syv2GNg4cCdeWFTDAiQV3D/uTT0I8lNelAmXkuY5uR5W9o6bNPQx34FQ5rAIR0cDwNVtZ51R4OwNFVE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/8] net/mlx5e: Add missing release firmware call
Date:   Wed,  8 Apr 2020 15:51:19 -0700
Message-Id: <20200408225124.883292-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:46 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7156de11-1619-47b2-fb6b-08d7dc0f6afc
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB636542692A8F7175F6D2EB8EBEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MftA1DjkMPP7B05COkp5jQlxIda6dbSYs/QKZdXXRDP+MF5LV6H0xxwyKIMk6Ugs04gdEmEUn5CGJSiQl6jo6CEQGM/iARAPh68kfKXxeQTvd8Xvxk1Kasg6tPXR921AgPV2YMZIF6L6N7ctRBaJFKpHp2vpVfMkzcmZ9hduIT0oyKfakHTtBPec2Gb1Dsay0sxcS1Hxr0VPAKHH9f3FptXZQm7j5p2Kt2zcFimVfpzF+GcOnNIWUnloA0cW1lfyFGEyW67vmgsaTG0vkggPQZk4jCByQ7veeXTeoEozNa3qC6MK7IRQzavPFwIWvdy1FqULoJwFH2Glja92HeCgx+kXsnMp0RhAK+0xlxjn97/4H1kGJM3k8NafZzsrEkSFOwTr6gnpnHGQeFFsJunONOQbO9LnTkiicMDcxChl4lPJm6EqOL7ysJMw4eKZ48hWuSAOc3tG0tdq1astn85aoH4AJ0HscJRfRBGOFyeL70gWBzo7GR/Lx6zzUZa2PwF7
X-MS-Exchange-AntiSpam-MessageData: XG/OY04CwfbD5X9+RG7IkWiJFruhbpjlR97FPF/0SBgEJY0VqwFP+UTcfhR8Vkd13zuVaC3IaGtbQLpnN9re2SiRl3ozmcCRHOzIxQ+tU5Ori6OZklYmOAN1V40aQ0pNc14yJQm6dbdodkPZZ51STw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7156de11-1619-47b2-fb6b-08d7dc0f6afc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:47.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9G4VclT4CWzhbvL45UJaD9ezwR7ccPVzylq9BDOBAvKheoGkVYQ5nvkbhFVRnFSudri+MiVYl0hqT7QGBaZug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Once driver finishes flashing the firmware image, it should release it.

Fixes: 9c8bca2637b8 ("mlx5: Move firmware flash implementation to devlink")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index bdeb291f6b67..e94f0c4d74a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -23,7 +23,10 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
 	if (err)
 		return err;
 
-	return mlx5_firmware_flash(dev, fw, extack);
+	err = mlx5_firmware_flash(dev, fw, extack);
+	release_firmware(fw);
+
+	return err;
 }
 
 static u8 mlx5_fw_ver_major(u32 version)
-- 
2.25.1

