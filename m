Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0C22960B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbgGVK3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:29:04 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:12259
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730296AbgGVK3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9HJPLHhMGNlUImjWqozL9ds1tiRfNZXHtZrJCECQzzuQ/NTVgZ5PBpOXRpJhpYm3Wqbnbg+iVBGo5Oiftp8NpzL9cEsVkiYLo54+NZEDhhp5mKObfC3puCD93vJ8ND9JTtLr/I5ztUeme259Fiu4cbxsi57S6AtWv3miGAeiEoM7PcJhd4Mx37uDLjlj4FIHXIOjLoW0qaNwqFw1kdxcNOeMFs3h0oHWx4P4Rj3Zp7i/i1/hbmz1G309QFiAobroH5iVCcZpEs1ngQhx2CNLUdbisCfIeq9sHgzXOVBrnpMANkq3MOVwwEKQxR2JPzvTByVVNsqrYIF57Hl1vvVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnGnEtUmyQYwXpJETS/tqVVtMv0DNpVRodokrpI66J0=;
 b=MgMRkxIx/VlLDQa+o6TlsfIbkcG8PSHHHplskpJAVOjhzDlPvo0VEI6WsG7U6RN0plUeEFqwMmnJGXuuoG6QTsZpgtwzWyFLoBDKKymDJnyHqBePdiLaWH9PLfn6f8QZLTPxDgt6xUevIwABcAxVNZ0Sa8ilMJ57Nt9yElVI0zQVivEvsr85FiWD99shWqyZHvyq/AHtRr3qYmhmo+n5K75N+DV9m6C8Q3vbsyD9ZGdhOszh249NM72p3e/viIBU3kvqMMbvK2hDYuT4idO0yisvM5Mx1cosp845Q7VtIxZYYEh4avGOe+0j/negjwMxP2eQfAaVSpZfN0r0R3gHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnGnEtUmyQYwXpJETS/tqVVtMv0DNpVRodokrpI66J0=;
 b=L0RR0EYut5wtn83UfidtF6ksC0Eu1A7GJs2+XFVsY6bW1rJR90Hpi311MRvxlQAJ59VH7kcet3ZKnJYewEPSQjz54tj4rGHJr0wzEdbu2WXILUlwuKx0ldY1bFartzCc+W/sbBSzTB6LEKKnFAtP9Cyt8dnaJcbQXXig8VMJ0iU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB3151.eurprd04.prod.outlook.com (2603:10a6:802:6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 10:29:00 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 10:29:00 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v3 0/2] Add 802.1AD protocol support for dsa switch and ocelot driver
Date:   Wed, 22 Jul 2020 18:31:58 +0800
Message-Id: <20200722103200.15395-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Wed, 22 Jul 2020 10:28:52 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b062c06-0248-4f81-ed23-08d82e2a0bd7
X-MS-TrafficTypeDiagnostic: VI1PR04MB3151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB31512A1084FD8604FB9E7194E1790@VI1PR04MB3151.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxV88pygcBxr8d7zRCPf7qvOkjc9qnUIPoI1zS7HjQOaKSaaqdpy6cp5zEGVzIbcrMsPawN8AHcFdUlmFHBHZ7JJGKoEh+ajJUeu02M01qsIGOy+tMLYyn/BxybOAy6kavBSLHC6xsWJpM2nN9treGHb4fi3NU5kV8QPMFxfaOmHKWe9YqGe+o308tL+hWTShFXEbC1x/KweqDSsW9uA/bfIqiwD6s92aCIckUiEunzW4LpYLW9teSIR/+6Nt5Xlr8c/eSL2PUA75UOexUQ+TF0esvHMN/QbWdKgObQdjXP/QsHhwV7wNqDN6lytICb4LIA6FNsKhhqGS3s4SQYAFwLiEe+lML8IW7trosVZrGKdrKHOSd7ArWXJaFjFzEKA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(8936002)(7416002)(2906002)(66476007)(66556008)(66946007)(8676002)(83380400001)(1076003)(6486002)(36756003)(6512007)(316002)(5660300002)(9686003)(6506007)(478600001)(86362001)(2616005)(956004)(16526019)(186003)(26005)(4326008)(52116002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s5lDhg3SmdB8TdBCBIjLAjxu12JnUSmFqynGQGjhgx5bGoFwaZVfau2M3Nzx3NU078k5R28lvwyi5KCm+98llEKwsJH3H6LKPkRiYX5v19rOfvrr0p9Rxc1tp8oMEDsJqR1rypctIonYQQosKAKgXf5jauLJ+8gUhTGK9WKNp5+3sy2nr7HvZQqhADwxq22ch+h5mFCEyDNWkm/eUtxHRp4z0mPqJmowBrmimuSKclZBaie1NIEwAa8ZIJj+7WY/lPRk0n/ygTFyWE1IwtH7MyN8PIL551DJY1lm0KBj1i7zRlNokzn0bIq7gqchNT3cCHdGenghhIv7CtoXOogXNird1NrzjT79oVnqSMZFeJiEHptd8luc6m/we6XUn4s0Hj+Hs+ZBsHdEPVYUxgSJyvoJigzJSNqQRxstg0/DBoPB9PA4hJAw4f0WHBMmD9axxLDVtLZcx70kS3Dp+Jh4eSvtqWbNvHOeseq9y4vLCcf4nrQdI7OOZaU/GNTOopcv
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b062c06-0248-4f81-ed23-08d82e2a0bd7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 10:28:59.8437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uhhx7K90zDLw5zQ6VLPCf5ObkyIfprrd8KQ5bULVa9wGHic1T1n4uyIai7bPhN7yBm+UL1SkayJ3mc39mVn9KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

1. the patch 0001* is for setting single port into 802.1AD(QinQ) mode,
before this patch, the function dsa_slave_vlan_rx_add_vid didn't pass 
the parameter "proto" to next port level, so switch's port can't get
parameter "proto"
  after applying this patch, we can use the following commands to set port 
to enable or disable QinQ mode:
  ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
  ip link del link swp1 name swp1.100

2. the patch 0002* is for setting QinQ related registers in ocelot 
switch driver, after applying this patch, the switch(VSC99599)'s port can
enable or disable QinQ mode.

hongbo.wang (2):
  net: dsa: Add protocol support for 802.1AD when adding or  deleting
    vlan for dsa switch and port
  net: dsa: ocelot: Add support for QinQ Operation

 drivers/net/dsa/ocelot/felix.c     |  8 ++++++
 drivers/net/ethernet/mscc/ocelot.c | 44 ++++++++++++++++++++++++------
 include/net/switchdev.h            |  1 +
 include/soc/mscc/ocelot.h          |  1 +
 net/dsa/dsa_priv.h                 |  4 +--
 net/dsa/port.c                     |  6 ++--
 net/dsa/slave.c                    |  9 +++---
 net/dsa/tag_8021q.c                |  4 +--
 8 files changed, 59 insertions(+), 18 deletions(-)

-- 
2.17.1

