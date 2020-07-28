Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB14F2306BF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbgG1Jol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:41 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728461AbgG1Jok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yb7692XAZxggM/k8KgzSOo0vhXfyJkNvBhhq3AaK2hnD+m+r8uzjemEgWvlx5SF4qL1/tdmJGVKMsuSe1w8591kX3xJoF7IHTY0qQLeDE4tojEVAQFwRuOSUcx/9+5QhsAYqEmQ7gjUDVl5D6HNrP2cdVl9RPM/n5FAgczYG0x6bbeogt9wyq4zIPYakUjs17hgD3nrftmgC3wygmMgKZjtRmNmDxo/oaFsSSsKOG33rQJX0BNu0kRetTKUkH8XRnR15MVop9wYXNYRqmuNXjniaUVrjG37SR5Sv9b6ZIoBvJ9w8FvND8D5YCjLGRivMkqy740hPirM8RSPz0rEi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZEj/nXlbSeTbpWf+H4G5laAMGl2IJvqU/zWtFGdvAE=;
 b=mcIVSsmw7GJf46iF8V34VRDWcDgzoPm/ueu6ItCbwkNYTjp0TXsxtaYQXRxjkCZGPY5CsdQej+O/XdwHyMZMppTbLWZmEPi5q+VF7tSgFSj/T2LAKdkVzTO+hGBMpBWEIPjxur1rMAEeHqausl4HOPImSSaTLY9VONjRlUohDWl0b/BNsn2gdTAsGCcv7TH/PEoTHAFeO00cvgnawXCiWPowYrQDDl+CLET24/Z97gir43lSOBR82d043qWWn9oIkVmrEDN/EkmhNlQAaNc7NmRIH9CO8p5yKrSkaHd71zsO3MaDN245yAjZEIXVzps/emOyT3/elyPuk9F35QFjfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZEj/nXlbSeTbpWf+H4G5laAMGl2IJvqU/zWtFGdvAE=;
 b=rxJdp05zVZzSMimNvdJe+JonwWXBUf2IgvWv/4J+CGDeXsmlb0vPq7C1j8Kujh1D4sDe6KpC1f/7sHvjRuixl5ttYz8Cse5+PD8lDiTpL/a0wNRrfUQiwQG68am5yuEFlhcxbtveez/XnPxBuQsCBEByoUDUy2LvxM4uJu2bcAA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Avihu Hagag <avihuh@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/13] net/mlx5: Add function ID to reclaim pages debug log
Date:   Tue, 28 Jul 2020 02:44:00 -0700
Message-Id: <20200728094411.116386-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:30 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 03e3e6f5-6b0e-4e41-8cf4-08d832dad494
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117BAF2F57E6ED1C2AB48F5BE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gH0fDv3DjFvLWFFwHkLnYQCTZgWc+esO1RsnsqtByAJZgMpb8TLoEvLcbN7QrHO5wCDLIOyezr3HRWUo0x6v+ASet1/WcQBk5VsTLvJ2BOXeplFrujYDVWhKRB97KTvRCPMLP6c4+NUK4b58tXUrhu/yFovu4yfU3neVrK2vX8nO61oTb+oh6ReppiMaGQ0OTKby6A7UhUdpDvDNwuwDYoQTIN59H1aL3ancduBsqz2CFBQnv+Kkv5wMSZ0RFaeFQxjzFGievMfk+V4X4gxZi7tDumjIVATN+lfvsp2zWn+kE07LLzA7W5jLZkEyxLGH/OS2dxHdk+dI/LAXcuy3YbbghgPl3IbzJ/M5ns4TBPVtw4/6WoUEj7Dkr+YWh2zy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: APtNMqI3mOe6HbY9fSxH3kN3qL61L4T4I+CwgDeLmbtfflidT5L1Z9CMgKraTdWD+HvQOCI52Us8/1Zu3Am9EXoyfp6P0csn4sby1ErTriBn/DQTZlhoSSxrhzWDIiJcUmC2sAEdUsPVKRENkNmksRrBxhmVCf4MwwjOZg9whxT59XOWJg84cY6ckM3RH2VbK5xD7AaAPE5Cmc1xfQ47kx7rGLD9uu6nIEGnnof3tBPJYfFrxfrEsieyb/xeRGKCXLl+7v8NTXTPNb1sHG7cTLoiqDdpngiLPwQJHF5YbtMhH43VgasRxRhmClypXdETOclo23C7DZjBFcRiRh8kI0zYXZuSnqMpvGogVpxJmQhTQfNwxWAFTnkSv/Hna82XYyTv27GJ41/ucmCN0+aIeuBYgjIY4xBK9Gfq+g+N7Okv+jR/al26GC5+qSybL8wimP9Zu9EH9kZtCpuprDeAgF8gvW9JuEma700C4Hey0fg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e3e6f5-6b0e-4e41-8cf4-08d832dad494
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:33.3386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1e9tdFaJC/JQnT6WaeAaAm33dg6iys1hvNJc2t02qz+GH0OdERihaU8kBLraFtW8S0dzC+0WwIvjLWhYElZRRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihu Hagag <avihuh@mellanox.com>

Add function ID to reclaim pages debug log for better user visibility.

Signed-off-by: Avihu Hagag <avihuh@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 1b20e3397ddef..a4a23a27c3682 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -480,7 +480,8 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	MLX5_SET(manage_pages_in, in, input_num_entries, npages);
 	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
-	mlx5_core_dbg(dev, "npages %d, outlen %d\n", npages, outlen);
+	mlx5_core_dbg(dev, "func 0x%x, npages %d, outlen %d\n",
+		      func_id, npages, outlen);
 	err = reclaim_pages_cmd(dev, in, sizeof(in), out, outlen);
 	if (err) {
 		mlx5_core_err(dev, "failed reclaiming pages: err %d\n", err);
-- 
2.26.2

