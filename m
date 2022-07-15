Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E4857698A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232112AbiGOWEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiGOWDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAA98D5D3;
        Fri, 15 Jul 2022 15:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZX5qQ9s4NTJCBFr295bjIGsJukRWc+nQaycgFoi6A9txQVh6wBf/wxK42KKM1k8ck8ChDJ2fBLUdAaWp6y8dTdj9YTzVTXalhSS3uqeWyDHDPp7qv5A18BwVxsun6LjGeNpnxrkko7/Dk+jU1Yftb0/nhaEVWWVhMz//ToyYRifo6tRc8JZ9vHbGSt/uCsPUh8NIsq3o+0/F08cmXcCIjn2PhsaD+Cp6YE05Ba18hhapwXXR01bt2aFDf8c+6zhQ44kHpjMNXQUeQGO69rQXvXtKIWOxCDmdwWxeo7hoAWxm15X1b4J3zBZ45fs1LTsBRJAF3zXEpRXoaCxmpRzolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/eCJbGAHSHU8+ge017Q4V8y5RRgZqs6L3IicsKbrO0=;
 b=K86MvOsIt/oelAudP4ipuwx5dHAeoYk/okmDw3CDRVNZGUGzr1R5nYkrcnu0iOI2mL5PHhlo7rcjHVPOvDNjJR7OrcJbwwC/2/VWI1LhofGG4OrqQAge0CJy6kYFXRSEDsxG1IQIgNB5/X5BPDo6U/pGO4MeK8HI6TKNy04V+A7k/ojFaQw3VdYFXy9+yeOEcXO4gOeG0SwABUFtrixpZkNFRWDxn23BdYT2qhzkGXMW+djIjeI8cPAzmcKQUAQvpTyYMQ6tAXAoebRxGkjTYIyXRPvS1knciklG76hTza9lgocxD5gVn00FrwhKGexCx0eBKZWVY3zHMaKIsDtvhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/eCJbGAHSHU8+ge017Q4V8y5RRgZqs6L3IicsKbrO0=;
 b=ozr/M6mMBcKYtaBa/eEMRUrRWk1t2/pmrsZ+BYVKSL9J/slMawrcuwWOrfY/86oggbJX4qhRYSkw0KsfCc2X5FuLym4xBaJn4iSht14vIAKzXVe5k0czZC9BjJnmOm6rIAw6i1eXMCafExJ9Ftn+MjcXDMwPkga1N2J53YbsBZRW/siGOmD9LyjmgcXCQCsX5lxukL1IxeJWbyexzt2mmTAsEL1XChJFvnLaj5iY3uTt9B+usrjVQwYGsP4BpvLm1Y4eXHY+zeldGVso/Q0kWBbsgP5dcwd+6gXeyFJRdqxuABe8b+Y7bh9li8BxUOI4zHm61g0phmU33ZGSFTOmNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:08 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 24/47] net: fman: memac: Use params instead of priv for max_speed
Date:   Fri, 15 Jul 2022 17:59:31 -0400
Message-Id: <20220715215954.1449214-25-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14d9ed15-2813-4189-9053-08da66ad8567
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjr3X0PcLhYy0YZMKAjxL7/9uCGnUayvkOkoN4wRuAZC0p9lDbrhAycu0uHx/HTipcGoywcJ4nov28aCJvDO8q48j85H94WlECF431I9jfQzHy0dn+8ASuMMcCa2ud3dVT8n2IrCnuEKxXFt7glXHtfRGXchU214KaGabE9UVrNhlrJMiz7tMruU1wzUbCc/rmIjLF0HT9wDWgm67S57aNgT+JQjxca5tLD6/Pl9KZ33yJ4mXgch4JbOUp2+F2OO+DRZY0IKJovzjtsNGk5cA3As2Y1wzVAONR8iOiRU3elPHKhcgBNfUxUmS1TfwIC2e4ArljWAk9WGtR+U3shvqyc6VGaav838hdmddwDKmPgnToVUjgBrJIR+tQqxRzsZym/XTXFNu6M9zLkNXgQZTCUikL0LJoxOEy4/44GwV6yqA1gGS0Z2ryeYJdgn9CdqjlC//PV7HPMSCgePRPuk43lhk5qH8VnGX6l9O7tdJSa9qqxr2DqKcuMGUFxlxC71R7zz4ION2WxYW5ZCW8Yj/FqElgBL9h6JFuvabqucCdjRX9KQoCrodRxtlvfsVH6dv7SSBlWA0mMjsBuK4GRgZk7pIP0ccHsg7Jxd3Ns2mHbW6cXZ/jHD82iXAnmee2UH/sKG9pEdADNiiCluLk/PtwB0AK9lq7D82lyLZ+wj7xtqWfnaldUEOcivZzDY7tFJ9SjQegQ6Sioljf+R0kRBJjBXPwMj2Y5Sy6JtTPZq1cptse2cTik+Pu/C14MVApnAkfKFf6CFZ0odep+FFN3GO++zAFc3hlXTFSb6VxpKb3nbCUcwxkIvYWKl/HpEqYnH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jJQaDf1qm1kc8wHsYeFx1/cle7t9CPMOxCPpD/0hfwBp4svuLU/vJSZZOiS0?=
 =?us-ascii?Q?WYL9nluvfEq+XWDOG4tbzBHOM1cMSZ/NjDeRVt/E11OCHkdH/uTXFhgSuoUi?=
 =?us-ascii?Q?HOnAWYLwGS/Zn2VJhmjXuzHOSXr/4UUU0Vvwxst8uU9cZYodllerTKT63Ys3?=
 =?us-ascii?Q?CYN+dKMSxA+xJemHIN/AebOIRUzAmjLFASN2rTaFrsNC1KqcCmJPNHU2VTwT?=
 =?us-ascii?Q?m2VYPFRuJfk9z90y0A/xIY3bXVWiDuytJCRmtLdj2zpcSTQmdJ1uf0hDdxC5?=
 =?us-ascii?Q?RpjUFCX5fK7G4S+iQspjKXnWZNwnba/XJc1ic9mOXGSPzzl5sw5IgvBBXT8B?=
 =?us-ascii?Q?aRuqgj2xAC/xOhg7W6L/CKyyfl2z7JwLXQrRHXc2PYAJg2UzI+6UZRbC4E7O?=
 =?us-ascii?Q?uusrQ1of8P6c1IW9UE+IYratAPi0MMnsB9YRl9QFQ1RgBxIRT7B//z2ijbt4?=
 =?us-ascii?Q?fmCmkRCkwyxanM2wE1M5Irvv1WDjHMwXgfIGTuV5YuTEQVcfW2bPODWCDWUz?=
 =?us-ascii?Q?K2M/xCKdVTV6lUmkRfnvDMhA3R3ucPNavhqtmZXRyJmuru8r9pFhYlytP+BP?=
 =?us-ascii?Q?vzDhlcH14DwIWILzp8rLmRdBBcdfZh/9rwSD5ioZAqHxc2+wUmPW7HRgetsK?=
 =?us-ascii?Q?hzy7zd4yjsX382STvbAV4idEVbZCHpHoVb96WPT2rfnuRQIP6MXmcl6+4f69?=
 =?us-ascii?Q?nj/6Ob24oYaoPOVdkZknByzbncMBf8AYkULlowp3x8e3Vv2I9aoBkfId/N02?=
 =?us-ascii?Q?j2Eq+LiL44XftDTAmKdbJS+OBbByk5HEUjf1axcrgec0nYOMwVQKil374K9b?=
 =?us-ascii?Q?XOe5fjACogYDMVZlM0XmEh/24bWhEWNjszIDzT8pqRtxztfzuy2iO8NZRGWB?=
 =?us-ascii?Q?vQZqD/I6aI1OzS6fOOypdaD1XHq3/BTVIk0l5XBr8pvCgI9+yDZaFmj35oQr?=
 =?us-ascii?Q?lQzSk1cA8zWolPf2v3Q5huXqvy1QhYhaNrjDpxYl5F7lst9NYUI/Q4BhtK/k?=
 =?us-ascii?Q?769IFVfKPCkqeLdCa4ZM4oSTNa96L2Cg4nvvmc5B204+3sA+FT8vsnLwgoxi?=
 =?us-ascii?Q?t3fnpArGS7r4hfbRNoidmT7shzyX9RC0P/8Q0fmqzutFfEDE2rdchAZouzm8?=
 =?us-ascii?Q?hMO40E0YezD9VcoOevAlI2W3MGoGYhVEYaKQNH8JPyR+AKoENNEeqPUSwoYO?=
 =?us-ascii?Q?GGg7y09u8JUVuNfTixdGDcLOr+HtoW+L0LUrPO2zAvEU4wut0ix2JU37C6BE?=
 =?us-ascii?Q?ivCF48lNrKAoUDMXjsvppfNLfYzT1jXq/NV0FeDj9fTOJ2VvizQLt+wxHMtt?=
 =?us-ascii?Q?2FJ6jxIZgxEMnTWh9X6FU4uC5vzSLcfyrZH+OLvepz6lEDq6gR4O+OZrgnkg?=
 =?us-ascii?Q?NQd2umjnKw7Oc0dBTUWF/+y3T4OkLM2ryqeHxf2oL2X6byA4I4oB6sHyq0lO?=
 =?us-ascii?Q?WzAbGlyz2jMk4mrr2xogq8/KMf6tExRJC9Ap4YjgAR5SIZaiaQrlkiKHH/R5?=
 =?us-ascii?Q?ivljhsdLhSD1OYOKC4kXVP6tHdYesPlfMBmWggZDVT86TAgt/boXDtACjdDb?=
 =?us-ascii?Q?R+LgxevCIEcRSr0zpi6Stp8+/p+V03va4onzIXua8pHikMfSKUmTTmHXnRu2?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d9ed15-2813-4189-9053-08da66ad8567
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:08.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAF2TcUkX559nK/DhwigLZvo6yrn7/T7zmaF1Vc7grby1VWlXdexN4gSOiWtiDzkCkf4Ki6IkloWhbKcVk+4xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option is present in params, so use it instead of the fman private
version.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0ac8df87308a..c376b9bf657d 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -388,11 +388,9 @@ static int memac_initialization(struct mac_device *mac_dev,
 				struct device_node *mac_node)
 {
 	int			 err;
-	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 
-	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
@@ -412,7 +410,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 		goto _return;
 	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
-	if (priv->max_speed == SPEED_10000)
+	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
 
 	mac_dev->fman_mac = memac_config(&params);
-- 
2.35.1.1320.gc452695387.dirty

