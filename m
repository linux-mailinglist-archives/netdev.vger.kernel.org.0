Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39723EBFE9
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbhHNCvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:12 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:10517
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236876AbhHNCu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkf0QGzIfYJvgWSBYE7gV4SbHaOkCZn4g8wqPrEOVCMPiz6ikmXnEVcQZFDy+CfKhvfuACKz2sJI4hKCqAFsAoAB2Z78/bV+jgWGt3hMn7aI98Q2HG1UH4XyaR0jroTMqBVOwDlYLS8VcdA40wOOPay0IGBa9yR1ecd2tAkMZMrjFV6fTw1B/HRkLx67J8Vo5xaFD3je/dM+Jq0knDqFX/YHaMAtBxwXBh7AvvtOfPuNaEI5TaXWa7X3rbmbhPbQE5fiZne83bEZUVEGqJzhxRbGrrQVeOaXRUa+BV1MNmdw/lHS+8rAzYDR+7DL21l01t5CmVuTEZ7clDBL3rtggg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VADINUX6ZcrePYzMyBY0BWpzDza+w3f5gI9s8clFrRI=;
 b=nv70X3IyW4Lmj/q1ps2p1XENh0fsq6ByMYsJuwzgdmFigyGbxuSCsed/hJsbDuHFuuLpuvL7DvbzQ5uSwNFZDUzzQHvQ/cIj1gAHgD3pQ+DRd5K8T4tIMRnNEyWE6G2NiRTDrOfa2Dnlh+Hw2SnKXJbzliy00tRjO5u2QDpgqp4bzXzvh+ytdGwUpHcOZnFCrhsM/8hc48ZAmdqSlPvDZiH/vfaX4gfG84rpoJ1bTbaqpBugJCRy2V15/7AZ8pKy07FVIFHJlNq70UfEabWvrWuKF9pKrt8Cwq1RDstYLQS2ZIdSjOVN9+5ZMifw/7qjN89WjGgnTDH+jMpNv4DkQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VADINUX6ZcrePYzMyBY0BWpzDza+w3f5gI9s8clFrRI=;
 b=EAFzeo3QbTOaUju4f6eoXGgTroEiSKETi06Nm9HYwW3oU6d0tFWWmCmSkKrJjKXshgGEmvICX372GFmvyEZ8SZ5bJb/bBeDsiFtc18OWSzaGXPoDVGwZYhQJK5uOYKfgyFV9s5eCJZRB8ITwo/putfMOoSsW1BG6Cz40pYhItWw=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:22 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 08/10] net: mscc: ocelot: felix: add ability to enable a CPU / NPI port
Date:   Fri, 13 Aug 2021 19:50:01 -0700
Message-Id: <20210814025003.2449143-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bea80c9-4558-4106-68a0-08d95ece41ad
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB20305420225BDA62B6FB393EA4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sl7BbLMls2EMBrnzYjIS1eMD4Mx1pmR2A+Y/Ay23fma4QtJB4n7krhjULnLQLGIA0oXy7hKM3aRYAMi03YeDQVcke8R7v21kZO80EEHjWJ1b+BWehav9Nf9aSqko3W7SYfWXu48kkhqcQfEFBi3FEPnQT/Gc36GTcr5+JkKJiWmD0VKhBmefJISgdop8900Dv9f+QvQ0muhueXC5Aq5SH+5x2WJzfU2sTkBuTCXn+w9VaAlta+C3MnSQD4NR1YuwhkGK+DEjZUVusd83M5TQOJQ/QMWQjsrrPPA43YMe00e6yuJEX3ljtYwpTjpSIAmvg6AW2a1slEIYxDVWj7oQfAucrxuyxC3CC6iwBXJnqkZt+BfA2NYBDbaswPvG/77gUKwgpFkWg8vNrmAuz7Vb9JPasadAsDHXYenLgtP6cYEVK87tcc2yHK5KYBQa3cTIy6tNKhINJVhCm4rh5ywTK7vtBR6CjLyWLSu52VxA8zVpevQ8ocCGERf4N9g236S1IhSf5B0m0SRUAWyJ7vgNKjCibOhgXDrQ5YQQPbccJBkrSCLQuh6r7w2aSJOhZDWDT61tBCkvq2ye3mf0/0u1GD2ySsp38d3IEquz9fjOt8XWgHCOb6pGirDOMGvwvRFRazT4HZthmi8X/DJrBcmq2LMZ8WeZ4xJoW0DQnZi3UVdnrt4uyHIEjfrmWAcxtT1jeNhy7dBCx+eBQdo7jgDQm3g2CH88GhUKmWuqVdWGHUk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ax5jLpbugq+Uv61y2Tlr9T2akw/JwPwBCJz2k2VbQO7tpxxHOr6z8XiXHc0A?=
 =?us-ascii?Q?+pUnmKv2AKHBubEjEWcFz0n51hnrSjr3gNEs+nwhQTZ3/6WoiebfaPPHsTJ1?=
 =?us-ascii?Q?Wj1TpI3TFdJUcQ8IeRDHWHZ/P89omjNhA2sXb2UPRenuGG2zdvf9+LP+N9MB?=
 =?us-ascii?Q?TV1kxTchjcP8KDk0MBDaxRPh8qS0tFHJq5I+niRaGzW2vWL88ogEkoLnGzkF?=
 =?us-ascii?Q?7avrKbkF4pLMbzSBwRkpH2WHzsHxR+xVrxQmZ7m8V0pPeW3mqVL1+yGmqHZF?=
 =?us-ascii?Q?gEIUJ93rYmeKgdmHCrhRF2LpVTAKN2mP7yqf8F8y63dXOcXxBJ5DGCQnT8kx?=
 =?us-ascii?Q?mxcLyEQJup3QnKR0W1by9cRla/mQ056k8w82MtrpdSsgtJGL4yWVb3/wUkl4?=
 =?us-ascii?Q?7mJ+mddRZBzwBrkP3FZaD2v8XIt3Klc6loFWlGrsBOFd1aP+/CfEd98SgbPg?=
 =?us-ascii?Q?ka6ErKT8ujZTaF8/mjBhNmoBUQNvn+aG7yFBJ3m7h4FFxcT3PZkNcWH74s6v?=
 =?us-ascii?Q?kSZ559u0nqcIN0VVSPwvtSb4PZJ4W/2KHuwgTNDP30a2ndFpFaGYQcND8EGs?=
 =?us-ascii?Q?4rMHEKRErwLuZ5KpQYCVwLbAMeVEHUDYKA3zI5tjIol0R6NzkTt51rEH1wqM?=
 =?us-ascii?Q?ZmGkVbAW4tnRbb7F7sbxTqHsPAoaQpnOPr0FkXPZU1bpNYXpsNg3B6LJY5Dh?=
 =?us-ascii?Q?Uax2mgv20J2agm8ZquSKHJYBOGkHTmsc7NrA7nQhFkPSsvA7KpRifRqwLo7p?=
 =?us-ascii?Q?ZnzS2pQ3nuNfFoOmKBBRmcLAsDFYBnbzBjHou7+ekQaQWekXrF6ztQ36kqT0?=
 =?us-ascii?Q?Uipi6CP0t8PnDlCdYf0sngweOyiZXrJzimW7wLKM5kYqdCrSPUhiXjMVmRnU?=
 =?us-ascii?Q?J/U9Pl6F2LBSpp6ACxgczqlnEbVx8nnYCD/N/TuMGlB+qzGlumwGToeTFLOq?=
 =?us-ascii?Q?3etOCAeHFT8EAfx+9y2aNOotaq4qhBSo4iNx3WKrWESHLibT0jwpvgQY8MrZ?=
 =?us-ascii?Q?OdmvTD16doSxarcP7y3UiqVjHBygKVJFmAf5aZKdtW5OZYrYi2P+QnPV8l6X?=
 =?us-ascii?Q?Yrq3GyobThcte027/Pjc4gR6f0NSi6hLOWs1Iq8Krm+oWqsmv5f5oYTT1sNp?=
 =?us-ascii?Q?m0HVIAqIF9PdmHoULn0cpoIzzKtq8W9UPE5dwPddFySuiY1seK9//VO5wl5x?=
 =?us-ascii?Q?URGklAshtavKTM7v7ZztBxpOgtplVGQYMIrfk/WN3s9vkxTGxBYLV8UnkcRq?=
 =?us-ascii?Q?51vhrujqjiUXGkCWfA43SoHXHPijrJdIsnpfK/IY2UTqfrR5CNQBOgJ8wHK1?=
 =?us-ascii?Q?oK5sT4rI8W/ewy9RrpyCEVyV?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bea80c9-4558-4106-68a0-08d95ece41ad
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:20.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fXSVr38tNRFc/82UK55KHlaoZrC8YZ8Gbb4Dot1TbQ0OsEbCp6l/JDzNTrt2SAVxurV/zw7Vsjdl7MeH2tQJKnYhAec4YifioGIrPKoCwXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the vsc7512 ocelot SPI driver, the CPU interface port needs to be enabled,
but can't be enabled via ocelot_adjust_link since it doesn't have a phylink.
This adds a hook so the port can be manually enabled.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 5 +++++
 drivers/net/dsa/ocelot/felix.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 77644deb4a35..33c0c7bc3e58 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -492,8 +492,13 @@ static void felix_teardown_tag_8021q(struct dsa_switch *ds, int cpu)
  */
 static void felix_npi_port_init(struct ocelot *ocelot, int port)
 {
+	struct felix *felix = ocelot_to_felix(ocelot);
+
 	ocelot->npi = port;
 
+	if (felix->info->enable_npi_port)
+		felix->info->enable_npi_port(ocelot);
+
 	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
 		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
 		     QSYS_EXT_CPU_CFG);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 25f664ef4947..c872705115bc 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -47,6 +47,7 @@ struct felix_info {
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
 				      struct resource *res);
+	void	(*enable_npi_port)(struct ocelot *ocelot);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
-- 
2.25.1

