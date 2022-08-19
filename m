Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C266959A3B6
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349712AbiHSSCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350480AbiHSSCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506A861716
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLCteqJ3GvYfi1srfVtJLAi3EZw4j21ULa7LuEqI6SwBx2V6UpUr3JLZvSYiGjOIHQRGvmCl9TRy59yt/3HroZOAXH00GUIHRaEE/9uH/+643s5YSByOc8ejkbQbd/D0Dt12gbxqc/le0dZqTy+JfvWcgoLUGkpkP6tUd660/n5kxsVnjJPA/Njv97KDQaO/ITZREczzN+0xFK8pAo8UIFuUSk/dklsi1WCttWxZ3NsIiGmhfWgcHe9VzmbMSPRfrUMw3ngdtjwemCfGvVxr3aajcSnShZxaAM66PXKgBsO0jo9LLZ8j/7GVhLWDVYag6IRh7sgjn6m9btOZLuMc8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRRxhoK4/GKcrJnPbk+kjossqjK7OMsto7APf5cpwkU=;
 b=nBtlGFencILI/bT4+HNn5rniKobCoWQol3ZCRO2KjKUCb0DydnfiVzqiOw4m7LMkuPMF8mKxoeWbLCYiPcyMNT0Hmz6dgWlLgend9qwdhPaagykjxhLZ4xJMLQxjvVDVuY8OxxcVAGkbg4MRy3j3eAwyjPWisax0yhedgBfLoElM/jJVgS4Ntm8SxWvGAAiM+25foMlP/+/vodhab2ptflBuKCt9ZxdCa0YHWJ7O+nFwjEgbQx6K+AahAZrahLO5LhOQ5rWU0fnE3Wr8GLCpBcQeIc0sErIlpz3GIaovbkwGHWIxKP4FrnwL5eH73F7zds1s7uOHSL3O7VwxaUZotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRRxhoK4/GKcrJnPbk+kjossqjK7OMsto7APf5cpwkU=;
 b=fzHw+0UtCEPGUQ0ZQuiEJGDFaKz04it2dH2/u9wz/oh8pckPcQc+K2oqnpNPS9ag29FbEFDFbh7uBIyrzDm08efb07YJMrlzfrZd4LdbWsTSPbLtWhqAqd+JtUNQgD+gEyjCtyTgrKJQi8G9KDRt9+GUE7LOJl4hAqOS7Dj6zjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9088.eurprd04.prod.outlook.com (2603:10a6:150:23::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 17:48:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v3 net-next 1/9] net: dsa: walk through all changeupper notifier functions
Date:   Fri, 19 Aug 2022 20:48:12 +0300
Message-Id: <20220819174820.3585002-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
References: <20220819174820.3585002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cf2cbf0-ff11-4aae-4e09-08da820b0811
X-MS-TrafficTypeDiagnostic: GV1PR04MB9088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VgfePTBaa2nLvD1tkFmejTuHzoQL74IsStsidTeN0ZRe29dsvZx0ENg2ERL2K6rO+SGn05Y3o9YTvTtrOVk1SQnjrbyeYjFhNzLTokX8UqecNLkCMN5OvGOmIUljLxa61VVR544z3nJInaQ1XQop0DhcmnF2kwHgoyDF8k5Hp/7n4wgg8ZuZilbOvTpEzLOa5qbPo5YZuQ94r7yo8LwCVlWJB3xt9qbNk+3qjb495ggiMzLGczLqKmj4xHrdTJwrnZj20lUbst0Jal7PRplJc4cHsQg2jiYtNHv/udqd/VaA8DnarmcNtwfLHseDgj71bZgcWi02e5/0fGQgaUhl8AxaGDOSYu1+CTssl07SOleEYM5FkCxaGSa37SZI01OuuKbFktQ4M/1v31UJPYBeExj2wuT7SWw94uEXWOK8JboZtzKQDTnDKEG21Syc7GGcjA+hPsRk4wGut1XXktgqYOvUUGAa1d9UbixZ8UZWzfMpGTCtdusW36Z8mVR5N3ffKVNCTaSfG+P2p4p1dgkkA69tlEUwnDzZkYEfAZfeEPtvjVZnE8qYMIQeKHVumP6RtKHN0TcsgUlOrMkp0r8UHxacQnvpkM0aNjRwR9+7HbA4B38TUqdkhp8AWfBK44lwsa0L9GCm4BrAGMtfU6+38g5v4QvanOjXq8UHOh+5BnBgo9Z4H9XLAoay8AgBt7E7ssFeB77QYSGiG0Ogug/MQKW//Z4jt3rTlDYp0q58IcfQ4MvFhfrpZvBdTJ/H9JvE7XpfFiqtLn+aUIGgIuVm3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(2906002)(2616005)(6916009)(186003)(1076003)(54906003)(316002)(83380400001)(38350700002)(38100700002)(4326008)(66946007)(66556008)(66476007)(8676002)(36756003)(6486002)(478600001)(26005)(86362001)(41300700001)(8936002)(6666004)(6512007)(6506007)(52116002)(5660300002)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lGYB5+Wd3dJ4RzYWSRn3rrsXBG3u4Qiepmr+ZuHwJRMSBj1jPyqa+9WSxaXQ?=
 =?us-ascii?Q?eKKDzXHr+4EMGGSDj8z9VWAhxkT6xj9ZP60uC05ccs4fSW83X0C40z5ANAD1?=
 =?us-ascii?Q?c4MjgNZaKrbdG2QqFwzt2tNIwtIxJ9d249MvXJ1Es4Bre01rGB0y1V1PfeYz?=
 =?us-ascii?Q?24q2UmS5iSCAHkTAPDr7zoT/T+HLhmPvwU5TECcNJvn3n0Bhuj7No1EZyVkh?=
 =?us-ascii?Q?J36tLbUQvDJ5p3U/k/VU60mftivI9OnnwrESbx+Tx6ILVUdc7NA5ywoUweRW?=
 =?us-ascii?Q?5Ij9yvvjQPEA2Mr+W3LQu16c1BPBP3DSXQswqbplTNA0D+QjSOUVMIkJ3LrN?=
 =?us-ascii?Q?i/rCd0UxOGmu7ilrI9t+IPLpQ+4BFRjpL1LRIZIZpT02Jo7JplwNAlTJ20Fr?=
 =?us-ascii?Q?Be+rHNGg/1BP3SqXJ4mnO9v+U7Tw1dOMlYvkwCrdPPBT4+hTbIw7ByyT/Piw?=
 =?us-ascii?Q?QMMd0JqT4la3rptIYIzmsQZ2HRG7nZj9i0FqyZK+pRiJQbnDPgrtGkj1Fbrw?=
 =?us-ascii?Q?bL5pBrXbupfSpQleYzFnzxmUJH9Tr25fIpZUpxU0sWU24weqL5D3Wr7q0e95?=
 =?us-ascii?Q?zkag8UDLjpmrbZY4C7EseR0v0BGb4YITSgah1Z7BoWJY+wcgGXHdrL6pN1Ej?=
 =?us-ascii?Q?OPYD9KSjLwa+0cxZwiYfMResCYQ/mmA3tUuY72CS/aV5DPZZeA3vDhPgcFyE?=
 =?us-ascii?Q?Ucw20+dSv8cqZ3LDnTmw3B2LH1PAN4ahvMvJCR0gr2vNLB55k+cjSdXwkqfX?=
 =?us-ascii?Q?OTuWKUITRIVxYeBcyjAvayIGehIurTRh2Y/ii6u6s/akXL4bM4lUl/wqMF1+?=
 =?us-ascii?Q?MHV95BBoxSkIOV77q1i0GL5soJ48pFh20W/4D+mno55PxnSO6bKpZnr7gtEt?=
 =?us-ascii?Q?aOnuwA2SLyumuMumrvZv1X9Gdf0BSoeHvlfMzK577UFWfQY10LsReQ9agHeV?=
 =?us-ascii?Q?FGuyu5mK57PZgdQ4rsoB1/M89jBMVUclD/gF55YkBMju1tLDJY9pi23Cxgxi?=
 =?us-ascii?Q?D0FAzvQaOdGZ2g8OPRAGG6nNLs6DM7Z3rGLxdCXUiw7nJLJ7gwTl9FBT2/OQ?=
 =?us-ascii?Q?z1FMeyckg3+dd/DTEPwC4JCtulRKAsyY+uAT6epzF4q2UCklQ2kTg0E9P/c9?=
 =?us-ascii?Q?pH266xu3O1G/r/T/5nq2dpW+k76Qv5DJDKvPX94uONhq9QtqKcJ/1FioZjEc?=
 =?us-ascii?Q?/HMbATzVansIKqKuESyD6SoaR/UpewuWkDn9CWzmlm15tzM9KDzsmZxJP+GH?=
 =?us-ascii?Q?mgrDamlsa81sE9a89I5e121DXZv4WCQOcSN5GNi8Os4zSENpMluTnawz3d1U?=
 =?us-ascii?Q?9Wrx1vAnWcfXYFU8d/bI+u5+EfYAPWbuHAKxHKXIIXtTpLxtHXrVzgs5ZVLM?=
 =?us-ascii?Q?8gyu/CIzN2Qome3RvvF6gdp1Yr5mLQ4wYaM6AFPg04K+/ajE8lOqpJJzdUEl?=
 =?us-ascii?Q?GUzgonyXbdgPDireAZwIMpOlkLerFcwQVvpM/5OmgJt5RqOynWWhAB4lwQ9k?=
 =?us-ascii?Q?fEhLUkB+JIDghOxNLA8E/vraUa/N1vn2dmmw33ue/Jlovv9fLOvQ0F8GFf59?=
 =?us-ascii?Q?DS2HaBNTSl5p+/nZXdV/EIuxQqD/ofWt/wzS1UV6xFWQgsD7GzSOyPB/+1FY?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf2cbf0-ff11-4aae-4e09-08da820b0811
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:31.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQ41gaisUK4iMm/iTfZu0NxkUWastX7NqC/umsQujPGGL3Qm58y0Wm9xT6uDxkf+9IkSOaUzcqqVafJ61ZqI0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Traditionally, DSA has had a single netdev notifier handling function
for each device type.

For the sake of code cleanliness, we would like to introduce more
handling functions which do one thing, but the conditions for entering
these functions start to overlap. Example: a handling function which
tracks whether any bridges contain both DSA and non-DSA interfaces.
Either this is placed before dsa_slave_changeupper(), case in which it
will prevent that function from executing, or we place it after
dsa_slave_changeupper(), case in which we will prevent it from
executing. The other alternative is to ignore errors from the new
handling function (not ideal).

To support this usage, we need to change the pattern. In the new model,
we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
if there is nothing to do. This allows the sub-functions to be
relatively free-form and independent from each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v3: none

 net/dsa/slave.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..2f0400a696fc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2476,6 +2476,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2531,6 +2534,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2551,6 +2557,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2580,6 +2589,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2701,22 +2713,29 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
+
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-- 
2.34.1

