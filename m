Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB084EAC80
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 13:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiC2LnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 07:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbiC2LnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 07:43:08 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93011201B5;
        Tue, 29 Mar 2022 04:41:25 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22T9Pgxr016715;
        Tue, 29 Mar 2022 11:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=XU8OAUvZ8rg3WHeRN3yogA5QACdGy7vBETwPzMwDTSM=;
 b=FJKM6F1T0Y3CCrQjTY2EtD1e9KLN59FewBU+TfLZhkdWQ0llRs+6EXTl9kJmuiJYqwyw
 VWfvsva5GnttFyyk2UNnuu68pEdItOS1EjRUf+WfZOACdacAT8xNMnTP8UIvBpF917Uo
 qpw4llIxI3kbR4NDOddv/6jbF6h8fFEY7TdKNOcqnKUfsz7laJ298zKUgsWRSS0L2zH6
 69LrvA02rDRwDKdllzcjB8jGThWak6nsUqi1g7e+jE8Xu/mIVoTatpZ+WgAFy9p8l8mw
 Sy50jrzrH98l8qSZ2EOBkfjwUCqcmZyWNRnuEwq+ltbt1rFKuNSH3Gyr0l0kRDRMAoyw UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3yfhtn5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:41:04 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22TBErTl002850;
        Tue, 29 Mar 2022 11:41:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3yfhtn4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:41:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22TBWGFt026102;
        Tue, 29 Mar 2022 11:41:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8x2fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 11:41:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22TBewKN15270190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 11:40:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 229B111C052;
        Tue, 29 Mar 2022 11:40:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FEA311C04C;
        Tue, 29 Mar 2022 11:40:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 29 Mar 2022 11:40:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id C4087E15ED; Tue, 29 Mar 2022 13:40:57 +0200 (CEST)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next v2] veth: Support bonding events
Date:   Tue, 29 Mar 2022 13:40:52 +0200
Message-Id: <20220329114052.237572-1-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7n0S1niuAqIpNpsb1YcU5gw84ANA6Wcv
X-Proofpoint-GUID: ZED8u5b0PmEwSkYMHg8b8UwsN4sKbbsj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_02,2022-03-29_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203290069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding drivers generate specific events during failover that trigger
switch updates.  When a veth device is attached to a bridge with a
bond interface, we want external switches to learn about the veth
devices as well.

Example:

	| veth_a2   |  veth_b2  |  veth_c2 |
	------o-----------o----------o------
	       \	  |	    /
		o	  o	   o
	      veth_a1  veth_b1  veth_c1
	      -------------------------
	      |        bridge         |
	      -------------------------
			bond0
			/  \
		     eth0  eth1

In case of failover from eth0 to eth1, the netdev_notifier needs to be
propagated, so e.g. veth_a2 can re-announce its MAC address to the
external hardware attached to eth1.

Without this patch we have seen cases where recovery after bond failover
took an unacceptable amount of time (depending on timeout settings in the
network).

Due to the symmetric nature of veth special care is required to avoid
endless notification loops. Therefore we only notify from a veth
bridgeport to a peer that is not a bridgeport.

References:
Same handling as for macvlan:
commit 4c9912556867 ("macvlan: Support bonding events")
and vlan:
commit 4aa5dee4d999 ("net: convert resend IGMP to notifier event")

Alternatives:
Propagate notifier events to all ports of a bridge. IIUC, this was
rejected in https://www.spinics.net/lists/netdev/msg717292.html
It also seems difficult to avoid re-bouncing the notifier.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d29fb9759cc9..74b074453197 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1579,6 +1579,57 @@ static void veth_setup(struct net_device *dev)
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 }
 
+static bool netif_is_veth(const struct net_device *dev)
+{
+	return (dev->netdev_ops == &veth_netdev_ops);
+}
+
+static void veth_notify_peer(unsigned long event, const struct net_device *dev)
+{
+	struct net_device *peer;
+	struct veth_priv *priv;
+
+	priv = netdev_priv(dev);
+	peer = rtnl_dereference(priv->peer);
+	/* avoid re-bounce between 2 bridges */
+	if (!netif_is_bridge_port(peer))
+		call_netdevice_notifiers(event, peer);
+}
+
+/* Called under rtnl_lock */
+static int veth_device_event(struct notifier_block *unused,
+			     unsigned long event, void *ptr)
+{
+	struct net_device *dev, *lower;
+	struct list_head *iter;
+
+	dev = netdev_notifier_info_to_dev(ptr);
+
+	switch (event) {
+	case NETDEV_NOTIFY_PEERS:
+	case NETDEV_BONDING_FAILOVER:
+	case NETDEV_RESEND_IGMP:
+		/* propagate to peer of a bridge attached veth */
+		if (netif_is_bridge_master(dev)) {
+			iter = &dev->adj_list.lower;
+			lower = netdev_next_lower_dev_rcu(dev, &iter);
+			while (lower) {
+				if (netif_is_veth(lower))
+					veth_notify_peer(event, lower);
+				lower = netdev_next_lower_dev_rcu(dev, &iter);
+			}
+		}
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block veth_notifier_block __read_mostly = {
+		.notifier_call  = veth_device_event,
+};
+
 /*
  * netlink interface
  */
@@ -1824,12 +1875,14 @@ static struct rtnl_link_ops veth_link_ops = {
 
 static __init int veth_init(void)
 {
+	register_netdevice_notifier(&veth_notifier_block);
 	return rtnl_link_register(&veth_link_ops);
 }
 
 static __exit void veth_exit(void)
 {
 	rtnl_link_unregister(&veth_link_ops);
+	unregister_netdevice_notifier(&veth_notifier_block);
 }
 
 module_init(veth_init);
-- 
2.32.0

