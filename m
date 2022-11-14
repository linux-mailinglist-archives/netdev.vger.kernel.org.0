Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6766286A0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiKNRH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238156AbiKNRH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:07:58 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432E32D75F
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:07:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5GkH1u5GCNoMExZjSU8DQhwnKGw5S71P06vO4d3pjpKRwlqEkfr5zrGxCbtZ/s+/UnHspVIyMOyehgYbIYOQZsuMs46AKFhHA6aJLF6qTQbsp4pB42kkKPPPNnw8oWYhY7k/obzjTSnmg6hP3p+if9Vh3Exn9PjeHiOcZ2MRh4A0WWonP4NWstvm5O+DkPza9fkXocTC6mf/JrnrmoK/paAcL1EINl2NzIqaSXWiO/EwNp7Mx71XTseiHdrN2IT3jomIyI+RNw+kWDpAtMpWuW3V3jagJN/xI6dQoenMPh5NLf5n1S93v3qKk743cs9xORnjlYXrA4Cvf8lYLndEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rPRt/c30v0HRKpe5jO9owRvqnuQ2AoIF7Qw3pJzdGE=;
 b=fxKDxhdacAcH8eRtZ/ke/ZxsUAxdp/J26bJfCjM+0WIsNV9tpFB1UmITMSDvxORF4f8PQ+VmpI+NnakgjRdT9QZQyYX05xmBD9k1NWa5WbNI/MKymQ8NBCEnx1JYkMWKC4G7kvIv0rntGDubM9//dJ3cQ3/yNZuqSFeDbBQRdABqb62xOqUPO9meuJEgZthmKDKNWwq4q7mCve9aHzzuhC3toIbJai0BMXhtYyImJ5MjNi3hTtPITVTKzigpB9ie8jDevBjjuJT+m33GvlRzcVQh+A6CKsqLuV7JKZinqr5YvM/s/d4qqthQjIY5fWXwGUIgM3S8HB+GmdPf+gAmdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rPRt/c30v0HRKpe5jO9owRvqnuQ2AoIF7Qw3pJzdGE=;
 b=UlD7C5B/srLvyHcKRLx3YTqxeVkpC1NXQPiLhi/60nxRReoUWiwS+UDTy/u9ielfXjt0vuS8+d76ZvB9R6H5s1Eks6Z27/Z3qSOszK9C3lDFxm+eY12G3whgIElAVTb4IB818A0by7g8TIwl0botxNp6IPAAnJPgFfQVSN0/dnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB8032.eurprd04.prod.outlook.com (2603:10a6:102:ba::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Mon, 14 Nov
 2022 17:07:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:07:51 +0000
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
Subject: [PATCH v2 net-next 0/4] Remove phylink_validate() from Felix DSA driver
Date:   Mon, 14 Nov 2022 19:07:26 +0200
Message-Id: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ba8edf9-bf70-4eca-c8cd-08dac662c34f
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEI0RHHfXvfe2vPlpTm7t6hZPsNSor3AYxIWOx1nyaqIXvEMbawJfEEVwLQ4wpNYoCIfp6Pqy/g7hxN26hITZ/sgPfdJZOKKsiQcICykIOw6GQy8Rm02nsxAYtBJ1+YR6Ixoz9dqJoAmsAF4k+XqEd8RRWmseVCML1A8uLUYE6+kMLnNrjAB8HnrkJflJeXZbKC5SW1gZcPTeFQYMW3KtRpiWRkUkS5ggPLWY5Q1uDhwtBjhVGVQ7EuChgfewMrVeyEiHhnc61vuHoRcyBiQXvvnv1IUHGQtZkraHdQpgvySofyUu1ii8ZbMSM5mHj8eWewG0F+wtRADthBJ0fj/IFdclQc+mi3zlBgjLzHLm73A3L0Sjq/Ntzl9DaIP7fuvswdv8NMDR35yqJZgtaAh70wTxl+FP/Ezv7vYhsWvpOylbNWcXGJE/itHFhB2fvTQRKcO8mhlpex1gPhyWewavAla57bJ/Xfyy5tWCXxKOy7eM4DtuKXedENHmY0OrrjiF7KrRoIMM7ib98yfGOl2V2YWpX+IwQ3/XV+gylNssLGG3eYCNsjUA8QJomHgTTuEBiMO/faraDskZPgcQa7miLu/BO0uWNy4xohUx+EPtw9xdWdkTxo+vCfO3tyclT5UJuJ/5jXbt3EuzZkr+9090j9ok2aFdSDH/0Dq2eIcL006iqYYgF4rk84CwARX0fNP/Mq4ZQv38+Io/mcCSyGZw1IR4xaFWNrUnVOK4DkFuvQqSpIht+DBSRPHY+CuGFRYPQEvx8sci/9xV2quEpgdvqorSX9NXPGJh3Bk+ZufzMM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199015)(38100700002)(38350700002)(66476007)(66556008)(44832011)(66946007)(41300700001)(36756003)(6506007)(52116002)(6666004)(4326008)(8676002)(5660300002)(86362001)(7416002)(8936002)(2616005)(6486002)(966005)(478600001)(54906003)(6916009)(316002)(1076003)(186003)(6512007)(26005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otCqQ3swGOY3lI6Foy8du1XGDDa6NNtRjEXVBt0ygVF7+eDIhZDAvW+j4nxY?=
 =?us-ascii?Q?i4Q4vUE1j32pETjlkZ1YjeLMZgTyH6SfdEMIeMm0QmZ1m4olKmu7rF+n0Bii?=
 =?us-ascii?Q?3nYdCLBvVr3ZGszZXSkQ5o9O3XEVsgHVYy6E4eaitkF03bj4EZBDq/gF6N/Q?=
 =?us-ascii?Q?CGVfeQkB/DTA5ta9gC4GLtNR9dheFBK+J47Z0HwQ8+YnEsYuH+vx7UzKSBR0?=
 =?us-ascii?Q?j5p0stOUANuL4L48329L1hWT4iK7vaJiZdfK1ereOtT3EVLbdbCOQBkWxVYH?=
 =?us-ascii?Q?lgJSoZqTbOt+JzhoxS5R3gPnpeXkf9qw9WfxNKdCg89d8/CEknO505hj9CSO?=
 =?us-ascii?Q?GTH6+EZ8VVOu61IWyW+NIHspMcCyHDPhYGsMNKSpaU23JlNN5/FjqI1+dL/a?=
 =?us-ascii?Q?6emzkyixslOyZpi/Zma5nDeIT4cP9QWGqOXXycTGGuQM4+uBmf1u0TkP/iTJ?=
 =?us-ascii?Q?+qzGoA6Bc6OKk50i7DP1MqI+6uTMgaZWT6SQqATeDiOMRN+73aUw4pLSb5o3?=
 =?us-ascii?Q?mMpAJAOLcvU20Gq5n65M6bQHYaJlQn3eOqiFixfESJPLUAbw58cGw3vC+Yu6?=
 =?us-ascii?Q?7qsgf3Ik978U0Zy4WFw/b7l2BLsHERGGVruxfApKradwEEKZbXeLpUcmcnkY?=
 =?us-ascii?Q?MY7+k2Kape6IcoIi8P6dhd5BHMmOol0SrKssuI/NM0St7y91VNgeW9dsVukN?=
 =?us-ascii?Q?reFdaLs2vOO+K/o3W82dkwlnuDlK4nHj5aWz298w0+E4JiuujhzNFc81TsKl?=
 =?us-ascii?Q?tYpO/VCpf+TWlOvYyFK+fboTScBKUxYMV4MQ2iG+70V9vOQNKXNf75JHjVrs?=
 =?us-ascii?Q?hHaxe2Syfwi3DnZKCEIeXN3FQjItLNlkRUzEmIWnhyYzZBe0SVBxrxI+A03x?=
 =?us-ascii?Q?sBth81QcpW6/7ia2wwIbS0V7szMgdY4McewU4XgOafkhHvhlisKTh8ZU8Sqa?=
 =?us-ascii?Q?868YS+AKZ11QZHWazqLXq5oXjWCY9aInoEHFSv/B9FRuAkx0yP6LQjrOMOg4?=
 =?us-ascii?Q?9pEYb6Eo1J9PNuCiZbvHKGB0C7hBbZrX8xp4OZ6Va0CwNo00Rp6mJU035Qmy?=
 =?us-ascii?Q?gAdkY0J2o/2vNxIG89dMPxHhxqOZDKck+eTZKS7s2ed3Hcpo8jpVzSJee3tz?=
 =?us-ascii?Q?8hOmdxK3loU/3HH/nHQSr9TKmb2rBhx9DFK4rUDe6tFCMe5gCERtxGIgZ/HR?=
 =?us-ascii?Q?L2C5TTkhZP5j5Kt1vyB4cwP3GfE1YaThVcNERzw0Y/yZPCtEDlhmipjJGn1x?=
 =?us-ascii?Q?4wGfn5RG6m9SzKtjyOXa18GuhRUIz3OeXSJrSwuYEaPLBJW97D/XWlgtNliP?=
 =?us-ascii?Q?6KaA1aOm3q3CSuK+RFzJUbEg+PWLv46V+2p+T9Vmyk9sYuX6VlXzWZ6YytwX?=
 =?us-ascii?Q?AYrBsILZXcru68aFoz1zmI1Gc6MzpcTrpXP5Possmtaflv/ot3u0EqHGamG5?=
 =?us-ascii?Q?vQAvoKiTLQgHYWUA4zjEFjfdt0vsAwVMlk3a34v4NLxeem4Eyyy6vNFLiivZ?=
 =?us-ascii?Q?6QejR08xIVa/zHvHiM3vXb383qrwW1/4ejUPXB2zRYmRmtmAQfWXKhjMSIwV?=
 =?us-ascii?Q?Tg7g7Oj6NI2MQb2e2S92FXMrNQ5CqzqYoNd8t2lDJp3aVRMdv7+vZq9rp6X+?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba8edf9-bf70-4eca-c8cd-08dac662c34f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:07:51.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZhHKlyrlcPANiivv+pkQ4lMxWoNG3ghRKAnD6Y0alRiTsgQxX2l6BmKjkny7wOFH8J2KZ97wp4MmNzT1IuMzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2: leave dsa_port_phylink_validate() for now, just remove
        ds->ops->phylink_validate()

The Felix DSA driver still uses its own phylink_validate() procedure
rather than the (relatively newly introduced) phylink_generic_validate()
because the latter did not cater for the case where a PHY provides rate
matching between the Ethernet cable side speed and the SERDES side
speed (and does not advertise other speeds except for the SERDES speed).

This changed with Sean Anderson's generic support for rate matching PHYs
in phylib and phylink:
https://patchwork.kernel.org/project/netdevbpf/cover/20220920221235.1487501-1-sean.anderson@seco.com/

Building upon that support, this patch set makes Linux understand that
the PHYs used in combination with the Felix DSA driver (SCH-30841 riser
card with AQR412 PHY, used with SERDES protocol 0x7777 - 4x2500base-x,
plugged into LS1028A-QDS) do support PAUSE rate matching. This requires
Aquantia PHY driver support for new PHY IDs.

To activate the rate matching support in phylink, config->mac_capabilities
must be populated. Coincidentally, this also opts the Felix driver into
the generic phylink validation.

Next, code that is no longer necessary is eliminated. This includes the
Felix driver validation procedures for VSC9959 and VSC9953, the
workaround in the Ocelot switch library to leave RX flow control always
enabled, as well as DSA plumbing necessary for a custom phylink
validation procedure to be propagated to the hardware driver level.

Many thanks go to Sean Anderson for providing generic support for rate
matching.

Vladimir Oltean (4):
  net: phy: aquantia: add AQR112 and AQR412 PHY IDs
  net: dsa: felix: use phylink_generic_validate()
  net: mscc: ocelot: drop workaround for forcing RX flow control
  net: dsa: remove phylink_validate() method

 drivers/net/dsa/ocelot/felix.c           | 16 +++-------
 drivers/net/dsa/ocelot/felix.h           |  3 --
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 30 ------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 27 ----------------
 drivers/net/ethernet/mscc/ocelot.c       |  6 ++--
 drivers/net/phy/aquantia_main.c          | 40 ++++++++++++++++++++++++
 include/net/dsa.h                        |  3 --
 net/dsa/port.c                           | 18 +++++------
 8 files changed, 54 insertions(+), 89 deletions(-)

-- 
2.34.1

