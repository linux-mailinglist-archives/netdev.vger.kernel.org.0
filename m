Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4602E0B1D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgLVNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:47:08 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:35431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbgLVNrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:47:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGepN5T02fze7Qd5HMeTBAEKq92XZ5iXpW6gQ76onHDVta3imw3IBn5YeFLDdDkQvCMXq6b0XGVDv6ZSbHmY1B38A1BRwnBEbKyl6gksog8IJVqYwaECPeuJyl75i22dn+3COWrCxK3/ypRWJWpqJT0nwrMqEDch9XGa4Pc5c4x8nwWxMGhV+Zn7UPMzLSup9eFuX6qlL84pOuMnD0nP+Bw39BKAY7zjIVjFvu8NOX9eEiB6ZTYdtsdsl/7/ijoRSooSCJjsaWVuG4CNYlU04Hd66PMfy+BMRPzlx9eD/n4cWa5dxFitpmupmyc5wPtoTNvZGzDYSC51yFSKU5VQbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeC2ykBWXlKOnx21mjQxTrlKstDkJD5SZopTilkp5DY=;
 b=hjzfZmVQJhcHzzLRmdOR8ywGQkSwWuXiIIayI8kVpBm+Gu4SL6z7cgd1BtvdfxgrLQJXFI4W3OM79IRx2VYKCVlZAdtSygeoNzw8z5M+urfCVk8uN4CUwAylT2vVccrxUIq0CPL8OcD+GrNS2jABmWytMWqEfRqxE6MpZOuxHImg417XqWLBI3ymdLbvIusJRePZIII2EsZ5KJsD26pjAOHwBTBEiwk/j8aD7l5XwjKeK3sB9urzFyiCbzTl2LW2dqvZSgl7W50W89jxywf4z+LVvlgQuTRSy2nGMU1nQDm3DLw/134+NWv3DDK2dUgDLQ5WflKZrfHfzebTdVbdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeC2ykBWXlKOnx21mjQxTrlKstDkJD5SZopTilkp5DY=;
 b=D5OIs5WmjqNny/KtyTis2i0zRnNuL/qHXPVe7L28baH/8ory7TCjuu5I9xwvPr3LGxUdRM/1ZJziQpmN4DB54b2shJDNVXcpo6YT7fyhD0wAbmruo9xBMZv+9jECpn3YPJubpPB20xIhHr8Sx1lu4AWS0Qbfzvh5wkgzqhwD4Ug=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 12/15] net: mscc: ocelot: refactor ocelot_xtr_irq_handler into ocelot_xtr_poll
Date:   Tue, 22 Dec 2020 15:44:36 +0200
Message-Id: <20201222134439.2478449-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6a976bff-fda2-4be1-763b-08d8a67fc95e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB740852CE668FECC6C51E7E25E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rocq6cp8xY7M9VwoTsSUcz1dW55acv2UTcvKUOHKg7wBWmQvC1t2SCWLSfk+2F69Oy8uXd/IFrSesiIKVPrr504zct5ZdMiyY/ZMnW6D/q9nijHrK/uOSFaWZeCmN/KMQI77u8eqRuZ4YpyvquBQYGcfbjpdXWqAZtNvkpXPk7qRaWIi8aZHiv9DjbuDHWARBBV/sChD/ZwtpStCaiRh4nfdjRdH9HQuQFi2x2hP4AoRz5w0Kx8Krav7borIxFWBqRx+d+DZDIUFnU+mLcR5EFJ3VxUk+hlEPE+ZMExHgo0HqoisBmrG762W0o8+dZWEyALSrLNQWlyAicsrhtn9kna9NJv73i4Nusu6eLZoUrkowo1jta43+Yor2DDg5UWistftsrJAB9VPx8YszNlSuXL7otLrZsPhDLFn+P5Z8zlathnJNGEV3yp8EHBWlL5rh17DCNpn0i9O3ks7FILPSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(30864003)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?85iRc3cZmtzoXBldaZC6gaW6jUrjIKJoOcDuvZhhyHBz+yRCgikIR1hI76CX?=
 =?us-ascii?Q?+fKNKsKQHoRCsm5E/9zusSvKxorHmcMCxs7u054t52wniyUNXBzYjh0GWJ9L?=
 =?us-ascii?Q?KuF3mwZwule02nli3a4SMXAyjhrzrs2BFDp78hoSw6fBvabVL7Zd3iBj20lI?=
 =?us-ascii?Q?BHqQNmuEvXIQ3VWXB0uecxJlvRJvK+sO4VSGHZtcDtqr0wkduqssQDHPDH3I?=
 =?us-ascii?Q?pYoYvvBw954cDIjGiKgOppvRMDST4WuHm3NDWH+6yVmXZT0n9i7WcPcCfiO0?=
 =?us-ascii?Q?82duR3CPLG+gT3OXig/jIy2F18UlzayWS1RdiLq7OcsrwUs+ZPpo5az6CEPw?=
 =?us-ascii?Q?hk43Zxik5aQE3t6G0qqfol/Pd1VkUPrC1iV5r5djmo2a9NwJxVNaPgBAWJIy?=
 =?us-ascii?Q?EUBWjC0g5uhd0qHKLVHmaZCgniGWlhufRByGQukErBKuhMwWaY8R7JhP+vcu?=
 =?us-ascii?Q?y6IxZl9hL9eX4ZBw994EeNyqOty1e8fiXvIDqx9t5KigxYiU126txnfrejTZ?=
 =?us-ascii?Q?LUPcBIZOnnYGG83Hbi2JbRzAAz+c9KWUvpI1mhvXXc2GUNxpQjjtTXM7aph7?=
 =?us-ascii?Q?RXHxU6AeW8ieo6eUhaSrf8jzPdvxOdVJEeuGsyOmJ3h4BEQtISo/6EoErVV/?=
 =?us-ascii?Q?XTSrrtRf8VEjf+Gyk/iVxJ6by3QIklfiyHgcq/yulrjUYbWwYZQ7iX+iXWbX?=
 =?us-ascii?Q?9AQvAlIoYZZx0ZLOKhkMMNnDfEiZe7YSh25o/XPm4kSOIn0vdBYWGoA0VMf9?=
 =?us-ascii?Q?pvHwMRay/Na/CQUbr45SX3/8Q69bELWB/OL+Zx6Rl7a8+ZQB1pMficPY6AMO?=
 =?us-ascii?Q?dTC1qkmuPJ/hF/qr9Y+cZJna5YwSs4p7KMivTMiMWes83sywF2cBpS1nvkMP?=
 =?us-ascii?Q?KY3EqYC6iCLIgfAoSof6Q2Jh2UBclH7Arb5zBnlQ3w+WUvd1+2LfKmRz+Xh5?=
 =?us-ascii?Q?UrhHSKqGZDGAZ1MkX9ddeF/dWVWZHY7kJcMZK/jXsw6KmPulg2tTPnniSbpy?=
 =?us-ascii?Q?rYuf?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:04.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a976bff-fda2-4be1-763b-08d8a67fc95e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KesDlmOoK5hSDJnUnt0RS7x6DEm5JbGg6NUOBschJyYax103i5ATM9zDcmzUoMM10ZgYXdHCYW4RXMJuBJiH7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the felix DSA driver will need to poll the CPU port module for
extracted frames as well, let's create some common functions that read
an Extraction Frame Header, and then an skb, from a CPU extraction
group.

This is so complicated, because the procedure to retrieve a struct
net_device pointer based on the source port is different for DSA and
switchdev. So this is the reason why the polling function is split in
the middle. The ocelot_xtr_poll_xfh() permits the caller to get a struct
net_device pointer based on the XFH port field, then pass this to the
ocelot_xtr_poll_frame() function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c         | 163 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h         |   6 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 158 ++------------------
 3 files changed, 179 insertions(+), 148 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7d73c3251dfb..b91d4c31d3d7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -12,6 +12,9 @@
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
 
+#define IFH_EXTRACT_BITFIELD64(x, o, w) \
+	(((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
+
 struct ocelot_mact_entry {
 	u8 mac[ETH_ALEN];
 	u16 vid;
@@ -566,6 +569,166 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
+static int ocelot_parse_xfh(u32 *_ifh, struct ocelot_frame_info *info)
+{
+	u8 llen, wlen;
+	u64 ifh[2];
+
+	ifh[0] = be64_to_cpu(((__force __be64 *)_ifh)[0]);
+	ifh[1] = be64_to_cpu(((__force __be64 *)_ifh)[1]);
+
+	wlen = IFH_EXTRACT_BITFIELD64(ifh[0], 7,  8);
+	llen = IFH_EXTRACT_BITFIELD64(ifh[0], 15,  6);
+
+	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
+
+	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
+
+	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
+
+	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
+	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
+
+	return 0;
+}
+
+static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
+				u32 *rval)
+{
+	u32 val;
+	u32 bytes_valid;
+
+	val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+	if (val == XTR_NOT_READY) {
+		if (ifh)
+			return -EIO;
+
+		do {
+			val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		} while (val == XTR_NOT_READY);
+	}
+
+	switch (val) {
+	case XTR_ABORT:
+		return -EIO;
+	case XTR_EOF_0:
+	case XTR_EOF_1:
+	case XTR_EOF_2:
+	case XTR_EOF_3:
+	case XTR_PRUNED:
+		bytes_valid = XTR_VALID_BYTES(val);
+		val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		if (val == XTR_ESCAPE)
+			*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+		else
+			*rval = val;
+
+		return bytes_valid;
+	case XTR_ESCAPE:
+		*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+
+		return 4;
+	default:
+		*rval = val;
+
+		return 4;
+	}
+}
+
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info)
+{
+	u32 ifh[OCELOT_TAG_LEN / 4];
+	int i, err = 0;
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
+		err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
+		if (err != 4)
+			return (err < 0) ? err : -EIO;
+	}
+
+	ocelot_parse_xfh(ifh, info);
+
+	return 0;
+}
+
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **nskb)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	u64 tod_in_ns, full_ts_in_ns;
+	struct timespec64 ts;
+	int sz, len, buf_len;
+	struct sk_buff *skb;
+	u32 val, *buf;
+	int err = 0;
+
+	skb = netdev_alloc_skb(dev, info->len);
+	if (unlikely(!skb)) {
+		netdev_err(dev, "Unable to allocate sk_buff\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	buf_len = info->len - ETH_FCS_LEN;
+	buf = (u32 *)skb_put(skb, buf_len);
+
+	len = 0;
+	do {
+		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+		if (sz < 0) {
+			err = sz;
+			goto out;
+		}
+		*buf++ = val;
+		len += sz;
+	} while (len < buf_len);
+
+	/* Read the FCS */
+	sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+	if (sz < 0) {
+		err = sz;
+		goto out;
+	}
+
+	/* Update the statistics if part of the FCS was read before */
+	len -= ETH_FCS_LEN - sz;
+
+	if (unlikely(dev->features & NETIF_F_RXFCS)) {
+		buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
+		*buf = val;
+	}
+
+	if (ocelot->ptp) {
+		ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+
+		tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
+		if ((tod_in_ns & 0xffffffff) < info->timestamp)
+			full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
+					info->timestamp;
+		else
+			full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
+					info->timestamp;
+
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
+		shhwtstamps->hwtstamp = full_ts_in_ns;
+	}
+
+	/* Everything we see on an interface that is in the HW bridge
+	 * has already been forwarded.
+	 */
+	if (ocelot->bridge_mask & BIT(info->port))
+		skb->offload_fwd_mark = 1;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	*nskb = skb;
+out:
+	return err;
+}
+
 /* Generate the IFH for frame injection
  *
  * The IFH is a 128bit-value
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 7dac0edd7767..68b089d1d81b 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -120,6 +120,12 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 bool ocelot_can_inject(struct ocelot *ocelot, int grp);
 void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
 			      u32 rew_op, struct sk_buff *skb);
+int ocelot_xtr_poll_xfh(struct ocelot *ocelot, int grp,
+			struct ocelot_frame_info *info);
+int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
+			  struct net_device *dev,
+			  struct ocelot_frame_info *info,
+			  struct sk_buff **skb);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 504881d531e5..a1d7698be78b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -18,8 +18,6 @@
 #include <soc/mscc/ocelot_hsio.h>
 #include "ocelot.h"
 
-#define IFH_EXTRACT_BITFIELD64(x, o, w) (((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
-
 static const u32 ocelot_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
@@ -533,173 +531,37 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	return 0;
 }
 
-static int ocelot_parse_ifh(u32 *_ifh, struct ocelot_frame_info *info)
-{
-	u8 llen, wlen;
-	u64 ifh[2];
-
-	ifh[0] = be64_to_cpu(((__force __be64 *)_ifh)[0]);
-	ifh[1] = be64_to_cpu(((__force __be64 *)_ifh)[1]);
-
-	wlen = IFH_EXTRACT_BITFIELD64(ifh[0], 7,  8);
-	llen = IFH_EXTRACT_BITFIELD64(ifh[0], 15,  6);
-
-	info->len = OCELOT_BUFFER_CELL_SZ * wlen + llen - 80;
-
-	info->timestamp = IFH_EXTRACT_BITFIELD64(ifh[0], 21, 32);
-
-	info->port = IFH_EXTRACT_BITFIELD64(ifh[1], 43, 4);
-
-	info->tag_type = IFH_EXTRACT_BITFIELD64(ifh[1], 16,  1);
-	info->vid = IFH_EXTRACT_BITFIELD64(ifh[1], 0,  12);
-
-	return 0;
-}
-
-static int ocelot_rx_frame_word(struct ocelot *ocelot, u8 grp, bool ifh,
-				u32 *rval)
-{
-	u32 val;
-	u32 bytes_valid;
-
-	val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-	if (val == XTR_NOT_READY) {
-		if (ifh)
-			return -EIO;
-
-		do {
-			val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		} while (val == XTR_NOT_READY);
-	}
-
-	switch (val) {
-	case XTR_ABORT:
-		return -EIO;
-	case XTR_EOF_0:
-	case XTR_EOF_1:
-	case XTR_EOF_2:
-	case XTR_EOF_3:
-	case XTR_PRUNED:
-		bytes_valid = XTR_VALID_BYTES(val);
-		val = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		if (val == XTR_ESCAPE)
-			*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-		else
-			*rval = val;
-
-		return bytes_valid;
-	case XTR_ESCAPE:
-		*rval = ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-
-		return 4;
-	default:
-		*rval = val;
-
-		return 4;
-	}
-}
-
 static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 {
 	struct ocelot *ocelot = arg;
-	int i = 0, grp = 0;
-	int err = 0;
+	int grp = 0, err;
 
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
-		struct skb_shared_hwtstamps *shhwtstamps;
 		struct ocelot_frame_info info = {};
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
-		u64 tod_in_ns, full_ts_in_ns;
 		struct net_device *dev;
-		u32 ifh[4], val, *buf;
-		struct timespec64 ts;
-		int sz, len, buf_len;
 		struct sk_buff *skb;
 
-		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
-			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
-			if (err != 4)
-				goto out;
-		}
-
-		/* At this point the IFH was read correctly, so it is safe to
-		 * presume that there is no error. The err needs to be reset
-		 * otherwise a frame could come in CPU queue between the while
-		 * condition and the check for error later on. And in that case
-		 * the new frame is just removed and not processed.
-		 */
-		err = 0;
+		err = ocelot_xtr_poll_xfh(ocelot, grp, &info);
+		if (err)
+			break;
 
-		ocelot_parse_ifh(ifh, &info);
+		if (WARN_ON(info.port >= ocelot->num_phys_ports))
+			goto out;
 
 		ocelot_port = ocelot->ports[info.port];
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 		dev = priv->dev;
 
-		skb = netdev_alloc_skb(dev, info.len);
-
-		if (unlikely(!skb)) {
-			netdev_err(dev, "Unable to allocate sk_buff\n");
-			err = -ENOMEM;
-			goto out;
-		}
-		buf_len = info.len - ETH_FCS_LEN;
-		buf = (u32 *)skb_put(skb, buf_len);
-
-		len = 0;
-		do {
-			sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
-			if (sz < 0) {
-				err = sz;
-				goto out;
-			}
-			*buf++ = val;
-			len += sz;
-		} while (len < buf_len);
-
-		/* Read the FCS */
-		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
-		if (sz < 0) {
-			err = sz;
-			goto out;
-		}
-
-		/* Update the statistics if part of the FCS was read before */
-		len -= ETH_FCS_LEN - sz;
-
-		if (unlikely(dev->features & NETIF_F_RXFCS)) {
-			buf = (u32 *)skb_put(skb, ETH_FCS_LEN);
-			*buf = val;
-		}
-
-		if (ocelot->ptp) {
-			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
-
-			tod_in_ns = ktime_set(ts.tv_sec, ts.tv_nsec);
-			if ((tod_in_ns & 0xffffffff) < info.timestamp)
-				full_ts_in_ns = (((tod_in_ns >> 32) - 1) << 32) |
-						info.timestamp;
-			else
-				full_ts_in_ns = (tod_in_ns & GENMASK_ULL(63, 32)) |
-						info.timestamp;
-
-			shhwtstamps = skb_hwtstamps(skb);
-			memset(shhwtstamps, 0, sizeof(struct skb_shared_hwtstamps));
-			shhwtstamps->hwtstamp = full_ts_in_ns;
-		}
-
-		/* Everything we see on an interface that is in the HW bridge
-		 * has already been forwarded.
-		 */
-		if (ocelot->bridge_mask & BIT(info.port))
-			skb->offload_fwd_mark = 1;
+		err = ocelot_xtr_poll_frame(ocelot, grp, dev, &info, &skb);
+		if (err)
+			break;
 
-		skb->protocol = eth_type_trans(skb, dev);
 		if (!skb_defer_rx_timestamp(skb))
 			netif_rx(skb);
-		dev->stats.rx_bytes += len;
+		dev->stats.rx_bytes += info.len;
 		dev->stats.rx_packets++;
 	}
 
-- 
2.25.1

