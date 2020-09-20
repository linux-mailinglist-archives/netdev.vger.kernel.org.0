Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37C2711B3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgITBsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:12 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbgITBsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpjZQkZqWweDOnMTbffurB76jNuXiydp4utndNfVhuhLy5BEG0vd1fIGGZiqrw65yFDszBmllXa7wCv6k6qcwEih7PCRknlfiwZXqUix5pNbyM05VdehgJ6vVQd2lQAjyvw3CW5Sew3qZPxNZ/YZV53Y53og/pXThoyCHq8zcJrh9+GeQFCC/KU44FD6quQ9MQEc90114+DAzgiZBBWaN9FVM/Irm9oSDK+IATcRfIOpHT25OaxCkiqweTgcXShHuxU+fobiR7V7Ti/kEmgGxtSfM+6M+tBpmym1qBQTS0PUGNjlQhtghX1mGyDCGRm06lUR5H15/iWIx5PLhqZQjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKqqluG1dQyDb7BPOjNsj51t25NxesKBasFVxYYIehM=;
 b=YlQYtLH8pNcA3Or1Ej5ao0632+3J3Ut9Oz2+9X2lhoZduF+8qMkJvoAYOmx2ry+Aj8QT8JBmAa+/w8PpF5SdMlYzoO4nD6TsDhd1Q5DppjO4Mm2qUW+C+Es2hBkZi/U2Jpj+5hfkuYd/wmiqC7uKutkXWk+EcqoxX1SBx9ldLwVZH5UqmEWum0dn1595KRE84O0+F4WHXMPyH81+KD6SypswGQfUcHiLjOKXley9xpVaqJd0ZpG0+mPkjOfWt3ETewmswkSPEdIrCsFaBBN0JYDjbTPJxa16dm/QP/3hSZGmpb13k3pHxelwLbRf01hRc5MfXOAfkFPXD+p9D0CTHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKqqluG1dQyDb7BPOjNsj51t25NxesKBasFVxYYIehM=;
 b=D5tDLOqOMfs5Lse6hd/wfViCFhRjYLiY7xPwtMZyecNtS3nmdD+DIxejBn9Px4VIs86y+7U48D8QUhaUKslVDupDQa2dBjSplXiguS5evzftZ2qGgfQa2N0Ww9TQ54YRQdSuwk8GCwFVdAZHJvhfIYi4hHkfOu6Sy44P0M0UEmc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:06 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 2/9] net: dsa: rename dsa_slave_upper_vlan_check to something more suggestive
Date:   Sun, 20 Sep 2020 04:47:20 +0300
Message-Id: <20200920014727.2754928-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:05 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 69e3ac83-0576-4126-0645-08d85d073803
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2686EE465B07B3E4D70D2974E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nve/ze+5uayAatlQaHv4hmELrhmWc+kYCsYDDzNgJ4YwAtMRFiXLpriY8rWlxWChp7rK53rXBzg0+TxTlQbJzvT9Oe16Z2f0fnudx+91Mn97RjRr0DmUQL9BnPRoNfUYoJBv0nEzBVK7E+T74ykTm3h37/Ib2NBmL4r8TXSF5QTdVn+0hB5tz2lTc+gvCPahD2IfQSS3W8HVm2T1G1j457i7C6deyzBIhEfqUcJDTwJzHSR6ILl+ujucWusz9pDsXaKKijzdQ4BpH9Wvo6EDoyYKTaqHEAL1c8WhcrlnCMNp4fV7z6/s8n91YXawoQbeBOWZ3QfXQ5hVLd5pCmsaF7hl8HKFY0ndGh9Re+MA4ubD9o+J3kJOPXr+ofu0TjDc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l6rXDrH0tyNwXMgiX+V2Vm5T4iK8pt8Ny2crimCcCPTahmoKdPYlZQIAlvO72tEM8/2eLRxgJKERhxiPz47zwiN0B2IIkkpFjW+98e++FKjg2xopw+YacNcGZCRJkEOcZYhv3LfjfQPz9YtNls2yqZ13B3ZkJ6E7FEulxvZGtBWSzyQvF9m2vh7yr7XDmETfC/EXP0ZgJeX8B6LYGcV2ipdklhO/zqzJ9+9Dk7m90e61Sr7hbw5xj0xdgPsCziw103v7AAPaFDAd1LPSlSLWIXGPI7P9BRUzeh3HeDcCcWVg3uiwlN/ynPhjOkhMxZlzp5YdDgxmINNcCFovxMaXH8xA0ojdoDX/pWA7G02kRwenhfBO2C2+jlrcRR27nRH4VYM/QYCdtAdQVddxROvSlxIwwHQ17C1pxMqFlPBQzPe2rS08QB7Bh8go/YiMuAB7GlMp4Ub3pVu/qTGTDfg9HjSIDDMypE85bW3z4OK7LGqblUFf+GyOhtuGv0EOg/doYYXAVTtAd6CSTxlj2oBcdDMNVQGUUSpmMprDwS2TNvPIrw12YWisp34SkTrzYnvOQU7i7jS7r/TcPHrk/hiYI1LEclDlGboxoh/K/eEVEkynEvpTxJfiYacUK0d/MPnzQ7CyIpWhEnAcdVoOBgva+A==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e3ac83-0576-4126-0645-08d85d073803
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:06.0760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W316Jms5+p1dY4uKNGb87+nBnVRZJYsFY++oM1RXhojMakwSiTsUhoPHJ9+4rNmI+WNl7IwSb60aFB1bo+Khjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll be adding a new check in the PRECHANGEUPPER notifier, where we'll
need to check some VLAN uppers. It is hard to do that when there is
already a function named dsa_slave_upper_vlan_check. So rename this one.

Not to mention that this function probably shouldn't have started with
"dsa_slave_" in the first place, since the struct net_device argument
isn't a DSA slave, but an 8021q upper of one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a00275cda05f..1bcba1c1b7cc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1909,9 +1909,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	return err;
 }
 
-static int dsa_slave_upper_vlan_check(struct net_device *dev,
-				      struct netdev_notifier_changeupper_info *
-				      info)
+static int
+dsa_prevent_bridging_8021q_upper(struct net_device *dev,
+				 struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *ext_ack;
 	struct net_device *slave;
@@ -1949,7 +1949,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
-			return dsa_slave_upper_vlan_check(dev, ptr);
+			return dsa_prevent_bridging_8021q_upper(dev, ptr);
 		break;
 	case NETDEV_CHANGEUPPER:
 		if (!dsa_slave_dev_check(dev))
-- 
2.25.1

