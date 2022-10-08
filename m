Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147DF5F86CC
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJHSwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJHSwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2AD3F1FD;
        Sat,  8 Oct 2022 11:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLu22WJ0iLkBo8uF1CqpF/UCZRRVgHO9zvG9Dv4WgWoBDwYzJFj56BToHKUReIBPmHPAGjUag2kcA6Rjm+h7DEmDY96DE12amFealLNZP+wghij/wcXo9t+dpPggGhRWEhx1BvhZpt6CaczR5hBGYdvJFGkBZWLBKL0qsUb+KGqJhJ+e7LTxgpHeA5dYuB609s9qd7N1WfUyhKa/JNsNY39Avpys/NmwJNPZe0ykd85WGSwUD/zPMx+SVlmvmS8KKOwwIoO8DRWStOIGdDi3e05S8vrSdq/zGFqNtH5zPxYFZ1OFjP81QBWyQRT+nLQD3MXV9WZzAhZvj8+BK4xwMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLPe7KitnzSsKJljKokTTWMRgfsa7lKoZH9viJ3Y+vE=;
 b=PKSDb5f54uJc08NB/PfE1KN7GaRG37SM9VmGQu/SznlmZRzm/z+CllmQVhUrLLkaBLf5QJNXgS16Y3AI3nHMuaJ9LFpow5IsqZogWP8REz93J/peWUgmapPGZZyw59vbbpHtSOxlyViZY4p+UTt7coluJYjV+eNZ40CvBsx9zOXdldUhQBapzKYj3OW0ZDTg80lkaDHXMmeLggyvT5TsKiEpN+9K3oHcWApEcocAY7eSqbO83nOzwCxgZJ0dLeoRzIL1bpDj9RGWXUZWxBcZ6NAwsMsZwAyHf+TpqJCOM5pRxFbPbpOpPPTex/DyR9aMm01Qq1TCMKg+FO9fXR6UGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLPe7KitnzSsKJljKokTTWMRgfsa7lKoZH9viJ3Y+vE=;
 b=umdm32M222FZBRhDiKYCD7OW5LXOugDdNAY2qyQfMcuSvNDL2fp2+riopIs1GoOZXWq87k441EoIiG9QPdd9eWRfG32+PvGrkJgwheBvvizrmUAhw9ZOuRHvRMS1fz93ddlYsS6FPkFe5P9KWvW26LWFf+X9dvJtRiQONE7mRWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC v4 net-next 07/17] net: dsa: felix: add configurable device quirks
Date:   Sat,  8 Oct 2022 11:51:42 -0700
Message-Id: <20221008185152.2411007-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f308378-e427-43f4-4ca6-08daa95e32e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tlnZhB/UVzcc++vdSlZTanDGdvJObLx0OWrdfAn64wQeEhS0qmlKbkuHuSWr95Fnv4n74G9Qqlz6jGH1a6uwfQTLNaKhQiWrS0qaaJG/Mwfn5cwonApFEhKit5NdyR4tLVxuVId0fBllsjwS7N2oWoEh3OiohSyhkLQmBSo2Kklgc6cZNSvWcoB7qbDfVjmDh50ynfBMHpLbApIzgO/bhKfMrbvtKnGJXXZMVm03UhRRU6L8ZjAihEaMi+Yx0MIcbfc+Bv/UkRwa7PokyIjGt94nL7Fcz/ulKlQ3rSMxydGWUKw2q9+XRgNtbxcfbi5cBw8uNkO5JvJBZl2vZvXD7TqoiOpNiua9KMxSP+9x0iXAiYDzlLKfiNXTTzWuJTdyQH56v+Xwmj5Vnl6llPkVHbc/qXunhMc4PSqJ/8USqDkpkhLr32QxUHTHzB6mzHtm4rM9pB8Dl1vefHAnzvLoNWm+7BVOsWMlvsbONZiK8rdQGQE1xkw36nsxdfbjkYTggyjkvqhHRcXUbtgZwwq4ofy7jR25NKuCEwffZv8FYmlGuMWDvUvkhSfPEQxY8leLX+Ip/5RhKMe9HwKM6HkBjrW9N21kbLLGzIUkyft/wWynIJZbYWQXS1XGKQFwBqUWTiNMuF6cnRgCpAmTLPRHdEEqvtTTdEaYO693iLl+hhBy6hOKBb4aKMVIvvoe2m3otj39z7vuV7gPp12dmi9ZupFHE63OMHJP6nt4rRrdGc81RlYlh/cxuCalmcC73YAb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UZsGjsfwQVWIxY3gugyL451+9HDB7bDC4sX5xVIcfQaGXJsnymTWIXhnU75P?=
 =?us-ascii?Q?qOVbcM+34Xy4rbp3WvkzARsJUHjC3eytTdvec8Ov3nOwX2lB75s47LSA88yB?=
 =?us-ascii?Q?ejj41kAtA5Ml9S8oP+zn+peWaw+q/am6sujBjXgO2IYwsrBJgSDSj5Lpwuqe?=
 =?us-ascii?Q?BGuNHfUK35uom5u1RsXSBX+MTyXuNNCT4iAmlIEZB1MzdDhar5Quo7eDRY6T?=
 =?us-ascii?Q?8vKcvMxp10AVPr0MZqCxhetTevldw0PDnCYyRaKrZ15vNUZnvvSIknxXWz9l?=
 =?us-ascii?Q?YWQauuqWtrJYq405QyRdV84m7oCcBUF5f+NdQffuRKtZkrgNasDvZoC5Q5Xi?=
 =?us-ascii?Q?m0J48u+0aWYMFDAbLxHOAZt92Jgt1kkF+i5xttLduHyTWle+gSPyYVCglgdQ?=
 =?us-ascii?Q?YMenqNpcsSCMh1Y9Cv1UJOa4mvT7gGd48XEkEDaOblw2NzsOhtW9OOS6YrvJ?=
 =?us-ascii?Q?zxvEPC2U/f46+2SN41LoK7/WsTEjZyD6xxkvblmkS0R3oWrBEtdouRjtj73i?=
 =?us-ascii?Q?9S6+yPFNn0+etj/AczNYaAyDFIwN8eLA2l5EO9i/PJGL+43a9cZWzuX29JU1?=
 =?us-ascii?Q?L+0DkA2tBf9HEwROeZrtTfnDsxTyWOFf89L5CBUmBgM6SbX8R6XwbZRcEOIs?=
 =?us-ascii?Q?+tfYYPopJ/RVuCMo6/HAO7K3lOtNtAt7fBGdCjJfxkEZARsyN5d+a6KohQ59?=
 =?us-ascii?Q?n+Hc/NTucmthj3BirHJOxMg32jyW3FWms/DmmgcgAApDs3mEszg5ggF0rhlO?=
 =?us-ascii?Q?ciPJDtcf0FuaAPsaLh/B0aX7XtII8/bunYMaYeNsM9CO9Fbx6P4YhGSeRgrY?=
 =?us-ascii?Q?y8qRRSKYyBvhxB3pdjFWIgqheWz2Js7CxJzHNUUKE0Rl0dCR48RsnR229yhz?=
 =?us-ascii?Q?NlLLxQLrIVv53E24d0EgPqENnoIpdbnNRVWkhdYap5WxoiFYse+9LL0p+Nly?=
 =?us-ascii?Q?VVlIZrYmP5dE5yZnLgJK/vKU8M4cDsjoaQTNxXSwB9JlBlw7smEXTUCE4fcq?=
 =?us-ascii?Q?wcVvZKepG5LnO0N1nQ+t09+CE+WkaSU+74RCYHSLgY51Xo2sCvgVXCZaD3BF?=
 =?us-ascii?Q?6tawPyA2X0auwUCGykuk7ov1JA4RryIJKM2VQpslJD2/DEXeYXaRaTbcQBST?=
 =?us-ascii?Q?EtanVoSIeDJ60UNVOhvkrr86FlIbifb8HMjCMq0na+lb1Eh0b+kxS+L1Oah4?=
 =?us-ascii?Q?iga+CYJfNaT1AxEq74mabaUq6Bs9EOOWmmTGX61tQId94Q2rcVVPzetB/ijD?=
 =?us-ascii?Q?vMomTaTRL4HbR3wDPBLhkGssOqaH9V5ATxPy/hoKt0ObhI9hFVMRNkPX/8x4?=
 =?us-ascii?Q?0B/LWWhMHvJXCgNjW+8nKIEmOG9/LceDrLHZcNRHahB1eC/+kDJSwe/8ftrW?=
 =?us-ascii?Q?v7nAsYD/TJ0vO5zJMBcOf2cCI85BkJWkTZ0Rl5QnzVCZiKsCU4l3aN9tqzXF?=
 =?us-ascii?Q?s9TiYm2uU6clY7OZFKz+pTp1Tj6eVG3eyZcmhwaEk8IF0RZoHVHUWlrb8WIo?=
 =?us-ascii?Q?Cr7Czhe8k2Q0TKFPukXNqq50MeTjrU4Wz1uToLiq0frJ2ro8zEmNRJZaeT1N?=
 =?us-ascii?Q?wi/Y698qDwUN55vVnIPbbsNBR3DLmqoBWRafl0IJ2spRyjiaRUNzHVKlTX7R?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f308378-e427-43f4-4ca6-08daa95e32e5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:07.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: haLqY14rNPKZnwTfB5obdM5ejdH16/GYeXoN9VdO7BWtdzf4LleJBDkhYl0NF8nxiV/1nOa/vlsFwXd/DDX0VKsZP3gDkoQWmNnyh6/cx+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v2-v4
    * No changes

v1 from previous RFC:
    * No changes

---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index dd3a18cc89dd..d56f6f67f648 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1082,9 +1082,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1099,7 +1102,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index c9c29999c336..e6b7021036c2 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -37,6 +37,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 26a35ae322d1..8999c523c0be 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2584,6 +2584,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685d..3e2f988b2b40 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1002,6 +1002,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

