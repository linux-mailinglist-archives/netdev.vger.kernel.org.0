Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9289641F8E
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiLDUdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLDUdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:33:45 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3FE1114B;
        Sun,  4 Dec 2022 12:33:44 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qk9so5612587ejc.3;
        Sun, 04 Dec 2022 12:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Grs/zW/Yy+MbYuU5nZpAnOLbGwu+GK+N8WBWWWD6HNA=;
        b=Q2tDROKUxutVdCFxgnmx/2gntq0AtTIYYyZXVjePpwBnV5rpa3gxG1fFW2570Z99Rd
         eSbr/4WI8hyd9X5WOQvuhRoZbs/Ypi5eYBB0dEO8KMeMKhdO3iDx1qmfrtEKvv93p3NL
         yd7FdWKG8CZZ0ZPlNNrnuDtqSXac6qVBWvNaeTDo+1kGyflbNirW8+sgW5l3BPSYiWxv
         1PV0Z6TWxixjeQHqEnn4Dc4xnq6vjuGU6F7AZt2StrHkKeOaVmtccKnLKytOwS0PYH/1
         zkNRg1f23ywb+Lpx5PAGxR+N5rKX1pWtida6q6JKW96iL4cN2EvQR2S9G5VhGQFgVhvM
         aJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Grs/zW/Yy+MbYuU5nZpAnOLbGwu+GK+N8WBWWWD6HNA=;
        b=l6uUyi7LUWdiK9eU+9VOD4RAfuYioa+5y2AbR1xVZFpMk0H4CqGhpB+xSYG6V2j/I9
         pLW6aFwJ8iJLeQco+OZ4mEK3xOkVP7xtEaCBRMkpm4bmSLqAS0Au9abldqz/cP44sd4v
         tMetjjDD5Wbwjvn9rkBHcpr04gFrF7dRlLDt+E8T1G511w9q1HLo3EZ7WrFVxXwu/p8B
         rQlVOiqDxFPu0XU9AFZjngyEFWYo5rRn/RTQS7HQyu0pOGI4WtK19NoQkitVImd1AWm3
         Gi4thJbHgOAx+xzs5ExOJKydh8ITVHDaq7LsgDkgJlL+Q1bXneAmTxw4UKLGONUnwaN/
         2Cog==
X-Gm-Message-State: ANoB5pmf4zEXcRk0hFwxbIG7bH/uH9mcq/anfORDjDAjlQvVbNmmu5sE
        yWmnUiPTgJEDpHTuEhUNYyo=
X-Google-Smtp-Source: AA0mqf7NdX5FJzVjrzn0F8B6sfQURLjP9m6l8fayKc0GWR7XeMLRw59JHWTzl4Qw7x4pSH07k96WxA==
X-Received: by 2002:a17:906:2854:b0:7ae:3684:84b0 with SMTP id s20-20020a170906285400b007ae368484b0mr58571379ejc.622.1670186023252;
        Sun, 04 Dec 2022 12:33:43 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906300700b007af105a87cbsm5399403ejz.152.2022.12.04.12.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:33:42 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:33:51 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y40ELzDwMjGy66gU@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
 <Y4zreLCwdx+fyuCe@lunn.ch>
 <Y4z+ZKZh4c14mFzA@gvm01>
 <Y40BkLMOhk8qR2IC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y40BkLMOhk8qR2IC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 08:22:40PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 04, 2022 at 09:09:08PM +0100, Piergiorgio Beruto wrote:
> > On Sun, Dec 04, 2022 at 07:48:24PM +0100, Andrew Lunn wrote:
> > > On Sun, Dec 04, 2022 at 05:06:50PM +0000, Russell King (Oracle) wrote:
> > > > On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> > > > > --- a/include/uapi/linux/mdio.h
> > > > > +++ b/include/uapi/linux/mdio.h
> > > > > @@ -26,6 +26,7 @@
> > > > >  #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
> > > > >  #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
> > > > >  #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
> > > > > +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
> > > > 
> > > > If this is in the vendor 2 register set, I doubt that this is a feature
> > > > described by IEEE 802.3, since they allocated the entirety of this MMD
> > > > over to manufacturers to do whatever they please with this space.
> > > > 
> > > > If this is correct, then these definitions have no place being in this
> > > > generic header file, since they are likely specific to the vendors PHY.
> > > 
> > > Piergiorgio can give you the full details.
> > > 
> > > As i understand it, IEEE 802.3 defines the basic functionality, but
> > > did not extend the standard to define the registers.
> > > 
> > > The Open Alliance member got together and added the missing parts, and
> > > published an Open Alliance document.
> > > 
> > > Piergiorgio, i suggest you add a header file for these defines, named
> > > to reflect that the Open Alliance defined them. And put in a comment,
> > > explaining their origin, maybe a link to the standard. I also don't
> > > think this needs to be a uapi header, they are not needed outside of
> > > the kernel.
> > > 
> > > I also would not use MDIO_MMD_OATC14, but rather MDIO_MMD_VEND2. There
> > > is no guarantee they are not being used for other things, and
> > > MDIO_MMD_VEND2 gives a gentle warning about this.
> > Thanks Andrew for commenting on this one. This is right, in the IEEE
> > 802.3cg group we could not allocate an MMD for the PLCA reconciliation
> > sublayer because of an 'unfriendly' wording in Clause 45 ruling out
> > Reconciliation Sublayers from what can be configured via registers.
> > Clause 45 says you can have registers for the PHY, while it should have
> > said 'Physical Layer" and there is a subtle difference between the two
> > words. PLCA, for example, is part of the Physical Layer but not of the
> > PHY. Since we could not change that wording, we had to define
> > configuration parameters in Clause 30, and let organizations outside the
> > IEEE define memory maps for PHYs that integrate PLCA.
> > 
> > The OPEN Alliance SIG (see the reference in the patches) defined
> > registers for the PLCA RS in MMD31, which is in fact vendor-specific
> > from an IEEE perspective, but part of it is now standardized in the OPEN
> > Alliance. So unfortunately we have to live with this somehow.
> > 
> > So ok, I can separate these definitions into a different non-UAPI header
> > as Andrew is suggesting. I'll do this in the next patchset.
> 
> Sounds like yet another clause 45 mess :(
I'm really sorry for this, I can assure you I personally pushed very
hard to get this through, but eventually we got an hard stop. The IEEE
has very strict formal rules too, and we were not allowed to change that
portion of the specs. To get permission we should have delayed the
standard by one year, and that would have upset many people from
different industries...

Thanks for your understanding.
Piergiorgio
