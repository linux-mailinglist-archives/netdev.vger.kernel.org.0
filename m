Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F80A21C7FC
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgGLIEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 04:04:42 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:7664
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728404AbgGLIEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 04:04:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwSUyaCuTuXno5eSLnJQ2HLgnuhWlOcYwZ8mOfDXskE55V/2vPcOM0ntCGM9UXQBmctOAQq5RqfyRNueklNrbIl9Z1Y8978XJr42FJOrPhErmXS/xBBn8avcTbZTw7qmQcMqM4rPIibe9ZmKL7/csGiYm47aFcof55boJWtMFPUUSi+A4mJk6ieUCaZVR4+G9P9LAIu7e4wvOLRup0RYVvt6GjJDwAg1+v0zlN7TPHnc02M3kgHnrfoTgxa6b327b94UR6q/+uucRQl5jiF9rrUtr/V8pQXu/+meMqwCwayA1KXZD5OfYSkBadf0Rkx0MmjsRsRU9SQlQADM1S2aAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jn40u+S9rbDkf0g/cWLwWqgQEJ98KeZXw3dDPSF+0/E=;
 b=jNpX4utdjqJANEvuJ+TGg2K6BRfQ0mL8DG1MOTaxzSPiWoj55eiSyL5DsX/wqqFp3MdT2jcn3l/AiEz6ZRdK+LQnQB7iDDKYK55tTeiA5W9YhcUnxQscEBKnUJV91hX7aU3VIgVFgvC5IerEKWZzMVe5YHTfSxmkHJpJHqfoFAYujLaVogGH9U0lbZbVmqhFPV7avrOpL58fEdLPMVN4ywXNXdz4HZi4gkcC4oEQ7SI3X2flVZDwd7ewt5CzGcRGzCo/pl37ImnV+21rC23C/dqbpDmtx5OxS8mxSWEWz8rbqFu9aMbGKHesV956g+CTnFR0ALPndTgGzzGFl4dJig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jn40u+S9rbDkf0g/cWLwWqgQEJ98KeZXw3dDPSF+0/E=;
 b=MVsVx9Au2oOj4GnS0b65W5f1hVETwLecLDWky0fbs2MTrSOaxN8E054Zm0dT+kPuL4aj9NNaKMO5QM1kiZN1DAKpaqlM/q1kLPz44wvnyQumY5JmlOaZIzZbIq0eXj+PhVUlYcM16wmRhYJ+Chepi1Vwy4zNlnsWVeFF+dA/czw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5634.eurprd05.prod.outlook.com (2603:10a6:208:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 08:04:31 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 08:04:31 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next 2/3] devlink: Expose number of port lanes
Date:   Sun, 12 Jul 2020 11:04:12 +0300
Message-Id: <20200712080413.15435-3-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200712080413.15435-1-danieller@mellanox.com>
References: <20200712080413.15435-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0018.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::28) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0018.eurprd09.prod.outlook.com (2603:10a6:200:9b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sun, 12 Jul 2020 08:04:30 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15016744-7d0e-48bf-ffc2-08d8263a34ea
X-MS-TrafficTypeDiagnostic: AM0PR05MB5634:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB56340F1E8478E89294C39A2CD5630@AM0PR05MB5634.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 92Tjy8WtqjqrBSKcqLEM9JskAVVMJm6fkHKBLISGfyxnBTvK11ZGf4wEpUe0xXQvSsYBVw40GSVpyHCZ+xgAnLt+OCudvkgd9nwvMOQRPvAcF2RbBlSpFa8S8nw46lja50hbETi+RA8iOAZUSieOLRSF1wERGFwwzCLQqTokrU8ysmurKfOaeuOsG6aixyKduVGI/y1X8rMLQ3ll6uCYAgbGECXsFftUbP0OZK7PicnelSO4XrgMoJ1jckP6pyffNj2Vyo1wwRv/qGE4nLz6zYaJE2yyN+lDbNb++OvtwfYz4yIpD4/Hxcf8/5CWlnAy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(376002)(346002)(366004)(396003)(107886003)(5660300002)(6666004)(316002)(1076003)(66946007)(186003)(52116002)(66556008)(16526019)(6506007)(66476007)(4744005)(26005)(8676002)(6512007)(8936002)(4326008)(86362001)(956004)(2616005)(2906002)(36756003)(478600001)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2jecPBmgW6/siUwJNegGSTTiEpAWvAf17FPguXpTTkPXpE7qu5DKKUic2Ixd+5ZGUHPbTQUbeeKtI2ABxsAb0iyp3enBujDWCombbrwaMF+YqN0k50hWat+RZ5zDF7aSEfk/1lsrDhvA5b4KTBakTPtk+aMB1nHj/s8jXt4b2lt2dz4zwLFGlP7nCPf+NeV+9vc1Upq/2214WU3dVDIpe9ew9BconDUWYtL9lizyY/JtO5LwQKES+7HiI/tqykVf3lt/mIdt4NLhJXSE4F4NOBk3nHvMIKs0zGejM00sXUcl8txVcNFTNuu5rfk6UdaNnel5ZtkyXOIX4z+FL1M5pSDriFU5AASQ1M/0p/8iy9iYtZvGrIFan5ri8kq+/UU/ng1kXl+qOrVhUx4liFvDZzGGPc2RtksOKsr6SjlF/kObxndG8SogU+L8mtGNfxPV4AiWMeLrNmc84OSn58TCpAPNZnCCthkzHHnCzU2AXgY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15016744-7d0e-48bf-ffc2-08d8263a34ea
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2020 08:04:31.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18HzRiPzf0EuEFGigU6oH6x1JvL2rNqPWrwjwGd7KiZ+Y7YwQEMxi5K8D6SZYNMq3odnPjAgvZTNOYSBm7OI+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5634
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new attribute that indicates the port's number of lanes to devlink port.

Expose the attribute to user space as RO value, for example:

$devlink port show swp1
pci/0000:03:00.0/61: type eth netdev swp1 flavour physical port 1 lanes 1

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 535c98d1..4aeb9f34 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3398,6 +3398,10 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		print_uint(PRINT_ANY, "split_group", " split_group %u",
 			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
+	if (tb[DEVLINK_ATTR_PORT_LANES])
+		print_uint(PRINT_ANY, "lanes", " lanes %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_LANES]));
+
 	pr_out_port_function(dl, tb);
 	pr_out_port_handle_end(dl);
 }
-- 
2.20.1

