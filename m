Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7772DCABD
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgLQB7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 20:59:52 -0500
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:13120
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727090AbgLQB7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 20:59:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXHjJk4emxV0QxfkQ//KAfOY8lBLMLlihm/7ktm3ETpHcsRXrg2fUsi1+LBhNO44sg5KtpQ/BCcBvc2UCw0WjMzsEoeegcZVvOiPc4hwe/z23LskUxva39Qrtdt0p8vXmiaJQehnTxvvfGAnJeXF/RxHwkUIL7+bx7xyYB29yHkprg7CNAjwnHTyFujnD9CiRq2OGsTQiqrOlsB7LwT3KLCjYtjvZhwee7GgHOsSjc136TmhtcU4RMX80l61WlRu64EfcvmvYx3/pB6QhIaMLTdN6yJXD46/XVRrfcFl1Xxyvum0tosYxRrR3HcZc2eDFo4iIEzfcIvvEHLh027tvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDILJ3vDRBxOivJ5koCsAKG+KbYaxl07M7IYcUh9lAY=;
 b=OtnwaQVk8BNd+WJliatQfc/q9zEfYjGFFBk5Vt365QDvAyHrtteVMXdj7TnFAX8MEW34yJO682cHeWVLaRqgZAn6uae6AP5+GUGuC7tMX5+PekyS1MNhnRtXGjB4DRBl5ZLNd37+UxJ689vE0TFli/su+obRYeOkc4Np/1QW1v3MmI29bIFucHovUrDVCkvfL2M48829BXL8pf6RCzL5ZRXLt7j0rSEcRbBPsd7hs3Qyqgq6I0XLXFsTpa/BdLKykuOU3QXiCuupJ1K5RSVWudMg10PkJQngj3VjYF5zF7y2mi8QpTxbOe5o9xPI7061bToi9b/RfS7SFNNJldgQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDILJ3vDRBxOivJ5koCsAKG+KbYaxl07M7IYcUh9lAY=;
 b=ptY/huyj9pt4TKocbFnfSMdgACR0AvQLn0Ma8MCGIjJwweRzQTXCaIasIcBkVgX19g5CZ9IgMETgpm9l0hyfcttVoIx6m+Gf0xaz2NZ+XLJOJABeQXswhZQhwtz40mjamifnq4erLwxWsWGVSSBxjp3AIiBy+7+C22xdbZk47F4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 0/9] Get rid of the switchdev transactional model
Date:   Thu, 17 Dec 2020 03:58:13 +0200
Message-Id: <20201217015822.826304-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c748f98d-45d6-436f-6dc6-08d8a22f534c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69439694A02C06AE74EDB280E0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +YeD6q5UYqNozmQ5cIeBTCypqKsfdL6av9uNzLTDabta3rSI0eyhJYTBl8eNAfPNzTzbP6sBBGr4YA2Qn6WRsuSmYfHDkcPQeki1tm1zqGlJtY9gfL85IvxOwaJLFGPGYSNPOvIeXxaLNR/U+Am9AFP6fVdAlBnf3J3owMw8xWMAZ3aVrqQvBbAmPfrtt6flwYftE4ndSoZc72NfhiOkoAzTmOmeakENvH1RdIMqWfFa1YXQthvP75J0WzDv3On24y+v2HHCXhGqeqKq9KKHqnPG8U6e9yLqFZiVhRy4j1c34wI3Ltq/i2HfF4+TK+Nt6YDrOrxipznKrqXdIF3ofS+G2wci0LUFvlcGAw8kVq/V67yCKwBRbbycEZFt3FPVUAz7Q1XYR7dADYJGc9EYhCObE9/wOHUXrZWNaOVEdYcwbIUSKicPaDwTS1AlIJ6dXitiir+iS8xCUQ0NxeNb+/k5pQntO+eupQhCa+Jrflk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(966005)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002)(26583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sR7h5vJ6E2TNFXRAopdJ8X1z+C7RPZLwLMQ5t9QK3nh1VFI/4W1PLYG/+K3g?=
 =?us-ascii?Q?hW/1lWmQvZ73xeI0mjmmtQHnxBfjUbVgrVr5c4VvrjvqJk88IM6gc2zfZGGG?=
 =?us-ascii?Q?Q8F1H3RYUIDu0b+qBSwH9h8X5bRyNEpW49zqguDcGa2QBD4qv/aqM+jt41zm?=
 =?us-ascii?Q?EqOIt7bHAJjDxaAjwDyYyJrHp6o8Z30gVJwH73iVY++qB8ceOZoenRjdAJBb?=
 =?us-ascii?Q?33UpATArmt44ge0QvpEgjtOTucfiOJHmFqVDp/tMb1CxCiQk6njz1ofJ5AAM?=
 =?us-ascii?Q?2aknQRBjUi9ixp128fkDCcXhPGuTu+aWXiSyVbsSeYC7tZZMTfiBF+kFR7Co?=
 =?us-ascii?Q?vgPaqBx7yulye710GxD3rS8CWvOA0B7rCULCR/scD018R1/UVTm5yiyAcsh1?=
 =?us-ascii?Q?RT76nPTZfDISKgpxgvTA0wI6n1HVKcOTapkQPZ/jdel+0xo4Tjvj92WQvMPP?=
 =?us-ascii?Q?LwHoHKzhdUfFC5IqitqTYmiojXzPrg7zWNJiCZlCl9oBSVmExixNtm4vlgg8?=
 =?us-ascii?Q?xP9pJoTUnuXkFerv2pQLclHgV6G7N65zOpHBrHxUbI81DyXfBwnS+t4dI4g6?=
 =?us-ascii?Q?G1D97ZQ3f2GaK7qd+wGLEDM63oeMfv8w5j6WLrvq/TF1/JyioDxCHEz27nSr?=
 =?us-ascii?Q?g0iPikzbWDoUIyZfJrL4hMYe2C1vR+7rDv1QUnGjM6AD+0Qz25J8Lhwyt0FH?=
 =?us-ascii?Q?+F9ApF3Sbh48zyMlP4zGBaWs2XgvZ49QAqxIQVmPbeblmOudhLH7eN5rp+fC?=
 =?us-ascii?Q?C4j54KW7uvbFQ1k/hIhTw4fRyQegDYrRW8QaLMC4vFGgpKMMdD7w7IPnmM95?=
 =?us-ascii?Q?Cx4U9Zrw/R7+vyg4emv6ji3xvsMX2aOIJv5e18dNmVF+RagLuBirNL64NVM0?=
 =?us-ascii?Q?LOz3Wsixbc2ISN1k89Xt81ssCHiUbF8VJe0BnD8tsEYVL0fcjWciSqPnzXx/?=
 =?us-ascii?Q?MPZjM0Uf+Q9kK51xcfyg7Az9on9LyLrdwVlVJW9GdcpalDyJBkSP9aUjk2nK?=
 =?us-ascii?Q?jxhn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:01.6306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: c748f98d-45d6-436f-6dc6-08d8a22f534c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4yWGLjCJ1B/uo43TAtbDNoSm98uF+B+ITvHKszUtRd8GujQSg6KIPP4H8lZLMQFOa6QR01+eovJQexDbJpQtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series comes after the late realization that the prepare/commit
separation imposed by switchdev does not help literally anybody:
https://patchwork.kernel.org/project/netdevbpf/patch/20201212203901.351331-1-vladimir.oltean@nxp.com/

We should kill it before it inflicts even more damage to the error
handling logic in drivers.

Vladimir Oltean (9):
  net: switchdev: remove the transaction structure from port object
    notifiers
  net: switchdev: delete switchdev_port_obj_add_now
  net: switchdev: remove the transaction structure from port attributes
  net: dsa: remove the transactional logic from ageing time notifiers
  net: dsa: remove the transactional logic from MDB entries
  net: dsa: remove the transactional logic from VLAN objects
  net: dsa: remove obsolete comment about switchdev transactions
  mlxsw: spectrum_switchdev: remove transactional logic for VLAN objects
  net: switchdev: delete the transaction object

 drivers/net/dsa/b53/b53_common.c              |  42 +++----
 drivers/net/dsa/b53/b53_priv.h                |  15 +--
 drivers/net/dsa/bcm_sf2.c                     |   2 -
 drivers/net/dsa/bcm_sf2_cfp.c                 |   7 +-
 drivers/net/dsa/dsa_loop.c                    |  32 ++----
 drivers/net/dsa/hirschmann/hellcreek.c        |  18 +--
 drivers/net/dsa/lan9303-core.c                |  12 +-
 drivers/net/dsa/lantiq_gswip.c                |  40 +++----
 drivers/net/dsa/microchip/ksz8795.c           |  14 +--
 drivers/net/dsa/microchip/ksz9477.c           |  40 +++----
 drivers/net/dsa/microchip/ksz_common.c        |  23 +---
 drivers/net/dsa/microchip/ksz_common.h        |   8 +-
 drivers/net/dsa/mt7530.c                      |  20 +---
 drivers/net/dsa/mv88e6xxx/chip.c              |  72 ++++++------
 drivers/net/dsa/ocelot/felix.c                |  32 +++---
 drivers/net/dsa/qca8k.c                       |  20 +---
 drivers/net/dsa/realtek-smi-core.h            |   9 +-
 drivers/net/dsa/rtl8366.c                     |  36 +++---
 drivers/net/dsa/rtl8366rb.c                   |   1 -
 drivers/net/dsa/sja1105/sja1105.h             |   3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c     |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  48 +++-----
 .../marvell/prestera/prestera_switchdev.c     |  44 ++------
 .../mellanox/mlxsw/spectrum_switchdev.c       | 102 ++++-------------
 drivers/net/ethernet/mscc/ocelot.c            |  32 ++----
 drivers/net/ethernet/mscc/ocelot_net.c        |  39 ++-----
 drivers/net/ethernet/rocker/rocker.h          |   6 +-
 drivers/net/ethernet/rocker/rocker_main.c     |  61 +++--------
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |  23 ++--
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  37 ++-----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  80 +++++---------
 include/net/dsa.h                             |  11 +-
 include/net/switchdev.h                       |  24 +---
 include/soc/mscc/ocelot.h                     |   3 +-
 net/dsa/dsa_priv.h                            |  27 ++---
 net/dsa/port.c                                | 103 +++++++-----------
 net/dsa/slave.c                               |  56 +++-------
 net/dsa/switch.c                              |  74 ++-----------
 net/switchdev/switchdev.c                     | 101 ++---------------
 39 files changed, 408 insertions(+), 918 deletions(-)

-- 
2.25.1

