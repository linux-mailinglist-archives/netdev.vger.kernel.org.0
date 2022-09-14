Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272375B8BEF
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiINPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiINPd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:58 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27485A880;
        Wed, 14 Sep 2022 08:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irPy2czynkLm0r26Ojf+1s2paNe5PScYmOf6vu9oXvVjoHJ0I7dCnfd3ePsL1fG0uVzOh0X7YGbPWGxUDm4zB02QMbJj3gxzKZHpdic8mbFL381d7xuzCwZXRmXQKygurx2ba/Oqk5IImjRLFZuYOd2+hBgF/QMfZfcDrQfqArDtXHYroyc3nK9/Lr05RUoh8BaPSraEH4gi0Vh85tkX56nAwzf3A8a1ZnzUazzHmifr0Koc3553rejhbe3sON5zLEDCjCgYkc5FhLiojiznnx5l3sFm+3ALWaLsMqrvRDkKlcYHf6kvj9QliUA5DzCLk9G+jeHTLnx3RwYBD90GVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubhvkhydI1YwrMu5jzggcAY5wglPzG8YmxLJR7Kg9rw=;
 b=LUSa9WzM4/MPsI5YgpY9T7SHf3I7SxCQPsxeNtwOILe+kNg2eUPqYc8FscEtMnLJH36C5vd7hW+JDDcaTjchioNc03DpJ1yRKk97idAHcSWAoIiotNNoIFFMtDl4I576YgOxQ4UMVtVbdG7DJR6VzP9vmYB2dMe6wBProVZk/ExVc2cnrgxTuGz/4RI0HoRWftWUJB7u/jksR/PSqusaWE7TELDmfZ992QqrBE9fr0hHDuhjYwtIzOI5sFT1l2d44OsCQf010FpORmxklqb/WWsI7SL+1jG322I6fFRCHkGqOMZXQZi2bko++MzJTOyyUdus/cmnT0Tui5nwGYjgsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubhvkhydI1YwrMu5jzggcAY5wglPzG8YmxLJR7Kg9rw=;
 b=Ze+0htSAtVbtoq/1nvk6SiowwDS9xBGxY7d32u2lsF8FifpxyfKo17SPp6g9aK6xyTGmeFyV9ilP9rdAH+wLYhv/vg45F5mZQCaNlXKYENNLfHF4+WzughlqDwMiO+jQ+sk2eh5OVW1ji0YgQfsbG5WpdS3OQDcc6YrY1K5rU9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7908.eurprd04.prod.outlook.com (2603:10a6:20b:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/13] igc: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:33:01 +0300
Message-Id: <20220914153303.1792444-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: fcbbced7-a60d-4ff1-1a4c-08da966688a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RYEd/kyN+Mq4TKap0CfRHPzrWdxstWPnwqSr2AtuEoUMgTex9qzZi8RqM1fcGt8OdRUVEIbP3sKhU83SHJYiOknwDVYddyua8iIEkMDJwRlQBdzAlZx4gXQz5FqQBrU9WLjf9UtOcfKwEPlKgStJpOX1s24kTxvc1UOjhcGOBmjKzyFeMkxz7hafC4yRtuZ8IQCKCuah36PmIDnQpnieoxZ6ozqU/05WOfg7WeCrgO68tgSg55ZD1xtTXrSBJ/RdMIEA9vZq/rQAEuFj0oFw3NWmRB3E0jIS8ejRP1e3Hiw8+xW4LvYgWidCTtvcrvgqt7o6N2BSx+QifbPPVu7kVk7LIoOXfsADjJZNqYv7kCTi4h5BeTSA57t0llS6v4y6hAthlJu4aQvm7L/+bvMxzfNSXjj6sGlfK29GtafHrPl/QPTOEbBBt8zFqh0m0sZja1HtjBCakQbBG2L5HO6fEkmzAn6TgNCkVj6FKSNyM5rdwAYzssgzbdJ96TN6UaZc9X3HogvY3LJ+U0Jw39KK4VyAsw+O0OipQn26ux9jnrWqmqtCnowRJyGF8+9D26RVTGIcS4DNQpTPkxJVUO2M1VRRmdhROpSAM9pVCdqYwnVf7eMaqKbOPehy74FoO7CRjNDz861a123OkwiMXK1A3y37lI2NUe3Ps1ZYi26xVJQh4CBKBQ0wdqCleLoSHcwb0Nf2R9OYpyDSTSuaGysy0/nHG6o15KoF8XL3g3Y+Yd6PkgCKYHcWVSemfudyx5GiLvJbuXKsoPaLTv0RLNHUT9zLWhV+ithSqOmbE0Kp/um8J07I3X/O4gk5uj4WifGb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(6486002)(83380400001)(186003)(2616005)(1076003)(8676002)(66476007)(6916009)(54906003)(44832011)(6666004)(4326008)(5660300002)(66556008)(86362001)(52116002)(66946007)(6506007)(7416002)(6512007)(38100700002)(316002)(8936002)(38350700002)(478600001)(2906002)(36756003)(41300700001)(26005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IzL+N7nuJCKItJPOgiEExW3S4mIbsSBUHElUUalow96AVo5fNdD1F3nbYQ3V?=
 =?us-ascii?Q?smwVfmUVZ+tBTnyhHGmmen5/XV5Kdel6tBjRAF3VRSV1KJOtTp6u7GohrOTh?=
 =?us-ascii?Q?4iXPLTXxuAN/PD473PhYnHgktr3Zi9RwEfYERl+55DYpxXd2YHOQaSCmkoaH?=
 =?us-ascii?Q?IAW3YUQEOmY3FeozxBmgMg5CJQXskehkStPUrddhyJVsUP9x7L+8qluIm1uB?=
 =?us-ascii?Q?Mf880nYqIxQAB6XXBeHh0VHPOxj4besUbsIXvG7n5dyV6NnvtD3v34lh5Css?=
 =?us-ascii?Q?uGBE31pzNZYqOyavItCvd8Vjz6CyCjIDa0OZ+ZOc/arVlaYbzca0gLfDunqx?=
 =?us-ascii?Q?h1p4za55zNCP4Se2deDlMn3RVVkLK+diRj3bC1bLLwZ7gO7TwnOtpwMQewdv?=
 =?us-ascii?Q?C6yDSG5khHun+gpc19ep1Ow44sUT0bgrD4Ztx4UvcwFUURgVD7IVd/Bbs4yL?=
 =?us-ascii?Q?cQdRxQZFxO7kP3vobMuf8AhUZNQ6jg6upY3XsRRdOoLhe07MmnGMDB/gPGCX?=
 =?us-ascii?Q?054XkqS0+Iu1L6cPzIos+pqS+hCfcytDSuiIfDbINOtlxE1boYtUgaejoA7K?=
 =?us-ascii?Q?QaEzMdpDYeVjY5JBGsdXPbrBvrUbrxdh2ofgsa0c8cTSgwZf86F+SlBBmwyS?=
 =?us-ascii?Q?MlV4yGIF4R6YMpb2piuzIpaOu9nQ+HUlDd4zMGXY2X8eSVsSwY5e9ZyW6e7d?=
 =?us-ascii?Q?3gzpDdRn+ssB/68lf0gK0tBXcZtM/W3f4kHMD6/I4ulT38rfU0igC2BwBpMj?=
 =?us-ascii?Q?ZIP29JDV0lRObubudCResvHDURAa7t49LkZNos02aVjXcqc8kHgkfz59FRSC?=
 =?us-ascii?Q?IWhva4dKcQNxJxCr6PK9MZiXvIY70pqlWYiu8TgTMw4xRUg5WlU5cFYUfMjL?=
 =?us-ascii?Q?WXHg4hJ4iacBmd1+QjSjZ34J0dyyVjlxe8TYD+JuTzKXxaK3HyaMdPwgsaU3?=
 =?us-ascii?Q?BdYObmsP74dD6T+/B45Gia9UH9LyafVhsyFyUFy339tCP3AiSrZD+Vf99ibM?=
 =?us-ascii?Q?vwmZr/AoLhZCdTojXvsx8lTyu/Osvse/30RKapayCuLW6iBoApbX6rWXCbdA?=
 =?us-ascii?Q?wuRQ3USFCu6VkFhz9UcF6pe44WnYHc+wColnXMYcbpC0knxGikDMx842wcfV?=
 =?us-ascii?Q?rNlOnhqcVp5dVo1syg7IHrPUnUm2KE8hQb+5l/sqSnnk8k07ekQAzFH4YOvF?=
 =?us-ascii?Q?1j1hyrUK6IPEdRGJMKupCfWCVSVmu85777RLdiCADZl0T1zDlsEq+vTDWEtP?=
 =?us-ascii?Q?rYc0IAP0rxCWfPaEjr6XcUI2YrSUJHeCFP4IpHcNmQYHmBSnPIhFvIwl9t9A?=
 =?us-ascii?Q?SlELmOEzbmygTJp1jzsNh4hSIDKgH2bzQiAvFGeSHlAaQILVZZEOa2iKLloW?=
 =?us-ascii?Q?uCM7hESyDHcPuPaZuXbub6tz9TYASg8d93CQFTbyvCiBkklM3b94Gk5lI5G+?=
 =?us-ascii?Q?BpCeEw2wXwREC1tkASSQ9lhpnq+GxO2uW7dz/MNg0vvURqObtucoUvheNAnw?=
 =?us-ascii?Q?g+8Nn27xF6jRchR4ba56mNHkZ/xKeNBn3aL/IwDByu57rMjzsZsAqrRaV5Oy?=
 =?us-ascii?Q?1/N2ERivv4WXW+4qE5y7St1Kw+v94/D7spPzbanzlCck+kXN9undIIT3k3AM?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcbbced7-a60d-4ff1-1a4c-08da966688a4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:55.2914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXpyx1vLNn9ysZC2SftH8LEZd4QNFqfQQvE8Lk6pmOq8S6EGILS0OzJWkfIehDRyxJJl+W83Umu79BlN+pw2AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7908
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index bf6c461e1a2a..47fae443066c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5965,11 +5965,15 @@ static int igc_tsn_enable_qbv_scheduling(struct igc_adapter *adapter,
 					 struct tc_taprio_qopt_offload *qopt)
 {
 	struct igc_hw *hw = &adapter->hw;
-	int err;
+	int tc, err;
 
 	if (hw->mac.type != igc_i225)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	err = igc_save_qbv_schedule(adapter, qopt);
 	if (err)
 		return err;
-- 
2.34.1

