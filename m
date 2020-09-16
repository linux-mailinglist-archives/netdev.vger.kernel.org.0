Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9605C26C0ED
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIPJp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:45:56 -0400
Received: from mail-db8eur05on2053.outbound.protection.outlook.com ([40.107.20.53]:41440
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgIPJpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:45:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dv7OnCkapVjU5WUtbZuYy4R/uI8aauddiFPPnSYEHEGLt7utlZuhEwEkjajvlBXvvKMTR62d83VJSPL6pb9tFL9lmYBJQe1nC47X5Y2sZWZmnyc3D5xHYp6/l53SDZFEXAX40uZiwzEtc7BzKGjsXns8NXy7AWBseeckJEm9KztcmiijvdNtyQvXOpllSophftG4tJ+aGbKB2by33u03N/NV/FXB3iBKeJroVmnfFlTtVtJuKcX1BlSCBl+ozpjEkftq4fp/1gPOcVQa/3qfTKtpoF/EU2mMu1YorYAHtlNMWG4nd3vjmmevuvh/TDSW95E+X9HbDI6XCTHOU/g9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llCmKiFPJLKfq00ZkQCPb+bYY9h+3qA4vgFxF4O8S3E=;
 b=oR1NQZTpkDhGx8pF3SxSTwkCMAzdOlheAkAY7wdX43tz3V0FeBRAIjMH40nCenUj/P6BvE8RN36Im0SVjeXOQHgOhNV2TNzXyMzNehvFwKI8ih5wV4Dr0kPwoTM+fKO7oi2hJ5ofKIKLM0eMyjm8cbQQRSwSb2A/v471CZ6IaV6Z3GvR0rKCkxBqPaMIGNTIH48BmpujV4ucjLMLTKYRXPOkrlxTJ8kFMqIrT8eVxcNKdX3Td35Yp1Hl3LGqutS8pHKvSQpUV5OoT/FcVQwqSGe13M9+pvOo8Ipp454iwzG8PoFrO7Gaw9qFpacI3HAdJVqquk3sWp8RuFuusjcdOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llCmKiFPJLKfq00ZkQCPb+bYY9h+3qA4vgFxF4O8S3E=;
 b=hwmDaVLAqZXgSw8bQZXKyeJZUF8Rch1eQxwuAwEtNMxlh++w1aGb4kejw3XDhkBGyLcHFM5qdmYSYtTGk+rEutGM7qn6htCubE5AbsE1Dyp2YKAEilF390JHz++0WB+1ggpVnOk/bkcp4ezV4f7dJ9MGxIVamz9NHA7k1zEc0Cc=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR0402MB3453.eurprd04.prod.outlook.com (2603:10a6:803:6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 09:45:49 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c99:9749:3211:2e1f%5]) with mapi id 15.20.3370.019; Wed, 16 Sep 2020
 09:45:49 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, mingkai.hu@nxp.com,
        allan.nielsen@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v6 0/3] Add 802.1AD protocol support for dsa switch and ocelot driver
Date:   Wed, 16 Sep 2020 17:48:42 +0800
Message-Id: <20200916094845.10782-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::44) To VI1PR04MB5677.eurprd04.prod.outlook.com
 (2603:10a6:803:ed::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by AM0PR10CA0091.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 16 Sep 2020 09:45:39 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 65e34f96-ecba-460f-4d5c-08d85a254abe
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3453947D7E10485012204599E1210@VI1PR0402MB3453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lmvZKdDknxQ7uHZUcDHQ+8dQ1MbOX6W70RGjztQBeaVpl8ZAvJD60z5oULlGuIoj22f70R8iVNoavJJrROkiCxM0jhY0CHcWckIdFCY1jE+Y+agOXc2cdlf4HGi4W/ALw9eSPLSwCVQxFcV4rDBAlUA1hbCXl5yTjWbEvexwXymqkNPtwAoD7QQR02tzxXfBY8AvHkDDjnZP9/lSK8b31j4JKFZ12iUb/8IXYbWraDEQcAPzERCeDErQKY7QECQdFBAXxDy0LuQE11Lh+fe5iLEHxPzCFBJ6a21YB/aGiQEie6dhAU+LvjInrC3uDRFU3utrUIOJW10FNl11oZ5T5r7wUqF1LOrieLpGS2anGwM1gmTx+jXIe03WIg92s/Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(346002)(376002)(136003)(316002)(86362001)(6666004)(16526019)(186003)(8936002)(8676002)(83380400001)(52116002)(7416002)(9686003)(1076003)(36756003)(5660300002)(6512007)(2906002)(26005)(66946007)(6506007)(4326008)(6486002)(66556008)(956004)(2616005)(478600001)(66476007)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gZkHA5FwVUN5uIKCAe/CVcCfpsuSMLZTceSkK/8aLEfe2QsAnI7rkDXvVAbuPYu5UAcwKrccXeJNrQ96FOuKJNV9hhH3hL+llWw/WcwWtGJZKi/0q25lnjxcNnmozktPiQkjJa800sCfyBV3KvrxiJQfzKmKCatvM4qhA0o8/FKGSpS6IqNiP5CePniB1ZAOFa3gjIMQfLOAM/TqUxjexE4Ejw+M7giUfj74jjt1dTghM4mefLw7vo/oYZM8yv4SdH7d4235iRze5gEADmCjn9sTm2XB/QZtX6IzCVsWwNCU6rbPxYKnW39xf9kINFS7RzFFQ4rW1iXL2puKg7f+668lKU/t4dZMgo6W7tPr33zfe+OzwVnITxRZR7pB5Y+W7ky70FuU8Y7hfvqYWJ11xnhLj5VX2qZZ6iEYDGhv1YMoYeZLxGqef0Ri4pFmD+hqEwYh+SMK7GxlUIV+42p3sws41B8ExvCjhleyGqm/KmLiXNwfAf6bZbQefdNIhE/+l6ZYf+k2QQuTWYrlweQLzGVFZUKZ8O1H0LiDS3ESmWPfWG6ltyxKE06J1OvtixEVHz9VJWJmlYpAaFSsDHOaZVwDqx2N8nLJbEDqeh9hO/Ic9SspqlvK3nz4jOWrtSBtwpDLqWG17o5irF+ZYZYCSQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e34f96-ecba-460f-4d5c-08d85a254abe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 09:45:49.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EMBBdWB4yuq0L57R/ejd1ES8B7tXlzqd4URYZ/j7e2MPbDeToujLYNKx4LHD1nvcJenlxM8205bIOSF5cDeBfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3453
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

1. Overview 
a) 0001* is for support to set dsa slave into 802.1AD(QinQ) mode.
b) 0002* is for vlan_proto support for br_switchdev_port_vlan_add and br_switchdev_port_vlan_del.
c) 0003* is for setting QinQ related registers in ocelot switch driver, after applying this patch, the switch(VSC99599)'s port can enable or disable QinQ mode.

2. Version log
v6:
a) put the code for switchdev into single patch
b) change code according to latest mainline

v5:
a) add devlink to enable qinq_mode of ocelot's single port 
b) modify br_switchdev_port_vlan_add to pass bridge's vlan_proto to port driver 
c) enable NETIF_F_HW_VLAN_STAG_FILTER in ocelot driver

v4:
a) modify slave.c to support "ip set br0 type bridge vlan_protocol 802.1ad"
b) modify ocelot.c, if enable QinQ, set VLAN_AWARE_ENA and VLAN_POP_CNT per
   port when vlan_filter=1

v3: combine two patches to one post

hongbo.wang (3):
  net: dsa: Add protocol support for 802.1AD when adding or deleting
    vlan for dsa switch port
  net: switchdev: Add VLAN protocol support for switchdev port
  net: dsa: ocelot: Add support for QinQ Operation

 drivers/net/dsa/ocelot/felix.c     | 123 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  39 +++++++--
 include/net/switchdev.h            |   1 +
 include/soc/mscc/ocelot.h          |   4 +
 net/bridge/br_switchdev.c          |  24 ++++++
 net/dsa/slave.c                    |  51 ++++++++----
 6 files changed, 221 insertions(+), 21 deletions(-)

-- 
2.17.1

