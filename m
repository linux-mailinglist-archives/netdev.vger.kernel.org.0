Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D193DC1D3
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhGaAOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:33 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:14636
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234151AbhGaAOa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYLjxABL80FzU+c8I9ULT/KJqB7nIUKVi3PMJi5ERZFP13MZmOyz9IdAE6cHxQ/XkkCvg54CRiJh3yxcjEZ7KVKLc+CiQRZvumnZWwE4DvKWnOTWri+SmgucIPOrelGoRn+l+p1ectrWXon5RmPBcwIEeTc7OlxRSwcZ754QFPbYoJBdbhLSGfm4R/AzgNPCsVGgB7P5VHuD9A98J5X5Dlz2c3dqi7pL4rAstD5J7q5RNtjutq6w5xwW2stzVE8GVLBBpTxXYwzzsswkjSadACMuPYrIXA77ylycF95Pi7qfHj+hzJ9lz4frppsvvzxE2UES7NIpvFBNE/eMMBSsEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z88dwXqGSe4+Eq09mqFjfLIf7LLcF7Ovf07RHPRzplE=;
 b=aRNeOos4aGR0G1KZi0LQAhL1weovgDwvEXqlIhesKXOtlMQXd2/u84bdC/M42fBmudLGX+r6MDj/kBPBYoV1gdAOnY442IZRyNNrVYV7lYGdG4PD2wqLSZReOKWOjTUfBzLkL3PdnjdsmsUY1j+YD7EAAvyZvsn71/WQOUEVdZfD1WubosHoTXVFWCOPA6OCo4St/nP+UQ7CojPBHaXoDNfPm3hkNjQzmLusxAT6BPXNvLZpua/qvAyCCVWTmpeqdCZr3BFeh+OCRsmSgWQYyr8DDsxSNo792DuuJpuIIhCO4stAlmGKFvf9PElzro1BQ8QZabaH9qvpeAqmkVAP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z88dwXqGSe4+Eq09mqFjfLIf7LLcF7Ovf07RHPRzplE=;
 b=srTJlidOCon5GDWe8gRgRCDLqYyQVhGAmTHeRQGmsH6AiAwhaeJH9e945ZCcnTSzHXVKoh8h83gUMxRuXD4eNWOz8WYTQUUB3u1P0XkChKd0Vb6rhsrG+wL3z92oEPyY7HQ5G7bPoIQ8ylsYHaXOg+px7bfV0CvXBirmJxKgzps=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Sat, 31 Jul
 2021 00:14:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 00/10] NXP SJA1105 driver support for "H" switch topologies
Date:   Sat, 31 Jul 2021 03:13:58 +0300
Message-Id: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6ff8b47-92c6-4a81-5719-08d953b8248b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB585469AE32BD2D38601FB9A7E0ED9@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJ+1O8FQ+sufLOMcGLWRzAJU7RKAfnDxI0dpT+paVPpNgl39TWuv3LWlo/CdvkmkXE9q3QXT9wGSJLnW3E73Q0ncl2A99hyzIC7BLiFt0u34scXO3bdzhUeAANzZXLkzvj3l5IRIp9SsfT+5vm83OVVh7ge/WEJR85EtUnwWupJwUYCuw2i2CBVwm+iTvBJbZvkmpKjgQxhl0c2GuXGxYp8N18UwDTFNFtA83T30IeRozqaDDGZghUfsfKuinHTCTaVsetgrSsvCdiO5noUPk/Q8ZOlY9+YReabwLkqq3mzxyJik0ryOz+n25LQLrY1t9kmgAY3AguRxGy+TPHPmgfM3k1KiGe7/A23b98wVFjh984ZK9RKjzP5Cvkb/XytfJLJ7wi+QPo7iNfMH05iLJZGwq18iOYCWKVcvc/kfMN6t+ruuyNbyZL8XWGE5SXXMeQ4w/MFG6l/oEPzoMpzfQv7adqGGtLhjswbCZsnmebdIdx0ESHRnkz9fvEA5E/JuXr+xZsoOkjjxJTZICC18IWbFPI0LhNt9MHzw6FHEbXaKPvNd5iwfvAQyClqP8R5mt7cIA4CeAzZEmcHVwFoEpYC/sZNw6PZRuoyxvx1E4B0PbQ7y3Wq4aEQyhEmwMs3caB0KjuSs88GYfUi3f+nxnfo+sgPZUxYGL13zzsUKDAa/w2U0dkOAwy4JNrSVFNoo7ISDjrXbNGblCmJZjX+oSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(136003)(376002)(366004)(478600001)(83380400001)(6666004)(110136005)(54906003)(66556008)(2906002)(86362001)(52116002)(38100700002)(36756003)(316002)(66476007)(66946007)(1076003)(38350700002)(44832011)(2616005)(8676002)(5660300002)(6512007)(6506007)(26005)(186003)(6486002)(8936002)(956004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AOpCo8j+R4/z5Czow/eI5Wth65UBn2RGHVCxY2X6ueqZj4dvr/rmunBDcwXu?=
 =?us-ascii?Q?4jGTwaGY14I8NsElgOzd/2Iq4AzC7eNOaicliVlEcvTedQDIvN5gGdecrkNf?=
 =?us-ascii?Q?002Z26vF+93mE0uIacBntUVMrujpJvneQ7B0TYX3oY7oWup8g14/LgVwoSO8?=
 =?us-ascii?Q?EaV7GNrtL5Hv6ykSiYZY7lp6lRSFS0ahmwPBi3zTWJT/3po9++UuQcmHNVHf?=
 =?us-ascii?Q?J9HQEd03NvFnnZvvDSZMWpd0HJMVyPumPlesvYFKU0mys8T8pvxtxRHYIVBe?=
 =?us-ascii?Q?znggy2/IcgxyaDp/fn/6TBVu+CmEtcwBuqVDvHKbXp2zb6ewjRZw5kMLvKao?=
 =?us-ascii?Q?vzWzxOaSu7MLhqgC0TLxRGmEVJZ5g9ENhEgd8Uud0bLJnjZt/728yYYpEz/C?=
 =?us-ascii?Q?lx2vs3GBs7VP2mekLwz8caTjZUfJdDLWYGxE+vcTy4BnQ8+awvs0uzLn+ImJ?=
 =?us-ascii?Q?V950C3/LWP0uxDxRRsYNcmgCSHw8Q6cXklPbBsVCy+y5lCcN/WY7Zgl3IHg7?=
 =?us-ascii?Q?UlINvFrshEeQQ2P6Am80e8FKirnLlYktQTV9TTVd8NCqa89oh6HvTSRTa7ee?=
 =?us-ascii?Q?z/vBzpaUxzbqXgd3x1j8IzfsH9tLMvv+pHeoDk/L/h0bSaVAj4vExrrYub6z?=
 =?us-ascii?Q?HnJuZdol1fZo7O5+3sa89iey4mdo4PNEprf9P/F81nZqJN1Uqvtj8wqRmXvU?=
 =?us-ascii?Q?i2Yab3LnyeqpVkbcy5KVh90vFSCkp5wuJkFlavNXOLosla0hWhpCLT/zPREN?=
 =?us-ascii?Q?hmJMt1zPYErSlOQeX4TxRVBY2UZWoslYtJj4f/8uGog8NfWomuzIsL9EzQUI?=
 =?us-ascii?Q?5tVC+DUNttRPGD9BAWJHtq6MIufpdUENdjpMb5cVqMZItlK78Kvzpa3KeGB6?=
 =?us-ascii?Q?jgqcFdVkXVsfEFEb8kmmHEyTes6OHw8gpJG9df2OQX+FCAohMfCFcwniouoe?=
 =?us-ascii?Q?8jDSjeeZndkjfzNadYA5PfqovEtAOkB6NLArB3dZaE7Y+zGvnJKHpq/OjCf8?=
 =?us-ascii?Q?xUJyUtSRJicmvmOja3p9/ztFzANzAhZY3FN/z+hk2cQV+aQKJlsPTEYcMFp2?=
 =?us-ascii?Q?bYxMHumIqbo8oLd2Uwun6KE8gTrkhDYw/tQypBa96RNzLee6+9UkSgP+XEyC?=
 =?us-ascii?Q?kiSOSWe0xs9TmNvzauYCQ7lxGfEUMEWMDIqDF5S50rLygraEi7wZoitzL2Bb?=
 =?us-ascii?Q?JJxUHyi1GNZRmksW29uQu7yqCKQdAJMfsG9e86V66UE10kiqRQ99n8Q35Jax?=
 =?us-ascii?Q?y6T0zjM9zLkABLQi5QccLRiYaq0zW670hUyHt0prdTGEeKdAWXhJevX79LI2?=
 =?us-ascii?Q?z72peTmTBTANZlf6B8jLeAe2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ff8b47-92c6-4a81-5719-08d953b8248b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:20.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7i72osYNGVDiz30pwBLPXSZldpXyPjNCxslZqIIUhFSU0uAPLxJAiqCwedQ3ZFMsah251q08/DhF9sjqexKEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is nothing more than what it says it is - a request
for feedback.

NXP builds boards like the Bluebox 3 where there are multiple SJA1110
switches connected to an LX2160A, but they are also connected to each
other. I call this topology an "H" tree because of the lateral
connection between switches. A piece extracted from a non-upstream
device tree looks like this:

&spi_bridge {
	/* SW1 */
	ethernet-switch@0 {
		compatible = "nxp,sja1110a";
		reg = <0>;
		spi-max-frequency = <4000000>;
		spi-cpol;
		dsa,member = <0 0>;

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

			/* Microcontroller port */
			port@0 {
				reg = <0>;
				status = "disabled";
			};

			/* SW1_P1 */
			port@1 {
				reg = <1>;
				label = "con_2x20";
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@2 {
				reg = <2>;
				ethernet = <&dpmac17>;
				phy-mode = "rgmii-id";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@3 {
				reg = <3>;
				label = "1ge_p1";
				phy-mode = "rgmii-id";
				phy-handle = <&sw1_mii3_phy>;
			};

			sw1p4: port@4 {
				reg = <4>;
				link = <&sw2p1>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@5 {
				reg = <5>;
				label = "trx1";
				phy-mode = "internal";
				phy-handle = <&sw1_port5_base_t1_phy>;
			};

			port@6 {
				reg = <6>;
				label = "trx2";
				phy-mode = "internal";
				phy-handle = <&sw1_port6_base_t1_phy>;
			};

			port@7 {
				reg = <7>;
				label = "trx3";
				phy-mode = "internal";
				phy-handle = <&sw1_port7_base_t1_phy>;
			};

			port@8 {
				reg = <8>;
				label = "trx4";
				phy-mode = "internal";
				phy-handle = <&sw1_port8_base_t1_phy>;
			};

			port@9 {
				reg = <9>;
				label = "trx5";
				phy-mode = "internal";
				phy-handle = <&sw1_port9_base_t1_phy>;
			};

			port@a {
				reg = <10>;
				label = "trx6";
				phy-mode = "internal";
				phy-handle = <&sw1_port10_base_t1_phy>;
			};
		};

		mdios {
			#address-cells = <1>;
			#size-cells = <0>;

			mdio@0 {
				reg = <0>;
				compatible = "nxp,sja1110-base-t1-mdio";
				#address-cells = <1>;
				#size-cells = <0>;

				sw1_port5_base_t1_phy: ethernet-phy@1 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x1>;
				};

				sw1_port6_base_t1_phy: ethernet-phy@2 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x2>;
				};

				sw1_port7_base_t1_phy: ethernet-phy@3 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x3>;
				};

				sw1_port8_base_t1_phy: ethernet-phy@4 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x4>;
				};

				sw1_port9_base_t1_phy: ethernet-phy@5 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x5>;
				};

				sw1_port10_base_t1_phy: ethernet-phy@6 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x6>;
				};
			};
		};
	};

	/* SW2 */
	ethernet-switch@2 {
		compatible = "nxp,sja1110a";
		reg = <2>;
		spi-max-frequency = <4000000>;
		spi-cpol;
		dsa,member = <0 1>;

		ethernet-ports {
			#address-cells = <1>;
			#size-cells = <0>;

			/* Microcontroller port */
			port@0 {
				reg = <0>;
				status = "disabled";
			};

			sw2p1: port@1 {
				reg = <1>;
				link = <&sw1p4>;
				phy-mode = "sgmii";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@2 {
				reg = <2>;
				ethernet = <&dpmac18>;
				phy-mode = "rgmii-id";

				fixed-link {
					speed = <1000>;
					full-duplex;
				};
			};

			port@3 {
				reg = <3>;
				label = "1ge_p2";
				phy-mode = "rgmii-id";
				phy-handle = <&sw2_mii3_phy>;
			};

			port@4 {
				reg = <4>;
				label = "to_sw3";
				phy-mode = "2500base-x";

				fixed-link {
					speed = <2500>;
					full-duplex;
				};
			};

			port@5 {
				reg = <5>;
				label = "trx7";
				phy-mode = "internal";
				phy-handle = <&sw2_port5_base_t1_phy>;
			};

			port@6 {
				reg = <6>;
				label = "trx8";
				phy-mode = "internal";
				phy-handle = <&sw2_port6_base_t1_phy>;
			};

			port@7 {
				reg = <7>;
				label = "trx9";
				phy-mode = "internal";
				phy-handle = <&sw2_port7_base_t1_phy>;
			};

			port@8 {
				reg = <8>;
				label = "trx10";
				phy-mode = "internal";
				phy-handle = <&sw2_port8_base_t1_phy>;
			};

			port@9 {
				reg = <9>;
				label = "trx11";
				phy-mode = "internal";
				phy-handle = <&sw2_port9_base_t1_phy>;
			};

			port@a {
				reg = <10>;
				label = "trx12";
				phy-mode = "internal";
				phy-handle = <&sw2_port10_base_t1_phy>;
			};
		};

		mdios {
			#address-cells = <1>;
			#size-cells = <0>;

			mdio@0 {
				reg = <0>;
				compatible = "nxp,sja1110-base-t1-mdio";
				#address-cells = <1>;
				#size-cells = <0>;

				sw2_port5_base_t1_phy: ethernet-phy@1 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x1>;
				};

				sw2_port6_base_t1_phy: ethernet-phy@2 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x2>;
				};

				sw2_port7_base_t1_phy: ethernet-phy@3 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x3>;
				};

				sw2_port8_base_t1_phy: ethernet-phy@4 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x4>;
				};

				sw2_port9_base_t1_phy: ethernet-phy@5 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x5>;
				};

				sw2_port10_base_t1_phy: ethernet-phy@6 {
					compatible = "ethernet-phy-ieee802.3-c45";
					reg = <0x6>;
				};
			};
		};
	};
};

Basically it is a single DSA tree with 2 "ethernet" properties, i.e. a
multi-CPU-port system. There is also a DSA link between the switches,
but it is not a daisy chain topology, i.e. there is no "upstream" and
"downstream" switch, the DSA link is only to be used for the bridge data
plane (autonomous forwarding between switches, between the RJ-45 ports
and the automotive Ethernet ports), otherwise all traffic that should
reach the host should do so through the dedicated CPU port of the switch.

Of course, plain forwarding in this topology is bound to create packet
loops. I have thought long and hard about strategies to cut forwarding
in such a way as to prevent loops but also not impede normal operation
of the network on such a system, and I believe I have found a solution
that does work as expected. This relies heavily on DSA's recent ability
to perform RX filtering towards the host by installing MAC addresses as
static FDB entries. Since we have 2 distinct DSA masters, we have 2
distinct MAC addresses, and if the bridge is configured to have its own
MAC address that makes it 3 distinct MAC addresses. The bridge core,
plus the switchdev_handle_fdb_add_to_device() extension, handle each MAC
address by replicating it to each port of the DSA switch tree. So the
end result is that both switch 1 and switch 2 will have static FDB
entries towards their respective CPU ports for the 3 MAC addresses
corresponding to the DSA masters and to the bridge net device (and of
course, towards any station learned on a foreign interface).

So I think the basic design works, and it is basically just as fragile
as any other multi-CPU-port system is bound to be in terms of reliance
on static FDB entries towards the host (if hardware address learning on
the CPU port is to be used, MAC addresses would randomly bounce between
one CPU port and the other otherwise). In fact, I think it is even
better to start DSA's support of multi-CPU-port systems with something
small like the NXP Bluebox 3, because we allow some time for the code
paths like dsa_switch_host_address_match(), which were specifically
designed for it, to break in, and this board needs no user space
configuration of CPU ports, like static assignments between user and CPU
ports, or bonding between the CPU ports/DSA masters.

Part 2 of the request for feedback has to do with patch 10, which in an
attempt to lock down the system a bit more, has uncovered some interesting
design questions in DSA's overall integration with the network stack,
like what to do if user space attempts to craft packets directly over a
DSA master. Should we proactively do something to prevent TX? Should we
do something about RX? But RX is useful, think tcpdump.

Vladimir Oltean (10):
  net: dsa: rename teardown_default_cpu to teardown_cpu_ports
  net: dsa: give preference to local CPU ports
  net: dsa: sja1105: configure the cascade ports based on topology
  net: dsa: sja1105: manage the forwarding domain towards DSA ports
  net: dsa: sja1105: manage VLANs on cascade ports
  net: dsa: sja1105: suppress TX packets from looping back in "H"
    topologies
  net: dsa: sja1105: prevent tag_8021q VLANs from being received on user
    ports
  net: dsa: sja1105: increase MTU to account for VLAN header on DSA
    ports
  net: dsa: sja1105: enable address learning on cascade ports
  net: dsa: sja1105: drop untagged packets on the CPU and DSA ports

 drivers/net/dsa/sja1105/sja1105_main.c | 274 +++++++++++++++++++------
 include/linux/dsa/sja1105.h            |   2 +
 net/dsa/dsa2.c                         |  47 ++++-
 net/dsa/tag_sja1105.c                  |  41 +++-
 4 files changed, 289 insertions(+), 75 deletions(-)

-- 
2.25.1

