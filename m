Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6673F227929
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGUHC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:02:59 -0400
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:38977
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726474AbgGUHC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:02:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hD2sNerKMZpzAkIOKpvQDtcQp1jDkOs7w8gGtSKsh5nSWESvS7+ITXOacNRwfLiRG2RgAWuWjoAru4tLpfi09fQ3Vhn0kvavhXeXNFt8lJ4b6L0gpUjT1U9vMwTA2Wzt/mxvLrm7n9q97z+TKT+cUaZDezksbV0HVwUrRPUNerG0Lj802l/Km/FCxA7WuaATRQepc557SgodPjN4Pk1bbYQsYi/Pu9uSc8KMbDYAV5KB59J2bhNdnlcr2LnzediKEOXCJ+ZMsn84K/2RqzM9A6yL5+LGE40q26g7IgjRln2Xh3EH8Nygmf6fXLKl3AYCrpwmp4gE0MlV+VLYZFF0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9umHd9s1KLtlLpxW/WfWbGDaJ94K2bGRIAoi3XOPsHE=;
 b=dp4fb+fx0w1HaUoY5lls0dfGzno/ZOCUneu3lSB3DuJjc7MsymVA2B2xFmp6sFan5+2CUSTgkEkTKlhKL2C7hlaXrHq/F8rGm2m7Hmue8nZXXX+wuKyJwUXj7IPWc1EQY/T8mr2gQeCUzOQJTmtPqTjOnQMmCzH12HsaiKg9GWkHl7Z3UE4ch/mtZZ1HSH5tFEvbYG/Yck5ofbszN2c/Qpa8OviBGyL403n3daXsWJnyNSIXUGwZYK46BZIz9viG/S3IA3NmaWO4bMFryoR8V754P3ujJQZSk/oUnGJasH7ODtNLa8S+sUqGfIuyBV5h1LLDdJ/y8JNs3tpR4S7uxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9umHd9s1KLtlLpxW/WfWbGDaJ94K2bGRIAoi3XOPsHE=;
 b=okLfBpLg61SvBEU+EKKM7dR9cyLCmHbvDkMtU0x8kG8KjzngXFUifGZuEiiKsTRHzzhNMh3mUAAalxgoHk88S/nLLYICN0wr8+A6xsaEwnII6hb/e7S0zfoKJ424FawB8T79Mc1XyR75u5BhhcD8zy02qXycvzsduXxpaQf2PWg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4599.namprd03.prod.outlook.com (2603:10b6:a03:134::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 07:02:55 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 07:02:55 +0000
Date:   Tue, 21 Jul 2020 15:01:57 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mdio-mux-gpio: use devm_gpiod_get_array()
Message-ID: <20200721150134.5ba52595@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0095.jpnprd01.prod.outlook.com
 (2603:1096:405:3::35) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYCPR01CA0095.jpnprd01.prod.outlook.com (2603:1096:405:3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 21 Jul 2020 07:02:52 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267efcd9-9517-4ad1-251a-08d82d44179b
X-MS-TrafficTypeDiagnostic: BYAPR03MB4599:
X-Microsoft-Antispam-PRVS: <BYAPR03MB4599BB71E7DBE09B91FD03DFED780@BYAPR03MB4599.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:121;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Simu/yEHWFoA0aYkDzHuWhK1wNjCvQgMtmwAS5fGbEJ19HiJsns6JJGjz1il84xVGgrgY6Ua6FAseOWP7zqECH/sC56iT1rgBm+sOXe/pFDvO7Ds58PTt6OCYQ3Izg7KyQy2F6IfN9G8rhg55YQbnHwvUwwhcr7ot79nE+LTBjtRIi+UGQQS8MhJrz+58l+9As4hKSUC+PGca8H5fzUrGJ9DzElNx0dHarUfoRspUnOQz99NMcf5EDEkxGsmU2LdqwjsTtCinTpqMWxBcsVj2W+qbfj93KBNw2T7KpxsdfASXgVeSbKNBZZsRHTG+ptvFndCxYF7uMPhTCaT2iCbSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(366004)(346002)(39860400002)(478600001)(4326008)(186003)(66946007)(52116002)(26005)(956004)(7696005)(16526019)(6506007)(86362001)(1076003)(110136005)(5660300002)(8676002)(2906002)(55016002)(83380400001)(9686003)(8936002)(66556008)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wv36h7pBlBfMpTpI8awrFvGtQvQhkFyJY4XSaENGjuI3KOvosQOM6Q8aW/YfQseEbGx3KsCFEdwuv35/ANctjUjeIk+yl2mMBS2OPBKrMnOtOs4lCb4CnU0XnQpibvFe530au2eu2pJ52Xj3fJVlpvSAq2aBHMrPeOFUWZ56UuQxwMjQZrzG/oJfVfZ3+iH31qvVSPHxPKx5gYYyIk/bDatIypN0wJ9bFXbqiFlqR61AWoZXYQXFVBq69tTlRvBAi04yEDWemFf/c3qWr5r/R/UDvr11QGkWV5Y8CbSJ4BsECyxuU1ts3lT+hJsI9DADy+fGFocg5QumYUXqIhhX9tM/uUTZp/4yp/sQ4abePb4uOMTojkeT2nJnmEJdr3Ld9y/c43Lk0BNEEISxACaVnTVlgaq1Q1pRTGasNkc9I3s9bKEoyKbs1wVXadI2fxZWwynFmp7ZAyN2N2XfYmckQCJHlMdS34HTWf8dSljfUnraGsUzt6a10TbU5GRLYzKv
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 267efcd9-9517-4ad1-251a-08d82d44179b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 07:02:55.4552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pD/xWSVeBD4Ls4kCC80/GehnPXEjeb+eaFgUJ75gi7YT6Z5VljAQcNaFbt5g/UifK/AMtSBhjz5siuCd5pF12g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_gpiod_get_array() to simplify the error handling and exit
code path.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/phy/mdio-mux-gpio.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/phy/mdio-mux-gpio.c
index 6c8960df43b0..10a758fdc9e6 100644
--- a/drivers/net/phy/mdio-mux-gpio.c
+++ b/drivers/net/phy/mdio-mux-gpio.c
@@ -42,25 +42,21 @@ static int mdio_mux_gpio_probe(struct platform_device *pdev)
 	struct gpio_descs *gpios;
 	int r;
 
-	gpios = gpiod_get_array(&pdev->dev, NULL, GPIOD_OUT_LOW);
+	gpios = devm_gpiod_get_array(&pdev->dev, NULL, GPIOD_OUT_LOW);
 	if (IS_ERR(gpios))
 		return PTR_ERR(gpios);
 
 	s = devm_kzalloc(&pdev->dev, sizeof(*s), GFP_KERNEL);
-	if (!s) {
-		gpiod_put_array(gpios);
+	if (!s)
 		return -ENOMEM;
-	}
 
 	s->gpios = gpios;
 
 	r = mdio_mux_init(&pdev->dev, pdev->dev.of_node,
 			  mdio_mux_gpio_switch_fn, &s->mux_handle, s, NULL);
 
-	if (r != 0) {
-		gpiod_put_array(s->gpios);
+	if (r != 0)
 		return r;
-	}
 
 	pdev->dev.platform_data = s;
 	return 0;
@@ -70,7 +66,6 @@ static int mdio_mux_gpio_remove(struct platform_device *pdev)
 {
 	struct mdio_mux_gpio_state *s = dev_get_platdata(&pdev->dev);
 	mdio_mux_uninit(s->mux_handle);
-	gpiod_put_array(s->gpios);
 	return 0;
 }
 
-- 
2.28.0.rc0

