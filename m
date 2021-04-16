Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D7362BB2
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhDPXDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:03:03 -0400
Received: from mail-eopbgr60090.outbound.protection.outlook.com ([40.107.6.90]:48005
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229719AbhDPXDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 19:03:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpueCVAdRBBy9Xz3cJxbJThzZHmBsb508+m058t06KmNVRTyWhcmvJJBV0nVbHhN6CpkMIrcQL3ItnePjkWPo4PiulzkF25hWzi4s0fFVBJ2R0/mPdWy1DxgSdNdz/rC/CXVKDTHMqAxjW0vWg0QKF3q//LHuyYtSlthVQZ2MtvUKCf3j4NMOQy4xpfha6i63LZqAhB2sv2bSgWIE1Nvx9IalcUafaVHOUd4XO6WIT2gex5HigCZyxszoCNsYSkpiMXk0WOqE5FeFWV8H4/EuNzGTdM5mkfjXFKwj4q7Lk4CTD9oufLXQHceygEJXObJTnTG+qonpgOdTfwP1iGsgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPzNeU8hbunu3IuW18YM77k4Sl+bfOg1bwvBLi4WQWk=;
 b=BGXy5Z/NM89cPm1cj29HvWWVZoVDZQbYrg1xbSne7GjItFoBxxq7CMtvC7zmFap8kbKIynBNBMdBnpOki0EuGBYJQQwjHrWrMkS4lS+/wE9SITmmnsiIfC80i7t8y9utZDopuRVbZ3LbfNNKP0fMAOSrrNRmh8X3nkwL5hH4+1GBpJ1p2mg7AKL0dGIRkMgOUyZR+E5n+vd+7Xy9QH0TyN1lzNgf5qPDR5JwDGeS8x+XJfGO73ir87A3HLDZ8tQrv92cDrETzYls/4QzbvnaswqPxcqe5tKzK84oPgTprIxfRmUmV/bkWJ79cCC6RzWoyWefW8xe9fXNY3x7fgtttw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPzNeU8hbunu3IuW18YM77k4Sl+bfOg1bwvBLi4WQWk=;
 b=n+slOiDeYTM9CRzuzIXCZjuQROQtc49Wl1oTt3y5Ink8wvjdEOmNZhgLdXeK2uNQ/Fp5s6BcFsyjoBqo0cUN1biq5C9RCU6hvcL/jpw+Lhwt+sqKVq0+BOrsHrT2lseGFJ6AZSPUHGAmg7oLx8XsXQUn3wq/skJnxIp6bTFVN8w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0090.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Fri, 16 Apr 2021 23:02:33 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 23:02:33 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH] net: marvell: prestera: add support for AC3X 98DX3265 device
Date:   Sat, 17 Apr 2021 02:02:02 +0300
Message-Id: <20210416230202.12526-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [77.222.147.22]
X-ClientProxiedBy: AM6P194CA0016.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::29) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (77.222.147.22) by AM6P194CA0016.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 23:02:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4387cc2c-2ab9-4129-1c34-08d9012bb7db
X-MS-TrafficTypeDiagnostic: HE1P190MB0090:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB009094A2CC37FC5DE6AE1946954C9@HE1P190MB0090.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5feNcVPjE+qfprZzStTFRFdmOBQLBYJJK1GQBfe5dO6g4PYCGimfTiQTqnd0OwfHtM8EzpgzxNddzAe7fXdTnJgF/DXgsHrMs3d+LFjQtdHacNq+Ujb2M3BytN3E7QH83tEO2Gd7co1g7rc9FWzm8L57EOf22DEaYrENmcHOfsnavjg7MLjWZvUfY0DsF0TKinrHQwfY6sgktsVqQvvgzB4gO0lB0tpjH/ep6MiTHgPz4pYtFJAVSXlrmzJGRW6E28UqzkCGwaUHB1i85R/cQqgDv5LMtNB9sEUo4NS0yqjITr9CD1209/L9NYm1KnSNV6sUhieLtSVyDz0bAj0YFloqcEeORVm0OxO8C6RR8i1QMIDZEau9DMeLMgUQ9qxg1Xjb2rfImaXOWTon5j1CfvevWIU+YGMptynTp7F9y59C5eS+fMK22Hfq7N3+Zllm4u3ivemmMtGqTvgWa6k5aRLAJJkHMSRE+AR8xgZ0zKRqtTyCKdaUrZmTQ6DtW2CyCN9Jl5joVBXQKodpOTVJxw4Chce31jxg26/fSB4nzRFWLgMK2tHC0qkpljgYDfVlgpTKISM51SoIK0WHQI6eIXYl1qBHVvgvNOQffxaOoyWSWlHoPBD/qLDWYEizjcO346xOr3shpanx6QNdoYTbGGL3LKDziCdHnBMq8cDbEsw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39830400003)(136003)(478600001)(2906002)(110136005)(8936002)(66476007)(316002)(66946007)(16526019)(66556008)(186003)(4326008)(44832011)(86362001)(6666004)(2616005)(956004)(1076003)(5660300002)(8676002)(54906003)(4744005)(38100700002)(52116002)(6506007)(36756003)(55236004)(26005)(38350700002)(6512007)(6486002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SaT80K+EDBqi4nstuXBrBVYQihDR2okP/hk1CG++i17ge9gCNYjYddYQ1Pzd?=
 =?us-ascii?Q?8vwX762kLxW3ThQ+SYXkoaqM3feHJovb+T3hh9oMszB2tcch6yIybSeqRAJl?=
 =?us-ascii?Q?YUlJNOLnTXnewFt8ikvHjm/RP2L1eyk82mOZ46T6jBlaByNUaq69SFfuoqg1?=
 =?us-ascii?Q?/2kPS26iqxIc/xBATKreTxCBz2I7jFb7zIfnGCyzLF2DqKbtbBl4hNj6zNfS?=
 =?us-ascii?Q?Af4l1kDMlNlFL+57VN6tS5bYTV6xwK2tczp33VVuXBJ/rx1w7CskUdjBYHFH?=
 =?us-ascii?Q?LyaoE5paMN13g3i3iZy5zxmXr6x2rrmlMroZH/onTmofLTWYmASXu5Y7REDo?=
 =?us-ascii?Q?CuyM9ZoOWknwPR0OP3lF8457sf9h4OW8XUrb+MZb/iNaCNkzuSBMslezYHIk?=
 =?us-ascii?Q?uscwdDlx1w1OCjC9EvL82H9r9r56FNgltGkUjkAdTgDJpkFRDqFryBjoNWDo?=
 =?us-ascii?Q?p0ETrY4JFqdRSM+qPk4J70+FyzEiYCQRlIbna2btOHJO9jFQwa72+71Sm9j7?=
 =?us-ascii?Q?iaMx2ColD8EUsuU/w9H3Xvn3apK1NBsYTIsg97gNBCH/zV2Khe6Pz275D8+D?=
 =?us-ascii?Q?VSJdAeJWeZiNQP90aGY3Bvw3kPNc0j7ZzRnfHv+NXFjL+vIoY4LISiZDWnef?=
 =?us-ascii?Q?Z7P8oOUD2zMC9igsIGFJVzgMAmK4mPWq37acF95Cdm7YL3b+4kjwkhrd/QUP?=
 =?us-ascii?Q?SFQFhhNkXcmZTzZElm/slbUYBzdG9ujp+sGJhiZRNLqqFPpEBEt9oixLXBQ0?=
 =?us-ascii?Q?9omq/KCk+tRg6DaRahl99wSqYDrFIuSEr1V1R/0NEJk2GYMuknlarABOiUmM?=
 =?us-ascii?Q?cajG5wwNLoiImuG9k0nrGjhXpDFDfcSAeRiKQTA3xxPfarHwAj4s356G2cZ3?=
 =?us-ascii?Q?30UxEULknoCLg8p+WzZv702gksrYDby3iXaZoqV9TpDeptTfxdam116FDkYc?=
 =?us-ascii?Q?exb2+Njuj9vfriVw7BgaZbIFGuxh+3F28xXrk9e27wInRbvj+Hb+8qtVmA3V?=
 =?us-ascii?Q?nYkeNfZg0NHDw90teVgfC19x97I8/b7tI6ZUOn+bN/5Cfrd8DjHpALUprtXM?=
 =?us-ascii?Q?9DtlpoYoKmihxbjJE1EJaL1eCOrPiNpBOAsmG5ACrHhGH9XYpqBqTzp9Tail?=
 =?us-ascii?Q?du7q+5H4kP6IYaYRX9u7YuMq0LOrbtx6gGbQIo4trhvKLdFBzSInigaJRbD3?=
 =?us-ascii?Q?UjdoLb6YBqsmtRofOErdus3JwnPJ4iUw8+6nqlJpWvEaXoLpuiSc/gLg2L0g?=
 =?us-ascii?Q?V9LtzpYnErbsCF9gqcVppM+wseyD03rQhAodHfvev9d0/zq5EV3/TqTKIY3h?=
 =?us-ascii?Q?HXaVcvZgLQ61nZhfbn6F7b1u?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4387cc2c-2ab9-4129-1c34-08d9012bb7db
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 23:02:33.1456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WCRcGJ95a6udy0HxKStMtPaJst+ifuxV/QLiV0jCdNni5Cn76Pv2NJCOafHteG3qKRWdcC7Z7mcRRPn9rQxyMd8C2U0VvZnqx4zxX6OWsmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Add PCI match for AC3X 98DX3265 device which is supported by the current
driver and firmware.

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index be5677623455..298110119272 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -756,6 +756,7 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 
 static const struct pci_device_id prestera_pci_devices[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

