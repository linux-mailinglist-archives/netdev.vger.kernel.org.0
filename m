Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4559A4B0
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350083AbiHSSCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350078AbiHSSCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:02:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80059.outbound.protection.outlook.com [40.107.8.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5054661104
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:48:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfZ2j91S4RvGrc4o81v9CpAUWGpY5rnV0KTVH37fR5H40jfVziNL7I4RUNlsojaFiFuN0FtDgIYD1c/UN5PqwSa+GlZsqHHEuJjZ0pBIuv4fKMIfR7yb2E5L5vVmyXP5DZ7L4w9zbs9ot+IqwP0zz/CjQkddFUGg05N9esx/QWIcALoLhd/HHmh4s6KuFBDUmcuVNtVTW9P6LGDQILtomTm4tbhFGAhKySujm6F4YyrHe9MJZU7ewlDBedLFDRSqsdAk9astciWJbi3yIXoTkMzGxGCb6NQ3RPvbDuiZRYK33QEezxJhf7S58qb2/qXn8wmIDc9berXs751g3xs6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c05nCBatA6p8JbJ2xNUWh+NBPqn32UhSKRjurn5BHOE=;
 b=A0CLSF6Cam2Wa44ieRmT4s/ZHXmEt4sPHnxSnH0suiAfFUSfeozpp7KCzZ6tkwsGwVoQ7rJCeEuwhiJv/iSihVX2ygHWRpXioZOVXWdfZYmu0NmM87x5CuFfuGwqLPwUdZkFg6TePifNeWer0MC3wwa2iXDcLxQ6/WbDhvpb3uKKARfTzDz1gnxw2ArIvCj6SWg0eh9f0zHRtViZGLogfbLAsTBRKf/5F7kFFdXfubjIRpzkdlTjuWXYvfdXNunP3JOzpmEDfSJPXRMmmZ6QR/qkg7hFH2LWqSBd6S3R00uUSUZHBpuq8VDllCtR88ywiNjPcYShVuprYx41O0RKHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c05nCBatA6p8JbJ2xNUWh+NBPqn32UhSKRjurn5BHOE=;
 b=phDnKynKIsocrQJVgKClWkIe3vHg3cGEk3OshvAZx+qic16UYozZpz77nQNbdj8u2ff110IDPg0IUhi8CbdhlrHGrC7VhdqOPyDUl29SsSytwWXvR6odyXAre5MMR64yzkMD5uhYZ0lcj8MAGjSrhbDyGozrm+/by4HwWdmOn1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:48:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:48:34 +0000
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
Subject: [PATCH v3 net-next 3/9] net: bridge: move DSA master bridging restriction to DSA
Date:   Fri, 19 Aug 2022 20:48:14 +0300
Message-Id: <20220819174820.3585002-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3b0ad3b3-6668-4898-3427-08da820b09a4
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iTxDIzc6argDsCySURA0eumYCVieRp3LbeT/TKFH9wkOdEMSO4Ibzp56IF+iqOpGzpmabAmi36Gm+kSRegWJPFX8+TUct0K/3jsATlDTE+KN1jVcOWhrV9e8Dnj+OHFOf++plC4mCiqCSRgp+ZX9Ft0tseN4MyvJH9AfKixSgy0CpB2k6AI7aRO8owsr4uLeiJ7kNbGmk7oWC1WRNsvuoYN9xHpiT3kXlG2Upirrxa/HR4f32pnjcT3EyMUXkAUg/n8OaPZgSbRWa+hyJt0rJn8tVFPkpNStjgL3KDMTeOFqUStIgG/h35IBjm9i6E9m9wnxLxhesHH5yve3CeQCAFhgOX75nMgWov8Kfhr3RRScvFlfe50tmALrO/3jFJ+JHF2UuCFuIW8YNSt7FbENyeS3N/gsLxUa+iylZcbD1UAzLjlDt//XrRXblS6US440JMSFbtThAPq9gNpVVn9zYHFSBuHblFL2pn0ICykUFwI7K6b4XhwA934iSqsuCu3ff774T3v+BkE8hjNRecW1Dnj+5Ochpr5mCuahuDlgfwkN74E/dAwULAjGwH7rjw3y+BQMLzdoKDKINLdjDfPOVo68w/agO8W0QHgRwga0j5XcTgFUyG4jxxu1QLpMzppHzIumzPS1EZorOib3eHjcXnP34URjxzqBYXNk0ApjJWCNvUirWLv2TaRg809jgzFho5moFTgm4yHNxjBTbcGgO8jbP7hJDA6JpMakZMpWWxWqDbYhwVCMqNeXFbOLOlLkdQ+T9VD61bIoXHEkP75RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(66556008)(8676002)(4326008)(7416002)(44832011)(66946007)(66476007)(316002)(6916009)(54906003)(5660300002)(36756003)(8936002)(2906002)(478600001)(6486002)(41300700001)(6506007)(6666004)(26005)(52116002)(6512007)(2616005)(86362001)(83380400001)(1076003)(38350700002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0P7oG3kupAkiX+SrJpvQY0D3d/FXM1+q58FkCpIWaoYxv9K5lqQKuVm6eVoZ?=
 =?us-ascii?Q?t2VVzUrBl2Flsvl6shawBh7Lwx+w7DmFhiCS4sk6/QcAASYniEw+dnm3pI8/?=
 =?us-ascii?Q?UDIbcuq2fYR/F8pY+qvmSq5B+wU9B+vcwxlL86oVJl7hqyruAZSY9BXIRqXj?=
 =?us-ascii?Q?W7GcpkPmwV+2DM4AZuSpNJzVbWzHO74hbZuTOmdtfWZ2VAA1TxNFsTpaJGTb?=
 =?us-ascii?Q?hA2p3txNewyRYuSPF08f4jS0szIaA0s0WJi5U3wPkRHgFsxTv4mnSmnMFK9s?=
 =?us-ascii?Q?VVx2D2/28D1tDkc7QhHKY28IUcvsvAehLcDqQLrgh1DDu6OV0o23vsGw5mTQ?=
 =?us-ascii?Q?BHv+Fx1rxTvCKP+LLQZHo9INOsaoktNVFzie6uDW9oQyXQN0P+9/RVCJG3Yt?=
 =?us-ascii?Q?LQISmyeXljCNEZlov4nOM1OIj3xmFwMZy5Ek9WwKNa62/n7UBzPmGX3ezWt6?=
 =?us-ascii?Q?UlWo3i7RJTDButl0oic5nTMQqidTdRjtMcWGzZMRpHuLcamltStpDTiDGC+F?=
 =?us-ascii?Q?pcNUa9A4BKnS5kswiSz9J6328t0rEjdy0tLzo+yMKBJxhAGTldrSe7A1VO5f?=
 =?us-ascii?Q?r5qzhpmONnsDm+6VxP3DqOKTL7NFOYu00ihwVpAM07AoabjY4f1+lQhAr+m8?=
 =?us-ascii?Q?HCtHCGux1dX+aS0bI98sC6fsQCowyLfkwYjXLZVWpXQA2B89iqyXPW5Y2pRy?=
 =?us-ascii?Q?w0Y1t5RkJdPkBWgItG79KB6ddTWXP6z966uCR/ZgvEcfYBQB7P4ghSEoEs7s?=
 =?us-ascii?Q?VW4qPQ6C77WisauJlJmSPxiV1z99CDHb3i1NMSI7YwTrQd+4xDA0pPzEicf+?=
 =?us-ascii?Q?NKQjBNw6A+zL2aIUEFvRLxuhdpmTkBZKDe3+E6reN9QaE1Y3YdYotXb9yWtW?=
 =?us-ascii?Q?0m1441gVcHpyS5lzqbd6p75OeSjB35NtfVYSW2pVFxEMPgDu36XceNAqsIUj?=
 =?us-ascii?Q?vXtnV7D+rMkuejuyckNRTP8vCnZDsmCX9Hz/BAivtPETqydmz1pkx+LibTme?=
 =?us-ascii?Q?LtKABrdsOPzsagfAOJHW+X5zSCZa3cHeBe+TNwJ1omrax5AtG364WJ/R/rev?=
 =?us-ascii?Q?x4aUEszwe63pprlfftx+dP3fqOLoflIZzxXBE702OKDAcN1k0SHFrZA9/w4q?=
 =?us-ascii?Q?sAANtFM71aDm7Yx+TcW2z6d/uQv/MX9V6qre/uTAoqHc1lakeDT4qetOB9ii?=
 =?us-ascii?Q?GsZ04uc740sFNg46OYAEHMZw/A2PInd9srPyMiie4rhHutgGjHbpD9ZgawIn?=
 =?us-ascii?Q?VntwO6SNlkg4Wwz34Slg/X+v7ZKnKhH7Az8T4srm8z2EUpycmG/2fbA6EK9n?=
 =?us-ascii?Q?qe0+SXBhJIEKkv/duztbq1jaq2PmvI55mct7J2DLZxZp/L6M7rR7CeFsBVjQ?=
 =?us-ascii?Q?DQclpsMIXXodUXs2ddddKN2IQvUmbre+ep1T64Sesjbrpic1pGyqJNGyHpEP?=
 =?us-ascii?Q?NETxPFBdm+kf+DXxapNhlhfNX/Ve8jfbaoPYBgUvVbmCcucZiTlTqE263gla?=
 =?us-ascii?Q?IrRO9ig+schOwK7lV9FYotZC4+b7PlhigWcy8G90yipNGnuLfwVSynE9MvhX?=
 =?us-ascii?Q?9a2ZQdTr8+waFlnAmt5Eb2h/o38KsJquOxp0Fl2TdjSzm5DjOmvNTMmPSZn/?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0ad3b3-6668-4898-3427-08da820b09a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:48:34.6853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QYwVswIOI1U7UplB69WZC7Q1InONmWURJLrDHPX0dDAn8MpjDNtqgTfroEh6uMq3l2wVCeOJiu0XWVic5xZ/lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When DSA gains support for multiple CPU ports in a LAG, it will become
mandatory to monitor the changeupper events for the DSA master.

In fact, there are already some restrictions to be imposed in that area,
namely that a DSA master cannot be a bridge port except in some special
circumstances.

Centralize the restrictions at the level of the DSA layer as a
preliminary step.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v1->v3: none

 net/bridge/br_if.c | 20 --------------------
 net/dsa/slave.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a84a7cfb9d6d..efbd93e92ce2 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -568,26 +568,6 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	    !is_valid_ether_addr(dev->dev_addr))
 		return -EINVAL;
 
-	/* Also don't allow bridging of net devices that are DSA masters, since
-	 * the bridge layer rx_handler prevents the DSA fake ethertype handler
-	 * to be invoked, so we don't get the chance to strip off and parse the
-	 * DSA switch tag protocol header (the bridge layer just returns
-	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames).
-	 * The only case where that would not be an issue is when bridging can
-	 * already be offloaded, such as when the DSA master is itself a DSA
-	 * or plain switchdev port, and is bridged only with other ports from
-	 * the same hardware device.
-	 */
-	if (netdev_uses_dsa(dev)) {
-		list_for_each_entry(p, &br->port_list, list) {
-			if (!netdev_port_same_parent_id(dev, p->dev)) {
-				NL_SET_ERR_MSG(extack,
-					       "Cannot do software bridging with a DSA master");
-				return -EINVAL;
-			}
-		}
-	}
-
 	/* No bridging of bridges */
 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
 		NL_SET_ERR_MSG(extack,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 008bbe1c0285..09767f4b3b37 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2699,6 +2699,46 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+/* Don't allow bridging of DSA masters, since the bridge layer rx_handler
+ * prevents the DSA fake ethertype handler to be invoked, so we don't get the
+ * chance to strip off and parse the DSA switch tag protocol header (the bridge
+ * layer just returns RX_HANDLER_CONSUMED, stopping RX processing for these
+ * frames).
+ * The only case where that would not be an issue is when bridging can already
+ * be offloaded, such as when the DSA master is itself a DSA or plain switchdev
+ * port, and is bridged only with other ports from the same hardware device.
+ */
+static int
+dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *br = info->upper_dev;
+	struct netlink_ext_ack *extack;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(br))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	netdev_for_each_lower_dev(br, lower, iter) {
+		if (!netdev_uses_dsa(new_lower) && !netdev_uses_dsa(lower))
+			continue;
+
+		if (!netdev_port_same_parent_id(lower, new_lower)) {
+			NL_SET_ERR_MSG(extack,
+				       "Cannot do software bridging with a DSA master");
+			return notifier_from_errno(-EINVAL);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2713,6 +2753,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_bridge_prechangelower_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_slave_prechangeupper(dev, ptr);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.34.1

