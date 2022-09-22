Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6757E5E59D0
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIVEBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiIVEBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A72ABD5C;
        Wed, 21 Sep 2022 21:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuaT8pj0lDDNKgpi0Gaa3+VcyLeKCsQKBi38kbiryhRoJhgkFo4aRLvygQQcQBMXo/iYIpbHgh/IKZ1TZ5cJpWQn0KFNRePJdtUCYupVAbi7rnsjBaQI63Xj9Ki+U1t2Gww6etG6LPJZLH37+0NumhIn73G8y5o1qDGX6kDkQYNA/rDE9Gudj7/LxTpAuDm6V4j5sqaAhjHMfIXcBPkVDuaBlGpPgd9h/i0UgxxDSlpzDrNX0ftTO9a2EzcVNGBdXAe/jLig+q5+A7uOnUKTvJfojTbiGFoURg96NYO6zHlDyZeFFe/j5X2sK0oGluNQJHCamSfB0CgOfQaZbCUjXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQm7cVLkFrqX06T8GiJS35gj5rrkvhiC+kGrADrQuWA=;
 b=Ll0JZgnFRqylJtcdH7bxZA+V6sO2kfjJawuGwJOpr8kZ7noh6kohMJiXr+tUz8UW+O0GOUmLvqsd0UAwtH2BzyUGN4YZj81inJ/2uExEBUpSC99SUsDiSTxxyeHXzfXHqJy7Frkkb5rRhbn2AB7rcAcc3bquWIE7XmYdP1VINPNC1EwCLt01PRb4E0CAkh2tsq5yf/tXTOPcz/1H9FnS3LuRsuMj4U0DO4VFOfeOiFzIefrbShb8tMuqUmDyFpX6KJIQnE5cb/gRGtY0hpp/w1sUhyz0RjAgIJvylCi+KErH7FupIpKGQiAiT44yfxY70iME0wNwDKaotaLziGp71w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQm7cVLkFrqX06T8GiJS35gj5rrkvhiC+kGrADrQuWA=;
 b=y51jMyXchqoS/l9XeaRu5VTq/zOKTddD6AAjKub3W+4wTwMTE0i2CvfwPP9aU5Q04VuwFh7DQatNgpZyPzuTuPfdl2qEqZ2S0lGDK04i8OnAP6VQl/f/YFVDPetMLLTDK+jpu+WdO5SQd8hlLSHWgXf+zW3XTyXGPwUTVpoYrm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:20 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:20 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 02/14] net: mscc: ocelot: expose regfield definition to be used by other drivers
Date:   Wed, 21 Sep 2022 21:00:50 -0700
Message-Id: <20220922040102.1554459-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: b2580750-5cec-431b-d276-08da9c4f1b30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTAMoC11ZVsa1BDqvK7lojCaw2h6JJwEeUILW4rk9MQAd/ueg4jXPe8OleeXMY8Nxdwu4AECd7o7+D07Aet9PzB3ehGR5zHAZBbg9VpfbIVbkDhL64rEGd1z/+Sz6mBlLplC60w9F41z/K4+uuuXdsM00uIYd5aIEZefH6QskPU8TZQV6xWUbF/eyhrnmi1xmyn6HsnYMU3YXDqR4/fvgimE9zvx7oqdpIC3r4x6NuNmxaANogpiaZgKw0D2hdS6FjwNxZJpcetv98OXYNGAM/cdTYhAWE11bX6Af0iThZ0SsSNJqwibRHfGb7m3p3uFwKrm96Ve6H4pXCawMIcNjsjRfWHRvkotBf8gbykZ/c/FTOoDd9zdpG16ztrrFzMeIrYJ+6C6CrSJ7SXjYJp4D6P4OkAqh3MAzG7A9+KdlCjo/7hHpUiupGK3MX8HElmB9PwWBWS62Ve1NeWNAVM+4E6a4YqkaaGRUj4gQkPaVJjN6qHTCrhRpBp8OiGA1Qz7eQQnK35TvxsXRLQitWFxaFhZxqDEq1aKvbKllKeDh1NqTBXXpXY70VKNHvpAblsmc6wxsNfh0T42f3OJ8WBhLKwZaxJAY92tAzwTBIby2Cxyx3fVA/MCo8twsM9oIhGEpdukICs0ujHWnvuK/yF2KZNRj7UmdYBxfYSgSjqmHLj1F+IJ/o0Ko7x0JD8nL6hUq9R79vTbAhCsHl6stKuBrdTF0UJhdkJNmOFaRxyiJp+29Fo2YwHi/I4uEas1l0p6TQeY5+Qs3sd+5PtTpBe+5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(30864003)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9TwPFLX5Z+E1Z8oDMfEuuMFMDyG+di889oyVsHHNc12YJrMyNuyfKuxh7e79?=
 =?us-ascii?Q?2BvdtD9O5jPbE54iVWUDP5pgmX3js+V7wy1T3xRZrd6ysnHszLXvbgb1UINI?=
 =?us-ascii?Q?HnVnnpcU9OmgoOoT5g/GCIJkcQqRONSR/GcRP3+UYAtrAjlhSb0w4hltY2y5?=
 =?us-ascii?Q?nyirhK7i16OeBIXLDGuGcvtxwQ0Su/mYm4oQSlz3XPLDOmIAGJ6J19GfGHUr?=
 =?us-ascii?Q?Y+Rhc2s7I0ahv1WjU71Iu1i7lB27kajnQe6WcUg2PFNFe5t/oOxyHvN6tsLg?=
 =?us-ascii?Q?t4mRDR88dkJGH++xLEOB4FOnqS2ln2iovq8VtZhyzvMFinBpdlXVYLO7aMcp?=
 =?us-ascii?Q?ajg4lzcprAuAqNFSOIctSSgf2bK68Bg/XJcIMqrNmFUrkdznbTCmuiXXGM+W?=
 =?us-ascii?Q?UwPpQ2pF4xb222Ytl+5woUFhd+B6D1B3D84V3pWwG7RMvEkhXqLoEpRvuRx6?=
 =?us-ascii?Q?lznNdnGwaWNirNkSvDd3VNMUr5XiMzYlS6e0rcl6YlbJp1w/MHs2+grDrWG+?=
 =?us-ascii?Q?W6i/nTJhIa7MxRYmGSQI4c1pDyspTF7FeNhrKzpiZBSQ9lXVsHlLvEAbXgdJ?=
 =?us-ascii?Q?8uOTtMbuVxvvrRmCgizZ1lPM9Equ8XE8sZv0kYacvHBDqq1OpvNsbobZOFut?=
 =?us-ascii?Q?x8oUBuENQ6gTE5q1B6d6HpXDoQD+spoLNCIQ766WPNEMi4NPvSHnySTCl/JA?=
 =?us-ascii?Q?y2otkvi6nbrUD3wkpYufWbjxBuQr6Dv6ELIdmqwIM4FVhg+VHLVW1s4E7HcT?=
 =?us-ascii?Q?UthyrJ39SPi+6aJmHLK22KOTjENiKigvrzPPHFTYv+IJ0RWM4e+qNwX6ej/F?=
 =?us-ascii?Q?mrlzKxUZ7lbplMO5YsVtFwJolqP7ToPg8WcUiOMRSMpcJecNGaGwt2qzeYxu?=
 =?us-ascii?Q?PK3mo320OGIkdLnf5THwgNZRyloKf7kQD1OzYDc3ySBchMpyupUNqxO/JYfi?=
 =?us-ascii?Q?7TmwirNz1n54o0bBjCWQh8eUOSq0CJv2B7Jksywi9dMi41o63w5d2fKP0S5H?=
 =?us-ascii?Q?SpU52KnoTwr3DAG5DolGslWsgU0cp0uGd0tG8X4yKVe+gNL1JUia5woENpyS?=
 =?us-ascii?Q?cilVQeRVcUi61kCj+z1hnl8JR2P1ttqeHzVcCrawpIJDuQI1ZDpFhh7VUPGs?=
 =?us-ascii?Q?7J5TbMC341Vq7trV7yRhVODMJHps2OaiYLXBrL36GSnNLa6VYO/xXV6kV5jt?=
 =?us-ascii?Q?x4IBlGLP8JRkbp6cKukHyrVav+Re40S4c7SqffxtfOLRgRJH0CzFZ+IDeXfz?=
 =?us-ascii?Q?PG2kt+doIkpTPvmMU3fyfWlnxx28YXtq0AYbYZeT32PiymJsJ+YIrBJoA+Fh?=
 =?us-ascii?Q?YyHQIM6UJL+WIRFn7kpGeYmZthqbuKyDTOdmMCCdox/BndtPjhA3yA+EPEn7?=
 =?us-ascii?Q?esneIPjlTi/iUmE/z/qqfWWr0brBDL1X/SY4f2p1WPGBD8HT+yZh2ZbmH3j8?=
 =?us-ascii?Q?0DdeWhbOEqMXAIc7Z6E/6/zVjJG3lkjSrLJTuEzvLxDUP3JRD5wkkjAdmreJ?=
 =?us-ascii?Q?OcH8qPAQXVEuVJ3DsGWiNZsbYB4Q+1LfY7TBZ0x2I5Ne/VtbZfabCFnostZF?=
 =?us-ascii?Q?09FQL1A1LbncDAxp0igF6dfah313VNQr+fNdl6fpbYE4qcgNlySmp4+a1e7+?=
 =?us-ascii?Q?rVVWNNcziMRICbiALQlRdUc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2580750-5cec-431b-d276-08da9c4f1b30
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:20.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YXrYbV12oUfzP5/Dl1StfPLiM11Y6tBAvSZ2vJqT5vaBmzkqL5r0DiR6mSg6JiGYJwWkvm0lC6yTOQ+xUSLKodNEab4o6pOVhXsf+GswNU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_regfields struct is common between several different chips, some
of which can only be controlled externally. Export this structure so it
doesn't have to be duplicated in these other drivers.

Rename the structure as well, to follow the conventions of other shared
resources.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v2
    * Add Reviewed tag

v1 from previous RFC:
    * Remove GCB_SOFT_RST_SWC_RST entry from the regfields struct - it
      isn't used.
    * Export the vsc7514_regfields symbol so it can be used as a module.

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 60 +---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 59 +++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  2 +
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index bac0ee9126f8..6d695375b14b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -42,64 +42,6 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = vsc7514_dev_gmii_regmap,
 };
 
-static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
-	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
-	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
-	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
-	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
-	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
-	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
-	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
-	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
-	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
-	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
-	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
-	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
-	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
-	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
-	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
-	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
-	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
-	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
-	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
-	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
-	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
-	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
-	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
-	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
-	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
-	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
-	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
-	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
-	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
-	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
-	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
-	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
-	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
-	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
-	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
-	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
-	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
-	/* Replicated per number of ports (12), register size 4 per port */
-	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
-	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
-	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
-	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
-	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
-	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
-};
-
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
@@ -142,7 +84,7 @@ static int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
-	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
+	ret = ocelot_regfields_init(ocelot, vsc7514_regfields);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 9d2d3e13cacf..123175618251 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -9,6 +9,65 @@
 #include <soc/mscc/vsc7514_regs.h>
 #include "ocelot.h"
 
+const struct reg_field vsc7514_regfields[REGFIELD_MAX] = {
+	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
+	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
+	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
+	[ANA_ANEVENTS_ACLKILL] = REG_FIELD(ANA_ANEVENTS, 26, 26),
+	[ANA_ANEVENTS_ACLUSED] = REG_FIELD(ANA_ANEVENTS, 25, 25),
+	[ANA_ANEVENTS_AUTOAGE] = REG_FIELD(ANA_ANEVENTS, 24, 24),
+	[ANA_ANEVENTS_VS2TTL1] = REG_FIELD(ANA_ANEVENTS, 23, 23),
+	[ANA_ANEVENTS_STORM_DROP] = REG_FIELD(ANA_ANEVENTS, 22, 22),
+	[ANA_ANEVENTS_LEARN_DROP] = REG_FIELD(ANA_ANEVENTS, 21, 21),
+	[ANA_ANEVENTS_AGED_ENTRY] = REG_FIELD(ANA_ANEVENTS, 20, 20),
+	[ANA_ANEVENTS_CPU_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 19, 19),
+	[ANA_ANEVENTS_AUTO_LEARN_FAILED] = REG_FIELD(ANA_ANEVENTS, 18, 18),
+	[ANA_ANEVENTS_LEARN_REMOVE] = REG_FIELD(ANA_ANEVENTS, 17, 17),
+	[ANA_ANEVENTS_AUTO_LEARNED] = REG_FIELD(ANA_ANEVENTS, 16, 16),
+	[ANA_ANEVENTS_AUTO_MOVED] = REG_FIELD(ANA_ANEVENTS, 15, 15),
+	[ANA_ANEVENTS_DROPPED] = REG_FIELD(ANA_ANEVENTS, 14, 14),
+	[ANA_ANEVENTS_CLASSIFIED_DROP] = REG_FIELD(ANA_ANEVENTS, 13, 13),
+	[ANA_ANEVENTS_CLASSIFIED_COPY] = REG_FIELD(ANA_ANEVENTS, 12, 12),
+	[ANA_ANEVENTS_VLAN_DISCARD] = REG_FIELD(ANA_ANEVENTS, 11, 11),
+	[ANA_ANEVENTS_FWD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 10, 10),
+	[ANA_ANEVENTS_MULTICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 9, 9),
+	[ANA_ANEVENTS_UNICAST_FLOOD] = REG_FIELD(ANA_ANEVENTS, 8, 8),
+	[ANA_ANEVENTS_DEST_KNOWN] = REG_FIELD(ANA_ANEVENTS, 7, 7),
+	[ANA_ANEVENTS_BUCKET3_MATCH] = REG_FIELD(ANA_ANEVENTS, 6, 6),
+	[ANA_ANEVENTS_BUCKET2_MATCH] = REG_FIELD(ANA_ANEVENTS, 5, 5),
+	[ANA_ANEVENTS_BUCKET1_MATCH] = REG_FIELD(ANA_ANEVENTS, 4, 4),
+	[ANA_ANEVENTS_BUCKET0_MATCH] = REG_FIELD(ANA_ANEVENTS, 3, 3),
+	[ANA_ANEVENTS_CPU_OPERATION] = REG_FIELD(ANA_ANEVENTS, 2, 2),
+	[ANA_ANEVENTS_DMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 1, 1),
+	[ANA_ANEVENTS_SMAC_LOOKUP] = REG_FIELD(ANA_ANEVENTS, 0, 0),
+	[ANA_TABLES_MACACCESS_B_DOM] = REG_FIELD(ANA_TABLES_MACACCESS, 18, 18),
+	[ANA_TABLES_MACTINDX_BUCKET] = REG_FIELD(ANA_TABLES_MACTINDX, 10, 11),
+	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 9),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_VLD] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 20, 20),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_FP] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 8, 19),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 4, 7),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 1, 3),
+	[QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T] = REG_FIELD(QSYS_TIMED_FRAME_ENTRY, 0, 0),
+	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
+	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
+	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
+};
+EXPORT_SYMBOL(vsc7514_regfields);
+
 const u32 vsc7514_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index ceee26c96959..9b40e7d00ec5 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -10,6 +10,8 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 
+extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
+
 extern const u32 vsc7514_ana_regmap[];
 extern const u32 vsc7514_qs_regmap[];
 extern const u32 vsc7514_qsys_regmap[];
-- 
2.25.1

