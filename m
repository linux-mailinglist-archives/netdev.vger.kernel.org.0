Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3DA6AA4BC
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 23:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjCCWpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 17:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjCCWpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 17:45:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D5A272;
        Fri,  3 Mar 2023 14:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1179B819DC;
        Fri,  3 Mar 2023 21:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589BDC433EF;
        Fri,  3 Mar 2023 21:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880639;
        bh=XKPieicA8mxBgDHfafnbiUGOdRZZfzDp6nuSYj8/TMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuw5J8gjl41jr3mJnjjeTHOf1wXLwDIe/tZButxgwNzM8tFPfkvKtsALhVyVpuZKr
         glridIdCQFjEt3otGwoxDtSpdkF6oCcp0cVHTN6W4z2KhwPT+wJLH/49bwm7r2N8dH
         vb+xF+EIqYM7q1ctW5Y6K6luz+UM7GZWXdyxL2aXegPF99VjzZwUjrxHcnnLwBCEoD
         D4WHJtmPowDlzs4J/oMYs2u72QEHX4zOFnp8Oy8XlGF9FDnfzprPxEH1JGjlJ1AepY
         pgKjzzpDCMTvARReHXB49XgkQ9aUuOhIjl/VAFa0L5+aToGC/4nER7Y+VrfVXENwkO
         jZHL0VwKjfgDA==
Date:   Fri, 3 Mar 2023 21:57:11 +0000
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC v1 net-next 2/7] mfd: ocelot: add ocelot-serdes capability
Message-ID: <20230303215711.GR2420672@google.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
 <20230216075321.2898003-3-colin.foster@in-advantage.com>
 <20230303104807.GW2303077@google.com>
 <ZAIOddFw//0VDoyw@MSI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZAIOddFw//0VDoyw@MSI.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Mar 2023, Colin Foster wrote:

> On Fri, Mar 03, 2023 at 10:48:07AM +0000, Lee Jones wrote:
> > On Wed, 15 Feb 2023, Colin Foster wrote:
> > 
> > > Add support for the Ocelot SERDES module to support functionality of all
> > > non-internal phy ports.
> > 
> > Looks non-controversial.
> > 
> > Please provide some explanation of what SERDES means / is.
> 
> Will do.
> 
> >  
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/mfd/ocelot-core.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > 
> > I'd expect this to go in via MFD once it comes out of RFC.
> 
> Understood. I'll be sure to make it clear that some sync will be needed
> between MFD and net-next in the cover letter this time.

To be honest, I don't think that's required this time.

This patch looks orthogonal, unless there's something I'm missing.
 
> Thanks Lee!

NP

-- 
Lee Jones [李琼斯]
