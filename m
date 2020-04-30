Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3A01C0B06
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 01:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD3Xla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 19:41:30 -0400
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:34525
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbgD3Xl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 19:41:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGu01S71VMxtIiKTXJ1jLDmeFASJbp+5gG3sh8xLBsNKxRQzI2zPsPbm16w/D5TUzlE6se+PwKYPdyDVe2N/KfZiZX7gzTSOGokmYMHtDPfvyYiZMpeJkoPF1VeC6BIdGT3SULt8oDw1e46+EQTvaO8Um+mjPLprqZQhqliUGPVjMaUzAY513us03ymR+a3B8AcEkNGMhpZ6ILlrIkDF9JspQs4JASXPIy6/X1U7K6ZBjpyY+ZjqwFU6L2c/zUSlCas89ZTzjqQaktPD/mOXEBMT/Pyu9U8ljPYjTyq3Js0yA6Ws/ZLpyowDb2graqkkXLXtoIuVfmEbJ+NhWxKu7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6FBWrKUArQOaeHVFkxoQ7Pw/gUA5tnVlaKIw7Tc6XY=;
 b=NMPpTY7J9U8MfArF4w1UgNwsQYsrKCeUP+7HsgDyAz0wiLYC3ZOIJc17IHQzaHq3BAROW0vDNTp+fcwOY+5QQHx8Um4y7JAIZ3L/iXarh7H1FHrsb3j3JvmUsgakesxPRbYpjhGhYZdDLlbwpJO9TXPpM8TTOu+UOLMlM4i4MAz0OiqoG1voNniL5xG8BzRJmmNtVMmeycsFPcoPQ9+7o+kjEVloMUCKGHSp5VdsoK9WLHRYgt41G7HALM0hv6JFw/Z4u8uTEHLL1rS8uAf4IEFOiY4ym5dRHSf/rFMOBnGViI0g1dYHBUm2PvKFDGEOjGKHEcNGaI6s3il2OkNCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6FBWrKUArQOaeHVFkxoQ7Pw/gUA5tnVlaKIw7Tc6XY=;
 b=ohZIIDNhJdDhbVlOv8BL3Xd+/hfN8bSx5p4eyWBVSCJSouCRJlJFkfsTQ7dNqYnWfvtXwchOsZ26v0FiWZQrfc3sIJL8rvISm4ZdcIWd76ozoyptiyirpmrbr1giPzD4w3hiuVjSQspRo/7A0Ek26KAocdZiVKqYzajMpvIwsz0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3230.eurprd05.prod.outlook.com (2603:10a6:802:1b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 23:41:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 23:41:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/2] ethtool: Add support for 100Gbps per lane link modes
Date:   Thu, 30 Apr 2020 16:41:04 -0700
Message-Id: <20200430234106.52732-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0026.namprd17.prod.outlook.com (2603:10b6:a03:1b8::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 23:41:22 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37705560-f4d7-47e5-f5c5-08d7ed5ffe70
X-MS-TrafficTypeDiagnostic: VI1PR05MB3230:|VI1PR05MB3230:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3230E91074E58CA4CCAA60F5BEAA0@VI1PR05MB3230.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(36756003)(186003)(26005)(6506007)(2616005)(956004)(5660300002)(52116002)(316002)(4744005)(1076003)(478600001)(16526019)(6666004)(6486002)(2906002)(6512007)(86362001)(4326008)(54906003)(8676002)(66946007)(107886003)(66556008)(66476007)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KLkNF3ujZ+Ht2xBzYiZRdvOjku5V5pqXQvRbVit3o/+JXHFv5lQLBBsxoVoI0vHeAd+JiDAk7ZpkXolOodBW3HqB/QN+U+Vj8+hNOG3gA3pHLeeeYBceJtvKT3cOSreXDBa1U/QdxUMdxJg1R6lxpmASdLfnlnKQU0Vjf54kfdZ31BrzS2ShcB3oyF0pcwNs+PNh6pTeOpEoquWRSgpgYp7M3N8B1tIfBBr/VgHWGYEw8bPAZa32RiUyhSIb1pOEpK7J2eIfWjQYpYmCyi1ZqpUp7FlxyQ3pBqSOFB4YuAleSr3lm7vfSiw+yZyj5KEMJn5MnsPMZAvzN0c6VctE28Tor4oW0DKv5oT/b9nlG9RFIL6xxSUZcGtKFBsfvHpuOsl9kGLNwuM3c/ha0wrdZlb2j54yqUVCgIQbFHcEzrw51xx/ZS18FuE6ECfOSo+8EM1rHAfbKNFcMKljFutdAllJ6bDeFh2PQANzBd9Xndv0V7u4qkSAJi2TOXs65HOV
X-MS-Exchange-AntiSpam-MessageData: 7vOAsYXUu5y8chjDZZesbFWQnDK/8phkHjUSVsUB+MFt8rS0Ub+NaMw1O6xzQeoD/IXy6ApyXkCiGH+M5k3WArJ1tPNXJ35hz+UlP1uomXL9fBk4Q5uXtwLPdHaFMBz+mK1vd8pPnlbCXkmLZB4LvqbNXCz/H27qib1ySkbZoCSSsyuEYTV6/T7g5YHtwXRpxCudIGeFpKNlkPJUc2PSUunRW64Ks5N1Hf+bg0kwLN9PPhZFPMG1hOvit+Bts/OR7D3svpB9k76gGG2YjIkfMS5+kEZrUbLveL30O/VJAkxpEcum5eMXJgGorm2zeUeqGUrvB4IHfKlUmUTwREk4SjEx9YOS7PRr4xHJNXAzy8Xoo+WnOMXqPN7i2vRcw0gurZ23a00ENHroTtbaPGwrl1O/CqTSAOnGeb6X1MzaqglCzWhRtyd20GRo3Id93Cyd+vcLWAK6JKeOQ32XI1VRdyHnQkjYhkEXckOUeTeO1Y7qGPEHpQarwju2cPMRD17hP3aF+8uqWXzCkGbCzfapyq56BaBYX0GLigOApRzCQ9yCNdVxkHKkF9vpx/O8wn7bGObBBcIHavK9HkLhjmhKykuqXX1QWNZRcdMTsl2LQgoF8xUnk8x0Q92Cdoqt6Di/vw3e8NmBmH6q53X98xXpPzumOaQHwSlrW3TW4Ca/i1hBYaR5KPThQa6XmE23IoC4J0/gfgqNN7IoyssATfeNaYcT+xmliYYEUHno+SKpJpXZDE9WQX2OUyjxHnnD0xtJD6h6/7FOJ+T6Xe5dbBBA7LkR7nKeqI8kn/q9ntEnokg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37705560-f4d7-47e5-f5c5-08d7ed5ffe70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 23:41:24.6184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfB9FrtsbIXvohVgdlSz/yyoGPjC9KTKecX9EeN+TVzTq2tkbmEQwOpEQn04VMXoAWB1K9913yiHaAaco8PzYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3230
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small series adds new ethtool link modes bits to 
Define 100G, 200G and 400G link modes using 100Gbps per lane.

Thanks,
Saeed.

Meir Lichtinger (2):
  ethtool: Add support for 100Gbps per lane link modes
  net/mlx5: Added support for 100Gbps per lane link modes

 .../net/ethernet/mellanox/mlx5/core/en/port.c |  3 +++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 21 ++++++++++++++++++-
 drivers/net/phy/phy-core.c                    | 17 ++++++++++++++-
 include/linux/mlx5/port.h                     |  3 +++
 include/uapi/linux/ethtool.h                  | 15 +++++++++++++
 net/ethtool/common.c                          | 15 +++++++++++++
 net/ethtool/linkmodes.c                       | 16 ++++++++++++++
 7 files changed, 88 insertions(+), 2 deletions(-)

-- 
2.25.4

