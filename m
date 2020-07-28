Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F7F2306C9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgG1JpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:19 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728524AbgG1JpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5b3Xw39gM4edbmsg+mLcBpCNONMeOPat7QfqGHy44J0mKRgSDN2tQVUP0eyiYzN37qoNJj30Q4DPCU4jGTd3vnHd93VoS3NbiGwFsCupvTTvuUVZECnq/jR82A0AzKK19tlWcB8n3tRRaD/MUjCH12ydJkj3v1Y6NWGr7IxR2bFrQsW0LW0QxhOZIT5Zc05vT9PeQSWoAPt2YEroBli+dY1moGfwZNBbXsZv7N9jZIdp8NyLx6fVg9CK7snAaI1yZ06nZcry/G02Vh6DqvhTgxPxWO1VEY4A01OA1t6bdzR6y8faK8W8VbMp/KCT1rOWmEK/3XeRXbV2epzmPgaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7lm5ziSRQfDBxvsbYyXP6xglHkIEFrIEfnytBoxtYs=;
 b=VqrdQQHuTN2CEurLhZK42TSnqM0/Qn+CV2u3tpVz9BIl1FrTpNBWHsNnjc2SRfF8PXk/8+t1xDs9mDrU2vFtYQTbY3j0m12U9jM15z5Xe/PBw7h8k6dyTgpikfyGssC6EcVRuezOuhEHtHpOMFu2x3kBvJQ3gYba79M1zol8Ar8CCvF31yGNJwVipJmbDefyezF8equ6+QBzhirTojPy/5yd2ibNO/5Q25WH55tW6Z9qOBFACavdLXcQK+SV0rQxnrreY9/TOQId8JwPGzEmIVYR59G/uGxJjTYpvkXERQxRPQ70yWB4/x7V9AVQArRj/AMW5OBlVlucMieYjh6KRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7lm5ziSRQfDBxvsbYyXP6xglHkIEFrIEfnytBoxtYs=;
 b=R9rVIfcVAnd13VVdTJwryI6CYHoRKtlyDR9FCBOyk6URjz6D1iLdpr/JWhIdg908zpr4oR+7wxl2lztDoKV71SLxGOGwhxYluwJzywtRgb5dmp6fOcmiXs/SC4zs32zJIxD9cmbSvycUSMuKY5kt3AfV3iI3XLupytddhcT84Vg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/13] net/mlx5: DR, Reduce print level for matcher print
Date:   Tue, 28 Jul 2020 02:44:09 -0700
Message-Id: <20200728094411.116386-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 044f39e1-f016-4897-430a-08d832dae486
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117961270FAA5C67ECC6FE5BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 489ZpcjvOz1UbRLsfgwIliuO8E/VTTnWF4383bO6hsSCwCAW1hspwhkeqiSSdzIN1tHbuNXvKoofYonIg+y4Km5o/1p+L15dOk0em6p93LPALcNd8yt3o5B3EhwcaBdCfJERuv+4pcE6xK7SyfT2/7u+/goD6JRdsbYlNhBdroGEa51OytokzL2IBLN1clSQOXsJDVCtgwTfFDnZvhJXiDvh13yKx1SJxwGThhpKUsfy0b5Pdh/36hnx+At1KerI0hi7FladWbX1IqkTH3aC0SAcE/1aGM+cOoEC9nbuWJDw6sOqm6xL7Bis34xLVE/3vb53mrzwP107mzR3iZdNWxzSBTYpeVunNX8RxjcZNNGOWP8Cn3r8ozXFElJ/5tP+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: omar1Ii7zeSXRjyNgfeomik8djq8EoRQ1nePDl99OO11MHn9NSZkPnNEzbstGaFI2xLH2wn1GlGeckqqgE08o9Z5l4qNC9CyS7GSCg/0zyfeECoD+aJxBckBM7fRz6IuC2aF4Aza7b4ZcNF449jTTDO0AC1N2ERc6NVydwPyWlhR9V5CNyd6UTGDeeXu4RIk5wqRycf9Tl+pnB93/jZJfzkbUeohHyT3L94ih0a8OgwgTW7Sl96aMLIYzlG7seaGfrNQPf1MGtsTuVAxpd8r6VYhJkwLIxASecwoCnpvGDmqUgQtjRArF9NHx2BBkj/cdWKmI7xuhwHQRzyx2+6llt5mlY38s7OXUMs4R5pZvuAq7ky2qFLo77z+u/xeZymCFBfXr9Pgg0AZYq+rOhg4xWGE11w/1QABrN/2kDjbSFQuK3W19V4Qo+7MEbNrRdrgepS+fci8sD155vWNxqrqIPhkJhMZ4I7xbN2snBlSE6w=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 044f39e1-f016-4897-430a-08d832dae486
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:59.5096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsT8APEO97HkgPrELFs1ESRIv2Oiv8THhpjswlmCfBw+ADBY1DQC66OS18DLVWDYXRLW/coF9jz+CDv3qcEkCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

There is no need to print on each unsuccessful matcher
ip_version combination since it probably will happen when
trying to create all the possible combinations.
On a real failure we have a print in the calling function.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 31abcbb95ca29..6960aedd33cb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -395,7 +395,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	/* Check that all mask fields were consumed */
 	for (i = 0; i < sizeof(struct mlx5dr_match_param); i++) {
 		if (((u8 *)&mask)[i] != 0) {
-			mlx5dr_err(dmn, "Mask contains unsupported parameters\n");
+			mlx5dr_dbg(dmn, "Mask contains unsupported parameters\n");
 			return -EOPNOTSUPP;
 		}
 	}
-- 
2.26.2

