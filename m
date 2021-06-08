Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4979F39ECD9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFHDRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:17:55 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:56339
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230323AbhFHDRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:17:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NN8JZ2Z7m4DbJjE6I0wdDBTWg9V+9FAyir11Y/SOWr2J/AHAgFbhEmwHtuN15ogRIWDl2sX+4VZU1JyUEbsja5+UkzF3XTVn/Ew2cB0G9dSHaSBP9u6Gndt4cuxvS7HzPVaOWM3p1bHzYwwV5pZpF0ai8MsXj/LVKrrrCvPkFEch7nDpyJdWUN7CVNWj+7TeGzIe5E1X1Jhfd4itmLgaVv6855THGUNAaHC1u3FbhtprxN1T6xTDjVBtZfFLxnKRuQqIjPvWI6Y0d7xRurHO2YwksXyTxLLVf/sHhZEemaSMjbqBVCHyr0Pq+v+O00abszdThdClNE1IUwYWCp5dBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1/8i5KnhmL04zc36V54TTrLSt3yBuKYISsTZyDkmZE=;
 b=FdHRRpcKgRpjKBXCO2t99DjGImo2vUgG7ps4Pvxj3ac8ueEP+BQLemmN6N/ZUP4X2sQV0+rW82Y0NNCCR7cJehjcTn0mfYJRN7RVePbl3awqjKX3JT29CE1k7ny8nmpnBlt0mnx6iSKUeFaGcyVUHL98AP408aG8zIgKt8cgQxJH5bOph6eewV8TIrCMdwyEz5nxv6dei0dnHH4wDyAf1+oTwgQPZN0MRphRfP/5qHeWM42MYesi6S3MrHqNG4LrXx3yXbFe7AIgdXnnpH9pVZ3lnZbRTyk8eWhWV23AcqjWTHtnNqQJH/YLeo3xbgsXZvCGQQdFQwdmiiNg28BvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1/8i5KnhmL04zc36V54TTrLSt3yBuKYISsTZyDkmZE=;
 b=V4qewCbblsI0iMw5su5ehrfcizjayqwyGOA20KtyswC20PFWauQdGzKtoOpEwGzAgSA38xGrqiz8Bw/jfAfNXKlofFW/9rMfbyn/3w2nrU+E2l2jG3MZA0WV0VM7jrEUIWSPmqm0vBqFoC8fBMwYpaQ+4whxQApiA4eETkDmves=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:16:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:15:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 0/4] net: phy: add dt property for realtek phy
Date:   Tue,  8 Jun 2021 11:15:31 +0800
Message-Id: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend Transport; Tue, 8 Jun 2021 03:15:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adef6f49-28eb-46bd-355b-08d92a2bbd25
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6139AD8E53EB38D312684603E6379@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAxIldQGkuD7niAsn5DZkvHHsDW5rxHmTklA4CQ7lYA3hvZvD4lTozOxY789gZ41bQ0FhG2Gx7iIGSi9MllJW+/JT3xnOOxrS2qPnJaZlq7EcvhbtVdSM2S3Bp20o8bVEgG38+rqM/vGqrSf5ZDIl+duebsQ+M1786Lzph1Fb3Pzh6xeH8yPrd1g3eBy1vQV/yPO/t/1rFP2rwnu/L8nJQPAkBQrM1y0PBZK3lT1gaVA4u2nGVq0XiS9xskCkUif1kEipb+i/h98u0Z0rnVUU5JfX3gkMDNu/+8TfASgW5kIFs5vGkqyVloiI8RrQI4fovUZ+jBdntvuNLgz88tiHm+QCiTb/dGUv1AT5jB90CRG1XA/e3TsnTAjE7Aql2fklfc5YbsJcM7zSnTEjoTDtM7bqYulfvk+1TAYj3AGYrloIkGfrxY7OTcBCi/v+HSw6Tlfcan6SS4K3ly3Nw88Au5xjg1lulyWEgCJwX/+Z9Yr5hsSC6xsVnA3PxqpnNuQmzvLzGQ8Es3RypOR4vWhGiNsudXucPeUpcfIDfsd793YP2cww1xXEyQCUN7NJGtVV0VWzN1z9XBj994vJq5KtNWqYOXacQdg0byV9UWh+HNWG6WWFVaom7H5y8HKidMWdI7QBT2EDX62We0dRSk5KQvE3fSL8/uC/aDmfJ1wa8QUDWS0B53dvR45jcCdkPGM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(66476007)(66556008)(8676002)(5660300002)(4744005)(66946007)(38100700002)(83380400001)(38350700002)(36756003)(6666004)(1076003)(8936002)(6506007)(6512007)(86362001)(52116002)(16526019)(6486002)(26005)(7416002)(186003)(956004)(4326008)(2906002)(478600001)(316002)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TVDnpa1k/QpUT7L4afDisvZ+Hj2saaLQN/PRovVyYpxRqXacSQQAx+uV1TcN?=
 =?us-ascii?Q?4y3vUvZqg2V3rMAGeaYNI8bHiZQTD+zvKOHZY41AYktQhYji+2y2n/4pfkhz?=
 =?us-ascii?Q?vjt9yCtSdIsad0bOllUUJLRn2e0YY6MJ8k8egg2xbQ5fVaS31knv0w1j2Oo/?=
 =?us-ascii?Q?8IPUjfSFxmO5yUeGVPzzo8EKnYriszFKo/3HdbSE+n303w0thK6fqMXmSGJD?=
 =?us-ascii?Q?7IQgdLRhO8AVdBL26+1n1tL61uXUG51MltwT98endLf6DLPzLN1CZAqAvoIJ?=
 =?us-ascii?Q?2xBY3omGKQkt9SjSBM0VgI2Y4zPiRTeGkk3aczK8qg8UI8ywhw3YCyYa99dJ?=
 =?us-ascii?Q?7s1W43eCee6yE4PVix2UpSflKcNaXONOiaqchbUtKIpun6298DGN/GAP4PLr?=
 =?us-ascii?Q?c2cVty8fLvEBQOOvJoYPUpzlE79I+WM12aHpIzfXgCNWOctcgq79YYZ0bgt+?=
 =?us-ascii?Q?wkCbrH0J8Kiu33xp4dWWEdxfNdGsUbD7McH4b9ry9feJOmmlSCCHBPfxNGNJ?=
 =?us-ascii?Q?qYxd4bJwREcWE3tu+hyo6l3/c+zVECw0gawcKPIQDqRiFgn8mbYxP17DEc0m?=
 =?us-ascii?Q?ebUPkFNCjCwxofP2iDz/NCLprOYXKEFgJJrw2kDFBLRw6KJgBvGPNpsZlMNq?=
 =?us-ascii?Q?QggcQDoh132hjLHuJnQ6krzT6TY2d4FsMutHgweN15Mb5WLBjhOvdoia0xyZ?=
 =?us-ascii?Q?kF9tXn/SID7tr5UbQkfpJmyPxQUblhT+xswmsZDkyeuAzIYxO5voL1sTTxFU?=
 =?us-ascii?Q?x24y0pgUb1ochxmZ3Lyg6e/CcOfeh3mQFMiDzxEt7D86HWBP1iAglB4NSnoX?=
 =?us-ascii?Q?J3KzH1p/YhiFLDwCbIZMVttySDsHcrk4KWsOOiCPozpyogVLEPIXKSKU074m?=
 =?us-ascii?Q?71SqrdRIaMGsL6enzKCGiGgVj9vBc+Xjscf7mgTaawslJ4ZOFM8xOqAm9F5e?=
 =?us-ascii?Q?sLQtKG9t9B1K9oj4luWrNAiSk+f2pE4pzoYFZbulH3KO9k0eP28pGlt1j0AD?=
 =?us-ascii?Q?0IzHDofhMeKcslY6cryfabdKhqa2mWJIq+VJyIT0v8pHxSKx1KNqPIZAFe4N?=
 =?us-ascii?Q?JUOkfMJ+KlSdFxfM/B1H6IHwAnKLEi+tcslRqc4mxotdVeJrDwtMgOqM1J5x?=
 =?us-ascii?Q?V/e2vDHKfUS/0WjWVXEdRmQwp+zGNku+ld4XGR/CCvf5c/2gbfXRPXwPkCVC?=
 =?us-ascii?Q?v/CXw5CCTEGE9hhhEPhdLp9j41qQON7i7pyG5Ya8oFJtFAJYXqbYsznYCiSp?=
 =?us-ascii?Q?N9r680vkeMxtO2uomQfGu985Top5HYs5Oo6jjmBfDLYeY21kvfGPGab+YvdV?=
 =?us-ascii?Q?y+iQ6YI1THjwMS/wX74u5itG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adef6f49-28eb-46bd-355b-08d92a2bbd25
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:15:59.7686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVwm6YTG7sDvHi0GUwPBmsurfJYldYEr/74J124puN3x/fOtFQqK3f5xb8WSdtesVmunPFBDwObdgpxilMcclg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt property for realtek phy.

---
ChangeLogs:
V1->V2:
	* store the desired PHYCR1/2 register value in "priv" rather than
	using "quirks", per Russell King suggestion, as well as can
	cover the bootloader setting.
	* change the behavior of ALDPS mode, default is disabled, add dt
	property for users to enable it.
	* fix dt binding yaml build issues.
V2->V3:
	* update the commit title
	net: phy: realtek: add dt property to disable ALDPS mode ->
	net: phy: realtek: add dt property to enable ALDPS mode

Joakim Zhang (4):
  dt-bindings: net: add dt binding for realtek rtl82xx phy
  net: phy: realtek: add dt property to disable CLKOUT clock
  net: phy: realtek: add dt property to disable ALDPS mode
  net: phy: realtek: add delay to fix RXC generation issue

 .../bindings/net/realtek,rtl82xx.yaml         | 45 +++++++++++
 drivers/net/phy/realtek.c                     | 75 ++++++++++++++++++-
 2 files changed, 116 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml

-- 
2.17.1

