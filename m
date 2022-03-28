Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A314E8FDE
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 10:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiC1IQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 04:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239196AbiC1IQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 04:16:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206F013D28;
        Mon, 28 Mar 2022 01:14:48 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S7BEZA029994;
        Mon, 28 Mar 2022 08:14:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Tvax1EpreYhpSfGqFLZ2dyca4slyRY3u7iC0J43xZ18=;
 b=QQDEE2DFuyt7Dc4tZ78i2j/CX7au4PNpsk0ustjSrEZKHD2jZ7gJkjFvBxTqGcmHVbuq
 D9eDT3yxf5veIJ2X4+XQgPP2e0t4HuTCjLSiHj8S60t67dAojCNsVEpnX7IvdwchklYS
 yJkaQKbKnZgqtE97MDoZVJw2Crjoz33erMS9qAUGm/QpGE9ytisPbUH122cPB0GU4KAX
 n2sj6sZPazMIqtRZ07PT5mR8P6WRKu9I+GNv0iNo9P/ose2MKn86IIlVjUPImAfY6SEO
 aybN/tyrD0DmIU/Ezaj32FYuIm4xDOycFJUT4ZX3VaClwVPDNa45D807yb0xsPNcdB60 Mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8j4wvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:31 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S8B9ap029891;
        Mon, 28 Mar 2022 08:14:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8j4wvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S8DV3h021725;
        Mon, 28 Mar 2022 08:14:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8uf5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:14:28 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S82VUf30802332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 08:02:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85CBAAE04D;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 730D4AE051;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Mar 2022 08:14:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 315EEE1BD2; Mon, 28 Mar 2022 10:14:25 +0200 (CEST)
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
Subject: [PATCH net-next 1/1] veth: Support bonding events
Date:   Mon, 28 Mar 2022 10:14:17 +0200
Message-Id: <20220328081417.1427666-2-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220328081417.1427666-1-wintera@linux.ibm.com>
References: <20220328081417.1427666-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D-ZF31Sj1Vsc8mD97dlpkO5ZYUFUrJEO
X-Proofpoint-GUID: 4Dpg5lSqhK-lkYs8H_4jUIHwrKI_0UZ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
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

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d29fb9759cc9..9019c9852daf 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1579,6 +1579,57 @@ static void veth_setup(struct net_device *dev)
 	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
 }
 
+static bool _is_veth(const struct net_device *dev)
+{
+	return (dev->netdev_ops->ndo_open == veth_open);
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
+				if (_is_veth(lower))
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

