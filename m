Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188B4272C36
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgIUQ2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:34 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:34958
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726471AbgIUQ2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0SoRiugr78Iblv1rrZ+GvLu1eUOyYNWwMtisvhYsAgrMJ7xjqkIO/2dqD3BY3ZcTl5xF8tlSVioQiVplfdoDAlvnig0gcyeNyHcq04V82SZwg5WNqn8jTE0W2hM0DLDofdWEtOsXEpOJSXk5x/yA2dJ9O7/CoLB8rIC8VqvCubLixRxnjS1cHGAzTEiJMQfCbtf/lCDLKUN/OrXIRedi1NTQ8Y6nowjn/JnmOIb9R10Yq0jBfWxjeqFYT4s6GdPzSV32e8ImndmO7om6AVCnaA4MTGcz+oPTpNN9h+XF1nq9SnbD2PMG5EJdGKH4JC9FTKNYWr1TTyP3sXr9Gm53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWevvGB1AIDSIcArzIJGmh9qUX7Qg+Sg03DGZdoLXAk=;
 b=G8kr2lFVZpDepQ34Fy9ci5CAsTsIOkl4ZQtVhaELDt0dDtTu3qLuyKcCTdKoKvyb6b9h0jVHubUFVXWdTJYa80LmzYMoeLVRM4EgyIgXeUD2RQgI76ZojhKmk+3m2zQrrWSk2Nztcepc+Cbg39akA2z0KEnD3aS2cfxh9rZW2LPlsFYSRPBk01E8D6WR4BpULF05+Mg2jFO/1MNvDesrzOGEjcgfqn3KaqpZOgRSRF5EH2Xc2B8r6MjgodPIbgQJOJlZS21VJLKBR584yk3hwcwz6e5DxlRAlxgKQqUQkC9Ud6Yv33zDvSJ0Zqz8oGBzf2S7hz4UpxS3qsGRQM60TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWevvGB1AIDSIcArzIJGmh9qUX7Qg+Sg03DGZdoLXAk=;
 b=c7wh2z/ju9Vb5aN8Qjr7CNEEGFE3KTg6aHVcMt+zqZRGdyNG+lYQNP8OvmyWj9GezbswLWNhgbnguCp60XQvcGRTU2mp/H3qMeluYIK/VHjOTAnmTQZSN/WSOzm24VP5fBp1xZX9MkeOCe9CxMTrv2iA7n6ebnUCtgY/9p6sF5A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 16:28:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 16:28:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, cphealy@gmail.com, jiri@nvidia.com
Subject: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Date:   Mon, 21 Sep 2020 19:27:39 +0300
Message-Id: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::13) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P18901CA0003.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 16:28:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50f5dd73-298b-419e-d7b3-08d85e4b5fcc
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB734390DFEF61AB56F38EB834E03A0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XML+0kb3x4au01q/uotl60VF1lZbS3fHrjsBcwRnFowygUTcnYYHHf70xihjM0CvBoTqrFVFeVOKZn9iwA2dTqQEQwvqU5eP93y4PWQATquK0+78iaSvSGYkzdRLeyKaMNggjsYO9wMnH9WhP02/M5KG0VVvC0ayucBMpaqhfUzdQzZ6thbhQMUDoQPJ7ySnNvACYDGzpcI5eaV8NtrPPkoAPm4ePLgj0WYzrT5pl27UAc94JuhYZ9Jq9/a9jfqrdfnS105z7tAneEMtJ3oy7y+cb7ld89Xn7nxDMhmenwCUjerTMMJjkE+mmFNB891g6MtQze9n1NSLz9bDhY336IJV5/uAMRCEHAFbZJJQ4AIg4ywO731bhMVlEWwGRRTKBYe2lZSWIp9zdxq7hY95v+p6sIF5pK2sv5AWp2xMQO8XBFGn3Il3wB+0tEzSLJTXOyRnws18m6GA2pRueVwIGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(8676002)(1076003)(16526019)(186003)(2906002)(26005)(66556008)(66476007)(6512007)(66946007)(5660300002)(8936002)(69590400008)(2616005)(956004)(316002)(86362001)(966005)(4744005)(36756003)(44832011)(6506007)(83380400001)(6666004)(52116002)(6486002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mUGleQxvLPogLqZVSIIh6NhFTbjxNyKro8908WGL4XQSzzmBjQ/zEdaw6cTTgDDGxkXFoyfvf2Du0rXP5ycJZfRJk9mjMulKV+0xkOrwo8ireQ9r/lwxWPD+ntNu+Nfrlj0iHO4EWFmvTBH3QXkj7OCCGcshIaPyn22u1d4KMTfs+FrdHtn+MpHSKTX6i7U1E4zLZUQLHSSMQ2UdUh86q8rl0ViueY5HyVbu9EaXlkExh754epzz5myBTLQrV1hx8bREPeMSJPidgOKvxvEsQoa6NZipJ7UIxJiN/ZNKhPlv/aYETZVszcynkv5qWbGambH1Mpn+7AkjZvT2Apg8ZD3trcmEs2udYyzLDpfmICFM37kbkO4ap1LlDZfZS582I1q0Bo1MV8xr5y6YS/szTmVx09VhbCC/cZgf8goF1X8i6xoHwatxAhSWKq9lZJThVFjMaPCKLamufkeK7zv2yovBcAdKFDKStyQubZmm54xp88rz9Z5kmHB5XcxuzDOkfcasWH3+aRHM168hE8gkl/0PNeW5mYxu1iQvGp8OSY5N3u3wThy4uYbga2PkriHJdxwUM8PBSXlqVKIdckq62htyPU1Vuq2F4B+vhqR8h853yZ22RUeFTi51Wh6Ol9wgm3GEVvKIJdUGnVpSzIcDww==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f5dd73-298b-419e-d7b3-08d85e4b5fcc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 16:28:29.7662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0y/tFXzSApkeNVYCEfs4vRqwN+W8s5jDmd24Ef49TvT7aHeog9txQew8bIdaLTjZfWkuTsELpFogmoBugtVdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series exposes the SJA1105 static config as a devlink region. This
can be used for debugging, for example with the sja1105_dump user space
program that I have derived from Andrew Lunn's mv88e6xxx_dump:

https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105

Vladimir Oltean (2):
  net: dsa: sja1105: move devlink param code to sja1105_devlink.c
  net: dsa: sja1105: expose static config as devlink region

 drivers/net/dsa/sja1105/Makefile          |   1 +
 drivers/net/dsa/sja1105/sja1105.h         |  13 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c | 236 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    | 105 +---------
 drivers/net/dsa/sja1105/sja1105_spi.c     |   5 +-
 5 files changed, 254 insertions(+), 106 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_devlink.c

-- 
2.25.1

