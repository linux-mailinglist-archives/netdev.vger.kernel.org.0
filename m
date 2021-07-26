Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F153D5B89
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhGZNq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:46:29 -0400
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:23266
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234296AbhGZNpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 09:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJWVPZYQ7pK+17RkY+tEMbDsYIarO3pUJRXU8wnYt0NkjdW3xASv8I5FbjCAu37qR3zXuL/xdJoVtw8XoQNVk3iUgiLzMdGYgdGoosfq/2ieKKqo33q761gykUKmCnMj0uI2d8JCfb2Oxs/4MoKNqjIPuJsZ2PU1RLoB6Mp/fwjY24gGMMYUUMTwdBsJAYVHgQSVHtp+pXkdi25s5l4XA8ukp0VQu/wWzBIbk9ACRjQoW++w/n9duYnPsy4sSrcXLbvy8N4m3JV+1m/yKsCMCxEvADwspu0nzBSi7bJk4nLobm57Hpf69SXbbFBCl1mxoHBYzPbNIuFDVwvijTaRPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddqlbigUEMd6o78+Z7G4lvdcZ37q35MBwX8GH+tCFEw=;
 b=bOcnrYfDs8luPyb812V3sSiPs7S+i3dPsfhadwqDAuGAu0WaY2/kCP7DXglkEJo3IHT2/jjZoFAb1JB0hfSTiKhXj4W82/qU685hfO9Gn3N2aXlOsyDSYliA+W/hPggMMENJ2Gf7b3ICUVwqKqDlUGbgs+m0dxPtIMlhQj5qlfebE2lg4u4e7whn+DJU4KbRXfiik7z9Pr9pyhTFxS7xODDNbvOzSlfGfpDiQPKEadlm1Q/jcu3OcXzQ2+AE+gdf/X9CzGwvuyy2M4MSJQ/Qsoe1Jak4rPANqRXdECBFSwIdSKIONoQh7OYUc06UkLCUzCLDM2wp95XPf5KLS13EQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddqlbigUEMd6o78+Z7G4lvdcZ37q35MBwX8GH+tCFEw=;
 b=Wbb6wmNQYKE79tuXTh1Zr56yrh66CEWSOtCpcKh/3c6QKCL5IZ4Av0vg6evVBET4t1+8UG8qNBhrn6GXC6eknU55+lHus0mWzfUUSOzrJpCqcGs/g4X0eg7/TsVYEULxPrgl5jr64fTYNgndx+urVznBBlBo5PCGAzmCkbzPTlw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Mon, 26 Jul
 2021 14:26:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 14:26:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH net-next] net: build all switchdev drivers as modules when the bridge is a module
Date:   Mon, 26 Jul 2021 17:25:36 +0300
Message-Id: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:205::24)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:205::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Mon, 26 Jul 2021 14:26:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c92a407-325e-4ba5-0b0f-08d950414ca1
X-MS-TrafficTypeDiagnostic: VI1PR04MB5294:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5294E6A9099F6AD97A82D1BEE0E89@VI1PR04MB5294.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjNqhXKCDPo4++uWapwB3wdJbRssuUuhCHfctNXUy5KfSWGx55Me+CLsPS8OcgEjgyYAu5JCmNcKwwpKoarbS93VEybxGc71NDNGqr+L56hV0eJatZ8YwWey93FfP/G19EOEK3MrAGLgZu2VCFOKkBQs8EX9WXCXgipDZcrel3M54MdGEKw6gHsfLEFnE9vIUuY3JgTZBBs3YTKvtjqUDSmHVUg7gXMqHM08jMKK8Oa87AfB+AuZD6aWhy91MehnM/vb7BPbnu5BecAzeTlnefzmrU+7pfbctzBLuCDng/BozQHZJt2XAzB//dMb/ilsPDS06U4n7wQrDxm7V9XNrNPJpasAADfUYWtdq+ur71SO64gqXGg/nGg3wSYZxq6UDsBsFqapSM7LPQ+E06UebBAw/h8kGEkUHmCgIDKRSW8Mih3qlaskX86bLc3fHcorjQ+eLgYUh+MEHeU6+/VzlFlTklBfTD1gy2WszfrsScUKpXaMom/E04hI3KdUZ8uqE93dpWJxcpHg8sV+XQTcTc7SHdj5NbPSrOH13mIqjWkmNps8hzjJr/7lj5PIoWtKQvPVY/s8Z2I9TqSfuhf+KCBHJiBOyqcyLKExJayxSH/dbXfSOQlOGxDJh5Hcsd6iPzBcFxaRqWtLiMyZXZo87Z0DsT4lZi1Lau/z//FkovyrdJpe/PgkB3Yg45FFqgWCMCVx62vtNb6q/Adox2c35g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(110136005)(4326008)(52116002)(54906003)(316002)(2616005)(1076003)(6666004)(36756003)(478600001)(5660300002)(38100700002)(44832011)(6512007)(7416002)(2906002)(8676002)(26005)(6486002)(66946007)(8936002)(186003)(86362001)(66556008)(66476007)(38350700002)(956004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gyaD/jC9/Bc3Zlsdohtb8MnYENvOuLVE+jLXaxtiP4sud/FuTOnHkUMV8hwF?=
 =?us-ascii?Q?uu6ye9BoM3hCUBcTabomHzlGBHJrvjfviIihVqMWP9M/HdYGiYj7SjxiWxj9?=
 =?us-ascii?Q?dwH762TGodCPHm+wNLyshARmTNDcm65piiWGcIW68owxwqkqvhXnpWyPxoAN?=
 =?us-ascii?Q?yXUGu9C05COxtdDzCRBU5sh107z+4AjJNCx27X9Y5uMcGPNS4dsntoA09TAP?=
 =?us-ascii?Q?S0stvSCCe0JeQi0cy8Jthqgzq1OM8WEt6SLLNzz3Ngqo49g5PjIErTCk9bJr?=
 =?us-ascii?Q?vx0J/VHQbZCVHQb6E4JPirZHYJei88/0HlVIbVu7vlEXXUVTdu1XPFpuprQ1?=
 =?us-ascii?Q?3XIcihmPjScmIHeDMeKICBlP/UyRWYVqh7rhnb9Vt75pL+p5mFG4TcPilsaO?=
 =?us-ascii?Q?+8xiCwnJvcL+kMua8Y/Oa6SqO/1Jn2Oc7hH5pUTjbXyDWPGGK4xwl0fg0dG7?=
 =?us-ascii?Q?axRQcL7cQlG2MgtXs2/50AF4fHWMSBhtFaOIF92k2lpP+XaE6pl7EB0wol3v?=
 =?us-ascii?Q?46zzlAI7+lH1USBqTp/yElDFsSBXa6sOW2M2MPY+GEjKcOMQPoZgT8AT2h9E?=
 =?us-ascii?Q?b5kK+Imtv2TQuIiI3NEf9EfLUNZ6wgQCeQvZn4NyPKyyHYLcQxBxTkeJKYqP?=
 =?us-ascii?Q?hQh29oNrs/ab7RRLUIjaesFeV22IaknnQQWuNsm88H1F/7xh4z7Y225+KoUu?=
 =?us-ascii?Q?9r4+E2H00TG73w35TBlth39HPbvq7muhb/5l/xecksv1GMdI9CnKGFDscxT3?=
 =?us-ascii?Q?DsYBS+zrBN/q6FkRAsFD3+BXSxl1Bd23ZVui/JEQn+ppXdNlaeror9/AnfcF?=
 =?us-ascii?Q?rmHaTBsS3xt5thi3TYVceN76EOyOOv3WHeiPGppAkKY7T2jXZa1Xy2LF5zzO?=
 =?us-ascii?Q?HgVAktFm+WjuLCRvSjv0C8Ut9StJMMACgaxW634erWQ7GIrnJISqSBNELfea?=
 =?us-ascii?Q?cR+vTDCUoCPLCgE97fqDMZI20fMqDKY1uNiCxYnWeNBHO+YrOdKtgo4sfo8C?=
 =?us-ascii?Q?QG4m+nhnvjCLzZKsspqd1TdUJ6t1P2vEV6S3RTdK4lSSQwQwMLYYbV/kEtjR?=
 =?us-ascii?Q?kF8xUow5g7cXb5nWub0XUwhLmUXXLUgLAMN20jwPQQJ/Wctd8W0dFgyB2B/v?=
 =?us-ascii?Q?cdQ41M8f23Bos9ehJYgjuVqR/sPqLPqzx4JfY2lq3e31loJMjwugCMjrMkzm?=
 =?us-ascii?Q?WTr6bKyZq/mBEaL2I7nqYNYDjhzNhNz5K0s9M/oigZyFuCvVa9d9Ris8bxRy?=
 =?us-ascii?Q?7xe+T7gywO6AzVFHGc96t/PwILHDdnJy5GmKHNZqwsFPr3A2Bbdkl/8npKSs?=
 =?us-ascii?Q?7Pij2w2VjhfmJOUuL/stiCse?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c92a407-325e-4ba5-0b0f-08d950414ca1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 14:26:04.0523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1A74nfWXlhpmKP049/ZW8ejCqb4szhlRPzX54b/Wd1QguR/9KZKXRsj73K7wMcn9wLrHVSoPFJPBiJp6DJE2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all drivers depend on the bool CONFIG_NET_SWITCHDEV, but only
the drivers that call some sort of function exported by the bridge, like
br_vlan_enabled() or whatever, have an extra dependency on CONFIG_BRIDGE.

Since the blamed commit, all switchdev drivers have a functional
dependency upon switchdev_bridge_port_{,un}offload(), which is a pair of
functions exported by the bridge module and not by the bridge-independent
part of CONFIG_NET_SWITCHDEV.

Problems appear when we have:

CONFIG_BRIDGE=m
CONFIG_NET_SWITCHDEV=y
CONFIG_TI_CPSW_SWITCHDEV=y

because cpsw, am65_cpsw and sparx5 will then be built-in but they will
call a symbol exported by a loadable module. This is not possible and
will result in the following build error:

drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_netdevice_event':
drivers/net/ethernet/ti/cpsw_new.c:1520: undefined reference to
					`switchdev_bridge_port_offload'
drivers/net/ethernet/ti/cpsw_new.c:1537: undefined reference to
					`switchdev_bridge_port_unoffload'

As mentioned, the other switchdev drivers don't suffer from this because
switchdev_bridge_port_offload() is not the first symbol exported by the
bridge that they are calling, so they already needed to deal with this
in the same way.

Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig | 1 +
 drivers/net/ethernet/ti/Kconfig               | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index 7bdbb2d09a14..d39ae2a6fb49 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -1,5 +1,6 @@
 config SPARX5_SWITCH
 	tristate "Sparx5 switch driver"
+	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index affcf92cd3aa..7ac8e5ecbe97 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -64,6 +64,7 @@ config TI_CPSW
 config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
+	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on TI_CPTS || !TI_CPTS
 	select PAGE_POOL
@@ -109,6 +110,7 @@ config TI_K3_AM65_CPSW_NUSS
 config TI_K3_AM65_CPSW_SWITCHDEV
 	bool "TI K3 AM654x/J721E CPSW Switch mode support"
 	depends on TI_K3_AM65_CPSW_NUSS
+	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	help
 	 This enables switchdev support for TI K3 CPSWxG Ethernet
-- 
2.25.1

