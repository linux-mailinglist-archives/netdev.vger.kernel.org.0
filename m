Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67DD641F65
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 21:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiLDUJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 15:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLDUJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 15:09:03 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8A5FAE0;
        Sun,  4 Dec 2022 12:09:02 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ud5so23269219ejc.4;
        Sun, 04 Dec 2022 12:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vkl5Py1oRMWrCzqnFnPy3sf0zNxYTULfKlMFBdBWZN0=;
        b=FOu/gaqweHGuxVi5iHwCoYTw7jKFehqERkZ63OWsEkaSNSO0BdTGuicXRG7XwE21wE
         FzM1BG2EcR3BpyE2fhnbT4laDj/hUmH6FE+z9mdBa29i/yKKIGwERDasuivaCiu7UPIc
         UPqzGxZwXreJJoYInkg/4OmQy24G8I334Pj+eaJZSOVBZoioS8CDh6OYqCSRLbe65kHB
         TKUGaBJSiaw+SfAIRq4CBHB9pW22I/xPYUfM54ooi9gN7rjeiZ4NOkiNIMLG8VeA/JTJ
         na15udw6DCKh3NopTh4U35zXB2LVb2hbUiiqRlDl+p884PLCXEHKfTTLqwqNtljVKHxN
         NQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkl5Py1oRMWrCzqnFnPy3sf0zNxYTULfKlMFBdBWZN0=;
        b=MKUsE7FjqkiE9ijwhERRMWWrbatyW0M2eJC1olzkEL8HXu2oz6ADoFGJjPAjZdi0fl
         iJlFPDUhRS9jPXK0KXVn/4ec4NpkcduFwB3ScjlkfkEDCDohFvuAcNTIWErgJ/eStR1Y
         AOLXpJhj3wxeRHK4dSuS567BK8ShqbrI/ncERmIkZ1cmg9/09ccOz/0MnX6TRxorqCTr
         Kpd7duNuEJugyM8P4hb2Hc+2Fx/Ujo4qe8hQJ6fWla19/MHqZ/9Pb1a6Y8OL8hpATuqI
         LpJ8qBb2zOxfGSwX57mxcff0C7FmGj+Kq52mcs2ru6raFmh3vfQU3wXhs93Z2g/mMspq
         pl7A==
X-Gm-Message-State: ANoB5pnzuvPwtMGW+SDz71QYUKw3pd+wqeCBFTURyClKEWEOS1NK7yXO
        NoJblTR7HCxyqhO8797XBrg=
X-Google-Smtp-Source: AA0mqf4ayGHfiKG73nBHu4lzx2sIQoUcFUc53AllO/028DHefNdZjyh7K8buw9AULOYYqAx0y1U2tA==
X-Received: by 2002:a17:906:38cd:b0:7be:4d3c:1a44 with SMTP id r13-20020a17090638cd00b007be4d3c1a44mr32659821ejd.543.1670184540686;
        Sun, 04 Dec 2022 12:09:00 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709060a4a00b00741a251d9e8sm5485906ejf.171.2022.12.04.12.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 12:09:00 -0800 (PST)
Date:   Sun, 4 Dec 2022 21:09:08 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 4/4] driver/ncn26000: add PLCA support
Message-ID: <Y4z+ZKZh4c14mFzA@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <38623984f6235a1521e6b0ad2ea958abc84ad708.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zTqvSxLJG+G8V+@shell.armlinux.org.uk>
 <Y4zreLCwdx+fyuCe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zreLCwdx+fyuCe@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 07:48:24PM +0100, Andrew Lunn wrote:
> On Sun, Dec 04, 2022 at 05:06:50PM +0000, Russell King (Oracle) wrote:
> > On Sun, Dec 04, 2022 at 03:32:06AM +0100, Piergiorgio Beruto wrote:
> > > --- a/include/uapi/linux/mdio.h
> > > +++ b/include/uapi/linux/mdio.h
> > > @@ -26,6 +26,7 @@
> > >  #define MDIO_MMD_C22EXT		29	/* Clause 22 extension */
> > >  #define MDIO_MMD_VEND1		30	/* Vendor specific 1 */
> > >  #define MDIO_MMD_VEND2		31	/* Vendor specific 2 */
> > > +#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
> > 
> > If this is in the vendor 2 register set, I doubt that this is a feature
> > described by IEEE 802.3, since they allocated the entirety of this MMD
> > over to manufacturers to do whatever they please with this space.
> > 
> > If this is correct, then these definitions have no place being in this
> > generic header file, since they are likely specific to the vendors PHY.
> 
> Piergiorgio can give you the full details.
> 
> As i understand it, IEEE 802.3 defines the basic functionality, but
> did not extend the standard to define the registers.
> 
> The Open Alliance member got together and added the missing parts, and
> published an Open Alliance document.
> 
> Piergiorgio, i suggest you add a header file for these defines, named
> to reflect that the Open Alliance defined them. And put in a comment,
> explaining their origin, maybe a link to the standard. I also don't
> think this needs to be a uapi header, they are not needed outside of
> the kernel.
> 
> I also would not use MDIO_MMD_OATC14, but rather MDIO_MMD_VEND2. There
> is no guarantee they are not being used for other things, and
> MDIO_MMD_VEND2 gives a gentle warning about this.
Thanks Andrew for commenting on this one. This is right, in the IEEE
802.3cg group we could not allocate an MMD for the PLCA reconciliation
sublayer because of an 'unfriendly' wording in Clause 45 ruling out
Reconciliation Sublayers from what can be configured via registers.
Clause 45 says you can have registers for the PHY, while it should have
said 'Physical Layer" and there is a subtle difference between the two
words. PLCA, for example, is part of the Physical Layer but not of the
PHY. Since we could not change that wording, we had to define
configuration parameters in Clause 30, and let organizations outside the
IEEE define memory maps for PHYs that integrate PLCA.

The OPEN Alliance SIG (see the reference in the patches) defined
registers for the PLCA RS in MMD31, which is in fact vendor-specific
from an IEEE perspective, but part of it is now standardized in the OPEN
Alliance. So unfortunately we have to live with this somehow.

So ok, I can separate these definitions into a different non-UAPI header
as Andrew is suggesting. I'll do this in the next patchset.

Thanks,
Piergiorgio

