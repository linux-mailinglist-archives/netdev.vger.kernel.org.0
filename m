Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582232FC4E8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbhASXhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:37:54 -0500
Received: from mail-eopbgr80122.outbound.protection.outlook.com ([40.107.8.122]:2143
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732668AbhASOHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 09:07:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsqAMRuHt6Aj/1pdAsxpLCCwObf7cZOOPxsrfpxZBsM=;
 b=DmTqnfVFrg410lWd2+iudKZXyQGMgCDvp3kHkd9guHWLMZooz6eH7uHOF5meghUCtd4Y/0XalSZ1W8PL80NlVglYTPnCvC1wJIh5n3xeLsRLS2J8V759WDIiDF6K++DaZmjAUHP5YaE8QTdKqkGko/PXRfIO0TVvMp+o0Gng1Nw=
Received: from AS8PR04CA0044.eurprd04.prod.outlook.com (2603:10a6:20b:312::19)
 by VI1PR10MB1904.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:35::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Tue, 19 Jan
 2021 14:06:52 +0000
Received: from VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:312:cafe::27) by AS8PR04CA0044.outlook.office365.com
 (2603:10a6:20b:312::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend
 Transport; Tue, 19 Jan 2021 14:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 104.40.229.156)
 smtp.mailfrom=aerq.com; nxp.com; dkim=fail (body hash did not verify)
 header.d=l2task.onmicrosoft.com;nxp.com; dmarc=none action=none
 header.from=aerq.com;
Received-SPF: Fail (protection.outlook.com: domain of aerq.com does not
 designate 104.40.229.156 as permitted sender)
 receiver=protection.outlook.com; client-ip=104.40.229.156;
 helo=eu1.smtp.exclaimer.net;
Received: from eu1.smtp.exclaimer.net (104.40.229.156) by
 VE1EUR03FT038.mail.protection.outlook.com (10.152.19.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3763.12 via Frontend Transport; Tue, 19 Jan 2021 14:06:51 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (104.47.8.52) by
         eu1.smtp.exclaimer.net (104.40.229.156) with Exclaimer Signature Manager
         ESMTP Proxy eu1.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Tue, 19 Jan 2021 14:06:52 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 7622329
X-ExclaimerImprintLatency: 679624
X-ExclaimerImprintAction: 28f8de00ff534d6ea63f9623057776db
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqJpcZ814JHEZfP8Vt1QciDr63PsVGls8VUonarnpiWVPa11+pjFqWnSNY8cfMbM1Wccho7mVPAdeH4N00QxLYbFlN+508AAGAUtB1aDIcZgIKwaovyczpifjxKLv/aV2e44MmRTu5onlBb0iCqV4aC0QSHnNLggkCvvyTTKAhZaKVHL8j/b83BWpFXBaNOeelYJoPptFeWNdVpmH9WWl8tC1qB/+aDyunqCABcXO+7z61au2Ad52OtSocfQcK4rcfcMgUNWXEF4rIyAX6p/pTVnCW/VoogPK44vMYwTJ7OiCzcBftCadJEsiGEUxU4/8lZ0PUT8bRG8Cq2BGbNPaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dZOWCeIF5If0Wf30uCychc5+jjk7IGtMqVLVT47a6M=;
 b=Ps7SIMwJJ+7frRWl36J4b+S7ivYudZ8B4VvzYF+nXtbTBHL23JVdYXjmgSAT+K+rlICQZ+Ar4U+rHmcCn7hziyPZ3rkQcajHe27q22MQ9RDgiBKD6vhJsSNG+bieh/+/p//k6sn6TYxGyeulCzkwcaOfc1i61lGsHpOONRUsvwUcyhCLLwhOrmvAsaWS/ax9a2xTdni0k7eC320kqY2tVUL3crna6IjnfmHWhZ+2It1yPSTqZfiyEypgmpR7EFFRAbCdkG8Ume01ZvmgKVvkg5cbDw7wqinevuRiTzdZTu9NnAqob3ptBXQjs8/IBV+OpFOKWc/uKu8TtFr3og/55g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aerq.com; dmarc=pass action=none header.from=aerq.com;
 dkim=pass header.d=aerq.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=l2task.onmicrosoft.com; s=selector1-l2task-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dZOWCeIF5If0Wf30uCychc5+jjk7IGtMqVLVT47a6M=;
 b=a8ssXEV8u5XHrWkNZ94mwtMqt9iXtlmmw8bRjguEqbspk0eZM5nUIf5Mf0iURqkhSwX2lGYQgXBi7XKFa4sui+vJkIdSQ6WDHnXkfPzbYLsDCIqTRCHab3tUv4uPsSIKzeGrh5HEWTAJ9jeJq5dTBbGfwnnGAn1XvnPgYrNruLU=
Authentication-Results-Original: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=aerq.com;
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:161::27)
 by AM0PR10MB3603.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:156::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 14:06:48 +0000
Received: from AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48]) by AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::2827:6512:610:6d48%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 14:06:48 +0000
From:   Alban Bedel <alban.bedel@aerq.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alban Bedel <alban.bedel@aerq.com>
Subject: [PATCH net v2] net: mscc: ocelot: Fix multicast to the CPU port
Date:   Tue, 19 Jan 2021 15:06:38 +0100
Message-ID: <20210119140638.203374-1-alban.bedel@aerq.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [87.123.195.14]
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:161::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aerq-nb-1030.dotsec.gv (87.123.195.14) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 19 Jan 2021 14:06:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92e566e0-8fe3-4005-9b5f-08d8bc837897
X-MS-TrafficTypeDiagnostic: AM0PR10MB3603:|VI1PR10MB1904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR10MB1904C9761C1DE3D05BC1256996A30@VI1PR10MB1904.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: eS06RBocHrTN+IVCj/hsKGnBvDlSl7U/w3g/RVGWtKvah/ojSpeOc0Tyb6BDCP3yP0WUYO0leto+0gA+v6Sr6yspvFN0RFCWGjsbLx2Gj9V0rGs5BsGmBwa5tvv+F3/aLOYc9duSZaYPCI1EKwbp44VRunF69ctR6xa/TUS8h/wQFl2c+1DZa+w7nrU26/rwjqlEQGUjKXzPG9Ui93pOBgkcsfFcE6wn2deVH8LCEcjxBm3LQ35Gbr07WYlgVpJAJ7LuD1RjmoV1IMnEv1ZmAkE2CBgItgPnasedOUG4Xjs58ujlCX6hUccniv5JgAOBYdn7nNpHoiPU+1P/jTIjI0QgVjs/e3FOJHlkq7KN7DZvBAmaZrZckP4XUMOp9cJL
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3428.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(54906003)(5660300002)(6916009)(6512007)(6486002)(2906002)(83380400001)(52116002)(66476007)(66556008)(6506007)(66946007)(86362001)(498600001)(26005)(8676002)(16526019)(4326008)(1076003)(44832011)(36756003)(107886003)(6666004)(8936002)(2616005)(186003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kg4DuI0uvuYRuVi0hyqchcMwG/Sf6I1x3RYgRvICNYrqNwhvl/w11xCcDFkM?=
 =?us-ascii?Q?MrUOmJuNzuPrMi/fFJR0D9ankDAOK9s8M9HAuoN4mw37c5bOYoxInLkuWBbd?=
 =?us-ascii?Q?HcfiSvamYTKl6arhFfTRSlzsjJ0stl0OkdJ7eBqy9jXJN9T41zfH222PIeqa?=
 =?us-ascii?Q?HUr5eja5ZigitAo2QNZRchS3cV6zgwLeGVfBquBLO971QVtkTIBFEWBO0n2E?=
 =?us-ascii?Q?DnUDeMSImBQ0vXKq8SHYXtXD7K+ee/4bv2ug/1WR3OiMOGh9DL4xFtJCpHpu?=
 =?us-ascii?Q?mdvbvZOBIQNiysyOh1rxRcYH2Mml+aJ3ro3jGiF71ZD8Qv2s7nGYLh7ARmGo?=
 =?us-ascii?Q?sDsPQgELyc4u/1/E3wSNSstG2k39kLdLvm7cM6F9xhDtMgPVxjG/5MRL56GE?=
 =?us-ascii?Q?6W+i+Dx9pead4ow8jzOfGJsrnlKwohygaaHlUGAiJ1clEJ640TjwgAA0CE0r?=
 =?us-ascii?Q?vR7LWBSIjb+ZKEvP+jBtrzZ7TQInpjptwV9VXToUCUWp2CdK7unjOvvHsmgY?=
 =?us-ascii?Q?BY/p67Ww8re2nrI8IYe9WpV8QagK+3idL5koGP9tfzPnKfHahr5Ed/4Z9g8q?=
 =?us-ascii?Q?BP41IWBTTzMaMMVd2LIzkoBM8JDT5IbDwDFk5m1TA7TZ79njWrzH36fPLl+1?=
 =?us-ascii?Q?ELLAw2zm+dFEms1IRTpLvH2J/IV4BbRrJF/AUut22HiXbNjI3utEVcyqcwl7?=
 =?us-ascii?Q?CM/cNd2OXCJy9GUt5htY6Twj9dq66wcGz0CwHY/uVAsGvbe28wFM8cAAThvt?=
 =?us-ascii?Q?bpS2Mg8VlRQkq7E44K2YgMiGBaJxT6cB1TJ+i5wyqMNWd8MiYzYHo0NXqCT8?=
 =?us-ascii?Q?z2cgr4ip9QA+BBtBVf61zTRBP8dg91+4CYPvKpYu2VTgVerpq5k1BW2ifhGk?=
 =?us-ascii?Q?y4N99bJ/paEzUlvH+IX8CafPbtsa+xEpKKPpOQpAeLRAPM/PIuBtE7jYAIJz?=
 =?us-ascii?Q?mx1eQKcDjP/rMc6uUeHLFGgklrM40UFXfNZFFkGS1PV+rPjAtmhMywGG0jXv?=
 =?us-ascii?Q?JnNC?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3603
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 083722c3-1401-484f-3079-08d8bc8375f9
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqrDt61ZL1IC95g56XjDGdmU46a7dmY9csVJlKznUinulGISX5b2jJuFH3wNsnYTItucQ7motINMp+9V5dCy4lxkSNCtxP2+qQ9vHRcGfv31Xjbtk+oM9pKr7XBxOnMuFX9UgbE4whWxsLKfepfx6cs59IXiM+Ua39a7YqH9XZooOkO6GBAC4DTB3WXmOP+LGLebOo7jb/l0tFC2m2Y2Ccv5ieMdDAAgMlVdw6CXKdfyo+psHlNJOCsHn910C4dFSFGhr7ZLRCUxCgGMjudEFwrH/R6h/OjChhbR8WI9pAjwHOq2+yEQBexRamrXkfQZ+Cq5vwl9ZqglQfjRamdM1BENtHEMYBD6DBPo5gH6kIwEUPXKMHkZXzGP0a5vd9RkKf/23A7vyPN9piDdfsJOFFPSLAkWAijnCL7rA9nyffnOuX3zP9EEX81bFeVdPZ0SG8CR4oGqcKzFBua00Jcu5A==
X-Forefront-Antispam-Report: CIP:104.40.229.156;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu1.smtp.exclaimer.net;PTR:eu1.smtp.exclaimer.net;CAT:NONE;SFS:(46966006)(956004)(8676002)(2616005)(8936002)(6486002)(82310400003)(47076005)(6916009)(54906003)(498600001)(7596003)(36756003)(7636003)(5660300002)(336012)(356005)(44832011)(86362001)(107886003)(6512007)(70586007)(16526019)(186003)(70206006)(83380400001)(4326008)(1076003)(6506007)(26005)(6666004)(2906002);DIR:OUT;SFP:1102;
X-OriginatorOrg: aerq.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 14:06:51.8626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e566e0-8fe3-4005-9b5f-08d8bc837897
X-MS-Exchange-CrossTenant-Id: bf24ff3e-ad0a-4c79-a44a-df7092489e22
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bf24ff3e-ad0a-4c79-a44a-df7092489e22;Ip=[104.40.229.156];Helo=[eu1.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1904
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

To fix this problem rework the ocelot_mact_learn() to set the
MAC_CPU_COPY flag when a multicast entry that target the CPU port is
added. For this we have to read back the ports endcoded in the pseudo
MAC address by the caller. It is not a very nice design but that avoid
changing the callers and should make backporting easier.

Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
Fixes: 9403c158b872 ("net: mscc: ocelot: support IPv4, IPv6 and plain Ether=
net mdb entries")

---
Changelog:

v2: - Fix inside ocelot_mact_learn() as suggested by Vladimir Oltean
      to avoid changing the callers and making backport easier.
    - Fixed the Fixes tag to have a 12 digits hash
---
 drivers/net/ethernet/mscc/ocelot.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc=
/ocelot.c
index 0b9992bd6626..ff87a0bc089c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -60,14 +60,27 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      const unsigned char mac[ETH_ALEN],
 		      unsigned int vid, enum macaccess_entry_type type)
 {
+	u32 cmd =3D ANA_TABLES_MACACCESS_VALID |
+		ANA_TABLES_MACACCESS_DEST_IDX(port) |
+		ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
+		ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN);
+	unsigned int mc_ports;
+
+	/* Set MAC_CPU_COPY if the CPU port is used by a multicast entry */
+	if (type =3D=3D ENTRYTYPE_MACv4)
+		mc_ports =3D (mac[1] << 8) | mac[2];
+	else if (type =3D=3D ENTRYTYPE_MACv6)
+		mc_ports =3D (mac[0] << 8) | mac[1];
+	else
+		mc_ports =3D 0;
+
+	if (mc_ports & BIT(ocelot->num_phys_ports))
+		cmd |=3D ANA_TABLES_MACACCESS_MAC_CPU_COPY;
+
 	ocelot_mact_select(ocelot, mac, vid);
=20
 	/* Issue a write command */
-	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
-			     ANA_TABLES_MACACCESS_DEST_IDX(port) |
-			     ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
-			     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN),
-			     ANA_TABLES_MACACCESS);
+	ocelot_write(ocelot, cmd, ANA_TABLES_MACACCESS);
=20
 	return ocelot_mact_wait_for_completion(ocelot);
 }
--=20
2.25.1

