Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C885430D88
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhJRBeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:34:37 -0400
Received: from mail-eopbgr1300109.outbound.protection.outlook.com ([40.107.130.109]:34502
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242986AbhJRBeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 21:34:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/35gquHYkWqMsbDfzs62Dvy3X3ZnbuNGEDOFDhFxnQ+Oj5/nG8vHgP4xaU4VUvGkS4eFp2YWmKVMHc3185FDIO8PGOgybZSY3Keq0+igE9S9rK/IOm+21FN36xoDMISXhJvsqLxPFaqvt6pUfn+WhcLtY6JP2t6Bd5nBbbz5pU4ayS3Po5S9BRheyJ5+iXKLUfdbQoX9Pa+61j6CX1/OpvnMDdyb86qtKEl0IfN6wTG/1f88kNM8U3biKWgwg/PfkmHwmv6qPKFIahJFVDrUGx+nQ/OVrRF8K7QUQLlmp1dPGQVFHKOZbDOVGDWV8TAU+cxl7B1CikkFAtyZ1zNFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xP7BZ/Mg94cWWW4sSuZbATSOSOzOqb8/Y3mDn/G8Gvk=;
 b=eKFqOOjbyo67Uu0ymkEJkYTZNUD6igQ6q5JgprDMEpvD/t4gKnoTEP72A6cShCdkwXp16FZGFK9pTGsmxxDSnEYtYgOBdEIuPHF+0ka10XkyofdIQrK+4R1J1a35w8F1fUKWImldnMJ75jy3hIWsTdVDOJb2qMOLrQngGpfrPlCZdQwRLqOeLD0nihSapyPMrAA4Po/cVWKp5uAevuEjUVzy44jVysdSbnSiF4qa2SSPKhZnh/JuwTzFHIjpl+rcqs/8p0HKrQwQwa2Q+w5+DqlngmDg623JrSZ6fo5jRgqw2tOmYYNEdg8Byk2K+SZ6l1GSEx8Pb4uvKXW0TPHGlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xP7BZ/Mg94cWWW4sSuZbATSOSOzOqb8/Y3mDn/G8Gvk=;
 b=ascuPidHlXsqfNBnD0M8fCV6qBY+vPdpp7FY/S7pS4wy5esz+74/XTBulIkuIgLLYRrj/sJLExLKMC4LWtB+L4hydq+fY+5r3XVAzH34SEkae8CKEltKur29JLnrteosSFoNNTy+GwbxD8DSvVitZss4WG+eB0D8NcqcoAgkZ5c=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2523.apcprd06.prod.outlook.com (2603:1096:4:5e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 18 Oct 2021 01:32:01 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 01:32:00 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH] net: sparx5: Add of_node_put() before goto
Date:   Sun, 17 Oct 2021 21:31:30 -0400
Message-Id: <20211018013138.2956-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0018.apcprd06.prod.outlook.com
 (2603:1096:202:2e::30) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HK2PR06CA0018.apcprd06.prod.outlook.com (2603:1096:202:2e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Mon, 18 Oct 2021 01:31:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea0e229-b76f-46e5-63bb-08d991d71489
X-MS-TrafficTypeDiagnostic: SG2PR06MB2523:
X-Microsoft-Antispam-PRVS: <SG2PR06MB2523E3E98B405791AE795DC0ABBC9@SG2PR06MB2523.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aSYz2/blw8qn7Fa7dL/UjCdm3Mq9c5BtQ0EJ8/Gttzbxeo6QkzNdLsXcrkemmxsVPNp/+m+cA1VkNvBdOsYmrREUTIi2rKhVwh8cL1qkfyNgeVIecXCJgwBUIQLfwUeHq5a5yGTtOWb3naF61vsP0w3tWoSn1ZlF9u46+e+bgEB3NeV0XtX++H8Ar6PCbyrQBOUlIFwPxQktaaGmZb1cduKhZUKep9wTRKQpVivhiq1lUlMDzstWa6I+Xk4bWl2XJBZPy+1RkVg0p/Drzwc3B0HxUndfudSzmsig8dlgXuqa8Sp7reEeIoXmzVNwvau437eL06mLEc3gqkKxtRRL6PJF52J4VboeQb1N8EOzUKhd+SKOePuIpkJljBh3BJLZSVBLRWES/lbySRDHOh27hQNyoXoxxIuwohoNtxAwthJL209wnoVLwgsPi+1zFGfK+dsi2VJVPRJmRqfqK2Plxyv9f6U+QZHbqxOYVC5e3LsSk4flG+VylZAtKen4mUzg0OJkKCkP+/ow9rYv0jMZ6BGp0zG2yNQSMR7Id8Fov3W9lEk8Yv1EElmctCevq67fUOp2Fzyvg2/Hk3d0/+ddyEhrbLtLpY8KPsN/JUGRQ5O0+cckxw5QniHenGiyitgrfzuso/AL/41rlb46O52fw3CZoPyNkvrDuWxUDpd58rTqp3Rnjin2M9OQuL4SVF/snkfJY5XVfApD8klwWIRUSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(921005)(52116002)(86362001)(6512007)(26005)(316002)(5660300002)(36756003)(186003)(7416002)(6486002)(6506007)(83380400001)(956004)(38100700002)(38350700002)(4326008)(66556008)(4744005)(66476007)(2906002)(66946007)(110136005)(6666004)(2616005)(8676002)(508600001)(8936002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uG45Ax0pqt4ac9tRlApbd5W1SWw0DaZPEjvis7TAlLdlNcDZ5dVHHHuGTKWQ?=
 =?us-ascii?Q?6pkwA3JLW6gAlrLmnJzze4LXljVT3JyADz30HMuMAFvUw0TUjoZDXP7zEHxa?=
 =?us-ascii?Q?zGboCX8lnCVySDXQDcyqACW3jGyPQ12D0eCOXDx+/I3amxdEh4NoBNqwhw/2?=
 =?us-ascii?Q?vu7xxSbKSfUGaUPs+R4Yq3CCO/wf7aSWO83uZQlgY8gXDlM0RfCNp4znbFwp?=
 =?us-ascii?Q?yomkj3MPsYA6XHZX28Cqv74SiXJ7j3Tqft1YwfXB6y1bn73FklzG9qZf2uOJ?=
 =?us-ascii?Q?O9v80/WlCDB722Uka/f1L+NpNhg91CHDuhWyXq3wV88wu1+ud7iKGppMLThR?=
 =?us-ascii?Q?Jg5Lo337QLRQySH1Szu81gHWDVwSm+0YOFs+R1uADT277LWJ4lvMCnUP272i?=
 =?us-ascii?Q?d7ksPbg4JRC+YxrTqrzsRDwrBmar4kiE+kyDtcOrKGqlMPn1RxYdrS5HRYRu?=
 =?us-ascii?Q?+u1xR0rZjxedAQYjXNFQaa4kvYtuvLH9PTOm/Rq0D5y/Jf5VhkJCBZ+yAEIP?=
 =?us-ascii?Q?MZmB7Hgr9HEMpv48zlPKnwik5wy42siBvVwD4CHN2lobHdHZv1R0zTpobsAk?=
 =?us-ascii?Q?MAUuwWVOrIlKt7LFiuaZYqAbeRcF6+FkQjTnKdpNAubML/4L4G3IWx5WG4M1?=
 =?us-ascii?Q?QtVf0jmmKAafQ3a1iAuGA7mLtRBJVASUfJzSnbv5F+ToVDOv/0SSHyE5P7Jf?=
 =?us-ascii?Q?k3LCNeK8QTQgBVy0UM6kfaaTfvYUm7ZgyVZxqUAMu74vWGUYZ1iAxk0aLbbd?=
 =?us-ascii?Q?hRxNCcncj5DsBvnl1Gk53Ei5ZueawJNLO7q9anTWVvqXo8iQcQDR0B4MOpKq?=
 =?us-ascii?Q?ZEZmHFXRbW6cb1PYAozfWYEcYkTPo065sQXaKqltpOrJzpV0UPy2iZW/Zb8N?=
 =?us-ascii?Q?LaBtwrHX24+Il6wA+VWeBboFOKFbBzFcJJWHUG2NHSukoxFkhPfg5wM7h1ij?=
 =?us-ascii?Q?9ODHNFLA+TVRKJVltSRg/Lt452DMMYGVJ5ZcNdnqKxFknxy+Q2c9p6P2Bz+N?=
 =?us-ascii?Q?CoW4RBOwdEXKn8OgyTlFwYO4QoEeRjYCnpnb/r5VgSGHnEd9UIihWOSDZtXv?=
 =?us-ascii?Q?xsgz2ueEgOcD7MRn5JKzgpJEF/a3Hp6bmSRplC5JuBXxXZuotc2QPD6gkcy3?=
 =?us-ascii?Q?fLbCWafBn3zDBQP773fuAFlg4UH8JPqErAFOhIr2LyKT1522eZeqojy3ddXF?=
 =?us-ascii?Q?s235LbrW+6oPwAoppS6K8QSw05oXpKS69xHEsbgMVShabLattJaB2KDO6JSa?=
 =?us-ascii?Q?MYmqYBxNjiBPnY8FP0lvFd3DP+9GKXHaRSs/GVDHLAIO15ICsmU2OWe/UEAQ?=
 =?us-ascii?Q?QkRXDzJ2pukTBSI9VR+fB3tg?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea0e229-b76f-46e5-63bb-08d991d71489
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 01:32:00.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cd26PrRfKYelJu+qVQ1rtrJ5/UnzcITSbfi0IREdou0+6lwVxjkQCgrYKbr4exSKI5cqr0Dl1SW5VGPrHCuW7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/ethernet/microchip/sparx5/s4parx5_main.c:723:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index c6eb0b70dd3f..4625d4fb4cde 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -757,6 +757,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 			err = dev_err_probe(sparx5->dev, PTR_ERR(serdes),
 					    "port %u: missing serdes\n",
 					    portno);
+			of_node_put(portnp);
 			goto cleanup_config;
 		}
 		config->portno = portno;
-- 
2.20.1

