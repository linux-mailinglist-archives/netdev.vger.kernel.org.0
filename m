Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97113C20A4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 10:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhGIIU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 04:20:29 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:47621
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhGIIU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 04:20:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Foq4hCmJJzEhWzA7z7fmR/n01e+Gvh/vOAOyf1cP6G46jq2SHhLG3NTs3jM1ZBEGhsb/tX1LB0JwYUV+p4w2EjKP0vqETuOWYyWo4CS9RNVcirmpHz6wRM8buoQ8J/vpadcghE+8E6w0wVQlWqInySn8Elg9rHdfket1+88VD2kl33wlyKFF6FHELDJU0X6R3ZnqmCIis2ODBLBzje/tOJWJCH0pULLEkkDms9w96vZY92cMuW99c/blVfj4nuRHr1fWVVcD6Dv6d1pr8FX7BdKNqkmPoQhBWFi56O9z0e71wvJOVoJcM3qGLmJrfmahbyh9ksJ4uVCbrhCTMfswyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJrXL3q1/yHPP4E7JWtm58D1pbGrVYe4ZSmMW+hSnxQ=;
 b=hweyWk6CWCz6q9cJ8uCBJSks2HPGmOY6GyJLVaw14YZSTMnNKwFms1qK3D21argD+UrytWCuvCs0oOJOyogLP5UphNgI1M5Qs+O7ULxWzwcuJcsOeL1eZ7J4D7MVrBrQYKrKMCeJtnycw3vVURfFSVTM9bTp9F9hBmteQQ8t0DUEx4yxoVo0192VcdMEbwh2dO4ejn2fQ2IdDQrOdYk4Wj/pFvCvdFcIFtZW04r5dUVDl4BILzTqFiimfLX3IVPWMESx+dxPSY0abF7a7tc/DBkkjFu8fpK8esoTsHnUF5V0HGtf87JXX39eTjwe194awqNfPfHjv10Sr3rg1Q1GnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJrXL3q1/yHPP4E7JWtm58D1pbGrVYe4ZSmMW+hSnxQ=;
 b=fK8mJY4TT4qy9sNZnCAOM+7XIZqMw7IsdLQ59xW7J5fhSHoTC66w8IccgRatFaF1PUeCLJ2+icyAqyYYevM4k5hSRtgo/uD8/AMtu9rPiuL3MBGgtIR432COGOYa2elwtP86DKVO920504g1RuGcwV17tZk8UBRbWpuDdGXUc/s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6140.eurprd04.prod.outlook.com (2603:10a6:10:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Fri, 9 Jul
 2021 08:17:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 08:17:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 0/5] net: fec: add support for i.MX8MQ and i.MX8QM
Date:   Fri,  9 Jul 2021 16:18:18 +0800
Message-Id: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:3:17::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0021.apcprd02.prod.outlook.com (2603:1096:3:17::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 08:17:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cded7227-da71-45ad-2241-08d942b2064b
X-MS-TrafficTypeDiagnostic: DBBPR04MB6140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB61403C36E77AB99E497FF152E6189@DBBPR04MB6140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xgZF3D0D53Z2cgtIpl3tKZptLpjrqYtHUu/0AWcj5yvgsOLHMmuf4E71RtrK/7artaa9jjbwBF0ExT8Lgl+c1wK8uk1aPmgLiBvLETHLLqU123MiSOI3Jf6g011VGJ2tTZw/sISVcbNhZTIJb+WpEHrtrW2qVKk22gJql6NavKwtvPrdjmby56z0uI6hG7EXATqVJQH6X1lunIJ5wXLD0ZZaNYVx8QRdywmxfE/rzH6oER6Fcb3Uxl933FYemeN2LoDyVIh0dLT+/xCou0f9hXkF4ELyEhGqwaV+45p2cDHc5GIxVyd3Dxvsjq+rZXF78kEKExhdtctOyRKCsHXBmqDJK3yOI4wNUO1PqqkYi9xIusnhuUo8FnnO65H9neWL6lzinnCvoImudtoKJs2h98mF0WKymhAbaE8/6BVyyo0lvKer2DYouW2K3xG6gwyQhZQEwJpqe1KZhAmIQBSOqV22vSpSr1WtCjz8FvFYI7uSYxG/56Gz+aBcNfpRCdL6eGFUhDKxi/J9IcGcAowXqwaMCzfNs3ITZw8CcB4qYUF8G6BWDmUMQ9GU2vt4akKWEE4Y00OeL/xdsVkvnx00+xhWUHcW6dBncyADEbCf6OuHzw0TlYWqHtOvepvyWSk9XPv4i3j2aNx9F2FZy1aLG8pkpL3uG4JLdBY+8pC7t8dbIr1IPKrKQeUJnNDNtBbO4Xy/Z+hcisdVCqhpoyATcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(478600001)(6506007)(38350700002)(316002)(956004)(8676002)(6666004)(6512007)(66946007)(6486002)(186003)(2616005)(26005)(66556008)(36756003)(8936002)(52116002)(2906002)(4744005)(38100700002)(1076003)(5660300002)(83380400001)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4fRXfRsDrG7UH3r0DMoliU5lIGC59MmAiGTH4Ozg0M9lRgbqc6BNtJjnPAlo?=
 =?us-ascii?Q?5G2pvadbNlAp3PIyb1twHihl2zsmY9/c4IwfJO45Wvz4VqHcHfHr6WE5hEsy?=
 =?us-ascii?Q?ipG+Uoj42UcfblSaZypgU+qB9tUe+1jpgpS4tNotptb0iA16CBqrxXQjlhwD?=
 =?us-ascii?Q?HH2aKNkfqB+zIhX24WB6jd2hDJT+FiKqvvodwZeiDRxgTnqMJg7VqAXEGYGk?=
 =?us-ascii?Q?JF0PQeMj1UkAJZp6vtj+Zvietq5CjD3/GKhWnVIse7B2rbzkJyymF+JtrD7y?=
 =?us-ascii?Q?6jImQ06ydYJ0iBkOtFHsM6FbqsOHl8QzoLtWmolrecOz0BFx3XBBKPWhc/aa?=
 =?us-ascii?Q?aChxmMKPHv5UTU2tp095TwEK9G97JegLieBidStskb5aXrvFjgFUM6ZEPmmP?=
 =?us-ascii?Q?5+lqds5JOGL0n19PgzkBhIJfS2PDJ0nU/i5OsSnWvaKp6d/+vZ7U0AsvML2N?=
 =?us-ascii?Q?rjRv/gUQFmqgJ+ofCQczZif+ckW3zix4nk8NSsTISUoN5H8SzCHYCurK3xs4?=
 =?us-ascii?Q?3sMNwWTc3uQRIm2BdLIt+iSPv0lCn8JP3UVtwLm5L7g+aO8gpnCEegoJ1GFJ?=
 =?us-ascii?Q?GqiH7db5o7c9NBkD+rnJuRKlPuRrRcXvozt4C7HMBh3wrBWOZykZHczQ9760?=
 =?us-ascii?Q?z6FxkdI9Lde5c9MAZv9z7hpEoXYhhAJkBTNyl27ReazqUeadYbteW5228VDp?=
 =?us-ascii?Q?WACldYZgvnOb9XBX2Q/gjLjzIJuEq8J6u9i64NvqEFsqYSpK/ODCu0imBHoX?=
 =?us-ascii?Q?1itDSd6XyPgEdLDBv9Qo/HG1liKRtMX/nemLZ7VCOnrv1ibFp05+vKxmzE5l?=
 =?us-ascii?Q?cblRsne6IIlrVsFGCrs2QZeyHQrMO2+Klvc3mXWYMz7N7kz6QthLsXBHucya?=
 =?us-ascii?Q?myC7YJ1qbyyIeMip6TZ8hGKXZIFPHfPOEBPeKc+WUUkzhycYkZDTK1n9GwnX?=
 =?us-ascii?Q?UBNUGM8VBbeGWhqeZMHtCXvxlNcwAWM+CCRsXHsvfkcbmEiQLKlT8/QuoPfy?=
 =?us-ascii?Q?fAOVtlRYiXcA5tPPzV0wvYzmVJtYKSIvVhVRGY2o3InpkOy5kGoB4hSdfxVE?=
 =?us-ascii?Q?5gHT/mhuJKpNF6nS8DZTr6jqNwYyfuDn2zuu+PO2oXDETVtswrU11WGWQJGF?=
 =?us-ascii?Q?QZIY3N2q46809jScl/ZXdBeTrTH1ktK5T4tA3n7YEfm4LVBK5nCPVYIlz+W7?=
 =?us-ascii?Q?5F48FIPTgxv9rUmy135cM0p6kNxofMY/KrKqCWBuqgZH2Y3/oe7puAYl8Qtp?=
 =?us-ascii?Q?tazdRPBGcaWO/LU+NoqPRE8KTALk3xhC3bfhPVO+fJnN4zE0mXas8SqkebCl?=
 =?us-ascii?Q?fB16I43CTSQrfSawwi+uTI7e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cded7227-da71-45ad-2241-08d942b2064b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 08:17:42.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ELefZyk1Hu805+nQJDxeBaE7VQ727z3kuEPJyZKm8IXhH3uSwxT1Puv4PQa/XqFJF5rRnSJcYEtiXv4qL+/gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds supports for i.MX8MQ and i.MX8QM, both of them extend new features.

Fugang Duan (5):
  dt-bindings: fec: add the missing clocks properties
  dt-bindings: fec: add RGMII delayed clock property
  net: fec: add imx8mq and imx8qm new versions support
  net: fec: add eee mode tx lpi support
  net: fec: add MAC internal delayed clock feature support

 .../devicetree/bindings/net/fsl-fec.txt       |  15 ++
 drivers/net/ethernet/freescale/fec.h          |  25 +++
 drivers/net/ethernet/freescale/fec_main.c     | 145 ++++++++++++++++++
 3 files changed, 185 insertions(+)

-- 
2.17.1

