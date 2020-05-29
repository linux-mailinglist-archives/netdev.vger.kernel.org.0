Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668C91E763F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgE2G52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:28 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:29351
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgE2G50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3oEKi0zEwu0/OlH4CXHxlX5FPAI/2bh+MD6sOXW3D61S+T1YPpeVYVFWw3iUn0y0BURml2MX3VBiGoK+CatHDizMo2am6JmsfmV5o8SRzTldL8YWbIYQ5A7XfDoNA7JXQB7cpkCeTXFW/PmdWjYSp7lMu+B2wmy596c9FDPi9qp+DvS7a/yg+ua4sKM7TQDGk14A2g5KhM6vfRhtP/8f4k96f7MrPCISr6fCzeMVG5BxlkK6Ywv4cXBjRCAtM/gVwRSpQOz5U+w5H4tF339BZyqVO0M7YUTfKmrKpKFnQaI2pnPDIQpT+5bLxOlg82qeM0tcNmAsH/EJ8IHBLN0pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsBLXdbXDBYiagQX1BG+nR+LSnWEMnxzCXY94vIxTJA=;
 b=b0zTbm4Vi301JeuNSWH6fDJWEhkcHMq+b83pqidaOQIIq08FXvspgBQSg6d3AzPCbAvdo/514UHYw7TU6ouBZaGnVUGtDQsJJumwdqXZCaLyHX0TqruhINSQqCexYoBckqHQXEBJrF4L9bQooQ2ZQJouPr3L3/6/VF/+Wq8eGcV2jIYs2b6774OBBu+m93/ueme2uHCNr0rQZZjnzs3zjzQs9VnkrqBsJOAoIx9vIo2/eLdGpo2ml+fYkw9n15bbS5B+dHjdaM5Tk0kIPTU/ocLtreVFAfQYe8Yhl0bAx1letIhQlH59bRRbW0dv7wtaCfi5IKzNX4WoXKZmabGlhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YsBLXdbXDBYiagQX1BG+nR+LSnWEMnxzCXY94vIxTJA=;
 b=VXb+hFGQyaA7JRjdlgM+BV0RfJQmMfWzzEdxfccVjDiIFnfzCj6Q2Haf1AjDiMoJ7cEDfLFom5uRsxrl4uQAclDjlcuC0bG9sPbrOL6Z4AqX9OL1OttwC15q4evxwLHj39fBj2RfbfIGhDv6Ubmp6bnLO+y+RBnL053gDDuoGZE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4189.eurprd05.prod.outlook.com (2603:10a6:803:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:57:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/6] net/mlx5e: Remove warning "devices are not on same switch HW"
Date:   Thu, 28 May 2020 23:56:42 -0700
Message-Id: <20200529065645.118386-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529065645.118386-1-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:18 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e67c7a9-27f0-4348-983d-08d8039d887a
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189FDFFA1FF0BF30A32CD46BE8F0@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OeBPJ/qpKq6APA4IVRstx8OM2NSEkT8nHSyvgquDDkFPWlhwSqmIO5XlNXmE/E8dwin6TMjXnekAojNrnhgrLe+xQ5Ay2JNG5HLJMehLBHNqpZfyXmZv3Qo8kEDl37zJrbhsVBGy2N6iE03syHrIPVtcid24xgdwzwUQ3MXsaLnb0zsAc7xNnSON2/oP+To4sMPjYCoU9ubgRkb+XHYQXZvavEnMgonro30CHuzXgnwVcZdirroyNYIhQLInEgpPO+IpM3TzYQeOV+zsdEg3hoZ/HSv+Q/SUyRKIwDjKLyai/L21Jmwd41qC0ZP3ckUt5QhnyLSnUkk/v3oRTPR1AUHqePWEfPSQDOM5ex+hW6pdBpPdtQlZXChohaJWgjGd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(26005)(1076003)(66476007)(8676002)(54906003)(8936002)(66946007)(66556008)(2616005)(107886003)(5660300002)(956004)(83380400001)(6486002)(6512007)(186003)(16526019)(52116002)(4326008)(36756003)(6506007)(2906002)(86362001)(6666004)(478600001)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jr6XliJ+p2cwg+kgKsgVaQ847QUm6g9PvoXqvtMgcgm/la/Yt+LQoakdCR89/Avc2fr/QX6DpScn21RDLMIcS3+k9Y5flpnU5DidwId07a+8gG7G6Bz7pADZrjp+dxHTUBR1YZSpHkwfY0PhzeSN3Co0qWSznPaweKWKFTabjdxpxmpNDC6rB1GchhrCnsJrPudV90DC6JO+l8YSzm3emosTmwQX5TQ+I1fG1SkkWRwFy2Lf5iW6J7AXuEID+lDozZcxagCueFstq66nG/fDWXIhTtNv9xp0v2EffJSvb0nBn+Z9QVy9mgzTdNyfvhPIeY9tGmfsoN1QAT8VhEjAFt7twC3Al/2dDWm+YWKi8EBXHD27NUqq5Yl1qp30GFhhIseUgUeOxJ0MMrhqUY2VvKzyFoTCQ32RWLgRBnTma4sJVSGkMqcytsiroCAj1wb49JGu3UwClGuRZGBjQoMldEvQDWsxo2qcTfu6XwvsvBs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e67c7a9-27f0-4348-983d-08d8039d887a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:20.8988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xF7A6aQkyEREws8Hv1PNesPjsy9pfGpN9S7NHCYvvEktISZcEWCbbI6pN4cpS8GbtG4+KnzyweKhfOjQvjCDzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

On tunnel decap rule insertion, the indirect mechanism will attempt to
offload the rule on all uplink representors which will trigger the
"devices are not on same switch HW, can't offload forwarding" message
for the uplink which isn't on the same switch HW as the VF representor.

The above flow is valid and shouldn't cause warning message,
fix by removing the warning and only report this flow using extack.

Fixes: f3953003a66f ("net/mlx5e: Fix allowed tc redirect merged eswitch offload cases")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cac36c27c7fa4..6e7b2ce29d411 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3849,10 +3849,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-					netdev_warn(priv->netdev,
-						    "devices %s %s not on same switch HW, can't offload forwarding\n",
-						    priv->netdev->name,
-						    out_dev->name);
 					return -EOPNOTSUPP;
 				}
 
-- 
2.26.2

