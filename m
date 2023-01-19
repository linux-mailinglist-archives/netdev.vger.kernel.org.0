Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4871673FEA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjASR2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjASR2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:28:05 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303157E49F;
        Thu, 19 Jan 2023 09:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/TC2gX/fzStJHSN7YiyNP/S4tX0zA7SmlVtg4UGYV9k=; b=ol
        xEZzdbsGI6r7ncKjKjT/hJR5lAQz2z+pzFd0cwEAxGJzpepyIR5QoJ/lNLEz/js+Jd6S7gHBx8K0T
        7/MJppdyj4KsZ5wUGU/g7py4M0ylnAq9WUynxYdSUqnSMCUQrkBoQW0jtQgxPt2nrGDF2blshTiCi
        x6mqbdxaSphOEeQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pIYhc-002c87-Gc; Thu, 19 Jan 2023 18:27:52 +0100
Date:   Thu, 19 Jan 2023 18:27:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh.Sankaranarayanan@microchip.com
Cc:     olteanv@gmail.com, davem@davemloft.net, pabeni@redhat.com,
        hkallweit1@gmail.com, Arun.Ramadoss@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Message-ID: <Y8l9mMpiFSHTt1iU@lunn.ch>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116222602.oswnt4ecoucpb2km@skbuf>
 <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d72bc330d0ce9e57cc862bec39388b7def8782a.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:34:00AM +0000, Rakesh.Sankaranarayanan@microchip.com wrote:
> Hi Vladimir,
> Thanks for the comments.
> 
> > 1. Don't prefix a patch with "net: dsa: microchip: " unless it
> > touches
> >    the drivers/net/dsa/microchip/ folder.
> > 
> > 2. Don't make unrelated patches on different drivers part of the same
> >    patch set.
> > 
> I will update the patch in next revision.
> 
> > 3. AFAIU, this is the second fixup of a feature which never worked
> > well
> >    (changing master/slave setting through ethtool). Not sure exactly
> >    what are the rules, but at some point, maintainers might say
> >    "hey, let go, this never worked, just send your fixes to net-
> > next".
> >    I mean: (1) fixes of fixes of smth that never worked can't be sent
> > ad
> >    infinitum, especially if not small and (2) there needs to be some
> >    incentive to submit code that actually works and was tested,
> > rather
> >    than a placeholder which can be fixed up later, right? In this
> > case,
> >    I'm not sure, this seems borderline net-next. Let's see what the
> > PHY
> >    library maintainers think.
> > 
> 
> Thanks for pointing this out. Do you think submitting this patch in
> net-next is the right way?

I would probably go for net-next. That will give it more soak time to
find the next way it is broken....

You might find i gets back ported to stable anyway, due to the ML bot
spotting it.

	 Andrew
