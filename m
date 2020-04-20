Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547961B1888
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgDTVha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:37:30 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:6101
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgDTVh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIR8CJooc+o8LjWJXRD76GoC10SxstYa4cv6qf7JhViUgzO3sNlISw/KIcPt9pvXI9c/eRsf1uYg/GG9PSuM2Q5vWnruLpoSw3sR7mBANfCJS+yM++b9u3jnIfLeH4viDk7Pmhv6jOXSFjzlg1i6tDelzFRVbvgXAmdZMl0r4rG3UQJNjb39n5BlEAg8e7JNbFE3/xK+nH6emWSPG3EFAP54bQh9QSYNvUoCduEuOksXugsaH7enOa8eIHpniXuzBsZRUA2Pxy3d+arftDFRhn9tWjJj7HgzUnqd5+QOUV/tWKSp0HYDaOk0gcruMlzLDhpUrOQhEEJuzvmQG2NqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx0w7Cqk4NkYh8WeGIIT+WO9daww6NPL/uRfJYiQOPg=;
 b=apvjSWBsGsaeCsN91Q3hKoZM1a6IxwDJ1VSMaAL0v1F8BAnyZYpe/Hu/kFN8Fw3e8Xe3mTyB1gWc5/nYwdUTEX/Uy4m5buy7B9uhBjOQra0GEMBrQfkUb0KSHaY0A5PZiJ6dQjJ9Y9alN4bmZgnbvieu7cfL9r3R8gE7bjeec8QUw9g3hndbbM7CgYmE0myp/YrVtYkKjLhiZi4g/fl3+f3Oz+24+gDPFaf8iaxsnWQwUufBmlbMgRzojg2Jz8r+36lKf8fYeSHSepOnkYlQn3rJpcjo/fp6WtRdrP8Vv5PH58xijyvO1/+h8/hIHpRifiP1FSPfp2KHLZqy9n89Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx0w7Cqk4NkYh8WeGIIT+WO9daww6NPL/uRfJYiQOPg=;
 b=OW0Lmx+D2Foykbr05RGhnDWLW88EY3zIhryHcTN90R3xlRCj0VZffLNmtduC5cs7qgFIPG/0o5X3k1Vnt0rsgmidc9KqyCP27RSeMgEgCzM+gOb9Q2nZ6iSg1Wki0E+HLiNjAcas3cyCml7hTZtj4XDi/4QbNkmiiViBaMs4M+s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6509.eurprd05.prod.outlook.com (2603:10a6:803:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/5] net/mlx5e: Get the latest values from counters in switchdev mode
Date:   Mon, 20 Apr 2020 14:36:06 -0700
Message-Id: <20200420213606.44292-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420213606.44292-1-saeedm@mellanox.com>
References: <20200420213606.44292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:49 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 442d581e-e91f-471d-98b9-08d7e572ef80
X-MS-TrafficTypeDiagnostic: VI1PR05MB6509:|VI1PR05MB6509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6509889136F895E3B75C28C7BED40@VI1PR05MB6509.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(1076003)(6486002)(66946007)(26005)(36756003)(6506007)(81156014)(66556008)(8936002)(6916009)(54906003)(2906002)(52116002)(66476007)(316002)(8676002)(5660300002)(478600001)(107886003)(4326008)(956004)(86362001)(2616005)(6666004)(6512007)(186003)(16526019)(54420400002)(15583001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mOfpI4GwMuj8Eufi00Y9A78Fr04oQpT5Wo8S1Dh/p8BAjfj8JB64RXao4xfdeJn7gnFD/lRC8KgloRqUn0oSzldhO7QEYpMAndWxQOgHpwh/7DCdtJPSmWVl8JI+wcRFsYprJJUN09/LZY1Zkw3Rl7moR1ZL7mwiNdfYk/q4SosjsK5hO2Ak5WECC7KPDkTIfDxK5Bf3qEJKus1Dpa/VoC8kfcJ6PdE1LFk5mMaIt8kbTebwDdSFkW/tPDCxLartA1FhrVhiPreIBjfnxcSiS9IWU2C7CwKBihY0lmF1XxNUJd5fekRK3/VSpvuyTfJ/Av+jxVvu1EznymNaT3L8HesDBJtMLftDOg2+uny+VH0+NgwczXDgWW7EcUxq+c68MzxrtxPMQu2Y41y5Os2qiVtJm+thbmCk7jOsvRmmnhrk06xWGY20hBikrOhionHojE/KjCT/18O3bfVjMb7cfks1mRtRqd6puzPZJ3vKyfghmOH75sIlJ9S//M5B6w2l+nVedpCOk+JE6Oop3WpQQ==
X-MS-Exchange-AntiSpam-MessageData: lQLjhrXjZAshGdYTu3SynsiAC3DdVfhqbmBCfLawhTfRAxOjO4k4t0NStLwfqH55THAbEWMJyuOhi/4fhCbwc8UNSJs4d9chlDyH6OGo99CR6SlM75HV1TXlrCYM+P1IaNr80/FbutAgB6p0rce80A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 442d581e-e91f-471d-98b9-08d7e572ef80
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:50.5598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CF6Dh5JRpsTTxyCRtYmDy0CsSIUuX9+v+i8mOR+bYPb4htDOrTs10zD83AaP0hhBi93Y+sgb7/8voZcVdIuOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

In the switchdev mode, when running "cat
/sys/class/net/NIC/statistics/tx_packets", the ppcnt register is
accessed to get the latest values. But currently this command can
not get the correct values from ppcnt.

From firmware manual, before getting the 802_3 counters, the 802_3
data layout should be set to the ppcnt register.

When the command "cat /sys/class/net/NIC/statistics/tx_packets" is
run, before updating 802_3 data layout with ppcnt register, the
monitor counters are tested. The test result will decide the
802_3 data layout is updated or not.

Actually the monitor counters do not support to monitor rx/tx
stats of 802_3 in switchdev mode. So the rx/tx counters change
will not trigger monitor counters. So the 802_3 data layout will
not be updated in ppcnt register. Finally this command can not get
the latest values from ppcnt register with 802_3 data layout.

Fixes: 5c7e8bbb0257 ("net/mlx5e: Use monitor counters for update stats")
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f02150a97ac8..b314adf438da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3583,7 +3583,12 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
-	if (!mlx5e_monitor_counter_supported(priv)) {
+	/* In switchdev mode, monitor counters doesn't monitor
+	 * rx/tx stats of 802_3. The update stats mechanism
+	 * should keep the 802_3 layout counters updated
+	 */
+	if (!mlx5e_monitor_counter_supported(priv) ||
+	    mlx5e_is_uplink_rep(priv)) {
 		/* update HW stats in background for next time */
 		mlx5e_queue_update_stats(priv);
 	}
-- 
2.25.3

