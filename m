Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4623EC01
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgHGLLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:11:35 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:38465
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728282AbgHGLLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 07:11:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNok1rc3DP42IHy1zFY7FZZCDBpkrrS2tcAigixQp1/hR98EDFRiaDAMtSvY9pvRuuAMtBk2c3EnASMjCCWT9FLazqaeeLf35QpDJmd2gw+3ZdmWv5YW+I3t2GKwEBmARMgZamaddVTuQ7pvAs4ImoA5YRwIh/lerQvIBHnxZpQrcJbOUbGDNwVSKNRS4YusDtxw5kKwy5INLydscw2Uy0f2vZ6UDXRBmexAhb2j+THG7BwkxikXQYfTTTWeTopdGSOKkIpv5rINF1J0wa8g/o7h5cMZdVRbRrkC8TYA9IPGE2A67gSY8IfpZgEa4KJ0+qjpFYvsllHiQKLP/vzRKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LGEE0s1WXDmPthwCmK03ULIlONUq5VwHB6sUXQklZk=;
 b=cB1utSLcTnDQpr5WW8VjxgGkp6BDORGpYeK4MMLT7vhTJPvClOYXbVmV6MrQVK98MiHbSR+3xvV3ErjIgFAfzH3Rihu950LKvWLPyKTi6zlznR+BTBtnsm11j0XCGaaU/Ihpm1wytE3VdwxRRaegAEy3YQGfMc5klxyYZUGVj4BrGjQTbtTVp5tOOaOz54py+qw7Qpntsyc8in3bDCTiQ2Z046B+7IYYcBIua7s4sIvGhVpGJCWh1J/8hoPWAn7BMqC5OXQZE8MnDpH2KmiikQM/AGWV732UoeoqfKWCybbmtUf+Ux0MHg8fkWLMupsPQOogubD4eZDeh3kJ5NjjqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LGEE0s1WXDmPthwCmK03ULIlONUq5VwHB6sUXQklZk=;
 b=IG8XDCE5e8F9QLpPtx51resM48VN+4eJ/FHuu8HW7kL4J1D5EuAUAe2+sju3SRcrVjd7is4fxYuNc6zl1HlWlvJHEo2abRWBb780VSc+Spt4xa61IMc9sVR81hAUUlta/lAEHxrW7ed0f52yXM1L4T9HHbeqPXcyGDeFiqAX+V0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5725.eurprd04.prod.outlook.com (2603:10a6:803:e3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Fri, 7 Aug
 2020 11:11:16 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3261.020; Fri, 7 Aug 2020
 11:11:16 +0000
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
Subject: [PATCH v5 0/2] Add 802.1AD protocol support for dsa switch and ocelot driver
Date:   Fri,  7 Aug 2020 19:13:47 +0800
Message-Id: <20200807111349.20649-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0218.apcprd06.prod.outlook.com
 (2603:1096:4:68::26) To VI1PR04MB5103.eurprd04.prod.outlook.com
 (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR06CA0218.apcprd06.prod.outlook.com (2603:1096:4:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 11:11:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7b4bfe3e-a0f4-4bcf-5b64-08d83ac29a26
X-MS-TrafficTypeDiagnostic: VI1PR04MB5725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5725A58CF66A09FE496D87CEE1490@VI1PR04MB5725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2vQzSWahuBiP9XO4VZT3laNQg7gExDMCADg6xhsBWoHhcUanahR5+Xi6DybMeNGGuPfjgEhqf7eIra46SbNG6Xtq005lJKMF/ocqpWI/Dk9vaDqI9Bm6havrDptrh1eOkuP+5leoKLhBP5MNvc0wwCtvbAtIIy//+CU4g4TDT8eHOu6rAAOMitOH3BFHvvKvGZMiv6UkiKcHFxjO8d6+uUzReMb5dGoWLB0NqkMcUq5/9dnB99ZlTAiQ4PayCmWj14ZTTB05E+7TWLoGIMMKwJxkFH+Faf5UbLS9QV83CsWuCtB9LO3yTQhlUz/yPMJYf1Av4i9MhJGUIyoAlNE0+PpCre/Uva0UxJNS3NAfmzDy2xv8zX6TkOGN4lGMw7pN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(956004)(4326008)(2616005)(7416002)(5660300002)(6512007)(9686003)(8936002)(8676002)(6486002)(2906002)(478600001)(52116002)(26005)(66946007)(6506007)(316002)(16526019)(36756003)(186003)(6666004)(1076003)(86362001)(83380400001)(66476007)(66556008)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uV0fYhJVcVBugIn5tY4vOfNQwlkjkSq8qHgLG/vyFmb7SjxfN7SIZCYd1EsxYqdM5f07C7I9mxf1x8bgPRmW3vrSQ/fRTG3nIgyI2BrxFmGlUgW+PCf5kxvJQBgkKAYQJSiUDrloxcNJgWai+GJF1jnnZlBDj+gmP62grO1wjcte3GUhw3kvF30FfCgx3sqwUqSFRl4aThv7ZKLCeZIeAoiizwckBhxNS04tQeTzACcDXkkAt7dX7YO4k2aodpmaE/2v4rJEbMG+V9YO17P7FR/Y3IYX1nzvITwZosr+F8i3hasmPeQdMP9qSNEZNfo1KEsUq290SiDGUQUHE7kSIdqnJsHPbDBttLjj6DiTa/DpIZzXGGAJN9EB5fsWa5phg8lbVygN45LKTU6gy+JWHetNxEd5EDxLrHvZ/LQgGrM4NgWv9hfdKA2b2+xXd7oJPSXk/o4R851/unVnhpi7gy41b4XgueekBX+V1ra0qY9m9af5FqRnkeD+3rEIDvQRzfmZq8CvqfuyvOyfwhrbGOTsJ3jgkV+18szxSq+gIE39Ps4xJIIfGYHLGmfDM7LFstU1pp0iusIlUN2H9Xl6oc4H3fboOq8X2oH9JKLHEuGxleuRtphvUPpq0Jx/T76/culLdFLEShoiw9u42QV3sg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4bfe3e-a0f4-4bcf-5b64-08d83ac29a26
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 11:11:16.0654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qywWHK6m6QE5DF+JjC4iA4NdPDrn1dMCT5/H6IOyOQhv9XhdQanooehwD0DPhxA0mWcf3qN5UKOoV7nI2ZRZQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5725
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

1. the patch 0001* is for setting single port into 802.1AD(QinQ) mode,
before this patch, the function dsa_slave_vlan_rx_add_vid didn't pass 
the parameter "proto" to next port level, so switch's port can't get
parameter "proto"
  after applying this patch, the following command can be supported:
  ip link set br0 type bridge vlan_protocol 802.1ad
  ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100

2. the patch 0002* is for setting QinQ related registers in ocelot 
switch driver, after applying this patch, the switch(VSC99599)'s port can
enable or disable QinQ mode.

3. Version log
v5:
a. add devlink to enable qinq_mode of ocelot's single port
b. modify br_switchdev_port_vlan_add to pass bridge's vlan_proto to port driver
c. enable NETIF_F_HW_VLAN_STAG_FILTER in ocelot driver
v4:
a. modify slave.c to support "ip set br0 type bridge vlan_protocol 802.1ad"
b. modify ocelot.c, if enable QinQ, set VLAN_AWARE_ENA and VLAN_POP_CNT per
   port when vlan_filter=1
v3: combine two patches to one post

hongbo.wang (2):
  net: dsa: Add protocol support for 802.1AD when adding or  deleting
    vlan for dsa switch port
  net: dsa: ocelot: Add support for QinQ Operation

 drivers/net/dsa/ocelot/felix.c     | 124 +++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c |  40 ++++++++--
 include/net/switchdev.h            |   1 +
 include/soc/mscc/ocelot.h          |   4 +
 net/bridge/br_switchdev.c          |  22 +++++
 net/dsa/dsa_priv.h                 |   4 +-
 net/dsa/port.c                     |   6 +-
 net/dsa/slave.c                    |  53 +++++++-----
 net/dsa/tag_8021q.c                |   4 +-
 9 files changed, 228 insertions(+), 30 deletions(-)

-- 
2.17.1

