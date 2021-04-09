Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA55B35980B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhDIIi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:38:28 -0400
Received: from mail-eopbgr30088.outbound.protection.outlook.com ([40.107.3.88]:23170
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229673AbhDIIi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:38:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXDXjn7awqgWj+eNd90K4AvQNR8N3pr5ErG12G7bcyQ/Kj0vfevrQ/5aECaWsvAXfqXFOrCx8nsumK/CyhAiGby7hII4uaxWuicSr8hBpYsARDWkFlUwrRBN2EMUkqmOR5bIwwOp87C0xxDCNFXkAKt/GDLbELYYSJVMNLGmEjQU29GurnKh41dBI4+UXSWkNRnMYjv/NMQSVg3lIx8xAm2tpKO9Ldxk2xt7VjF2s/ju7OAHxep5KUuwXjPzjwgYSjPUgfy6fPCOl3RFty/C/rYJ7+0lXjmFiIKNfYCCZ0ZuqDzwRKmDCLonhjeIklaEUnuP5NSheR2rVLB/F02Klg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHY6EzVVQcKbIMNK7n29d9hc4VnG0DLip7bPBB4Np/A=;
 b=d+Y2LLgFdaht9xR99jhlNipn4tp3MbRI0Wj5tQJLNJ7GaavK6NFSSbviunTvBlCwERvMjwxTVfd0wlTlLc0/zniVfqvQ8n7Hm3iQzS1loSgaKAZOYFHU/DUBProIhfz4EAdnaL0gr7Hvct5puWqj6qcbDol3gv9QuvvcS+RVpl8TwssxNWxyprDzusqLAjsFBKL7sw8gcRcSF2kLXT//wicFFtwpCAhCIXYl1QmsjtyMu1vGSdhgzLBQgRJKAhBtx1dwAAeW7i6A7Jq7reHZwOTbkn2fLd320dfCdlqB1afm1Y5E2wUdgaFBzedOD1VoJzlzmrGiSyxAPHFjR57GmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHY6EzVVQcKbIMNK7n29d9hc4VnG0DLip7bPBB4Np/A=;
 b=D1KY6Jfqe900HHydpKZqc98xT0jE8VuDSNJ54GVqZiRfeWlpmGp3jQRD3EKTuVpJ7jzg68R48Qf9h89B5OGRy0GH0/aI39AwmRHhuTycAhibFl2Lz+Qva+NwZFZP8rA1o+sciFRWq1It8zo+sGhCv7hOENXSfRF7xcBG/V82CWs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4521.eurprd04.prod.outlook.com (2603:10a6:5:39::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Fri, 9 Apr
 2021 08:38:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 08:38:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: add new properties for of_get_mac_address from nvmem
Date:   Fri,  9 Apr 2021 16:37:48 +0800
Message-Id: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:202:2::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:202:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 08:38:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f917a208-ddeb-47aa-1008-08d8fb32cf52
X-MS-TrafficTypeDiagnostic: DB7PR04MB4521:
X-Microsoft-Antispam-PRVS: <DB7PR04MB452169737A6F874E58F1434FE6739@DB7PR04MB4521.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFZk2ZdK4uWu4fEs3WOWyY/g+CsDBHNT5Bo7CIrMuruheGDg1F539QjFDUhpoIchjXnxBdLs8WIqO1avQjciuSRE0Um2W0GlABqP+aKo5e946cW/SZomku9pEuE9Ml1XxLT/pIUjJKeg5Re/pSgmSG9xxBlRjtm2PnvZZSNiXXprdsstSwbKsGkfPwtOk9EnNntYibLVi2KJjydN0h/4qKya9SiAqXik+d8UbgEXqnE5WiavXRqHMNzUmE2O+73PczmmVIMtKKl9QGIppS2GYkXMtGyzYf8JoLjp5caogcey9rKuwazkscsPaCSQ8pEWF4GUTU8iBHnSIq/N2rpn1LP3a6n+UQo934IurtHZDFVUn+J5GWPFmzaM+qpyc2xwoMp2c8mrv2cyShlXLNo/43GNkZOv29wluuFLQGWoNgcr2B06NutL5xfbRq3KPdiIO/iC7Jxx7qktD5QS2huaXzhBuhR2KA21I5ksEN0josrSG8j+3l0wNNWpJf1fPd8IXptvOU6MbNTwRyVW8OFok/8GEb4Fum/DxgdcMPaZVLDTVUr3t4UlY7f0KyxSivFcEU2DfeFNRkGFW4EIoNVe11BSHZILOBTG8b7BUppJHnNxaNRPbY3uxYjPEPlxfrR7oagpeEkqdAsK7fxbIh6XTCxUf6aLJsxT9TQ5FaE/V0uJ9IAaLt3J3DoPLvnw3p3tyeahHeKduferOrRSyN06tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(8676002)(6486002)(52116002)(316002)(6506007)(6512007)(478600001)(69590400012)(83380400001)(8936002)(2616005)(36756003)(4744005)(7416002)(2906002)(26005)(186003)(956004)(38350700001)(16526019)(66946007)(6666004)(1076003)(66476007)(66556008)(4326008)(5660300002)(38100700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oCHvbLhV8Jbp/l8Rb8CinzTeaYKVUmULevQTwM+OqpjVOQCUAkgVb+jB082H?=
 =?us-ascii?Q?uENlo7SnCgw9rGogIseOYwA2zk9sScnE2ArpWdBMSvQJ/Pql55OSi4ssa1nL?=
 =?us-ascii?Q?dt2r3y+kEKZJOdgLJmeH3V5w8FIElNyE/XpBp49Ls9astmUdw+a9dUfKqUR5?=
 =?us-ascii?Q?43PTwR19E5v02jSkWKw2ueNGa8ECLzBFfYGJ5jxwPNjsTKxr7hN/pHRjY/Jw?=
 =?us-ascii?Q?WcoVxuzHc2c9YrGRRgc1C68+R0ObFQ0Poe2RlwAcB12PMONNkQelYLm2K8zF?=
 =?us-ascii?Q?dxTfFiaZrBJvOEpTjwwSFy66Jz640n/J0zIMyVOa5zSVN1GQ4HSLVBkF8nxO?=
 =?us-ascii?Q?dym/PoVpdBQkfChzY7dbU+KWT0adAnlsLuZpsUMSnGPRUBA6HfWlJrv3+/hm?=
 =?us-ascii?Q?pFXmsmdyPzgS0Iikt1hcYsAqvPkjn4J9PrGBj3Goq2GKrmdu13bUAiiW405r?=
 =?us-ascii?Q?284zlAgz48QExn0DV9L+aj7KpgAMSBi7YaGCr78EY023y6qo7bwuir/uijR/?=
 =?us-ascii?Q?hv9PpA1UW6B55GDi9L7Kf0CBkrQ/m9Lef8KJQmxl6meWJb8xm3xI0NS+QgTk?=
 =?us-ascii?Q?Bp6pkcGciA0jvLF1hA7cOaVWR+TfssWh2VGr9m8gcrWu+0KS95I+UynDCR92?=
 =?us-ascii?Q?wp+0fzzw8Razn5vZRw4HQxYmQ8lCKdvAAY1r3PlWL1NSNOU0keluZgC5fN2G?=
 =?us-ascii?Q?XVHiXIgePOxkgJeaU8x5+WBF5fR1JDbJeal23c7etpv6vc0FoLNEfTYUhxe0?=
 =?us-ascii?Q?X7C2HcE2FTu33hymn73wRNjH8j9RhD8O4mhe03Uoeh6UTSgmnMPZ7JPt/CV8?=
 =?us-ascii?Q?TJxDUkafZDbUFxsaJFDdU3FtskYTc3pVFkYSRsMDCcoSNK9pdBqB9vCO2icO?=
 =?us-ascii?Q?Ez9p6XcEjNZr2sBi+gmYiK8AnAozKIriG3FgGVJuTu8aiIEhqV0TE03U9U77?=
 =?us-ascii?Q?hzEL45n4fdVmzuvqKoA1MOfJPLkSiEB3na6BHkaGzHU2fc0T5dJzhf4g00t4?=
 =?us-ascii?Q?JfmbeoXPaIZK1GylAWkwgPZj9KKqCZeTeE+q+KlPBOQnBJ5qxMIDt5jbPbY4?=
 =?us-ascii?Q?xUJefUMznorjzvBvlMyh0DfAnN922T7rpUkjOM1iigEqJ1hcVNJOphPqO4yp?=
 =?us-ascii?Q?ShFGp0UQq9XWPuD2CJJnHC4QXoJlSz28QytrV3AHpDdPAQUP1sp3qrN2LqQb?=
 =?us-ascii?Q?7tJCbbZuVHOnV6YHhcirN9P3yv9lmMcDJRFAvycZ+nvXKz2ChcyN4iAdhfne?=
 =?us-ascii?Q?LDaqLUYRlygFn+annI+S0ciyOaxZvTiXOE/UIMNOEfH3c75+8a508cmLU8gE?=
 =?us-ascii?Q?YCM3WXAKGEjz07HZRJE1OEIp?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f917a208-ddeb-47aa-1008-08d8fb32cf52
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:38:12.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfgTwbhlbTuVmQTgJ5pWhwsYqqBmb19TuTpe+greck00FAENIIb1FgD5PQmA2UL56yNWIMvVjpcCL+QsKUwmpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds new properties for of_get_mac_address from nvmem.

Fugang Duan (3):
  dt-bindings: net: add new properties for of_get_mac_address from nvmem
  net: ethernet: add property "nvmem_macaddr_swap" to swap macaddr bytes
    order
  of_net: add property "nvmem-mac-address" for of_get_mac_addr()

 .../bindings/net/ethernet-controller.yaml     | 14 +++++++++++
 drivers/of/of_net.c                           |  4 +++
 net/ethernet/eth.c                            | 25 +++++++++++++++----
 3 files changed, 38 insertions(+), 5 deletions(-)

-- 
2.17.1

