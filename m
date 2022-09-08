Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44E05B23F1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiIHQu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiIHQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:38 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C636597;
        Thu,  8 Sep 2022 09:49:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR32ojZowtgH4u1WjyRXOObuD+4/zeJFnKw30dlPoe4axL7qKC5Ndhx5C5ACRIA+6beWUtTSHpGYC0P4TG+fmQhHXEzN3o2mMmTZKgPOoVid1RPAik2OoKV+wLlvbW3X7Bk+CSEAt70u3d6WpdAjN+usJMALlq5xU3X3956sDwrmmdfSoAuLUgr6TRxAvh5YB5XP9tMZboPFbLcKeIXHKh10j4/QUJ2o200E2yuPW2vvisdZhvOSOPUh1K2lXT08FkiJmo8WmZdfrY+djXZpelMNGnszRL2qkTWvOOaJ02xDAQWPq1sF6DOcYh4rIzCndJEoqR6N9y2J0xORsJkTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUqg0sG2YqREUBAXn9C2xU/pJTs0XyvdUGa6tVONOno=;
 b=mmyE3SN0N55VgPGtmSOahKE8/k1hiZtlqBpYZ+qi4R9kDAxq02wk2hf0YIePHsMACrWyMfd0hQkf/Vuaj/3p6cyPMwLsHhLzF3uhXzeu/amsZ73+/QqIKGgp5m6vUftfHd+qvnG8DomxoLZnBlMZUi4DA5ygVO0axe9i9W+fEW9FdRnIK3nP7xWcl2g/Y/4s3NLTYsPSjyVbQZixb5sZBdFZUjDFSNjxKLKHKqstKD23VGyTy5/3tV68GtZIG46CCFAAnGE3hkbrv7N62B0qrbdivxKVjUI0KcDljQwlgppmhO9SIvqauactXlSa42uYtF05m/ZfFczOEeOZj0GfpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUqg0sG2YqREUBAXn9C2xU/pJTs0XyvdUGa6tVONOno=;
 b=KZ5amVjUdJlWL03KspCxv8CThsKWx30KfeUew9xHXBimgvqSijRlTdu/V2+ubobW93hdt88aWntafG8ddS4Nf90iv76KkkRc+JFq0XGhVqWtW9gOS4CItLGi3K4nnC0eBMsm61VTOqtqNdDxoxYuGJsdMdCIClPue3Jh7tMWFBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:49:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:49:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 14/14] net: mscc: ocelot: share the common stat definitions between all drivers
Date:   Thu,  8 Sep 2022 19:48:16 +0300
Message-Id: <20220908164816.3576795-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d762fce5-3a93-4437-4a5e-08da91b9fe42
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YyrsM12PTurL67pu1NUPpRjqiiaeuu5CUaB1+60S0cF/w5ZQRyWcT0zjVVPxI7Z7eX/VTXM6+xUyCzY5lU4nbK67oWzrRUSlObnxTGW1fre6Lx3j1un07yXu4fkWN+m9MSNlSPRNDZdx3WnZoGYqBJxFQ+NT/kK9zF4Wr3yRZaTR5aNAPIDUHoqtRvNbmSIXWGVxqMA3uafVRNHAtj2YRYF+7CQEXZcXrXY7MYzuS3lKqnW3+Y/dTKONND28C9/CZBluHF+jG5sBmTHkzsKOMFHRETzxfMyT8/ri37NQt9hLWLsv+NrFHX6ysJsPTumwJLYd8SjFVyFM6IpTTy/1oqYSdGZq+wVIVw7Ut9ZsoDPa1ufbnimuPmq94V7M2dVEp90xWxr2cQHiTweG7Fv8T5UoFLMULJWbJFU2pgECSlz4MET43/wKUmR5rx+8cLtQLsp0/ycwAlb7lcht8y2Qa7le2Wv1pTyp/MEzUbhs4JNnHBQLttA6qIjqXVdkXuuAInv42MZQLsHoCluCdTVlVwtD48Oi9v92bEUkZ1rCWi9eKzGECvHQAwOu533rlerSKy6gNEVTfJ2Me/PLiDXWp85QzfZYMCziTNEPeBjrust9wqu5lCx6r4m27b3uv2bjynq2Ta2SKOfsN3LOw75d+LfPoxJFtLtDfKv4rfa2tccF3bOmWQFJwh48JDpdKXcW4dl1kK2van3xNyDSIHK6i+HTMoB52wAhvUutw7jDEDsMyfhYxZDkJASfGAbKCegp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(30864003)(7416002)(52116002)(41300700001)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BZBrUnCdUJmQWicfbdjybswbJ+lhF0bjtTQAca3lawgQh729UiqRwK326LKm?=
 =?us-ascii?Q?XxU2DgHLIU15qvmRO/B+VxBoHIePw6GyTRINCw1b6M2PWJv7quNS0q5+Ursm?=
 =?us-ascii?Q?2da3FHxH1IetAOyWzMkH62Tx2TfHnfl61liETwKlnrCJ4wz54GZn5WKddeLb?=
 =?us-ascii?Q?D98WtC9I+wX4rePjnpfCZy+YySnn4how6VuuRFgKIGgVIVGdI4yV19kKEosg?=
 =?us-ascii?Q?h6EmVWkb4delluzPpK9g0IASaP5ClX0kbuu+XQydcs8z2+hytpsEl9MTV7fl?=
 =?us-ascii?Q?EDYYQ/RMLkv1c0b/zXt2tpqsXkmtcKkIALH6EVhKvNP31a88kOgYJ/8jWYaI?=
 =?us-ascii?Q?dr4x3TvyLO/FOsmpviGPya2YzkDPhXEdWbbL4DAa3lviXwX+iQUZkDnURcp8?=
 =?us-ascii?Q?vhh8UBumTs9KrFvGo49vo00QA1GZIqWo91uVBdpIC5GXkj+/hsM+OW5L96CN?=
 =?us-ascii?Q?ESW9TrgEBo24guk3SLt7EqQdS29Uukie1+CIAX5HV6SR6pKNhXfhXRsqkZfH?=
 =?us-ascii?Q?1XWswhCfWTC0WkLJVrkgYjDjeQp0zjes21tOkhJFIzeFJBq6hKyN1jbp91Py?=
 =?us-ascii?Q?baiTkl+lfCIF3tjym4TvfLOryxQwNMHYojzHNDcz5t5FWOSo4uyB3qNLDf2k?=
 =?us-ascii?Q?W95mcDdXakFN3bgl0d3tu8ki3OS4Hn1FS1ICQ5qN8QXdhxuRa8O9buWAOfVL?=
 =?us-ascii?Q?DAdtH5UhHijTtP5zGyUVb57tSYQGVwA2iQz0o/xNVHTfEQDqylPgGYRCrLyg?=
 =?us-ascii?Q?UZBtdiErJNGyfvuqOsXlaKiTk4KhZFVBh+PDz+MvJSTVquD4iulUY6UGHTaa?=
 =?us-ascii?Q?BIVULA2f4zyj0zV75I+ou0EBq1fDT1KmDzLubhjvrnViyUUE2nb3S/v/LT1b?=
 =?us-ascii?Q?qbTpS3UCGuvL4ojWRag7IzDLUI53WX7/D5RqVTrL7L/HSVzlXUBkMnUQTb/P?=
 =?us-ascii?Q?joZaYe1T9k5FOlsfHJfJpea9EkSs5jMG0UxwNzXidYevAj9PjjkYCqaxNdAK?=
 =?us-ascii?Q?mLIW5tzkRDL52lpfxsEKzkOkuVjlzlgY1feFCP5c2RV6moEsSocwwqmIlOpM?=
 =?us-ascii?Q?ctstxF7xfBPHhVgNrFOIvgm/jQMk3CSNFc//CRIjqxLCCLun4HjayumyGiNF?=
 =?us-ascii?Q?gZakYQBX6zU8Zsd0lNSyQNBN9j6JguYoWZSInt1BA/e8CO+3j3YbFSvNIXdN?=
 =?us-ascii?Q?BKBAjqt1FKEvJ4Oc/974+XpKg9k4qyTfbbEdYycqzXLdLUMlNzdz7/sI2rDw?=
 =?us-ascii?Q?ef7gHTwWjCfk7G9GDnnybIfyEbm5SzlDF+gLb7Ms7TYNKPbVSVtsjRFgAlT6?=
 =?us-ascii?Q?QN2mlsoIqBoS4+GhV3CTCAbftL6xucPu4yqeuR2uMFu2NKFmqTunyB0pHhKn?=
 =?us-ascii?Q?lTX55vDTn68qqT0iEmOUn2Jo01AVLhBQJpBdletzWyuCtLF75JGOiTA4/2xF?=
 =?us-ascii?Q?lJoTRlO01BZnhybjIkWCmSvlvZW0ypdauNKFlMLfBZKCVxID3NgXo1MjPwqA?=
 =?us-ascii?Q?qvPcqdq2Z52QBd9iOnrI7AByXF8sPXJ3jQ61JFjA6GWhQmszrf5uiAQYY6K8?=
 =?us-ascii?Q?CCf671E/bO7OomgJQxb7skXMGI2LYn30UlOvuoNTrcMsN+cljYtcm7Hn8fYZ?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d762fce5-3a93-4437-4a5e-08da91b9fe42
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:44.8799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGrrZp+6iAnZttM+PJ6mneepsR+O2wBpf3fO7aTHhmKYVgSkY3XpCaTQRweIQMVeagEsmguOi7J7eALTJM1vWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All switch families supported by the ocelot lib (ocelot, felix, seville)
export the same registers so far. But for example felix also has TSN
counters, while the others don't.

To reduce the bloat even further, create an OCELOT_COMMON_STATS() macro
which just lists all stats that are common between switches. The array
elements are still replicated among all of vsc9959_stats_layout,
vsc9953_stats_layout and ocelot_stats_layout.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 94 +--------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 94 +--------------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 94 +--------------------
 include/soc/mscc/ocelot.h                  | 95 ++++++++++++++++++++++
 4 files changed, 98 insertions(+), 279 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 07641915fcf0..848c5839c9c0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -622,99 +622,7 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout vsc9959_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
-	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
-	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
-	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
-	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
-	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
-	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
-	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
-	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
-	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
-	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
-	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
-	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
-	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
-	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
-	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
-	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
-	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
-	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
-	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
-	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
-	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
-	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
-	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
-	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
-	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
+	OCELOT_COMMON_STATS,
 };
 
 static const struct vcap_field vsc9959_vcap_es0_keys[] = {
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index a8f69d483abf..3ce1cd1a8d4a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -614,99 +614,7 @@ static const struct reg_field vsc9953_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout vsc9953_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
-	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
-	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
-	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
-	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
-	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
-	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
-	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
-	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
-	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
-	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
-	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
-	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
-	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
-	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
-	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
-	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
-	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
-	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
-	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
-	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
-	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
-	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
-	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
-	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
-	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
+	OCELOT_COMMON_STATS,
 };
 
 static const struct vcap_field vsc9953_vcap_es0_keys[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 8fe84d753cc9..ae42bbba5747 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -97,99 +97,7 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
-	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"),
-	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"),
-	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"),
-	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"),
-	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"),
-	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"),
-	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"),
-	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"),
-	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"),
-	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"),
-	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"),
-	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"),
-	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"),
-	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"),
-	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"),
-	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"),
-	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"),
-	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"),
-	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"),
-	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"),
-	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"),
-	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"),
-	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"),
-	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"),
-	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"),
-	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"),
-	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"),
-	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"),
-	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"),
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7"),
+	OCELOT_COMMON_STATS,
 };
 
 static void ocelot_pll5_init(struct ocelot *ocelot)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2fd8486bb7f0..355cfdedc43b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -709,6 +709,101 @@ struct ocelot_stat_layout {
 #define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
 	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
 
+#define OCELOT_COMMON_STATS \
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
+
 struct ocelot_stats_region {
 	struct list_head node;
 	u32 base;
-- 
2.34.1

