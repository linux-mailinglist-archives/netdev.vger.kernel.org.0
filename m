Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3744C585EEF
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiGaMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbiGaMlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:41:31 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00075.outbound.protection.outlook.com [40.107.0.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F383CE01B
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 05:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekPOKHZDdTRq+umePa1PhyRXo/1WU7xvv1Ob6zl1pga2QobWww1mQxso8CKwKDLSUCO2n2RSnU55y1JpneP24/25/+2xzr2VNEACqDjj/2VTrgYCxrilIw0zTjaIFToGATpyN1ysKDfSpSdaR1lLxQXhhKJ3Md6345C1i3uzRrHiL5MWxw/q6JY8DAVBUdSNsTqycWXehNHBWalaFwWA/utgpnIfnSJMvCnC0VFpux7M1TqrBC0uCY/nh8qAmySlbGLBH1eAVYEGfNKLD7Mg5FHUxA/+tSPupnHkgf5/NvRVt5BWuXScVGvn7kYN466G4Q13KK5S6LIXQGf0BZEi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ucXbSzyPhwNGJIQJI5TuJwGx6KVPRhivtc9eAA3hJ4=;
 b=deIbMZkp8mNSc39KMOwyQCtzEQZjnB+MuB3ZRTtIjFXSbDZEcymuBJNkITflQnX7Kp+CQE0Eb+EBH/4JPk/FeM0Reu3AAd0iuPKdxxoT8gOQqpKmGaZYocHEHY/BYNXsNXe93ZBz0qekciWmulDE4hcabpuJ+xDFLig8DN8gaZJnMHbk6oCnmEXoP/FmQ6hYH/mOvb7SSYrcTEP6/2IemqeofOQwdefNdRJRws91e5uNTZXnIUA+69W2G5POsE7U1LvffoQeY5TxkTjHnwjC9qUdraw6kULD/Re/lwcWCVFEE9BwVuGbcbHqAlY6lW5AVVCmB5X2GVhR4/A2SXUjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ucXbSzyPhwNGJIQJI5TuJwGx6KVPRhivtc9eAA3hJ4=;
 b=NLdKh6clJ6DoZGC4+Xqs2D58nd++1IEFsH1qYQyEMbN2/PS2fLxxLY+GJs6r8dNp7d5+xUZjnCvcbvDkjbUB8AqnN+CEADUUIXgevrLyB0vngc6LQjoiX5Q7rr1PaRFtpe0q6osFS2hw37Z8Jw4n5zmBtW+kweG93XH9nJAwfDY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6446.eurprd04.prod.outlook.com (2603:10a6:803:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 12:41:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 12:41:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 net 4/4] docs: net: bonding: remove mentions of trans_start
Date:   Sun, 31 Jul 2022 15:41:08 +0300
Message-Id: <20220731124108.2810233-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1da8d2c-1b7a-4895-c09b-08da72f1fab9
X-MS-TrafficTypeDiagnostic: VE1PR04MB6446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drazSKm44F+hvkZ3is/WQ/oS70fa/gblCFt4YFTIJO7WzDzCDqbHGK3wNRWaKil/nQyALUWt0zDIJNICmS4QtCFVHzMDDsJIbbT+LyIIx1XP0uyFjUMg4WClCn4utMixMYRuUDxySXmFLHglArydQBXaswKEWytdqL0De36imox4xmaw4B1AH76YgNYhu1RJQdOR7Rw6KNEkLtfd5tmwUUsEh1SGKJ0pG1l5KYVRqj4nf/P1u6Wwd3t5n31TlqKbGbDHi+9M4QbtkJQEJes2x0AGi9QPq4s1zFz67GPk2Q7ZUUhbw5q2bNx7SchkiRep4SJ+R0XPvf18Rj2YJWUiFGKmcDnO3dcNz7NnufBpU8fnnvhziIvW3Umjy8TDtLMxybcuJIF7xqi4eHi5ZZf3Ty3FxmiUVrCDC53DjakdEWFBQ9i/Od4R3ThDrW5qCsc87hfRWTfc+adZIiuBY68KGhan3BcbyxkAXNjX8MLi2PIiTtGh/BTgm2ivnFjPW0gTCdUJZ4zHDOCA1hBu21p0WBdCIuEF7NAvjpQZYhMVxyoS8c7ueYNT51+rna2ROI6Or2WaxZwVdZCbsfD6wf1aGVEkwHGYr7olkjyx+PLvMd+tyP/mEXXPikBVcAPZBYccPK19LE5x+RbKDLLZdRkEGtLAC4d7PbksLgQQCAOALiCBP1/uSrtx+NJOUN8kIw10vYznZ2+/tWeymOR2REEhLrZBUaGBatlQnnA+qBfGqMONIZQSFyfpnsKnwr814LaxMcBu8viy5BqI/ntapWAEm2GCR+0mEzs2swwgNvMLhB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(316002)(7416002)(8676002)(4326008)(44832011)(66946007)(8936002)(36756003)(54906003)(6916009)(6486002)(5660300002)(66476007)(478600001)(66556008)(6512007)(6506007)(52116002)(186003)(38350700002)(2906002)(41300700001)(6666004)(26005)(2616005)(1076003)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yvZ3XTBjMBfxr8VQEoZxAjz8e+GvogYIKktkzLnienqKKhZ+iAH/MtwLmCj3?=
 =?us-ascii?Q?NTv3ED019XiFCZ9jfGBnJHCt8HXnjhNu3ZnuurXq7lJ7Ga3r/Rby0Zq7NIHt?=
 =?us-ascii?Q?viRu2994+nTbSdYnyH1HmmQOD3iiAwemGr6JlcvFFPFy27EDHrdW1V3YX8Za?=
 =?us-ascii?Q?VjXhkKBVu9XvDS5Kf8BqmIBt0DwRQQr1x2npYt8DeLXYoAeMkseYt4fEy+bO?=
 =?us-ascii?Q?MzKpoP/6KAgrESos7wUtF8yB1C84oyNCl2Y01j5MNrWzrtNzoiQAIC/Y8vep?=
 =?us-ascii?Q?HStSQePUBupOs0jIvVjWaI2ia5dXJErO6Fq0ImaHqHlwShAun4RhCZbyyu1m?=
 =?us-ascii?Q?x+HWKFa1tV3RRvOmMj1HOlr/S5XwLSzd3ZTfAJQmm8T7ZmzKNQN3q2if4wM6?=
 =?us-ascii?Q?2+eU62hcKIBdw5pj6+YEPr4iP1VjcyQ6EkGpyzNWNJaRDWxTRSyQt3xpbfLp?=
 =?us-ascii?Q?ZsKMXtObIsAvNHtqNdf6g7lhS0RD3YoSOsvn9NCJAT4+8RKGuIBEX3EfevZ+?=
 =?us-ascii?Q?TA6UU1ZeKzE5U9M1Pn8xfhXQr29fBAxwh/yBJzIqoq/7deUhmAj6TUy4Waka?=
 =?us-ascii?Q?K7xbDpXSDGarGL9PdR7zE2KQa1eSJ0wxjUejxCs4v8+yzO4wAKjtbBHlzSxT?=
 =?us-ascii?Q?ZyR5O2k8xK6JQJWWrtTfUn4I4Xcs4smjDwdDjUtps6Vee87ZY+i+ETLKTvtJ?=
 =?us-ascii?Q?Un/pxXkBzZMWTqqFMH2zJCoXS9rv3VYfC0eLdzwbYA9UBLic2KCOkpTpKk5J?=
 =?us-ascii?Q?OSICqCAVYWqEhskQmZyT/kgfgKqoNxwSN4yOL0AbUiDrrXBTfTXTieilYNLe?=
 =?us-ascii?Q?xVKlEAJkIf8mUFPZX8eZtEwH2Y6hA7/A4kx5YNN2gvrX6paJToYUndRr/Zux?=
 =?us-ascii?Q?/y7mGv5XPXfKQO0SybxQ3yERjSBnAAQ0wfRmKqXnZS17UvNjPMKNTKXIW+Zd?=
 =?us-ascii?Q?CCvgnKsw/dqwHt75IjIayCLy4RsT6r+92U4DXANrkBz9+2Ke7ajxm2aWcR67?=
 =?us-ascii?Q?2FVKyKDBm8l4KB6jWlYYUSGucPYFsO+o3dBSAuxnSWjLdRSGIkp/QbcrfXFZ?=
 =?us-ascii?Q?vRReOyzt8UOmD6LPZXoiFIhioo50vfOoyT2MuqCTgBfqBdgsJoCX4S5AOenY?=
 =?us-ascii?Q?4CCnd5U8PKrjj17Ugv25rK85mH/CKbAj+79qnFODB7ojxyWa/lH+GDP2BKv9?=
 =?us-ascii?Q?P1jhrrefRzkpch6Z4ZzYltUWMTS/Uzgc9OmZJnj77X/kn4igS18AA89xIwZR?=
 =?us-ascii?Q?JdH31tFGHm8IHLVU5R6IhMPnOz70vu11H5oD6C7ToHj93iWNmBBFQlutdAlI?=
 =?us-ascii?Q?cd0k9MC1APzLxbSme8crZxt5FH15pgXbCa7EbHaMMW9aQ1eSWygP70Ob6fOI?=
 =?us-ascii?Q?4+4tZXohbqi2ZYuQrk7WLTE5PNNQdIssYQPD/MGRTqtXGnOCy7lKZdan2N+m?=
 =?us-ascii?Q?dmbMugKEUau5iWT6u6fCXyJzN/q8c9iwFn36w49ioCJLktXm58iSEKO0Iilg?=
 =?us-ascii?Q?qYe93ewnfXqV5FZaCVgnqMVRIRVhNixbxq4x3mTLhJAshvvURSamWDvMpK1o?=
 =?us-ascii?Q?qomLHy4FGhPX6wmfYZJDA3bRxR+Di2BFEbqyvN6oeC9iwhqouYEnqKCCKDJb?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1da8d2c-1b7a-4895-c09b-08da72f1fab9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:41:24.6914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPNL25hkb7opyWKvjKb4B82yTpsIrFt+gtfX0hZULtUfk9n/qu1P6U3WPBzTCuxxBE8eKLA8p1YOSfrH9UOHZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6446
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARP monitoring no longer depends on dev->last_rx or dev_trans_start(),
so delete this information.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/bonding.rst | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 43be3782e5df..4ebbf21590c4 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -1971,15 +1971,6 @@ uses the response as an indication that the link is operating.  This
 gives some assurance that traffic is actually flowing to and from one
 or more peers on the local network.
 
-The ARP monitor relies on the device driver itself to verify
-that traffic is flowing.  In particular, the driver must keep up to
-date the last receive time, dev->last_rx.  Drivers that use NETIF_F_LLTX
-flag must also update netdev_queue->trans_start.  If they do not, then the
-ARP monitor will immediately fail any slaves using that driver, and
-those slaves will stay down.  If networking monitoring (tcpdump, etc)
-shows the ARP requests and replies on the network, then it may be that
-your device driver is not updating last_rx and trans_start.
-
 7.2 Configuring Multiple ARP Targets
 ------------------------------------
 
-- 
2.34.1

