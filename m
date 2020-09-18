Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C52702C9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIRRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:03:04 -0400
Received: from mail-db8eur05on2126.outbound.protection.outlook.com ([40.107.20.126]:49377
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726273AbgIRRDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:03:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Onkhz5Zy1S2MoNnmYAAUY5ztqhJtuiXYW7M0xL4gvUsI8bsZGWI9qzOKyyICSFAeyoJ6XznTRe14ZLJ0lkXE6JHWWod7nqbrYZCpeUzNWneo/NaEdFRTM0D3ktiNq0kQmW0q9rI8WrN5GSGLiGTco0UP1mMd0tRHi/YrKMU3FBSkPkT6BYuh+pEhb7T6tLA0TA5g+pUi3GqOOjfxwuZUsDCoj2ckfN0FWhLdv+QSj2/noToyWGmB+ko5JGQtypGcVejQ5QXTaLD411MjL9YXUwfCf6B6++St0YWvh+r2vcuwJa3myHs1p6rZutDRf6JgbD5K4BlkfN4Bvmj6Pld3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/zQYdbqatBhniOA1ZS8hg3evtPkXcUQlTLyccTb60w=;
 b=afm8E6IWLNkGRXn63ZVx2Mh9L4BzEVnB3896TbjjUj9oL/8bTvmW+OdIfOclaf+tLYb9xrcrqXMGOLiGOZSdD/8dM+HIJgJJji/oNVWQpLQdcqbGfm5+/P3938+Rd1yq2reRNV3IkxJ9SraUeioygo7admO5bvvZZAYLmleptOJxoypaILKthOPpwFtiQh0mJNdparnoN+687UL9zS8FHNcL2Z0aI0FA5juaLuWCRO6mBDgXRjA2A+qo5Owv2kaDI31sRgKc003Vyf2sGzZQmxDSe3GgOLbftxI2FutwC2K5nekq8j8kCaoRzIXnS8uasL607rHppdUeDtVH916sMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/zQYdbqatBhniOA1ZS8hg3evtPkXcUQlTLyccTb60w=;
 b=MpvbPBdmhi51jvwTOGZ2rf1y3ufsF4BinLmRuLa8lorOEWVeFvs0ByDEp0FYUEYZWYhkyR7c6Aga7Y8IBKzKo4WolqYNoFq8Ay37/OiXfrF5T2BmLTxrrO5Yp9rO9tIuY5lZFZHCdRfdYqvhJEeFKge4qAo1+mvUjb9qvSsMWrM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR0502MB3827.eurprd05.prod.outlook.com (2603:10a6:208:1a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 18 Sep
 2020 17:03:00 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3391.015; Fri, 18 Sep 2020
 17:02:59 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net-next v3 0/4] tipc: add more features to TIPC encryption
Date:   Fri, 18 Sep 2020 08:17:25 +0700
Message-Id: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26)
 To AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SG2PR04CA0164.apcprd04.prod.outlook.com (2603:1096:4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 18 Sep 2020 17:02:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [113.20.114.51]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a8b16ac-07a9-4180-0af7-08d85bf4b240
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3827:
X-Microsoft-Antispam-PRVS: <AM0PR0502MB38278FDC8BFBBBB81863DD42E23F0@AM0PR0502MB3827.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVamIJJNgy8df0HxOzbhU2mxEOeJilhUFCpPeH1wHllceG+5LppSwD8nTUEjkx3HULRJ3VG2qDuRr5Nj7OxJlRIhyeHI7OdG8p1v+QOXoYNRF4cPRx0GZFUD69NJsTVUixALHT2BKxpD2HldDgiRJXwjRBbNYMMt3wAY5wWM227+r5qTsfPh3/eESsoMVLlQyEbs9m91Cd5bp0nN0KYTdEPTP4/7vpAL+OGJZXOR3dExrurYSWJFdlprj6RDI/0nmm10GMNppyROnAf+UL2PaFUCI6GWdfI7DOc+zLz3Rl/2lTTMQHDPHvMJnbOZJDqb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(346002)(376002)(366004)(396003)(2906002)(103116003)(36756003)(7696005)(55016002)(26005)(4326008)(8936002)(52116002)(316002)(16526019)(956004)(478600001)(186003)(83380400001)(2616005)(1076003)(86362001)(6666004)(66946007)(66556008)(8676002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9HrjrrulP9JbmLsFTswXbpjx3h9URBipezCORllw0L1AihnVK9Z0/VjOY096h5OpJgfcWZyD6RcJFPxMkm6GIuFcICey0q5H5WKoutmEnVC6YglFbBYC2AMNCYdVepmhjeGy/NJqLpLzdDB0x/5bDSucu3fqMjJuppI1NIGUK1xmjz7u43wHunafIJCeZJNf7Grd8ixFAKTq3cszUVUJmLJoOomnUsOAGoCz3niYXFwou2bbM3tNxwuNY3+iYDWvG2jMp3CV93OO1oLRVxGFKbEK5jMQ312liocV8XCtOy+p8fWuYJ8FG3TnY6/OGSGX/5I5J5CTw6gQ3t2YVcXGc/8o2duaC4/xFqElBRNmmduNoMeqszOvZttASIPMN6Ydq5nRiuLmDKuAIFQh9MU9y48S4YSnwMMR8uEb70UmCl4rHUxaNPdsr9zDZSDbSfP7dLBV9d45uYFdC6NUvPjoIr5Mk3vvlzxrOWKxgV2Fk6oMl4Xxo3UnpdWN/2xfcxxwX9d+JOO6flZJM4P7clmgQ/t3AbEB2P3uDVvBzpvWqdKOGErnDEupgdIhGPXZ5GOOwLx/PSrdQnj2YelBRMYxRT9c1xp3+NRVqFcfsGCQ1DXKx6nkM3sH8j6A6d1rEKDGhup11lyZlWK/Xsc44riZaQ==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a8b16ac-07a9-4180-0af7-08d85bf4b240
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2020 17:02:59.6671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkUXvh1/rd3eyzPR4hM4eUaekC7y6faS7R66rh9QJ1klKooFuUmHdQE3IlZmstDNUgAlU9hE05R7pTob8z2sWkD0MdSsbiNye200+YGOI/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3827
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

v2: update the "tipc: add automatic session key exchange" patch to fix
"implicit declaration" issue when built without "CONFIG_TIPC_CRYPTO".

v3: update the patches according to David comments by using the
"genl_info->extack" for messages in response to netlink user config
requests.

Tuong Lien (4):
  tipc: optimize key switching time and logic
  tipc: introduce encryption master key
  tipc: add automatic session key exchange
  tipc: add automatic rekeying for encryption key

 include/uapi/linux/tipc.h         |   2 +
 include/uapi/linux/tipc_netlink.h |   2 +
 net/tipc/crypto.c                 | 981 ++++++++++++++++++++++--------
 net/tipc/crypto.h                 |  43 +-
 net/tipc/link.c                   |   5 +
 net/tipc/msg.h                    |   8 +-
 net/tipc/netlink.c                |   2 +
 net/tipc/node.c                   |  94 ++-
 net/tipc/node.h                   |   2 +
 net/tipc/sysctl.c                 |   9 +
 10 files changed, 859 insertions(+), 289 deletions(-)

-- 
2.26.2

