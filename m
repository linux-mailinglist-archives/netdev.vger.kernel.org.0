Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC32293627
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405559AbgJTHyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:22 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:33760
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405491AbgJTHyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQ4T4yjG52rxPG4kTkjxWWAFonBVlD0moiWRIUx5mjfn39eD+hy2aNZPV4HD8Fxw0GSX2yx2R3vDQ9QkR55r6zafb5NZK2XJVOPUVi99VObyt0dSffoCW4pk+K6Ju8ThHEbOIBLIpuKBta9VsIC+bUkuoK+eIcCQO/YhGV3IXKAIqassGUxdKVLI+NOOw2y89YtdPlFIUfF7oJSPovjwajOehpJhyVHT3Xm19hEPzr0Xa+hgTIEG8c3R7A3KsZv0uzhXV145tJ6hcJd04ABuIb8RkC/aeRk2Y6ty+hqDAzyAVmB9g+MXVN53uzisPJk/TDvWGQCrm82tOVG54Sjrlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peiX8UE9p5cXI2sL73kSBj0XwcJcL5uwALVe1rW5XNU=;
 b=hx4tUd/t0RP1NpUw4pt8x7db1CwHiYaRkXqOtt2q96Atz0ZU2ru4h6gjApHAs0N1ou30hj1Srvz3NcxQ6l9Uu0s/RqH5tUQnU9UgB0WmEC5Tzo1AAyHMtgHh0ns0H5CfSz3ANEA0VxISGLZwoa5Oq5dZ5EcczJ+SFipNND192bdjGE1ykLyf6NsC9s41N1OGzBL9421Bb4hPlbLtF/KoAbnVTopwDmJZ7zLA8QtHPo55QQTnIj+F2Rv9bCAqgRkI2MXLarGYe3zgtR5BbMs0wQc/0IalAD+0u2OClKA4/g7E5qrYuoeoSO46JWPno+Mkj2XdlwarZ153Bq2UxrCEXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peiX8UE9p5cXI2sL73kSBj0XwcJcL5uwALVe1rW5XNU=;
 b=AiwGlOFK/1AaT9wqfZ5JhiJtmLisENSAWrmbPcTD8T3+ENcgKgi16Ihk15CBNcMEZnNiLaWOEtf4FmynLf0I7iKD5ArZdAXMA23llhKpYQzYcxfurZMVstK2Sun0BJKXlXeVLCs4NY+UHQOfWiK0QhyL5fU4Rg3xeXZihn0JZdI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 03/10] can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
Date:   Tue, 20 Oct 2020 23:53:55 +0800
Message-Id: <20201020155402.30318-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2961e1c6-e97e-4418-43af-08d874cd5826
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73332958D80C6684422C5D48E61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayJ0LrIlZqHC/xcTLBKfHyo5PgjCsfmfnsBMk4KMgRR5GUcPNREs8+8agCb4tDVKsJy9EJMLT9LJ88yiKC+6gHUQfuwm82X/7hZjm+N3nU8qw7qTgOqSke54AKDCQieJXO7kWbpkQW3pbm4+K7RKQyczsKpBzh+zEPDI1em5AQmMHnXEAOeOvS5AFWmyP5fwjDCrdNpVNnWPf9OkEM0r2Y3ZtOEbUxsr2/F2nm+a72On+caInk8Cimvcb3AVKw0iGg4uatMEeVySJ5g+j61h34ue3Zm6Is+HH5IqL1rgDapM56aRLigsJJm2F22nNFi0Jcf43+8Nq/IwneS9+N8LqCjig0DS5VBa7PiAfJHuok1pWmVQ7+4L8kpXDUwMVbAk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Qd/Kx1Aag6swNk/dO2Vh1iF3iKbWMxVNcWvIBaK+PVH6L1lIIkihgqWjZf1JCSHsogWm6brjsdezQN2ngc/xQP1icmMLEMmoVnI/TTYzkzyV2n2ryUaXAXGA5yd4aHmJCIgSxVcJXOSCE+Z2JxT2SPc4atMTsU1ZBfTIjLm/CEuiR5ONxILapV0DdNGKiFe53+SfmXC0dkhKIeJy5f+KTLyDlQYgoOgCffi/a9RtEjVflvwQxogqhuSIFFIPESWe7TDuhKnsDKIfjJG6bA6h4n9C2OvBrwHAsmpoJjFEhKLtwrdd69VM16g1Ut2PztSxLvKJO22v7Jhhkx2MorbZ/V5cR2ViUJqEDGLQh7N/uDd0P0ktNxZvbx5KSJeqtDsRGB5D+0DmMG1fyrkYKxpuDFiz/kLGz9gK9eVVHqH5s/1hpB4OPW72m8R9xAyMJeyFeSOYzl1rbTzMBUo1gY4w2QiWr7tWDd+UloMopYRkTb8kZjVLAax3Qf4Mal5wsj8Xp2cVJ9vIeJDa0W/D5FoOx5S9TdQOYp3wzvgzVluppCQxuo6X5pFXNt9aZY3J586w+6s9XRHuWwlkRDzZVd1Ci11tPEpmDxsuVvDVurnk8OOYSWjDXM33MDPbP07jVSBdtVDeWXBrNytM2M/T3akaoQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2961e1c6-e97e-4418-43af-08d874cd5826
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:17.1972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oUw0m9+6k9pm9d+JaeIw1sjB6xHev/yELLvscNKNQICFN6/jDDsJIiJgKfFx9UL3qjuEv74oe/oEdI4oU3UCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After double check with Layerscape CAN owner (Pankaj Bansal), confirm that
LS1021A doesn't support ECC feature, so remove FLEXCAN_QUIRK_DISABLE_MECR
quirk.

Fixes: 99b7668c04b27 ("can: flexcan: adding platform specific details for LS1021A")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4d594e977497..586e1417a697 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -405,8 +405,7 @@ static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
-		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP,
 };
 
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
-- 
2.17.1

