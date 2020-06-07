Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DC71F0C42
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgFGPAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:55 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726928AbgFGPAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvRkbTn2/AT5o64w82NYRfi305T5R4oGn2u92toVoIZAo0VMYnMa2bUjdtJ4i8+KJYtBZBU6JmAcgkS9tYIs8+du6BFbTqkfZWOgKy1q7DObda3gBrgWW6LkqskHOiZiiwtvSArmqT1L9QxukaiGYvMmp2YG+7WA1PoaPEoEwrPIgMnTG08CM12a5GPbupEmlOt0egtCsDJ1Fa/8A7sYo6EFUmlKajhuKDPw1CQja7DUK8uscOG2A6rwjbA2br8JUEH6ayxhQcwRV5D4oWF3RkB+z+uLAM2McdEPzLhzQWfKG2GfnXfO24kqHTly0K/8BZroED/HNEzEjjqL0PnwEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp5nHoxAB2etTgp1gkPiEkPSwS+hgt9gr9sT1pfMMDg=;
 b=TAlVfynmTvSAikotRs1klnyeW9DKSQDUpfiXKxOs+696Vn1sNZAwc/1CiS8MsOXCJy+OFBKqYavnUod6PA6exPTKGaGqbz+iX4kHdynff349c1opGN1H4PWJeOTfo4ZylXKOXdWcLc9BQ0xpN+STX1s7uARoikKGBpy8mXpZnxuVgrbsBes/dGLCOBPDjsy/sybv91n63Cmpxi88Jg9cxrUNz6nWpwJn5q9wwfeQAq62fK+aSzE8weFouWo51oGfVHqmHLR/3aBUbWG/LAPWSE4D9YSVOkM+/vvl/0/8NtxFvhK/L+tlC5dGaF3YH7AvzbROUXEO6koqCVSXHpKPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hp5nHoxAB2etTgp1gkPiEkPSwS+hgt9gr9sT1pfMMDg=;
 b=E33VpT65SF8kKgIqBq++WsilIPAE1kcAuu5RNXnxBtksbHFChUlQpWOBx2zZs03Tcr6Tt7MG51/4qLZo9Tf9cqwY364qa2+xnR2xgJ49Nod0DMqaqtsYf0cviifVRT2wOvEIOjmeYsUvnDJ0SrIbcdQGjHe/qZP0Ln5m1j1ZscU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:27 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:27 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 09/10] selftests: forwarding: forwarding.config.sample: Add port with no cable connected
Date:   Sun,  7 Jun 2020 17:59:44 +0300
Message-Id: <20200607145945.30559-10-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:25 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4b8813d8-82b3-4de0-41f8-08d80af3835d
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40031A1D46A46E5F583833ECD7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhcTmegCPvtzUYx7tmasy5fdgzHp5si5+0fIQa8IcsGukaeK0E+estpfe08/Aqt9beHRqjIOI1YfyTIaLJb7rAOzzaSpaxE7uWJv4uHqQ083V7DCTleZy23aDocaejkOd+SGv1Rtec2CFYzA/jrdltI/58hWlBBBnYl1aCZ9UViBgVLDvRJlT187e8mXZJS2v2o5ZuXjy6tey/ECc178jisJpQ8p/vFneyJKiwtPXzaMFaNL8cgWItW0P/BTwhbSp8As2zSSF8WCD60k50msy7YeAFgNEyBhIfZykrMwv/UI3yVrFNmmHFJVfhfb5tQZYwveukfEXartgP39Cxd7aQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(6486002)(316002)(86362001)(6916009)(2616005)(4744005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C4+pOv8UUx2MOzc7jZQYt5l+wFUBxKomEF1wl1tVUZTSTtgMwkvPORsAt8mTA5X2+eLAFDVzWHAfFVj1qwVkOyxJa2G6Q54Zst5A8pVwDWPgX9NRINvC7E0nd9h44AOOt/ufXArDZ07y3ZTkk8CC/F7iyzFjB1vgx58n4LmNfE+GSAlhKJFM5D5y2iOQqXH4HHcALMD0UQstYHZIvektEXXMtgYU03Giwz5IKPt0+T7NvEUnYlc85dOJPyQi7JrLBY4/samWNZcNIlh5oMc0co669rULXYOjJPQvMbu2R4I8/HwamF0vvqL8hNaSYKY39Lt1UV5bIUlY7q4XnDpUHDTm8Xxc8RYkecrBZIBWw94D8bIbIvuMfKVTY4GoJSGyplYkpXmI2iHUH70Ng9qGW8hhu1yZO/G7+k+p4DgXRp5iy6DjHA7UJjDrrmeeg/nVfxCtCvWOMXQFK7Pbsi8c68PQWlllvh+2qKt7YhE0a5Q=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8813d8-82b3-4de0-41f8-08d80af3835d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:27.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C27X59T5fL92b1RBZZKSJ2EngLZGWHgiu7RrbQbhaaJhKjPXI61YPUjnXy/kvSVqfQm24dc6y4hRLsEHqh5bDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NETIF_NO_CABLE port to tests topology.

The port can also be declared as an environment variable and tests can be
run like that:
NETIF_NO_CABLE=eth9 ./test.sh eth{1..8}

The NETIF_NO_CABLE port will be used by ethtool_extended_state test.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../testing/selftests/net/forwarding/forwarding.config.sample  | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index e2adb533c8fc..b802c14d2950 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -14,6 +14,9 @@ NETIFS[p6]=veth5
 NETIFS[p7]=veth6
 NETIFS[p8]=veth7
 
+# Port that does not have a cable connected.
+NETIF_NO_CABLE=eth8
+
 ##############################################################################
 # Defines
 
-- 
2.20.1

