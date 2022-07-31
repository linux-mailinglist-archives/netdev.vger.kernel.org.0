Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B502F585EEB
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiGaMl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbiGaMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:41:26 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00075.outbound.protection.outlook.com [40.107.0.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0CBDF0C
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 05:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/NvyhLtnSDzfM7AQmAOFPXtO9RSWECK5EVosP5wpQoySbWj3PCYC/Eq/JZyFj2BsaWq7nE6izKbflt5n/vBZ47FliNaNoLPxj0xZZ8XsNSsWht2gR9FS61Bw7+IB7JbvcZrNqFzlx8aa1BZocLc7ztADSbe4S0ofRSjvSPgAVWKhpclX69skucpT0D/MjQC4Eeeh6wjNueUtFfKJCzY/m20abyillpRfmxhVugZmgEZMENQ6foRQbL3RB3YWlrSySpOe0lZfsYfBF+64ilrD31h7QblFrTYnOIXwCHIlQjtcjymQZnxmY+HZoTicw92Xamon+EtV6ptRNvbpASfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2vT1HcLTCugNr0gU6vxqA6T2g+VlQrCv2L0WeH014o=;
 b=Sd5RJrwmuM3cwKSIiQgyKgYzn43zxAj5YkezQtfr1GPztUgmCreQzGyQe9W/YGNBCAbd7mTgD3N440pwkRZ7a02iTcCvf9pLh2uMvhB9/GFzC+FOwoX73yJ6zDd/HdRyITZ+dS9tO9nB+4f7lSz3K/LFuN9oeRwmhYXYJ0E6Fz4fsazgGtI7bBfoGMm8vkGyYnkgF9EAJnllGhKVFcvaZsFajsiw667nQjVnTx2vEyI5BiDBqKD0ADb/MxJKvbkAbTwpONg/+3vZzO7LsCMRCe4ouLMu5CYS5ySKNs5R/FcYAkVRLuelJjhU+mDuuWeXgUY1rtNWlSo6NKyFj0usYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2vT1HcLTCugNr0gU6vxqA6T2g+VlQrCv2L0WeH014o=;
 b=EO1njI8OU/ZIw70HXTjDpWBFVSWu6a2TVg62UJE80NqOQPVmlp7Z5QCowJ+J3wKi5xQEqGRriX54nukD8kUOucaaTyisJI3lWSPJx0HESeiRLgQpAmNu7Numzkw4n9kRQYviBItx/yWgolbSvuE00RITZPyngM16ztlCt3qc0Lc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6446.eurprd04.prod.outlook.com (2603:10a6:803:11f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 12:41:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 12:41:20 +0000
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
Subject: [PATCH v3 net 0/4] Make DSA work with bonding's ARP monitor
Date:   Sun, 31 Jul 2022 15:41:04 +0300
Message-Id: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0191.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7de4660e-2a15-4ad8-fcc6-08da72f1f841
X-MS-TrafficTypeDiagnostic: VE1PR04MB6446:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fbPHSJTSpazZGYAK/zd847hey/3CkEx5nTOON9n2rEKqXwqXPs6hFm9Wln6gb05RJByBkB0JZ4mUZe190CKAWcsFRNG+LyWKgrnX+jgIwN5DJSnlRnXnx2Z0TWA8GU1VRK6j+20SxV43ggjuI1cMo7Unk47VAwekUlmi9nmjHM7BoKBmpn/Fu9sJfPMpvWxT24V1FMpngmZ02GYKd/BwBbLIgx1eeOLsb/wsyeX6WSQ4e50D9OzU6B84IhZxkapzLa7abKijMXYlhWESJNKHrq+BAYV9Cjj2IFk9nN86p0GMw39eGFnMGAzWd6QM1voTvZtvdKCKBH9yiCMV410kACjAQ0HH9jndKRekJbLqxd70wkGMFtZWnaZ0PMNEzbyo75j2CWb3wPeBtEYT6d3ZyNQ9eYtXlf7y1e7/JlBslQ+1cjC1t0BhwTUU84PjZBJKXIYFYj2kCxCe8SpZr0FgLFvMrCZ9+ApDA4WpcCbftWYxkaH9OdMl3H0h1zfWIKiSyQPGsl4d4ePohobHCRi6TWIveqjthASGHQVgGMSExHsLX5yXMi2fzqWrtfMvMvcp1h6qD0F+vkawuk+EFxwFFBK2r5YkJa3Tmc+lAkrkXyFXKAsRBB/NNjN3+tv16q87v/ko9e6kLceBZpDQq+IKZXVtropyhF9YWD+ClA8PlmU+WrFujvkLcvFSYuMr04YdtqpAGQnwIcvnHmDDbe65cC2z09rOb/NZ2JFAjfGPJpsmZTbu/npn4lBxIpadKjLQ8ig7IHN7kmMfA0S38w8Eqer5vV/sN+ztbHx32hrirShF17stxcfekxMcmO3bNhWFbmqaVFXSUWXX0pZAn9qyorjoX8VVK9HYWVy3YkWfhjo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39850400004)(346002)(376002)(316002)(966005)(7416002)(8676002)(4326008)(44832011)(66946007)(8936002)(36756003)(54906003)(6916009)(6486002)(5660300002)(66476007)(478600001)(66556008)(6512007)(6506007)(52116002)(186003)(38350700002)(2906002)(41300700001)(6666004)(26005)(2616005)(1076003)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DX7NrCDgLvHvIpZ4KXa+cgKYsjxm8GKoLeww5joTFNojcwDJqTOK1JJd0d7q?=
 =?us-ascii?Q?rKeZVRlWDpe5gFJIxKqkNdNihuNkwEK41I+4tmcPsfui0RasrmG+SmDTnPS3?=
 =?us-ascii?Q?TEJaRMPSYwuQ2UtkmjVls6rHQLm54Qex2TJcpfuKIgZJbDRxZ0U829abyATL?=
 =?us-ascii?Q?+NNqj7WEYJrMjqX6FoaRbLAKKt/JNuWvLfEWSybxfH1ZGFsZuSwAHH3Gv9v1?=
 =?us-ascii?Q?YmKwvCdI1C7BfrjwGBXSOKWfHqAERT2aSbOBWTNubozLCuTLhhRUr0vc71tV?=
 =?us-ascii?Q?kfxk1wGsUX/PiSsPNPFmDTyHYr4TzjpMRlBQAwJkdwvpfi4UjsszxlRxlSQ2?=
 =?us-ascii?Q?FWzMdEmHtY5cp2J6ibG5MweqQWwY45FFmzo1UZoAN25F7DotXiGWz8ABvedx?=
 =?us-ascii?Q?DjI65hgPyYIlEijKLkqB41a5H/MPBDY2bE1f+d1pQY+QoJvkdq8ZpGe96H5y?=
 =?us-ascii?Q?Ma5BaMOE2gpCpfTrnDIh8z7zPfPlaMsypQE6Ufglcob0nfDWaQQ9egFeU9sf?=
 =?us-ascii?Q?WPD95YYVY+hyuQYlTEc2WuaIS9ZhFs9Lbg/v+Iv4B+AINvVoO+iPFkq1M2y1?=
 =?us-ascii?Q?x3COuocCk66zuibKi7OS9ZBxoFo/eBkPCT5uKtu1nX0cJMT6EeJEM7h+V4gt?=
 =?us-ascii?Q?wumyTC6SmdPherpO8i4bAip5i9Nt9WCYBP/+hkBI9EAEWUto3bBQZfqDwtnD?=
 =?us-ascii?Q?cA1uYg3uteiwLupCtgPvNd9IoVZgK87eiwYtgHAR5L4FamQOCsT5eK3ltXw/?=
 =?us-ascii?Q?/y/kL2qMTWCnTiZ5FLGBDbwEQk4pmeWNLbXZQPuhATldNnYOcoieBkGt1d7E?=
 =?us-ascii?Q?LqXoHaJHScTocuikx2q5mzepsX1iudWv5Lh7oHp/mk99LflhmdKXmJgpj/RW?=
 =?us-ascii?Q?aS7xTMXr+k1447eOQhIeuDQzHUnoD0PS66cmr5LvtL40xL8y7Zy7UWvOInKK?=
 =?us-ascii?Q?ESNxyr/a7/YP1b/4rHRAxXPgvQw3hL2Xzxy816g1CWt8fHv6SK22TPXBx6Wy?=
 =?us-ascii?Q?83dvakXPPAlmkXkIenmdI7Nf0NdgNKtgjeXRhbIpUw4iy+VF+h4QEvib5R4b?=
 =?us-ascii?Q?gvamCjnNEu+B3ptj5edZn04cEr9M5/C0Cbzfk/2HosbJ5eiEK8Xz7LAin7jj?=
 =?us-ascii?Q?JeUxEvUxETnUmETb3WkpvtU0zce6G4HTNByavtf4mGL3pjRwHA4DFSofF9cO?=
 =?us-ascii?Q?l9OcjLr3rfw1SainwSA/Ou85T8NjtbcRyjVYR88MWndBEI6E44y9Cz+xqCNy?=
 =?us-ascii?Q?OYv8uF5SNbA1T6DzZjFIzcldSQSl10iSr8ukC4nlncXivg3WE9rRXs5Crxw/?=
 =?us-ascii?Q?WEAY4rgReqVVZik06FjaEKAiHxc7EF3q+fhs5QLrCKy1eQnHKsUSRMbeOG05?=
 =?us-ascii?Q?iTuzEfPZQHiMfk/KFBXFbfAxTg7WTiRQJMZ6K0aghYFr++hODnzITKqxJHfX?=
 =?us-ascii?Q?BPMnZ19zsoD8mvHhF+VuxuCrK+LR82ikC7pMFvjH7jFHgGCXXHVxYyIqZrG9?=
 =?us-ascii?Q?TyDQ2w+HYUrbvXvT9mQyQhMIzd9fEqdvYIOfpYfYJGN0koKHBhSgrslFg+LU?=
 =?us-ascii?Q?IuzKzc/+P8U9Bj43EqrjfDv742yYUtgzckGcAxBJZUv/GYPrRN/guWh+F7Pm?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de4660e-2a15-4ad8-fcc6-08da72f1f841
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:41:20.6917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwRo/ZnDi7viIRjDRX+aIuW2mC6nKyf+z3JwYmTLDsP/DdkedXG2/wj1R7NsWDq3kd4MK8dKA5JoO7RMDZY+Zg==
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

Since commit 2b86cb829976 ("net: dsa: declare lockless TX feature for
slave ports") in v5.7, DSA breaks the ARP monitoring logic from the
bonding driver, fact which was pointed out by Brian Hutchinson who uses
a linux-5.10.y stable kernel.

Initially I got lured by other similar hacks introduced for other
NETIF_F_LLTX drivers, which, inspired by the bonding documentation,
update the trans_start of their TX queues by hand.

However Jakub pointed out that this simply isn't a proper solution, and
after coming to think more about it, I agree, and it doesn't work
properly with DSA nor is it maintainable for the future changes I plan
for it (multiple DSA masters in a LAG).

I've tested these changes using a DSA-based setup and a veth-based
setup, using the active-backup mode and ARP monitoring, with and without
arp_validate.

Where I'd need some help from Jakub is to make sure these changes
somehow get integrated into the 5.10 stable kernel, since that's what
Brian, who reported the issue, actually uses. I haven't provided any
Fixes tags.

More testing and other feedback is welcome.

Link to v1:
https://patchwork.kernel.org/project/netdevbpf/patch/20220715232641.952532-1-vladimir.oltean@nxp.com/

Link to v2:
https://patchwork.kernel.org/project/netdevbpf/patch/20220727152000.3616086-1-vladimir.oltean@nxp.com/

Vladimir Oltean (4):
  net: bonding: replace dev_trans_start() with the jiffies of the last
    ARP/NS
  net/sched: remove hacks added to dev_trans_start() for bonding to work
  Revert "veth: Add updating of trans_start"
  docs: net: bonding: remove mentions of trans_start

 Documentation/networking/bonding.rst |  9 -------
 drivers/net/bonding/bond_main.c      | 35 ++++++++++++++++------------
 drivers/net/veth.c                   |  4 ----
 include/net/bonding.h                | 13 ++++++++++-
 net/sched/sch_generic.c              |  8 ++-----
 5 files changed, 34 insertions(+), 35 deletions(-)

-- 
2.34.1

