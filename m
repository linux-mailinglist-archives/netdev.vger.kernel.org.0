Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD1E3CB614
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbhGPKbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:31:55 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:22652
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230287AbhGPKbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:31:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwH4ycLDNp+iFoefoUBPADKhX0JAb04o+RSldspzsPXLJc0DDrMU/2ivMXgObTnP90J+GNLzZNfIY/i9OiYeLdbQkf+db6IE8jycYnSpHT3ULgWauDeAEz0deTc7BdOVlbx2yjY50ugVZHsYp7drU7pRmrAiOcQWdA/JFPmc4wpnpFYzp0zdMEEfCxafVGS+ulfxU3yFORvvikegJgBiWFbpcazmreElD1XwA9hfxFuu/bQ7NWNzeCL5VGR4oaWDfTcaCdg4Z6c2qot3jesbPBB3HzMuWgibV/JDsPbtSAQZlmcNnU8RDpp33S13Yd/V0lMAfmrcG0mmxCURk3NZ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sO+sLmsngCElUBJQP+5ttJXwX2VDRTGjszRK4k69Ts8=;
 b=KZjJ9zqNVqEA6Axy4uHkqTC1gaironNK3PbT6JGmuLxCkVwBFJIlBtYEr5DjVFnTKdshDVMH5WQiMvvg4AVSpo9ebLX0ufnLI3g00RflObeMQH5QMmSFNN0gwEK4pnx6Pr5OkJAy4vd791GAwhC9Xn5nVTUFd6mOL51MOS59JNR47lVTQh3dzDSkYMhFH2LNL6V2F9hPeL9pnPqSjDnj6wPF9LOgk5FgYSU0Bn8IvGWiY1Q45gJ7VjCRoSwH+duaZOSgyAju+FBdqtRhkXZLg/5yWrZpMk5fOLIAmAShQ4DAtvwBchfdks89carUstaNLYYPDSXbrFvQjfoo9EoKVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sO+sLmsngCElUBJQP+5ttJXwX2VDRTGjszRK4k69Ts8=;
 b=HBO4pd1VmXrvA6lPj+DrdKrexlWwIOLj0j6nfSQprKCrjrORsC9WBu/R/Mlbo0d1g3Ntf2R+6Idg8l82Rse/BJL++Tmn2VTDDijN+waAekrA7DFQSi/4AAf/1rmkBbpazrexozR01JorrUOnpwuzcstsbYNiUHUwNMOf+/2E3kY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 10:28:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Fri, 16 Jul 2021
 10:28:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, bruno.thomsen@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V1 0/3] dt-bindings: net: fec: convert fsl,*fec bindings to yaml
Date:   Fri, 16 Jul 2021 18:29:08 +0800
Message-Id: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Fri, 16 Jul 2021 10:28:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b18b8b56-eedd-4b54-db6a-08d9484482a8
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB272568FFEE1F7FA556745322E6119@DB6PR0402MB2725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GCqrXfS5Ks2KlNEfB+Q6oQB7HerSTFQiKXwQx8nZNVWulQHhONjeEtT3tHfnCD4Z6fVuXXOy8dysoDcGBkvNWmRCebczQSld89/ba40KWLMjSbuM0vMJGP48yDWaI6VXXaDW2eZHm2KuQng+BXD0L4zPtrlyPtRVADWd8iZUpW46GhtUflOxo+EuHbI7VFZw5EtCj7G7uqsU4c0ZoNZlcgvyMTsHcvehbGkhcOCV/xY3lkvRlRrWuMXUADHR2xidDuT2UKBGG3W8/TbUuT+ZcrZ1KUg276kRPgEVkfkRVpRYLdwIOSuV7BA8NrMrU+de1X+N1M/400SNJESpqxVYX5RvjmgT4zzrVY58k+BRFjjY7NErq8oY2KINNfTjJJiwQ62QmJ2C860ueDHmncU66BQe4mb4jEgvdPRcmhZTSxjLwHaedZTQVNo0o1Np9T1MogNCKQ3cnAli6qO7pNR9KzmzbUevErk9H/ynMidIfTIFglnAJYDIVsCEevdKqa6q6kb/256QrYPMk2YbOSnvn1GU593kQK7vqY1cgHCo3fmgGmqWZVBxPMiFuqZQqW4eEK76AcHhmw53xRuoLyo35fLruPLsOA73UGj/hVCgC+yB1qpdzOT//84n+FpEXh89DEFXbfrtxl6zoFSbPdKGXjzwnORnPjOCDCnqK2AY4GCjjupFON1fRXjpixQl8ZvTggBXiiHNPpNd69Q2RCMeWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(316002)(83380400001)(478600001)(5660300002)(86362001)(66476007)(1076003)(66556008)(52116002)(36756003)(66946007)(2906002)(4326008)(26005)(6506007)(956004)(2616005)(6486002)(8936002)(6666004)(7416002)(186003)(8676002)(38350700002)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MpHQZTullTnWSLD1YqfVGwup9FdpazIs41wxn3UEIH9H+oGVV4zu+HVbSX19?=
 =?us-ascii?Q?FNt599pyC8wyRRFExeyXeFtDJcipWuAhasiB+RHUjkWdUBrgl+DS5PcQ7xdn?=
 =?us-ascii?Q?OdGh8F1gbk7Rwn9YBZLK27PS28WJJi0SwK8ghvwaq0HkgCbU150KfX0S4Mth?=
 =?us-ascii?Q?hK7EzAYgYJ8wvjZdZIppRDZ3feG48gd3XrWhaL+dISshHQtDxPasQQADmckH?=
 =?us-ascii?Q?hox90f05Spsfng+vrjqRSQkZsAz6dhMcTpCgAyeIv7bLIDH2lfjIG6JzL1Yy?=
 =?us-ascii?Q?BV4qnPr04YHKQCMG7m6Xz5ytuqPSw//lImbejDjlHEmUzaaVQzkUJukkRGHo?=
 =?us-ascii?Q?PPwHS+Dfm0IwbiaEhPcZ9Mbh0dQ5S0UEVPBiyb2zvkbl7EF589Pj3UAbUTf3?=
 =?us-ascii?Q?vwO/Bjp4mMr6VQev6lcsmLNMWGbMccIVMq6KcpbWkHXPBXqJyICOqw7D0NF8?=
 =?us-ascii?Q?1SR7cCBYDTEMm5wmE0PmFO3aocxTWL/Nm+Rb9zIoJ/Uh059LgiJLZBUdMVxP?=
 =?us-ascii?Q?7bdrXPL/3XE26xYadJofJBkhWXUYUVBgCQZVXtPqcNwOoG/YwVaV4LEcqhmf?=
 =?us-ascii?Q?1PRv0/4n+f82Lww63sr/k3oUOf6zFGKrRGWTjcAp2+Cx0uRokfqwh0cwgUe3?=
 =?us-ascii?Q?nYhf+YKPo/YN55UsOhg/mtH6PbHc3aiRE6k2N3G+tdGfeQ/e2H1EW4KXBVos?=
 =?us-ascii?Q?E+WVcWupRvyhBl0Kb+/gDTIgp7vU9+T2DR0wM+vCRJpm+OWa6optlx2wAqZh?=
 =?us-ascii?Q?Ex3tKzlgayRpmKlDZD4xZ/ASW/EIVCbpH/famHR9QONEk7FRbnbuSIynPKyl?=
 =?us-ascii?Q?n57PDjqXrF8nO9LcaN/JpSxY51IZFvHOhObugmlXy4iLCuyAbTNWKg4HXQQ2?=
 =?us-ascii?Q?pUViQbphQITkX6kquMN9DuM5jSFanrP04iq5c1oVaHrypz9LSG/RKOeo7WOr?=
 =?us-ascii?Q?1xe7zMs0t3DHl9wUXKHtshSuQrIdDXvyTNUi4LPUJrqVc305U6qTaWdaPu7G?=
 =?us-ascii?Q?USiNNhsR85/xyeZmhJQF9RvWjCTjmTWMd64vL0iO1ckyyJJOwHwDn3uEfDky?=
 =?us-ascii?Q?GR6P2fNPS5I8hcVAwuNj/PgG2a3MT0og+vMC0KwnonUU4OOa7EO2nKnA7dAl?=
 =?us-ascii?Q?K3YlsRSzeTwRQSM2k4cMGkDUEz32lzsJKvUggQ/YbbWgWGx2+Pnd4IwbWtPA?=
 =?us-ascii?Q?pWszdAZfUBpjbMJEi8Xxm07wGOD0sOFm6ngLXVRfEnQu59o2g3bboDpsiwI5?=
 =?us-ascii?Q?Rmw40T9Vi+puRrXirWNxrybyD2n28ohHhIdfTaJpp3ehVic4dM2ysY41hOmB?=
 =?us-ascii?Q?d3f6DmzroaHlmVXpwStdgKgv?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18b8b56-eedd-4b54-db6a-08d9484482a8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 10:28:53.9643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MnGfXsJxeQhKWjC3DTlL3my6PnJJcvOf4xkfljDATnxRkdTaEkT932dtoSiaAlNjCw2o+srb2FAV0LkjKGdqFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set intends to convert fec binding into scheme, and fixes
when do dtbs_check on ARCH arm.

One notice is that there are below logs for some dts when do dtbs_check:
	ethernet@2188000: More than one condition true in oneOf schema:
We found that fec node in these dts all have "interrupts-extended"
property, and schema default is:
         'oneOf': [{'required': ['interrupts']},
                   {'required': ['interrupts-extended']}],
so we don't know if it is a common issue or need be fixed in specific
bindings.

Joakim Zhang (3):
  dt-bindings: net: fec: convert fsl,*fec bindings to yaml
  ARM: dts: imx35: correct node name for FEC
  ARM: dts: imx7-mba7: remove un-used "phy-reset-delay" property

 .../devicetree/bindings/net/fsl,fec.yaml      | 213 ++++++++++++++++++
 .../devicetree/bindings/net/fsl-fec.txt       |  95 --------
 arch/arm/boot/dts/imx35.dtsi                  |   2 +-
 arch/arm/boot/dts/imx7-mba7.dtsi              |   1 -
 arch/arm/boot/dts/imx7d-mba7.dts              |   1 -
 5 files changed, 214 insertions(+), 98 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt

-- 
2.17.1

