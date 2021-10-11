Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB364298DF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhJKV2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:51 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:23262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235293AbhJKV2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiL60+o5NtUBxGcAv7FmypezYI4yqbvPirHCy5FUe2MNU3v/DHMtDcq7fJ9jWcx1nh8DW7Ogu926TGP8Rxq0CQ4cprj1q90fypphoT6hkbNjwf4AHBrxMFGZt9o19zVBsUsjPmlpF5SOERA2VoFQSTxXQ1hU2ZiQgLnTeVOsNCOOVTeoz0GV1UU9Hg+bMgHd4Mql3wTM3nVM36+HYftSZY3+rQnYAh+vz7vAmaGixP8ZZlVirEIfD8RG8U6P7WOwS3EG79YuozlMn+tBByNr40JFQj1nr6kmg1NJG0Kq0GoxGb1Ja9N7PiR0+mh9gJ2pVRavsK1oa2+YFpTAeI0HXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMAzweVQRyW7BCEGhARrMkD8CGtGau70zyhFNwRxBwY=;
 b=NAXnD4ufv6RhzFt5sMaF5ma62k3yMNENTAnT2WfsLz5MajUZ849paJAFKyd/okgpAtBs0DZY8Vdz3Ht5a5oM8icgivXKrO2rHGZASZ14nq9TkbAn1wj3XGWQpRmHpb/fqbs3MfmZskKC3u4Colvb5dOMMI/ZJICeF2lkwkdSqEQbdHRx0BNB0mwFtNhpjKGjXFC4XwUVWOJQylByz+ItfPhNYdNntPTigIFGx75p1HwNk1lEyJ/ekh3Q5imAKeDEaL0Y1E2e+E1oa7HfpFs8b1MeE8apyJjeOycyhG5pkd3S+E/DdlkFGshwSLlQ0wHDcvrJUe0KuYqap1SnNZYJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMAzweVQRyW7BCEGhARrMkD8CGtGau70zyhFNwRxBwY=;
 b=mlQUoPw6A2bBDoY+2kMFNcxOot1KYK/yZasOweQ7E2WmMZe3ZDtyyJ2VUIsF4wiTs/+2mdIBcCSTVcbEOAX57TK0A3tiXkCNvcEOS/B1dsrclMVDDM+pq/NrOB+GOCp7bXp4XvCEN7hm6uuYpgHh+hMbir5y5qrgqXiIWiUhA+U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 21:26:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 10/10] net: dsa: felix: break at first CPU port during init and teardown
Date:   Tue, 12 Oct 2021 00:26:16 +0300
Message-Id: <20211011212616.2160588-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eee54867-547e-4a6d-2d3b-08d98cfdd0fc
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910055FCDC87C8190F77C8DE0B59@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhBH9j3ZVGmPMZHKIH3K/FGeQa5znBzS1cuhsl8SKKMaRASO0pOlVw610P9pTF75ZCajyzOqYLThIolkjKc/NGMMfgtilLEZyDR+uE2JO5rFtXVzrroBZjPPJ65DFOv551MwVLzD405WLvCEtFCa573/ZYIuVx9ww/VvSSZweZkivJNFgCwcoP3VVSGKa9PscLJGo/J87F9yWXZrQ5zkONHmTtZeXw6K8+xmcMqRb1+x5SRR2t/beYhPA2Ozohua4EAz432M0whoXnCGUyBdep2Q75fFnKQDHVbXAlcqXk/PPUTUNZNRoEGGg9EQ84xawNR8kkk7wCfv8dFTjhCzinFQTYht0W7aejEgVdIFA0PjYRsH2R7bYAJe0TB/bjATp14/iQDsqDkpx5vkg0XWXeMs2jHFGtOxoZazBN/ruXy03HDs/lnc8jVKw1/eMuyBjYUiFoQAVWM4B+e7GyCWkImYY2H8+mfCm5hxUbjDpDvF6Q0Ek/5Bx8RrQ7rv6Ps+ipqbZ964HF/3B9MnCVcio2JxxIIseUztHmTrpMbLBT7F6Jie9jseoilmK75scP+7hHf3DY92ok4sjBZGijrQOKaLoEkJcCi/6zw9x2XB/rWD//AnpaV0Igv3OonfR13ybSGGHxjqGS/muDlHdLJLJqLKkw9naKyUmShkZS5vE4112hrNgNK8LzJ60cf5TaxulveUkl7D0iaVYpiUP55ytQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(66476007)(44832011)(66556008)(66946007)(54906003)(110136005)(52116002)(26005)(6486002)(5660300002)(508600001)(4326008)(6506007)(956004)(38350700002)(1076003)(6666004)(36756003)(6512007)(86362001)(38100700002)(6636002)(83380400001)(316002)(2616005)(7416002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Vgdcldue1P11MbQY0K0z6LXOXCD3PO6tEpRjUxaT4+dwT/ZihVioE7EGd3z?=
 =?us-ascii?Q?eab1LazSHKCyzu1c/NdK7gjMTyiQZpw0M47DeE1360pu6bfHC8zbnP0oslJp?=
 =?us-ascii?Q?XjvSade6CH8c8lDX54PExhVU99u9aa6u+gYkOBQr8U9WCPv21BzhopFqoR7R?=
 =?us-ascii?Q?i8zLvy6ZfWz8qt42xKnUO4g9Kf2/nllwj0rDjBTzLTVR3hAIZey4IDVTigU6?=
 =?us-ascii?Q?8WY83b10vVfgqwd3rTZXMl3E1tKjfplRoLtVsP9++B9EFARM9oHdYQMc8od6?=
 =?us-ascii?Q?f0tfYSTMUp3x5WPt8A5OZXDcG2gLTgkfs+hgP/me3xr6H+D/U5LhuhSjNiz1?=
 =?us-ascii?Q?kP1UnQl8It4QXZp/6rI0GgkTDBXYVDffc/Ty+zbBqEylZhZ2jDp87EjDj+Cz?=
 =?us-ascii?Q?rSLzMJMfBWBEaEJUf8WIlMmL+xqBaY60/WFLxSG5suNLV9dX9ORdZVhHp0d5?=
 =?us-ascii?Q?xXrZXidTYgdFHpbXPx7SStHh69qcOwIcyWKgTnS6OlSuoZGm6ORheOZrUFyv?=
 =?us-ascii?Q?lPDSCo2d1KZqAQ5UvjugppPKPYR/MD5JCYGXYU1sPHHVWlPFkiYq/QQ6iWRy?=
 =?us-ascii?Q?Wx/n5BbrWVDH0cwe8OQb9riXZ7fPLkXXj96/C/qjXmRrdv8TB+azYauN9Bo/?=
 =?us-ascii?Q?WrkKm7AicifIA8NLuCcBGfShlL1Fl8UVR0c5ZIyajqm3PnOHTuY7J5GlnXQH?=
 =?us-ascii?Q?FdUgXC3E8s7eUAPNrLz41bDsqGXHlwb1QdkOjcl4ea4EYPkXH60aVJaffCzM?=
 =?us-ascii?Q?AmBXELHY25rdrSa+aVUS+P25a4zUMHuxt1aF6MqYpurxNAPUsDNpWgIfw6sY?=
 =?us-ascii?Q?egDAtZOLxoOOogA+LMg8kyhYkD0sb/Y2GeU7iFg3pihaZb+XwCW9tgh60FVV?=
 =?us-ascii?Q?Mb24GMFPJJMNG0zwGEQ2YRjaD/WnDv5i5HgYcmom8jXb/AFg7D9npZonPr0Z?=
 =?us-ascii?Q?9arhCzKHWl6rWQsKzRgP+0EhJH3+UYTf4eYLnuvGR6NFgcjXf/YiE8ZRaAxx?=
 =?us-ascii?Q?yVH2Kc743jXERP9lRjjBNuYHwiWfIny/isIT0p4L5tAdN1sUdiRlHfyKaLHe?=
 =?us-ascii?Q?qABaxlutl1ju6Xys4OgjDEu9mXaQ2dTIQR4sLHD+t0gsKy8OLYXrY59zV/kd?=
 =?us-ascii?Q?TvWLm955r0U7mgp1riBtv1XM2mHwxp6FShofQsMYMHxcMZQcKpNsdZwe9N8A?=
 =?us-ascii?Q?2vmQ0rNpTOUVguDLOdU7hbJd61LUOO2cx/ykMj3kGwUuVdwNt6indtlcE/w1?=
 =?us-ascii?Q?HHSgeXEcTZsqmOt8/9zZ7368UYXVaAescNL1fRcRDL5P+FQdZAE+ZvgZAktt?=
 =?us-ascii?Q?T04kyMVWSRs1KNOGTTgMIMbW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee54867-547e-4a6d-2d3b-08d98cfdd0fc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:41.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWaG73G1wX4/BSkM4gR3J+lPX0qHSrqNqLPoMo2rn6lIkDa4UcDDpeHjeov2L+z2WhZNWx1ESP+mzZhH7WrVXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NXP LS1028A switch has two Ethernet ports towards the CPU, but only
one of them is capable of acting as an NPI port at a time (inject and
extract packets using DSA tags).

However, using the alternative ocelot-8021q tagging protocol, it should
be possible to use both CPU ports symmetrically, but for that we need to
mark both ports in the device tree as DSA masters.

In the process of doing that, it can be seen that traffic to/from the
network stack gets broken, and this is because the Felix driver iterates
through all DSA CPU ports and configures them as NPI ports. But since
there can only be a single NPI port, we effectively end up in a
situation where DSA thinks the default CPU port is the first one, but
the hardware port configured to be an NPI is the last one.

I would like to treat this as a bug, because if the updated device trees
are going to start circulating, it would be really good for existing
kernels to support them, too.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 78b10957c644..276a56206e68 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -266,12 +266,12 @@ static void felix_8021q_cpu_port_deinit(struct ocelot *ocelot, int port)
  */
 static int felix_setup_mmio_filtering(struct felix *felix)
 {
-	unsigned long user_ports = 0, cpu_ports = 0;
+	unsigned long user_ports = dsa_user_ports(felix->ds);
 	struct ocelot_vcap_filter *redirect_rule;
 	struct ocelot_vcap_filter *tagging_rule;
 	struct ocelot *ocelot = &felix->ocelot;
 	struct dsa_switch *ds = felix->ds;
-	int port, ret;
+	int cpu = -1, port, ret;
 
 	tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!tagging_rule)
@@ -284,12 +284,15 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 	}
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		if (dsa_is_user_port(ds, port))
-			user_ports |= BIT(port);
-		if (dsa_is_cpu_port(ds, port))
-			cpu_ports |= BIT(port);
+		if (dsa_is_cpu_port(ds, port)) {
+			cpu = port;
+			break;
+		}
 	}
 
+	if (cpu < 0)
+		return -EINVAL;
+
 	tagging_rule->key_type = OCELOT_VCAP_KEY_ETYPE;
 	*(__be16 *)tagging_rule->key.etype.etype.value = htons(ETH_P_1588);
 	*(__be16 *)tagging_rule->key.etype.etype.mask = htons(0xffff);
@@ -325,7 +328,7 @@ static int felix_setup_mmio_filtering(struct felix *felix)
 		 * the CPU port module
 		 */
 		redirect_rule->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
-		redirect_rule->action.port_mask = cpu_ports;
+		redirect_rule->action.port_mask = BIT(cpu);
 	} else {
 		/* Trap PTP packets only to the CPU port module (which is
 		 * redirected to the NPI port)
@@ -1236,6 +1239,7 @@ static int felix_setup(struct dsa_switch *ds)
 		 * there's no real point in checking for errors.
 		 */
 		felix_set_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	ds->mtu_enforcement_ingress = true;
@@ -1276,6 +1280,7 @@ static void felix_teardown(struct dsa_switch *ds)
 			continue;
 
 		felix_del_tag_protocol(ds, port, felix->tag_proto);
+		break;
 	}
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-- 
2.25.1

