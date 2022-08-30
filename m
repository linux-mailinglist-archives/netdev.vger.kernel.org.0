Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5273A5A6E01
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiH3UBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiH3UAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:00:32 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9388248CE;
        Tue, 30 Aug 2022 13:00:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xn53/oWyjP4HaHaQnPYXfCin0iGd8diCnHBRNkrKoEWSejEnhKKubzJFiSRD/UwQutJ2FlSKA6seTewNrfrsbYn7EhoeYff5XgmN0hXE2YakaUGQC5wSup/t3tDz1LoeJjv0ddblRn+HvHkyxhR80uJwmpFX9OQZ7/PZUit5GN4MR3L1/rOPlh3hpIvyRg5h2escCvwlBAhDpzE95HiShbtzncM4hfhNGHbQSePMdyLrIwHItmv5iYWzOXJXgVsp6scMbRpLR8/ZLYhdqnI8ZahAiRJ0I+PPePbgMiGHwExKSXvg1f/lRht3WrHc/QqwwZgXA1i/UHPTVICMYF01fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpsdEmkxc9C67B5T8k6L60wsiFWrP+l1QjhHW9L0hMI=;
 b=E52jhXUmXph/L5cf7g4tFWRHlt9di5jtAPj1/+PMnETjMCa+Ia8va1INrv0bIyP8m0AzS4BEXdffFstn5zVv3g3qSk839gcSJ1y6r3oLoo3PSk1fSKC7IBBwJN5dT1w50DCxYmS0nzU+yZhzjusoj3E3pE+eOQ+TZfoGaZaCh7B6niGO6Gp0ZZWBtS1WL14I6zAN2mJCUOet0vebZAhaS85pqpJvVKB+FpRVRUsnpVLlNZAiBvEG4VZXXd4lxdQt0Qc9OJ3OJAMKv6UpTD9drVEOBXejd8Qa3h5OzijMWmhSMBgtGgKf1O3QdaDDd3k39SM64SzjXuUylJL2Yw1BDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpsdEmkxc9C67B5T8k6L60wsiFWrP+l1QjhHW9L0hMI=;
 b=c7Sywb+d+HtcOPJ+1JKlHHsgRHOCVDxMzAk8vQ/Qd/9NCkmw9+33vvXm7bg2p9GvmiPntWEcajDJFtWS5eq24JYjQk4xAkjnYJ3XznJ91d063qEVYE6tqZNDBltAnE8cwF2dyg4sqL4DBF3WFhEMc+PQ6huUy2nLqJKJ65iYd8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 5/9] net: dsa: suppress appending ethtool stats to LAG DSA masters
Date:   Tue, 30 Aug 2022 22:59:28 +0300
Message-Id: <20220830195932.683432-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8b01ff9-d3c7-4cde-9376-08da8ac232b3
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FC2TOZweVZkK7F3THyUd4rKv4VGwkoTcBJCplxiUQoWLWLsk0oATD6q8yhF2FrphhPorLlQs0bRvxFnEyKQM6oR/h99C0kwZXWvnSZx/NBVWj6bKN1RYdfnXmZw74ZeoOE30otSmqWRG5+KVXWykSYVtK01ka28FxWgL3n1mIsDueIIJ7aLc+s4yxdEK00dwGCIUieyxbSQJShkgfB/PxwH/UP4YsI0GRdGxM1htwWTXA7m6CQyJh8eotqRaP0uyrKq/Bxcy2O9ogH/FFDjBE8wnXDbvrxcs56JQ5VPGDRqt4WQreQOkoLrQsjxM1SrDJP63PUtsR/mzLZiBNr0+pvkzFXpt5DUmEwrwkn2+u4UDx1hLT6d9K6VuAqEeXSygL86ZHSx2BE2k9n75ORSAwWP2YR6A3AXyHTCk4t0fhLpM30eBz28Zd2TXL/nW4o0eMQYtqJPwfs9cDZ05j7n3m/CozuMWzSfhzThn61h/MVKH/enGdI7Taz5WshpErQ8gjzENX45o3AANfgLgE5feI2R+EUvbOtXSb5EW85YxCmeGJHuBhvbfuLetOULMUU9nmuMXxNw/rCTnO7sOJq/xzrWk43k4IJUvTnWUUEryQYAzZhdaV17d8ExR2CiiK2iD4HsoNcRZ+xnpCY9etG3QHMxhqZgcuczP2aLGCFBGyTsZKherq3gszj+4pfqk2mIUZ8lSWrQ6kZDrJ5MqV3jOmCcuWwhfb0NhaFaGMt+B8NC1SDHNf1F8GWKG/NkS4VNH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zu13r9vWXBHz8+LE5BTuGOZ5NfdTXpSrHkB+Yln6w0F3YkNSWGeOqJbbIw1A?=
 =?us-ascii?Q?l/GOFBfJ9AB3cvnUfKBE8GZya8etjRHkMpAKqdTVX0jleCt0829nvUHNhKfu?=
 =?us-ascii?Q?ClNAWYfvriTinW4OC9Ex+5biD11UeZXoIwlVyyQlS661Jd3rJx7l+HtwOgV0?=
 =?us-ascii?Q?U+zGtM6Te3QA2N/yHSKS5Fyf7xwtbQMGdmjB2s6GOpHyg+Njpe53F5KczKCz?=
 =?us-ascii?Q?op7tWBG1O0bOrY+zJv5uOL/OLYLL5ms5DAoGSjl9rqNnbzyhOgq5OdOIKxFM?=
 =?us-ascii?Q?dj4GFIZ0A3BVHvWO0VI4MMCFwfKPC3GvxhguXVK2suUcfEMxLLq8/7z9zpDn?=
 =?us-ascii?Q?MeA+k5/X0aLtZm1eULnACMd0awa4bV4Nk9+EeFJbwkEQc3R0hM4NzNZYaRDO?=
 =?us-ascii?Q?bhA6vOMc5naJ9agQRspyqdn2lfu6afHhAoLFZMrbXbbp4SRGycB9+UXKu0ye?=
 =?us-ascii?Q?Nl5+libOm0qcZOurORd0Edqzk/9FZXkf+4EiCenJpZdSkap1d30LoR6lPu3i?=
 =?us-ascii?Q?eaxxWFbTe1Xt5W31jwYN8dFoIzrRnECrAtyIc7lbuPzJyY0fWjSDtFys5c40?=
 =?us-ascii?Q?0TK4PuaANVvqQzf7WCHflnBbBodef2mcVg7brvDD9i3iK1XPn+g+Kxv1b6FK?=
 =?us-ascii?Q?5aaTuBH9Gxc2U/iopAQNKFDY2w/uhwje3bwMc2kUf0RDgc2qJn1WBilGuM9I?=
 =?us-ascii?Q?lQSlvfi+1GTks3jnLXg8TLUv6TAjAquZH6T1uItV2Ry/tEA8H0J6Ugtrdn9S?=
 =?us-ascii?Q?UN3aC8h6sEzjaM8Ik4/iE0YfEWnYfNi8DK2AdsULlMiHoWeJ9r8NMjPuT0Xf?=
 =?us-ascii?Q?XAmJsT+ynA1EfG+rJWzEODvk/urJv6jNtZ0D0M53LvUd37h0CR2bAhomvh/q?=
 =?us-ascii?Q?q8+H7BH2SVZawNRIJxNdcGHzQhbyp7Q3sqNovXobdnhW0Smi9OQwN1ZfTjHl?=
 =?us-ascii?Q?vpjDaqU6N68uWSkh4gRPe2xfBiS8ytYneZGErgnuXIFJAqlrDTfOiDGCXH2t?=
 =?us-ascii?Q?ILNSscsSj6eGTY4vsqY34RkSz0aTBtnDPyWZ/DL4FXkTfRZUTRdQiWCLCYN0?=
 =?us-ascii?Q?45J8OXjtV5WOusRarjQixz83hn1DlzT1HU/bHu1okfOUq3tHjp0YKXZYUiIw?=
 =?us-ascii?Q?qR7dMI1AYgLAt1aQ9QUnesA2HXuSOFx8DIC+LpmslVO+cGYY+2nyt+YZZQ4+?=
 =?us-ascii?Q?D8nongtkIVKCxxg/x90rKfMun6C4Mby/20KaHj0GLOIjH0iA/UwfF3cCc509?=
 =?us-ascii?Q?8RbgkOtT7CSXQXTVjl4VUuVPskxZ8VL8JAE92Jr9n4xBI4ALnMb5SLOaWHNi?=
 =?us-ascii?Q?ubJ/UKvfUSuvI3GNfQakG/+qwv0DivHA48F31Sj3sTS6MYFIiYIkM/1ErYPI?=
 =?us-ascii?Q?XuIL/QfPUQJeUewUwZsk9haRNdp+Qz08Bjb5EQHGzo/4clpoueucAUlDEyyT?=
 =?us-ascii?Q?JQF6mlghkv1d/MOVoK588NyWmf/2s6M8fESG6b8avFqmVugjeft6ytBQ5rPK?=
 =?us-ascii?Q?YRn8vWUjWZeLTo6aOmdv4vGCMSZEcsQOcKKc6K4sXtU4p9ZXsLmaLW97AXs+?=
 =?us-ascii?Q?JAD2ZUAN+gByECxtcI2vz6eKMpcsL2+RLngDiVru0M3MLWk8yUhLuuZrSDaP?=
 =?us-ascii?Q?+w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b01ff9-d3c7-4cde-9376-08da8ac232b3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:50.7139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxzWJUFIwGx2lRoT+z2lu4OgbJZpoqoYiAYXWMLTqnkOD7ZROINKNJJmzLu/phOdu/GoXTkEGFtDYBRBI5zmGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the discussion about tracking the admin/oper state of LAG DSA
masters, we have the problem here that struct dsa_port *cpu_dp caches a
single pair of orig_ethtool_ops and netdev_ops pointers.

So if we call dsa_master_setup(bond0, cpu_dp) where cpu_dp is also the
dev->dsa_ptr of one of the physical DSA masters, we'd effectively
overwrite what we cached from that physical netdev with what replaced
from the bonding interface.

We don't need DSA ethtool stats on the bonding interface when used as
DSA master, it's good enough to have them just on the physical DSA
masters, so suppress this logic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index fb810edc8281..99d773b24223 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -226,6 +226,9 @@ static int dsa_master_ethtool_setup(struct net_device *dev)
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct ethtool_ops *ops;
 
+	if (netif_is_lag_master(dev))
+		return 0;
+
 	ops = devm_kzalloc(ds->dev, sizeof(*ops), GFP_KERNEL);
 	if (!ops)
 		return -ENOMEM;
@@ -250,6 +253,9 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 
+	if (netif_is_lag_master(dev))
+		return;
+
 	dev->ethtool_ops = cpu_dp->orig_ethtool_ops;
 	cpu_dp->orig_ethtool_ops = NULL;
 }
@@ -257,6 +263,9 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 static void dsa_netdev_ops_set(struct net_device *dev,
 			       const struct dsa_netdevice_ops *ops)
 {
+	if (netif_is_lag_master(dev))
+		return;
+
 	dev->dsa_ptr->netdev_ops = ops;
 }
 
-- 
2.34.1

