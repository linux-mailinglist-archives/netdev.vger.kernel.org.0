Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30240474DF0
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhLNWfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:35:52 -0500
Received: from mail-zr0che01on2095.outbound.protection.outlook.com ([40.107.24.95]:39009
        "EHLO CHE01-ZR0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230098AbhLNWfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 17:35:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPr4+chUZA4Hp1Ae40Li8PrOudehptQv4aeHTbFo4mq2G3aqBR8DKmtKoBJi+x/dw9AULk5MinlXxnL1+f/aJkA233LEU9oxfo2VuHq4EtAEN1f/g2fM8ERcrfSceVxqoCCY7y0cTEodvC+BeJn5i2cB36BOIP746woCszqrIMF/JQDA9c7HVv1C0qzshmekgof74cuPnGCXztvkXWdjCivR9vLrDoOCbUDEUPiUbP/0gABPhWoyYNpbYTNs+o7oJcCt4kYeqhUsqUKc8Y29fMLobQH7rbh5/uZBR0XuHQTEcPd9VL2/5SKkgJAb1RLZoOHPZCZdQKw8OvlKAkDhyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=spiQY1SQdkr+F2xzFj2RCo2tq3f7Rqx2B8AIlXmZRl0=;
 b=FXLGIdTlwRWvH4LZTCpZk/NlShwXh6v/jvmcwCBpR4qNBmvLQmit2PGKgTKSXp+DtB18cC5LkucrN/Mwl/+B6XgtNlZmXStLnjDN5vnOfrd3LO32p2HBcKLGXt/KvgTvNdibvb6qzeqUFsF1DJcJ5NqZVNO2fYd6FbnaqqEE4SQE0dVbDCiPrOqIf6D5AuFyW/q/r/P8/8K5UNdrgYlB8641V6uYlEZSdRDg5TlL8O0AMLT9fxwAOgOaJWYlfhOPLsdZtnSzZiPHoAQtZn8mWOQVibkMLgss8XAkTQpFyu3hL/jgCmfxt2fxgAqh/NLvPQCMGuI9xCtspdIf6S8FMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spiQY1SQdkr+F2xzFj2RCo2tq3f7Rqx2B8AIlXmZRl0=;
 b=DdeB2zdNnronBgXuLMJsHYSAjBzBg+M4atqoAZnJucUhdyHBcJ3Rre+x2qwaXcf6lEAglsevyvF/vq3cGmL/ie7SbpKj0OuBi5J+LfdghhQiGSgoHIPhT4S4VU597JApg7TSxH5QgAuxJcAR1M0PF7uiJ5gglps5uDI9U/54sBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::11)
 by ZR0P278MB0028.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:18::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 22:35:49 +0000
Received: from ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0]) by ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d837:7398:e400:25f0%2]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 22:35:49 +0000
Date:   Tue, 14 Dec 2021 23:35:48 +0100
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <20211214223548.GA47132@francesco-nb.int.toradex.com>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
 <YbjofqEBIjonjIgg@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbjofqEBIjonjIgg@lunn.ch>
X-ClientProxiedBy: ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::12) To ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:3d::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a6c5ae-1e12-4975-0b9e-08d9bf5213d4
X-MS-TrafficTypeDiagnostic: ZR0P278MB0028:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0028CE7357AB27670929E8AEE2759@ZR0P278MB0028.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIOqS3cEchTir1FLBvBIw02dfbO2s9R+ZhEgNLQ635iK94XfJlLWTOGPR0ItjI/wVQw4AraxsUWbSXgnLLS+2U9s7gNF6JbrpPDQpeyFkrhLO6mKtAjXvHZxg0EfrsEBwsSlJkhwDVRwHwsGXDAo/nQux4D2qxxWaQB+7ggTW5yczTBqCqa7D3ic9b6Q2lmgkJoea3M/N26kTbFF79tNu+vXHXIaY3t0be7Jxpw/HyVqo8uclLQvDeM8iXq2e/rpsDYxP1RC8TnxXxAGihSPVs2q+rU0sWzI/sLyayXFLvx908AYn50/uE7IKzc90TWqMKK2/dmF/fLS6Wmhky7cQjgDbrqX67Po5syAPR5dDDhgnYooE4pqrhKdQoRNBUoLNZ02/cW/OY+/Cbx/d1YA8lczIaTGYuIflpMdUrsK3Wugzno1jRKXERMEyQBnpyRw18n9RbXmwNC9BscO6bbdjbidbAOpoJniTotztaVcEfhYnVDq1cQk1IMhg2Pqbbjh1PgNWCfwqVyHza+6eXCOZedtWjo/vHdJZZsuh+RexfRdsZ5LuzTKnhWuJXohobl1rRPMXk9yMspcNQOnePQaj4Y4vENIv/8YDlnChbC1TzKSboAc+cYwn+Jey9uQAusDj6Ky4vLxnqYbUJo45/+Cg5PrJpvVVEJW3JuA1rT60/uSbfF51CVFDmg9YhRZ3S0EMUVD+vbgCdJ57USlxlpZtiDUhtB+MydXnUQ93gedAlc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(136003)(346002)(396003)(376002)(2906002)(7416002)(54906003)(966005)(6916009)(44832011)(5660300002)(508600001)(8676002)(52116002)(4326008)(8936002)(316002)(1076003)(186003)(66476007)(83380400001)(66556008)(6506007)(33656002)(86362001)(6486002)(6512007)(38100700002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GQO/W2geciZS3LscuXYMlR2u2Wo1jInC6FTUjBRiToj/7iTpYERsYeLVHVEy?=
 =?us-ascii?Q?8Tz0vOjtb3G9kCp3XCtex1FIHl/9hMxucFWo4XSRYCCKVYfs1KSyoQiQK95e?=
 =?us-ascii?Q?sZVsvPAbXbZdi4b6s+Qqnt6Bfo6rqRTaFg9xGXxXdF5WocMKechGEuvLOuKq?=
 =?us-ascii?Q?PUJ7E0AUiu2MP9JEmqniJ897Lv01lEJcOQG+8x4y3qM9KsRYBHQsqjcrIMWv?=
 =?us-ascii?Q?kh7rdpWjSF7cUktsX76HcbJYyiFhMv8B+SeR5QJYMDzWnKFEUx7eBLGgTEGm?=
 =?us-ascii?Q?up3R84Ef+LsrqiOn5xgF+vTFWKfkkToj918TTRwtZCS+rRWdvJX0EFEEVIAD?=
 =?us-ascii?Q?RrEhARp8c/3sFd5f7K2MTctbYhzuE82x7oG8CWG37zpX9gIh88RdCHQhfWf0?=
 =?us-ascii?Q?icN5px1snPHpUsvBHVXqEt2ARkgCF+0UFr8Xi8l5BQK7Ijnqlx1e9l6RMWTH?=
 =?us-ascii?Q?GeQzww+dStI4x3k0iAb+eqaZElKUQF73acySn5y6ct/T65XBDZ0I3dz9wD3J?=
 =?us-ascii?Q?SGPydztGHHXzF3B8HpX8Gk0DS7pZh1wQBAACZFjeowdlHdTt9FT2BQPU3nmR?=
 =?us-ascii?Q?VyRN+A1qGq0Wm4TC6ureY98MQl0RvMEGH747NCLI8MjVCdQdLNwlFa3rwTlA?=
 =?us-ascii?Q?1TtUOPIwFyFcsFx0HCMA78RW3bB2wqN3EUHjD0tgJczcMBU7Oljwix7NNzRP?=
 =?us-ascii?Q?w8E8opvQOuqsogxPfrG96R1YyPSGF3FthYSCvseiV4YOuM/ufthcnHzIm9se?=
 =?us-ascii?Q?Mu3h8UA2xWCFPJJhmtsTns2r1VOD4o+wuI+WryMQGsFKKm+38OQEaa4t5Ol+?=
 =?us-ascii?Q?GARZsCrtNZrGYNgFAHJUMoqQe7rBFI8mhh1dxcYcqWebrwoSyzJMRvuMoS18?=
 =?us-ascii?Q?TSjRIFe8BfI+tilMx8hw69kD194ukcUVoNRTEJ4Frb5uY6LgYlYdHvTI+O4D?=
 =?us-ascii?Q?ujUzpqkWGe/mqqXnSdUmUHIk3e1i//BH3waXSYGB67noRxsWwHRPlX6wtbR4?=
 =?us-ascii?Q?3KHnM4+4Cuj51vaUiZmV2GG2srjBkWO1Xb6syD3FpowI2A4oRAZKeMgdL6PZ?=
 =?us-ascii?Q?5gU5yp12Hj72y7ksKdh7k+LGb8ck09y6MMN3oWwbHWjXGIAMqzdWppbekUpn?=
 =?us-ascii?Q?OxoGJki16DHUzUrEtVIi0Jlm13cM8GQJ5CLikRi0mPY3SwW7GZjc2vQe2nhu?=
 =?us-ascii?Q?VM6Yr7QhVqgbmCzB4UonmINwfBSzPD1BCsx8A1EyCps1K+J3YeLWZcF3yDG1?=
 =?us-ascii?Q?qwDSTVynjNb9svSbofqKYM7PKC91gZhH7zz1W+HjOd+PapY6k7KhkzhZYPQN?=
 =?us-ascii?Q?sDlR2D01kuOjrPTi78W3m5euQ6StV8dRrJzk9RLgM2S9TKAyKM9NsOwOxX00?=
 =?us-ascii?Q?YTNSe6opHjur8kbHn2NpAQA6y8PyxAZ1fFWEyDyhNcrkJTTinOLkzmWam+FY?=
 =?us-ascii?Q?u2yXarEOAhtswcpQMDh0IJDxbqZrW2GPEN6plcDwjnXHOrO4sfnUK8WEOrws?=
 =?us-ascii?Q?87MHZmdsvNFzM9UEHSfs8KQgg6eYEcLpYNAtngqtOtnuAcMG6bLd/HWSEG+w?=
 =?us-ascii?Q?NjA9qtSyhXrheb9/6rwnFh2wCHzXHNZCTbWPqXD1LdeNRGty+t13y7qg/Q4P?=
 =?us-ascii?Q?mG3BxOfh9cJgW5drCz7fiwVDGDs4wsngX1U5rMSfJi0Lp8mu4BrwWZ8cTinX?=
 =?us-ascii?Q?B7J2ArRMjsk0OTu4eYh4Zf+uMl7NKsjzO7MgVr6SwX7kJxt3diOKrBojYGTT?=
 =?us-ascii?Q?nMZEdwJ9Cw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a6c5ae-1e12-4975-0b9e-08d9bf5213d4
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0642.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 22:35:49.1339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xKqsXQwFA9QlAT7n9h/2LrU7y69e0b6GDapWhe+U+IB5N+09jYeaLFesoMKtKHA1T91khWB50t+HAva0qwNY85YqnwysENhYKI+YCI0y58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Tue, Dec 14, 2021 at 07:54:54PM +0100, Andrew Lunn wrote:
> What i don't particularly like about this is that the MAC driver is
> doing it. Meaning if this PHY is used with any other MAC, the same
> code needs adding there.
This is exactly the same case as phy_reset_after_clk_enable() [1][2], to
me it does not look that bad.

> So maybe in the phy driver, add a suspend handler, which asserts the
> reset. This call here will take it out of reset, so applying the reset
> you need?
Asserting the reset in the phylib in suspend path is a bad idea, in the
general case in which the PHY is powered in suspend the
power-consumption is likely to be higher if the device is in reset
compared to software power-down using the BMCR register (at least for
the PHY datasheet I checked).

What we could do is to call phy_device_reset in the fec driver suspend
path when we know we are going to disable the regulator, I do not like
it, but it would solve the issue.

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4064,7 +4064,11 @@ static int __maybe_unused fec_suspend(struct device *dev)
        rtnl_unlock();

        if (fep->reg_phy && !(fep->wol_flag & FEC_WOL_FLAG_ENABLE))
+       {
                regulator_disable(fep->reg_phy);
+               phy_device_reset(ndev->phydev, 1);
+       }
+

        /* SOC supply clock to phy, when clock is disabled, phy link down
         * SOC control phy regulator, when regulator is disabled, phy link down

Francesco

[1] https://lore.kernel.org/netdev/20171211121700.10200-1-dev@g0hl1n.net/
[2] 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")

