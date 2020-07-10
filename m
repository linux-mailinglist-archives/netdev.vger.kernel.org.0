Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0015021ADA7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgGJDrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:55 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgGJDry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVjYqAaPIwopKOstC82jjk5UI42nus6EY0X1kpoOhQ3oBrkcoY6ohBbNj7AHQsqeZHwSb1aOLbYV4Wy9Vpo2f5BrvSwVuT+KMfBj8rluiFAJCRbTh2w0sUMQfibVOqODsS2fGJ5aPbgLhBPktmahSYwzqEMJLye/ybbhgOD48zkpOLrV2VFJHHPxoakBPLPAx4PgSWugBhLmPNb2mtei/yAxN3axMtb1SHn14uCJ3vvlNbfQLFBLkk6JbXc41gZ2nb3cFUD1j+SYJO6YLwgQ1oKgB3Td01omNZqNWsLxPn9h0yv9/0EGd/fmPTngWMsD2k91cJslNNulmSBhpaeEGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8FiiQMJBjeNhdqYLIX5Qo3q1TNCBJYXJtRPPgLWxJY=;
 b=NovfHiRD7ikI5/RcalVFX9I/XpJ9zxmBx1IF8eF5N6RtY5Uh/XJ/ofJUrDbC9MLVIJwFBoY+yGM3swyiXOYNd2wLzxRE/L4axFYFwRTsw2EC7NUZeTJtNWx6PgcVEsoMde+bThTYlsWzoLv5mA+Gm33GTd1CKJ6bMOoYmTwEKje4lm2YI1al2q4SQ08GK5ecZlOFfrXzIj42GMyV5bJspcU4ckiQ0TrQI0LyeLxvXlBeBbw3quw9t2A0ZaEUJ6kz0mChCk8l/X7GMrNcdcSU3tnLlbDlQsDMA1WphtRkn0lJPRHvHlizo3MJ9duxZ8ILCz7+eYNGs1u7qNudzDkAZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8FiiQMJBjeNhdqYLIX5Qo3q1TNCBJYXJtRPPgLWxJY=;
 b=mXFQ686mzgksmxFNfH1x4B8dKAOZrDHhnKdVh7yq7ZvUegpdPMFvKqkcbILXO2BqW+SrcAihjWKrGp4xPke3hp7eHlYBZyWtLWIrV4Q8uyAR13toIRiP1KwWJBeYWxa+SxETKk4uXRHcSd1PZP1gwsJtLhTggFCulqhWmB2MtJs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/13] net/mlx5e: Use netdev_info instead of pr_info
Date:   Thu,  9 Jul 2020 20:44:23 -0700
Message-Id: <20200710034432.112602-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ff0a43d5-cca1-4d20-9ce1-08d824840337
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512A2B9E0635B40EB1D56CCBE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UzBvT/uWIUai7IPtN1EGBuZq2dI7chNNRh6/v7eJsnxDlvGSKYyPSJZ8ffcO2PUkp5zli+/eIuHZOgUXU6RylkRgsJbCtqh7bRy6179t4bfj2u2+Kr05+6LLEzqLeyasJpIikCp5xeVF4+fNrNEvJ1fRR8ZmXdqK7/foJdduovN+MwXsoXxQPIOhbUgr+jv5GEtpR5DNjUkT3GIB2ZnesUtPAv9InPpNWPYwUvTqevSJoChINPF+O4Bjn4glA0ZkBPjguFKNVVT14L1foA7gy2DLVV3hRBuP+D5dTjNNI8uKAv+OVQBLDc6CRRo1w0iPl+h2YhLKLYDn3e0EGFyXOdsTGmO9LCeHw2vf3NTdI2ZiQXPli+kcLxiGC3pR4wDb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EAf5196AqVe81iSB1hKE44dfSQW9aK7QBWpW0eoyw2UdSm/0JAoQuLrslD6yE5QXhWRNIZzhNy4f+PWKQy/dWeQRTKeHVxLh7LtDTSYtZIp5TQAuvf0fGNQRl7b5R6DYaRXWrS0luklm1Hf8Cz9XpykJI2F2VxnZmeQrxoX1PyoZ0F5yztpevDFztNXEw5X7wLcX5OazDGLj5QvcF2EXdvdb67OREi2mj+d6Yv+C2NkL1MuoxOCkMwt9R2Jw2YywjqITiyCpC3vDv3LoB+YCba+FrcfILEYehgRxjivJDikzykRrR47nesopevFN5KCdrNfh2jsR83OL5L/u+GYBzmNl5k+xzMV9cl6Abbzx/5Nkxa+PBvLKot4uk55Zp+vo8WNpl8iLJfIvVWk4G0TR1Vy/XRTVyJVmc8Fg7Kr4ekLKxfJen+OD8VhuiN5eyz/sgpP2Vss0KKfQbfwsK6PMxCp5MAZEK6wJ7vgFLFvM6yc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0a43d5-cca1-4d20-9ce1-08d824840337
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:48.3912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BKKhkw/7ADjCcglez/98gYTgs8gZJ6gwL2JaLu8WTx8gsdjKH0dAFcHGz8DNKSeCesWeRq+o5yyWi8PcKAl53Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@mellanox.com>

The next patch will pass the mlx5e_priv struct to the
modify_header_match_supported method. Use this opportunity to refactor
the existing pr_info call to a netdev_info call.

Signed-off-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5674dbb682de..a6cb5d81f08b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3138,7 +3138,8 @@ static int is_action_keys_supported(const struct flow_action_entry *act,
 	return 0;
 }
 
-static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
+static bool modify_header_match_supported(struct mlx5e_priv *priv,
+					  struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
 					  u32 actions, bool ct_flow,
 					  struct netlink_ext_ack *extack)
@@ -3177,7 +3178,8 @@ static bool modify_header_match_supported(struct mlx5_flow_spec *spec,
 	    ip_proto != IPPROTO_UDP && ip_proto != IPPROTO_ICMP) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "can't offload re-write of non TCP/UDP");
-		pr_info("can't offload re-write of ip proto %d\n", ip_proto);
+		netdev_info(priv->netdev, "can't offload re-write of ip proto %d\n",
+			    ip_proto);
 		return false;
 	}
 
@@ -3212,7 +3214,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	}
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		return modify_header_match_supported(&parse_attr->spec,
+		return modify_header_match_supported(priv, &parse_attr->spec,
 						     flow_action, actions,
 						     ct_flow, extack);
 
-- 
2.26.2

