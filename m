Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259AA27CECF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgI2NPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:15:50 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:63190
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgI2NPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 09:15:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqwP7kuHkrPQJqklItw0LKC7Kac1m+bLiXm7PITy7FXremUWnTgR+WfggQQg86vz/lkbavNuCIPU5vPzxF5AMHzz376/BT23LW2Calxm4Lr8m5LkElf0Lt99z7zcJAJ/Z2QYzktsiur696rNm/idNxxTDO5Vf3Z6XSTOLAvq9ydXJeqmjOCnlmtw9yIPM34e7iTtaHTTiVz7Aqg9+swRzThrPZICN1Oz0t03c6esjZoVqaTYJJLnmmt5ejQK9a2n4Nlo12YItH6fsNjYvsUfBXJM9rY4hxCC2pj15KMlEWVlZ/pQtTzstfgq/IG89HvW1cY5U903qjYvZmTMuehXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA5KhoFogSbt0fcvb9wD4jdJAOpcV8gsTGAd8jIs/do=;
 b=hQSTJblUrV32rVG+Xr3aD3eSrxLhTeJvT4KHkuq6uaift40SZAvSQ/mfD9/vtCNmm7aaPes7Qx3KULviZHQV3MEDSEgKJIfNopFMz0Aj/J/18JjQp/kNGbUT7e1kdpa6rHcFZ9/KMX5KCCsmQ8LU4QFMP9EDvVcIYNedRkKLkCDDap1/yX+k2/K0RV0aqMpoq3T1NGd2P7Tk48N1nVJaGwFabjJj+z1tRfMhKexsDPP1/SOEyyjiBiZ9xpZK8CWp33TDeppW2qfMg1dRhjoh+U4+Tu5jBWK9LZq7wM1Xy12blWtyTpJy5j/vuW6mIAPIsVw6yJeUnTtq1oOSj/6ErA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PA5KhoFogSbt0fcvb9wD4jdJAOpcV8gsTGAd8jIs/do=;
 b=asZgKpPtlFUwVUdobkg2HqyALJYDQQeVSZ6ZndU1ZTC16n0EI4ve4XdZu1X4m7Zj/Ej02BvbAzzXSQCRerC1dFFZmJt0yNAT5RL+Zw6fOSujvIt/Ccau/jHmkrPUJNidP3AfLYqrLsaqnC3ACvasnUk79PfFEelvlrn3mFL2A1o=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6347.eurprd04.prod.outlook.com (2603:10a6:10:107::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 29 Sep
 2020 13:15:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 13:15:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 0/3] patch set for flexcan
Date:   Wed, 30 Sep 2020 05:15:54 +0800
Message-Id: <20200929211557.14153-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0189.apcprd06.prod.outlook.com (2603:1096:4:1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Tue, 29 Sep 2020 13:15:44 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a27836c2-c1b1-4a58-7f78-08d86479c657
X-MS-TrafficTypeDiagnostic: DB8PR04MB6347:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB63475BA84FC8A4FA19D4E908E6320@DB8PR04MB6347.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LNSQPGTsWLEVZ1KuOT2e+3AuBjCYfnWMy1QpJu4OX0t7j1H4/GL6SqHgz/2eJJ/E9GhjWp1zVL2OHbIiI46x99DdsM14XgPeK6sgVK83BCQISm53EAcw1NrgK4uh+Iq5M88ynzdcy1XMJF6wZJ46wzZOYYZ9CcTex/3Bws10jyC4itEOTo5jw7otUOxUH0xmDfCjyibwHX2dIUtm41tt6XnGCGiz1co9it1mdo6C6dmOrlgW7bAeFf5Mxn3tYtf9nJC4wHz2fNj6yASG6qF9jmqjhdvg9dtJ1YfhpqpSGB8mzTROxhb1s24gAalNH/RTDCcOGbP31rFL1aMjqc+Dw/eSW6Gj+Pje47P7eZsxSg4vq9GeKfXZNKZduhLaJyKC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(366004)(136003)(36756003)(4326008)(6512007)(4744005)(86362001)(66556008)(66476007)(66946007)(6486002)(5660300002)(8676002)(8936002)(186003)(16526019)(69590400008)(316002)(26005)(478600001)(6666004)(2616005)(83380400001)(52116002)(1076003)(956004)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bWRaVrWo4Xst8fQ9Bx2LIEvE9D26pfJg2boxie9MczWv6yDMMcVltNIJuYKMiAgLWvv8Y8kUJOGCQWzflPHSYKJxkwC3D1I4XDQNvLsTzukcIaYnn/D6Wxh9QDmAAWWTloSs7ecZcfhZmPZgxu4YpvF7KHG+XSMq82oHdfNAnwQid3hCh3p/sGocjavaklAtpondpb3dSq+88XFT2h/1pJ6YDyX/NGrf7B2i8JElfQyDdM2YdHY7Q23fhZ5woSZFOLnz+vNOBqVtTkufNVhT0hvxwjmbLbX7VrnlWFjuPyEunITM46qpVxOiWVg+H/5qffa0c8mpzPPhi24XrMmwYpu6M1J/DpNMrxVmTMcjFm78kZe55AqBm5bp8c7zdR5mXc4aOAmoCb6WG+QlveSGDWzBoZuvui6W8eFjTRC8QtLkzI5twly0aiwRX9SNrh1+scDJcsVG2HIP2PopLjxbN4sr08U9iXNickyo42EgxfCGwTdEFQsPg2m6J2anR7gjG6rPexIM2QmGUhkQL5apkOP7cSGQ4naFLwNYCUfXmxIrfc5JLu8MGDTT4XvsJ4LKHtcl1yMettYercNwKXWWcQwjsyAHpiT/e+/BCdXvUL4EfM2pmidHFVNzFX3fY8VdFjULAKi8nUdQQLWoDqQIWg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a27836c2-c1b1-4a58-7f78-08d86479c657
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 13:15:45.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+pQodTsq/HU/t3t2yX3me0o5xGlQbbN38dxLprNb928+YjPonpeQP65Qu/yMcEQm7N5UyvpHZWUuRh5ZGoIPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6347
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Flexcan ECC support.

Joakim Zhang (3):
  can: flexcan: initialize all flexcan memory for ECC function
  can: flexcan: add flexcan driver for i.MX8MP
  can: flexcan: disable runtime PM if register flexcandev failed

 drivers/net/can/flexcan.c | 62 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

-- 
2.17.1

