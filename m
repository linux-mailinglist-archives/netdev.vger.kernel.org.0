Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143B43C3663
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhGJT3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:21 -0400
Received: from mail-bn7nam10on2110.outbound.protection.outlook.com ([40.107.92.110]:51932
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231184AbhGJT3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl9RmSwFX0LoSZqJFOP/NBycuQkv+QYiLSUm2vI73uxHM1xWNEBau2NYYIG2t4UCQcWfv/WgasoqySU9j9VIBbSl7JOL0yJdzLsml8pP6yrSUPpp6oof9YIGm8QtozTxIhKmGxih5koCgvg9gk0CidX/se1FDuT1CGdm5fmD4xNBz+AuD99dLjwnWzvb/EyAyXcoPzFTz3UENtHuYZJAInFQvku8v/hzEzdfyQEZ6nsnBYUKq8dYF1rTrNElnviKrfS8PMYvjM1/6hsJRcbJYOtr7q76cOeq661mZeTg/YfR9eIk9yZNzz3FRUIZculIbcFdKrDKsQs9eFlJXGXckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCPo/unyFkF2zHAE734bCvqx6zKhLBpbbjT0QENzyR0=;
 b=mqcqH02iZMj4ANck69ApfyeGcAfk1i7y3+tgn7yaUyb+RL3+Z6Pzl7Qd0bG4xRhQ/NeZ3yj8nD2brgcQcgTjPHHYC8wme7P74L6ChE+FK2xG4xlOF9fZ6XuXFK7g/BNkFnWleKLxRgQqE0MHPLXRIsQHI6tS6iX6kw/CQiDqncAiMN9NloqVZmIXaG0bqJ06TJBM22WZ0FP+vOdNxldPCOW063FHRWMUe7ZboG0MhmD1yYW01Te6uC/DSqzM1xYHHW5i3sL2Z8m80X4txbDQuYSxcsjsreQsZqn0LzCoZrDm5NcvwvBZ6SuCTlU8RyomaDn8/dPVYa4kroBRudb/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCPo/unyFkF2zHAE734bCvqx6zKhLBpbbjT0QENzyR0=;
 b=kWMy+5eCBWf2aFZn/ThdaRYXPBqZW9Chjn0VoAT5xZYPhQNpWmp2YFCI4QlfOI3XzWmJauj5TcrMVKUO/uIXkBR7ZZGKcHqQUV2GWB/CF+Q2Ti5aZ4X+EyU1mjRA/yOB8QOp+yN3HP43gBhXAN0GvJ90D5FunApQnEiL5YhT20w=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 3/8] net: dsa: ocelot: felix: NULL check on variable
Date:   Sat, 10 Jul 2021 12:25:57 -0700
Message-Id: <20210710192602.2186370-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b4e773c-a08d-49b4-2812-08d943d89769
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB170901E57284B8FF717667EDA4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YaMnyVj3dJwc6LtcB7oQXGDuUxAPY84W+P+Ftk/40lSGj5+4A5Q2wAfRr26I+EnaXI44XN5j0W3K7nowHDL5VvpL/znAJgIUid4qmrvPnX+7WgPaYjTxva/wf9wuuesFgVov7FA8bwODi/gZgWLzhwU+HtvFHnqrRxqKb6KtNp1lIYGCYaCoY+AlWb8upPuGUtIm9ExgxDifXgZpyjhyWgoS1rFRVjVzdY95GRplupJrTkOUVVfIS9PPMjpDi9RrRvD3j7+o5rapHEUC2MhwvB5Bcp/JC+1tszrkjD4IWM7DXiKGhho9xpYmLWvGkJp/FpMFa+UfxdqqfesalCIHYVNr0cdhNEDwgJ9AVqDnIGlJMmH9jaFXPtSy6XKYDeenf58aV2E4P9F98KmzJHSDi4ABSlWWyBvN+QAmNqdlg+A0OBn6c5Kc3NQicemxmhPtXXAIkNjAkkE50bJiCC5G/H16eTjpADleA9shZuIwvA+jf7G5e/T2i5CxFXbR/HgaUIqZldj6mYDm8gZ2dnT280AgpRxN5c2dKgO2gXD7KCl16HT8bNssoX/sFAB23AW58DBtQQtAVc/f9CFwXz8njnX+b+r305G2nyjx0mJpE/5Pq7cs/EOpqCZHU5rHVj93aB3MAoHR1TrIv4Xz0M+dbwzJuMnuvGEPIHb+anWVkXzgAXNaNtcAIeD0Y+pBzfMiHawewWS9EBuRBoDsbF3edidpTeJvDVcAntFMuwGce2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O/BF8q+QUfqTpxAh1xc/wey6Dj7W0x4kAF6cGoJGQvgXCp0Kw/Qk+0EPlLb8?=
 =?us-ascii?Q?eehVgMNXFumxbS23xwspoPUJRZnECne91CrkyUWX4AZCkD8dEB99um79mj9e?=
 =?us-ascii?Q?2zZPL8/a3mjFxCY8vj+qZChL2yQFnK+quV/9pqdkXKEBdm7k4YUixIGBUc1B?=
 =?us-ascii?Q?jMNm164k5rPJs3mFwAHgsK13sFHpzQjiq2ijs4UV/jfhbhfGdIp00VEqhgVH?=
 =?us-ascii?Q?Ph/1m0npm9bmQrhgDwZydSaIl3fyyManoVIIWNv4OwABZeDpo8/9fMx/yPhR?=
 =?us-ascii?Q?8ROgjmxop7Sat0MsG06cDCEhYTlbDgtGVGbPZCfbxZ+Wh1YpoOkz4zPBl/zj?=
 =?us-ascii?Q?7hA3m5LXkT+4oij30CclS/ZuSl2K8mASRz2PaLfojiXJR6kT4Mb9BmRVJ1ue?=
 =?us-ascii?Q?1DOu+IHmhFggisctwRrNI3+LVaWKePe3zUxFEAgIpVAmqg34NkEtMz9hSBRw?=
 =?us-ascii?Q?63CLmZdifLrjsm6T1tGXoGBjnCKYZwBYjxi9sKQFYFYHYJqUAYciYrGL06oq?=
 =?us-ascii?Q?GxvPotcDEbd1zRXoUs1v9c+qH1rctNsUzeKqYff6Tzu4AdZYgGb76EQy+/+X?=
 =?us-ascii?Q?vlCif/31vnHYly0uY4VGHWNtGq+1wYO0m13qac3IUWBrNSAcJt4j8Cb5coLv?=
 =?us-ascii?Q?JiAi4RVQliLOCwVBlwKJUd3xYAz32GXKicPFS4nQ+R/OIqpjN/6uvn366EFJ?=
 =?us-ascii?Q?LpWdDW3xrq9K4s+DmLWS3MSLvUtya85V70WslBUIdGItRgQHlj07VhHGOq85?=
 =?us-ascii?Q?ARYx7Ii2zr66fdVyUqEKJkbl9LBrCeyQ105TlQbo0WmsD0Oi+HputQi24a3L?=
 =?us-ascii?Q?DgEgpSsZmxxGC6tOTHQn3/zyb1QAWw/PBlF4OJ/+nJKpjMZ+kARMJGXFyjvb?=
 =?us-ascii?Q?P0l7S8HdZGyqxEnlLdxU/hRx6HbFc9DGkLy3GwOwRL0iOIq9F0Rb881aKT8V?=
 =?us-ascii?Q?P8RwsqULQVfRNIBZSgWUd9XJa7FLywHgipf1VGkOXOwb50YdeloWFCkFbg2i?=
 =?us-ascii?Q?+MlrqZQntWZjf23YtNWpH5ZwOVpBrgvpveMm0e7hJJBnuALpzoT0+6Rp9B00?=
 =?us-ascii?Q?4paR7qYa8wudTa7gSRSDSGFxT1DzjY77OLLo9qCKP6bI1TkRIFtzIFNtreGY?=
 =?us-ascii?Q?ihr3h1SVDcFU+45Ek5h7rggkcEN62NGIuRdgqsc3UiY2BCoK4nfJXivfsHpU?=
 =?us-ascii?Q?CUNbmqRRu2V/RbjKeV1e8bAbc7mASBnKST2jxGyH4wJvjozOaAS6sPweXZFi?=
 =?us-ascii?Q?X4vbssbwq+9Z6OI9g7VQ2FhGB+RX1gpTHu7TzXFUSHmimwK2aC/yHyE3dzqD?=
 =?us-ascii?Q?1Jyp14AVijngTJgDq5haUmpg?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4e773c-a08d-49b4-2812-08d943d89769
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:18.3682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YY6fX4+QaVndHUbcpS32iqisWGjg/roqKVv/F5/TGSdCXxAlv2d9vyR9jt23Kg5i+MUtdYVhjYowPFmWEUsNp2CbBHGm4rbHQH2uhNv9bkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NULL check before dereferencing array

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ce607fbaaa3a..74ae322b2126 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -852,7 +852,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct felix *felix = ocelot_to_felix(ocelot);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
-	if (felix->pcs[port])
+	if (felix->pcs && felix->pcs[port])
 		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
 }
 
-- 
2.25.1

