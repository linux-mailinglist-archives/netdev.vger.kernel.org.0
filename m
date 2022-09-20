Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F1C5BEFE0
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiITWNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiITWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:03 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84F67823F;
        Tue, 20 Sep 2022 15:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZOdRn0hITOkoX9+x/IfwHJzolaCSKt0w/71TpMme3y6ALNVmZe6ob1jayBgkQLxh0UYHXeTb5GOS5f+Ilu1/gEKBduKSL07/XMDGkJzXjOGAteAD15vk5tOn+/izQbYJFhd6+Ig8RuuwxWSlXpwYzUovnNiktjflmCIQWmam7jrAN3TlgeM/hDZVGKwCi2wPxHL3l96PbA9NL32POyK24c1STr4gD99XC8LvA1dlAu7qfFMd6VZ9x3eEB8uXZCulCOjABKJI8/FVWNNw0Jlw5v60noRmdfvRMfBM8v71n1uSQz3qis05jqbvxZTo3u5UimJhuRTlJS1+60bm6nDNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9p9/gcvaRGgI23Z9aVU4mf9+CgF+4Fo3AzUvtoGWAgg=;
 b=T7WBjizQ+DArrjwcybOgVMyXbQwLnQ7C9F6wPIDTyj5ZhyX/LLaiXiHy7oCD6aQLXJQ5p69phQiKpoANKp8NM2rfjfINJLtf9C2KwTW04cQXBby3DcYNPkWvGwrqjUZFzO1EnLrPig8TKP5u13fOjqPDbKDagJUMzIsL3eOf+EZQeL8C8P+J0ZLxPkzfuMOtLTSwTC/0KLcEDjRTqjNJObxQ/XBgi/q3f7hZ29ejD90gO/+8ntWd77mvADDjtparqcDuxikEOgkVGejhBUp2wrTAL9/JjskkoWDi9r4IiQ4U/WbYXn12kidoyyNrC3nGPrFOxfa/LaQbGl0nS8rnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9p9/gcvaRGgI23Z9aVU4mf9+CgF+4Fo3AzUvtoGWAgg=;
 b=gOa2+CcLlZKEcCRQ/81mrlPmSa/XyJgBcZtb70Gg8zVGDxbYLMC98RgMITfu5lLXzn12wf29goEUP+BbMsB5gX874RA3BpXzICtbrXjW0jbSOnthBtHWDn6JtZIdI0EU0Gt3OlJNe2BO2nBW+FSiuQvLWIaJaZOtSSQ0JoyN84+ruW8V0l5Jta7AcN6FCMMgjoDTVICxiQFz8/E9dAKzgEfBd74YxWZMJxTa7EKyRYFWvxFrmjurqZD9wuxrAz1BR6XB8E63t0oVl+5ZgzVHoYaPTeA1iEOOZfiAliec7ZAkO1Gpg7Nd1fSR/8VsYToLIhZkNC/jyfpAXwQsn8fxFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v6 3/8] net: phylink: Generate caps and convert to linkmodes separately
Date:   Tue, 20 Sep 2022 18:12:30 -0400
Message-Id: <20220920221235.1487501-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a32aca2-7369-436f-0b38-08da9b5541e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZw+/sXnVl9IGVoFEs9QGKVKZ1jjrzBMHdhZ4NtYTBIJBo2HcHcRhLIXrrPZnsf8qg9DKspf+kyxgHqPn7f5V29S+M7/riPQr30ZFqPvgP1A2YBPHwjstC+N/C81zTEKamvYlQjfrRvhM97ennQWPWm2XPJF+xGPFQMihCgXMc41/VBwAgFQgz1O7N6xRquJF0fBXcZa3iQoh3QSKSDvl1qLKr2YZPRxCa+jjUX7/s5Aa1fq04euKB6AJep1s1CQHkDg/+FRo4kROqytYIOLgqXzA/ddpBA53QABNZVWLjzzm21h1tCcKJRstKdJZOKD2Jr5jB+Hxt8fQwa5Wqdg1/sKEkMqsgTO3BIT1HwGENj0rOCCh5qX+d9uTNVfwwSYSkjesW95BW9krPzSpvQL1t6VfPzIvogPvSi7RqljBFMSnDI48bVFlVAlFDQMQCgo7hdEelz6fMb/miUSDN9xxSoNTMLXuLhnTxHlf+WEIVocEBIYIfWPSiXCNSVkuImpNu4oFC/0T5K4f4K5X6iDiPelcsbtyRkwoXfl9P56GUDmKw1SOV9w6wFNcTYSQPHHoXfDwpS2Zmx7+/3g2QlgZqB8o0RvxdkpTpbsvMlZ8G/ePqnQX2ja5U4P000hi2w97jcr1QIYdUVgQds1EuIEwGZ1cEtEbhMEuQTbsEpA7XpGtonhN2Y8y6+8Qr4Cq31x5S5ZtINUKVeDsSO99a/8LkfJDOcDow/ROTco0hqMjO988jTbLUWwfpIxDmKmbHenVxHLpALx3kAvZQJyLPrlJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(107886003)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFBKb/emaltYRuris5D+fRfz2P7nmZ+cvceXudVtR+EC5hZij01bzkYkh4xk?=
 =?us-ascii?Q?LdpZe/hVIonUEh+RGy2i4sTGkAZhEoZtEVGbZaVv1LStCz1BbxBRcPV2HVGP?=
 =?us-ascii?Q?ws4h+Jk9dYzxu3g2BfNl08j/DG+DCwpY4Nm2Qiq1SPTIRpBnbyCsoVUwIu2i?=
 =?us-ascii?Q?8V4EkZjXySqeXmAOHVxId6dh9QkAF6vRHLQYRqB4gsO9JOX6HKCeWgUCJ9oQ?=
 =?us-ascii?Q?KCWIK0Tm1Dl4sgWLtwGQor6C5TP/yZiJfEByWQDbSJjKz8XmxHZmDgVwF51Z?=
 =?us-ascii?Q?q9X6ZuOgnkps++SDAxbaZilzLFAD1WSzZQ9MHfU+sE7jLbYjd/1u+ekEm44W?=
 =?us-ascii?Q?Rhlv7JUr2VFiez/BC3erAcVuFsUGr+4IQM4FDv+ow984Aj1B6ahTMofOEGia?=
 =?us-ascii?Q?bgn5icaxCvFtiw7pe2qYGEpMGWe6ZKMaX10oGGZGmdNLJzYSp0PL0IBpciiB?=
 =?us-ascii?Q?nZkZAkQ3su7LL9UKrj/StamoTCQMyGLTYIMw5KOqtZ3FmZOzqFSMsdPz9xvd?=
 =?us-ascii?Q?LF9c43iAH0GOlqBasi3zZJ7q+6uUepZImzjM2XG00rZu3aHD/vTe5hjyb+iG?=
 =?us-ascii?Q?q/i0UnRSCM3S/nmLODv8257UjX9HkUd9VNZC998LpVY3mPzgGuzhAWJfcezm?=
 =?us-ascii?Q?WYfwLgnu5B5fk2FL8loxDOoN58E/zdCSpSC0y4K4UJTuTFtkUQrUpB5/wRwp?=
 =?us-ascii?Q?I2m1x+YOOzmaHMXtLnkrsYTgwM1ivchVzMMGRvKXdqVClS9Lsl8RNNlsjFCN?=
 =?us-ascii?Q?jRfxiWxuwiGM/IZ/5YsU9LLKw9+sypePwHjARcZU8zBloRgV1zgjq46QagjX?=
 =?us-ascii?Q?1Rro46Nwi46tm3SQHQ/v5D3vRxedl0bi0Dli1A95zC/zTyZfl+C6+2UHNcWs?=
 =?us-ascii?Q?bgMC2bviuZ4uJSIKYGlT2DtRQnRawoxfyNCXJExXQJ9f4B2BMc9VYKI3I1hz?=
 =?us-ascii?Q?FidSk9VKT1K4e67pjI98VmGHSfN0BqNKbtBxTmRb0e8YKzQJNC8sngrcOQOY?=
 =?us-ascii?Q?piE49kePcpNwgLL7VaMTnbhEKtWBXtx6hmPTdcGzRLrWdt1pgKukT8RxsSV4?=
 =?us-ascii?Q?Vt8IT6O9MPKUr246SRrB7YmIeGxpDgxmlzishnH9aGwi4FLaPe/oth1PllQl?=
 =?us-ascii?Q?hR2dJ1H1BWUtz66RTOnE41VhFddgOvms7XzyoYcl9Lqfbct1EeAZJ/220TtO?=
 =?us-ascii?Q?bDA5X3ycLkIJDXggYpDMRILMHioltCLVTyQs/no2SwGRa1OGtNMghPIjkeUt?=
 =?us-ascii?Q?JC+ueXSxSxJMf6HW3e6kMnyDyqnFQ1gO08maOmSCB7cqCfWiaWRhWESOmIgk?=
 =?us-ascii?Q?V1J0zDdYpL20byefKVcvowqGj2qYo2uyQ7Es8un/ZP5lUGsFBYjtCCSNgquV?=
 =?us-ascii?Q?H0g5HHfZZzekf0Fy39hTSeFCZ0JEaFK0X2gcA7PTHE7IGr2ylPF4acR3xrqa?=
 =?us-ascii?Q?2KaOzWr++gEeHqASP9GaMPEqIVf9AlRXoh3av4GBpdODrjaoADA9b4ezM3c0?=
 =?us-ascii?Q?d83G6g75SE5EYQ0oY/tjDut+FAa1tgWQ4/0XB0eQVq7K/2AzQlKojd6WJXLe?=
 =?us-ascii?Q?Z9fhwek2UqsVM9+mpMB9MH4skZalh7BTNhpB+QAL3fqgNLg8EdxHR2GJtjKD?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a32aca2-7369-436f-0b38-08da9b5541e3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:50.7364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oi3ikSKNBKqABeCYDGGIOFnV2Z+UJeeeJ3fel+H2ed5zuPCxuJn27FOxDn0MTKzXZjhLbwLwDMHOvtGjZhhg4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we call phylink_caps_to_linkmodes directly from
phylink_get_linkmodes, it is difficult to re-use this functionality in
MAC drivers. This is because MAC drivers must then work with an ethtool
linkmode bitmap, instead of with mac capabilities. Instead, let the
caller of phylink_get_linkmodes do the conversion. To reflect this
change, rename the function to phylink_get_capabilities.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v6:
- Merry Christmas

 drivers/net/phy/phylink.c | 21 +++++++++++----------
 include/linux/phylink.h   |  4 ++--
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c5c3f0b62d7f..7f0c49c2b09d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -305,17 +305,15 @@ void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps)
 EXPORT_SYMBOL_GPL(phylink_caps_to_linkmodes);
 
 /**
- * phylink_get_linkmodes() - get acceptable link modes
- * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * phylink_get_capabilities() - get capabilities for a given MAC
  * @interface: phy interface mode defined by &typedef phy_interface_t
  * @mac_capabilities: bitmask of MAC capabilities
  *
- * Set all possible pause, speed and duplex linkmodes in @linkmodes that
- * are supported by the @interface mode and @mac_capabilities. @linkmodes
- * must have been initialised previously.
+ * Get the MAC capabilities that are supported by the @interface mode and
+ * @mac_capabilities.
  */
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities)
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities)
 {
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
@@ -391,9 +389,9 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
-	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
+	return caps & mac_capabilities;
 }
-EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
+EXPORT_SYMBOL_GPL(phylink_get_capabilities);
 
 /**
  * phylink_generic_validate() - generic validate() callback implementation
@@ -410,10 +408,13 @@ void phylink_generic_validate(struct phylink_config *config,
 			      struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	unsigned long caps;
 
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
-	phylink_get_linkmodes(mask, state->interface, config->mac_capabilities);
+	caps = phylink_get_capabilities(state->interface,
+					config->mac_capabilities);
+	phylink_caps_to_linkmodes(mask, caps);
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 7cf26d7a522d..cc039ae7e80c 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -548,8 +548,8 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 #endif
 
 void phylink_caps_to_linkmodes(unsigned long *linkmodes, unsigned long caps);
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities);
+unsigned long phylink_get_capabilities(phy_interface_t interface,
+				       unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
-- 
2.35.1.1320.gc452695387.dirty

