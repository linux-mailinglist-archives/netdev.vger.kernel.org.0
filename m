Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFFD564D64
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 07:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiGDFoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 01:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiGDFnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 01:43:42 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC86AE60
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 22:42:09 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0D89A320029B;
        Mon,  4 Jul 2022 01:42:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 04 Jul 2022 01:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=traverse.com.au;
         h=cc:cc:content-transfer-encoding:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1656913328; x=
        1656999728; bh=ovGRdRS6bvA6dLT9h/FiuCHL8xuc6tgJs93lGf1fPjA=; b=V
        GUkrK5ZJmo3iRfmkeNBScZNdrbaxK99owH+kCREzy0DUYTI+u6LtrlPcLQYgeXFm
        +FTBrFQ4HYhA966hdDQDZXheCxbMoaCCI0ZySyfHEGlu4sBkgh/hX8wVgkXqeurz
        bTpsMFSf3fPvDzerGZqeNnKfMrBcAO9ANrxGNzFssMsTPmbV3FekwMJtlm9amE9Z
        Pu53/0ROmUi9NHF26I1KZnBjBSoBwpnxiEtehokLBEbabWGV65rxUlDMQZJR5V+H
        G5lN4ZhNo25yWhiwekDQOIuxDVcxOJn0C65uSZKWrAs5f9q7AI3Odt2KBhXoozI+
        zuahaBQpHhO3U6Y7usWkw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1656913328; x=1656999728; bh=ovGRdRS6bvA6d
        LT9h/FiuCHL8xuc6tgJs93lGf1fPjA=; b=GLNgV4VFtHzX5/lHaW+ftWfv+gdb7
        ckj9I6R425P27as2a0VzG/kFFzSFx0//GApLNHFq7rrX9y28bhS8yfc1R0mcMdOe
        k//wH+2h551+x2+4nZTcsBjQwNbKHFyLOMV6XOxjeyxgZ72EL/GG36cUm4zrYG8S
        HF+6dZb0vSKtRO+LPsyKpFAIGMQe+Z5BS/0Atk9Xbt5gbwCAyyLezfFsxSLS7DlK
        z01wd6bCRkNydG+iOrlgkM2sXduvBC5P7goCl20m7TuQl5nQwNy9+MYqrW/WxxY/
        q88SkxyXEhhtlvophelIz223nMt+sYwgJ5iZPuGfgpu9WAhSh2nOK6dmw==
X-ME-Sender: <xms:sH3CYp7uL7VccwxwsuwJT4RxEWr5a5rzRZpUH1BADxIaz1BHPwtlAw>
    <xme:sH3CYm6paHtDrLSxzgX-pXMw4b9bkvhnsFl-eljtKS2z3c_5LkuS03mkgUOTAbCrJ
    Ard9D3gHNDtRLr_dqY>
X-ME-Received: <xmr:sH3CYgdQkSA0oNCyFUu8Mt8DXVaj-G5iR3bGhHKeuxmr5O-C2zUzvavse5-GCOIaKXvfcul2OIjzi_mYjvBdiTisu7rgLdoTy2RwfOMQQo6qWxZ2zbUfIHCIKDPrp4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehkedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepofgrthhh
    vgifucfotgeurhhiuggvuceomhgrthhtsehtrhgrvhgvrhhsvgdrtghomhdrrghuqeenuc
    ggtffrrghtthgvrhhnpeeiieefheeiieeuledufefgtdevfeejffetgedvveduffffleeh
    jedtjeegleelgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehmrghtthesthhrrghvvghrshgvrdgtohhmrdgruh
X-ME-Proxy: <xmx:sH3CYiLJHImPpsUd4H5usynnIMIuKS5gCeO7QvaCOOAmjBySyq_ZPQ>
    <xmx:sH3CYtLzkWG96PgTLlN8CrMjl5VuUBe2T-sWpFwo3zCHcFrLRo27uw>
    <xmx:sH3CYrwYsg4yWQfcdkPh_xUrPIg_HAL76A2b9nFxoVepKth3eYKm1g>
    <xmx:sH3CYrgW49hqogOEhoA5yQSy5urYOEN19XdBTqEcEITe8tbyAjRojQ>
Feedback-ID: i426947f3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 01:42:06 -0400 (EDT)
From:   Mathew McBride <matt@traverse.com.au>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Mathew McBride <matt@traverse.com.au>
Subject: [PATCH ethtool 1/2] ethtool: add JSON output to --module-info
Date:   Mon,  4 Jul 2022 05:41:13 +0000
Message-Id: <20220704054114.22582-2-matt@traverse.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220704054114.22582-1-matt@traverse.com.au>
References: <20220704054114.22582-1-matt@traverse.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides JSON output support for 'ethtool -m' / --module-info

To make presenting the module data as simple as possible,
both the raw bytes/codes and formatted descriptions are provided
where available.

A sample output (edited and formatted for brevity) is shown below:
$ ethtool --json -m eth8
[
	{
		"identifier": 3,
		"identifier_description": "SFP",
		"vendor_name": "UBNT",
		"vendor_oui": "00:00:00",
		"vendor_pn": "UF-MM-10G",
		"vendor_sn": "FT17072604079",
		"date_code": "170727__",
		"extended_identifier": 4,
		"extended_identifier_description": "GBIC/SFP defined by 2-wire interface ID",
		"connector": 7,
		"connector_description": "LC",
		"transceiver_codes": [
			16,
			0,
			0,
			0,
			64,
			64,
			12,
			85,
			0
		],
		"transceiver_types": [
			"10G Ethernet: 10G Base-SR"
		],
		"encoding": 6,
		"encoding_description": "64B/66B",
		"bitrate_nominal": 10300,
		"rate_identifier": 0,
		"rate_identifier_description": "unspecified",
		"laser_wavelength": 850,
		"vendor_rev": "",
		"option_byte1": 0,
		"option_byte2": 26,
		"option_descriptions": [
			"RX_LOS implemented",
			"TX_FAULT implemented",
			"TX_DISABLE implemented"
		],
		"br_margin_max": 0,
		"br_margin_min": 0,
		"optical_diagnostics_supported": true,
		"bias_current": 11.516,
		"tx_power": 0.4872,
		"module_temp": 47.1719,
		"module_voltage": 3.2784
	}
]

Signed-off-by: Mathew McBride <matt@traverse.com.au>
---
 ethtool.c    |   5 +
 sff-common.c | 213 +++++++++++++++--------
 sff-common.h |  17 +-
 sfpdiag.c    |  64 ++++++-
 sfpid.c      | 478 +++++++++++++++++++++++++++++++--------------------
 5 files changed, 522 insertions(+), 255 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 911f26b..83bbde8 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4897,6 +4897,8 @@ static int do_getmodule(struct cmd_context *ctx)
 		    (eeprom->len != modinfo.eeprom_len)) {
 			geeprom_dump_hex = 1;
 		} else if (!geeprom_dump_hex) {
+			new_json_obj(ctx->json);
+			open_json_object(NULL);
 			switch (modinfo.type) {
 #ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 			case ETH_MODULE_SFF_8079:
@@ -4916,6 +4918,8 @@ static int do_getmodule(struct cmd_context *ctx)
 				geeprom_dump_hex = 1;
 				break;
 			}
+			close_json_object();
+			delete_json_obj();
 		}
 		if (geeprom_dump_hex)
 			dump_hex(stdout, eeprom->data,
@@ -5925,6 +5929,7 @@ static const struct option args[] = {
 		.opts	= "-m|--dump-module-eeprom|--module-info",
 		.func	= do_getmodule,
 		.nlfunc = nl_getmodule,
+		.json	= true,
 		.help	= "Query/Decode Module EEPROM information and optical diagnostics if available",
 		.xhelp	= "		[ raw on|off ]\n"
 			  "		[ hex on|off ]\n"
diff --git a/sff-common.c b/sff-common.c
index e951cf1..2d7c995 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -62,218 +62,257 @@ void sff8024_show_oui(const __u8 *id, int id_offset)
 
 void sff8024_show_identifier(const __u8 *id, int id_offset)
 {
-	printf("\t%-41s : 0x%02x", "Identifier", id[id_offset]);
+	char identifier_description[64];
+
 	switch (id[id_offset]) {
 	case SFF8024_ID_UNKNOWN:
-		printf(" (no module present, unknown, or unspecified)\n");
+		strncpy(identifier_description,
+			 "no module present, unknown, or unspecified", 64);
 		break;
 	case SFF8024_ID_GBIC:
-		printf(" (GBIC)\n");
+		strncpy(identifier_description, "GBIC", 64);
 		break;
 	case SFF8024_ID_SOLDERED_MODULE:
-		printf(" (module soldered to motherboard)\n");
+		strncpy(identifier_description,
+			 "module soldered to motherboard", 64);
 		break;
 	case SFF8024_ID_SFP:
-		printf(" (SFP)\n");
+		strncpy(identifier_description, "SFP", 64);
 		break;
 	case SFF8024_ID_300_PIN_XBI:
-		printf(" (300 pin XBI)\n");
+		strncpy(identifier_description, "300 pin XBI", 64);
 		break;
 	case SFF8024_ID_XENPAK:
-		printf(" (XENPAK)\n");
+		strncpy(identifier_description, "XENPAK", 64);
 		break;
 	case SFF8024_ID_XFP:
-		printf(" (XFP)\n");
+		strncpy(identifier_description, "XFP", 64);
 		break;
 	case SFF8024_ID_XFF:
-		printf(" (XFF)\n");
+		strncpy(identifier_description, "XFF", 64);
 		break;
 	case SFF8024_ID_XFP_E:
-		printf(" (XFP-E)\n");
+		strncpy(identifier_description, "XFP-E", 64);
 		break;
 	case SFF8024_ID_XPAK:
-		printf(" (XPAK)\n");
+		strncpy(identifier_description, "XPAK", 64);
 		break;
 	case SFF8024_ID_X2:
-		printf(" (X2)\n");
+		strncpy(identifier_description, "X2", 64);
 		break;
 	case SFF8024_ID_DWDM_SFP:
-		printf(" (DWDM-SFP)\n");
+		strncpy(identifier_description, "DWDM-SFP", 64);
 		break;
 	case SFF8024_ID_QSFP:
-		printf(" (QSFP)\n");
+		strncpy(identifier_description, "QSFP", 64);
 		break;
 	case SFF8024_ID_QSFP_PLUS:
-		printf(" (QSFP+)\n");
+		strncpy(identifier_description, "QSFP+", 64);
 		break;
 	case SFF8024_ID_CXP:
-		printf(" (CXP)\n");
+		strncpy(identifier_description, "CXP", 64);
 		break;
 	case SFF8024_ID_HD4X:
-		printf(" (Shielded Mini Multilane HD 4X)\n");
+		strncpy(identifier_description,
+			 "Shielded Mini Multilane HD 4X", 64);
 		break;
 	case SFF8024_ID_HD8X:
-		printf(" (Shielded Mini Multilane HD 8X)\n");
+		strncpy(identifier_description,
+			 "Shielded Mini Multilane HD 8X", 64);
 		break;
 	case SFF8024_ID_QSFP28:
-		printf(" (QSFP28)\n");
+		strncpy(identifier_description, "QSFP28", 64);
 		break;
 	case SFF8024_ID_CXP2:
-		printf(" (CXP2/CXP28)\n");
+		strncpy(identifier_description, "CXP2/CXP28", 64);
 		break;
 	case SFF8024_ID_CDFP:
-		printf(" (CDFP Style 1/Style 2)\n");
+		strncpy(identifier_description, "CDFP Style 1/Style 2", 64);
 		break;
 	case SFF8024_ID_HD4X_FANOUT:
-		printf(" (Shielded Mini Multilane HD 4X Fanout Cable)\n");
+		strncpy(identifier_description,
+			 "Shielded Mini Multilane HD 4X Fanout Cable", 64);
 		break;
 	case SFF8024_ID_HD8X_FANOUT:
-		printf(" (Shielded Mini Multilane HD 8X Fanout Cable)\n");
+		strncpy(identifier_description,
+			 "Shielded Mini Multilane HD 8X Fanout Cable", 64);
 		break;
 	case SFF8024_ID_CDFP_S3:
-		printf(" (CDFP Style 3)\n");
+		strncpy(identifier_description, "CDFP Style 3", 64);
 		break;
 	case SFF8024_ID_MICRO_QSFP:
-		printf(" (microQSFP)\n");
+		strncpy(identifier_description, "microQSFP", 64);
 		break;
 	case SFF8024_ID_QSFP_DD:
-		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))\n");
+		strncpy(identifier_description,
+			 "QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628)", 64);
 		break;
 	case SFF8024_ID_OSFP:
-		printf(" (OSFP 8X Pluggable Transceiver)\n");
+		strncpy(identifier_description,
+			 "OSFP 8X Pluggable Transceiver", 64);
 		break;
 	case SFF8024_ID_DSFP:
-		printf(" (DSFP Dual Small Form Factor Pluggable Transceiver)\n");
+		strncpy(identifier_description,
+			 "DSFP Dual Small Form Factor Pluggable Transceiver", 64);
 		break;
 	default:
-		printf(" (reserved or unknown)\n");
+		strncpy(identifier_description, "reserved or unknown", 64);
 		break;
 	}
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "identifier", "0x%02x", id[id_offset]);
+		print_string(PRINT_JSON, "identifier_description",
+			     "%s", identifier_description);
+	} else {
+		printf("\t%-41s : 0x%02x (%s)\n", "Identifier",
+		       id[id_offset], identifier_description);
+	}
 }
 
 void sff8024_show_connector(const __u8 *id, int ctor_offset)
 {
-	printf("\t%-41s : 0x%02x", "Connector", id[ctor_offset]);
+	char connector_description[64];
+
 	switch (id[ctor_offset]) {
 	case  SFF8024_CTOR_UNKNOWN:
-		printf(" (unknown or unspecified)\n");
+		strncpy(connector_description, "unknown or unspecified", 64);
 		break;
 	case SFF8024_CTOR_SC:
-		printf(" (SC)\n");
+		strncpy(connector_description, "SC", 64);
 		break;
 	case SFF8024_CTOR_FC_STYLE_1:
-		printf(" (Fibre Channel Style 1 copper)\n");
+		strncpy(connector_description, "Fibre Channel Style 1 copper", 64);
 		break;
 	case SFF8024_CTOR_FC_STYLE_2:
-		printf(" (Fibre Channel Style 2 copper)\n");
+		strncpy(connector_description, "Fibre Channel Style 2 copper", 64);
 		break;
 	case SFF8024_CTOR_BNC_TNC:
-		printf(" (BNC/TNC)\n");
+		strncpy(connector_description, "BNC/TNC", 64);
 		break;
 	case SFF8024_CTOR_FC_COAX:
-		printf(" (Fibre Channel coaxial headers)\n");
+		strncpy(connector_description, "Fibre Channel coaxial headers", 64);
 		break;
 	case SFF8024_CTOR_FIBER_JACK:
-		printf(" (FibreJack)\n");
+		strncpy(connector_description, "FibreJack", 64);
 		break;
 	case SFF8024_CTOR_LC:
-		printf(" (LC)\n");
+		strncpy(connector_description, "LC", 64);
 		break;
 	case SFF8024_CTOR_MT_RJ:
-		printf(" (MT-RJ)\n");
+		strncpy(connector_description, "MT-RJ", 64);
 		break;
 	case SFF8024_CTOR_MU:
-		printf(" (MU)\n");
+		strncpy(connector_description, "MU", 64);
 		break;
 	case SFF8024_CTOR_SG:
-		printf(" (SG)\n");
+		strncpy(connector_description, "SG", 64);
 		break;
 	case SFF8024_CTOR_OPT_PT:
-		printf(" (Optical pigtail)\n");
+		strncpy(connector_description, "Optical pigtail", 64);
 		break;
 	case SFF8024_CTOR_MPO:
-		printf(" (MPO Parallel Optic)\n");
+		strncpy(connector_description, "MPO Parallel Optic", 64);
 		break;
 	case SFF8024_CTOR_MPO_2:
-		printf(" (MPO Parallel Optic - 2x16)\n");
+		strncpy(connector_description, "MPO Parallel Optic - 2x16", 64);
 		break;
 	case SFF8024_CTOR_HSDC_II:
-		printf(" (HSSDC II)\n");
+		strncpy(connector_description, "HSSDC II", 64);
 		break;
 	case SFF8024_CTOR_COPPER_PT:
-		printf(" (Copper pigtail)\n");
+		strncpy(connector_description, "Copper pigtail", 64);
 		break;
 	case SFF8024_CTOR_RJ45:
-		printf(" (RJ45)\n");
+		strncpy(connector_description, "RJ45", 64);
 		break;
 	case SFF8024_CTOR_NO_SEPARABLE:
-		printf(" (No separable connector)\n");
+		strncpy(connector_description, "No separable connector", 64);
 		break;
 	case SFF8024_CTOR_MXC_2x16:
-		printf(" (MXC 2x16)\n");
+		strncpy(connector_description, "MXC 2x16", 64);
 		break;
 	case SFF8024_CTOR_CS_OPTICAL:
-		printf(" (CS optical connector)\n");
+		strncpy(connector_description, "CS optical connector", 64);
 		break;
 	case SFF8024_CTOR_CS_OPTICAL_MINI:
-		printf(" (Mini CS optical connector)\n");
+		strncpy(connector_description, "Mini CS optical connector", 64);
 		break;
 	case SFF8024_CTOR_MPO_2X12:
-		printf(" (MPO 2x12)\n");
+		strncpy(connector_description, "MPO 2x12", 64);
 		break;
 	case SFF8024_CTOR_MPO_1X16:
-		printf(" (MPO 1x16)\n");
+		strncpy(connector_description, "MPO 1x16", 64);
 		break;
 	default:
-		printf(" (reserved or unknown)\n");
+		strncpy(connector_description, "reserved or unknown", 64);
 		break;
 	}
+
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "connector", "%0x02x", id[ctor_offset]);
+		print_string(PRINT_JSON, "connector_description",
+			     "%s", connector_description);
+	} else {
+		printf("\t%-41s : 0x%02x (%s)\n", "Connector",
+		       id[ctor_offset], connector_description);
+	}
 }
 
 void sff8024_show_encoding(const __u8 *id, int encoding_offset, int sff_type)
 {
-	printf("\t%-41s : 0x%02x", "Encoding", id[encoding_offset]);
+	char encoding_description[64];
+
 	switch (id[encoding_offset]) {
 	case SFF8024_ENCODING_UNSPEC:
-		printf(" (unspecified)\n");
+		strncpy(encoding_description, "unspecified", 64);
 		break;
 	case SFF8024_ENCODING_8B10B:
-		printf(" (8B/10B)\n");
+		strncpy(encoding_description, "8B/10B", 64);
 		break;
 	case SFF8024_ENCODING_4B5B:
-		printf(" (4B/5B)\n");
+		strncpy(encoding_description, "4B/5B", 64);
 		break;
 	case SFF8024_ENCODING_NRZ:
-		printf(" (NRZ)\n");
+		strncpy(encoding_description, "NRZ", 64);
 		break;
 	case SFF8024_ENCODING_4h:
 		if (sff_type == ETH_MODULE_SFF_8472)
-			printf(" (Manchester)\n");
+			strncpy(encoding_description, "Manchester", 64);
 		else if (sff_type == ETH_MODULE_SFF_8636)
-			printf(" (SONET Scrambled)\n");
+			strncpy(encoding_description, "SONET Scrambled", 64);
 		break;
 	case SFF8024_ENCODING_5h:
 		if (sff_type == ETH_MODULE_SFF_8472)
-			printf(" (SONET Scrambled)\n");
+			strncpy(encoding_description, "SONET Scrambled", 64);
 		else if (sff_type == ETH_MODULE_SFF_8636)
-			printf(" (64B/66B)\n");
+			strncpy(encoding_description, "64B/66B", 64);
 		break;
 	case SFF8024_ENCODING_6h:
 		if (sff_type == ETH_MODULE_SFF_8472)
-			printf(" (64B/66B)\n");
+			strncpy(encoding_description, "64B/66B", 64);
 		else if (sff_type == ETH_MODULE_SFF_8636)
-			printf(" (Manchester)\n");
+			strncpy(encoding_description, "Manchester", 64);
 		break;
 	case SFF8024_ENCODING_256B:
-		printf(" ((256B/257B (transcoded FEC-enabled data))\n");
+		strncpy(encoding_description,
+			"256B/257B (transcoded FEC-enabled data)", 64);
 		break;
 	case SFF8024_ENCODING_PAM4:
-		printf(" (PAM4)\n");
+		strncpy(encoding_description, "PAM4", 64);
 		break;
 	default:
-		printf(" (reserved or unknown)\n");
+		strncpy(encoding_description, "reserved or unknown", 64);
 		break;
 	}
+
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "encoding", "0x%02x", id[encoding_offset]);
+		print_string(PRINT_JSON, "encoding_description",
+			     "%s", encoding_description);
+	} else {
+		printf("\t%-41s : 0x%02x (%s)\n", "Encoding",
+		       id[encoding_offset], encoding_description);
+	}
 }
 
 void sff_show_thresholds(struct sff_diags sd)
@@ -324,6 +363,44 @@ void sff_show_thresholds(struct sff_diags sd)
 		     sd.rx_power[LWARN]);
 }
 
+void sff_show_thresholds_json(struct sff_diags sd)
+{
+	open_json_object("laser_bias_current");
+	PRINT_BIAS_JSON("high_alarm",	sd.bias_cur[HALRM]);
+	PRINT_BIAS_JSON("low_alarm",	sd.bias_cur[LALRM]);
+	PRINT_BIAS_JSON("high_warning", sd.bias_cur[HWARN]);
+	PRINT_BIAS_JSON("low_warning",	sd.bias_cur[HWARN]);
+	close_json_object();
+
+	open_json_object("laser_output_power");
+	PRINT_xX_PWR_JSON("high_alarm",		sd.tx_power[HALRM]);
+	PRINT_xX_PWR_JSON("low_alarm",		sd.tx_power[LALRM]);
+	PRINT_xX_PWR_JSON("high_warning",	sd.tx_power[LALRM]);
+	PRINT_xX_PWR_JSON("low_warning",	sd.tx_power[LALRM]);
+	close_json_object();
+
+	open_json_object("module_temperature");
+	PRINT_TEMP_JSON("high_alarm", sd.sfp_temp[HALRM]);
+	PRINT_TEMP_JSON("low_alarm", sd.sfp_temp[LALRM]);
+	PRINT_TEMP_JSON("high_warning", sd.sfp_temp[HWARN]);
+	PRINT_TEMP_JSON("low_warning", sd.sfp_temp[HWARN]);
+	close_json_object();
+
+	open_json_object("module_voltage");
+	PRINT_VCC_JSON("high_alarm", sd.sfp_voltage[HALRM]);
+	PRINT_VCC_JSON("low_alarm", sd.sfp_voltage[LALRM]);
+	PRINT_VCC_JSON("high_warning", sd.sfp_voltage[HWARN]);
+	PRINT_VCC_JSON("low_warning", sd.sfp_voltage[LWARN]);
+	close_json_object();
+
+	open_json_object("laser_rx_power");
+	PRINT_xX_PWR_JSON("high_alarm",		sd.rx_power[HALRM]);
+	PRINT_xX_PWR_JSON("low_alarm",		sd.rx_power[LALRM]);
+	PRINT_xX_PWR_JSON("high_warning",	sd.rx_power[LALRM]);
+	PRINT_xX_PWR_JSON("low_warning",	sd.rx_power[LALRM]);
+	close_json_object();
+}
+
 void sff_show_revision_compliance(const __u8 *id, int rev_offset)
 {
 	static const char *pfx =
diff --git a/sff-common.h b/sff-common.h
index dd12dda..9750273 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -134,19 +134,31 @@
 		printf("\t%-41s : %.4f mW / %.2f dBm\n", (string),         \
 		      (double)((var) / 10000.),                           \
 		       convert_mw_to_dbm((double)((var) / 10000.)))
+#define PRINT_xX_PWR_JSON(key, var)			       \
+		print_float(PRINT_JSON, key, "%.2f",	       \
+			    (double)((var) / 10000.))
 
+#define BIAS_DIV(value) ((double)(value / 500.))
 #define PRINT_BIAS(string, bias_cur)                             \
 		printf("\t%-41s : %.3f mA\n", (string),                       \
-		      (double)(bias_cur / 500.))
+		       BIAS_DIV(bias_cur))
+
+#define PRINT_BIAS_JSON(key, bias_cur)				\
+		print_float(PRINT_JSON, key, "%.3f", BIAS_DIV(bias_cur))
 
 #define PRINT_TEMP(string, temp)                                   \
 		printf("\t%-41s : %.2f degrees C / %.2f degrees F\n", \
 		      (string), (double)(temp / 256.),                \
 		      (double)(temp / 256. * 1.8 + 32.))
-
+#define PRINT_TEMP_JSON(key, temp)				   \
+		print_float(PRINT_JSON, key, "%.2f",		   \
+			    (double)(temp / 256.))
 #define PRINT_VCC(string, sfp_voltage)          \
 		printf("\t%-41s : %.4f V\n", (string),       \
 		      (double)(sfp_voltage / 10000.))
+#define PRINT_VCC_JSON(key, sfp_voltage)		\
+		print_float(PRINT_JSON, key, "%.4f",	\
+			    (double)(sfp_voltage / 10000.))
 
 # define PRINT_xX_THRESH_PWR(string, var, index)                       \
 		PRINT_xX_PWR(string, (var)[(index)])
@@ -199,6 +211,7 @@ void sff_show_value_with_unit(const __u8 *id, unsigned int reg,
 void sff_show_ascii(const __u8 *id, unsigned int first_reg,
 		    unsigned int last_reg, const char *name);
 void sff_show_thresholds(struct sff_diags sd);
+void sff_show_thresholds_json(struct sff_diags sd);
 
 void sff8024_show_oui(const __u8 *id, int id_offset);
 void sff8024_show_identifier(const __u8 *id, int id_offset);
diff --git a/sfpdiag.c b/sfpdiag.c
index 1fa8b7b..c180f2f 100644
--- a/sfpdiag.c
+++ b/sfpdiag.c
@@ -8,6 +8,7 @@
  *   by SFF Committee.
  */
 
+#include <ctype.h>
 #include <stdio.h>
 #include <math.h>
 #include <arpa/inet.h>
@@ -239,6 +240,62 @@ static void sff8472_parse_eeprom(const __u8 *id, struct sff_diags *sd)
 		sff8472_calibration(id, sd);
 }
 
+static __u8 sff8472_alarm_human_to_json(const char *orig_desc,
+					char *new_desc, size_t max_len)
+{
+	__u8 cur_pos = 0;
+
+	while (orig_desc[cur_pos] != '\0' && cur_pos < max_len) {
+		if (orig_desc[cur_pos] == ' ')
+			new_desc[cur_pos] = '_';
+		else if (orig_desc[cur_pos] >= 'A' && orig_desc[cur_pos] <= 'Z')
+			new_desc[cur_pos] = tolower(orig_desc[cur_pos]);
+		else
+			new_desc[cur_pos] = orig_desc[cur_pos];
+		cur_pos++;
+	}
+
+	new_desc[cur_pos] = '\0';
+	return cur_pos;
+}
+
+void sff8472_show_all_json(const __u8 *id, struct sff_diags *sd)
+{
+	char json_alarm_name[64];
+	int i;
+
+	if (is_json_context()) {
+		print_bool(PRINT_JSON, "optical_diagnostics_supported",
+			   NULL, sd->supports_dom);
+	}
+
+	if (!sd->supports_dom)
+		return;
+
+	PRINT_BIAS_JSON("bias_current",		sd->bias_cur[MCURR]);
+	PRINT_xX_PWR_JSON("tx_power",		sd->tx_power[MCURR]);
+	PRINT_TEMP_JSON("module_temp",		sd->sfp_temp[MCURR]);
+	PRINT_VCC_JSON("module_voltage",	sd->sfp_voltage[MCURR]);
+	PRINT_xX_PWR_JSON("rx_power",		sd->rx_power[MCURR]);
+	print_bool(PRINT_JSON, "rx_power_is_average", NULL, sd->rx_power_type);
+	print_bool(PRINT_JSON, "supports_alarms", NULL, sd->supports_alarms);
+	if (sd->supports_alarms) {
+		open_json_object("alarms");
+		for (i = 0; sff8472_aw_flags[i].str; ++i) {
+			sff8472_alarm_human_to_json(sff8472_aw_flags[i].str,
+						    &json_alarm_name[0],
+						    64);
+			print_bool(PRINT_JSON, json_alarm_name, NULL,
+				   id[SFF_A2_BASE + sff8472_aw_flags[i].offset]
+				   & sff8472_aw_flags[i].value);
+		}
+		close_json_object();
+		open_json_object("thresholds");
+		sff_show_thresholds_json(*sd);
+		close_json_object();
+	}
+}
+
 void sff8472_show_all(const __u8 *id)
 {
 	struct sff_diags sd = {0};
@@ -247,6 +304,11 @@ void sff8472_show_all(const __u8 *id)
 
 	sff8472_parse_eeprom(id, &sd);
 
+	if (is_json_context()) {
+		sff8472_show_all_json(id, &sd);
+		return;
+	}
+
 	if (!sd.supports_dom) {
 		printf("\t%-41s : No\n", "Optical diagnostics support");
 		return;
@@ -268,8 +330,8 @@ void sff8472_show_all(const __u8 *id)
 
 	printf("\t%-41s : %s\n", "Alarm/warning flags implemented",
 	       (sd.supports_alarms ? "Yes" : "No"));
-	if (sd.supports_alarms) {
 
+	if (sd.supports_alarms) {
 		for (i = 0; sff8472_aw_flags[i].str; ++i) {
 			printf("\t%-41s : %s\n", sff8472_aw_flags[i].str,
 			       id[SFF_A2_BASE + sff8472_aw_flags[i].offset]
diff --git a/sfpid.c b/sfpid.c
index 1bc45c1..d6ce88b 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -24,15 +24,28 @@ static void sff8079_show_identifier(const __u8 *id)
 
 static void sff8079_show_ext_identifier(const __u8 *id)
 {
-	printf("\t%-41s : 0x%02x", "Extended identifier", id[1]);
+	char ext_identifier_description[64];
+
 	if (id[1] == 0x00)
-		printf(" (GBIC not specified / not MOD_DEF compliant)\n");
+		strncpy(ext_identifier_description,
+			 "GBIC not specified / not MOD_DEF compliant", 64);
 	else if (id[1] == 0x04)
-		printf(" (GBIC/SFP defined by 2-wire interface ID)\n");
+		strncpy(ext_identifier_description,
+			 "GBIC/SFP defined by 2-wire interface ID", 64);
 	else if (id[1] <= 0x07)
-		printf(" (GBIC compliant with MOD_DEF %u)\n", id[1]);
+		snprintf(ext_identifier_description, 64,
+			 "GBIC compliant with MOD_DEF %u", id[1]);
 	else
-		printf(" (unknown)\n");
+		strncpy(ext_identifier_description, "unknown", 64);
+
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "extended_identifier", NULL, id[1]);
+		print_string(PRINT_JSON, "extended_identifier_description",
+			     NULL, ext_identifier_description);
+	} else {
+		printf("\t%-41s : 0x%02x (%s)\n", "Extended identifier",
+		       id[1], ext_identifier_description);
+	}
 }
 
 static void sff8079_show_connector(const __u8 *id)
@@ -40,233 +53,244 @@ static void sff8079_show_connector(const __u8 *id)
 	sff8024_show_connector(id, 2);
 }
 
+static void print_transceiver_type(const char *desc)
+{
+	if (is_json_context())
+		print_string(PRINT_JSON, NULL, NULL, desc);
+	else
+		printf("\t%-41s : %s\n", "Transceiver type", desc);
+}
+
 static void sff8079_show_transceiver(const __u8 *id)
 {
-	static const char *pfx =
-		"\tTransceiver type                          :";
-
-	printf("\t%-41s : 0x%02x 0x%02x 0x%02x " \
-	       "0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
-		   "Transceiver codes",
-	       id[3], id[4], id[5], id[6],
-	       id[7], id[8], id[9], id[10], id[36]);
+	int i;
+
+	if (!is_json_context()) {
+		printf("\t%-41s : 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
+		       "Transceiver codes",
+		       id[3], id[4], id[5], id[6],
+		       id[7], id[8], id[9], id[10], id[36]);
+	} else {
+		open_json_array("transceiver_codes", NULL);
+
+		for (i = 3; i < 11; i++)
+			print_int(PRINT_JSON, NULL, NULL, id[i]);
+
+		print_int(PRINT_JSON, NULL, NULL, id[36]);
+		close_json_array(NULL);
+		open_json_array("transceiver_types", NULL);
+	}
+
 	/* 10G Ethernet Compliance Codes */
 	if (id[3] & (1 << 7))
-		printf("%s 10G Ethernet: 10G Base-ER" \
-		       " [SFF-8472 rev10.4 onwards]\n", pfx);
+		print_transceiver_type("10G Ethernet: 10G Base-ER [SFF-8472 rev10.4 onwards]");
 	if (id[3] & (1 << 6))
-		printf("%s 10G Ethernet: 10G Base-LRM\n", pfx);
+		print_transceiver_type("10G Ethernet: 10G Base-LRM");
 	if (id[3] & (1 << 5))
-		printf("%s 10G Ethernet: 10G Base-LR\n", pfx);
+		print_transceiver_type("10G Ethernet: 10G Base-LR");
 	if (id[3] & (1 << 4))
-		printf("%s 10G Ethernet: 10G Base-SR\n", pfx);
+		print_transceiver_type("10G Ethernet: 10G Base-SR");
 	/* Infiniband Compliance Codes */
 	if (id[3] & (1 << 3))
-		printf("%s Infiniband: 1X SX\n", pfx);
+		print_transceiver_type("Infiniband: 1X SX");
 	if (id[3] & (1 << 2))
-		printf("%s Infiniband: 1X LX\n", pfx);
+		print_transceiver_type("Infiniband: 1X LX");
 	if (id[3] & (1 << 1))
-		printf("%s Infiniband: 1X Copper Active\n", pfx);
+		print_transceiver_type("Infiniband: 1X Copper Active");
 	if (id[3] & (1 << 0))
-		printf("%s Infiniband: 1X Copper Passive\n", pfx);
+		print_transceiver_type("Infiniband: 1X Copper Passive");
 	/* ESCON Compliance Codes */
 	if (id[4] & (1 << 7))
-		printf("%s ESCON: ESCON MMF, 1310nm LED\n", pfx);
+		print_transceiver_type("ESCON: ESCON MMF, 1310nm LED");
 	if (id[4] & (1 << 6))
-		printf("%s ESCON: ESCON SMF, 1310nm Laser\n", pfx);
+		print_transceiver_type("ESCON: ESCON SMF, 1310nm Laser");
 	/* SONET Compliance Codes */
 	if (id[4] & (1 << 5))
-		printf("%s SONET: OC-192, short reach\n", pfx);
+		print_transceiver_type("SONET: OC-192, short reach");
 	if (id[4] & (1 << 4))
-		printf("%s SONET: SONET reach specifier bit 1\n", pfx);
+		print_transceiver_type("SONET: SONET reach specifier bit 1");
 	if (id[4] & (1 << 3))
-		printf("%s SONET: SONET reach specifier bit 2\n", pfx);
+		print_transceiver_type("SONET: SONET reach specifier bit 2");
 	if (id[4] & (1 << 2))
-		printf("%s SONET: OC-48, long reach\n", pfx);
+		print_transceiver_type("SONET: OC-48, long reach");
 	if (id[4] & (1 << 1))
-		printf("%s SONET: OC-48, intermediate reach\n", pfx);
+		print_transceiver_type("SONET: OC-48, intermediate reach");
 	if (id[4] & (1 << 0))
-		printf("%s SONET: OC-48, short reach\n", pfx);
+		print_transceiver_type("SONET: OC-48, short reach");
 	if (id[5] & (1 << 6))
-		printf("%s SONET: OC-12, single mode, long reach\n", pfx);
+		print_transceiver_type("SONET: OC-12, single mode, long reach");
 	if (id[5] & (1 << 5))
-		printf("%s SONET: OC-12, single mode, inter. reach\n", pfx);
+		print_transceiver_type("SONET: OC-12, single mode, inter. reach");
 	if (id[5] & (1 << 4))
-		printf("%s SONET: OC-12, short reach\n", pfx);
+		print_transceiver_type("SONET: OC-12, short reach");
 	if (id[5] & (1 << 2))
-		printf("%s SONET: OC-3, single mode, long reach\n", pfx);
+		print_transceiver_type("SONET: OC-3, single mode, long reach");
 	if (id[5] & (1 << 1))
-		printf("%s SONET: OC-3, single mode, inter. reach\n", pfx);
+		print_transceiver_type("SONET: OC-3, single mode, inter. reach");
 	if (id[5] & (1 << 0))
-		printf("%s SONET: OC-3, short reach\n", pfx);
+		print_transceiver_type("SONET: OC-3, short reach");
 	/* Ethernet Compliance Codes */
 	if (id[6] & (1 << 7))
-		printf("%s Ethernet: BASE-PX\n", pfx);
+		print_transceiver_type("Ethernet: BASE-PX");
 	if (id[6] & (1 << 6))
-		printf("%s Ethernet: BASE-BX10\n", pfx);
+		print_transceiver_type("Ethernet: BASE-BX10");
 	if (id[6] & (1 << 5))
-		printf("%s Ethernet: 100BASE-FX\n", pfx);
+		print_transceiver_type("Ethernet: 100BASE-FX");
 	if (id[6] & (1 << 4))
-		printf("%s Ethernet: 100BASE-LX/LX10\n", pfx);
+		print_transceiver_type("Ethernet: 100BASE-LX/LX10");
 	if (id[6] & (1 << 3))
-		printf("%s Ethernet: 1000BASE-T\n", pfx);
+		print_transceiver_type("Ethernet: 1000BASE-T");
 	if (id[6] & (1 << 2))
-		printf("%s Ethernet: 1000BASE-CX\n", pfx);
+		print_transceiver_type("Ethernet: 1000BASE-CX");
 	if (id[6] & (1 << 1))
-		printf("%s Ethernet: 1000BASE-LX\n", pfx);
+		print_transceiver_type("Ethernet: 1000BASE-LX");
 	if (id[6] & (1 << 0))
-		printf("%s Ethernet: 1000BASE-SX\n", pfx);
+		print_transceiver_type("Ethernet: 1000BASE-SX");
 	/* Fibre Channel link length */
 	if (id[7] & (1 << 7))
-		printf("%s FC: very long distance (V)\n", pfx);
+		print_transceiver_type("FC: very long distance (V)");
 	if (id[7] & (1 << 6))
-		printf("%s FC: short distance (S)\n", pfx);
+		print_transceiver_type("FC: short distance (S)");
 	if (id[7] & (1 << 5))
-		printf("%s FC: intermediate distance (I)\n", pfx);
+		print_transceiver_type("FC: intermediate distance (I)");
 	if (id[7] & (1 << 4))
-		printf("%s FC: long distance (L)\n", pfx);
+		print_transceiver_type("FC: long distance (L)");
 	if (id[7] & (1 << 3))
-		printf("%s FC: medium distance (M)\n", pfx);
+		print_transceiver_type("FC: medium distance (M)");
 	/* Fibre Channel transmitter technology */
 	if (id[7] & (1 << 2))
-		printf("%s FC: Shortwave laser, linear Rx (SA)\n", pfx);
+		print_transceiver_type("FC: Shortwave laser, linear Rx (SA)");
 	if (id[7] & (1 << 1))
-		printf("%s FC: Longwave laser (LC)\n", pfx);
+		print_transceiver_type("FC: Longwave laser (LC)");
 	if (id[7] & (1 << 0))
-		printf("%s FC: Electrical inter-enclosure (EL)\n", pfx);
+		print_transceiver_type("FC: Electrical inter-enclosure (EL)");
 	if (id[8] & (1 << 7))
-		printf("%s FC: Electrical intra-enclosure (EL)\n", pfx);
+		print_transceiver_type("FC: Electrical intra-enclosure (EL)");
 	if (id[8] & (1 << 6))
-		printf("%s FC: Shortwave laser w/o OFC (SN)\n", pfx);
+		print_transceiver_type("FC: Shortwave laser w/o OFC (SN)");
 	if (id[8] & (1 << 5))
-		printf("%s FC: Shortwave laser with OFC (SL)\n", pfx);
+		print_transceiver_type("FC: Shortwave laser with OFC (SL)");
 	if (id[8] & (1 << 4))
-		printf("%s FC: Longwave laser (LL)\n", pfx);
+		print_transceiver_type("FC: Longwave laser (LL)");
 	if (id[8] & (1 << 3))
-		printf("%s Active Cable\n", pfx);
+		print_transceiver_type("Active Cable");
 	if (id[8] & (1 << 2))
-		printf("%s Passive Cable\n", pfx);
+		print_transceiver_type("Passive Cable");
 	if (id[8] & (1 << 1))
-		printf("%s FC: Copper FC-BaseT\n", pfx);
+		print_transceiver_type("FC: Copper FC-BaseT");
 	/* Fibre Channel transmission media */
 	if (id[9] & (1 << 7))
-		printf("%s FC: Twin Axial Pair (TW)\n", pfx);
+		print_transceiver_type("FC: Twin Axial Pair (TW)");
 	if (id[9] & (1 << 6))
-		printf("%s FC: Twisted Pair (TP)\n", pfx);
+		print_transceiver_type("FC: Twisted Pair (TP)");
 	if (id[9] & (1 << 5))
-		printf("%s FC: Miniature Coax (MI)\n", pfx);
+		print_transceiver_type("FC: Miniature Coax (MI)");
 	if (id[9] & (1 << 4))
-		printf("%s FC: Video Coax (TV)\n", pfx);
+		print_transceiver_type("FC: Video Coax (TV)");
 	if (id[9] & (1 << 3))
-		printf("%s FC: Multimode, 62.5um (M6)\n", pfx);
+		print_transceiver_type("FC: Multimode, 62.5um (M6)");
 	if (id[9] & (1 << 2))
-		printf("%s FC: Multimode, 50um (M5)\n", pfx);
+		print_transceiver_type("FC: Multimode, 50um (M5)");
 	if (id[9] & (1 << 0))
-		printf("%s FC: Single Mode (SM)\n", pfx);
+		print_transceiver_type("FC: Single Mode (SM)");
 	/* Fibre Channel speed */
 	if (id[10] & (1 << 7))
-		printf("%s FC: 1200 MBytes/sec\n", pfx);
+		print_transceiver_type("FC: 1200 MBytes/sec");
 	if (id[10] & (1 << 6))
-		printf("%s FC: 800 MBytes/sec\n", pfx);
+		print_transceiver_type("FC: 800 MBytes/sec");
 	if (id[10] & (1 << 4))
-		printf("%s FC: 400 MBytes/sec\n", pfx);
+		print_transceiver_type("FC: 400 MBytes/sec");
 	if (id[10] & (1 << 2))
-		printf("%s FC: 200 MBytes/sec\n", pfx);
+		print_transceiver_type("FC: 200 MBytes/sec");
 	if (id[10] & (1 << 0))
-		printf("%s FC: 100 MBytes/sec\n", pfx);
+		print_transceiver_type("FC: 100 MBytes/sec");
 	/* Extended Specification Compliance Codes from SFF-8024 */
 	if (id[36] == 0x1)
-		printf("%s Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 5x10^(-5)\n", pfx);
+		print_transceiver_type("Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 5x10^(-5)");
 	if (id[36] == 0x2)
-		printf("%s Extended: 100G Base-SR4 or 25GBase-SR\n", pfx);
+		print_transceiver_type("Extended: 100G Base-SR4 or 25GBase-SR");
 	if (id[36] == 0x3)
-		printf("%s Extended: 100G Base-LR4 or 25GBase-LR\n", pfx);
+		print_transceiver_type("Extended: 100G Base-LR4 or 25GBase-LR");
 	if (id[36] == 0x4)
-		printf("%s Extended: 100G Base-ER4 or 25GBase-ER\n", pfx);
+		print_transceiver_type("Extended: 100G Base-ER4 or 25GBase-ER");
 	if (id[36] == 0x8)
-		printf("%s Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 5x10^(-5)\n", pfx);
+		print_transceiver_type("Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 5x10^(-5)");
 	if (id[36] == 0xb)
-		printf("%s Extended: 100G Base-CR4 or 25G Base-CR CA-L\n", pfx);
+		print_transceiver_type("Extended: 100G Base-CR4 or 25G Base-CR CA-L");
 	if (id[36] == 0xc)
-		printf("%s Extended: 25G Base-CR CA-S\n", pfx);
+		print_transceiver_type("Extended: 25G Base-CR CA-S");
 	if (id[36] == 0xd)
-		printf("%s Extended: 25G Base-CR CA-N\n", pfx);
+		print_transceiver_type("Extended: 25G Base-CR CA-N");
 	if (id[36] == 0x16)
-		printf("%s Extended: 10Gbase-T with SFI electrical interface\n", pfx);
+		print_transceiver_type("Extended: 10Gbase-T with SFI electrical interface");
 	if (id[36] == 0x18)
-		printf("%s Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 10^(-12)\n", pfx);
+		print_transceiver_type("Extended: 100G AOC or 25GAUI C2M AOC with worst BER of 10^(-12)");
 	if (id[36] == 0x19)
-		printf("%s Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 10^(-12)\n", pfx);
+		print_transceiver_type("Extended: 100G ACC or 25GAUI C2M ACC with worst BER of 10^(-12)");
 	if (id[36] == 0x1a)
-		printf("%s Extended: 100GE-DWDM2 (DWDM transceiver using 2 wavelengths on a 1550 nm DWDM grid with a reach up to 80 km)\n",
-		       pfx);
+		print_transceiver_type("Extended: 100GE-DWDM2 (DWDM transceiver using 2 wavelengths on a 1550 nm DWDM with a reach up to 80 km)");
 	if (id[36] == 0x1b)
-		printf("%s Extended: 100G 1550nm WDM (4 wavelengths)\n", pfx);
+		print_transceiver_type("Extended: 100G 1550nm WDM (4 wavelengths)");
 	if (id[36] == 0x1c)
-		printf("%s Extended: 10Gbase-T Short Reach\n", pfx);
+		print_transceiver_type("Extended: 10Gbase-T Short Reach");
 	if (id[36] == 0x1d)
-		printf("%s Extended: 5GBASE-T\n", pfx);
+		print_transceiver_type("Extended: 5GBASE-T");
 	if (id[36] == 0x1e)
-		printf("%s Extended: 2.5GBASE-T\n", pfx);
+		print_transceiver_type("Extended: 2.5GBASE-T");
 	if (id[36] == 0x1f)
-		printf("%s Extended: 40G SWDM4\n", pfx);
+		print_transceiver_type("Extended: 40G SWDM4");
 	if (id[36] == 0x20)
-		printf("%s Extended: 100G SWDM4\n", pfx);
+		print_transceiver_type("Extended: 100G SWDM4");
 	if (id[36] == 0x21)
-		printf("%s Extended: 100G PAM4 BiDi\n", pfx);
+		print_transceiver_type("Extended: 100G PAM4 BiDi");
 	if (id[36] == 0x22)
-		printf("%s Extended: 4WDM-10 MSA (10km version of 100G CWDM4 with same RS(528,514) FEC in host system)\n",
-		       pfx);
+		print_transceiver_type("Extended: 4WDM-10 MSA (10km version of 100G CWDM4 with same RS(528,514) FEC in host system)");
 	if (id[36] == 0x23)
-		printf("%s Extended: 4WDM-20 MSA (20km version of 100GBASE-LR4 with RS(528,514) FEC in host system)\n",
-		       pfx);
+		print_transceiver_type("Extended: 4WDM-20 MSA (20km version of 100GBASE-LR4 with RS(528,514) FEC in host system)");
 	if (id[36] == 0x24)
-		printf("%s Extended: 4WDM-40 MSA (40km reach with APD receiver and RS(528,514) FEC in host system)\n",
-		       pfx);
+		print_transceiver_type("Extended: 4WDM-40 MSA (40km reach with APD receiver and RS(528,514) FEC in host system)");
 	if (id[36] == 0x25)
-		printf("%s Extended: 100GBASE-DR (clause 140), CAUI-4 (no FEC)\n", pfx);
+		print_transceiver_type("Extended: 100GBASE-DR (clause 140), CAUI-4 (no FEC)");
 	if (id[36] == 0x26)
-		printf("%s Extended: 100G-FR or 100GBASE-FR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+		print_transceiver_type("Extended: 100G-FR or 100GBASE-FR1 (clause 140), CAUI-4 (no FEC)");
 	if (id[36] == 0x27)
-		printf("%s Extended: 100G-LR or 100GBASE-LR1 (clause 140), CAUI-4 (no FEC)\n", pfx);
+		print_transceiver_type("Extended: 100G-LR or 100GBASE-LR1 (clause 140), CAUI-4 (no FEC)");
 	if (id[36] == 0x30)
-		printf("%s Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
-		       pfx);
+		print_transceiver_type("Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below");
 	if (id[36] == 0x31)
-		printf("%s Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below\n",
-		       pfx);
+		print_transceiver_type("Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 10-6 or below");
 	if (id[36] == 0x32)
-		printf("%s Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
-		       pfx);
+		print_transceiver_type("Extended: Active Copper Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below");
 	if (id[36] == 0x33)
-		printf("%s Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below\n",
-		       pfx);
+		print_transceiver_type("Extended: Active Optical Cable with 50GAUI, 100GAUI-2 or 200GAUI-4 C2M. Providing a worst BER of 2.6x10-4 for ACC, 10-5 for AUI, or below");
 	if (id[36] == 0x40)
-		printf("%s Extended: 50GBASE-CR, 100GBASE-CR2, or 200GBASE-CR4\n", pfx);
+		print_transceiver_type("Extended: 50GBASE-CR, 100GBASE-CR2, or 200GBASE-CR4");
 	if (id[36] == 0x41)
-		printf("%s Extended: 50GBASE-SR, 100GBASE-SR2, or 200GBASE-SR4\n", pfx);
+		print_transceiver_type("Extended: 50GBASE-SR, 100GBASE-SR2, or 200GBASE-SR4");
 	if (id[36] == 0x42)
-		printf("%s Extended: 50GBASE-FR or 200GBASE-DR4\n", pfx);
+		print_transceiver_type("Extended: 50GBASE-FR or 200GBASE-DR4");
 	if (id[36] == 0x43)
-		printf("%s Extended: 200GBASE-FR4\n", pfx);
+		print_transceiver_type("Extended: 200GBASE-FR4");
 	if (id[36] == 0x44)
-		printf("%s Extended: 200G 1550 nm PSM4\n", pfx);
+		print_transceiver_type("Extended: 200G 1550 nm PSM4");
 	if (id[36] == 0x45)
-		printf("%s Extended: 50GBASE-LR\n", pfx);
+		print_transceiver_type("Extended: 50GBASE-LR");
 	if (id[36] == 0x46)
-		printf("%s Extended: 200GBASE-LR4\n", pfx);
+		print_transceiver_type("Extended: 200GBASE-LR4");
 	if (id[36] == 0x50)
-		printf("%s Extended: 64GFC EA\n", pfx);
+		print_transceiver_type("Extended: 196GFC EA");
 	if (id[36] == 0x51)
-		printf("%s Extended: 64GFC SW\n", pfx);
+		print_transceiver_type("Extended: 196GFC SW");
 	if (id[36] == 0x52)
-		printf("%s Extended: 64GFC LW\n", pfx);
+		print_transceiver_type("Extended: 196GFC LW");
 	if (id[36] == 0x53)
-		printf("%s Extended: 128GFC EA\n", pfx);
+		print_transceiver_type("Extended: 128GFC EA");
 	if (id[36] == 0x54)
-		printf("%s Extended: 128GFC SW\n", pfx);
+		print_transceiver_type("Extended: 128GFC SW");
 	if (id[36] == 0x55)
-		printf("%s Extended: 128GFC LW\n", pfx);
+		print_transceiver_type("Extended: 128GFC LW");
+	if (is_json_context())
+		close_json_array(NULL);
 }
 
 static void sff8079_show_encoding(const __u8 *id)
@@ -276,130 +300,201 @@ static void sff8079_show_encoding(const __u8 *id)
 
 static void sff8079_show_rate_identifier(const __u8 *id)
 {
-	printf("\t%-41s : 0x%02x", "Rate identifier", id[13]);
+	char rate_identifier_description[72];
+
 	switch (id[13]) {
 	case 0x00:
-		printf(" (unspecified)\n");
+		snprintf(rate_identifier_description, 72, "unspecified");
 		break;
 	case 0x01:
-		printf(" (4/2/1G Rate_Select & AS0/AS1)\n");
+		snprintf(rate_identifier_description, 72,
+			 "4/2/1G Rate_Select & AS0/AS1");
 		break;
 	case 0x02:
-		printf(" (8/4/2G Rx Rate_Select only)\n");
+		snprintf(rate_identifier_description, 72,
+			 "8/4/2G Rx Rate_Select only");
 		break;
 	case 0x03:
-		printf(" (8/4/2G Independent Rx & Tx Rate_Select)\n");
+		snprintf(rate_identifier_description, 72,
+			 "8/4/2G Independent Rx & Tx Rate_Select");
 		break;
 	case 0x04:
-		printf(" (8/4/2G Tx Rate_Select only)\n");
+		snprintf(rate_identifier_description, 72,
+			 "8/4/2G Tx Rate_Select only");
 		break;
 	default:
-		printf(" (reserved or unknown)\n");
+		snprintf(rate_identifier_description, 72,
+			 "reserved or unknown");
 		break;
 	}
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "rate_identifier", NULL, id[13]);
+		print_string(PRINT_JSON, "rate_identifier_description",
+			     NULL, rate_identifier_description);
+	} else {
+		printf("\t%-41s : 0x%02x (%s)\n", "Rate identifier",
+		       id[13], rate_identifier_description);
+	}
 }
 
 static void sff8079_show_oui(const __u8 *id)
 {
-	printf("\t%-41s : %02x:%02x:%02x\n", "Vendor OUI",
-	       id[37], id[38], id[39]);
+	char oui_value[16];
+
+	snprintf(oui_value, 16, "%02x:%02x:%02x", id[37], id[38], id[39]);
+
+	if (is_json_context())
+		print_string(PRINT_JSON, "vendor_oui", NULL, oui_value);
+	else
+		printf("\t%-41s : %s\n", "Vendor OUI", oui_value);
 }
 
 static void sff8079_show_wavelength_or_copper_compliance(const __u8 *id)
 {
+	char compliance_mode_buf[64];
+
 	if (id[8] & (1 << 2)) {
-		printf("\t%-41s : 0x%02x", "Passive Cu cmplnce.", id[60]);
 		switch (id[60]) {
 		case 0x00:
-			printf(" (unspecified)");
+			strncpy(compliance_mode_buf, "unspecified", 64);
 			break;
 		case 0x01:
-			printf(" (SFF-8431 appendix E)");
+			strncpy(compliance_mode_buf, "SFF-8431 appendix E", 64);
 			break;
 		default:
-			printf(" (unknown)");
+			strncpy(compliance_mode_buf, "unknown", 64);
 			break;
 		}
-		printf(" [SFF-8472 rev10.4 only]\n");
+		if (is_json_context()) {
+			print_int(PRINT_JSON, "passive_copper_compliance",
+				  "0x%02x", id[60]);
+			print_string(PRINT_JSON, "passive_copper_compliance_desc",
+				     NULL, compliance_mode_buf);
+		} else {
+			printf("\t%-41s : 0x%02x (%s)\n", "Passive Cu cmplnce.",
+			       id[60], compliance_mode_buf);
+		}
 	} else if (id[8] & (1 << 3)) {
-		printf("\t%-41s : 0x%02x", "Active Cu cmplnce.", id[60]);
 		switch (id[60]) {
 		case 0x00:
-			printf(" (unspecified)");
+			strncpy(compliance_mode_buf, "unspecified", 64);
 			break;
 		case 0x01:
-			printf(" (SFF-8431 appendix E)");
+			strncpy(compliance_mode_buf, "SFF-8431 appendix E", 64);
 			break;
 		case 0x04:
-			printf(" (SFF-8431 limiting)");
+			strncpy(compliance_mode_buf, "SFF-8431 limiting", 64);
 			break;
 		default:
-			printf(" (unknown)");
+			strncpy(compliance_mode_buf, "unknown", 64);
 			break;
 		}
-		printf(" [SFF-8472 rev10.4 only]\n");
+		if (is_json_context()) {
+			print_int(PRINT_JSON, "active_copper_compliance",
+				  "0x%02x", id[60]);
+			print_string(PRINT_JSON, "active_copper_compliance_desc",
+				     NULL, compliance_mode_buf);
+		} else {
+			printf("\t%-41s : 0x%02x (%s)\n", "Active Cu cmplnce.",
+			       id[60], compliance_mode_buf);
+		}
 	} else {
-		printf("\t%-41s : %unm\n", "Laser wavelength",
-		       (id[60] << 8) | id[61]);
+		if (is_json_context())
+			print_int(PRINT_JSON, "laser_wavelength", NULL,
+				  (id[60] << 8) | id[61]);
+		else
+			printf("\t%-41s : %unm\n", "Laser wavelength",
+			       (id[60] << 8) | id[61]);
+
 	}
 }
 
 static void sff8079_show_value_with_unit(const __u8 *id, unsigned int reg,
-					 const char *name, unsigned int mult,
-					 const char *unit)
+					 const char *name, const char *json_name,
+					 unsigned int mult, const char *unit)
 {
 	unsigned int val = id[reg];
 
-	printf("\t%-41s : %u%s\n", name, val * mult, unit);
+	if (is_json_context()) {
+		open_json_object(json_name);
+		print_int(PRINT_JSON, "value", NULL, val*mult);
+		print_string(PRINT_JSON, "unit", NULL, unit);
+		close_json_object();
+	} else {
+		printf("\t%-41s : %u%s\n", name, val * mult, unit);
+	}
 }
 
 static void sff8079_show_ascii(const __u8 *id, unsigned int first_reg,
-			       unsigned int last_reg, const char *name)
+			       unsigned int last_reg, const char *name,
+			       const char *json_name)
 {
-	unsigned int reg, val;
+	unsigned int reg, val, x = 0;
+	char value[64];
 
-	printf("\t%-41s : ", name);
 	while (first_reg <= last_reg && id[last_reg] == ' ')
 		last_reg--;
 	for (reg = first_reg; reg <= last_reg; reg++) {
 		val = id[reg];
-		putchar(((val >= 32) && (val <= 126)) ? val : '_');
+		value[x] = ((val >= 32) && (val <= 126)) ? val : '_';
+		x++;
 	}
-	printf("\n");
+	value[x] = '\0';
+
+	if (is_json_context())
+		print_string(PRINT_JSON, json_name, NULL, value);
+	else
+		printf("\t%-41s : %s\n", name, value);
+}
+
+static void print_option(const char *opt_desc)
+{
+	if (is_json_context())
+		print_string(PRINT_JSON, NULL, NULL, opt_desc);
+	else
+		printf("\t%-41s : %s\n", "Option", opt_desc);
 }
 
 static void sff8079_show_options(const __u8 *id)
 {
-	static const char *pfx =
-		"\tOption                                    :";
+	if (is_json_context()) {
+		print_int(PRINT_JSON, "option_byte1", NULL, id[64]);
+		print_int(PRINT_JSON, "option_byte2", NULL, id[65]);
+		open_json_array("option_descriptions", "");
+	} else {
+		printf("\t%-41s : 0x%02x 0x%02x\n", "Option values", id[64], id[65]);
+	}
 
-	printf("\t%-41s : 0x%02x 0x%02x\n", "Option values", id[64], id[65]);
 	if (id[65] & (1 << 1))
-		printf("%s RX_LOS implemented\n", pfx);
+		print_option("RX_LOS implemented");
 	if (id[65] & (1 << 2))
-		printf("%s RX_LOS implemented, inverted\n", pfx);
+		print_option("RX_LOS implemented, inverted");
 	if (id[65] & (1 << 3))
-		printf("%s TX_FAULT implemented\n", pfx);
+		print_option("TX_FAULT implemented");
 	if (id[65] & (1 << 4))
-		printf("%s TX_DISABLE implemented\n", pfx);
+		print_option("TX_DISABLE implemented");
 	if (id[65] & (1 << 5))
-		printf("%s RATE_SELECT implemented\n", pfx);
+		print_option("RATE_SELECT implemented");
 	if (id[65] & (1 << 6))
-		printf("%s Tunable transmitter technology\n", pfx);
+		print_option("Tunable transmitter technology");
 	if (id[65] & (1 << 7))
-		printf("%s Receiver decision threshold implemented\n", pfx);
+		print_option("Receiver decision threshold implemented");
 	if (id[64] & (1 << 0))
-		printf("%s Linear receiver output implemented\n", pfx);
+		print_option("Linear receiver output implemented");
 	if (id[64] & (1 << 1))
-		printf("%s Power level 2 requirement\n", pfx);
+		print_option("Power level 2 requirement");
 	if (id[64] & (1 << 2))
-		printf("%s Cooled transceiver implemented\n", pfx);
+		print_option("Cooled transceiver implemented");
 	if (id[64] & (1 << 3))
-		printf("%s Retimer or CDR implemented\n", pfx);
+		print_option("Retimer or CDR implemented");
 	if (id[64] & (1 << 4))
-		printf("%s Paging implemented\n", pfx);
+		print_option("Paging implemented");
 	if (id[64] & (1 << 5))
-		printf("%s Power level 3 requirement\n", pfx);
+		print_option("Power level 3 requirement");
+
+	if (is_json_context())
+		close_json_array(NULL);
+
 }
 
 static void sff8079_show_all_common(const __u8 *id)
@@ -423,26 +518,40 @@ static void sff8079_show_all_common(const __u8 *id)
 		sff8079_show_connector(id);
 		sff8079_show_transceiver(id);
 		sff8079_show_encoding(id);
-		printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
+		if (is_json_context())
+			print_int(PRINT_JSON, "bitrate_nominal", NULL, br_nom);
+		else
+			printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
 		sff8079_show_rate_identifier(id);
-		sff8079_show_value_with_unit(id, 14,
-					     "Length (SMF,km)", 1, "km");
-		sff8079_show_value_with_unit(id, 15, "Length (SMF)", 100, "m");
-		sff8079_show_value_with_unit(id, 16, "Length (50um)", 10, "m");
-		sff8079_show_value_with_unit(id, 17,
-					     "Length (62.5um)", 10, "m");
-		sff8079_show_value_with_unit(id, 18, "Length (Copper)", 1, "m");
-		sff8079_show_value_with_unit(id, 19, "Length (OM3)", 10, "m");
+		open_json_object("lengths");
+		sff8079_show_value_with_unit(id, 14, "Length (SMF,km)",
+					     "smf_km", 1, "km");
+		sff8079_show_value_with_unit(id, 15, "Length (SMF)",
+					     "smf", 100, "m");
+		sff8079_show_value_with_unit(id, 16, "Length (50um)",
+					     "50um", 10, "m");
+		sff8079_show_value_with_unit(id, 17, "Length (62.5um)",
+					     "62_5um", 10, "m");
+		sff8079_show_value_with_unit(id, 18, "Length (Copper)",
+					     "copper", 1, "m");
+		sff8079_show_value_with_unit(id, 19, "Length (OM3)",
+					     "om3", 10, "m");
+		close_json_object();
 		sff8079_show_wavelength_or_copper_compliance(id);
-		sff8079_show_ascii(id, 20, 35, "Vendor name");
+		sff8079_show_ascii(id, 20, 35, "Vendor name", "vendor_name");
 		sff8079_show_oui(id);
-		sff8079_show_ascii(id, 40, 55, "Vendor PN");
-		sff8079_show_ascii(id, 56, 59, "Vendor rev");
+		sff8079_show_ascii(id, 40, 55, "Vendor PN", "vendor_pn");
+		sff8079_show_ascii(id, 56, 59, "Vendor rev", "vendor_rev");
 		sff8079_show_options(id);
-		printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
-		printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
-		sff8079_show_ascii(id, 68, 83, "Vendor SN");
-		sff8079_show_ascii(id, 84, 91, "Date code");
+		if (is_json_context()) {
+			print_int(PRINT_JSON, "br_margin_max", NULL, br_max);
+			print_int(PRINT_JSON, "br_margin_min", NULL, br_min);
+		} else {
+			printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
+			printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
+		}
+		sff8079_show_ascii(id, 68, 83, "Vendor SN", "vendor_sn");
+		sff8079_show_ascii(id, 84, 91, "Date code", "date_code");
 	}
 }
 
@@ -485,7 +594,9 @@ int sff8079_show_all_nl(struct cmd_context *ctx)
 	if (ret)
 		goto out;
 
+	new_json_obj(ctx->json);
 	sff8079_show_all_common(buf);
+	close_json_object();
 
 	/* Finish if A2h page is not present */
 	if (!(buf[92] & (1 << 6)))
@@ -500,6 +611,5 @@ int sff8079_show_all_nl(struct cmd_context *ctx)
 	sff8472_show_all(buf);
 out:
 	free(buf);
-
 	return ret;
 }
-- 
2.30.1

