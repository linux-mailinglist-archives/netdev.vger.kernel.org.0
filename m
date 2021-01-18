Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26CC2FA592
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406211AbhARQFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:05:14 -0500
Received: from mail-db8eur05hn2205.outbound.protection.outlook.com ([52.100.20.205]:17792
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406184AbhARQEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 11:04:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5X5IrMgFGXgdPJZ1IoVvituWceozyxw+XBY3jptHyc=;
 b=C4ZxCc0D5fquIqtQ/faTOfgnxHzBhD40YfijPe4uFbywIjWGIyl6ubp8GXI9OtGTdY7BscXg/boCj+okQ8BACdYqAhhM4rBrYKrHT+6HzJf+HUAgmQ9WIG0+wlkQOG+/HPjjdYHm5KWzbMz2u/vHsumY5Q/UjVT86NP1y9ibyhw=
Received: from AM6P192CA0006.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::19)
 by VE1PR10MB2957.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:112::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 16:03:39 +0000
Received: from AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:83:cafe::68) by AM6P192CA0006.outlook.office365.com
 (2603:10a6:209:83::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend
 Transport; Mon, 18 Jan 2021 16:03:39 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 52.169.0.179)
 smtp.mailfrom=aerq.com; nxp.com; dkim=fail (body hash did not verify)
 header.d=l2task.onmicrosoft.com;nxp.com; dmarc=none action=none
 header.from=aerq.com;
Received-SPF: Fail (protection.outlook.com: domain of aerq.com does not
 designate 52.169.0.179 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.169.0.179; helo=eu2.smtp.exclaimer.net;
Received: from eu2.smtp.exclaimer.net (52.169.0.179) by
 AM5EUR03FT027.mail.protection.outlook.com (10.152.16.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 16:03:38 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (104.47.6.50) by
         eu2.smtp.exclaimer.net (52.169.0.179) with Exclaimer Signature Manager
         ESMTP Proxy eu2.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Mon, 18 Jan 2021 16:03:39 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 16117409
X-ExclaimerImprintLatency: 850021
X-ExclaimerImprintAction: 024488c03bc541af91ebd2edd2cd891e
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHHMNl5ObKABIpON7TjUyGjQLd7mAN77peSruJ1eutOB2DhzZdMYHwj37+9TdFrQIIlneWTmeGkuKiAVfpgG4SSvJqAl7zYBDpus+8VK5aULvISASGGZepathRktu19GwIB3CUKd0lPh1Yqb/BnMql6ZIrd4A5OxzDzXUiZCBrnqo94HN/AhhrPYezBo18c2PnKa3bymvP/pYxZnhLhrTzHLFHjIyAlkC2/AyqAsldGaWdboiMlOGlLcFLUJr9uhPVUttaXGzyty2gn6T9JkLD78pobp9nds6z64RZ+1HmLo6rCtkX3Le7K5GKKRPkCYZ3khzofY+In71hwm5YdsyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxW1l3hz7vuz7l3k4mhc4CUG/BqYLeViPR0UwOPlwmQ=;
 b=a4xNYTQ+Jk9Y4R/2moOIxhP6ncU0465adyUQoDLYcAgDs6L4hrKW6l4w9swTwLPR8raH0+U52lgF+tGeKYjdJyORxfIZSki7ZOdctyC3hRE1ZSpkvXkdX2lWos7vnjg14YuY4gy1OiNh437k01SaUE59w5jgs7cR/nD8qaMDnfAFD7mumnI7Fe1+ONDbVlpgOKEc2KmIE9JVZjbM2TuXg7QAiDm7xixHjM9cVcD3jNWtKNfFO9oqWhHcxICsFjWcsCHKnVL0CGs2VvY3dnbLNFKoK4hWcpmbsxfUBoA9YwKrRmVPcIlSn1sNvbR6JC+DSWbr97hFGakio/VTfXcrtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aerq.com; dmarc=pass action=none header.from=aerq.com;
 dkim=pass header.d=aerq.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxW1l3hz7vuz7l3k4mhc4CUG/BqYLeViPR0UwOPlwmQ=;
 b=etqmyCF/SNASeR7C698PWLDmV/sNXzm3SetHrXZSAdvRhhP/O7P89JVGpxSBtEKrpR8w5KGpAdB1jnfiy4IYNcqLN3suRDeDCP2dwXXjYF5Xd9XMZjPJX1+IpDc6pGJQV3tX4JUH+ruDTUbCb5lqOuf3RZD2tuWLatsjiVMQzMY=
Authentication-Results-Original: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=aerq.com;
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:161::27)
 by AM9PR10MB4295.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1cd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 16:03:33 +0000
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48]) by AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 16:03:33 +0000
From:   Alban Bedel <alban.bedel@aerq.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alban Bedel <alban.bedel@aerq.com>
Subject: [PATCH] net: mscc: ocelot: Fix multicast to the CPU port
Date:   Mon, 18 Jan 2021 17:03:17 +0100
Message-ID: <20210118160317.554018-1-alban.bedel@aerq.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [88.130.51.253]
X-ClientProxiedBy: AM0PR04CA0005.eurprd04.prod.outlook.com
 (2603:10a6:208:122::18) To AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:161::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aerq-nb-1030.dotsec.gv (88.130.51.253) by AM0PR04CA0005.eurprd04.prod.outlook.com (2603:10a6:208:122::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 16:03:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6a230c5-d775-4598-fae8-08d8bbca9e9a
X-MS-TrafficTypeDiagnostic: AM9PR10MB4295:|VE1PR10MB2957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR10MB2957A4919A57BA284E3AEF0296A40@VE1PR10MB2957.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: +Ikj5aOu3g+9gswZjBd75livqtdUIzQ8dcXC95/mR+KR6q5WIIkAqFUjm0zN5fPF0rrKoRRAOW5hi/m7u4+98qoA2GkOOlnQT++a3gNQEDQJ2Sl81/393CjCetjw83lv0s2nCTxUbQWXheScz4FzHdPTWGV3n2QY4eJGlnLDO8Q8IxRvd4RqPgA/m79dCM71eoCwsSFtAZMMujfoQDgiYECGQhAW6oOJ5aXMu9hMMYMoWu2Ru8TJNYL6Aewjx8nXSfBIwXWaLHU6m5E3g0qVYuAwhIoYvyg2iQX0n4lF7T6MC6PSn9yxSarBTJst/2j641DkymxbuwHIpkikarAFHQ6ksnhjj7lReGHMVLmcBDbho05uWPrQzsKSJeMGuds34X0YMNdurPANHUH0fED4tA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39830400003)(136003)(6666004)(6512007)(6486002)(4326008)(36756003)(478600001)(44832011)(6506007)(86362001)(8936002)(1076003)(107886003)(2906002)(8676002)(54906003)(26005)(316002)(66476007)(5660300002)(66556008)(186003)(66946007)(52116002)(83380400001)(956004)(16526019)(6916009)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hKCl8k6tRXD/jpSD6x7F8yNX0SQw+l1WfFtXDyAPF/Yyzxws/q8GxvImKj6q?=
 =?us-ascii?Q?silJTiurcSyliHgtrFo3/0Pkdhs2t7rUUspZMepTqYp5eVLYCDqOPqMFtVRX?=
 =?us-ascii?Q?Zh3dPirxa/UnqN3FWXZcO1ARrnakLobCA4bvqvjlVZrMXUItOcO4V9YTf2e4?=
 =?us-ascii?Q?kflBDz15NdRoQLnsbZGtCleNHWUgTcNpoy4HHffJTw5FErZiloxWYcL7/Euu?=
 =?us-ascii?Q?gYZ0S2+eyaz5dL7DUScQCumqtwR4iCoPcVEoP8jzQ2ldVs5REebFjT1yXtpC?=
 =?us-ascii?Q?CEwHztaNIXytafMOvxOprIBhsB0351tk1yqtccpcuJBNfE1fHbIO5oAdGots?=
 =?us-ascii?Q?Ik2g5j0U4rZUf7nTeL7yQip6EKRXHuCYSx1LdWasRI0CNB9TKPT0xDpHHGao?=
 =?us-ascii?Q?MVpL2I+VRDbkBFuwBqhcm+JLtrsVcb8A+Q8Lx2+OzMPl5TVI0GRelhEXDOpn?=
 =?us-ascii?Q?X0qei1G3YKCgg+Ay8d/7K8g+yMHlK5g3bbxozygx/k3qs0JwsXloVCW3m6Jx?=
 =?us-ascii?Q?QF2OuJUElmwVn35kS/5tshPFP3kfXMb9P2zYEBayjJeJ3gAC4A5pan+gb3bD?=
 =?us-ascii?Q?xlC8aaGxFUpYIrVnqDW69u6iaWd4s5SqSbZIPy4+F4DxXtmganrdbO+ogFE7?=
 =?us-ascii?Q?qRh0Z+suaFw9jd4IvuKr2u3lVRrRQk507p/gqRcQFoNCA3IqxI0q3VPpQML3?=
 =?us-ascii?Q?qOWUqAS5Ipv55TEDspsIOtpIAdpR1oCcE6uafOpZ1d0kuj1l+/Xf33Bwn6Q8?=
 =?us-ascii?Q?oSADEM6FAhI4/ZhXWAnXikYpQ6vAhjj+wHQJt2vki9Wj0JHr7rawVLc6I2EL?=
 =?us-ascii?Q?PlIA5K2OakE2592yRJLicO2RBczZYk1b36g1VD8st1E+kJyoBaJe31jZhpa5?=
 =?us-ascii?Q?+djZaM350JRbIhIq9LIqGNBE9CUrHLYU0JOsh7/EUCHrC4FNPxfE6fEUX/rH?=
 =?us-ascii?Q?uL7UP8AYCzuQNiAEjy4NT5Oj8BRecxRQtqV4ek1dkKlpsLgvJVpxnzW299d5?=
 =?us-ascii?Q?Hmd9?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4295
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 40149529-3d51-4c6e-4c70-08d8bbca9ac1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HsNOtpxuGoyFiCcb70jTMi2k6doeCPJURjXU/tNjvCGkYbk3asDYE6EaO6ocZdVCdw+Yi7BrZjI59dLIP8u80T0CqFDqbCPEiynO8MHXykpl7zUuAmCYYBv0cOs/b9cx/EIFGb/img9fBqnxFDL4xlPzrKtHgo+sUMS3agcWMqAgXdynbT3hWzSqElPzGWfAcD3qb/z+zVACERV/gU08aXnEp5cmgOgKQbLFa9PVbruPsdS3AYc3dStX5dd+ItgWcWI+XUtkDDmS2415i0ibMSgsopdRBGbS3fMp9O6W6k8dufekpoRHs4wW4txzPN6lQGSEwOpLp95i1kQgEeb1/PgVxY5gNIBVwJhy6toGyXEX/zI2JfDCBqtAobYZm8Yd2DRBDgg9YGHq3LJu+ngtjn7oiRz6/XWMmAKk9HHp4jxeSuu85XFiflqa9OUN+E+K0dGLkH7D5RQkFniBDNt1FO6AVbfIiuqZsm0gvDIs3+QCt4LZUO5j/0G9pI4YEb+TdYnXKkl9ucSfxjAv2cbqoByj1RodmXeL1hjOUc6Y1q5lMXCAIiN/uGont/4aY40UNWSxI4Wn7X/8ReVOoko1UZj+tgIuLVJAQ6m9uYmpTSU=
X-Forefront-Antispam-Report: CIP:52.169.0.179;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu2.smtp.exclaimer.net;PTR:eu2.smtp.exclaimer.net;CAT:NONE;SFS:(376002)(396003)(346002)(39830400003)(136003)(46966006)(356005)(86362001)(36756003)(8936002)(478600001)(7596003)(54906003)(316002)(7636003)(83380400001)(82310400003)(6486002)(16526019)(6916009)(186003)(44832011)(26005)(8676002)(6512007)(107886003)(1076003)(5660300002)(6666004)(336012)(70586007)(956004)(4326008)(6506007)(2906002)(47076005)(70206006)(34010700045)(2616005);DIR:OUT;SFP:1501;
X-OriginatorOrg: aerq.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 16:03:38.3180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a230c5-d775-4598-fae8-08d8bbca9e9a
X-MS-Exchange-CrossTenant-Id: bf24ff3e-ad0a-4c79-a44a-df7092489e22
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bf24ff3e-ad0a-4c79-a44a-df7092489e22;Ip=[52.169.0.179];Helo=[eu2.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT027.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR10MB2957
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multicast entries in the MAC table use the high bits of the MAC
address to encode the ports that should get the packets. But this port
mask does not work for the CPU port, to receive these packets on the
CPU port the MAC_CPU_COPY flag must be set.

Because of this IPv6 was effectively not working because neighbor
solicitations were never received. This was not apparent before commit
9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb
entries) as the IPv6 entries were broken so all incoming IPv6
multicast was then treated as unknown and flooded on all ports.

To fix this problem add a new `flags` parameter to ocelot_mact_learn()
and set MAC_CPU_COPY when the CPU port is in the port set. We still
leave the CPU port in the bitfield as it doesn't seems to hurt.

Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
Fixes: 9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet m=
db entries)
---
 drivers/net/ethernet/mscc/ocelot.c | 17 ++++++++++++-----
 drivers/net/ethernet/mscc/ocelot.h |  3 ++-
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc=
/ocelot.c
index 0b9992bd6626..c33162dbf075 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -58,12 +58,13 @@ static void ocelot_mact_select(struct ocelot *ocelot,
=20
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      const unsigned char mac[ETH_ALEN],
-		      unsigned int vid, enum macaccess_entry_type type)
+		      unsigned int vid, enum macaccess_entry_type type,
+		      u32 flags)
 {
 	ocelot_mact_select(ocelot, mac, vid);
=20
 	/* Issue a write command */
-	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
+	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID | flags |
 			     ANA_TABLES_MACACCESS_DEST_IDX(port) |
 			     ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
 			     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN),
@@ -574,7 +575,7 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 	if (port =3D=3D ocelot->npi)
 		pgid =3D PGID_CPU;
=20
-	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED, 0);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
=20
@@ -1064,6 +1065,7 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int po=
rt,
 	struct ocelot_multicast *mc;
 	struct ocelot_pgid *pgid;
 	u16 vid =3D mdb->vid;
+	u32 flags =3D 0;
=20
 	if (port =3D=3D ocelot->npi)
 		port =3D ocelot->num_phys_ports;
@@ -1107,9 +1109,11 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int p=
ort,
 	    mc->entry_type !=3D ENTRYTYPE_MACv6)
 		ocelot_write_rix(ocelot, pgid->ports, ANA_PGID_PGID,
 				 pgid->index);
+	if (mc->ports & BIT(ocelot->num_phys_ports))
+		flags |=3D ANA_TABLES_MACACCESS_MAC_CPU_COPY;
=20
 	return ocelot_mact_learn(ocelot, pgid->index, addr, vid,
-				 mc->entry_type);
+				 mc->entry_type, flags);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_add);
=20
@@ -1120,6 +1124,7 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int po=
rt,
 	struct ocelot_multicast *mc;
 	struct ocelot_pgid *pgid;
 	u16 vid =3D mdb->vid;
+	u32 flags =3D 0;
=20
 	if (port =3D=3D ocelot->npi)
 		port =3D ocelot->num_phys_ports;
@@ -1151,9 +1156,11 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int p=
ort,
 	    mc->entry_type !=3D ENTRYTYPE_MACv6)
 		ocelot_write_rix(ocelot, pgid->ports, ANA_PGID_PGID,
 				 pgid->index);
+	if (mc->ports & BIT(ocelot->num_phys_ports))
+		flags |=3D ANA_TABLES_MACACCESS_MAC_CPU_COPY;
=20
 	return ocelot_mact_learn(ocelot, pgid->index, addr, vid,
-				 mc->entry_type);
+				 mc->entry_type, flags);
 }
 EXPORT_SYMBOL(ocelot_port_mdb_del);
=20
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc=
/ocelot.h
index 291d39d49c4e..63045f1ef0cd 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -106,7 +106,8 @@ int ocelot_port_fdb_do_dump(const unsigned char *addr, =
u16 vid,
 			    bool is_static, void *data);
 int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      const unsigned char mac[ETH_ALEN],
-		      unsigned int vid, enum macaccess_entry_type type);
+		      unsigned int vid, enum macaccess_entry_type type,
+		      u32 flags);
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
--=20
2.25.1

