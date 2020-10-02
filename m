Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DECF2811F4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbgJBMDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:03:47 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:10595
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387823AbgJBMDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGDehkHHpZQAJzAlKoJdOQruksF3s79Z1UuYX1lOAgio0BSKYWL6wHxuMXOwXxTmum0KZFezsu2r6mxiit3Mba+NxEGqfIyOFWF86fNa3k8tRF71Y56yPmDU/p0tmrPt4zTzwtwSfzoi4h8a8ZdrpIIdhJv8/fz8jVS/pii5TaXxXzwl63CHFD633+9e7lcjIIO8yEaKGXC1QDR83ssvqrhcb5QWT8zRqvrDoxaIgr/a5WTC96FiPA61+RLVlcrohlRJx9vb77nG8eqrMz5oiy4F9fQ5opFTlmyQi9q6Qll63ftEZue/Md37f6LEWReG73T9l8ghQApuUCcMGE3Qzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93P/Kbzz2xIhmXhMV6aklkWSbWi0lsJj9RsxeUMYQQ8=;
 b=USHZod2YQ/YKoLXKk4JDkauru0L8+vI4f4Gw0S3U+Ebi7HmSVtfz+jHb6FeKhQNihvWMBU8r6DUaPc46pqJEI6F1Kfu66Vd5dKWFWtAMgnXKSv325KaLpi6tebc5V56FndzA3tlrlTsfYYymAj1VVCvI8y98JQ4KFfdzwm4XmTMFTYzqs3iih9BRH9pJ4qYOo0lkI0T6Y0OL9CE3LtgmekNmZXhv0wIYMXNlMbcp/u/YTo/SZHFG2xNKLNPOelA08fS/a2HYEJgqpbUIA+vYQjeXoM1J9UgvVsK/nKonlAGYFh7dmrQwWl8N4l43EsTL4GLrhdbICeKlPHStkOcJ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93P/Kbzz2xIhmXhMV6aklkWSbWi0lsJj9RsxeUMYQQ8=;
 b=q+VCb6WCfsOEJYIRzBHlD7B6Am6dShtEAldu/sOPJp2DbHBj4V3VjkMkpfkIvqXEBjryBOuQATxFoqriw8f93PnpyBvXHNB9s9FoBAnYZBB7fCBSGA4i+RrrGXr4iV6lYTASLt9871/p1Ms2ADCQn5iEa7Divjiu0fRBHysprxg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Fri, 2 Oct
 2020 12:03:10 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 12:03:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 7/9] net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
Date:   Fri,  2 Oct 2020 15:02:26 +0300
Message-Id: <20201002120228.3451337-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.14 via Frontend Transport; Fri, 2 Oct 2020 12:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 320dc9a2-2523-4f38-80f8-08d866cb21a3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB422253D1901948D0ED01738CE0310@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwkELHkCKfHuPCOrsMfkublWhVGwVskeYA4zJSy7ys1Btj6SFigfwxahWu8bK3yHztr6+nUjct86f/Jw+412JCQg9n4Moy0qM0S0DcjTTtn+KxlCASGEJIQGQ1ddZgfCbL/pUcl26uIe+oNRWD3H33h4WCo7TPiBtNIqACYCgtkUHfXn5V2e6GNwJQTRahTuG4J39WwQTHJWGhPK2wjZCmEK7VRHYjnOpamLqL53TT1hDipxldzbA04eNkU3y+Un6u1ZimKnMS0KQMCbYnAY1io17sXnZQxbW7K/xcCwzGvejvh8JePr6uBrosBKNS8bp82RCVSkeEeaeOEJ0zLKhr9Hg9TQJ34uY4hV5wUrZJGqmApCH0Z30QPE4Cxebabgk7X0FZRqFROOJWdSaBhA+FykfTb//3eSxRV1ZXcUEwhJb9gjoMpIdKzIoqIb6u/K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(86362001)(186003)(26005)(2616005)(16526019)(7416002)(52116002)(478600001)(5660300002)(6916009)(2906002)(6506007)(6486002)(66946007)(36756003)(69590400008)(66476007)(66556008)(956004)(6512007)(6666004)(44832011)(4326008)(83380400001)(8676002)(8936002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1MbgGCyIPRaFfiiTXN/BU3OKhp2iO0yNMYhvl25YzjkibYUczKm1uGQIHTE7uZR8i1onViLIN/bnaNQl5cKdaUwmpB8v3OXoABjh0imTZ4pkN5TdqZswWEf2dsj6wDhb85P+2rZ9EYiPpZfH0x756r9OFgl6Vj0nT2OEJfXKSZDk9xKE/H6uACRRM8oaA255pH9lNO4PfUE2S/S9AKP4kXO+dFDqWBFX/1TXqz7O3QhcoDoMQY+twUYKvM1YV/RVcHwOCdCdutPqkY2809Gq48LpaLkQSibYLzQ9pFyLVIqGK1GcIOPPKl01qxGJWz4NAhdSzYfL+3Ta61YswP48GGrqNP0Nkm39oF/eB7OApwfIxgqhQuEcffIOWZRmQMFCi3f3p06tj890jJh39X/NOww0pSHe6M6XFq6lA8EQg1rwA8vxON6lVcYJt0xLmBgOOVwxse+OYMtL+ta94t2KvuJUEwLZCJ9gNJmTDuOG1pXDVmW8+9eaSfQGfvuV8AIIuck5plP0OxYmq0bYjaqLeypNbtDRg4o6ddget1etk0bvHRV3T9BJSE04Ai+w3CShTq2jxjaMWFurV0seOl1PDBg8+lo6pSZDqGloN6aUvtKthsV6dwYS+Ayyc/FGmQ5tI4XuvwVNovfReL2nP5T/oQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320dc9a2-2523-4f38-80f8-08d866cb21a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:03:10.4771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3JLnm8gPbExVqtz1mvai49uXJkdPrmL7FHUxKdK1zsXW40YH6ALGGb1iQF9Nu9QZFV4sksXN9UdWSewUcnT6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue which led to the introduction of this check was that MAC_ETYPE
rules, such as filters on dst_mac and src_mac, would only match non-IP
frames. There is a knob in VCAP_S2_CFG which forces all IP frames to be
treated as non-IP, which is what we're currently doing if the user
requested a dst_mac filter, in order to maintain sanity.

But that knob is actually per IS2 lookup. And the good thing with
exposing the lookups to the user via tc chains is that we're now able to
offload MAC_ETYPE keys to one lookup, and IP keys to the other lookup.
So let's do that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC:
None.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 36 +++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 0656e146129a..d8c778ee6f1b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1013,23 +1013,23 @@ ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
  * on any _other_ keys than MAC_ETYPE ones.
  */
 static void ocelot_match_all_as_mac_etype(struct ocelot *ocelot, int port,
-					  bool on)
+					  int lookup, bool on)
 {
 	u32 val = 0;
 
 	if (on)
-		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(3) |
-		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(3);
+		val = ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(BIT(lookup)) |
+		      ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(BIT(lookup));
 
 	ocelot_rmw_gix(ocelot, val,
-		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS_M |
-		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS_M,
+		       ANA_PORT_VCAP_S2_CFG_S2_SNAP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_ARP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_TCPUDP_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_IP_OTHER_DIS(BIT(lookup)) |
+		       ANA_PORT_VCAP_S2_CFG_S2_OAM_DIS(BIT(lookup)),
 		       ANA_PORT_VCAP_S2_CFG, port);
 }
 
@@ -1080,30 +1080,38 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	unsigned long port;
 	int i;
 
+	/* We only have the S2_IP_TCPUDP_DIS set of knobs for VCAP IS2 */
+	if (filter->block_id != VCAP_IS2)
+		return true;
+
 	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
 			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    tmp->lookup == filter->lookup &&
 			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
 		}
 
 		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
-			ocelot_match_all_as_mac_etype(ocelot, port, true);
+			ocelot_match_all_as_mac_etype(ocelot, port,
+						      filter->lookup, true);
 	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
 			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
+			    tmp->lookup == filter->lookup &&
 			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
 		}
 
 		for_each_set_bit(port, &filter->ingress_port_mask,
 				 ocelot->num_phys_ports)
-			ocelot_match_all_as_mac_etype(ocelot, port, false);
+			ocelot_match_all_as_mac_etype(ocelot, port,
+						      filter->lookup, false);
 	}
 
 	return true;
@@ -1118,7 +1126,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
+				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules, use the other IS2 lookup");
 		return -EBUSY;
 	}
 
-- 
2.25.1

