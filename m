Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2651F0C32
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgFGPAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:19 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbgFGPAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imriIrWZ35ljUfwBUO1GZE0wqn8jZe0EcUBGCPlnxIIqSOO6uy97Z8w9I5zMjghPsRVx+svE6WE4ayfn/DPan3xEMiaT0qoAgNEdX3hdszBLfKInRtNwyOSqwNO+TkkiZ2nMR5hZNQf2REQugJKw6yqV/vgmXaTyMDfRVHaGMD8orFYqvgg4VZAz8wTr8VXdiRiuIvXC9NHvBIb7sn/AJomKNeS+DVV+RObOerPVq1uPYVe/EBjrd3W6SG7rO/8LPl0fumK392MJJAhvNCqdOSwqg8Cw2etvCzjrobDWWtunYMfmBWTarXteplPGrBODhEDQhoFLtgCOiwK4FXA9ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwNh1QN4b46yiYV8lIgAPkOSqxYAk4IThekHyt1r2wk=;
 b=kj0xyCk6YM6tQrR+NMldQEgasmosycrsX8qn0EsnXq6XPVRR1TlYJ/wnnRussBAxmv7+iCdLFGUJJVmkYFtvaoMW312Dy2NtYARPRRWzv26trDFgNr1qYrcfMOTOTSTbU55EttDXUzZAra5ng/Tn5NwwvCOcEMgtQMYZio49esxyVf9+8dWYl9IKRyOKtKUMu6wWamFj6HdiPYtsJh14CycK+GPB+G52ffefPbJlOskibbYH8yMHyJHuYla+q7QRCgNWuYIPSIL2/+FPDgVv3T7coklsNi480RXQ+JMdoZ94t8fH7lSzIV6ZzESCyaWCfPsWz+XXydIqgzSNSpFGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwNh1QN4b46yiYV8lIgAPkOSqxYAk4IThekHyt1r2wk=;
 b=pypu3wjjEgv585aiFw9g18ffgU6prF2Eggq8M4vbBTsQfd3hJ2PQgWZaMxTILssW0cEwsnNdEKF8Zm2roaLRqtmMRvvbBzI39VP++jfADIWtS4b0iWUolej8lf9bSAwg7+mdZ5b7Y3U+ZqbvvngzfhHyw+jJNBhaaELVBPNvXDw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:08 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:08 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 01/10] mlxsw: spectrum_dcb: Rename mlxsw_sp_port_headroom_set()
Date:   Sun,  7 Jun 2020 17:59:36 +0300
Message-Id: <20200607145945.30559-2-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:05 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01cf4b40-59cc-4ec1-c97a-08d80af377dc
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB400339A860A4728CA32783DFD7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jhrx9Bhe9ZGED7//LFfrE4cV3gb6x1o0+xQfMLUR5fWzgMr2OPhV5SK4Cz0iYMxLvU81a2etBTrmK3ih0MSbxFc5uUb/WJA7eZNQTr49PR2eRBfFhUiw7LM1M2hbStyiNgvpaReDf/D1DM9D16xA8J+r4GalZVKVU7r6BoBjebmznGT4ycSO1JnePWtkksE51GyOfJ+3iTgH0hWW3xfeT3gv5ILIAnhs/s2OFgrL46Eyv5uffje1LI9D2pYgFjvHaHQGkB/ZgSneExH9O1ZyI6UaR4AA8g1g24xMxKvLKAPznrI4u6an1daQ2mon/VsDkqN/3OPgBwSBH51DudR5XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VoPEQHNCSnKykzyQMrIwai4GoeoYA8HFLMLgJ4yLpwOFwZDBoAmKDeoFBnFl/CEKn3MbpnkCRfn6l/S8TomYTjPDvcTsya0LaB6SjQxR4SS8205e/6d0M+QBmzNXnRToRt1bzmJnVJkVhe4I2b0pZVZafY9KHIs2b6J2UibarGL1lOdYGVYpVAeXBDsOFGAlDxBrDtBmCLt5MLW35C9hSvUBFSxgBKTX2YLdVK2yww7BCyi6ElCwq2mhVZcwxtDqMIE/AV9F5bDlsqjxiwdfaDM6Jxbl2akC7KCRxu/SyPZzEdIdJPs0WoxHuzRFSkz2uFrM4y9nXwFauYi5EraE1dJJ4FxA2aEDfpfiqCA3FZAPr7V3P5XA/a7H7uThMBmYlu6vr+bLrfT/xBf8qMmgd2+L8JAHxx8xGopFXc7XYm4HXRbST7WwopJ9u/AeJfogxvJXuZyxinodm0pBMcX2YMYaT7nUMJKkKwXWNml5nb4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01cf4b40-59cc-4ec1-c97a-08d80af377dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:08.0052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GwKk4Y7R6r3FjH0n8PdjD0D5N5B7fSwXE0ybsHqYZEP2KMnzgi5OmdXXPkKQvYkIPAOx9AYxHYthyhzErrLjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw_sp_port_headroom_set() is defined twice - in spectrum.c and in
spectrum_dcb.c, with different arguments and different implementation
but the name is same.

Rename mlxsw_sp_port_headroom_set() to mlxsw_sp_port_headroom_ets_set()
in order to allow using the second function in several files, and not
only as static function in spectrum.c.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 49a72a8f1f57..e4e0c7c7e9d4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -110,8 +110,8 @@ static int mlxsw_sp_port_pg_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
 }
 
-static int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct ieee_ets *ets)
+static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
+					  struct ieee_ets *ets)
 {
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	struct ieee_ets *my_ets = mlxsw_sp_port->dcb.ets;
@@ -180,7 +180,7 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 
 	/* Ingress configuration. */
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, ets);
+	err = mlxsw_sp_port_headroom_ets_set(mlxsw_sp_port, ets);
 	if (err)
 		goto err_port_headroom_set;
 
-- 
2.20.1

