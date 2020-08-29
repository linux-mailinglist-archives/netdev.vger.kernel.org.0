Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D85256B82
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 06:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgH3ElH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 00:41:07 -0400
Received: from mail-eopbgr60101.outbound.protection.outlook.com ([40.107.6.101]:6823
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgH3ElG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 00:41:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVKVZ159zGUzFJAG54EAkCSZeZIuJ4zIy9022rNrQf6G6yH35PneGaE8Wxs1OShE5kS07NabSqBAksXmNbOMrHXYlsiQvYet3DZlzqdIPCWI514n5s3hF0x1qLj02THMpjZsKYD2mH5qzQ+oGb9C1b60JC1L6pDC3aVZjZmT3vPgH0uf8v0hhwd17OmryahWWRRWH1oUhgR9f+avnbIhPSAwpH3AhY+VnM5Iodf3AaNlMw4NVAaNShOEeBM0lnJNxxFnEUxqSUZj9yNjIkAV6/QEJ0nMn56gprqR9L1SW2x2LOEu3yBy7dya0Ylo8HHIY322J0vPoTKsV7MSlHCA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrhpv5s0y9SJkY1M0Jh0+fer3ifdBTDVkJDihh5YPN0=;
 b=Eypzjhpaeht7yGSx4pl1niFIlNIWY/zB+bBaY1/PhbDgHiOAQbmI8p1UGSrweOzXK7cUitJtvi2yJ6qR3yUxmdeoo48Q3Rjzu6H0L+u8ZK79gUqcE8GMUgnGped+54zTEe9w6bTZadK5F70aS9KCiX0nRPq0EToHQVyYf3VKNYiEMR/6uXAFX3yRdkcZdGPp3Zy4/3iYeiic6ncfYuaaVQmGJz3BLgOjmpc3hvHWky4rC4RewzEz7Yz+FxPGLsIWQlM3547tNwTPUqYLMa2c5UrmfUTLvkajJHuq7WVxaeT6CJwWwv76T6RyJtT+IAFyfPCdQ9rpciy7utG8aVUicA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrhpv5s0y9SJkY1M0Jh0+fer3ifdBTDVkJDihh5YPN0=;
 b=J37fM759G6w2GueUQS6h+xEKjDzjFVtqJKWyiZqEoXUI4cTuoyADJ8Md1wzvNH6Xj9Ru+xxAlkyLneWQHnHEQUvs8En3U3kDRT6GdWwd3FjBd5YwNNAsv9Le+mUk/nbKKo1LaLGQuGCzN8h1s7LsUbIZvRDCMxQYr1N8pAxhU+U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB5105.eurprd05.prod.outlook.com (2603:10a6:208:f4::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sun, 30 Aug
 2020 04:41:03 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3326.025; Sun, 30 Aug 2020
 04:41:03 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next 0/4] tipc: add more features to TIPC encryption
Date:   Sun, 30 Aug 2020 02:41:53 +0700
Message-Id: <20200829194157.10273-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:3:18::28) To AM8PR05MB7332.eurprd05.prod.outlook.com
 (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR02CA0040.apcprd02.prod.outlook.com (2603:1096:3:18::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sun, 30 Aug 2020 04:41:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d252c960-43ce-450e-8120-08d84c9ee693
X-MS-TrafficTypeDiagnostic: AM0PR05MB5105:
X-Microsoft-Antispam-PRVS: <AM0PR05MB5105487A6CE7DD997CDBD615E2500@AM0PR05MB5105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKcbBlOpptBGPApVRY3GjiQj/WPtULO/KPbM6Hb3Y7pFHGiTixzyAW/2S2zVOIeYkT9WEtjEzViddsLmoSmaaWQYthBJG7UQfVhGN9PljfI3hdAaQ4+vZqvS7g3ZfTLdwKZ5ZJxI43KqeIljNDcBZ1V4nO8DOFdAazmU/5XDr8czCdx+0VH4DNs7uW7Cjt1/ZKViqkimniuJNvy9xRpA+GBVYRvuSrBv8Tez1nIYBC5RsgxaRk3+dFJSbQXU7U6aMMts+9ENFRqM202Z7QrmKKEytSyN6RcKZ0RrjT0MpuYNy1UHF8tf9zg9dWoUj1z2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39830400003)(36756003)(86362001)(16526019)(2906002)(478600001)(26005)(186003)(6666004)(55016002)(316002)(66476007)(66556008)(66946007)(8936002)(8676002)(1076003)(956004)(2616005)(103116003)(5660300002)(52116002)(83380400001)(7696005)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lo5OlrowGz1zuUfuGidtdzsopheyA7gFUTKsMTNdRr0GHlupd6ESBKYmEeYvkR28xR5Mdu5cUhOlXllHDVFo2X3pKxM/JN/1KSYwavqKKj4PPpJhg8AFI7vodZ52KEs/GrJGN2JDdGlyabdAOSS04sUai3zBVLEGelcXlWtknIaV9X5iatC2DT64XkGe2gHKKffjpEW5V7B3Wo2KS9Motixh/tZ+V+ImmVpveziBEVHJI9y7abBhVE4FGSOic5qfka2Wp9j4ekf8P25yrnXyrYSIFxQzamfQ4jEorBD54hiVYUvRxewpgyxqFeJ69iqzTu/dQ/2h0VXlw4CVYc+cj4v1trRzuBKd3zwlnC/VOqRw4QYfeuvwCSY9ylmKXYPFunLH3KB3a8R9deYxnS9QeBX9/TwCpspe8mRyHrxWplmfqtZmaTo4rEy/mMdyaD1yKkpV+gantFj42EM2U8Tkj97uLbl7zsHSwo1fskptK/xkZ1sIDY7TT7hMdMSj2BjSXiYFNX711WgNDY+/NbTr3d1n28k+vx7dCaGal7DF5VCp/OmWziS++bPAkOQZxxmBROyjUuRnqz3y5BWD8Tj/3TbsUvXhb5eI4C/su7wCDaC0UjHFBSmWuDYRa3g4r4j+p2qj37zeMgOpvX35Mr+VZQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: d252c960-43ce-450e-8120-08d84c9ee693
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2020 04:41:03.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jtpo2zP7BFHpJHgiXTOpEjCfeqrA171miu0Mfetpm8CCj2YNDY0QHl+AUNJNEsukp27U84gVEHlQ4zUCokzLDm1z9wn5bHqdxyY6uuWgiOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds some new features to TIPC encryption:

- Patch 1 ("tipc: optimize key switching time and logic") optimizes the
code and logic in preparation for the following commits.

- Patch 2 ("tipc: introduce encryption master key") introduces support
of 'master key' for authentication of new nodes and key exchange. A
master key can be set/changed by user via netlink (eg. using the same
'tipc node set key' command in iproute2/tipc).

- Patch 3 ("tipc: add automatic session key exchange") allows a session
key to be securely exchanged between nodes as needed.

- Patch 4 ("tipc: add automatic rekeying for encryption key") adds
automatic 'rekeying' of session keys a specific interval. The new key
will be distributed automatically to peer nodes, so become active then.
The rekeying interval is configurable via netlink as well.

Tuong Lien (4):
  tipc: optimize key switching time and logic
  tipc: introduce encryption master key
  tipc: add automatic session key exchange
  tipc: add automatic rekeying for encryption key

 include/uapi/linux/tipc.h         |   2 +
 include/uapi/linux/tipc_netlink.h |   2 +
 net/tipc/crypto.c                 | 974 ++++++++++++++++++++++--------
 net/tipc/crypto.h                 |  41 +-
 net/tipc/link.c                   |   5 +
 net/tipc/msg.h                    |   8 +-
 net/tipc/netlink.c                |   2 +
 net/tipc/node.c                   |  89 ++-
 net/tipc/node.h                   |   2 +
 net/tipc/sysctl.c                 |   9 +
 10 files changed, 851 insertions(+), 283 deletions(-)

-- 
2.26.2

