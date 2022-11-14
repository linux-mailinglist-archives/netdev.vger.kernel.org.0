Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5A26286A3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238179AbiKNRIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbiKNRIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:08:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D54D2D74E
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:07:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Io2vbXSteFg5ywN/nBfiCD0Ctgivg8+e+iTJmtvKLMTpBsWCcU+cDvrszdi16fNhRah09ZM0DXJFZ95Ap3KogP/8pGE5059vRSdTyBtG9wsGWhni8j5QDOYnOklf5FICBQp4V9NddNR0zCEDZ9kZuuO1c4J0BdgYRIYKEgyW9izmrrUsO8rPS1K9ABlQtz4dUZPEPold8/MnYw1usSJQpc9S7bzOlFUcyCWVTfqqKcaC9niX7yuDHtOUlr9TJHXO7Kg48DSV3YIdiRKmWhk7vHMaTXkqpMePnQ67Bj9LBpLZtIPNtIl0HlQYZr1XaBZDGcVBOFBfRDqoCNT68MFBFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWu7D9edz9gc/S9RYMQWUQ2MZ2CorjnfC1mqyiypfT0=;
 b=TGRxnRFiUnBMOj0C6UVndvXKFxyH9f4IGlmBD5cr7xafXUYGDR++W2lcN2O+HLMnZ/UvxedEsbpipjHdlMGEY/Yc6r8j2y/1nzGJLvWebYxjgApcczGVWciSDSX1tUpLhyaCOm7MozmucMOb3NfKJN8e8CJdh1TV0+C8zuUa3o17vAicz01DyWim+xPQd1B2vuyHbv6NvtMgWm4SFDWdPDUwZbIlNWs+86pAjeyP2g2H7vYW4PMRRW01p7Hrsxgp+F1cxe+29tn7hgFS36wY2uSeq34jtMRB6hXNhvcEj+n31zxUQq3IGWbZJPhOZsm/A0inEaL9DgqlCYxx0mM1aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWu7D9edz9gc/S9RYMQWUQ2MZ2CorjnfC1mqyiypfT0=;
 b=GezGF+1mJoyf/xxu+PntWALR6tTdOYLwQpUI+shREJIVAgVPA/QFgd6ICZTjIk/5SKJh2hZ7PTcxtum3iHcY+U69rj163aiJNod3q/xnVJN9BYIS4L/oRLHH83WfU5/MoNYhK6HXfFnQ7weqdsvkyWoFz/F1/cujWTiLWbSoQPg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9280.eurprd04.prod.outlook.com (2603:10a6:102:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 17:07:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:07:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next 3/4] net: mscc: ocelot: drop workaround for forcing RX flow control
Date:   Mon, 14 Nov 2022 19:07:29 +0200
Message-Id: <20221114170730.2189282-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e5aa05-f719-4955-8685-08dac662c624
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r1BUKngbtHqPm02rdCqvbLd/QqFPxJMpc6J+xO0teQQND3ucUpw92U+SZDbCzJgDTAWZPlb0uX40PSIKwmSfwZ3VxJs6zUYP8UAsmnjYM/dbk8v4LeoTtA7jzgKInhFWQ8vTa4PIZae8Akt9QwHk1PWwE/Lhrdx5/ZdYilU6aa+ptrn+IzphjCFVPZ61Rh6szPHgAtgOt1oPbJPC2dTVvegevNmBWvbmsS3bBl+fij+Ziv79j/0hngVoEvdH61bPKJkFGeY+Of+fGYGrty5YIXMZ36OAtoDixXNogga/AYjr6z5edJ43eOrPmjJlrayxK/QOnj5p+f1khVmUNyRBzHXwR3ID83cNmsmF0QLIYGJr2Gf0M3MJcSp9JSXBkit2njhPSlTOgXWlx/V1ns83tE1E8vwDbcjq/7zCxQ/j9sJfDC8GEJ7/XhvVcWylsMx4HGnGO+M5k8sfHDSUxNN9vs76nDz7YPiUkZW1AiCaY0c6Whm4atf6NXY1cUT1PbOypD9YvGXtDq9xhegesDVj1IOBYMZlyTSx8D8qk0wmoxekq/lYRRTPC24ryIH6qE3PP1+kMpsDcFBFrTm9+oQv8PHJLxeKD0/Trxhf6s+W++CufgNEp3fXwleo2ukUsldXeFIpE/q5VFMtpg3tO+kb4/+JWMXbHD/oemBHDmaUcNT7d0gg3f4NNmLnUYevdW9/PjqQqzfHEFM+lhVINYY2FfmXzFbclcev+7xr8UaB+FDEo+ziVD7PtO8ubRbo5whdec7knKyAgxAUJWKzKHg9xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(44832011)(36756003)(7416002)(6512007)(5660300002)(26005)(1076003)(6506007)(6666004)(2616005)(86362001)(8936002)(52116002)(478600001)(6486002)(83380400001)(2906002)(186003)(316002)(66946007)(66556008)(41300700001)(66476007)(6916009)(8676002)(4326008)(54906003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I3G8YaPoUbwg7KTnOlkd32PW1SRl1q/LkaVfLJ/gZePkC9c9MGAG2sLwWXPR?=
 =?us-ascii?Q?2DH6guIUgCo62YyzhgE3hjLf/z6BBXlhzTtEPBRkWYPdVMou0+4vThBY0dNL?=
 =?us-ascii?Q?6vQv2au50JDHhC2a0b4VAe1Gr43+o7hnbdOubvp1mS17z+q/97xEol53EvPS?=
 =?us-ascii?Q?vQn79vusGjlJTN3X5GzE0fXHQpTsUc0U0yVuAZ4PK0OnwCUeVFdwYuvROxPk?=
 =?us-ascii?Q?CyApnvn3VcSmNOmQsC1xYEH00qJ8s9NrzdNCDgrSYbuCFyxFz+rROaBmDM66?=
 =?us-ascii?Q?n2LavvydFSyYVE87GsPWpcis4TxSG0G3tIFzBNdk6h1DckTxscQTk55KhvqI?=
 =?us-ascii?Q?KTHE4VR0GBFzfiZ/Qdlh1Y1IXvhDgY++C+tKX3goBkgBz7E9tCHshV3/z9le?=
 =?us-ascii?Q?MPx2NMbR21QmCOgr3JPq9zHBz3nDEkJwUbP0Vqwn+z4PevYa4xCKTmWlyCue?=
 =?us-ascii?Q?S5REdpo6SME0w2+Nd6ity6Q8OyPY5zyDLvN39RMwvO/4vY5Omg5ySkgDV0wl?=
 =?us-ascii?Q?0Z/NEKKV1HWqapdUWPabLMc5v5ubhKKcQmTwf+ao77bvV+hX47UaRrp3tR/b?=
 =?us-ascii?Q?e8ngy3/7/hAbavBNmtPpBhWmyAIGI0MnL7cLlcQ+42BtAyZFqwdojbNHOATz?=
 =?us-ascii?Q?SJl1bCOZgFc1bRW0SOeCrmt547ltgHWbLWyGCFdPb9B+Uonue+X5afbE4rB2?=
 =?us-ascii?Q?BNIdVHBzE9xkU5x7jlt54iCwTkhih8nKNbZsAWr5qITt+Kx6S03KeLaevfYk?=
 =?us-ascii?Q?076aANeCqLZJ78GamB8RHpi3onyDAobQBvo/cE8oM5ywqQUSHh7sw/PK0D4a?=
 =?us-ascii?Q?fUTC0Xp6Dkf2VSYrNyg3FEnfEcj9MhsQ3JnGTpasJeXVx55WnaQwfkoTCJ+w?=
 =?us-ascii?Q?ef2Vf+LzHZQFk1e4oF9H7xIEWK0N5tR6O5l2VdXs1MnHsyigEble7DhiTt0z?=
 =?us-ascii?Q?PW5MQ0ElmUmQ3/jgQJueZl3/RM/pjhwDdxCnIheAlHvdaxk8d5IUrUSJo4nZ?=
 =?us-ascii?Q?vAupKWFagGm1uLMOS58lH4yXA+Kf8ImjwYzckEFWbq9ntHNmxX/5QIJC/AV+?=
 =?us-ascii?Q?X8f017cEOZZQGKDs6xgebR73xFPydkhNr4muyVUKJVXBGmmYCPDfV1bP5Aeo?=
 =?us-ascii?Q?l2lDxT+aCb5WbITGwtG6vVk6HqA2TNVXpPfDNOEVNSBbdwh6Yj99DKD8ymLV?=
 =?us-ascii?Q?ZUM6womM5Yjx387usHNiDzQwkVodzaaZ318p3VrFSnIPXpHQsGBy1apBDWSD?=
 =?us-ascii?Q?Y/En4rYL2YwEU0D/89wbiJrc3j0kmFrlCm+ou2b9y6cnyEAysyoQttXPwP/a?=
 =?us-ascii?Q?Ik1oP0JxGlKZMDBzOwmt/A0joYmA87ldLrnjxOAEQxfUX/sivKS7XWYc57Q0?=
 =?us-ascii?Q?fa368f7IoiqGVGdkFYp4eF1xx3Zx7nurE/FT2BrdhpjNEoPyFHdLclYHjQ+y?=
 =?us-ascii?Q?oPA4UH7l4++k5oMZUIPisMkLzMjqHaVNmeqr1wyzt/VzmjByzLgOWuXC4z4x?=
 =?us-ascii?Q?UQ7B/D5S3P0IIhraFQLVJsnjQUd0a0FGikl/qEYlNy+hh8JAY1BDazSg98A0?=
 =?us-ascii?Q?ukJn6v9MZ9YL6DjEBopMoIzVSZTCpOyR860HcIWF8BhiALLHEUOxsUeANA2y?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e5aa05-f719-4955-8685-08dac662c624
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:07:56.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbCHhkRcSIzig1EZ2BKImbOcsZEWAfW0tsncKDcLqNbzwZAwGM3lqDy0oUKLJM1yZFYylv1OccOnDwc+uJZ6IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As phylink gained generic support for PHYs with rate matching via PAUSE
frames, the phylink_mac_link_up() method will be called with the maximum
speed and with rx_pause=true if rate matching is in use. This means that
setups with 2500base-x as the SERDES protocol between the MAC/PCS and
the PHY now work with no need for the driver to do anything special.

Tested with fsl-ls1028a-qds-7777.dts.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 13b14110a060..da56f9bfeaf0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -872,10 +872,8 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 		return;
 	}
 
-	/* Handle RX pause in all cases, with 2500base-X this is used for rate
-	 * adaptation.
-	 */
-	mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
+	if (rx_pause)
+		mac_fc_cfg |= SYS_MAC_FC_CFG_RX_FC_ENA;
 
 	if (tx_pause)
 		mac_fc_cfg |= SYS_MAC_FC_CFG_TX_FC_ENA |
-- 
2.34.1

