Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63B4EB7C5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbiC3B1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241538AbiC3B1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:27:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FD86D959;
        Tue, 29 Mar 2022 18:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=tZYc2x+vv8rKofC+QZs5Dm01z5/Tl7zBxIhKCL4u4TU=; b=CV
        ABkgUtdotMjW50TIHz8n+sZ9YE+bXF+p/oXlByB3JLHbRiQ9v7OEwFrmu5nXjG0qiBY0wUEDpMwFD
        I4RR9mVEROAlM75TDJkfwehqteSlHgn1EWvc5Giwi/KVsztyLdCyDD8BYG5QFQemurK1GbfejHX5C
        WXuPrt2hJaVVTgs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZN5H-00DFKb-ID; Wed, 30 Mar 2022 03:25:15 +0200
Date:   Wed, 30 Mar 2022 03:25:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Chiu <andy.chiu@sifive.com>, radhey.shyam.pandey@xilinx.com,
        robert.hancock@calian.com, michal.simek@xilinx.com,
        davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH v7 net 4/4] net: axiemac: use a phandle to reference
 pcs_phy
Message-ID: <YkOxexKUQqmFVe9l@lunn.ch>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
 <20220329024921.2739338-5-andy.chiu@sifive.com>
 <20220329155609.674caa9c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220329155609.674caa9c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 03:56:09PM -0700, Jakub Kicinski wrote:
> On Tue, 29 Mar 2022 10:49:21 +0800 Andy Chiu wrote:
> > In some SGMII use cases where both a fixed link external PHY and the
> > internal PCS/PMA PHY need to be configured, we should explicitly use a
> > phandle "pcs-phy" to get the reference to the PCS/PMA PHY. Otherwise, the
> > driver would use "phy-handle" in the DT as the reference to both the
> > external and the internal PCS/PMA PHY.
> > 
> > In other cases where the core is connected to a SFP cage, we could still
> > point phy-handle to the intenal PCS/PMA PHY, and let the driver connect
> > to the SFP module, if exist, via phylink.
> > 
> > Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> > Reviewed-by: Robert Hancock <robert.hancock@calian.com>
> 
> I'm not sure if this is a fix or adding support for a new configuration.
> Andrew, WDYT?

I guess it fails this stable rule:

It must fix a problem that causes a build error (but not for things
marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
security issue, or some “oh, that’s not good” issue. In short,
something critical.

So this probably should be for net-next.

   Andrew
