Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27CE1CDCC4
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgEKONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730158AbgEKONY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 10:13:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2BBC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 07:13:23 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jY9BC-0003lJ-88; Mon, 11 May 2020 16:13:14 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jY9B8-0001LY-Ts; Mon, 11 May 2020 16:13:10 +0200
Date:   Mon, 11 May 2020 16:13:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: signal quality and cable diagnostic
Message-ID: <20200511141310.GA2543@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:31:16 up 243 days,  2:19, 514 users,  load average: 0.45, 0.37,
 0.66
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

First of all, great work! As your cable diagnostic patches are in
net-next now and can be used as base for the follow-up discussion.

Do you already have ethtool patches somewhere? :=) Can you please give a
link for testing?

I continue to work on TJA11xx PHY and need to export some additional
cable diagnostic/link stability information: Signal Quality Index (SQI).
The PHY data sheet describes it as following [1]:
================================================================================
  6.10.3   Link stability

The signal-to-noise ratio is the parameter used to estimate link
stability. The PMA Receive function monitors the signal-to-noise ratio
continuously. Once the signal-to-noise ratio falls below a configurable
threshold (SQI_FAILLIMIT), the link status is set to FAIL and
communication is interrupted. The TJA1100 allows for adjusting the
sensitivity of the PMA Receive function by configuring this threshold.
The microcontroller can always check the current value of the
signal-to-noise ratio via the SMI, allowing it to track a possible
degradation in link stability.
================================================================================

Since this functionality is present at least on TJA11xx PHYs and
mandatory according to Open Alliance[2], I hope this functionality is
present on other 100/1000Base-T1 PHYs. So may be some common abstraction
is possible. What would be the best place to provide it for the user
space? According to the [2] SQI, is the part of Dynamic Channel Quality
(DCQ) together with Mean Square Error (MSE) and Peak MSE value (pMSE).

[1] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
[2] http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
    http://www.opensig.org/download/document/225/Open_Alliance_100BASE-T1_PMA_Test_Suite_v1.0-dec.pdf

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
