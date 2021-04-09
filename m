Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C893598B3
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhDIJIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:08:01 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:40854
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232878AbhDIJHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:07:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpOcoXHUT+FdfaxSLy7PoQWV6iw54y757LTawFAC+H96Y2h1GAhSvuUmN6NAVB808tbUO/Pq2SlU/WGivz+RIcOUQZkUP4KRL+U+A2gyb7MHRRezKfM0rJBQ8xUjduci6aq7DFQ4W9MaixJ2aqZc5iWOdabwTt5TvaGfK9neod6UcjUSYIwcpRZ3qZi9K47t20JM0FHnx5EPtG6lZCfy8zxFXWLq68POI5xi5RLSFmzjzBLzwMLGcf/tDQf9ctZJIxEm7Qpsm7lJ9DZOtO5vnSwDBJsA2anQ2wxZTkT94LsVtgXfWfVOg6RpZEyARTp6NN2sBfDZnWv2ZmY0Cu0Dhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHY6EzVVQcKbIMNK7n29d9hc4VnG0DLip7bPBB4Np/A=;
 b=XqdPGNbiAZ34Uma/I7+tk1i8fPLuPoMYAGFjMW/4mVpUESxG0SE5I7+irOD09uEm2CelMtriGNQIFJUE+EB84nd3GPeDL5tdFsK5uZHOuoevGMpNGrmlmU3RHD9k1svjAG6jHy6hbcyFaUS5CkNYcAy6UmLisETLG3aMILdDEboC9/KiPvJZ2clU6x1EpkgDyh3kSWTjXwbHHwTuNr32zEBamFMZSqzoqug26a7BEwrZuP6VsFy4MBrntoIdv87nPSYRo1NnpPQ3lL8UH6gu9s4hhyXr+Sb1+S6cVkXx4juxOb1qDc1jPu/au13g4fbdFzWylDIhHn6hL/Pxm69QFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHY6EzVVQcKbIMNK7n29d9hc4VnG0DLip7bPBB4Np/A=;
 b=NLcUZy9SI2ODu7NmKVUd8iPAzx5gIwAoS5uocOKC/X9VVJAY2AxOvoCcHpJhUYCIhyW/ufS6NrG5YIntUWxch+0ce7mQujL7LoQnTBwozrd+t0+5inEF8LqRRSUYBhWQ02jv8rdqDSxP9e9vDXVQG6dMr4dpdAHMZYdWHSZPtxU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Fri, 9 Apr
 2021 09:07:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:07:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH net-next 0/3] net: add new properties for of_get_mac_address from nvmem
Date:   Fri,  9 Apr 2021 17:07:08 +0800
Message-Id: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0184.apcprd02.prod.outlook.com
 (2603:1096:201:21::20) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0184.apcprd02.prod.outlook.com (2603:1096:201:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 09:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b43865ea-4f8a-4b46-69dd-08d8fb36edb8
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73365140EB2E7C854066BA41E6739@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QiL2m91xJdveNkDPKbpq39wXRkYYVyUo2/9uDHS/eR+4ZsSaJ29fDQaJjf4iEZs4TZcJwMwHXn31qrrlaEj0ekx6H/TefHMHkQWKa6Dri4qxA5wWYmnlcSRVqQApTEVHmH4vlCNmJO1pV/S4HEpquD32pypnGCm4wdAbJfhrJ6C0hqtUFX6W9HTcA3bhjZo9o+fWYih7cPWK9pIylOihtHhCz9w6PWgK+uf6JZS1AZO0LQOPK4mzjMnW7J5PCrcXT04bvACD8n4PuFstXpUA7s+Eo74qWZOFY8AgqWAzF9MDiU78RAzEg2KA87bKVv1u3ubSMqXC5LWRIKnXMSQZrun0ptEySHchwFrEyBDVE60wVu6cbzt3nw8mO30sMzv8DnyiAgzc1oRYQE8aaOp+++UpNOy4/DKPuTMNnYYhU5Za/+d4fYYSawy8qSyLTszxH/oeuN7XPm/tKAzXFOnoWuRPMQvArWvyZDnZPHPRTS9B31TyVm4phIJNxPaLmwZn7P1DmVoFGSgMcqBE5vtiebYj4eikUiC/24LfG0oCzbNnFe9o5FpkjynigSC1SNJ1ayPHfYrSYsHjM9PHLQbiWwimYtBzJ77AD5FP06TBEdmVNLYUM0ds5MX+haAn60Qasd/fUhutGb9hfACdQhqRx7FavGJfrMvPqo8RPYwzczmj7G4ibFN7PG22oCFxWgOtx45AN/Z85jBIViagHGQtaFvLXsT36XlJpG8v7/QLs9s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(316002)(36756003)(6506007)(8936002)(8676002)(6486002)(52116002)(6666004)(6512007)(4326008)(956004)(66476007)(38350700001)(66556008)(5660300002)(69590400012)(2616005)(38100700001)(83380400001)(478600001)(7416002)(16526019)(26005)(186003)(2906002)(4744005)(1076003)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lSdOzOuXz2LJULomDdLoQrkdG2v8EWfC8vwO1hRyC0lWZeqfPFZwxja+iJdJ?=
 =?us-ascii?Q?w8tFaHRYm3dOSDuYUkxS8GhJOZk/+0oC6ADd64QbsLc3JS4dOtCNz6qg29pW?=
 =?us-ascii?Q?f4Q2TBwGW+xgbVnGgYytR1rIb9dhLBkWvb7uwuKwUXOP2dlStrEJZ6ChhDIT?=
 =?us-ascii?Q?Z3xkt+S1yKe69Ij9jw4Y6aBb5kF/Q19uMQ+6TaftrmGOnVR4kIKsLNgyxwoN?=
 =?us-ascii?Q?ow8mc8pASNXH72O+mMEGRIiw/XqX7CLNIibEmbTspAFzZjpig4/kBgeiAdf0?=
 =?us-ascii?Q?ZmWypOUppLazctm0zctcLiU+M3yEh9uW8DLEgo4t1WGw1hh/N4P+2Vn2qzaD?=
 =?us-ascii?Q?rDNZTZbnm2yFN57lx4xI64CCBgn6CoDLq3zeKi/0Aif9bMe9D/IodP/U4zxq?=
 =?us-ascii?Q?LbDc3IOb5F5djF9QXT04bY9TT4RtpaDgfG7b3S40vckxaqohub9S69iTaIRi?=
 =?us-ascii?Q?ZhcCTbT7Iiv7rM9ohHXwYFIA9nI8FIsrHZ8E91EYllRmqY95QqN1D4bWVoeC?=
 =?us-ascii?Q?kA8X5RxaVWpN937RDo19Ps9VDRYmlrDUoXLIog4tWOui3Zo+tA0hvc1N04pd?=
 =?us-ascii?Q?zn32cAzbE4vfwFyvwwAZBCeaphViPwpEd+cYV/06K7vdLQAT1Od/oQRoMNkE?=
 =?us-ascii?Q?X9QZnCCqrJrnR2u95wBKmkAaQqIqHweN667jugCNA/ImCfUObqe+x3RaN7Up?=
 =?us-ascii?Q?31vFV7TLo0gFxcsQsKxcgj9YrqIpu+kB5lKhmegeUSRbK/rK60kapJ01tvGm?=
 =?us-ascii?Q?ZSGnvp919PGHswyXzUkhHPICotkKpBF304o1OfosXilALcNyxHXJYW2x2s9s?=
 =?us-ascii?Q?TsPSHLVAK3XQDBlPMJmBKc912yFCKgQ1HCWzveJEmES0IsGf9evarNg4fLMT?=
 =?us-ascii?Q?/jVomLsI60M/PtSqwbQgS9byuXbZnv8Ji5dMjUkcEssUIEFock+fGJ/KKHuT?=
 =?us-ascii?Q?xvwvJnxQzE125UZwvLP77ZzJnZEIQ5AxuEuQOypMYezKdxg/fxsY0Rlg2fhx?=
 =?us-ascii?Q?PV1C7tw56OTy4IiArNJIZLEk5eM9OdhYhHS07VWT5ndNwoc3G5N3dVGvgGbb?=
 =?us-ascii?Q?ZjczAmw+NgPXsPy82HsbQboTG9W4dlNfZRtswLL1PA6T5Y8II3VM7AAILnYx?=
 =?us-ascii?Q?SAnUMDJWMCoxwcWG8eQLN3Ex2XBlnWrY24aaHVUgP5IPHHGWjuTcVUtxxCoN?=
 =?us-ascii?Q?HyZJ5yrWHHu38YAlognT4RcUaoDwi4y/0L9Nn824AVwRciAx8d7EAH2oKYCF?=
 =?us-ascii?Q?ibA4KoePeEUZLGJidVnQi0pQa3yTr575G2IXpxUoX2zFxNOMFh7s5ZTapaCF?=
 =?us-ascii?Q?VnWdKFb1hDtiNMW+7ENVtJUF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43865ea-4f8a-4b46-69dd-08d8fb36edb8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 09:07:41.1252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZe6bnvNYLfVciHCIqKXuO7E9fTvH7wtx52tr3dFfw/ku3W+PoX2z9OEn9v/Orb49ykUVq+/+q64MYV4sD29ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
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

