Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEE422EABE
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgG0LGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:06:35 -0400
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:18112
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728540AbgG0LGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 07:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kO0WiDymYerTQZzcISnnKJ49/zys1uFdlwvteeyCrSRXHgyb3xoGmgAvMRlrIpUxcinbMyaR2GGXoMMJgTDKHjMe7cPpgojRtlaAnBdGRNVB1so2dfcvt3Z4ZW4/uKVypzbImKoo9BJV6JhS2XmFNuXFvZ5cujpOIDV1wutv/DdZs3EKuIS3SX1iGEovazY3krrZG+cerlJfv/ooTJzb0xsYlmLLYyT6q/r2jEI5a9OVo6uMtU+9lM/FHAFLaD5ruxEPDpUCA1I4iutJyZkrelOwfbZXnu0DSXMuCDNk+Vw2GUsn2z4zTP7XpdHvFWW9uLZM12uPY7ZIbWhsNXeoWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3k9X2rqq/jJIIXu0mA6HZLu/WnQz/P5jmMdxsQGMq8=;
 b=XvoE31L2ft5klXRGEvTF7zDWNVazV/w2E+vvafTU9DXqKxEjGH9RwPOgmxWbyg5EvCcYzNUUu0YDzYiXiHb/j6G/QADN5Vw+FE3XbCz43L4aXxO8nvx/NcvzBd7WOiuIhoK8T3ROmhFgPfL4VSrJq5so9u4XmD93Me9l5N+9WOb9RXInrd0kfAxi/V6vhFy9skS6WiKruqT0RG2J89yAZz5SdyO4JBbT8FBVlJZMTOzF6B2369DlO/9tSJxH+0ix40UKOK8C0EJOLbjL/k0gxUUWB7XnpgASPbqW9TRbGVF93OHyO6lIpA1RBSzqLuxgUvUQwoyNEVzGeeKSvVtyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3k9X2rqq/jJIIXu0mA6HZLu/WnQz/P5jmMdxsQGMq8=;
 b=JXXuqD+4jJLOACFtXfShiu5Uh6Ik2Uy2pKtesAGRNErLJgierAkWDho8q4D0XyoM+I8EjOvfm5dMbf0Zsst4GSbXJQm8fQGx7kJI7wuYWZ7/XzGb2OFNAJEPsqQcO8GYLzkME9A31WlyDFN4MFCxUyhX+3Wy6wly56PHtyBuoew=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB4198.namprd03.prod.outlook.com (2603:10b6:a03:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Mon, 27 Jul
 2020 11:06:31 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 11:06:31 +0000
Date:   Mon, 27 Jul 2020 19:02:13 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] net: stmmac: Move device_can_wakeup() check earlier in
 set_wol
Message-ID: <20200727190213.5dcb8ea0@xhacker.debian>
In-Reply-To: <20200727190045.36f247cc@xhacker.debian>
References: <20200727190045.36f247cc@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR01CA0012.jpnprd01.prod.outlook.com
 (2603:1096:404:a::24) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TY2PR01CA0012.jpnprd01.prod.outlook.com (2603:1096:404:a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 11:06:28 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8acab02a-1b9c-4475-9ab3-08d8321d1db9
X-MS-TrafficTypeDiagnostic: BYAPR03MB4198:
X-Microsoft-Antispam-PRVS: <BYAPR03MB419813DBD4FC97F15797A605ED720@BYAPR03MB4198.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pn+cEgVU1+9ghZOQxPC56TDOOGoSIRHPTWrGsW+trOc0t92AjhhDucCV/EllPbBeJydXGB+1D8nBNUuls/JxyjAKq6sA9IBmQNPOlSWB8t8dscP9yKPvZ+lsDz1L0iy6/GOlLmtWrcjloeSTknOWveqhPHI7IOTJ5fljd76r6qITjh630EwmFClfDe7U7qnBvNfEmIy478J2G7MbqgK6UUdR3MOq34gfdbxfWnKPDbwjDR5Z5q68OMrSz4RIDTDaZMNLcSHnm6mI0ASCJDBE7KbizpmRrZgw7Yfa0jtZCeTBK8b1JxowEHftz1TjStOqgkkTThUORxJCBdDa6QFu/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(66946007)(66476007)(66556008)(5660300002)(6506007)(55016002)(86362001)(52116002)(9686003)(8676002)(478600001)(110136005)(7696005)(316002)(1076003)(4326008)(16526019)(8936002)(26005)(956004)(83380400001)(2906002)(6666004)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L5qedW8rehtSRB/DaRRvfH0RIFJPZ9Z1X5y4/Qgug2uztUstzSW1waWGrjyGDK17HAf75CXbdsL/Sj4ImMscZW+3d9Nkbcs85BoK3wc4b8T/7la1rjuOI0EvKiUmjP2zY1C6k9QDAQijcVGJL8E6z5TWPaIwTPML++MDdOwyKc384ZAy2GPqR5ShYYkpXU3UfW0P8XSZzHHYiok6eqaqoPAjlOu+6GY1FCgyVn5S9ZSM/rM7/7UTUih8zlWVQ2O8iHvDu6l9YHn8idsrt7YAmOe54++COEgmP8+wUBpPDHUWAInL/r0/nSFVJtqKbr9TeBd4XHoVrGw9c4c/VvAp2CP/KmT0teuNyY/beAtP57/ByUhUPElF8JTA5ZUECYkjZ3rlSgQ3/uSUTFYf5AuRJCL+cGF51RYyrM14G/yD7pGDjFb0Mxg35oAlZKYNFe/ePwS1KImdEkrlSdngLDfvhYpaqTATGrQ8cGXJWP3GIlw=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acab02a-1b9c-4475-9ab3-08d8321d1db9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 11:06:31.0166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGqxeyv7kYV+6w7o6IDRii0OHB3IPjDzmrhDPeWumpkP6vCmpH0BPiSofKKxZpXFhYMPzP3+sIhr5GubL6131A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If !device_can_wakeup(), there's no need to futher check. And return
-EOPNOTSUPP rather than -EINVAL if !device_can_wakeup().

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 9e0af626a24a..79795bebd3a2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -615,15 +615,15 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 support = WAKE_MAGIC | WAKE_UCAST;
 
+	if (!device_can_wakeup(priv->device))
+		return -EOPNOTSUPP;
+
 	/* By default almost all GMAC devices support the WoL via
 	 * magic frame but we can disable it if the HW capability
 	 * register shows no support for pmt_magic_frame. */
 	if ((priv->hw_cap_support) && (!priv->dma_cap.pmt_magic_frame))
 		wol->wolopts &= ~WAKE_MAGIC;
 
-	if (!device_can_wakeup(priv->device))
-		return -EINVAL;
-
 	if (wol->wolopts & ~support)
 		return -EINVAL;
 
-- 
2.28.0.rc0

