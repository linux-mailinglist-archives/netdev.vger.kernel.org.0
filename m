Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608D262E9F9
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiKRACh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbiKRACQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:16 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7989382210
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INNbVLgvhqpv8+6mJ2bj/1ZFJBZPO/ySPR7dVGYh+CJVWjhoWj9rSAqjWeO9+14MkYQtqIeXd0nlaKwCMku4kpeYGnvJJxF/ZY0KjPfzR+VZiQ9wQbpicKGRHf9/HuYoPqb/AsdZ+omtc7xr4HEBGFXL3+WWeVJmTHgsqfpLG7NV373+skwnOPEGAJVUhPaCzcEjxzQ52LktDJOTpFMGVoi8HUHCWloPkNuk6vFJESYI4Q9QMfWILQmgXcxYnCvrPfZrWd9sHNA8uFpQWvkd2uJ+964yDbVtJyTT9hTg3iu73ZumWqsPAsIap7J2pRquBNtrD6MF/W/o4la0C1NmVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d98lzkpGhp0QenrHW8ucPX1119el6MMPyrH9jsJC284=;
 b=Z9WJGZqgcMu17hqf8VpRRs1U6xTLrXBqh+gqLA+WxMEHxbwCCSjaQUq3vlqucLb/aj9HAMa8WdJBKG3SA2NFNlTus6FLzWrgvuoJONriJche5xVo85qCIp4v3MIya8ObQW3BRolIfXcVZJH5MCdI+CH653ScNqTQ+E3zMDVyJj7v2fNdEiqYlU5YYsVIpBh7sODLKdJft+Ip5UU7ead4HJHkAO67jC0vS0g1Ff0cmKhMNDzW+SU86Gb9GZ2lTABStVVIyuMcgWufzWIwDepBnhyHvCksRR4VIqRXG7PjFNsy+8iVC320yaeLZoBUj0Rb3lOC50RupqMnVAHbnMrmjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d98lzkpGhp0QenrHW8ucPX1119el6MMPyrH9jsJC284=;
 b=MLpC1C5EVpGMzD5qKpJAgY1u+xHRrxXkRbFgPFpYit/KhSzPmHHQI8OTdS65mr4P4WW04tvft9ryjbcfwEFyZB6joZamyHE5ON0RU6xovgcCTuqdOGXs2UtFgtTxpf+gDQxC8nLH02ZOMKlF/hDyZBaMBfSb2B/oQ7OKD5rokCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 4/8] net: phylink: add option to sync in-band autoneg setting between PCS and PHY
Date:   Fri, 18 Nov 2022 02:01:20 +0200
Message-Id: <20221118000124.2754581-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dea0ee1-eacf-4aa6-4cc2-08dac8f82350
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzfYNySVAD5lY8Hgax3z7e57DWvJovkFpbg2DTA8QozTfVQHizXzjUJBAukz0n3q782ok84C30socka2WStUh0yTasbe23sXUXRNsecAKnIQV9L8uZiyPK/NUu5LYyeHbuPvZnfcQvv2vzzhZYlmMYHwfrSiXYgyp+LYKc+lo3LkyGngFNjHZ8BFdbJmh2pO7YP7WbHdrC8QjYcaOztAHkF3iUt4F119USeMzDbBbQ3JgXf+mvk+xYkv6W7jwmhcOdm9Z9Fvn6BEkMU7UUFBBHumrV+DxmGFDLZEVD1c3hoNeTLnrcb9YJlhCrqvs8I1PjQVSu/nsD4ZicBeyq4N685ABC7F6fERprZTqqCt6e5S8flVSle7ZNuYj4fIraMK2YmVpqFz1YjZJ4eI9d4IwsieQNhYZ9aXgS1W3TrNBsACUPU+WTUghj12t2r1XGiXWFdtBIbq6dWVHuhZ4UQdthyUSg8UemyrrYlMjciRHIET+Gn/7agNNZk1NyV1YGubatIWH9zAuzbcXGoz5x9C/TX0ZwDYXy3bEqQogS3TaMBG5HIIpBEXPMuNxP2JWDb0dbeJlzaCh9P8GML2c6ZXplrsCBuHEAHUKKkAEkh2Ur5OIlOktztWxYvQdh3c5IQ3sdw/Y9GIDO+xqXXiD5xgAFrbOtDsxPmzj0tK81zCH0uJzKEbmNTCMqbw0N11Km2STIM+KOsAeH6FrGN2n0FRIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3L0gIIBHRYPor5pmgyKnRHJIzyqHzxBncjv9p4Fw+53J1aOhHm1JN27I9zJF?=
 =?us-ascii?Q?2nU4MVkHFJgl7uGRWRnLMttQpxJRYsf8fl5XOlhvbSqddPvT9pizOfCyORvX?=
 =?us-ascii?Q?93HSZsIgN9qrMnjXBL/NHoU8UTFprj886HvrrxmlKIftFEHg3QqGAITN7+7o?=
 =?us-ascii?Q?0I6WDZpgnrQPsPbyrpj80taMQNqEURuufOjUkU4CzTlA++e3uxc71kPcAh4I?=
 =?us-ascii?Q?SBWYmDLI1J8fsy+D5h6CZCfqnmFzgDIVKsvpN4YnKJZfVH3NwxZBTO5DEPra?=
 =?us-ascii?Q?NfcgN+mj434zijASNm247xfCx0lRj1yln+lmfJ+LUEtHo+t23YZ2BzMJHhKK?=
 =?us-ascii?Q?X+m/f+qj/qaqiXlPHw035KMEi+sB0YzAq/LQBPhBSM/8PiFLqB0ixmNEmQXU?=
 =?us-ascii?Q?DWrbWlqmcTlWEBErH/lfi8AHO/Eq+Oc760JfJq5/LwRDJmaYMBdHkSUiviI9?=
 =?us-ascii?Q?UB6XejocSFCCiRGVDErgpLxOmAqArCPH1vD+xfwwzjb3/xV8iDjR3lPgXNyO?=
 =?us-ascii?Q?PT+k1/UhaC551+W3HcCeKe0R7Q8D+wTygjpniFuMDeEXzFqYEiKlHFm556Pa?=
 =?us-ascii?Q?5qbOcVQNL/e/MigOXDR03EaEr139FY7cV4lceGkxizCMsPQc31t03P0f7Ddx?=
 =?us-ascii?Q?s29V1yU9vYwHNUqLgNaV+DxVyoKIpbhPUl4vuT7GCVwfvS70w9K8L0ZO/SG7?=
 =?us-ascii?Q?pomquF2htsOBnm9z4PD/yNBTvIcC6sHbtdgOnUI7BQmzJCutLmRXzwsz9mWp?=
 =?us-ascii?Q?BNOIU9x7uWVf7ShRn87DaHgRm5jepaa9Xc4gYqXFZnqLvXHwuRZoBYCzzyZI?=
 =?us-ascii?Q?3y61Jw2AWlKDTjTmuzuW+RX7aFi684K09V6NSWME3SJMH+ysf1vJX/XxyZLa?=
 =?us-ascii?Q?Mov70LHk8H/MjjJq3pmMC4rcxDXUDCdq6MzSzIC//Q+1nVZDdZerCq0lemI2?=
 =?us-ascii?Q?W1snuood7oGQZS+0wm5D4Ux9d4odTQ93MxRxoz1AxVxDC3PO7ImfxWxeym66?=
 =?us-ascii?Q?KBaUMON4eOltldGOM+ODxhKRh1kXdEw+HWIYn06VxtMMgpUOb/zFqmCa7MFw?=
 =?us-ascii?Q?WU80HcInyLS4eudtX4kfK+LJSKQKtyDUqggS+n3FmdeLp05V+NwLvIsaaqgn?=
 =?us-ascii?Q?DzxXgRIh03O3/eOPacSxa26/zJtjGfZVEjDGoUTuXHwSVNAcQh93JeOsUqZ8?=
 =?us-ascii?Q?xl4nQcNorpRFylxTkfz+Vylq1K3ADn25chhjrq9COudeK2A1n+Gax5VSg3g5?=
 =?us-ascii?Q?qA+HGXWLrR3i0BlHQuTv3CTG886xvHKrogqa/+qFS9xQOar9/BCIpeVYLX1J?=
 =?us-ascii?Q?7YYolDu/x5yIUA1qjKNPhDxOphic04n/R99eI7B3f9ToWGetTY3xD/MNIRcD?=
 =?us-ascii?Q?y2+nVpVKYjTPdEIRrGNSVhUk5O/DBxj2p821ob/96Tm04A7MQUQlfvdkqoa/?=
 =?us-ascii?Q?39nzhQasYwpayQiN4sdpJAhjZ+Q0RxQ0nyd8FWcTdRIdYzmah/YRB5IvASFp?=
 =?us-ascii?Q?wpPJju8PUKWDGSgkWt0zPYxLOLoO1ocP5eEqxbo0PLa31sbm6tqF+XbVCnUK?=
 =?us-ascii?Q?BcrpDWUic9g7uC69I3+fESQE+RFMvc6zyl41wXXdTlT1g7ysvOpzYKEwO2Go?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dea0ee1-eacf-4aa6-4cc2-08dac8f82350
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:09.8599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rz7Owsnw+Ol7prAuii3SbiEYfTmi5PaHUJxBj9AzBR2s+cjpfAWMQeR0d5bZ9QjHJQgtparPGQWvW9g6HyT4Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the case of an on-board PHY (not on SFP module), phylink parses the
'managed = "in-band-status"' property (which may or may not be present
in addition to the 'phy-handle' property), and based on this, selects
pl->cfg_link_an_mode to be MLO_AN_PHY or MLO_AN_INBAND.

Drivers which make use of phylink can use MLO_AN_PHY as an indication to
disable in-band autoneg when connected to an on-board PHY, and
MLO_AN_INBAND to enable it. That's what most of the drivers seem to do,
except macb_mac_config() which seems to always force in-band autoneg
except for MLO_AN_FIXED.

If one assumes purely Clause 37 compatible state machines in the
PHY-side PCS and in the MAC-side PCS, then in-band autoneg needs to be
enabled in both places, or disabled in both places, to establish a
successful system-side link. The exception seems to be mvneta, which has
a hardware-based fallback on no-inband when inband autoneg was enabled
but failed. Nonetheless, this is not a generally available feature.

While in the case of an SFP module, in-band autoneg is genuinely useful
in passing the link information through the Ethernet channel when we
lack an I2C/MDIO side channel, in the case of on-board PHYs it is
perhaps less so. Nonetheless, settings must be in sync for a functional
link.

There is currently a lack of information within the kernel as to whether
in-band autoneg should be used between a certain MAC and PHY. We rely on
the fwnode specification for this.

Most of the platforms are seemingly okay with the status quo, but there
are 2 real life scenarios where it has limitations:

- A driver recently converted from phylib to phylink. The device trees
  in circulation will not have the 'managed' property (since it's
  phylink specific), but some PHYs will require in-band autoneg enabled
  in the MAC-side PCS to work with them.

- The PHY in-band autoneg setting is not really fixed but configurable,
  and therefore, the property should not really belong to device tree.
  Matters are made worse when PHY drivers in bootloaders (U-Boot) also
  enable/disable this setting, and this can cause what is specified in
  the device tree to be out of sync with reality. Linux PHY drivers do
  not currently configure in-band autoneg according to the 'managed'
  property of the attached MAC.

This change introduces a new opt-in feature called sync_an_inband which
may override the in-band autoneg setting passed to phylink callbacks,
but not to 'true' as ovr_an_inband does, but rather to what the PHY
reports as supported (with a fallback to what was in the device tree, if
the PHY driver reports nothing).

It's quite possible that one more call to phylink_sync_inband_aneg() is
needed when the PHY changes its pl->phy_state.interface and this results
in a change to pl->link_config.interface. This is the
phylink_major_config() code path, and if the PHY has different in-band
autoneg requirements for the new SERDES protocol, we are currently not
informed about those. Unfortunately I don't have access to any board
which supports SERDES protocol change of an on-board PHY, and I don't
know without testing where that extra sync call should be put, so I
haven't put it anywhere.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- split the on-board PHY part out of previous patch 2/6 which combines them
- phylink_fixup_inband_aneg() renamed to phylink_sync_an_inband()
- opt-in via phylink_config :: sync_an_inband
- look at pl->link_config.interface rather than pl->link_interface
- clearer comments, add kerneldocs

 drivers/net/phy/phylink.c | 49 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  7 ++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index bf2a5ebfc4f4..598f5feb661e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -156,6 +156,45 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+/**
+ * phylink_sync_an_inband() - Sync in-band autoneg between PCS and PHY
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @phy: a pointer to a &struct phy_device
+ *
+ * Query the in-band autoneg capability of an on-board PHY in an attempt to
+ * sync the PCS-side link autoneg mode with the PHY autoneg mode. Set the
+ * current link autoneg mode to the mode configured through the fwnode if the
+ * PHY supports it or if its capabilities are unknown, or to an alternative
+ * mode that the PHY can operate in.
+ */
+static void phylink_sync_an_inband(struct phylink *pl, struct phy_device *phy)
+{
+	unsigned int mode = pl->cfg_link_an_mode;
+	int ret;
+
+	if (!pl->config->sync_an_inband)
+		return;
+
+	ret = phy_validate_an_inband(phy, pl->link_config.interface);
+	if (ret == PHY_AN_INBAND_UNKNOWN) {
+		phylink_dbg(pl,
+			    "PHY driver does not report in-band autoneg capability, assuming %s\n",
+			    phylink_autoneg_inband(mode) ? "true" : "false");
+	} else if (phylink_autoneg_inband(mode) && !(ret & PHY_AN_INBAND_ON)) {
+		phylink_err(pl,
+			    "Requested in-band autoneg but driver does not support this, disabling it.\n");
+
+		mode = MLO_AN_PHY;
+	} else if (!phylink_autoneg_inband(mode) && !(ret & PHY_AN_INBAND_OFF)) {
+		phylink_dbg(pl,
+			    "PHY driver requests in-band autoneg, force-enabling it.\n");
+
+		mode = MLO_AN_INBAND;
+	}
+
+	pl->cur_link_an_mode = mode;
+}
+
 /**
  * phylink_interface_max_speed() - get the maximum speed of a phy interface
  * @interface: phy interface mode defined by &typedef phy_interface_t
@@ -1475,6 +1514,12 @@ struct phylink *phylink_create(struct phylink_config *config,
 	struct phylink *pl;
 	int ret;
 
+	if (config->ovr_an_inband && config->sync_an_inband) {
+		dev_err(config->dev,
+			"phylink: error: ovr_an_inband and sync_an_inband cannot be used simultaneously\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (mac_ops->mac_select_pcs &&
 	    mac_ops->mac_select_pcs(config, PHY_INTERFACE_MODE_NA) !=
 	      ERR_PTR(-EOPNOTSUPP))
@@ -1725,6 +1770,8 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
 		pl->link_config.interface = pl->link_interface;
 	}
 
+	phylink_sync_an_inband(pl, phy);
+
 	ret = phylink_attach_phy(pl, phy, pl->link_interface);
 	if (ret < 0)
 		return ret;
@@ -1800,6 +1847,8 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 		pl->link_config.interface = pl->link_interface;
 	}
 
+	phylink_sync_an_inband(pl, phy_dev);
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index c492c26202b5..d4b931bdfdfe 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -124,6 +124,12 @@ enum phylink_op_type {
  *		      if MAC link is at %MLO_AN_FIXED mode.
  * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
+ * @sync_an_inband: if true, select between %MLO_AN_INBAND and %MLO_AN_PHY
+ *		    according to the capability of the attached on-board PHY
+ *		    (if both modes are supported, the mode deduced from the
+ *		    fwnode specification is used). With PHYs on SFP modules,
+ *		    the automatic selection takes place regardless of this
+ *		    setting. Mutually exclusive with &ovr_an_inband.
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
  * @supported_interfaces: bitmap describing which PHY_INTERFACE_MODE_xxx
@@ -137,6 +143,7 @@ struct phylink_config {
 	bool poll_fixed_state;
 	bool mac_managed_pm;
 	bool ovr_an_inband;
+	bool sync_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
 	DECLARE_PHY_INTERFACE_MASK(supported_interfaces);
-- 
2.34.1

