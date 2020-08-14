Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2AE244A44
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgHNNRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:17:42 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:48226
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728253AbgHNNRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:17:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DD1IQDwnFz2fYtBoUqdQtIyXxI7iVxGoDK2TY9entyvxVt6qYCzt9bFZOi+6cPu60Q0goAGrfiFIeyNe874jQ/+rjNLC2xK8jM2K3ZkdR32hj5MEJnQiETrgDb/PROmtKjHZiJhOkiAc3UGZnAlp+V6Gq9uv+WlVfs90So/Fk/Wtrp/1KorH7O/XGCJnweUXNRv3egfgEb0/haY/bEZoWm2jZoGTgyAka0U2cXbxkXXt0MR7/BXkMufKQbsAc6et+SWaSTStINkYPEH1duE8BUxh0IHWaeb2A4BuSpllsLqVEMZ9R+Eu73u23YnGd6ERwXWYhsiF2s8AFJA25UMWzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/96INqOfqHCpKINKraivRGw3QsyP8oTrOy2jya6mI=;
 b=neM5olLEospwzEZ4JwmHXT2bqXz/vkY7YmRSR6e48b2+vHFVJ82Rhf2IILZxeSCdRXKu5N2UzgE1H6e9378jX58A65beCXH6UGueNJPLQjQJzW3I3HirB4HexUNv6amNvNh431w5TYCLENotqskPUT5v1CRarE3rIZrhMS+pbpVD6gYuaMuKm9JoqW/HZVjkQD+osyA1odVPVEO+4/Il3M9+SdwEhH5eJQdzJOKcoFDOWhnLhEoUHRbr6BVt9TcQ0RWLQw7BGnlYIGV3LhQLO+NuFeBsNZqDV9TckvbMXg+vvUTpJ4Mh5Uysx39Qg/FQUkfWy1255HuzvQTSZnYYdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qz/96INqOfqHCpKINKraivRGw3QsyP8oTrOy2jya6mI=;
 b=J2v/f4ZSsdkGhQSnJSnMtOnxHBUwVD1uebqllBbmeq2GfKvtwhmR6NdFtW9qUFAxKigWTact+5DL9j8TGNelp95TrjenUOZtK0tygnjCTFu7fQV6CfSLuYLgYLUEU2kzUxz4K/drXz4ibtBReb3vYz/1hrpleeMnpfvCqOzuRJk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:17:37 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:17:37 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH ethtool 0/2] ethtool-netlink compatibility fixes
Date:   Fri, 14 Aug 2020 16:17:43 +0300
Message-Id: <20200814131745.32215-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM3PR05CA0156.eurprd05.prod.outlook.com (2603:10a6:207:3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Fri, 14 Aug 2020 13:17:36 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 58b50c22-ef92-4a05-eb88-08d8405469c9
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB360537AFB11E92378B89AC34D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYzrdg+Omrdze4g7zMkhgp2vqJ7r8OQ2tsZtjydeBX2CBclaR322qCl8PXecweN8YRR4qzpDR2340D1yva57mGpds5401+ZsaE5G1FRAHIWP9QOZjh+Qd89Hg4+O0PqVELA4XDD7oQLLMIe1dg00+hvkhercxLNEhAVj/rtXOy0Dr/D6inMibjRO69q64VqBjPBrgNaPRGpoe8Pe0cji+lqh3bX5vMKw0kYmeA536uT4YnnUpAxvhX5id5GHwpyNLlrXQd+gBfQm+K+oZJ2xi5GfSnXkRZ4OYFgUPFXDhXwP7LocLdGKVnZJDAdc2ohr4y8BKmsFxJvMl0NQuejQww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(4744005)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Brq4R8+VezH/1smEyoev+r4OP1lVd8lMV6L+4K1RCYtaJCmDOffuqeLQSYwR/bKBiuyk9Lx8jPi+4XNnM5KPTU5lJMS+ZXlWm/72V9bljkE25pme4+IcA7UVrE4OqWCAvtLsNuaUEnrUe2d1NZyQWqDCH5gt9ZeDmFKL1FQiWIiYUjjlAi3VLyY5m8O8NaxfldN7NX6jAa+qHGDCHK+F9onBZU/ta9+gf8Gzk+iCbmfYghrqkpgL9nmUgMRw0ZXZTbrGOJVIDIUIMbByL+cck/RjlRXYY30EmLU5L48jg9PBxPwWgBOwIDyttyfXA+lJxRUZZmxDS+Fg8jfH4kk+JVqDvlxIx79KoyA6yr3mMdGK5o02NFRgT2GrLwJPSffQZ5FQRpaC1J4KtCJ0swd3w1zxqqfQILOnbOB/ahH/QClsHkRZXn4dgMdPJaWM+r34qGo0+XrzIiMe1Yh/5aqsDWzAMW93dAvA1ImPrK5UmYexngtJoM85pUEl1JK1ThFCvBdBpx27CfCuo4ee2wr4zs3JHuAsbB2oFjhh77t0Xsl92LSH9+K88ORpISVV8qdOz/OEqY0NG3B0GY3XQ2MWa/vs4FtVSAkGondWt41CET89F/HonNDEYxUiGr0bwwKVrBRDWHdV63TjOU7rnIS2KQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b50c22-ef92-4a05-eb88-08d8405469c9
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:17:37.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMkQpc6v3YY0gTFWu8X6p0imlv1Jyp05zrBz+dtfDV4v4vo9Jb9BeRrW1UZTT49kOhEYKdUaYmSEcmaCVFGWuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes for ethtool-netlink to make the behavior
similar to the legacy ethtool and avoid regressions caused by
differences in behavior between the old and the new tool.

Please also see the sibling series for the kernel.

Maxim Mikityanskiy (2):
  netlink: Fix the condition for displaying actual changes
  netlink: Print and return an error when features weren't changed

 netlink/features.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

-- 
2.21.0

