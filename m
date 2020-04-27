Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844161BA491
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgD0NZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:25:08 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:33848
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbgD0NZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:25:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYlbO6xOhdFkNrpHAwMpNJpzorz5nt6ZpJxUwltO8+R7IrpMYkE7+hsYJ5hijvEBu4dk9d43wnxIa3NXj5Arv6iLmOP96zcTSGMyzloWt35Q9rGupAq1Bbrr8dzXloAAQ4ImqjIKXfIQEkWNHz80RfaSjgeThHGP3HTwlfI8l/XJSv50HTxlKDgj1zH3iQChf52H9/vUiIG5NI/F7X+n8j39C0XEhiCyKGpEJnVwJLymb0dVkSv7E8m231ZgqWR3eYzjy9Vo3WIvJsxMSZ6hUDSGJd9TOZpawVPN0uuGmG+AAhPuKGEiERXnVZwtZuqcDRmajv1yeheAl6NWK0y6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDIISntgPyNzQgq2M7Zk7hxiN0ad+WOU/OJG37zmS/A=;
 b=I/DMPM0HxCAWtVh3xFzVFez5bUEi2+Q9+oZxOFfdge6M16tX+duGGBDiLm5LbZs7reTAVSlIDiMOcY4jehEKuTeWp3jh/W4jy0v6ktkKUG1EIY4y2voZWsFWv7vc6VquWnBtmZYOydI1CcB05WGfh7qGNJ96xKwroPRrkI5lRM72znx5AWAhv+o8PgAMOfZy+NDETuHbqfXMMVpype+cpWFV5+o3ElOTPSiZzNA9JK9rGu9SnFtUfuDupG9DC7DS3w7NiAMRkxzVLvahPRsJYfLSFId0oHNDp5Dn/enlSEuYBWuw4wagO9abc9fGTPTjHAa6CQWEw1suOnxnLrk7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDIISntgPyNzQgq2M7Zk7hxiN0ad+WOU/OJG37zmS/A=;
 b=ipZNpZk3tHvNcdk2NaH/TIXYS63x/lW04Zf26XrYy9mdc6692Gp/6bMTndFuxjtk8YJVCBKaml2eorMR2IVSFz8KatqcIOBKvETGI32ir/iNEo7YUT7d0Ckk+coMbux341oIZw9rL1kPt1lDe1seGW1BhO6k1vBdchukJqwOMfI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6867.eurprd04.prod.outlook.com (2603:10a6:208:182::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Mon, 27 Apr
 2020 13:25:00 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 13:25:00 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>, linux-kernel@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [net-next PATCH v2 0/3] Introduce new APIs to support phylink and phy layers
Date:   Mon, 27 Apr 2020 18:54:06 +0530
Message-Id: <20200427132409.23664-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0191.apcprd04.prod.outlook.com
 (2603:1096:4:14::29) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0191.apcprd04.prod.outlook.com (2603:1096:4:14::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:24:54 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd8988b9-ab13-4b9a-387d-08d7eaae62db
X-MS-TrafficTypeDiagnostic: AM0PR04MB6867:|AM0PR04MB6867:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6867441ACB343811412D5661D2AF0@AM0PR04MB6867.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(86362001)(8936002)(44832011)(2906002)(478600001)(66476007)(81156014)(66556008)(5660300002)(1076003)(66946007)(8676002)(4744005)(26005)(7416002)(6506007)(2616005)(956004)(6512007)(4326008)(16526019)(110136005)(52116002)(6486002)(186003)(6666004)(316002)(1006002)(54906003)(55236004)(110426005)(921003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDNHAPl3W0Y+ELkgbNJbW/pdUKrXaezvgBTPYndcuif2ut/3m+fUixanR+Lwmx0E0t6VrulkEZU2WszVJM72hQysPwO0XGq3KdCclsQ5BzACmTZULxfgEtLf3oiHza4uGXIj0JT3YF3nQ/SVhh84EL7nIxh5TLdkj4EUYOujxaKzANv36N2L70gLI+hQOIeU9KaI8a7icn1CcR1LhHpl9GSDZvF/6cP81ibCIWLzv0TjOV6z3T8Z/eHfAwyrLhwWocuYfFDk1gVi47Jh/FxNOZfdaeYmoyIb3FsqAjV9FJUxYOycrZwDEAHY/XGnGdQK43DxnPDn5x8FdiQFARU3teC0cCY+PxW8ExlDYV0htHW+Aozt/D6rbrZ2WZbGOavXzNDeZkAmSALKU2UxftvO8I/xR2+KYa6WLvGI9WQPl1AsuGbNTvWf2+kjhveaW/61KOnI+Uy9mg2lcdVmAi/IzRWqQ/e+N8REGs/GQwaPXggtD1GFyOy2tW8cicrDPun/W8TzthmG+Ve6G89PCDWvMA==
X-MS-Exchange-AntiSpam-MessageData: M/fd8T53+zLaUSE9hJ7btUUIoS836qolxYss4v1byAQwYnemd4v5kBmdLnb3qiJFntb1o3h0uQX5QDWCJrXE0wUfH3zEEsb4+/fr5CATroHX+RyVG01FFkAUnwKQSP1igatf/lt6Q+IbvxQizf9/PDt7llxIFno3P4uYrH3nUAwoeaPv99wA7G7kMJxwV6tjTENQe1O83p9wLEpVUnZYFbedTtVCpx+PNiM32ZIGGpRzL1w9BfzzFJaCB705B1Qr4C2z0ARr8AJdMTbhFKnzyZzhUNBFL/St1hjrR2IT7Y229dKXqdUmZ8toPgWqZ6fNGTySpapkmYO4Ml58jM1kFxmicFmyM4Nl3LTJRBOUcRvfm9z2hgalmib64X6U1RwXxmy05xyyD6FulHEYRIWTnZskMU4T2lq8Rq9GWs9oxsolqmspZiWXDSwaKKqIllKARdPo7o8fVI9JDPv7J2raXNyfIpLyF2Gbvasoj4lwJiVgznPWyXvhHe3rJOqHC1wy4SwSwQITbOe1HwuDiyDhgAkH/l1oQnbqhr+GyqR1QGmfNg23YOh38Yx1whlXfEn+SiW+kMqZk55b9NSw8hCksED4JElL0EDwNeoqfpXZ9VVB+53pkS80yYyorKs3MEadOZvLcxX7AQIeZqOMqrgAoT66rH+YO0n7+y6mFXPdrd36YkC+13T+a9UkI1zOmy81Pm+8C88FAcXdv8LRFoj4VlszJby8JWZKlxFzMAUX1SBh6ac1OL6OeZCUmW5X5phJMDp5Sk8bSXxhV4xbZ2fQ8esFPvga9XM2/r5c1yIvR+g=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8988b9-ab13-4b9a-387d-08d7eaae62db
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:25:00.3765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hJrQTVV2JLew8BHmXlji93FHT7aUTR2HJz9+mFN/sZqa1RrcIK8mEdbA6zNL3RJng7X7mcIYDqRk0jJDFYMcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6867
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following functions are defined:
  phylink_fwnode_phy_connect()
  phylink_device_phy_connect()
  fwnode_phy_find_device()
  device_phy_find_device()
  fwnode_get_phy_node()

First two help in connecting phy to phylink instance.
Next two help in finding a phy on a mdiobus.
Last one helps in getting phy_node from a fwnode.

Changes in v2:
  move phy code from base/property.c to net/phy/phy_device.c
  replace acpi & of code to get phy-handle with fwnode_find_reference
  replace of_ and acpi_ code with generic fwnode to get phy-handle.

Calvin Johnson (3):
  device property: Introduce phy related fwnode functions
  net: phy: alphabetically sort header includes
  phylink: Introduce phylink_fwnode_phy_connect()

 drivers/net/phy/phy_device.c | 83 ++++++++++++++++++++++++++++++------
 drivers/net/phy/phylink.c    | 68 +++++++++++++++++++++++++++++
 include/linux/phy.h          |  3 ++
 include/linux/phylink.h      |  6 +++
 4 files changed, 146 insertions(+), 14 deletions(-)

-- 
2.17.1

