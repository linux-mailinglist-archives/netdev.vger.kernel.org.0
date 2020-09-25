Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E0F279479
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgIYXEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:04:37 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:28545
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgIYXEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2NsUXHLNNF+bHlSYCuDWRmxXC7A9Nj5Vi1S7Hyt/ET+0DJlZd++6aBhfh+abravvfD0KsBt66KoO6TrPIVqBehkw1fibr0+ECzFtHO6UX2Sh/+nahPPYoloNKTIJypyHf28PwBPGTJno/bv6vufYCT4lLB0DxX1t/E1giZac9mdZIBAR2gXKgcUT/tbq7lMLSZC+JjR/bMmh86KO/1nLYoeLaemT6yv4y5Ynae3+SCgti8j+xAzzzNLVGpQSpzlNn6AxDimjrpv/b0MbUBbsT5ghDv4h94K0nLHYkzi/9G0sIzg36g/jSxx/zcFcNK+bx0IRHytMGI7TnQvCX0NzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTSiA/4DBo8lYt59y50EF6xLm/4GsT+/N/LXEdmelvg=;
 b=CBVUXhV8ZEI+65QalQ4gqT7wCixlrP5lEgo0Yt71U1mlAymTyrPbdSD/Jx454GQuztjAjxUOWdfY4XrsHlAkR3yNrLPA0q0rAE69UPl53CoBG0cQb0fr91OdlOa6d8jv2Hvmdf4M+SRtjIKn1YGzL9dEko0w0q0BjemXRqK5gC9LYVwbQqZs4+rGML34cu46IXwfNHbbHfpB0x17psBSjmMtHKMV+VVZUj9HaxzVs70OX2OplKXLidbQgUa7GYqxNF9OqzIlbiamihWSwKSJi42ebu2bzQ8eSkKhAJ20dt8JtATyQ+hYWGnIBq1BbgfEYTTJx1VX+313A9Bm4H/Wsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTSiA/4DBo8lYt59y50EF6xLm/4GsT+/N/LXEdmelvg=;
 b=gjDlSU6G+SXPKyxh7XwLejE8CI7ybQaZL3MBsdcHV9VyExr5PNYRRi4rRMLJ+ZRNqtjvoqSSDDHF71pILSodXL+e+WE1H3s3uxHQK3mdSHzFeMIV8V6wS8Ys3l9Ea/1ofHrHz6htsKS0tJ23C8RxyIbD3jgXFslmflI+g/DJLyc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 23:04:33 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 23:04:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, cphealy@gmail.com, jiri@nvidia.com
Subject: [PATCH v2 net-next 0/3] Devlink regions for SJA1105 DSA driver
Date:   Sat, 26 Sep 2020 02:04:18 +0300
Message-Id: <20200925230421.711991-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0169.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::26) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR06CA0169.eurprd06.prod.outlook.com (2603:10a6:803:c8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 23:04:32 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 537a5757-598a-40f1-a9fe-08d861a75d8b
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39680D36A6287E4CA7E5443AE0360@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6nOR1Gz0iASH+a6g4MNPqefvjjz0Lr67i/WCrofRs8kgKQjgEgU7wBv4beO9efuK/3PF+hvRjpgRQhJxh/jBM3VFPQNOhGFXqepMbrCc9jJrvw8wOSOd/6DBS+AeexDn5CVJAgIpRejMaFoCQegwr2Phaz0XVbIN56Y61Q4CFJZhKUc6p3kQiWClOoj54Jnu2QuIwd1/GG/VY8uWWRgwbzVVUKldxZF7Lqd/IPpm5JY4IgQUCkhwU/sPumG4YT98ht5Ng3nHkH9MNuzHBVkSwcrzGchgYit9uubYmz32kEJVD2eqWWF/L/z/QYqVmIPVN8ZL+H0MlxJzj4ypx+9h0Og41qrKcz3YXF5Y+XA5G4cFOf2ywx3Ccrx1kb/3ueUhU0/Icr5Xm1b1AbYtcbfBQLKRN7wKBr//R9+U4SVgGB27gG6icBU8+zwML/LWM3rf7fho20R5j+3NjZuML5xyRZUTVqvE5R4E2E1Zti4SI1RfEZe/bU4yx+CmIAd3yqih
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(478600001)(5660300002)(83380400001)(86362001)(66946007)(4744005)(69590400008)(1076003)(316002)(6506007)(52116002)(16526019)(6512007)(36756003)(66476007)(66556008)(2906002)(44832011)(6666004)(8936002)(966005)(8676002)(26005)(4326008)(2616005)(956004)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pv2y55Fyc4T8y0H79Doz512w2yTt8W31GPR02JwIjDZxMVa9tYNJDQzB+zVm0/ZPjyFf8itmZrtwdxd2ycGMp3saDFIixRAsX/XSdiYKfL0xz1ck14swFOsOEgxx6qtnNskcvUQEzchHiTKD6N87pJjipVYosA6KBnTcx5SssuNKeVxZsquOFTyUvhvo+7ueJ+weAH0SWBh+XzDjbCvSI3g+hiN0pg1mMlkcXDo6hnlBrz72DWtS6OfH2EU7dOC4P8SbqzKVjAOoA5ekQrQx+InLr5PizvJvEw7U3PmEWEi6M/2FWDmM4d4Q3RLzml1hQ12ZQAC+Iv7GLOGnfGw+WTPlp62Z9c8Zf5vXwLCi0GBGKExN9gNwrI2JMLA1nRneDGbxCLivaFx7uhMlSy5sq6ESOjSWRDB/D+4p5DxOeuVIOrSrI7OIiakFEHImiCptUDF8xIonVw5fn7aQeQRuc7GyCE/dy0pscN6yOgf7uzNKKxQSrWmAk+9oGbi/3OGrN+5NXEyftFN8zZg9pI4KeQoCvRTiyxE/cwtoCTvWacj91Xnrdx0SfL6377ktTcm7U/5RPWH3R2+FtL6NuNwq58sHqx7lLFQcktFjtrzbxF/mb+8DYn2Y0wBnxoOVTmzGsudzqVxPoGS7P2AYNxfAsg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 537a5757-598a-40f1-a9fe-08d861a75d8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 23:04:33.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkVbLCMqvo15qO22EZti46S+MqPRAxdymCQn7InDDK8VxY5rLUuKFmYgkal4XPlxpxc7HkmSLIMDZgUH/DVKjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series exposes the SJA1105 static config as a devlink region. This
can be used for debugging, for example with the sja1105_dump user space
program that I have derived from Andrew Lunn's mv88e6xxx_dump:

https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105

Changes in v2:
- Tear down devlink params on initialization failure.
- Add driver identification through devlink.

Vladimir Oltean (3):
  net: dsa: sja1105: move devlink param code to sja1105_devlink.c
  net: dsa: sja1105: expose static config as devlink region
  net: dsa: sja1105: implement .devlink_info_get

 drivers/net/dsa/sja1105/Makefile          |   1 +
 drivers/net/dsa/sja1105/sja1105.h         |  16 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c | 255 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    | 106 +--------
 drivers/net/dsa/sja1105/sja1105_spi.c     |   5 +-
 5 files changed, 277 insertions(+), 106 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_devlink.c

-- 
2.25.1

