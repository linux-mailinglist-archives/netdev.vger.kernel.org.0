Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E14A2811F3
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387833AbgJBMDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:39 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgJBMDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1i/aMFmxOYzh7QjlgFh7fX1B3McaTcRa3xUXfBdKzz9t0eYhlFZExGzC+J7efLl7TFHdWIo+G+ebB3hD8h0pRF1Iw4XMfSff5a1NXhow/Py1zWOjOF7gSmTqwYKlK1MCOm4HhMrOEw88dMBor+z+DCISeo3edNoVZZxVp6NnMmdPm4toURCm7tFsOwszYjUMCDpR3Pu2P/8Gr8xhIlbKikLZsUS21M9/Ahy30kTpmnXjWzpbDmYC8ey/YB4bWTDJe5hqBsniU4/Sjw0Yh1Cif82jxzZQTMUunZH1Fchg3Cfun8ytvg5NUhmhQLjmvTr2qzGoRhncbGSXB1+n16bNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGYBxGALBk06LU9om6y9cuY/DScr0DvHLcwxhfTb1zg=;
 b=B82SPEkE8w7ENb7JBrgDZD+dxsXAWZ/jGvnekBaVj9+8ZzDbVDaO3aBLjloLupbd392HCS4xte7LTlTNEN6BT6YMHYVYcB37lAcyW9XkIB2lj01KUGVbEKzOuEUcvXMusKBYgxyWzVAYkBonwDS9sLjOb83ctlBd0TQrC8W4YRM8Z7ikGw615KEIZMljOSIF2qcc73FpmBuzOF+NcnvxmaIze9jzd4XBD4kLhlq3EiP6eKw1QVFEQ2D98u2oSFRU/w176HYkKI9+7GVoI/mCyH7JiUYuwdxJPJ9hesDs0iWg6jw8UIWyvA8KJPcV54+NWC7X/xFBf34z1eUf1rl3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGYBxGALBk06LU9om6y9cuY/DScr0DvHLcwxhfTb1zg=;
 b=rhlyetXgZqrhJuGiRgW4hYxVSpSokD7eEw9sVnzHSHJ6uoBzXppy3UYF04rhtlUG9LtDmkAiDO16yrsGUVA8A4wjCV0lZjm26hz2bl+5J1j2+NsAep6Bw5L9x0pvmdIH3GLZZNwr+Bf8rF7qiMiGuLPzO4cnrYDEDIvQVuC1riI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 6/9] net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG
Date:   Fri,  2 Oct 2020 15:02:25 +0300
Message-Id: <20201002120228.3451337-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
References: <20201002120228.3451337-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a0e52f07-0520-46a5-688a-08d866cb208e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222039765FE4D8E162582D1E0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oaR0Guz5wRSWQxdLlOGj88ioQz2FaGteBy3c7g4wPc0qsUBqCs4XA1fOool9Xu1x2bzeekhioHmqvcYQqOb2Qvzq23jYFp8b6Q0H/aiPyhGgYSBdByMJjyfD9SAsmg9DR3veXf+OEKH3rnAT8Jya2nkr3bGUPgbKilSmvuGlb+7mPlTl6DCTyasbgZQ+NLL4sFoj1gIpzP8m10GTCMUBa2VQjEfQ1E++1ARzdgdJlloJ0esuBJBDixh1GCJgfYntB5YfCgU48vcz5MAQK9PgpamawA4piEHN8uslmSpt0humsvcU0VwTbmoeW7LTL9SmX2NlLBOkYqsgoJx1ilvoLFO2wR1UWAirmgQVYIfFauyEj2CTOdgSxGxyPq9jT/e/tNKSpwIaNY7jeHDYA56p7grPYgCxySr0Qz0zahhUib7rRDi2GDwnsHUnYgjiVTqj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: D+NY5YakpJY/duURKqvACmCtAxuc8sehUMUsIEcbQEWCq6JCXP7XRvMqYnb5GxxlhE/6kSB5GTn425rcZmkwSidFyzHav5GtT/FzZopt2oPOMc69eE4m7DLa8Hbue5bmsem2JWZm/h9BVCy3EoK9XAzdcOMesJ0C0M9FGweJa2gof3IgdKJP0IRyO8mkwJAq8aL+LIC6K4OrL1IMzxh6hUeqrTOTI1DuP6M1O87CgceOXB5skIb1Q3JQBmFId8JvtqmrkOpMdI7ajo9vjCUQVVG4MPlF+xEXluLyvsZAjj/dhXV3xyMZDFh6caUb8GRZ0Y65SkX/QrJeK3Dn3U3Jt/Txp1VbmVnxlZiej9sgZL3kdj+5/0vW3auu3uqo3hb7VHUnzur/SyvNM8O//qikHFmrNk1n14AO1FkPjusi2w3rdHG+53uB5OdNBwwyE3Ozp+FoQqvBgSQ8oDIBh2VDZzgmI3vK11rLNvh//0jtmY5kh/NuuL0/s6hG+mwKxx9anxWlnY5aqpPTIdiQJAe1C09N1VSxSxw03FyfadSDbtcHOg2rwHB93cUcdzkqgwKuTTH+qUqoXe1j98VDO+Ci4BjpIINjIzosN5F55HzTQfjLUflAwZTbTAu9tmN4emZao9B4TMGxE7zjUA6sQTGpeA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e52f07-0520-46a5-688a-08d866cb208e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:08.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FToxCkbF8dVTg+XViVVbSEga92nNbFcIWtzA18WFTVWtcGZaHVEIEUKRvsTqNWZM6zViy/8admsUeerhZ0Uxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were installing TCAM rules with the LOOKUP field as unmasked, meaning
that all entries were matching on all lookups. Now that lookups are
exposed as individual chains, let's make the LOOKUP explicit when
offloading TCAM entries.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 10 ++++++----
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  6 +++++-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index feeaf016f8ca..b26a5f8dc62d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -164,6 +164,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 	}
 	if (filter->block_id == VCAP_IS1 || filter->block_id == VCAP_IS2)
 		filter->lookup = ocelot_chain_to_lookup(chain);
+	if (filter->block_id == VCAP_IS2)
+		filter->pag = ocelot_chain_to_pag(chain);
 
 	filter->goto_target = -1;
 	filter->type = OCELOT_VCAP_FILTER_DUMMY;
@@ -205,9 +207,10 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_POLICE:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Police action can only be offloaded to VCAP IS2");
+						   "Police action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
@@ -259,8 +262,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f, bool ingress,
 		case FLOW_ACTION_GOTO:
 			filter->goto_target = a->chain_index;
 
-			if (filter->block_id == VCAP_IS1 &&
-			    ocelot_chain_to_lookup(chain) == 2) {
+			if (filter->block_id == VCAP_IS1 && filter->lookup == 2) {
 				int pag = ocelot_chain_to_pag(filter->goto_target);
 
 				filter->action.pag_override_mask = 0xff;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d0e5c5bbdbf8..0656e146129a 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -367,7 +367,10 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
-	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, 0, 0);
+	vcap_key_set(vcap, &data, VCAP_IS2_HK_PAG, filter->pag, 0xff);
+	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST,
+			 (filter->lookup == 0) ? OCELOT_VCAP_BIT_1 :
+			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
@@ -688,6 +691,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	if (filter->prio != 0)
 		data.tg |= data.tg_value;
 
+	vcap_key_set(vcap, &data, VCAP_IS1_HK_LOOKUP, filter->lookup, 0x3);
 	vcap_key_set(vcap, &data, VCAP_IS1_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
 	vcap_key_bit_set(vcap, &data, VCAP_IS1_HK_L2_MC, filter->dmac_mc);
-- 
2.25.1

