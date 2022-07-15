Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996ED57694D
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiGOWBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiGOWBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:02 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECCB8BA93;
        Fri, 15 Jul 2022 15:00:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYk9lu0CiPkLEm5KxqP6oEF/TLC+Pzq7rf2jZaciFTVOVHcCdcKOo5/23eB63JiWVNKXlr8zI5gRUCAkjUoyDfgKAO6Sm+xA8PDtnNko/XWMmpI/lR7RsfMak0U58GBoQwnVwUca+824AqNUS9Z2S+xX2/7jf2YI/fGBFdU+BQy/kfY/GgjF/Lkonobe/DW7XRhkt2bKMd2Unv9J7ilYvzHrir6a5a1y2TmnAlF+57VHNx8HTMK2xNRc1qy79wUISGJ+xl1+P+Ga+mDsoUGFydbdXreQarvGKi+rpQkHl2qZJd+Y8VlGvGzpvJsZsrQ9RF5vr2pau7fPRuiGAe3yug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgYV3xwT5XrKc75lJUSiXz3xK2FaCx3SvoKQdGIo2zs=;
 b=OJFW5urVvDrNeXj/P8l9E2WFtejMzbdPDyfjgrhn8jLvf9vDXF1xkOkThV4rWZXxDbA+UMA0f+F7WpKrdX7yyEwVT+s0tHqJqr5yUJaEITWc+vN/bsQIgioF0cWqTMifgJ54k/HBA44Pu7L01AewQ8AY58IZPuerLmLOncXZ7jmKo4FVQJKk4vEHwj+qvVgDKiQSh1owvzoG57g3vjW2eM9nM/q/1jJaQDPkCRW7D4yLfe/pS07DkQjTuznpZ8ihIEk3v314EYhcJcCLr664koeHtG+LneXrQAcdwtWNAfZ8mAk/HvVMRpWG6RYUz7XUoJlg/di1QhXR/h4ZKtTFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgYV3xwT5XrKc75lJUSiXz3xK2FaCx3SvoKQdGIo2zs=;
 b=hDrGJhGVvLm/pOczhqtpKzQ5cEERem3YDrQtFw2vqhlTS5Hf4Y6Eoregp7/XlZ84nsHKxeTNreB8XaZWeO5lLQCHIJoQ/d/K/G9ElyhzMuz0NarSsirlIvk0U61q1SDx9O7KjSCDDT8FaTShjZ/AgOqejn0OtwZIDmuBxfU1UVig99ldhdK/PHXKN8z8HQETbdnhnxPs8Vz8OoCzQt1iYWQ7ytFY87WsZKR8CDb41+Xzw6b5fZLw/u4mNXoM3LROa3av7C2hn9LqY1s+DJaLdF+Ok9Nfx1TFY9RBahaUXFgEnvdvzQhSKYxDlJQLrn27o01ltobS3HvTKseNMLAMMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBBPR03MB5302.eurprd03.prod.outlook.com (2603:10a6:10:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Fri, 15 Jul
 2022 22:00:28 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 07/47] net: phy: Add support for rate adaptation
Date:   Fri, 15 Jul 2022 17:59:14 -0400
Message-Id: <20220715215954.1449214-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5d582b-bd99-495f-0cbb-08da66ad6df2
X-MS-TrafficTypeDiagnostic: DBBPR03MB5302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4sm75Nf4Kgs66vFSN+kKIUqvMZCxwxQTJyMZAhMh7o5LicIKijViVvscvlW9jKBXbWk2KgFtqhBs6fIfLQImQ5R9KikdBJDmSXSb6ooIZhuKvHDcVTATx0WaoFuSLWfZNChYdgI4dF17rg6Rfwt9taxEUs8lxlHsESfL9vggtfVjBShT3XQVYmdQhTey3kvqCkLK5y3wZHW9CORoERKV0dwA0CYUBJfUCHb5iBAiloqEEwm92dkip/o9bO1/BxMwX5lY1wGPU7BToIvp6Ax4HDWxWJxGmbr3V6YKZoCDa/6+fKxKvdvBfdWU5EggcgyZCcVsk9JxyJ9rfk+LH/98uxw0DBF1xFWOhkB4kGang5SRRpfkWG0yAkX3yb3JyZW3tqrhtLCFFsNCRxppoOXmw4K+AedzcsNnZMiCVVC6SDjHxCaTdLsVZccAu9cByIFHQudq9qEVB+uZytFEDcl/eNL4c/IV54GJaNAAgaxo0/9EeIS96+9rJ4H3e8YHzRPARZ++QGl1/vhVnNklIA8Ht4Mq2cNghUyT8GqiBdEjXyfrUcPZlX737kktirgT1F+tgv1E1ol1pkZuvPfvBeARh/xldyZKsyBIauhKy00aeFLct8NQQPUjUSIeqYWVmyTgaaTUx1jNa4ZM2zCpvooyWBgebNAQDyvlVv4J3WvPktY9dsiBUHV8mq0XH8waxA0P8yO4k7DBRtFHE/YyeJkxkt5fjAft9jJHAw07MNALkeeYdUqJIjHOHPrF8EsaY6Nl2md8EKr37xPEhzX052DR44dapnKrNlaw9gH6zDMggsNwqNITwJmR/AvsUxtKNdm5qnbO3ReEwDCMF1pB3MfAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(136003)(39850400004)(346002)(478600001)(66556008)(41300700001)(66476007)(52116002)(966005)(6506007)(6486002)(6512007)(26005)(8676002)(6666004)(54906003)(86362001)(66946007)(316002)(8936002)(4326008)(83380400001)(38350700002)(2616005)(1076003)(186003)(7416002)(36756003)(110136005)(38100700002)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YvA4M4MiD2Mx8q2CT4B8ZUDmDgGpmZbW4fJ0pmPOnT6yC4iwIzUmp0IkMby2?=
 =?us-ascii?Q?xoXiHRn9pHaVuDK6xx0PJiWS4nLLildTK2M/R746L7YJFM82sJOYOUDCI/qR?=
 =?us-ascii?Q?5jwLuoPvg0+I09ra5H7IBtRRYFoosjpHB97oHUgFUmZYg/ssN2rMyccC3Rjq?=
 =?us-ascii?Q?iiMeodcT948Bg6qALiUP96A29Q8Ms19msjLpp7/K8sulB3OXyJgFMykG6JWy?=
 =?us-ascii?Q?HkvRbnIAT0G1q+nA5rOVi5UGtXDbFg1OyIP+tYWYxBXgKGcvTjqk8uhrhHD9?=
 =?us-ascii?Q?RJjfOqB+QRgjcgfw/aFrLaDGlmCjQI9+uQ3zW7q/6QF8B3IZpo0hFY7tOOnm?=
 =?us-ascii?Q?pjFMvibIEyeSBZFOSVcjfE0q5SPSKCgfybF9DReSQ55VC/r2DrntOsSRaLph?=
 =?us-ascii?Q?ogOMBBvN9oRakmLviEtdxRkmyvlVHLrpDSMSxriUuHsYG+uZgzNl0J3CKqbN?=
 =?us-ascii?Q?i7XpyadIvmlTSFmpQ2njjvQkUYbGrWhvJlX/Yvup9JBl+up+61xHbCleMGY1?=
 =?us-ascii?Q?nXyQ7B0yrbmybv5n+jXdL/gHuUJuIrMT2MPUGx+QfgjxFFCh8j4DQeq72KX2?=
 =?us-ascii?Q?0dNsRk5paQJe9qoAWONg0tNHbc416SM/Ifu9hoyUC7i5v/zMlrVk0H9zK/Dk?=
 =?us-ascii?Q?7zcs1BnDK+TtJpHyFI3j+aoEx1UnntZ3l6+91psB9NxTtg1T9llEqc3zBDNK?=
 =?us-ascii?Q?E74OCiD3PJ7ddOIqnbt9fS+5hFX6ZBdpPDHSVOiVlyHOoagveCKOjgXd9BNN?=
 =?us-ascii?Q?28aORzyPUnRci6JPhtSa0h/gmDOgHhBOTR/uGw6rY9AZbv9fPsPaxfzYrjuV?=
 =?us-ascii?Q?usFMU2yJHRpDS6Xj9nGuIip1wm6Qal+ziTbkJkPVzKDAHl2e2EbaxjHkA7ZB?=
 =?us-ascii?Q?PRCKnS7vs9V8mwfrH/mKwvuIfMPwWmdFOQCbTsysuyW7TP/1reRFQgi2UIkz?=
 =?us-ascii?Q?Z0eUKD53DRmTnsh8jSit7Wuq/prhVo5fq/aIURxkX1oGbWSgEYr3xR3p7ENO?=
 =?us-ascii?Q?F/bsGiYYqL0cP6KuCKf69H5JpSvIKbSuVkPmYkFD4fnP+xPs7a2HIw+Hei0O?=
 =?us-ascii?Q?Ls+cGzdHHNgCWy2Rk9PlaEwt6VgENVQIG5pkfgztnF3hG471J0eaIRfYkCU8?=
 =?us-ascii?Q?qFiEowZ+e+3pvzBPL865B46rMiHw6AEzttSPH9uB7ULXPaLzU4WgnRaQwPN+?=
 =?us-ascii?Q?31xt76ODdd11eWssX9x82AbLP36L/2ec1MnLQxIaWfHucxcwq9DteIWwPxFY?=
 =?us-ascii?Q?DVrgIe4eubyzcqidBYUueXZl9Q0gUYq4nRxnSqOt3YIhPP/bRto0avMevDEC?=
 =?us-ascii?Q?hU+J0F0osgdHrVPQTxRmSljy3somHjamoWXHxB0RMNZ2cG3jsS3RM5tUF6O8?=
 =?us-ascii?Q?odwactbiSKsWjoUaGNn82KNbrZUaS7vlRu9EVGA4wvv6RbbJobYXOEG/97PE?=
 =?us-ascii?Q?yhDL5uJpomhM6Lym83Hjky5A0IwLPfP2VjlLm90oZ6jL6NcR5MMebaf9D0aq?=
 =?us-ascii?Q?q/1AG0D1HJkMBkijyKqVmPv8K10EzACw18/oVA4tFjU5Z+obhBdg/BCuxnwB?=
 =?us-ascii?Q?ve23V339mvbdyDf0cd8YzBoRloq+01H9vxOe+PpLnFu7WDYDHBgCGUZtSVuR?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5d582b-bd99-495f-0cbb-08da66ad6df2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:28.7395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E44aMyyf6LBiUOWDhNWImNbNfrWQqL6FqmJYBxUboh9x1m6OqqxrXBsXsGmpF2yfbolVYgzksmrKaSyyl+zG3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5302
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds general support for rate adaptation to the phy subsystem. The
general idea is that the phy interface runs at one speed, and the MAC
throttles the rate at which it sends packets to the link speed. There's a
good overview of several techniques for achieving this at [1]. This patch
adds support for three: pause-frame based (such as in Aquantia phys),
CRS-based (such as in 10PASS-TS and 2BASE-TL), and open-loop-based (such as
in 10GBASE-W).

This patch makes a few assumptions and a few non assumptions about the
types of rate adaptation available. First, it assumes that different phys
may use different forms of rate adaptation. Second, it assumes that phys
can use rate adaptation for any of their supported link speeds (e.g. if a
phy supports 10BASE-T and XGMII, then it can adapt XGMII to 10BASE-T).
Third, it does not assume that all interface modes will use the same form
of rate adaptation. Fourth, it does not assume that all phy devices will
support rate adaptation (even some do). Relaxing or strengthening these
(non-)assumptions could result in a different API. For example, if all
interface modes were assumed to use the same form of rate adaptation, then
a bitmask of interface modes supportting rate adaptation would suffice.

We need support for rate adaptation for two reasons. First, the phy
consumer needs to know if the phy will perform rate adaptation in order to
program the correct advertising. An unaware consumer will only program
support for link modes at the phy interface mode's native speed. This will
cause autonegotiation to fail if the link partner only advertises support
for lower speed link modes.

Second, to reduce packet loss it may be desirable to throttle packet
throughput. In past discussions [2-4], this behavior has been
controversial. It is the opinion of several developers that it is the
responsibility of the system integrator or end user to set the link
settings appropriately for rate adaptation. In particular, it was argued
that it is difficult to determine whether a particular phy has rate
adaptation enabled, and it is simpler to keep such determinations out of
the kernel. Another criticism is that packet loss may happen anyway, such
as if a faster link is used with a switch or repeater that does not support
pause frames.

I believe that our current approach is limiting, especially when
considering that rate adaptation (in two forms) has made it into IEEE
standards. In general, When we have appropriate information we should set
sensible defaults. To consider use a contrasting example, we enable pause
frames by default for switches which autonegotiate for them. When it's the
phy itself generating these frames, we don't even have to autonegotiate to
know that we should enable pause frames.

Our current approach also encourages workarounds, such as commit
73a21fa817f0 ("dpaa_eth: support all modes with rate adapting PHYs").
These workarounds are fine for phylib drivers, but phylink drivers cannot
use this approach (since there is no direct access to the phy). Note that
even when we determine (e.g.) the pause settings based on whether rate
adaptation is enabled, they can still be overridden by userspace (using
ethtool). It might be prudent to allow disabling of rate adaptation
generally in ethtool as well.

[1] https://www.ieee802.org/3/efm/baseline/marris_1_0302.pdf
[2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
[3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
[4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 drivers/net/phy/phy.c | 21 +++++++++++++++++++++
 include/linux/phy.h   | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8d3ee3a6495b..cf4a8b055a42 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -114,6 +114,27 @@ void phy_print_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_print_status);
 
+/**
+ * phy_get_rate_adaptation - determine if rate adaptation is supported
+ * @phydev: The phy device to return rate adaptation for
+ * @iface: The interface mode to use
+ *
+ * This determines the type of rate adaptation (if any) that @phy supports
+ * using @iface. @iface may be %PHY_INTERFACE_MODE_NA to determine if any
+ * interface supports rate adaptation.
+ *
+ * Return: The type of rate adaptation @phy supports for @iface, or
+ *         %RATE_ADAPT_NONE.
+ */
+enum rate_adaptation phy_get_rate_adaptation(struct phy_device *phydev,
+					     phy_interface_t iface)
+{
+	if (phydev->drv->get_rate_adaptation)
+		return phydev->drv->get_rate_adaptation(phydev, iface);
+	return RATE_ADAPT_NONE;
+}
+EXPORT_SYMBOL_GPL(phy_get_rate_adaptation);
+
 /**
  * phy_config_interrupt - configure the PHY device for the requested interrupts
  * @phydev: the phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 81ce76c3e799..e983711f6c8b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -276,6 +276,24 @@ static inline const char *phy_modes(phy_interface_t interface)
 	}
 }
 
+/**
+ * enum rate_adaptation - methods of rate adaptation
+ * @RATE_ADAPT_NONE: No rate adaptation performed.
+ * @RATE_ADAPT_PAUSE: The phy sends pause frames to throttle the MAC.
+ * @RATE_ADAPT_CRS: The phy asserts CRS to prevent the MAC from transmitting.
+ * @RATE_ADAPT_OPEN_LOOP: The MAC is programmed with a sufficiently-large IPG.
+ *
+ * These are used to throttle the rate of data on the phy interface when the
+ * native speed of the interface is higher than the link speed. These should
+ * not be used for phy interfaces which natively support multiple speeds (e.g.
+ * MII or SGMII).
+ */
+enum rate_adaptation {
+	RATE_ADAPT_NONE = 0,
+	RATE_ADAPT_PAUSE,
+	RATE_ADAPT_CRS,
+	RATE_ADAPT_OPEN_LOOP,
+};
 
 #define PHY_INIT_TIMEOUT	100000
 #define PHY_FORCE_TIMEOUT	10
@@ -570,6 +588,7 @@ struct macsec_ops;
  * @lp_advertising: Current link partner advertised linkmodes
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
+ * @rate_adaptation: Current rate adaptation mode
  * @link: Current link state
  * @autoneg_complete: Flag auto negotiation of the link has completed
  * @mdix: Current crossover
@@ -637,6 +656,8 @@ struct phy_device {
 	unsigned irq_suspended:1;
 	unsigned irq_rerun:1;
 
+	enum rate_adaptation rate_adaptation;
+
 	enum phy_state state;
 
 	u32 dev_flags;
@@ -801,6 +822,21 @@ struct phy_driver {
 	 */
 	int (*get_features)(struct phy_device *phydev);
 
+	/**
+	 * @get_rate_adaptation: Get the supported type of rate adaptation for a
+	 * particular phy interface. This is used by phy consumers to determine
+	 * whether to advertise lower-speed modes for that interface. It is
+	 * assumed that if a rate adaptation mode is supported on an interface,
+	 * then that interface's rate can be adapted to all slower link speeds
+	 * supported by the phy. If iface is %PHY_INTERFACE_MODE_NA, and the phy
+	 * supports any kind of rate adaptation for any interface, then it must
+	 * return that rate adaptation mode (preferring %RATE_ADAPT_PAUSE, to
+	 * %RATE_ADAPT_CRS). If the interface is not supported, this should
+	 * return %RATE_ADAPT_NONE.
+	 */
+	enum rate_adaptation (*get_rate_adaptation)(struct phy_device *phydev,
+						    phy_interface_t iface);
+
 	/* PHY Power Management */
 	/** @suspend: Suspend the hardware, saving state if needed */
 	int (*suspend)(struct phy_device *phydev);
@@ -1681,6 +1717,8 @@ int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
+enum rate_adaptation phy_get_rate_adaptation(struct phy_device *phydev,
+					     phy_interface_t iface);
 void phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
-- 
2.35.1.1320.gc452695387.dirty

