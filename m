Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907D552714
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 00:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245747AbiFTWpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 18:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344365AbiFTWpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 18:45:40 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC06D1EC50
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 15:45:24 -0700 (PDT)
Received: (qmail 18080 invoked by uid 89); 20 Jun 2022 22:45:19 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 20 Jun 2022 22:45:19 -0000
Date:   Mon, 20 Jun 2022 15:45:17 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v8 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220620224517.wv2qecwxjkqfvayd@bsd-mbp.dhcp.thefacebook.com>
References: <20220616195218.217408-3-jonathan.lemon@gmail.com>
 <202206181756.RQjX7jiS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202206181756.RQjX7jiS-lkp@intel.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 18, 2022 at 05:48:46PM +0800, kernel test robot wrote:
> Hi Jonathan,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]

Upcoming fix:

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 2f299ef26a27..4bb231013009 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -105,6 +105,7 @@ config BROADCOM_PHY
        tristate "Broadcom 54XX PHYs"
        select BCM_NET_PHYLIB
        select BCM_NET_PHYPTP if NETWORK_PHY_TIMESTAMPING
+       depends on PTP_1588_CLOCK_OPTIONAL
        help
          Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
          BCM5481, BCM54810 and BCM5482 PHYs.
@@ -163,7 +164,6 @@ config BCM_NET_PHYLIB

 config BCM_NET_PHYPTP
        tristate
-       depends on PTP_1588_CLOCK_OPTIONAL

 config CICADA_PHY
        tristate "Cicada PHYs"


Since apparently rules under "select" are not transitive.

Florian - before I repost this, any other changes to patch #3?
--
Jonathan
