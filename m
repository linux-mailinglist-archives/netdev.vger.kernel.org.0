Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61415A18FE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242168AbiHYSsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbiHYSr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:47:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3A875FED
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:47:57 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRHt8-00034B-3Y; Thu, 25 Aug 2022 20:47:34 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRHt2-00079v-SE; Thu, 25 Aug 2022 20:47:28 +0200
Date:   Thu, 25 Aug 2022 20:47:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        kernel test robot <lkp@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        David Jander <david@protonic.nl>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 6/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220825184728.GA2116@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-7-o.rempel@pengutronix.de>
 <20220825111019.1dc3dae0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220825111019.1dc3dae0@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:10:19AM -0700, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 15:02:10 +0200 Oleksij Rempel wrote:
> > +enum ethtool_podl_pse_admin_state {
> > +	ETHTOOL_PODL_PSE_ADMIN_STATE_UNKNOWN = 1,
> 
> Why define UNKNOWN.. as 1? No real objection here, just in my head
> somehow UNKNOWN = 0 or just start from 1.

I need to keep difference between not supported functionality and
supported but unknown.

> > +	ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED,
> > +	ETHTOOL_PODL_PSE_ADMIN_STATE_ENABLED,
> > +
> > +	/* add new constants above here */
> > +	ETHTOOL_PODL_PSE_ADMIN_STATE_COUNT
> 
> Why define count for a value enum like this? For attrs we define it
> because it's used to size tables, don't think anyone will size tables
> based on states.

ok, i'll remove it.

> There's a bunch of kdoc warnings in the patches as well.

ok.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
