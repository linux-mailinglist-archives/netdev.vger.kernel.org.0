Return-Path: <netdev+bounces-4330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4865370C185
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BD511C20B2F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB111427D;
	Mon, 22 May 2023 14:53:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3DC14278
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:53:23 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2055.outbound.protection.outlook.com [40.107.22.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F018DC
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKiB4XUKRAB1whtQGp8w4XM9N7tPkMTDTkx9c+Wo/tVDNJ4n92xad8+leJokb8VrsuRMvIK1AR6ncK6+1b9PH16e1QgBhTiX2ACeaBbzsE1MyyBGymatcutV+qGKka2v94tUnmmaso1go+ntgQ30B7T5QnZK3tt2Kfv9zJNI523CK0qoa4cASaYJP+P299RAr72VSV226GOQcc2nyRAq0lKDdn+p0Klbr2hCpn+lpf4Elj2IsiUrGrY8A5nm4t52z11zkEzT99eDb+6th2EhMt7aqIZc7KUpCr/o8LEYQSweMS5+xs+9pe7n/JNNCZyQKAW2pbMTXt1qr8OmO7VA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTYrJAyZ54kc6EPGXTtoxs2xf1isxV0olABI3DzLqVs=;
 b=ErZVGAU2ubgt8RlkPGx9gqxCJ88FaHrn0Mw7O5i3ota5TpAxGsmwh2oSDyyoLzKl3AmwBBWdXpGAnKC27QJi7+jZ+zfwu+ps/VGh1yHCNKD0f1950AA/XY115B/j0ttQ/O+s3PG3KcTrHsM9xFCd8vu6WWpw7Pp3gbSuWcRRcq7fVrtG8N7EQ+t3rofH9dYQdA7URrp4tvs0YG/q+Ud5afYVrLmwW3eJMcf11/d36wDPboD6u8ZZa7WsaU8XrTaA16Jx/T9YxP0vMeEcSZZ71FUAm9ZxdL8tbgzeeMg+FUGsMNkAdRl2EKVeKXjVSAmuQYH1YluoephCT1DeAwoVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTYrJAyZ54kc6EPGXTtoxs2xf1isxV0olABI3DzLqVs=;
 b=hdIfM2UDDhV/YBgGE4/S6vjKv0mU8bsjv8knSnWpEWegVIP9+OAAFH4EtNpbhWyE751xwSTeJsIOp6Gq3vuzprStn5174vPgOg59bQw/7zHw2El5ofqSq/pKw4o2wuh20ihAkVs5pAe7vc5F6ReoP1rrG9776UoOdRTxJtAcpek=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com (2603:10a6:20b:42e::18)
 by PA4PR04MB7856.eurprd04.prod.outlook.com (2603:10a6:102:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 14:53:20 +0000
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::9e27:8c41:a8d:938e]) by AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::9e27:8c41:a8d:938e%6]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 14:53:20 +0000
From: Josua Mayer <josua@solid-run.com>
To: netdev@vger.kernel.org
Cc: Josua Mayer <josua@solid-run.com>,
	Russell King <linux@armlinux.org.uk>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 1/1] net: sfp: add support for HXSX-ATRI-1 copper SFP+ module
Date: Mon, 22 May 2023 17:52:42 +0300
Message-Id: <20230522145242.30192-2-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230522145242.30192-1-josua@solid-run.com>
References: <20230522145242.30192-1-josua@solid-run.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0199.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:57::10) To AS8PR04MB8963.eurprd04.prod.outlook.com
 (2603:10a6:20b:42e::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8963:EE_|PA4PR04MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a0c8736-5083-4d69-abfb-08db5ad44879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w5XmR0C6s54W/4uYs3kRHw6tzIUvTpQhtrRyUocU2NqXl+oTpZ2RVzk1wpISvXnheo9wswsa3BWsoarSMco0+Pcvif8pnjKM27FNwI+k5EEEz8yB9Fzf72sYrgneSAzPARkL5Oba6ICtvhbEqMEHsXwUxOBMtx0DipaEQBDdDdtEo844OvRhFl4Umbwd6CELA7+8vBAIZ/EQ4fvjiRHQGr4QqO6aPFbq5JhYmsp4guCZjMhSZX1oS/mtN3iEbKaC3NMrpZU2pENgBdANAT/SaNSzdnjNDkq8nOPFvgIFMdyfp8n+EHRe+rjRHCWDHxUaU2TZE4n8UAMkZe2UJ+/GSc4kXQf/HJIliKSDE9C+jloh3H1/3yZTlEYtFQjYqvFIRFpeRtRUBaF6Rtc4QWpFEapKFdHFRhYhRPAmp7AXFIKIoF0XNo6ab9icrdoMP9FW7EJvqTJ44dzwd2ubMy10HvpCIng4pOwYzPqT4oq7Hj2oeN7Nn4GP3lEYwGzW9gvpvVweKNgrhLAqCh5uLQLG4kAr0aEvR6ZIkfGDQrVQ6AwgmqNciaoyjkP8lrgTLyXFxt0KGzH+53qCzzu10+/vFhTD6rR+XQDDeVPiuSBEw/qaR00RWZY0UIkIWlONdXWz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8963.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39840400004)(376002)(136003)(451199021)(8936002)(8676002)(5660300002)(83380400001)(186003)(6506007)(6512007)(1076003)(86362001)(2616005)(26005)(38100700002)(38350700002)(41300700001)(6666004)(6486002)(52116002)(66476007)(66556008)(66946007)(316002)(6916009)(4326008)(36756003)(478600001)(54906003)(2906002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OvQcowo1Irwnu8MrPT5uZD+cNxmRxbPVHvml7HD+3cetbMlzFzE5XizY9GsH?=
 =?us-ascii?Q?639tS4Ku8TLxuIw1vJRRusyfPfajvO5IPegKUH6MFJM1kFE11GAsqMAmbkfv?=
 =?us-ascii?Q?329iGfZ5sXC+maTbL3rcpi4eouzF4IVDchR2ptyqifGIEOigNl+h5/DbTLap?=
 =?us-ascii?Q?j4oSpMYLuAliSefUt+4VJIp5yTyhDwq3PRSmxC7uieGthTXeNGsEUQsQ+uuF?=
 =?us-ascii?Q?GJYTC3uERLYpl0UXEGyGbyfxESD9PUXCurLkzZOQyLCieZQdbshufCD6PfGj?=
 =?us-ascii?Q?ZsTTIkby6Dv6pdtzDn/myRH3tyjTdrCvLp2Fsv9QQ+N331MuHf5ZUTeBT2tz?=
 =?us-ascii?Q?kvf7E0OgW9k/E8OyvTjcQgURjZKRUtohJW5Qtvd75YK9bxftb69626vezBm9?=
 =?us-ascii?Q?hgc1vuthdwpHDtZCqMJ+WUpEtp2Qf6O4tUiY76x4SKMh51a+3x6U4EAeSBH/?=
 =?us-ascii?Q?45ERNVFIWM+3m2DoCkKuWIBP8EARgXqArCPQW6BqP6noIP10OVZP4DBQa2xX?=
 =?us-ascii?Q?luNCm00X2rEfZvHm+txIwgUpxdS0M4KssKPqGhBl8ewi8RlpFQGL+Ia1F/Ah?=
 =?us-ascii?Q?wzuNrBoOKfs7XJs3WCVBbBFAqgywzncIHgnRARP5v6qZSDdl8chp9HHJb7H6?=
 =?us-ascii?Q?u3kjFBQBrp1GR3bx9kIepqIGMBne+mx05SS3gSVzgzeApc8kYm0lyF+qTRN8?=
 =?us-ascii?Q?bcnNCIm4WNCwe7LnODYyFJfsNP0ioinI1gfvTv+r59lJTMhRY/ceMvcndpa4?=
 =?us-ascii?Q?5HZRT8xBQXxguC2hPt2DladXEZRcsRq5mH/Z9O7a7YUrV2Fv4bA1YsWihFYf?=
 =?us-ascii?Q?qrB/4fmq2MCyikZwi9q0QKh/Ujg5C4AaclWlKpXSJ8NhYUMxTfWbJ7rpaXWY?=
 =?us-ascii?Q?tFq7RRiUfZVXm3J0jxbpYgkBXL6iLxbxTBpHcq14jx8KROMSmL7x0r5DXqjP?=
 =?us-ascii?Q?ZjrcxAeA7LjQvFfyYqddpkpt8P8ymv6Ttpq//hzV5dAv/6qg26q0oRW59hYB?=
 =?us-ascii?Q?WL69JORucKUjKGMmW5KhzTDp4wE54F/9KRLxmgSkv3ZZlatOmuNGaxlKjT10?=
 =?us-ascii?Q?WhLRb0/3lrtMGuld6om21NoazEtJYWizmRbag9lfPnu34mY4vnggdBRbOOIy?=
 =?us-ascii?Q?0g106gs6DIujczcHo8vWbhx3BkokarCUzMGApHHaRRbng/bYv1OkpK9iSu7v?=
 =?us-ascii?Q?bbnRJ9G/jl+4o2tRNsApX4pdIa8zX0lF4eIVnBuQRYUky33SdW6wouJRsw2Q?=
 =?us-ascii?Q?QA9PP4nNgyusVWmHtUGpr7pM8MzInzFV641omJYDOhRyVhJOMWVU81p4881w?=
 =?us-ascii?Q?Et+Wje4Tk56ewyOGBDH23+CwEht8x4zsd+dOVVu6PjNsOMw9NyaxslH/EJAC?=
 =?us-ascii?Q?eQeDNm8nB/uKIBSZ/1ePqdtPrmKEipXNsQhZEHAWfQPl3qxchLLOcvYlJ+O8?=
 =?us-ascii?Q?4duumpqTnKhavGGJQztbX1pwOojbsmB+n2ZgWdaE/wkgNNLyS6PSwJYyDWqf?=
 =?us-ascii?Q?vm27rZxvA2FOaoD1bghrUs2FoNEqsguAwahIGjY3umuzY7r6DHfzK7QZIKLt?=
 =?us-ascii?Q?iocp39oKpZYjw7dPnylRkc1VMnJCjAjQoVmaNdFK?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0c8736-5083-4d69-abfb-08db5ad44879
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8963.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 14:53:20.0153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggkJFgokgD9ujFuuKxapcr0TJrHkN9y0QoBeYFtXfUDGuUjJb8hCduWIFLR0nCRTGXX7DZtLRsfnIaj56HIJcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7856
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Walsun offers commercial ("C") and industrial ("I") variants of
multi-rate copper SFP+ modules.

Add quirk for HXSX-ATRI-1 using same parameters as the already supported
commercial variant HXSX-ATRC-1.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ce9693f9f488..2592ff08c783 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -451,9 +451,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
-	// Walsun HXSX-ATRC-1 doesn't identify as copper, and uses the
+	// Walsun HXSX-ATR[CI]-1 don't identify as copper, and use the
 	// Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("Walsun", "HXSX-ATRC-1", sfp_fixup_fs_10gt),
+	SFP_QUIRK_F("Walsun", "HXSX-ATRI-1", sfp_fixup_fs_10gt),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
 	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
-- 
2.35.3


