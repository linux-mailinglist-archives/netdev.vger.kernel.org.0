Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F29C452AC6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhKPG3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:41 -0500
Received: from mail-bn8nam12on2099.outbound.protection.outlook.com ([40.107.237.99]:36352
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231181AbhKPG1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nhm/fxRLMv7+GnHn5OHZ5XR25rMyImX/Llm/Lj+Xrjrvsh5rPu9Iw15MYveB8NtauoXEqF8ybMempOimfBWcXnx9dQODFaOy+VuASRkUrhCJsG8NbCu4EkGgGgJZTSqb3c7/17bnNDlSr1WVLxGwGn0fwuAVT7GXRka5sISJlP1xA6NOWLk4CVBLalSnYoVXgXjpwxsod/NmWi5mXty3z+WvwM9YIFo4Szp/ZVOQQgkI76fBH3yCgxh8UikcdYg3rIDgRR/6u1LBOyJmQJ72K0vYaKdjduLVi2FUYFNnVN3SqLuI+y9xvPs27pEu2nBAQecnuRWHj26wwh+oWI+kFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=bKqTjm/jxZv4oAOHIhID15uFXQb26am2EBox2tKytl4lcSqbcyp1bAiu3deMaB21354g3I8t+M+scpsNE50QkqPAj6eTNWZFcCRdp7NHFzSOYTOi10TqNVB84r90u8GgS7HluQgTTR9VuWofUTMRBHHmpb+zBaiU2kKSxWhaasVJlnqYGoaKyI+fhpbquE8ysJJEPFtuEDzVTN7w+fUUCvUuWBJwB0zGC94c4BHc04eolcF2st4VU4eyX0+lPKVxPP923R4Tr6IL65qizPMpwvOLdXPA/Xrh86nYW9AsRM3DiwdyPzPTbkLRxeCuUGFinxzMyOwdIs+q0i5bFPCDuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=fAJ8MT1NruGCMg2wGgvZWt/ZdT1c6xvg+N5q7wL/6luvIASFQQuf97dm6jW+Bhg9Wgn+3x6LTMfA9jqUYlsSu7jVJrLzhw17js8epx6UdKVKFfk0/ptTO/fDUuTqRnPhNC0E974SmnVqfnQxFeDddqtg/bngivr7KTXKvVg873g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1501.namprd10.prod.outlook.com
 (2603:10b6:300:24::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:59 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:59 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 22/23] net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
Date:   Mon, 15 Nov 2021 22:23:27 -0800
Message-Id: <20211116062328.1949151-23-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a505f9a-d6a9-4f5a-81eb-08d9a8c9ad11
X-MS-TrafficTypeDiagnostic: MWHPR10MB1501:
X-Microsoft-Antispam-PRVS: <MWHPR10MB150143068A6F6A0ADE67F1AEA4999@MWHPR10MB1501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0rcLOJrc0wDmKl/6UGsDY395uEWNPgzjYJsKb8XmcxHTQqY32l7N7FWtQ7Lc79x/ZXlpz2yBMzrK4372bAxHyXrKAH0Njx7l2RmQjGjWboVJZITubWxkU4IDuVpNW1kKFqjWwiP3XrBiWfqm7xlaemZ+ulU7Fi5sJ0qS4SEkrWq5iuNU7zY5HKtL6hX7ScYFpo6wpYz+FTcNNcardcViDy1Q7uHA5h4sUWiGKhmN5t/8kEFCXDCWKZfwXM9mU48xLxXZxb+RN5IKaUI8XV6o/vUHF7Xj0avwMn0c4Lf1IzWQMH2rVY4PV7ci+zkrKCRyRDbrQgXdweQVbIErmkNfKQhDfTOPGfvJlXoBecoOJfQcaZiUV62Ljlo7hQvuz+xSRAv/lKcQ4KXjwKq+V3DSacrEub0eeNwnCF9b+67QO0esNu/MuojgllTDqqh15elkpI5z3a9xgequIGGgFDClnHCoKpmp6pVkAhtOcr+/KTgs4EGzYKT2jqQhFc5I1GXKY28Rqy3sPkYNa7jVCEWG3c0MBlxgyBQfxVmAWs5k639DNf9k7ZdylIJf5VuvA92ii3lOTNop6dILbV5vb38GCabiybGPSBtOaV1Cu0ive4Xl3If2z33VYDXZ7LcsGJh7ABBcBy8Efglgx5u+7BDC/F7cg+fraGCyybURGvt2zlmq6BiDYs0XZuPN3mKd8aw5gC5T9qLtrgaXPqqqV8qVTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(39840400004)(346002)(4326008)(2616005)(956004)(186003)(44832011)(7416002)(6506007)(1076003)(26005)(86362001)(6486002)(38350700002)(66946007)(54906003)(36756003)(38100700002)(316002)(6512007)(5660300002)(2906002)(508600001)(66556008)(8676002)(66476007)(6666004)(8936002)(83380400001)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WeSiCUSvtvjxoDPN8SpS22Dif9mZcENxURzKD41iPjV4sCVQhz9Z4KS3xY99?=
 =?us-ascii?Q?ejwjqI1/RrKkVaIPcZpA+dKx/P5DMzr9yLDOyLwS/b4xyTnEYSA11DWI90TI?=
 =?us-ascii?Q?tQrZqwTfZyVELJfG1oQWac+/EpBvL+RvJT1bYffrmTcnDggL++TIZ4At0vKF?=
 =?us-ascii?Q?l+QqaWrDppT4slRR0Pauek6couWsoEIriXEmxvBebQvIMMXTifWcBQAIaMFs?=
 =?us-ascii?Q?mmqWAU/DEwxST/gfOAKfKi5EkET67S/5P+h+BJD5a7n2isIyESTBaN2grH5/?=
 =?us-ascii?Q?xoziw651pO/KDFywjpTjTsebYVYTSZxBjgOrPqnJ5Jf0G1NXALigj4DMrrg0?=
 =?us-ascii?Q?stmrgir5BcETffRaU3d2E3+1OSQJNRxYrBCHPH5cDAkMpZi7Q5TowxYaF7c7?=
 =?us-ascii?Q?uLrpwf7jNtyeuL/3hrB84G6/RlCJB2yYTswwPPnw4RQ1HMKQb0TfOfoSwdDS?=
 =?us-ascii?Q?5fKmnJoXn7MBrGEvrE3z9ZnG5bH54Dyh7Yc8Vy9Hm573TtZEAmwAC0EwIhyN?=
 =?us-ascii?Q?5ClbYmoEzmTBMYo+ocW8YnA1gwiXTfff2C1CR5unnIGpnmJj5WGBrlgLkj4m?=
 =?us-ascii?Q?Zh4C1cPPsxZ1Ep486O8/rp3ixXhZuHM8S8zIZq79kV9DCMz3mFF0Fbhkj8PY?=
 =?us-ascii?Q?/uzZ1uheuMPCRpuiciyLSzmCWJ5mY5nw210USkTWJDsgTtnfN/pMgE9eRX75?=
 =?us-ascii?Q?ObGrarhTf2DXNtuvx2rVdZhLC2k6Tknc73KRzR643K2+ujldzT+CjcMukCmM?=
 =?us-ascii?Q?pXaUFVReD6Np2uGbcVRSZFnj0e3R5U3ayf6R3aLl6mLSapl3/+leC3FxtqVs?=
 =?us-ascii?Q?eyylq0V+B3VQZfWIPPGCfU1OKlFMTGsAdG0JZ4Pzp3pksbNqbl7P4dbswddG?=
 =?us-ascii?Q?evjROAH0UBOVdfqiC0T2p+f53wM/GwqjavAvyyQKtH8iO5gvhp3RtmNWp4Ad?=
 =?us-ascii?Q?l6JGRgQ7y2Sma78PSw8cQemGyiFeLh6BSO2L7xfYcQUvvqZjRIXZfAkn/8QR?=
 =?us-ascii?Q?cI9oIbWZVRa1uu20k0tXD0yF33laTK74s8kwCcQX4SOTt7eSkfv/ACf4GR33?=
 =?us-ascii?Q?JCDRsL6rMhyQ99UlCJGdayMPQrt+9YE69n2l9S+j09TpjTul/uIpoL3x1mTm?=
 =?us-ascii?Q?9xGoIp/iWJt3BY3RmDUTfCcdOVTgGBKCPNhKflE8BoB+t/GI+7OnwFMW22t8?=
 =?us-ascii?Q?FAnEVNKkd9dE/aaxqks2OVW+ebt/DROZLMRk5ZN48SUXNLFDmJIwKGyGElcN?=
 =?us-ascii?Q?swCL+PrfaW9KnqgRMPedPJihcLeScDTzQkYxBWxUCJc42ZOHB2GWocY97uS8?=
 =?us-ascii?Q?Edkjs2H1v5szOGGHVaiiHT2XG96u3we+XKUd0sZzGUoZKQdzesqtwyB8uBoV?=
 =?us-ascii?Q?x9AW5PQp662SKnlYtBnB8Yt78e/8yRW/L+qMYPW2IdETuLFev41tAGFReCKy?=
 =?us-ascii?Q?/8eeN+fPVgEFzzU/Wo2Tq7zYN0gx4TQqW9GPXqc7W8cDd8ney4EfEq/UVzsB?=
 =?us-ascii?Q?1K38p3x66DdTLW0WI8nPOQGdackPFu5DK6UXE5tSSNUnGWQz9+FEU7YKLv1e?=
 =?us-ascii?Q?C0r8urlrQnq3yx+fnJxIbe/MKuUGdetlUlN5cUgTtZXnY/MD/ba4VNYAw8DQ?=
 =?us-ascii?Q?wtFW8iI2NlaYQQ0cs5wIJ8BA+XArrlU7AoGRST5YnE4MMYCFKXgiM2S2+yQE?=
 =?us-ascii?Q?V5P7u0mXjCnpcsBSRyh3o60cdMs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a505f9a-d6a9-4f5a-81eb-08d9a8c9ad11
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:59.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Q03CBOEP3dr8CgSiLPORCP2zDNFh54qVL1Xf7kToPhutU6xJ46swX7fLzOo56QKNQjvQ4zv8IFiMZiibZk09xGIDPxXMppU9yAORhPayiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pcs-lynx.c used lynx_pcs and lynx as a variable name within the same file.
This standardizes all internal variables to just "lynx"

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/pcs/pcs-lynx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 7ff7f86ad430..fd3445374955 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -345,17 +345,17 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
-	struct lynx_pcs *lynx_pcs;
+	struct lynx_pcs *lynx;
 
-	lynx_pcs = kzalloc(sizeof(*lynx_pcs), GFP_KERNEL);
-	if (!lynx_pcs)
+	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
+	if (!lynx)
 		return NULL;
 
-	lynx_pcs->mdio = mdio;
-	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
-	lynx_pcs->pcs.poll = true;
+	lynx->mdio = mdio;
+	lynx->pcs.ops = &lynx_pcs_phylink_ops;
+	lynx->pcs.poll = true;
 
-	return lynx_to_phylink_pcs(lynx_pcs);
+	return lynx_to_phylink_pcs(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-- 
2.25.1

