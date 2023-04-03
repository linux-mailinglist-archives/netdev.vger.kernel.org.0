Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155B56D4226
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjDCKfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjDCKfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:02 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A62230C0;
        Mon,  3 Apr 2023 03:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkPicQG3Mwn+zelksmPh0rvapsOVgQXuGIshggOzs/O+qpUyuA6ZgqoE8aicyic+uNGmAUMfYHFgCLJmnJnlpcNFrE3xN3HVs0xPVVpd2rw8kqRgJbbY7Jx9yB3KHVq25+kNdpZT/I7T1AYwwj9y9T5VtowM3jxQ3fo56EgtCetL2/OfIzGBAaLrrb7l7MpTSXbBnL+q7z4Xyi2s1I9aWGb2VqZRpRIyv9k51fe3R4xxLgz8ccnS4SNqB/3nL43BZAqUpvXCe3p+ZemF5Gr+5vOJoJxeJomDmwaVWqhMoifTxronRqmS9PqIneS6lMOqq1PnXpKmbNWyQ/sztqZumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY/aF5uCNJirWMIsyFHU5hjMEXepo7qEsPXSzwR9Vys=;
 b=d8yZVmySdflxey90Yq/2ZVVB4zffOTKScdgQIScHtGHy4O+YnPB1iQ4bE9Bs/cwrPk4C0/BhV3d6TTFYJYOl5F5itzNc3Ru0RgyjvmzHSqGIf4c58w6uVRgoNW4uHKd78Hw/1olbpgZfJ3P5aRQLHWT2HiQLuTUVWy0LrED97RWBGF/3Eq/QVTGJZ/I0QzLfPek4Tj1iIOftysLi/ZPEMwGCS3jGmOO+tAK9drfhQ47vULZU1E8Thfz3Y++xoUSgCQ11yXDHALhQwtueNLNPWLvcO5RGNOk2u1nRZgVgoEDU7vitEhXPWxrH9ljpVIBjlRq/uuFVLBca505uaxSljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UY/aF5uCNJirWMIsyFHU5hjMEXepo7qEsPXSzwR9Vys=;
 b=ol5iU2XgWqNkgEOBMdFHHl49n+vED/bzcoEBHmU4T1Q326hu+2pGYd92trcGYHeRECPJvm+1kgHPD325AOJvudnY/EPhYqPu0L9upFMB8KwYsjkDb6zmd7VlSw0wISNUwa5e3aD4e5HJGt0v+xT8qEWJ5aG7+Gh3huB/Xdt1ar8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:34:58 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:34:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 1/9] net: ethtool: create and export ethtool_dev_mm_supported()
Date:   Mon,  3 Apr 2023 13:34:32 +0300
Message-Id: <20230403103440.2895683-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: b1056332-5de2-4e39-f36e-08db342f1274
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKptN/TXpaVQeWuVRnqW/Rgkwi4NFpseU6ZDKxgxXQbqZthlvtr8nGfCE1/JPKnpyhsXOAUnE7woo3Ye76YWEhnqSaAOH8PA7IWjzVWZMh5eqb+cDzK1QNUdknE2iEhTg4d4cEMjgiLW/BP61a0+RQseK8eUnWKfG6bOY5lAvNFSoA9PXj6BPbO/VSfhcCi3Y1knt5mkIz45+6/YrIt67MbpQylz2PV7xH1IXpNkStWToi2ePrBUByLcVgXjVT+NdmpmT3+WbTzpjjU9yUjwfeHBfEyVR4klpcpYH1L+KMnLbMiF62MDsnjgM5pGwFb4ElrwiabjswEVoCE+ZEXx66mxOCSDH0nxCHlDL6QtUKwJ6vz03bOCGR+eWQLN4lrkEbtQu/iAwEzokTHaowSE27hIw7aJYa8yucHpPDeDKgrFIHBWjyYpeluokrBXfkvShttJdOS+FmYd7x/z8GfPyZ+AENcgUDQUEKwMOXcZChiekR1zKyCo1wwozCHCe6WzFUqIuJqddweyuOosU7mzc9pjytBV4wD7uRdOUNIVtebY6ExOyszG1uCbJLwtdzjwH/ziVawyVLQ31sYtsBbavGa7Fl51gCpua8WeIH+ZhTFYXZ5yUkaRhw1azWY/J3uk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oVuhACjhAENuuOC/7phPgONv/X4B4qFMdIxiRUi3RcJ2WVGtwe2787NffkgO?=
 =?us-ascii?Q?9CLxOhNGkMuOiDyX8WWqbRFsbRc6Jl1X2Nlz6uZUXfLvtyxOrCZKFpWVq66Q?=
 =?us-ascii?Q?kkopAYN/fXnpTS0A8tjGr/0whuJzfuPfAuyubaZZq9uPunJrbdETqUWcGpUh?=
 =?us-ascii?Q?vhOjy/8LrIOHlLS2mFhBMWBDi8ON5Ua+5ES1gbY6V/vO0p4kM5sj8OUqKSAS?=
 =?us-ascii?Q?Sxgn5NrqcmlaTOvV9aaevS9xNP7S/8uOx9THhXBw5F3lEoC4L+CFP3rb6Hk1?=
 =?us-ascii?Q?/4q6Vaw8vRrNdlTUPPt0bmHYv9A8XATeaorH5bORJAEO98VIehJM96BQkTEX?=
 =?us-ascii?Q?ZCdESkKw7rrrTSukVl5xIzHahYA9nV1jmuF1ErQ60L+Fz/DuzKyTwgjH5iZx?=
 =?us-ascii?Q?C6M7f2K4U1zjvo0BTm6bvPZuUwjlwPKRFQGL92kfSbFjLMJw1KgG+tXtID8q?=
 =?us-ascii?Q?irbC+5sRyM3TCWLQgJuPi1BKBErxDEX95YejzmSXLduztkP/JWVT9kU5lNAB?=
 =?us-ascii?Q?DlmQacdzTwc8ejaEym7eO061SUeMLibH2VioPy8z6yaYjuGGNW2FHPhVHQXC?=
 =?us-ascii?Q?hC7QSvfmpOc0qwuF/xEHqyYw7lvyMkVscpZu7HgcK0X66ElvPABXujskLJ00?=
 =?us-ascii?Q?GFESVyAhIeDl2wZWyZBpwa5LPHUhg2ACOETg1PbfPz3cbh0mecl89Fig2rNp?=
 =?us-ascii?Q?Q2daWBo7mrngOaum/ruup3CFJXgpPGidR0KDyrlaDl0WWNCTJb9jpFNnkB1M?=
 =?us-ascii?Q?ihp0Mkp2++jxWETNd9kbO5rDpZKhiRQJNTAtK+0qD1kt4S+UrGpculXQTefI?=
 =?us-ascii?Q?Gr54mhtsaTqBACDSRdfGM9k7cjvjt1cQXxohA/+al8HOP6u2vdZomUBtbiiW?=
 =?us-ascii?Q?YWutKLyRdKHR6lCR4GozX5QajSBi4TmEcaI39iFCO9WF7L1vp92o34VC9cDB?=
 =?us-ascii?Q?uatP9VApxPt35EUQXpW6EfV7Ry6VuiXJUacI9WxLIA8fcJcbqGi/lltYQxS4?=
 =?us-ascii?Q?tg4we/i+Og0myI5lYRuCnom+SKSivCQq6vmcNjGRrJzzDuBz8TU9QKV0jVUx?=
 =?us-ascii?Q?yRZXIYzGIs673rrG5xObIhwn7flyiUcioUk35XX76d6bc4MlwShh6vkSF5Ry?=
 =?us-ascii?Q?5DkNvVHNs2vUIrkGl5StYaHazOcwwsXr8f28vcr40OT80YEtxzXYFtFWg0R6?=
 =?us-ascii?Q?18CT3Nkxk2ZUUDeO258tSpdZ7D3zInIU3q8p34Rafh/DrTDmmNzg3/gjBGnh?=
 =?us-ascii?Q?v66hW0XBx6F8Qpe2lIGVr012WPI71cLWEbz0wIdAbPTe0ssilIRZjJC6VzzB?=
 =?us-ascii?Q?wf1PIkmSaS7Y0N2RNaO+8wCbUzmDEL/pa6V2Y6DL9Mtl+T/4hbPE3y4lPnFS?=
 =?us-ascii?Q?qI9UNQ6CqGlVOhbJA3Nx5EPNfZ+IZ/YuWSA0eNNi1wG6WKIzjHckuNi4OJVE?=
 =?us-ascii?Q?UMmO7AMkQN79wXjYyAi+tMkgA2Cgz+p8FkoLrAFn/BGjUT0GdFipYQUcFgAw?=
 =?us-ascii?Q?LM9fWYE2NkcfpWUM/AQlnMUcdHJqTpFTmfQ1mwblO+CbbZdwcWvrkbQN1PRc?=
 =?us-ascii?Q?9GXmRjHVeciGdq5gc7bqLgX6UL4oP/A0k57AmC2pk9k/usG34SITORWW3Zsb?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1056332-5de2-4e39-f36e-08db342f1274
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:34:58.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dWNy+QN/yNZXRoHgIRoEtgbcqmGffwDyiuoOBu7Ob9WLEj9lgbuWvxJ75ULZJAqZsbBQwpIaIYE82ANcyhJdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a wrapper over __ethtool_dev_mm_supported() which also calls
ethnl_ops_begin() and ethnl_ops_complete(). It can be used by other code
layers, such as tc, to make sure that preemptible TCs are supported
(this is true if an underlying MAC Merge layer exists).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v4: none
v2->v3: none
v1->v2:
- don't touch net/sched/sch_mqprio.c in this patch
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)

 include/linux/ethtool_netlink.h |  6 ++++++
 net/ethtool/mm.c                | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 17003b385756..fae0dfb9a9c8 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -39,6 +39,7 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 				   struct ethtool_pause_stats *pause_stats);
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
+bool ethtool_dev_mm_supported(struct net_device *dev);
 
 #else
 static inline int ethnl_cable_test_alloc(struct phy_device *phydev, u8 cmd)
@@ -112,5 +113,10 @@ ethtool_aggregate_rmon_stats(struct net_device *dev,
 {
 }
 
+static inline bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	return false;
+}
+
 #endif /* IS_ENABLED(CONFIG_ETHTOOL_NETLINK) */
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
index fce3cc2734f9..e00d7d5cea7e 100644
--- a/net/ethtool/mm.c
+++ b/net/ethtool/mm.c
@@ -249,3 +249,26 @@ bool __ethtool_dev_mm_supported(struct net_device *dev)
 
 	return !ret;
 }
+
+bool ethtool_dev_mm_supported(struct net_device *dev)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	bool supported;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (!ops)
+		return false;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return false;
+
+	supported = __ethtool_dev_mm_supported(dev);
+
+	ethnl_ops_complete(dev);
+
+	return supported;
+}
+EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported);
-- 
2.34.1

