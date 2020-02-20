Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0D1658E1
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 09:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBTIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 03:00:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32084 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbgBTIAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 03:00:21 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01K7x5MP006512
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 03:00:20 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubuw6g5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 03:00:20 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 20 Feb 2020 08:00:18 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 20 Feb 2020 08:00:15 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01K7xJx717170870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 07:59:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4B814207D;
        Thu, 20 Feb 2020 08:00:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7359442063;
        Thu, 20 Feb 2020 08:00:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 08:00:13 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: use netif_is_bridge_port() to check for IFF_BRIDGE_PORT
Date:   Thu, 20 Feb 2020 09:00:07 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20022008-0028-0000-0000-000003DCAA8B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20022008-0029-0000-0000-000024A1B9A6
Message-Id: <20200220080007.51862-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial cleanup, so that all bridge port-specific code can be found in
one go.

CC: Johannes Berg <johannes@sipsolutions.net>
CC: Roopa Prabhu <roopa@cumulusnetworks.com>
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/net/bonding/bond_main.c       |  2 +-
 drivers/net/ethernet/micrel/ksz884x.c |  2 +-
 net/core/rtnetlink.c                  | 12 ++++++------
 net/wireless/nl80211.c                |  2 +-
 net/wireless/util.c                   |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 48d5ec770b94..c3c524f77fcd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1265,7 +1265,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	skb->dev = bond->dev;
 
 	if (BOND_MODE(bond) == BOND_MODE_ALB &&
-	    bond->dev->priv_flags & IFF_BRIDGE_PORT &&
+	    netif_is_bridge_port(bond->dev) &&
 	    skb->pkt_type == PACKET_HOST) {
 
 		if (unlikely(skb_cow_head(skb,
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index d1444ba36e10..4fe6aedca22f 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5694,7 +5694,7 @@ static void dev_set_promiscuous(struct net_device *dev, struct dev_priv *priv,
 		 * from the bridge.
 		 */
 		if ((hw->features & STP_SUPPORT) && !promiscuous &&
-		    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+		    netif_is_bridge_port(dev)) {
 			struct ksz_switch *sw = hw->ksz_switch;
 			int port = priv->port.first_port;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 9b4f8a254a15..6e35742969e6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3911,7 +3911,7 @@ static int rtnl_fdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Support fdb on master device the net/bridge default case */
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
-	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
@@ -4022,7 +4022,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	/* Support fdb on master device the net/bridge default case */
 	if ((!ndm->ndm_flags || ndm->ndm_flags & NTF_MASTER) &&
-	    (dev->priv_flags & IFF_BRIDGE_PORT)) {
+	    netif_is_bridge_port(dev)) {
 		struct net_device *br_dev = netdev_master_upper_dev_get(dev);
 		const struct net_device_ops *ops = br_dev->netdev_ops;
 
@@ -4248,13 +4248,13 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (!br_idx) { /* user did not specify a specific bridge */
-				if (dev->priv_flags & IFF_BRIDGE_PORT) {
+				if (netif_is_bridge_port(dev)) {
 					br_dev = netdev_master_upper_dev_get(dev);
 					cops = br_dev->netdev_ops;
 				}
 			} else {
 				if (dev != br_dev &&
-				    !(dev->priv_flags & IFF_BRIDGE_PORT))
+				    !netif_is_bridge_port(dev))
 					continue;
 
 				if (br_dev != netdev_master_upper_dev_get(dev) &&
@@ -4266,7 +4266,7 @@ static int rtnl_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			if (idx < s_idx)
 				goto cont;
 
-			if (dev->priv_flags & IFF_BRIDGE_PORT) {
+			if (netif_is_bridge_port(dev)) {
 				if (cops && cops->ndo_fdb_dump) {
 					err = cops->ndo_fdb_dump(skb, cb,
 								br_dev, dev,
@@ -4416,7 +4416,7 @@ static int rtnl_fdb_get(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 	if (dev) {
 		if (!ndm_flags || (ndm_flags & NTF_MASTER)) {
-			if (!(dev->priv_flags & IFF_BRIDGE_PORT)) {
+			if (!netif_is_bridge_port(dev)) {
 				NL_SET_ERR_MSG(extack, "Device is not a bridge port");
 				return -EINVAL;
 			}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f0112dabe21e..8c2a246099ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3531,7 +3531,7 @@ static int nl80211_valid_4addr(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype)
 {
 	if (!use_4addr) {
-		if (netdev && (netdev->priv_flags & IFF_BRIDGE_PORT))
+		if (netdev && netif_is_bridge_port(netdev))
 			return -EBUSY;
 		return 0;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8481e9ac33da..80fb47c43bdd 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -934,7 +934,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	/* if it's part of a bridge, reject changing type to station/ibss */
-	if ((dev->priv_flags & IFF_BRIDGE_PORT) &&
+	if (netif_is_bridge_port(dev) &&
 	    (ntype == NL80211_IFTYPE_ADHOC ||
 	     ntype == NL80211_IFTYPE_STATION ||
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
-- 
2.17.1

