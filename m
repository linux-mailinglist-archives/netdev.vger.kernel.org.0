Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8DA2EF017
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbhAHJwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:52:47 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:44182 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbhAHJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:52:46 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102]) by mx-outbound44-209.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 08 Jan 2021 09:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJLdYMvfUVP+zP1xkWTCKLY+uVo5m9VNW5O6mvdG0kcYwE1FvBRqSHVwk25evlhEJWgk+q1GfDTlANsuYLCsrLjUZdElsYRnOXYuWOfSRfuECCAHOqNQgpIGoNyzWvlnB3Oyp+wPLCjznIvyzuRxZ7GIWpv5xzjlMllK8ZCEsZ92XsQICM7lFc8exOTr4h+eis6R2COpI798/kzaT9dMfgwaLftEGdAX1QJDN7Qu7AGMzF0YHnehNVKFIWezfIqH7VIAgnv7jRkKOlUszeJJ7aUKaHNceCQeGjaF1T4IKXpxn1RAszVnBUS0xJCp/Sg/Mwk5fxUaBWirzRCRaqrdwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4K9WEUnDD4RPP2XKZZ2r5b7OHqczwV6PTSXnCAGC3U=;
 b=SyDOUuKqU7Bu5d/qDaVfGn1o35LvT1S52d30Oays0eXDxVOsUjwujIPIn/tTeOjnQq7wA+jCwPKrPNcsFt3kfxvSLXL7MakzCyvlIsz5Ksk0sJs6TBCqGhfK+Hs0CG/XJosgWkJkNHZI8ls5lGmi8kRMagNvtFGbG/nDhyzXl+8PqI/6Kzd3/674XCpl3hCMKQiydW9wVOUlh1CqMVeoK9qlbf0vXxmqe/POYQxAs1AJufX9DvXq9RATqTngYC75RfA3kJ9RcbrWs7yTJeaCppVzFPJ4q0muI/jM6DZXSFuNQs/E5Rh951PEzsgXd7vRhEVpGKpXIDU+gq+Az+1vuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4K9WEUnDD4RPP2XKZZ2r5b7OHqczwV6PTSXnCAGC3U=;
 b=jnjyPDQOkMrykZ9qlKuKEp7Ox3qf44dvkkgwxVRGC3F6NbZzPAnFRjbswYrKlrcJ5BgPArdcdPy6ugdtzFzEveoY7kF59i992xc/b+0iU3hxQPIpL/LyoJLWB/t/2KGLj94aBRtwknojJzGAO3SIRaY5vVDmANv1KVRA3mDQWBM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
Received: from PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:51:27 +0000
Received: from PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e]) by PH0PR10MB4693.namprd10.prod.outlook.com
 ([fe80::4060:f3f0:5449:c60e%7]) with mapi id 15.20.3742.009; Fri, 8 Jan 2021
 09:51:27 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     kabel@kernel.org
CC:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [net-next PATCH v13 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell
Date:   Fri,  8 Jan 2021 19:50:56 +1000
Message-ID: <0044dda2a5d1d03494ff753ee14ed4268f653e9c.1610071984.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1610071984.git.pavana.sharma@digi.com>
References: <cover.1610071984.git.pavana.sharma@digi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [203.194.46.17]
X-ClientProxiedBy: SYAPR01CA0034.ausprd01.prod.outlook.com (2603:10c6:1:1::22)
 To PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (203.194.46.17) by SYAPR01CA0034.ausprd01.prod.outlook.com (2603:10c6:1:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 09:51:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e891d093-317d-45be-d87c-08d8b3baf7e4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4789E8D7482D572992FD19DF95AE0@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gxzB8qOci5aec2ap0/jX6HaC03LDSs7BwAF6aupIp9SOhWahGgiZlYQxchY45BDvuU9nUUaIMcooWB8KWnyOAxYoUBZq7jCLvdAmZiUB7Gyo5GV8fS04xKa00oZrMBaKzIrcn01Z3L+hoJNMh8ECUSdla0HNSvCC6LL4JC7QzTxqOlG0qyMyVq4k9e9FIQrXyJ0Qe8FjI4IcZMapWeREDTn5EG7bzyreAvF27NuXARSDRsuKnLdE+XL88CyH/5rPPE323mRR3jk1bBWcNGc2nhSYFye/Zt9z53I1KHFkRcU8oBGPsR3ysIyu/GuBwA7TnXbBNX6zvJ+vDe7+rslhb+G5llGtCFJEEbhrSiHiTtH0K1ODpW7PQ+OaXbd2NzjxLX4z29rN5Kt8j8DhU4/DEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4693.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39850400004)(346002)(2616005)(16526019)(956004)(186003)(6666004)(6506007)(36756003)(26005)(4326008)(6512007)(66574015)(30864003)(6486002)(44832011)(83380400001)(5660300002)(66946007)(66476007)(66556008)(6916009)(316002)(86362001)(2906002)(8676002)(8936002)(52116002)(478600001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qGJehaU6X92WZNfo2wtKcSt+qtn8c8u0rNAI+tsh/4bAqz6A88yCr/IEZsol?=
 =?us-ascii?Q?MBdUBbgoxJ6ZU04Nava9tavEiAwr4SGXxvarcPsF39h0S7duee8X3w/Y4jJJ?=
 =?us-ascii?Q?HlduUTvnr4d7R/TxMF/eb3FfiyLwokK0wLGgC7taQzpjFUjJkwd2L3gs0pO7?=
 =?us-ascii?Q?Vl185xSr3Ic60m91prsmtIwCFY2kAPXHRh5ntFGbhwnMfB7523niLyHS8Uq9?=
 =?us-ascii?Q?EhDuN8aMgJEGhDrCtzeYO/AUO/rheGoHjbvOOVYIIce9zl3PvJJvtkas2Abj?=
 =?us-ascii?Q?Ub8yxsnZwFou8dSt6UjJDJPNgAZa06zD5oLS39nHLDF1Tmm6N1LoaNk15bGN?=
 =?us-ascii?Q?cBE/VsRlGzVB/qPzLuxjtxNws9DCFuJhMqGAz9P/0Szy5BYw9/9kHF9KLth5?=
 =?us-ascii?Q?Oj9GmfBpkW4Gl74TsbkJJaN8dq57B+h3fpc/DpM8nhvtvjsEfA6/OkJULJze?=
 =?us-ascii?Q?u+0Lb8/ZFX2Ui6jOwfjMJvAIhYbJhZS7QK5w/UYFahPGN6MTJCJIsfC01XSJ?=
 =?us-ascii?Q?jIr0Oez2EAeMNQce5YApbr7fJXZFVT88rIgTuPkXrwDiwSQT9Csen4dwllH5?=
 =?us-ascii?Q?DvtI1YG7/W4euqYIAv8phfstlMz2VY7jC8XDE3eYBoYJxObWXAiaM82tW0xZ?=
 =?us-ascii?Q?1aUQ+lTLwKGZJAHbkRfNn5luYyY875kDneHsPsbqGpqptkaEBMYxLe+20dy1?=
 =?us-ascii?Q?s3J+oM3dpwXD5sqkMiMY8GopA2g6vkz1/EHDvlsl2CWdcPTbGx4HGXNKe7Pp?=
 =?us-ascii?Q?P+WFZIyJ8/gVLBtAKFFQk6EW21yhBpckfVB90bqaUpH9/NEa0OJ4Qw0tT26z?=
 =?us-ascii?Q?8FTdQ0upgF88jXtgX3sd3U1gQToWkkWG4Dk2vX4G8TOuo8rigun4hXVZLqvS?=
 =?us-ascii?Q?lQycJI8xEe6TRazQXGe031Lk3okspd8BnBobQOwJdYd6YCiEcz6cvx1Sxz+b?=
 =?us-ascii?Q?/T2PdVsvc6dhImLctxzUK6h961lhg2PhFOWjs0Uo5I2z1SlThAsEo0sKgozd?=
 =?us-ascii?Q?VhTF?=
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4693.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:51:27.5720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-Network-Message-Id: e891d093-317d-45be-d87c-08d8b3baf7e4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uaVvcY07eohoAWrsIawQYctloS1u4PpFrfDNN6iANNjbGTXF0EDNLb56E0ifCJXNfi8WLyXdbPWPST/OHdp65A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-BESS-ID: 1610099440-111473-5637-28430-2
X-BESS-VER: 2019.1_20210107.2235
X-BESS-Apparent-Source-IP: 104.47.70.102
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.229399 [from 
        cloudscan12-62.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.50 BSF_RULE7568M          META: Custom Rule 7568M 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Marvell 88E6393X device is a single-chip integration of a 11-port
Ethernet switch with eight integrated Gigabit Ethernet (GbE) transceivers
and three 10-Gigabit interfaces.

This patch adds functionalities specific to mv88e6393x family (88E6393X,
88E6193X and 88E6191X)

Co-developed-by: Marek Beh=C3=BAn <kabel@kernel.org>
Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
Co-developed-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
Signed-off-by: Ashkan Boldaji <ashkan.boldaji@digi.com>
Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
Changes in v2:
  - Fix a warning (Reported-by: kernel test robot <lkp@intel.com>)
Changes in v3:
  - Fix 'unused function' warning
Changes in v4-v9:
  - Incorporated feedback from maintainers.
Changes in v10:
  - Fix ISO C90 forbids mixing declarations and code warning
Changes in v11:
  - Add comment for clarity, regarding configuring speed 5000 (supported
    by mv88e6393x family)
Changes in v12:
  - Rebase to net-next
  - Remove 5GBASE-R comments from patch 1 & 2 of this patchset
  - Make function name to the convention
Changes in v13:
  - Rebase to latest.
  - Pick-up Marek's patch to fix SERDES IRQ enablement and
	status reading for 10G on 6393x.
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 136 ++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |   4 +
 drivers/net/dsa/mv88e6xxx/global1.h |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h |   8 +
 drivers/net/dsa/mv88e6xxx/port.c    | 230 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  43 +++-
 drivers/net/dsa/mv88e6xxx/serdes.c  | 319 ++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h  |  44 ++++
 8 files changed, 784 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/c=
hip.c
index 9bddd70449c6..ab929d9d93f3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -635,6 +635,24 @@ static void mv88e6390x_phylink_validate(struct mv88e6x=
xx_chip *chip, int port,
 	mv88e6390_phylink_validate(chip, port, mask, state);
 }
=20
+static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int p=
ort,
+					unsigned long *mask,
+					struct phylink_link_state *state)
+{
+	if (port =3D=3D 0 || port =3D=3D 9 || port =3D=3D 10) {
+		phylink_set(mask, 10000baseT_Full);
+		phylink_set(mask, 10000baseKR_Full);
+		phylink_set(mask, 5000baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+		phylink_set(mask, 2500baseT_Full);
+	}
+
+	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseX_Full);
+
+	mv88e6065_phylink_validate(chip, port, mask, state);
+}
+
 static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 			       unsigned long *supported,
 			       struct phylink_link_state *state)
@@ -3944,6 +3962,55 @@ static const struct mv88e6xxx_ops mv88e6191_ops =3D =
{
 	.phylink_validate =3D mv88e6390_phylink_validate,
 };
=20
+static const struct mv88e6xxx_ops mv88e6393x_ops =3D {
+	/* MV88E6XXX_FAMILY_6393 */
+	.setup_errata =3D mv88e6393x_serdes_setup_errata,
+	.irl_init_all =3D mv88e6390_g2_irl_init_all,
+	.get_eeprom =3D mv88e6xxx_g2_get_eeprom8,
+	.set_eeprom =3D mv88e6xxx_g2_set_eeprom8,
+	.set_switch_mac =3D mv88e6xxx_g2_set_switch_mac,
+	.phy_read =3D mv88e6xxx_g2_smi_phy_read,
+	.phy_write =3D mv88e6xxx_g2_smi_phy_write,
+	.port_set_link =3D mv88e6xxx_port_set_link,
+	.port_set_speed_duplex =3D mv88e6393x_port_set_speed_duplex,
+	.port_set_rgmii_delay =3D mv88e6390_port_set_rgmii_delay,
+	.port_tag_remap =3D mv88e6390_port_tag_remap,
+	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
+	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
+	.port_set_ether_type =3D mv88e6393x_port_set_ether_type,
+	.port_set_jumbo_size =3D mv88e6165_port_set_jumbo_size,
+	.port_egress_rate_limiting =3D mv88e6097_port_egress_rate_limiting,
+	.port_pause_limit =3D mv88e6390_port_pause_limit,
+	.port_set_cmode =3D mv88e6393x_port_set_cmode,
+	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
+	.port_disable_pri_override =3D mv88e6xxx_port_disable_pri_override,
+	.port_get_cmode =3D mv88e6352_port_get_cmode,
+	.stats_snapshot =3D mv88e6390_g1_stats_snapshot,
+	.stats_set_histogram =3D mv88e6390_g1_stats_set_histogram,
+	.stats_get_sset_count =3D mv88e6320_stats_get_sset_count,
+	.stats_get_strings =3D mv88e6320_stats_get_strings,
+	.stats_get_stats =3D mv88e6390_stats_get_stats,
+	.set_cpu_port =3D mv88e6393x_port_set_cpu_dest,
+	.set_egress_port =3D mv88e6393x_set_egress_port,
+	.watchdog_ops =3D &mv88e6390_watchdog_ops,
+	.mgmt_rsvd2cpu =3D mv88e6393x_port_mgmt_rsvd2cpu,
+	.pot_clear =3D mv88e6xxx_g2_pot_clear,
+	.reset =3D mv88e6352_g1_reset,
+	.rmu_disable =3D mv88e6390_g1_rmu_disable,
+	.vtu_getnext =3D mv88e6390_g1_vtu_getnext,
+	.vtu_loadpurge =3D mv88e6390_g1_vtu_loadpurge,
+	.serdes_power =3D mv88e6393x_serdes_power,
+	.serdes_get_lane =3D mv88e6393x_serdes_get_lane,
+	.serdes_pcs_get_state =3D mv88e6393x_serdes_pcs_get_state,
+	.serdes_irq_mapping =3D mv88e6390_serdes_irq_mapping,
+	.serdes_irq_enable =3D mv88e6393x_serdes_irq_enable,
+	.serdes_irq_status =3D mv88e6393x_serdes_irq_status,
+	.gpio_ops =3D &mv88e6352_gpio_ops,
+	.avb_ops =3D &mv88e6390_avb_ops,
+	.ptp_ops =3D &mv88e6352_ptp_ops,
+	.phylink_validate =3D mv88e6393x_phylink_validate,
+};
+
 static const struct mv88e6xxx_ops mv88e6240_ops =3D {
 	/* MV88E6XXX_FAMILY_6352 */
 	.ieee_pri_map =3D mv88e6085_g1_ieee_pri_map,
@@ -4887,6 +4954,52 @@ static const struct mv88e6xxx_info mv88e6xxx_table[]=
 =3D {
 		.ops =3D &mv88e6191_ops,
 	},
=20
+	[MV88E6191X] =3D {
+		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6191X,
+		.family =3D MV88E6XXX_FAMILY_6393,
+		.name =3D "Marvell 88E6191X",
+		.num_databases =3D 4096,
+		.num_ports =3D 11,	/* 10 + Z80 */
+		.num_internal_phys =3D 9,
+		.max_vid =3D 8191,
+		.port_base_addr =3D 0x0,
+		.phy_base_addr =3D 0x0,
+		.global1_addr =3D 0x1b,
+		.global2_addr =3D 0x1c,
+		.age_time_coeff =3D 3750,
+		.g1_irqs =3D 10,
+		.g2_irqs =3D 14,
+		.atu_move_port_mask =3D 0x1f,
+		.pvt =3D true,
+		.multi_chip =3D true,
+		.tag_protocol =3D DSA_TAG_PROTO_DSA,
+		.ptp_support =3D true,
+		.ops =3D &mv88e6393x_ops,
+	},
+
+	[MV88E6193X] =3D {
+		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6193X,
+		.family =3D MV88E6XXX_FAMILY_6393,
+		.name =3D "Marvell 88E6193X",
+		.num_databases =3D 4096,
+		.num_ports =3D 11,	/* 10 + Z80 */
+		.num_internal_phys =3D 9,
+		.max_vid =3D 8191,
+		.port_base_addr =3D 0x0,
+		.phy_base_addr =3D 0x0,
+		.global1_addr =3D 0x1b,
+		.global2_addr =3D 0x1c,
+		.age_time_coeff =3D 3750,
+		.g1_irqs =3D 10,
+		.g2_irqs =3D 14,
+		.atu_move_port_mask =3D 0x1f,
+		.pvt =3D true,
+		.multi_chip =3D true,
+		.tag_protocol =3D DSA_TAG_PROTO_DSA,
+		.ptp_support =3D true,
+		.ops =3D &mv88e6393x_ops,
+	},
+
 	[MV88E6220] =3D {
 		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6220,
 		.family =3D MV88E6XXX_FAMILY_6250,
@@ -5177,6 +5290,29 @@ static const struct mv88e6xxx_info mv88e6xxx_table[]=
 =3D {
 		.ptp_support =3D true,
 		.ops =3D &mv88e6390x_ops,
 	},
+
+	[MV88E6393X] =3D {
+		.prod_num =3D MV88E6XXX_PORT_SWITCH_ID_PROD_6393X,
+		.family =3D MV88E6XXX_FAMILY_6393,
+		.name =3D "Marvell 88E6393X",
+		.num_databases =3D 4096,
+		.num_ports =3D 11,	/* 10 + Z80 */
+		.num_internal_phys =3D 9,
+		.max_vid =3D 8191,
+		.port_base_addr =3D 0x0,
+		.phy_base_addr =3D 0x0,
+		.global1_addr =3D 0x1b,
+		.global2_addr =3D 0x1c,
+		.age_time_coeff =3D 3750,
+		.g1_irqs =3D 10,
+		.g2_irqs =3D 14,
+		.atu_move_port_mask =3D 0x1f,
+		.pvt =3D true,
+		.multi_chip =3D true,
+		.tag_protocol =3D DSA_TAG_PROTO_DSA,
+		.ptp_support =3D true,
+		.ops =3D &mv88e6393x_ops,
+	},
 };
=20
 static const struct mv88e6xxx_info *mv88e6xxx_lookup_info(unsigned int pro=
d_num)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/c=
hip.h
index 1ac8338d2256..bf1bc540be79 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -63,6 +63,8 @@ enum mv88e6xxx_model {
 	MV88E6190,
 	MV88E6190X,
 	MV88E6191,
+	MV88E6191X,
+	MV88E6193X,
 	MV88E6220,
 	MV88E6240,
 	MV88E6250,
@@ -75,6 +77,7 @@ enum mv88e6xxx_model {
 	MV88E6352,
 	MV88E6390,
 	MV88E6390X,
+	MV88E6393X,
 };
=20
 enum mv88e6xxx_family {
@@ -90,6 +93,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
 	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
+	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
 };
=20
 struct mv88e6xxx_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xx=
x/global1.h
index 80a182c5b98a..5b084f4015f6 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -22,6 +22,7 @@
 #define MV88E6185_G1_STS_PPU_STATE_DISABLED		0x8000
 #define MV88E6185_G1_STS_PPU_STATE_POLLING		0xc000
 #define MV88E6XXX_G1_STS_INIT_READY			0x0800
+#define MV88E6393X_G1_STS_IRQ_DEVICE_2			9
 #define MV88E6XXX_G1_STS_IRQ_AVB			8
 #define MV88E6XXX_G1_STS_IRQ_DEVICE			7
 #define MV88E6XXX_G1_STS_IRQ_STATS			6
@@ -59,6 +60,7 @@
 #define MV88E6185_G1_CTL1_SCHED_PRIO		0x0800
 #define MV88E6185_G1_CTL1_MAX_FRAME_1632	0x0400
 #define MV88E6185_G1_CTL1_RELOAD_EEPROM		0x0200
+#define MV88E6393X_G1_CTL1_DEVICE2_EN		0x0200
 #define MV88E6XXX_G1_CTL1_DEVICE_EN		0x0080
 #define MV88E6XXX_G1_CTL1_STATS_DONE_EN		0x0040
 #define MV88E6XXX_G1_CTL1_VTU_PROBLEM_EN	0x0020
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xx=
x/global2.h
index 1f42ee656816..04696cb68971 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -38,9 +38,15 @@
 /* Offset 0x02: MGMT Enable Register 2x */
 #define MV88E6XXX_G2_MGMT_EN_2X		0x02
=20
+/* Offset 0x02: MAC LINK change IRQ Register for MV88E6393X */
+#define MV88E6393X_G2_MACLINK_INT_SRC		0x02
+
 /* Offset 0x03: MGMT Enable Register 0x */
 #define MV88E6XXX_G2_MGMT_EN_0X		0x03
=20
+/* Offset 0x03: MAC LINK change IRQ Mask Register for MV88E6393X */
+#define MV88E6393X_G2_MACLINK_INT_MASK		0x03
+
 /* Offset 0x04: Flow Control Delay Register */
 #define MV88E6XXX_G2_FLOW_CTL	0x04
=20
@@ -52,6 +58,8 @@
 #define MV88E6XXX_G2_SWITCH_MGMT_FORCE_FLOW_CTL_PRI	0x0080
 #define MV88E6XXX_G2_SWITCH_MGMT_RSVD2CPU		0x0008
=20
+#define MV88E6393X_G2_EGRESS_MONITOR_DEST		0x05
+
 /* Offset 0x06: Device Mapping Table Register */
 #define MV88E6XXX_G2_DEVICE_MAPPING		0x06
 #define MV88E6XXX_G2_DEVICE_MAPPING_UPDATE	0x8000
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/p=
ort.c
index 0af596957b97..c38fcb8163ce 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -14,6 +14,7 @@
 #include <linux/phylink.h>
=20
 #include "chip.h"
+#include "global2.h"
 #include "port.h"
 #include "serdes.h"
=20
@@ -25,6 +26,14 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, int=
 port, int reg,
 	return mv88e6xxx_read(chip, addr, reg, val);
 }
=20
+int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg=
,
+		int bit, int val)
+{
+	int addr =3D chip->info->port_base_addr + port;
+
+	return mv88e6xxx_wait_bit(chip, addr, reg, bit, val);
+}
+
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
 			 u16 val)
 {
@@ -426,6 +435,89 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int por=
t)
 	return PHY_INTERFACE_MODE_NA;
 }
=20
+/* Support 10, 100, 200, 1000, 2500, 5000, 10000 Mbps (e.g. 88E6393X)
+ * This function adds new speed 5000 supported by Amethyst family.
+ * Function mv88e6xxx_port_set_speed_duplex() can't be used as the registe=
r
+ * values for speeds 2500 & 5000 conflict.
+ */
+
+int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port=
,
+		int speed, int duplex)
+{
+	u16 reg, ctrl;
+	int err;
+
+	if (speed =3D=3D SPEED_MAX)
+		speed =3D (port > 0 && port < 9) ? 1000 : 10000;
+
+	if (speed =3D=3D 200 && port !=3D 0)
+		return -EOPNOTSUPP;
+
+	if (speed >=3D 2500 && port > 0 && port < 9)
+		return -EOPNOTSUPP;
+
+	switch (speed) {
+	case 10:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_10;
+		break;
+	case 100:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_100;
+		break;
+	case 200:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_100 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 1000:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_1000;
+		break;
+	case 2500:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_1000 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 5000:
+		ctrl =3D MV88E6390_PORT_MAC_CTL_SPEED_10000 |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED;
+		break;
+	case 10000:
+	case SPEED_UNFORCED:
+		ctrl =3D MV88E6XXX_PORT_MAC_CTL_SPEED_UNFORCED;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	switch (duplex) {
+	case DUPLEX_HALF:
+		ctrl |=3D MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX;
+		break;
+	case DUPLEX_FULL:
+		ctrl |=3D MV88E6XXX_PORT_MAC_CTL_FORCE_DUPLEX |
+			MV88E6XXX_PORT_MAC_CTL_DUPLEX_FULL;
+		break;
+	case DUPLEX_UNFORCED:
+		/* normal duplex detection */
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
+	if (err)
+		return err;
+
+	reg &=3D ~(MV88E6XXX_PORT_MAC_CTL_SPEED_MASK |
+			MV88E6390_PORT_MAC_CTL_ALTSPEED |
+			MV88E6390_PORT_MAC_CTL_FORCE_SPEED);
+
+	if (speed !=3D SPEED_UNFORCED)
+		reg |=3D MV88E6390_PORT_MAC_CTL_FORCE_SPEED;
+
+	reg |=3D ctrl;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_MAC_CTL, reg);
+
+}
+
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
@@ -450,6 +542,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_ch=
ip *chip, int port,
 	case PHY_INTERFACE_MODE_2500BASEX:
 		cmode =3D MV88E6XXX_PORT_STS_CMODE_2500BASEX;
 		break;
+	case PHY_INTERFACE_MODE_5GBASER:
+		cmode =3D MV88E6XXX_PORT_STS_CMODE_5GBASER;
+		break;
 	case PHY_INTERFACE_MODE_XGMII:
 	case PHY_INTERFACE_MODE_XAUI:
 		cmode =3D MV88E6XXX_PORT_STS_CMODE_XAUI;
@@ -457,6 +552,13 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_c=
hip *chip, int port,
 	case PHY_INTERFACE_MODE_RXAUI:
 		cmode =3D MV88E6XXX_PORT_STS_CMODE_RXAUI;
 		break;
+	case PHY_INTERFACE_MODE_10GBASER:
+	case PHY_INTERFACE_MODE_10GKR:
+		cmode =3D MV88E6XXX_PORT_STS_CMODE_10GBASER;
+		break;
+	case PHY_INTERFACE_MODE_USXGMII:
+		cmode =3D MV88E6XXX_PORT_STS_CMODE_USXGMII;
+		break;
 	default:
 		cmode =3D 0;
 	}
@@ -541,6 +643,15 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *ch=
ip, int port,
 	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
 }
=20
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode)
+{
+	if (port !=3D 0 && port !=3D 9 && port !=3D 10)
+		return -EOPNOTSUPP;
+
+	return mv88e6xxx_port_set_cmode(chip, port, mode, false);
+}
+
 static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
 					     int port)
 {
@@ -1164,6 +1275,125 @@ int mv88e6xxx_port_disable_pri_override(struct mv88=
e6xxx_chip *chip, int port)
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_PRI_OVERRIDE, 0);
 }
=20
+/* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393=
X */
+
+static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, u16 p=
ointer,
+				u8 data)
+{
+
+	int err =3D 0;
+	int port;
+	u16 reg;
+
+	/* Setup per Port policy register */
+	for (port =3D 0; port < mv88e6xxx_num_ports(chip); port++) {
+		if (dsa_is_unused_port(chip->ds, port))
+			continue;
+
+		reg =3D MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE | pointer | data;
+		err =3D mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL=
, reg);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
+				enum mv88e6xxx_egress_direction direction,
+				int port)
+{
+	u16 ptr;
+	int err;
+
+	switch (direction) {
+	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST;
+		err =3D mv88e6393x_port_policy_write(chip, ptr, port);
+		if (err)
+			return err;
+		break;
+	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		ptr =3D MV88E6393X_G2_EGRESS_MONITOR_DEST;
+		err =3D mv88e6xxx_g2_write(chip, ptr, port);
+		if (err)
+			return err;
+		break;
+	}
+	return 0;
+}
+
+int mv88e6393x_port_set_cpu_dest(struct mv88e6xxx_chip *chip, int port)
+{
+	u16 ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST;
+	u8 data =3D MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI | port;
+
+	return mv88e6393x_port_policy_write(chip, ptr, data);
+}
+
+int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip)
+{
+	u16 ptr;
+	int err;
+
+	/* Consider the frames with reserved multicast destination
+	 * addresses matching 01:80:c2:00:00:00 and
+	 * 01:80:c2:00:00:02 as MGMT.
+	 */
+	ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO;
+	err =3D mv88e6393x_port_policy_write(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI;
+	err =3D mv88e6393x_port_policy_write(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO;
+	err =3D mv88e6393x_port_policy_write(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	ptr =3D MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI;
+	err =3D mv88e6393x_port_policy_write(chip, ptr, 0xff);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Offset 0x10 & 0x11: EPC */
+
+static int mv88e6393x_port_epc_wait_ready(struct mv88e6xxx_chip *chip, int=
 port)
+{
+	int bit =3D __bf_shf(MV88E6393X_PORT_EPC_CMD_BUSY);
+
+	return mv88e6xxx_port_wait_bit(chip, port, MV88E6393X_PORT_EPC_CMD, bit, =
0);
+}
+
+/* Port Ether type for 6393X family */
+
+int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
+					u16 etype)
+{
+	u16 val;
+	int err;
+
+	err =3D mv88e6393x_port_epc_wait_ready(chip, port);
+	if (err)
+		return err;
+
+	err =3D mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_DATA, etype)=
;
+	if (err)
+		return err;
+
+	val =3D MV88E6393X_PORT_EPC_CMD_BUSY |
+	      MV88E6393X_PORT_EPC_CMD_WRITE |
+	      MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE;
+
+	return mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_EPC_CMD, val);
+}
+
 /* Offset 0x0f: Port Ether type */
=20
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/p=
ort.h
index 500e1d4896ff..051665fa22d5 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -49,6 +49,9 @@
 #define MV88E6XXX_PORT_STS_CMODE_2500BASEX	0x000b
 #define MV88E6XXX_PORT_STS_CMODE_XAUI		0x000c
 #define MV88E6XXX_PORT_STS_CMODE_RXAUI		0x000d
+#define MV88E6XXX_PORT_STS_CMODE_5GBASER	0x000c
+#define MV88E6XXX_PORT_STS_CMODE_10GBASER	0x000d
+#define MV88E6XXX_PORT_STS_CMODE_USXGMII	0x000e
 #define MV88E6185_PORT_STS_CDUPLEX		0x0008
 #define MV88E6185_PORT_STS_CMODE_MASK		0x0007
 #define MV88E6185_PORT_STS_CMODE_GMII_FD	0x0000
@@ -117,6 +120,8 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6176	0x1760
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6190	0x1900
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6191	0x1910
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6191X	0x1920
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6193X	0x1930
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6185	0x1a70
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6220	0x2200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6240	0x2400
@@ -129,6 +134,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6393X	0x3930
 #define MV88E6XXX_PORT_SWITCH_ID_REV_MASK	0x000f
=20
 /* Offset 0x04: Port Control Register */
@@ -236,6 +242,19 @@
 #define MV88E6XXX_PORT_POLICY_CTL_TRAP		0x0002
 #define MV88E6XXX_PORT_POLICY_CTL_DISCARD	0x0003
=20
+/* Offset 0x0E: Policy & MGMT Control Register (FAMILY_6393X) */
+#define MV88E6393X_PORT_POLICY_MGMT_CTL				0x0e
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_UPDATE			0x8000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_MASK		0x3f00
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XLO	0x2000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000000XHI	0x2100
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XLO	0x2400
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_01C280000002XHI	0x2500
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_INGRESS_DEST	0x3000
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_PTR_CPU_DEST		0x3800
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_DATA_MASK		0x00ff
+#define MV88E6393X_PORT_POLICY_MGMT_CTL_CPU_DEST_MGMTPRI	0x00e0
+
 /* Offset 0x0F: Port Special Ether Type */
 #define MV88E6XXX_PORT_ETH_TYPE		0x0f
 #define MV88E6XXX_PORT_ETH_TYPE_DEFAULT	0x9100
@@ -243,6 +262,15 @@
 /* Offset 0x10: InDiscards Low Counter */
 #define MV88E6XXX_PORT_IN_DISCARD_LO	0x10
=20
+/* Offset 0x10: Extended Port Control Command */
+#define MV88E6393X_PORT_EPC_CMD		0x10
+#define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
+
+/* Offset 0x11: Extended Port Control Data */
+#define MV88E6393X_PORT_EPC_DATA	0x11
+
 /* Offset 0x11: InDiscards High Counter */
 #define MV88E6XXX_PORT_IN_DISCARD_HI	0x11
=20
@@ -288,7 +316,8 @@ int mv88e6xxx_port_read(struct mv88e6xxx_chip *chip, in=
t port, int reg,
 			u16 *val);
 int mv88e6xxx_port_write(struct mv88e6xxx_chip *chip, int port, int reg,
 			 u16 val);
-
+int mv88e6xxx_port_wait_bit(struct mv88e6xxx_chip *chip, int port, int reg=
,
+		int bit, int val);
 int mv88e6185_port_set_pause(struct mv88e6xxx_chip *chip, int port,
 			     int pause);
 int mv88e6352_port_set_rgmii_delay(struct mv88e6xxx_chip *chip, int port,
@@ -315,7 +344,8 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_ch=
ip *chip, int port,
 				    int speed, int duplex);
 int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port=
,
 				     int speed, int duplex);
-
+int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port=
,
+					int speed, int duplex);
 phy_interface_t mv88e6341_port_max_speed_mode(int port);
 phy_interface_t mv88e6390_port_max_speed_mode(int port);
 phy_interface_t mv88e6390x_port_max_speed_mode(int port);
@@ -349,6 +379,13 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *c=
hip, int port,
 			      enum mv88e6xxx_policy_action action);
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
+int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
+			       enum mv88e6xxx_egress_direction direction,
+			       int port);
+int mv88e6393x_port_set_cpu_dest(struct mv88e6xxx_chip *chip, int port);
+int mv88e6393x_port_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
+int mv88e6393x_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
+				u16 etype);
 int mv88e6xxx_port_set_message_port(struct mv88e6xxx_chip *chip, int port,
 				    bool message_port);
 int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int port,
@@ -365,6 +402,8 @@ int mv88e6390_port_set_cmode(struct mv88e6xxx_chip *chi=
p, int port,
 			     phy_interface_t mode);
 int mv88e6390x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 			      phy_interface_t mode);
+int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
+			      phy_interface_t mode);
 int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cm=
ode);
 int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cm=
ode);
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx=
/serdes.c
index e48260c5c6ba..ae21d1dea9ba 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -637,6 +637,27 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *=
chip, int port)
 	return lane;
 }
=20
+/* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane addres=
s
+ * a port is using else Returns -ENODEV.
+ */
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+{
+	u8 cmode =3D chip->ports[port].cmode;
+	int lane =3D -ENODEV;
+
+	if (port !=3D 0 && port !=3D 9 && port !=3D 10)
+		return -EOPNOTSUPP;
+
+	if (cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
+		cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_SGMII ||
+		cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_2500BASEX ||
+		cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_5GBASER ||
+		cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_10GBASER ||
+		cmode =3D=3D MV88E6XXX_PORT_STS_CMODE_USXGMII)
+		lane =3D port;
+	return lane;
+}
+
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
 static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lan=
e,
 				      bool up)
@@ -902,6 +923,30 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct m=
v88e6xxx_chip *chip,
 	return 0;
 }
=20
+static int mv88e6393x_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip=
,
+					       int port, int lane,
+					       struct phylink_link_state *state)
+{
+	u16 status;
+	int err;
+
+	err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err)
+		return err;
+
+	state->link =3D !!(status & MDIO_STAT1_LSTATUS);
+	if (state->link) {
+		if (state->interface =3D=3D PHY_INTERFACE_MODE_5GBASER)
+			state->speed =3D SPEED_5000;
+		else
+			state->speed =3D SPEED_10000;
+		state->duplex =3D DUPLEX_FULL;
+	}
+
+	return 0;
+}
+
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
@@ -921,6 +966,25 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_ch=
ip *chip, int port,
 	}
 }
=20
+int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				    int lane, struct phylink_link_state *state)
+{
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return mv88e6390_serdes_pcs_get_state_sgmii(chip, port, lane,
+							    state);
+	case PHY_INTERFACE_MODE_5GBASER:
+	case PHY_INTERFACE_MODE_10GBASER:
+		return mv88e6393x_serdes_pcs_get_state_10g(chip, port, lane,
+							   state);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    int lane)
 {
@@ -988,6 +1052,23 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv=
88e6xxx_chip *chip,
 	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
 }
=20
+static void mv88e6393x_serdes_irq_link_10g(struct mv88e6xxx_chip *chip,
+					   int port, u8 lane)
+{
+	u16 status;
+	int err;
+
+	/* If the link has dropped, we want to know about it. */
+	err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_10G_STAT1, &status);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes STAT1: %d\n", err);
+		return;
+	}
+
+	dsa_port_phylink_mac_change(chip->ds, port, !!(status & MDIO_STAT1_LSTATU=
S));
+}
+
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 					     int lane, bool enable)
 {
@@ -1027,6 +1108,83 @@ static int mv88e6390_serdes_irq_status_sgmii(struct =
mv88e6xxx_chip *chip,
 	return err;
 }
=20
+static int mv88e6393x_serdes_irq_enable_10g(struct mv88e6xxx_chip *chip,
+					    u8 lane, bool enable)
+{
+	u16 val =3D 0;
+
+	if (enable)
+		val |=3D MV88E6393X_10G_INT_LINK_CHANGE;
+
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6393X_10G_INT_ENABLE, val);
+}
+
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
+				int lane, bool enable)
+{
+	u8 cmode =3D chip->ports[port].cmode;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_irq_enable_sgmii(chip, lane, enable);
+	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
+	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+		return mv88e6393x_serdes_irq_enable_10g(chip, lane, enable);
+	}
+
+	return 0;
+}
+
+static int mv88e6393x_serdes_irq_status_10g(struct mv88e6xxx_chip *chip,
+					    u8 lane, u16 *status)
+{
+	int err;
+
+	err =3D mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6393X_10G_INT_STATUS, status);
+
+	return err;
+}
+
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int =
port,
+					int lane)
+{
+	u8 cmode =3D chip->ports[port].cmode;
+	irqreturn_t ret =3D IRQ_NONE;
+	u16 status;
+	int err;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_SGMII:
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		err =3D mv88e6390_serdes_irq_status_sgmii(chip, lane, &status);
+		if (err)
+			return ret;
+		if (status & (MV88E6390_SGMII_INT_LINK_DOWN |
+			      MV88E6390_SGMII_INT_LINK_UP)) {
+			ret =3D IRQ_HANDLED;
+			mv88e6390_serdes_irq_link_sgmii(chip, port, lane);
+		}
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_5GBASER:
+	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+		err =3D mv88e6393x_serdes_irq_status_10g(chip, lane, &status);
+		if (err)
+			return err;
+		if (status & MV88E6393X_10G_INT_LINK_CHANGE) {
+			ret =3D IRQ_HANDLED;
+			mv88e6393x_serdes_irq_link_10g(chip, port, lane);
+		}
+		break;
+	}
+
+	return ret;
+}
+
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int p=
ort,
 					int lane)
 {
@@ -1112,3 +1270,164 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chi=
p *chip, int port, void *_p)
 			p[i] =3D reg;
 	}
 }
+
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip)
+{
+	u16 config0, config9, config10;
+	u16 pcs0, pcs9, pcs10;
+	int err =3D 0;
+
+	/* mv88e6393x family errata 3.8 :
+	 * When a SERDES port is operating in 1000BASE-X or SGMII mode link may n=
ot
+	 * come up after hardware reset or software reset of SERDES core.
+	 * Workaround is to write SERDES register 4.F074.14 =3D1 for only those m=
odes
+	 * and 0 in all other modes.
+	 */
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE, MDIO_MMD_PHYXS=
,
+				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config0);
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT9_LANE, MDIO_MMD_PHYXS=
,
+				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config9);
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT10_LANE, MDIO_MMD_PHYX=
S,
+				    MV88E6393X_ERRATA_1000BASEX_SGMII, &config10);
+
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE, MDIO_MMD_PHYXS=
,
+				    MV88E6393X_SERDES_POC, &pcs0);
+	pcs0 &=3D MV88E6393X_SERDES_POC_PCS_MODE_MASK;
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT9_LANE, MDIO_MMD_PHYXS=
,
+				    MV88E6393X_SERDES_POC, &pcs9);
+	pcs9 &=3D MV88E6393X_SERDES_POC_PCS_MODE_MASK;
+	err =3D mv88e6390_serdes_read(chip, MV88E6393X_PORT10_LANE, MDIO_MMD_PHYX=
S,
+				    MV88E6393X_SERDES_POC, &pcs10);
+	pcs10 &=3D MV88E6393X_SERDES_POC_PCS_MODE_MASK;
+
+	if (pcs0 =3D=3D MV88E6393X_PCS_SELECT_1000BASEX ||
+		pcs0 =3D=3D MV88E6393X_PCS_SELECT_SGMII_PHY ||
+		pcs0 =3D=3D MV88E6393X_PCS_SELECT_SGMII_MAC) {
+		config0 |=3D MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT0_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config0);
+	} else {
+		config0 &=3D ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT0_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config0);
+	}
+
+	if (pcs9 =3D=3D MV88E6393X_PCS_SELECT_1000BASEX ||
+		pcs9 =3D=3D MV88E6393X_PCS_SELECT_SGMII_PHY ||
+		pcs9 =3D=3D MV88E6393X_PCS_SELECT_SGMII_MAC) {
+		config9 |=3D MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT9_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config9);
+	} else {
+		config9 &=3D ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT9_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config9);
+	}
+
+	if (pcs10 =3D=3D MV88E6393X_PCS_SELECT_1000BASEX ||
+		pcs10 =3D=3D MV88E6393X_PCS_SELECT_SGMII_PHY ||
+		pcs10 =3D=3D MV88E6393X_PCS_SELECT_SGMII_MAC) {
+		config10 |=3D MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT10_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config10);
+	} else {
+		config10 &=3D ~MV88E6393X_ERRATA_1000BASEX_SGMII_BIT;
+		err =3D mv88e6390_serdes_write(chip, MV88E6393X_PORT10_LANE,
+						MDIO_MMD_PHYXS,
+						MV88E6393X_ERRATA_1000BASEX_SGMII,
+						config10);
+	}
+	return err;
+}
+
+static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int =
lane,
+					bool on)
+{
+	u8 cmode =3D chip->ports[lane].cmode;
+	u16 config, pcs;
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+		pcs =3D MV88E6393X_PCS_SELECT_1000BASEX;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		pcs =3D MV88E6393X_PCS_SELECT_2500BASEX;
+		break;
+	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+		pcs =3D MV88E6393X_PCS_SELECT_10GBASER;
+		break;
+	default:
+		pcs =3D MV88E6393X_PCS_SELECT_1000BASEX;
+		break;
+	}
+
+	if (on) {
+		/* mv88e6393x family errata 3.6 :
+		 * When changing c_mode on Port 0 from [x]MII mode to any
+		 * SERDES mode SERDES will not be operational.
+		 * Workaround: Set Port0 SERDES register 4.F002.5=3D0
+		 */
+		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6393X_SERDES_POC, &config);
+		config &=3D ~(MV88E6393X_SERDES_POC_PCS_MODE_MASK |
+				MV88E6393X_SERDES_POC_PDOWN);
+		config |=3D pcs;
+		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6393X_SERDES_POC, config);
+		config |=3D MV88E6393X_SERDES_POC_RESET;
+		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6393X_SERDES_POC, config);
+
+		/* mv88e6393x family errata 3.7 :
+		 * When changing cmode on SERDES port from any other mode to
+		 * 1000BASE-X mode the link may not come up due to invalid
+		 * 1000BASE-X advertisement.
+		 * Workaround: Correct advertisement and reset PHY core.
+		 */
+		config =3D MV88E6390_SGMII_ANAR_1000BASEX_FD;
+		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6390_SGMII_ANAR, config);
+
+		/* soft reset the PCS/PMA */
+		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6390_SGMII_CONTROL, &config);
+		config |=3D MV88E6390_SGMII_CONTROL_RESET;
+		mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				MV88E6390_SGMII_CONTROL, config);
+	}
+
+	return 0;
+}
+
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lan=
e,
+		    bool on)
+{
+	u8 cmode;
+
+	if (port !=3D 0 && port !=3D 9 && port !=3D 10)
+		return -EOPNOTSUPP;
+
+	cmode =3D chip->ports[port].cmode;
+
+	mv88e6393x_serdes_port_config(chip, lane, on);
+
+	switch (cmode) {
+	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
+	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
+		return mv88e6390_serdes_power_sgmii(chip, lane, on);
+	case MV88E6XXX_PORT_STS_CMODE_10GBASER:
+		return mv88e6390_serdes_power_10g(chip, lane, on);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx=
/serdes.h
index a1a51a6d6c1f..4015db6287ca 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -42,6 +42,9 @@
 /* 10GBASE-R and 10GBASE-X4/X2 */
 #define MV88E6390_10G_CTRL1		(0x1000 + MDIO_CTRL1)
 #define MV88E6390_10G_STAT1		(0x1000 + MDIO_STAT1)
+#define MV88E6393X_10G_INT_ENABLE	0x9000
+#define MV88E6393X_10G_INT_LINK_CHANGE	BIT(2)
+#define MV88E6393X_10G_INT_STATUS	0x9001
=20
 /* 1000BASE-X and SGMII */
 #define MV88E6390_SGMII_BMCR		(0x2000 + MII_BMCR)
@@ -68,16 +71,48 @@
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 #define MV88E6390_SGMII_PHY_STATUS_TX_PAUSE	BIT(3)
 #define MV88E6390_SGMII_PHY_STATUS_RX_PAUSE	BIT(2)
+#define MV88E6390_SGMII_STATUS_AN_ABLE	BIT(3)
+#define MV88E6390_SGMII_ANAR	0x2004
+#define MV88E6390_SGMII_ANAR_1000BASEX_FD	BIT(5)
+#define MV88E6390_SGMII_CONTROL		0x2000
+#define MV88E6390_SGMII_CONTROL_RESET		BIT(15)
+#define MV88E6390_SGMII_CONTROL_LOOPBACK	BIT(14)
+#define MV88E6390_SGMII_CONTROL_PDOWN		BIT(11)
+#define MV88E6390_SGMII_STATUS		0x2001
=20
 /* Packet generator pad packet checker */
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
=20
+#define MV88E6393X_PORT0_LANE		0x00
+#define MV88E6393X_PORT9_LANE		0x09
+#define MV88E6393X_PORT10_LANE		0x0a
+
+/* Port Operational Configuration */
+#define MV88E6393X_PCS_SELECT_1000BASEX		0x0000
+#define MV88E6393X_PCS_SELECT_2500BASEX		0x0001
+#define MV88E6393X_PCS_SELECT_SGMII_PHY		0x0002
+#define MV88E6393X_PCS_SELECT_SGMII_MAC		0x0003
+#define MV88E6393X_PCS_SELECT_5GBASER		0x0004
+#define MV88E6393X_PCS_SELECT_10GBASER		0x0005
+#define MV88E6393X_PCS_SELECT_USXGMII_PHY	0x0006
+#define MV88E6393X_PCS_SELECT_USXGMII_MAC	0x0007
+
+#define MV88E6393X_SERDES_POC		0xf002
+#define MV88E6393X_SERDES_POC_PCS_MODE_MASK		0x0007
+#define MV88E6393X_SERDES_POC_RESET		BIT(15)
+#define MV88E6393X_SERDES_POC_PDOWN		BIT(5)
+#define MV88E6393X_SERDES_POC_ANEG		BIT(3)
+
+#define MV88E6393X_ERRATA_1000BASEX_SGMII		0xF074
+#define MV88E6393X_ERRATA_1000BASEX_SGMII_BIT	BIT(14)
+
 int mv88e6185_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				int lane, unsigned int mode,
 				phy_interface_t interface,
@@ -92,6 +127,8 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip=
 *chip, int port,
 				   int lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state);
+int mv88e6393x_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
+				    int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 				    int lane);
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -110,18 +147,25 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chi=
p, int port, int lane,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane=
,
 			   bool on);
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lan=
e,
+		    bool on);
+int mv88e6393x_serdes_setup_errata(struct mv88e6xxx_chip *chip);
 int mv88e6097_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int=
 lane,
 				bool enable);
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int=
 lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int=
 lane,
 				bool enable);
+int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
+	    int lane, bool enable);
 irqreturn_t mv88e6097_serdes_irq_status(struct mv88e6xxx_chip *chip, int p=
ort,
 					int lane);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int p=
ort,
 					int lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int p=
ort,
 					int lane);
+irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int =
port,
+					int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)=
;
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
--=20
2.17.1

