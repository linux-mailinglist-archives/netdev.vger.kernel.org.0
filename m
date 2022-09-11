Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA43D5B4B26
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiIKBKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiIKBJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:09:08 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC984DB03;
        Sat, 10 Sep 2022 18:08:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUQo6TTkII9NDA4COBJQLaeWMVagToaDAQoNsYFjRrhRWIbd+omfvo5uyub5WzoWlfYTTN/irpvYri9zVWnLzf7j0h0fA8wQhk4n3uw09lvCjzlQZIaXO0dxxeacJ4utHWwXL/zHzFmAJPOPfu6+JvYp9UouIJ+AkgrUwHpYSHH8DBUhYrX0XG0r3pLwyD48zyJ7GZZdugQG1b4vr/cW5+iqlF4BgcvPqI2DXjAJ6hKvkKKA4e47ejfsn3Yn8OnWrNWBBFU54R3k70xk4TaimAJ0hXYGgm2I1zNjv/6Fd9dASayG5LskymtJIeZFLAkZdA/ROjYcRW8RrS+TkrqGJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sw6Pq9fAuMHXVbCrUOFl6qpdEOonBAGV652RMp/1rUc=;
 b=itY9x0c3JPu7NwbSoPiiRnnOcUeISMdPOMOdk70dwYBFILy3Evv8OGrZeIQDvrFeNP95efLmz4O8+JJWCRMP/xbU9DEy/54gAexY0r7QrVPP0NAuFmd633GCj3v2lmy+m6PuZW7IZiJyTCTz7MooSRZLkW0LPsE0v99bExk6fJ6oV69YwhVUJbh60hULKLxtvRmK7CJNaxqQ5bmYspT0lFn6borzC7jWAQYuuyQ9NNpI+bibZVMhOOvAeNsu3BNowwWeAZUQhDtno5v4u6fG/QqxhpMlujGfZ6FOoch2+R15L0Z6Qr4ApVHkas2ymP633S/mF912M8Qa7bNF3srI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sw6Pq9fAuMHXVbCrUOFl6qpdEOonBAGV652RMp/1rUc=;
 b=NjkOxdQeR4R7Fw0Gn1XFg6p/jjktO539gpw18Zu8ue41ds9vAl8Ucw1B8lKDvE3JGrhYO34RdYiDwwuhT0wt2ihpgRVLx71hChYh3mcBdjKrFMrp5MjKycQzt+I5Weon65LyoSJahx5rjf1CfxUmJbP4n7BeJi4l2I+1aaj/Ru4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:08:06 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:08:06 +0000
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
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 10/10] net: dsa: felix: add support for changing DSA master
Date:   Sun, 11 Sep 2022 04:07:06 +0300
Message-Id: <20220911010706.2137967-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd786f9-63e1-4b23-5852-08da93921594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6D5bodeDO55lrqw9apM6DMp3CpERvooDw0i9gSEG3+LXzXsQtY5Rmtf2gX4FYOdkVwQOrQ7O9HGOpeifNbLy4rNlomIcaG1G19I1uN57kIdR/p54FMdQnhpHv4GCSNSl2VrZN6Dld9U3N21SbT5nJXA2hwoO0UthceymWe5tzmx2v8Sr83+EdAC+s8LdZn+nRHNFeeoxWnu0taMSAl+EBX1ezlDG7zhTQ5CvEuaqtbZAqaRDuVbB2onyBf4Fr5ztQdF9qf0kQhDng6oFK9WF17Nj2QdtGREqeaK2wkgwoBdXNkshg9qVXydSjyccv664do1i1nZBK6qVEtekXT39ACbVvFa/7zau+K+9ZkaqXvaXVrNCTzS7XVIdSJdv1Cj2Q0qmr4cl103gt7Tj3AkL7zghXbZssK2yGXNX4TAMtviSCbWqMMuKl/6Sv874W+gOVO5X18Kt5tCjl7yHVj4z94/TzpMwT7pvnFTUyQbQ9+EU+UPHZq1aeQWKn1YCHtTSnRkTj43L1E0UfJYDKrPevZr2KrfXdkPOqgQcw+vyOXkL+myLqTaH+jHaoE4nnEwHAkQG96j2MQwnZzGlADKqL1PGyoLeL0Iq+ezPK5GfT1DmetYZpXczLRXq+61LcCxDyt1bs2/5vzuf8ELcos+49gF2HXPpBF8KpJu5Rn9x7+A1w9vKXLX34TOpA+i+qezVZVsxEeEJuwoHPAgooUy9HaMdFjLR1HxuQZX/fExEVT+JXML9LQJKAw33AsIcyN2jZI+stRBQryb19F7F5BnSF5Z6TpUs7v9ve7BgSYb9S+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(30864003)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6506007)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GMyfJlvrxqzTiuBiurmIWOO5f/NuePGFC0l9ablap0ezJaBw3gHWCzSTCHyC?=
 =?us-ascii?Q?FiZSQSqKIgt/0iNnxJs/r1Riy/kkxHAFnRL5XU1FyWweSHCw+lEsu83b0QN8?=
 =?us-ascii?Q?9AeZA2uPIW9uB7BT8qRXfQbxb+aJxW2UJDjL+4TsrdnO+S7yMbBKT6uEwzGM?=
 =?us-ascii?Q?edBZ/hgGC6QkRy9guenskDKhpmKtlV97WoCqjyIGI5fZ8pg6+h/OE5neQaOC?=
 =?us-ascii?Q?MMZQvPHC+VUvxn4Op6VCfD1I9YUdPNg3rktPg8bl9ubLGstclnJzyftpp3Lj?=
 =?us-ascii?Q?xGjdXkCMH6SxsppaLf6S+H6VXy6iW+BYm67x/8yvmufVCsoBKcghi2MqtMdj?=
 =?us-ascii?Q?CbcytHaM5vvYII5F3194rymEQa6mpIDKSb3AIT/gnupRxQOFoPEoU1BtP2sq?=
 =?us-ascii?Q?szfZgGas1ArZFtHnXWqG5fq6r+LCObKfeOHYUYDWG9VfuPVnPbOwolFzIpSF?=
 =?us-ascii?Q?hkVuA0w+swkZFfbkoxBgOLKidIhThPT220lxM0EgpbEIewuZlRUTNjqxeq2C?=
 =?us-ascii?Q?FapTfspOI9eNnASYCkzUBeVE2a/Qx3k7YNFTkAkOuV/kngGPvWNplMQlsgG5?=
 =?us-ascii?Q?J6424xsQrGqv3yLP3apVeSMnLSGDLLIk3v1Hwk9OY6VZlewUfS1tsmlOaapX?=
 =?us-ascii?Q?rGAnKZ0dabgbnGWrU7RZ7S9nQNqk/fRBfgUm5v0lPOngeufz/UgVjYniMAJH?=
 =?us-ascii?Q?j7L7mPOFnJBIZZlEQjbVSM2HkR02hOikDjyNasm8N7EZRaJpD+R02I7GBxCT?=
 =?us-ascii?Q?YHAPRr0p4n26ywmWY3hh9V0aIRpfsKHapH0TJTq2/zERLtsjLn9J5JPX6cQA?=
 =?us-ascii?Q?DJp0T0WF6LrSb1tVH0KTivSWScMlOP6ZKzAb6FMIWrU2t6govoOxgKesVdYA?=
 =?us-ascii?Q?LNi2X/q9LFaDoUqaaQOa5MKiRTtRGOAw8QwS6KvMkMAfn3vW9ZYqtgtIACem?=
 =?us-ascii?Q?PsUyFzNreuMHxm2lqdCM7CL8K9KHavXbvF0V/Dv6kEtHFD6r4cppboCSGKVh?=
 =?us-ascii?Q?ne1k9EBddF4X4M04yJ0u5OJy1ryE/zKlI+kaU95EMxGq6fyyxe9My0igjJ6S?=
 =?us-ascii?Q?sH/eTNy8LxJGPuos4CI6vyz3L8rXGKbZ3VZGIZRVzwcv9kRTD7QpNZrHSkZW?=
 =?us-ascii?Q?Y4KhAEWDNQt0gcWp51lKh4m956TP+s3Ic7MVjIx2ZpgUr4aUABPhajIaX5Op?=
 =?us-ascii?Q?l0c/aKJ6hoa3Ek10yUYkibcpAXg7aVwUwu7GSbPZNn/t5AbFIjc2/QKKJJkT?=
 =?us-ascii?Q?1u/+8qxEYEeuDvMBy8dsIx694q7KdoOy0aU54S5WnVg2DQTJbCDT4Sqo2YVv?=
 =?us-ascii?Q?Hvxt5y19+/hUTrBqPfijUAN9VWJA7ZBYMXgwMKXIGwg/qI3IvaG/1l2DA72J?=
 =?us-ascii?Q?1PhUW5inR+p6wz59g0vt2rGCsug5DlLo30OZskXjdbnbigrFP2cNExTZFFjp?=
 =?us-ascii?Q?ZBtJheZGmI7p4j8yhwTIpFl9My3rjpwjpdgj3l+/gXvcEHGG6BLvJKwUd6GQ?=
 =?us-ascii?Q?Fsj6RQjRnJhviTyZeRnM2Rh1TYeIUltyZ9EP5e6RrJLZGEYFGrwlkdVQZyTP?=
 =?us-ascii?Q?T+y5riCcGhMQArRlw/HpFDbZQrfi5flwKR0w+m/0QFMt1NXSrp0tq2iE0dY+?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd786f9-63e1-4b23-5852-08da93921594
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:08:06.4304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VBpGuRNAQXtwqyDq4aapfyxnXCYnd7ZhYKaRHXFIkAWqw4iAEXPvIIKP5YDt+EN267d8tG1nNgbwR3zJ5kYqOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing the DSA master means different things depending on the tagging
protocol in use.

For NPI mode ("ocelot" and "seville"), there is a single port which can
be configured as NPI, but DSA only permits changing the CPU port
affinity of user ports one by one. So changing a user port to a
different NPI port globally changes what the NPI port is, and breaks the
user ports still using the old one.

To address this while still permitting the change of the NPI port,
require that the user ports which are still affine to the old NPI port
are down, and cannot be brought up until they are all affine to the same
NPI port.

The tag_8021q mode ("ocelot-8021q") is more flexible, in that each user
port can be freely assigned to one CPU port or to the other. This works
by filtering host addresses towards both tag_8021q CPU ports, and then
restricting the forwarding from a certain user port only to one of the
two tag_8021q CPU ports.

Additionally, the 2 tag_8021q CPU ports can be placed in a LAG. This
works by enabling forwarding via PGID_SRC from a certain user port
towards the logical port ID containing both tag_8021q CPU ports, but
then restricting forwarding per packet, via the LAG hash codes in
PGID_AGGR, to either one or the other.

When we change the DSA master to a LAG device, DSA guarantees us that
the LAG has at least one lower interface as a physical DSA master.
But DSA masters can come and go as lowers of that LAG, and
ds->ops->port_change_master() will not get called, because the DSA
master is still the same (the LAG). So we need to hook into the
ds->ops->port_lag_{join,leave} calls on the CPU ports and update the
logical port ID of the LAG that user ports are assigned to.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: pass extack to felix_port_change_master() from felix_lag_join()

 drivers/net/dsa/ocelot/felix.c     | 118 ++++++++++++++++++++++++++++-
 drivers/net/dsa/ocelot/felix.h     |   3 +
 drivers/net/ethernet/mscc/ocelot.c |   3 +-
 include/soc/mscc/ocelot.h          |   1 +
 4 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 82dcc21a7172..d2a9d292160c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,6 +42,25 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
+static int felix_cpu_port_for_master(struct dsa_switch *ds,
+				     struct net_device *master)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *cpu_dp;
+	int lag;
+
+	if (netif_is_lag_master(master)) {
+		mutex_lock(&ocelot->fwd_domain_lock);
+		lag = ocelot_bond_get_id(ocelot, master);
+		mutex_unlock(&ocelot->fwd_domain_lock);
+
+		return lag;
+	}
+
+	cpu_dp = master->dsa_ptr;
+	return cpu_dp->index;
+}
+
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -422,6 +441,40 @@ static unsigned long felix_tag_npi_get_host_fwd_mask(struct dsa_switch *ds)
 	return BIT(ocelot->num_phys_ports);
 }
 
+static int felix_tag_npi_change_master(struct dsa_switch *ds, int port,
+				       struct net_device *master,
+				       struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
+	struct ocelot *ocelot = ds->priv;
+
+	if (netif_is_lag_master(master)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "LAG DSA master only supported using ocelot-8021q");
+		return -EOPNOTSUPP;
+	}
+
+	/* Changing the NPI port breaks user ports still assigned to the old
+	 * one, so only allow it while they're down, and don't allow them to
+	 * come back up until they're all changed to the new one.
+	 */
+	dsa_switch_for_each_user_port(other_dp, ds) {
+		struct net_device *slave = other_dp->slave;
+
+		if (other_dp != dp && (slave->flags & IFF_UP) &&
+		    dsa_port_to_master(other_dp) != master) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change while old master still has users");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	felix_npi_port_deinit(ocelot, ocelot->npi);
+	felix_npi_port_init(ocelot, felix_cpu_port_for_master(ds, master));
+
+	return 0;
+}
+
 /* Alternatively to using the NPI functionality, that same hardware MAC
  * connected internally to the enetc or fman DSA master can be configured to
  * use the software-defined tag_8021q frame format. As far as the hardware is
@@ -433,6 +486,7 @@ static const struct felix_tag_proto_ops felix_tag_npi_proto_ops = {
 	.setup			= felix_tag_npi_setup,
 	.teardown		= felix_tag_npi_teardown,
 	.get_host_fwd_mask	= felix_tag_npi_get_host_fwd_mask,
+	.change_master		= felix_tag_npi_change_master,
 };
 
 static int felix_tag_8021q_setup(struct dsa_switch *ds)
@@ -507,10 +561,24 @@ static unsigned long felix_tag_8021q_get_host_fwd_mask(struct dsa_switch *ds)
 	return dsa_cpu_ports(ds);
 }
 
+static int felix_tag_8021q_change_master(struct dsa_switch *ds, int port,
+					 struct net_device *master,
+					 struct netlink_ext_ack *extack)
+{
+	int cpu = felix_cpu_port_for_master(ds, master);
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_unassign_dsa_8021q_cpu(ocelot, port);
+	ocelot_port_assign_dsa_8021q_cpu(ocelot, port, cpu);
+
+	return felix_update_trapping_destinations(ds, true);
+}
+
 static const struct felix_tag_proto_ops felix_tag_8021q_proto_ops = {
 	.setup			= felix_tag_8021q_setup,
 	.teardown		= felix_tag_8021q_teardown,
 	.get_host_fwd_mask	= felix_tag_8021q_get_host_fwd_mask,
+	.change_master		= felix_tag_8021q_change_master,
 };
 
 static void felix_set_host_flood(struct dsa_switch *ds, unsigned long mask,
@@ -673,6 +741,16 @@ static void felix_port_set_host_flood(struct dsa_switch *ds, int port,
 			     !!felix->host_flood_mc_mask, true);
 }
 
+static int felix_port_change_master(struct dsa_switch *ds, int port,
+				    struct net_device *master,
+				    struct netlink_ext_ack *extack)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	return felix->tag_proto_ops->change_master(ds, port, master, extack);
+}
+
 static int felix_set_ageing_time(struct dsa_switch *ds,
 				 unsigned int ageing_time)
 {
@@ -865,8 +943,17 @@ static int felix_lag_join(struct dsa_switch *ds, int port,
 			  struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
+	int err;
 
-	return ocelot_port_lag_join(ocelot, port, lag.dev, info, extack);
+	err = ocelot_port_lag_join(ocelot, port, lag.dev, info, extack);
+	if (err)
+		return err;
+
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, extack);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
@@ -876,7 +963,11 @@ static int felix_lag_leave(struct dsa_switch *ds, int port,
 
 	ocelot_port_lag_leave(ocelot, port, lag.dev);
 
-	return 0;
+	/* Update the logical LAG port that serves as tag_8021q CPU port */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	return felix_port_change_master(ds, port, lag.dev, NULL);
 }
 
 static int felix_lag_change(struct dsa_switch *ds, int port)
@@ -1014,6 +1105,27 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 		felix->info->port_sched_speed_set(ocelot, port, speed);
 }
 
+static int felix_port_enable(struct dsa_switch *ds, int port,
+			     struct phy_device *phydev)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	if (!dsa_port_is_user(dp))
+		return 0;
+
+	if (ocelot->npi >= 0) {
+		struct net_device *master = dsa_port_to_master(dp);
+
+		if (felix_cpu_port_for_master(ds, master) != ocelot->npi) {
+			dev_err(ds->dev, "Multiple masters are not allowed\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
 {
 	int i;
@@ -1913,6 +2025,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
+	.port_enable			= felix_port_enable,
 	.port_fast_age			= felix_port_fast_age,
 	.port_fdb_dump			= felix_fdb_dump,
 	.port_fdb_add			= felix_fdb_add,
@@ -1968,6 +2081,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_add_dscp_prio		= felix_port_add_dscp_prio,
 	.port_del_dscp_prio		= felix_port_del_dscp_prio,
 	.port_set_host_flood		= felix_port_set_host_flood,
+	.port_change_master		= felix_port_change_master,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index deb8dde1fc19..e4fd5eef57a0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -71,6 +71,9 @@ struct felix_tag_proto_ops {
 	int (*setup)(struct dsa_switch *ds);
 	void (*teardown)(struct dsa_switch *ds);
 	unsigned long (*get_host_fwd_mask)(struct dsa_switch *ds);
+	int (*change_master)(struct dsa_switch *ds, int port,
+			     struct net_device *master,
+			     struct netlink_ext_ack *extack);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5c18f8986975..7a613b52787d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1382,7 +1382,7 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 /* The logical port number of a LAG is equal to the lowest numbered physical
  * port ID present in that LAG. It may change if that port ever leaves the LAG.
  */
-static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 {
 	int bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
@@ -1391,6 +1391,7 @@ static int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond)
 
 	return __ffs(bond_mask);
 }
+EXPORT_SYMBOL_GPL(ocelot_bond_get_id);
 
 /* Returns the mask of user ports assigned to this DSA tag_8021q CPU port.
  * Note that when CPU ports are in a LAG, the user ports are assigned to the
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ea19e8ef1f61..967ba30ea636 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1234,6 +1234,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond);
 void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
+int ocelot_bond_get_id(struct ocelot *ocelot, struct net_device *bond);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.34.1

