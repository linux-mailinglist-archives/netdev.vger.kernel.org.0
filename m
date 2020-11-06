Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F136F2A9932
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKFQM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:12:26 -0500
Received: from mail-eopbgr40097.outbound.protection.outlook.com ([40.107.4.97]:14503
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbgKFQMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 11:12:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF+CqrAwd3My3e1g1voADX/0p8Wy/Ryb5gvfVxbMXPI8KYaCSrJugY6JDFGlrDrrzydFftWHLVIswfZnJUeEiow6PLe2mCIKzkxDkyv8PTnvgeVReZZ7CMd10EGyUMIzqr027CdiVMVff6jgd1h5rxP8iHgcg6qkZNOVZ6y2cX4VoYF5xWROr7Vk02/i2b/fbsUTH2FC0lQAUTg4HFCx/m1BcXvIoY1EC+53PrH500tNsBdmnLVawUwFxzl2LkI/Ak/DFmo9p+3yHBtJee8VJh+xY2uTaf1KuIumCWt2gJmsVpLi7j+NnK4OrQz74z41DvPnLdU876p4u63Y/046fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8Df0edrjwG7zvlqwzcM7zgQD19g8v6gG+4/QzN8Tf8=;
 b=g8xHkmiBa2Yh6EdliW7WKRWGX7d9QBZb1Fe8ZMePjUQv0TmL6X5RFsalA90QB64xJnFZ0nc4mhOkjokBg/G8cDmelsDQlDSrxTUwcG2yOFlNonEcDJIjnSJ1k7Az4v3m00D4tENulKT4UV6sF68SOuvD5RenwVUhUM0QSi0Dekcw4PCM14sc7AfwnuTaqfer/8KhSKgfvbVGOfCaWB3Ss3bLxiup7dpGSo1CAmGb/3NYgQPTpnmzo6IQkMN2PU+wCvt+FG85XDilVGhQhRerOGgszIsgDWIeIHylOkNGiu2VK25sxERBamsoyV9OFRVnjX58bxP2wcbSdn55OCzH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8Df0edrjwG7zvlqwzcM7zgQD19g8v6gG+4/QzN8Tf8=;
 b=k3VNSkdnTk2ppRZvW8weYrzKgekqfl5TZfMv5HAo+6Km6GUWXZ9sZN2ovBpkUjFbZ34YJ8S8Vlj/+NEZ8FoS0qVI3bKxlYXYLZSiIWey369Zg2Wgg8eqccCfJ9OxQOOMX386UDpnpoFioIbmEptZmLI1YIIUFUJ5j6CIxilXoX8=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0489.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:60::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Fri, 6 Nov 2020 16:12:21 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 16:12:21 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>
Subject: [PATCH net] net: marvell: prestera: fix compilation with CONFIG_BRIDGE=m
Date:   Fri,  6 Nov 2020 18:11:25 +0200
Message-Id: <20201106161128.24069-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0701CA0062.eurprd07.prod.outlook.com
 (2603:10a6:203:2::24) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0701CA0062.eurprd07.prod.outlook.com (2603:10a6:203:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Fri, 6 Nov 2020 16:12:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a4e5068-cce0-4de1-2c74-08d8826ebd56
X-MS-TrafficTypeDiagnostic: HE1P190MB0489:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04895566926E107DDB26224995ED0@HE1P190MB0489.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2tSmLTChG8gQGjJCJqX96zSE34AI6Xb7IIN+jgQNW1dV0JT9EpWqXRcN2GsW3qanFWYMvq1COZ9xZGHtWTh+c3SmDdYjPgLvsgK/I47lAC8KYJmdVJ4kRUxLW/yMHLRh3u9kvnzMqAPJVqwxBLa5y8aWUy6Eha4BwkRgnOoO1FVz6GJ0dGtr59ZDg5Qxg92tXG4zNlTWEy/oezKZu9WVrmm3eHyowsZI04o1pruib/nbkxchGjQO4QRyG6O6+/3Lh9UuQijjOX29oBJuiWQbaYvahVNUa09IqmXbEGuxoRK2meuL5XubDXRBb8WlZIqpIlSSM2grU7CC6koRoHk8oNJhuanFyvvxmrIJ3uwOxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(39830400003)(376002)(396003)(346002)(2616005)(36756003)(6486002)(16526019)(478600001)(6506007)(2906002)(6512007)(956004)(8936002)(186003)(5660300002)(86362001)(66556008)(44832011)(110136005)(8676002)(66946007)(4326008)(52116002)(1076003)(66476007)(26005)(316002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HqL2zCFEDS0DBArIqcR/pUVmbCxMyTGiCPRHwpT2a5kacD0UvTNRGvBEFmwz2X6Pdduqzb+28tm+mxh+1gsYtjZI/h7WU/sek7mGnQ98dD0QWZp6azj+ridyPZjfi4v8nPkU5LpvmvDWqKjr31L8CreY2C1Puv0lxWZ629nFdmC6SC7kLUATBRl3yxOrzhtS0tEYw54iTtgI4LBvDRSoJyI7edahGlMQOOnQZRX0pdh5wAbHfOdMx2Ly/PPZ/6a5XoNHa4zU+W3BJMs9jgEQXat2vWcz+0//5XLbhQXJJQ/aLa1pj+JsS7caXNqHHGQ8l1rDqoazhvN4kpeEsEF7vpAZulo/MJpstLECZRFI9wHtNHR1AE510qs4ThzaE6YTr8x5CgkG1zRExSLIhxAxhaWGC2VSDj6wQq1lxxwKU85IEiIbwNjp/5cysFhgC+Jco+g6omaYMuJJQ3hlPUzfZouxfx2d06MKtet1rAcSIasSMJD0xC9EdPpDPZ8rPVwfMkUzaJEzuksVXaAvBO7ktuGeHklPDGL1k+vCQbUVgnSnl8XNJrVX7DgcqbqTDe5DPYuyJ3Cb+pLGRlxQ1VfIvk+zIvU52YqV8O1pKYrkQPPfp+duFQQigZNuK4ul/d0uvhyY1RNE17rHtu4qkM4TQA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4e5068-cce0-4de1-2c74-08d8826ebd56
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 16:12:20.9628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0AGn0tlv2bisWjREZyle+RoC/IqucP+hH/pMarnuJ5m4c9gKtrXgmgphxEUREC0tulXtEuV3D8/L9muir+SCYbpqc5tN6LUv24H1GC15Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_BRIDGE=m the compilation fails:

    ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
    prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'

in case the driver is statically enabled.

Fix it by adding 'BRIDGE || BRIDGE=n' dependency.

Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
index b1fcc44f566a..b6f20e2034c6 100644
--- a/drivers/net/ethernet/marvell/prestera/Kconfig
+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
@@ -6,6 +6,7 @@
 config PRESTERA
 	tristate "Marvell Prestera Switch ASICs support"
 	depends on NET_SWITCHDEV && VLAN_8021Q
+	depends on BRIDGE || BRIDGE=n
 	select NET_DEVLINK
 	help
 	  This driver supports Marvell Prestera Switch ASICs family.
-- 
2.17.1

